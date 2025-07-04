import { type SVGProps } from "react";
import { useIconComponent } from "./useIcon";
import type { IconName } from "./IconMap.gen";

// SVG 컴포넌트로 렌더링
export function Icon({ name, ...props }: Icon.Props) {
  const IconComponent = useIconComponent(name);

  if (!IconComponent) {
    console.warn(`Icon "${name}" not found`);
    return null;
  }

  return <IconComponent {...props} />;
}

export namespace Icon {
  export interface Props extends SVGProps<SVGSVGElement> {
    name: IconName;
  }
}
