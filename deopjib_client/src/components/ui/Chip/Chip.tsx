import { tva } from "~/utils/styles";
import { Icon } from "../Icon/Icon";
import type {
  Component,
  ComponentProps,
  ComponentType,
  PropsWithChildren,
} from "react";
import type { ValueOf } from "~/utils/types";

export function Chip({ children, theme, className, ...rest }: Chip.Props) {
  return (
    <div className={wrapStyle({ theme })}>
      {children}

      <button className="flex justify-center items-center w-6 h-full" {...rest}>
        <Icon className={iconStyle({ theme })} name="cross_circle"></Icon>
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

const iconStyle = tva("size-3.5 stroke-white", {
  variants: {
    theme: {
      [white]: "fill-gray200",
      [secondary]: "fill-primary",
      [primary]: "fill-blue500",
      [gray]: "fill-gray200",
    },
  },
  defaultVariants: {
    theme: white,
  },
});

export namespace Chip {
  export const themes = chipThemes;
  export type Theme = ValueOf<typeof themes>;

  export interface Props extends PropsWithChildren<ComponentProps<"button">> {
    theme?: Theme;
  }
}
