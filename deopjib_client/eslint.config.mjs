// https://docs.expo.dev/guides/using-eslint/
// import simpleImportSort from 'eslint-plugin-simple-import-sort';

import { defineConfig, globalIgnores } from "eslint/config";
import expoConfig from "eslint-config-expo/flat.js";
import eslintPluginPrettierRecommended from "eslint-plugin-prettier/recommended";
import { configs, parser } from "typescript-eslint";

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
	]),
	expoConfig,
	eslintPluginPrettierRecommended,
	{
		// plugins: {
		//   'simple-import-sort': simpleImportSort,
		// },
		rules: {
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
