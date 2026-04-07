"use client";
import { useState, useEffect, useRef } from "react";
import { usePathname } from "next/navigation";
import useSWR, { mutate } from "swr";
import { api } from "@/lib/api";
import HealthProfile from "@/components/HealthProfile";
import AIAssistant from "@/components/AIAssistant";

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
  author_username: string | null;
  author_display_name: string | null;
  author_role?: string;
  source: string;
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

  if (slug === "admin") {
    return <AdminDashboardView />;
  }
  if (slug && slug.startsWith("user/")) {
    return <UserProfileView username={slug.slice(5)} />;
  }
  if (slug && !["planner", "pantry", "login"].includes(slug)) {
    return <RecipeDetailView slug={slug} />;
  }
  return <RecipeList />;
}

function RoleBadge({ role }: { role?: string }) {
  if (!role || role === "user") return null;
  const map: Record<string, { label: string; icon: string; color: string }> = {
    vip: { label: "VIP", icon: "💎", color: "text-purple-400 bg-purple-400/10 border-purple-400/20" },
    verified_chef: { label: "Chef", icon: "👨‍🍳", color: "text-amber-400 bg-amber-400/10 border-amber-400/20" },
    moderator: { label: "Mod", icon: "🛡️", color: "text-blue-400 bg-blue-400/10 border-blue-400/20" },
    admin: { label: "Admin", icon: "💎", color: "text-brand-400 bg-brand-400/10 border-brand-400/20" },
  };
  const cfg = map[role];
  if (!cfg) return null;
  return (
    <span className={`inline-flex items-center gap-1 rounded-full border px-2 py-0.5 text-[10px] font-bold ${cfg.color}`}>
      {cfg.icon} {cfg.label}
    </span>
  );
}

// ── Recipe list ──────────────────────────────────────────────────────────────

const PAGE_SIZE = 40;

