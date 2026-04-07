from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from pydantic import BaseModel
from typing import Optional, List, Dict
from datetime import datetime
import re, unicodedata, json

from app.core.database import get_db
from app.core.security import get_current_user_id
from app.models.models import User, Recipe, RecipeStep, RecipeIngredient, Ingredient
from app.services.ai_assistant import ai_assistant

router = APIRouter(prefix="/ai", tags=["ai"])

# ── Biometric Schemas ──────────────────────────────────────────────────────────

class BMIUpdate(BaseModel):
    height_cm: float
    weight_kg: float
    target_weight_kg: Optional[float] = None
    birth_date: Optional[str] = None
    biological_sex: str
    activity_level: str

class ChatMessage(BaseModel):
    message: str
    history: List[Dict] = []

# ── Routes ────────────────────────────────────────────────────────────────────

@router.post("/calculate-bmi")
async def calculate_bmi(
    body: BMIUpdate,
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db)
):
    """Calculates BMI and updates the user health profile."""
    user = await db.get(User, user_id)
    if not user:
        raise HTTPException(404, "User not found")

    # BMI calculation: weight (kg) / [height (m)]^2
    height_m = body.height_cm / 100
    bmi = round(body.weight_kg / (height_m * height_m), 1)

    # Categories
    category = "Healthy Weight"
    if bmi < 18.5: category = "Underweight"
    elif bmi >= 25.0 and bmi < 30.0: category = "Overweight"
    elif bmi >= 30.0: category = "Obese"

    # Update user
    user.height_cm = body.height_cm
    user.weight_kg = body.weight_kg
    user.target_weight_kg = body.target_weight_kg
    user.biological_sex = body.biological_sex
    user.activity_level = body.activity_level
    
    # Simple history snapshot
    history = list(user.bmi_history or [])
    history.append({
        "date": datetime.now().isoformat(),
        "weight": body.weight_kg,
        "bmi": bmi
    })
    user.bmi_history = history
    
    await db.commit()
    return {"bmi": bmi, "category": category, "health_summary": f"BMI {bmi} is considered {category}."}

@router.post("/chat")
async def ai_chat(
    body: ChatMessage,
    user_id: int = Depends(get_current_user_id)
):
    """Conversational endpoint for RAUL THE CHEF."""
    response = await ai_assistant.chat(body.message, body.history)
    return {"response": response}


class RaulPrefs(BaseModel):
    """User taste & preference profile stored by Raul."""
    breakfast_styles: List[str] = []    # e.g. ["overnight oats", "eggs", "smoothie bowl"]
    lunch_styles: List[str] = []        # e.g. ["salad", "wrap", "soup"]
    dinner_styles: List[str] = []       # e.g. ["chicken rice", "steak", "pasta"]
    snack_styles: List[str] = []        # e.g. ["protein shake", "fruit", "nuts"]
    disliked_foods: List[str] = []      # e.g. ["mushrooms", "fish"]
    cuisine_prefs: List[str] = []       # e.g. ["asian", "mediterranean", "mexican"]
    consistent_meals: bool = False      # True = repeat same meals, False = variety
    lazy_cook: bool = False             # True = minimal ingredients, dead-simple recipes
    extra_notes: str = ""               # freeform notes Raul learned from conversation


