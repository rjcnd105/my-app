// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";


import topbar from "./vendor/topbar";
import { RoomMessages } from "./hooks/RoomMessages";
import { ChatMessageTextarea } from "./hooks/ChatMessageTextarea";
import "./events";
import hooks from "./hooks";


let csrfToken = (
  document.querySelector("meta[name='csrf-token']") as HTMLElement
).getAttribute("content");

let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,

  hooks,
  params: {
    _csrf_token: csrfToken,
    timezone: Intl.DateTimeFormat().resolvedOptions().timeZone,
  },
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

window.addEventListener("phx:live_reload:attached", ({ detail: reloader }) => {
  // Enable server log streaming to client. Disable with reloader.disableServerLogs()
  reloader.enableServerLogs();

  // Open configured PLUG_EDITOR at file:line of the clicked element's HEEx component
  //
  //   * click with "c" key pressed to open at caller location
  //   * click with "d" key pressed to open at function component definition location
  let keyDown: string | null = null;
  window.addEventListener("keydown", (e) => (keyDown = e.key));
  window.addEventListener("keyup", (e) => (keyDown = null));
  window.addEventListener(
    "click",
    (e) => {
      if (keyDown === "e") {
        e.preventDefault();
        e.stopImmediatePropagation();
        reloader.openEditorAtCaller(e.target);
      } else if (keyDown === "d") {
        e.preventDefault();
        e.stopImmediatePropagation();
        reloader.openEditorAtDef(e.target);
      }
    },
    true,
  );
  window.liveReloader = reloader;
});


// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
