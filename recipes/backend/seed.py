"""
Seed the database with real recipes scraped from public recipe sites.
Run once: python seed.py
"""
import asyncio
import sys
import os

sys.path.insert(0, os.path.dirname(__file__))
os.chdir(os.path.dirname(__file__))

from app.core.database import AsyncSessionLocal
from app.models.models import Recipe, RecipeIngredient, RecipeStep, Ingredient
from sqlalchemy import select


RECIPES = [
    {
        "title": "Classic Spaghetti Carbonara",
        "slug": "classic-spaghetti-carbonara",
        "description": "A rich and creamy Roman pasta made with eggs, pecorino, guanciale and black pepper. No cream needed.",
        "image_url": "https://images.unsplash.com/photo-1588013273468-315fd88ea34c?w=800",
        "prep_minutes": 10,
        "cook_minutes": 20,
        "servings": 4,
        "diet_tags": [],
        "source": "ugc",
        "ingredients": [
            ("spaghetti", 400, "g"),
            ("guanciale or pancetta", 150, "g"),
            ("eggs", 4, None),
            ("egg yolks", 2, None),
            ("pecorino romano", 100, "g"),
            ("parmesan", 50, "g"),
            ("black pepper", None, "to taste"),
            ("salt", None, "to taste"),
        ],
        "steps": [
            "Bring a large pot of salted water to a boil. Cook spaghetti until al dente.",
            "Meanwhile, cook guanciale in a large pan over medium heat until crispy. Remove from heat.",
            "Whisk eggs, yolks, and grated cheeses together in a bowl. Season generously with black pepper.",
            "Reserve 1 cup of pasta water before draining.",
            "Add hot pasta to the pan with guanciale (off heat). Add egg mixture, tossing quickly and adding pasta water a splash at a time until creamy.",
            "Serve immediately with extra cheese and black pepper.",
        ],
    },
    {
        "title": "Butter Chicken",
        "slug": "butter-chicken",
        "description": "Tender chicken in a rich, mildly spiced tomato and butter sauce. A crowd-pleasing Indian favourite.",
        "image_url": "https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=800",
        "prep_minutes": 20,
        "cook_minutes": 40,
        "servings": 4,
        "diet_tags": [],
        "source": "ugc",
        "ingredients": [
            ("chicken thighs", 800, "g"),
            ("plain yoghurt", 200, "g"),
            ("garam masala", 2, "tsp"),
            ("turmeric", 1, "tsp"),
            ("cumin", 1, "tsp"),
            ("garlic", 4, "cloves"),
            ("ginger", 2, "tsp"),
            ("butter", 50, "g"),
            ("onion", 1, None),
            ("crushed tomatoes", 400, "g"),
            ("heavy cream", 150, "ml"),
            ("chilli powder", 1, "tsp"),
            ("salt", None, "to taste"),
        ],
        "steps": [
            "Marinate chicken in yoghurt, half the spices, garlic and ginger for at least 1 hour.",
            "Grill or pan-fry marinated chicken until charred and cooked through. Set aside.",
            "Melt butter in a large pan. Fry onion until golden, about 8 minutes.",
            "Add remaining spices, garlic and ginger. Cook 2 minutes until fragrant.",
            "Add crushed tomatoes and simmer 15 minutes. Blend sauce until smooth.",
            "Return sauce to pan. Add cream and chicken. Simmer 10 minutes.",
            "Serve with basmati rice and naan.",
        ],
    },
    {
        "title": "Avocado Toast with Poached Eggs",
        "slug": "avocado-toast-poached-eggs",
        "description": "Creamy smashed avocado on sourdough topped with perfectly poached eggs and chilli flakes.",
        "image_url": "https://images.unsplash.com/photo-1525351484163-7529414344d8?w=800",
        "prep_minutes": 5,
        "cook_minutes": 10,
        "servings": 2,
        "diet_tags": ["vegetarian"],
        "source": "ugc",
        "ingredients": [
            ("sourdough bread", 2, "slices"),
            ("ripe avocados", 2, None),
            ("eggs", 4, None),
            ("lemon juice", 1, "tbsp"),
            ("chilli flakes", 1, "tsp"),
            ("salt", None, "to taste"),
            ("white vinegar", 1, "tsp"),
        ],
        "steps": [
            "Toast the sourdough until golden and crisp.",
            "Mash avocado with lemon juice and salt.",
            "Bring a pot of water to a gentle simmer. Add vinegar.",
            "Crack eggs one at a time into the water, swirling gently. Poach 3 minutes for runny yolks.",
            "Spread avocado on toast, top with poached eggs and chilli flakes.",
        ],
    },
    {
        "title": "Thai Green Curry",
        "slug": "thai-green-curry",
        "description": "Fragrant, coconut-based Thai curry with fresh green paste, vegetables and your choice of protein.",
        "image_url": "https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?w=800",
        "prep_minutes": 15,
        "cook_minutes": 25,
        "servings": 4,
        "diet_tags": [],
        "source": "ugc",
        "ingredients": [
            ("chicken breast or tofu", 600, "g"),
            ("green curry paste", 3, "tbsp"),
            ("coconut milk", 400, "ml"),
            ("fish sauce", 2, "tbsp"),
            ("palm sugar", 1, "tbsp"),
            ("zucchini", 1, None),
            ("capsicum", 1, None),
            ("Thai basil", 1, "handful"),
            ("kaffir lime leaves", 4, None),
            ("vegetable oil", 1, "tbsp"),
        ],
        "steps": [
            "Heat oil in a wok. Fry curry paste 1-2 minutes until fragrant.",
            "Add thick coconut cream (top of can) and stir-fry until oil splits.",
            "Add protein and cook until sealed.",
            "Pour in remaining coconut milk, fish sauce, sugar and lime leaves.",
            "Add vegetables and simmer 8 minutes.",
            "Stir through Thai basil just before serving. Serve with jasmine rice.",
        ],
    },
    {
        "title": "Chocolate Lava Cakes",
        "slug": "chocolate-lava-cakes",
        "description": "Decadent individual chocolate cakes with a molten gooey centre. Ready in 20 minutes.",
        "image_url": "https://images.unsplash.com/photo-1617305855105-b8d1f6a2abb6?w=800",
        "prep_minutes": 10,
        "cook_minutes": 12,
        "servings": 4,
        "diet_tags": ["vegetarian"],
        "source": "ugc",
        "ingredients": [
            ("dark chocolate", 200, "g"),
            ("butter", 150, "g"),
            ("eggs", 4, None),
            ("egg yolks", 4, None),
            ("caster sugar", 150, "g"),
            ("plain flour", 60, "g"),
            ("cocoa powder", 2, "tbsp"),
            ("vanilla extract", 1, "tsp"),
        ],
        "steps": [
            "Preheat oven to 200°C. Grease and flour 4 ramekins.",
            "Melt chocolate and butter together over a double boiler. Cool slightly.",
            "Whisk eggs, yolks and sugar until pale and thick.",
            "Fold chocolate mixture into eggs. Sift in flour and cocoa, fold gently.",
            "Divide between ramekins. Chill 10 minutes (or up to 24 hours).",
            "Bake 10-12 minutes until edges are set but centre wobbles.",
            "Rest 1 minute, run a knife around edges, invert onto plates. Serve immediately.",
        ],
    },
    {
        "title": "Shakshuka",
        "slug": "shakshuka",
        "description": "Eggs poached in a spiced tomato and pepper sauce. A Middle Eastern breakfast classic, easy one-pan meal.",
        "image_url": "https://images.unsplash.com/photo-1590412200988-a436970781fa?w=800",
        "prep_minutes": 10,
        "cook_minutes": 25,
        "servings": 2,
        "diet_tags": ["vegetarian", "gluten_free"],
        "source": "ugc",
        "ingredients": [
            ("eggs", 4, None),
            ("crushed tomatoes", 400, "g"),
            ("red capsicum", 1, None),
            ("onion", 1, None),
            ("garlic", 3, "cloves"),
            ("cumin", 1, "tsp"),
            ("paprika", 1, "tsp"),
            ("chilli flakes", 0.5, "tsp"),
            ("olive oil", 2, "tbsp"),
            ("feta", 50, "g"),
            ("fresh parsley", None, "to garnish"),
        ],
        "steps": [
            "Heat olive oil in a large skillet. Fry onion and capsicum until softened, 7 minutes.",
            "Add garlic and spices. Cook 1 minute.",
            "Add tomatoes, simmer 10 minutes until thickened.",
            "Make wells in the sauce. Crack eggs in. Cover and cook 5-7 minutes until whites are set.",
            "Top with feta and parsley. Serve with crusty bread.",
        ],
    },
    {
        "title": "Beef Tacos",
        "slug": "beef-tacos",
        "description": "Juicy seasoned ground beef in corn tortillas with all the classic toppings.",
        "image_url": "https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=800",
        "prep_minutes": 10,
        "cook_minutes": 15,
        "servings": 4,
        "diet_tags": [],
        "source": "ugc",
        "ingredients": [
            ("ground beef", 500, "g"),
            ("corn tortillas", 8, None),
            ("onion", 1, None),
            ("garlic", 2, "cloves"),
            ("cumin", 1, "tsp"),
            ("smoked paprika", 1, "tsp"),
            ("chilli powder", 1, "tsp"),
            ("cheddar cheese", 100, "g"),
            ("sour cream", 100, "g"),
            ("avocado", 1, None),
            ("lime", 1, None),
            ("fresh coriander", None, "to garnish"),
        ],
        "steps": [
            "Brown ground beef with onion and garlic in a skillet over high heat.",
            "Add spices and 1/4 cup water. Simmer 5 minutes until saucy.",
            "Warm tortillas in a dry pan or directly over flame.",
            "Assemble tacos with beef, cheese, sour cream, diced avocado, lime and coriander.",
        ],
    },
    {
        "title": "Banana Pancakes",
        "slug": "banana-pancakes",
        "description": "Fluffy, naturally sweet pancakes made with ripe bananas. Gluten-free and packed with flavour.",
        "image_url": "https://images.unsplash.com/photo-1554520735-0a6b8b6ce8b7?w=800",
        "prep_minutes": 5,
        "cook_minutes": 15,
        "servings": 2,
        "diet_tags": ["vegetarian", "gluten_free"],
        "source": "ugc",
        "ingredients": [
            ("ripe bananas", 2, None),
            ("eggs", 2, None),
            ("oats", 50, "g"),
            ("baking powder", 1, "tsp"),
            ("vanilla extract", 1, "tsp"),
            ("butter", 1, "tbsp"),
            ("maple syrup", None, "to serve"),
        ],
        "steps": [
            "Blend bananas, eggs, oats, baking powder and vanilla until smooth.",
            "Heat butter in a non-stick pan over medium heat.",
            "Pour small rounds of batter. Cook 2-3 minutes until bubbles form, flip and cook 1 minute more.",
            "Serve with maple syrup and sliced banana.",
        ],
    },
    {
        "title": "Roast Chicken with Garlic and Herbs",
        "slug": "roast-chicken-garlic-herbs",
        "description": "A perfectly golden, crispy-skinned whole roast chicken infused with garlic, lemon and fresh herbs.",
        "image_url": "https://images.unsplash.com/photo-1598103442097-8b74394b95c3?w=800",
        "prep_minutes": 15,
        "cook_minutes": 90,
        "servings": 4,
        "diet_tags": ["gluten_free"],
        "source": "ugc",
        "ingredients": [
            ("whole chicken", 1.8, "kg"),
            ("garlic", 6, "cloves"),
            ("lemon", 1, None),
            ("fresh rosemary", 3, "sprigs"),
            ("fresh thyme", 5, "sprigs"),
            ("butter", 60, "g"),
            ("olive oil", 2, "tbsp"),
            ("salt", None, "to taste"),
            ("black pepper", None, "to taste"),
        ],
        "steps": [
            "Preheat oven to 200°C. Pat chicken dry with paper towels.",
            "Mix softened butter with chopped garlic, rosemary and thyme. Season well.",
            "Loosen skin over breast and rub butter mixture underneath and over the outside.",
            "Stuff cavity with lemon halves and remaining herb sprigs.",
            "Roast 1.5 hours, basting every 30 minutes, until juices run clear.",
            "Rest 15 minutes before carving.",
        ],
    },
    {
        "title": "Mushroom Risotto",
        "slug": "mushroom-risotto",
        "description": "Creamy, deeply flavoured Italian risotto with mixed mushrooms and parmesan. Comfort food at its finest.",
        "image_url": "https://images.unsplash.com/photo-1476124369491-e7addf5db371?w=800",
        "prep_minutes": 10,
        "cook_minutes": 35,
        "servings": 4,
        "diet_tags": ["vegetarian", "gluten_free"],
        "source": "ugc",
        "ingredients": [
            ("arborio rice", 320, "g"),
            ("mixed mushrooms", 400, "g"),
            ("vegetable stock", 1.2, "L"),
            ("white wine", 150, "ml"),
            ("onion", 1, None),
            ("garlic", 3, "cloves"),
            ("butter", 60, "g"),
            ("parmesan", 80, "g"),
            ("olive oil", 2, "tbsp"),
            ("fresh thyme", 4, "sprigs"),
            ("salt and pepper", None, "to taste"),
        ],
        "steps": [
            "Warm stock in a saucepan over low heat.",
            "Sauté mushrooms in butter until golden. Set aside.",
            "In the same pan, soften onion and garlic in olive oil. Add rice and toast 2 minutes.",
            "Add white wine and stir until absorbed.",
            "Add warm stock one ladle at a time, stirring constantly, waiting until each addition is absorbed — about 20 minutes.",
            "Stir in mushrooms, remaining butter and parmesan. Season well.",
            "Rest 2 minutes, then serve.",
        ],
    },
]


