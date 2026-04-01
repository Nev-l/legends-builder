"""
export_wheels.py
Extracts every wheel SWF bitmap, converts to SVG, adds a preview.png
per design folder, and zips everything to wheels_svg_v2.zip.

Run from the legends/ folder:
    python export_wheels.py

Requires Pillow:  pip install pillow
"""

import base64, io, struct, sys, zipfile, zlib
from pathlib import Path

try:
    from PIL import Image
    HAS_PIL = True
except ImportError:
    HAS_PIL = False
    print("WARNING: Pillow not installed — preview.png thumbnails will be skipped.")
    print("         pip install pillow  to enable them.\n")

WHEEL_DIR = Path(__file__).parent / "decom" / "car" / "wheel"
OUT_ZIP   = Path(__file__).parent / "wheels_svg_v2.zip"
PREFIXES  = ["wheelFF", "wheelBF", "wheelFR", "wheelBR", "wheelR"]
THUMB_SIZE = 120

# ── SWF helpers ───────────────────────────────────────────────────────────────

def _read_rect(data, off):
    nb = data[off] >> 3
    if nb == 0: return 0, 0, 0, 0, 1
    tb = 5 + nb * 4; nb_bytes = (tb + 7) // 8
    val = 0
    for i in range(nb_bytes): val = (val << 8) | data[off + i]
    val >>= (nb_bytes * 8 - tb)
    mask = (1 << nb) - 1
    def s(v): return v - (1 << nb) if v >= (1 << (nb - 1)) else v
    return (s((val >> (3*nb)) & mask), s((val >> nb) & mask),
            max(0, s((val >> (2*nb)) & mask) - s((val >> (3*nb)) & mask)),
            max(0, s(val & mask) - s((val >> nb) & mask)), nb_bytes)

def _jpeg_wh(jpg):
    i = 0
    while i < len(jpg) - 3:
        if jpg[i] == 0xff and jpg[i+1] in (0xc0, 0xc1, 0xc2, 0xc3):
            h, w = struct.unpack_from('>HH', jpg, i + 5)
            return w, h
        i += 1
    return None, None

def _png_chunk(tag, data):
    c = struct.pack('>I', len(data)) + tag + data
    return c + struct.pack('>I', zlib.crc32(tag + data) & 0xffffffff)

def _grey_png(w, h, grey):
    raw = b''.join(b'\x00' + grey[y*w:(y+1)*w] for y in range(h))
    png  = b'\x89PNG\r\n\x1a\n'
    png += _png_chunk(b'IHDR', struct.pack('>II', w, h) + bytes([8, 0, 0, 0, 0]))
    png += _png_chunk(b'IDAT', zlib.compress(raw, 6))
    png += _png_chunk(b'IEND', b'')
    return png

def _rgba_png(w, h, argb):
    rows = []
    for y in range(h):
        row = bytearray(b'\x00')
        for x in range(w):
            i = (y * w + x) * 4
            a, r, g, b = argb[i], argb[i+1], argb[i+2], argb[i+3]
            row += bytes([r, g, b, a])
        rows.append(bytes(row))
    raw = b''.join(rows)
    png  = b'\x89PNG\r\n\x1a\n'
    png += _png_chunk(b'IHDR', struct.pack('>II', w, h) + bytes([8, 6, 0, 0, 0]))
    png += _png_chunk(b'IDAT', zlib.compress(raw, 6))
    png += _png_chunk(b'IEND', b'')
    return png

def _iter_bitmaps(swf_path):
    """Yield raw bitmap records from a SWF file."""
    raw = open(swf_path, 'rb').read()
    if raw[:3] == b'CWS':
        raw = raw[:8] + zlib.decompress(raw[8:])
    _,_,_,_,rb = _read_rect(raw, 8)
    off = 8 + rb + 4; end = len(raw)
    while off + 2 <= end:
        hdr = struct.unpack_from('<H', raw, off)[0]; off += 2
        tt  = hdr >> 6; tl = hdr & 0x3F
        if tl == 63:
            tl = struct.unpack_from('<I', raw, off)[0]; off += 4
        te = off + tl
        if te > end: break
        yield tt, raw, off, te
        off = te

