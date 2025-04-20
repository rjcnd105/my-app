import { cva, cx } from "class-variance-authority";
import type { ClassValue } from "class-variance-authority/types";
import { twMerge } from "tailwind-merge";

export const tva = <T>(...params: Parameters<typeof cva<T>>) => {
  const v = cva(...params);
  const f: typeof v = (props) => twMerge(v(props));

  return f;
};

export const cn = (...classes: ClassValue[]) => twMerge(cx(...classes));
