#!/usr/bin/env bash
# Run once on the Pi to set everything up.
# Usage: bash setup.sh
set -euo pipefail

PROJ=/home/q/legends/recipes
BACKEND=$PROJ/backend

echo "=== 1. Install PostgreSQL ==="
sudo apt-get update -q
sudo apt-get install -y postgresql postgresql-contrib tesseract-ocr

echo "=== 2. Create DB user + database ==="
sudo -u postgres psql -c "CREATE USER recipes WITH PASSWORD 'recipes';" 2>/dev/null || true
sudo -u postgres psql -c "CREATE DATABASE recipes OWNER recipes;" 2>/dev/null || true

echo "=== 3. Python venv + deps ==="
cd "$BACKEND"
python3 -m venv venv
venv/bin/pip install --upgrade pip wheel
venv/bin/pip install -r requirements.txt

echo "=== 4. Copy .env ==="
[ -f "$BACKEND/.env" ] || cp "$BACKEND/.env.example" "$BACKEND/.env"
echo "  → Edit $BACKEND/.env and fill in SECRET_KEY + Google OAuth credentials"

echo "=== 5. Run DB migrations ==="
cd "$BACKEND"
venv/bin/alembic upgrade head

echo "=== 6. Create upload directory ==="
mkdir -p "$PROJ/uploads"
mkdir -p "$BACKEND/static"   # Next.js build output goes here

echo "=== 7. Install systemd service ==="
sudo cp "$PROJ/deploy/recipes.service" /etc/systemd/system/recipes.service
sudo systemctl daemon-reload
sudo systemctl enable recipes
sudo systemctl start recipes

echo "=== 8. Add nginx location block ==="
# Append to existing 0k.au nginx config
NGINX_CONF=/etc/nginx/sites-available/0k.au
if ! grep -q "location /recipes" "$NGINX_CONF"; then
    sudo tee -a "$NGINX_CONF" > /dev/null << 'NGINX'

    # 7. RecipeHub
    location /recipes {
        proxy_pass         http://127.0.0.1:5002;
        proxy_http_version 1.1;
        proxy_set_header   Upgrade $http_upgrade;
        proxy_set_header   Connection 'upgrade';
        proxy_set_header   Host $host;
        proxy_set_header   X-Real-IP $remote_addr;
        proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto $scheme;
        proxy_read_timeout 120s;
        client_max_body_size 15m;
    }
NGINX
    # Insert the new block before the closing } of the server block
    sudo sed -i 's/^}$//' "$NGINX_CONF"
    sudo tee -a "$NGINX_CONF" > /dev/null << 'NGINX'

    # 7. RecipeHub
    location /recipes {
        proxy_pass         http://127.0.0.1:5002;
        proxy_http_version 1.1;
        proxy_set_header   Upgrade $http_upgrade;
        proxy_set_header   Connection 'upgrade';
        proxy_set_header   Host $host;
        proxy_set_header   X-Real-IP $remote_addr;
        proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto $scheme;
        proxy_read_timeout 120s;
        client_max_body_size 15m;
    }
}
NGINX
    sudo nginx -t && sudo systemctl reload nginx
    echo "  → Nginx updated"
else
    echo "  → Nginx block already present, skipping"
fi

echo ""
echo "✓ Setup complete."
echo "  API docs: https://0k.au/recipes/api/docs"
echo "  Health:   https://0k.au/recipes/api/health"
echo ""
echo "  Next steps:"
echo "  1. Edit $BACKEND/.env — add SECRET_KEY and Google OAuth creds"
echo "  2. sudo systemctl restart recipes"
echo "  3. Build the frontend: cd $PROJ/frontend && npm ci && npm run build"
