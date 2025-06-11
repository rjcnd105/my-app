import { cn } from "~/utils/styles";
import { Input as BaseInput } from "@mantine/core";
import type { TextInputProps } from "@mantine/core";

function _Input({ className, ...props }: TextInput.Props) {
  return <BaseInput className={cn("", className)} {...props} />;
}

export namespace TextInput {
  export interface Props extends TextInputProps { }
}
