<script setup lang="ts">
import {computed, onMounted, ref} from 'vue';
import {storeToRefs} from 'pinia';
import DOMPurify from 'dompurify';
import {CircleHelp} from 'lucide-vue-next';
import {useExercisesStore} from '../stores/exercises.store.ts';
import type {Equipment, Exercise, ExerciseCategory, MovementPattern} from '../model/exercise.contract.ts';

const exercisesStore = useExercisesStore();
const {exercises} = storeToRefs(exercisesStore);

onMounted(() => exercisesStore.getAll());

const searchQuery = ref('');

const CATEGORY_ORDER: ExerciseCategory[] = ['push', 'pull', 'legs', 'core'];

const EQUIPMENT_COLORS: Record<Equipment, string> = {
    barbell: '#C17A30',
    dumbbell: 'rgb(74, 127, 193)',
    machine: 'rgb(90, 158, 90)',
    cable: '#176a5a',
    bodyweight: '#a65d9b',
    kettlebell: '#5aacb5',
};

function toTitleCase(value: string): string {
    return value.replace(/_/g, ' ').replace(/\b\w/g, c => c.toUpperCase());
}

function categoryLabel(category: ExerciseCategory): string {
    const prefix = category === 'push' || category === 'pull' ? 'Arms: ' : '';
    return prefix + toTitleCase(category);
}

const selectedExercise = ref<Exercise | null>(null);

function sanitizedHowTo(html: string): string {
    return DOMPurify.sanitize(html);
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
    <div class="exercises-list">
        <IconField class="search-field">
            <InputIcon class="pi pi-search" />
            <InputText v-model="searchQuery" placeholder="Search exercises..." fluid />
        </IconField>

        <div v-for="group in grouped" :key="group.category" class="category-section">
            <h2 class="category-heading">{{ categoryLabel(group.category) }}</h2>

            <div v-for="patternGroup in group.patterns" :key="patternGroup.pattern" class="pattern-section">
                <h3 class="pattern-heading">{{ toTitleCase(patternGroup.pattern) }}</h3>

                <div class="cards-list">
                    <Card v-for="exercise in patternGroup.items" :key="exercise.id" class="exercise-card" :class="{'has-how-to': exercise.how_to}" @click="exercise.how_to ? selectedExercise = exercise : undefined">
                        <template #content>
                            <div class="card-body">
                                <div class="card-main">
                                    <div class="name-row">
                                        <span class="exercise-name">{{ exercise.name }}</span>
                                        <CircleHelp v-if="exercise.how_to" :size="15" class="how-to-icon" />
                                    </div>
                                    <span v-if="exercise.description" class="exercise-description">
                                        {{ exercise.description }}
                                    </span>
                                </div>
                                <div class="card-tags">
                                    <Tag
                                        :value="toTitleCase(exercise.equipment)"
                                        :style="{ backgroundColor: EQUIPMENT_COLORS[exercise.equipment], color: '#ffffff', border: 'none' }"
                                    />
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

    <Dialog
        :visible="!!selectedExercise"
        :header="selectedExercise?.name"
        :modal="true"
        :closable="true"
        :style="{width: '540px', maxWidth: '95vw'}"
        @update:visible="selectedExercise = null"
    >
        <div v-if="selectedExercise" class="dialog-exercise-body">
            <div class="card-main">
                <span v-if="selectedExercise.description" class="exercise-description">
                    {{ selectedExercise.description }}
                </span>
                <div class="card-tags">
                    <Tag
                        :value="toTitleCase(selectedExercise.equipment)"
                        :style="{ backgroundColor: EQUIPMENT_COLORS[selectedExercise.equipment], color: '#ffffff', border: 'none' }"
                    />
                    <Tag
                        v-for="muscle in selectedExercise.muscle_groups"
                        :key="muscle"
                        :value="toTitleCase(muscle)"
                        severity="secondary"
                    />
                </div>
            </div>
            <div
                v-if="selectedExercise.how_to"
                class="how-to-content"
                v-html="sanitizedHowTo(selectedExercise.how_to)"
            />
        </div>
    </Dialog>
</template>

<style scoped>
.exercises-list {
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
    color: var(--primary-color);
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
    gap: 6px;
}

.card-main {
    display: flex;
    flex-direction: column;
    gap: 8px;

}

.name-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 8px;
}

.exercise-name {
    font-weight: 600;
    font-size: 0.95rem;
    color: #2E2E2E;
}

.how-to-icon {
    flex-shrink: 0;
    color: #BEBEBE;
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

:deep(.p-tag) {
    font-size: 0.7rem;
}

.exercise-card.has-how-to {
    cursor: pointer;
    transition: box-shadow 0.15s;

    &:hover {
        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.12);
    }
}

.dialog-exercise-body {
    display: flex;
    flex-direction: column;
}

.how-to-content {
    font-size: 0.9rem;
    line-height: 1.6;
    color: #2E2E2E;
  border-top: 1px solid #E0E0E0;
  margin-top: 16px;

    :deep(h2) {
        font-size: 1rem;
        font-weight: 700;
        margin: 0 0 8px;
        color: var(--primary-color);

        &:not(:first-child) {
            margin-top: 20px;
        }
    }

    :deep(ol),
    :deep(ul) {
        margin: 0;
        padding-left: 20px;
        display: flex;
        flex-direction: column;
        gap: 6px;
    }

    :deep(li) {
        color: #3E3E3E;
    }

    :deep(strong) {
        color: #1E1E1E;
    }
}
</style>
