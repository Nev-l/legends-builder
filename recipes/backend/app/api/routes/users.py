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
from app.core.security import get_current_user_id, get_optional_user_id, get_current_admin
from app.models.models import User, Recipe, Rating, RecipeComment, AdminActivityLog

router = APIRouter(tags=["users"])


# ── Badge definitions ─────────────────────────────────────────────────────────

BADGE_DEFS = [
    # Cooking activity
    {"id": "first_recipe",    "name": "First Recipe",       "icon": "🍳", "desc": "Created your first recipe"},
    {"id": "recipe_5",        "name": "Home Cook",          "icon": "👨‍🍳", "desc": "Created 5 recipes"},
    {"id": "recipe_20",       "name": "Chef",               "icon": "🧑‍🍳", "desc": "Created 20 recipes"},
    {"id": "recipe_50",       "name": "Master Chef",        "icon": "⭐", "desc": "Created 50 recipes"},
    {"id": "recipe_100",      "name": "Chef de Cuisine",    "icon": "👨🏼‍🍳", "desc": "Created 100 recipes"},
    {"id": "first_fork",      "name": "Remixer",            "icon": "🍴", "desc": "Forked your first recipe"},
    {"id": "fork_5",          "name": "Recipe Hacker",      "icon": "🔧", "desc": "Forked 5 recipes"},
    {"id": "fork_10",         "name": "Forking Legend",     "icon": "🔱", "desc": "Forked 10 recipes"},
    # Voting
    {"id": "first_upvote",    "name": "Crowd Pleaser",      "icon": "👍", "desc": "Received your first upvote"},
    {"id": "upvotes_10",      "name": "Fan Favourite",      "icon": "🌟", "desc": "Received 10 upvotes across recipes"},
    {"id": "upvotes_50",      "name": "Community Star",     "icon": "💫", "desc": "Received 50 upvotes"},
    {"id": "upvotes_100",     "name": "Legend",             "icon": "🏆", "desc": "Received 100 upvotes"},
    {"id": "upvotes_250",     "name": "Michelin Star",      "icon": "🎖️", "desc": "Received 250 upvotes"},
    {"id": "voted_10",        "name": "Critic",             "icon": "🎭", "desc": "Voted on 10 recipes"},
    {"id": "voted_50",        "name": "Food Critic",        "icon": "📝", "desc": "Voted on 50 recipes"},
    {"id": "voted_100",       "name": "Professional Critic","icon": "⚖️", "desc": "Voted on 100 recipes"},
    # Social
    {"id": "first_comment",   "name": "Conversationalist",  "icon": "💬", "desc": "Left your first comment"},
    {"id": "comment_10",      "name": "Social Butterfly",   "icon": "🦋", "desc": "Left 10 comments"},
    {"id": "comment_50",      "name": "Community Pillar",   "icon": "🏛️", "desc": "Left 50 comments"},
    # Longevity
    {"id": "week_1",          "name": "Regular",            "icon": "📅", "desc": "Member for 1 week"},
    {"id": "month_1",         "name": "Loyal Member",       "icon": "🗓️", "desc": "Member for 1 month"},
    {"id": "month_6",         "name": "Veteran",            "icon": "🎖️", "desc": "Member for 6 months"},
    {"id": "year_1",          "name": "Old Timer",          "icon": "🏅", "desc": "Member for 1 year"},
    # Specialty
    {"id": "diet_variety",    "name": "Diet Explorer",      "icon": "🌈", "desc": "Created recipes covering 3+ diet types"},
    {"id": "diet_global",     "name": "Global Taster",      "icon": "🌍", "desc": "Created recipes covering 5+ diet types"},
    {"id": "healthy_habit",   "name": "Healthy Living",     "icon": "🥗", "desc": "Created 10+ Vegan/Vegetarian recipes"},
    {"id": "pantry_master",   "name": "Pantry Specialist",  "icon": "📦", "desc": "Added 20+ items to your pantry"},
    {"id": "meal_architect",  "name": "Meal Architect",     "icon": "🏗️", "desc": "Created 10+ meal plans"},
    {"id": "alchemist",       "name": "Ingredient Alchemist","icon": "🧪", "desc": "Created a recipe with 15+ ingredients"},
    {"id": "night_owl",       "name": "Night Owl",          "icon": "🦉", "desc": "Activity between 2 AM and 5 AM"},
    # Easter Eggs (Hidden triggers)
    {"id": "logo_fanatic",    "name": "Logo Fanatic",       "icon": "🌀", "desc": "Click the logo 7 times rapidly"},
    {"id": "inside_look",     "name": "The Inspector",      "icon": "👀", "desc": "Awarded for exploring the inner workings of the site"},
    {"id": "secret_vault",    "name": "Vault Explorer",     "icon": "🗝️", "desc": "Found the hidden secret vault"},
    {"id": "speed_demon",     "name": "Speed Demon",        "icon": "⚡", "desc": "Saved a recipe within 5 seconds of opening it"},
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

    # Manually granted badges
    if user.manual_badges:
        for b in user.manual_badges:
            if b not in earned:
                earned.append(b)

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
    if comment_count >= 50: earned.append("comment_50")

    # Time of day based (Owl)
    if joined.hour >= 2 and joined.hour < 5:
        earned.append("night_owl")

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


# ── Admin: search users ───────────────────────────────────────────────────────

@router.get("/users/search")
async def search_users(
    q: Optional[str] = None,
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    if user_id != 1:
        raise HTTPException(403, "Admin only")
    
    stmt = select(User.id, User.username, User.display_name).order_by(User.username.asc())
    if q:
        stmt = stmt.where(
            (User.username.ilike(f"%{q}%")) | (User.display_name.ilike(f"%{q}%"))
        )
    
    result = await db.execute(stmt.limit(50))
    return [
        {"id": r.id, "username": r.username, "display_name": r.display_name or r.username}
        for r in result.all()
    ]


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
        "bio": user.bio,
        "role": user.role,
        "manual_badges": user.manual_badges or [],
        "joined": user.created_at.date().isoformat() if user.created_at else None,
        "recipe_count": recipe_count,
        "total_upvotes": int(total_upvotes),
        "badges": badges,
        # Biometrics (New)
        "height_cm": user.height_cm,
        "weight_kg": user.weight_kg,
        "target_weight_kg": user.target_weight_kg,
        "biological_sex": user.biological_sex,
        "activity_level": user.activity_level,
        "bmi_history": user.bmi_history or [],
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
                "role": c.user.role,
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

    # Explicitly check user exists to avoid IntegrityError (which causes 500s)
    user = await db.scalar(select(User).where(User.id == user_id))
    if not user:
        raise HTTPException(401, "Account not found. Please log in again.")

    now = datetime.now(timezone.utc)
    comment = RecipeComment(
        recipe_id=recipe.id,
        user_id=user_id,
        body=body.body.strip()[:1000],
        created_at=now,
        updated_at=now,
    )
    db.add(comment)
    await db.flush()
    await db.refresh(comment)
    await db.commit()

    return {
        "id": comment.id,
        "body": comment.body,
        "created_at": comment.created_at.isoformat() if comment.created_at else now.isoformat(),
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
    
    if user_id == 1 and comment.user_id != 1:
        db.add(AdminActivityLog(
            admin_id=user_id,
            action_type="comment_delete",
            target_type="comment",
            target_id=str(comment.id),
            details={"body": comment.body, "author_id": comment.user_id}
        ))
    
    await db.delete(comment)
    await db.commit()


# ── Profile editing ───────────────────────────────────────────────────────────

class ProfileUpdate(BaseModel):
    display_name: Optional[str] = None
    avatar_url: Optional[str] = None
    bio: Optional[str] = None
    # Biometrics
    height_cm: Optional[float] = None
    weight_kg: Optional[float] = None
    target_weight_kg: Optional[float] = None
    biological_sex: Optional[str] = None
    activity_level: Optional[str] = None


@router.patch("/users/{username}")
async def update_profile(
    username: str,
    body: ProfileUpdate,
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    user = await db.scalar(select(User).where(User.username == username.lower()))
    if not user:
        raise HTTPException(404, "User not found")
    # Only the user themselves or admin (id=1) can edit
    if user.id != user_id and user_id != 1:
        raise HTTPException(403, "Not authorised")

    if body.display_name is not None:
        user.display_name = body.display_name.strip()[:120] or None
    if body.avatar_url is not None:
        user.avatar_url = body.avatar_url.strip()[:500] or None
    if body.bio is not None:
        user.bio = body.bio.strip()[:500] or None
        
    # Biometrics
    if body.height_cm is not None: user.height_cm = body.height_cm
    if body.weight_kg is not None: user.weight_kg = body.weight_kg
    if body.target_weight_kg is not None: user.target_weight_kg = body.target_weight_kg
    if body.biological_sex is not None: user.biological_sex = body.biological_sex
    if body.activity_level is not None: user.activity_level = body.activity_level

    await db.commit()
    return {"ok": True}




# ── Admin: manage manual badges ───────────────────────────────────────────────

class BadgeUpdate(BaseModel):
    badges: list[str]


@router.put("/users/{username}/badges")
async def set_manual_badges(
    username: str,
    body: BadgeUpdate,
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    if user_id != 1:
        raise HTTPException(403, "Admin only")
    user = await db.scalar(select(User).where(User.username == username.lower()))
    if not user:
        raise HTTPException(404, "User not found")

    # Only allow valid badge ids
    valid = {b["id"] for b in BADGE_DEFS}
    old_badges = list(user.manual_badges or [])
    new_badges = [b for b in body.badges if b in valid]
    
    # Force mutation tracking
    user.manual_badges = new_badges
    
    db.add(AdminActivityLog(
        admin_id=user_id,
        action_type="badge_update",
        target_type="user",
        target_id=user.username,
        details={"old": old_badges, "new": new_badges}
    ))
    
    await db.commit()
    return {"ok": True, "manual_badges": user.manual_badges}


# ── Easter Egg Badge Claiming ─────────────────────────────────────────────────

class ClaimBadgeIn(BaseModel):
    badge_id: str
    secret_key: str  # Prevention of accidental double-claiming and minor obfuscation


@router.post("/users/badges/claim-easter-egg")
async def claim_easter_egg(
    body: ClaimBadgeIn,
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    valid_easter_eggs = ["logo_fanatic", "inside_look", "secret_vault", "speed_demon"]
    if body.badge_id not in valid_easter_eggs:
        raise HTTPException(400, "Invalid easter egg badge")
    
    # Simple validation keys (obfuscated in frontend)
    keys = {
        "logo_fanatic": "clicks_7_logo",
        "inside_look": "inspect_element_open",
        "secret_vault": "found_the_hidden_vault",
        "speed_demon": "saved_recipe_fast",
    }
    
    if keys.get(body.badge_id) != body.secret_key:
        raise HTTPException(403, "Invalid secret key")

    user = await db.scalar(select(User).where(User.id == user_id))
    if not user:
        raise HTTPException(404, "User not found")

    if not user.manual_badges:
        user.manual_badges = []
    
    if body.badge_id not in user.manual_badges:
        user.manual_badges = list(user.manual_badges) + [body.badge_id]
        await db.commit()
        return {"ok": True, "badge": BADGE_MAP[body.badge_id]}
    
    return {"ok": False, "message": "Badge already earned"}
