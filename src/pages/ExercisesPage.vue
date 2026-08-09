<script setup lang="ts">
import {ref} from 'vue';
import ExercisesList from '../components/ExercisesList.vue';
import WorkoutsList from '../components/WorkoutsList.vue';

const viewOptions = ['Exercises', 'Workouts'];
const selectedView = ref('Exercises');
</script>

<template>
    <div class="exercises-page">
        <SelectButton v-model="selectedView" :options="viewOptions" :allow-empty="false" />
        <ExercisesList v-if="selectedView === 'Exercises'" />
        <WorkoutsList v-else />
    </div>
</template>

<style scoped>
@use '../styles/style' as *;

.exercises-page {
    padding: 16px;
    display: flex;
    flex-direction: column;
    gap: 12px;
}

:deep(.p-selectbutton) {
    width: 100%;
    display: flex;
}

:deep(.p-selectbutton .p-togglebutton) {
    flex: 1;
    background: #ffffff;
    color: var(--primary-color);
}

:deep(.p-togglebutton-checked .p-togglebutton-content) {
  background: var(--primary-color);
  color: #ffffff;
}
</style>
