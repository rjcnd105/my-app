import type { ComponentProps, PropsWithChildren } from "react";
import { cn } from "~/utils/styles";
import { Icon } from "../Icon/Icon";
import { Checkbox as BaseCheckbox } from "@base-ui-components/react/checkbox";

export function Checkbox({
  labelClassName,
  className,
  children,
  ...rest
}: Checkbox.Props) {
  return (
    <label className={cn("size-fit block items-center", labelClassName)}>
      <BaseCheckbox.Root
        className={cn(
          "flex size-5 items-center justify-center rounded-full overflow-hidden focus-visible:ring-1 data-[unchecked]:bg-gray100 data-[checked]:bg-primary",
          className,
        )}
        {...rest}
      >
        <BaseCheckbox.Indicator className="size-full data-[unchecked]:hidden">
          <Icon
            className="size-full"
            name="check"
            style={{ "--icon-stroke-color": "white" } as React.CSSProperties}
          ></Icon>
        </BaseCheckbox.Indicator>
      </BaseCheckbox.Root>
      {children}
    </label>
  );
}

export namespace Checkbox {
  export interface Props extends PropsWithChildren, BaseCheckbox.Root.Props {
    labelClassName?: String;
  }
}
