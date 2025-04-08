function payItemNameFilter(text: string) {
  const [name, price] = text.split("/");

  if (!name || !price) return "";

  return name;
}

const globalFunctions = {
  payItemNameFilter,
} as const;

export type GlobalFunctions = typeof globalFunctions;
