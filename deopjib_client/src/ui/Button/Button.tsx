import type {
  ComponentProps,
  ComponentType,
  FunctionComponentElement,
  PropsWithChildren,
  ReactComponentElement,
  ReactElement,
} from "react";
import { twMerge } from "tailwind-merge";

export namespace Button {
  export type Themes = "primary" | "secondary";
  export interface Props extends ComponentProps<"button">, PropsWithChildren {
    theme: Themes;
  }
}

export const Button = ({ theme, ...rest }: Button.Props) => {
  return (
    <button
      className={twMerge(
        "button",
        theme === "primary" ? "primary" : "secondary",
      )}
      {...rest}
    >
      Button
    </button>
  );
};

Button.utils = {
  getClassName: (props: Button.Props) => {
    return `button ${props.theme}`;
  },
};