def swf_to_svgs(path):
    """Return list of (bm_suffix, svg_string) for every bitmap in the SWF."""
    results = []
    bitmaps = []

    for tt, raw, off, te in _iter_bitmaps(path):
        if tt == 35:  # DefineBitsJPEG3
            dlen = struct.unpack_from('<I', raw, off + 2)[0]
            jpg  = raw[off + 6 : off + 6 + dlen]
            if jpg[:4] == b'\xff\xd9\xff\xd8': jpg = jpg[4:]
            alpha_comp = raw[off + 6 + dlen : te]
            bid = struct.unpack_from('<H', raw, off)[0]
            bitmaps.append(('jpeg3', bid, jpg, alpha_comp))
        elif tt == 36:  # DefineBitsLossless2
            bid = struct.unpack_from('<H', raw, off)[0]
            fmt = raw[off + 2]
            w   = struct.unpack_from('<H', raw, off + 3)[0]
            h   = struct.unpack_from('<H', raw, off + 5)[0]
            bitmaps.append(('lossless2', bid, fmt, w, h, raw[off + 7 : te]))

    for entry in bitmaps:
        suffix = f"_bm{entry[1]}" if len(bitmaps) > 1 else ""
        if entry[0] == 'jpeg3':
            _, bid, jpg, alpha_comp = entry
            w, h = _jpeg_wh(jpg)
            if not w: continue
            jpg_b64 = base64.b64encode(jpg).decode()
            if alpha_comp:
                try:
                    alpha = zlib.decompress(alpha_comp)[:w*h]
                    alpha_b64 = base64.b64encode(_grey_png(w, h, alpha)).decode()
                    svg = (f'<svg xmlns="http://www.w3.org/2000/svg"'
                           f' xmlns:xlink="http://www.w3.org/1999/xlink"'
                           f' width="{w}" height="{h}" viewBox="0 0 {w} {h}">'
                           f'<defs><mask id="a"><image width="{w}" height="{h}"'
                           f' xlink:href="data:image/png;base64,{alpha_b64}"/></mask></defs>'
                           f'<image width="{w}" height="{h}"'
                           f' xlink:href="data:image/jpeg;base64,{jpg_b64}" mask="url(#a)"/></svg>')
                except Exception:
                    svg = (f'<svg xmlns="http://www.w3.org/2000/svg"'
                           f' xmlns:xlink="http://www.w3.org/1999/xlink"'
                           f' width="{w}" height="{h}" viewBox="0 0 {w} {h}">'
                           f'<image width="{w}" height="{h}"'
                           f' xlink:href="data:image/jpeg;base64,{jpg_b64}"/></svg>')
            else:
                svg = (f'<svg xmlns="http://www.w3.org/2000/svg"'
                       f' xmlns:xlink="http://www.w3.org/1999/xlink"'
                       f' width="{w}" height="{h}" viewBox="0 0 {w} {h}">'
                       f'<image width="{w}" height="{h}"'
                       f' xlink:href="data:image/jpeg;base64,{jpg_b64}"/></svg>')
            results.append((suffix, svg))

        elif entry[0] == 'lossless2':
            _, bid, fmt, w, h, compressed = entry
            if fmt != 5: continue
            try:
                argb = zlib.decompress(compressed)[:w*h*4]
                b64  = base64.b64encode(_rgba_png(w, h, argb)).decode()
                svg  = (f'<svg xmlns="http://www.w3.org/2000/svg"'
                        f' xmlns:xlink="http://www.w3.org/1999/xlink"'
                        f' width="{w}" height="{h}" viewBox="0 0 {w} {h}">'
                        f'<image width="{w}" height="{h}"'
                        f' xlink:href="data:image/png;base64,{b64}"/></svg>')
                results.append((suffix, svg))
            except Exception:
                pass

    return results


