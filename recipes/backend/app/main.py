"""
RecipeHub FastAPI application entry point.
Serves the API at /recipes/api/* and the static Next.js frontend at /recipes/*.
"""
from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
import os

from app.core.config import settings
from app.api.routes import auth, recipes, meal_planner, pantry


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup: nothing heavy yet (migrations run via alembic separately)
    yield
    # Shutdown


app = FastAPI(
    title=settings.APP_NAME,
    version="0.1.0",
    docs_url=f"{settings.API_PREFIX}/docs",
    redoc_url=f"{settings.API_PREFIX}/redoc",
    openapi_url=f"{settings.API_PREFIX}/openapi.json",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://0k.au", "http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ── API routes ────────────────────────────────────────────────────────────────
app.include_router(auth.router,         prefix=settings.API_PREFIX)
app.include_router(recipes.router,      prefix=settings.API_PREFIX)
app.include_router(meal_planner.router, prefix=settings.API_PREFIX)
app.include_router(pantry.router,      prefix=settings.API_PREFIX)


# ── Health check ──────────────────────────────────────────────────────────────
@app.get(f"{settings.API_PREFIX}/health")
async def health():
    return {"status": "ok", "version": "0.1.0"}


# ── Serve static Next.js build at /recipes/* ─────────────────────────────────
# The frontend is built with `next build && next export` → /out directory
STATIC_DIR = os.path.join(os.path.dirname(__file__), "..", "static")
if os.path.isdir(STATIC_DIR):
    app.mount("/recipes", StaticFiles(directory=STATIC_DIR, html=True), name="frontend")
