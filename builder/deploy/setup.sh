#!/bin/bash
# Run once on the RPi4 to set everything up
# Assumes you've already SCP'd the builder/ folder and the car/parts assets.
#
# Expected layout on RPi4:
#   /home/pi/legends/
#     builder/         ← this repo
#     car/             ← decom/car from Windows
#     parts/           ← decom/parts from Windows

set -e
cd /home/pi/legends/builder

echo "▶ Creating Python venv..."
python3 -m venv venv
./venv/bin/pip install -q --upgrade pip
./venv/bin/pip install -q -r requirements.txt

echo "▶ Creating saved/ directory..."
mkdir -p saved

echo "▶ Installing systemd service..."
sudo cp deploy/builder.service /etc/systemd/system/builder.service
sudo systemctl daemon-reload
sudo systemctl enable builder
sudo systemctl restart builder

echo "▶ Installing nginx config..."
sudo cp deploy/nginx-builder.conf /etc/nginx/sites-available/builder
sudo ln -sf /etc/nginx/sites-available/builder /etc/nginx/sites-enabled/builder
sudo nginx -t && sudo systemctl reload nginx

echo ""
echo "✓ Done! Try: curl http://localhost:5000/builder"
echo "✓ Public:    http://0k.au/builder"
