import { HeadlessMantineProvider } from "@mantine/core";


import type { QueryClient } from "@tanstack/react-query";
import { ReactQueryDevtools } from "@tanstack/react-query-devtools";
import {
  createRootRouteWithContext,
  HeadContent,
  Link,
  Outlet,
  Scripts,
} from "@tanstack/react-router";
import { TanStackRouterDevtools } from "@tanstack/react-router-devtools";
import { DefaultCatchBoundary } from "@/shared/ui/DefaultCatchBoundary";
import { NotFound } from "@/shared/ui/NotFound";
import { seo } from "@/shared/utils/seo";
import "../styles/app.css";
const RootLayout = () => (
  <>
    <div id="modals-root" />

    <Outlet />
    <TanStackRouterDevtools position="bottom-right" />
    <ReactQueryDevtools buttonPosition="bottom-left" />
    <Scripts />

  </>
)

function RootDocument({ children }: { children: React.ReactNode }) {
  return (
    <html lang="ko">
      <head>
        <link href="/src/styles/app.css" rel="stylesheet" />
        <HeadContent />
      </head>
      <body>
        <div className="p-2 flex gap-2 text-lg">
          <Link
            to="/"
            activeProps={{
              className: "font-bold",
            }}
            activeOptions={{ exact: true }}
          >
            Home
          </Link>{" "}
          <Link
            to="/$roomId/add_items"
            activeProps={{
              className: "font-bold",
            }}
            params={{
              roomId: "10",
            }}
          >
            room10
          </Link>{" "}
          <Link
            to="/route-a"
            activeProps={{
              className: "font-bold",
            }}
          >
            Pathless Layout
          </Link>{" "}
          {/* <Link
            to="/deferred"
            activeProps={{
              className: "font-bold",
            }}
          >
            Deferred
          </Link>{" "} */}
          <Link
            // @ts-expect-error
            to="/this-route-does-not-exist"
            activeProps={{
              className: "font-bold",
            }}
          >
            This Route Does Not Exist
          </Link>
        </div>
        <hr />

      </body>
    </html>
  );
}
