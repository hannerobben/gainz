<script setup lang="ts">
import {computed, ref} from 'vue';
import {useToast} from 'primevue/usetoast';
import {useUsersStore} from '../stores/users.store.ts';
import {OtherWorkoutsApi} from '../supabase/other-workouts.api.ts';
import type {OtherWorkout} from '../model/other-workout.contract.ts';

const props = defineProps<{date: Date | null; existingFootball: OtherWorkout | null}>();
const emit = defineEmits<{close: []; saved: []}>();

const visible = computed(() => props.date !== null);

const title = computed(() => {
    if (!props.date) return '';
    return new Intl.DateTimeFormat('en-GB', {day: 'numeric', month: 'long', year: 'numeric'}).format(props.date);
});

const usersStore = useUsersStore();
const toast = useToast();

const saving = ref(false);
const deleting = ref(false);
const showDeleteConfirm = ref(false);

async function save() {
    if (!props.date) return;
    if (!usersStore.activeUser) {
        toast.add({severity: 'error', summary: 'No active user', detail: 'Select a user to save football.', life: 3000});
        return;
    }
    saving.value = true;
    try {
        await OtherWorkoutsApi.create(props.date, usersStore.activeUser.id, 'FOOTBALL');
        toast.add({severity: 'success', summary: 'Football saved', life: 3000});
        emit('saved');
    } catch (e) {
        toast.add({severity: 'error', summary: 'Save failed', detail: String(e), life: 4000});
    } finally {
        saving.value = false;
    }
}

async function deleteFootball() {
    if (!props.existingFootball) return;
    deleting.value = true;
    try {
        await OtherWorkoutsApi.delete(props.existingFootball.id);
        toast.add({severity: 'success', summary: 'Football deleted', life: 3000});
        showDeleteConfirm.value = false;
        emit('saved');
    } catch (e) {
        toast.add({severity: 'error', summary: 'Delete failed', detail: String(e), life: 4000});
    } finally {
        deleting.value = false;
    }
}

function cancel() {
    emit('close');
}
</script>

<template>
    <Toast />
    <Dialog
        :visible="visible"
        :header="title"
        :modal="true"
        :closable="true"
        :style="{width: '320px', maxWidth: '95vw'}"
        @update:visible="cancel"
    >
        <p class="confirm-text">
            {{ existingFootball ? 'Football is logged for this day.' : 'Log football for this day?' }}
        </p>

        <template #footer>
            <div class="footer-row">
                <Button
                    v-if="existingFootball"
                    label="Delete"
                    severity="danger"
                    text
                    @click="showDeleteConfirm = true"
                />
                <div class="footer-actions">
                    <Button label="Cancel" severity="secondary" text @click="cancel" />
                    <Button v-if="!existingFootball" label="Save" :loading="saving" @click="save" />
                </div>
            </div>
        </template>
    </Dialog>

    <Dialog
        :visible="showDeleteConfirm"
        header="Delete football entry?"
        :modal="true"
        :closable="true"
        @update:visible="() => showDeleteConfirm = false"
        :style="{width: '320px', maxWidth: '95vw'}"
    >
        <p class="confirm-text">This cannot be undone.</p>
        <template #footer>
            <Button label="Cancel" severity="secondary" text @click="showDeleteConfirm = false" />
            <Button label="Delete" severity="danger" :loading="deleting" @click="deleteFootball" />
        </template>
    </Dialog>
</template>

<style scoped>
.confirm-text {
    margin: 0;
    color: #5F5F5F;
    font-size: 0.9rem;
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
</style>
