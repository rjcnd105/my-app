import { createFileRoute } from "@tanstack/react-router";
import { Button } from "~/components/ui/Button/Button";
import { Checkbox } from "~/components/ui/Checkbox/Checkbox";
import { Icon } from "~/components/ui/Icon/Icon";
import { iconNames } from "~/icons/types.gen";

export const Route = createFileRoute("/dev__components")({
  component: RouteComponent,
});

function RouteComponent() {
  return (
    <div className="[&_h3]:text-title">
      <h3>Buttons</h3>
      <Button theme="primary">Primary</Button>
      <h3>Icons</h3>
      <div className="flex flex-wrap gap-4">
        {iconNames.map((name) => (
          <span className="flex items-center" key={name}>
            <Icon name={name} />
            &nbsp;
            {name}
          </span>
        ))}
      </div>
      <h3>Checkbox</h3>
      <Checkbox></Checkbox>
    </div>
  );
}
