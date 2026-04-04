"""
tag_recipes.py — Batch-tag all recipes with diet tags and estimate macros.

Run: python tag_recipes.py [--dry-run] [--batch 500]

Strategy:
  1. Load each recipe's ingredients + title + description
  2. Apply keyword-based rules to assign diet tags
  3. Estimate per-serving macros from a simple ingredient lookup table
  4. Update recipes in batches
"""
import asyncio
import argparse
import re
import sys
from typing import Optional

# ─── Keyword rule sets ────────────────────────────────────────────────────────

# Ingredients that disqualify a tag
VEGAN_BLOCKERS     = {"meat","beef","pork","chicken","turkey","lamb","fish","salmon","tuna",
                       "shrimp","prawn","bacon","ham","sausage","egg","eggs","milk","cream",
                       "butter","cheese","yogurt","honey","gelatin","lard","ghee","whey",
                       "mayonnaise","mayo","anchovy","anchovies","sardine","cod","tilapia",
                       "crab","lobster","scallop","clam","mussel","oyster","duck","venison",
                       "bison","veal","pepperoni","salami","chorizo"}

VEGETARIAN_BLOCKERS = {"meat","beef","pork","chicken","turkey","lamb","fish","salmon","tuna",
                        "shrimp","prawn","bacon","ham","sausage","anchovy","anchovies","sardine",
                        "cod","tilapia","crab","lobster","scallop","clam","mussel","oyster",
                        "duck","venison","bison","veal","pepperoni","salami","chorizo","lard",
                        "gelatin"}

# High-carb ingredients that disqualify keto/low-carb
HIGH_CARB           = {"sugar","flour","bread","pasta","rice","potato","potatoes","oat","oats",
                        "oatmeal","corn","cornstarch","cornmeal","tortilla","noodle","noodles",
                        "quinoa","barley","wheat","rye","cracker","crackers","cereal","granola",
                        "pancake","waffle","cake","cookie","brownie","muffin","biscuit","roll",
                        "bun","bagel","pita","wrap","honey","syrup","maple","jam","jelly",
                        "ketchup","bbq sauce","sweet potato","yam","lentil","lentils","bean",
                        "beans","chickpea","chickpeas","banana","mango","grape","grapes",
                        "pineapple","dates","raisin","raisins","agave","molasses","brown sugar",
                        "powdered sugar","confectioner","cornflake","polenta","couscous","farro"}

# Must have at least one of these to qualify as carnivore
ANIMAL_PRODUCTS     = {"beef","pork","chicken","turkey","lamb","fish","salmon","tuna","shrimp",
                        "prawn","bacon","egg","eggs","butter","cream","cheese","steak","meat",
                        "brisket","ribs","sausage","ham","duck","venison","bison","veal",
                        "liver","kidney","bone","lard","ghee","tallow","suet"}

# Carnivore blockers: any plant foods
CARNIVORE_PLANT_BLOCKERS = {"vegetable","vegetables","onion","garlic","tomato","pepper",
                              "broccoli","spinach","lettuce","carrot","celery","mushroom",
                              "zucchini","eggplant","cucumber","cauliflower","kale","cabbage",
                              "corn","bean","beans","lentil","rice","pasta","bread","flour",
                              "potato","sugar","honey","fruit","apple","orange","lemon","lime",
                              "herb","herbs","spice","spices","sauce","salsa","soy","tofu",
                              "nuts","nut","seed","seeds","oat","quinoa","barley","berries"}

GLUTEN_INGREDIENTS  = {"flour","wheat","barley","rye","bread","pasta","noodle","noodles",
                        "cracker","crackers","soy sauce","beer","malt","semolina","spelt",
                        "farro","couscous","bulgur","panko","breadcrumb","breadcrumbs",
                        "pita","tortilla","wrap","bagel","muffin"}

DAIRY_INGREDIENTS   = {"milk","cream","butter","cheese","yogurt","ghee","whey","casein",
                        "lactose","sour cream","creme fraiche","ricotta","mozzarella",
                        "parmesan","cheddar","feta","brie","camembert","gouda","havarti",
                        "half and half","heavy cream","ice cream","custard","kefir"}

# High-protein signals
HIGH_PROTEIN_INGREDIENTS = {"chicken","beef","pork","turkey","fish","salmon","tuna","shrimp",
                              "prawn","egg","eggs","tofu","tempeh","lentil","lentils","bean",
                              "beans","chickpea","chickpeas","greek yogurt","cottage cheese",
                              "edamame","quinoa","protein","whey"}

PALEO_BLOCKERS      = {"grain","grains","flour","bread","pasta","rice","oat","oats","corn",
                        "dairy","milk","cream","butter","cheese","yogurt","legume","legumes",
                        "bean","beans","lentil","lentils","peanut","peanuts","soy","tofu",
                        "sugar","candy","processed","cereal","granola","potato chips"}

