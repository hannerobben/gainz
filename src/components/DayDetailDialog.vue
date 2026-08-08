<script setup lang="ts">
import {computed} from 'vue';
import {createLucideIcon, Dumbbell, Footprints} from 'lucide-vue-next';
import {SportShoe as SportShoeIcon} from 'lucide';

const SportShoe = createLucideIcon('SportShoe', SportShoeIcon as any);

const props = defineProps<{date: Date | null; existingTypes: string[]}>();
const emit = defineEmits<{close: []; 'open-strength-workout': []; 'open-run': []; 'open-walk': []}>();

const visible = computed(() => props.date !== null);

const title = computed(() => {
    if (!props.date) return '';
    return new Intl.DateTimeFormat('en-GB', {day: 'numeric', month: 'long', year: 'numeric'}).format(props.date);
});

const activities = [
    {icon: Dumbbell, bg: '#4A7FC1', type: 'strength', action: () => emit('open-strength-workout')},
    {icon: SportShoe, bg: '#5A9E5A', type: 'running', action: () => emit('open-run')},
    {icon: Footprints, bg: '#C17A30', type: 'steps', action: () => emit('open-walk')}
];
</script>

<template>
    <Dialog
        :visible="visible"
        :header="title"
        :modal="true"
        :closable="true"
        @update:visible="emit('close')"
    >
        <div class="activity-row">
            <button
                v-for="(activity, i) in activities"
                :key="i"
                class="activity-circle"
                :style="{backgroundColor: activity.bg, opacity: props.existingTypes.includes(activity.type) ? 1 : 0.5}"
                @click="activity.action"
            >
                <component :is="activity.icon" :size="28" color="white" />
            </button>
        </div>

        <template #footer>
            <Button label="Close" @click="emit('close')" />
        </template>
    </Dialog>
</template>

<style scoped>
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
}
</style>