function RecipeList() {
  const [sort, setSort] = useState<(typeof SORTS)[number]>("trending");
  const [diet, setDiet] = useState("");
  const [q, setQ] = useState("");
  const [search, setSearch] = useState("");
  const [creating, setCreating] = useState(false);
  const [page, setPage] = useState(0);
  const [isLoggedIn, setIsLoggedIn] = useState(false);

  // Autocomplete state
  const [suggestions, setSuggestions] = useState<Recipe[]>([]);
  const [showSuggestions, setShowSuggestions] = useState(false);
  const suggestTimer = useRef<ReturnType<typeof setTimeout> | null>(null);
  const searchBoxRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    setIsLoggedIn(!!localStorage.getItem("rh_token"));
  }, []);

  // Close suggestions on outside click
  useEffect(() => {
    function handleClick(e: MouseEvent) {
      if (searchBoxRef.current && !searchBoxRef.current.contains(e.target as Node)) {
        setShowSuggestions(false);
      }
    }
    document.addEventListener("mousedown", handleClick);
    return () => document.removeEventListener("mousedown", handleClick);
  }, []);

  // Live suggestions as user types
  function handleInputChange(val: string) {
    setQ(val);
    if (!val.trim()) {
      // Clear search → back to all recipes
      setSearch("");
      setPage(0);
      setSuggestions([]);
      setShowSuggestions(false);
      return;
    }
    if (suggestTimer.current) clearTimeout(suggestTimer.current);
    suggestTimer.current = setTimeout(async () => {
      try {
        const res = await api.get<Recipe[]>(`/recipes?q=${encodeURIComponent(val.trim())}&limit=6&sort=trending`);
        setSuggestions(Array.isArray(res) ? res : []);
        setShowSuggestions(true);
      } catch {
        setSuggestions([]);
      }
    }, 250);
  }

  // Reset to page 0 whenever filters change
  function changeFilter(fn: () => void) { fn(); setPage(0); }

  const swrKey = `/recipes?sort=${sort}&limit=${PAGE_SIZE}&offset=${page * PAGE_SIZE}${search ? `&q=${encodeURIComponent(search)}` : ""}${diet ? `&diet=${diet}` : ""}`;
  const { data: recipes, isLoading } = useSWR<Recipe[]>(
    swrKey,
    (url: string) => api.get<Recipe[]>(url.replace("/recipes/api", ""))
  );

  function commitSearch(term: string) {
    setQ(term);
    setSearch(term);
    setPage(0);
    setShowSuggestions(false);
  }

  function handleKeyDown(e: React.KeyboardEvent) {
    if (e.key === "Enter") { if (q.trim()) commitSearch(q.trim()); }
    if (e.key === "Escape") setShowSuggestions(false);
  }

  return (
    <div>
      <section className="mb-10 text-center">
        <h1 className="mb-2 text-4xl font-extrabold tracking-tight">
          Find your next favourite meal
        </h1>
        <p className="text-gray-400">
          Search from 5,000+ recipes or create your own.
        </p>
      </section>

      <div className="mb-2 flex flex-col gap-3 sm:flex-row">
        {/* Search box with dropdown */}
        <div ref={searchBoxRef} className="relative flex-1">
          <div className="flex">
            <input
              className="flex-1 rounded-l-lg border border-gray-700 bg-gray-900 px-4 py-2.5 text-sm placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-brand-500"
              placeholder="Search recipes…"
              value={q}
              onChange={(e) => handleInputChange(e.target.value)}
              onKeyDown={handleKeyDown}
              onFocus={() => suggestions.length > 0 && setShowSuggestions(true)}
              autoComplete="off"
            />
            {q && (
              <button
                onClick={() => { setQ(""); setSearch(""); setPage(0); setSuggestions([]); setShowSuggestions(false); }}
                className="border border-l-0 border-gray-700 bg-gray-900 px-3 text-gray-500 hover:text-white"
                title="Clear"
              >
                ✕
              </button>
            )}
            <button
              onClick={() => q.trim() && commitSearch(q.trim())}
              disabled={!q.trim()}
              className="rounded-r-lg bg-brand-500 px-5 py-2.5 text-sm font-semibold text-white hover:bg-brand-600 disabled:opacity-50 whitespace-nowrap"
            >
              Search
            </button>
          </div>

          {/* Autocomplete dropdown */}
          {showSuggestions && suggestions.length > 0 && (
            <ul className="absolute left-0 right-0 top-full z-40 mt-1 overflow-hidden rounded-xl border border-gray-700 bg-gray-900 shadow-xl">
              {suggestions.map((r) => (
                <li key={r.id}>
                  <button
                    onMouseDown={(e) => { e.preventDefault(); commitSearch(r.title); window.location.href = `/recipes/${r.slug}`; }}
                    className="flex w-full items-center gap-3 px-4 py-2.5 text-left hover:bg-gray-800"
                  >
                    {r.image_url
                      ? <img src={r.image_url} alt="" className="h-9 w-9 rounded-lg object-cover shrink-0" />
                      : <span className="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg bg-gray-800 text-lg">🍽️</span>
                    }
                    <div className="min-w-0">
                      <div className="truncate text-sm font-medium">{r.title}</div>
                      {r.diet_tags.length > 0 && (
                        <div className="text-xs text-gray-500">{r.diet_tags.slice(0, 2).map(t => t.replace(/_/g, " ")).join(" · ")}</div>
                      )}
                    </div>
                  </button>
                </li>
              ))}
              <li>
                <button
                  onMouseDown={(e) => { e.preventDefault(); commitSearch(q.trim()); }}
                  className="flex w-full items-center gap-2 border-t border-gray-800 px-4 py-2.5 text-sm text-brand-400 hover:bg-gray-800"
                >
                  <span>🔍</span> See all results for "<span className="font-medium">{q}</span>"
                </button>
              </li>
            </ul>
          )}
        </div>

        <div className="flex gap-2">
          {SORTS.map((s) => (
            <button
              key={s}
              onClick={() => changeFilter(() => setSort(s))}
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
      {/* Diet filters + Create button */}
      <div className="mb-4 flex flex-wrap items-center justify-between gap-2">
        <div className="flex flex-wrap gap-2">
        <button
          onClick={() => changeFilter(() => setDiet(""))}
          className={`rounded-full px-3 py-1 text-xs font-medium transition ${
            !diet ? "bg-brand-500 text-white" : "bg-gray-800 text-gray-400 hover:bg-gray-700 hover:text-white"
          }`}
        >
          All
        </button>
        {DIETS.map((d) => (
          <button
            key={d.key}
            onClick={() => changeFilter(() => setDiet(diet === d.key ? "" : d.key))}
            className={`rounded-full px-3 py-1 text-xs font-medium transition ${
              diet === d.key ? "bg-brand-500 text-white" : "bg-gray-800 text-gray-400 hover:bg-gray-700 hover:text-white"
            }`}
          >
            {d.label}
          </button>
        ))}
        </div>
        {isLoggedIn && (
          <button
            onClick={() => setCreating(true)}
            className="rounded-lg bg-brand-500 px-4 py-2 text-sm font-semibold text-white hover:bg-brand-600 whitespace-nowrap"
          >
            + Create recipe
          </button>
        )}
      </div>

      {creating && (
        <CreateRecipeForm
          onClose={() => setCreating(false)}
          onCreated={(slug) => { window.location.href = `/recipes/${slug}`; }}
        />
      )}

      {isLoading ? (
        <p className="text-center text-gray-500">Loading…</p>
      ) : (
        <>
          <div className="grid gap-5 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
            {recipes?.map((r) => <RecipeCard key={r.id} recipe={r} />)}
            {recipes?.length === 0 && (
              <p className="col-span-full text-center text-gray-500">
                No recipes found.
              </p>
            )}
          </div>
          {/* Pagination */}
          {(recipes?.length === PAGE_SIZE || page > 0) && (
            <div className="mt-8 flex items-center justify-center gap-2">
              <button
                disabled={page === 0}
                onClick={() => { setPage(p => p - 1); window.scrollTo(0, 0); }}
                className="rounded-lg bg-gray-800 px-4 py-2 text-sm hover:bg-gray-700 disabled:opacity-40"
              >
                ← Prev
              </button>
              <span className="px-3 text-sm text-gray-400">Page {page + 1}</span>
              <button
                disabled={!recipes || recipes.length < PAGE_SIZE}
                onClick={() => { setPage(p => p + 1); window.scrollTo(0, 0); }}
                className="rounded-lg bg-gray-800 px-4 py-2 text-sm hover:bg-gray-700 disabled:opacity-40"
              >
                Next →
              </button>
            </div>
          )}
        </>
      )}
    </div>
  );
}

// ── Create Recipe Form ───────────────────────────────────────────────────────

function CreateRecipeForm({ onClose, onCreated }: { onClose: () => void; onCreated: (slug: string) => void }) {
  const [title, setTitle]       = useState("");
  const [desc, setDesc]         = useState("");
  const [image, setImage]       = useState("");
  const [prep, setPrep]         = useState("");
  const [cook, setCook]         = useState("");
  const [servings, setServings] = useState("4");
  const [diets, setDiets]       = useState<string[]>([]);
  const [ingredients, setIngredients] = useState("");
  const [steps, setSteps]       = useState("");
  const [saving, setSaving]     = useState(false);

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    if (!title.trim()) return;
    setSaving(true);
    try {
      const body = {
        title: title.trim(),
        description: desc.trim() || null,
        image_url: image.trim() || null,
        prep_minutes: prep ? parseInt(prep) : null,
        cook_minutes: cook ? parseInt(cook) : null,
        servings: parseInt(servings) || 4,
        diet_tags: diets,
        ingredients: ingredients.split("\n").filter(Boolean).map(line => ({ name: line.trim() })),
        steps: steps.split(/\n\n+/).filter(Boolean).map(s => ({ body: s.trim() })),
      };
      const created = await api.post<{ slug: string }>("/recipes", body);
      onCreated((created as any).slug);
    } catch (e: any) {
      alert(e.message);
    } finally {
      setSaving(false);
    }
  }

  return (
    <div className="fixed inset-0 z-50 flex items-start justify-center overflow-y-auto bg-black/70 p-4 pt-10" onClick={onClose}>
      <div className="w-full max-w-2xl rounded-2xl border border-gray-700 bg-gray-950 p-6" onClick={e => e.stopPropagation()}>
        <div className="mb-5 flex items-center justify-between">
          <h2 className="text-xl font-extrabold">Create Recipe</h2>
          <button onClick={onClose} className="text-sm text-gray-500 hover:text-white">✕ Cancel</button>
        </div>
        <form onSubmit={submit} className="flex flex-col gap-4">
          <div className="grid gap-4 sm:grid-cols-2">
            <div className="flex flex-col gap-1 sm:col-span-2">
              <label className="text-xs text-gray-400">Title *</label>
              <input required value={title} onChange={e => setTitle(e.target.value)}
                placeholder="e.g. Garlic Butter Steak"
                className="rounded-lg border border-gray-700 bg-gray-900 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500" />
            </div>
            <div className="flex flex-col gap-1 sm:col-span-2">
              <label className="text-xs text-gray-400">Image URL</label>
              <input value={image} onChange={e => setImage(e.target.value)}
                placeholder="https://…"
                className="rounded-lg border border-gray-700 bg-gray-900 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500" />
            </div>
            <div className="flex flex-col gap-1">
              <label className="text-xs text-gray-400">Prep time (mins)</label>
              <input type="number" min="0" value={prep} onChange={e => setPrep(e.target.value)}
                className="rounded-lg border border-gray-700 bg-gray-900 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500" />
            </div>
            <div className="flex flex-col gap-1">
              <label className="text-xs text-gray-400">Cook time (mins)</label>
              <input type="number" min="0" value={cook} onChange={e => setCook(e.target.value)}
                className="rounded-lg border border-gray-700 bg-gray-900 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500" />
            </div>
            <div className="flex flex-col gap-1">
              <label className="text-xs text-gray-400">Servings</label>
              <input type="number" min="1" value={servings} onChange={e => setServings(e.target.value)}
                className="rounded-lg border border-gray-700 bg-gray-900 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500" />
            </div>
          </div>

          <div className="flex flex-col gap-1">
            <label className="text-xs text-gray-400">Description</label>
            <textarea rows={2} value={desc} onChange={e => setDesc(e.target.value)}
              className="rounded-lg border border-gray-700 bg-gray-900 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500" />
          </div>

          <div className="flex flex-col gap-2">
            <label className="text-xs text-gray-400">Dietary tags <span className="text-gray-600">(select all that apply)</span></label>
            <div className="flex flex-wrap gap-2">
              {ALL_DIET_TAGS.map(tag => (
                <button key={tag} type="button"
                  onClick={() => setDiets(d => d.includes(tag) ? d.filter(x => x !== tag) : [...d, tag])}
                  className={`rounded-full px-3 py-1 text-xs font-medium transition ${diets.includes(tag) ? "bg-brand-500 text-white" : "bg-gray-800 text-gray-400 hover:bg-gray-700"}`}>
                  {tag.replace(/_/g, " ")}
                </button>
              ))}
            </div>
          </div>

          <div className="flex flex-col gap-1">
            <label className="text-xs text-gray-400">Ingredients <span className="text-gray-600">(one per line, e.g. "2 cups flour")</span></label>
            <textarea rows={8} value={ingredients} onChange={e => setIngredients(e.target.value)}
              placeholder={"500g chicken breast\n2 tbsp olive oil\n3 cloves garlic\nsalt and pepper"}
              className="rounded-lg border border-gray-700 bg-gray-900 px-3 py-2 font-mono text-sm focus:outline-none focus:ring-2 focus:ring-brand-500" />
          </div>

          <div className="flex flex-col gap-1">
            <label className="text-xs text-gray-400">Steps <span className="text-gray-600">(separate steps with a blank line)</span></label>
            <textarea rows={8} value={steps} onChange={e => setSteps(e.target.value)}
              placeholder={"Preheat oven to 200°C.\n\nSeason chicken with salt, pepper, and garlic.\n\nBake for 25 minutes until golden."}
              className="rounded-lg border border-gray-700 bg-gray-900 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500" />
          </div>

          <div className="flex gap-3 pt-2">
            <button type="submit" disabled={saving}
              className="rounded-lg bg-brand-500 px-6 py-2.5 text-sm font-semibold text-white hover:bg-brand-600 disabled:opacity-50">
              {saving ? "Creating…" : "Create recipe"}
            </button>
            <button type="button" onClick={onClose}
              className="rounded-lg bg-gray-800 px-6 py-2.5 text-sm hover:bg-gray-700">
              Cancel
            </button>
          </div>
        </form>
      </div>

    </div>
  );
}

// ── Comments ──────────────────────────────────────────────────────────────────

interface Comment {
  id: number;
  body: string;
  created_at: string;
  user: { id: number; username: string; display_name: string; avatar_url: string | null; role?: string };
}

function CommentsSection({ slug }: { slug: string }) {
  const { data: comments, mutate } = useSWR<Comment[]>(
    `/recipes/${slug}/comments`,
    (url: string) => api.get<Comment[]>(url)
  );
  const [body, setBody] = useState("");
  const [posting, setPosting] = useState(false);
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [myUsername, setMyUsername] = useState<string | null>(null);
  const [isAdmin, setIsAdmin] = useState(false);

  useEffect(() => {
    setIsLoggedIn(!!localStorage.getItem("rh_token"));
    setMyUsername(localStorage.getItem("rh_username"));
    try {
      const token = localStorage.getItem("rh_token");
      if (token) setIsAdmin(parseInt(JSON.parse(atob(token.split(".")[1])).sub) === 1);
    } catch {}
  }, []);

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    if (!body.trim()) return;
    setPosting(true);
    try {
      await api.post(`/recipes/${slug}/comments`, { body: body.trim() });
      setBody("");
      mutate();
    } catch (e: any) { alert(e.message); }
    finally { setPosting(false); }
  }

  async function deleteComment(id: number) {
    await api.delete(`/recipes/${slug}/comments/${id}`);
    mutate();
  }

  return (
    <section className="mt-12 border-t border-gray-800 pt-8">
      <h2 className="mb-6 text-xl font-bold">Comments {comments?.length ? `(${comments.length})` : ""}</h2>
      {isLoggedIn ? (
        <form onSubmit={submit} className="mb-8 flex flex-col gap-2">
          <textarea
            rows={3}
            value={body}
            onChange={e => setBody(e.target.value)}
            placeholder="Leave a comment…"
            className="w-full rounded-xl border border-gray-700 bg-gray-900 px-4 py-3 text-sm placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-brand-500"
          />
          <div className="flex justify-end">
            <button type="submit" disabled={posting || !body.trim()}
              className="rounded-lg bg-brand-500 px-5 py-2 text-sm font-semibold text-white hover:bg-brand-600 disabled:opacity-50">
              {posting ? "Posting…" : "Post comment"}
            </button>
          </div>
        </form>
      ) : (
        <p className="mb-6 text-sm text-gray-500">
          <a href="/recipes/login" className="text-brand-400 hover:underline">Sign in</a> to leave a comment.
        </p>
      )}
      <div className="space-y-5">
        {comments?.map(c => (
          <div key={c.id} className="flex gap-3">
            <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-full bg-gray-800 text-sm font-bold text-gray-300">
              {c.user.display_name?.[0]?.toUpperCase() ?? "?"}
            </div>
            <div className="flex-1">
              <div className="flex items-baseline gap-2">
                <a href={`/recipes/user/${c.user.username}`} className="text-sm font-semibold hover:text-brand-400">
                  {c.user.display_name || c.user.username}
                </a>
                <RoleBadge role={c.user.role} />
                <span className="text-xs text-gray-600">
                  {/* Custom override for @Nev (User ID 1) - Dawn of Time */}
                  {c.user.username === "Nev" || c.user.id === 1 ? "The Dawn of Time" : new Date(c.created_at).toLocaleDateString()}
                </span>
                {(c.user.username === myUsername || isAdmin) && (
                  <button onClick={() => deleteComment(c.id)} className="ml-auto text-xs text-gray-600 hover:text-red-400">✕</button>
                )}
              </div>
              <p className="mt-1 text-sm text-gray-300">{c.body}</p>
            </div>
          </div>
        ))}
        {comments?.length === 0 && <p className="text-sm text-gray-600">No comments yet. Be the first!</p>}
      </div>
    </section>
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

const ALL_DIET_TAGS = ["keto","carnivore","vegan","vegetarian","paleo","high_protein","low_carb","gluten_free","dairy_free","nut_free"];

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

  // Auto-open edit mode when navigated with ?edit=1 (e.g. after fork)
  useEffect(() => {
    if (!recipe || !isOwner) return;
    const params = new URLSearchParams(window.location.search);
    if (params.get("edit") === "1") {
      window.history.replaceState({}, "", window.location.pathname);
      startEdit();
    }
  }, [recipe, isOwner]);

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
      const payload = {
        title:       editTitle,
        description: editDesc || null,
        image_url:   editImage || null,
        prep_minutes: editPrep ? parseInt(editPrep) : null,
        cook_minutes: editCook ? parseInt(editCook) : null,
        servings:    parseInt(editServings) || 4,
        diet_tags:   editDiets,
        ingredients,
        steps,
      };

      if (!isOwner && recipe.source === "scraped") {
        await api.post(`/recipes/${recipe.slug}/suggest-edit`, payload);
        setEditing(false);
        alert("Edit suggestion submitted for review!");
        return;
      }

      const updated = await api.put<RecipeDetail>(`/recipes/${recipe.slug}`, payload);
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
      // Navigate with ?edit=1 so the fork lands directly in edit mode
      window.location.href = `/recipes/${(forked as any).slug}?edit=1`;
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
      <div className="mb-4 flex items-center justify-between">
        <a href="/recipes" className="text-sm text-gray-500 hover:text-white">← Back</a>
        {isAdmin && (
          <a href="/recipes/admin" className="rounded-lg bg-brand-500/10 px-3 py-1 text-xs font-bold text-brand-400 border border-brand-500/20 hover:bg-brand-500/20">
            🛡️ Admin Panel
          </a>
        )}
      </div>

      {recipe.image_url ? (
        <img src={recipe.image_url} alt={recipe.title} className="mb-6 h-64 w-full rounded-xl object-cover" />
      ) : (
        <div className="mb-6 flex h-64 items-center justify-center rounded-xl bg-gray-800 text-7xl">🍽️</div>
      )}

      <div className="mb-6">
        <h1 className="mb-2 text-3xl font-extrabold">{recipe.title}</h1>
        {recipe.author_username && (
          <p className="mb-3 text-sm text-gray-500">
            By{" "}
            <a
              href={`/recipes/user/${recipe.author_username}`}
              className="font-medium text-brand-400 hover:underline"
            >
              {recipe.author_display_name || recipe.author_username}
            </a>
            <RoleBadge role={recipe.author_role} />
          </p>
        )}
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
        {isOwner ? (
          <>
            <button onClick={startEdit} className="rounded-lg bg-gray-800 px-4 py-2 text-sm hover:bg-gray-700">
              ✏️ Edit
            </button>
            <button onClick={deleteRecipe} disabled={deleting}
              className="rounded-lg bg-red-900/50 px-4 py-2 text-sm text-red-400 hover:bg-red-900 disabled:opacity-50">
              {deleting ? "Deleting…" : "🗑 Delete"}
            </button>
          </>
        ) : (recipe.source === "scraped" && userId) ? (
          <button onClick={startEdit} className="rounded-lg bg-gray-800 px-4 py-2 text-sm text-brand-400 hover:bg-gray-700 font-medium">
            💡 Suggest Edit
          </button>
        ) : null}
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

      {/* Print recipe card button */}
      <div className="mt-8 flex justify-end">
        <button
          onClick={() => window.print()}
          className="rounded-lg border border-gray-700 px-4 py-2 text-sm text-gray-400 hover:border-brand-500 hover:text-brand-400"
        >
          🖨️ Print recipe card
        </button>
      </div>

      {/* Comments */}
      <CommentsSection slug={recipe.slug} />

      {isAdmin && <AdminAuthorReassign recipe={recipe} mutate={mutate} />}

      {/* Print-only recipe card */}
      <div className="hidden print:block" id="recipe-print">
        <style>{`
          @media print {
            body * { visibility: hidden; }
            #recipe-print, #recipe-print * { visibility: visible; }
            #recipe-print { position: absolute; top: 0; left: 0; width: 100%; font-family: Georgia, serif; color: #000; padding: 24px; }
            .rp-header { border-bottom: 3px solid #e67e22; padding-bottom: 12px; margin-bottom: 16px; }
            .rp-title { font-size: 28px; font-weight: 700; margin: 0 0 4px; }
            .rp-meta { font-size: 12px; color: #666; margin: 0; }
            .rp-tags { margin-top: 6px; }
            .rp-tag { display: inline-block; background: #fff3e0; color: #e67e22; border: 1px solid #e67e22; border-radius: 20px; padding: 1px 8px; font-size: 10px; margin-right: 4px; text-transform: capitalize; }
            .rp-image { width: 100%; max-height: 220px; object-fit: cover; border-radius: 8px; margin-bottom: 16px; }
            .rp-desc { font-size: 13px; color: #444; margin-bottom: 16px; font-style: italic; }
            .rp-cols { display: grid; grid-template-columns: 1fr 2fr; gap: 24px; }
            .rp-section-title { font-size: 14px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.06em; border-bottom: 2px solid #e67e22; padding-bottom: 4px; margin-bottom: 8px; }
            .rp-ingr-list { list-style: none; padding: 0; margin: 0; font-size: 12px; }
            .rp-ingr-list li { padding: 3px 0; border-bottom: 1px solid #eee; }
            .rp-steps { padding: 0; margin: 0; font-size: 12px; }
            .rp-step { display: flex; gap: 8px; margin-bottom: 10px; }
            .rp-step-num { min-width: 22px; height: 22px; background: #e67e22; color: #fff; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 11px; font-weight: 700; }
            .rp-footer { margin-top: 16px; border-top: 1px solid #ddd; padding-top: 8px; font-size: 10px; color: #999; display: flex; justify-content: space-between; }
          }
        `}</style>
        <div className="rp-header">
          <h1 className="rp-title">{recipe.title}</h1>
          <p className="rp-meta">
            {recipe.prep_minutes != null && `Prep: ${recipe.prep_minutes} min  `}
            {recipe.cook_minutes != null && `Cook: ${recipe.cook_minutes} min  `}
            Serves {recipe.servings}
            {(recipe as any).calories != null && `  ·  ${Math.round((recipe as any).calories)} kcal/serving`}
          </p>
          {recipe.diet_tags.length > 0 && (
            <div className="rp-tags">
              {recipe.diet_tags.map(t => <span key={t} className="rp-tag">{t.replace(/_/g, " ")}</span>)}
            </div>
          )}
        </div>
        {recipe.image_url && <img src={recipe.image_url} alt={recipe.title} className="rp-image" />}
        {recipe.description && <p className="rp-desc">{recipe.description}</p>}
        <div className="rp-cols">
          <div>
            <div className="rp-section-title">Ingredients</div>
            <ul className="rp-ingr-list">
              {recipe.ingredients.map((ing, i) => (
                <li key={i}>
                  {ing.quantity != null ? `${ing.quantity}${ing.unit ? ` ${ing.unit}` : ""} ` : ""}
                  {ing.name}{ing.note ? `, ${ing.note}` : ""}
                </li>
              ))}
            </ul>
          </div>
          <div>
            <div className="rp-section-title">Method</div>
            <ol className="rp-steps">
              {recipe.steps.map(step => (
                <li key={step.id} className="rp-step">
                  <span className="rp-step-num">{step.position}</span>
                  <span>{step.body}</span>
                </li>
              ))}
            </ol>
          </div>
        </div>
        <div className="rp-footer">
          <span>RecipeHub — 0k.au/recipes</span>
          {recipe.author_username && <span>Recipe by {recipe.author_display_name || recipe.author_username}</span>}
          {recipe.source_url && <span>Source: {recipe.source_url}</span>}
        </div>
      </div>
    </div>
  );
}

