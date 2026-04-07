import type { Metadata } from "next";
import "./globals.css";
import Nav from "./Nav";
import AIAssistant from "@/components/AIAssistant";

export const metadata: Metadata = {
  title: "RecipeHub",
  description: "Smart meal planning & recipe aggregation",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <head>
        <meta name="version" content="1.0.1-raul-unleashed" />
      </head>
      <body className="min-h-screen bg-gray-950 text-gray-100 antialiased">
        <Nav />
        <main className="mx-auto max-w-6xl px-4 py-8">{children}</main>
        <AIAssistant />
        <div className="fixed bottom-2 left-2 text-[8px] text-gray-800 font-mono pointer-events-none">
          RAUL_v1.0.1_LIVE
        </div>
      </body>
    </html>
  );
}
