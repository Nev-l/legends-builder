"use client";
import { useState, useRef, useEffect } from "react";
import { api } from "@/lib/api";

interface Message {
  role: "user" | "model";
  parts: [{ text: string }];
}

export default function AIAssistant() {
  const [isOpen, setIsOpen] = useState(false);
  const [messages, setMessages] = useState<Message[]>([]);
  const [input, setInput] = useState("");
  const [loading, setLoading] = useState(false);
  const scrollRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (scrollRef.current) scrollRef.current.scrollTop = scrollRef.current.scrollHeight;
  }, [messages]);

  async function handleSend(customMsg?: string) {
    const userMsg = customMsg || input;
    if (!userMsg.trim() || loading) return;
    setInput("");
    setMessages(prev => [...prev, { role: "user", parts: [{ text: userMsg }] }]);
    setLoading(true);

    try {
      // CACHE BUSTING: Adding v=1.0.1 to force fresh update
      const res: any = await api.post("/ai/chat?v=1.0.1", { 
        message: userMsg, 
        history: messages 
      });
      setMessages(prev => [...prev, { role: "model", parts: [{ text: res.response }] }]);
    } catch (e: any) {
      const errMsg = e.response?.data?.response || e.message || "Unknown Connection Error";
      setMessages(prev => [...prev, { role: "model", parts: [{ text: `✨ Raul Help: ${errMsg}` }] }]);
    } finally {
      setLoading(false);
    }
  }

  // Plan Application Logic
  async function applyPlan(rawPlanJson: string) {
    try {
      const plan = JSON.parse(rawPlanJson);
      const weekStart = (offset: number) => {
        const d = new Date();
        d.setDate(d.getDate() + (offset * 7) - d.getDay() + 1);
        return d.toISOString().split("T")[0];
      };

      // Dynamically iterate through all weeks provided by Raul
      for (let i = 0; i < plan.weeks.length; i++) {
        const ws = weekStart(i);
        const weekData = plan.weeks[i];
        if (!weekData) continue;
        
        const items = weekData.days.flatMap((d: any) => [
          { recipe_slug: d.meals.breakfast.slug_hint, day_of_week: d.day_number - 1, slot: "breakfast" },
          { recipe_slug: d.meals.lunch.slug_hint, day_of_week: d.day_number - 1, slot: "lunch" },
          { recipe_slug: d.meals.dinner.slug_hint, day_of_week: d.day_number - 1, slot: "dinner" },
          { recipe_slug: d.meals.snack.slug_hint, day_of_week: d.day_number - 1, slot: "snack" },
        ]);
        await api.post("/meal-planner", { week_start: ws, items });
      }
      alert(`✅ ${plan.weeks.length}-Week Plan applied to your planner!`);
    } catch (e) {
      alert("❌ Failed to apply plan: Malformed data.");
    }
  }

  return (
    <div className="fixed bottom-8 right-8 z-[100]">
      {/* Bot Button */}
      <button 
        onClick={() => setIsOpen(!isOpen)}
        className="group relative flex h-16 w-16 items-center justify-center rounded-full bg-brand-500 text-white shadow-2xl transition-all hover:scale-110 active:scale-95"
      >
        <span className="text-2xl">{isOpen ? "✕" : "✨"}</span>
        <div className="absolute -inset-1 animate-pulse rounded-full bg-brand-500/50 blur-lg group-hover:bg-brand-500/80"></div>
      </button>

      {/* Chat Window */}
      {isOpen && (
        <div className="absolute bottom-20 right-0 w-[420px] max-w-[90vw] overflow-hidden rounded-3xl border border-gray-800 bg-gray-950/90 shadow-[0_32px_64px_-16px_rgba(0,0,0,0.8)] backdrop-blur-2xl animate-in slide-in-from-bottom-8 duration-500">
          <div className="bg-brand-500 p-6 flex items-center gap-4">
            <div className="h-12 w-12 rounded-full border-2 border-white/20 overflow-hidden bg-gray-900 flex-shrink-0">
              <img src="/images/raul_unleashed.png" alt="Raul" className="h-full w-full object-cover" />
            </div>
            <div>
              <h3 className="text-lg font-black italic tracking-tight text-white">RAUL THE CHEF</h3>
              <p className="text-[10px] font-bold uppercase tracking-widest text-brand-100 opacity-70">Your Kitchen Amigo & Head Chef</p>
            </div>
          </div>

          <div ref={scrollRef} className="h-[400px] overflow-y-auto p-6 space-y-4">
            {messages.length === 0 && (
              <div className="py-10 text-center">
                <div className="mx-auto h-24 w-24 rounded-full border-4 border-brand-500/20 overflow-hidden mb-4">
                  <img src="/images/raul_unleashed.png" alt="Raul" className="h-full w-full object-cover" />
                </div>
                <p className="text-sm font-bold text-gray-500 uppercase tracking-widest leading-relaxed">
                  Hola! I'm Raul, your Smart AI Chef.<br/>
                  <span className="text-brand-400">Want to build a custom plan?</span><br/>
                  <span className="text-gray-700 text-[10px]">Tell me how many weeks (1, 2, 4+) and your diet!</span>
                </p>
                <button 
                  onClick={() => handleSend("Hola Raul! I want to build a new 4-week meal plan. What do you recommend?")}
                  className="mt-6 rounded-full bg-brand-500/10 px-6 py-2 text-xs font-bold text-brand-400 hover:bg-brand-500 hover:text-white transition-all"
                >
                  ✨ Start Planning with Raul
                </button>
              </div>
            )}
            {messages.map((m, i) => {
              const planToken = m.parts[0].text.match(/\[MEAL_PLAN_DATA: ([\s\S]*?)\]/);
              const cleanText = m.parts[0].text.replace(/\[MEAL_PLAN_DATA: [\s\S]*?\]/, "").trim();
              
              let weekCount = 0;
              if (planToken) {
                try {
                  const p = JSON.parse(planToken[1]);
                  weekCount = p.weeks?.length || 0;
                } catch(e) {}
              }

              return (
                <div key={i} className={`flex flex-col ${m.role === "user" ? "items-end" : "items-start"}`}>
                  {cleanText && (
                    <div className={`max-w-[85%] rounded-2xl p-4 text-sm font-medium leading-relaxed ${m.role === "user" ? "bg-brand-500 text-white" : "bg-gray-900 text-gray-300"}`}>
                      {cleanText}
                    </div>
                  )}
                  {planToken && weekCount > 0 && (
                    <button 
                      onClick={() => applyPlan(planToken[1])}
                      className="mt-2 w-[85%] rounded-2xl bg-brand-500 p-4 text-center text-sm font-black text-white shadow-xl shadow-brand-500/30 hover:scale-[1.02] active:scale-[0.98] transition-all"
                    >
                      🚀 APPLY THIS {weekCount}-WEEK PLAN
                    </button>
                  )}
                </div>
              );
            })}
            {loading && (
              <div className="flex justify-start">
                <div className="flex items-center gap-2 rounded-2xl bg-gray-900 p-4">
                  <div className="h-2 w-2 animate-bounce rounded-full bg-brand-500 [animation-delay:-0.3s]"></div>
                  <div className="h-2 w-2 animate-bounce rounded-full bg-brand-500 [animation-delay:-0.15s]"></div>
                  <div className="h-2 w-2 animate-bounce rounded-full bg-brand-500"></div>
                </div>
              </div>
            )}
          </div>

          <div className="p-6 border-t border-gray-900 bg-gray-900/10">
            <div className="relative flex items-center">
              <input 
                type="text" 
                placeholder="Ask me a question..." 
                value={input}
                onChange={e => setInput(e.target.value)}
                onKeyDown={e => e.key === "Enter" && handleSend()}
                className="w-full rounded-2xl border border-gray-800 bg-gray-900 px-5 py-4 text-sm text-white transition-all placeholder:text-gray-600 focus:outline-none focus:ring-2 focus:ring-brand-500"
              />
              <button 
                onClick={() => handleSend()}
                className="absolute right-2 flex h-10 w-10 items-center justify-center rounded-xl bg-brand-500 text-white shadow-lg transition-all hover:bg-brand-600 hover:scale-105 active:scale-95 disabled:opacity-50"
              >
                ➔
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
