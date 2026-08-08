<script setup lang="ts">
import {ref, watch} from 'vue';
import {useToast} from 'primevue/usetoast';
import {useUsersStore} from '../stores/users.store.ts';
import {WeightsApi} from '../supabase/weights.api.ts';
import type {Weight} from '../model/weight.contract.ts';

const props = defineProps<{visible: boolean; existingWeight: Weight | null}>();
const emit = defineEmits<{close: []; saved: []}>();

const usersStore = useUsersStore();
const toast = useToast();

const date = ref<Date>(new Date());
const weight = ref<number | null>(null);
const saving = ref(false);
const deleting = ref(false);
const showDeleteConfirm = ref(false);

watch(() => props.visible, isVisible => {
    if (isVisible) {
        if (props.existingWeight) {
            const [y, m, d] = props.existingWeight.date.split('-').map(Number);
            date.value = new Date(y, m - 1, d);
            weight.value = props.existingWeight.weight;
        } else {
            date.value = new Date();
            weight.value = null;
        }
    }
});

async function save() {
    if (weight.value === null) return;
    if (!usersStore.activeUser) {
        toast.add({severity: 'error', summary: 'No active user', detail: 'Select a user to save.', life: 3000});
        return;
    }
    saving.value = true;
    try {
        if (props.existingWeight) {
            await WeightsApi.update(props.existingWeight.id, weight.value);
            toast.add({severity: 'success', summary: 'Weight updated', life: 3000});
        } else {
            await WeightsApi.create(date.value, usersStore.activeUser.id, weight.value);
            toast.add({severity: 'success', summary: 'Weight saved', life: 3000});
        }
        emit('saved');
    } catch (e) {
        toast.add({severity: 'error', summary: 'Save failed', detail: String(e), life: 4000});
    } finally {
        saving.value = false;
    }
}

async function deleteWeight() {
    if (!props.existingWeight) return;
    deleting.value = true;
    try {
        await WeightsApi.delete(props.existingWeight.id);
        toast.add({severity: 'success', summary: 'Entry deleted', life: 3000});
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
        :header="existingWeight ? 'Edit weight' : 'Log weight'"
        :modal="true"
        :closable="true"
        :style="{width: '320px', maxWidth: '95vw'}"
        @update:visible="cancel"
    >
        <div class="weight-form">
            <div class="field">
                <label>Date</label>
                <DatePicker
                    v-model="date"
                    :disabled="!!existingWeight"
                    date-format="dd/mm/yy"
                    :max-date="new Date()"
                    fluid
                />
            </div>
            <div class="field">
                <label>Weight (kg)</label>
                <InputNumber
                    v-model="weight"
                    :min="0"
                    :max-fraction-digits="1"
                    placeholder="e.g. 75.5"
                    fluid
                    autofocus
                />
            </div>
        </div>

        <template #footer>
            <div class="footer-row">
                <Button
                    v-if="existingWeight"
                    label="Delete"
                    severity="danger"
                    text
                    @click="showDeleteConfirm = true"
                />
                <div class="footer-actions">
                    <Button label="Cancel" severity="secondary" text @click="cancel" />
                    <Button
                        :label="existingWeight ? 'Update' : 'Save'"
                        :loading="saving"
                        :disabled="weight === null"
                        @click="save"
                    />
                </div>
            </div>
        </template>
    </Dialog>

    <Dialog
        :visible="showDeleteConfirm"
        header="Delete entry?"
        :modal="true"
        :closable="true"
        @update:visible="() => showDeleteConfirm = false"
        :style="{width: '320px', maxWidth: '95vw'}"
    >
        <p class="confirm-text">This cannot be undone.</p>
        <template #footer>
            <Button label="Cancel" severity="secondary" text @click="showDeleteConfirm = false" />
            <Button label="Delete" severity="danger" :loading="deleting" @click="deleteWeight" />
        </template>
    </Dialog>
</template>

<style scoped>
.weight-form {
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
