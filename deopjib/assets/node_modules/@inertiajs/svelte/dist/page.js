import {} from '@inertiajs/core';
import { writable } from 'svelte/store';
const { set, subscribe } = writable();
export const setPage = set;
export default { subscribe };
