"""
Bulk recipe scraper — pulls URLs from sitemaps and scrapes each one.
Run: python bulk_scrape.py [--target 500] [--workers 4]

Sources (all support schema.org/Recipe JSON-LD):
  - allrecipes.com
  - recipetineats.com
  - taste.com.au
  - simplyrecipes.com
  - budgetbytes.com
"""
import asyncio
import argparse
import re
import unicodedata
import xml.etree.ElementTree as ET
from typing import Optional
import httpx
from sqlalchemy import select

import sys, os
sys.path.insert(0, os.path.dirname(__file__))
os.chdir(os.path.dirname(__file__))

from app.core.database import AsyncSessionLocal
from app.models.models import Recipe, RecipeIngredient, RecipeStep, Ingredient
from app.services.scraper import scrape_recipe_url


_HEADERS = {
    "User-Agent": (
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
        "AppleWebKit/537.36 (KHTML, like Gecko) "
        "Chrome/124.0 Safari/537.36"
    ),
    "Accept-Language": "en-AU,en;q=0.9",
}

# Sitemap index URLs — we'll pull child sitemaps then individual URLs
SITEMAPS = [
    "https://www.recipetineats.com/post-sitemap.xml",
    "https://www.recipetineats.com/post-sitemap2.xml",
    "https://www.budgetbytes.com/post-sitemap.xml",
    "https://www.budgetbytes.com/post-sitemap2.xml",
    "https://www.budgetbytes.com/post-sitemap3.xml",
    "https://www.loveandlemons.com/post-sitemap.xml",
    "https://www.loveandlemons.com/post-sitemap2.xml",
    "https://cookieandkate.com/post-sitemap.xml",
    "https://cookieandkate.com/post-sitemap2.xml",
    "https://www.skinnytaste.com/post-sitemap1.xml",
    "https://www.skinnytaste.com/post-sitemap2.xml",
    "https://minimalistbaker.com/post-sitemap.xml",
]

# Pattern — only follow URLs that look like actual recipes
_RECIPE_URL_RE = re.compile(
    r"(recipetineats\.com/(?!category|tag|page|author|shop)"
    r"|budgetbytes\.com/(?!category|tag|page|about|contact|meal-prep)"
    r"|loveandlemons\.com/(?!category|tag|page|about|contact)"
    r"|cookieandkate\.com/(?!category|tag|page|about|contact)"
    r"|skinnytaste\.com/(?!category|tag|page|about|contact|shop)"
    r"|minimalistbaker\.com/(?!category|tag|page|about|contact))"
)


def slugify(text: str) -> str:
    text = unicodedata.normalize("NFKD", text).encode("ascii", "ignore").decode()
    text = re.sub(r"[^\w\s-]", "", text.lower())
    return re.sub(r"[-\s]+", "-", text).strip("-")


async def fetch_sitemap_urls(client: httpx.AsyncClient, url: str) -> list[str]:
    try:
        resp = await client.get(url, timeout=20)
        resp.raise_for_status()
    except Exception as e:
        print(f"  sitemap error {url}: {e}")
        return []

    urls = []
    try:
        root = ET.fromstring(resp.text)
        ns = {"sm": "http://www.sitemaps.org/schemas/sitemap/0.9"}
        # Sitemap index — recurse into child sitemaps
        for loc in root.findall(".//sm:sitemap/sm:loc", ns):
            child_urls = await fetch_sitemap_urls(client, loc.text.strip())
            urls.extend(child_urls)
        # Regular sitemap
        for loc in root.findall(".//sm:url/sm:loc", ns):
            u = loc.text.strip()
            if _RECIPE_URL_RE.search(u):
                urls.append(u)
    except ET.ParseError:
        pass
    return urls


async def get_or_create_ingredient(db, name: str) -> Optional[int]:
    """Get ingredient id, creating if needed. Handles concurrent inserts."""
    name = name.strip().lower()[:200]
    if not name:
        return None
    ing = await db.scalar(select(Ingredient).where(Ingredient.name == name))
    if ing:
        return ing.id
    # Use INSERT ... ON CONFLICT DO NOTHING via raw SQL to avoid race conditions
    from sqlalchemy import text
    await db.execute(
        text("INSERT INTO ingredients (name, canonical, allergen_tags) VALUES (:n, :n, '{}') ON CONFLICT (name) DO NOTHING"),
        {"n": name},
    )
    ing = await db.scalar(select(Ingredient).where(Ingredient.name == name))
    return ing.id if ing else None


