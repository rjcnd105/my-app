import { type DragControls, motion } from "motion/react";
import { cn } from "@shared/utils/styles";

export function Handlebar({ className, controller }: Handlebar.Props) {
  return (
    <motion.div
      onPointerDown={(e) => {
        controller.start(e);
        e.stopPropagation();
      }}
      className={cn(
        "touch-none select-none flex cursor-grab justify-center w-full pt-2.5 pb-4 px-4",
        className,
      )}
    >
      <div className="size-full max-w-6 h-0.5 rounded-[2px] overflow-hidden bg-gray300" />
    </motion.div>
  );
}

export namespace Handlebar {
  export interface Props {
    className?: string;
    controller: DragControls;
  }
}
