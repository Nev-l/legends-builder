"""Pantry management routes."""
from datetime import datetime, timezone
from typing import Optional
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from sqlalchemy import select, delete
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.core.database import get_db
from app.core.security import get_current_user_id
from app.models.models import Ingredient, PantryItem

router = APIRouter(prefix="/pantry", tags=["pantry"])


class PantryItemIn(BaseModel):
    ingredient_name: str
    quantity: Optional[float] = None
    unit: Optional[str] = None
    expires_on: Optional[str] = None  # ISO date string YYYY-MM-DD


class PantryItemOut(BaseModel):
    id: int
    ingredient_name: str
    quantity: Optional[float]
    unit: Optional[str]
    expires_on: Optional[str]

    model_config = {"from_attributes": True}


@router.get("", response_model=list[PantryItemOut])
async def list_pantry(
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(PantryItem)
        .where(PantryItem.user_id == user_id)
        .options(selectinload(PantryItem.ingredient))
        .order_by(PantryItem.ingredient_id)
    )
    items = result.scalars().all()
    return [
        PantryItemOut(
            id=item.id,
            ingredient_name=item.ingredient.name,
            quantity=item.quantity,
            unit=item.unit,
            expires_on=item.expires_on.date().isoformat() if item.expires_on else None,
        )
        for item in items
    ]


@router.post("", response_model=PantryItemOut, status_code=201)
async def add_pantry_item(
    body: PantryItemIn,
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    # Upsert ingredient
    result = await db.execute(
        select(Ingredient).where(Ingredient.name == body.ingredient_name.lower().strip())
    )
    ingredient = result.scalar_one_or_none()
    if not ingredient:
        ingredient = Ingredient(name=body.ingredient_name.lower().strip())
        db.add(ingredient)
        await db.flush()

    # Check if pantry item already exists for this user+ingredient
    existing = await db.execute(
        select(PantryItem).where(
            PantryItem.user_id == user_id,
            PantryItem.ingredient_id == ingredient.id,
        )
    )
    item = existing.scalar_one_or_none()

    expires_dt = None
    if body.expires_on:
        expires_dt = datetime.fromisoformat(body.expires_on).replace(tzinfo=timezone.utc)

    if item:
        item.quantity = body.quantity
        item.unit = body.unit
        item.expires_on = expires_dt
    else:
        item = PantryItem(
            user_id=user_id,
            ingredient_id=ingredient.id,
            quantity=body.quantity,
            unit=body.unit,
            expires_on=expires_dt,
        )
        db.add(item)

    await db.commit()
    await db.refresh(item)

    return PantryItemOut(
        id=item.id,
        ingredient_name=ingredient.name,
        quantity=item.quantity,
        unit=item.unit,
        expires_on=item.expires_on.date().isoformat() if item.expires_on else None,
    )


@router.delete("/{item_id}", status_code=204)
async def remove_pantry_item(
    item_id: int,
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(PantryItem).where(PantryItem.id == item_id, PantryItem.user_id == user_id)
    )
    item = result.scalar_one_or_none()
    if not item:
        raise HTTPException(status_code=404, detail="Item not found")
    await db.delete(item)
    await db.commit()
