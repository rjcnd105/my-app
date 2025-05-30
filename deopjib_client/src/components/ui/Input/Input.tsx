import { cn } from "~/utils/styles";
import { Input as BaseInput } from "@mantine/core";
import type { InputProps, InputWrapperProps } from "@mantine/core";

function _Input({ className, ...props }: Input.Props) {
  return <BaseInput className={cn("", className)} {...props} />;
}

function _Wrapper({ children, ...props }: Input.WrapperProps) {
  return <BaseInput.Wrapper {...props}>{children}</BaseInput.Wrapper>;
}

export namespace Input {
  export interface Props extends InputProps { }
  export interface WrapperProps extends InputWrapperProps { }
}
