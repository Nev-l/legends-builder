"use client";
import { useState } from "react";
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

const SORTS = ["trending", "newest", "top"] as const;

export default function Home() {
  const [sort, setSort] = useState<(typeof SORTS)[number]>("trending");
  const [q, setQ] = useState("");
  const [search, setSearch] = useState("");

  const { data: recipes, isLoading } = useSWR<Recipe[]>(
    `/recipes?sort=${sort}${search ? `&q=${encodeURIComponent(search)}` : ""}`,
    (url: string) => api.get<Recipe[]>(url.replace("/recipes/api", ""))
  );

  return (
    <div>
      {/* Hero */}
      <section className="mb-10 text-center">
        <h1 className="mb-2 text-4xl font-extrabold tracking-tight">
          Find your next favourite meal
        </h1>
        <p className="text-gray-400">
          Scrape any recipe, plan your week, generate a grocery list — all in one place.
        </p>
      </section>

      {/* Search + filters */}
      <div className="mb-8 flex flex-col gap-3 sm:flex-row">
        <input
          className="flex-1 rounded-lg border border-gray-700 bg-gray-900 px-4 py-2.5 text-sm placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-brand-500"
          placeholder="Search recipes…"
          value={q}
          onChange={(e) => setQ(e.target.value)}
          onKeyDown={(e) => e.key === "Enter" && setSearch(q)}
        />
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

      {/* Grid */}
      {isLoading ? (
        <p className="text-center text-gray-500">Loading…</p>
      ) : (
        <div className="grid gap-5 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
          {recipes?.map((r) => <RecipeCard key={r.id} recipe={r} />)}
          {recipes?.length === 0 && (
            <p className="col-span-full text-center text-gray-500">No recipes found.</p>
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
      href={`/${r.slug}`}
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
