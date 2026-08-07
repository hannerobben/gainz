<script setup lang="ts">
import {DumbbellIcon, ChartNoAxesCombined, Grid2X2CheckIcon, UndoDot} from 'lucide-vue-next';
import AppTabMenu from './AppTabMenu.vue';

const items = [
    { label: 'Tracking', route: { name: 'Tracking' }, icon: Grid2X2CheckIcon },
    { label: 'History', route: { name: 'History' }, icon: UndoDot },
    { label: 'Dashboard', route: { name: 'Dashboard' }, icon: ChartNoAxesCombined },
    { label: 'Exercises', route: { name: 'Exercises' }, icon: DumbbellIcon },
];
</script>

<template>
    <div class="footer">
        <AppTabMenu :items="items" />
    </div>
</template>

<style scoped></style>
