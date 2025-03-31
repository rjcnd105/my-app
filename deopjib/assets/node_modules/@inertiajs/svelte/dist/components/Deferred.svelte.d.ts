import { SvelteComponent } from "svelte";
declare const __propDef: {
    props: {
        data: string | string[];
    };
    events: {
        [evt: string]: CustomEvent<any>;
    };
    slots: {
        default: {};
        fallback: {};
    };
    exports?: {} | undefined;
    bindings?: string | undefined;
};
export type DeferredProps = typeof __propDef.props;
export type DeferredEvents = typeof __propDef.events;
export type DeferredSlots = typeof __propDef.slots;
export default class Deferred extends SvelteComponent<DeferredProps, DeferredEvents, DeferredSlots> {
}
export {};
