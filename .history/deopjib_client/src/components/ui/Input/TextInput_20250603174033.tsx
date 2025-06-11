import { cn } from "~/utils/styles";
import { TextInput as BaseTextInput } from "@mantine/core";
import type { TextInputProps } from "@mantine/core";

export function TextInput({ className, ...props }: TextInput.Props) {
  return <BaseTextInput className={cn("", className)} {...props} />;
}

export namespace TextInput {

  export interface Props extends TextInputProps { }
}
