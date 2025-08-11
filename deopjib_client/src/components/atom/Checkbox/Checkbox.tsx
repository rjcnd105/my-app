import { Checkbox as BaseCheckbox, type CheckboxProps } from "@mantine/core";
import { cn } from "@/utils/styles";
import { Icon as CommonIcon } from "../Icon/Icon";

export function Checkbox({
  icon = Checkbox.Icon,
  className,
  ...rest
}: Checkbox.Props) {
  return (
    <BaseCheckbox
      classNames={{
        body: "flex gap-1.5",
        inner:
          "relative size-5 inline-block rounded-full overflow-hidden bg-gray100 has-checked:bg-primary",
        input: "peer absolute inset-0 z-1 appearance-none cursor-pointer",
        label: "text-caption2",
        labelWrapper: "flex items-center h-5",
        icon: "absolute hidden left-0 right-0 size-full rounded-full overflow-hidden peer-checked:block",
      }}
      icon={icon}
      {...rest}
    />
  );
}

export namespace Checkbox {
  export interface Props extends CheckboxProps {}

  export const Icon: NonNullable<CheckboxProps["icon"]> = ({
    indeterminate,
    className,
  }) => {
    return (
      <CommonIcon
        className={cn("absolute inset-0 ", className)}
        viewBox="0 0 20 20"
        name="check"
        aria-hidden
        style={{ "--icon-stroke-color": "white" } as React.CSSProperties}
      />
    );
  };
}
