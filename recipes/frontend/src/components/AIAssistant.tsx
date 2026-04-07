"use client";
import { useState, useRef, useEffect, useCallback } from "react";
import { api } from "@/lib/api";

interface Message {
  role: "user" | "assistant";
  content: string;
  formCard?: boolean;
}

interface Profile {
  height_cm: string;
  weight_kg: string;
  target_weight_kg: string;
  age: string;
  sex: string;
  activity: string;
  goal: string;
  max_time: string;  // max prep+cook minutes per meal ("" = no limit)
}

const STORAGE_KEY = "raul_chat_history";
const PROFILE_KEY = "raul_user_profile";

const ACTIVITY_LABELS: Record<string, string> = {
  sedentary: "Sedentary (desk job, little exercise)",
  light: "Light (1–3 days/week exercise)",
  moderate: "Moderate (3–5 days/week)",
  active: "Active (6–7 days/week)",
  very_active: "Very Active (physical job + gym)",
};

const GOAL_LABELS: Record<string, string> = {
  lose_fast: "Lose weight fast (aggressive cut)",
  lose: "Lose weight (steady cut)",
  maintain: "Maintain current weight",
  gain: "Build muscle (lean bulk)",
  gain_fast: "Bulk up (aggressive bulk)",
};

function calcTDEE(p: Profile): { bmr: number; tdee: number; target: number; deficit: number } | null {
  const h = parseFloat(p.height_cm);
  const w = parseFloat(p.weight_kg);
  const a = parseInt(p.age);
  if (!h || !w || !a) return null;

  // Mifflin-St Jeor
  const bmr = p.sex === "female"
    ? 10 * w + 6.25 * h - 5 * a - 161
    : 10 * w + 6.25 * h - 5 * a + 5;

  const activityMult: Record<string, number> = {
    sedentary: 1.2, light: 1.375, moderate: 1.55, active: 1.725, very_active: 1.9,
  };
  const tdee = Math.round(bmr * (activityMult[p.activity] || 1.55));

  const goalAdj: Record<string, number> = {
    lose_fast: -750, lose: -500, maintain: 0, gain: 300, gain_fast: 500,
  };
  const deficit = goalAdj[p.goal] || -500;
  const target = tdee + deficit;

  return { bmr: Math.round(bmr), tdee, target, deficit };
}

function estimateTimeline(p: Profile): string {
  const current = parseFloat(p.weight_kg);
  const goal = parseFloat(p.target_weight_kg);
  if (!current || !goal) return "";
  const diff = current - goal;
  if (Math.abs(diff) < 0.5) return "You're already at your goal weight!";

  const goalAdj: Record<string, number> = {
    lose_fast: 0.75, lose: 0.5, maintain: 0, gain: 0.3, gain_fast: 0.5,
  };
  const kgPerWeek = goalAdj[p.goal] || 0.5;
  if (kgPerWeek === 0) return "Maintenance — no weight change expected.";

  const direction = diff > 0 ? "lose" : "gain";
  const weeks = Math.ceil(Math.abs(diff) / kgPerWeek);
  const months = (weeks / 4.33).toFixed(1);
  return `To ${direction} ${Math.abs(diff).toFixed(1)}kg at ~${kgPerWeek}kg/week: approx ${weeks} weeks (${months} months).`;
}

