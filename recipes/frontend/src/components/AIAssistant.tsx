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
    age: "", sex: "male", activity: "moderate", goal: "lose",
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

  async function send(text: string) {
    if (!text.trim() || loading) return;
    setInput("");
    const userMsg: Message = { role: "user", content: text };
    const next = [...messages, userMsg];
    setMessages(next);
    setLoading(true);

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
      stats ? `\n📊 My estimated TDEE is ${stats.tdee} kcal/day. Target: ${stats.target} kcal/day (${stats.deficit > 0 ? "+" : ""}${stats.deficit} kcal ${stats.deficit < 0 ? "deficit" : "surplus"}).` : "",
      timeline ? `\n⏱️ ${timeline}` : "",
      `\nPlease build me a personalised meal plan based on this!`,
    ].filter(Boolean).join("\n");

    send(summary);
  }

  async function applyPlanToPlanner() {
    if (!isLoggedIn) { alert("Sign in to save your meal plan!"); return; }
    setApplyingPlan(true);

    // Get the last assistant message with a meal plan
    const planMessages = messages.filter(m => m.role === "assistant" && m.content.length > 200);
    if (planMessages.length === 0) {
      alert("No plan found yet — ask Raul to build one first!");
      setApplyingPlan(false);
      return;
    }
    const planText = planMessages[planMessages.length - 1].content;

    try {
      // Ask Raul to convert the plan to structured JSON
      const res: any = await api.post("/ai/chat", {
        message: `Convert the meal plan above into this exact JSON format (use real recipe slugs from recipehub where possible, otherwise use descriptive slug-style names):
{
  "week_start": "YYYY-MM-DD",
  "days": [
    {
      "day": 0,
      "breakfast": "recipe-slug-or-name",
      "lunch": "recipe-slug-or-name",
      "dinner": "recipe-slug-or-name",
      "snack": "recipe-slug-or-name"
    }
  ]
}
day 0=Monday, 1=Tuesday, ... 6=Sunday. Reply with ONLY the JSON, no other text.`,
        history: messages.slice(-10).map(m => ({ role: m.role, content: m.content })),
      });

      const jsonStr = res.response.replace(/```json\n?|\n?```/g, "").trim();
      const plan = JSON.parse(jsonStr);

      // Get Monday of current week (local time)
      const today = new Date();
      const day = today.getDay();
      const monday = new Date(today);
      monday.setDate(today.getDate() - (day === 0 ? 6 : day - 1));
      const weekStart = `${monday.getFullYear()}-${String(monday.getMonth() + 1).padStart(2, "0")}-${String(monday.getDate()).padStart(2, "0")}`;

      // Create the plan
      const created: any = await api.post("/meal-planner", { week_start: weekStart, items: [] });
      const planId = created.id;

      // Add each meal as an item
      let added = 0;
      for (const day of plan.days) {
        for (const slot of ["breakfast", "lunch", "dinner", "snack"] as const) {
          const slugRaw = day[slot];
          if (!slugRaw) continue;
          const slug = slugRaw.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/^-|-$/g, "");
          try {
            await api.post(`/meal-planner/${planId}/items`, {
              recipe_slug: slug,
              day_of_week: day.day,
              slot,
              servings: 1,
            });
            added++;
          } catch {}
        }
      }

      setMessages(prev => [...prev, {
        role: "assistant",
        content: `✅ Done, Amigo! I've added ${added} meals to your planner for this week. Head to the Meal Planner to see it! Some meals may need adjusting if the exact recipe wasn't found — just swap them out in the planner. 🍳`,
      }]);
    } catch (e: any) {
      setMessages(prev => [...prev, {
        role: "assistant",
        content: `Hmm, I couldn't auto-fill the planner right now. Try copying the plan and adding meals manually, Amigo! (${e.message})`,
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
        <div className="absolute bottom-18 right-0 mb-4 flex w-[400px] max-w-[95vw] flex-col overflow-hidden rounded-2xl border border-gray-800 bg-gray-950 shadow-2xl">

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
          <div ref={scrollRef} className="flex-1 overflow-y-auto p-4 space-y-3" style={{ maxHeight: "380px" }}>
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
                <div className={`max-w-[85%] rounded-2xl px-4 py-3 text-sm leading-relaxed whitespace-pre-wrap ${
                  m.role === "user"
                    ? "bg-brand-500 text-white"
                    : "bg-gray-900 text-gray-200"
                }`}>
                  {m.content}
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

          {/* Apply plan button */}
          {hasPlan && isLoggedIn && (
            <div className="border-t border-gray-800 px-4 py-2">
              <button onClick={applyPlanToPlanner} disabled={applyingPlan}
                className="w-full rounded-xl bg-green-600 py-2.5 text-xs font-bold text-white hover:bg-green-500 disabled:opacity-50 transition-colors">
                {applyingPlan ? "⏳ Filling your planner…" : "🗓 Add this plan to my Meal Planner"}
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
            </div>
          )}

          {/* Input */}
          <div className="border-t border-gray-800 p-3">
            <div className="flex items-center gap-2">
              <input
                ref={inputRef}
                type="text"
                placeholder="Ask Raul anything…"
                value={input}
                onChange={e => setInput(e.target.value)}
                onKeyDown={e => e.key === "Enter" && send(input)}
                className="flex-1 rounded-xl border border-gray-700 bg-gray-900 px-4 py-2.5 text-sm text-white placeholder-gray-600 focus:outline-none focus:ring-2 focus:ring-brand-500"
              />
              <button onClick={() => send(input)} disabled={!input.trim() || loading}
                className="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-brand-500 text-white hover:bg-brand-600 disabled:opacity-40 transition-colors">
                ➔
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
