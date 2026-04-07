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
- Funny, high-energy, passionate about food and fitness.
- Address the user as 'Amigo' or 'Chef'.
- CRITICAL: Keep responses SHORT and scannable. Never write walls of text.
- Use short sentences. Use line breaks between thoughts.
- When asking questions, ask ONE at a time or list them as short bullet points (use • not numbers).
- Use emojis sparingly — 1-2 per message max.
- When building meal plans, use a clear day-by-day structure with each meal on its own line.
- Never open with a long paragraph. Lead with one punchy sentence, then bullet points if needed.

YOUR EXPERTISE:
- Personalised meal planning (keto, carnivore, vegan, high-protein, cutting, bulking, maintenance)
- Macro & calorie calculation (TDEE, BMR, deficit/surplus)
- Nutrition science — protein timing, micronutrients, meal prep strategies
- Personal training — workout programming, progressive overload, recovery
- Recipe creation — you can invent brand-new recipes from scratch, tailored to macros and goals
- Shopping lists and budget-friendly meal prep

MEAL SLOT RULES (strictly follow these):
- Breakfast = morning foods ONLY: eggs, bacon, omelette, pancakes, waffles, oatmeal, overnight oats, smoothie bowls, granola, frittata, French toast, avocado toast, breakfast burritos
- Lunch = lighter meals: salads, wraps, soups, grain bowls, sandwiches, sushi
- Dinner = hearty mains: stir-fries, curries, roasts, pasta, grills, BBQ, casseroles
- Snack = small bites: protein balls, hummus, nuts, muffins, shakes, fruit + cheese
- NEVER put a dinner main at breakfast. NEVER put cereal at dinner.

MEAL PLAN FORMAT (when asked to build a plan):
- Always include calories, protein, carbs, fat per meal
- Respect the user's max meal time if specified (e.g. "15 minutes max" = quick meals only)
- Structure: Breakfast / Lunch / Dinner / Snacks
- Give simple prep tips
- End with a total daily macro summary

RECIPE CREATION:
- When asked to create a recipe, give it a clear title, ingredients in metric, and numbered steps.
- Make recipes achievable, specific, and delicious.
- Always state: calories, protein, carbs, fat per serving.

Be enthusiastic, be helpful, be Raul."""


class AIAssistantService:
    # Model priority list — try in order if rate limited
    MODELS = [
        "llama-3.3-70b-versatile",   # best quality
        "llama-3.1-8b-instant",      # fast fallback, same family
    ]

    def __init__(self):
        self.api_key = os.getenv("GROQ_API_KEY", "")
        self.model = self.MODELS[0]
        self.status = "ready" if self.api_key else "no_key"

    async def _call(self, messages: List[Dict], max_tokens: int = 1024) -> str:
        """Try each model in order, falling back on rate limit."""
        client = AsyncGroq(api_key=self.api_key)
        last_err = ""
        for model in self.MODELS:
            try:
                response = await client.chat.completions.create(
                    model=model,
                    messages=messages,
                    temperature=0.8,
                    max_tokens=max_tokens,
                )
                return response.choices[0].message.content
            except Exception as e:
                err = str(e)
                if "rate_limit" in err.lower() or "429" in err:
                    last_err = f"rate limit on {model}"
                    continue  # try next model
                if "api_key" in err.lower() or "auth" in err.lower():
                    return "Raul's key is wrong, Amigo! Check the GROQ_API_KEY in .env."
                # Unexpected error — break
                return f"Raul hit a snag: {err}"
        return f"Raul's all models are rate-limited right now, Amigo! ({last_err}). Give it a minute and try again — too many cooks in the kitchen! 🍳"

    async def chat(self, message: str, history: List[Dict] = None) -> str:
        if not self.api_key:
            return "Raul needs a GROQ_API_KEY to cook, Amigo! Ask the admin to add one."

        messages = [{"role": "system", "content": SYSTEM_PROMPT}]

        if history:
            for msg in history:
                role = msg.get("role", "user")
                content = msg.get("content", "")
                if role in ("user", "assistant") and content:
                    messages.append({"role": role, "content": content})

        messages.append({"role": "user", "content": message})
        return await self._call(messages)

    async def generate_flexible_plan(self, user: User, db: AsyncSession, weeks: int = 1, diet_type: str = "keto") -> dict:
        prompt = f"""Build a {weeks}-week {diet_type} meal plan for someone with the following profile:
Height: {getattr(user, 'height_cm', 'unknown')} cm
Weight: {getattr(user, 'weight_kg', 'unknown')} kg
Goal: {getattr(user, 'target_weight_kg', 'maintain weight')} kg target
Activity: {getattr(user, 'activity_level', 'moderate')}

Include daily calorie targets, macros, and a structured meal plan with breakfast, lunch, dinner and snacks.
Format it clearly with days and totals."""

        messages = [{"role": "system", "content": SYSTEM_PROMPT}, {"role": "user", "content": prompt}]
        result = await self._call(messages, max_tokens=2048)
        return {"plan": result, "weeks": weeks, "diet_type": diet_type}


ai_assistant = AIAssistantService()
