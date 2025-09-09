import type { ComponentProps } from "react";

export function View(props: View.Props) {
  return (
    <div
      {...props}
      style={{ viewTransitionName: props.transitionName, ...props.style }}
    />
  );
}
export namespace View {
  export type TransitionName = "main";
  export interface Props extends ComponentProps<"div"> {
    transitionName: TransitionName;
  }
}
