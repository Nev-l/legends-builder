"use client";
import { useState, useEffect } from "react";
import { usePathname } from "next/navigation";
import useSWR from "swr";
import { api } from "@/lib/api";

interface Recipe {
  id: number;
  title: string;
  slug: string;
  description: string | null;
  image_url: string | null;
  prep_minutes: number | null;
  cook_minutes: number | null;
  servings: number;
  diet_tags: string[];
  upvotes: number;
  downvotes: number;
  score: number;
}

interface Ingredient {
  id: number;
  name: string;
  quantity: number | null;
  unit: string | null;
  note: string | null;
  position: number;
}

interface Step {
  id: number;
  position: number;
  body: string;
  image_url: string | null;
  timer_mins: number | null;
}

interface RecipeDetail extends Recipe {
  author_id: number | null;
  source_url: string | null;
  ingredients: Ingredient[];
  steps: Step[];
}

const SORTS = ["trending", "newest", "top"] as const;

const DIETS = [
  { key: "keto",        label: "Keto" },
  { key: "carnivore",   label: "Carnivore" },
  { key: "vegan",       label: "Vegan" },
  { key: "vegetarian",  label: "Vegetarian" },
  { key: "gluten_free", label: "Gluten-Free" },
  { key: "dairy_free",  label: "Dairy-Free" },
  { key: "high_protein",label: "High Protein" },
  { key: "low_carb",    label: "Low Carb" },
  { key: "paleo",       label: "Paleo" },
] as const;

export default function Home() {
  // Pick up Google OAuth token redirect: /recipes?token=...
  useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    const token = params.get("token");
    if (token) {
      localStorage.setItem("rh_token", token);
      const uname = params.get("username");
      if (uname) localStorage.setItem("rh_username", uname);
      window.history.replaceState({}, "", "/recipes");
    }
  }, []);

  // SPA routing: if the path is /recipes/<slug>, show detail view
  const pathname = usePathname();
  // basePath is /recipes, so pathname from usePathname() is relative to that
  // e.g. visiting /recipes/pasta → pathname = "/pasta"
  const slug = pathname && pathname !== "/" ? pathname.replace(/^\//, "").replace(/\/$/, "") : null;

  if (slug && !["planner", "pantry", "login"].includes(slug)) {
    return <RecipeDetailView slug={slug} />;
  }
  return <RecipeList />;
}

// ── Recipe list ──────────────────────────────────────────────────────────────

