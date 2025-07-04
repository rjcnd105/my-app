import { type ImgHTMLAttributes } from "react";
import { useIconFile } from "./useIcon";
import type { IconName } from "./IconMap.gen";

// img 태그로 렌더링
export function ImageIcon({ name, alt, ...props }: ImageIcon.Props) {
  const iconUrl = useIconFile(name);

  if (!iconUrl) {
    console.warn(`Icon file "${name}" not found`);
    return null;
  }

  return (
    <img
      src={iconUrl}
      alt={alt || `${name} icon`}
      {...props}
    />
  );
}

export namespace ImageIcon {
  export interface Props extends Omit<ImgHTMLAttributes<HTMLImageElement>, 'src'> {
    name: IconName;
    alt?: string;
  }
}
