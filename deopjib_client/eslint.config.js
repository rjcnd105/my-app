import react from "@eslint-react/eslint-plugin";
import js from "@eslint/js";
import pluginQuery from "@tanstack/eslint-plugin-query";
import pluginRouter from "@tanstack/eslint-plugin-router";
import eslintConfigPrettier from "eslint-config-prettier";
import reactHooks from "eslint-plugin-react-hooks";
import { defineConfig } from "eslint/config";
import tseslint from "typescript-eslint";
import eslintPluginPrettierRecommended from "eslint-plugin-prettier/recommended";

const { plugins: _, ...reactHooksConfig } = reactHooks.configs["recommended-latest"];

export default defineConfig({
  ignores: ["dist", ".wrangler", ".vercel", ".netlify", ".output", "build/", "**/gen/**/*"],
  files: ["**/*.{ts,tsx}"],
  languageOptions: {
    parser: tseslint.parser,
    parserOptions: {
      projectService: true,
      tsconfigRootDir: import.meta.dirname,
    },
  },
  plugins: {
    "react-hooks": reactHooks,
  },
  extends: [
    js.configs.recommended,
    ...tseslint.configs.recommendedTypeChecked,
    ...tseslint.configs.stylisticTypeChecked,
    eslintConfigPrettier,
    ...pluginQuery.configs["flat/recommended"],
    ...pluginRouter.configs["flat/recommended"],
    reactHooksConfig,
    react.configs["recommended-type-checked"],
    ...eslintPluginPrettierRecommended,
  ],
  rules: {
    // You can override any rules here
    "@typescript-eslint/no-deprecated": "warn",
    "@typescript-eslint/no-unused-vars": "warn",
    "@typescript-eslint/no-namespace": "off",
  },
});
