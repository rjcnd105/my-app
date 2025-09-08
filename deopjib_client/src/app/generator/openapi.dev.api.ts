import { defineConfig } from "@hey-api/openapi-ts";

export default defineConfig({
  input: `http://localhost:${process.env.SERVER_PORT}/api/json/open_api`,
  output: "src/entities/gen/api",
  plugins: [
    '@hey-api/typescript',
    {
      name: "@hey-api/client-fetch",
    },
    "@tanstack/react-query",
  ],
});
