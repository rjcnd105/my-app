import type { variant } from "valibot";
import { cn, tva } from "~/utils/styles";

export function Chip({ children, className, ...rest }: Chip.Props) {
  return (
    <div
      className={cn(" rounded-full bg-gray-200 px-2 py-1 text-sm", className)}
      {...rest}
    >
      {children}
    </div>
  );
}

const buttonStyle = tva(null, {
  variants: {
    theme: {
      white: "bg-white font-bold text-primary",
      secondary: "text-white bg-secondary",
    },
  },
});
export namespace Chip {
  export type Props = {
    children: React.ReactNode;
    className?: string;
  };
}
