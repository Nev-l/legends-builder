"""
Recipe scraper — targets schema.org/Recipe JSON-LD first (works on 90% of
major recipe sites: AllRecipes, Taste, Delicious, BBC Good Food, etc.).
Falls back to Open Graph metadata.
"""
import json, re
from typing import Optional
import httpx
from bs4 import BeautifulSoup


_HEADERS = {
    "User-Agent": (
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
        "AppleWebKit/537.36 (KHTML, like Gecko) "
        "Chrome/124.0 Safari/537.36"
    ),
    "Accept-Language": "en-AU,en;q=0.9",
}

_ISO_RE = re.compile(r"PT(?:(\d+)H)?(?:(\d+)M)?", re.IGNORECASE)


def _parse_iso_duration(val: str | None) -> Optional[int]:
    """Convert ISO 8601 duration (PT30M, PT1H15M) to total minutes."""
    if not val:
        return None
    m = _ISO_RE.search(val)
    if not m:
        return None
    hours = int(m.group(1) or 0)
    mins  = int(m.group(2) or 0)
    return hours * 60 + mins


def _coerce_list(val) -> list[str]:
    if isinstance(val, list):
        return [str(v) for v in val]
    if isinstance(val, str):
        return [val]
    return []


def _extract_jsonld(soup: BeautifulSoup) -> Optional[dict]:
    for tag in soup.find_all("script", type="application/ld+json"):
        try:
            data = json.loads(tag.string or "")
        except (json.JSONDecodeError, TypeError):
            continue
        # Handle @graph arrays
        if isinstance(data, list):
            for item in data:
                if isinstance(item, dict) and item.get("@type") == "Recipe":
                    return item
        if isinstance(data, dict):
            if data.get("@type") == "Recipe":
                return data
            # Some sites nest it under @graph
            for item in data.get("@graph", []):
                if isinstance(item, dict) and item.get("@type") == "Recipe":
                    return item
    return None


async def scrape_recipe_url(url: str) -> Optional[dict]:
    try:
        async with httpx.AsyncClient(headers=_HEADERS, follow_redirects=True, timeout=15) as client:
            resp = await client.get(url)
            resp.raise_for_status()
    except Exception:
        return None

    soup = BeautifulSoup(resp.text, "html.parser")
    ld   = _extract_jsonld(soup)

    if ld:
        title = ld.get("name", "").strip()
        if not title:
            return None

        # Image — schema allows string, list, or ImageObject
        img = ld.get("image")
        if isinstance(img, list):
            img = img[0]
        if isinstance(img, dict):
            img = img.get("url")

        # Instructions — HowToStep list or plain strings
        raw_steps = ld.get("recipeInstructions", [])
        steps = []
        for s in raw_steps:
            if isinstance(s, dict):
                steps.append(s.get("text", "").strip())
            elif isinstance(s, str):
                steps.append(s.strip())
        steps = [s for s in steps if s]

        # Ingredients
        ingredients = _coerce_list(ld.get("recipeIngredient", []))

        # Servings
        yield_val = ld.get("recipeYield")
        servings = 4
        if yield_val:
            nums = re.findall(r"\d+", str(yield_val))
            if nums:
                servings = int(nums[0])

        return {
            "title": title,
            "description": ld.get("description", "").strip() or None,
            "image": img,
            "prep_minutes": _parse_iso_duration(ld.get("prepTime")),
            "cook_minutes": _parse_iso_duration(ld.get("cookTime")),
            "servings": servings,
            "ingredients": ingredients,
            "steps": steps,
        }

    # Fallback: Open Graph title + description only (no structured data)
    og_title = soup.find("meta", property="og:title")
    if og_title and og_title.get("content"):
        return {
            "title": og_title["content"].strip(),
            "description": None,
            "image": (soup.find("meta", property="og:image") or {}).get("content"),
            "prep_minutes": None,
            "cook_minutes": None,
            "servings": 4,
            "ingredients": [],
            "steps": [],
        }

    return None
