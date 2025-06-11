import { cn } from "~/utils/styles";
import { TextInput as BaseTextInput } from "@mantine/core";
import type { TextInputProps } from "@mantine/core";
import { Button } from "../Button/Button";
import { Icon } from "../Icon/Icon";


export function TextInput({ className, placeholder, ...props }: TextInput.Props) {
  return <BaseTextInput classNames={{
    error: "TextInput__error",
    section: "TextInput__section flex items-center h-full",
    root: "TextInput__root",
    description: "TextInput__description",
    wrapper: "TextInput__wrapper h-12 py-2 [&_input:placeholder-shown~div>button[data-part=close]]:invisible flex items-center justify-center",
    input: "TextInput__input pl-2",
    label: "TextInput__label",

  }} className={cn("", className)} placeholder={placeholder ?? ""} rightSection={<>
    <Button data-part="close" className="px-2 w-7.5 h-full" >
      <Icon name="cross_circle" className="size-full fill-gray100" ></Icon>
    </Button>
    <Button>hihi</Button>
  </>}  {...props} />;
}

export namespace TextInput {

  export interface Props extends TextInputProps { }
}
