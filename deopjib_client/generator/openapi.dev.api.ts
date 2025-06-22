import { defineConfig } from "@hey-api/openapi-ts";

export default defineConfig({
  input: "http://localhost:4000/api/json/open_api",
  output: "src/gen/api",
  plugins: [
    {
      name: "@hey-api/client-fetch",
      // runtimeConfigPath: "../src/utils/genClientConfig.ts",
    },
    "@tanstack/react-query",
    "valibot",
  ],
});
