// Server component wrapper — required for generateStaticParams with output: "export"
import RecipeDetail from "./RecipeDetail";

export async function generateStaticParams() {
  // All slug pages are rendered entirely client-side via SWR.
  // Returning [] means no pages are pre-generated; Next.js still emits the shell.
  return [];
}

export default function RecipePage() {
  return <RecipeDetail />;
}
