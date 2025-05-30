import { ModalTitle } from "@mantine/core";
import { Modal } from "./Modal";
import { cn } from "~/utils/styles";
import { AnimatePresence } from "motion/react";

export function BottomModal({
  children,
  className,
  onClose,
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
      <Modal.Overlay />

      <AnimatePresence>
        {rest.opened && <Modal.BottomSheetContent
          onClose={onClose}
          contentClassName={cn(
            Modal.commonPopupClass,
            "!ease-cubic-out ",
            "z-30 max-w-[480px] w-full max-h-[calc(100dvh-8rem)] p-5 rounded-t-lg bottom-0 left-1/2 -translate-x-1/2",
            className,
          )}
        >
          {children}
        </Modal.BottomSheetContent>}
      </AnimatePresence>
    </Modal.Root >
  );
}

export namespace BottomModal {
  export interface Props extends Modal.RootProps {
    className?: string;
    hasCloseButton?: boolean;
  }
}
