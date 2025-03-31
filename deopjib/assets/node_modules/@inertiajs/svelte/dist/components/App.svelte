<script context="module">import {} from "@inertiajs/core";
</script>

<script>import { router } from "@inertiajs/core";
import Render, { h } from "./Render.svelte";
import { setPage } from "../page";
export let initialComponent;
export let initialPage;
export let resolveComponent;
let component = initialComponent;
let key = null;
let page = initialPage;
let renderProps = resolveRenderProps(component, page, key);
setPage(page);
const isServer = typeof window === "undefined";
if (!isServer) {
  router.init({
    initialPage,
    resolveComponent,
    swapComponent: async (args) => {
      component = args.component;
      page = args.page;
      key = args.preserveState ? key : Date.now();
      renderProps = resolveRenderProps(component, page, key);
      setPage(page);
    }
  });
}
function resolveRenderProps(component2, page2, key2 = null) {
  const child = h(component2.default, page2.props, [], key2);
  const layout = component2.layout;
  return layout ? resolveLayout(layout, child, page2.props, key2) : child;
}
function resolveLayout(layout, child, pageProps, key2) {
  if (isLayoutFunction(layout)) {
    return layout(h, child);
  }
  if (Array.isArray(layout)) {
    return layout.slice().reverse().reduce((currentRender, layoutComponent) => h(layoutComponent, pageProps, [currentRender], key2), child);
  }
  return h(layout, pageProps, child ? [child] : [], key2);
}
function isLayoutFunction(layout) {
  return typeof layout === "function" && layout.length === 2 && typeof layout.prototype === "undefined";
}
</script>

<Render {...renderProps} />