async def save_recipe(db, data: dict, source_url: str) -> bool:
    """Save scraped recipe to DB. Returns True if saved, False if skipped."""
    title = data.get("title", "").strip()
    if not title or len(title) < 3:
        return False

    # Must have actual recipe content
    ingredients = data.get("ingredients", [])
    steps = data.get("steps", [])
    if len(ingredients) < 2 and len(steps) < 2:
        return False

    slug = slugify(title)
    if not slug:
        return False

    existing = await db.scalar(select(Recipe).where(Recipe.slug == slug))
    if existing:
        return False

    try:
        recipe = Recipe(
            title=title,
            slug=slug,
            description=data.get("description") or None,
            source="scraped",
            source_url=source_url,
            image_url=data.get("image") or None,
            prep_minutes=data.get("prep_minutes"),
            cook_minutes=data.get("cook_minutes"),
            servings=data.get("servings", 4),
            diet_tags=[],
            is_published=True,
        )
        db.add(recipe)
        await db.flush()

        for pos, raw in enumerate(ingredients):
            ing_id = await get_or_create_ingredient(db, str(raw))
            if ing_id:
                db.add(RecipeIngredient(recipe_id=recipe.id, ingredient_id=ing_id, position=pos))

        for pos, step_text in enumerate(steps):
            body = str(step_text).strip()
            if body:
                db.add(RecipeStep(recipe_id=recipe.id, position=pos + 1, body=body))

        await db.commit()
        return True
    except Exception as e:
        await db.rollback()
        raise


async def worker(queue: asyncio.Queue, results: dict, client: httpx.AsyncClient, worker_id: int):
    async with AsyncSessionLocal() as db:
        while True:
            url = await queue.get()
            if url is None:
                queue.task_done()
                break
            try:
                data = await scrape_recipe_url(url)
                if data:
                    saved = await save_recipe(db, data, url)
                    if saved:
                        results["saved"] += 1
                        print(f"  [{worker_id}] saved  {data['title'][:60]}")
                    else:
                        results["skipped"] += 1
                else:
                    results["failed"] += 1
            except Exception as e:
                results["failed"] += 1
                print(f"  [{worker_id}] error  {url}: {e}")
            finally:
                queue.task_done()
                results["processed"] += 1
                if results["processed"] % 50 == 0:
                    print(f"\n  === Progress: {results['saved']} saved / {results['processed']} processed ===\n")


async def main(target: int, num_workers: int):
    print(f"Target: {target} recipes, {num_workers} workers\n")

    # Check how many we already have
    async with AsyncSessionLocal() as db:
        count = await db.scalar(select(Recipe).count() if hasattr(Recipe, 'count') else
                                 __import__('sqlalchemy', fromlist=['func']).func.count(Recipe.id))
        from sqlalchemy import func
        count = await db.scalar(select(func.count(Recipe.id)))
        print(f"Current recipes in DB: {count}")
        if count >= target:
            print("Already at target.")
            return

    async with httpx.AsyncClient(headers=_HEADERS, follow_redirects=True, timeout=20) as client:
        # Collect URLs from all sitemaps
        print("Fetching sitemaps...")
        all_urls = []
        for sitemap_url in SITEMAPS:
            urls = await fetch_sitemap_urls(client, sitemap_url)
            print(f"  {sitemap_url}: {len(urls)} URLs")
            all_urls.extend(urls)

        # Deduplicate
        all_urls = list(dict.fromkeys(all_urls))
        print(f"\nTotal unique recipe URLs: {len(all_urls)}")
        print(f"Will process up to {min(len(all_urls), target * 3)} URLs to reach {target} saved\n")

        # Limit queue to avoid processing far more than needed
        urls_to_process = all_urls[:target * 4]

        queue: asyncio.Queue = asyncio.Queue()
        for url in urls_to_process:
            await queue.put(url)
        for _ in range(num_workers):
            await queue.put(None)  # sentinel

        results = {"saved": 0, "skipped": 0, "failed": 0, "processed": 0}

        tasks = [
            asyncio.create_task(worker(queue, results, client, i))
            for i in range(num_workers)
        ]

        await queue.join()
        await asyncio.gather(*tasks)

    print(f"\n=== Done ===")
    print(f"  Saved:   {results['saved']}")
    print(f"  Skipped: {results['skipped']} (duplicates)")
    print(f"  Failed:  {results['failed']}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--target", type=int, default=500, help="Target number of recipes")
    parser.add_argument("--workers", type=int, default=3, help="Concurrent scrapers")
    args = parser.parse_args()
    asyncio.run(main(args.target, args.workers))
