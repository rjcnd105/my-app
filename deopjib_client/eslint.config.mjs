// https://docs.expo.dev/guides/using-eslint/
// import simpleImportSort from 'eslint-plugin-simple-import-sort';

import { defineConfig, globalIgnores } from "eslint/config";
import reactCompiler from "eslint-plugin-react-compiler";
import expoConfig from "eslint-config-expo/flat.js";
import eslintPluginPrettierRecommended from "eslint-plugin-prettier/recommended";
import { configs, parser } from "typescript-eslint";

// eslint-disable-next-line import/no-named-as-default, import/no-named-as-default-member, import/namespace
import eslintPluginUnicorn from "eslint-plugin-unicorn";

export default defineConfig([
  globalIgnores([
    "dist/*",
    "node_modules",
    "__tests__/",
    "coverage",
    ".expo",
    ".expo-shared",
    "android",
    "ios",
    ".vscode",
    "docs/",
    "cli/",
    "expo-env.d.ts",
    "src/gen",
  ]),
  expoConfig,
  eslintPluginPrettierRecommended,
  reactCompiler.configs.recommended,
  {
    plugins: {
      // 'simple-import-sort': simpleImportSort,
      unicorn: eslintPluginUnicorn,
    },
    rules: {
      // "unicorn/filename-case": [
      //   "error",
      //   {
      //     case: "kebabCase",
      //     ignore: ["/android", "/ios"],
      //   },
      // ],
      "max-params": ["error", 3],
      "react/display-name": "off",
      "react/no-inline-styles": "off",
      "react/destructuring-assignment": "off",
      "react/require-default-props": "off",
      "import/prefer-default-export": "off",
      // 'simple-import-sort/imports': 'error',
      // 'simple-import-sort/exports': 'error',

      "import/no-cycle": ["error", { maxDepth: "∞" }],
    },
  },
  {
    files: ["**/*.ts", "**/*.tsx"],
    languageOptions: {
      parser: parser,
      parserOptions: {
        project: "./tsconfig.json",
        sourceType: "module",
      },
    },
    rules: {
      ...configs.stylisticTypeChecked.rules,
      "@typescript-eslint/comma-dangle": "off",
      "@typescript-eslint/consistent-type-imports": [
        "warn",
        {
          prefer: "type-imports",
          fixStyle: "inline-type-imports",
          disallowTypeAnnotations: true,
        },
      ],
    },
  },
]);
