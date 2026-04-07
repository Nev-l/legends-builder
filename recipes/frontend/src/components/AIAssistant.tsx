"use client";
import { useState, useRef, useEffect } from "react";
import { api } from "@/lib/api";

interface Message {
  role: "user" | "assistant";
  content: string;
}

interface Profile {
  height_cm: string;
  weight_kg: string;
  target_weight_kg: string;
  age: string;
  sex: string;
  activity: string;
  goal: string;
  max_time: string;
}

interface Tastes {
  breakfast_styles: string[];   // multi-select chips
  lunch_styles: string[];
  dinner_styles: string[];
  snack_styles: string[];
  disliked_foods: string;       // freeform comma list
  cuisine_prefs: string[];
  consistent_meals: boolean;    // repeat same meals vs variety
  lazy_cook: boolean;           // minimal ingredients, quick prep
  extra_notes: string;
}

const STORAGE_KEY  = "raul_chat_history";
const PROFILE_KEY  = "raul_user_profile";
const TASTES_KEY   = "raul_user_tastes";
const DAY_NAMES    = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"];

// ── Taste option sets ─────────────────────────────────────────────────────────

const BREAKFAST_OPTIONS = [
  "Overnight oats","Oatmeal / porridge","Eggs & bacon","Scrambled eggs","Omelette",
  "Smoothie bowl","Avocado toast","Pancakes / waffles","Frittata","Greek yogurt bowl",
  "Protein shake","Granola","Fruit salad","Breakfast burrito","Chia pudding",
];
const LUNCH_OPTIONS = [
  "Chicken salad","Tuna wrap","Grain bowl","Soup","Sandwich / roll",
  "Sushi / poke bowl","Stir-fry","Pasta salad","Leftovers","Grilled chicken & veg",
  "Caesar salad","Quinoa bowl","Toasted wrap","Noodle salad","BLT",
];
const DINNER_OPTIONS = [
  "Chicken & rice","Steak","Salmon fillet","Pasta","Stir-fry",
  "BBQ / grill","Curry","Tacos / burritos","Roast","Burger",
  "Schnitzel","Fried rice","Noodles","Casserole","Pizza",
];
const SNACK_OPTIONS = [
  "Protein shake","Greek yogurt","Boiled eggs","Nuts & seeds","Fruit",
  "Rice cakes","Protein bar","Hummus & veg","Cheese & crackers","Bliss balls",
  "Cottage cheese","Tuna on crackers","Dark chocolate","Apple & PB","Smoothie",
];
const CUISINE_OPTIONS = [
  "Asian","Mediterranean","Mexican","Italian","Indian",
  "Middle Eastern","Japanese","Thai","American","Greek",
  "French","Spanish","Korean","Vietnamese","Lebanese",
];

// ── Preset defaults per goal for smart filling ───────────────────────────────

const GOAL_BREAKFAST_DEFAULTS: Record<string, string[]> = {
  lose_fast: ["Overnight oats","Greek yogurt bowl","Protein shake"],
  lose:      ["Overnight oats","Scrambled eggs","Smoothie bowl"],
  maintain:  ["Eggs & bacon","Oatmeal / porridge","Avocado toast"],
  gain:      ["Pancakes / waffles","Breakfast burrito","Protein shake"],
  gain_fast: ["Breakfast burrito","Pancakes / waffles","Granola"],
};
const GOAL_DINNER_DEFAULTS: Record<string, string[]> = {
  lose_fast: ["Chicken & rice","Salmon fillet","Stir-fry"],
  lose:      ["Chicken & rice","Steak","Grilled fish"],
  maintain:  ["Steak","Pasta","Stir-fry"],
  gain:      ["Steak","Burger","Pasta"],
  gain_fast: ["Burger","Pasta","BBQ / grill"],
};

// ── Labels ───────────────────────────────────────────────────────────────────

const ACTIVITY_LABELS: Record<string, string> = {
  sedentary:   "Sedentary (desk job, little exercise)",
  light:       "Light (1–3 days/week exercise)",
  moderate:    "Moderate (3–5 days/week)",
  active:      "Active (6–7 days/week)",
  very_active: "Very Active (physical job + gym)",
};
const GOAL_LABELS: Record<string, string> = {
  lose_fast: "Lose weight fast (aggressive cut)",
  lose:      "Lose weight (steady cut)",
  maintain:  "Maintain current weight",
  gain:      "Build muscle (lean bulk)",
  gain_fast: "Bulk up (aggressive bulk)",
};

// ── TDEE helpers ──────────────────────────────────────────────────────────────

function calcTDEE(p: Profile): { bmr: number; tdee: number; target: number; deficit: number } | null {
  const h = parseFloat(p.height_cm);
  const w = parseFloat(p.weight_kg);
  const a = parseInt(p.age);
  if (!h || !w || !a) return null;
  const bmr = p.sex === "female"
    ? 10 * w + 6.25 * h - 5 * a - 161
    : 10 * w + 6.25 * h - 5 * a + 5;
  const mult: Record<string, number> = {
    sedentary: 1.2, light: 1.375, moderate: 1.55, active: 1.725, very_active: 1.9,
  };
  const tdee = Math.round(bmr * (mult[p.activity] || 1.55));
  const adj: Record<string, number> = {
    lose_fast: -750, lose: -500, maintain: 0, gain: 300, gain_fast: 500,
  };
  const deficit = adj[p.goal] || -500;
  return { bmr: Math.round(bmr), tdee, target: tdee + deficit, deficit };
}

function estimateTimeline(p: Profile): string {
  const current = parseFloat(p.weight_kg);
  const goal    = parseFloat(p.target_weight_kg);
  if (!current || !goal) return "";
  const diff = current - goal;
  if (Math.abs(diff) < 0.5) return "You're already at your goal weight!";
  const rate: Record<string, number> = {
    lose_fast: 0.75, lose: 0.5, maintain: 0, gain: 0.3, gain_fast: 0.5,
  };
  const kgPerWeek = rate[p.goal] || 0.5;
  if (!kgPerWeek) return "Maintenance — no weight change expected.";
  const dir = diff > 0 ? "lose" : "gain";
  const weeks = Math.ceil(Math.abs(diff) / kgPerWeek);
  return `To ${dir} ${Math.abs(diff).toFixed(1)}kg at ~${kgPerWeek}kg/week: approx ${weeks} weeks (${(weeks / 4.33).toFixed(1)} months).`;
}

// ── Chip selector component ───────────────────────────────────────────────────

