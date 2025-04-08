import type { Hook, ViewHookInterface } from "phoenix_live_view";
import type { HookWithAbortController } from "../../../../assets/js/types/liveview";
import { get, identity } from "es-toolkit/compat";

function updateCounter(this: ViewHookInterface, e: Event) {
  const input = e.target;
  if (input instanceof HTMLInputElement) {
    const length = input.value.length;
    this.el.innerText = `${length}`;
  }
}
export const InputBoxLengthHook = {
  _abortController: new AbortController(),
  input: null as HTMLInputElement | null,
  mounted() {
    const input_target = this.el.getAttribute("phx-value-target");
    const filterKind = this.el.dataset["filterKind"];

    const k = filterKind ? get(window.__globalFunctions, filterKind) : identity;

    if (!input_target) return;

    const inputEl = document.querySelector(input_target);

    if (!(inputEl instanceof HTMLInputElement)) return;

    this.input = inputEl;

    const length = this.input.value.length;
    this.el.innerText = `${length}`;

    this.input?.addEventListener("input", updateCounter.bind(this), {
      signal: this._abortController.signal,
    });
    this.input?.addEventListener("change", updateCounter.bind(this), {
      signal: this._abortController.signal,
    });
    this.input?.addEventListener("reset", updateCounter.bind(this), {
      signal: this._abortController.signal,
    });
  },
  destroyed() {
    if (!this.input) return;
    this._abortController.abort();
  },
} satisfies HookWithAbortController<{ input: HTMLInputElement | null }>;
