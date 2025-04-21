import { createFileRoute } from "@tanstack/react-router";
import { Button } from "~/components/ui/Button/Button";
import { Checkbox } from "~/components/ui/Checkbox/Checkbox";
import { Chip } from "~/components/ui/Chip/Chip";
import { Icon } from "~/components/ui/Icon/Icon";
import { iconNames } from "~/icons/types.gen";

export const Route = createFileRoute("/dev__components")({
  component: RouteComponent,
});

function RouteComponent() {
  return (
    <div className="[&_h3]:text-title [&_h3]:mt-2 [&_h3]:mb-1 px-4">
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

      <h3>Chip</h3>
      <div className="flex gap-2 bg-lightgray200 p-2">
        <Chip>깨비</Chip>
        <Chip theme="gray">깨비</Chip>
        <Chip theme="primary">깨비</Chip>
        <Chip theme="secondary">깨비</Chip>
      </div>
    </div>
  );
}
