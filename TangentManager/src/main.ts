//main.ts
import { createApp } from 'vue'
import { createRouter, createWebHistory } from 'vue-router';
import { createPinia } from 'pinia'
import './style.scss'
import App from './App.vue'
import VueKonva from 'vue-konva';
import PrimeVue from 'primevue/config';
import Ripple from 'primevue/ripple';
// import 'primevue/resources/themes/lara-dark-amber/theme.css'
import 'primevue/resources/primevue.min.css';           // core css
import 'primeicons/primeicons.css';
import ConfirmationService from 'primevue/confirmationservice';
import ToastService from 'primevue/toastservice';

createApp(App)
    .use(createRouter({
        history: createWebHistory(),
        routes: [
            {
                path: '/',
                name: 'Home',
                component: () => import('./views/Home.vue'),
                meta:{
                    icon:'pi pi-home'
                }
                
            },
            {
                path: '/tree',
                name: 'Tree Editor',
                component: () => import('./views/TreeEditor.vue'),
                meta:{
                    icon:'pi pi-share-alt'
                }
            },
            {
                path: '/curve',
                name: 'Curve Editor',
                component: () => import('./views/CurveEditor.vue'),
                meta:{
                    icon:'pi pi-sliders-v'
                }
            },
            
            {
                path: '/test',
                name: 'Tests',
                component: () => import('./views/Test.vue'),
                meta:{
                    icon:'pi pi-prime'
                }
            },
        ]
    }))
    .use(createPinia())
    .use(VueKonva)
    .use(ConfirmationService)
    .use(ToastService)
    .use(PrimeVue, { ripple: true })
    .directive('ripple', Ripple)
    .mount('#app')
