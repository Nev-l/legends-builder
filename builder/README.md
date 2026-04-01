# Car Builder — 0k.au/builder

Web-based car compositor for the Legends game assets.
Loads SWF part files via Ruffle (WASM Flash), composites them layer-by-layer
on an HTML5 Canvas, and exports a layered SVG file (ready for Inkscape).

---

## How it works

1. Each car lives in `car/packages/{carId}f/` (front) or `{carId}b/` (back).
2. Parts are SWF files: `body.swf`, `hood.swf`, `bumper.swf`, etc.
3. Ruffle renders each SWF off-screen in a hidden player.
4. The browser's Canvas API composites them in the correct z-order.
5. Paintable parts get a colour-matrix tint (replicates Flash's `ColorMatrixFilter`).
6. The result is exported as a layered SVG with each part as an Inkscape layer.

---

## File layout expected on the RPi4

```
/home/pi/legends/
  builder/          ← this directory
    app.py
    templates/
    deploy/
    saved/          ← SVG output goes here
  car/              ← from Windows: decom/car/
    packages/
    wheel/
    decals/
  parts/            ← from Windows: decom/parts/
```

Copy assets from Windows to RPi4:
```bash
rsync -avz "/c/Users/kan1b/OneDrive/Desktop/legends/decom/car/"   pi@<ip>:/home/pi/legends/car/
rsync -avz "/c/Users/kan1b/OneDrive/Desktop/legends/decom/parts/" pi@<ip>:/home/pi/legends/parts/
rsync -avz "/c/Users/kan1b/OneDrive/Desktop/legends/builder/"     pi@<ip>:/home/pi/legends/builder/
```

---

## RPi4 deployment (first time)

```bash
ssh pi@<ip>
cd /home/pi/legends/builder
bash deploy/setup.sh
```

That script:
- Creates a Python venv and installs Flask + gunicorn
- Installs and enables the systemd service (port 5000)
- Installs the nginx reverse-proxy config for `0k.au/builder`

---

## Development on Windows

```bash
cd C:\Users\kan1b\OneDrive\Desktop\legends\builder
pip install flask
python app.py
# open http://localhost:5000/builder
```

The app auto-detects the `decom/car` and `decom/parts` paths relative to the
builder directory — no config needed for local dev.

---

## SVG output

Saved files appear in `builder/saved/` and are linked in the sidebar.
Each SVG contains one Inkscape layer per car part, ordered bottom-to-top.
Open in Inkscape → File → Open → pick the SVG → layers are ready to use.

---

## Colour tinting

Replicates Flash's `ColorMatrixFilter` from `CarConstruction.getPaintFilter`:

```
R_out = (R_target / 255) × R_in
G_out = (G_target / 255) × R_in
B_out = (B_target / 255) × R_in
```

The raw SWF artwork stores its paint layer as a white/light shape.
Multiplying by the target colour gives natural shading without losing highlights.

---

## Part render order (front view, bottom → top)

```
shadow → underCarriage → body/bodyOpp → bumperRear → skirt → bumper →
grille → hood → lights → effects (door/fender/cPillar/side/hood) →
eyelids → spoiler → top → roofEffect → tireF → wheelF → tireR → wheelR
```
