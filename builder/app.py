import io
import os
import struct
import zipfile
import zlib
from pathlib import Path
from flask import Flask, render_template, send_file, request, jsonify, abort, Response

app = Flask(__name__)

# Assets sit one level up from the builder folder:
#   /legends/builder/  ← this app
#   /legends/car/      ← packages, wheel, decals
#   /legends/parts/    ← 14_*.swf wheels, 13_*.swf tires etc.
BASE = Path(__file__).parent.parent
CAR_DIR       = BASE / "decom" / "car"
PARTS_DIR     = BASE / "decom" / "parts"
CHALLENGE_DIR = BASE / "decom" / "challenge"
SAVE_DIR      = Path(__file__).parent / "saved"
SAVE_DIR.mkdir(exist_ok=True)

# Allow overriding paths via env (useful on RPi4 where decom/ may not exist)
if os.environ.get("LEGENDS_CAR_DIR"):
    CAR_DIR = Path(os.environ["LEGENDS_CAR_DIR"])
if os.environ.get("LEGENDS_PARTS_DIR"):
    PARTS_DIR = Path(os.environ["LEGENDS_PARTS_DIR"])

# All routes are prefixed /builder so nginx can route this app without
# conflicting with other services already running on this RPi4.
P = "/builder"


# ── UI ──────────────────────────────────────────────────────────────────────

def _nocache(resp):
    resp.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    resp.headers["Pragma"] = "no-cache"
    resp.headers["Expires"] = "0"
    return resp

@app.route(P)
@app.route(P + "/")
def index():
    from flask import make_response
    return _nocache(make_response(render_template("index.html")))

@app.route(P + "/wheels")
@app.route(P + "/wheels/v2")
def wheels_export():
    from flask import make_response
    return _nocache(make_response(render_template("wheels_export.html")))

@app.route(P + "/challenge")
@app.route(P + "/challenge/")
def challenge_index():
    from flask import make_response
    return _nocache(make_response(render_template("challenge.html")))

@app.route(P + "/assets/challenge/<path:filename>")
def challenge_asset(filename):
    p = (CHALLENGE_DIR / filename).resolve()
    if not p.exists() or CHALLENGE_DIR not in p.parents:
        abort(404)
    return send_file(p)

