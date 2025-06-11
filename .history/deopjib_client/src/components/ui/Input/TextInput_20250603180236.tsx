import { cn } from "~/utils/styles";
import { TextInput as BaseTextInput } from "@mantine/core";
import type { TextInputProps } from "@mantine/core";
import { Button } from "../Button/Button";
import { Icon } from "../Icon/Icon";


export function TextInput({ className, placeholder, ...props }: TextInput.Props) {
  return <BaseTextInput classNames={{
    error: "TextInput__error",
    section: "TextInput__section",
    root: "TextInput__root",
    description: "TextInput__description",
    wrapper: "TextInput__wrapper h-full flex items-center justify-center",
    input: "TextInput__input",
    label: "TextInput__label",
  }} className={cn("", className)} placeholder={placeholder ?? ""} rightSection={<>
    <Button className="placeholder-shown:invisible">
      <Icon name="cross_circle" className="size-3.5 fill-gray100" ></Icon>
    </Button>
    <Button>hihi</Button>
  </>}  {...props} />;
}

export namespace TextInput {

  export interface Props extends TextInputProps { }
}
