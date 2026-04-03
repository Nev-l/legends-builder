import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "RecipeHub",
  description: "Smart meal planning & recipe aggregation",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body className="min-h-screen bg-gray-950 text-gray-100 antialiased">
        <nav className="sticky top-0 z-50 border-b border-gray-800 bg-gray-950/90 backdrop-blur">
          <div className="mx-auto flex max-w-6xl items-center justify-between px-4 py-3">
            <a href="/recipes" className="text-xl font-bold text-brand-500">
              🍳 RecipeHub
            </a>
            <div className="flex gap-4 text-sm text-gray-400">
              <a href="/recipes/planner" className="hover:text-white">Meal Planner</a>
              <a href="/recipes/pantry"  className="hover:text-white">Pantry</a>
              <a href="/recipes/login"   className="rounded-md bg-brand-500 px-3 py-1.5 text-white hover:bg-brand-600">
                Sign in
              </a>
            </div>
          </div>
        </nav>
        <main className="mx-auto max-w-6xl px-4 py-8">{children}</main>
      </body>
    </html>
  );
}
