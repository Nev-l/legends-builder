"use client";
import { useState, useEffect } from "react";
import useSWR from "swr";
import { api } from "@/lib/api";

interface RecipeEditProposal {
  id: number;
  recipe_id: number;
  recipe_title: string;
  recipe_slug: string;
  user_id: number;
  username: string;
  proposed_changes: any;
  created_at: string;
}

export default function AdminEditsDashboard() {
  const [isAdmin, setIsAdmin] = useState<boolean | null>(null);

  useEffect(() => {
    const token = localStorage.getItem("rh_token");
    if (!token) {
      window.location.href = "/recipes/login";
      return;
    }
    try {
      const p = JSON.parse(atob(token.split(".")[1]));
      setIsAdmin(parseInt(p.sub) === 1);
    } catch {
      setIsAdmin(false);
    }
  }, []);

  const { data: edits, mutate, error } = useSWR<RecipeEditProposal[]>(
    isAdmin ? "/recipes/edits/pending" : null,
    (url: string) => api.get<RecipeEditProposal[]>(url)
  );

  async function handleApprove(id: number) {
    if (!confirm("Are you sure you want to approve this edit? It will overwrite the recipe.")) return;
    try {
      await api.post(`/recipes/edits/${id}/approve`, {});
      mutate();
    } catch (e: any) { alert(e.message); }
  }

  async function handleReject(id: number) {
    if (!confirm("Reject this edit?")) return;
    try {
      await api.post(`/recipes/edits/${id}/reject`, {});
      mutate();
    } catch (e: any) { alert(e.message); }
  }

  if (isAdmin === null) return null;
  if (!isAdmin) return <div className="p-20 text-center text-red-500">Access Denied</div>;

  return (
    <div className="mx-auto max-w-4xl py-10">
      <h1 className="mb-8 text-3xl font-extrabold">Review Suggested Edits</h1>
      {error && <p className="text-red-500 mb-4">{error.message}</p>}
      
      {!edits ? (
        <p className="text-gray-500">Loading...</p>
      ) : edits.length === 0 ? (
        <div className="rounded-xl bg-gray-900 border border-gray-800 p-10 text-center">
          <p className="text-gray-500 text-lg">No pending edits to review! 🎉</p>
        </div>
      ) : (
        <div className="flex flex-col gap-6">
          {edits.map(edit => (
            <div key={edit.id} className="rounded-xl border border-gray-800 bg-gray-900 p-6">
              <div className="mb-4 flex items-center justify-between border-b border-gray-800 pb-4">
                <div>
                  <h2 className="text-xl font-bold">
                    Edit for <a href={`/recipes/${edit.recipe_slug}`} target="_blank" className="text-brand-400 hover:underline">{edit.recipe_title}</a>
                  </h2>
                  <p className="text-sm text-gray-500">
                    Suggested by <strong>{edit.username}</strong> on {new Date(edit.created_at).toLocaleDateString()}
                  </p>
                </div>
                <div className="flex gap-2">
                  <button onClick={() => handleApprove(edit.id)} className="rounded-lg bg-green-600/20 px-4 py-2 text-sm font-semibold text-green-400 hover:bg-green-600/40 border border-green-600/30">
                    ✓ Approve
                  </button>
                  <button onClick={() => handleReject(edit.id)} className="rounded-lg bg-red-600/20 px-4 py-2 text-sm font-semibold text-red-400 hover:bg-red-600/40 border border-red-600/30">
                    ✕ Reject
                  </button>
                </div>
              </div>
              
              <div className="space-y-4">
                <h3 className="text-sm font-semibold text-gray-400 uppercase tracking-wider">Proposed Changes</h3>
                <div className="rounded-lg bg-gray-950 p-4 font-mono text-sm break-words overflow-hidden text-gray-300">
                   {/* Format changes dynamically */}
                   {Object.keys(edit.proposed_changes).map(key => {
                      if (key === "ingredients") {
                        return (
                          <div key={key} className="mb-2">
                            <strong className="text-brand-300">{key}:</strong>
                            <ul className="list-disc pl-5 mt-1">
                              {edit.proposed_changes[key].map((ing: any, i: number) => (
                                <li key={i}>{ing.name}</li>
                              ))}
                            </ul>
                          </div>
                        )
                      }
                      if (key === "steps") {
                        return (
                          <div key={key} className="mb-2">
                            <strong className="text-brand-300">{key}:</strong>
                            <ol className="list-decimal pl-5 mt-1">
                              {edit.proposed_changes[key].map((step: any, i: number) => (
                                <li key={i} className="mb-1">{step.body}</li>
                              ))}
                            </ol>
                          </div>
                        )
                      }
                      if (key === "diet_tags") {
                        return (
                          <div key={key} className="mb-2">
                            <strong className="text-brand-300">{key}:</strong> {edit.proposed_changes[key].join(", ")}
                          </div>
                        )
                      }
                      return (
                        <div key={key} className="mb-2 line-clamp-3">
                          <strong className="text-brand-300">{key}:</strong> {String(edit.proposed_changes[key])}
                        </div>
                      )
                   })}
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