@app.route(P + "/api/challenge/cars")
def api_challenge_cars():
    """Return list of car objects with layer paths for the challenge builder."""
    sprites_dir = CHALLENGE_DIR / "sprites"

    # Build full lookup: sprite_id (int) -> folder name
    id_to_folder = {}
    for d in sprites_dir.iterdir():
        if not d.is_dir():
            continue
        parts = d.name.split("_")
        if parts[0] == "DefineSprite" and len(parts) >= 2:
            try:
                id_to_folder[int(parts[1])] = d.name
            except ValueError:
                pass

    def frame_count(folder_name):
        return len(list((sprites_dir / folder_name).glob("*.png")))

    # 6-frame unnamed sprites = graphic overlays
    six_frame_ids = sorted(
        sid for sid, folder in id_to_folder.items()
        if len(folder.split("_")) == 2 and frame_count(folder) == 6
    )

    # 2-frame unnamed sprites = composed car body (frame1=no graphic, frame2=with graphic)
    two_frame_ids = sorted(
        sid for sid, folder in id_to_folder.items()
        if len(folder.split("_")) == 2 and frame_count(folder) == 2
    )

    # racecar sprite lookup: car_name_lower -> path
    racecar_lookup = {}
    for d in sprites_dir.iterdir():
        if not d.is_dir() or "racecar" not in d.name.lower():
            continue
        png = d / "1.png"
        if not png.exists():
            continue
        parts = d.name.split("_")
        rc_idx = next((i for i, p in enumerate(parts) if p.lower() == "racecar"), None)
        if rc_idx is None:
            continue
        racecar_lookup["_".join(parts[2:rc_idx]).lower()] = f"sprites/{d.name}/1.png"

    # --- Color block sprites: large solid-colour unnamed single-frame sprites ---
    import statistics as _stats
    try:
        from PIL import Image as _PIL
        _HAS_PIL = True
    except ImportError:
        _HAS_PIL = False

    color_block_ids = []
    if _HAS_PIL:
        for sid, fname in id_to_folder.items():
            if len(fname.split("_")) != 2:
                continue
            if frame_count(fname) != 1:
                continue
            p = sprites_dir / fname / "1.png"
            if not p.exists():
                continue
            with _PIL.open(p) as img:
                bw, bh = img.size
            if bw < 200 or bh < 60:
                continue
            with _PIL.open(p) as img:
                px = [pix for pix in img.convert("RGBA").getdata() if pix[3] > 10]
            if len(px) < 50:
                continue
            sample = px[:300]
            try:
                rv = _stats.stdev(pix[0] for pix in sample)
                gv = _stats.stdev(pix[1] for pix in sample)
                bv = _stats.stdev(pix[2] for pix in sample)
            except Exception:
                continue
            if rv < 30 and gv < 30 and bv < 30:
                color_block_ids.append(sid)
    color_block_ids.sort()

    # --- Image file lookup: id -> filename ---
    images_dir = CHALLENGE_DIR / "images"
    img_files = {}
    for f in images_dir.iterdir():
        if f.stem.isdigit():
            img_files[int(f.stem)] = f.name

    cars = []
    for d in sorted(sprites_dir.iterdir()):
        n = d.name
        if not d.is_dir():
            continue
        nl = n.lower()
        if "frontquarter_menu" not in nl or "wing" in nl:
            continue
        png = d / "1.png"
        if not png.exists():
            continue
        parts = n.split("_")
        try:
            menu_id = int(parts[1])
        except (IndexError, ValueError):
            continue
        fq_idx = next((i for i, p in enumerate(parts) if p.lower() == "frontquarter"), None)
        if fq_idx is None:
            continue
        car_name = "_".join(parts[2:fq_idx])

        try:
            from PIL import Image as _PilImage
            with _PilImage.open(png) as img:
                w, h = img.size
        except Exception:
            w, h = 0, 0

        # --- Color block: nearest large solid sprite before this menu ---
        block_cands = [b for b in color_block_ids if b < menu_id]
        block_path = None
        if block_cands:
            bid = max(block_cands)
            bp = sprites_dir / f"DefineSprite_{bid}" / "1.png"
            if bp.exists():
                block_path = f"sprites/DefineSprite_{bid}/1.png"

        # --- Car image from images/ and detail sprite ---
        car_img_path = None
        detail_path = None
        for sid, fname in id_to_folder.items():
            fl = fname.lower()
            if car_name.lower() in fl and "frontquarter_detail" in fl:
                dp = sprites_dir / fname / "1.png"
                if dp.exists():
                    detail_path = f"sprites/{fname}/1.png"
                    # Match image file: closest ID to detail sprite, most similar size
                    try:
                        from PIL import Image as _PilImage
                        with _PilImage.open(dp) as di:
                            dw2, dh2 = di.size
                        best_score, best_iid = 9999.0, None
                        for iid, fname2 in img_files.items():
                            if abs(iid - sid) > 80:
                                continue
                            ip = images_dir / fname2
                            with _PilImage.open(ip) as ii:
                                iw, ih = ii.size
                            if iw < 100:
                                continue
                            score = (abs(iw - dw2) / max(dw2, 1)
                                     + abs(ih - dh2) / max(dh2, 1)
                                     + abs(iid - sid) / 200.0)
                            if score < best_score:
                                best_score, best_iid = score, iid
                        if best_iid is not None:
                            car_img_path = f"images/{img_files[best_iid]}"
                    except Exception:
                        pass
                break

        # --- Graphic overlay paths (6-frame unnamed sprite) ---
        graphic_paths = None
        cands6 = [s for s in six_frame_ids if s < menu_id and (menu_id - s) < 60]
        if cands6:
            gfolder = id_to_folder.get(cands6[-1])
            if gfolder:
                graphic_paths = [f"sprites/{gfolder}/{i}.png" for i in range(1, 7)]

        cars.append({
            "id": str(menu_id),
            "name": car_name,
            "w": w, "h": h,
            "block_path":  block_path,     # solid colour silhouette → tint for body colour
            "car_img":     car_img_path,   # transparent car art from images/ → draw as-is
            "detail_path": detail_path,    # extra outlines/trim → draw as-is on top
            "graphic_paths": graphic_paths,
            "racecar_path": racecar_lookup.get(car_name.lower()),
        })
    return jsonify(cars)

