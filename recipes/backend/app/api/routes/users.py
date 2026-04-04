"""
User profiles, badges, and recipe comments.
"""
from datetime import datetime, timezone
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload
from typing import Optional

from app.core.database import get_db
from app.core.security import get_current_user_id, get_optional_user_id
from app.models.models import User, Recipe, Rating, RecipeComment

router = APIRouter(tags=["users"])


# ── Badge definitions ─────────────────────────────────────────────────────────

BADGE_DEFS = [
    # Cooking activity
    {"id": "first_recipe",    "name": "First Recipe",       "icon": "🍳", "desc": "Created your first recipe"},
    {"id": "recipe_5",        "name": "Home Cook",          "icon": "👨‍🍳", "desc": "Created 5 recipes"},
    {"id": "recipe_20",       "name": "Chef",               "icon": "🧑‍🍳", "desc": "Created 20 recipes"},
    {"id": "recipe_50",       "name": "Master Chef",        "icon": "⭐", "desc": "Created 50 recipes"},
    {"id": "first_fork",      "name": "Remixer",            "icon": "🍴", "desc": "Forked your first recipe"},
    {"id": "fork_5",          "name": "Recipe Hacker",      "icon": "🔧", "desc": "Forked 5 recipes"},
    # Voting
    {"id": "first_upvote",    "name": "Crowd Pleaser",      "icon": "👍", "desc": "Received your first upvote"},
    {"id": "upvotes_10",      "name": "Fan Favourite",      "icon": "🌟", "desc": "Received 10 upvotes across recipes"},
    {"id": "upvotes_50",      "name": "Community Star",     "icon": "💫", "desc": "Received 50 upvotes"},
    {"id": "upvotes_100",     "name": "Legend",             "icon": "🏆", "desc": "Received 100 upvotes"},
    {"id": "voted_10",        "name": "Critic",             "icon": "🎭", "desc": "Voted on 10 recipes"},
    {"id": "voted_50",        "name": "Food Critic",        "icon": "📝", "desc": "Voted on 50 recipes"},
    # Social
    {"id": "first_comment",   "name": "Conversationalist",  "icon": "💬", "desc": "Left your first comment"},
    {"id": "comment_10",      "name": "Social Butterfly",   "icon": "🦋", "desc": "Left 10 comments"},
    # Longevity
    {"id": "week_1",          "name": "Regular",            "icon": "📅", "desc": "Member for 1 week"},
    {"id": "month_1",         "name": "Loyal Member",       "icon": "🗓️", "desc": "Member for 1 month"},
    {"id": "month_6",         "name": "Veteran",            "icon": "🎖️", "desc": "Member for 6 months"},
    {"id": "year_1",          "name": "Old Timer",          "icon": "🏅", "desc": "Member for 1 year"},
    # Diet diversity
    {"id": "diet_variety",    "name": "Diet Explorer",      "icon": "🌈", "desc": "Created recipes covering 3+ diet types"},
    # Pantry / planner
    {"id": "planner_user",    "name": "Meal Planner",       "icon": "📋", "desc": "Built your first meal plan"},
    # Special
    {"id": "admin",           "name": "Admin",              "icon": "🛡️", "desc": "Site administrator"},
]

BADGE_MAP = {b["id"]: b for b in BADGE_DEFS}


async def compute_badges(user: User, db: AsyncSession) -> list[dict]:
    earned = []
    now = datetime.now(timezone.utc)
    joined = user.created_at or now

    # Admin
    if user.id == 1:
        earned.append("admin")

    # Membership duration
    days = (now - joined).days
    if days >= 7:   earned.append("week_1")
    if days >= 30:  earned.append("month_1")
    if days >= 180: earned.append("month_6")
    if days >= 365: earned.append("year_1")

    # Recipes created
    recipe_count = await db.scalar(
        select(func.count()).select_from(Recipe)
        .where(Recipe.author_id == user.id, Recipe.source == "ugc")
    )
    fork_count = await db.scalar(
        select(func.count()).select_from(Recipe)
        .where(Recipe.author_id == user.id, Recipe.source == "forked")
    )
    if recipe_count and recipe_count >= 1:  earned.append("first_recipe")
    if recipe_count and recipe_count >= 5:  earned.append("recipe_5")
    if recipe_count and recipe_count >= 20: earned.append("recipe_20")
    if recipe_count and recipe_count >= 50: earned.append("recipe_50")
    if fork_count and fork_count >= 1: earned.append("first_fork")
    if fork_count and fork_count >= 5: earned.append("fork_5")

    # Upvotes received on own recipes
    total_upvotes = await db.scalar(
        select(func.sum(Recipe.upvotes))
        .where(Recipe.author_id == user.id)
    ) or 0
    if total_upvotes >= 1:   earned.append("first_upvote")
    if total_upvotes >= 10:  earned.append("upvotes_10")
    if total_upvotes >= 50:  earned.append("upvotes_50")
    if total_upvotes >= 100: earned.append("upvotes_100")

    # Votes cast
    vote_count = await db.scalar(
        select(func.count()).select_from(Rating).where(Rating.user_id == user.id)
    ) or 0
    if vote_count >= 10: earned.append("voted_10")
    if vote_count >= 50: earned.append("voted_50")

    # Comments
    comment_count = await db.scalar(
        select(func.count()).select_from(RecipeComment).where(RecipeComment.user_id == user.id)
    ) or 0
    if comment_count >= 1:  earned.append("first_comment")
    if comment_count >= 10: earned.append("comment_10")

    # Diet variety across ugc recipes
    diet_rows = await db.execute(
        select(Recipe.diet_tags).where(Recipe.author_id == user.id, Recipe.source == "ugc")
    )
    all_tags: set[str] = set()
    for (tags,) in diet_rows:
        if tags:
            all_tags.update(tags)
    if len(all_tags) >= 3:
        earned.append("diet_variety")

    return [BADGE_MAP[b] for b in earned if b in BADGE_MAP]


