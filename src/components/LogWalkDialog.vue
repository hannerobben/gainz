<script setup lang="ts">
import {computed, ref, watch} from 'vue';
import {useToast} from 'primevue/usetoast';
import {useUsersStore} from '../stores/users.store.ts';
import {WalksApi} from '../supabase/walks.api.ts';
import type {Walk} from '../model/walk.contract.ts';

const props = defineProps<{date: Date | null; existingWalk: Walk | null}>();
const emit = defineEmits<{close: []; saved: []}>();

const visible = computed(() => props.date !== null);

const title = computed(() => {
    if (!props.date) return '';
    return new Intl.DateTimeFormat('en-GB', {day: 'numeric', month: 'long', year: 'numeric'}).format(props.date);
});

const usersStore = useUsersStore();
const toast = useToast();

const stepCount = ref<number | null>(null);
const saving = ref(false);
const deleting = ref(false);
const showDeleteConfirm = ref(false);

watch(visible, isVisible => {
    if (isVisible) {
        stepCount.value = props.existingWalk ? props.existingWalk.stepCount : null;
    }
});

async function save() {
    if (!props.date || stepCount.value === null) return;
    if (!usersStore.activeUser) {
        toast.add({severity: 'error', summary: 'No active user', detail: 'Select a user to save walks.', life: 3000});
        return;
    }
    saving.value = true;
    try {
        if (props.existingWalk) {
            await WalksApi.update(props.existingWalk.id, stepCount.value);
            toast.add({severity: 'success', summary: 'Walk updated', life: 3000});
        } else {
            await WalksApi.create(props.date, usersStore.activeUser.id, stepCount.value);
            toast.add({severity: 'success', summary: 'Walk saved', life: 3000});
        }
        emit('saved');
    } catch (e) {
        toast.add({severity: 'error', summary: 'Save failed', detail: String(e), life: 4000});
    } finally {
        saving.value = false;
    }
}

async function deleteWalk() {
    if (!props.existingWalk) return;
    deleting.value = true;
    try {
        await WalksApi.delete(props.existingWalk.id);
        toast.add({severity: 'success', summary: 'Walk deleted', life: 3000});
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
        :closable="false"
        :style="{width: '320px', maxWidth: '95vw'}"
    >
        <div class="walk-form">
            <label class="step-label">Steps</label>
            <InputNumber
                v-model="stepCount"
                :min="0"
                :max-fraction-digits="0"
                placeholder="Enter step count"
                fluid
                autofocus
            />
        </div>

        <template #footer>
            <div class="footer-row">
                <Button
                    v-if="existingWalk"
                    label="Delete"
                    severity="danger"
                    text
                    @click="showDeleteConfirm = true"
                />
                <div class="footer-actions">
                    <Button label="Cancel" severity="secondary" text @click="cancel" />
                    <Button
                        :label="existingWalk ? 'Update' : 'Save'"
                        :loading="saving"
                        :disabled="stepCount === null"
                        @click="save"
                    />
                </div>
            </div>
        </template>
    </Dialog>

    <Dialog
        :visible="showDeleteConfirm"
        header="Delete walk?"
        :modal="true"
        :closable="false"
        :style="{width: '320px', maxWidth: '95vw'}"
    >
        <p class="confirm-text">This cannot be undone.</p>
        <template #footer>
            <Button label="Cancel" severity="secondary" text @click="showDeleteConfirm = false" />
            <Button label="Delete" severity="danger" :loading="deleting" @click="deleteWalk" />
        </template>
    </Dialog>
</template>

<style scoped>
.walk-form {
    display: flex;
    flex-direction: column;
    gap: 8px;
    padding: 4px 0;
}

.step-label {
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
}

.confirm-text {
    margin: 0;
    color: #5F5F5F;
    font-size: 0.9rem;
}
</style>
