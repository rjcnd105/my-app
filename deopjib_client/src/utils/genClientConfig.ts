import type { CreateClientConfig } from "@/gen/api/client";

export const createClientConfig: CreateClientConfig = (config) => ({
  ...config,
  baseUrl: `${process.env.BASE_SERVER_URL}`,
});