# ─── Simple macro lookup (per 100g) ──────────────────────────────────────────
# (calories, protein_g, carbs_g, fat_g)
MACRO_TABLE = {
    # Proteins
    "chicken": (165, 31, 0, 3.6),
    "beef": (250, 26, 0, 15),
    "pork": (242, 27, 0, 14),
    "turkey": (189, 29, 0, 7),
    "salmon": (208, 20, 0, 13),
    "tuna": (132, 28, 0, 1),
    "shrimp": (99, 24, 0.9, 0.3),
    "prawn": (99, 24, 0.9, 0.3),
    "egg": (155, 13, 1.1, 11),
    "eggs": (155, 13, 1.1, 11),
    "bacon": (541, 37, 1.4, 42),
    "ham": (145, 21, 0, 6),
    "lamb": (294, 25, 0, 21),
    "sausage": (301, 14, 3, 26),
    # Dairy
    "milk": (61, 3.2, 4.8, 3.3),
    "cream": (340, 2.8, 2.8, 36),
    "butter": (717, 0.9, 0.1, 81),
    "cheese": (402, 25, 1.3, 33),
    "yogurt": (59, 3.5, 3.6, 3.3),
    # Carbs
    "rice": (130, 2.7, 28, 0.3),
    "pasta": (131, 5, 25, 1.1),
    "bread": (265, 9, 49, 3.2),
    "potato": (77, 2, 17, 0.1),
    "flour": (364, 10, 76, 1),
    "sugar": (387, 0, 100, 0),
    "oats": (389, 17, 66, 7),
    "corn": (86, 3.3, 19, 1.4),
    # Vegetables
    "broccoli": (34, 2.8, 7, 0.4),
    "spinach": (23, 2.9, 3.6, 0.4),
    "tomato": (18, 0.9, 3.9, 0.2),
    "onion": (40, 1.1, 9.3, 0.1),
    "garlic": (149, 6.4, 33, 0.5),
    "carrot": (41, 0.9, 10, 0.2),
    "cauliflower": (25, 1.9, 5, 0.3),
    "mushroom": (22, 3.1, 3.3, 0.3),
    "pepper": (31, 1, 6, 0.3),
    "zucchini": (17, 1.2, 3.1, 0.3),
    "kale": (49, 4.3, 9, 0.9),
    "cabbage": (25, 1.3, 6, 0.1),
    # Fats/oils
    "olive oil": (884, 0, 0, 100),
    "oil": (884, 0, 0, 100),
    "avocado": (160, 2, 9, 15),
    "coconut": (354, 3.3, 15, 33),
    "nuts": (607, 20, 21, 54),
    "almond": (579, 21, 22, 50),
    "walnut": (654, 15, 14, 65),
    # Legumes
    "beans": (347, 22, 63, 1.2),
    "lentils": (116, 9, 20, 0.4),
    "chickpeas": (364, 19, 61, 6),
    # Fruit
    "banana": (89, 1.1, 23, 0.3),
    "apple": (52, 0.3, 14, 0.2),
    "lemon": (29, 1.1, 9, 0.3),
}

# ─── Helper functions ─────────────────────────────────────────────────────────

_NUM_PREFIX = re.compile(r"^[\d/\s\.\-]+(cup|tbsp|tsp|oz|lb|g|kg|ml|l|clove|cloves|slice|slices|can|cans|bunch|head|piece|pieces|x)?\s*", re.IGNORECASE)
_PAREN = re.compile(r"\(.*?\)")
_PRICE = re.compile(r"\$[\d\.]+")

def clean_ingredient(raw: str) -> str:
    """Strip quantities, prices, parentheticals from scraped ingredient strings."""
    s = raw.lower()
    s = _PRICE.sub("", s)
    s = _PAREN.sub("", s)
    s = _NUM_PREFIX.sub("", s)
    # strip trailing notes after comma
    s = s.split(",")[0]
    return s.strip()

def ingredient_words(name: str) -> set[str]:
    return set(re.split(r"\s+", clean_ingredient(name)))

def any_match(words: set[str], keyword_set: set[str]) -> bool:
    return bool(words & keyword_set)

