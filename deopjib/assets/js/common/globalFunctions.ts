function payItemNameFilter(text: string) {
  const [name, amount] = text.split("/");

  if (!name || !amount) return "";

  return name;
}

export const globalFunctions = {
  payItemNameFilter,
} as const;

export type GlobalFunctions = typeof globalFunctions;
