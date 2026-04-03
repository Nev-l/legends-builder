"use client";
import { useState } from "react";
import useSWR from "swr";
import { api } from "@/lib/api";

const DAYS = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
const SLOTS = ["breakfast", "lunch", "dinner", "snack"] as const;
type Slot = (typeof SLOTS)[number];

interface MealPlanItem {
  id: number;
  day_of_week: number;
  slot: Slot;
  servings: number;
  recipe: { slug: string; title: string; image_url: string | null };
}

interface MealPlan {
  id: number;
  week_start: string;
  items: MealPlanItem[];
}

interface GroceryItem {
  ingredient: string;
  total_quantity: number;
  unit: string | null;
}

function weekStart(offset = 0) {
  const d = new Date();
  const day = d.getDay();
  const diff = (day === 0 ? -6 : 1 - day) + offset * 7;
  d.setDate(d.getDate() + diff);
  d.setHours(0, 0, 0, 0);
  return d.toISOString().slice(0, 10);
}

export default function PlannerPage() {
  const [weekOffset, setWeekOffset] = useState(0);
  const ws = weekStart(weekOffset);

  const { data: plans, mutate: mutatePlans } = useSWR<MealPlan[]>(
    "/meal-planner",
    (url: string) => api.get<MealPlan[]>(url)
  );

  const plan = plans?.find((p) => p.week_start.slice(0, 10) === ws);

  const { data: grocery } = useSWR<GroceryItem[]>(
    plan ? `/meal-planner/${plan.id}/grocery-list` : null,
    (url: string) => api.get<GroceryItem[]>(url)
  );

  async function createPlan() {
    await api.post("/meal-planner", { week_start: ws, items: [] });
    mutatePlans();
  }

  function cellItems(day: number, slot: Slot) {
    return plan?.items.filter((i) => i.day_of_week === day && i.slot === slot) ?? [];
  }

  return (
    <div>
      {/* Week nav */}
      <div className="mb-6 flex items-center justify-between">
        <h1 className="text-2xl font-extrabold">Meal Planner</h1>
        <div className="flex items-center gap-3">
          <button
            onClick={() => setWeekOffset((o) => o - 1)}
            className="rounded-lg bg-gray-800 px-3 py-1.5 text-sm hover:bg-gray-700"
          >
            ← Prev
          </button>
          <span className="text-sm text-gray-400">
            Week of <strong className="text-white">{ws}</strong>
          </span>
          <button
            onClick={() => setWeekOffset((o) => o + 1)}
            className="rounded-lg bg-gray-800 px-3 py-1.5 text-sm hover:bg-gray-700"
          >
            Next →
          </button>
        </div>
      </div>

      {!plan ? (
        <div className="py-16 text-center">
          <p className="mb-4 text-gray-500">No plan for this week yet.</p>
          <button
            onClick={createPlan}
            className="rounded-lg bg-brand-500 px-5 py-2.5 text-sm font-semibold text-white hover:bg-brand-600"
          >
            Create plan
          </button>
        </div>
      ) : (
        <>
          {/* Grid */}
          <div className="overflow-x-auto">
            <table className="w-full min-w-[700px] border-collapse text-sm">
              <thead>
                <tr>
                  <th className="w-24 p-2 text-left text-gray-500"></th>
                  {DAYS.map((d) => (
                    <th key={d} className="p-2 text-center font-semibold text-gray-300">
                      {d}
                    </th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {SLOTS.map((slot) => (
                  <tr key={slot} className="border-t border-gray-800">
                    <td className="p-2 capitalize text-gray-500">{slot}</td>
                    {DAYS.map((_, dayIdx) => {
                      const items = cellItems(dayIdx, slot);
                      return (
                        <td key={dayIdx} className="p-1 align-top">
                          <div className="min-h-[52px] rounded-lg border border-dashed border-gray-800 p-1">
                            {items.map((item) => (
                              <a
                                key={item.id}
                                href={`/recipes/${item.recipe.slug}`}
                                className="mb-1 flex items-center gap-1 rounded bg-gray-800 p-1 text-xs hover:bg-gray-700"
                              >
                                {item.recipe.image_url ? (
                                  <img
                                    src={item.recipe.image_url}
                                    alt=""
                                    className="h-7 w-7 rounded object-cover"
                                  />
                                ) : (
                                  <span className="text-base">🍽️</span>
                                )}
                                <span className="line-clamp-2 leading-tight">
                                  {item.recipe.title}
                                </span>
                              </a>
                            ))}
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
                      {g.total_quantity > 0 ? `${g.total_quantity}${g.unit ? ` ${g.unit}` : ""}` : ""}
                    </span>
                  </li>
                ))}
              </ul>
              <button
                onClick={() => {
                  const text = grocery
                    .map((g) => `${g.total_quantity}${g.unit ? ` ${g.unit}` : ""} ${g.ingredient}`)
                    .join("\n");
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
    </div>
  );
}
