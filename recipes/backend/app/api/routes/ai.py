from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from pydantic import BaseModel
from typing import Optional, List, Dict
from datetime import datetime

from app.core.database import get_db
from app.core.security import get_current_user_id
from app.models.models import User, Recipe, MealPlan, MealPlanItem
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
    response = await ai_assistant.chat(user_id, body.message, body.history)
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
        "endpoint": "v1/models/gemini-pro"
    }

