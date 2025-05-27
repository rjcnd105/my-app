import {
  useEffect,
  useRef,
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
import { Modal as MantineModal } from "@mantine/core";
import type { ModalProps, ModalRootProps } from "@mantine/core";
import { useDisclosure } from "@mantine/hooks";
import type { Button } from "../Button/Button";
import type { ContextModalProps } from "@mantine/modals";

function ModalRoot({
  id,
  children,
  hasBackdrop = true,
  hasCloseButton = true,
  ContentWrapper = MantineModal.Content,
  contentClassName = "pt-4 pb-5 px-5",
  title,
  context,
}: Modal.Props) {

  return (
    <MantineModal.Root opened={true} onClose={() => context.closeContextModal(id)}>
      {hasBackdrop && <MantineModal.Overlay />}
      <ContentWrapper>
        {hasCloseButton && title && <MantineModal.Header className={cn("flex relative h-[28px] mb-2", title ? "justify-end" : "justify-between")}>
          {title && <MantineModal.Title>{title}</MantineModal.Title>}
          {hasCloseButton && <MantineModal.CloseButton className="size-[28px] flex justify-center items-center" onClick={() => context.closeContextModal(id)}>
            <Modal.CrossCloseIcon />
          </MantineModal.CloseButton>}
        </MantineModal.Header>}

        <MantineModal.Body>
          {children}
        </MantineModal.Body>

      </ContentWrapper>



    </MantineModal.Root >
  );
}

export namespace Modal {
  export const Root = ModalRoot;
  export interface Props extends ContextModalProps {
    hasCloseButton?: boolean;
    closePosition: "left" | "right";
    hasBackdrop?: boolean;
    children?: React.ReactNode;
    ContentWrapper?: typeof MantineModal.Content
    contentClassName?: string
    bodyClassName?: string
    title?: string
  }

  export const focusAttrs = {
    "data-autofocus": true,
  }

  const MotionPopup = motion.create(MantineModal.Content);
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
        scope.current.style.transitionDuration = `${50 + scope.current.getBoundingClientRect().height / 1.5}ms`;
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
        <Handlebar
          controller={controller}
          className="absolute top-0 left-0 right-0"
        />
        {children}
      </MotionPopup>
    );
  }

  export function CrossCloseIcon({ className, ...props }: Button.Props) {

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

