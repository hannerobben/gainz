<script setup lang="ts">
import {ref} from 'vue';
import WorkoutTypeSelector from '../components/WorkoutTypeSelector.vue';
import StrengthDashboard from '../components/StrengthDashboard.vue';
import RunningDashboard from '../components/RunningDashboard.vue';
import StepsDashboard from '../components/StepsDashboard.vue';

const selectedType = ref(new Set<string>(['strength']));
</script>

<template>
    <div class="dashboard">
        <div class="dashboard__selector">
            <WorkoutTypeSelector v-model="selectedType" single-select />
        </div>

        <StrengthDashboard v-if="selectedType.has('strength')" />
        <RunningDashboard v-else-if="selectedType.has('running')" />
        <StepsDashboard v-else-if="selectedType.has('steps')" />

        <div v-else class="dashboard__empty">
            No data to show here yet.
        </div>
    </div>
</template>

<style scoped>
.dashboard {
    padding: 16px 1.5rem;
    padding-top: 0;
    overflow-x: hidden;
}

.dashboard__selector {
    position: sticky;
    top: 0;
    z-index: 1;
    background: whitesmoke;
    display: flex;
    justify-content: center;
    padding: 18px 0 12px 0;
    margin: -16px -1.5rem 1.5rem;
    padding-left: 1.5rem;
    padding-right: 1.5rem;
}

.dashboard__empty {
    color: var(--p-text-muted-color);
    text-align: center;
    padding: 3rem 0;
}
</style>
