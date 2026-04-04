"""
Weekly meal planner — CRUD + grocery list + calorie goals + recipe recommendations.
"""
from datetime import datetime, timezone
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func
from sqlalchemy.orm import selectinload
from pydantic import BaseModel
from typing import Optional

from app.core.database import get_db
from app.core.security import get_current_user_id
from app.models.models import MealPlan, MealPlanItem, Recipe, RecipeIngredient, User

router = APIRouter(prefix="/meal-planner", tags=["meal_planner"])


# ── Schemas ───────────────────────────────────────────────────────────────────

class MealPlanItemIn(BaseModel):
    recipe_slug: str
    day_of_week: int        # 0=Mon … 6=Sun
    slot: str               # breakfast | lunch | dinner | snack
    servings: int = 2
    is_leftover: bool = False
    is_batch: bool = False

class MealPlanCreate(BaseModel):
    week_start: str         # YYYY-MM-DD
    items: list[MealPlanItemIn] = []
    is_batch_week: bool = False
    notes: Optional[str] = None

class CalorieGoalUpdate(BaseModel):
    daily_calorie_goal: Optional[int] = None


# ── Helpers ───────────────────────────────────────────────────────────────────

def _item_out(item: MealPlanItem) -> dict:
    r = item.recipe
    return {
        "id": item.id,
        "day_of_week": item.day_of_week,
        "slot": item.slot,
        "servings": item.servings,
        "is_leftover": item.is_leftover,
        "recipe": {
            "slug": r.slug,
            "title": r.title,
            "image_url": r.image_url,
            "calories": r.calories,
            "servings": r.servings,
        },
    }

def _plan_out(plan: MealPlan) -> dict:
    return {
        "id": plan.id,
        "week_start": plan.week_start.date().isoformat() if plan.week_start else None,
        "is_batch_week": plan.is_batch_week,
        "notes": plan.notes,
        "daily_calorie_goal": plan.notes and None,  # stored separately below
        "items": [_item_out(i) for i in plan.items],
    }


# ── Routes ────────────────────────────────────────────────────────────────────

