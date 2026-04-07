from pydantic_settings import BaseSettings, SettingsConfigDict
from functools import lru_cache


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")

    # App
    APP_NAME: str = "RecipeHub"
    API_PREFIX: str = "/recipes/api"
    DEBUG: bool = False

    # Database
    DATABASE_URL: str = "postgresql+asyncpg://recipes:recipes@localhost:5432/recipes"

    # Redis
    REDIS_URL: str = "redis://localhost:6379/1"

    # JWT
    SECRET_KEY: str = "change-me-in-production"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 7  # 7 days

    # File uploads
    UPLOAD_DIR: str = "/home/q/legends/recipes/uploads"
    MAX_UPLOAD_MB: int = 10

    # Grocery price cache TTL (seconds) — 6 hours
    PRICE_CACHE_TTL: int = 60 * 60 * 6

    # Google OAuth
    GOOGLE_CLIENT_ID: str = ""
    GOOGLE_CLIENT_SECRET: str = ""
    GOOGLE_REDIRECT_URI: str = "https://0k.au/recipes/api/auth/google/callback"

    # AI (Gemini)
    GEMINI_API_KEY: str = ""


@lru_cache
def get_settings() -> Settings:
    return Settings()


settings = get_settings()
