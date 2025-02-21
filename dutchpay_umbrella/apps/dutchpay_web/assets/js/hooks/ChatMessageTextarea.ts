import type { Hook } from "phoenix_live_view";

export const ChatMessageTextarea: Hook = {
  mounted() {
    this.el.addEventListener("keydown", (e) => {
      if (e.key === "Enter" && !e.shiftKey) {
        const form = this.el.closest("form");
        if (!form) throw Error("Form not found");

        // phx-debounce전에 변화를 감지할 수 있도록
        this.el.dispatchEvent(
          new Event("change", { bubbles: true, cancelable: true }),
        );
        form.dispatchEvent(
          new Event("submit", { bubbles: true, cancelable: true }),
        );
      }
    });
  },
};
