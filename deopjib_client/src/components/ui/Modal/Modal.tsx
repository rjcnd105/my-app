import { Dialog } from "@base-ui-components/react/dialog";
import type { OverlayControllerComponent } from "overlay-kit";
import {
  useEffect,
  useRef,
  useState,
  type ComponentProps,
  type PropsWithChildren,
} from "react";
import type { OnlySpecificRequired } from "~/utils/types";
import { Icon } from "../Icon/Icon";
import { cn, tva } from "~/utils/styles";
import { variant } from "valibot";
import type { VariantProps } from "class-variance-authority";
import {
  motion,
  MotionConfig,
  useAnimate,
  useDragControls,
} from "motion/react";
import { Handlebar } from "../Handlebar/Handlebar";

export function Modal({
  children,
  rootProps: _rootProps,
  hasBackdrop = true,
  TriggerSlot,
  keepMounted = false,
}: Modal.Props) {
  const { onOpenChange, ...rootProps } = _rootProps || {};

  return (
    <Dialog.Root {...rootProps}>
      {TriggerSlot}
      <Dialog.Portal keepMounted={keepMounted}>
        {hasBackdrop && (
          <Dialog.Backdrop className="fixed inset-0 opacity-100 max-h-screen max-w-screen bg-dimm ease-in-out backdrop-blur-dimm transition-opacity duration-100 data-[ending-style]:opacity-0 data-[starting-style]:opacity-0"></Dialog.Backdrop>
        )}
        {children}
      </Dialog.Portal>
    </Dialog.Root>
  );
}

export namespace Modal {
  export interface Props extends PropsWithChildren {
    rootProps?: Omit<Dialog.Root.Props, "children">;
    TriggerSlot?: React.ReactNode;
    hasBackdrop?: boolean;
    keepMounted?: Dialog.Portal.Props["keepMounted"];
  }
  export const Trigger = Dialog.Trigger;
  export const Popup = Dialog.Popup;
  export const Close = Dialog.Close;
  export const Title = Dialog.Title;
  export const Description = Dialog.Description;

  const MotionPopup = motion.create(Modal.Popup);
  export function BottomSheetPopup({
    children,
    className,
    ...props
  }: PropsWithChildren<ComponentProps<typeof MotionPopup>>) {
    const closeRef = useRef<HTMLButtonElement | null>(null);
    const [scope, animate] = useAnimate<HTMLDivElement>();
    const controller = useDragControls();

    useEffect(() => {
      if (scope.current) {
        scope.current.style.transitionDuration = `${scope.current.getBoundingClientRect().height / 1.4}ms`;
      }
    }, [scope]);

    return (
      <MotionPopup
        drag="y"
        ref={scope}
        className={cn(
          "fixed ease-quad2-out bg-white bottom-0 data-[dragging]:duration-[0ms]! data-[starting-style]:translate-y-full data-[ending-style]:translate-y-full",
          className,
        )}
        {...props}
        style={{
          paddingBottom: "80px",
          marginBottom: "-80px",
          ...props.style,
        }}
        dragControls={controller}
        dragSnapToOrigin
        dragListener={false}
        dragConstraints={{ top: 0 }}
        dragTransition={{ bounceStiffness: 500, bounceDamping: 24 }}
        dragElastic={0.1}
        onDragStart={() => {
          if (scope.current) {
            scope.current.dataset.dragging = "true";
          }
        }}
        onDragTransitionEnd={() => {
          delete scope.current.dataset.dragging;
        }}
        onDragEnd={(e, info) => {
          if (!scope.current) return;

          const { height: withPaddingHeight } =
            scope.current.getBoundingClientRect();
          const height = withPaddingHeight - 80;

          if (info.offset.y < 0) return;
          const per = info.offset.y / height;
          const velPer = height / 200;
          const perWithVelocity =
            ((info.offset.y + info.velocity.y) / height) * velPer;

          if (perWithVelocity > 0.4) {
            delete scope.current.dataset.dragging;
            requestAnimationFrame(() => {
              closeRef.current?.click();
            });
          }
        }}
      >
        <Dialog.Close className="hidden" ref={closeRef} />
        <Handlebar
          controller={controller}
          className="absolute top-0 left-0 right-0"
        />
        {children}
      </MotionPopup>
    );
  }

  export function CrossClose({ className, ...props }: Dialog.Close.Props) {
    return (
      <Modal.Close
        className="size-6 flex justify-center items-center"
        {...props}
      >
        <Icon
          name="cross"
          style={
            {
              "--icon-stroke-color": "var(--color-darkgray200)",
            } as React.CSSProperties
          }
          className="size-full stroke-darkgray200"
        ></Icon>
      </Modal.Close>
    );
  }

  export const commonPopupClass =
    "fixed outline-transparent focus-visible:outline-blue300 bg-white shadow-1";

  export const style = tva(null, {
    variants: {
      duration: {
        "150_100": "duration-150 data-[ending-style]:duration-100",
        "200_150": "duration-200 data-[ending-style]:duration-150",
        "250_200": "duration-250 data-[ending-style]:duration-200",
        "300_250": "duration-300 data-[ending-style]:duration-250",
      },
    },
  });
  export type Style = VariantProps<typeof style>;
}
