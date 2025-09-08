import { ModalTitle } from "@mantine/core";
import { cn } from "@/shared/utils/styles";
import { Modal } from "./Modal";

export function ConfirmModal({ children, title, ...rest }: ConfirmModal.Props) {
  return (
    <Modal.Root
      transitionProps={{
        duration: 275,
        exitDuration: 300,
      }}
      {...rest}
    >
      <Modal.Overlay />
      <Modal.Content
        contentClassName={cn(
          Modal.commonPopupClass,
          "!ease-spring-2 opacity-0 translate-y-[calc(-50%+12px)] scale-90 data-showing:opacity-100 data-showing:-translate-y-1/2 data-showing:scale-100",
          "z-30 max-h-[calc(100dvh-2rem)] p-6 rounded-lg position-center",
        )}
        Title={<ModalTitle>{title}</ModalTitle>}
      >
        {children}
      </Modal.Content>
    </Modal.Root>
  );
}

export namespace ConfirmModal {
  export interface Props extends Modal.RootProps {
    title?: string;
  }
}
