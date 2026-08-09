<script setup lang="ts">
import type {ExerciseCategory} from '../model/exercise.contract.ts';

defineProps<{category: ExerciseCategory}>();

const CATEGORY_LABEL: Record<ExerciseCategory, string> = {
    push: 'Arms: Push',
    pull: 'Arms: Pull',
    legs: 'Legs',
    core: 'Core'
};

const CATEGORY_COLOR: Record<ExerciseCategory, string> = {
    push: '#4A7FC1',
    pull: '#5A9E5A',
    legs: '#C17A30',
    core: '#ddb160'
};
</script>

<template>
    <span class="exercise-category">
        {{ CATEGORY_LABEL[category] }}
        <span class="category-dot" :style="{background: CATEGORY_COLOR[category]}" />
    </span>
</template>

<style scoped>
.exercise-category {
    display: flex;
    align-items: center;
    gap: 5px;
    font-size: 0.72rem;
    color: var(--p-text-muted-color);
    white-space: nowrap;
}

.category-dot {
    display: inline-block;
    width: 8px;
    height: 8px;
    border-radius: 50%;
    flex-shrink: 0;
}
</style>
