import os
from groq import AsyncGroq
from dotenv import load_dotenv
from typing import List, Dict, Optional
from sqlalchemy.ext.asyncio import AsyncSession
from app.models.models import User

load_dotenv("/home/q/legends/recipes/backend/.env")

SYSTEM_PROMPT = """You are RAUL THE CHEF — the spicy, witty, and exceptionally talented Head Chef and Personal Trainer of RecipeHub.
You're not just an AI; you're the user's best friend in the kitchen AND the gym.

PERSONALITY:
- Funny, high-energy, passionate about food and fitness. Use culinary puns where appropriate.
- Address the user as 'Amigo' or 'Chef'.
- Keep responses concise and actionable — no waffle (unless it's a waffle recipe).

YOUR EXPERTISE:
- Personalised meal planning (keto, carnivore, vegan, high-protein, cutting, bulking, maintenance)
- Macro & calorie calculation (TDEE, BMR, deficit/surplus)
- Nutrition science — protein timing, micronutrients, meal prep strategies
- Personal training — workout programming, progressive overload, recovery
- Recipe creation and modification to hit specific macro targets
- Shopping lists and budget-friendly meal prep

MEAL PLAN FORMAT (when asked to build a plan):
- Always include calories, protein, carbs, fat per meal
- Structure: Breakfast / Lunch / Dinner / Snacks
- Give simple prep tips
- End with a total daily macro summary

Be enthusiastic, be helpful, be Raul."""


class AIAssistantService:
    def __init__(self):
        self.api_key = os.getenv("GROQ_API_KEY", "")
        self.model = "llama3-70b-8192"  # Best free model on Groq
        self.status = "ready" if self.api_key else "no_key"

    async def chat(self, message: str, history: List[Dict] = None) -> str:
        if not self.api_key:
            return "Raul needs a GROQ_API_KEY to cook, Amigo! Ask the admin to add one."

        client = AsyncGroq(api_key=self.api_key)

        messages = [{"role": "system", "content": SYSTEM_PROMPT}]

        if history:
            for msg in history:
                role = msg.get("role", "user")
                content = msg.get("content", "")
                if role in ("user", "assistant") and content:
                    messages.append({"role": role, "content": content})

        messages.append({"role": "user", "content": message})

        try:
            response = await client.chat.completions.create(
                model=self.model,
                messages=messages,
                temperature=0.8,
                max_tokens=1024,
            )
            return response.choices[0].message.content
        except Exception as e:
            err = str(e)
            if "rate_limit" in err.lower():
                return "Raul's a bit busy right now, Amigo — hit the rate limit. Try again in a moment!"
            if "api_key" in err.lower() or "auth" in err.lower():
                return "Raul's key is wrong, Amigo! Check the GROQ_API_KEY in .env."
            return f"Raul hit a snag: {err}"

    async def generate_flexible_plan(self, user: User, db: AsyncSession, weeks: int = 1, diet_type: str = "keto") -> dict:
        prompt = f"""Build a {weeks}-week {diet_type} meal plan for someone with the following profile:
Height: {getattr(user, 'height_cm', 'unknown')} cm
Weight: {getattr(user, 'weight_kg', 'unknown')} kg
Goal: {getattr(user, 'target_weight_kg', 'maintain weight')} kg target
Activity: {getattr(user, 'activity_level', 'moderate')}

Include daily calorie targets, macros, and a structured meal plan with breakfast, lunch, dinner and snacks.
Format it clearly with days and totals."""

        result = await self.chat(prompt)
        return {"plan": result, "weeks": weeks, "diet_type": diet_type}


ai_assistant = AIAssistantService()
