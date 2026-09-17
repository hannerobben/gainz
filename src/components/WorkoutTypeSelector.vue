<script setup lang="ts">
import {computed} from 'vue';
import {createLucideIcon, Dumbbell, Footprints, Volleyball} from 'lucide-vue-next';
import {SportShoe as SportShoeIcon} from 'lucide';
import {SECONDARY_COLOR} from '../colors.ts';

const SportShoe = createLucideIcon('SportShoe', SportShoeIcon as any);

const props = defineProps<{
    modelValue: Set<string>;
    singleSelect?: boolean;
    showFootball?: boolean;
}>();

const emit = defineEmits<{
    'update:modelValue': [value: Set<string>];
}>();

const allFilters = [
    {type: 'strength', icon: Dumbbell, bg: '#4A7FC1'},
    {type: 'running', icon: SportShoe, bg: '#5A9E5A'},
    {type: 'football', icon: Volleyball, bg: '#C1504A'},
    {type: 'steps', icon: Footprints, bg: SECONDARY_COLOR}
];

const filters = computed(() =>
    !props.showFootball ? allFilters.filter(f => f.type !== 'football') : allFilters
);

function toggleFilter(type: string) {
    if (props.singleSelect) {
        emit('update:modelValue', new Set([type]));
        return;
    }
    const next = new Set(props.modelValue);
    if (type === 'steps') {
        emit('update:modelValue', new Set(['steps']));
        return;
    }
    if (next.has('steps')) {
        emit('update:modelValue', new Set([type]));
        return;
    }
    if (next.has(type)) {
        next.delete(type);
        if (next.size === 0) next.add(type);
    } else {
        next.add(type);
    }
    emit('update:modelValue', next);
}
</script>

<template>
    <div class="filter-row">
        <button
            v-for="f in filters"
            :key="f.type"
            class="filter-circle"
            :style="{backgroundColor: f.bg, opacity: modelValue.has(f.type) ? 1 : 0.4}"
            @click="toggleFilter(f.type)"
        >
            <component :is="f.icon" :size="20" color="white" />
        </button>
    </div>
</template>

<style scoped>
.filter-row {
    display: flex;
    justify-content: center;
    gap: 16px;
  padding-bottom: 4px;
}

.filter-circle {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    border: none;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: opacity 0.15s;
}
</style>