@app.route(P + "/api/challenge/wheels")
def api_challenge_wheels():
    """Return list of {name, f_path, r_path, fw, fh, rw, rh} for every wheel design."""
    sprites_dir = CHALLENGE_DIR / "sprites"
    seen = {}
    for d in sorted(sprites_dir.iterdir()):
        if not d.is_dir():
            continue
        n = d.name
        # Match DefineSprite_{id}_{WheelName}_F_100 or _R_100
        if "_F_100" not in n and "_R_100" not in n:
            continue
        png = d / "1.png"
        if not png.exists():
            continue
        # Extract wheel name (between id and _F_100/_R_100)
        parts = n.split("_")
        # find F/R index
        try:
            fr_idx = next(i for i, p in enumerate(parts) if p in ("F", "R"))
        except StopIteration:
            continue
        wheel_name = "_".join(parts[2:fr_idx])
        side = parts[fr_idx]
        try:
            from PIL import Image as _PilImage
            with _PilImage.open(png) as img:
                w, h = img.size
        except Exception:
            w, h = 0, 0
        if wheel_name not in seen:
            seen[wheel_name] = {"name": wheel_name, "f_path": None, "r_path": None,
                                "fw": 0, "fh": 0, "rw": 0, "rh": 0}
        if side == "F":
            seen[wheel_name]["f_path"] = f"sprites/{d.name}/1.png"
            seen[wheel_name]["fw"] = w
            seen[wheel_name]["fh"] = h
        else:
            seen[wheel_name]["r_path"] = f"sprites/{d.name}/1.png"
            seen[wheel_name]["rw"] = w
            seen[wheel_name]["rh"] = h
    # Only return wheels that have both F and R
    wheels = [v for v in seen.values() if v["f_path"] and v["r_path"]]
    wheels.sort(key=lambda x: x["name"])
    return jsonify(wheels)


# ── Static asset proxies (SWF files) ────────────────────────────────────────

@app.route(P + "/assets/car/<path:filename>")
def car_asset(filename):
    p = (CAR_DIR / filename).resolve()
    if not p.exists() or CAR_DIR not in p.parents:
        abort(404)
    return send_file(p)


@app.route(P + "/assets/parts/<path:filename>")
def parts_asset(filename):
    p = (PARTS_DIR / filename).resolve()
    if not p.exists() or PARTS_DIR not in p.parents:
        abort(404)
    return send_file(p)


# ── API ──────────────────────────────────────────────────────────────────────

@app.route(P + "/api/cars")
def api_cars():
    pkg = CAR_DIR / "packages"
    ids = set()
    for d in pkg.iterdir():
        if d.is_dir() and (d.name.endswith("f") or d.name.endswith("b")):
            try:
                ids.add(int(d.name[:-1]))
            except ValueError:
                pass
    return jsonify(sorted(ids))


@app.route(P + "/api/car/<int:car_id>/parts/<view>")
def api_car_parts(car_id, view):
    suffix = "f" if view == "front" else "b"
    pkg = CAR_DIR / "packages" / f"{car_id}{suffix}"
    if not pkg.exists():
        return jsonify([])
    parts = sorted(f.stem for f in pkg.glob("*.swf"))
    return jsonify(parts)


@app.route(P + "/api/wheels")
def api_wheels():
    ids = sorted(
        int(f.stem.split("_")[1])
        for f in (CAR_DIR / "wheel").glob("wheelFF_*.swf")
    )
    return jsonify(ids)


@app.route(P + "/api/tires")
def api_tires():
    ids = sorted(
        int(f.stem.split("_")[1])
        for f in (CAR_DIR / "wheel").glob("tireFF_*.swf")
    )
    return jsonify(ids)


@app.route(P + "/api/save", methods=["POST"])
def api_save():
    data = request.get_json(force=True)
    raw_name = data.get("filename", "car_export.svg")
    svg = data.get("svg", "")

    filename = Path(raw_name).name
    if not filename.lower().endswith(".svg"):
        filename += ".svg"

    out = SAVE_DIR / filename
    out.write_text(svg, encoding="utf-8")
    return jsonify({"ok": True, "path": str(out), "filename": filename})


@app.route(P + "/saved/<filename>")
def get_saved(filename):
    p = (SAVE_DIR / Path(filename).name).resolve()
    if not p.exists():
        abort(404)
    return send_file(p, as_attachment=True)


