"""
Full database schema — all tables in one file for Phase 1 clarity.
"""
import enum
from datetime import datetime, timezone
from sqlalchemy import (
    BigInteger, Boolean, Column, DateTime, Enum, Float, ForeignKey,
    Integer, SmallInteger, String, Text, UniqueConstraint, Index,
)
from sqlalchemy.dialects.postgresql import ARRAY, JSONB
from sqlalchemy.orm import relationship
from app.core.database import Base


def now_utc():
    return datetime.now(timezone.utc)


# ── Enums ─────────────────────────────────────────────────────────────────────

class DietTag(str, enum.Enum):
    gluten_free  = "gluten_free"
    dairy_free   = "dairy_free"
    vegan        = "vegan"
    vegetarian   = "vegetarian"
    high_protein = "high_protein"
    low_carb     = "low_carb"
    nut_free     = "nut_free"

class RecipeSource(str, enum.Enum):
    scraped  = "scraped"   # pulled from external site
    ugc      = "ugc"       # user-generated
    forked   = "forked"    # remixed from another recipe

class MealSlot(str, enum.Enum):
    breakfast = "breakfast"
    lunch     = "lunch"
    dinner    = "dinner"
    snack     = "snack"

class RatingValue(int, enum.Enum):
    up   = 1
    down = -1

class UserRole(str, enum.Enum):
    user          = "user"
    vip           = "vip"
    verified_chef = "verified_chef"
    moderator     = "moderator"
    admin         = "admin"


# ── Users ─────────────────────────────────────────────────────────────────────

class User(Base):
    __tablename__ = "users"

    id              = Column(BigInteger, primary_key=True, autoincrement=True)
    email           = Column(String(255), unique=True, nullable=False, index=True)
    username        = Column(String(60), unique=True, nullable=False)
    hashed_password = Column(String(255), nullable=True)   # null = OAuth-only account
    display_name    = Column(String(120))
    avatar_url      = Column(String(500))
    dietary_prefs   = Column(ARRAY(String), default=list)  # e.g. ["vegan", "gluten_free"]
    bio             = Column(Text)
    manual_badges   = Column(ARRAY(String), default=list)  # admin-granted badge ids
    household_id    = Column(BigInteger, ForeignKey("households.id"), nullable=True)
    # Biometrics & Health (Smart AI Assistant)
    height_cm       = Column(Float)
    weight_kg       = Column(Float)
    target_weight_kg = Column(Float)
    birth_date      = Column(DateTime(timezone=True))
    biological_sex  = Column(String(20))                    # "male" | "female"
    activity_level  = Column(String(50))                    # "sedentary" | "light" | "moderate" | "active" | "very_active"
    bmi_history     = Column(JSONB, default=list)           # list of snapshots: [{"date": ISO, "weight": 85.0, "bmi": 24.5}]
    raul_prefs      = Column(JSONB, default=dict)           # Raul learned preferences: tastes, dislikes, patterns

    is_active       = Column(Boolean, default=True)
    role            = Column(String(20), default="user", nullable=False)
    created_at      = Column(DateTime(timezone=True), default=now_utc)

    household   = relationship("Household", back_populates="members")
    recipes     = relationship("Recipe", back_populates="author", foreign_keys="Recipe.author_id")
    ratings     = relationship("Rating", back_populates="user")
    pantry      = relationship("PantryItem", back_populates="user")
    meal_plans  = relationship("MealPlan", back_populates="user")
    favorites   = relationship("Favorite", back_populates="user")
    comments    = relationship("RecipeComment", back_populates="user")


class Household(Base):
    __tablename__ = "households"

    id         = Column(BigInteger, primary_key=True, autoincrement=True)
    name       = Column(String(120), nullable=False)
    invite_code = Column(String(12), unique=True)
    created_at = Column(DateTime(timezone=True), default=now_utc)

    members    = relationship("User", back_populates="household")
    shared_list = relationship("SharedGroceryItem", back_populates="household")


# ── Recipes ───────────────────────────────────────────────────────────────────