function ChipSelect({
  options, selected, onChange, max = 6,
}: { options: string[]; selected: string[]; onChange: (v: string[]) => void; max?: number }) {
  function toggle(opt: string) {
    if (selected.includes(opt)) {
      onChange(selected.filter(s => s !== opt));
    } else if (selected.length < max) {
      onChange([...selected, opt]);
    }
  }
  return (
    <div className="flex flex-wrap gap-1.5">
      {options.map(opt => {
        const on = selected.includes(opt);
        return (
          <button key={opt} type="button" onClick={() => toggle(opt)}
            className={`rounded-full border px-2.5 py-1 text-xs transition-colors ${
              on
                ? "border-brand-500 bg-brand-500/20 text-brand-300"
                : "border-gray-700 bg-gray-800 text-gray-400 hover:border-gray-600"
            }`}>
            {on ? "✓ " : ""}{opt}
          </button>
        );
      })}
    </div>
  );
}

// ── Message renderer ──────────────────────────────────────────────────────────

function RaulMessage({ text }: { text: string }) {
  const lines = text.split("\n");
  const elements: React.ReactNode[] = [];
  let key = 0;
  for (const line of lines) {
    const trimmed = line.trim();
    if (!trimmed) { elements.push(<div key={key++} className="h-1" />); }
    else if (/^#{1,3}\s/.test(trimmed)) {
      elements.push(<p key={key++} className="font-bold text-brand-400 mt-2 mb-0.5">{trimmed.replace(/^#+\s/, "")}</p>);
    } else if (/^[•\-\*]\s/.test(trimmed)) {
      elements.push(
        <div key={key++} className="flex gap-2 items-start">
          <span className="mt-0.5 shrink-0 text-brand-400">•</span>
          <span>{renderInline(trimmed.replace(/^[•\-\*]\s/, ""))}</span>
        </div>
      );
    } else if (/^\d+\.\s/.test(trimmed)) {
      const num = trimmed.match(/^(\d+)\./)?.[1];
      elements.push(
        <div key={key++} className="flex gap-2 items-start">
          <span className="mt-0.5 shrink-0 font-bold text-brand-400">{num}.</span>
          <span>{renderInline(trimmed.replace(/^\d+\.\s/, ""))}</span>
        </div>
      );
    } else if (/^(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday|Day \d)/i.test(trimmed)) {
      elements.push(<p key={key++} className="font-bold text-white mt-3 border-t border-gray-700 pt-2">{trimmed}</p>);
    } else if (/^(Breakfast|Lunch|Dinner|Snack):/i.test(trimmed)) {
      const [slot, ...rest] = trimmed.split(":");
      elements.push(
        <div key={key++} className="flex gap-2 text-xs mt-1">
          <span className="shrink-0 font-semibold text-brand-400 w-16">{slot}:</span>
          <span className="text-gray-300">{rest.join(":").trim()}</span>
        </div>
      );
    } else {
      elements.push(<p key={key++} className="leading-snug">{renderInline(trimmed)}</p>);
    }
  }
  return <div className="space-y-0.5">{elements}</div>;
}

function renderInline(text: string): React.ReactNode {
  const parts = text.split(/(\*\*[^*]+\*\*)/g);
  return parts.map((p, i) =>
    p.startsWith("**") && p.endsWith("**")
      ? <strong key={i} className="text-white font-semibold">{p.slice(2, -2)}</strong>
      : p
  );
}

// ── Main component ────────────────────────────────────────────────────────────

const DEFAULT_TASTES: Tastes = {
  breakfast_styles: [],
  lunch_styles: [],
  dinner_styles: [],
  snack_styles: [],
  disliked_foods: "",
  cuisine_prefs: [],
  consistent_meals: false,
  lazy_cook: false,
  extra_notes: "",
};

const DEFAULT_PROFILE: Profile = {
  height_cm: "", weight_kg: "", target_weight_kg: "",
  age: "", sex: "male", activity: "moderate", goal: "lose", max_time: "",
};

export default function AIAssistant() {
  const [isOpen,       setIsOpen]       = useState(false);
  const [messages,     setMessages]     = useState<Message[]>([]);
  const [input,        setInput]        = useState("");
  const [loading,      setLoading]      = useState(false);
  const [isLoggedIn,   setIsLoggedIn]   = useState(false);
  const [showForm,     setShowForm]     = useState(false);
  const [formTab,      setFormTab]      = useState<"stats"|"tastes">("stats");
  const [applyingPlan, setApplyingPlan] = useState(false);
  const [profile,      setProfile]      = useState<Profile>(DEFAULT_PROFILE);
  const [tastes,       setTastes]       = useState<Tastes>(DEFAULT_TASTES);
  const scrollRef  = useRef<HTMLDivElement>(null);
  const inputRef   = useRef<HTMLTextAreaElement>(null);

  // ── Persist / restore ──────────────────────────────────────────────────────

  useEffect(() => {
    setIsLoggedIn(!!localStorage.getItem("rh_token"));
    try {
      const saved = localStorage.getItem(STORAGE_KEY);
      if (saved) setMessages(JSON.parse(saved));
      const savedProfile = localStorage.getItem(PROFILE_KEY);
      if (savedProfile) setProfile({ ...DEFAULT_PROFILE, ...JSON.parse(savedProfile) });
      const savedTastes = localStorage.getItem(TASTES_KEY);
      if (savedTastes) setTastes({ ...DEFAULT_TASTES, ...JSON.parse(savedTastes) });
    } catch {}
  }, []);

  useEffect(() => {
    if (messages.length > 0) localStorage.setItem(STORAGE_KEY, JSON.stringify(messages.slice(-60)));
  }, [messages]);

  useEffect(() => {
    if (scrollRef.current) scrollRef.current.scrollTop = scrollRef.current.scrollHeight;
  }, [messages, loading, showForm]);

  useEffect(() => {
    if (isOpen) setTimeout(() => inputRef.current?.focus(), 100);
  }, [isOpen]);

  function saveProfile(p: Profile) {
    setProfile(p);
    localStorage.setItem(PROFILE_KEY, JSON.stringify(p));
  }

  function saveTastes(t: Tastes) {
    setTastes(t);
    localStorage.setItem(TASTES_KEY, JSON.stringify(t));
    // Sync to backend if logged in
    if (isLoggedIn) {
      api.post("/ai/prefs", {
        breakfast_styles: t.breakfast_styles,
        lunch_styles:     t.lunch_styles,
        dinner_styles:    t.dinner_styles,
        snack_styles:     t.snack_styles,
        disliked_foods:   t.disliked_foods.split(",").map(s => s.trim()).filter(Boolean),
        cuisine_prefs:    t.cuisine_prefs,
        consistent_meals: t.consistent_meals,
        lazy_cook:        t.lazy_cook,
        extra_notes:      t.extra_notes,
      }).catch(() => {});
    }
  }

  // Load prefs from backend on login
  useEffect(() => {
    if (!isLoggedIn) return;
    api.get<any>("/ai/prefs").then(prefs => {
      if (prefs && Object.keys(prefs).length > 0) {
        const merged: Tastes = {
          breakfast_styles: prefs.breakfast_styles || [],
          lunch_styles:     prefs.lunch_styles || [],
          dinner_styles:    prefs.dinner_styles || [],
          snack_styles:     prefs.snack_styles || [],
          disliked_foods:   (prefs.disliked_foods || []).join(", "),
          cuisine_prefs:    prefs.cuisine_prefs || [],
          consistent_meals: prefs.consistent_meals ?? false,
          lazy_cook:        prefs.lazy_cook ?? false,
          extra_notes:      prefs.extra_notes || "",
        };
        setTastes(merged);
        localStorage.setItem(TASTES_KEY, JSON.stringify(merged));
      }
    }).catch(() => {});
  }, [isLoggedIn]);

  // ── Build context string Raul gets injected with on every message ──────────

  function buildTasteContext(): string {
    const parts: string[] = [];
    if (tastes.breakfast_styles.length)  parts.push(`Breakfast preferences: ${tastes.breakfast_styles.join(", ")}`);
    if (tastes.lunch_styles.length)      parts.push(`Lunch preferences: ${tastes.lunch_styles.join(", ")}`);
    if (tastes.dinner_styles.length)     parts.push(`Dinner preferences: ${tastes.dinner_styles.join(", ")}`);
    if (tastes.snack_styles.length)      parts.push(`Snack preferences: ${tastes.snack_styles.join(", ")}`);
    if (tastes.cuisine_prefs.length)     parts.push(`Favourite cuisines: ${tastes.cuisine_prefs.join(", ")}`);
    if (tastes.disliked_foods.trim())    parts.push(`Dislikes: ${tastes.disliked_foods}`);
    if (tastes.consistent_meals)         parts.push("Prefers consistent / repeating meals rather than variety.");
    if (tastes.lazy_cook)                parts.push("LAZY COOK MODE: recommend only dead-simple meals with 5 or fewer ingredients and under 15 minutes prep+cook.");
    if (tastes.extra_notes.trim())       parts.push(`Extra notes: ${tastes.extra_notes}`);
    return parts.length ? `\n\n[USER TASTE PROFILE]\n${parts.join("\n")}` : "";
  }

  // ── Clear requests ─────────────────────────────────────────────────────────

  function detectClearRequest(text: string): { type: "all"|"day"|"slot"|"cell"; day?: number; slot?: string } | null {
    const t = text.toLowerCase();
    if (!/\b(clear|wipe|delete|remove|empty|reset)\b/.test(t)) return null;
    const days: Record<string, number> = {
      monday:0,mon:0,tuesday:1,tue:1,wednesday:2,wed:2,
      thursday:3,thu:3,friday:4,fri:4,saturday:5,sat:5,sunday:6,sun:6,
    };
    const slots: Record<string,string> = {
      breakfast:"breakfast",lunch:"lunch",dinner:"dinner",snack:"snack",snacks:"snack",
    };
    let foundDay: number | null = null;
    let foundSlot: string | null = null;
    for (const [d, n] of Object.entries(days)) { if (t.includes(d)) { foundDay = n; break; } }
    for (const [s, v] of Object.entries(slots)) { if (t.includes(s)) { foundSlot = v; break; } }
    if (/\b(whole|entire|full|all|everything|week|plan)\b/.test(t) && foundDay === null && !foundSlot) return { type: "all" };
    if (foundDay !== null && foundSlot) return { type: "cell", day: foundDay, slot: foundSlot };
    if (foundDay !== null) return { type: "day", day: foundDay };
    if (foundSlot) return { type: "slot", slot: foundSlot };
    return null;
  }

  // ── Replace requests ("replace breakfast with boiled eggs") ───────────────

  function detectReplaceRequest(text: string): { type: "slot"|"day"|"cell"; day?: number; slot?: string; keyword: string } | null {
    const t = text.toLowerCase();
    if (!/\b(replace|fill|swap out|change all|set all|make all|use|put)\b/.test(t)) return null;
    const days: Record<string,number> = {
      monday:0,mon:0,tuesday:1,tue:1,wednesday:2,wed:2,
      thursday:3,thu:3,friday:4,fri:4,saturday:5,sat:5,sunday:6,sun:6,
    };
    const slots: Record<string,string> = {
      breakfast:"breakfast",lunch:"lunch",dinner:"dinner",snack:"snack",snacks:"snack",
    };
    let foundDay: number | null = null;
    let foundSlot: string | null = null;
    let keyword = "";
    for (const [d, n] of Object.entries(days)) { if (t.includes(d)) { foundDay = n; break; } }
    for (const [s, v] of Object.entries(slots)) { if (t.includes(s)) { foundSlot = v; break; } }

    // Extract what they want to replace with
    const withMatch = /\b(?:with|to)\s+(.+?)(?:\s+every|\s+for|$)/.exec(t);
    const asMatch   = /\b(?:as|like)\s+(.+?)(?:\s+every|\s+for|$)/.exec(t);
    const raw = withMatch?.[1] || asMatch?.[1] || "";
    keyword = raw.trim().replace(/[.,!?]$/, "");

    if (!keyword || (!foundSlot && foundDay === null)) return null;
    if (foundDay !== null && foundSlot) return { type: "cell", day: foundDay, slot: foundSlot, keyword };
    if (foundDay !== null) return { type: "day", day: foundDay, keyword };
    if (foundSlot) return { type: "slot", slot: foundSlot, keyword };
    return null;
  }

  // ── Start fresh / restart ─────────────────────────────────────────────────

  function detectRestartRequest(text: string): boolean {
    return /\b(start fresh|start over|restart|reset raul|new profile|redo my profile|fill in again|update my details|change my details|edit profile|fresh start)\b/i.test(text);
  }

  // ── Get current plan helper ────────────────────────────────────────────────

  async function getCurrentPlan(): Promise<{ id: number; items: any[] } | null> {
    const plans: any = await api.get("/meal-planner");
    if (!Array.isArray(plans)) return null;
    const today = new Date();
    const dow = today.getDay();
    const monday = new Date(today);
    monday.setDate(today.getDate() - (dow === 0 ? 6 : dow - 1));
    const ws = `${monday.getFullYear()}-${String(monday.getMonth()+1).padStart(2,"0")}-${String(monday.getDate()).padStart(2,"0")}`;
    return plans.find((p: any) => p.week_start?.slice(0, 10) === ws) ?? null;
  }

  async function executeClear(req: { type: "all"|"day"|"slot"|"cell"; day?: number; slot?: string }): Promise<string | null> {
    try {
      const plan = await getCurrentPlan();
      if (!plan) return "No plan found for this week, Amigo!";
      if (req.type === "all") {
        await api.delete(`/meal-planner/${plan.id}/items`);
        return "Wiped the whole week clean, Amigo! Blank canvas — let's rebuild it!";
      }
      if (req.type === "day" && req.day !== undefined) {
        await api.delete(`/meal-planner/${plan.id}/day/${req.day}`);
        return `Cleared all meals for ${DAY_NAMES[req.day]}. What do you want there instead?`;
      }
      if (req.type === "slot" && req.slot) {
        await api.delete(`/meal-planner/${plan.id}/slot/${req.slot}`);
        return `Cleared the entire ${cap(req.slot)} row for the week. Want me to fill it back up?`;
      }
      if (req.type === "cell" && req.day !== undefined && req.slot) {
        const item = plan.items?.find((i: any) => i.day_of_week === req.day && i.slot === req.slot);
        if (item) {
          await api.delete(`/meal-planner/${plan.id}/items/${item.id}`);
          return `Removed ${cap(req.slot!)} from ${DAY_NAMES[req.day!]}. Want something specific there?`;
        }
        return "Nothing in that slot to clear, Amigo!";
      }
    } catch {}
    return null;
  }

  // ── Replace slot/day with a repeated meal ─────────────────────────────────

  async function executeReplace(req: { type: "slot"|"day"|"cell"; day?: number; slot?: string; keyword: string }): Promise<string | null> {
    try {
      const plan = await getCurrentPlan();
      if (!plan) {
        const today = new Date();
        const dow = today.getDay();
        const monday = new Date(today);
        monday.setDate(today.getDate() - (dow === 0 ? 6 : dow - 1));
        const ws = `${monday.getFullYear()}-${String(monday.getMonth()+1).padStart(2,"0")}-${String(monday.getDate()).padStart(2,"0")}`;
        await api.post("/meal-planner", { week_start: ws, items: [] });
      }
      const freshPlan = await getCurrentPlan();
      if (!freshPlan) return "Couldn't find or create a plan, Amigo!";

      const slots  = req.slot ? [req.slot] : ["breakfast","lunch","dinner","snack"];
      const days   = req.day !== undefined ? [req.day] : [0,1,2,3,4,5,6];
      let filled = 0;
      for (const dayIdx of days) {
        for (const slot of slots) {
          const res: any = await api.post(`/meal-planner/${freshPlan.id}/smart-update`, {
            day_of_week: dayIdx, slot, keyword: req.keyword,
          }).catch(() => null);
          if (res?.ok) filled++;
        }
      }
      if (!filled) {
        // Raul creates the recipe then retries
        setMessages(prev => [...prev, {
          role: "assistant",
          content: `No "${req.keyword}" in the recipe base — let me create one! 👨‍🍳`,
        }]);
        const created: any = await api.post("/ai/create-recipe", {
          title: req.keyword, servings: 2,
          max_time_minutes: profile.max_time ? parseInt(profile.max_time) : undefined,
        }).catch(() => null);
        if (created?.slug) {
          for (const dayIdx of days) {
            for (const slot of slots) {
              await api.post(`/meal-planner/${freshPlan.id}/smart-update`, {
                day_of_week: dayIdx, slot, keyword: created.title,
              }).catch(() => {});
            }
          }
          const scope = req.day !== undefined ? `${DAY_NAMES[req.day!]} ${req.slot || "all slots"}` : `all ${req.slot || "meals"}`;
          return `Created **${created.title}** and filled ${scope} with it!`;
        }
        return `Couldn't find or create a recipe for "${req.keyword}", Amigo!`;
      }
      const scope = req.type === "cell" ? `${DAY_NAMES[req.day!]} ${cap(req.slot!)}`
                  : req.type === "day"  ? `all of ${DAY_NAMES[req.day!]}`
                  : `the entire ${cap(req.slot!)} row`;
      return `Done, Amigo! Replaced ${scope} with **${req.keyword}** — all ${filled} slots updated.`;
    } catch (e: any) {
      return null;
    }
  }

  // ── Meal change (single slot update) ──────────────────────────────────────

  function detectMealChange(text: string): { day: number; slot: string; keyword: string } | null {
    const days: Record<string,number> = {
      monday:0,mon:0,tuesday:1,tue:1,wednesday:2,wed:2,
      thursday:3,thu:3,friday:4,fri:4,saturday:5,sat:5,sunday:6,sun:6,
      today: new Date().getDay()===0 ? 6 : new Date().getDay()-1,
      tomorrow: new Date().getDay()===0 ? 0 : new Date().getDay()===6 ? 0 : new Date().getDay(),
    };
    const slots: Record<string,string> = {
      breakfast:"breakfast",lunch:"lunch",dinner:"dinner",
      snack:"snack",supper:"dinner",tea:"dinner",
    };
    const t = text.toLowerCase();
    let foundDay: number | null = null;
    let foundSlot = "dinner";
    let foundKeyword = "";
    for (const [d, n] of Object.entries(days)) { if (t.includes(d)) { foundDay = n; break; } }
    for (const [s, v] of Object.entries(slots)) { if (t.includes(s)) { foundSlot = v; break; } }

    const daySlotPat = new RegExp(
      `(?:${Object.keys(days).join("|")})\\s+(?:${Object.keys(slots).join("|")})\\s+(?:to be|should be|=)?\\s*(.+)`, "i"
    );
    const changePat = /(?:change|swap|replace|want|give me|make|use|put|set|switch)\s+(?:to\s+|with\s+)?(.+?)(?:\s+(?:for|on|as|at)\s+|$)/i;
    const wantPat   = /(?:i want|i'd like|can you(?:\s+make)?|give me|how about)\s+(.+?)(?:\s+(?:for|on|as)\s+|$)/i;
    const m = daySlotPat.exec(t) || changePat.exec(t) || wantPat.exec(t);
    if (m) foundKeyword = m[1].trim().replace(/[.,!?]$/, "");
    if (foundDay !== null && foundKeyword) return { day: foundDay, slot: foundSlot, keyword: foundKeyword };
    return null;
  }

  async function raulCreateRecipe(keyword: string) {
    try {
      return await api.post<any>("/ai/create-recipe", {
        title: keyword, servings: 2,
        max_time_minutes: profile.max_time ? parseInt(profile.max_time) : (tastes.lazy_cook ? 15 : undefined),
        lazy_mode: tastes.lazy_cook,
        notes: [
          profile.goal ? `Goal: ${profile.goal}` : "",
          tastes.cuisine_prefs.length ? `Cuisine preference: ${tastes.cuisine_prefs[0]}` : "",
          tastes.disliked_foods ? `Avoid: ${tastes.disliked_foods}` : "",
        ].filter(Boolean).join(". ") || undefined,
      });
    } catch { return null; }
  }

  async function smartUpdatePlan(day: number, slot: string, keyword: string) {
    if (!isLoggedIn) return null;
    try {
      const plan = await getCurrentPlan();
      if (!plan) return null;
      const res: any = await api.post(`/meal-planner/${plan.id}/smart-update`, { day_of_week: day, slot, keyword });
      if (!res?.ok) {
        setMessages(prev => [...prev, {
          role: "assistant",
          content: `I don't have "${keyword}" in the recipe base yet, Amigo. Let me whip one up! 👨‍🍳`,
        }]);
        const created: any = await raulCreateRecipe(keyword);
        if (created?.slug) {
          const retry: any = await api.post(`/meal-planner/${plan.id}/smart-update`, {
            day_of_week: day, slot, keyword: created.title,
          }).catch(() => null);
          if (retry?.ok) return { ...retry, _created: true };
        }
        return null;
      }
      return res;
    } catch { return null; }
  }

  // ── Send ──────────────────────────────────────────────────────────────────

  async function send(text: string) {
    if (!text.trim() || loading) return;
    setInput("");
    const userMsg: Message = { role: "user", content: text };
    const next = [...messages, userMsg];
    setMessages(next);
    setLoading(true);

    // 1. Start fresh / show profile form
    if (detectRestartRequest(text)) {
      setMessages(prev => [...prev, {
        role: "assistant",
        content: "Let's start fresh, Amigo! Fill in your details below and I'll build you a new plan.",
      }]);
      setShowForm(true);
      setFormTab("stats");
      setLoading(false);
      return;
    }

    // 2. Replace slot/day/cell with a repeated meal
    const replaceReq = detectReplaceRequest(text);
    if (replaceReq && isLoggedIn) {
      const result = await executeReplace(replaceReq);
      if (result) {
        setMessages(prev => [...prev, { role: "assistant", content: result }]);
        setLoading(false);
        return;
      }
    }

    // 3. Clear request
    const clearReq = detectClearRequest(text);
    if (clearReq && isLoggedIn) {
      const result = await executeClear(clearReq);
      if (result) {
        setMessages(prev => [...prev, { role: "assistant", content: result }]);
        setLoading(false);
        return;
      }
    }

    // 4. Single-slot meal change
    const mealChange = detectMealChange(text);
    if (mealChange && isLoggedIn) {
      const result = await smartUpdatePlan(mealChange.day, mealChange.slot, mealChange.keyword);
      if (result?.ok) {
        const wasCreated = result._created;
        setMessages(prev => [...prev, {
          role: "assistant",
          content: wasCreated
            ? `No existing recipe matched, so I created **${result.recipe.title}** from scratch and added it to ${DAY_NAMES[mealChange.day]} ${mealChange.slot}! 🍳`
            : `Done, Amigo! Updated ${DAY_NAMES[mealChange.day]} ${mealChange.slot} to **${result.recipe.title}**. Planner refreshes automatically!`,
        }]);
        setLoading(false);
        return;
      }
    }

    // 5. Normal AI chat — inject taste context into first system message
    try {
      const tasteCtx = buildTasteContext();
      const historyRaw = next.slice(-20).map(m => ({ role: m.role, content: m.content }));
      const messageWithCtx = text + tasteCtx;
      const history = historyRaw.slice(0, -1);
      const res: any = await api.post("/ai/chat", { message: messageWithCtx, history });
      setMessages(prev => [...prev, { role: "assistant", content: res.response }]);
    } catch (e: any) {
      setMessages(prev => [...prev, {
        role: "assistant",
        content: `Sorry Amigo, I hit a snag: ${e.message}`,
      }]);
    } finally {
      setLoading(false);
    }
  }

  // ── Profile form submit ───────────────────────────────────────────────────

  function handleProfileSubmit(e: React.FormEvent) {
    e.preventDefault();
    saveProfile(profile);
    saveTastes(tastes);
    setShowForm(false);

    const stats    = calcTDEE(profile);
    const timeline = estimateTimeline(profile);
    const goalLabel = GOAL_LABELS[profile.goal] || profile.goal;
    const actLabel  = ACTIVITY_LABELS[profile.activity] || profile.activity;

    const tasteSummary: string[] = [];
    if (tastes.breakfast_styles.length) tasteSummary.push(`• Breakfast: ${tastes.breakfast_styles.slice(0,3).join(", ")}`);
    if (tastes.dinner_styles.length)    tasteSummary.push(`• Dinner: ${tastes.dinner_styles.slice(0,3).join(", ")}`);
    if (tastes.disliked_foods.trim())   tasteSummary.push(`• Dislikes: ${tastes.disliked_foods}`);
    if (tastes.consistent_meals)        tasteSummary.push("• Prefers consistent / repeating meals");

    const summary = [
      "📋 Here's my profile:\n",
      `• Height: ${profile.height_cm}cm, Weight: ${profile.weight_kg}kg`,
      `• Age: ${profile.age}, Sex: ${profile.sex}`,
      `• Activity: ${actLabel}`,
      `• Goal: ${goalLabel}`,
      profile.target_weight_kg ? `• Target weight: ${profile.target_weight_kg}kg` : "",
      profile.max_time ? `• Max meal time: ${profile.max_time} minutes` : "",
      tasteSummary.length ? `\n🍽 My food preferences:\n${tasteSummary.join("\n")}` : "",
      stats ? `\n📊 TDEE: ${stats.tdee} kcal/day → Target: ${stats.target} kcal/day (${stats.deficit > 0 ? "+" : ""}${stats.deficit} kcal ${stats.deficit < 0 ? "deficit" : "surplus"})` : "",
      timeline ? `\n⏱️ ${timeline}` : "",
      "\nPlease build me a personalised meal plan that matches my food preferences!",
    ].filter(Boolean).join("\n");

    send(summary);
  }

  // ── Apply plan to planner ─────────────────────────────────────────────────

  async function applyPlanToPlanner(replace = false) {
    if (!isLoggedIn) { alert("Sign in to save your meal plan!"); return; }
    setApplyingPlan(true);
    try {
      const stats    = calcTDEE(profile);
      const dailyCal = stats?.target || 2000;
      const slotCals = {
        breakfast: Math.round(dailyCal * 0.25),
        lunch:     Math.round(dailyCal * 0.30),
        dinner:    Math.round(dailyCal * 0.35),
        snack:     Math.round(dailyCal * 0.10),
      };
      const slots = ["breakfast","lunch","dinner","snack"] as const;
      const recipePool: Record<string, { slug: string; title: string }[]> = {};
      const timeParam = profile.max_time ? `&max_time=${profile.max_time}` : "";

      // Build per-slot keyword hint from tastes
      const slotKeywords: Record<string, string> = {
        breakfast: tastes.breakfast_styles[0] || "",
        lunch:     tastes.lunch_styles[0] || "",
        dinner:    tastes.dinner_styles[0] || "",
        snack:     tastes.snack_styles[0] || "",
      };

      await Promise.all(slots.map(async slot => {
        const cal = slotCals[slot];
        const kw  = slotKeywords[slot];
        const kwParam = kw ? `&keyword=${encodeURIComponent(kw)}` : "";
        const res = await api.get<{ slug: string; title: string }[]>(
          `/meal-planner/recommend?calorie_target=${cal}&slot=${slot}${timeParam}${kwParam}`
        );
        recipePool[slot] = Array.isArray(res) ? res : [];
      }));

      const today  = new Date();
      const dow    = today.getDay();
      const monday = new Date(today);
      monday.setDate(today.getDate() - (dow === 0 ? 6 : dow - 1));
      const weekStart = `${monday.getFullYear()}-${String(monday.getMonth()+1).padStart(2,"0")}-${String(monday.getDate()).padStart(2,"0")}`;

      const created: any = await api.post("/meal-planner", { week_start: weekStart, items: [] });
      const planId = created.id;
      if (replace) await api.delete(`/meal-planner/${planId}/items`);

      for (const slot of slots) {
        const pool = recipePool[slot];
        for (let i = pool.length - 1; i > 0; i--) {
          const j = Math.floor(Math.random() * (i + 1));
          [pool[i], pool[j]] = [pool[j], pool[i]];
        }
      }

      let added = 0;
      for (let dayNum = 0; dayNum < 7; dayNum++) {
        for (const slot of slots) {
          const pool = recipePool[slot];
          if (!pool.length) continue;
          // If consistent meals: always use index 0, else rotate through pool
          const idx = tastes.consistent_meals ? 0 : dayNum % pool.length;
          const recipe = pool[idx];
          try {
            await api.post(`/meal-planner/${planId}/items`, {
              recipe_slug: recipe.slug, day_of_week: dayNum, slot, servings: 1,
            });
            added++;
          } catch {}
        }
      }

      setMessages(prev => [...prev, {
        role: "assistant",
        content: `✅ ${replace ? "Plan revised" : "Plan created"}, Amigo!\n\n• ${added} meals filled targeting ~${dailyCal} kcal/day\n• Tailored to your taste preferences\n• Head to the Meal Planner to review it! 🍳`,
      }]);
    } catch (e: any) {
      setMessages(prev => [...prev, {
        role: "assistant",
        content: `Couldn't fill the planner right now, Amigo. (${e.message})`,
      }]);
    } finally {
      setApplyingPlan(false);
    }
  }

  function clearChat() {
    setMessages([]);
    localStorage.removeItem(STORAGE_KEY);
  }

  // ── Derived state ─────────────────────────────────────────────────────────

  const hasPlan = messages.some(m =>
    m.role === "assistant" && m.content.length > 200 &&
    (m.content.toLowerCase().includes("breakfast") || m.content.toLowerCase().includes("lunch"))
  );
  const savedStats    = calcTDEE(profile);
  const profileFilled = !!(profile.height_cm && profile.weight_kg && profile.age);
  const tastesFilled  = tastes.breakfast_styles.length > 0 || tastes.dinner_styles.length > 0;

  // ── Render ────────────────────────────────────────────────────────────────

  return (
    <div className="fixed bottom-6 right-6 z-[100]">
      {/* Toggle button */}
      <button
        onClick={() => setIsOpen(o => !o)}
        className="group relative flex h-14 w-14 items-center justify-center rounded-full bg-brand-500 text-white shadow-2xl transition-all hover:scale-110 active:scale-95"
        title="Chat with Raul"
      >
        <span className="text-xl">{isOpen ? "✕" : "✨"}</span>
        <div className="absolute -inset-1 animate-pulse rounded-full bg-brand-500/40 blur-lg" />
      </button>

      {isOpen && (
        <div className="fixed bottom-24 right-6 flex w-[420px] max-w-[calc(100vw-24px)] flex-col overflow-hidden rounded-2xl border border-gray-800 bg-gray-950 shadow-2xl" style={{ maxHeight: "calc(100vh - 100px)" }}>

          {/* Header */}
          <div className="flex items-center gap-3 bg-brand-500 px-4 py-3 shrink-0">
            <div className="h-10 w-10 shrink-0 overflow-hidden rounded-full border-2 border-white/20 bg-gray-900">
              <img src="/recipes/images/raul_unleashed.png" alt="Raul" className="h-full w-full object-cover"
                onError={e => { (e.target as HTMLImageElement).style.display = "none"; }} />
            </div>
            <div className="flex-1 min-w-0">
              <p className="text-sm font-black italic text-white">RAUL THE CHEF</p>
              <p className="text-[10px] uppercase tracking-widest text-brand-100/70">Personal Trainer & Head Chef</p>
            </div>
            <div className="flex items-center gap-1.5">
              <button onClick={() => { setShowForm(f => !f); setFormTab("stats"); }}
                title="Edit profile"
                className="rounded-lg bg-white/10 px-2 py-1 text-xs text-white hover:bg-white/20">
                📋 {savedStats ? `${savedStats.target} kcal` : "Profile"}
              </button>
              <button onClick={() => { setShowForm(f => !f); setFormTab("tastes"); }}
                title="Food preferences"
                className={`rounded-lg px-2 py-1 text-xs text-white hover:bg-white/20 ${tastesFilled ? "bg-white/20" : "bg-white/10"}`}>
                🍽
              </button>
              <button onClick={clearChat} title="Clear chat"
                className="rounded-lg bg-white/10 px-2 py-1 text-xs text-white hover:bg-white/20">
                🗑
              </button>
            </div>
          </div>

          {/* Profile / Tastes form */}
          {showForm && (
            <div className="border-b border-gray-800 bg-gray-900 overflow-y-auto shrink-0" style={{ maxHeight: "55vh" }}>
              {/* Tabs */}
              <div className="flex border-b border-gray-800">
                {(["stats","tastes"] as const).map(tab => (
                  <button key={tab} onClick={() => setFormTab(tab)}
                    className={`flex-1 py-2 text-xs font-semibold uppercase tracking-wider transition-colors ${
                      formTab === tab ? "bg-brand-500/20 text-brand-400 border-b-2 border-brand-500" : "text-gray-500 hover:text-gray-300"
                    }`}>
                    {tab === "stats" ? "📊 Stats & Goals" : "🍽 Food Preferences"}
                  </button>
                ))}
              </div>

              <form onSubmit={handleProfileSubmit} className="p-4">
                {formTab === "stats" && (
                  <div className="grid grid-cols-2 gap-2 text-xs">
                    {[
                      ["Height (cm)", "height_cm", "175", "number"],
                      ["Weight (kg)", "weight_kg", "80", "number"],
                      ["Target weight (kg)", "target_weight_kg", "70", "number"],
                      ["Age", "age", "30", "number"],
                    ].map(([label, key, ph, type]) => (
                      <div key={key} className="flex flex-col gap-1">
                        <label className="text-gray-500">{label}</label>
                        <input type={type} placeholder={ph}
                          value={(profile as any)[key]}
                          onChange={e => setProfile(p => ({ ...p, [key]: e.target.value }))}
                          className="rounded-lg border border-gray-700 bg-gray-950 px-3 py-2 text-white focus:outline-none focus:ring-1 focus:ring-brand-500" />
                      </div>
                    ))}
                    <div className="flex flex-col gap-1">
                      <label className="text-gray-500">Sex</label>
                      <select value={profile.sex} onChange={e => setProfile(p => ({ ...p, sex: e.target.value }))}
                        className="rounded-lg border border-gray-700 bg-gray-950 px-3 py-2 text-white focus:outline-none focus:ring-1 focus:ring-brand-500">
                        <option value="male">Male</option>
                        <option value="female">Female</option>
                      </select>
                    </div>
                    <div className="flex flex-col gap-1">
                      <label className="text-gray-500">Activity level</label>
                      <select value={profile.activity} onChange={e => setProfile(p => ({ ...p, activity: e.target.value }))}
                        className="rounded-lg border border-gray-700 bg-gray-950 px-3 py-2 text-white focus:outline-none focus:ring-1 focus:ring-brand-500">
                        {Object.entries(ACTIVITY_LABELS).map(([v, l]) => <option key={v} value={v}>{l}</option>)}
                      </select>
                    </div>
                    <div className="col-span-2 flex flex-col gap-1">
                      <label className="text-gray-500">Goal</label>
                      <select value={profile.goal} onChange={e => setProfile(p => ({ ...p, goal: e.target.value }))}
                        className="rounded-lg border border-gray-700 bg-gray-950 px-3 py-2 text-white focus:outline-none focus:ring-1 focus:ring-brand-500">
                        {Object.entries(GOAL_LABELS).map(([v, l]) => <option key={v} value={v}>{l}</option>)}
                      </select>
                    </div>
                    <div className="col-span-2 flex flex-col gap-1">
                      <label className="text-gray-500">Max meal prep + cook time</label>
                      <select value={profile.max_time} onChange={e => setProfile(p => ({ ...p, max_time: e.target.value }))}
                        className="rounded-lg border border-gray-700 bg-gray-950 px-3 py-2 text-white focus:outline-none focus:ring-1 focus:ring-brand-500">
                        <option value="">No limit</option>
                        <option value="15">15 minutes</option>
                        <option value="20">20 minutes</option>
                        <option value="30">30 minutes</option>
                        <option value="45">45 minutes</option>
                        <option value="60">1 hour</option>
                        <option value="90">1.5 hours</option>
                      </select>
                    </div>
                    {/* TDEE preview */}
                    {profile.height_cm && profile.weight_kg && profile.age && (() => {
                      const s = calcTDEE(profile);
                      const t = estimateTimeline(profile);
                      return s ? (
                        <div className="col-span-2 mt-1 rounded-xl bg-brand-500/10 p-3 text-xs text-brand-300">
                          <p>BMR: {s.bmr} kcal · TDEE: {s.tdee} kcal · <strong>Target: {s.target} kcal/day</strong></p>
                          {t && <p className="mt-1 text-gray-400">{t}</p>}
                        </div>
                      ) : null;
                    })()}
                  </div>
                )}

                {formTab === "tastes" && (
                  <div className="space-y-4 text-xs">

                    {/* Toggles */}
                    <div className="space-y-2">
                      <label className="flex items-center gap-3 cursor-pointer">
                        <div className={`relative h-5 w-9 shrink-0 rounded-full transition-colors ${tastes.consistent_meals ? "bg-brand-500" : "bg-gray-700"}`}
                          onClick={() => setTastes(t => ({ ...t, consistent_meals: !t.consistent_meals }))}>
                          <div className={`absolute top-0.5 left-0.5 h-4 w-4 rounded-full bg-white shadow transition-transform ${tastes.consistent_meals ? "translate-x-4" : ""}`} />
                        </div>
                        <span className="text-gray-300">
                          <strong className="text-white">Consistent meals</strong> — repeat the same meals each day instead of mixing it up
                        </span>
                      </label>
                      <label className="flex items-center gap-3 cursor-pointer">
                        <div className={`relative h-5 w-9 shrink-0 rounded-full transition-colors ${tastes.lazy_cook ? "bg-brand-500" : "bg-gray-700"}`}
                          onClick={() => setTastes(t => ({ ...t, lazy_cook: !t.lazy_cook }))}>
                          <div className={`absolute top-0.5 left-0.5 h-4 w-4 rounded-full bg-white shadow transition-transform ${tastes.lazy_cook ? "translate-x-4" : ""}`} />
                        </div>
                        <span className="text-gray-300">
                          <strong className="text-white">Lazy cook mode</strong> — minimal ingredients, ultra-simple steps, under 15 mins
                        </span>
                      </label>
                    </div>

                    {/* Breakfast */}
                    <div>
                      <p className="mb-1.5 font-semibold text-gray-400">🌅 Breakfast style (pick up to 6)</p>
                      <ChipSelect options={BREAKFAST_OPTIONS} selected={tastes.breakfast_styles}
                        onChange={v => setTastes(t => ({ ...t, breakfast_styles: v }))} />
                    </div>

                    {/* Lunch */}
                    <div>
                      <p className="mb-1.5 font-semibold text-gray-400">☀️ Lunch style (pick up to 6)</p>
                      <ChipSelect options={LUNCH_OPTIONS} selected={tastes.lunch_styles}
                        onChange={v => setTastes(t => ({ ...t, lunch_styles: v }))} />
                    </div>

                    {/* Dinner */}
                    <div>
                      <p className="mb-1.5 font-semibold text-gray-400">🌙 Dinner style (pick up to 6)</p>
                      <ChipSelect options={DINNER_OPTIONS} selected={tastes.dinner_styles}
                        onChange={v => setTastes(t => ({ ...t, dinner_styles: v }))} />
                    </div>

                    {/* Snacks */}
                    <div>
                      <p className="mb-1.5 font-semibold text-gray-400">⚡ Snack style (pick up to 6)</p>
                      <ChipSelect options={SNACK_OPTIONS} selected={tastes.snack_styles}
                        onChange={v => setTastes(t => ({ ...t, snack_styles: v }))} />
                    </div>

                    {/* Cuisines */}
                    <div>
                      <p className="mb-1.5 font-semibold text-gray-400">🌍 Favourite cuisines (pick up to 5)</p>
                      <ChipSelect options={CUISINE_OPTIONS} selected={tastes.cuisine_prefs} max={5}
                        onChange={v => setTastes(t => ({ ...t, cuisine_prefs: v }))} />
                    </div>

                    {/* Dislikes */}
                    <div>
                      <p className="mb-1 font-semibold text-gray-400">🚫 Foods you dislike (comma separated)</p>
                      <input type="text" placeholder="e.g. mushrooms, fish, capsicum"
                        value={tastes.disliked_foods}
                        onChange={e => setTastes(t => ({ ...t, disliked_foods: e.target.value }))}
                        className="w-full rounded-lg border border-gray-700 bg-gray-950 px-3 py-2 text-white placeholder-gray-600 focus:outline-none focus:ring-1 focus:ring-brand-500" />
                    </div>

                    {/* Extra notes */}
                    <div>
                      <p className="mb-1 font-semibold text-gray-400">📝 Anything else Raul should know?</p>
                      <textarea rows={2} placeholder="e.g. I meal prep on Sunday, I'm lactose intolerant, I love spicy food…"
                        value={tastes.extra_notes}
                        onChange={e => setTastes(t => ({ ...t, extra_notes: e.target.value }))}
                        className="w-full resize-none rounded-lg border border-gray-700 bg-gray-950 px-3 py-2 text-white placeholder-gray-600 focus:outline-none focus:ring-1 focus:ring-brand-500" />
                    </div>
                  </div>
                )}

                <div className="mt-4 flex gap-2">
                  <button type="submit"
                    className="flex-1 rounded-xl bg-brand-500 py-2 text-xs font-bold text-white hover:bg-brand-600">
                    Save & Build My Plan
                  </button>
                  <button type="button" onClick={() => setShowForm(false)}
                    className="rounded-xl bg-gray-800 px-4 py-2 text-xs text-gray-400 hover:bg-gray-700">
                    Close
                  </button>
                </div>
              </form>
            </div>
          )}

          {/* Messages */}
          <div ref={scrollRef} className="flex-1 overflow-y-auto p-4 space-y-3" style={{ minHeight: "120px" }}>
            {messages.length === 0 && !showForm && (
              <div className="py-8 text-center">
                <p className="text-sm font-bold text-gray-400">Hola! I'm Raul 🔥</p>
                <p className="mt-1 text-xs text-gray-600">Your personal chef, trainer & dietician.</p>
                <div className="mt-4 flex flex-col gap-2">
                  <button onClick={() => { setShowForm(true); setFormTab("stats"); }}
                    className="rounded-xl bg-brand-500 px-4 py-2.5 text-xs font-bold text-white hover:bg-brand-600">
                    📋 Fill in my profile & get a meal plan
                  </button>
                  <button onClick={() => send("What can you help me with?")}
                    className="rounded-xl bg-gray-800 px-4 py-2.5 text-xs text-gray-300 hover:bg-gray-700">
                    💬 Just chat with Raul
                  </button>
                </div>
              </div>
            )}

            {messages.map((m, i) => (
              <div key={i} className={`flex ${m.role === "user" ? "justify-end" : "justify-start"}`}>
                <div className={`max-w-[85%] rounded-2xl px-4 py-3 text-sm leading-relaxed break-words ${
                  m.role === "user" ? "bg-brand-500 text-white" : "bg-gray-900 text-gray-200"
                }`}>
                  {m.role === "user" ? m.content : <RaulMessage text={m.content} />}
                </div>
              </div>
            ))}

            {loading && (
              <div className="flex justify-start">
                <div className="flex items-center gap-1.5 rounded-2xl bg-gray-900 px-4 py-3">
                  <div className="h-1.5 w-1.5 animate-bounce rounded-full bg-brand-500 [animation-delay:-0.3s]" />
                  <div className="h-1.5 w-1.5 animate-bounce rounded-full bg-brand-500 [animation-delay:-0.15s]" />
                  <div className="h-1.5 w-1.5 animate-bounce rounded-full bg-brand-500" />
                </div>
              </div>
            )}
          </div>

          {/* Fill / Revise plan buttons */}
          {hasPlan && isLoggedIn && (
            <div className="border-t border-gray-800 px-4 py-2 flex gap-2 shrink-0">
              <button onClick={() => applyPlanToPlanner(false)} disabled={applyingPlan}
                className="flex-1 rounded-xl bg-green-600 py-2.5 text-xs font-bold text-white hover:bg-green-500 disabled:opacity-50 transition-colors">
                {applyingPlan ? "⏳ Working…" : "🗓 Fill Planner"}
              </button>
              <button onClick={() => applyPlanToPlanner(true)} disabled={applyingPlan}
                className="flex-1 rounded-xl bg-orange-600 py-2.5 text-xs font-bold text-white hover:bg-orange-500 disabled:opacity-50 transition-colors">
                {applyingPlan ? "⏳ Working…" : "🔄 Revise (replace all)"}
              </button>
            </div>
          )}

          {/* Quick actions */}
          {messages.length > 0 && !showForm && (
            <div className="border-t border-gray-800 px-4 py-2 flex gap-2 overflow-x-auto shrink-0">
              <button onClick={() => { setShowForm(true); setFormTab("stats"); }}
                className="shrink-0 rounded-lg bg-gray-800 px-3 py-1.5 text-xs text-gray-300 hover:bg-gray-700">
                📋 Stats
              </button>
              <button onClick={() => { setShowForm(true); setFormTab("tastes"); }}
                className="shrink-0 rounded-lg bg-gray-800 px-3 py-1.5 text-xs text-gray-300 hover:bg-gray-700">
                🍽 Tastes
              </button>
              <button onClick={() => send("Build me a 7-day meal plan based on my profile")}
                className="shrink-0 rounded-lg bg-gray-800 px-3 py-1.5 text-xs text-gray-300 hover:bg-gray-700">
                🗓 7-day plan
              </button>
              <button onClick={() => send("What should I eat today to hit my calorie goal?")}
                className="shrink-0 rounded-lg bg-gray-800 px-3 py-1.5 text-xs text-gray-300 hover:bg-gray-700">
                📅 Today
              </button>
              <button onClick={() => send("Give me a high protein snack idea under 200 calories")}
                className="shrink-0 rounded-lg bg-gray-800 px-3 py-1.5 text-xs text-gray-300 hover:bg-gray-700">
                💪 Snack
              </button>
              <button onClick={() => send("Create a new recipe for me — surprise me with something delicious!")}
                className="shrink-0 rounded-lg bg-gray-800 px-3 py-1.5 text-xs text-gray-300 hover:bg-gray-700">
                🧑‍🍳 Create
              </button>
            </div>
          )}

          {/* Input */}
          <div className="border-t border-gray-800 p-3 shrink-0">
            <div className="flex items-end gap-2">
              <textarea
                ref={inputRef}
                placeholder="Ask Raul anything… or say 'replace breakfast with boiled eggs'"
                value={input}
                rows={1}
                onChange={e => {
                  setInput(e.target.value);
                  e.target.style.height = "auto";
                  e.target.style.height = Math.min(e.target.scrollHeight, 120) + "px";
                }}
                onKeyDown={e => {
                  if (e.key === "Enter" && !e.shiftKey) {
                    e.preventDefault();
                    send(input);
                    (e.target as HTMLTextAreaElement).style.height = "auto";
                  }
                }}
                className="flex-1 resize-none overflow-hidden rounded-xl border border-gray-700 bg-gray-900 px-4 py-2.5 text-sm text-white placeholder-gray-600 focus:outline-none focus:ring-2 focus:ring-brand-500"
                style={{ minHeight: "42px" }}
              />
              <button
                onClick={() => { send(input); if (inputRef.current) inputRef.current.style.height = "auto"; }}
                disabled={!input.trim() || loading}
                className="mb-0.5 flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-brand-500 text-white hover:bg-brand-600 disabled:opacity-40 transition-colors">
                ➔
              </button>
            </div>
            <p className="mt-1 text-right text-[10px] text-gray-700">Enter to send · Shift+Enter for new line</p>
          </div>
        </div>
      )}
    </div>
  );
}

function cap(s: string) { return s.charAt(0).toUpperCase() + s.slice(1); }
