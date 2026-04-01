# Legends Car Builder

A web-based car compositor for the Legends racing game.
Loads the original SWF part files via Ruffle (WebAssembly Flash emulator), composites them layer by layer on an HTML5 Canvas, and exports a layered SVG ready for editing in Inkscape.

Live at: **http://0k.au/builder**

---

## What it does

- Pick a car, wheel design, tire design and paint colours
- The browser loads each SWF part (body, hood, bumper, wheels, etc.) through Ruffle and renders them in the correct game layer order
- Paint colours are applied using the same ColorMatrixFilter formula the game uses
- Export the result as a PNG or layered SVG (one Inkscape layer per part)
- Individual parts can be repositioned, scaled and skewed after building

---

## Repo layout

```
legends/
  builder/          ← Flask app + Ruffle frontend (the code)
    app.py          ← Python/Flask backend
    templates/
      index.html    ← All frontend JS/HTML/CSS in one file
    deploy/
      setup.sh      ← One-shot RPi4 setup script
      builder.service  ← systemd service
      nginx-builder.conf  ← nginx reverse proxy config
    requirements.txt
    README.md
  decom/
    car/            ← SWF packages, wheels, decals (game assets)
    parts/          ← Additional part SWFs
```

> `decom/` contains the original game asset files extracted from the SWF.
> They are required to run the builder but are not source code.

---

## Running locally (Windows / Mac / Linux)

**Requirements:** Python 3.8+

```bash
git clone https://github.com/Nev-l/legends-builder.git
cd legends-builder
pip install flask
python builder/app.py
```

Then open **http://localhost:5001/builder** in your browser.

---

## Deploying to Raspberry Pi 4

**First time setup:**

```bash
# On your local machine — copy assets to the Pi
rsync -avz decom/car/   pi@<ip>:/home/pi/legends/car/
rsync -avz decom/parts/ pi@<ip>:/home/pi/legends/parts/
rsync -avz builder/     pi@<ip>:/home/pi/legends/builder/

# On the Pi
ssh pi@<ip>
cd /home/pi/legends/builder
bash deploy/setup.sh
```

**Updating after a code change:**

```bash
# Push from your machine
git add -A
git commit -m "describe your change"
git push

# Pull on the Pi
ssh pi@<ip> "cd /home/pi/legends/builder && git pull && sudo systemctl restart builder"
```

---

## How colours work

The game applies paint using Flash's `ColorMatrixFilter` (from `CarConstruction.getPaintFilter`):

```
R_out = (R_target / 255) * R_in
G_out = (G_target / 255) * R_in
B_out = (B_target / 255) * R_in
```

The paint artwork in each SWF is a white/grey luminance map. Multiplying by the target colour produces natural shading while preserving highlights. The builder replicates this exactly.

Paintable parts: `body`, `bodyOpp`, `hood`, `bumper`, `bumperRear`, `skirt`, `top`, `trunk`, `spoiler`, `grille`, `wheelF`, `wheelR`, and all effect layers.

---

## Contributing

1. Fork the repo
2. Make your changes in `builder/`
3. Test locally with `python builder/app.py`
4. Open a pull request
