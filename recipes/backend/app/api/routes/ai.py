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
    servings: int = 4
    max_time_minutes: Optional[int] = None  # combined prep+cook
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
    if body.max_time_minutes:
        constraints.append(f"Total prep + cook time must be under {body.max_time_minutes} minutes.")
    if body.diet_tags:
        constraints.append(f"Diet tags: {', '.join(body.diet_tags)}.")
    if body.notes:
        constraints.append(body.notes)

    constraint_block = "\n".join(constraints) if constraints else "No special constraints."

    prompt = f"""Create a complete, detailed recipe for: "{body.title}"
{f'Description: {body.description}' if body.description else ''}
Servings: {body.servings}
{constraint_block}

Return ONLY valid JSON in this exact format (no markdown, no commentary before or after):
{{
  "title": "recipe title",
  "description": "2-3 sentence description",
  "prep_minutes": 15,
  "cook_minutes": 25,
  "servings": {body.servings},
  "calories_per_serving": 450,
  "protein_g": 35,
  "carbs_g": 20,
  "fat_g": 18,
  "diet_tags": [],
  "ingredients": [
    {{"name": "chicken breast", "quantity": 500, "unit": "g", "note": "sliced"}},
    {{"name": "olive oil", "quantity": 2, "unit": "tbsp", "note": null}}
  ],
  "steps": [
    {{"body": "Preheat oven to 200°C.", "timer_mins": null}},
    {{"body": "Season chicken with salt and pepper.", "timer_mins": null}},
    {{"body": "Bake for 25 minutes until golden.", "timer_mins": 25}}
  ]
}}

Use metric measurements (grams, ml, tbsp, tsp). Include at least 5 ingredients and 4 steps. Be specific and helpful."""

    raw = await ai_assistant.chat(prompt)

    # Extract JSON from response (Raul might wrap it in markdown fences)
    json_match = re.search(r"\{[\s\S]+\}", raw)
    if not json_match:
        raise HTTPException(500, f"Raul's recipe output wasn't parseable. Raw: {raw[:300]}")

    try:
        data = json.loads(json_match.group(0))
    except json.JSONDecodeError as e:
        raise HTTPException(500, f"JSON parse error: {e}. Raw: {raw[:300]}")

    # Find or create the Raul account
    raul_user = await db.scalar(select(User).where(User.username == "raul"))
    if not raul_user:
        # Create Raul's account if it doesn't exist
        import hashlib, os
        raul_user = User(
            email="raul@recipehub.ai",
            username="raul",
            display_name="Raul The Chef",
            role="verified_chef",
            hashed_password=hashlib.sha256(os.urandom(32)).hexdigest(),
            bio="I'm RAUL THE CHEF — your AI-powered personal chef and trainer! I create custom recipes tailored to your goals.",
        )
        db.add(raul_user)
        await db.flush()

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
        diet_tags=data.get("diet_tags") or body.diet_tags or [],
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

