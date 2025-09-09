import type { TextInputProps } from "@mantine/core";
import { TextInput as BaseTextInput } from "@mantine/core";
import type { MouseEventHandler } from "react";
import { cn } from "@shared/utils/styles";
import { Button } from "../Button/Button";
import { Icon } from "../Icon/Icon";
import classes from "./input.module.css";

export function TextInput({
  className,
  placeholder,
  rightSection,
  ...props
}: TextInput.Props) {
  return (
    <BaseTextInput
      classNames={{
        // error: "TextInput__error",
        error: `TextInput__error ${classes.error}`,
        section: "TextInput__section flex items-center h-full",
        root: "group/TextInput",
        description: "TextInput__description",
        wrapper:
          "TextInput__wrapper has-[&>input:valid]:border-primary has-[&_input:user-invalid]:border-warning rounded-md border-1 pr-2 h-12 py-2 flex items-center justify-center",
        input: "TextInput__input pl-2 outline-0",
        label: "TextInput__label",
      }}
      className={cn("", className)}
      placeholder={placeholder ?? ""}
      rightSection={
        <>
          <InputClearButton />
          {rightSection}
        </>
      }
      {...props}
    />
  );
}

function InputClearButton() {
  return (
    <Button
      className="group-has-[&_input]/TextInput:invisible group-has-placeholder-shown/TextInput:invisible px-2 w-7.5 h-full"
      onClick={inputClear}
    >
      <Icon
        name="cross"
        className="size-3.5 rounded-full in-focus-visible:fill-darkgray100 stroke-darkgray300"
      />
    </Button>
  );
}
const inputClear: MouseEventHandler<HTMLButtonElement> = (e) => {
  const inputEl = e.currentTarget.closest(".TextInput__wrapper")?.querySelector("input");

  if (inputEl instanceof HTMLInputElement) {
    inputEl.value = "";
    inputEl.dispatchEvent(new Event("change", { bubbles: true }));
    inputEl.focus();
  }
};

export namespace TextInput {
  export interface Props extends TextInputProps {}
}
