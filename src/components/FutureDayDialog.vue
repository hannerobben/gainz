<script setup lang="ts">
import {computed, ref} from 'vue';
import {createLucideIcon, Dumbbell, Volleyball} from 'lucide-vue-next';
import {SportShoe as SportShoeIcon} from 'lucide';
import {useToast} from 'primevue/usetoast';
import {useUsersStore} from '../stores/users.store.ts';
import {FutureWorkoutsApi} from '../supabase/future-workouts.api.ts';
import type {FutureWorkout} from '../model/future-workout.contract.ts';

const SportShoe = createLucideIcon('SportShoe', SportShoeIcon as any);

const props = defineProps<{date: Date | null; existing: FutureWorkout[]}>();
const emit = defineEmits<{close: []}>();

const usersStore = useUsersStore();
const toast = useToast();
const busyType = ref<string | null>(null);

const visible = computed(() => props.date !== null);

const title = computed(() => {
    if (!props.date) return '';
    return new Intl.DateTimeFormat('en-GB', {day: 'numeric', month: 'long', year: 'numeric'}).format(props.date);
});

const types = [
    {type: 'STRENGTH', icon: Dumbbell, bg: '#4A7FC1'},
    {type: 'RUNNING', icon: SportShoe, bg: '#5A9E5A'},
    {type: 'FOOTBALL', icon: Volleyball, bg: '#C1504A'}
];

function existingId(type: string): string | undefined {
    return props.existing.find(e => e.type === type)?.id;
}

async function toggle(type: string) {
    if (!props.date) return;
    if (!usersStore.activeUser) {
        toast.add({severity: 'error', summary: 'No active user', detail: 'Select a user first.', life: 3000});
        return;
    }
    busyType.value = type;
    try {
        const id = existingId(type);
        if (id) {
            await FutureWorkoutsApi.delete(id);
        } else {
            await FutureWorkoutsApi.create(props.date, usersStore.activeUser.id, type);
        }
        emit('close');
    } catch (e) {
        toast.add({severity: 'error', summary: 'Failed', detail: String(e), life: 4000});
    } finally {
        busyType.value = null;
    }
}
</script>

<template>
    <Toast />
    <Dialog
        :visible="visible"
        :header="title"
        :modal="true"
        :closable="true"
        @update:visible="emit('close')"
    >
        <p class="section-label">Schedule a workout</p>
        <div class="activity-row">
            <button
                v-for="t in types"
                :key="t.type"
                class="activity-circle"
                :style="{backgroundColor: t.bg, opacity: existingId(t.type) ? 1 : 0.4}"
                :disabled="busyType === t.type"
                @click="toggle(t.type)"
            >
                <component :is="t.icon" :size="28" color="white" />
            </button>
        </div>

        <template #footer>
            <Button label="Close" @click="emit('close')" />
        </template>
    </Dialog>
</template>

<style scoped>
.section-label {
    margin: 0;
    text-align: center;
    color: #9e9e9e;
}

.activity-row {
    display: flex;
    justify-content: center;
    gap: 24px;
    padding: 16px 0 0;
}

.activity-circle {
    width: 72px;
    height: 72px;
    border-radius: 50%;
    border: none;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: opacity 0.15s;

    &:hover {
        opacity: 0.85;
    }

    &:disabled {
        cursor: default;
    }
}
</style>