@app.route(P + "/api/saved")
def list_saved():
    files = [f.name for f in sorted(SAVE_DIR.glob("*.svg"))]
    return jsonify(files)


# ── Bitmap extraction helpers ─────────────────────────────────────────────────

def _composite_thumbnail(swf_path, max_size=120):
    """Composite all bitmaps in a SWF into a single RGBA PNG (bytes).

    Uses Pillow (available on the Pi via system packages).
    Returns None if Pillow is unavailable or the SWF has no bitmaps.
    """
    try:
        from PIL import Image
    except ImportError:
        return None

    try:
        raw = open(swf_path, 'rb').read()
    except OSError:
        return None
    if raw[:3] == b'CWS':
        try:
            raw = raw[:8] + zlib.decompress(raw[8:])
        except Exception:
            return None

    _,_,_,_,rb = _read_rect(raw, 8)
    off = 8 + rb + 4
    end = len(raw)
    composite = None

    while off + 2 <= end:
        hdr = struct.unpack_from('<H', raw, off)[0]; off += 2
        tt  = hdr >> 6
        tl  = hdr & 0x3F
        if tl == 63:
            if off + 4 > end: break
            tl = struct.unpack_from('<I', raw, off)[0]; off += 4
        te = off + tl
        if te > end: break

        if tt == 35:  # DefineBitsJPEG3
            dlen = struct.unpack_from('<I', raw, off + 2)[0]
            jpg  = raw[off + 6 : off + 6 + dlen]
            if jpg[:4] == b'\xff\xd9\xff\xd8':
                jpg = jpg[4:]
            alpha_comp = raw[off + 6 + dlen : te]
            try:
                img = Image.open(io.BytesIO(jpg)).convert('RGBA')
                if alpha_comp:
                    alpha_raw = zlib.decompress(alpha_comp)
                    w, h = img.size
                    img.putalpha(Image.frombytes('L', (w, h), alpha_raw[:w * h]))
                composite = img if composite is None else Image.alpha_composite(composite, img)
            except Exception:
                pass

        elif tt == 36:  # DefineBitsLossless2 fmt=5 (32-bit ARGB)
            fmt = raw[off + 2]
            w   = struct.unpack_from('<H', raw, off + 3)[0]
            h   = struct.unpack_from('<H', raw, off + 5)[0]
            if fmt == 5:
                try:
                    argb = zlib.decompress(raw[off + 7 : te])[:w * h * 4]
                    rgba = bytearray(w * h * 4)
                    for i in range(w * h):
                        a, r, g, b = argb[i*4], argb[i*4+1], argb[i*4+2], argb[i*4+3]
                        rgba[i*4 : i*4+4] = bytes([r, g, b, a])
                    img = Image.frombytes('RGBA', (w, h), bytes(rgba))
                    composite = img if composite is None else Image.alpha_composite(composite, img)
                except Exception:
                    pass

        off = te

    if composite is None:
        return None

    # Scale down to thumbnail size
    w, h = composite.size
    scale = min(1.0, max_size / max(w, h, 1))
    if scale < 1.0:
        composite = composite.resize(
            (int(w * scale), int(h * scale)), Image.LANCZOS)

    buf = io.BytesIO()
    composite.save(buf, 'PNG', optimize=True)
    return buf.getvalue()

def _png_chunk(tag, data):
    c = struct.pack('>I', len(data)) + tag + data
    return c + struct.pack('>I', zlib.crc32(tag + data) & 0xffffffff)

def _make_png_grey(width, height, grey_bytes):
    """Greyscale (L) PNG from raw single-channel bytes."""
    raw = b''.join(b'\x00' + grey_bytes[y*width:(y+1)*width] for y in range(height))
    png  = b'\x89PNG\r\n\x1a\n'
    png += _png_chunk(b'IHDR', struct.pack('>II', width, height) + bytes([8, 0, 0, 0, 0]))
    png += _png_chunk(b'IDAT', zlib.compress(raw, 6))
    png += _png_chunk(b'IEND', b'')
    return png

