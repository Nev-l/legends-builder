"use client";
import { useState } from "react";
import useSWR from "swr";
import { api } from "@/lib/api";

interface PantryItem {
  id: number;
  ingredient_name: string;
  quantity: number | null;
  unit: string | null;
  expires_on: string | null;
}

export default function PantryPage() {
  const { data: items, mutate, isLoading } = useSWR<PantryItem[]>(
    "/pantry",
    (url: string) => api.get<PantryItem[]>(url)
  );

  const [name, setName] = useState("");
  const [qty, setQty] = useState("");
  const [unit, setUnit] = useState("");
  const [expires, setExpires] = useState("");
  const [adding, setAdding] = useState(false);

  // Leftover wizard
  const [wizardResults, setWizardResults] = useState<
    { slug: string; title: string; match_count: number }[] | null
  >(null);
  const [wizardLoading, setWizardLoading] = useState(false);

  async function addItem(e: React.FormEvent) {
    e.preventDefault();
    if (!name.trim()) return;
    setAdding(true);
    try {
      await api.post("/pantry", {
        ingredient_name: name.trim(),
        quantity: qty ? parseFloat(qty) : null,
        unit: unit.trim() || null,
        expires_on: expires || null,
      });
      setName("");
      setQty("");
      setUnit("");
      setExpires("");
      mutate();
    } catch (e: any) {
      alert(e.message);
    } finally {
      setAdding(false);
    }
  }

  async function removeItem(id: number) {
    await api.delete(`/pantry/${id}`);
    mutate();
  }

  async function runWizard() {
    if (!items?.length) return;
    setWizardLoading(true);
    try {
      const names = items.map((i) => i.ingredient_name).join(",");
      const results = await api.get<{ slug: string; title: string; match_count: number }[]>(
        `/recipes/leftover-wizard/search?ingredients=${encodeURIComponent(names)}`
      );
      setWizardResults(results);
    } catch (e: any) {
      alert(e.message);
    } finally {
      setWizardLoading(false);
    }
  }

  function expiryColor(dateStr: string | null) {
    if (!dateStr) return "";
    const days = (new Date(dateStr).getTime() - Date.now()) / 86400000;
    if (days < 0) return "text-red-400";
    if (days <= 3) return "text-yellow-400";
    return "text-gray-400";
  }

  return (
    <div>
      <div className="mb-6 flex items-center justify-between">
        <h1 className="text-2xl font-extrabold">Pantry</h1>
        <button
          onClick={runWizard}
          disabled={wizardLoading || !items?.length}
          className="rounded-lg bg-brand-500 px-4 py-2 text-sm font-semibold text-white hover:bg-brand-600 disabled:opacity-50"
        >
          {wizardLoading ? "Searching…" : "✨ Leftover wizard"}
        </button>
      </div>

      {/* Add form */}
      <form onSubmit={addItem} className="mb-8 flex flex-wrap gap-2">
        <input
          className="flex-1 min-w-[160px] rounded-lg border border-gray-700 bg-gray-900 px-3 py-2 text-sm placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-brand-500"
          placeholder="Ingredient name"
          value={name}
          onChange={(e) => setName(e.target.value)}
          required
        />
        <input
          className="w-24 rounded-lg border border-gray-700 bg-gray-900 px-3 py-2 text-sm placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-brand-500"
          placeholder="Qty"
          type="number"
          min="0"
          step="any"
          value={qty}
          onChange={(e) => setQty(e.target.value)}
        />
        <input
          className="w-24 rounded-lg border border-gray-700 bg-gray-900 px-3 py-2 text-sm placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-brand-500"
          placeholder="Unit"
          value={unit}
          onChange={(e) => setUnit(e.target.value)}
        />
        <input
          type="date"
          className="rounded-lg border border-gray-700 bg-gray-900 px-3 py-2 text-sm text-gray-300 focus:outline-none focus:ring-2 focus:ring-brand-500"
          value={expires}
          onChange={(e) => setExpires(e.target.value)}
          title="Expiry date"
        />
        <button
          type="submit"
          disabled={adding}
          className="rounded-lg bg-brand-500 px-4 py-2 text-sm font-semibold text-white hover:bg-brand-600 disabled:opacity-50"
        >
          {adding ? "Adding…" : "Add"}
        </button>
      </form>

      {/* Items list */}
      {isLoading ? (
        <p className="text-center text-gray-500">Loading…</p>
      ) : !items?.length ? (
        <p className="text-center text-gray-500">Your pantry is empty. Add some ingredients above.</p>
      ) : (
        <ul className="space-y-2">
          {items.map((item) => (
            <li
              key={item.id}
              className="flex items-center gap-3 rounded-xl border border-gray-800 bg-gray-900 px-4 py-3 text-sm"
            >
              <span className="flex-1 font-medium">{item.ingredient_name}</span>
              {item.quantity != null && (
                <span className="text-gray-400 tabular-nums">
                  {item.quantity}{item.unit ? ` ${item.unit}` : ""}
                </span>
              )}
              {item.expires_on && (
                <span className={`tabular-nums ${expiryColor(item.expires_on)}`}>
                  exp {item.expires_on.slice(0, 10)}
                </span>
              )}
              <button
                onClick={() => removeItem(item.id)}
                className="ml-2 rounded p-1 text-gray-600 hover:bg-gray-800 hover:text-red-400"
                title="Remove"
              >
                ✕
              </button>
            </li>
          ))}
        </ul>
      )}

      {/* Leftover wizard results */}
      {wizardResults && (
        <section className="mt-10">
          <h2 className="mb-3 text-lg font-bold">What can I make?</h2>
          {wizardResults.length === 0 ? (
            <p className="text-gray-500">No matching recipes found with your pantry ingredients.</p>
          ) : (
            <ul className="space-y-2">
              {wizardResults.map((r) => (
                <li key={r.slug}>
                  <a
                    href={`/${r.slug}`}
                    className="flex items-center justify-between rounded-xl border border-gray-800 bg-gray-900 px-4 py-3 text-sm hover:border-brand-500"
                  >
                    <span className="font-medium">{r.title}</span>
                    <span className="text-gray-500">{r.match_count} ingredient{r.match_count !== 1 ? "s" : ""} matched</span>
                  </a>
                </li>
              ))}
            </ul>
          )}
        </section>
      )}
    </div>
  );
}
