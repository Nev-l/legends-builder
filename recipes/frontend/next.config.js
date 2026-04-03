/** @type {import('next').NextConfig} */
const nextConfig = {
  // Static export for serving via FastAPI's StaticFiles
  output: "export",
  // All pages live under /recipes
  basePath: "/recipes",
  assetPrefix: "/recipes",
  trailingSlash: true,
  images: { unoptimized: true },
};

module.exports = nextConfig;
