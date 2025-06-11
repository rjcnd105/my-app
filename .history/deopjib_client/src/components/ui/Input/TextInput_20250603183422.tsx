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
    wrapper: "TextInput__wrapper group h-12 py-2 flex items-center justify-center",
    input: "TextInput__input pl-2",
    label: "TextInput__label",

  }} className={cn("", className)} placeholder={placeholder ?? ""} rightSection={<>
    <InputClearButton />
    <Button>hihi</Button>
  </>}  {...props} />;
}

function InputClearButton() {

  return <Button data-part="close" className="group-has-[placeholder-shown]:invisible px-2 w-7.5 h-full" >
    <Icon name="cross_circle" className="size-full fill-gray100" ></Icon>
  </Button>
}
window.addEventListener("input_box/clear-input", (e) => {
  const buttonEl = e.target as HTMLButtonElement;
  const inputEl = buttonEl.previousElementSibling;

  if (inputEl instanceof HTMLInputElement) {
    inputEl.value = "";
    inputEl.dispatchEvent(new Event("change", { bubbles: true }));
    inputEl.focus();
  }
});
export namespace TextInput {

  export interface Props extends TextInputProps { }
}
