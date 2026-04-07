"""
Recipe CRUD + scrape + fork + leftover-wizard.
"""
from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func, or_, text
from datetime import datetime, timezone
from sqlalchemy.orm import selectinload, joinedload
from pydantic import BaseModel, HttpUrl
from typing import Optional
import re, unicodedata

from app.core.database import get_db
from app.core.security import get_current_user_id, get_optional_user_id, get_current_admin
from app.models.models import Recipe, RecipeIngredient, RecipeStep, Ingredient, Rating, Favorite, AdminActivityLog
from app.services.scraper import scrape_recipe_url

router = APIRouter(prefix="/recipes", tags=["recipes"])


# ── Helpers ───────────────────────────────────────────────────────────────────

def slugify(text: str) -> str:
    text = unicodedata.normalize("NFKD", text).encode("ascii", "ignore").decode()
    text = re.sub(r"[^\w\s-]", "", text.lower())
    return re.sub(r"[-\s]+", "-", text).strip("-")


# ── Schemas ───────────────────────────────────────────────────────────────────

class IngredientIn(BaseModel):
    name: str
    quantity: Optional[float] = None
    unit: Optional[str] = None
    note: Optional[str] = None

class StepIn(BaseModel):
    body: str
    image_url: Optional[str] = None
    timer_mins: Optional[int] = None

class RecipeCreate(BaseModel):
    title: str
    description: Optional[str] = None
    prep_minutes: Optional[int] = None
    cook_minutes: Optional[int] = None
    servings: int = 4
    image_url: Optional[str] = None
    ingredients: list[IngredientIn] = []
    steps: list[StepIn] = []

class RecipeScrapeRequest(BaseModel):
    url: str

class RecipeUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    image_url: Optional[str] = None
    prep_minutes: Optional[int] = None
    cook_minutes: Optional[int] = None
    servings: Optional[int] = None
    diet_tags: Optional[list[str]] = None
    ingredients: Optional[list[IngredientIn]] = None
    steps: Optional[list[StepIn]] = None

