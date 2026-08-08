import {createRouter, createWebHistory} from 'vue-router';
import type {Component} from 'vue';
import LoginPage from '../pages/LoginPage.vue';
import DefaultLayout from '../layouts/DefaultLayout.vue';
import EmptyLayout from '../layouts/EmptyLayout.vue';
import {useAuthStore} from '../stores/auth.store.ts';

declare module 'vue-router' {
    interface RouteMeta {
        layout?: Component;
        requiresAuth?: boolean;
        title?: string;
    }
}
import TrackingPage from "../pages/TrackingPage.vue";
import ExercisesPage from "../pages/ExercisesPage.vue";
import DashboardPage from "../pages/DashboardPage.vue";
import HistoryPage from "../pages/HistoryPage.vue";
import UserWeightPage from "../pages/UserWeightPage.vue";

const routes = [
    {
        path: '/login',
        name: 'Login',
        component: LoginPage,
        meta: { layout: EmptyLayout }
    },
    {
        path: '/',
        meta: { requiresAuth: true, layout: DefaultLayout },
        redirect: { name: 'Tracking' },
        children: [
            { path: 'tracking', name: 'Tracking', component: TrackingPage, meta: { title: 'Workout Tracker' } },
            { path: 'dashboard', name: 'Dashboard', component: DashboardPage, meta: { title: 'Progress' } },
            { path: 'exercises', name: 'Exercises', component: ExercisesPage, meta: { title: 'Exercise Catalog' } },
            { path: 'history', name: 'History', component: HistoryPage, meta: { title: 'Workout History' } },
            { path: 'weight', name: 'Weight', component: UserWeightPage, meta: { title: 'Weight Tracker' } },
        ]
    }
];

const router = createRouter({
    history: createWebHistory('/gainz/'),
    routes
});

router.beforeEach(async (to, _from, next) => {
    await useAuthStore().getAuthUser();
    const user = useAuthStore().authUser;

    if (to.meta.requiresAuth && !user) {
        next({ name: 'Login' });
    } else if (to.name === 'Login' && user) {
        next({ name: 'Tracking' });
    } else {
        next();
    }
});

export default router;
