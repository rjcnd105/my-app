import type { LiveSocket, Defaults } from "phoenix_live_view";

declare global {
  interface Window {
    liveSocket: LiveSocket;
    liveReloader: Live;
  }

  interface WindowEventMap {
    "phx:page-loading-start": CustomEvent<{}>;
    "phx:page-loading-stop": CustomEvent<{}>;
    "phx:live_reload:attached": CustomEvent<any>;
  }
}
