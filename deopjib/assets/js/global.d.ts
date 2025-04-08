import type { GlobalFunctions } from "./common/globalFunctions";
import type { LiveSocket, Defaults } from "phoenix_live_view";

declare global {
  interface Window {
    liveSocket: LiveSocket;
    liveReloader: Live;
    __globalFunctions: GlobalFunctions;
  }

  interface WindowEventMap {
    "phx:page-loading-start": CustomEvent<{}>;
    "phx:page-loading-stop": CustomEvent<{}>;
    "phx:live_reload:attached": CustomEvent<any>;
  }
}
