import { defineConfig } from "@hey-api/openapi-ts";

export default defineConfig({
  input: "http://localhost:4000/api/json/open_api",
  output: "src/entities/gen/api",
  plugins: [
    '@hey-api/typescript',
    {
      name: "@hey-api/client-fetch",
      runtimeConfigPath: "../../src/shared/utils/genClientConfig.ts",
    },
    "@tanstack/react-query",
  ],
});
