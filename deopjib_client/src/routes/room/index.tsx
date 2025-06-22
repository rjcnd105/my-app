import { createRootRoute, Outlet, createFileRoute } from "@tanstack/react-router"

export const Route = createRootRoute("/room/")({
  component: RouteComponent,
});

function RouteComponent() {
  return (
    <div className="bg-gray200">
      <Outlet />
    </div>
  );
}
