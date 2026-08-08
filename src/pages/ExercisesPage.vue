<script setup lang="ts">
import {computed, onMounted, ref} from 'vue';
import {storeToRefs} from 'pinia';
import {useExercisesStore} from '../stores/exercises.store.ts';
import type {ExerciseCategory, MovementPattern} from '../model/exercise.contract.ts';


const exercisesStore = useExercisesStore();
const {exercises} = storeToRefs(exercisesStore);

onMounted(() => exercisesStore.getAll());

const searchQuery = ref('');

const CATEGORY_ORDER: ExerciseCategory[] = ['push', 'pull', 'legs', 'core'];

function toTitleCase(value: string): string {
    return value.replace(/_/g, ' ').replace(/\b\w/g, c => c.toUpperCase());
}

function categoryLabel(category: ExerciseCategory): string {
    const prefix = category === 'push' || category === 'pull' ? 'Arms: ' : '';
    return prefix + toTitleCase(category);
}

const grouped = computed(() => {
    const query = searchQuery.value.toLowerCase();
    const sorted = [...exercises.value]
        .filter(e => e.name.toLowerCase().includes(query))
        .sort((a, b) => a.name.localeCompare(b.name));

    const map = new Map<ExerciseCategory, Map<MovementPattern, typeof sorted>>();

    for (const exercise of sorted) {
        if (!map.has(exercise.category)) {
            map.set(exercise.category, new Map());
        }
        const patternMap = map.get(exercise.category)!;
        if (!patternMap.has(exercise.movement_pattern)) {
            patternMap.set(exercise.movement_pattern, []);
        }
        patternMap.get(exercise.movement_pattern)!.push(exercise);
    }

    return CATEGORY_ORDER.filter(cat => map.has(cat)).map(cat => ({
        category: cat,
        patterns: [...map.get(cat)!.entries()].map(([pattern, items]) => ({pattern, items}))
    }));
});

</script>

<template>
    <div class="exercises-page">
        <IconField class="search-field">
            <InputIcon class="pi pi-search" />
            <InputText v-model="searchQuery" placeholder="Search exercises..." fluid />
        </IconField>

        <div v-for="group in grouped" :key="group.category" class="category-section">
            <h2 class="category-heading">{{ categoryLabel(group.category) }}</h2>

            <div v-for="patternGroup in group.patterns" :key="patternGroup.pattern" class="pattern-section">
                <h3 class="pattern-heading">{{ toTitleCase(patternGroup.pattern) }}</h3>

                <div class="cards-list">
                    <Card v-for="exercise in patternGroup.items" :key="exercise.id" class="exercise-card">
                        <template #content>
                            <div class="card-body">
                                <div class="card-main">
                                    <span class="exercise-name">{{ exercise.name }}</span>
                                    <span v-if="exercise.description" class="exercise-description">
                                        {{ exercise.description }}
                                    </span>
                                </div>
                                <div class="card-tags">
                                    <Tag :value="toTitleCase(exercise.equipment)" class="tag-equipment" />
                                    <Tag
                                        v-for="muscle in exercise.muscle_groups"
                                        :key="muscle"
                                        :value="toTitleCase(muscle)"
                                        severity="secondary"
                                    />
                                </div>
                            </div>
                        </template>
                    </Card>
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped>
.exercises-page {
    padding: 16px;
    display: flex;
    flex-direction: column;
    gap: 12px;
}

.search-field {
    width: 100%;
}

.category-heading {
    margin: 0 0 4px;
    font-size: 1.25rem;
    font-weight: 700;
    color: #0a0d2e;
    text-transform: uppercase;
    letter-spacing: 0.05em;
}

.pattern-section {
    margin-bottom: 16px;
}

.pattern-heading {
    margin: 0 0 8px;
    font-size: 0.85rem;
    font-weight: 600;
    color: #7E7E7E;
    text-transform: uppercase;
    letter-spacing: 0.04em;
}

.cards-list {
    display: flex;
    flex-direction: column;
    gap: 8px;
}

.exercise-card {
    border-radius: 10px;
}

:deep(.exercise-card .p-card-body) {
    padding: 12px;
}

.card-body {
    display: flex;
    flex-direction: column;
    gap: 8px;
}

.card-main {
    display: flex;
    flex-direction: column;
    gap: 2px;
}

.exercise-name {
    font-weight: 600;
    font-size: 0.95rem;
    color: #2E2E2E;
}

.exercise-description {
    font-size: 0.82rem;
    color: #7E7E7E;
    line-height: 1.4;
}

.card-tags {
    display: flex;
    flex-wrap: wrap;
    gap: 4px;
}

.tag-equipment {
    background-color: #C17A30;
    color: #ffffff;
    border: none;
}

:deep(.p-tag) {
    font-size: 0.7rem;
}
</style>
