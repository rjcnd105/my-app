

/**
 * 데카르트곱 형식의 mapping
 * @example joinMap([['a', 'b'], [1, 2]], (a, b) => `${a}-${b}`) // ['a-1', 'a-2', 'b-1', 'b-2']
 */
export const joinMap = <const T extends readonly (readonly unknown[])[], R>(
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
    currentCombination: unknown[],
  ) => {
    if (currentIndex === numArrays) {
      results.push(
        fn(...(currentCombination as { [K in keyof T]: T[K][number] })),
      );
      return;
    }

    const currentArray = arrays[currentIndex];
    if (currentArray === undefined) {
      // This path should not be reached if:
      // 1. currentIndex is always < numArrays (guaranteed by the recursive structure).
      // 2. arrays[currentIndex] is always an array (guaranteed by T extends unknown[][]).
      // This error helps catch issues if 'noUncheckedIndexedAccess' is true in tsconfig
      // or if arrays somehow contains undefined values despite its type.
      throw new Error(
        `Critical error in generateCombinations: arrays[${currentIndex}] is undefined. ` +
        `currentIndex: ${currentIndex}, numArrays: ${numArrays}, arrays content: ${JSON.stringify(arrays)}`
      );
    }
    for (const element of currentArray) {
      generateCombinations(currentIndex + 1, [...currentCombination, element]);
    }
  };

  generateCombinations(0, []);

  return results;
};
