// /stores/index.ts

import { createPinia } from 'pinia';

// Import individual stores
import { useNodeStore } from './modules/nodeStore';
export const nodeStore = useNodeStore();