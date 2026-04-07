"use client";
import { useState, useRef, useEffect } from "react";
import useSWR from "swr";
import { api } from "@/lib/api";

const COMMON_PANTRY = {
  "Spices & Seasonings": [
    "Salt", "Black pepper", "Chilli flakes", "Paprika", "Cumin", "Turmeric",
    "Garlic powder", "Onion powder", "Oregano", "Thyme", "Rosemary", "Cinnamon",
    "Nutmeg", "Cayenne", "Mixed herbs", "Curry powder", "Garam masala",
  ],
  "Oils & Condiments": [
    "Olive oil", "Vegetable oil", "Coconut oil", "Butter", "White vinegar",
    "Apple cider vinegar", "Soy sauce", "Fish sauce", "Worcestershire sauce",
    "Tomato paste", "Dijon mustard", "Hot sauce", "Honey", "Maple syrup",
  ],
  "Baking & Dry Goods": [
    "Plain flour", "Self-raising flour", "Baking powder", "Baking soda",
    "Sugar", "Brown sugar", "Icing sugar", "Cornflour", "Rolled oats",
    "Breadcrumbs", "Dried pasta", "White rice", "Basmati rice", "Lentils",
  ],
  "Canned & Jarred": [
    "Canned tomatoes", "Coconut milk", "Chickpeas", "Kidney beans",
    "Black beans", "Chicken stock", "Vegetable stock", "Tuna",
    "Tomato sauce", "Peanut butter",
  ],
  "Kitchen Essentials": [
    "Aluminium foil", "Baking paper", "Glad wrap", "Zip lock bags",
    "Paper towel",
  ],
};

function CommonPantryItems({ onAdd, existingItems }: {
  onAdd: (name: string) => void;
  existingItems: string[];
}) {
  const [open, setOpen] = useState(false);
  const [added, setAdded] = useState<Set<string>>(new Set());

  function handleAdd(item: string) {
    if (existingItems.includes(item.toLowerCase()) || added.has(item)) return;
    onAdd(item);
    setAdded(prev => new Set([...prev, item]));
  }

  return (
    <div className="mb-6">
      <button
        onClick={() => setOpen(o => !o)}
        className="flex items-center gap-2 rounded-xl border border-dashed border-gray-700 px-4 py-2.5 text-sm text-gray-400 hover:border-brand-500 hover:text-brand-400 transition-colors"
      >
        <span>🛒</span>
        <span>{open ? "Hide" : "Add common pantry items"}</span>
        <span className="ml-auto text-xs text-gray-600">{open ? "▲" : "▼"}</span>
      </button>
      {open && (
        <div className="mt-3 rounded-xl border border-gray-800 bg-gray-900 p-4">
          <p className="mb-4 text-xs text-gray-500">Click items to add them to your pantry. Already-added items are greyed out.</p>
          {Object.entries(COMMON_PANTRY).map(([cat, items]) => (
            <div key={cat} className="mb-4">
              <p className="mb-2 text-xs font-semibold uppercase tracking-wider text-gray-500">{cat}</p>
              <div className="flex flex-wrap gap-2">
                {items.map(item => {
                  const isAdded = existingItems.includes(item.toLowerCase()) || added.has(item);
                  return (
                    <button
                      key={item}
                      onClick={() => handleAdd(item)}
                      disabled={isAdded}
                      className={`rounded-full border px-3 py-1 text-xs transition-colors ${
                        isAdded
                          ? "border-gray-800 bg-gray-800 text-gray-600 cursor-default"
                          : "border-gray-700 bg-gray-800 text-gray-300 hover:border-brand-500 hover:text-brand-400"
                      }`}
                    >
                      {isAdded ? "✓ " : "+ "}{item}
                    </button>
                  );
                })}
              </div>
            </div>
          ))}
          <button
            onClick={() => {
              Object.values(COMMON_PANTRY).flat().forEach(item => handleAdd(item));
            }}
            className="mt-2 rounded-lg bg-brand-500/20 px-4 py-2 text-xs font-semibold text-brand-400 hover:bg-brand-500 hover:text-white transition-colors"
          >
            + Add all missing items
          </button>
        </div>
      )}
    </div>
  );
}

interface PantryItem {
  id: number;
  ingredient_name: string;
  quantity: number | null;
  unit: string | null;
  expires_on: string | null;
}

interface OcrResult {
  added: PantryItem[];
  raw_text: string;
  message?: string;
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

  // OCR state
  const [ocrLoading, setOcrLoading] = useState(false);
  const [ocrResult, setOcrResult] = useState<OcrResult | null>(null);
  const [showRaw, setShowRaw] = useState(false);
  const fileRef = useRef<HTMLInputElement>(null);

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
      setName(""); setQty(""); setUnit(""); setExpires("");
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

