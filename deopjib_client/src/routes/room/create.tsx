import { createFileRoute } from "@tanstack/react-router";
import { Button } from "~/ui/Button/Button";

export const Route = createFileRoute("/room/create")({
  component: RouteComponent,
});

function RouteComponent() {
  return (
    <div>
      <Button theme="primary">hihi</Button>
      Hello "/room/create"!
    </div>
  );
}
