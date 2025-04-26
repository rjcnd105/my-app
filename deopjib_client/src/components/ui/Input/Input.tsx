import { Input as BUI_Input } from "@base-ui-components/react/input";
import { cn } from "~/utils/styles";

function Input({ className, ...props }: InputTextBox.Props) {
  return <BUI_Input className={cn("", className)} {...props} />;
}

export namespace InputTextBox {
  export interface Props extends BUI_Input.Props {}
}