def tag_recipe(title: str, description: str, raw_ingredients: list[str]) -> list[str]:
    """Return a list of diet tag strings for a recipe."""
    tags = []
    title_lower = (title + " " + (description or "")).lower()

    # Build word sets
    ingr_word_sets = [ingredient_words(i) for i in raw_ingredients]
    all_ingr_words: set[str] = set()
    for ws in ingr_word_sets:
        all_ingr_words |= ws

    # Also include significant words from title/description
    title_words = set(re.split(r"\W+", title_lower))
    all_words = all_ingr_words | title_words

    is_vegan = not any_match(all_words, VEGAN_BLOCKERS)
    is_vegetarian = not any_match(all_words, VEGETARIAN_BLOCKERS)
    is_gluten_free = not any_match(all_words, GLUTEN_INGREDIENTS)
    is_dairy_free = not any_match(all_words, DAIRY_INGREDIENTS)
    has_high_carb = any_match(all_words, HIGH_CARB)
    has_animal = any_match(all_words, ANIMAL_PRODUCTS)
    has_plant = any_match(all_words, CARNIVORE_PLANT_BLOCKERS)
    is_paleo = not any_match(all_words, PALEO_BLOCKERS) and has_animal

    if is_vegan:
        tags.append("vegan")
    if is_vegetarian and not is_vegan:
        tags.append("vegetarian")
    if is_gluten_free:
        tags.append("gluten_free")
    if is_dairy_free:
        tags.append("dairy_free")

    # Keto: low carb + has fat/protein, no high-carb ingredients
    if not has_high_carb and has_animal:
        tags.append("keto")
        tags.append("low_carb")
    elif not has_high_carb and is_vegan:
        tags.append("low_carb")

    # Carnivore: mostly animal products, minimal plants
    # More lenient: title/desc must signal it or ingredients are >60% animal
    animal_ingr_count = sum(1 for ws in ingr_word_sets if any_match(ws, ANIMAL_PRODUCTS))
    total_ingr = max(len(raw_ingredients), 1)
    if has_animal and not has_high_carb and animal_ingr_count / total_ingr >= 0.4:
        if not has_plant or any(w in title_lower for w in ["carnivore", "zero carb", "meat only", "all meat"]):
            tags.append("carnivore")

    # High protein
    if any_match(all_words, HIGH_PROTEIN_INGREDIENTS):
        tags.append("high_protein")

    # Paleo
    if is_paleo:
        tags.append("paleo")

    return list(dict.fromkeys(tags))  # deduplicate preserving order


def estimate_macros(raw_ingredients: list[str], servings: int) -> dict:
    """Rough macro estimation based on ingredient keywords."""
    total = {"calories": 0.0, "protein": 0.0, "carbs": 0.0, "fat": 0.0}
    matched = 0

    for raw in raw_ingredients:
        cleaned = clean_ingredient(raw)
        # Find best macro match
        for keyword, (cal, prot, carb, fat) in MACRO_TABLE.items():
            if keyword in cleaned:
                # Assume ~150g per ingredient line (rough)
                factor = 1.5
                total["calories"] += cal * factor
                total["protein"]  += prot * factor
                total["carbs"]    += carb * factor
                total["fat"]      += fat * factor
                matched += 1
                break

    if matched == 0:
        return {}

    sv = max(servings, 1)
    return {
        "calories": round(total["calories"] / sv, 1),
        "protein_g": round(total["protein"] / sv, 1),
        "carbs_g": round(total["carbs"] / sv, 1),
        "fat_g": round(total["fat"] / sv, 1),
    }


# ─── Async DB update ─────────────────────────────────────────────────────────

async def run(dry_run: bool, batch_size: int):
    import os
    sys.path.insert(0, os.path.dirname(__file__))
    from app.core.database import AsyncSessionLocal as async_session_factory
    from app.models.models import Recipe, RecipeIngredient, Ingredient
    from sqlalchemy import select, update
    from sqlalchemy.orm import selectinload

    print(f"Starting tagger (dry_run={dry_run}, batch={batch_size})")

    async with async_session_factory() as db:
        # Count total
        from sqlalchemy import func
        total = await db.scalar(select(func.count()).select_from(Recipe))
        print(f"Total recipes: {total}")

        offset = 0
        updated = 0
        while True:
            rows = await db.execute(
                select(Recipe)
                .options(
                    selectinload(Recipe.ingredients).selectinload(RecipeIngredient.ingredient)
                )
                .order_by(Recipe.id)
                .limit(batch_size)
                .offset(offset)
            )
            recipes = rows.scalars().all()
            if not recipes:
                break

            for recipe in recipes:
                raw_ingredients = [ri.ingredient.name for ri in recipe.ingredients]
                tags = tag_recipe(recipe.title, recipe.description or "", raw_ingredients)
                macros = estimate_macros(raw_ingredients, recipe.servings or 4)

                if not dry_run:
                    recipe.diet_tags = tags
                    if macros:
                        recipe.calories  = macros.get("calories")
                        recipe.protein_g = macros.get("protein_g")
                        recipe.carbs_g   = macros.get("carbs_g")
                        recipe.fat_g     = macros.get("fat_g")
                    updated += 1
                else:
                    # Print a sample
                    if offset == 0 and updated < 5:
                        print(f"  [{recipe.id}] {recipe.title[:50]}")
                        print(f"    Ingredients: {[clean_ingredient(i) for i in raw_ingredients[:5]]}")
                        print(f"    Tags: {tags}")
                        print(f"    Macros: {macros}")
                        updated += 1

            if not dry_run:
                await db.commit()
                print(f"  Tagged {offset + len(recipes)}/{total}…")

            offset += batch_size

        print(f"\nDone. {'Would update' if dry_run else 'Updated'} {total} recipes.")

        if not dry_run:
            # Print tag distribution
            from sqlalchemy import text
            rows = await db.execute(text(
                "SELECT unnest(diet_tags) as tag, COUNT(*) as cnt "
                "FROM recipes GROUP BY tag ORDER BY cnt DESC"
            ))
            print("\nTag distribution:")
            for row in rows:
                print(f"  {row.tag}: {row.cnt}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--batch", type=int, default=500)
    args = parser.parse_args()
    asyncio.run(run(args.dry_run, args.batch))