def _make_png_rgba(width, height, argb_bytes):
    """RGBA PNG from SWF Lossless2 ARGB bytes (A,R,G,B order → R,G,B,A)."""
    raw_lines = []
    for y in range(height):
        row = b'\x00'
        for x in range(width):
            i = (y * width + x) * 4
            a, r, g, b = argb_bytes[i], argb_bytes[i+1], argb_bytes[i+2], argb_bytes[i+3]
            row += bytes([r, g, b, a])
        raw_lines.append(row)
    raw = b''.join(raw_lines)
    png  = b'\x89PNG\r\n\x1a\n'
    png += _png_chunk(b'IHDR', struct.pack('>II', width, height) + bytes([8, 6, 0, 0, 0]))
    png += _png_chunk(b'IDAT', zlib.compress(raw, 6))
    png += _png_chunk(b'IEND', b'')
    return png

def _jpeg_dimensions(jpg_bytes):
    """Return (width, height) by scanning SOF markers."""
    i = 0
    while i < len(jpg_bytes) - 3:
        if jpg_bytes[i] == 0xff and jpg_bytes[i+1] in (0xc0, 0xc1, 0xc2, 0xc3):
            h, w = struct.unpack_from('>HH', jpg_bytes, i + 5)
            return w, h
        i += 1
    return None, None

def _extract_bitmaps(swf_path):
    """Extract all bitmaps from a SWF file.

    Yields dicts:
      { 'id': int, 'type': 'jpeg3'|'lossless2',
        'jpg': bytes|None, 'alpha_png': bytes|None,  # jpeg3
        'rgba_png': bytes|None,                       # lossless2
        'w': int, 'h': int }
    """
    try:
        raw = open(swf_path, 'rb').read()
    except OSError:
        return
    if len(raw) < 9 or raw[:3] not in (b'FWS', b'CWS'):
        return
    if raw[:3] == b'CWS':
        try:
            raw = raw[:8] + zlib.decompress(raw[8:])
        except Exception:
            return

    _,_,_,_,rb = _read_rect(raw, 8)
    off = 8 + rb + 4
    end = len(raw)

    while off + 2 <= end:
        hdr = struct.unpack_from('<H', raw, off)[0]; off += 2
        tt  = hdr >> 6
        tl  = hdr & 0x3F
        if tl == 63:
            if off + 4 > end: break
            tl = struct.unpack_from('<I', raw, off)[0]; off += 4
        te = off + tl
        if te > end: break

        if tt == 35:  # DefineBitsJPEG3
            bid  = struct.unpack_from('<H', raw, off)[0]
            dlen = struct.unpack_from('<I', raw, off + 2)[0]
            jpg  = raw[off + 6 : off + 6 + dlen]
            # Strip erroneous SOI/EOI pair Flash sometimes prepends
            if jpg[:4] == b'\xff\xd9\xff\xd8':
                jpg = jpg[4:]
            alpha_compressed = raw[off + 6 + dlen : te]
            w, h = _jpeg_dimensions(jpg)
            alpha_png = None
            if w and h and alpha_compressed:
                try:
                    alpha_raw = zlib.decompress(alpha_compressed)
                    alpha_png = _make_png_grey(w, h, alpha_raw[:w*h])
                except Exception:
                    pass
            yield {'id': bid, 'type': 'jpeg3', 'jpg': jpg,
                   'alpha_png': alpha_png, 'rgba_png': None, 'w': w or 0, 'h': h or 0}

        elif tt == 36:  # DefineBitsLossless2 (fmt 5 = 32-bit ARGB)
            bid = struct.unpack_from('<H', raw, off)[0]
            fmt = raw[off + 2]
            w   = struct.unpack_from('<H', raw, off + 3)[0]
            h   = struct.unpack_from('<H', raw, off + 5)[0]
            compressed = raw[off + 7 : te]
            rgba_png = None
            if fmt == 5:
                try:
                    argb = zlib.decompress(compressed)
                    rgba_png = _make_png_rgba(w, h, argb[:w*h*4])
                except Exception:
                    pass
            yield {'id': bid, 'type': 'lossless2', 'jpg': None,
                   'alpha_png': None, 'rgba_png': rgba_png, 'w': w, 'h': h}

        off = te