  async function handleReceiptUpload(e: React.ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0];
    if (!file) return;
    setOcrLoading(true);
    setOcrResult(null);
    try {
      const token = typeof window !== "undefined" ? localStorage.getItem("rh_token") : null;
      const formData = new FormData();
      formData.append("file", file);
      const res = await fetch("/recipes/api/pantry/ocr-receipt", {
        method: "POST",
        headers: token ? { Authorization: `Bearer ${token}` } : {},
        body: formData,
      });
      if (!res.ok) {
        const err = await res.json().catch(() => ({ detail: res.statusText }));
        throw new Error(err.detail ?? "Upload failed");
      }
      const data: OcrResult = await res.json();
      setOcrResult(data);
      mutate();
    } catch (err: any) {
      alert(err.message);
    } finally {
      setOcrLoading(false);
      // Reset file input so same file can be re-uploaded
      if (fileRef.current) fileRef.current.value = "";
    }
  }

  function expiryColor(dateStr: string | null) {
    if (!dateStr) return "";
    const days = (new Date(dateStr).getTime() - Date.now()) / 86400000;
    if (days < 0) return "text-red-400";
    if (days <= 3) return "text-yellow-400";
    return "text-gray-400";
  }

  const isLoggedIn = typeof window !== "undefined" && !!localStorage.getItem("rh_token");

  return (
    <div>
      <div className="mb-6 flex flex-wrap items-center justify-between gap-3">
        <h1 className="text-2xl font-extrabold">Pantry</h1>
        <div className="flex flex-wrap gap-2">
          {/* Receipt scan button */}
          <label className={`inline-flex cursor-pointer items-center gap-2 rounded-lg border border-gray-700 px-4 py-2 text-sm font-semibold hover:border-brand-500 hover:text-brand-400 ${!isLoggedIn ? "opacity-50 pointer-events-none" : ""}`}>
            {ocrLoading ? (
              <span className="text-gray-400">Scanning…</span>
            ) : (
              <>
                <span>📷</span>
                <span>Scan receipt</span>
              </>
            )}
            <input
              ref={fileRef}
              type="file"
              accept="image/*"
              capture="environment"
              className="hidden"
              onChange={handleReceiptUpload}
              disabled={ocrLoading || !isLoggedIn}
            />
          </label>
          <button
            onClick={runWizard}
            disabled={wizardLoading || !items?.length}
            className="rounded-lg bg-brand-500 px-4 py-2 text-sm font-semibold text-white hover:bg-brand-600 disabled:opacity-50"
          >
            {wizardLoading ? "Searching…" : "✨ What can I make?"}
          </button>
        </div>
      </div>

      {!isLoggedIn && (
        <div className="mb-6 rounded-xl border border-yellow-800 bg-yellow-950/40 px-4 py-3 text-sm text-yellow-300">
          <a href="/recipes/login" className="font-semibold underline">Sign in</a> to save your pantry.
        </div>
      )}

      {/* OCR result banner */}
      {ocrResult && (
        <div className="mb-6 rounded-xl border border-green-800 bg-green-950/40 px-4 py-4">
          <div className="flex items-center justify-between">
            <p className="text-sm font-semibold text-green-300">
              {ocrResult.message ?? `Added ${ocrResult.added.length} item${ocrResult.added.length !== 1 ? "s" : ""} from receipt`}
            </p>
            <button
              onClick={() => setOcrResult(null)}
              className="text-xs text-gray-500 hover:text-white"
            >
              Dismiss
            </button>
          </div>
          {ocrResult.added.length > 0 && (
            <ul className="mt-2 flex flex-wrap gap-1.5">
              {ocrResult.added.map((i) => (
                <li key={i.id} className="rounded-full bg-green-900/60 px-2.5 py-0.5 text-xs text-green-200">
                  {i.ingredient_name}{i.quantity ? ` (${i.quantity}${i.unit ? ` ${i.unit}` : ""})` : ""}
                </li>
              ))}
            </ul>
          )}
          <button
            onClick={() => setShowRaw(!showRaw)}
            className="mt-2 text-xs text-gray-500 hover:text-gray-300"
          >
            {showRaw ? "Hide" : "Show"} raw OCR text
          </button>
          {showRaw && (
            <pre className="mt-2 max-h-48 overflow-y-auto whitespace-pre-wrap rounded-lg bg-gray-900 p-3 text-xs text-gray-400">
              {ocrResult.raw_text}
            </pre>
          )}
        </div>
      )}

      {/* Manual add form */}
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

      {/* Common pantry items prefill */}
      {isLoggedIn && (
        <CommonPantryItems onAdd={(name) => {
          api.post("/pantry", { ingredient_name: name, quantity: null, unit: null, expires_on: null })
            .then(() => mutate())
            .catch(() => {});
        }} existingItems={items?.map(i => i.ingredient_name.toLowerCase()) ?? []} />
      )}

      {/* Items list */}
      {isLoading ? (
        <p className="text-center text-gray-500">Loading…</p>
      ) : !items?.length ? (
        <p className="text-center text-gray-500">Your pantry is empty. Add ingredients above or scan a receipt.</p>
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
                    href={`/recipes/${r.slug}`}
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
