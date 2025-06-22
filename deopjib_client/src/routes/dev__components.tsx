import { useModalsStack } from "@mantine/core";
import { createFileRoute } from "@tanstack/react-router";
import { useState } from "react";
import { Button } from "@/components/ui/Button/Button";
import { Checkbox } from "@/components/ui/Checkbox/Checkbox";
import { Chip } from "@/components/ui/Chip/Chip";
import { Icon } from "@/components/ui/Icon/Icon";
import { TextInput } from "@/components/ui/Input/TextInput";
import { BottomModal } from "@/components/ui/Modal/BottomModal";
import { ConfirmModal } from "@/components/ui/Modal/ConfirmModal";
import { Modal } from "@/components/ui/Modal/Modal";
import { iconNames } from "@/icons/types.gen";
import { joinMap } from "@/utils/functions";
import { objKeys } from "@/utils/obj";
import { cn } from "@/utils/styles";

export const Route = createFileRoute("/dev__components")({
  component: RouteComponent,
});

function RouteComponent() {
  const stack = useModalsStack([
    "confirmModal",
    "customModal",
    "bottomSheetModal",
  ]);
  const [_bottomModalOpen, _setBottomModalOpen] = useState(false);
  const [text, setText] = useState("");
  return (
    <div className="[&_h3]:text-title [&_h3]:mt-2 [&_h3]:mb-1 px-4">
      <h3>Buttons</h3>
      <Wrapper className="bg-gray100">
        {joinMap(
          [objKeys(Button.themes), objKeys(Button.sizes)],
          (theme, size) => (
            <Button key={`${theme}-${size}`} theme={theme} size={size}>
              {theme}_{size}
            </Button>
          ),
        )}
      </Wrapper>
      <h3>Icons</h3>
      <Wrapper>
        {iconNames.map((name) => (
          <span className="flex items-center" key={name}>
            <Icon name={name} />
            &nbsp;
            {name}
          </span>
        ))}
      </Wrapper>
      <h3>Checkbox</h3>
      <Checkbox />

      <h3>Chip</h3>
      <Wrapper className="bg-lightgray200 p-2">
        <Chip>깨비</Chip>
        <Chip theme="gray">깨비</Chip>
        <Chip theme="primary">깨비</Chip>
        <Chip theme="secondary">깨비</Chip>
      </Wrapper>

      <h3>modal</h3>
      <Wrapper>
        <Button onClick={() => stack.open("confirmModal")}>confirmModal</Button>
        <Button onClick={() => stack.open("bottomSheetModal")}>
          bottomSheetModal
        </Button>
        <Button onClick={() => stack.open("customModal")}>customModal</Button>

        <ConfirmModal {...stack.register("confirmModal")} title="title" />
        <BottomModal
          {...stack.register("bottomSheetModal")}
          isClickClose={false}
          hasCloseButton={true}
        >
          <div className="w-full h-[300px]">
            <Button onClick={() => stack.open("confirmModal")}>
              confirmModal
            </Button>
            <br />
            <Button onClick={() => stack.open("customModal")}>
              customModal
            </Button>
          </div>
        </BottomModal>
        <Modal.Root {...stack.register("customModal")} lockScroll={false}>
          {/* <Modal.Overlay /> */}
          <Modal.Content contentClassName="fixed top-0 left-1/2 -translate-x-1/2 max-w-[480px] w-full bg-white -translate-y-full data-showing:translate-y-0">
            <div className="flex justify-between p-2">
              hihi
              <Modal.CloseButton />
            </div>
          </Modal.Content>
        </Modal.Root>

        {/* <Modal TriggerSlot={<Modal.Trigger>custom modal</Modal.Trigger>}>
          <Modal.Popup className="fixed outline-transparent shadow-1 focus-visible:outline-blue300 outline-1 w-full top-0 bg-white">
            hihi
          </Modal.Popup>
        </Modal>
        <ConfirmModal
          title="title"
          TriggerSlot={<Modal.Trigger>confirm modal</Modal.Trigger>}
        >
          i'm confirm modal
        </ConfirmModal>
        <BottomModal
          hasCloseButton={true}
          TriggerSlot={<Modal.Trigger>bottom modal</Modal.Trigger>}
        >
          <div className="w-full h-[300px]">hihi</div>
        </BottomModal>
        <Modal
          TriggerSlot={<Modal.Trigger>bottom sheet</Modal.Trigger>}
          onOpenChange={(open, event, reason) => {
            console.log("!!open", open);
            console.log("!!event", event);
            console.log("!!reason", reason);
            // setIsOpen(open);
          }}
        >
          <Modal.BottomSheetPopup className="w-full">
            <div className="h-80 pt-8 w-full">bottom sheet</div>
          </Modal.BottomSheetPopup>
        </Modal> */}
      </Wrapper>

      <h3>input</h3>
      <Wrapper>
        <TextInput
          label="Input label"
          description="Input description"
          error="fuck"
          placeholder="Input placeholder"
          value={text}
          onChange={(e) => setText(e.target.value)}
          required
          rightSection={
            <Button theme="dark" size="md" disabled={text.length === 0}>
              hihi
            </Button>
          }
        />
      </Wrapper>
    </div>
  );
}

function Wrapper({
  children,
  className,
}: {
  children?: React.ReactNode;
  className?: string;
}) {
  return (
    <div className={cn("flex flex-wrap gap-4 p-2", className)}>{children}</div>
  );
}
