import { createApp } from 'vue';
import './style.scss';
import 'primeicons/primeicons.css';
import App from './App.vue';
import router from './router/route.ts';
import { ScreenSizeUtil } from './size.ts';
import { createPinia } from 'pinia';
import { useAuthStore } from './stores/auth.store.ts';
import {useUsersStore} from './stores/users.store.ts';
import { primevuePlugin } from './primevue/primevue.ts';

(async () => {
    const app = createApp(App);

    app.use(router);

    const pinia = createPinia();
    app.use(pinia);

    app.use(primevuePlugin);

    const authStore = useAuthStore();
    await authStore.getAuthUserAndAppUser();

    const usersStore = useUsersStore();
    if (authStore.authUser) {
        await usersStore.loadUsers(authStore.authUser.id);
    }

    app.mount('#app');

    ScreenSizeUtil.setViewportHeight();
    ScreenSizeUtil.watchViewPortChange();
})();
