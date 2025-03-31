<script context="module">export const h = (component, propsOrChildren, childrenOrKey, key = null) => {
  const hasProps = typeof propsOrChildren === "object" && propsOrChildren !== null && !Array.isArray(propsOrChildren);
  return {
    component,
    key: hasProps ? key : typeof childrenOrKey === "number" ? childrenOrKey : null,
    props: hasProps ? propsOrChildren : {},
    children: hasProps ? Array.isArray(childrenOrKey) ? childrenOrKey : childrenOrKey !== null ? [childrenOrKey] : [] : Array.isArray(propsOrChildren) ? propsOrChildren : propsOrChildren !== null ? [propsOrChildren] : []
  };
};
</script>

<script>export let component;
export let props = {};
export let children = [];
export let key = null;
</script>

{#if component}
  <!--
  Add the `key` only to the last (page) component in the tree.
  This ensures that the page component re-renders when `preserveState` is disabled,
  while the layout components are persisted across page changes. -->
  {#key children?.length === 0 ? key : null}
    {#if children.length > 0}
      <svelte:component this={component} {...props}>
        {#each children as child}
          <svelte:self {...child} />
        {/each}
      </svelte:component>
    {:else}
      <svelte:component this={component} {...props} />
    {/if}
  {/key}
{/if}