function RaulMessage({ text }: { text: string }) {
  const lines = text.split("\n").filter(l => l.trim() !== "" || true);
  const elements: React.ReactNode[] = [];
  let key = 0;

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    const trimmed = line.trim();

    if (trimmed === "") {
      // blank line → small spacer
      elements.push(<div key={key++} className="h-1" />);
    } else if (/^#{1,3}\s/.test(trimmed)) {
      // ## Heading
      const content = trimmed.replace(/^#+\s/, "");
      elements.push(<p key={key++} className="font-bold text-brand-400 mt-2 mb-0.5">{content}</p>);
    } else if (/^[•\-\*]\s/.test(trimmed)) {
      // bullet
      const content = trimmed.replace(/^[•\-\*]\s/, "");
      elements.push(
        <div key={key++} className="flex gap-2 items-start">
          <span className="mt-0.5 shrink-0 text-brand-400">•</span>
          <span>{renderInline(content)}</span>
        </div>
      );
    } else if (/^\d+\.\s/.test(trimmed)) {
      // numbered list
      const num = trimmed.match(/^(\d+)\./)?.[1];
      const content = trimmed.replace(/^\d+\.\s/, "");
      elements.push(
        <div key={key++} className="flex gap-2 items-start">
          <span className="mt-0.5 shrink-0 font-bold text-brand-400">{num}.</span>
          <span>{renderInline(content)}</span>
        </div>
      );
    } else if (/^(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday|Day \d)/i.test(trimmed)) {
      // Day header in meal plan
      elements.push(<p key={key++} className="font-bold text-white mt-3 border-t border-gray-700 pt-2">{trimmed}</p>);
    } else if (/^(Breakfast|Lunch|Dinner|Snack):/i.test(trimmed)) {
      // Meal slot
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
  // Bold: **text**
  const parts = text.split(/(\*\*[^*]+\*\*)/g);
  return parts.map((p, i) =>
    p.startsWith("**") && p.endsWith("**")
      ? <strong key={i} className="text-white font-semibold">{p.slice(2, -2)}</strong>
      : p
  );
}

export default function AIAssistant() {
  const [isOpen, setIsOpen] = useState(false);
  const [messages, setMessages] = useState<Message[]>([]);
  const [input, setInput] = useState("");
  const [loading, setLoading] = useState(false);
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [showForm, setShowForm] = useState(false);
  const [applyingPlan, setApplyingPlan] = useState(false);
  const [profile, setProfile] = useState<Profile>({
    height_cm: "", weight_kg: "", target_weight_kg: "",
    age: "", sex: "male", activity: "moderate", goal: "lose", max_time: "",
  });
  const scrollRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLInputElement>(null);

  // Load persisted chat + profile on mount
  useEffect(() => {
    setIsLoggedIn(!!localStorage.getItem("rh_token"));
    try {
      const saved = localStorage.getItem(STORAGE_KEY);
      if (saved) setMessages(JSON.parse(saved));
      const savedProfile = localStorage.getItem(PROFILE_KEY);
      if (savedProfile) setProfile(JSON.parse(savedProfile));
    } catch {}
  }, []);

  // Persist messages to localStorage whenever they change
  useEffect(() => {
    if (messages.length > 0) {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(messages.slice(-60)));
    }
  }, [messages]);

  // Auto-scroll
  useEffect(() => {
    if (scrollRef.current) scrollRef.current.scrollTop = scrollRef.current.scrollHeight;
  }, [messages, loading, showForm]);

  // Focus input when opened
  useEffect(() => {
    if (isOpen) setTimeout(() => inputRef.current?.focus(), 100);
  }, [isOpen]);

  function saveProfile(p: Profile) {
    setProfile(p);
    localStorage.setItem(PROFILE_KEY, JSON.stringify(p));
  }

  // Detect meal change requests like "Saturday I want steak for dinner"
  function detectMealChange(text: string): { day: number; slot: string; keyword: string } | null {
    const days: Record<string, number> = {
      monday: 0, mon: 0, tuesday: 1, tue: 1, wednesday: 2, wed: 2,
      thursday: 3, thu: 3, friday: 4, fri: 4, saturday: 5, sat: 5, sunday: 6, sun: 6,
      today: new Date().getDay() === 0 ? 6 : new Date().getDay() - 1,
      tomorrow: new Date().getDay() === 0 ? 0 : new Date().getDay() === 6 ? 0 : new Date().getDay(),
    };
    const slots: Record<string, string> = {
      breakfast: "breakfast", lunch: "lunch", dinner: "dinner",
      snack: "snack", supper: "dinner", tea: "dinner",
    };
    const t = text.toLowerCase();
    let foundDay: number | null = null;
    let foundSlot = "dinner";
    let foundKeyword = "";

    for (const [d, n] of Object.entries(days)) {
      if (t.includes(d)) { foundDay = n; break; }
    }
    for (const [s, v] of Object.entries(slots)) {
      if (t.includes(s)) { foundSlot = v; break; }
    }

    // Look for change/want/swap/replace patterns
    const changePattern = /(?:change|swap|replace|want|give me|make|use|put|set|switch)\s+(?:to\s+|with\s+)?(.+?)(?:\s+(?:for|on|as|at)\s+|$)/i;
    const wantPattern = /(?:i want|i'd like|can you(?:\s+make)?|give me|how about)\s+(.+?)(?:\s+(?:for|on|as)\s+|$)/i;
    const daySlotPattern = new RegExp(`(?:${Object.keys(days).join("|")})\\s+(?:${Object.keys(slots).join("|")})\\s+(?:to be|should be|=)?\\s*(.+)`, "i");

    let m = daySlotPattern.exec(t) || changePattern.exec(t) || wantPattern.exec(t);
    if (m) foundKeyword = m[1].trim().replace(/[.,!?]$/, "");

    if (foundDay !== null && foundKeyword) {
      return { day: foundDay, slot: foundSlot, keyword: foundKeyword };
    }
    return null;
  }

  async function raulCreateRecipe(keyword: string): Promise<{ slug: string; title: string } | null> {
    try {
      const timeParam = profile.max_time ? parseInt(profile.max_time) : undefined;
      const res: any = await api.post("/ai/create-recipe", {
        title: keyword,
        servings: 2,
        max_time_minutes: timeParam,
        notes: profile.goal ? `Goal: ${profile.goal}` : undefined,
      });
      return res;
    } catch {
      return null;
    }
  }

  async function smartUpdatePlan(day: number, slot: string, keyword: string) {
    if (!isLoggedIn) return;
    // Get current plan id
    try {
      const plans: any = await api.get("/meal-planner");
      const today = new Date();
      const dow = today.getDay();
      const monday = new Date(today);
      monday.setDate(today.getDate() - (dow === 0 ? 6 : dow - 1));
      const ws = `${monday.getFullYear()}-${String(monday.getMonth() + 1).padStart(2, "0")}-${String(monday.getDate()).padStart(2, "0")}`;
      const plan = Array.isArray(plans) ? plans.find((p: any) => p.week_start?.slice(0, 10) === ws) : null;
      if (!plan) return null;

      const res: any = await api.post(`/meal-planner/${plan.id}/smart-update`, {
        day_of_week: day,
        slot,
        keyword,
      });

      // If no recipe found, ask Raul to create one
      if (!res?.ok) {
        setMessages(prev => [...prev, {
          role: "assistant",
          content: `I don't have "${keyword}" in the recipe base yet, Amigo. Let me whip one up! 👨‍🍳`,
        }]);
        const created = await raulCreateRecipe(keyword);
        if (created) {
          // Now retry the smart update with the exact new title
          const retry: any = await api.post(`/meal-planner/${plan.id}/smart-update`, {
            day_of_week: day,
            slot,
            keyword: created.title,
          }).catch(() => null);
          if (retry?.ok) {
            return { ...retry, _created: true };
          }
        }
        return null;
      }

      return res;
    } catch {
      return null;
    }
  }

  const DAY_NAMES = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];

  async function send(text: string) {
    if (!text.trim() || loading) return;
    setInput("");
    const userMsg: Message = { role: "user", content: text };
    const next = [...messages, userMsg];
    setMessages(next);
    setLoading(true);

    // Check for meal change request before sending to AI
    const mealChange = detectMealChange(text);
    if (mealChange && isLoggedIn) {
      try {
        const result = await smartUpdatePlan(mealChange.day, mealChange.slot, mealChange.keyword);
        if (result?.ok) {
          const dayName = DAY_NAMES[mealChange.day];
          const wasCreated = result._created;
          setMessages(prev => [...prev, {
            role: "assistant",
            content: wasCreated
              ? `No existing recipe matched, so I created **${result.recipe.title}** from scratch and added it to ${dayName} ${mealChange.slot}! 🍳\n\nCheck it out in the planner — refresh might be needed.`
              : `Done, Amigo! I've updated ${dayName} ${mealChange.slot} to **${result.recipe.title}**.\n\nYour planner is already updated — no refresh needed! 🍳`,
          }]);
          setLoading(false);
          return;
        }
      } catch {}
      // If smart update failed, fall through to normal AI chat
    }

    try {
      const history = next.slice(-20).map(m => ({ role: m.role, content: m.content }));
      const res: any = await api.post("/ai/chat", { message: text, history: history.slice(0, -1) });
      const reply: Message = { role: "assistant", content: res.response };
      setMessages(prev => [...prev, reply]);
    } catch (e: any) {
      setMessages(prev => [...prev, {
        role: "assistant",
        content: `Sorry Amigo, I hit a snag: ${e.message}`,
      }]);
    } finally {
      setLoading(false);
    }
  }

  function handleProfileSubmit(e: React.FormEvent) {
    e.preventDefault();
    saveProfile(profile);
    setShowForm(false);

    const stats = calcTDEE(profile);
    const timeline = estimateTimeline(profile);
    const goalLabel = GOAL_LABELS[profile.goal] || profile.goal;
    const actLabel = ACTIVITY_LABELS[profile.activity] || profile.activity;

    const summary = [
      `📋 Here's my profile:\n`,
      `• Height: ${profile.height_cm}cm, Weight: ${profile.weight_kg}kg`,
      `• Age: ${profile.age}, Sex: ${profile.sex}`,
      `• Activity: ${actLabel}`,
      `• Goal: ${goalLabel}`,
      profile.target_weight_kg ? `• Target weight: ${profile.target_weight_kg}kg` : "",
      profile.max_time ? `• Max meal time: ${profile.max_time} minutes per meal` : "",
      stats ? `\n📊 My estimated TDEE is ${stats.tdee} kcal/day. Target: ${stats.target} kcal/day (${stats.deficit > 0 ? "+" : ""}${stats.deficit} kcal ${stats.deficit < 0 ? "deficit" : "surplus"}).` : "",
      timeline ? `\n⏱️ ${timeline}` : "",
      `\nPlease build me a personalised meal plan based on this!`,
    ].filter(Boolean).join("\n");

    send(summary);
  }

  async function applyPlanToPlanner(replace = false) {
    if (!isLoggedIn) { alert("Sign in to save your meal plan!"); return; }
    setApplyingPlan(true);

    try {
      const stats = calcTDEE(profile);
      const dailyCal = stats?.target || 2000;

      const slotCals = {
        breakfast: Math.round(dailyCal * 0.25),
        lunch:     Math.round(dailyCal * 0.30),
        dinner:    Math.round(dailyCal * 0.35),
        snack:     Math.round(dailyCal * 0.10),
      };

      const slots = ["breakfast", "lunch", "dinner", "snack"] as const;
      const recipePool: Record<string, { slug: string; title: string }[]> = {};

      const timeParam = profile.max_time ? `&max_time=${profile.max_time}` : "";
      await Promise.all(slots.map(async slot => {
        const cal = slotCals[slot];
        const res = await api.get<{ slug: string; title: string }[]>(
          `/meal-planner/recommend?calorie_target=${cal}&slot=${slot}&limit=21${timeParam}`
        );
        recipePool[slot] = Array.isArray(res) ? res : [];
      }));

      // Get Monday of current week (local time)
      const today = new Date();
      const dow = today.getDay();
      const monday = new Date(today);
      monday.setDate(today.getDate() - (dow === 0 ? 6 : dow - 1));
      const weekStart = `${monday.getFullYear()}-${String(monday.getMonth() + 1).padStart(2, "0")}-${String(monday.getDate()).padStart(2, "0")}`;

      // Create or reuse the plan
      const created: any = await api.post("/meal-planner", { week_start: weekStart, items: [] });
      const planId = created.id;

      // Clear existing items if replacing
      if (replace) {
        await api.delete(`/meal-planner/${planId}/items`);
      }

      // Shuffle pool so revisions give different recipes
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
          const recipe = pool[dayNum % pool.length];
          try {
            await api.post(`/meal-planner/${planId}/items`, {
              recipe_slug: recipe.slug,
              day_of_week: dayNum,
              slot,
              servings: 1,
            });
            added++;
          } catch {}
        }
      }

      setMessages(prev => [...prev, {
        role: "assistant",
        content: `✅ ${replace ? "Plan revised" : "Plan created"}, Amigo!\n\n• ${added} meals filled targeting ~${dailyCal} kcal/day\n• Head to the Meal Planner to review it\n• Not happy with something? Hit Revise for a fresh set! 🍳`,
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

  const hasPlan = messages.some(m => m.role === "assistant" && m.content.length > 200 &&
    (m.content.toLowerCase().includes("breakfast") || m.content.toLowerCase().includes("lunch")));

  const savedStats = calcTDEE(profile);
  const profileFilled = !!(profile.height_cm && profile.weight_kg && profile.age);

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
        <div className="fixed bottom-24 right-6 flex w-[400px] max-w-[calc(100vw-24px)] flex-col overflow-hidden rounded-2xl border border-gray-800 bg-gray-950 shadow-2xl" style={{ maxHeight: "calc(100vh - 100px)" }}>

          {/* Header */}
          <div className="flex items-center gap-3 bg-brand-500 px-4 py-3">
            <div className="h-10 w-10 shrink-0 overflow-hidden rounded-full border-2 border-white/20 bg-gray-900">
              <img src="/recipes/images/raul_unleashed.png" alt="Raul" className="h-full w-full object-cover"
                onError={e => { (e.target as HTMLImageElement).style.display = "none"; }} />
            </div>
            <div className="flex-1 min-w-0">
              <p className="text-sm font-black italic text-white">RAUL THE CHEF</p>
              <p className="text-[10px] uppercase tracking-widest text-brand-100/70">Personal Trainer & Head Chef</p>
            </div>
            <div className="flex items-center gap-2">
              {profileFilled && (
                <button onClick={() => setShowForm(f => !f)}
                  title="Edit profile"
                  className="rounded-lg bg-white/10 px-2 py-1 text-xs text-white hover:bg-white/20">
                  📋 {savedStats ? `${savedStats.target} kcal` : "Profile"}
                </button>
              )}
              <button onClick={clearChat} title="Clear chat"
                className="rounded-lg bg-white/10 px-2 py-1 text-xs text-white hover:bg-white/20">
                🗑
              </button>
            </div>
          </div>

          {/* Intake form */}
          {showForm && (
            <form onSubmit={handleProfileSubmit} className="border-b border-gray-800 bg-gray-900 p-4">
              <p className="mb-3 text-xs font-bold uppercase tracking-widest text-brand-400">Your Profile</p>
              <div className="grid grid-cols-2 gap-2 text-xs">
                <div className="flex flex-col gap-1">
                  <label className="text-gray-500">Height (cm)</label>
                  <input type="number" placeholder="175" value={profile.height_cm}
                    onChange={e => setProfile(p => ({ ...p, height_cm: e.target.value }))}
                    className="rounded-lg border border-gray-700 bg-gray-950 px-3 py-2 text-white focus:outline-none focus:ring-1 focus:ring-brand-500" />
                </div>
                <div className="flex flex-col gap-1">
                  <label className="text-gray-500">Weight (kg)</label>
                  <input type="number" placeholder="80" value={profile.weight_kg}
                    onChange={e => setProfile(p => ({ ...p, weight_kg: e.target.value }))}
                    className="rounded-lg border border-gray-700 bg-gray-950 px-3 py-2 text-white focus:outline-none focus:ring-1 focus:ring-brand-500" />
                </div>
                <div className="flex flex-col gap-1">
                  <label className="text-gray-500">Target weight (kg)</label>
                  <input type="number" placeholder="70" value={profile.target_weight_kg}
                    onChange={e => setProfile(p => ({ ...p, target_weight_kg: e.target.value }))}
                    className="rounded-lg border border-gray-700 bg-gray-950 px-3 py-2 text-white focus:outline-none focus:ring-1 focus:ring-brand-500" />
                </div>
                <div className="flex flex-col gap-1">
                  <label className="text-gray-500">Age</label>
                  <input type="number" placeholder="30" value={profile.age}
                    onChange={e => setProfile(p => ({ ...p, age: e.target.value }))}
                    className="rounded-lg border border-gray-700 bg-gray-950 px-3 py-2 text-white focus:outline-none focus:ring-1 focus:ring-brand-500" />
                </div>
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
                    {Object.entries(ACTIVITY_LABELS).map(([v, l]) => (
                      <option key={v} value={v}>{l}</option>
                    ))}
                  </select>
                </div>
                <div className="col-span-2 flex flex-col gap-1">
                  <label className="text-gray-500">Goal</label>
                  <select value={profile.goal} onChange={e => setProfile(p => ({ ...p, goal: e.target.value }))}
                    className="rounded-lg border border-gray-700 bg-gray-950 px-3 py-2 text-white focus:outline-none focus:ring-1 focus:ring-brand-500">
                    {Object.entries(GOAL_LABELS).map(([v, l]) => (
                      <option key={v} value={v}>{l}</option>
                    ))}
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
              </div>
              {profile.height_cm && profile.weight_kg && profile.age && (() => {
                const s = calcTDEE(profile);
                const t = estimateTimeline(profile);
                return s ? (
                  <div className="mt-3 rounded-xl bg-brand-500/10 p-3 text-xs text-brand-300">
                    <p>BMR: {s.bmr} kcal · TDEE: {s.tdee} kcal · Target: <strong>{s.target} kcal/day</strong></p>
                    {t && <p className="mt-1 text-gray-400">{t}</p>}
                  </div>
                ) : null;
              })()}
              <div className="mt-3 flex gap-2">
                <button type="submit"
                  className="flex-1 rounded-xl bg-brand-500 py-2 text-xs font-bold text-white hover:bg-brand-600">
                  Send to Raul & Build Plan
                </button>
                <button type="button" onClick={() => setShowForm(false)}
                  className="rounded-xl bg-gray-800 px-4 py-2 text-xs text-gray-400 hover:bg-gray-700">
                  Cancel
                </button>
              </div>
            </form>
          )}

          {/* Messages */}
          <div ref={scrollRef} className="flex-1 overflow-y-auto p-4 space-y-3" style={{ minHeight: "120px", maxHeight: "min(380px, 50vh)" }}>
            {messages.length === 0 && !showForm && (
              <div className="py-8 text-center">
                <p className="text-sm font-bold text-gray-400">Hola! I'm Raul 🔥</p>
                <p className="mt-1 text-xs text-gray-600">Your personal chef, trainer & dietician.</p>
                <div className="mt-4 flex flex-col gap-2">
                  <button onClick={() => setShowForm(true)}
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

          {/* Apply / Revise plan buttons */}
          {hasPlan && isLoggedIn && (
            <div className="border-t border-gray-800 px-4 py-2 flex gap-2">
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

          {/* Quick actions when no messages */}
          {messages.length > 0 && !showForm && (
            <div className="border-t border-gray-800 px-4 py-2 flex gap-2 overflow-x-auto">
              <button onClick={() => setShowForm(true)}
                className="shrink-0 rounded-lg bg-gray-800 px-3 py-1.5 text-xs text-gray-300 hover:bg-gray-700">
                📋 My profile
              </button>
              <button onClick={() => send("Build me a 7-day meal plan based on my profile")}
                className="shrink-0 rounded-lg bg-gray-800 px-3 py-1.5 text-xs text-gray-300 hover:bg-gray-700">
                🍽 7-day plan
              </button>
              <button onClick={() => send("What should I eat today to hit my calorie goal?")}
                className="shrink-0 rounded-lg bg-gray-800 px-3 py-1.5 text-xs text-gray-300 hover:bg-gray-700">
                📅 Today's meals
              </button>
              <button onClick={() => send("Give me a high protein snack idea under 200 calories")}
                className="shrink-0 rounded-lg bg-gray-800 px-3 py-1.5 text-xs text-gray-300 hover:bg-gray-700">
                💪 Snack idea
              </button>
              <button onClick={() => send("Create a new recipe for me — surprise me with something delicious and healthy!")}
                className="shrink-0 rounded-lg bg-gray-800 px-3 py-1.5 text-xs text-gray-300 hover:bg-gray-700">
                🧑‍🍳 Create recipe
              </button>
            </div>
          )}

          {/* Input */}
          <div className="border-t border-gray-800 p-3">
            <div className="flex items-end gap-2">
              <textarea
                ref={inputRef as any}
                placeholder="Ask Raul anything…"
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
              <button onClick={() => { send(input); const ta = document.querySelector(".raul-input") as HTMLTextAreaElement; if (ta) ta.style.height = "auto"; }} disabled={!input.trim() || loading}
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