def _bitmaps_to_svgs(swf_path):
    """Convert all bitmaps in a SWF to SVG strings.

    JPEG3: embeds JPEG as data URI with greyscale alpha mask.
    Lossless2 (ARGB): converts to RGBA PNG, embeds as data URI.
    Returns list of (filename_stem, svg_string).
    """
    import base64
    results = []
    bitmaps = list(_extract_bitmaps(swf_path))
    for bm in bitmaps:
        bid = bm['id']
        w, h = bm['w'], bm['h']
        if not w or not h:
            continue
        bm_suffix = f"_bm{bid}" if len(bitmaps) > 1 else ""

        if bm['type'] == 'jpeg3' and bm['jpg']:
            jpg_b64 = base64.b64encode(bm['jpg']).decode()
            if bm['alpha_png']:
                alpha_b64 = base64.b64encode(bm['alpha_png']).decode()
                svg = (
                    f'<svg xmlns="http://www.w3.org/2000/svg"'
                    f' xmlns:xlink="http://www.w3.org/1999/xlink"'
                    f' width="{w}" height="{h}" viewBox="0 0 {w} {h}">'
                    f'<defs><mask id="a">'
                    f'<image width="{w}" height="{h}"'
                    f' xlink:href="data:image/png;base64,{alpha_b64}"/>'
                    f'</mask></defs>'
                    f'<image width="{w}" height="{h}"'
                    f' xlink:href="data:image/jpeg;base64,{jpg_b64}"'
                    f' mask="url(#a)"/></svg>'
                )
            else:
                svg = (
                    f'<svg xmlns="http://www.w3.org/2000/svg"'
                    f' xmlns:xlink="http://www.w3.org/1999/xlink"'
                    f' width="{w}" height="{h}" viewBox="0 0 {w} {h}">'
                    f'<image width="{w}" height="{h}"'
                    f' xlink:href="data:image/jpeg;base64,{jpg_b64}"/></svg>'
                )
            results.append((bm_suffix, svg))

        elif bm['type'] == 'lossless2' and bm['rgba_png']:
            b64 = base64.b64encode(bm['rgba_png']).decode()
            svg = (
                f'<svg xmlns="http://www.w3.org/2000/svg"'
                f' xmlns:xlink="http://www.w3.org/1999/xlink"'
                f' width="{w}" height="{h}" viewBox="0 0 {w} {h}">'
                f'<image width="{w}" height="{h}"'
                f' xlink:href="data:image/png;base64,{b64}"/></svg>'
            )
            results.append((bm_suffix, svg))

    return results


@app.route(P + "/api/wheels/svg.zip")
def wheels_svg_zip():
    """Convert every wheel SWF bitmap to SVG and zip them server-side.

    No browser/Ruffle needed — pure Python stdlib.
    Structure: wheels/wheelFF/wheelFF_1.svg, wheels/wheelBF/wheelBF_1.svg, …
    Multi-bitmap SWFs get one SVG per bitmap: wheelFF_50_bm1.svg, _bm2.svg, etc.
    """
    PREFIXES = ["wheelFF", "wheelBF", "wheelFR", "wheelBR", "wheelR"]
    wheel_dir = CAR_DIR / "wheel"

    # Collect all IDs across all prefixes
    all_ids = sorted(set(
        int(p.stem.split('_')[1])
        for prefix in PREFIXES
        for p in wheel_dir.glob(f"{prefix}_*.swf")
    ))

    buf = io.BytesIO()
    with zipfile.ZipFile(buf, 'w', zipfile.ZIP_DEFLATED) as zf:
        for wid in all_ids:
            folder = f"wheels/wheel_{wid}"

            # Preview thumbnail — composite from the FF (front) view
            thumb_swf = wheel_dir / f"wheelFF_{wid}.swf"
            if thumb_swf.exists():
                thumb = _composite_thumbnail(thumb_swf)
                if thumb:
                    zf.writestr(f"{folder}/preview.png", thumb)

            for prefix in PREFIXES:
                swf = wheel_dir / f"{prefix}_{wid}.swf"
                if not swf.exists():
                    continue
                stem = swf.stem
                for bm_suffix, svg in _bitmaps_to_svgs(swf):
                    fname = f"{stem}{bm_suffix}.svg"
                    zf.writestr(f"{folder}/{fname}", svg)

    buf.seek(0)
    return Response(
        buf.read(),
        mimetype='application/zip',
        headers={'Content-Disposition': 'attachment; filename="wheels_svg_v2.zip"'}
    )