@router.get("")
async def list_plans(
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    rows = await db.execute(
        select(MealPlan).where(MealPlan.user_id == user_id)
        .options(
            selectinload(MealPlan.items).selectinload(MealPlanItem.recipe)
        )
        .order_by(MealPlan.week_start.desc()).limit(12)
    )
    plans = rows.scalars().all()
    out = []
    for p in plans:
        items = [_item_out(i) for i in p.items]
        out.append({
            "id": p.id,
            "week_start": p.week_start.date().isoformat() if p.week_start else None,
            "is_batch_week": p.is_batch_week,
            "items": items,
        })
    return out


@router.post("", status_code=201)
async def create_plan(
    body: MealPlanCreate,
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    # Parse week_start — accept YYYY-MM-DD string
    try:
        ws = datetime.fromisoformat(body.week_start).replace(tzinfo=timezone.utc)
    except ValueError:
        raise HTTPException(400, "week_start must be YYYY-MM-DD")

    # Avoid duplicate plans for the same week
    existing = await db.scalar(
        select(MealPlan).where(
            MealPlan.user_id == user_id,
            func.date_trunc("day", MealPlan.week_start) == func.date_trunc("day", ws),
        )
    )
    if existing:
        return {"id": existing.id}

    plan = MealPlan(
        user_id=user_id,
        week_start=ws,
        is_batch_week=body.is_batch_week,
        notes=body.notes,
    )
    db.add(plan)
    await db.flush()

    for item in body.items:
        recipe = await db.scalar(select(Recipe).where(Recipe.slug == item.recipe_slug))
        if not recipe:
            raise HTTPException(404, f"Recipe '{item.recipe_slug}' not found")
        db.add(MealPlanItem(
            plan_id=plan.id,
            recipe_id=recipe.id,
            day_of_week=item.day_of_week,
            slot=item.slot,
            servings=item.servings,
            is_leftover=item.is_leftover,
            is_batch=item.is_batch,
        ))

    await db.commit()
    return {"id": plan.id}


@router.post("/{plan_id}/items", status_code=201)
async def add_item(
    plan_id: int,
    body: MealPlanItemIn,
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    plan = await db.scalar(
        select(MealPlan).where(MealPlan.id == plan_id, MealPlan.user_id == user_id)
    )
    if not plan:
        raise HTTPException(404, "Plan not found")

    recipe = await db.scalar(select(Recipe).where(Recipe.slug == body.recipe_slug))
    if not recipe:
        raise HTTPException(404, f"Recipe '{body.recipe_slug}' not found")

    # Remove any existing item in that slot/day first (one recipe per slot)
    existing = await db.scalar(
        select(MealPlanItem).where(
            MealPlanItem.plan_id == plan_id,
            MealPlanItem.day_of_week == body.day_of_week,
            MealPlanItem.slot == body.slot,
        )
    )
    if existing:
        await db.delete(existing)

    item = MealPlanItem(
        plan_id=plan.id,
        recipe_id=recipe.id,
        day_of_week=body.day_of_week,
        slot=body.slot,
        servings=body.servings,
        is_leftover=body.is_leftover,
        is_batch=body.is_batch,
    )
    db.add(item)
    await db.commit()

    # Reload with recipe relationship
    item = await db.scalar(
        select(MealPlanItem)
        .where(MealPlanItem.plan_id == plan.id, MealPlanItem.day_of_week == body.day_of_week, MealPlanItem.slot == body.slot)
        .options(selectinload(MealPlanItem.recipe))
    )
    return _item_out(item)


@router.delete("/{plan_id}/items/{item_id}", status_code=204)
async def remove_item(
    plan_id: int,
    item_id: int,
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    plan = await db.scalar(
        select(MealPlan).where(MealPlan.id == plan_id, MealPlan.user_id == user_id)
    )
    if not plan:
        raise HTTPException(404, "Plan not found")
    item = await db.scalar(
        select(MealPlanItem).where(MealPlanItem.id == item_id, MealPlanItem.plan_id == plan_id)
    )
    if not item:
        raise HTTPException(404, "Item not found")
    await db.delete(item)
    await db.commit()


# Ingredients that are universal pantry staples — never add to grocery list
_SKIP_GROCERY = {
    # Water / liquids
    "water", "cold water", "hot water", "ice", "ice water",
    # Salt & pepper
    "salt", "sea salt", "kosher salt", "table salt", "rock salt", "flaky salt",
    "black pepper", "white pepper", "pepper", "cracked pepper", "ground pepper",
    "salt and pepper", "salt & pepper",
    # Basic spices & herbs almost everyone has
    "olive oil", "oil", "vegetable oil", "canola oil", "cooking oil", "cooking spray",
    "nonstick spray", "spray oil",
    "sugar", "white sugar", "granulated sugar",
    "flour", "plain flour", "all purpose flour", "all-purpose flour",
    "baking powder", "baking soda", "bicarbonate of soda", "bicarb soda",
    "vanilla", "vanilla extract", "vanilla essence",
    "cornstarch", "cornflour", "arrowroot",
    # Super-common spices
    "paprika", "cumin", "coriander", "turmeric", "cinnamon", "nutmeg",
    "oregano", "thyme", "basil", "rosemary", "bay leaf", "bay leaves",
    "chilli flakes", "red pepper flakes", "cayenne", "cayenne pepper",
    "mixed herbs", "dried herbs", "italian seasoning", "dried oregano",
    "dried thyme", "dried basil", "dried rosemary", "dried parsley",
    "parsley", "chives",
    "garlic powder", "onion powder", "smoked paprika",
    # Common condiments / pantry sauces
    "soy sauce", "fish sauce", "worcestershire sauce", "tabasco",
    "vinegar", "white vinegar", "red wine vinegar", "apple cider vinegar",
    "dijon mustard", "mustard",
    # Leavening / baking staples
    "yeast", "dry yeast", "instant yeast", "active dry yeast",
    "cocoa powder", "cocoa",
}

def _should_skip(name: str) -> bool:
    """Return True if this ingredient should be excluded from the grocery list."""
    n = name.lower().strip()
    # Exact match
    if n in _SKIP_GROCERY:
        return True
    # Partial match for things like "1 tsp salt", "pinch of pepper", "to taste"
    if any(skip in n for skip in ("to taste", "as needed", "as required", "pinch of",
                                   "pinch", "dash of", "dash", "spray")):
        return True
    return False


@router.get("/{plan_id}/grocery-list")
async def grocery_list(
    plan_id: int,
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    plan = await db.scalar(
        select(MealPlan).where(MealPlan.id == plan_id, MealPlan.user_id == user_id)
        .options(selectinload(MealPlan.items).selectinload(MealPlanItem.recipe)
                 .selectinload(Recipe.ingredients).selectinload(RecipeIngredient.ingredient))
    )
    if not plan:
        raise HTTPException(404, "Plan not found")

    totals: dict[str, dict] = {}
    for item in plan.items:
        if item.is_leftover:
            continue
        scale = item.servings / max(item.recipe.servings or 1, 1)
        for ri in item.recipe.ingredients:
            name = ri.ingredient.name
            if _should_skip(name):
                continue
            qty = (ri.quantity or 0) * scale
            if name not in totals:
                totals[name] = {"ingredient": name, "total_quantity": 0.0, "unit": ri.unit}
            totals[name]["total_quantity"] += qty

    return list(totals.values())


# Keywords that signal a recipe belongs to a particular slot
_BREAKFAST_KEYWORDS = {
    "breakfast", "pancake", "pancakes", "waffle", "waffles", "omelette", "omelet",
    "eggs benedict", "french toast", "granola", "oatmeal", "porridge", "muesli",
    "smoothie bowl", "breakfast bowl", "morning", "brunch", "scrambled eggs",
    "fried eggs", "poached eggs", "frittata", "quiche", "hash brown", "hashbrown",
    "bacon and eggs", "cereal", "overnight oats", "crepes", "crêpes",
}
_SNACK_KEYWORDS = {
    "snack", "dip", "chips", "crackers", "bites", "balls", "bliss balls",
    "protein bar", "energy bar", "muffin", "muffins", "cookie", "cookies",
    "brownie", "slice", "trail mix", "hummus", "guacamole", "salsa",
    "nachos", "popcorn", "nuts", "smoothie", "shake", "protein shake",
    "mini", "bite-sized", "finger food",
}
_LUNCH_KEYWORDS = {
    "salad", "sandwich", "wrap", "roll", "soup", "bowl", "sushi", "poke",
    "lunch", "frittata", "quiche", "flatbread", "bruschetta", "toast",
    "grain bowl", "noodle salad", "pasta salad",
}


def _slot_score(title: str, slot: str) -> bool:
    """Return True if recipe title suggests it fits the given slot."""
    t = title.lower()
    if slot == "breakfast":
        return any(k in t for k in _BREAKFAST_KEYWORDS)
    if slot == "snack":
        return any(k in t for k in _SNACK_KEYWORDS)
    if slot == "lunch":
        return any(k in t for k in _LUNCH_KEYWORDS)
    # dinner: anything that's NOT clearly a breakfast or snack
    return not any(k in t for k in _BREAKFAST_KEYWORDS | _SNACK_KEYWORDS)


@router.get("/recommend")
async def recommend_meals(
    calorie_target: int = Query(..., ge=100, le=10000),
    slot: str = Query("dinner"),
    diet_tags: Optional[str] = Query(None),  # comma-separated
    db: AsyncSession = Depends(get_db),
    user_id: int = Depends(get_current_user_id),
):
    """Return recipes appropriate for the given slot, near the calorie target."""
    q = select(Recipe).where(
        Recipe.calories != None,
        Recipe.is_published == True,
        Recipe.calories > 0,
    )
    if diet_tags:
        tags = [t.strip() for t in diet_tags.split(",") if t.strip()]
        for tag in tags:
            q = q.where(Recipe.diet_tags.contains([tag]))

    # Calorie range — snacks are lighter, mains are fuller
    if slot == "snack":
        low  = max(50,  calorie_target * 0.4)
        high = calorie_target * 0.8
    elif slot == "breakfast":
        low  = calorie_target * 0.5
        high = calorie_target * 1.1
    else:  # lunch / dinner
        low  = calorie_target * 0.7
        high = calorie_target * 1.4

    q = q.where(Recipe.calories >= low, Recipe.calories <= high)

    # Fetch a larger pool then filter + shuffle in Python for slot relevance
    q = q.order_by(func.random()).limit(60)
    rows = await db.execute(q)
    all_recipes = rows.scalars().all()

    # Prefer recipes whose title matches the slot; fall back to anything in range
    matched   = [r for r in all_recipes if _slot_score(r.title, slot)]
    unmatched = [r for r in all_recipes if not _slot_score(r.title, slot)]

    # If lunch, also accept dinner-style mains (no strong slot signal)
    if slot == "lunch" and len(matched) < 6:
        neutral = [r for r in unmatched if not any(k in r.title.lower() for k in _BREAKFAST_KEYWORDS | _SNACK_KEYWORDS)]
        matched = matched + neutral

    combined = (matched + unmatched)[:12]

    return [
        {
            "slug": r.slug,
            "title": r.title,
            "image_url": r.image_url,
            "calories": r.calories,
            "servings": r.servings,
            "diet_tags": r.diet_tags,
            "prep_minutes": r.prep_minutes,
            "cook_minutes": r.cook_minutes,
        }
        for r in combined
    ]