// ── User Profile ─────────────────────────────────────────────────────────────

const ALL_BADGE_IDS = [
  {"id": "first_recipe",    "name": "First Recipe",       "icon": "🍳", "desc": "Created your first recipe"},
  {"id": "recipe_5",        "name": "Home Cook",          "icon": "👨‍🍳", "desc": "Created 5 recipes"},
  {"id": "recipe_20",       "name": "Chef",               "icon": "🧑‍🍳", "desc": "Created 20 recipes"},
  {"id": "recipe_50",       "name": "Master Chef",        "icon": "⭐", "desc": "Created 50 recipes"},
  {"id": "recipe_100",      "name": "Chef de Cuisine",    "icon": "👨🏼‍🍳", "desc": "Created 100 recipes"},
  {"id": "first_fork",      "name": "Remixer",            "icon": "🍴", "desc": "Forked your first recipe"},
  {"id": "fork_5",          "name": "Recipe Hacker",      "icon": "🔧", "desc": "Forked 5 recipes"},
  {"id": "fork_10",         "name": "Forking Legend",     "icon": "🔱", "desc": "Forked 10 recipes"},
  {"id": "first_upvote",    "name": "Crowd Pleaser",      "icon": "👍", "desc": "Received your first upvote"},
  {"id": "upvotes_10",      "name": "Fan Favourite",      "icon": "🌟", "desc": "Received 10 upvotes"},
  {"id": "upvotes_50",      "name": "Community Star",     "icon": "💫", "desc": "Received 50 upvotes"},
  {"id": "upvotes_100",     "name": "Legend",             "icon": "🏆", "desc": "Received 100 upvotes"},
  {"id": "upvotes_250",     "name": "Michelin Star",      "icon": "🎖️", "desc": "Received 250 upvotes"},
  {"id": "voted_10",        "name": "Critic",             "icon": "🎭", "desc": "Voted on 10 recipes"},
  {"id": "voted_50",        "name": "Food Critic",        "icon": "📝", "desc": "Voted on 50 recipes"},
  {"id": "voted_100",       "name": "Professional Critic","icon": "⚖️", "desc": "Voted on 100 recipes"},
  {"id": "first_comment",   "name": "Conversationalist",  "icon": "💬", "desc": "Left your first comment"},
  {"id": "comment_10",      "name": "Social Butterfly",   "icon": "🦋", "desc": "Left 10 comments"},
  {"id": "comment_50",      "name": "Community Pillar",   "icon": "🏛️", "desc": "Left 50 comments"},
  {"id": "week_1",          "name": "Regular",            "icon": "📅", "desc": "Member for 1 week"},
  {"id": "month_1",         "name": "Loyal Member",       "icon": "🗓️", "desc": "Member for 1 month"},
  {"id": "month_6",         "name": "Veteran",            "icon": "🎖️", "desc": "Member for 6 months"},
  {"id": "year_1",          "name": "Old Timer",          "icon": "🏅", "desc": "Member for 1 year"},
  {"id": "diet_variety",    "name": "Diet Explorer",      "icon": "🌈", "desc": "Tested 3+ diets"},
  {"id": "diet_global",     "name": "Global Taster",      "icon": "🌍", "desc": "Tested 5+ diets"},
  {"id": "healthy_habit",   "name": "Healthy Living",     "icon": "🥗", "desc": "10+ Vegan/Veg recipes"},
  {"id": "pantry_master",   "name": "Pantry Specialist",  "icon": "📦", "desc": "20+ Pantry items"},
  {"id": "meal_architect",  "name": "Meal Architect",     "icon": "🏗️", "desc": "10+ Meal plans"},
  {"id": "alchemist",       "name": "Ingredient Alchemist","icon": "🧪", "desc": "A recipe with 15+ ingredients"},
  {"id": "night_owl",       "name": "Night Owl",          "icon": "🦉", "desc": "Late night cooking (2-5 AM)"},
  // Easter Eggs
  {"id": "logo_fanatic",    "name": "Logo Fanatic",       "icon": "🌀", "desc": "Logo click obsession"},
  {"id": "inside_look",     "name": "The Inspector",      "icon": "👀", "desc": "Web inspector master"},
  {"id": "secret_vault",    "name": "Vault Explorer",     "icon": "🗝️", "desc": "Found the secret vault"},
  {"id": "speed_demon",     "name": "Speed Demon",        "icon": "⚡", "desc": "Fast recipe saving"},
  {"id": "admin",           "name": "Admin",              "icon": "🛡️", "desc": "Site administrator"},
];

