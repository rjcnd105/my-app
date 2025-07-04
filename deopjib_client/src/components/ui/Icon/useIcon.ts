import { getIconComponent, getIconFile, type IconName } from "./IconMap.gen";

export function useIcon(name: IconName) {
  const component = getIconComponent(name);
  const fileUrl = getIconFile(name);

  return {
    Component: component,
    fileUrl,
    exists: !!(component && fileUrl),
  };
}

// 파일 URL만 필요한 경우
export function useIconFile(name: IconName) {
  return getIconFile(name);
}

// 컴포넌트만 필요한 경우
export function useIconComponent(name: IconName) {
  return getIconComponent(name);
}
