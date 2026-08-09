<script setup lang="ts">
import {computed, ref, watch} from 'vue';
import {storeToRefs} from 'pinia';
import {X, GripVertical} from 'lucide-vue-next';
import {VueDraggable} from 'vue-draggable-plus';
import {useToast} from 'primevue/usetoast';
import {useExercisesStore} from '../stores/exercises.store.ts';
import {useUsersStore} from '../stores/users.store.ts';
import {WorkoutTemplatesApi} from '../supabase/workout-templates.api.ts';
import type {Exercise} from '../model/exercise.contract.ts';
import type {WorkoutTemplate} from '../model/workout-template.contract.ts';

const props = defineProps<{visible: boolean; existingTemplate: WorkoutTemplate | null}>();
const emit = defineEmits<{close: []; saved: []}>();

const exercisesStore = useExercisesStore();
const {exercises} = storeToRefs(exercisesStore);
if (exercises.value.length === 0) exercisesStore.getAll();

const usersStore = useUsersStore();
const toast = useToast();

const name = ref('');
const selectedExercises = ref<Exercise[]>([]);
const searchQuery = ref('');
const filteredExercises = ref<Exercise[]>([]);
const saving = ref(false);

const canSave = computed(() => name.value.trim().length > 0 && selectedExercises.value.length > 0);

watch(() => props.visible, visible => {
    if (visible && props.existingTemplate) {
        name.value = props.existingTemplate.name;
        selectedExercises.value = [...props.existingTemplate.exercises];
    }
});

function onSearch(event: {query: string}) {
    const q = event.query.toLowerCase();
    filteredExercises.value = exercises.value.filter(
        e => e.name.toLowerCase().includes(q) && !selectedExercises.value.some(s => s.id === e.id)
    );
}

function onExerciseSelect(exercise: Exercise) {
    selectedExercises.value.push(exercise);
    searchQuery.value = '';
}

function removeExercise(index: number) {
    selectedExercises.value.splice(index, 1);
}

function reset() {
    name.value = '';
    selectedExercises.value = [];
    searchQuery.value = '';
}

async function save() {
    if (!usersStore.activeUser || !canSave.value) return;
    saving.value = true;
    try {
        const exerciseIds = selectedExercises.value.map(e => e.id);
        if (props.existingTemplate) {
            await WorkoutTemplatesApi.update(props.existingTemplate.id, name.value.trim(), exerciseIds);
        } else {
            await WorkoutTemplatesApi.create(usersStore.activeUser.id, name.value.trim(), exerciseIds);
        }
        reset();
        emit('saved');
    } catch {
        toast.add({severity: 'error', summary: 'Error', detail: 'Failed to save template', life: 3000});
    } finally {
        saving.value = false;
    }
}

function onHide() {
    reset();
    emit('close');
}
</script>

<template>
    <Dialog
        :visible="visible"
        modal
        :header="existingTemplate ? 'Edit Template' : 'New Template'"
        :style="{width: '90vw', maxWidth: '480px'}"
        @update:visible="onHide"
    >
        <div class="dialog-body">
            <div class="field">
                <label class="field-label">Name</label>
                <InputText v-model="name" placeholder="e.g. Push Day A" fluid />
            </div>

            <div class="field">
                <label class="field-label">Add Exercises</label>
                <AutoComplete
                    v-model="searchQuery"
                    :suggestions="filteredExercises"
                    option-label="name"
                    placeholder="Search exercises..."
                    fluid
                    @complete="onSearch"
                    @option-select="e => onExerciseSelect(e.value)"
                />
            </div>

            <VueDraggable
                v-if="selectedExercises.length > 0"
                v-model="selectedExercises"
                class="exercise-list"
                handle=".drag-handle"
            >
                <div
                    v-for="(exercise, index) in selectedExercises"
                    :key="exercise.id"
                    class="exercise-row"
                >
                    <GripVertical :size="14" class="drag-handle" />
                    <span class="exercise-row__name">{{ exercise.name }}</span>
                    <button class="exercise-row__remove" @click="removeExercise(index)">
                        <X :size="14" />
                    </button>
                </div>
            </VueDraggable>
        </div>

        <template #footer>
            <Button label="Cancel" severity="secondary" text @click="onHide" />
            <Button label="Save" :disabled="!canSave" :loading="saving" @click="save" />
        </template>
    </Dialog>
</template>

<style scoped>
.dialog-body {
    display: flex;
    flex-direction: column;
    gap: 16px;
}

.field {
    display: flex;
    flex-direction: column;
    gap: 6px;
}

.field-label {
    font-size: 0.8rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    color: var(--p-text-muted-color);
}

.exercise-list {
    display: flex;
    flex-direction: column;
    gap: 4px;
}

.exercise-row {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 8px 10px;
    background: var(--p-content-border-color);
    border-radius: 8px;
    cursor: grab;
    user-select: none;

    &:active {
        cursor: grabbing;
    }
}

.drag-handle {
    color: var(--p-text-muted-color);
    flex-shrink: 0;
}

.exercise-row__name {
    flex: 1;
    font-size: 0.9rem;
    font-weight: 500;
}

.exercise-row__remove {
    background: none;
    border: none;
    cursor: pointer;
    color: var(--p-text-muted-color);
    display: flex;
    align-items: center;
    padding: 2px;

    &:hover {
        color: var(--p-text-color);
    }
}
</style>