interface UserProfile {
  id: number;
  username: string;
  display_name: string;
  avatar_url: string | null;
  bio: string | null;
  manual_badges: string[];
  joined: string | null;
  recipe_count: number;
  total_upvotes: number;
  badges: { id: string; name: string; icon: string; desc: string }[];
}

function UserProfileView({ username }: { username: string }) {
  const { data: profile, error, mutate } = useSWR<UserProfile>(
    `/users/${username}`,
    (url: string) => api.get<UserProfile>(url)
  );
  const { data: userRecipes } = useSWR<Recipe[]>(
    profile ? `/users/${username}/recipes?limit=40` : null,
    (url: string) => api.get<Recipe[]>(url)
  );

  const [editing, setEditing] = useState(false);
  const [editName, setEditName] = useState("");
  const [editAvatar, setEditAvatar] = useState("");
  const [editBio, setEditBio] = useState("");
  const [saving, setSaving] = useState(false);

  const [adminBadges, setAdminBadges] = useState(false);
  const [selectedBadges, setSelectedBadges] = useState<string[]>([]);
  const [savingBadges, setSavingBadges] = useState(false);

  const [myUsername, setMyUsername] = useState<string | null>(null);
  const [isAdmin, setIsAdmin] = useState(false);

  useEffect(() => {
    const u = localStorage.getItem("rh_username");
    setMyUsername(u);
    try {
      const token = localStorage.getItem("rh_token");
      if (token) {
        const payload = JSON.parse(atob(token.split(".")[1]));
        setIsAdmin(parseInt(payload.sub) === 1);
      }
    } catch {}
  }, []);

  const isOwn = myUsername?.toLowerCase() === username.toLowerCase();
  const canEdit = isOwn || isAdmin;

  function startEdit() {
    if (!profile) return;
    setEditName(profile.display_name || "");
    setEditAvatar(profile.avatar_url || "");
    setEditBio(profile.bio || "");
    setEditing(true);
  }

  async function saveProfile(e: React.FormEvent) {
    e.preventDefault();
    setSaving(true);
    try {
      await api.patch(`/users/${username}`, {
        display_name: editName,
        avatar_url: editAvatar,
        bio: editBio,
      });
      mutate();
      setEditing(false);
    } catch (e: any) { alert(e.message); }
    finally { setSaving(false); }
  }

  function openBadgeAdmin() {
    if (!profile) return;
    setSelectedBadges(profile.manual_badges || []);
    setAdminBadges(true);
  }

  async function saveBadges() {
    setSavingBadges(true);
    try {
      await api.put(`/users/${username}/badges`, { badges: selectedBadges });
      mutate();
      setAdminBadges(false);
    } catch (e: any) { alert(e.message); }
    finally { setSavingBadges(false); }
  }

  function toggleBadge(id: string) {
    setSelectedBadges(prev => prev.includes(id) ? prev.filter(x => x !== id) : [...prev, id]);
  }

  if (error) return (
    <div className="min-h-screen bg-gray-950 px-4 py-12 text-center">
      <p className="text-gray-400">User not found.</p>
      <a href="/recipes" className="mt-4 inline-block text-brand-400 hover:underline">← Back to recipes</a>
    </div>
  );

  if (!profile) return (
    <div className="min-h-screen bg-gray-950 px-4 py-12 text-center text-gray-500">Loading…</div>
  );

  const initials = profile.display_name?.slice(0, 2).toUpperCase() ?? "?";

  return (
    <div className="min-h-screen bg-gray-950 text-gray-100">
      <div className="mx-auto max-w-4xl px-4 py-10">
        <a href="/recipes" className="mb-8 inline-flex items-center gap-1 text-sm text-gray-500 hover:text-brand-400">
          ← All Recipes
        </a>

        {/* Edit profile form */}
        {editing ? (
          <form onSubmit={saveProfile} className="mb-10 rounded-2xl border border-gray-700 bg-gray-900 p-6">
            <h2 className="mb-4 text-lg font-bold">Edit Profile</h2>
            <div className="flex flex-col gap-4">
              <div className="flex flex-col gap-1">
                <label className="text-xs text-gray-400">Display name</label>
                <input value={editName} onChange={e => setEditName(e.target.value)} maxLength={120}
                  className="rounded-lg border border-gray-700 bg-gray-950 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500" />
              </div>
              <div className="flex flex-col gap-1">
                <label className="text-xs text-gray-400">Avatar URL</label>
                <input value={editAvatar} onChange={e => setEditAvatar(e.target.value)} placeholder="https://…"
                  className="rounded-lg border border-gray-700 bg-gray-950 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500" />
              </div>
              <div className="flex flex-col gap-1">
                <label className="text-xs text-gray-400">Bio <span className="text-gray-600">(max 500 chars)</span></label>
                <textarea rows={3} value={editBio} onChange={e => setEditBio(e.target.value)} maxLength={500}
                  className="rounded-lg border border-gray-700 bg-gray-950 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500" />
              </div>
              <div className="flex gap-3">
                <button type="submit" disabled={saving}
                  className="rounded-lg bg-brand-500 px-5 py-2 text-sm font-semibold text-white hover:bg-brand-600 disabled:opacity-50">
                  {saving ? "Saving…" : "Save"}
                </button>
                <button type="button" onClick={() => setEditing(false)}
                  className="rounded-lg bg-gray-800 px-5 py-2 text-sm hover:bg-gray-700">
                  Cancel
                </button>
              </div>
            </div>
          </form>
        ) : (
          /* Profile header */
          <div className="flex items-start gap-6 mb-10">
            {profile.avatar_url ? (
              <img src={profile.avatar_url} alt={profile.display_name} className="h-20 w-20 rounded-full object-cover shrink-0" />
            ) : (
              <div className="flex h-20 w-20 shrink-0 items-center justify-center rounded-full bg-brand-500 text-2xl font-bold text-white">
                {initials}
              </div>
            )}
            <div className="flex-1 min-w-0">
              <div className="flex items-center gap-3 flex-wrap">
                <h1 className="text-2xl font-bold">{profile.display_name}</h1>
                {canEdit && (
                  <button onClick={startEdit}
                    className="rounded-lg border border-gray-700 px-3 py-1 text-xs text-gray-400 hover:border-brand-500 hover:text-brand-400">
                    ✏️ Edit profile
                  </button>
                )}
                {isAdmin && (
                  <button onClick={openBadgeAdmin}
                    className="rounded-lg border border-yellow-700 px-3 py-1 text-xs text-yellow-500 hover:border-yellow-500">
                    🛡️ Manage badges
                  </button>
                )}
              </div>
              <p className="text-sm text-gray-500">@{profile.username}</p>
              {profile.joined && (
                <p className="text-xs text-gray-600 mt-1">
                  Member since {profile.id === 1 ? "The Dawn of Time" : new Date(profile.joined).toLocaleDateString("en-AU", { year: "numeric", month: "long" })}
                </p>
              )}
              {profile.bio && <p className="mt-2 text-sm text-gray-300">{profile.bio}</p>}
              <div className="mt-2 flex gap-4 text-sm text-gray-400">
                <span>📖 {profile.recipe_count} recipe{profile.recipe_count !== 1 ? "s" : ""}</span>
                <span>👍 {profile.total_upvotes} upvote{profile.total_upvotes !== 1 ? "s" : ""}</span>
              </div>
            </div>
          </div>
        )}

        {/* Admin badge manager */}
        {adminBadges && (
          <div className="mb-10 rounded-2xl border border-yellow-700 bg-gray-900 p-6">
            <h2 className="mb-1 text-lg font-bold">Manage Badges — {profile.display_name}</h2>
            <p className="mb-4 text-xs text-gray-500">Toggled badges are manually granted (on top of auto-earned ones).</p>
            <div className="grid grid-cols-2 gap-2 sm:grid-cols-3 md:grid-cols-4">
              {ALL_BADGE_IDS.map(b => (
                <button key={b.id} type="button" onClick={() => toggleBadge(b.id)}
                  className={`flex items-center gap-2 rounded-xl border px-3 py-2 text-left text-sm transition ${selectedBadges.includes(b.id) ? "border-yellow-500 bg-yellow-900/30 text-yellow-300" : "border-gray-700 bg-gray-800 text-gray-400 hover:border-gray-500"}`}>
                  <span>{b.icon}</span>
                  <span className="text-xs">{b.name}</span>
                </button>
              ))}
            </div>
            <div className="mt-4 flex gap-3">
              <button onClick={saveBadges} disabled={savingBadges}
                className="rounded-lg bg-yellow-600 px-5 py-2 text-sm font-semibold text-white hover:bg-yellow-500 disabled:opacity-50">
                {savingBadges ? "Saving…" : "Save badges"}
              </button>
              <button onClick={() => setAdminBadges(false)}
                className="rounded-lg bg-gray-800 px-5 py-2 text-sm hover:bg-gray-700">
                Cancel
              </button>
            </div>
          </div>
        )}

        {/* Badges */}
        {profile.badges.length > 0 && (
          <section className="mb-10">
            <h2 className="mb-4 text-lg font-bold">Badges</h2>
            <div className="grid grid-cols-2 gap-3 sm:grid-cols-3 md:grid-cols-4">
              {profile.badges.map(b => (
                <div key={b.id} className="flex items-start gap-3 rounded-xl border border-gray-800 bg-gray-900 p-3">
                  <span className="text-2xl">{b.icon}</span>
                  <div>
                    <p className="text-sm font-semibold">{b.name}</p>
                    <p className="text-xs text-gray-500">{b.desc}</p>
                  </div>
                </div>
              ))}
            </div>
          </section>
        )}

        {/* Health Dashboard (New) - Only visible if viewing own profile */}
        {canEdit && (
          <section className="mb-10">
            <HealthProfile initialData={profile} onUpdate={mutate} />
          </section>
        )}

        {/* Recipes */}
        <section>
          <h2 className="mb-4 text-lg font-bold">Recipes by {profile.display_name}</h2>
          {!userRecipes ? (
            <p className="text-sm text-gray-500">Loading…</p>
          ) : userRecipes.length === 0 ? (
            <p className="text-sm text-gray-500">No published recipes yet.</p>
          ) : (
            <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 md:grid-cols-3">
              {userRecipes.map(r => <RecipeCard key={r.id} recipe={r} />)}
            </div>
          )}
        </section>
      </div>
    </div>
  );
}

