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
                  "scallop","clam","mussel","oyster","seafood","meat"}
_PRODUCE_WORDS = {"onion","garlic","tomato","pepper","capsicum","carrot","celery",
                  "broccoli","spinach","lettuce","zucchini","eggplant","cucumber",
                  "mushroom","cauliflower","kale","cabbage","corn","potato",
                  "sweet potato","leek","shallot","ginger","lemon","lime","orange",
                  "apple","banana","avocado","berry","berries","mango","pineapple",
                  "herbs","herb","cilantro","parsley","coriander leaf","spring onion",
                  "scallion","beetroot","beet","asparagus","artichoke","fennel",
                  "butternut","squash","pumpkin","radish","turnip","bok choy",
                  "bean sprouts","snap peas","snow peas","green beans"}
_DAIRY_WORDS   = {"milk","cream","butter","cheese","yogurt","yoghurt","sour cream",
                  "creme fraiche","ricotta","mozzarella","parmesan","cheddar",
                  "feta","brie","gouda","havarti","cream cheese","ghee","whey",
                  "half and half","heavy cream","ice cream","custard","kefir",
                  "condensed milk","evaporated milk","buttermilk"}
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
                  "coconut cream","vine leaves","breadcrumbs","panko"}


def _clean_ingredient_name(raw: str) -> str:
    """Strip quantity, unit, price, and parentheticals from a raw ingredient string."""
    s = raw.strip()
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
    if any(w in n for w in _MEAT_WORDS):   return "Meat & Seafood"
    if any(w in n for w in _PRODUCE_WORDS): return "Produce"
    if any(w in n for w in _DAIRY_WORDS):   return "Dairy"
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

    # key = cleaned food name → accumulate
    totals: dict[str, dict] = {}
    for item in plan.items:
        if item.is_leftover:
            continue
        for ri in item.recipe.ingredients:
            raw = ri.ingredient.name
            cleaned = _clean_ingredient_name(raw)
            if _should_skip_grocery(cleaned):
                continue
            key = cleaned.lower()
            if key not in totals:
                totals[key] = {
                    "ingredient": cleaned,
                    "category": _categorise(cleaned),
                    "raw_names": set(),
                }
            totals[key]["raw_names"].add(raw)

    # Convert sets to lists for JSON serialisation, sort by category then name
    result = []
    for v in totals.values():
        result.append({
            "ingredient": v["ingredient"],
            "category": v["category"],
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
