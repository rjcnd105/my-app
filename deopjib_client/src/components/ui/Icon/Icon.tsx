import type { SVGProps } from "react";
import { iconSpriteHref } from "@/constants/dev";
import type { IconName } from "@/icons/types.gen";

export function Icon({ name, className = "size-6", ...props }: Icon.Props) {
  return (
    <svg {...props} className={className}>
      <use href={`${iconSpriteHref}#${name}`} />
    </svg>
  );
}

export namespace Icon {
  export interface Props extends SVGProps<SVGSVGElement> {
    name: IconName;
  }
}