def composite_thumbnail(path):
    """Composite all bitmaps into a single RGBA PIL Image. Returns None if PIL unavailable."""
    if not HAS_PIL:
        return None
    composite = None
    for tt, raw, off, te in _iter_bitmaps(path):
        if tt == 35:
            dlen = struct.unpack_from('<I', raw, off + 2)[0]
            jpg  = raw[off + 6 : off + 6 + dlen]
            if jpg[:4] == b'\xff\xd9\xff\xd8': jpg = jpg[4:]
            alpha_comp = raw[off + 6 + dlen : te]
            try:
                img = Image.open(io.BytesIO(jpg)).convert('RGBA')
                if alpha_comp:
                    w, h = img.size
                    alpha = zlib.decompress(alpha_comp)[:w*h]
                    img.putalpha(Image.frombytes('L', (w, h), alpha))
                composite = img if composite is None else Image.alpha_composite(composite, img)
            except Exception:
                pass
        elif tt == 36:
            fmt = raw[off + 2]
            w   = struct.unpack_from('<H', raw, off + 3)[0]
            h   = struct.unpack_from('<H', raw, off + 5)[0]
            if fmt == 5:
                try:
                    argb = zlib.decompress(raw[off + 7 : te])[:w*h*4]
                    rgba = bytearray(w * h * 4)
                    for i in range(w * h):
                        a, r, g, b = argb[i*4], argb[i*4+1], argb[i*4+2], argb[i*4+3]
                        rgba[i*4:i*4+4] = bytes([r, g, b, a])
                    img = Image.frombytes('RGBA', (w, h), bytes(rgba))
                    composite = img if composite is None else Image.alpha_composite(composite, img)
                except Exception:
                    pass
    if composite is None:
        return None
    w, h = composite.size
    scale = min(1.0, THUMB_SIZE / max(w, h, 1))
    if scale < 1.0:
        composite = composite.resize((int(w*scale), int(h*scale)), Image.LANCZOS)
    return composite


# ── Main ──────────────────────────────────────────────────────────────────────

def main():
    if not WHEEL_DIR.exists():
        print(f"ERROR: wheel directory not found: {WHEEL_DIR}")
        sys.exit(1)

    # Collect all design IDs
    all_ids = sorted(set(
        int(p.stem.split('_')[1])
        for prefix in PREFIXES
        for p in WHEEL_DIR.glob(f"{prefix}_*.swf")
    ))

    print(f"Found {len(all_ids)} wheel designs across {len(PREFIXES)} views")
    print(f"Output: {OUT_ZIP}\n")

    total_svgs = 0
    total_thumbs = 0

    with zipfile.ZipFile(OUT_ZIP, 'w', zipfile.ZIP_DEFLATED, compresslevel=6) as zf:
        for idx, wid in enumerate(all_ids, 1):
            folder = f"wheels/wheel_{wid}"
            sys.stdout.write(f"\r  [{idx:>3}/{len(all_ids)}] wheel_{wid}   ")
            sys.stdout.flush()

            # Preview thumbnail from FF view
            ff_swf = WHEEL_DIR / f"wheelFF_{wid}.swf"
            if ff_swf.exists():
                thumb = composite_thumbnail(ff_swf)
                if thumb:
                    buf = io.BytesIO()
                    thumb.save(buf, 'PNG', optimize=True)
                    zf.writestr(f"{folder}/preview.png", buf.getvalue())
                    total_thumbs += 1

            # SVGs for all views
            for prefix in PREFIXES:
                swf = WHEEL_DIR / f"{prefix}_{wid}.swf"
                if not swf.exists():
                    continue
                stem = swf.stem
                for bm_suffix, svg in swf_to_svgs(swf):
                    zf.writestr(f"{folder}/{stem}{bm_suffix}.svg", svg)
                    total_svgs += 1

    print(f"\n\nDone.")
    print(f"  SVGs:      {total_svgs}")
    print(f"  Thumbnails:{total_thumbs}")
    print(f"  ZIP:       {OUT_ZIP.name}  ({OUT_ZIP.stat().st_size // 1024} KB)")


if __name__ == "__main__":
    main()