@app.route(P + "/api/wheels/raw.zip")
def wheels_raw_zip():
    """Zip original JPEG + alpha PNG bitmaps extracted from every wheel SWF."""
    PREFIXES = ["wheelFF", "wheelBF", "wheelFR", "wheelBR", "wheelR"]
    wheel_dir = CAR_DIR / "wheel"

    all_ids = sorted(set(
        int(p.stem.split('_')[1])
        for prefix in PREFIXES
        for p in wheel_dir.glob(f"{prefix}_*.swf")
    ))

    buf = io.BytesIO()
    with zipfile.ZipFile(buf, 'w', zipfile.ZIP_DEFLATED) as zf:
        for wid in all_ids:
            for prefix in PREFIXES:
                swf = wheel_dir / f"{prefix}_{wid}.swf"
                if not swf.exists():
                    continue
                stem = swf.stem
                bitmaps = list(_extract_bitmaps(swf))
                for bm in bitmaps:
                    bid    = bm['id']
                    suffix = f"_bm{bid}" if len(bitmaps) > 1 else ""
                    folder = f"wheels/wheel_{wid}"

                    if bm['type'] == 'jpeg3' and bm['jpg']:
                        zf.writestr(f"{folder}/{stem}{suffix}.jpg", bm['jpg'])
                        if bm['alpha_png']:
                            zf.writestr(f"{folder}/{stem}{suffix}_alpha.png", bm['alpha_png'])

                    elif bm['type'] == 'lossless2' and bm['rgba_png']:
                        zf.writestr(f"{folder}/{stem}{suffix}.png", bm['rgba_png'])

    buf.seek(0)
    return Response(
        buf.read(),
        mimetype='application/zip',
        headers={'Content-Disposition': 'attachment; filename="wheels_raw.zip"'}
    )


# ── SWF position parser ───────────────────────────────────────────────────────