class RecipeForkRequest(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    ingredients: Optional[list[IngredientIn]] = None
    steps: Optional[list[StepIn]] = None

class RecipeOut(BaseModel):
    id: int
    title: str
    slug: str
    description: Optional[str]
    source: str
    source_url: Optional[str]
    image_url: Optional[str]
    prep_minutes: Optional[int]
    cook_minutes: Optional[int]
    servings: int
    diet_tags: list[str]
    upvotes: int
    downvotes: int
    score: int
    author_id: Optional[int]
    calories: Optional[float] = None

    class Config:
        from_attributes = True


# ── Routes ────────────────────────────────────────────────────────────────────

@router.get("", response_model=list[RecipeOut])
async def list_recipes(
    q: Optional[str] = Query(None, description="Search title/description"),
    sort: str = Query("trending", enum=["trending", "newest", "top"]),
    diet: Optional[str] = Query(None),
    limit: int = Query(20, le=100),
    offset: int = Query(0),
    db: AsyncSession = Depends(get_db),
):
    stmt = select(Recipe).where(Recipe.is_published == True)

    if q:
        stmt = stmt.where(
            or_(Recipe.title.ilike(f"%{q}%"), Recipe.description.ilike(f"%{q}%"))
        )
    if diet:
        stmt = stmt.where(Recipe.diet_tags.contains([diet]))

    if sort == "trending":
        stmt = stmt.order_by(Recipe.score.desc(), Recipe.view_count.desc())
    elif sort == "newest":
        stmt = stmt.order_by(Recipe.created_at.desc())
    elif sort == "top":
        stmt = stmt.order_by(Recipe.upvotes.desc())

    result = await db.execute(stmt.limit(limit).offset(offset))
    return result.scalars().all()


@router.get("/{slug}", response_model=dict)
async def get_recipe(slug: str, db: AsyncSession = Depends(get_db)):
    from app.models.models import User
    stmt = (
        select(Recipe)
        .where(Recipe.slug == slug, Recipe.is_published == True)
        .options(
            selectinload(Recipe.ingredients).selectinload(RecipeIngredient.ingredient),
            selectinload(Recipe.steps),
            selectinload(Recipe.author),
        )
    )
    recipe = await db.scalar(stmt)
    if not recipe:
        raise HTTPException(status_code=404, detail="Recipe not found")

    # Increment view count (fire and forget — don't block on commit)
    recipe.view_count = (recipe.view_count or 0) + 1
    await db.commit()

    return {
        "id": recipe.id,
        "title": recipe.title,
        "slug": recipe.slug,
        "description": recipe.description,
        "source": recipe.source,
        "source_url": recipe.source_url,
        "image_url": recipe.image_url,
        "prep_minutes": recipe.prep_minutes,
        "cook_minutes": recipe.cook_minutes,
        "servings": recipe.servings,
        "diet_tags": recipe.diet_tags or [],
        "upvotes": recipe.upvotes,
        "downvotes": recipe.downvotes,
        "score": recipe.score,
        "calories": recipe.calories,
        "protein_g": recipe.protein_g,
        "carbs_g": recipe.carbs_g,
        "fat_g": recipe.fat_g,
        "author_id": recipe.author_id,
        "author_username": recipe.author.username if recipe.author else None,
        "author_display_name": recipe.author.display_name or recipe.author.username if recipe.author else None,
        "forked_from_id": recipe.forked_from_id,
        "ingredients": [
            {
                "name": ri.ingredient.name if ri.ingredient else "Unknown",
                "quantity": ri.quantity,
                "unit": ri.unit,
                "note": ri.note,
            }
            for ri in recipe.ingredients
        ],
        "steps": [
            {"position": s.position, "body": s.body, "image_url": s.image_url, "timer_mins": s.timer_mins}
            for s in recipe.steps
        ],
    }


@router.post("", response_model=RecipeOut, status_code=status.HTTP_201_CREATED)
async def create_recipe(
    body: RecipeCreate,
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    slug = slugify(body.title)
    # Ensure unique slug
    existing = await db.scalar(select(Recipe).where(Recipe.slug == slug))
    if existing:
        slug = f"{slug}-{user_id}"

    recipe = Recipe(
        title=body.title,
        slug=slug,
        description=body.description,
        prep_minutes=body.prep_minutes,
        cook_minutes=body.cook_minutes,
        servings=body.servings,
        image_url=body.image_url,
        source="ugc",
        author_id=user_id,
    )
    db.add(recipe)
    await db.flush()

    await _upsert_ingredients(recipe.id, body.ingredients, db)
    for i, step in enumerate(body.steps):
        db.add(RecipeStep(recipe_id=recipe.id, position=i + 1, **step.model_dump()))

    await db.commit()
    await db.refresh(recipe)
    return recipe


@router.post("/scrape", response_model=RecipeOut, status_code=status.HTTP_201_CREATED)
async def scrape_recipe(
    body: RecipeScrapeRequest,
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    """Scrape a public recipe URL and save it to the database."""
    data = await scrape_recipe_url(body.url)
    if not data:
        raise HTTPException(status_code=422, detail="Could not extract recipe from that URL")

    slug = slugify(data["title"])
    existing = await db.scalar(select(Recipe).where(Recipe.slug == slug))
    if existing:
        return existing

    recipe = Recipe(
        title=data["title"],
        slug=slug,
        description=data.get("description"),
        source="scraped",
        source_url=body.url,
        image_url=data.get("image"),
        prep_minutes=data.get("prep_minutes"),
        cook_minutes=data.get("cook_minutes"),
        servings=data.get("servings", 4),
        author_id=user_id,
    )
    db.add(recipe)
    await db.flush()

    await _upsert_ingredients(recipe.id, [IngredientIn(name=i) for i in data.get("ingredients", [])], db)
    for i, step_text in enumerate(data.get("steps", [])):
        db.add(RecipeStep(recipe_id=recipe.id, position=i + 1, body=step_text))

    await db.commit()
    await db.refresh(recipe)
    return recipe


@router.post("/{slug}/fork", response_model=RecipeOut, status_code=status.HTTP_201_CREATED)
async def fork_recipe(
    slug: str,
    body: RecipeForkRequest,
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    """Clone a recipe and apply the user's tweaks."""
    original = await db.scalar(
        select(Recipe).where(Recipe.slug == slug)
        .options(selectinload(Recipe.ingredients).selectinload(RecipeIngredient.ingredient),
                 selectinload(Recipe.steps))
    )
    if not original:
        raise HTTPException(status_code=404, detail="Recipe not found")

    new_title = body.title or f"{original.title} (my version)"
    new_slug  = f"{slugify(new_title)}-fork-{user_id}"

    fork = Recipe(
        title=new_title,
        slug=new_slug,
        description=body.description or original.description,
        source="forked",
        forked_from_id=original.id,
        image_url=original.image_url,
        prep_minutes=original.prep_minutes,
        cook_minutes=original.cook_minutes,
        servings=original.servings,
        author_id=user_id,
    )
    db.add(fork)
    await db.flush()

    ingrs = body.ingredients or [
        IngredientIn(name=ri.ingredient.name, quantity=ri.quantity, unit=ri.unit, note=ri.note)
        for ri in original.ingredients
    ]
    await _upsert_ingredients(fork.id, ingrs, db)

    steps = body.steps or [StepIn(body=s.body, timer_mins=s.timer_mins) for s in original.steps]
    for i, step in enumerate(steps):
        db.add(RecipeStep(recipe_id=fork.id, position=i + 1, **step.model_dump()))

    await db.commit()
    await db.refresh(fork)
    return fork


@router.put("/{slug}", response_model=dict)
async def update_recipe(
    slug: str,
    body: RecipeUpdate,
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    """Update a recipe. Admin (user_id=1) can edit any recipe; others only their own."""
    recipe = await db.scalar(
        select(Recipe).where(Recipe.slug == slug)
        .options(selectinload(Recipe.ingredients), selectinload(Recipe.steps))
    )
    if not recipe:
        raise HTTPException(status_code=404, detail="Recipe not found")
    if user_id != 1 and recipe.author_id != user_id:
        raise HTTPException(status_code=403, detail="Not authorised to edit this recipe")

    if body.title is not None:
        new_slug = slugify(body.title)
        if new_slug != recipe.slug:
            conflict = await db.scalar(select(Recipe).where(Recipe.slug == new_slug))
            if conflict:
                new_slug = f"{new_slug}-{recipe.id}"
        recipe.title = body.title
        recipe.slug  = new_slug
    if body.description  is not None: recipe.description  = body.description
    if body.image_url    is not None: recipe.image_url    = body.image_url
    if body.prep_minutes is not None: recipe.prep_minutes = body.prep_minutes
    if body.cook_minutes is not None: recipe.cook_minutes = body.cook_minutes
    if body.servings     is not None: recipe.servings     = body.servings
    if body.diet_tags    is not None: recipe.diet_tags    = body.diet_tags

    if body.ingredients is not None:
        for ri in recipe.ingredients:
            await db.delete(ri)
        await db.flush()
        await _upsert_ingredients(recipe.id, body.ingredients, db)

    if body.steps is not None:
        for s in recipe.steps:
            await db.delete(s)
        await db.flush()
        for i, step in enumerate(body.steps):
            db.add(RecipeStep(recipe_id=recipe.id, position=i + 1, **step.model_dump()))

    await db.commit()
    await db.refresh(recipe)

    # Return full detail so frontend can update without re-fetching
    stmt = (
        select(Recipe).where(Recipe.id == recipe.id)
        .options(
            selectinload(Recipe.ingredients).selectinload(RecipeIngredient.ingredient),
            selectinload(Recipe.steps),
        )
    )
    recipe = await db.scalar(stmt)
    return {
        "id": recipe.id, "title": recipe.title, "slug": recipe.slug,
        "description": recipe.description, "source": recipe.source,
        "source_url": recipe.source_url, "image_url": recipe.image_url,
        "prep_minutes": recipe.prep_minutes, "cook_minutes": recipe.cook_minutes,
        "servings": recipe.servings, "diet_tags": recipe.diet_tags or [],
        "upvotes": recipe.upvotes, "downvotes": recipe.downvotes, "score": recipe.score,
        "author_id": recipe.author_id,
        "ingredients": [{"id": ri.id, "name": ri.ingredient.name, "quantity": ri.quantity, "unit": ri.unit, "note": ri.note, "position": ri.position} for ri in recipe.ingredients],
        "steps": [{"id": s.id, "position": s.position, "body": s.body, "image_url": s.image_url, "timer_mins": s.timer_mins} for s in recipe.steps],
    }


@router.post("/{slug}/suggest-edit")
async def suggest_recipe_edit(
    slug: str,
    body: RecipeUpdate,
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    from app.models.models import RecipeEditProposal
    recipe = await db.scalar(select(Recipe).where(Recipe.slug == slug))
    if not recipe:
        raise HTTPException(status_code=404, detail="Recipe not found")
    if recipe.source != "scraped":
        raise HTTPException(status_code=400, detail="Only scraped recipes can receive public edit suggestions")

    proposal = RecipeEditProposal(
        recipe_id=recipe.id,
        user_id=user_id,
        proposed_changes=body.model_dump(exclude_unset=True),
        status="pending"
    )
    db.add(proposal)
    await db.commit()
    return {"message": "Edit suggestion submitted for review."}


@router.delete("/{slug}", status_code=204)
async def delete_recipe(
    slug: str,
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    """Delete a recipe. Admin (user_id=1) can delete any; others only their own."""
    recipe = await db.scalar(select(Recipe).where(Recipe.slug == slug))
    if not recipe:
        raise HTTPException(status_code=404, detail="Recipe not found")
    if user_id != 1 and recipe.author_id != user_id:
        raise HTTPException(status_code=403, detail="Not authorised")
    await db.delete(recipe)
    
    if user_id == 1: # Log if admin deleted
        db.add(AdminActivityLog(
            admin_id=user_id,
            action_type="recipe_delete",
            target_type="recipe",
            target_id=recipe.slug,
            details={"title": recipe.title}
        ))
    
    await db.commit()


@router.get("/leftover-wizard/search")
async def leftover_wizard(
    ingredients: str = Query(..., description="Comma-separated ingredient names"),
    limit: int = Query(10, le=50),
    db: AsyncSession = Depends(get_db),
):
    """Find recipes that use the given ingredients."""
    names = [n.strip().lower() for n in ingredients.split(",") if n.strip()]
    if not names:
        raise HTTPException(status_code=422, detail="Provide at least one ingredient")

    # Find ingredient IDs
    ing_rows = await db.execute(
        select(Ingredient.id).where(
            or_(*[Ingredient.name.ilike(f"%{n}%") for n in names])
        )
    )
    ing_ids = [r[0] for r in ing_rows.all()]
    if not ing_ids:
        return []

    # Recipes with most matching ingredients, ordered by match count then score
    stmt = (
        select(Recipe, func.count(RecipeIngredient.ingredient_id).label("match_count"))
        .join(RecipeIngredient, Recipe.id == RecipeIngredient.recipe_id)
        .where(RecipeIngredient.ingredient_id.in_(ing_ids), Recipe.is_published == True)
        .group_by(Recipe.id)
        .order_by(func.count(RecipeIngredient.ingredient_id).desc(), Recipe.score.desc())
        .limit(limit)
    )
    rows = await db.execute(stmt)
    return [
        {"recipe": RecipeOut.model_validate(row.Recipe), "matched_ingredients": row.match_count}
        for row in rows.all()
    ]


# ── Rating ────────────────────────────────────────────────────────────────────

class RatingRequest(BaseModel):
    value: int  # 1 or -1

@router.post("/{slug}/rate")
async def rate_recipe(
    slug: str,
    body: RatingRequest,
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    if body.value not in (1, -1):
        raise HTTPException(status_code=422, detail="value must be 1 or -1")

    recipe = await db.scalar(select(Recipe).where(Recipe.slug == slug))
    if not recipe:
        raise HTTPException(status_code=404, detail="Recipe not found")

    existing = await db.scalar(
        select(Rating).where(Rating.user_id == user_id, Rating.recipe_id == recipe.id)
    )
    if existing:
        old = existing.value
        existing.value = body.value
        recipe.upvotes   += (1 if body.value == 1 else 0) - (1 if old == 1 else 0)
        recipe.downvotes += (1 if body.value == -1 else 0) - (1 if old == -1 else 0)
    else:
        db.add(Rating(user_id=user_id, recipe_id=recipe.id, value=body.value))
        if body.value == 1:
            recipe.upvotes += 1
        else:
            recipe.downvotes += 1

    recipe.score = recipe.upvotes - recipe.downvotes
    return {"upvotes": recipe.upvotes, "downvotes": recipe.downvotes, "score": recipe.score}


# ── Edit Proposals (Admin) ────────────────────────────────────────────────────

@router.get("/edits/pending")
async def get_pending_edits(
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    if user_id != 1:
        raise HTTPException(status_code=403, detail="Admin only")
    from app.models.models import RecipeEditProposal, User
    stmt = (
        select(RecipeEditProposal)
        .where(RecipeEditProposal.status == "pending")
        .options(
            joinedload(RecipeEditProposal.user),
            joinedload(RecipeEditProposal.recipe).selectinload(Recipe.ingredients).joinedload(RecipeIngredient.ingredient),
            joinedload(RecipeEditProposal.recipe).selectinload(Recipe.steps)
        )
        .order_by(RecipeEditProposal.created_at.desc())
    )
    rows = await db.execute(stmt)
    results = []
    
    for prop in rows.scalars().all():
        rec = prop.recipe
        usr = prop.user
        
        # Current state for diffing
        current_data = {
            "title": rec.title,
            "description": rec.description,
            "image_url": rec.image_url,
            "prep_minutes": rec.prep_minutes,
            "cook_minutes": rec.cook_minutes,
            "servings": rec.servings,
            "diet_tags": rec.diet_tags,
            "ingredients": [{"name": i.ingredient.name if i.ingredient else "Unknown", "quantity": i.quantity, "unit": i.unit, "note": i.note} for i in rec.ingredients],
            "steps": [{"body": s.body, "timer_mins": s.timer_mins, "image_url": s.image_url} for s in rec.steps],
        }
        
        results.append({
            "id": prop.id,
            "recipe_id": rec.id,
            "recipe_title": rec.title,
            "recipe_slug": rec.slug,
            "user_id": usr.id,
            "username": usr.username,
            "proposed_changes": prop.proposed_changes,
            "current_state": current_data,
            "created_at": prop.created_at.isoformat() if prop.created_at else None,
        })
    return results

@router.post("/edits/{edit_id}/approve")
async def approve_recipe_edit(
    edit_id: int,
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    if user_id != 1:
        raise HTTPException(status_code=403, detail="Admin only")
    from app.models.models import RecipeEditProposal
    prop = await db.scalar(
        select(RecipeEditProposal)
        .where(RecipeEditProposal.id == edit_id)
        .options(
            joinedload(RecipeEditProposal.recipe).selectinload(Recipe.ingredients).selectinload(RecipeIngredient.ingredient),
            joinedload(RecipeEditProposal.recipe).selectinload(Recipe.steps)
        )
    )
    if not prop or prop.status != "pending":
        raise HTTPException(status_code=404, detail="Pending proposal not found")

    recipe = prop.recipe
    if not recipe:
        raise HTTPException(status_code=404, detail="Recipe not found")

    changes = prop.proposed_changes
    # Apply changes (same logic as update_recipe)
    if "title" in changes:
        new_title = changes["title"]
        new_slug = slugify(new_title)
        if new_slug != recipe.slug:
            conflict = await db.scalar(select(Recipe).where(Recipe.slug == new_slug))
            if conflict:
                new_slug = f"{new_slug}-{recipe.id}"
        recipe.title = new_title
        recipe.slug = new_slug
    
    if "description" in changes: recipe.description = changes["description"]
    if "image_url" in changes: recipe.image_url = changes["image_url"]
    if "prep_minutes" in changes: recipe.prep_minutes = changes["prep_minutes"]
    if "cook_minutes" in changes: recipe.cook_minutes = changes["cook_minutes"]
    if "servings" in changes: recipe.servings = changes["servings"]
    if "diet_tags" in changes: recipe.diet_tags = changes["diet_tags"]

    if "ingredients" in changes:
        # Delete old ingredients
        for ri in recipe.ingredients:
            await db.delete(ri)
        await db.flush()
        # Insert new ingredients
        await _upsert_ingredients(recipe.id, [IngredientIn(**i) for i in changes["ingredients"]], db)

    if "steps" in changes:
        # Delete old steps
        for s in recipe.steps:
            await db.delete(s)
        await db.flush()
        # Insert new steps
        from app.models.models import RecipeStep
        for i, step in enumerate(changes["steps"]):
            # Filter only valid keys for RecipeStep
            valid_keys = {"body", "timer_mins", "image_url"}
            sdata = {k: v for k, v in step.items() if k in valid_keys}
            db.add(RecipeStep(recipe_id=recipe.id, position=i + 1, **sdata))

    # Finalize state
    prop.status = "approved"
    prop.updated_at = datetime.now(timezone.utc)
    
    # Optional Activity Log (don't crash on this)
    try:
        db.add(AdminActivityLog(
            admin_id=user_id,
            action_type="edit_approve",
            target_type="recipe",
            target_id=recipe.slug,
            details={"proposal_id": prop.id, "editor_id": prop.user_id}
        ))
    except Exception as e:
        print(f"Activity logging failed: {e}")
    
    try:
        await db.commit()
    except Exception as e:
        await db.rollback()
        raise HTTPException(status_code=500, detail=str(e))

    return {"message": "Edit approved successfully", "slug": recipe.slug}

@router.post("/edits/{edit_id}/reject")
async def reject_recipe_edit(
    edit_id: int,
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    if user_id != 1:
        raise HTTPException(status_code=403, detail="Admin only")
    from app.models.models import RecipeEditProposal
    prop = await db.scalar(select(RecipeEditProposal).where(RecipeEditProposal.id == edit_id))
    if not prop or prop.status != "pending":
        raise HTTPException(status_code=404, detail="Pending proposal not found")
    
    prop.status = "rejected"
    prop.updated_at = datetime.now(timezone.utc)
    
    try:
        db.add(AdminActivityLog(
            admin_id=user_id,
            action_type="edit_reject",
            target_type="recipe",
            target_id=str(prop.recipe_id),
            details={"proposal_id": prop.id, "editor_id": prop.user_id}
        ))
    except Exception as e:
        print(f"Activity logging failed: {e}")
    
    try:
        await db.commit()
    except Exception as e:
        await db.rollback()
        raise HTTPException(status_code=500, detail=str(e))

    return {"message": "Edit rejected successfully"}


class RecipeReassignRequest(BaseModel):
    new_author_id: int

@router.post("/{slug}/reassign-author")
async def reassign_recipe_author(
    slug: str,
    body: RecipeReassignRequest,
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    if user_id != 1:
        raise HTTPException(status_code=403, detail="Admin only")
    
    recipe = await db.scalar(select(Recipe).where(Recipe.slug == slug))
    if not recipe:
        raise HTTPException(status_code=404, detail="Recipe not found")
    
    # Update author
    recipe.author_id = body.new_author_id
    
    # If it was a scraped recipe, it's now user-maintained
    if recipe.source == "scraped":
        recipe.source = "ugc"
    
    db.add(AdminActivityLog(
        admin_id=user_id,
        action_type="reassign_author",
        target_type="recipe",
        target_id=recipe.slug,
        details={"new_author_id": body.new_author_id}
    ))
    
    await db.commit()
    return {"message": "Authorship reassigned successfully", "new_author_id": body.new_author_id}


# ── Internal helpers ──────────────────────────────────────────────────────────

async def _upsert_ingredients(recipe_id: int, items: list[IngredientIn], db: AsyncSession):
    for pos, item in enumerate(items):
        name = item.name.strip().lower()
        ing = await db.scalar(select(Ingredient).where(Ingredient.name == name))
        if not ing:
            ing = Ingredient(name=name, canonical=name)
            db.add(ing)
            await db.flush()
        db.add(RecipeIngredient(
            recipe_id=recipe_id,
            ingredient_id=ing.id,
            quantity=item.quantity,
            unit=item.unit,
            note=item.note,
            position=pos,
        ))
