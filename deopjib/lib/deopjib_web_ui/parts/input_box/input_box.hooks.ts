import type { Hook, ViewHookInterface } from "phoenix_live_view";

function updateCounter(this: ViewHookInterface, e: Event) {
  const input = e.target;
  if (input instanceof HTMLInputElement) {
    const length = input.value.length;
    this.el.innerText = `${length}`;
  }
}
export const InputBoxLengthHook: Hook = {
  mounted() {
    const input = this.el
      .closest(`[data-ui="input_box"]`)
      ?.querySelector("input");

    if (!input) return;

    const length = input.value.length;
    this.el.innerText = `${length}`;

    input?.addEventListener("input", updateCounter.bind(this));
  },
  destroyed() {
    const input = this.el
      .closest("[data-ui=input_box]")
      ?.querySelector("input");

    if (!input) return;

    input.removeEventListener("input", updateCounter);
  },
};
