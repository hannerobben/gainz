<script setup lang="ts">
import {computed, ref, watch} from 'vue';
import {useToast} from 'primevue/usetoast';
import {useUsersStore} from '../stores/users.store.ts';
import {RunsApi} from '../supabase/runs.api.ts';
import type {Run} from '../model/run.contract.ts';

const props = defineProps<{date: Date | null; existingRun: Run | null}>();
const emit = defineEmits<{close: []; saved: []}>();

const visible = computed(() => props.date !== null);

const title = computed(() => {
    if (!props.date) return '';
    return new Intl.DateTimeFormat('en-GB', {day: 'numeric', month: 'long', year: 'numeric'}).format(props.date);
});

const usersStore = useUsersStore();
const toast = useToast();

const duration = ref<number | null>(null);
const seconds = ref<number | null>(null);
const distance = ref<number | null>(null);
const saving = ref(false);
const deleting = ref(false);
const showDeleteConfirm = ref(false);

watch(visible, isVisible => {
    if (isVisible) {
        duration.value = props.existingRun ? props.existingRun.duration : null;
        seconds.value = props.existingRun ? props.existingRun.seconds : null;
        distance.value = props.existingRun ? props.existingRun.distance : null;
    }
});

async function save() {
    if (!props.date || duration.value === null || seconds.value === null || distance.value === null) return;
    if (!usersStore.activeUser) {
        toast.add({severity: 'error', summary: 'No active user', detail: 'Select a user to save runs.', life: 3000});
        return;
    }
    saving.value = true;
    try {
        if (props.existingRun) {
            await RunsApi.update(props.existingRun.id, duration.value, seconds.value, distance.value);
            toast.add({severity: 'success', summary: 'Run updated', life: 3000});
        } else {
            await RunsApi.create(props.date, usersStore.activeUser.id, duration.value, seconds.value, distance.value);
            toast.add({severity: 'success', summary: 'Run saved', life: 3000});
        }
        emit('saved');
    } catch (e) {
        toast.add({severity: 'error', summary: 'Save failed', detail: String(e), life: 4000});
    } finally {
        saving.value = false;
    }
}

async function deleteRun() {
    if (!props.existingRun) return;
    deleting.value = true;
    try {
        await RunsApi.delete(props.existingRun.id);
        toast.add({severity: 'success', summary: 'Run deleted', life: 3000});
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
        <div class="run-form">
            <div class="field">
                <label>Duration</label>
                <div class="duration-row">
                    <InputNumber
                        v-model="duration"
                        :min="0"
                        :max-fraction-digits="0"
                        placeholder="min"
                        fluid
                        autofocus
                    />
                    <span class="duration-sep">:</span>
                    <InputNumber
                        v-model="seconds"
                        :min="0"
                        :max="59"
                        :max-fraction-digits="0"
                        placeholder="sec"
                        fluid
                    />
                </div>
            </div>
            <div class="field">
                <label>Distance (km)</label>
                <InputNumber
                    v-model="distance"
                    :min="0"
                    :max-fraction-digits="2"
                    placeholder="e.g. 5.0"
                    fluid
                />
            </div>
        </div>

        <template #footer>
            <div class="footer-row">
                <Button
                    v-if="existingRun"
                    label="Delete"
                    severity="danger"
                    text
                    @click="showDeleteConfirm = true"
                />
                <div class="footer-actions">
                    <Button label="Cancel" severity="secondary" text @click="cancel" />
                    <Button
                        :label="existingRun ? 'Update' : 'Save'"
                        :loading="saving"
                        :disabled="duration === null || seconds === null || distance === null"
                        @click="save"
                    />
                </div>
            </div>
        </template>
    </Dialog>

    <Dialog
        :visible="showDeleteConfirm"
        header="Delete run?"
        :modal="true"
        :closable="true"
        @update:visible="() => showDeleteConfirm = false"
        :style="{width: '320px', maxWidth: '95vw'}"
    >
        <p class="confirm-text">This cannot be undone.</p>
        <template #footer>
            <Button label="Cancel" severity="secondary" text @click="showDeleteConfirm = false" />
            <Button label="Delete" severity="danger" :loading="deleting" @click="deleteRun" />
        </template>
    </Dialog>
</template>

<style scoped>
.run-form {
    display: flex;
    flex-direction: column;
    gap: 12px;
    padding: 4px 0;
}

.field {
    display: flex;
    flex-direction: column;
    gap: 6px;
}

.duration-row {
    display: flex;
    align-items: center;
    gap: 6px;

    :deep(.p-inputnumber) {
        flex: 1;
        min-width: 0;
    }
}

.duration-sep {
    font-size: 1.1rem;
    font-weight: 700;
    color: #5F5F5F;
    line-height: 1;
}

.field label {
    font-size: 0.85rem;
    font-weight: 600;
    color: #5F5F5F;
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
