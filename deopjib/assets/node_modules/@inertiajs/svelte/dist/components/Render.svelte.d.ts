import { SvelteComponent } from "svelte";
import type { PageProps } from '@inertiajs/core';
import type { ComponentType } from 'svelte';
export type RenderProps = {
    component: ComponentType;
    props?: PageProps;
    children?: RenderProps[];
    key?: number | null;
};
export type RenderFunction = {
    (component: ComponentType, props?: PageProps, children?: RenderProps[], key?: number | null): RenderProps;
    (component: ComponentType, children?: RenderProps[], key?: number | null): RenderProps;
};
export declare const h: RenderFunction;
declare const __propDef: {
    props: {
        component: ComponentType;
        props?: PageProps;
        children?: RenderProps[];
        key?: number | null;
    };
    events: {
        [evt: string]: CustomEvent<any>;
    };
    slots: {};
    exports?: {} | undefined;
    bindings?: string | undefined;
};
type RenderProps_ = typeof __propDef.props;
export type RenderEvents = typeof __propDef.events;
export type RenderSlots = typeof __propDef.slots;
export default class Render extends SvelteComponent<RenderProps_, RenderEvents, RenderSlots> {
}
export {};
