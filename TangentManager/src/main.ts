import { createApp } from 'vue'
import { createRouter, createWebHistory } from 'vue-router';
import { createPinia } from 'pinia'
import { library } from '@fortawesome/fontawesome-svg-core'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import { faFloppyDisk } from '@fortawesome/free-solid-svg-icons'
import './style.css'
import App from './App.vue'
import VueKonva from 'vue-konva';

library.add(faFloppyDisk)

createApp(App)
    .use(createRouter({
        history:createWebHistory(),
        routes:[
            {path:'/', name:'Home',component: ()=>import('./views/Home.vue')},
            {path:'/tree', name:'Tree Editor',component: ()=>import('./views/TreeEditor.vue')},
        ]
    }))
    .use(createPinia())
    .use(VueKonva)
    .component("fa-icon",FontAwesomeIcon)
    .mount('#app')
