import { createRootRoute, createRootRouteWithContext, createRouter, RouterProvider } from '@tanstack/react-router'
import ReactDOM from 'react-dom/client'
import { routeTree } from './routeTree.gen'
import { queryClient } from './queryClient'
import { QueryClientProvider } from '@tanstack/react-query'
const rootElement = document.getElementById('app')!


const appRouter = createRouter({
  routeTree,
  context: { queryClient },
  defaultPreload: "intent",

  scrollRestoration: true,
  // defaultErrorComponent: DefaultCatchBoundary,
  // defaultNotFoundComponent: () => <NotFound />,
})

declare module "@tanstack/react-router" {
  interface Register {
    router: typeof appRouter;
  }
}



if (!rootElement.innerHTML) {
  const root = ReactDOM.createRoot(rootElement)
  root.render(
    <QueryClientProvider client={queryClient}>
      <RouterProvider router={appRouter} />
    </QueryClientProvider>
  )
}
