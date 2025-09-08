export function objKeys<T extends Record<string, unknown>>(
  obj: T,
): ReadonlyArray<keyof T> {
  return Object.keys(obj);
}

/**
 * Converts an object's keys to an enum.
 * @example
 * const obj = { a: 1, b: 2 };
 * const enumObj = objKeyToEnum(obj);
 * console.log(enumObj.a); // Output: 'a'
 */
export function objKeyToEnum<const T extends Record<string, unknown>>(
  obj: T,
): { [keys in keyof T]: keys } {
  return Object.keys(obj).reduce(
    (acc, key) => {
      // @ts-ignore
      acc[key] = key as keyof T;
      return acc;
    },
    {} as unknown as { [keys in keyof T]: keys },
  );
}
