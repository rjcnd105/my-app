import type { CreateClientConfig } from "@/entities/gen/api/client";

export const createClientConfig: CreateClientConfig = (config) => ({
  ...config,
  baseUrl: `http://localhost:${process.env.SERVER_PORT}`,
});
