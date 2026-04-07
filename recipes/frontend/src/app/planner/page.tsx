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

// ── Toast notification ────────────────────────────────────────────────────────
function Toast({ message, onDone }: { message: string; onDone: () => void }) {
  useEffect(() => {
    const t = setTimeout(onDone, 3000);
    return () => clearTimeout(t);
  }, [onDone]);
  return (
    <div className="fixed bottom-6 left-1/2 z-50 -translate-x-1/2 rounded-xl border border-gray-700 bg-gray-900 px-5 py-3 text-sm font-medium shadow-2xl animate-fade-in">
      {message}
    </div>
  );
}

// Next unfilled slot for a day, in order breakfast → lunch → dinner → snack
// Returns null if all main slots are filled (snack can always stack)
function nextSlot(items: MealPlanItem[], dayIdx: number): Slot {
  const filled = new Set(items.filter(i => i.day_of_week === dayIdx).map(i => i.slot));
  for (const s of ["breakfast", "lunch", "dinner"] as Slot[]) {
    if (!filled.has(s)) return s;
  }
  return "snack"; // always allow snack as overflow
}

export default function PlannerPage() {
  const [weekOffset, setWeekOffset] = useState(0);
  const ws = weekStart(weekOffset);
  const [calorieGoal, setCalorieGoal] = useState<number>(2000);
  const [goalInput, setGoalInput] = useState("2000");

  // Toast
  const [toast, setToast] = useState<string | null>(null);

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
  const [aiGenerating, setAiGenerating] = useState(false);

  const [isLoggedIn, setIsLoggedIn] = useState(false);
  useEffect(() => {
    setIsLoggedIn(!!localStorage.getItem("rh_token"));
  }, []);

  const { data: plans, mutate: mutatePlans, isLoading } = useSWR<MealPlan[]>(
    isLoggedIn ? "/meal-planner" : null,
    (url: string) => api.get<MealPlan[]>(url)
  );

  const plan = plans?.find((p) => p.week_start?.slice(0, 10) === ws);

  const { data: grocery, mutate: mutateGrocery } = useSWR<{ ingredient: string; category: string }[]>(
    plan ? `/meal-planner/${plan.id}/grocery-list` : null,
    (url: string) => api.get<{ ingredient: string; category: string }[]>(url)
  );
  const [addedToPantry, setAddedToPantry] = useState<Set<string>>(new Set());

  async function addToPantry(name: string) {
    try {
      await api.post("/pantry", { ingredient_name: name });
      setAddedToPantry(prev => new Set(prev).add(name));
    } catch { /* ignore */ }
  }

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
    await mutatePlans();

    const dayName = DAYS[addingTo.day];
    const slotName = addingTo.slot.charAt(0).toUpperCase() + addingTo.slot.slice(1);
    setToast(`Added "${recipe.title}" as ${slotName} for ${dayName}`);

    // Auto-advance: open next unfilled slot for same day, unless all filled
    const updatedItems = plans?.flatMap(p => p.items) ?? [];
    const nextS = nextSlot(
      [...updatedItems, { day_of_week: addingTo.day, slot: addingTo.slot } as MealPlanItem],
      addingTo.day
    );
    // Only auto-advance if there's still a main slot free (not looping back to snack)
    const filledNow = new Set(
      updatedItems.filter(i => i.day_of_week === addingTo.day).map(i => i.slot)
    );
    filledNow.add(addingTo.slot);
    const mainsFull = (["breakfast","lunch","dinner"] as Slot[]).every(s => filledNow.has(s));

    if (!mainsFull) {
      setAddingTo({ planId: addingTo.planId, day: addingTo.day, slot: nextS });
      setSearchQ("");
      setSearchRes([]);
    } else {
      setAddingTo(null);
      setSearchQ("");
      setSearchRes([]);
      setServings(2);
    }
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

  async function buildAIPlan() {
    setAiGenerating(true);
    setToast("✨ Raul The Chef is cooking up a special Keto plan for you...");
    try {
      // For the quick button, we default to 4 weeks, but the code is now dynamic
      const res = (await api.post("/ai/generate-plan?weeks=4&diet_type=keto", {})) as any;
      setToast(`✨ ${res.weeks.length}-Week Plan Generated! Applying to your schedule...`);
      
      for (let i = 0; i < res.weeks.length; i++) {
        const weekWs = weekStart(weekOffset + i);
        const weekData = res.weeks[i];
        if (!weekData) continue;
        
        const items = weekData.days.flatMap((d: any) => [
          { recipe_slug: d.meals.breakfast.slug_hint || "keto-pancakes", day_of_week: d.day_number - 1, slot: "breakfast" },
          { recipe_slug: d.meals.lunch.slug_hint || "keto-salad", day_of_week: d.day_number - 1, slot: "lunch" },
          { recipe_slug: d.meals.dinner.slug_hint || "keto-steak", day_of_week: d.day_number - 1, slot: "dinner" },
          { recipe_slug: d.meals.snack.slug_hint || "keto-nuts", day_of_week: d.day_number - 1, slot: "snack" },
        ]);

        await api.post("/meal-planner", { week_start: weekWs, items });
      }
      
      await mutatePlans();
      setToast(`✅ ${res.weeks.length}-Week Plan successfully applied, Amigo!`);
    } catch (e: any) {
      setToast("❌ Raul failed: " + e.message);
    } finally {
      setAiGenerating(false);
    }
  }

  function startAIPlanning() {
    setToast("✨ Click the floating '✨' button in the bottom-right to start your AI-guided plan with Raul The Chef!");
  }

  return (
    <div>
      {toast && <Toast message={toast} onDone={() => setToast(null)} />}
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
          <>
            <button
              onClick={fetchRecommend}
              className="ml-auto rounded-lg bg-brand-500 px-3 py-1.5 text-sm font-semibold text-white hover:bg-brand-600"
            >
              Suggest meals for goal
            </button>
            <button
              onClick={startAIPlanning}
              className="rounded-lg border border-brand-500/50 bg-brand-500/10 px-4 py-1.5 text-sm font-bold text-brand-400 hover:bg-brand-500 hover:text-white transition-all"
            >
              ✨ AI Guided Planner (Raul)
            </button>
          </>
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
                      // Snack allows multiple items; others show one
                      const cellItems = slot === "snack"
                        ? (plan?.items.filter(i => i.day_of_week === dayIdx && i.slot === slot) ?? [])
                        : [cellItem(dayIdx, slot)].filter(Boolean) as MealPlanItem[];
                      const isEmpty = cellItems.length === 0;
                      // For non-snack slots: show + if empty; for snack: always show +
                      const showAdd = isEmpty || slot === "snack";
                      // Check if calories unmet (show extra snack hint)
                      const dayCal = caloriesForDay(plan.items, dayIdx);
                      const showSnackHint = slot === "snack" && cellItems.length > 0 && dayCal < calorieGoal * 0.9;
                      return (
                        <td key={dayIdx} className="p-1 align-top">
                          <div className="min-h-[60px] rounded-lg border border-dashed border-gray-800 p-1">
                            {cellItems.map(item => (
                              <div key={item.id} className="group relative mb-1 rounded bg-gray-800 p-1 text-xs">
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
                            ))}
                            {showAdd && (
                              <button
                                onClick={() => setAddingTo({ planId: plan.id, day: dayIdx, slot })}
                                className={`flex w-full items-center justify-center gap-1 rounded p-1.5 text-xs hover:bg-gray-800 hover:text-gray-300 ${
                                  showSnackHint ? "text-yellow-600" : "text-gray-700"
                                }`}
                                title={showSnackHint ? "Add snack to meet calorie goal" : "Add meal"}
                              >
                                {showSnackHint ? "⚡ add snack" : "+"}
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
              <div className="mb-3 flex items-center justify-between">
                <h2 className="text-lg font-bold">Grocery list</h2>
                <div className="flex gap-2">
                  <button
                    onClick={() => window.print()}
                    className="rounded-lg bg-gray-800 px-3 py-1.5 text-xs hover:bg-gray-700"
                    title="Print / Save as PDF"
                  >
                    🖨️ Print / PDF
                  </button>
                  <button
                    onClick={async () => {
                      for (const g of grocery) {
                        if (!addedToPantry.has(g.ingredient)) await addToPantry(g.ingredient);
                      }
                    }}
                    className="rounded-lg bg-gray-800 px-3 py-1.5 text-xs hover:bg-gray-700"
                    title="Add all to pantry"
                  >
                    + Add all to pantry
                  </button>
                  <button
                    onClick={() => navigator.clipboard.writeText(grocery.map(g => g.ingredient).join("\n"))}
                    className="rounded-lg bg-gray-800 px-3 py-1.5 text-xs hover:bg-gray-700"
                  >
                    Copy list
                  </button>
                </div>
              </div>

              {/* Grouped by category */}
              {(["Meat & Seafood", "Produce", "Dairy", "Pantry & Other"] as const).map(cat => {
                const items = grocery.filter(g => g.category === cat);
                if (!items.length) return null;
                return (
                  <div key={cat} className="mb-5">
                    <h3 className="mb-2 text-xs font-semibold uppercase tracking-wider text-gray-500">{cat}</h3>
                    <ul className="grid gap-1.5 sm:grid-cols-2 lg:grid-cols-3">
                      {items.map((g) => {
                        const added = addedToPantry.has(g.ingredient);
                        return (
                          <li key={g.ingredient} className="flex items-center gap-2 rounded-lg border border-gray-800 bg-gray-900 px-3 py-2 text-sm">
                            <span className="h-2 w-2 shrink-0 rounded-full bg-brand-500" />
                            <span className="flex-1">{g.ingredient}</span>
                            <button
                              onClick={() => !added && addToPantry(g.ingredient)}
                              title={added ? "Added to pantry" : "Add to pantry"}
                              className={`shrink-0 rounded px-1.5 py-0.5 text-xs transition ${
                                added
                                  ? "text-green-400 cursor-default"
                                  : "text-gray-600 hover:bg-gray-800 hover:text-brand-400"
                              }`}
                            >
                              {added ? "✓" : "+ pantry"}
                            </button>
                          </li>
                        );
                      })}
                    </ul>
                  </div>
                );
              })}
            </section>
          )}
        </>
      )}

      {/* ── Print-only view ─────────────────────────────────────── */}
      {plan && (
        <div className="hidden print:block print-view">
          <style>{`
            @media print {
              body * { visibility: hidden; }
              .print-view, .print-view * { visibility: visible; }
              .print-view { position: absolute; top: 0; left: 0; width: 100%; font-family: sans-serif; color: #000; }
              .print-section { page-break-inside: avoid; margin-bottom: 24px; }
              .print-table { width: 100%; border-collapse: collapse; font-size: 11px; }
              .print-table th, .print-table td { border: 1px solid #ccc; padding: 4px 6px; text-align: left; }
              .print-table th { background: #f0f0f0; font-weight: 600; }
              .recipe-card { border: 1px solid #ccc; border-radius: 6px; padding: 10px; margin: 6px; display: inline-block; width: 45%; vertical-align: top; font-size: 11px; }
              .recipe-card h3 { font-size: 13px; margin: 0 0 4px; }
              .recipe-card ul { padding-left: 16px; margin: 4px 0; }
              .grocery-cols { columns: 3; column-gap: 16px; }
              .grocery-item { break-inside: avoid; padding: 2px 0; border-bottom: 1px solid #eee; font-size: 12px; }
              .grocery-cat { font-weight: 700; font-size: 11px; text-transform: uppercase; letter-spacing: 0.05em; margin-top: 12px; margin-bottom: 4px; color: #555; }
            }
          `}</style>

          <h1 style={{ fontSize: 20, fontWeight: 700, marginBottom: 4 }}>
            Meal Plan — Week of {ws}
          </h1>
          <p style={{ fontSize: 12, color: "#555", marginBottom: 16 }}>
            Calorie goal: {calorieGoal} kcal/day
          </p>

          {/* Weekly grid */}
          <div className="print-section">
            <table className="print-table">
              <thead>
                <tr>
                  <th>Slot</th>
                  {DAYS.map(d => <th key={d}>{d}</th>)}
                </tr>
              </thead>
              <tbody>
                {SLOTS.map(slot => (
                  <tr key={slot}>
                    <td style={{ fontWeight: 600, textTransform: "capitalize" }}>{slot}</td>
                    {DAYS.map((_, di) => {
                      const items = plan.items.filter(i => i.day_of_week === di && i.slot === slot);
                      return (
                        <td key={di}>
                          {items.map(i => (
                            <div key={i.id} style={{ fontSize: 10, lineHeight: 1.3 }}>
                              {i.recipe.title}
                              {i.recipe.calories ? ` (${Math.round((i.recipe.calories / (i.recipe.servings ?? 1)) * i.servings)} kcal)` : ""}
                            </div>
                          ))}
                        </td>
                      );
                    })}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          {/* Recipe cards */}
          {plan.items.length > 0 && (
            <div className="print-section">
              <h2 style={{ fontSize: 15, fontWeight: 700, marginBottom: 8 }}>Recipe Cards</h2>
              <div>
                {Array.from(new Map(plan.items.map(i => [i.recipe.slug, i.recipe])).values()).map(r => (
                  <div key={r.slug} className="recipe-card">
                    <h3>{r.title}</h3>
                    {r.calories && <p style={{ margin: "2px 0", color: "#555" }}>{Math.round(r.calories)} kcal/serving</p>}
                    <a href={`https://0k.au/recipes/${r.slug}`} style={{ fontSize: 10, color: "#666" }}>
                      0k.au/recipes/{r.slug}
                    </a>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* Grocery list */}
          {grocery && grocery.length > 0 && (
            <div className="print-section">
              <h2 style={{ fontSize: 15, fontWeight: 700, marginBottom: 8 }}>Shopping List</h2>
              {(["Meat & Seafood", "Produce", "Dairy", "Pantry & Other"] as const).map(cat => {
                const items = grocery.filter(g => g.category === cat);
                if (!items.length) return null;
                return (
                  <div key={cat}>
                    <div className="grocery-cat">{cat}</div>
                    <div className="grocery-cols">
                      {items.map(g => (
                        <div key={g.ingredient} className="grocery-item">
                          ☐ {g.ingredient}
                        </div>
                      ))}
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </div>
      )}

      {/* Add-meal modal */}
      {addingTo && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/70 p-4" onClick={() => setAddingTo(null)}>
          <div className="w-full max-w-md rounded-2xl border border-gray-700 bg-gray-950 p-6" onClick={(e) => e.stopPropagation()}>
            <h2 className="mb-4 text-lg font-bold">
              Add {addingTo.slot} — {DAYS[addingTo.day]}
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