# ── Profile endpoint ──────────────────────────────────────────────────────────

@router.get("/users/{username}")
async def get_profile(username: str, db: AsyncSession = Depends(get_db)):
    user = await db.scalar(select(User).where(User.username == username.lower()))
    if not user:
        raise HTTPException(404, "User not found")

    badges = await compute_badges(user, db)

    recipe_count = await db.scalar(
        select(func.count()).select_from(Recipe)
        .where(Recipe.author_id == user.id, Recipe.is_published == True)
    ) or 0

    total_upvotes = await db.scalar(
        select(func.sum(Recipe.upvotes)).where(Recipe.author_id == user.id)
    ) or 0

    return {
        "id": user.id,
        "username": user.username,
        "display_name": user.display_name or user.username,
        "avatar_url": user.avatar_url,
        "joined": user.created_at.date().isoformat() if user.created_at else None,
        "recipe_count": recipe_count,
        "total_upvotes": int(total_upvotes),
        "badges": badges,
    }


@router.get("/users/{username}/recipes")
async def get_user_recipes(
    username: str,
    limit: int = 20,
    offset: int = 0,
    db: AsyncSession = Depends(get_db),
):
    user = await db.scalar(select(User).where(User.username == username.lower()))
    if not user:
        raise HTTPException(404, "User not found")

    rows = await db.execute(
        select(Recipe)
        .where(Recipe.author_id == user.id, Recipe.is_published == True)
        .order_by(Recipe.created_at.desc())
        .limit(limit).offset(offset)
    )
    recipes = rows.scalars().all()
    return [
        {
            "slug": r.slug,
            "title": r.title,
            "image_url": r.image_url,
            "diet_tags": r.diet_tags or [],
            "upvotes": r.upvotes,
            "source": r.source,
            "created_at": r.created_at.date().isoformat() if r.created_at else None,
        }
        for r in recipes
    ]


# ── Comments ──────────────────────────────────────────────────────────────────

class CommentIn(BaseModel):
    body: str


@router.get("/recipes/{slug}/comments")
async def list_comments(slug: str, db: AsyncSession = Depends(get_db)):
    recipe = await db.scalar(select(Recipe).where(Recipe.slug == slug))
    if not recipe:
        raise HTTPException(404, "Recipe not found")

    rows = await db.execute(
        select(RecipeComment)
        .where(RecipeComment.recipe_id == recipe.id)
        .options(selectinload(RecipeComment.user))
        .order_by(RecipeComment.created_at.asc())
    )
    comments = rows.scalars().all()
    return [
        {
            "id": c.id,
            "body": c.body,
            "created_at": c.created_at.isoformat() if c.created_at else None,
            "user": {
                "username": c.user.username,
                "display_name": c.user.display_name or c.user.username,
                "avatar_url": c.user.avatar_url,
            },
        }
        for c in comments
    ]


@router.post("/recipes/{slug}/comments", status_code=201)
async def add_comment(
    slug: str,
    body: CommentIn,
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    if not body.body.strip():
        raise HTTPException(400, "Comment cannot be empty")
    recipe = await db.scalar(select(Recipe).where(Recipe.slug == slug))
    if not recipe:
        raise HTTPException(404, "Recipe not found")

    comment = RecipeComment(
        recipe_id=recipe.id,
        user_id=user_id,
        body=body.body.strip()[:1000],
    )
    db.add(comment)
    await db.flush()

    # Load user for response
    user = await db.scalar(select(User).where(User.id == user_id))
    await db.commit()

    return {
        "id": comment.id,
        "body": comment.body,
        "created_at": comment.created_at.isoformat() if comment.created_at else None,
        "user": {
            "username": user.username,
            "display_name": user.display_name or user.username,
            "avatar_url": user.avatar_url,
        },
    }


@router.delete("/recipes/{slug}/comments/{comment_id}", status_code=204)
async def delete_comment(
    slug: str,
    comment_id: int,
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    comment = await db.scalar(
        select(RecipeComment).where(RecipeComment.id == comment_id)
    )
    if not comment:
        raise HTTPException(404, "Comment not found")
    # Allow author or admin (user_id=1)
    if comment.user_id != user_id and user_id != 1:
        raise HTTPException(403, "Not authorised")
    await db.delete(comment)
    await db.commit()
