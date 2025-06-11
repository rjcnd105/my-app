import { cn } from "~/utils/styles";
import { Input as BaseInput } from "@mantine/core";
import type { InputProps, InputWrapperProps, TextInputProps } from "@mantine/core";

function _Input({ className, ...props }: TextInput.Props) {
  return <BaseInput className={cn("", className)} {...props} />;
}

function _Wrapper({ children, ...props }: TextInput.WrapperProps) {
  return <BaseInput.Wrapper {...props}>{children}</BaseInput.Wrapper>;
}

export namespace TextInput {
  export interface Props extends TextInputProps { }
}