// ── Admin: Reassign Author ───────────────────────────────────────────────────

function AdminAuthorReassign({ recipe, mutate }: { recipe: RecipeDetail; mutate: any }) {
  const [open, setOpen] = useState(false);
  const [q, setQ] = useState("");
  const [users, setUsers] = useState<{ id: number; username: string; display_name: string }[]>([]);
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    if (!open) return;
    const delay = setTimeout(async () => {
      setLoading(true);
      try {
        const res = await api.get<{ id: number; username: string; display_name: string }[]>(`/users/search?q=${q}`);
        setUsers(res);
      } catch {}
      finally { setLoading(false); }
    }, 300);
    return () => clearTimeout(delay);
  }, [q, open]);

  async function reassign(userId: number) {
    if (!confirm("Reassign authorship to this user? The source will also be updated to UGC if it was previously scraped.")) return;
    setSaving(true);
    try {
      await api.post(`/recipes/${recipe.slug}/reassign-author`, { new_author_id: userId });
      mutate();
      setOpen(false);
    } catch (e: any) { alert(e.message); }
    finally { setSaving(false); }
  }

  return (
    <section className="mt-8 rounded-xl border border-brand-500/30 bg-brand-500/5 p-6">
      <div className="flex items-center justify-between">
        <div>
          <h3 className="text-lg font-bold text-brand-400">🛡️ Admin: Authorship</h3>
          <p className="text-xs text-gray-500">Change the owner of this recipe. Scraped recipes will become UGC.</p>
        </div>
        <button
          onClick={() => setOpen(!open)}
          className="rounded-lg bg-gray-800 px-4 py-2 text-sm font-medium hover:bg-gray-700"
        >
          {open ? "Close" : "Change Author"}
        </button>
      </div>

      {open && (
        <div className="mt-4 space-y-4">
          <input
            type="text"
            placeholder="Search users by name or username…"
            value={q}
            onChange={(e) => setQ(e.target.value)}
            className="w-full rounded-lg border border-gray-700 bg-gray-900 px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500"
          />
          <div className="max-h-48 overflow-y-auto rounded-lg border border-gray-800 bg-gray-900/50">
            {loading ? (
              <p className="p-4 text-center text-xs text-gray-600">Searching…</p>
            ) : users.length > 0 ? (
              <div className="divide-y divide-gray-800/50">
                {users.map((u) => (
                  <button
                    key={u.id}
                    disabled={saving}
                    onClick={() => reassign(u.id)}
                    className="flex w-full items-center justify-between px-4 py-3 text-left transition hover:bg-brand-500/10"
                  >
                    <div>
                      <div className="text-sm font-semibold">{u.display_name}</div>
                      <div className="text-xs text-gray-500">@{u.username}</div>
                    </div>
                    {recipe.author_id === u.id ? (
                      <span className="text-xs font-bold text-brand-500">Current</span>
                    ) : (
                      <span className="text-xs text-gray-400 group-hover:text-brand-400">Select →</span>
                    )}
                  </button>
                ))}
              </div>
            ) : (
              <p className="p-4 text-center text-xs text-gray-600">No users found.</p>
            )}
          </div>
        </div>
      )}
    </section>
  );
}

