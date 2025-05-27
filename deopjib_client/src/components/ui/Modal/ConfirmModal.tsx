import { Dialog } from "@base-ui-components/react/dialog";
import { Modal } from "./Modal";
import { cn } from "~/utils/styles";

export function ConfirmModal({
  children,
  duration = "200_150",
  title,
  ...rest
}: ConfirmModal.Props) {
  return (
    <Modal.Root {...rest}>
      <Modal.Popup
        className={cn(
          Modal.commonPopupClass,
          Modal.style({ duration }),
          "ease-spring-2 data-[starting-style]:translate-y-[calc(-50%+8px)] data-[starting-style]:scale-95 data-[starting-style]:opacity-0 data-[ending-style]:translate-y-[calc(-50%+8px)] data-[ending-style]:scale-95 data-[ending-style]:opacity-0",
          "z-30 max-h-[calc(100dvh-2rem)] p-6 rounded-lg position-center",
        )}
      >
        {title && (
          <Modal.Title className="text-center text-subtitle font-bold mb-2">
            {title}
          </Modal.Title>
        )}
        {children}
      </Modal.Popup>
    </Modal.Root>
  );
}

export namespace ConfirmModal {
  export interface Props extends Modal.Props, Modal.Style {
    title?: string;
  }
}
