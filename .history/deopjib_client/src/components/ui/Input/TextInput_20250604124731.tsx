import { cn } from "~/utils/styles";
import { TextInput as BaseTextInput } from "@mantine/core";
import type { TextInputProps } from "@mantine/core";
import { Button } from "../Button/Button";
import { Icon } from "../Icon/Icon";
import type { MouseEventHandler } from "react";


export function TextInput({ className, placeholder, rightSection, ...props }: TextInput.Props) {
  return <BaseTextInput classNames={{
    error: "TextInput__error",
    section: "TextInput__section flex items-center h-full",
    root: "TextInput__root",
    description: "TextInput__description",
    wrapper: "TextInput__wrapper group/TextInput rounded-md border-1 border-primary pr-2 h-12 py-2 flex items-center justify-center",
    input: "TextInput__input pl-2 outline-0",
    label: "TextInput__label",

  }} className={cn("", className)} placeholder={placeholder ?? ""} rightSection={<>
    <InputClearButton />
    {rightSection}
  </>}  {...props} />;
}


function InputClearButton() {
  return <Button className="group/TextInput-has-placeholder-shown:invisible px-2 w-7.5 h-full" onClick={inputClear} >
    <Icon name="cross_circle" className="size-3.5 rounded-full in-focus-visible:fill-darkgray100 fill-gray100" ></Icon>
  </Button>
}
const inputClear: MouseEventHandler<HTMLButtonElement> = (e) => {
  const inputEl = e.currentTarget.closest(".group")?.querySelector("input");

  if (inputEl instanceof HTMLInputElement) {
    inputEl.value = "";
    inputEl.dispatchEvent(new Event("change", { bubbles: true }));
    inputEl.focus();
  }
}


export namespace TextInput {

  export interface Props extends TextInputProps { }
}
