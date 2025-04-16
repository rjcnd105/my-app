import { createFileRoute } from "@tanstack/react-router";

export const Route = createFileRoute("/room/create")({
  component: RouteComponent,
});

function RouteComponent() {
  return <div>Hello "/room/create"!</div>;
}