function RecipeList() {
  const [sort, setSort] = useState<(typeof SORTS)[number]>("trending");
  const [diet, setDiet] = useState("");
  const [q, setQ] = useState("");
  const [search, setSearch] = useState("");
  const [scraping, setScraping] = useState(false);
  const [scrapeError, setScrapeError] = useState("");

  const swrKey = `/recipes?sort=${sort}${search ? `&q=${encodeURIComponent(search)}` : ""}${diet ? `&diet=${diet}` : ""}`;
  const { data: recipes, isLoading, mutate } = useSWR<Recipe[]>(
    swrKey,
    (url: string) => api.get<Recipe[]>(url.replace("/recipes/api", ""))
  );

  function isUrl(val: string) {
    return val.startsWith("http://") || val.startsWith("https://");
  }

  async function handleSearch() {
    setScrapeError("");
    if (!q.trim()) return;

    if (isUrl(q.trim())) {
      // Scrape the URL and navigate to the new recipe
      setScraping(true);
      try {
        const token = localStorage.getItem("rh_token");
        if (!token) {
          setScrapeError("Sign in to scrape recipes from URLs.");
          return;
        }
        const recipe = await api.post<Recipe>("/recipes/scrape", { url: q.trim() });
        mutate();
        window.location.href = `/recipes/${recipe.slug}`;
      } catch (e: any) {
        setScrapeError(e.message ?? "Could not scrape that URL.");
      } finally {
        setScraping(false);
      }
    } else {
      setSearch(q.trim());
    }
  }

  return (
    <div>
      <section className="mb-10 text-center">
        <h1 className="mb-2 text-4xl font-extrabold tracking-tight">
          Find your next favourite meal
        </h1>
        <p className="text-gray-400">
          Search recipes or paste any recipe URL to scrape and save it.
        </p>
      </section>

      <div className="mb-2 flex flex-col gap-3 sm:flex-row">
        <input
          className="flex-1 rounded-lg border border-gray-700 bg-gray-900 px-4 py-2.5 text-sm placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-brand-500"
          placeholder="Search recipes or paste a URL to scrape…"
          value={q}
          onChange={(e) => { setQ(e.target.value); setScrapeError(""); }}
          onKeyDown={(e) => e.key === "Enter" && handleSearch()}
          disabled={scraping}
        />
        <button
          onClick={handleSearch}
          disabled={scraping || !q.trim()}
          className="rounded-lg bg-brand-500 px-5 py-2.5 text-sm font-semibold text-white hover:bg-brand-600 disabled:opacity-50 whitespace-nowrap"
        >
          {scraping ? "Scraping…" : isUrl(q) ? "Scrape & Save" : "Search"}
        </button>
        <div className="flex gap-2">
          {SORTS.map((s) => (
            <button
              key={s}
              onClick={() => setSort(s)}
              className={`rounded-lg px-4 py-2.5 text-sm font-medium capitalize transition ${
                sort === s
                  ? "bg-brand-500 text-white"
                  : "bg-gray-800 text-gray-400 hover:bg-gray-700 hover:text-white"
              }`}
            >
              {s}
            </button>
          ))}
        </div>
      </div>
      {scrapeError && <p className="mb-4 text-sm text-red-400">{scrapeError}</p>}

      {/* Diet filters */}
      <div className="mb-6 flex flex-wrap gap-2">
        <button
          onClick={() => setDiet("")}
          className={`rounded-full px-3 py-1 text-xs font-medium transition ${
            !diet ? "bg-brand-500 text-white" : "bg-gray-800 text-gray-400 hover:bg-gray-700 hover:text-white"
          }`}
        >
          All
        </button>
        {DIETS.map((d) => (
          <button
            key={d.key}
            onClick={() => setDiet(diet === d.key ? "" : d.key)}
            className={`rounded-full px-3 py-1 text-xs font-medium transition ${
              diet === d.key ? "bg-brand-500 text-white" : "bg-gray-800 text-gray-400 hover:bg-gray-700 hover:text-white"
            }`}
          >
            {d.label}
          </button>
        ))}
      </div>

      {isLoading ? (
        <p className="text-center text-gray-500">Loading…</p>
      ) : (
        <div className="grid gap-5 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
          {recipes?.map((r) => <RecipeCard key={r.id} recipe={r} />)}
          {recipes?.length === 0 && (
            <p className="col-span-full text-center text-gray-500">
              No recipes found.{" "}
              {!search && <span className="text-gray-600">Paste a recipe URL above to add one.</span>}
            </p>
          )}
        </div>
      )}
    </div>
  );
}

function RecipeCard({ recipe: r }: { recipe: Recipe }) {
  const mins = (r.prep_minutes ?? 0) + (r.cook_minutes ?? 0);
  return (
    <a
      href={`/recipes/${r.slug}`}
      className="group flex flex-col overflow-hidden rounded-xl border border-gray-800 bg-gray-900 transition hover:border-brand-500"
    >
      {r.image_url ? (
        <img
          src={r.image_url}
          alt={r.title}
          className="h-44 w-full object-cover transition group-hover:opacity-90"
        />
      ) : (
        <div className="flex h-44 items-center justify-center bg-gray-800 text-5xl">🍽️</div>
      )}
      <div className="flex flex-1 flex-col gap-1.5 p-4">
        <h2 className="font-semibold leading-snug group-hover:text-brand-500">{r.title}</h2>
        {r.description && (
          <p className="line-clamp-2 text-xs text-gray-400">{r.description}</p>
        )}
        <div className="mt-auto flex items-center justify-between pt-2 text-xs text-gray-500">
          <span>{mins > 0 ? `${mins} min` : "—"}</span>
          <span>👍 {r.upvotes}</span>
        </div>
        {r.diet_tags.length > 0 && (
          <div className="flex flex-wrap gap-1">
            {r.diet_tags.slice(0, 3).map((t) => (
              <span key={t} className="rounded-full bg-gray-800 px-2 py-0.5 text-[10px] text-gray-400">
                {t.replace("_", " ")}
              </span>
            ))}
          </div>
        )}
      </div>
    </a>
  );
}

// ── Recipe detail ────────────────────────────────────────────────────────────

const ALL_DIET_TAGS = ["gluten_free","dairy_free","vegan","vegetarian","high_protein","low_carb","nut_free","keto","carnivore","paleo"];

