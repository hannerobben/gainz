<script setup lang="ts">
import {computed, ref, watch} from 'vue';
import {storeToRefs} from 'pinia';
import {X, Plus} from 'lucide-vue-next';
import {useToast} from 'primevue/usetoast';
import {useExercisesStore} from '../stores/exercises.store.ts';
import {useUsersStore} from '../stores/users.store.ts';
import {WorkoutsApi} from '../supabase/workouts.api.ts';
import type {Exercise} from '../model/exercise.contract.ts';
import type {Workout, WorkoutExerciseEntry, WorkoutSet} from '../model/workout.contract.ts';

const props = defineProps<{date: Date | null; existingWorkout: Workout | null}>();
const emit = defineEmits<{close: []; saved: []}>();

const visible = computed(() => props.date !== null);

const title = computed(() => {
    if (!props.date) return '';
    return new Intl.DateTimeFormat('en-GB', {day: 'numeric', month: 'long', year: 'numeric'}).format(props.date);
});

const exercisesStore = useExercisesStore();
const {exercises} = storeToRefs(exercisesStore);

if (exercises.value.length === 0) exercisesStore.getAll();
const usersStore = useUsersStore();
const toast = useToast();

const entries = ref<WorkoutExerciseEntry[]>([]);
const searchQuery = ref('');
const saving = ref(false);
const deleting = ref(false);
const showDeleteConfirm = ref(false);
const filteredExercises = ref<Exercise[]>([]);

watch(visible, isVisible => {
    if (isVisible && props.existingWorkout) {
        entries.value = props.existingWorkout.entries.map(e => ({
            exercise: e.exercise,
            sets: e.sets.map(s => ({...s}))
        }));
    }
});

function onSearch(event: {query: string}) {
    const q = event.query.toLowerCase();
    filteredExercises.value = exercises.value.filter(e => e.name.toLowerCase().includes(q));
}

function onExerciseSelect(exercise: Exercise) {
    if (entries.value.some(e => e.exercise.id === exercise.id)) return;
    entries.value.push({exercise, sets: [{load: null, reps: null}]});
    searchQuery.value = '';
}

function removeEntry(index: number) {
    entries.value.splice(index, 1);
}

function addSet(entry: WorkoutExerciseEntry) {
    const last = entry.sets[entry.sets.length - 1];
    entry.sets.push({load: last?.load ?? null, reps: last?.reps ?? null});
}

function removeSet(entry: WorkoutExerciseEntry, index: number) {
    if (entry.sets.length > 1) entry.sets.splice(index, 1);
}

async function save() {
    if (!props.date) return;
    if (!usersStore.activeUser) {
        toast.add({severity: 'error', summary: 'No active user', detail: 'Select a user to save workouts.', life: 3000});
        return;
    }
    saving.value = true;
    try {
        if (props.existingWorkout) {
            await WorkoutsApi.update(props.existingWorkout.id, entries.value);
            toast.add({severity: 'success', summary: 'Workout updated', life: 3000});
        } else {
            await WorkoutsApi.create(props.date, usersStore.activeUser.id, entries.value);
            toast.add({severity: 'success', summary: 'Workout saved', life: 3000});
        }
        entries.value = [];
        emit('saved');
    } catch (e) {
        toast.add({severity: 'error', summary: 'Save failed', detail: String(e), life: 4000});
    } finally {
        saving.value = false;
    }
}

async function deleteWorkout() {
    if (!props.existingWorkout) return;
    deleting.value = true;
    try {
        await WorkoutsApi.delete(props.existingWorkout.id);
        toast.add({severity: 'success', summary: 'Workout deleted', life: 3000});
        showDeleteConfirm.value = false;
        entries.value = [];
        emit('saved');
    } catch (e) {
        toast.add({severity: 'error', summary: 'Delete failed', detail: String(e), life: 4000});
    } finally {
        deleting.value = false;
    }
}

function cancel() {
    entries.value = [];
    searchQuery.value = '';
    emit('close');
}
</script>