@router.post("/prefs")
async def save_raul_prefs(
    body: RaulPrefs,
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    """Save user taste preferences to the database so Raul remembers across sessions."""
    user = await db.get(User, user_id)
    if not user:
        raise HTTPException(404, "User not found")
    user.raul_prefs = body.model_dump()
    await db.commit()
    return {"ok": True}


@router.get("/prefs")
async def get_raul_prefs(
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    """Get stored Raul preferences for the current user."""
    user = await db.get(User, user_id)
    if not user:
        raise HTTPException(404, "User not found")
    return user.raul_prefs or {}

@router.post("/generate-plan")
async def ai_generate_plan(
    weeks: int = 1,
    diet_type: str = "keto",
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db)
):
    """Generates a high-fidelity flexible duration meal plan via Raul The Chef."""
    user = await db.get(User, user_id)
    if not user or not user.height_cm:
        raise HTTPException(400, "Please update your health profile in Settings first, Amigo!")

    plan_data = await ai_assistant.generate_flexible_plan(user, db, weeks, diet_type)
    if "error" in plan_data:
        raise HTTPException(500, plan_data["error"])
    
    return plan_data

@router.get("/status")
async def ai_status(user_id: int = Depends(get_current_user_id)):
    """Diagnostic endpoint to check Raul's connectivity."""
    return {
        "status": ai_assistant.status,
        "character": "RAUL THE CHEF",
        "model": ai_assistant.model,
    }


class RecipeGenRequest(BaseModel):
    title: str
    description: Optional[str] = None
    diet_tags: Optional[List[str]] = []
    servings: int = 2
    max_time_minutes: Optional[int] = None  # combined prep+cook
    lazy_mode: bool = False                  # minimal ingredients, dead-simple steps
    notes: Optional[str] = None             # extra instructions e.g. "high protein", "keto"


def _slugify(text: str) -> str:
    text = unicodedata.normalize("NFKD", text).encode("ascii", "ignore").decode()
    text = re.sub(r"[^\w\s-]", "", text.lower())
    return re.sub(r"[-\s]+", "-", text).strip("-")


@router.post("/create-recipe")
async def ai_create_recipe(
    body: RecipeGenRequest,
    user_id: int = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    """Ask Raul to generate a full recipe and save it under the Raul account."""

    # Build a detailed prompt for structured output
    constraints = []
    if body.lazy_mode:
        constraints.append("LAZY MODE: Keep it DEAD SIMPLE. Max 5 ingredients, max 3 steps, under 15 minutes total. Think: boiled eggs, tinned tuna & rice, steak & salad, instant oats. No fancy techniques.")
    if body.max_time_minutes:
        constraints.append(f"Total prep + cook time must be under {body.max_time_minutes} minutes.")
    if body.diet_tags:
        constraints.append(f"Diet requirements: {', '.join(body.diet_tags)}.")
    if body.notes:
        constraints.append(body.notes)

    constraint_block = "\n".join(constraints) if constraints else "Make it detailed, delicious, and impressive."
    ingredient_count = "3-5" if body.lazy_mode else "5-12"
    step_count = "2-3" if body.lazy_mode else "4-8"

    prompt = f"""You are Raul The Chef. Create a complete recipe for: "{body.title}"
{f'Description hint: {body.description}' if body.description else ''}
Servings: {body.servings}
{constraint_block}

Return ONLY valid JSON — no markdown fences, no text before or after the JSON:
{{
  "title": "exact recipe name",
  "description": "2-3 sentences — appetising, specific, mention key flavours",
  "prep_minutes": 10,
  "cook_minutes": 20,
  "servings": {body.servings},
  "calories_per_serving": 450,
  "protein_g": 35,
  "carbs_g": 20,
  "fat_g": 18,
  "diet_tags": ["high_protein"],
  "ingredients": [
    {{"name": "chicken breast", "quantity": 400, "unit": "g", "note": "sliced thin"}},
    {{"name": "olive oil", "quantity": 1, "unit": "tbsp", "note": null}},
    {{"name": "garlic clove", "quantity": 2, "unit": null, "note": "minced"}}
  ],
  "steps": [
    {{"body": "Heat oil in a pan over medium-high heat.", "timer_mins": null}},
    {{"body": "Season chicken with salt and pepper, cook 4 minutes each side.", "timer_mins": 8}},
    {{"body": "Add garlic, toss for 1 minute. Serve immediately.", "timer_mins": 1}}
  ]
}}

Rules:
- Use metric measurements (g, ml, tbsp, tsp, cups)
- Include {ingredient_count} ingredients and {step_count} steps
- Every step must be specific with temperatures, times, and techniques
- Calories must be realistic for the ingredients listed
- diet_tags only from: ["gluten_free","dairy_free","vegan","vegetarian","high_protein","low_carb","nut_free"]"""

    raw = await ai_assistant.chat(prompt, max_tokens=2048)

    # Strip markdown fences if present
    raw_clean = re.sub(r"```(?:json)?\s*", "", raw).strip()

    # Find the JSON object — try strict parse first, then attempt repair
    json_match = re.search(r"\{[\s\S]+\}", raw_clean)
    if not json_match:
        raise HTTPException(500, f"Raul couldn't produce a recipe. Try again! (no JSON found)")

    raw_json = json_match.group(0)

    # Attempt to close truncated JSON by counting braces/brackets
    def try_fix_truncated(s: str) -> str:
        open_b = s.count("{") - s.count("}")
        open_sq = s.count("[") - s.count("]")
        # Close any open strings first (remove trailing partial string)
        s = re.sub(r',\s*"[^"]*$', "", s)          # trailing partial key
        s = re.sub(r':\s*"[^"]*$', ': null', s)    # trailing partial value
        s = re.sub(r',\s*\{[^}]*$', "", s)          # trailing partial object
        for _ in range(open_sq): s += "]"
        for _ in range(open_b):  s += "}"
        return s

    data = None
    for attempt in (raw_json, try_fix_truncated(raw_json)):
        try:
            data = json.loads(attempt)
            break
        except json.JSONDecodeError:
            continue

    if data is None:
        raise HTTPException(500, f"Raul's recipe JSON was malformed. Try again!")

    # Sanitise diet_tags — only keep valid enum values
    VALID_TAGS = {"gluten_free","dairy_free","vegan","vegetarian","high_protein","low_carb","nut_free"}
    raw_tags = data.get("diet_tags") or body.diet_tags or []
    clean_tags = [t for t in raw_tags if t in VALID_TAGS]

    # Find or create the Raul account
    raul_user = await db.scalar(select(User).where(User.username == "raul"))
    if not raul_user:
        import hashlib, os as _os
        raul_user = User(
            email="raul@recipehub.ai",
            username="raul",
            display_name="Raul The Chef",
            role="verified_chef",
            hashed_password=hashlib.sha256(_os.urandom(32)).hexdigest(),
            avatar_url="/recipes/images/raul_unleashed.png",
            bio="I'm RAUL THE CHEF — your AI-powered personal chef and trainer! When a recipe doesn't exist in the vault, I create it from scratch — tailored to your goals, your tastes, and your schedule.",
        )
        db.add(raul_user)
        await db.flush()

    # Generate a food image URL using Unsplash Source (free, no API key needed)
    # Use the recipe title as the search query for a relevant food photo
    import urllib.parse as _urlparse
    title_query = _urlparse.quote(data.get("title", body.title).replace("-", " "))
    image_url = f"https://source.unsplash.com/800x600/?food,{title_query}"

    # Build slug
    base_slug = _slugify(data.get("title", body.title))
    slug = base_slug
    counter = 1
    while await db.scalar(select(Recipe).where(Recipe.slug == slug)):
        slug = f"{base_slug}-{counter}"
        counter += 1

    recipe = Recipe(
        title=data.get("title", body.title),
        slug=slug,
        description=data.get("description"),
        prep_minutes=data.get("prep_minutes"),
        cook_minutes=data.get("cook_minutes"),
        servings=data.get("servings", body.servings),
        calories=data.get("calories_per_serving"),
        protein_g=data.get("protein_g"),
        carbs_g=data.get("carbs_g"),
        fat_g=data.get("fat_g"),
        diet_tags=clean_tags,
        image_url=image_url,
        source="ugc",
        author_id=raul_user.id,
        is_published=True,
    )
    db.add(recipe)
    await db.flush()

    # Ingredients
    for ing_data in data.get("ingredients", []):
        ing_name = str(ing_data.get("name", "")).strip()
        if not ing_name:
            continue
        ingredient = await db.scalar(
            select(Ingredient).where(Ingredient.name.ilike(ing_name))
        )
        if not ingredient:
            ingredient = Ingredient(name=ing_name)
            db.add(ingredient)
            await db.flush()
        db.add(RecipeIngredient(
            recipe_id=recipe.id,
            ingredient_id=ingredient.id,
            quantity=ing_data.get("quantity"),
            unit=ing_data.get("unit"),
            note=ing_data.get("note"),
        ))

    # Steps
    for i, step_data in enumerate(data.get("steps", [])):
        db.add(RecipeStep(
            recipe_id=recipe.id,
            position=i + 1,
            body=step_data.get("body", ""),
            timer_mins=step_data.get("timer_mins"),
        ))

    await db.commit()

    return {
        "slug": recipe.slug,
        "title": recipe.title,
        "calories": recipe.calories,
        "prep_minutes": recipe.prep_minutes,
        "cook_minutes": recipe.cook_minutes,
        "message": f"Recipe '{recipe.title}' created and published by Raul!",
    }

