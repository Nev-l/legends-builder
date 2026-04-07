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


class SmartUpdateIn(BaseModel):
    day_of_week: int        # 0=Mon … 6=Sun
    slot: str               # breakfast|lunch|dinner|snack
    keyword: str            # e.g. "steak", "salmon", "vegan pasta"

@router.post("/{plan_id}/smart-update")
async def smart_update_slot(
    plan_id: int,
    body: SmartUpdateIn,
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    """Replace a single slot with the best matching recipe for a keyword."""
    plan = await db.scalar(
        select(MealPlan).where(MealPlan.id == plan_id, MealPlan.user_id == user_id)
        .options(selectinload(MealPlan.items))
    )
    if not plan:
        raise HTTPException(404, "Plan not found")

    # Search for a recipe matching the keyword
    keyword = f"%{body.keyword.lower()}%"
    result = await db.execute(
        select(Recipe)
        .where(Recipe.is_published == True, func.lower(Recipe.title).like(keyword))
        .order_by(func.random())
        .limit(1)
    )
    recipe = result.scalar_one_or_none()

    # Fallback: search by ingredient keyword
    if not recipe:
        from app.models.models import Ingredient, RecipeIngredient
        result = await db.execute(
            select(Recipe)
            .join(RecipeIngredient, RecipeIngredient.recipe_id == Recipe.id)
            .join(Ingredient, Ingredient.id == RecipeIngredient.ingredient_id)
            .where(Recipe.is_published == True, func.lower(Ingredient.name).like(keyword))
            .order_by(func.random())
            .limit(1)
        )
        recipe = result.scalar_one_or_none()

    if not recipe:
        raise HTTPException(404, f"No recipe found matching '{body.keyword}'")

    # Remove existing item in that slot/day
    for item in plan.items:
        if item.day_of_week == body.day_of_week and item.slot == body.slot:
            await db.delete(item)

    # Add new item
    db.add(MealPlanItem(
        plan_id=plan_id,
        recipe_id=recipe.id,
        day_of_week=body.day_of_week,
        slot=body.slot,
        servings=1,
    ))
    await db.commit()
    return {"ok": True, "recipe": {"slug": recipe.slug, "title": recipe.title}}


@router.delete("/{plan_id}/items", status_code=204)
async def clear_plan_items(
    plan_id: int,
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    """Remove all items from a plan (for Raul replace/revise)."""
    plan = await db.scalar(
        select(MealPlan).where(MealPlan.id == plan_id, MealPlan.user_id == user_id)
        .options(selectinload(MealPlan.items))
    )
    if not plan:
        raise HTTPException(404, "Plan not found")
    for item in plan.items:
        await db.delete(item)
    await db.commit()


import re as _re

# ── Grocery list helpers ──────────────────────────────────────────────────────

# Strip leading quantity + unit from raw ingredient strings like:
#   "2 tbsp olive oil ($0.32)"  →  "olive oil"
#   "1 15oz. can kidney beans ($1.09)"  →  "kidney beans"
#   "1/4 tsp cayenne powder ($0.02)"  →  "cayenne powder"
_QTY_STRIP = _re.compile(
    r"^[\d/ ]+\.?\d*\s*"                          # leading number (1, 1/4, 1.5 …)
    r"(tbsp|tsp|cup|cups|oz|lb|lbs|g|kg|ml|l|"
    r"clove|cloves|can|cans|bunch|head|slice|"
    r"slices|piece|pieces|stalk|stalks|sprig|"
    r"sprigs|pinch|dash|handful|pkg|package|"
    r"packet|pkt|strip|strips|large|medium|"
    r"small|extra large|xl)s?\.?\s*",
    _re.IGNORECASE,
)
_PRICE_STRIP  = _re.compile(r"\(\$[\d\.]+\)")          # ($0.32)
_PAREN_STRIP  = _re.compile(r"\([^)]*\)")              # any (…)
_MULTI_SPACE  = _re.compile(r"\s{2,}")
# Drop leading digits/fractions left after unit strip (e.g. "15" from "1 15oz. can")
_LEADING_NUM  = _re.compile(r"^\d+\.?\d*\s+")

# Words that when they appear in a cleaned name mean it's a spice/staple
_SKIP_WORDS = {
    "salt","pepper","water","oil","sugar","flour","powder","spice","spices",
    "seasoning","sauce","extract","vanilla","vinegar","baking","cumin",
    "paprika","turmeric","oregano","thyme","basil","coriander","cayenne",
    "cinnamon","nutmeg","rosemary","bay","chilli","chili","flakes","mustard",
    "cornstarch","cornflour","spray","soda","yeast","cocoa","lard","shortening",
    "broth","stock","bouillon","msg","gelatin","agar",
}

# Categories for the UI grouping
_MEAT_WORDS    = {"beef","chicken","pork","lamb","turkey","fish","salmon","tuna",
                  "shrimp","prawn","bacon","ham","sausage","mince","ground beef",
                  "steak","duck","venison","bison","veal","liver","pepperoni",
                  "chorizo","salami","anchovy","cod","tilapia","crab","lobster",
                  "scallop","clam","mussel","oyster","seafood","meat","meatball",
                  "schnitzel","rissole","brisket","ribs","roast","cutlet","fillet"}
_PRODUCE_WORDS = {"onion","garlic","tomato","pepper","capsicum","carrot","celery",
                  "broccoli","spinach","lettuce","zucchini","eggplant","cucumber",
                  "mushroom","cauliflower","kale","cabbage","corn","potato",
                  "sweet potato","leek","shallot","lemon","lime","orange",
                  "apple","banana","avocado","berry","berries","mango","pineapple",
                  "spring onion","scallion","beetroot","beet","asparagus","artichoke",
                  "fennel","butternut","squash","pumpkin","radish","turnip","bok choy",
                  "bean sprouts","snap peas","snow peas","green beans","silverbeet",
                  "rocket","watercress","chilli","jalapeno","capsicum","coriander leaf",
                  "basil leaf","mint","parsley leaf","thyme sprig","rosemary sprig"}
_DAIRY_WORDS   = {"milk","cream","butter","cheese","yogurt","yoghurt","sour cream",
                  "creme fraiche","ricotta","mozzarella","parmesan","cheddar",
                  "feta","brie","gouda","havarti","cream cheese","ghee","whey",
                  "heavy cream","ice cream","custard","kefir","egg","eggs",
                  "condensed milk","evaporated milk","buttermilk","tasty cheese"}
_HERBS_WORDS   = {"basil","oregano","thyme","rosemary","parsley","coriander","cilantro",
                  "mint","dill","chives","sage","tarragon","bay leaf","bay leaves",
                  "lemongrass","kaffir lime","curry leaf","dried herb","mixed herbs",
                  "italian seasoning","herbs de provence","bouquet garni"}
_PANTRY_WORDS  = {"pasta","rice","noodle","noodles","bread","flour","sugar",
                  "canned","can","tin","tinned","beans","lentils","chickpeas",
                  "kidney beans","black beans","coconut milk","tomato paste",
                  "diced tomatoes","crushed tomatoes","stock","broth","honey",
                  "maple syrup","jam","peanut butter","almond butter","oats",
                  "quinoa","barley","couscous","cracker","crackers","cereal",
                  "granola","nuts","almonds","walnuts","cashews","seeds",
                  "sunflower seeds","pumpkin seeds","chia","flaxseed","soy sauce",
                  "fish sauce","oyster sauce","hoisin","teriyaki","hot sauce",
                  "ketchup","worcestershire","tahini","miso","curry paste",
                  "coconut cream","vine leaves","breadcrumbs","panko","tofu",
                  "tempeh","tortilla","wrap","pita","naan","sourdough"}


_US_UNIT_CONVERSIONS = {
    # volume
    "fl oz": "ml", "fluid oz": "ml", "fluid ounce": "ml", "fluid ounces": "ml",
    "oz": "g",     "ounce": "g",     "ounces": "g",
    "lb": "g",     "lbs": "g",       "pound": "g",  "pounds": "g",
    "cup": "ml",   "cups": "ml",
    "pint": "ml",  "pints": "ml",
    "quart": "L",  "quarts": "L",
    "gallon": "L", "gallons": "L",
    "stick": "g",  # butter sticks
    "sticks": "g",
}

_US_QTY_RE = _re.compile(
    r"^([\d/ \.]+)\s*(fl oz|fluid oz(?:ce)?s?|ounces?|oz|pounds?|lbs?|cups?|pints?|quarts?|gallons?|sticks?)\b",
    _re.IGNORECASE,
)

_US_CONVERSIONS_FACTOR = {
    "fl oz": 29.57, "fluid oz": 29.57, "fluid ounce": 29.57, "fluid ounces": 29.57,
    "oz": 28.35, "ounce": 28.35, "ounces": 28.35,
    "lb": 453.6, "lbs": 453.6, "pound": 453.6, "pounds": 453.6,
    "cup": 250.0, "cups": 250.0,
    "pint": 473.0, "pints": 473.0,
    "quart": 0.946, "quarts": 0.946,
    "gallon": 3.785, "gallons": 3.785,
    "stick": 113.0, "sticks": 113.0,
}

def _convert_us_units(s: str) -> str:
    """Convert US measurements to metric in ingredient strings."""
    m = _US_QTY_RE.match(s.strip())
    if not m:
        return s
    qty_str, unit = m.group(1).strip(), m.group(2).strip().lower()
    rest = s[m.end():].strip()
    try:
        # Handle fractions like 1/2, 1 1/2
        parts = qty_str.split()
        qty = 0.0
        for p in parts:
            if "/" in p:
                n, d = p.split("/")
                qty += float(n) / float(d)
            else:
                qty += float(p)
    except (ValueError, ZeroDivisionError):
        return s

    factor = _US_CONVERSIONS_FACTOR.get(unit, 1.0)
    metric_val = qty * factor
    metric_unit = _US_UNIT_CONVERSIONS.get(unit, "g")

    # Round nicely
    if metric_val >= 100:
        metric_val = round(metric_val / 5) * 5
    elif metric_val >= 10:
        metric_val = round(metric_val)
    else:
        metric_val = round(metric_val, 1)

    # Choose better unit for large volumes
    if metric_unit == "ml" and metric_val >= 1000:
        metric_val = round(metric_val / 1000, 2)
        metric_unit = "L"
    elif metric_unit == "g" and metric_val >= 1000:
        metric_val = round(metric_val / 1000, 2)
        metric_unit = "kg"

    return f"{metric_val}{metric_unit} {rest}".strip()


def _clean_ingredient_name(raw: str) -> str:
    """Strip quantity, unit, price, and parentheticals from a raw ingredient string."""
    s = raw.strip()
    s = _convert_us_units(s)      # convert US → metric first
    s = _PRICE_STRIP.sub("", s)   # remove ($x.xx)
    s = _PAREN_STRIP.sub("", s)   # remove (anything)
    s = _QTY_STRIP.sub("", s)     # remove leading qty+unit
    s = _LEADING_NUM.sub("", s)   # remove any leftover leading number
    # Strip common descriptor prefixes
    for prefix in ("ground ", "dried ", "fresh ", "frozen ", "chopped ", "minced ",
                   "sliced ", "diced ", "grated ", "shredded ", "whole ", "raw ",
                   "cooked ", "canned ", "tinned ", "large ", "medium ", "small ",
                   "extra ", "boneless ", "skinless ", "lean "):
        if s.lower().startswith(prefix):
            s = s[len(prefix):]
    s = _MULTI_SPACE.sub(" ", s).strip(" ,.")
    # Title-case for display
    return s


def _categorise(name: str) -> str:
    n = name.lower()
    if any(w in n for w in _MEAT_WORDS):    return "Meat & Seafood"
    if any(w in n for w in _PRODUCE_WORDS): return "Produce"
    if any(w in n for w in _DAIRY_WORDS):   return "Dairy"
    if any(w in n for w in _HERBS_WORDS):   return "Herbs & Spices"
    return "Pantry & Other"


def _should_skip_grocery(cleaned: str) -> bool:
    """Skip if clearly a spice, staple, or too short after cleaning."""
    if len(cleaned) < 2:
        return True
    n = cleaned.lower()
    if any(skip in n for skip in ("to taste", "as needed", "pinch", "dash", "spray")):
        return True
    words = set(_re.split(r"\W+", n))
    return bool(words & _SKIP_WORDS)


_UNIT_TO_ML = {
    "ml": 1, "l": 1000, "L": 1000,
    "tsp": 5, "tbsp": 15,
    "cup": 250, "cups": 250,
    "fl oz": 29.57, "fluid oz": 29.57,
    "pint": 473, "pints": 473,
    "quart": 946, "quarts": 946,
    "gallon": 3785, "gallons": 3785,
}
_UNIT_TO_G = {
    "g": 1, "kg": 1000,
    "oz": 28.35, "ounce": 28.35, "ounces": 28.35,
    "lb": 453.6, "lbs": 453.6, "pound": 453.6, "pounds": 453.6,
    "stick": 113, "sticks": 113,
}

def _normalise_unit(unit: str | None) -> tuple[str, float]:
    """Return (canonical_unit, multiplier_to_base). Base = ml for volume, g for weight."""
    if not unit:
        return ("", 1.0)
    u = unit.strip().lower()
    if u in _UNIT_TO_ML:
        return ("ml", _UNIT_TO_ML[u])
    if u in _UNIT_TO_G:
        return ("g", _UNIT_TO_G[u])
    return (unit, 1.0)

def _format_qty(total: float, base_unit: str) -> tuple[float, str]:
    """Convert base (ml or g) totals to nice display units."""
    if base_unit == "ml":
        if total >= 1000:
            return (round(total / 1000, 2), "L")
        return (round(total), "ml")
    if base_unit == "g":
        if total >= 1000:
            return (round(total / 1000, 2), "kg")
        return (round(total), "g")
    return (round(total, 1), base_unit)


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

    # key = cleaned food name → accumulate quantities by base unit
    totals: dict[str, dict] = {}
    for item in plan.items:
        if item.is_leftover:
            continue
        scale = item.servings or 1
        for ri in item.recipe.ingredients:
            # Extract name from the raw ingredient string
            raw = ri.ingredient.name
            # Try to get quantity from the structured fields first, else parse from name
            qty = ri.quantity
            unit_raw = ri.unit
            # If no structured qty, try parsing from the raw name
            if qty is None:
                m = _US_QTY_RE.match(raw.strip())
                if m:
                    qty_str = m.group(1).strip()
                    unit_raw = m.group(2).strip()
                    try:
                        parts = qty_str.split()
                        qty = 0.0
                        for p in parts:
                            if "/" in p:
                                n, d = p.split("/")
                                qty += float(n) / float(d)
                            else:
                                qty += float(p)
                    except (ValueError, ZeroDivisionError):
                        qty = None

            cleaned = _clean_ingredient_name(raw)
            if _should_skip_grocery(cleaned):
                continue
            key = cleaned.lower()

            base_unit, mult = _normalise_unit(unit_raw)
            base_qty = (qty or 0) * mult * scale

            if key not in totals:
                totals[key] = {
                    "ingredient": cleaned,
                    "category": _categorise(cleaned),
                    "base_unit": base_unit,
                    "base_total": 0.0,
                    "count": 0,
                }
            totals[key]["base_total"] += base_qty
            totals[key]["count"] += 1
            # If units are mixed (e.g. g and ml), fallback to count only
            if base_unit and totals[key]["base_unit"] and base_unit != totals[key]["base_unit"]:
                totals[key]["base_unit"] = ""

    result = []
    for v in totals.values():
        qty_display, unit_display = None, None
        if v["base_unit"] and v["base_total"] > 0:
            qty_display, unit_display = _format_qty(v["base_total"], v["base_unit"])

        result.append({
            "ingredient": v["ingredient"],
            "category": v["category"],
            "quantity": qty_display,
            "unit": unit_display,
        })

    result.sort(key=lambda x: (x["category"], x["ingredient"].lower()))
    return result


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
    max_time: Optional[int] = Query(None, ge=5, le=300),  # max prep+cook minutes
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
    q = q.order_by(func.random()).limit(120)
    rows = await db.execute(q)
    all_recipes = rows.scalars().all()

    # Apply max time filter (prep + cook <= max_time)
    if max_time is not None:
        all_recipes = [
            r for r in all_recipes
            if (r.prep_minutes or 0) + (r.cook_minutes or 0) <= max_time
            or ((r.prep_minutes is None) and (r.cook_minutes is None))  # include if no time data
        ]

    # For breakfast: STRICT — only return slot-matched recipes
    if slot == "breakfast":
        matched = [r for r in all_recipes if _slot_score(r.title, slot)]
        # If not enough, do a wider fallback DB search specifically for breakfast keywords
        if len(matched) < 4:
            bk_query = select(Recipe).where(
                Recipe.calories != None,
                Recipe.is_published == True,
                Recipe.calories >= low,
                Recipe.calories <= high,
                func.lower(Recipe.title).op("~")(
                    "breakfast|pancake|waffle|omelette|omelet|scramble|french toast|"
                    "oatmeal|porridge|muesli|granola|overnight oat|frittata|quiche|"
                    "hash brown|bacon|cereal|crepe|brunch|muffin|egg"
                ),
            ).order_by(func.random()).limit(20)
            bk_rows = await db.execute(bk_query)
            extra = bk_rows.scalars().all()
            existing_slugs = {r.slug for r in matched}
            for r in extra:
                if r.slug not in existing_slugs:
                    matched.append(r)
                    existing_slugs.add(r.slug)
        combined = matched[:12]

    else:
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