<template>
    <Toast />
    <Dialog
        :visible="visible"
        :header="title"
        :modal="true"
        :closable="false"
        :style="{width: '480px', maxWidth: '95vw'}"
    >
        <div class="workout-form">
            <AutoComplete
                v-model="searchQuery"
                :suggestions="filteredExercises"
                optionLabel="name"
                placeholder="Search and add exercise..."
                class="exercise-search"
                forceSelection
                fluid
                @complete="onSearch"
                @option-select="(e) => onExerciseSelect(e.value)"
            />

            <div v-if="entries.length === 0" class="empty-state">
                No exercises added yet. Search above to get started.
            </div>

            <div class="entries-list">
                <div v-for="(entry, ei) in entries" :key="entry.exercise.id" class="exercise-card">
                    <div class="exercise-card-header">
                        <span class="exercise-card-name">{{ entry.exercise.name }}</span>
                        <button class="remove-btn" @click="removeEntry(ei)">
                            <X :size="14" />
                        </button>
                    </div>

                    <div class="sets-table">
                        <div class="sets-header">
                            <span class="col-set">#</span>
                            <span class="col-load">Load (kg)</span>
                            <span class="col-reps">Reps</span>
                            <span class="col-action" />
                        </div>
                        <div v-for="(set, si) in entry.sets" :key="si" class="set-row">
                            <span class="col-set set-number">{{ si + 1 }}</span>
                            <InputNumber
                                v-model="(set as WorkoutSet).load"
                                class="col-load"
                                :min="0"
                                :maxFractionDigits="2"
                                placeholder="—"
                                fluid
                            />
                            <InputNumber
                                v-model="(set as WorkoutSet).reps"
                                class="col-reps"
                                :min="0"
                                placeholder="—"
                                fluid
                            />
                            <button
                                class="col-action remove-set-btn"
                                :disabled="entry.sets.length === 1"
                                @click="removeSet(entry, si)"
                            >
                                <X :size="12" />
                            </button>
                        </div>
                    </div>

                    <button class="add-set-btn" @click="addSet(entry)">
                        <Plus :size="13" />
                        Add set
                    </button>
                </div>
            </div>
        </div>

        <template #footer>
            <div class="footer-row">
                <Button
                    v-if="existingWorkout"
                    label="Delete"
                    severity="danger"
                    text
                    @click="showDeleteConfirm = true"
                />
                <div class="footer-actions">
                    <Button label="Cancel" severity="secondary" text @click="cancel" />
                    <Button
                        label="Save"
                        :loading="saving"
                        :disabled="entries.length === 0"
                        @click="save"
                    />
                </div>
            </div>
        </template>
    </Dialog>

    <Dialog
        :visible="showDeleteConfirm"
        header="Delete workout?"
        :modal="true"
        :closable="false"
        :style="{width: '320px', maxWidth: '95vw'}"
    >
        <p class="confirm-text">This cannot be undone.</p>
        <template #footer>
            <Button label="Cancel" severity="secondary" text @click="showDeleteConfirm = false" />
            <Button label="Delete" severity="danger" :loading="deleting" @click="deleteWorkout" />
        </template>
    </Dialog>
</template>

<style scoped>


.workout-form {
    display: flex;
    flex-direction: column;
    gap: 16px;
    padding: 4px 0;
}

.exercise-search {
    width: 100%;
}

.empty-state {
    text-align: center;
    color: #9E9E9E;
    font-size: 0.85rem;
    padding: 16px 0;
}

.entries-list {
    display: flex;
    flex-direction: column;
    gap: 12px;
}

.exercise-card {
    border: 1px solid #EEEEEE;
    border-radius: 10px;
    overflow: hidden;
}

.exercise-card-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    background: #0a0d2e;
    padding: 10px 12px;
}

.exercise-card-name {
    font-weight: 600;
    font-size: 0.9rem;
    color: #ffffff;
}

.remove-btn {
    background: none;
    border: none;
    cursor: pointer;
    color: rgba(255, 255, 255, 0.6);
    display: flex;
    align-items: center;
    padding: 2px;
    border-radius: 4px;
    transition: color 0.15s;

    &:hover {
        color: #ffffff;
    }
}

.sets-table {
    padding: 8px 12px 4px;
    display: flex;
    flex-direction: column;
    gap: 6px;
}

.sets-header,
.set-row {
    display: grid;
    grid-template-columns: 24px 1fr 1fr 24px;
    gap: 8px;
    align-items: center;
}

.sets-header {
    font-size: 0.7rem;
    font-weight: 600;
    color: #9E9E9E;
    text-transform: uppercase;
    letter-spacing: 0.04em;
    padding-bottom: 2px;
}

.col-set {
    text-align: center;
}

.set-number {
    font-size: 0.75rem;
    color: #BEBEBE;
    font-weight: 600;
}

.remove-set-btn {
    background: none;
    border: none;
    cursor: pointer;
    color: #BEBEBE;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 2px;
    border-radius: 4px;
    transition: color 0.15s;

    &:hover:not(:disabled) {
        color: #5F5F5F;
    }

    &:disabled {
        opacity: 0.3;
        cursor: default;
    }
}

.add-set-btn {
    display: flex;
    align-items: center;
    gap: 4px;
    background: none;
    border: none;
    cursor: pointer;
    color: #C9A84C;
    font-size: 0.8rem;
    font-weight: 600;
    padding: 8px 12px;
    transition: color 0.15s;

    &:hover {
        color: #A07828;
    }
}

.footer-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    width: 100%;
}

.footer-actions {
    display: flex;
    gap: 8px;
    margin-left: auto;
}

.confirm-text {
    margin: 0;
    color: #5F5F5F;
    font-size: 0.9rem;
}
</style>
