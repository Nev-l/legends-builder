"use client";
import { useState, useRef, useEffect } from "react";
import useSWR from "swr";
import { api } from "@/lib/api";

const DAYS = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
const SLOTS = ["breakfast", "lunch", "dinner", "snack"] as const;
type Slot = (typeof SLOTS)[number];

interface RecipeSnap {
  slug: string;
  title: string;
  image_url: string | null;
  calories: number | null;
  servings: number | null;
}

interface MealPlanItem {
  id: number;
  day_of_week: number;
  slot: Slot;
  servings: number;
  recipe: RecipeSnap;
}

interface MealPlan {
  id: number;
  week_start: string;
  items: MealPlanItem[];
}

interface RecipeResult {
  slug: string;
  title: string;
  image_url: string | null;
  calories: number | null;
  diet_tags: string[];
}

function weekStart(offset = 0) {
  const d = new Date();
  const day = d.getDay(); // 0=Sun … 6=Sat
  const diff = (day === 0 ? -6 : 1 - day) + offset * 7;
  d.setDate(d.getDate() + diff);
  // Format using local date to avoid UTC offset shifting the day
  const yyyy = d.getFullYear();
  const mm = String(d.getMonth() + 1).padStart(2, "0");
  const dd = String(d.getDate()).padStart(2, "0");
  return `${yyyy}-${mm}-${dd}`;
}

function caloriesForDay(items: MealPlanItem[], dayIdx: number): number {
  return items
    .filter((i) => i.day_of_week === dayIdx)
    .reduce((sum, i) => {
      const cal = i.recipe.calories ?? 0;
      const recipeServings = i.recipe.servings ?? 1;
      return sum + (cal / recipeServings) * i.servings;
    }, 0);
}