// ── Admin Dashboard ──────────────────────────────────────────────────────────

interface AdminStats {
  total_users: number;
  total_recipes: number;
  total_views: number;
  new_users_24h: number;
  new_recipes_24h: number;
}

interface AdminLog {
  id: number;
  admin_username: string;
  action: string;
  target_type: string;
  target_id: string;
  details: any;
  created_at: string;
}

interface AdminUser {
  id: number;
  username: string;
  display_name: string;
  role: string;
  created_at: string;
}

function AdminDashboardView() {
  const fetcher = (url: string) => api.get(url);
  const { data: stats } = useSWR("/admin/stats", fetcher) as { data: AdminStats | undefined };
  const { data: logs } = useSWR("/admin/logs", fetcher) as { data: AdminLog[] | undefined };
  const { data: users, mutate: mutateUsers } = useSWR("/admin/users", fetcher) as { data: AdminUser[] | undefined; mutate: any };
  const { data: edits, mutate: mutateEdits } = useSWR("/recipes/edits/pending", fetcher) as { data: any[] | undefined; mutate: any };

  async function setRole(userId: number, role: string) {
    if (!confirm(`Change user role to ${role}?`)) return;
    try {
      await api.patch(`/admin/users/${userId}/role`, { role });
      mutateUsers();
    } catch (e: any) { alert(e.message); }
  }

  async function handleEditAction(editId: number, action: 'approve' | 'reject') {
    try {
      await api.post(`/recipes/edits/${editId}/${action}`, {});
      mutateEdits();
    } catch (e: any) { alert(e.message); }
  }

  return (
    <div className="mx-auto max-w-5xl px-4 py-8">
      <header className="mb-10 flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-extrabold tracking-tight">Admin Dashboard</h1>
          <p className="text-gray-500">Manage users, roles, and site activity.</p>
        </div>
        <a href="/recipes" className="text-sm font-medium text-gray-500 hover:text-white">← Back to Hub</a>
      </header>

      {/* Stats Cards */}
      <div className="mb-10 grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <StatCard title="Total Users" value={stats?.total_users ?? "—"} sub={`+${stats?.new_users_24h ?? 0} today`} />
        <StatCard title="Total Recipes" value={stats?.total_recipes ?? "—"} sub={`+${stats?.new_recipes_24h ?? 0} today`} />
        <StatCard title="Total Page Views" value={stats?.total_views?.toLocaleString() ?? "—"} />
        <StatCard title="Platform Status" value="Online" trend="up" />
      </div>

      {/* Suggested Edits Queue (Restored Inline) */}
      <section className="mb-12">
        <div className="flex items-center justify-between mb-6">
          <h2 className="flex items-center gap-2 text-2xl font-black text-brand-400 italic">
            ✨ Suggested Edits Review
          </h2>
          <span className="rounded-full bg-brand-500/20 px-4 py-1 text-sm font-bold text-brand-400 border border-brand-500/30">
            {edits?.length ?? 0} Pending
          </span>
        </div>
        
        <div className="space-y-8">
          {edits?.map(edit => (
            <div key={edit.id} className="group relative rounded-3xl border border-gray-800 bg-gray-900/50 hover:bg-gray-900 transition-all p-8 shadow-2xl">
              <div className="mb-8 flex items-center justify-between">
                <div>
                  <div className="flex items-center gap-3 mb-2">
                    <span className="rounded bg-brand-500/10 px-2 py-0.5 text-[10px] font-bold uppercase text-brand-400 border border-brand-500/30 tracking-widest">Community Contribution</span>
                    <span className="text-xs text-gray-600">ID: {edit.id}</span>
                  </div>
                  <h3 className="text-2xl font-black tracking-tight mb-1">Improve "{edit.recipe_title}"</h3>
                  <p className="text-sm text-gray-500">Proposed by <span className="font-bold text-white">@{edit.username}</span> • {new Date(edit.created_at).toLocaleString()}</p>
                </div>
                <div className="flex gap-4">
                  <button 
                    onClick={() => handleEditAction(edit.id, 'reject')}
                    className="rounded-xl border border-red-500/30 px-6 py-2.5 text-sm font-bold text-red-500 hover:bg-red-500 hover:text-white transition-all shadow-lg shadow-red-500/5"
                  >
                    Reject
                  </button>
                  <button 
                    onClick={() => handleEditAction(edit.id, 'approve')}
                    className="rounded-xl bg-brand-500 px-6 py-2.5 text-sm font-bold text-white hover:bg-brand-600 hover:scale-105 active:scale-95 transition-all shadow-xl shadow-brand-500/20"
                  >
                    Approve Changes
                  </button>
                </div>
              </div>
              
              <div className="rounded-2xl border border-gray-800 bg-gray-950 p-6">
                <h4 className="mb-6 text-[10px] font-bold uppercase tracking-[0.2em] text-gray-600 border-b border-gray-900 pb-2">Structural Comparison</h4>
                <EditDiffView original={edit.current_state} proposed={edit.proposed_changes} />
              </div>
            </div>
          ))}
          {edits?.length === 0 && (
            <div className="rounded-3xl border border-dashed border-gray-800 py-20 text-center">
              <p className="text-4xl mb-4 grayscale opacity-20">📂</p>
              <p className="text-sm text-gray-600 italic">No pending edits in the queue.</p>
            </div>
          )}
        </div>
      </section>

      <div className="grid gap-8 lg:grid-cols-2">
        {/* User Management */}
        <section className="rounded-2xl border border-gray-800 bg-gray-900/50 p-6">
          <h2 className="mb-6 text-xl font-bold">User Management</h2>
          <div className="space-y-4">
            {users?.map(u => (
              <div key={u.id} className="flex items-center justify-between rounded-xl border border-gray-800/50 bg-gray-900 p-4">
                <div>
                  <p className="font-bold">{u.display_name}</p>
                  <p className="text-xs text-gray-500">@{u.username}</p>
                </div>
                <div className="flex gap-2">
                  <select 
                    value={u.role} 
                    onChange={(e) => setRole(u.id, e.target.value)}
                    className="rounded-lg border border-gray-700 bg-gray-800 px-2 py-1 text-xs focus:ring-2 focus:ring-brand-500 outline-none"
                  >
                    <option value="user">User</option>
                    <option value="vip">VIP</option>
                    <option value="verified_chef">Chef</option>
                    <option value="moderator">Mod</option>
                    <option value="admin">Admin</option>
                  </select>
                </div>
              </div>
            ))}
          </div>
        </section>

        {/* Activity Logs */}
        <section className="rounded-2xl border border-gray-800 bg-gray-900/50 p-6">
          <h2 className="mb-6 text-xl font-bold">Recent Activity</h2>
          <div className="space-y-4">
            {logs?.map(l => (
              <div key={l.id} className="flex gap-3 border-l-2 border-brand-500/30 pl-4 py-1">
                <div className="flex-1">
                  <p className="text-sm">
                    <span className="font-bold">@{l.admin_username}</span>{" "}
                    <span className="text-gray-400">{l.action.replace("_", " ")}</span>{" "}
                    <span className="font-medium text-brand-400">{l.target_type}: {l.target_id}</span>
                  </p>
                  <p className="text-[10px] text-gray-600">
                    {new Date(l.created_at).toLocaleString()}
                  </p>
                </div>
              </div>
            ))}
            {logs?.length === 0 && <p className="text-sm text-gray-600">No activity logged yet.</p>}
          </div>
        </section>
      </div>
    </div>
  );
}

