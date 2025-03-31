import { SvelteComponent } from "svelte";
import { type ReloadOptions } from '@inertiajs/core';
declare const __propDef: {
    props: {
        data?: string | string[];
        params?: ReloadOptions;
        buffer?: number;
        as?: keyof HTMLElementTagNameMap;
        always?: boolean;
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
export type WhenVisibleProps = typeof __propDef.props;
export type WhenVisibleEvents = typeof __propDef.events;
export type WhenVisibleSlots = typeof __propDef.slots;
export default class WhenVisible extends SvelteComponent<WhenVisibleProps, WhenVisibleEvents, WhenVisibleSlots> {
}
export {};
