import type { LinkProps } from "@tanstack/react-router";
import type { View } from "../Templates/View";

interface Props extends LinkProps {
  viewTransitionName?: View.TransitionName;
}

export function Link({viewTransitionName, ...props}: Props) {
  return <Link {...props}
    viewTransition={
      viewTransitionName
        ? { types: [viewTransitionName], }
        : false
    }
  />;
}
