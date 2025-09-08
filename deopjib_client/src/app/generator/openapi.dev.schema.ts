import { defineConfig } from "@hey-api/openapi-ts";

export default defineConfig({
  input: `http://localhost:${process.env.SERVER_PORT}/api/json/json_schema`,
  output: "src/entities/gen/schema",
  plugins: ["@hey-api/client-fetch", "@tanstack/react-query"],
});
