import {
  useEffect,
  useRef,
  type ComponentProps,
  type ComponentType,
  type PropsWithChildren,
  type ReactNode,
} from "react";
import type { OnlySpecificRequired } from "~/utils/types";
import { Icon } from "../Icon/Icon";
import { cn, tva } from "~/utils/styles";
import { variant } from "valibot";
import type { VariantProps } from "class-variance-authority";
import {
  AnimatePresence,
  DragControls,
  motion,
  MotionConfig,
  useAnimate,
  useDragControls,
  type MotionProps,
} from "motion/react";
import { Handlebar } from "../Handlebar/Handlebar";
import { Modal as MantineModal, ModalBaseCloseButton, ModalBody, ModalContent, ModalHeader, ModalOverlay } from "@mantine/core";
import type { ModalProps, ModalRootProps, ModalContentProps, ModalOverlayProps, OverlayProps } from "@mantine/core";
import { useDisclosure } from "@mantine/hooks";
import type { Button } from "../Button/Button";
import type { ContextModalProps as _ContextModalProps } from "@mantine/modals";
import { ModalRoot } from "@mantine/core";




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


function _Content({
  children,
  hasBackdrop = true,
  hasCloseButton = true,
  ContentWrapper = ModalContent,
  contentClassName,
  closePosition = "right",
  Title,
}: Modal.ContentProps) {
  return <>

    <ContentWrapper classNames={{
      content: contentClassName
    }}
    >
      {hasCloseButton && Title && <ModalHeader className={cn("flex relative h-[28px] mb-2", Title ? "justify-end" : "justify-between")}>
        {closePosition === "left" && hasCloseButton && <ModalBaseCloseButton icon={<CrossCloseIcon />} className="size-[28px] flex justify-center items-center" />}
        {Title}
        {closePosition === "right" && hasCloseButton && <ModalBaseCloseButton icon={<CrossCloseIcon />} className="size-[28px] flex justify-center items-center" />}
      </ModalHeader>}

      <ModalBody>
        {children}
      </ModalBody>

    </ContentWrapper>
  </>
}

function _Overlay({ className, ...props }: Modal.OverlayProps) {
  return <ModalOverlay className={cn("fixed inset-0 bg-dimm backdrop-blur-dimm !ease-cubic-out", className)}
    {...props}
    transitionProps={{
      duration: 150,
      ...props.transitionProps,
    }} />
}


function _Root({ children, transitionProps, ...props }: Modal.RootProps) {
  const ref = useRef<HTMLDivElement>(null);

  return (
    <ModalRoot ref={ref} transitionProps={{
      transition: {
        in: {},
        out: {},
        common: {},
        transitionProperty: undefined,
      },
      timingFunction: undefined,
      ...transitionProps,
      onEnter() {
        const content = ref?.current?.querySelector("[data-modal-content=true]")
        if (content instanceof HTMLElement && content.dataset.enter !== "true") {
          content.dataset.showing = "true";
          delete content.dataset.exited;
          transitionProps?.onEnter?.()
        }
      },
      onEntered() {
        const content = ref?.current?.querySelector("[data-modal-content=true]")
        if (content instanceof HTMLElement && content.dataset.entered !== "true") {
          content.dataset.entered = "true";
          transitionProps?.onEntered?.()
        }
      },
      onExit() {
        const content = ref?.current?.querySelector("[data-modal-content=true]")
        if (content instanceof HTMLElement && content.dataset.exit !== "true") {

          content.dataset.exit = "true";
          delete content.dataset.entered;
          delete content.dataset.showing;
          transitionProps?.onExit?.()
        }
      },
      onExited() {
        const content = ref?.current?.querySelector("[data-modal-content=true]")
        if (content instanceof HTMLElement && content.dataset.exited !== "true") {

          delete content.dataset.exit;
          content.dataset.exited = "true";
          transitionProps?.onExited?.()
        }
      }
    }}
      style={{}}
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
  const [scope, animate] = useAnimate<HTMLDivElement>();

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
        ...style
      }}

      initial={{
        y: "100%"
      }}
      animate={{
        y: "0%",
        transition: {
          type: "spring",
          duration: 0.3,
          bounce: 0.2
        }
      }}
      exit={{
        y: "100%",
        transition: {
          duration: 0.15,
          ease: "easeOut",
        }
      }}
      dragControls={controller}
      dragSnapToOrigin
      dragMomentum={false}
      dragListener={false}
      dragConstraints={{ top: 0 }}
      dragTransition={{ bounceStiffness: 500, bounceDamping: 24 }}
      dragElastic={0.1}
      onDragStart={(e: PointerEvent) => {

        if (scope.current) {
          scope.current.dataset.dragging = "true";
        }
      }}
      onDragTransitionEnd={() => {
        if (!scope.current) return;
        delete scope.current?.dataset.dragging;
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


export namespace Modal {
  export interface RootProps extends ModalRootProps { }
  export interface ContentProps {
    hasCloseButton?: boolean;
    closePosition?: "left" | "right";
    hasBackdrop?: boolean;
    children?: React.ReactNode;
    ContentWrapper?: ComponentType<ModalContentProps>
    contentClassName?: string
    bodyClassName?: string
    Title?: ReactNode
  }
  export interface OverlayProps extends ModalOverlayProps { }


  export type ContentWrapperProps = ModalContentProps;

  export const Root = _Root
  export const Content = _Content
  export const Overlay = _Overlay
  export const BottomSheetContent = _BottomSheetContent;

  export const focusAttrs = {
    "data-autofocus": true,
  }

  export interface BottomSheetContentProps extends Omit<MotionProps, "children"> {
    children?: ReactNode;
    className?: string;
    style?: React.CSSProperties;
    onClose?: () => void;
    contentClassName?: string
  }



  export const commonPopupClass =
    "fixed outline-transparent focus-visible:outline-blue300 bg-white shadow-1";

}

