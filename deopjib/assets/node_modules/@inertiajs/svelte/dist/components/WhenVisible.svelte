<script>import { router } from "@inertiajs/core";
import { onDestroy, onMount } from "svelte";
export let data = "";
export let params = {};
export let buffer = 0;
export let as = "div";
export let always = false;
let loaded = false;
let fetching = false;
let el;
let observer = null;
onMount(() => {
  if (!el) {
    return;
  }
  observer = new IntersectionObserver(
    (entries) => {
      if (!entries[0].isIntersecting) {
        return;
      }
      if (!always) {
        observer?.disconnect();
      }
      if (fetching) {
        return;
      }
      fetching = true;
      const reloadParams = getReloadParams();
      router.reload({
        ...reloadParams,
        onStart: (event) => {
          fetching = true;
          reloadParams.onStart?.(event);
        },
        onFinish: (event) => {
          loaded = true;
          fetching = false;
          reloadParams.onFinish?.(event);
        }
      });
    },
    {
      rootMargin: `${buffer}px`
    }
  );
  observer.observe(el);
});
onDestroy(() => {
  observer?.disconnect();
});
function getReloadParams() {
  if (data !== "") {
    return {
      only: Array.isArray(data) ? data : [data]
    };
  }
  if (!params.data) {
    throw new Error("You must provide either a `data` or `params` prop.");
  }
  return params;
}
</script>

{#if always || !loaded}
  <svelte:element this={as} bind:this={el} />
{/if}

{#if loaded}
  <slot />
{:else if $$slots.fallback}
  <slot name="fallback" />
{/if}
