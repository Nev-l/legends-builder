"""
Weekly meal planner — CRUD + grocery list generation.
"""
from datetime import datetime, timezone
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from sqlalchemy.orm import selectinload
from pydantic import BaseModel
from typing import Optional

from app.core.database import get_db
from app.core.security import get_current_user_id
from app.models.models import MealPlan, MealPlanItem, Recipe, RecipeIngredient, MealSlot

router = APIRouter(prefix="/meal-planner", tags=["meal_planner"])


class MealPlanItemIn(BaseModel):
    recipe_slug: str
    day_of_week: int        # 0=Mon … 6=Sun
    slot: MealSlot
    servings: int = 4
    is_leftover: bool = False
    is_batch: bool = False

class MealPlanCreate(BaseModel):
    week_start: datetime    # ISO8601 — should be the Monday of the target week
    items: list[MealPlanItemIn] = []
    is_batch_week: bool = False
    notes: Optional[str] = None


@router.get("")
async def list_plans(
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    rows = await db.execute(
        select(MealPlan).where(MealPlan.user_id == user_id)
        .order_by(MealPlan.week_start.desc()).limit(12)
    )
    plans = rows.scalars().all()
    return [{"id": p.id, "week_start": p.week_start, "is_batch_week": p.is_batch_week} for p in plans]


@router.post("", status_code=201)
async def create_plan(
    body: MealPlanCreate,
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    plan = MealPlan(
        user_id=user_id,
        week_start=body.week_start,
        is_batch_week=body.is_batch_week,
        notes=body.notes,
    )
    db.add(plan)
    await db.flush()

    for item in body.items:
        recipe = await db.scalar(select(Recipe).where(Recipe.slug == item.recipe_slug))
        if not recipe:
            raise HTTPException(status_code=404, detail=f"Recipe '{item.recipe_slug}' not found")
        db.add(MealPlanItem(
            plan_id=plan.id,
            recipe_id=recipe.id,
            day_of_week=item.day_of_week,
            slot=item.slot,
            servings=item.servings,
            is_leftover=item.is_leftover,
            is_batch=item.is_batch,
        ))

    return {"id": plan.id}


@router.get("/{plan_id}")
async def get_plan(
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
        raise HTTPException(status_code=404, detail="Plan not found")

    days = {i: {"breakfast": None, "lunch": None, "dinner": None, "snack": None} for i in range(7)}
    for item in plan.items:
        days[item.day_of_week][item.slot.value] = {
            "recipe_id": item.recipe_id,
            "recipe_title": item.recipe.title,
            "recipe_slug": item.recipe.slug,
            "servings": item.servings,
            "is_leftover": item.is_leftover,
            "is_batch": item.is_batch,
        }

    return {
        "id": plan.id,
        "week_start": plan.week_start,
        "is_batch_week": plan.is_batch_week,
        "notes": plan.notes,
        "days": days,
    }


@router.get("/{plan_id}/grocery-list")
async def grocery_list(
    plan_id: int,
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    """
    Consolidate all ingredients from a meal plan into a single grocery list,
    scaled to each meal item's servings vs the recipe's default servings.
    """
    plan = await db.scalar(
        select(MealPlan).where(MealPlan.id == plan_id, MealPlan.user_id == user_id)
        .options(selectinload(MealPlan.items).selectinload(MealPlanItem.recipe)
                 .selectinload(Recipe.ingredients).selectinload(RecipeIngredient.ingredient))
    )
    if not plan:
        raise HTTPException(status_code=404, detail="Plan not found")

    # Aggregate by ingredient name, scaling quantities
    totals: dict[str, dict] = {}
    for item in plan.items:
        if item.is_leftover:
            continue  # leftovers don't need fresh shopping
        scale = item.servings / max(item.recipe.servings, 1)
        for ri in item.recipe.ingredients:
            name = ri.ingredient.name
            qty  = (ri.quantity or 0) * scale
            if name not in totals:
                totals[name] = {"name": name, "quantity": 0, "unit": ri.unit, "ingredient_id": ri.ingredient_id}
            totals[name]["quantity"] += qty

    return {"plan_id": plan_id, "items": list(totals.values())}
