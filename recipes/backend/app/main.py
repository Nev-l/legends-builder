"""
RecipeHub FastAPI application entry point.
Serves the API at /recipes/api/* and the static Next.js frontend at /recipes/*.
Unknown paths under /recipes/* fall back to index.html (SPA routing).
"""
from contextlib import asynccontextmanager
from pathlib import Path
from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse, JSONResponse

from app.core.config import settings
from app.api.routes import auth, recipes, meal_planner, pantry, users, admin, ai


STATIC_DIR = Path(__file__).parent.parent / "static"


@asynccontextmanager
async def lifespan(app: FastAPI):
    yield


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
app.include_router(pantry.router,       prefix=settings.API_PREFIX)
app.include_router(users.router,        prefix=settings.API_PREFIX)
app.include_router(admin.router,        prefix=settings.API_PREFIX)
app.include_router(ai.router,           prefix=settings.API_PREFIX)


# ── Health check ──────────────────────────────────────────────────────────────
@app.get(f"{settings.API_PREFIX}/health")
async def health():
    return {"status": "ok", "version": "0.1.0"}


# ── Static assets (_next/*, *.css, *.js, etc.) ───────────────────────────────
if STATIC_DIR.is_dir():
    app.mount(
        "/recipes/_next",
        StaticFiles(directory=str(STATIC_DIR / "_next")),
        name="next-assets",
    )

    # ── SPA fallback: everything else under /recipes/* → index.html ──────────
    @app.get("/recipes/{path:path}")
    async def spa_fallback(path: str, request: Request):
        candidate = STATIC_DIR / path
        # Exact file match
        if candidate.is_file():
            return FileResponse(str(candidate))
        # Directory with index.html (e.g. /recipes/login → login/index.html)
        dir_index = candidate / "index.html"
        if dir_index.is_file():
            return FileResponse(str(dir_index))
        # SPA shell for all other paths (recipe slugs etc.)
        index = STATIC_DIR / "index.html"
        if index.is_file():
            return FileResponse(str(index))
        return JSONResponse({"detail": "Not found"}, status_code=404)

    @app.get("/recipes")
    @app.get("/recipes/")
    async def spa_root():
        index = STATIC_DIR / "index.html"
        if index.is_file():
            return FileResponse(str(index))
        return JSONResponse({"detail": "Not found"}, status_code=404)
