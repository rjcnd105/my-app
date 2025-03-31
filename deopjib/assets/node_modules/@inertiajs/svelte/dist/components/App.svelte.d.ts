import { SvelteComponent } from "svelte";
import type { ComponentResolver, ResolvedComponent } from '../types';
import { type Page } from '@inertiajs/core';
export interface InertiaAppProps {
    initialComponent: ResolvedComponent;
    initialPage: Page;
    resolveComponent: ComponentResolver;
}
declare const __propDef: {
    props: {
        initialComponent: InertiaAppProps["initialComponent"];
        initialPage: InertiaAppProps["initialPage"];
        resolveComponent: InertiaAppProps["resolveComponent"];
    };
    events: {
        [evt: string]: CustomEvent<any>;
    };
    slots: {};
    exports?: {} | undefined;
    bindings?: string | undefined;
};
export type AppProps = typeof __propDef.props;
export type AppEvents = typeof __propDef.events;
export type AppSlots = typeof __propDef.slots;
export default class App extends SvelteComponent<AppProps, AppEvents, AppSlots> {
}
export {};
