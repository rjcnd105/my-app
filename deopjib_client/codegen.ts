import type { CodegenConfig } from "@graphql-codegen/cli";

import { addTypenameSelectionDocumentTransform } from "@graphql-codegen/client-preset";

const config: CodegenConfig = {
  schema: "https://graphql.org/graphql/",
  documents: ["src/**/*.tsx"],
  ignoreNoDocuments: true,
  generates: {
    "./src/graphql/": {
      preset: "client",
      config: {
        documentMode: "string",
        persistedDocuments: true,
        documentTransforms: [addTypenameSelectionDocumentTransform],
      },
    },
  },
};

export default config;