class Recipe(Base):
    __tablename__ = "recipes"

    id              = Column(BigInteger, primary_key=True, autoincrement=True)
    title           = Column(String(300), nullable=False)
    slug            = Column(String(350), unique=True, nullable=False, index=True)
    description     = Column(Text)
    source          = Column(String(20), nullable=False, default="ugc")
    source_url      = Column(String(1000))           # original URL for scraped recipes
    forked_from_id  = Column(BigInteger, ForeignKey("recipes.id"), nullable=True)
    author_id       = Column(BigInteger, ForeignKey("users.id"), nullable=True)
    image_url       = Column(String(1000))
    prep_minutes    = Column(SmallInteger)
    cook_minutes    = Column(SmallInteger)
    servings        = Column(SmallInteger, default=4)
    diet_tags       = Column(ARRAY(String), default=list)   # auto-tagged + user-confirmed
    # Macros per serving (auto-calculated)
    calories        = Column(Float)
    protein_g       = Column(Float)
    carbs_g         = Column(Float)
    fat_g           = Column(Float)
    # Voting cache (denormalised for fast sorts)
    upvotes         = Column(Integer, default=0)
    downvotes       = Column(Integer, default=0)
    score           = Column(Integer, default=0)       # upvotes - downvotes
    view_count      = Column(Integer, default=0)
    is_published    = Column(Boolean, default=True)
    created_at      = Column(DateTime(timezone=True), default=now_utc)
    updated_at      = Column(DateTime(timezone=True), default=now_utc, onupdate=now_utc)

    author          = relationship("User", back_populates="recipes", foreign_keys=[author_id])
    fork_parent     = relationship("Recipe", remote_side="Recipe.id", foreign_keys=[forked_from_id])
    ingredients     = relationship("RecipeIngredient", back_populates="recipe", cascade="all, delete-orphan", order_by="RecipeIngredient.position")
    steps           = relationship("RecipeStep", back_populates="recipe", cascade="all, delete-orphan", order_by="RecipeStep.position")
    ratings         = relationship("Rating", back_populates="recipe", cascade="all, delete-orphan")
    meal_plan_items = relationship("MealPlanItem", back_populates="recipe", cascade="all, delete-orphan")
    favorites       = relationship("Favorite", back_populates="recipe", cascade="all, delete-orphan")
    comments        = relationship("RecipeComment", back_populates="recipe", cascade="all, delete-orphan")

    __table_args__ = (
        Index("ix_recipes_score", "score"),
        Index("ix_recipes_created", "created_at"),
    )


class Ingredient(Base):
    """Canonical ingredient dictionary — one row per unique ingredient name."""
    __tablename__ = "ingredients"

    id           = Column(BigInteger, primary_key=True, autoincrement=True)
    name         = Column(String(200), unique=True, nullable=False, index=True)
    canonical    = Column(String(200))   # normalised form, e.g. "chicken breast"
    allergen_tags = Column(ARRAY(String), default=list)

    recipe_uses  = relationship("RecipeIngredient", back_populates="ingredient")
    pantry_items = relationship("PantryItem", back_populates="ingredient")
    prices       = relationship("IngredientPrice", back_populates="ingredient")


class RecipeIngredient(Base):
    """Junction: a recipe uses an ingredient at a specific quantity/unit."""
    __tablename__ = "recipe_ingredients"

    id            = Column(BigInteger, primary_key=True, autoincrement=True)
    recipe_id     = Column(BigInteger, ForeignKey("recipes.id", ondelete="CASCADE"), nullable=False)
    ingredient_id = Column(BigInteger, ForeignKey("ingredients.id"), nullable=False)
    quantity      = Column(Float)          # numeric quantity (e.g. 1.5)
    unit          = Column(String(50))     # "cups", "g", "tbsp", etc.
    note          = Column(String(200))    # "finely chopped", "to taste"
    position      = Column(SmallInteger, default=0)

    recipe       = relationship("Recipe", back_populates="ingredients")
    ingredient   = relationship("Ingredient", back_populates="recipe_uses")


