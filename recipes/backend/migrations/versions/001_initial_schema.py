"""Initial schema

Revision ID: 001
Revises:
Create Date: 2026-04-03
"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

revision = "001"
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.create_table(
        "households",
        sa.Column("id", sa.BigInteger(), autoincrement=True, primary_key=True),
        sa.Column("name", sa.String(120), nullable=False),
        sa.Column("invite_code", sa.String(12), unique=True),
        sa.Column("created_at", sa.DateTime(timezone=True)),
    )

    op.create_table(
        "users",
        sa.Column("id", sa.BigInteger(), autoincrement=True, primary_key=True),
        sa.Column("email", sa.String(255), nullable=False, unique=True),
        sa.Column("username", sa.String(60), nullable=False, unique=True),
        sa.Column("hashed_password", sa.String(255)),
        sa.Column("display_name", sa.String(120)),
        sa.Column("avatar_url", sa.String(500)),
        sa.Column("dietary_prefs", postgresql.ARRAY(sa.String()), server_default="{}"),
        sa.Column("household_id", sa.BigInteger(), sa.ForeignKey("households.id"), nullable=True),
        sa.Column("is_active", sa.Boolean(), server_default="true"),
        sa.Column("created_at", sa.DateTime(timezone=True)),
    )
    op.create_index("ix_users_email", "users", ["email"])

    op.create_table(
        "ingredients",
        sa.Column("id", sa.BigInteger(), autoincrement=True, primary_key=True),
        sa.Column("name", sa.String(200), nullable=False, unique=True),
        sa.Column("canonical", sa.String(200)),
        sa.Column("allergen_tags", postgresql.ARRAY(sa.String()), server_default="{}"),
    )
    op.create_index("ix_ingredients_name", "ingredients", ["name"])

    op.create_table(
        "recipes",
        sa.Column("id", sa.BigInteger(), autoincrement=True, primary_key=True),
        sa.Column("title", sa.String(300), nullable=False),
        sa.Column("slug", sa.String(350), nullable=False, unique=True),
        sa.Column("description", sa.Text()),
        sa.Column("source", sa.String(20), nullable=False, server_default="ugc"),
        sa.Column("source_url", sa.String(1000)),
        sa.Column("forked_from_id", sa.BigInteger(), sa.ForeignKey("recipes.id"), nullable=True),
        sa.Column("author_id", sa.BigInteger(), sa.ForeignKey("users.id"), nullable=True),
        sa.Column("image_url", sa.String(1000)),
        sa.Column("prep_minutes", sa.SmallInteger()),
        sa.Column("cook_minutes", sa.SmallInteger()),
        sa.Column("servings", sa.SmallInteger(), server_default="4"),
        sa.Column("diet_tags", postgresql.ARRAY(sa.String()), server_default="{}"),
        sa.Column("calories", sa.Float()),
        sa.Column("protein_g", sa.Float()),
        sa.Column("carbs_g", sa.Float()),
        sa.Column("fat_g", sa.Float()),
        sa.Column("upvotes", sa.Integer(), server_default="0"),
        sa.Column("downvotes", sa.Integer(), server_default="0"),
        sa.Column("score", sa.Integer(), server_default="0"),
        sa.Column("view_count", sa.Integer(), server_default="0"),
        sa.Column("is_published", sa.Boolean(), server_default="true"),
        sa.Column("created_at", sa.DateTime(timezone=True)),
        sa.Column("updated_at", sa.DateTime(timezone=True)),
    )
    op.create_index("ix_recipes_slug",    "recipes", ["slug"])
    op.create_index("ix_recipes_score",   "recipes", ["score"])
    op.create_index("ix_recipes_created", "recipes", ["created_at"])

    op.create_table(
        "recipe_ingredients",
        sa.Column("id", sa.BigInteger(), autoincrement=True, primary_key=True),
        sa.Column("recipe_id", sa.BigInteger(), sa.ForeignKey("recipes.id", ondelete="CASCADE"), nullable=False),
        sa.Column("ingredient_id", sa.BigInteger(), sa.ForeignKey("ingredients.id"), nullable=False),
        sa.Column("quantity", sa.Float()),
        sa.Column("unit", sa.String(50)),
        sa.Column("note", sa.String(200)),
        sa.Column("position", sa.SmallInteger(), server_default="0"),
    )

    op.create_table(
        "recipe_steps",
        sa.Column("id", sa.BigInteger(), autoincrement=True, primary_key=True),
        sa.Column("recipe_id", sa.BigInteger(), sa.ForeignKey("recipes.id", ondelete="CASCADE"), nullable=False),
        sa.Column("position", sa.SmallInteger(), nullable=False),
        sa.Column("body", sa.Text(), nullable=False),
        sa.Column("image_url", sa.String(1000)),
        sa.Column("timer_mins", sa.SmallInteger()),
    )

    op.create_table(
        "ratings",
        sa.Column("id", sa.BigInteger(), autoincrement=True, primary_key=True),
        sa.Column("user_id", sa.BigInteger(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False),
        sa.Column("recipe_id", sa.BigInteger(), sa.ForeignKey("recipes.id", ondelete="CASCADE"), nullable=False),
        sa.Column("value", sa.SmallInteger(), nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True)),
        sa.UniqueConstraint("user_id", "recipe_id"),
    )

    op.create_table(
        "favorites",
        sa.Column("id", sa.BigInteger(), autoincrement=True, primary_key=True),
        sa.Column("user_id", sa.BigInteger(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False),
        sa.Column("recipe_id", sa.BigInteger(), sa.ForeignKey("recipes.id", ondelete="CASCADE"), nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True)),
        sa.UniqueConstraint("user_id", "recipe_id"),
    )

    op.create_table(
        "meal_plans",
        sa.Column("id", sa.BigInteger(), autoincrement=True, primary_key=True),
        sa.Column("user_id", sa.BigInteger(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False),
        sa.Column("week_start", sa.DateTime(timezone=True), nullable=False),
        sa.Column("is_batch_week", sa.Boolean(), server_default="false"),
        sa.Column("notes", sa.Text()),
        sa.Column("created_at", sa.DateTime(timezone=True)),
    )

    op.create_table(
        "meal_plan_items",
        sa.Column("id", sa.BigInteger(), autoincrement=True, primary_key=True),
        sa.Column("plan_id", sa.BigInteger(), sa.ForeignKey("meal_plans.id", ondelete="CASCADE"), nullable=False),
        sa.Column("recipe_id", sa.BigInteger(), sa.ForeignKey("recipes.id"), nullable=False),
        sa.Column("day_of_week", sa.SmallInteger(), nullable=False),
        sa.Column("slot", sa.String(20), nullable=False),
        sa.Column("servings", sa.SmallInteger(), server_default="4"),
        sa.Column("is_leftover", sa.Boolean(), server_default="false"),
        sa.Column("is_batch", sa.Boolean(), server_default="false"),
    )

    op.create_table(
        "pantry_items",
        sa.Column("id", sa.BigInteger(), autoincrement=True, primary_key=True),
        sa.Column("user_id", sa.BigInteger(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False),
        sa.Column("ingredient_id", sa.BigInteger(), sa.ForeignKey("ingredients.id"), nullable=False),
        sa.Column("quantity", sa.Float()),
        sa.Column("unit", sa.String(50)),
        sa.Column("expires_on", sa.DateTime(timezone=True)),
        sa.Column("added_via_ocr", sa.Boolean(), server_default="false"),
        sa.Column("updated_at", sa.DateTime(timezone=True)),
        sa.UniqueConstraint("user_id", "ingredient_id"),
    )

    op.create_table(
        "ingredient_prices",
        sa.Column("id", sa.BigInteger(), autoincrement=True, primary_key=True),
        sa.Column("ingredient_id", sa.BigInteger(), sa.ForeignKey("ingredients.id"), nullable=False),
        sa.Column("retailer", sa.String(30), nullable=False),
        sa.Column("product_name", sa.String(300)),
        sa.Column("price_aud", sa.Float()),
        sa.Column("unit_price", sa.Float()),
        sa.Column("unit_label", sa.String(30)),
        sa.Column("product_url", sa.String(1000)),
        sa.Column("fetched_at", sa.DateTime(timezone=True)),
        sa.UniqueConstraint("ingredient_id", "retailer"),
    )

    op.create_table(
        "shared_grocery_items",
        sa.Column("id", sa.BigInteger(), autoincrement=True, primary_key=True),
        sa.Column("household_id", sa.BigInteger(), sa.ForeignKey("households.id", ondelete="CASCADE"), nullable=False),
        sa.Column("ingredient_id", sa.BigInteger(), sa.ForeignKey("ingredients.id"), nullable=False),
        sa.Column("quantity", sa.Float()),
        sa.Column("unit", sa.String(50)),
        sa.Column("is_checked", sa.Boolean(), server_default="false"),
        sa.Column("added_by_id", sa.BigInteger(), sa.ForeignKey("users.id")),
        sa.Column("created_at", sa.DateTime(timezone=True)),
    )


def downgrade() -> None:
    for t in [
        "shared_grocery_items", "ingredient_prices", "pantry_items",
        "meal_plan_items", "meal_plans", "favorites", "ratings",
        "recipe_steps", "recipe_ingredients", "recipes",
        "ingredients", "users", "households",
    ]:
        op.drop_table(t)
