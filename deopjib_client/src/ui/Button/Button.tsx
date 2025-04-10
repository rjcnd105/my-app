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
  export type Return = ReturnType<typeof Button> & { __uri: "Button" };
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
  ) as ReactElement<Button.Props>;
};
export type Button = typeof Button;

Button.utils = {
  getClassName: (props: Button.Props) => {
    return `button ${props.theme}`;
  },
};

export const ButtonRail = ({
  MyButton,
  ButtonProps,
}: {
  MyButton: Button;
  ButtonProps: Button.Props;
}) => {
  return (
    <button className="button">
      <MyButton {...ButtonProps} />
    </button>
  );
};
