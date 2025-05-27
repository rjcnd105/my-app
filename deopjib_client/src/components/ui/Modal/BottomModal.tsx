import { Modal } from "./Modal";
import { cn } from "~/utils/styles";

export function BottomModal({
  children,
  className,
  title,
  hasCloseButton,
  duration = "250_200",
  ...rest
}: BottomModal.Props) {
  return (

    <Modal {...rest}>
      <Modal.Popup
        className={cn(
          Modal.commonPopupClass,
          Modal.style({ duration }),
          "ease-cubic-out data-[starting-style]:translate-y-full data-[ending-style]:translate-y-full",
          "z-30 max-w-[480px] w-full max-h-[calc(100dvh-8rem)] p-5 rounded-t-lg bottom-0 left-1/2 -translate-x-1/2",
          className,
        )}
      >
        {hasCloseButton && (
          <div className="mb-2">
            <Modal.CrossClose />
          </div>
        )}
        {title && (
          <Modal.Title className="text-center text-subtitle font-bold mb-2">
            {title}
          </Modal.Title>
        )}
        {children}
      </Modal.Popup>
    </Modal>
  );
}

export namespace BottomModal {
  export interface Props extends Modal.Props, Modal.Style {
    title?: string;
    className?: string;
    hasCloseButton?: boolean;
  }
}