function RecipeDetailView({ slug }: { slug: string }) {
  const [servings, setServings] = useState<number | null>(null);
  const [voting, setVoting] = useState(false);
  const [editing, setEditing] = useState(false);
  const [saving, setSaving] = useState(false);
  const [deleting, setDeleting] = useState(false);

  // Edit form state
  const [editTitle, setEditTitle]       = useState("");
  const [editDesc, setEditDesc]         = useState("");
  const [editImage, setEditImage]       = useState("");
  const [editPrep, setEditPrep]         = useState("");
  const [editCook, setEditCook]         = useState("");
  const [editServings, setEditServings] = useState("");
  const [editDiets, setEditDiets]       = useState<string[]>([]);
  const [editIngredients, setEditIngredients] = useState("");
  const [editSteps, setEditSteps]       = useState("");

  const { data: recipe, mutate, isLoading } = useSWR<RecipeDetail>(
    `/recipes/${slug}`,
    (url: string) => api.get<RecipeDetail>(url)
  );

  const userId = typeof window !== "undefined" ? getUserId() : null;
  const isAdmin = userId === 1;
  const isOwner = recipe ? (isAdmin || recipe.author_id === userId) : false;

  function getUserId(): number | null {
    const token = localStorage.getItem("rh_token");
    if (!token) return null;
    try {
      const p = JSON.parse(atob(token.split(".")[1]));
      return parseInt(p.sub);
    } catch { return null; }
  }

  function startEdit() {
    if (!recipe) return;
    setEditTitle(recipe.title);
    setEditDesc(recipe.description ?? "");
    setEditImage(recipe.image_url ?? "");
    setEditPrep(recipe.prep_minutes?.toString() ?? "");
    setEditCook(recipe.cook_minutes?.toString() ?? "");
    setEditServings(recipe.servings.toString());
    setEditDiets(recipe.diet_tags ?? []);
    setEditIngredients(recipe.ingredients.map(i =>
      `${i.quantity != null ? i.quantity : ""}${i.unit ? " " + i.unit : ""} ${i.name}${i.note ? ", " + i.note : ""}`.trim()
    ).join("\n"));
    setEditSteps(recipe.steps.map(s => s.body).join("\n\n"));
    setEditing(true);
  }

  async function saveEdit() {
    if (!recipe) return;
    setSaving(true);
    try {
      const ingredients = editIngredients.split("\n").filter(Boolean).map(line => ({ name: line.trim() }));
      const steps = editSteps.split(/\n\n+/).filter(Boolean).map(s => ({ body: s.trim() }));
      const updated = await api.put<RecipeDetail>(`/recipes/${recipe.slug}`, {
        title:       editTitle,
        description: editDesc || null,
        image_url:   editImage || null,
        prep_minutes: editPrep ? parseInt(editPrep) : null,
        cook_minutes: editCook ? parseInt(editCook) : null,
        servings:    parseInt(editServings) || 4,
        diet_tags:   editDiets,
        ingredients,
        steps,
      });
      await mutate(updated as any, false);
      setEditing(false);
      // If slug changed, navigate to new URL
      if ((updated as any).slug !== recipe.slug) {
        window.location.href = `/recipes/${(updated as any).slug}`;
      }
    } catch (e: any) {
      alert(e.message);
    } finally {
      setSaving(false);
    }
  }

  async function deleteRecipe() {
    if (!recipe || !confirm(`Delete "${recipe.title}"? This cannot be undone.`)) return;
    setDeleting(true);
    try {
      await api.delete(`/recipes/${recipe.slug}`);
      window.location.href = "/recipes";
    } catch (e: any) {
      alert(e.message);
      setDeleting(false);
    }
  }

  async function vote(value: 1 | -1) {
    if (!recipe || voting) return;
    setVoting(true);
    try {
      await api.post(`/recipes/${recipe.slug}/rate`, { value });
      mutate();
    } catch { } finally { setVoting(false); }
  }

  async function fork() {
    if (!recipe) return;
    if (!localStorage.getItem("rh_token")) {
      alert("Sign in to fork recipes.");
      return;
    }
    try {
      const forked = await api.post<RecipeDetail>(`/recipes/${recipe.slug}/fork`, {});
      window.location.href = `/recipes/${(forked as any).slug}`;
    } catch (e: any) { alert(e.message); }
  }

  if (isLoading) return <p className="py-20 text-center text-gray-500">Loading…</p>;
  if (!recipe)   return <p className="py-20 text-center text-gray-500">Recipe not found.</p>;

  const scale = (servings ?? recipe.servings) / recipe.servings;
  const totalMins = (recipe.prep_minutes ?? 0) + (recipe.cook_minutes ?? 0);

  // ── Edit mode ──────────────────────────────────────────────────────────────
  if (editing) {
    return (
      <div className="mx-auto max-w-3xl">
        <div className="mb-6 flex items-center justify-between">
          <h1 className="text-2xl font-extrabold">Edit Recipe</h1>
          <button onClick={() => setEditing(false)} className="text-sm text-gray-500 hover:text-white">✕ Cancel</button>
        </div>
        <div className="flex flex-col gap-4">
          <div className="grid gap-4 sm:grid-cols-2">
            <div className="flex flex-col gap-1">
              <label className="text-xs text-gray-400">Title</label>
              <input value={editTitle} onChange={e => setEditTitle(e.target.value)}
                className="rounded-lg border border-gray-700 bg-gray-900 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500" />
            </div>
            <div className="flex flex-col gap-1">
              <label className="text-xs text-gray-400">Image URL</label>
              <input value={editImage} onChange={e => setEditImage(e.target.value)}
                className="rounded-lg border border-gray-700 bg-gray-900 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500" />
            </div>
            <div className="flex flex-col gap-1">
              <label className="text-xs text-gray-400">Prep (mins)</label>
              <input type="number" value={editPrep} onChange={e => setEditPrep(e.target.value)}
                className="rounded-lg border border-gray-700 bg-gray-900 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500" />
            </div>
            <div className="flex flex-col gap-1">
              <label className="text-xs text-gray-400">Cook (mins)</label>
              <input type="number" value={editCook} onChange={e => setEditCook(e.target.value)}
                className="rounded-lg border border-gray-700 bg-gray-900 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500" />
            </div>
            <div className="flex flex-col gap-1">
              <label className="text-xs text-gray-400">Servings</label>
              <input type="number" value={editServings} onChange={e => setEditServings(e.target.value)}
                className="rounded-lg border border-gray-700 bg-gray-900 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500" />
            </div>
          </div>

          <div className="flex flex-col gap-1">
            <label className="text-xs text-gray-400">Description</label>
            <textarea rows={2} value={editDesc} onChange={e => setEditDesc(e.target.value)}
              className="rounded-lg border border-gray-700 bg-gray-900 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500" />
          </div>

          <div className="flex flex-col gap-2">
            <label className="text-xs text-gray-400">Dietary tags</label>
            <div className="flex flex-wrap gap-2">
              {ALL_DIET_TAGS.map(tag => (
                <button key={tag} type="button"
                  onClick={() => setEditDiets(d => d.includes(tag) ? d.filter(x => x !== tag) : [...d, tag])}
                  className={`rounded-full px-3 py-1 text-xs font-medium transition ${editDiets.includes(tag) ? "bg-brand-500 text-white" : "bg-gray-800 text-gray-400 hover:bg-gray-700"}`}>
                  {tag.replace(/_/g, " ")}
                </button>
              ))}
            </div>
          </div>

          <div className="flex flex-col gap-1">
            <label className="text-xs text-gray-400">Ingredients (one per line)</label>
            <textarea rows={8} value={editIngredients} onChange={e => setEditIngredients(e.target.value)}
              className="rounded-lg border border-gray-700 bg-gray-900 px-3 py-2 font-mono text-sm focus:outline-none focus:ring-2 focus:ring-brand-500" />
          </div>

          <div className="flex flex-col gap-1">
            <label className="text-xs text-gray-400">Steps (separate with a blank line)</label>
            <textarea rows={10} value={editSteps} onChange={e => setEditSteps(e.target.value)}
              className="rounded-lg border border-gray-700 bg-gray-900 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500" />
          </div>

          <div className="flex gap-3 pt-2">
            <button onClick={saveEdit} disabled={saving}
              className="rounded-lg bg-brand-500 px-6 py-2.5 text-sm font-semibold text-white hover:bg-brand-600 disabled:opacity-50">
              {saving ? "Saving…" : "Save changes"}
            </button>
            <button onClick={() => setEditing(false)}
              className="rounded-lg bg-gray-800 px-6 py-2.5 text-sm hover:bg-gray-700">
              Cancel
            </button>
          </div>
        </div>
      </div>
    );
  }

  // ── View mode ──────────────────────────────────────────────────────────────
  return (
    <div className="mx-auto max-w-3xl">
      <a href="/recipes" className="mb-4 inline-block text-sm text-gray-500 hover:text-white">← Back</a>

      {recipe.image_url ? (
        <img src={recipe.image_url} alt={recipe.title} className="mb-6 h-64 w-full rounded-xl object-cover" />
      ) : (
        <div className="mb-6 flex h-64 items-center justify-center rounded-xl bg-gray-800 text-7xl">🍽️</div>
      )}

      <div className="mb-6">
        <h1 className="mb-2 text-3xl font-extrabold">{recipe.title}</h1>
        {recipe.description && <p className="mb-4 text-gray-400">{recipe.description}</p>}
        <div className="flex flex-wrap items-center gap-4 text-sm text-gray-400">
          {recipe.prep_minutes != null && <span>Prep: <strong className="text-white">{recipe.prep_minutes} min</strong></span>}
          {recipe.cook_minutes != null && <span>Cook: <strong className="text-white">{recipe.cook_minutes} min</strong></span>}
          {totalMins > 0 && <span>Total: <strong className="text-white">{totalMins} min</strong></span>}
          {recipe.source_url && (
            <a href={recipe.source_url} target="_blank" rel="noopener noreferrer" className="ml-auto text-brand-500 hover:underline">
              Original source ↗
            </a>
          )}
        </div>
        {recipe.diet_tags.length > 0 && (
          <div className="mt-3 flex flex-wrap gap-1.5">
            {recipe.diet_tags.map(t => (
              <span key={t} className="rounded-full bg-gray-800 px-2.5 py-1 text-xs text-gray-300">
                {t.replace(/_/g, " ")}
              </span>
            ))}
          </div>
        )}
      </div>

      <div className="mb-8 flex flex-wrap items-center gap-3">
        <button onClick={() => vote(1)} disabled={voting} className="flex items-center gap-1.5 rounded-lg bg-gray-800 px-4 py-2 text-sm hover:bg-gray-700 disabled:opacity-50">
          👍 <span>{recipe.upvotes}</span>
        </button>
        <button onClick={() => vote(-1)} disabled={voting} className="flex items-center gap-1.5 rounded-lg bg-gray-800 px-4 py-2 text-sm hover:bg-gray-700 disabled:opacity-50">
          👎 <span>{recipe.downvotes}</span>
        </button>
        {localStorage.getItem("rh_token") && (
          <button onClick={fork} className="rounded-lg bg-gray-800 px-4 py-2 text-sm hover:bg-gray-700">
            🍴 Fork & edit
          </button>
        )}
        {isOwner && (
          <>
            <button onClick={startEdit} className="rounded-lg bg-gray-800 px-4 py-2 text-sm hover:bg-gray-700">
              ✏️ Edit
            </button>
            <button onClick={deleteRecipe} disabled={deleting}
              className="rounded-lg bg-red-900/50 px-4 py-2 text-sm text-red-400 hover:bg-red-900 disabled:opacity-50">
              {deleting ? "Deleting…" : "🗑 Delete"}
            </button>
          </>
        )}
        <div className="ml-auto flex items-center gap-2 text-sm">
          <span className="text-gray-400">Servings:</span>
          <button onClick={() => setServings(Math.max(1, (servings ?? recipe.servings) - 1))} className="rounded bg-gray-800 px-2 py-1 hover:bg-gray-700">−</button>
          <span className="w-6 text-center font-semibold">{servings ?? recipe.servings}</span>
          <button onClick={() => setServings((servings ?? recipe.servings) + 1)} className="rounded bg-gray-800 px-2 py-1 hover:bg-gray-700">+</button>
        </div>
      </div>

      <div className="grid gap-8 md:grid-cols-[1fr_2fr]">
        <section>
          <h2 className="mb-3 text-lg font-bold">Ingredients</h2>
          <ul className="space-y-2">
            {recipe.ingredients.map(ing => {
              const qty = ing.quantity != null ? +(ing.quantity * scale).toFixed(2) : null;
              return (
                <li key={ing.id} className="flex gap-2 text-sm">
                  <span className="w-16 shrink-0 text-right text-gray-400">
                    {qty != null ? `${qty}${ing.unit ? ` ${ing.unit}` : ""}` : ""}
                  </span>
                  <span>{ing.name}{ing.note && <span className="text-gray-500">, {ing.note}</span>}</span>
                </li>
              );
            })}
          </ul>
        </section>
        <section>
          <h2 className="mb-3 text-lg font-bold">Method</h2>
          <ol className="space-y-5">
            {recipe.steps.map(step => (
              <li key={step.id} className="flex gap-3">
                <span className="mt-0.5 flex h-6 w-6 shrink-0 items-center justify-center rounded-full bg-brand-500 text-xs font-bold text-white">
                  {step.position}
                </span>
                <div>
                  <p className="text-sm leading-relaxed">{step.body}</p>
                  {step.timer_mins && <span className="mt-1 inline-block text-xs text-gray-500">⏱ {step.timer_mins} min</span>}
                  {step.image_url && <img src={step.image_url} alt={`Step ${step.position}`} className="mt-2 rounded-lg" />}
                </div>
              </li>
            ))}
          </ol>
        </section>
      </div>
    </div>
  );
}
