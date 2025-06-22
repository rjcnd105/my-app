import type {
  ModalCloseButtonProps,
  ModalContentProps,
  ModalOverlayProps,
  ModalRootProps,
} from "@mantine/core";
import {
  ModalBaseCloseButton,
  ModalBody,
  ModalContent,
  ModalHeader,
  ModalOverlay,
  ModalRoot,
} from "@mantine/core";
import {
  type MotionProps,
  motion,
  useAnimate,
  useDragControls,
} from "motion/react";
import { type ReactNode, useEffect, useRef } from "react";
import { cn } from "@/utils/styles";
import type { Button } from "../Button/Button";
import { Handlebar } from "../Handlebar/Handlebar";
import { Icon } from "../Icon/Icon";

const commonPopupClass =
  "fixed outline-transparent focus-visible:outline-blue300 bg-white shadow-1";

const commonZIndex = "calc(var(--mb-z-index) + var(--add-modal-stack))";

function CrossCloseIcon({ className, ...props }: Button.Props) {
  return (
    <Icon
      name="cross"
      style={
        {
          "--icon-stroke-color": "var(--color-darkgray200)",
        } as React.CSSProperties
      }
      className="size-full stroke-darkgray200"
    />
  );
}

function _CloseButton({ className, ...props }: Modal.CloseButtonProps) {
  return (
    <ModalBaseCloseButton
      icon={<CrossCloseIcon />}
      className={cn("size-[28px] flex justify-center items-center", className)}
      {...props}
    />
  );
}

function _Content({
  children,
  hasBackdrop = true,
  hasCloseButton = true,
  contentClassName,
  closePosition = "right",
  Title,
  style,
  ...props
}: Modal.ContentProps) {
  return (
    <ModalContent
      classNames={{
        content: contentClassName,
      }}
      style={{
        zIndex: commonZIndex,
        ...style,
      }}
      {...props}
    >
      {hasCloseButton && Title && (
        <ModalHeader
          className={cn(
            "flex relative h-[28px] mb-2",
            Title ? "justify-end" : "justify-between",
          )}
        >
          {closePosition === "left" && hasCloseButton && (
            <ModalBaseCloseButton
              icon={<CrossCloseIcon />}
              className="size-[28px] flex justify-center items-center"
            />
          )}
          {Title}
          {closePosition === "right" && hasCloseButton && (
            <ModalBaseCloseButton
              icon={<CrossCloseIcon />}
              className="size-[28px] flex justify-center items-center"
            />
          )}
        </ModalHeader>
      )}

      <ModalBody>{children}</ModalBody>
    </ModalContent>
  );
}

function _Overlay({
  className,
  style,
  transitionProps,
  ...props
}: Modal.OverlayProps) {
  return (
    <ModalOverlay
      className={cn(
        "fixed inset-0 bg-dimm backdrop-blur-dimm !ease-cubic-out",
        className,
      )}
      style={{
        zIndex: commonZIndex,
        ...style,
      }}
      transitionProps={{
        duration: 150,
        ...transitionProps,
      }}
      onClick={(e) => {
        if (!props.isClickClose) {
          e.stopPropagation();
          e.preventDefault();
        }
        props.onClick?.(e);
      }}
      {...props}
    />
  );
}

function _Root({
  children,
  transitionProps,
  opened,
  lockScroll = true,
  ...props
}: Modal.RootProps) {
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!lockScroll) return;
    if (!(ref.current instanceof HTMLElement)) return;
    if (!opened) {
      delete ref.current.dataset.overlayHidden;
      return;
    }
    const scrollLocked = document.body.dataset.scrollLocked ?? "0";

    const lockNum = Number(scrollLocked);

    ref.current.style.setProperty("--add-modal-stack", String(lockNum));

    return () => {
      ref.current?.style.removeProperty("--add-modal-stack");
    };
  }, [opened, lockScroll]);

  return (
    <ModalRoot
      ref={ref}
      opened={opened}
      lockScroll={lockScroll}
      transitionProps={{
        duration: 300,
        transition: {
          in: {},
          out: {},
          common: {},
          transitionProperty: undefined,
        },
        timingFunction: undefined,
        ...transitionProps,
        onEnter() {
          const content = ref?.current?.querySelector(
            "[data-modal-content=true]",
          );
          if (
            content instanceof HTMLElement &&
            content.dataset.enter !== "true"
          ) {
            content.dataset.showing = "true";
            delete content.dataset.exited;
            transitionProps?.onEnter?.();
          }
        },
        onEntered() {
          const content = ref?.current?.querySelector(
            "[data-modal-content=true]",
          );
          if (
            content instanceof HTMLElement &&
            content.dataset.entered !== "true"
          ) {
            content.dataset.entered = "true";
            transitionProps?.onEntered?.();
          }
        },
        onExit() {
          const content = ref?.current?.querySelector(
            "[data-modal-content=true]",
          );
          if (
            content instanceof HTMLElement &&
            content.dataset.exit !== "true"
          ) {
            content.dataset.exit = "true";
            delete content.dataset.entered;
            delete content.dataset.showing;
            transitionProps?.onExit?.();
          }
        },
        onExited() {
          const content = ref?.current?.querySelector(
            "[data-modal-content=true]",
          );
          if (
            content instanceof HTMLElement &&
            content.dataset.exited !== "true"
          ) {
            delete content.dataset.exit;
            content.dataset.exited = "true";
            transitionProps?.onExited?.();
          }
        },
      }}
      classNames={{
        root: "mantine-Modal-root data-overlay-hidden:[&_.mantine-Modal-overlay]:!hidden",
        overlay: "mantine-Modal-overlay",
        inner: "mantine-Modal-inner",
      }}
      style={{
        "--add-modal-stack": 0,
        ...props.style,
      }}
      {...props}
    >
      {children}
    </ModalRoot>
  );
}

