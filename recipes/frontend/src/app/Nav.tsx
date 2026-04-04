"use client";
import { useEffect, useState } from "react";

export default function Nav() {
  const [username, setUsername] = useState<string | null>(null);

  useEffect(() => {
    setUsername(localStorage.getItem("rh_username"));
  }, []);

  function signOut() {
    localStorage.removeItem("rh_token");
    localStorage.removeItem("rh_username");
    window.location.href = "/recipes";
  }

  return (
    <nav className="sticky top-0 z-50 border-b border-gray-800 bg-gray-950/90 backdrop-blur">
      <div className="mx-auto flex max-w-6xl items-center justify-between px-4 py-3">
        <a href="/recipes" className="text-xl font-bold text-brand-500">
          🍳 RecipeHub
        </a>
        <div className="flex items-center gap-4 text-sm text-gray-400">
          <a href="/recipes/planner" className="hover:text-white">Meal Planner</a>
          <a href="/recipes/pantry"  className="hover:text-white">Pantry</a>
          {username ? (
            <>
              {username.toLowerCase() === "nev" && (
                <a href="/recipes/admin/edits" className="rounded-md bg-brand-500/20 px-3 py-1.5 text-brand-400 border border-brand-500/50 hover:bg-brand-500 hover:text-white">
                  Review Edits
                </a>
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
