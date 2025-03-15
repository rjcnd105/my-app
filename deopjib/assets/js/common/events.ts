console.log("common-event");
import { get } from "es-toolkit/compat";
import { map } from "nanostores";

type AddEvent = {
  detail: {
    event_name: string;
  };
};

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

window.addEventListener("addEvent:enter-submit", (e) => {
  const eventName = get(e, ["detail", "event_name"]);
  if (!eventName) return;

  e.target?.addEventListener(eventName, enterSubmit);
});
