export type ValueOf<T> = T[keyof T];

type Combine<A> = { [K in keyof A]: A[K] };

/**
 * @example
 * type A = Rest<[number, string, boolean]>;
 * // [string, boolean]
 * type B = Rest<readonly [number, string, boolean]>;
 * // readonly [string, boolean]
 */
export type Rest<T> = T extends readonly [infer _, ...infer Rest]
  ? Readonly<Rest>
  : T extends [infer _, ...infer Rest]
    ? Rest
    : never;

/**
 * @example
 * type A = Optional<{ a: number, b: string }, 'a'>;
 * // { b: string, a?: boolean }
 */
export type Optional<A, B extends keyof A> = Combine<
  Omit<A, B> & { [K in B]?: A[K] }
>;

/**
 * @example
 * type A = Optional<{ a?: number, b?: string, c: boolean }, 'a'>;
 * // { a: number, b?: string, c: boolean }
 */
export type PartialRequired<A, B extends keyof A> = Combine<
  Omit<A, B> & { [K in B]: A[K] }
>;

/**
 * 특정 필드만 필수로
 */
export type OnlySpecificRequired<A, B extends keyof A> = Combine<
  { [K in Exclude<keyof A, B>]?: A[K] } & { [K in B]: A[K] }
>;
