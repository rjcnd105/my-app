import type {
  ComponentProps,
  ComponentType,
  FunctionComponentElement,
  PropsWithChildren,
  ReactComponentElement,
  ReactElement,
} from "react";
import { cva, type VariantProps } from "class-variance-authority";
import { tva } from "~/utils/styles";

const selected_class = "bg-primary text-white pointer-events-none";

export function Button({ theme, selected, size, ...rest }: Button.Props) {
  return (
    <button
      className={style({ theme, selected, size })}
      data-selected={selected}
      {...rest}
    ></button>
  );
}

export namespace Button {
  export type StyleProps = VariantProps<typeof style>;

  export interface Props
    extends StyleProps,
      PropsWithChildren,
      ComponentProps<"button"> {}
}

const themes = {
  none: "bg-none",
  primary: "bg-primary text-white disabled:bg-gray100",
  sub: `bg-sub`,
  gray: `bg-lightgray100`,
  warning: "bg-warning text-white disabled:bg-gray100 ",
  dark: "bg-darkgray200 text-white disabled:bg-gray100",
  ghost:
    "border border-blue200 rounded-[26px] text-blue300 disabled:text-gray100 disabled:border-gray100",
  text: "text-primary underline underline-offset-3 disabled:text-gray100 group-invalid/form:text-gray100",
};

const style = tva(null, {
  variants: {
    theme: {
      none: " bg-none",
      primary: "bg-primary text-white disabled:bg-gray100",
      sub: `bg-sub`,
      gray: `bg-lightgray100`,
      warning: "bg-warning text-white disabled:bg-gray100 ",
      dark: "bg-darkgray200 text-white disabled:bg-gray100",
      ghost:
        "border border-blue200 rounded-[26px] text-blue300 disabled:text-gray100 disabled:border-gray100",
      text: "text-primary underline underline-offset-3 disabled:text-gray100 group-invalid/form:text-gray100",
    },
    selected: {
      false: null,
      true: null,
    },
    isRounded: {
      true: "rounded-[26px]",
      false: null,
    },
    size: {
      sm: "px-4 h-6 rounded text-caption1 font-light",
      md: "px-4 h-8 rounded-md text-body2",
      lg: "px-4 h-9 rounded-md text-body2",
      xlg: "px-4 h-12 rounded-md text-body2",
    },
  },
  compoundVariants: [
    {
      theme: ["sub", "gray", "dark"],
      selected: true,
      className: selected_class,
    },
  ],
  defaultVariants: {
    theme: "none",
  },
});
