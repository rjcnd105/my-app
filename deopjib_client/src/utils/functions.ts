import type { extend } from "es-toolkit/compat";

/**
 * 데카르트곱 형식의 mapping
 * @example joinMap([['a', 'b'], [1, 2]], (a, b) => `${a}-${b}`) // ['a-1', 'a-2', 'b-1', 'b-2']
 */
export const joinMap = <const T extends ReadonlyArray<ReadonlyArray<any>>, R>(
  arrays: T,
  fn: (...args: { [K in keyof T]: T[K][number] }) => R,
): R[] => {
  const results: R[] = [];
  const numArrays = arrays.length;

  if (numArrays === 0 || arrays.some((arr) => arr.length === 0)) {
    return [];
  }

  const generateCombinations = (
    currentIndex: number,
    currentCombination: any[],
  ) => {
    if (currentIndex === numArrays) {
      results.push(
        fn(...(currentCombination as { [K in keyof T]: T[K][number] })),
      );
      return;
    }

    const currentArray = arrays[currentIndex]!;
    for (const element of currentArray) {
      generateCombinations(currentIndex + 1, [...currentCombination, element]);
    }
  };

  generateCombinations(0, []);

  return results;
};
