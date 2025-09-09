import { AnimatePresence } from "motion/react";
import { cn } from "@shared/utils/styles";
import { Modal } from "./Modal";

export function BottomModal({
  children,
  className,
  onClose,
  isClickClose = true,
  ...rest
}: BottomModal.Props) {
  return (
    <Modal.Root
      transitionProps={{
        duration: 250,
        exitDuration: 300,
      }}
      onClose={onClose}
      {...rest}
    >
      <Modal.Overlay
        className={cn(isClickClose ? "" : "pointer-events-none")}
      />

      <AnimatePresence>
        {rest.opened && (
          <Modal.BottomSheetContent
            onClose={onClose}
            contentClassName={cn(
              Modal.commonPopupClass,
              "!ease-cubic-out ",
              "z-30 max-w-[480px] w-full max-h-[calc(100dvh-8rem)] p-5 rounded-t-lg bottom-0 left-1/2 -translate-x-1/2",
              className,
            )}
          >
            {children}
          </Modal.BottomSheetContent>
        )}
      </AnimatePresence>
    </Modal.Root>
  );
}

export namespace BottomModal {
  export interface Props extends Modal.RootProps, Modal.CommonOverlayProps {
    className?: string;
    hasCloseButton?: boolean;
  }
}