async def seed():
    async with AsyncSessionLocal() as db:
        count = 0
        for r in RECIPES:
            existing = await db.scalar(select(Recipe).where(Recipe.slug == r["slug"]))
            if existing:
                print(f"  skip  {r['slug']}")
                continue

            recipe = Recipe(
                title=r["title"],
                slug=r["slug"],
                description=r["description"],
                image_url=r["image_url"],
                prep_minutes=r["prep_minutes"],
                cook_minutes=r["cook_minutes"],
                servings=r["servings"],
                diet_tags=r["diet_tags"],
                source=r["source"],
                is_published=True,
            )
            db.add(recipe)
            await db.flush()

            for pos, (name, qty, unit) in enumerate(r["ingredients"]):
                name = name.lower().strip()
                ing = await db.scalar(select(Ingredient).where(Ingredient.name == name))
                if not ing:
                    ing = Ingredient(name=name, canonical=name)
                    db.add(ing)
                    await db.flush()
                db.add(RecipeIngredient(
                    recipe_id=recipe.id,
                    ingredient_id=ing.id,
                    quantity=qty,
                    unit=unit,
                    position=pos,
                ))

            for pos, body in enumerate(r["steps"]):
                db.add(RecipeStep(recipe_id=recipe.id, position=pos + 1, body=body))

            await db.commit()
            print(f"  added {r['slug']}")
            count += 1

        print(f"\nDone — {count} recipes added.")


if __name__ == "__main__":
    asyncio.run(seed())
