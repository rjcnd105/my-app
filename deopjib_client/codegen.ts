import type { CodegenConfig } from "@graphql-codegen/cli";

import { addTypenameSelectionDocumentTransform } from "@graphql-codegen/client-preset";

const config: CodegenConfig = {
  // schema: "https://graphql.org/graphql/",
  schema: "../deopjib/priv/schema.graphql",
  documents: ["src/**/*.{graphql,ts,tsx}"],
  ignoreNoDocuments: true,
  generates: {
    "./src/graphql/generated/": {
      preset: "client",
      // plugins: ["typescript", "typescript-operations", "typed-document-node"],
      config: {
        strictScalars: true,
        useTypeImports: true,
        enumsAsTypes: true,
        scalars: {
          // TODO: Choose a decimal library and use that type instead
          // For custom scalars config, see https://github.com/dotansimha/graphql-code-generator/issues/153
          Decimal: "number",
          DateTime: "Date",
          Json: "{ [key: string]: any }",
        },
      },
    },
  },
  watch: true,
};

export default config;
