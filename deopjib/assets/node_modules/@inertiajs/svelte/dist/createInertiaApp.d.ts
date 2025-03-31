import { type InertiaAppResponse, type Page } from '@inertiajs/core';
import type { ComponentType } from 'svelte';
import App, { type InertiaAppProps } from './components/App.svelte';
import type { ComponentResolver } from './types';
type SvelteRenderResult = {
    html: string;
    head: string;
    css?: {
        code: string;
    };
};
type AppComponent = ComponentType<App> & {
    render: (props: InertiaAppProps) => SvelteRenderResult;
};
interface CreateInertiaAppProps {
    id?: string;
    resolve: ComponentResolver;
    setup: (props: {
        el: HTMLElement | null;
        App: AppComponent;
        props: InertiaAppProps;
    }) => void | App | SvelteRenderResult;
    progress?: false | {
        delay?: number;
        color?: string;
        includeCSS?: boolean;
        showSpinner?: boolean;
    };
    page?: Page;
}
export default function createInertiaApp({ id, resolve, setup, progress, page, }: CreateInertiaAppProps): InertiaAppResponse;
export {};