def _read_rect(data, off):
    """Parse SWF RECT bit-field. Returns (xmin_px, ymin_px, width_px, height_px, bytes_consumed)."""
    nb = data[off] >> 3
    if nb == 0:
        return 0, 0, 0, 0, 1
    tb = 5 + nb * 4
    nb_bytes = (tb + 7) // 8
    val = 0
    for i in range(nb_bytes):
        val = (val << 8) | data[off + i]
    val >>= (nb_bytes * 8 - tb)
    mask = (1 << nb) - 1
    def s(v):
        return v - (1 << nb) if v >= (1 << (nb - 1)) else v
    xmin = s((val >> (3 * nb)) & mask)
    xmax = s((val >> (2 * nb)) & mask)
    ymin = s((val >>      nb)  & mask)
    ymax = s( val              & mask)
    xmin_px = xmin // 20
    ymin_px = ymin // 20
    w = max(0, (xmax - xmin) // 20)
    h = max(0, (ymax - ymin) // 20)
    return xmin_px, ymin_px, w, h, nb_bytes


def _scan_actions(data, off, end, cpool=None):
    """Return dict of tx/ty/scx/scy extracted from ActionScript SetVariable opcodes."""
    out = {}
    stack = []
    pool = list(cpool) if cpool else []

    while off < end:
        if off >= len(data):
            break
        op = data[off]; off += 1
        alen = 0
        if op >= 0x80:
            if off + 2 > end:
                break
            alen = struct.unpack_from('<H', data, off)[0]; off += 2
        ae = off + alen

        if op == 0x88:  # ActionConstantPool — build string pool
            if ae - off >= 2:
                count = struct.unpack_from('<H', data, off)[0]
                p = off + 2
                pool = []
                for _ in range(count):
                    try:
                        e = data.index(b'\x00', p)
                        pool.append(data[p:e].decode('latin-1', 'replace'))
                        p = e + 1
                    except (ValueError, IndexError):
                        break

        elif op == 0x96:  # ActionPush
            p = off
            while p < ae:
                t = data[p]; p += 1
                try:
                    if   t == 0:
                        e = data.index(b'\x00', p)
                        stack.append(data[p:e].decode('latin-1', 'replace'))
                        p = e + 1
                    elif t == 1:  stack.append(struct.unpack_from('<f', data, p)[0]); p += 4
                    elif t == 2:  stack.append(None); p += 0   # null
                    elif t == 3:  stack.append(None); p += 0   # undefined
                    elif t == 4:  stack.append(None); p += 1   # register
                    elif t == 5:  stack.append(bool(data[p])); p += 1
                    elif t == 6:  stack.append(struct.unpack_from('<d', data, p)[0]); p += 8
                    elif t == 7:  stack.append(struct.unpack_from('<i', data, p)[0]); p += 4
                    elif t == 8:  # constant pool index (1 byte)
                        idx = data[p]; p += 1
                        stack.append(pool[idx] if idx < len(pool) else None)
                    elif t == 9:  # constant pool index (2 bytes)
                        idx = struct.unpack_from('<H', data, p)[0]; p += 2
                        stack.append(pool[idx] if idx < len(pool) else None)
                    else: break
                except Exception:
                    break

        elif op == 0x1D:  # ActionSetVariable
            if len(stack) >= 2:
                val  = stack.pop()
                name = stack.pop()
                if isinstance(name, str) and name in ('tx', 'ty', 'scx', 'scy'):
                    try:
                        out[name] = float(val)
                    except Exception:
                        pass

        off = ae
    return out


def _scan_tags(data, off, end, accum):
    """Walk SWF tag list, collecting bg colour and tx/ty/scx/scy.

    SWF RECORDHEADER: UI16 where bits[15..6] = TagType, bits[5..0] = Length
    (Length == 63 means a UI32 long-form length follows.)
    """
    while off + 2 <= end:
        hdr = struct.unpack_from('<H', data, off)[0]; off += 2
        tt = hdr >> 6          # tag type  (upper 10 bits)
        tl = hdr & 0x3F        # tag length (lower 6 bits; 63 = long form)
        if tl == 63:
            if off + 4 > end:
                break
            tl = struct.unpack_from('<I', data, off)[0]; off += 4
        te = off + tl
        if te > end:
            break

        if tt == 9 and tl >= 3:               # SetBgColor
            accum.setdefault('bg', (data[off], data[off + 1], data[off + 2]))
        elif tt == 12:                         # DoAction
            accum.update(_scan_actions(data, off, te))
        elif tt == 59 and tl > 2:             # DoInitAction (2-byte sprite ID prefix)
            accum.update(_scan_actions(data, off + 2, te))
        elif tt == 39 and tl > 4:             # DefineSprite — recurse into sub-tags
            # DefineSprite body: SpriteID (2), FrameCount (2), then tags
            _scan_tags(data, off + 4, te, accum)
        elif tt == 0:                          # End tag
            break

        off = te


def _swf_info(path):
    """Return {xoff, yoff, w, h, bg, tx, ty, scx, scy} for a SWF file, or None on error."""
    try:
        raw = open(path, 'rb').read()
    except OSError:
        return None
    if len(raw) < 9 or raw[:3] not in (b'FWS', b'CWS'):
        return None
    if raw[:3] == b'CWS':
        try:
            raw = raw[:8] + zlib.decompress(raw[8:])
        except Exception:
            return None
    xoff, yoff, w, h, rb = _read_rect(raw, 8)
    accum = {}
    _scan_tags(raw, 8 + rb + 4, len(raw), accum)
    return {
        'xoff': xoff,
        'yoff': yoff,
        'w':    w,
        'h':    h,
        'bg':   list(accum['bg']) if 'bg' in accum else None,
        'tx':   accum.get('tx'),
        'ty':   accum.get('ty'),
        'scx':  accum.get('scx', 100),
        'scy':  accum.get('scy', 100),
    }


@app.route(P + "/api/positions/<int:car_id>/<view>")
def api_positions(car_id, view):
    """SWF info for all parts in a car package + all wheel/tire SWFs."""
    suffix = "f" if view in ("f", "front") else "b"
    pkg = CAR_DIR / "packages" / f"{car_id}{suffix}"
    if not pkg.exists():
        return jsonify({}), 404
    out = {}
    for swf in sorted(pkg.glob("*.swf")):
        info = _swf_info(swf)
        if info:
            out[swf.stem] = info
    wdir = CAR_DIR / "wheel"
    if wdir.exists():
        for swf in sorted(wdir.glob("*.swf")):
            info = _swf_info(swf)
            if info:
                out["whl:" + swf.stem] = info
    return jsonify(out)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001, debug=False)
