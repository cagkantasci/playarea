
import { createApp } from 'vue';
import './style.css';
import App from './App.vue';
import pinia from './stores';
import router from './router';
import i18n from './i18n';

const app = createApp(App);
app.use(pinia);
app.use(router);
app.use(i18n);
app.mount('#app');
