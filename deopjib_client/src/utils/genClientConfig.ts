import type { CreateClientConfig } from "@/gen/api/client";

export const createClientConfig: CreateClientConfig = (config) => ({
  ...config,
  baseUrl: "http://localhost:4000",
});
