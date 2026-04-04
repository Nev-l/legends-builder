"""Pantry management routes — manual entry + receipt OCR."""
import io
import re
from datetime import datetime, timezone
from typing import Optional
from fastapi import APIRouter, Depends, HTTPException, UploadFile, File
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


# ── Helpers ───────────────────────────────────────────────────────────────────

async def _upsert_pantry_item(
    user_id: int,
    ingredient_name: str,
    quantity: Optional[float],
    unit: Optional[str],
    expires_on_str: Optional[str],
    db: AsyncSession,
) -> PantryItemOut:
    name = ingredient_name.lower().strip()
    result = await db.execute(select(Ingredient).where(Ingredient.name == name))
    ingredient = result.scalar_one_or_none()
    if not ingredient:
        ingredient = Ingredient(name=name)
        db.add(ingredient)
        await db.flush()

    existing = await db.execute(
        select(PantryItem).where(
            PantryItem.user_id == user_id,
            PantryItem.ingredient_id == ingredient.id,
        )
    )
    item = existing.scalar_one_or_none()

    expires_dt = None
    if expires_on_str:
        expires_dt = datetime.fromisoformat(expires_on_str).replace(tzinfo=timezone.utc)

    if item:
        item.quantity = quantity
        item.unit = unit
        item.expires_on = expires_dt
    else:
        item = PantryItem(
            user_id=user_id,
            ingredient_id=ingredient.id,
            quantity=quantity,
            unit=unit,
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


# ── Routes ────────────────────────────────────────────────────────────────────

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
    return await _upsert_pantry_item(
        user_id, body.ingredient_name, body.quantity, body.unit, body.expires_on, db
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


# ── Receipt OCR ───────────────────────────────────────────────────────────────

# Common supermarket receipt noise to skip
_SKIP_WORDS = {
    "total", "subtotal", "gst", "tax", "change", "cash", "eftpos", "visa",
    "mastercard", "savings", "discount", "special", "member", "price",
    "thank", "you", "receipt", "balance", "due", "paid", "tender",
    "woolworths", "coles", "aldi", "iga", "spar", "harris", "farm",
    "date", "time", "ref", "trans", "item", "qty", "each", "unit",
}

# Unit patterns at the start of a word: 1.5kg, 500g, 2L, etc.
_QTY_UNIT_RE = re.compile(
    r"^(\d+\.?\d*)\s*(kg|g|ml|l|lb|oz|pk|pkt|pack|x|ea)?\s*(.+)?$",
    re.IGNORECASE,
)

# Price at end of line: $3.49 or 3.49
_PRICE_RE = re.compile(r"\$?\d+\.\d{2}\s*$")

# Lines that are clearly not ingredient names (purely numeric, very short, etc.)
_JUNK_RE = re.compile(r"^[\d\s\$\.\-\*]+$")


def _parse_receipt_text(text: str) -> list[dict]:
    """
    Heuristic parser: extract probable ingredient names + qty/unit from OCR text.
    Returns list of {name, quantity, unit}.
    """
    items = []
    seen: set[str] = set()

    for raw_line in text.splitlines():
        line = raw_line.strip()
        if not line or len(line) < 3:
            continue

        # Strip trailing price
        line = _PRICE_RE.sub("", line).strip()
        if not line:
            continue

        # Skip junk lines
        if _JUNK_RE.match(line):
            continue

        # Lowercase for keyword check
        lower = line.lower()
        if any(w in lower for w in _SKIP_WORDS):
            continue

        # Try to extract quantity + unit from the start of the line
        qty: Optional[float] = None
        unit: Optional[str] = None
        name = line

        m = _QTY_UNIT_RE.match(line)
        if m and m.group(3):
            qty_str, unit_str, rest = m.group(1), m.group(2), m.group(3)
            try:
                qty = float(qty_str)
                unit = unit_str.lower() if unit_str else None
                name = rest.strip()
            except ValueError:
                pass

        # Clean name: remove code-like prefixes (e.g. "1234 Chicken Breast")
        name = re.sub(r"^\d{3,}\s+", "", name).strip()
        name = re.sub(r"\s{2,}", " ", name)

        # Final length and skip checks
        if len(name) < 3 or len(name) > 80:
            continue
        lower_name = name.lower()
        if any(w in lower_name for w in _SKIP_WORDS):
            continue

        if lower_name in seen:
            continue
        seen.add(lower_name)

        items.append({"name": name, "quantity": qty, "unit": unit})

    return items


@router.post("/ocr-receipt", status_code=200)
async def ocr_receipt(
    file: UploadFile = File(...),
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    """
    Accept a receipt image (JPEG/PNG/WEBP), run Tesseract OCR,
    parse ingredient lines, and bulk-add them to the user's pantry.
    Returns the list of added items.
    """
    try:
        import pytesseract
        from PIL import Image, ImageFilter, ImageEnhance
    except ImportError:
        raise HTTPException(500, "OCR dependencies not installed on server")

    # Read + validate image
    data = await file.read()
    if len(data) > 20 * 1024 * 1024:
        raise HTTPException(413, "Image too large (max 20 MB)")

    try:
        img = Image.open(io.BytesIO(data)).convert("L")  # greyscale
    except Exception:
        raise HTTPException(400, "Could not read image file")

    # Pre-process for better OCR: sharpen + increase contrast
    img = ImageEnhance.Contrast(img).enhance(2.0)
    img = img.filter(ImageFilter.SHARPEN)

    # OCR
    try:
        text = pytesseract.image_to_string(img, config="--psm 6")
    except Exception as e:
        raise HTTPException(500, f"OCR failed: {e}")

    # Parse lines into items
    parsed = _parse_receipt_text(text)
    if not parsed:
        return {"added": [], "raw_text": text, "message": "No items detected. Try a clearer photo."}

    # Bulk upsert
    added = []
    for p in parsed:
        try:
            out = await _upsert_pantry_item(
                user_id, p["name"], p["quantity"], p["unit"], None, db
            )
            added.append(out)
        except Exception:
            continue  # skip items that fail (e.g. name too long)

    return {"added": added, "raw_text": text}
