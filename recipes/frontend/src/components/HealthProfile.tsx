"use client";
import { useState, useEffect } from "react";
import { api } from "@/lib/api";

interface HealthData {
  height_cm: number | null;
  weight_kg: number | null;
  target_weight_kg: number | null;
  biological_sex: string;
  activity_level: string;
  bmi_history: { date: string; weight: number; bmi: number }[];
}

export default function HealthProfile({ initialData, onUpdate }: { initialData: any, onUpdate: () => void }) {
  const [data, setData] = useState<HealthData>({
    height_cm: initialData.height_cm || 170,
    weight_kg: initialData.weight_kg || 70,
    target_weight_kg: initialData.target_weight_kg || 65,
    biological_sex: initialData.biological_sex || "male",
    activity_level: initialData.activity_level || "moderate",
    bmi_history: initialData.bmi_history || [],
  });
  const [saving, setSaving] = useState(false);

  const heightM = (data.height_cm || 170) / 100;
  const bmi = data.weight_kg ? parseFloat((data.weight_kg / (heightM * heightM)).toFixed(1)) : 0;

  const getBMICategory = (val: number) => {
    if (val < 18.5) return { label: "Underweight", color: "text-blue-400", bg: "bg-blue-400" };
    if (val < 25) return { label: "Healthy", color: "text-green-400", bg: "bg-green-400" };
    if (val < 30) return { label: "Overweight", color: "text-yellow-400", bg: "bg-yellow-400" };
    return { label: "Obese", color: "text-red-400", bg: "bg-red-400" };
  };

  const cat = getBMICategory(bmi);

  async function handleSave() {
    setSaving(true);
    try {
      await api.patch(`/users/${initialData.username}`, data);
      onUpdate();
    } catch (e) { alert("Save failed"); }
    finally { setSaving(false); }
  }

  return (
    <div className="rounded-3xl border border-gray-800 bg-gray-950 p-8 shadow-2xl">
      <div className="mb-8 flex items-center justify-between">
        <h2 className="text-2xl font-black italic tracking-tight text-brand-400">🥗 SMART HEALTH PROFILE</h2>
        <div className="flex items-center gap-2 rounded-full bg-gray-900 px-4 py-1 text-xs font-bold uppercase tracking-widest text-gray-500">
           AI Personalized
        </div>
      </div>

      <div className="grid gap-12 lg:grid-cols-2">
        {/* BMI Visualization */}
        <div className="flex flex-col items-center justify-center rounded-2xl border border-gray-900 bg-gray-900/20 p-8">
          <div className="relative mb-6 flex h-48 w-48 items-center justify-center">
            {/* SVG Gauge */}
            <svg className="absolute inset-0 h-full w-full" viewBox="0 0 100 100">
              <circle cx="50" cy="50" r="45" fill="none" stroke="#1f2937" strokeWidth="8" />
              <circle 
                cx="50" cy="50" r="45" fill="none" 
                stroke="currentColor" strokeWidth="8" 
                strokeDasharray="283" 
                strokeDashoffset={283 - (Math.min(bmi, 40) / 40) * 283}
                className={`${cat.color} transition-all duration-1000 ease-out`}
                transform="rotate(-90 50 50)"
              />
            </svg>
            <div className="text-center">
              <div className="text-5xl font-black tracking-tighter text-white">{bmi}</div>
              <div className={`text-xs font-bold uppercase tracking-widest ${cat.color}`}>{cat.label}</div>
            </div>
          </div>
          <p className="text-center text-sm text-gray-500 max-w-[240px]">
            Your current BMI of <span className="text-white font-bold">{bmi}</span> indicates you are in the 
            <span className={`mx-1 font-bold ${cat.color}`}>{cat.label}</span> range.
          </p>
        </div>

        {/* Inputs */}
        <div className="space-y-6">
          <div className="grid gap-4 sm:grid-cols-2">
            <div>
              <label className="mb-2 block text-[10px] font-bold uppercase tracking-[0.2em] text-gray-600">Height (cm)</label>
              <input 
                type="number" value={data.height_cm || ""} 
                onChange={e => setData({...data, height_cm: parseFloat(e.target.value) || 0})}
                className="w-full rounded-xl border border-gray-800 bg-gray-900 px-4 py-3 text-sm text-white focus:outline-none focus:ring-2 focus:ring-brand-500" 
              />
            </div>
            <div>
              <label className="mb-2 block text-[10px] font-bold uppercase tracking-[0.2em] text-gray-600">Weight (kg)</label>
              <input 
                type="number" value={data.weight_kg || ""} 
                onChange={e => setData({...data, weight_kg: parseFloat(e.target.value) || 0})}
                className="w-full rounded-xl border border-gray-800 bg-gray-900 px-4 py-3 text-sm text-white focus:outline-none focus:ring-2 focus:ring-brand-500" 
              />
            </div>
          </div>

          <div>
              <label className="mb-2 block text-[10px] font-bold uppercase tracking-[0.2em] text-gray-600">Bio Sex</label>
              <div className="flex gap-2">
                {["male", "female"].map(s => (
                  <button 
                    key={s} onClick={() => setData({...data, biological_sex: s})}
                    className={`flex-1 rounded-xl border px-4 py-3 text-sm font-bold capitalize transition-all ${data.biological_sex === s ? "border-brand-500 bg-brand-500/10 text-brand-400" : "border-gray-800 bg-gray-900 text-gray-500"}`}
                  >
                    {s}
                  </button>
                ))}
              </div>
          </div>

          <div>
              <label className="mb-2 block text-[10px] font-bold uppercase tracking-[0.2em] text-gray-600">Activity Level</label>
              <select 
                value={data.activity_level} 
                onChange={e => setData({...data, activity_level: e.target.value})}
                className="w-full rounded-xl border border-gray-800 bg-gray-900 px-4 py-3 text-sm text-white focus:outline-none focus:ring-2 focus:ring-brand-500"
              >
                <option value="sedentary">Sedentary (Office job)</option>
                <option value="light">Lightly Active (1-3 days/wk)</option>
                <option value="moderate">Moderately Active (3-5 days/wk)</option>
                <option value="active">Active (6-7 days/wk)</option>
                <option value="very_active">Very Active (Elite athlete)</option>
              </select>
          </div>

          <button 
            disabled={saving} onClick={handleSave}
            className="w-full rounded-xl bg-brand-500 py-4 text-sm font-black text-white shadow-xl shadow-brand-500/20 hover:bg-brand-600 hover:scale-[1.02] active:scale-[0.98] transition-all disabled:opacity-50"
          >
            {saving ? "SAVING..." : "UPDATE HEALTH PROFILE"}
          </button>
        </div>
      </div>
    </div>
  );
}
