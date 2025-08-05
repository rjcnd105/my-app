import { defineConfig } from "@hey-api/openapi-ts";

export default defineConfig({
  input: `${process.env.BASE_SERVER_URL}/api/json/json_schema`,
  output: "src/gen/schema",
  plugins: [
    {
      name: "@hey-api/client-fetch",
      runtimeConfigPath: "../src/utils/genClientConfig.ts",
    },
    "zod",
  ],
});
