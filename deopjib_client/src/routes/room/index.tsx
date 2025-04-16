import {
  createFileRoute,
  createRootRoute,
  Link,
  Outlet,
} from "@tanstack/react-router";

export const Route = createRootRoute({
  component: RouteComponent,
});

function RouteComponent() {
  return (
    <div className="bg-gray200">
      <Outlet />
    </div>
  );
}
