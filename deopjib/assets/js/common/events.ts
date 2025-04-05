import { get, set } from "es-toolkit/compat";
import { map } from "nanostores";
import * as v from "valibot"; // 1.31 kB

window.addEventListener("phx:js-exec", ({ detail }: any) => {
  document.querySelectorAll(detail.to).forEach((el) => {
    window.liveSocket?.execJS(el, el.getAttribute(detail.attr));
  });
});

type EnterSubmitAddEvent = {
  detail: {
    event_name: string;
  };
};

const enterSubmitSchema = v.object({
  detail: v.object({
    event_name: v.picklist(["keyup", "keydown", "input"]),
  }),
});

function enterSubmit(e: Event) {
  if (e instanceof KeyboardEvent && e.target instanceof HTMLElement) {
    if (e.key === "Enter" && !e.shiftKey) {
      const form = e.target.closest("form");
      if (!form) throw Error("Form not found");

      // phx-debounce전에 변화를 감지할 수 있도록
      e.target.dispatchEvent(
        new Event("change", { bubbles: true, cancelable: true }),
      );
      form.dispatchEvent(
        new Event("submit", { bubbles: true, cancelable: true }),
      );
    }
  }
}

// JS.dispatch("addEvent:enterSubmit", detail: %{event_name: "keyup"})
window.addEventListener("addEvent:enterSubmit", (e) => {
  const { detail } = v.parse(enterSubmitSchema, e);

  e.target?.addEventListener(detail.event_name, enterSubmit);
});

const InputMaxLengthLimitSchema = v.object({
  detail: v.object({
    max_length: v.number(),
  }),
});

function inputMaxLengthLimit(e: Event) {
  const { detail } = e.target as typeof e.target &
    v.InferOutput<typeof InputMaxLengthLimitSchema>;
  if (e.target instanceof HTMLInputElement) {
    const currentLength = e.target.value.length;

    if (currentLength > detail.max_length) {
      e.target.value = e.target.value.slice(0, detail.max_length);
    }
  }
}

// JS.dispatch("addEvent:inputMaxLengthLimit", detail: %{max_length: 13})
window.addEventListener("addEvent:inputMaxLengthLimit", (e) => {
  const { detail } = v.parse(InputMaxLengthLimitSchema, e);

  if (e.target) {
    set(e.target, "detail", detail);

    e.target?.addEventListener("input", inputMaxLengthLimit);
  }
});
