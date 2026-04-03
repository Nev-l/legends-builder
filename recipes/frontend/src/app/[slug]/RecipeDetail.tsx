"use client";
import { useState } from "react";
import { useParams, useRouter } from "next/navigation";
import useSWR from "swr";
import { api } from "@/lib/api";

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

interface RecipeDetail {
  id: number;
  title: string;
  slug: string;
  description: string | null;
  image_url: string | null;
  source_url: string | null;
  prep_minutes: number | null;
  cook_minutes: number | null;
  servings: number;
  diet_tags: string[];
  upvotes: number;
  downvotes: number;
  score: number;
  ingredients: Ingredient[];
  steps: Step[];
}

export default function RecipeDetail() {
  const { slug } = useParams<{ slug: string }>();
  const router = useRouter();
  const [servings, setServings] = useState<number | null>(null);
  const [voting, setVoting] = useState(false);

  const { data: recipe, mutate, isLoading } = useSWR<RecipeDetail>(
    slug ? `/recipes/${slug}` : null,
    (url: string) => api.get<RecipeDetail>(url)
  );

  const scale = recipe ? (servings ?? recipe.servings) / recipe.servings : 1;

  async function vote(value: 1 | -1) {
    if (!recipe || voting) return;
    setVoting(true);
    try {
      await api.post(`/recipes/${recipe.slug}/rate`, { value });
      mutate();
    } catch {
      // ignore
    } finally {
      setVoting(false);
    }
  }

  async function fork() {
    if (!recipe) return;
    try {
      const forked = await api.post<RecipeDetail>(`/recipes/${recipe.slug}/fork`, {});
      router.push(`/${forked.slug}`);
    } catch (e: any) {
      alert(e.message);
    }
  }

  if (isLoading) {
    return <p className="text-center text-gray-500 py-20">Loading…</p>;
  }
  if (!recipe) {
    return <p className="text-center text-gray-500 py-20">Recipe not found.</p>;
  }

  const totalMins = (recipe.prep_minutes ?? 0) + (recipe.cook_minutes ?? 0);

  return (
    <div className="mx-auto max-w-3xl">
      {/* Header image */}
      {recipe.image_url ? (
        <img
          src={recipe.image_url}
          alt={recipe.title}
          className="mb-6 h-64 w-full rounded-xl object-cover"
        />
      ) : (
        <div className="mb-6 flex h-64 items-center justify-center rounded-xl bg-gray-800 text-7xl">
          🍽️
        </div>
      )}

      {/* Title + meta */}
      <div className="mb-6">
        <h1 className="mb-2 text-3xl font-extrabold">{recipe.title}</h1>
        {recipe.description && (
          <p className="mb-4 text-gray-400">{recipe.description}</p>
        )}
        <div className="flex flex-wrap items-center gap-4 text-sm text-gray-400">
          {recipe.prep_minutes != null && (
            <span>Prep: <strong className="text-white">{recipe.prep_minutes} min</strong></span>
          )}
          {recipe.cook_minutes != null && (
            <span>Cook: <strong className="text-white">{recipe.cook_minutes} min</strong></span>
          )}
          {totalMins > 0 && (
            <span>Total: <strong className="text-white">{totalMins} min</strong></span>
          )}
          {recipe.source_url && (
            <a
              href={recipe.source_url}
              target="_blank"
              rel="noopener noreferrer"
              className="ml-auto text-brand-500 hover:underline"
            >
              Original source ↗
            </a>
          )}
        </div>
        {recipe.diet_tags.length > 0 && (
          <div className="mt-3 flex flex-wrap gap-1.5">
            {recipe.diet_tags.map((t) => (
              <span key={t} className="rounded-full bg-gray-800 px-2.5 py-1 text-xs text-gray-300">
                {t.replace(/_/g, " ")}
              </span>
            ))}
          </div>
        )}
      </div>

      {/* Actions */}
      <div className="mb-8 flex flex-wrap items-center gap-3">
        <button
          onClick={() => vote(1)}
          disabled={voting}
          className="flex items-center gap-1.5 rounded-lg bg-gray-800 px-4 py-2 text-sm hover:bg-gray-700 disabled:opacity-50"
        >
          👍 <span>{recipe.upvotes}</span>
        </button>
        <button
          onClick={() => vote(-1)}
          disabled={voting}
          className="flex items-center gap-1.5 rounded-lg bg-gray-800 px-4 py-2 text-sm hover:bg-gray-700 disabled:opacity-50"
        >
          👎 <span>{recipe.downvotes}</span>
        </button>
        <button
          onClick={fork}
          className="rounded-lg bg-gray-800 px-4 py-2 text-sm hover:bg-gray-700"
        >
          🍴 Fork recipe
        </button>
        <div className="ml-auto flex items-center gap-2 text-sm">
          <span className="text-gray-400">Servings:</span>
          <button
            onClick={() => setServings(Math.max(1, (servings ?? recipe.servings) - 1))}
            className="rounded bg-gray-800 px-2 py-1 hover:bg-gray-700"
          >−</button>
          <span className="w-6 text-center font-semibold">{servings ?? recipe.servings}</span>
          <button
            onClick={() => setServings((servings ?? recipe.servings) + 1)}
            className="rounded bg-gray-800 px-2 py-1 hover:bg-gray-700"
          >+</button>
        </div>
      </div>

      <div className="grid gap-8 md:grid-cols-[1fr_2fr]">
        {/* Ingredients */}
        <section>
          <h2 className="mb-3 text-lg font-bold">Ingredients</h2>
          <ul className="space-y-2">
            {recipe.ingredients.map((ing) => {
              const qty = ing.quantity != null ? +(ing.quantity * scale).toFixed(2) : null;
              return (
                <li key={ing.id} className="flex gap-2 text-sm">
                  <span className="w-16 shrink-0 text-right text-gray-400">
                    {qty != null ? `${qty}${ing.unit ? ` ${ing.unit}` : ""}` : ""}
                  </span>
                  <span>
                    {ing.name}
                    {ing.note && <span className="text-gray-500">, {ing.note}</span>}
                  </span>
                </li>
              );
            })}
          </ul>
        </section>

        {/* Steps */}
        <section>
          <h2 className="mb-3 text-lg font-bold">Method</h2>
          <ol className="space-y-5">
            {recipe.steps.map((step) => (
              <li key={step.id} className="flex gap-3">
                <span className="mt-0.5 flex h-6 w-6 shrink-0 items-center justify-center rounded-full bg-brand-500 text-xs font-bold text-white">
                  {step.position}
                </span>
                <div>
                  <p className="text-sm leading-relaxed">{step.body}</p>
                  {step.timer_mins && (
                    <span className="mt-1 inline-block text-xs text-gray-500">
                      ⏱ {step.timer_mins} min
                    </span>
                  )}
                  {step.image_url && (
                    <img
                      src={step.image_url}
                      alt={`Step ${step.position}`}
                      className="mt-2 rounded-lg"
                    />
                  )}
                </div>
              </li>
            ))}
          </ol>
        </section>
      </div>
    </div>
  );
}
