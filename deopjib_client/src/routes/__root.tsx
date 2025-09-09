import { HeadlessMantineProvider } from "@mantine/core";


import type { QueryClient } from "@tanstack/react-query";
import { ReactQueryDevtools } from "@tanstack/react-query-devtools";
import {
  createRootRoute,
  createRootRouteWithContext,
  HeadContent,
  Link,
  Outlet,
  Scripts,
} from "@tanstack/react-router";
import { TanStackRouterDevtools } from "@tanstack/react-router-devtools";
import { DefaultCatchBoundary } from "@shared/ui/DefaultCatchBoundary";
import { NotFound } from "@shared/ui/NotFound";
import { seo } from "@shared/utils/seo";
import "../shared/styles/app.css";
import { View } from "@shared/ui/Templates/View";


const RootLinks = () => (
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
      // @ts-expect-error ts-expect-error
      to="/this-route-does-not-exist"
      activeProps={{
        className: "font-bold",
      }}
      viewTransition={{
        types: ['slide-left'],
      }}
    >
      This Route Does Not Exist
    </Link>
  </div>
)
const RootLayout = () => (
  <>
    <div id="modals-root" />

    <RootLinks />
    <Outlet />
    <TanStackRouterDevtools position="bottom-right" />
    <ReactQueryDevtools buttonPosition="bottom-left" />
    <Scripts />
  </>
)

export const Route = createRootRouteWithContext<{ queryClient: QueryClient }>()({
  component: RootLayout,
  notFoundComponent: () => {
    return (
      <View transitionName="main">
        <p>This is the notFoundComponent configured on root route</p>
        <Link
          to="/room/create"
          viewTransition={{
            types: ['slide-right'],
          }}>Start Over</Link>
      </View>
    )
  },
})

