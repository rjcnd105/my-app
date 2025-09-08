import type { VariantProps } from "class-variance-authority";
import type { ComponentProps, PropsWithChildren } from "react";
import { objKeyToEnum } from "@/shared/utils/obj";
import { tva } from "@/shared/utils/styles";

export function Button({
  theme,
  selected,
  size,
  className,
  ...rest
}: Button.Props) {
  return (
    <button
      className={style({ theme, selected, size }, disabledClass, className)}
      data-selected={selected}
      {...rest}
    />
  );
}

const themeClasses = {
  none: "bg-none",
  primary: "bg-primary text-white disabled:bg-gray100",
  sub: "bg-sub",
  gray: "bg-lightgray100",
  warning: "bg-warning text-white disabled:bg-gray100 ",
  dark: "bg-darkgray200 text-white disabled:bg-gray100",
  ghost:
    "border border-blue200 rounded-[26px] text-blue300 disabled:text-gray100 disabled:border-gray100",
  text: "text-primary underline underline-offset-3 disabled:text-gray100 group-invalid/form:text-gray100",
};

const sizeClasses = {
  sm: "px-4 h-6 rounded text-caption1 font-light",
  md: "px-4 h-8 rounded-md text-body2",
  lg: "px-4 h-9 rounded-md text-body2",
  xlg: "px-4 h-12 rounded-md text-body2",
};

const disabledClass = "disabled:pointer-events-none disabled:bg-gray100";
const selectedClass = "bg-primary text-white pointer-events-none";

Button.disabledClass = disabledClass;

const style = tva("my-button", {
  variants: {
    theme: themeClasses,
    selected: {
      false: null,
      true: null,
    },
    isRounded: {
      true: "rounded-[26px]",
      false: null,
    },
    size: sizeClasses,
  },
  compoundVariants: [
    {
      theme: ["sub", "gray", "dark"],
      selected: true,
      className: selectedClass,
    },
  ],
  defaultVariants: {
    theme: "none",
  },
});

export namespace Button {
  export type StyleProps = VariantProps<typeof style>;

  export interface Props
    extends StyleProps,
      PropsWithChildren,
      ComponentProps<"button"> {}

  export const themes = objKeyToEnum(themeClasses);
  export const sizes = objKeyToEnum(sizeClasses);
}
