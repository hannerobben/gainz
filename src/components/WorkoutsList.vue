<script setup lang="ts">
import {computed, onMounted, ref, watch} from 'vue';
import {storeToRefs} from 'pinia';
import {Plus} from 'lucide-vue-next';
import {useUsersStore} from '../stores/users.store.ts';
import {useWorkoutTemplatesStore} from '../stores/workout-templates.store.ts';
import CreateWorkoutTemplateDialog from './CreateWorkoutTemplateDialog.vue';
import ExerciseCategoryBadge from './ExerciseCategoryBadge.vue';
import type {WorkoutTemplate} from '../model/workout-template.contract.ts';

const usersStore = useUsersStore();
const workoutTemplatesStore = useWorkoutTemplatesStore();
const {templates} = storeToRefs(workoutTemplatesStore);

const sortedTemplates = computed(() =>
    [...templates.value].sort((a, b) => {
        const dateDiff = new Date(a.created_at).getTime() - new Date(b.created_at).getTime();
        return dateDiff !== 0 ? dateDiff : a.name.localeCompare(b.name);
    })
);

const dialogVisible = ref(false);
const selectedTemplate = ref<WorkoutTemplate | null>(null);

function openCreate() {
    selectedTemplate.value = null;
    dialogVisible.value = true;
}

function openEdit(template: WorkoutTemplate) {
    selectedTemplate.value = template;
    dialogVisible.value = true;
}

async function load() {
    if (!usersStore.activeUser) return;
    await workoutTemplatesStore.getAll(usersStore.activeUser.id);
}

onMounted(load);
watch(() => usersStore.activeUser?.id, load);

function onSaved() {
    dialogVisible.value = false;
    selectedTemplate.value = null;
    load();
}
</script>

<template>
    <div class="workouts-list">
        <div v-if="templates.length === 0" class="empty-state">
            No templates yet. Tap + to create one.
        </div>

        <div v-else class="templates-grid">
            <Card v-for="template in sortedTemplates" :key="template.id" class="template-card" @click="openEdit(template)">
                <template #content>
                    <div class="template-card__body">
                        <span class="template-card__name">{{ template.name }}</span>
                        <div class="exercise-list">
                            <div
                                v-for="exercise in template.exercises"
                                :key="exercise.id"
                                class="exercise-row"
                            >
                                <span class="exercise-row__name">{{ exercise.name }}</span>
                                <ExerciseCategoryBadge :category="exercise.category" />
                            </div>
                        </div>
                    </div>
                </template>
            </Card>
        </div>

        <button class="fab" @click="openCreate">
            <Plus :size="24" />
        </button>

        <CreateWorkoutTemplateDialog
            :visible="dialogVisible"
            :existing-template="selectedTemplate"
            @close="dialogVisible = false; selectedTemplate = null"
            @saved="onSaved"
        />
    </div>
</template>

<style scoped>
.workouts-list {
    display: flex;
    flex-direction: column;
    gap: 12px;
    padding-bottom: 80px;
}

.empty-state {
    color: var(--p-text-muted-color);
    text-align: center;
    padding: 3rem 0;
}

.templates-grid {
    display: flex;
    flex-direction: column;
    gap: 8px;
}

.template-card {
    border-radius: 10px;
    cursor: pointer;
}

:deep(.template-card .p-card-body) {
    padding: 12px;
}

.template-card__body {
    display: flex;
    flex-direction: column;
    gap: 8px;
}

.template-card__name {
    font-weight: 600;
    font-size: 0.95rem;
}

.exercise-list {
    display: flex;
    flex-direction: column;
    gap: 4px;
}

.exercise-row {
    display: flex;
    justify-content: space-between;
    align-items: baseline;
    gap: 8px;
    border-top: 1px solid var(--p-content-border-color);
    padding: 4px 0 0;

    &:first-child {
        border-top: none;
    }
}

.exercise-row__name {
    font-size: 0.85rem;
    color: var(--p-text-color);
}


.fab {
    position: fixed;
    bottom: calc(60px + 16px);
    right: 16px;
    width: 52px;
    height: 52px;
    border-radius: 50%;
    background: var(--secondary-color);
    color: #ffffff;
    border: none;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
    z-index: 10;
    transition: background 0.15s;

    &:hover {
        background: #a86628;
    }
}
</style>
