import { Client, fetchExchange, cacheExchange, ssrExchange } from "urql";
import { persistedExchange } from "@urql/exchange-persisted";

const isServerSide = typeof window === "undefined";

// The `ssrExchange` must be initialized with `isClient` and `initialState`
const ssr = ssrExchange({
  isClient: !isServerSide,
  // @ts-ignore
  initialState: !isServerSide ? window.__URQL_DATA__ : undefined,
});

export const client = new Client({
  url: "http://localhost:4000/graphql",
  exchanges: [
    cacheExchange,
    persistedExchange({
      preferGetForPersistedQueries: true,
    }),
    ssr,
    fetchExchange,
  ],
  requestPolicy: "cache-and-network",
});