// ── Edit Diff View ──────────────────────────────────────────────────────────

function EditDiffView({ original, proposed }: { original: any; proposed: any }) {
  const fields = Object.keys(proposed).filter(k => !Array.isArray(proposed[k]));
  
  return (
    <div className="grid gap-4 text-sm">
      {/* Basic Fields */}
      <div className="grid grid-cols-2 gap-2 border-b border-gray-800 pb-4 font-mono text-[11px] uppercase tracking-wider text-gray-600">
        <div>Current Version</div>
        <div>Proposed Change</div>
      </div>
      
      {fields.map(field => (
        <div key={field} className="grid grid-cols-2 gap-4 border-b border-gray-800/30 py-2">
          <div className="break-words text-xs text-gray-400">
            <span className="mb-1 block text-[10px] font-bold uppercase text-gray-600">{field}</span>
            {String(original[field] ?? "—")}
          </div>
          <div className="break-words rounded-lg bg-green-500/10 p-2 text-xs text-green-300">
            <span className="mb-1 block text-[10px] font-bold uppercase text-green-500/50">{field}</span>
            {String(proposed[field])}
          </div>
        </div>
      ))}

      {/* Complex Arrays (Ingredients/Steps) - Shown as list updates */}
      {proposed.ingredients && (
        <div className="mt-4">
          <h4 className="mb-2 text-[10px] font-bold uppercase text-gray-500">Updated Ingredients</h4>
          <div className="rounded-xl border border-gray-800 bg-gray-900/50 p-4">
            <ul className="list-inside list-disc space-y-1 text-xs text-green-400">
              {proposed.ingredients.map((ing: any, i: number) => (
                <li key={i}>{ing.quantity} {ing.unit} {ing.name} {ing.note && <span className="text-gray-500 italic">({ing.note})</span>}</li>
              ))}
            </ul>
          </div>
        </div>
      )}

      {proposed.steps && (
        <div className="mt-4">
          <h4 className="mb-2 text-[10px] font-bold uppercase text-gray-500">Updated Steps</h4>
          <div className="space-y-2">
            {proposed.steps.map((step: any, i: number) => (
              <div key={i} className="rounded-lg border border-gray-800 bg-gray-900/50 p-3 text-xs text-green-300">
                <span className="mr-2 font-bold text-green-500/50">#{i + 1}</span>
                {step.body}
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}

function StatCard({ title, value, sub, trend }: { title: string; value: string | number; sub?: string; trend?: "up" | "down" }) {
  return (
    <div className="rounded-2xl border border-gray-800 bg-gray-900 p-6">
      <p className="text-xs font-bold uppercase tracking-wider text-gray-500">{title}</p>
      <div className="mt-2 flex items-baseline gap-2">
        <h3 className="text-2xl font-extrabold">{value}</h3>
        {trend === "up" && <span className="text-xs font-bold text-green-500">↑</span>}
      </div>
      {sub && <p className="mt-1 text-xs text-gray-500">{sub}</p>}
    </div>
  );
}
