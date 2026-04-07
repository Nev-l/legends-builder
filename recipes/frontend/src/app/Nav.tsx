"use client";
import { useEffect, useState } from "react";

export default function Nav() {
  const [username, setUsername] = useState<string | null>(null);

  const [clicks, setClicks] = useState(0);

  useEffect(() => {
    setUsername(localStorage.getItem("rh_username"));
  }, []);

  async function handleLogoClick(e: React.MouseEvent) {
    if (!username) return;
    const newCount = clicks + 1;
    setClicks(newCount);
    if (newCount === 7) {
      try {
        const res = await fetch("/api/users/badges/claim-easter-egg", {
          method: "POST",
          headers: { 
            "Content-Type": "application/json",
            "Authorization": `Bearer ${localStorage.getItem("rh_token")}`
          },
          body: JSON.stringify({ badge_id: "logo_fanatic", secret_key: "clicks_7_logo" })
        });
        const data = await res.json();
        if (data.ok) alert(`✨ Achievement Unlocked: ${data.badge.name}!`);
      } catch {}
    }
    // Reset after some time
    setTimeout(() => setClicks(0), 3000);
  }

  function signOut() {
    localStorage.removeItem("rh_token");
    localStorage.removeItem("rh_username");
    window.location.href = "/recipes";
  }

  return (
    <nav className="sticky top-0 z-50 border-b border-gray-800 bg-gray-950/90 backdrop-blur">
      <div className="mx-auto flex max-w-6xl items-center justify-between px-4 py-3">
        <div className="flex items-center gap-6">
          <a href="/recipes" onClick={handleLogoClick} className="text-xl font-bold text-brand-500 hover:scale-105 transition-transform active:scale-95">
            🍳 RecipeHub
          </a>
          <a href="/recipes/vault" className="opacity-0 hover:opacity-10 text-[10px] text-gray-800 transition-opacity">.</a>
        </div>
        <div className="flex items-center gap-4 text-sm text-gray-400">
          <a href="/recipes/planner" className="hover:text-white">Meal Planner</a>
          <a href="/recipes/pantry"  className="hover:text-white">Pantry</a>
          {username ? (
            <>
              {(username.toLowerCase() === "nev" || username.toLowerCase() === "q") && (
                <div className="flex gap-2">
                  <a href="/recipes/admin" className="rounded-md bg-brand-500/20 px-3 py-1.5 text-brand-400 border border-brand-500/50 hover:bg-brand-500 hover:text-white">
                    🛡️ Admin Panel
                  </a>
                  <a href="/recipes/admin" className="rounded-md bg-gray-800 px-3 py-1.5 text-gray-300 border border-gray-700 hover:bg-gray-700 hover:text-white">
                    Review Edits
                  </a>
                </div>
              )}
              <a href={`/recipes/user/${username}`} className="text-gray-500 hover:text-brand-400">Hi, <strong className="text-white">{username}</strong></a>
              <button
                onClick={signOut}
                className="rounded-md border border-gray-700 px-3 py-1.5 hover:border-gray-500 hover:text-white"
              >
                Sign out
              </button>
            </>
          ) : (
            <a href="/recipes/login" className="rounded-md bg-brand-500 px-3 py-1.5 text-white hover:bg-brand-600">
              Sign in
            </a>
          )}
        </div>
      </div>
    </nav>
  );
}
