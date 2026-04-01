import os
import struct
import zlib
from pathlib import Path
from flask import Flask, render_template, send_file, request, jsonify, abort

app = Flask(__name__)

# Assets sit one level up from the builder folder:
#   /legends/builder/  ← this app
#   /legends/car/      ← packages, wheel, decals
#   /legends/parts/    ← 14_*.swf wheels, 13_*.swf tires etc.
BASE = Path(__file__).parent.parent
CAR_DIR   = BASE / "decom" / "car"
PARTS_DIR = BASE / "decom" / "parts"
SAVE_DIR  = Path(__file__).parent / "saved"
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

@app.route(P)
@app.route(P + "/")
def index():
    from flask import make_response
    resp = make_response(render_template("index.html"))
    resp.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    resp.headers["Pragma"] = "no-cache"
    resp.headers["Expires"] = "0"
    return resp


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
