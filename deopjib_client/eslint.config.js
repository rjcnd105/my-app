import react from "@eslint-react/eslint-plugin";
import eslint from "@eslint/js";
import pluginQuery from "@tanstack/eslint-plugin-query";
import pluginRouter from "@tanstack/eslint-plugin-router";
import reactHooks from "eslint-plugin-react-hooks";
import eslintConfigPrettier from "eslint-config-prettier";
import { defineConfig } from "eslint/config";
import tseslint from "typescript-eslint";

const { plugins: _, ...reactHooksConfig } = reactHooks.configs["recommended-latest"];

export default defineConfig({
  ignores: ["dist", ".wrangler", ".vercel", ".netlify", ".output", "build/", "**/gen/**/*"],
  files: ["**/*.{ts,tsx}"],
  languageOptions: {
    parser: tseslint.parser,
    // parserOptions: {
    //   projectService: true,
    //   tsconfigRootDir: import.meta.dirname,
    // },
  },
  plugins: {
    "react-hooks": reactHooks,
  },
  extends: [
    eslint.configs.recommended,
    tseslint.configs.recommended,
    ...tseslint.configs.stylisticTypeChecked,
    eslintConfigPrettier,
    ...pluginQuery.configs["flat/recommended"],
    ...pluginRouter.configs["flat/recommended"],
    reactHooksConfig,
    react.configs["recommended-type-checked"]
  ],
  rules: {
    // You can override any rules here
    "@typescript-eslint/no-deprecated": "warn",
    "@typescript-eslint/no-unused-vars": "warn",
    "@typescript-eslint/no-namespace": "off"
  },
});
