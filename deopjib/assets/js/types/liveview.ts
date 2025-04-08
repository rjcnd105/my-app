import type { Hook } from "phoenix_live_view";

type WithAbort = {
  _abortController: AbortController;
};

export type HookWithAbortController<T extends {} = {}> = Hook<T & WithAbort> &
  WithAbort &
  T;
