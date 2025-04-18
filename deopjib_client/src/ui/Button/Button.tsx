import type {
  ComponentProps,
  ComponentType,
  FunctionComponentElement,
  PropsWithChildren,
  ReactComponentElement,
  ReactElement,
} from "react";
import { twMerge } from "tailwind-merge";
import css from "./Button.module.css";

const selected_class =
  "data-selected:bg-primary data-selected:text-white data-selected:pointer-events-none";

const themes = {
  none: "bg-none",
  primary: "bg-primary text-white disabled:bg-gray100",
  sub: "bg-sub ",
} as const;

export namespace Button {
  export interface Props extends ComponentProps<"button">, PropsWithChildren {
    theme: keyof typeof themes;
  }
}

export const Button = ({ theme, ...rest }: Button.Props) => {
  return (
    <button className={css.Button} {...rest}>
      Button
    </button>
  );
};

Button.utils = {
  getClassName: (props: Button.Props) => {
    return `button ${props.theme}`;
  },
};