class RecipeStep(Base):
    __tablename__ = "recipe_steps"

    id          = Column(BigInteger, primary_key=True, autoincrement=True)
    recipe_id   = Column(BigInteger, ForeignKey("recipes.id", ondelete="CASCADE"), nullable=False)
    position    = Column(SmallInteger, nullable=False)
    body        = Column(Text, nullable=False)   # rich-text / markdown
    image_url   = Column(String(1000))
    timer_mins  = Column(SmallInteger)          # optional step timer

    recipe = relationship("Recipe", back_populates="steps")


# ── Ratings ───────────────────────────────────────────────────────────────────

class Rating(Base):
    __tablename__ = "ratings"
    __table_args__ = (UniqueConstraint("user_id", "recipe_id"),)

    id        = Column(BigInteger, primary_key=True, autoincrement=True)
    user_id   = Column(BigInteger, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    recipe_id = Column(BigInteger, ForeignKey("recipes.id", ondelete="CASCADE"), nullable=False)
    value     = Column(SmallInteger, nullable=False)  # 1 = up, -1 = down
    created_at = Column(DateTime(timezone=True), default=now_utc)

    user   = relationship("User", back_populates="ratings")
    recipe = relationship("Recipe", back_populates="ratings")


class Favorite(Base):
    __tablename__ = "favorites"
    __table_args__ = (UniqueConstraint("user_id", "recipe_id"),)

    id        = Column(BigInteger, primary_key=True, autoincrement=True)
    user_id   = Column(BigInteger, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    recipe_id = Column(BigInteger, ForeignKey("recipes.id", ondelete="CASCADE"), nullable=False)
    created_at = Column(DateTime(timezone=True), default=now_utc)

    user   = relationship("User", back_populates="favorites")
    recipe = relationship("Recipe", back_populates="favorites")


# ── Meal Planner ──────────────────────────────────────────────────────────────

class MealPlan(Base):
    """One plan = one week, owned by a user (or shared via household)."""
    __tablename__ = "meal_plans"

    id           = Column(BigInteger, primary_key=True, autoincrement=True)
    user_id      = Column(BigInteger, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    week_start   = Column(DateTime(timezone=True), nullable=False)   # Monday 00:00 UTC
    is_batch_week = Column(Boolean, default=False)
    notes        = Column(Text)
    created_at   = Column(DateTime(timezone=True), default=now_utc)

    user  = relationship("User", back_populates="meal_plans")
    items = relationship("MealPlanItem", back_populates="plan", cascade="all, delete-orphan")


class MealPlanItem(Base):
    __tablename__ = "meal_plan_items"

    id          = Column(BigInteger, primary_key=True, autoincrement=True)
    plan_id     = Column(BigInteger, ForeignKey("meal_plans.id", ondelete="CASCADE"), nullable=False)
    recipe_id   = Column(BigInteger, ForeignKey("recipes.id"), nullable=False)
    day_of_week = Column(SmallInteger, nullable=False)   # 0=Mon … 6=Sun
    slot        = Column(String(20), nullable=False)
    servings    = Column(SmallInteger, default=4)
    is_leftover = Column(Boolean, default=False)
    is_batch    = Column(Boolean, default=False)

    plan   = relationship("MealPlan", back_populates="items")
    recipe = relationship("Recipe", back_populates="meal_plan_items")


# ── Pantry ────────────────────────────────────────────────────────────────────

class PantryItem(Base):
    __tablename__ = "pantry_items"
    __table_args__ = (UniqueConstraint("user_id", "ingredient_id"),)

    id            = Column(BigInteger, primary_key=True, autoincrement=True)
    user_id       = Column(BigInteger, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    ingredient_id = Column(BigInteger, ForeignKey("ingredients.id"), nullable=False)
    quantity      = Column(Float)
    unit          = Column(String(50))
    expires_on    = Column(DateTime(timezone=True))
    added_via_ocr = Column(Boolean, default=False)
    updated_at    = Column(DateTime(timezone=True), default=now_utc, onupdate=now_utc)

    user       = relationship("User", back_populates="pantry")
    ingredient = relationship("Ingredient", back_populates="pantry_items")


# ── Grocery Prices ────────────────────────────────────────────────────────────

class IngredientPrice(Base):
    """Cached supermarket pricing. Refreshed every 6 hours via background task."""
    __tablename__ = "ingredient_prices"
    __table_args__ = (UniqueConstraint("ingredient_id", "retailer"),)

    id            = Column(BigInteger, primary_key=True, autoincrement=True)
    ingredient_id = Column(BigInteger, ForeignKey("ingredients.id"), nullable=False)
    retailer      = Column(String(30), nullable=False)   # "coles" | "woolworths" | "aldi"
    product_name  = Column(String(300))
    price_aud     = Column(Float)
    unit_price    = Column(Float)    # price per 100g / 100ml
    unit_label    = Column(String(30))
    product_url   = Column(String(1000))
    fetched_at    = Column(DateTime(timezone=True), default=now_utc)

    ingredient = relationship("Ingredient", back_populates="prices")


# ── Recipe Comments ───────────────────────────────────────────────────────────

class RecipeComment(Base):
    __tablename__ = "recipe_comments"

    id         = Column(BigInteger, primary_key=True, autoincrement=True)
    recipe_id  = Column(BigInteger, ForeignKey("recipes.id", ondelete="CASCADE"), nullable=False)
    user_id    = Column(BigInteger, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    body       = Column(Text, nullable=False)
    created_at = Column(DateTime(timezone=True), default=now_utc)
    updated_at = Column(DateTime(timezone=True), default=now_utc, onupdate=now_utc)

    recipe = relationship("Recipe", back_populates="comments")
    user   = relationship("User", back_populates="comments")


# ── Recipe Edits ─────────────────────────────────────────────────────────────

class RecipeEditProposal(Base):
    __tablename__ = "recipe_edits"

    id               = Column(BigInteger, primary_key=True, autoincrement=True)
    recipe_id        = Column(BigInteger, ForeignKey("recipes.id", ondelete="CASCADE"), nullable=False)
    user_id          = Column(BigInteger, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    proposed_changes = Column(JSONB, nullable=False)
    status           = Column(String(20), default="pending") # pending, approved, rejected
    created_at       = Column(DateTime(timezone=True), default=now_utc)
    updated_at       = Column(DateTime(timezone=True), default=now_utc, onupdate=now_utc)

    recipe = relationship("Recipe")
    user   = relationship("User")


# ── Shared Household Grocery List ─────────────────────────────────────────────

class SharedGroceryItem(Base):
    __tablename__ = "shared_grocery_items"

    id            = Column(BigInteger, primary_key=True, autoincrement=True)
    household_id  = Column(BigInteger, ForeignKey("households.id", ondelete="CASCADE"), nullable=False)
    ingredient_id = Column(BigInteger, ForeignKey("ingredients.id"), nullable=False)
    quantity      = Column(Float)
    unit          = Column(String(50))
    is_checked    = Column(Boolean, default=False)
    added_by_id   = Column(BigInteger, ForeignKey("users.id"))
    created_at    = Column(DateTime(timezone=True), default=now_utc)

    household = relationship("Household", back_populates="shared_list")


# ── Administration ────────────────────────────────────────────────────────────

class AdminActivityLog(Base):
    """Tracks administrative actions for audit purposes."""
    __tablename__ = "admin_activity_logs"

    id          = Column(BigInteger, primary_key=True, autoincrement=True)
    admin_id    = Column(BigInteger, ForeignKey("users.id"), nullable=False)
    action_type = Column(String(50), nullable=False)   # e.g., "role_change", "recipe_delete", "reassign_author"
    target_type = Column(String(50))                   # e.g., "user", "recipe"
    target_id   = Column(String(100))                  # ID or slug of the target
    details     = Column(JSONB)                        # exact changes or additional context
    created_at  = Column(DateTime(timezone=True), default=now_utc)

    admin = relationship("User")


class SiteStats(Base):
    """Aggregated daily statistics for the admin dashboard."""
    __tablename__ = "site_stats"

    id             = Column(BigInteger, primary_key=True, autoincrement=True)
    date           = Column(DateTime(timezone=True), unique=True, nullable=False, index=True)
    page_views     = Column(Integer, default=0)
    new_users      = Column(Integer, default=0)
    new_recipes    = Column(Integer, default=0)
    active_users   = Column(Integer, default=0)
    created_at     = Column(DateTime(timezone=True), default=now_utc)