export default function PlannerPage() {
  const [weekOffset, setWeekOffset] = useState(0);
  const ws = weekStart(weekOffset);
  const [calorieGoal, setCalorieGoal] = useState<number>(2000);
  const [goalInput, setGoalInput] = useState("2000");

  // Add-meal modal state
  const [addingTo, setAddingTo] = useState<{ planId: number; day: number; slot: Slot } | null>(null);
  const [searchQ, setSearchQ] = useState("");
  const [searchRes, setSearchRes] = useState<RecipeResult[]>([]);
  const [searching, setSearching] = useState(false);
  const [servings, setServings] = useState(2);
  const searchRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  // Recommend state
  const [showRecommend, setShowRecommend] = useState(false);
  const [recommendSlot, setRecommendSlot] = useState<Slot>("dinner");
  const [recommendResults, setRecommendResults] = useState<RecipeResult[]>([]);
  const [recommendLoading, setRecommendLoading] = useState(false);
  const [targetDay, setTargetDay] = useState(0);

  const [isLoggedIn, setIsLoggedIn] = useState(false);
  useEffect(() => {
    setIsLoggedIn(!!localStorage.getItem("rh_token"));
  }, []);

  const { data: plans, mutate: mutatePlans, isLoading } = useSWR<MealPlan[]>(
    isLoggedIn ? "/meal-planner" : null,
    (url: string) => api.get<MealPlan[]>(url)
  );

  const plan = plans?.find((p) => p.week_start?.slice(0, 10) === ws);

  const { data: grocery } = useSWR<{ ingredient: string; total_quantity: number; unit: string | null }[]>(
    plan ? `/meal-planner/${plan.id}/grocery-list` : null,
    (url: string) => api.get<{ ingredient: string; total_quantity: number; unit: string | null }[]>(url)
  );

  async function createPlan() {
    await api.post("/meal-planner", { week_start: ws, items: [] });
    await mutatePlans();
  }

  function cellItem(day: number, slot: Slot): MealPlanItem | undefined {
    return plan?.items.find((i) => i.day_of_week === day && i.slot === slot);
  }

  async function removeItem(itemId: number) {
    if (!plan) return;
    await api.delete(`/meal-planner/${plan.id}/items/${itemId}`);
    mutatePlans();
  }

  // Live search as user types
  useEffect(() => {
    if (!searchQ.trim()) { setSearchRes([]); return; }
    if (searchRef.current) clearTimeout(searchRef.current);
    searchRef.current = setTimeout(async () => {
      setSearching(true);
      try {
        const res = await api.get<RecipeResult[]>(
          `/recipes?q=${encodeURIComponent(searchQ)}&limit=8`
        );
        setSearchRes(Array.isArray(res) ? res : []);
      } catch {
        setSearchRes([]);
      } finally {
        setSearching(false);
      }
    }, 300);
  }, [searchQ]);

  async function addMeal(recipe: RecipeResult) {
    if (!addingTo) return;
    await api.post(`/meal-planner/${addingTo.planId}/items`, {
      recipe_slug: recipe.slug,
      day_of_week: addingTo.day,
      slot: addingTo.slot,
      servings,
    });
    mutatePlans();
    setAddingTo(null);
    setSearchQ("");
    setSearchRes([]);
    setServings(2);
  }

  async function fetchRecommend() {
    setRecommendLoading(true);
    setShowRecommend(true);
    try {
      const perMeal = Math.round(calorieGoal / 3);
      const res = await api.get<RecipeResult[]>(
        `/meal-planner/recommend?calorie_target=${perMeal}&slot=${recommendSlot}&_t=${Date.now()}`
      );
      setRecommendResults(res);
    } catch {
      setRecommendResults([]);
    } finally {
      setRecommendLoading(false);
    }
  }

  async function addRecommended(recipe: RecipeResult) {
    if (!plan) return;
    await api.post(`/meal-planner/${plan.id}/items`, {
      recipe_slug: recipe.slug,
      day_of_week: targetDay,
      slot: recommendSlot,
      servings: 2,
    });
    mutatePlans();
  }

  return (
    <div>
      {/* Header */}
      <div className="mb-6 flex flex-wrap items-center justify-between gap-3">
        <h1 className="text-2xl font-extrabold">Meal Planner</h1>
        <div className="flex items-center gap-3">
          <button onClick={() => setWeekOffset((o) => o - 1)} className="rounded-lg bg-gray-800 px-3 py-1.5 text-sm hover:bg-gray-700">← Prev</button>
          <span className="text-sm text-gray-400">Week of <strong className="text-white">{ws}</strong></span>
          <button onClick={() => setWeekOffset((o) => o + 1)} className="rounded-lg bg-gray-800 px-3 py-1.5 text-sm hover:bg-gray-700">Next →</button>
        </div>
      </div>

      {/* Calorie goal */}
      <div className="mb-6 flex flex-wrap items-center gap-3 rounded-xl border border-gray-800 bg-gray-900 px-4 py-3">
        <span className="text-sm font-semibold text-gray-300">Daily calorie goal</span>
        <input
          type="number"
          min={500}
          max={10000}
          step={50}
          value={goalInput}
          onChange={(e) => setGoalInput(e.target.value)}
          onBlur={() => {
            const v = parseInt(goalInput);
            if (v >= 500) setCalorieGoal(v);
          }}
          className="w-24 rounded-lg border border-gray-700 bg-gray-800 px-2 py-1.5 text-sm text-white focus:outline-none focus:ring-2 focus:ring-brand-500"
        />
        <span className="text-sm text-gray-500">kcal / day</span>
        {plan && (
          <button
            onClick={fetchRecommend}
            className="ml-auto rounded-lg bg-brand-500 px-3 py-1.5 text-sm font-semibold text-white hover:bg-brand-600"
          >
            Suggest meals for goal
          </button>
        )}
      </div>

      {!isLoggedIn ? (
        <div className="py-16 text-center">
          <p className="mb-4 text-gray-500">Sign in to use the meal planner.</p>
          <a href="/recipes/login" className="rounded-lg bg-brand-500 px-5 py-2.5 text-sm font-semibold text-white hover:bg-brand-600">Sign in</a>
        </div>
      ) : isLoading ? (
        <p className="py-16 text-center text-gray-500">Loading…</p>
      ) : !plan ? (
        <div className="py-16 text-center">
          <p className="mb-4 text-gray-500">No plan for this week yet.</p>
          <button onClick={createPlan} className="rounded-lg bg-brand-500 px-5 py-2.5 text-sm font-semibold text-white hover:bg-brand-600">
            Create plan
          </button>
        </div>
      ) : (
        <>
          {/* Planner grid */}
          <div className="overflow-x-auto">
            <table className="w-full min-w-[700px] border-collapse text-sm">
              <thead>
                <tr>
                  <th className="w-24 p-2 text-left text-gray-500"></th>
                  {DAYS.map((d, i) => {
                    const dayCal = caloriesForDay(plan.items, i);
                    const pct = Math.min((dayCal / calorieGoal) * 100, 100);
                    const color = dayCal > calorieGoal * 1.1 ? "text-red-400" : dayCal > calorieGoal * 0.8 ? "text-green-400" : "text-gray-500";
                    return (
                      <th key={d} className="p-2 text-center">
                        <div className="font-semibold text-gray-300">{d}</div>
                        {dayCal > 0 && (
                          <>
                            <div className={`text-xs tabular-nums ${color}`}>{Math.round(dayCal)} kcal</div>
                            <div className="mx-auto mt-1 h-1 w-full max-w-[60px] overflow-hidden rounded-full bg-gray-800">
                              <div
                                className={`h-full rounded-full transition-all ${dayCal > calorieGoal * 1.1 ? "bg-red-500" : "bg-green-500"}`}
                                style={{ width: `${pct}%` }}
                              />
                            </div>
                          </>
                        )}
                      </th>
                    );
                  })}
                </tr>
              </thead>
              <tbody>
                {SLOTS.map((slot) => (
                  <tr key={slot} className="border-t border-gray-800">
                    <td className="p-2 capitalize text-gray-500">{slot}</td>
                    {DAYS.map((_, dayIdx) => {
                      const item = cellItem(dayIdx, slot);
                      return (
                        <td key={dayIdx} className="p-1 align-top">
                          <div className="min-h-[60px] rounded-lg border border-dashed border-gray-800 p-1">
                            {item ? (
                              <div className="group relative mb-1 rounded bg-gray-800 p-1 text-xs">
                                <a href={`/recipes/${item.recipe.slug}`} className="flex items-center gap-1 hover:text-brand-400">
                                  {item.recipe.image_url ? (
                                    <img src={item.recipe.image_url} alt="" className="h-8 w-8 rounded object-cover" />
                                  ) : (
                                    <span className="text-base">🍽️</span>
                                  )}
                                  <span className="line-clamp-2 leading-tight flex-1">{item.recipe.title}</span>
                                </a>
                                {item.recipe.calories != null && (
                                  <div className="mt-0.5 text-gray-500">
                                    {Math.round((item.recipe.calories / (item.recipe.servings ?? 1)) * item.servings)} kcal
                                  </div>
                                )}
                                <button
                                  onClick={() => removeItem(item.id)}
                                  className="absolute right-1 top-1 hidden rounded p-0.5 text-gray-600 hover:text-red-400 group-hover:block"
                                  title="Remove"
                                >✕</button>
                              </div>
                            ) : (
                              <button
                                onClick={() => setAddingTo({ planId: plan.id, day: dayIdx, slot })}
                                className="flex h-full w-full items-center justify-center rounded p-2 text-gray-700 hover:bg-gray-800 hover:text-gray-400"
                                title="Add meal"
                              >
                                +
                              </button>
                            )}
                          </div>
                        </td>
                      );
                    })}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          {/* Grocery list */}
          {grocery && grocery.length > 0 && (
            <section className="mt-8">
              <h2 className="mb-3 text-lg font-bold">Grocery list</h2>
              <ul className="grid gap-1.5 sm:grid-cols-2 lg:grid-cols-3">
                {grocery.map((g, i) => (
                  <li key={i} className="flex items-center gap-2 rounded-lg bg-gray-900 px-3 py-2 text-sm">
                    <span className="h-2 w-2 rounded-full bg-brand-500" />
                    <span className="flex-1">{g.ingredient}</span>
                    <span className="text-gray-400 tabular-nums">
                      {g.total_quantity > 0 ? `${g.total_quantity.toFixed(1)}${g.unit ? ` ${g.unit}` : ""}` : ""}
                    </span>
                  </li>
                ))}
              </ul>
              <button
                onClick={() => {
                  const text = grocery.map((g) => `${g.total_quantity > 0 ? g.total_quantity.toFixed(1) : ""}${g.unit ? ` ${g.unit}` : ""} ${g.ingredient}`.trim()).join("\n");
                  navigator.clipboard.writeText(text);
                }}
                className="mt-3 rounded-lg bg-gray-800 px-4 py-2 text-sm hover:bg-gray-700"
              >
                Copy to clipboard
              </button>
            </section>
          )}
        </>
      )}

      {/* Add-meal modal */}
      {addingTo && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/70 p-4" onClick={() => setAddingTo(null)}>
          <div className="w-full max-w-md rounded-2xl border border-gray-700 bg-gray-950 p-6" onClick={(e) => e.stopPropagation()}>
            <h2 className="mb-4 text-lg font-bold">
              Add meal — {DAYS[addingTo.day]} {addingTo.slot}
            </h2>
            <input
              autoFocus
              className="mb-3 w-full rounded-lg border border-gray-700 bg-gray-900 px-3 py-2 text-sm placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-brand-500"
              placeholder="Search recipes…"
              value={searchQ}
              onChange={(e) => setSearchQ(e.target.value)}
            />
            <div className="mb-3 flex items-center gap-2">
              <label className="text-sm text-gray-400">Servings:</label>
              <input
                type="number"
                min={1}
                max={20}
                value={servings}
                onChange={(e) => setServings(parseInt(e.target.value) || 1)}
                className="w-16 rounded-lg border border-gray-700 bg-gray-900 px-2 py-1.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500"
              />
            </div>
            {searching && <p className="text-sm text-gray-500">Searching…</p>}
            <ul className="max-h-60 overflow-y-auto space-y-1">
              {searchRes.map((r) => (
                <li key={r.slug}>
                  <button
                    onClick={() => addMeal(r)}
                    className="flex w-full items-center gap-3 rounded-lg p-2 text-left hover:bg-gray-800"
                  >
                    {r.image_url ? (
                      <img src={r.image_url} alt="" className="h-10 w-10 rounded-lg object-cover" />
                    ) : (
                      <span className="text-2xl">🍽️</span>
                    )}
                    <div>
                      <div className="text-sm font-medium">{r.title}</div>
                      {r.calories != null && (
                        <div className="text-xs text-gray-500">{Math.round(r.calories)} kcal/serving</div>
                      )}
                    </div>
                  </button>
                </li>
              ))}
            </ul>
            {!searching && searchQ && searchRes.length === 0 && (
              <p className="text-sm text-gray-500">No results for "{searchQ}"</p>
            )}
          </div>
        </div>
      )}

      {/* Recommend modal */}
      {showRecommend && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/70 p-4" onClick={() => setShowRecommend(false)}>
          <div className="w-full max-w-lg rounded-2xl border border-gray-700 bg-gray-950 p-6" onClick={(e) => e.stopPropagation()}>
            <h2 className="mb-1 text-lg font-bold">Meal suggestions</h2>
            <p className="mb-4 text-sm text-gray-400">
              Based on {calorieGoal} kcal/day goal (~{Math.round(calorieGoal / 3)} kcal per meal)
            </p>
            <div className="mb-4 flex flex-wrap gap-2">
              <select
                value={recommendSlot}
                onChange={(e) => setRecommendSlot(e.target.value as Slot)}
                className="rounded-lg border border-gray-700 bg-gray-900 px-3 py-1.5 text-sm focus:outline-none"
              >
                {SLOTS.map((s) => <option key={s} value={s}>{s}</option>)}
              </select>
              <select
                value={targetDay}
                onChange={(e) => setTargetDay(parseInt(e.target.value))}
                className="rounded-lg border border-gray-700 bg-gray-900 px-3 py-1.5 text-sm focus:outline-none"
              >
                {DAYS.map((d, i) => <option key={d} value={i}>{d}</option>)}
              </select>
              <button
                onClick={fetchRecommend}
                className="rounded-lg bg-brand-500 px-3 py-1.5 text-sm font-semibold text-white hover:bg-brand-600"
              >
                Refresh
              </button>
            </div>

            {recommendLoading && <p className="text-sm text-gray-500">Finding recipes…</p>}
            {!recommendLoading && recommendResults.length === 0 && (
              <p className="text-sm text-gray-500">No recipes with calorie data found. Try adjusting your goal.</p>
            )}
            <ul className="max-h-80 overflow-y-auto space-y-2">
              {recommendResults.map((r) => (
                <li key={r.slug} className="flex items-center gap-3 rounded-xl border border-gray-800 bg-gray-900 p-3">
                  {r.image_url && <img src={r.image_url} alt="" className="h-12 w-12 rounded-lg object-cover" />}
                  <div className="flex-1 min-w-0">
                    <div className="truncate text-sm font-medium">{r.title}</div>
                    {r.calories != null && (
                      <div className="text-xs text-gray-500">{Math.round(r.calories)} kcal/serving</div>
                    )}
                  </div>
                  <button
                    onClick={() => { addRecommended(r); }}
                    className="shrink-0 rounded-lg bg-brand-500 px-3 py-1.5 text-xs font-semibold text-white hover:bg-brand-600"
                  >
                    Add to {DAYS[targetDay]}
                  </button>
                </li>
              ))}
            </ul>
          </div>
        </div>
      )}
    </div>
  );
}
