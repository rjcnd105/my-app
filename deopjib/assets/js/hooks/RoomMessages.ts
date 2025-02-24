import type { Hook } from "phoenix_live_view";
import type ViewHook from "phoenix_live_view/view_hook";

export const RoomMessages: Hook = {
  mounted() {
    const goScrollBottom = () => {
      this.el.scrollTop = this.el.scrollHeight;
    };

    this.handleEvent("scroll_messages_to_bottom", goScrollBottom);
    goScrollBottom();
  },
};