function _BottomSheetContent({
  children,
  className,
  style,
  contentClassName,
  ...props
}: Modal.BottomSheetContentProps) {
  const [scope, _animate] = useAnimate<HTMLDivElement>();

  const controller = useDragControls();

  return (
    <motion.div
      drag="y"
      ref={scope}
      data-modal-content={true}
      className={cn("data-dragging:!duration-[0ms]", contentClassName)}
      style={{
        paddingBottom: "80px",
        marginBottom: "-80px",
        backfaceVisibility: "hidden",
        zIndex: commonZIndex,
        ...style,
      }}
      initial={{
        y: "100%",
      }}
      animate={{
        y: "0%",
        transition: {
          type: "spring",
          duration: 0.3,
          bounce: 0.2,
        },
      }}
      exit={{
        y: "100%",
        transition: {
          duration: 0.15,
          ease: "easeOut",
        },
      }}
      dragControls={controller}
      dragSnapToOrigin
      dragMomentum={false}
      dragListener={false}
      dragConstraints={{ top: 0 }}
      dragTransition={{ bounceStiffness: 500, bounceDamping: 24 }}
      dragElastic={0.1}
      onDragStart={(_e: PointerEvent) => {
        if (scope.current) {
          scope.current.dataset.dragging = "true";
        }
      }}
      onDragTransitionEnd={() => {
        if (!scope.current) return;
        delete scope.current?.dataset.dragging;
      }}
      onDragEnd={(_e, info) => {
        if (!scope.current) return;

        const { height: withPaddingHeight } =
          scope.current.getBoundingClientRect();
        const height = withPaddingHeight - 80;

        if (info.offset.y < 0) return;
        const _per = info.offset.y / height;
        const velPer = height / 200;
        const perWithVelocity =
          ((info.offset.y + info.velocity.y) / height) * velPer;

        if (perWithVelocity > 0.4) {
          delete scope.current.dataset.dragging;
          requestAnimationFrame(() => {
            props.onClose?.();
          });
        }
      }}
      {...props}
    >
      <Handlebar
        controller={controller}
        className="absolute top-0 left-0 right-0"
      />
      {children}
    </motion.div>
  );
}

export const Modal = {
  Root: _Root,
  Content: _Content,
  Overlay: _Overlay,
  CloseButton: _CloseButton,
  BottomSheetContent: _BottomSheetContent,
  focusAttrs: {
    "data-autofocus": true,
  },
  commonPopupClass,
};

export namespace Modal {
  export interface RootProps extends ModalRootProps {}
  export interface CloseButtonProps extends ModalCloseButtonProps {}
  export interface ContentProps extends ModalContentProps {
    hasCloseButton?: boolean;
    closePosition?: "left" | "right";
    hasBackdrop?: boolean;
    children?: React.ReactNode;
    contentClassName?: string;
    bodyClassName?: string;
    Title?: ReactNode;
  }
  export interface CommonOverlayProps {
    isClickClose?: boolean;
  }
  export interface OverlayProps extends ModalOverlayProps, CommonOverlayProps {}

  export type ContentWrapperProps = ModalContentProps;

  export interface BottomSheetContentProps
    extends Omit<MotionProps, "children"> {
    children?: ReactNode;
    className?: string;
    style?: React.CSSProperties;
    onClose?: () => void;
    contentClassName?: string;
  }
}
