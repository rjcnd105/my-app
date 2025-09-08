import { defineConfig } from "@hey-api/openapi-ts";

export default defineConfig({
  input: "http://localhost:4000/api/json/json_schema",
  output: "src/gen/schema",
  plugins: ["@hey-api/client-fetch", "@tanstack/react-query"],
});
