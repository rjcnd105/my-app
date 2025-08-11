import type { ComponentProps, PropsWithChildren } from "react";
import { tva } from "@/utils/styles";
import type { ValueOf } from "@/utils/types";
import { Icon } from "../Icon/Icon";

export function Chip({ children, theme, className, ...rest }: Chip.Props) {
  return (
    <div className={wrapStyle({ theme })}>
      {children}

      <button className="flex justify-center items-center w-6 h-full" {...rest}>
        <div className={iconWrapStyle({ theme })}>
          <Icon name="cross" />
        </div>
      </button>
    </div>
  );
}

const chipThemes = {
  white: "white",
  secondary: "secondary",
  primary: "primary",
  gray: "gray",
} as const;

const { white, secondary, primary, gray } = chipThemes;

const wrapStyle = tva(
  "flex w-fit items-center gap-0.5 pl-2 pr-1 h-9 rounded-[26px]",
  {
    variants: {
      theme: {
        [white]: "bg-white font-bold text-primary",
        [secondary]: "text-white bg-secondary",
        [primary]: "text-white bg-primary",
        [gray]: "text-black bg-lightgray100",
      },
    },
    defaultVariants: {
      theme: white,
    },
  },
);

const iconWrapStyle = tva(
  "grid place-items-center size-3.5 rounded-full [&_svg]:size-3 stroke-white",
  {
    variants: {
      theme: {
        [white]: "bg-gray200",
        [secondary]: "bg-primary",
        [primary]: "bg-blue500",
        [gray]: "bg-gray200",
      },
    },
    defaultVariants: {
      theme: white,
    },
  },
);

export namespace Chip {
  export const themes = chipThemes;
  export type Theme = ValueOf<typeof themes>;

  export interface Props extends PropsWithChildren<ComponentProps<"button">> {
    theme?: Theme;
  }
}
