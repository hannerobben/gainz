<script setup lang="ts">
import {computed, onMounted, ref, watch} from 'vue';
import {useUsersStore} from '../stores/users.store.ts';
import {WorkoutsApi} from '../supabase/workouts.api.ts';
import type {Workout} from '../model/workout.contract.ts';
import {Calendar} from 'lucide-vue-next';
import ExerciseCategoryBadge from '../components/ExerciseCategoryBadge.vue';
import LoadingSpinner from '../components/LoadingSpinner.vue';

const usersStore = useUsersStore();
const workouts = ref<Workout[]>([]);
const loading = ref(true);
const searchQuery = ref('');

async function loadWorkouts() {
    if (!usersStore.activeUser) return;
    loading.value = true;
    workouts.value = await WorkoutsApi.getAll(usersStore.activeUser.id);
    loading.value = false;
}

onMounted(loadWorkouts);
watch(() => usersStore.activeUser?.id, loadWorkouts);

const filteredWorkouts = computed(() => {
    const query = searchQuery.value.toLowerCase().trim();
    if (!query) return workouts.value;
    return workouts.value
        .map(w => ({
            ...w,
            entries: w.entries.filter(e => e.exercise.name.toLowerCase().includes(query))
        }))
        .filter(w => w.entries.length > 0);
});

function formatDate(dateStr: string): string {
    const [year, month, day] = dateStr.split('-').map(Number);
    return new Intl.DateTimeFormat('en-GB', {day: 'numeric', month: 'long', year: 'numeric'}).format(
        new Date(year, month - 1, day)
    );
}

function formatSet(load: number | null, reps: number | null): string {
    if (load && reps !== null) return `${load} kg × ${reps}`;
    if (reps !== null) return `× ${reps}`;
    if (load) return `${load} kg`;
    return '—';
}

function formatSets(sets: {load: number | null; reps: number | null}[]): {text: string; count: number}[] {
    const groups: {text: string; count: number}[] = [];
    for (const set of sets) {
        const text = formatSet(set.load, set.reps);
        const last = groups[groups.length - 1];
        if (last && last.text === text) {
            last.count++;
        } else {
            groups.push({text, count: 1});
        }
    }
    return groups;
}
</script>

<template>
    <div class="history-page">
        <IconField class="search-field">
            <InputIcon class="pi pi-search" />
            <InputText v-model="searchQuery" placeholder="Search by exercise..." fluid />
        </IconField>

        <div v-if="loading" class="state-center">
            <LoadingSpinner />
        </div>
        <div v-else-if="filteredWorkouts.length === 0" class="state-center">
            <span class="empty-text">{{ searchQuery ? 'No results' : 'No strength workouts yet' }}</span>
        </div>
        <div v-else class="workout-list">
            <Card v-for="workout in filteredWorkouts" :key="workout.id" class="workout-card">
                <template #content>
                    <div class="workout-body">
                        <div class="workout-date">
                            <Calendar :size="18" />
                            <span>{{ formatDate(workout.date) }}</span>
                        </div>
                        <div v-for="entry in workout.entries" :key="entry.exercise.id" class="exercise-row">
                            <div class="exercise-header">
                                <span class="exercise-name">{{ entry.exercise.name }}</span>
                                <ExerciseCategoryBadge :category="entry.exercise.category" />
                            </div>
                            <div class="sets-row">
                                <div v-for="(group, i) in formatSets(entry.sets)" :key="i" class="set-group">
                                    <span class="set-chip">{{ group.text }}</span>
                                    <span v-if="group.count > 1" class="set-multiplier">×{{ group.count }}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </template>
            </Card>
        </div>
    </div>
</template>

<style scoped>
.history-page {
    padding: 16px;
    display: flex;
    flex-direction: column;
    gap: 12px;
    min-height: 100%;
}

.search-field {
    width: 100%;
}

.state-center {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
}

.empty-text {
    font-size: 0.95rem;
    color: #9E9E9E;
}

.workout-list {
    display: flex;
    flex-direction: column;
    gap: 12px;
}

.workout-card {
    border-radius: 10px;
}

:deep(.workout-card .p-card-body) {
    padding: 12px;
}

.workout-body {
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.workout-date {
    display: flex;
    align-items: center;
    gap: 6px;
    font-size: 0.95rem;
    font-weight: 700;
    color: var(--primary-color);
}

.exercise-row {
    display: flex;
    flex-direction: column;
    gap: 4px;
    border-top: 1px solid var(--p-content-border-color);
    padding-top: 6px;
}

.workout-date + .exercise-row {
    border-top: none;
    padding-top: 0;
}

.exercise-header {
    display: flex;
    justify-content: space-between;
    align-items: baseline;
    gap: 8px;
}

.exercise-name {
    font-size: 0.85rem;
    font-weight: 600;
    color: #2E2E2E;
}


.sets-row {
    display: flex;
    flex-wrap: wrap;
    gap: 4px;
}

.set-group {
    display: flex;
    align-items: center;
    gap: 3px;
}

.set-multiplier {
  font-size: 0.85rem;
  font-weight: 600;
  color: #9E9E9E;
  padding: 0 2px;
}

.set-chip {
    font-size: 0.75rem;
    font-weight: 500;
    color: #ffffff;
    background: var(--secondary-color);
    border-radius: 4px;
    padding: 2px 8px;
    white-space: nowrap;
}
</style>
