import { cva, cx } from "class-variance-authority";
import type { ClassValue } from "class-variance-authority/types";

export const tva = <T>(...params: Parameters<typeof cva<T>>) => {
  const v = cva(...params);
  type Props = Parameters<typeof v>[0];
  const f = (props: Props, ...rest: ClassValue[]) =>
    cn(v(props), ...rest);

  return f;
};

export const cn = cx;
