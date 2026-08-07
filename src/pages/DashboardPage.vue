<script setup lang="ts">
import {ref, computed, onMounted, reactive, watch} from 'vue';
import {useUsersStore} from '../stores/users.store.ts';
import { WorkoutApi, type ExerciseProgression } from '../supabase/workout.api.ts';
import ExerciseCardStats from '../components/ExerciseCardStats.vue';
import dayjs from 'dayjs';
import { ChevronDown, ChevronUp } from 'lucide-vue-next';

const usersStore = useUsersStore();

const progressions = ref<ExerciseProgression[]>([]);
const loading = ref(true);
const expandedHistory = reactive<Record<string, boolean>>({});

function toggleHistory(id: string) {
    expandedHistory[id] = !expandedHistory[id];
}

function daysAgoLabel(date: string): string {
    const d = dayjs().diff(dayjs(date), 'day');
    if (d === 0) return 'today';
    if (d === 1) return '1 day ago';
    return `${d} days ago`;
}

function formatDate(date: string): string {
    return dayjs(date).format('MMM D, YYYY');
}

function formatSets(sets: { load: number; reps: number }[]): { text: string; badge: number | null }[] {
    if (sets.length === 0) return [];
    const allSame = sets.every(s => s.load === sets[0].load && s.reps === sets[0].reps);
    if (allSame) {
        return [{ text: `${sets[0].load} kg × ${sets[0].reps}`, badge: sets.length > 1 ? sets.length : null }];
    }
    return sets.map(s => ({ text: `${s.load} kg × ${s.reps}`, badge: null }));
}

async function loadProgressions() {
    if (!usersStore.activeUser) return;
    loading.value = true;
    const result = await WorkoutApi.getStrengthProgression(usersStore.activeUser.id);
    progressions.value = result.sort((a, b) => b.dataPoints.length - a.dataPoints.length);
    loading.value = false;
}

onMounted(loadProgressions);
watch(() => usersStore.activeUser?.id, loadProgressions);

function chartData(progression: ExerciseProgression) {
    return {
        labels: progression.dataPoints.map((p: { date: string; e1rm: number }) => p.date),
        datasets: [
            {
                label: 'e1RM (kg)',
                data: progression.dataPoints.map((p: { date: string; e1rm: number }) => p.e1rm),
                borderColor: '#C9A84C',
                pointBackgroundColor: '#C9A84C',
                fill: false,
                tension: 0.3,
                pointRadius: 4,
            },
        ],
    };
}

const chartOptions = computed(() => ({
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
        legend: { display: false },
        tooltip: {
            callbacks: {
                label: (ctx: { parsed: { y: number } }) => `${ctx.parsed.y} kg`,
            },
        },
    },
    scales: {
        x: { grid: { display: false } },
        y: {
            title: { display: true, text: 'e1RM (kg)' },
            ticks: { callback: (v: number) => `${v} kg` },
        },
    },
}));
</script>

<template>
    <div class="dashboard">
        <div v-if="loading" class="dashboard__loading">Loading progression data…</div>

        <div v-else-if="progressions.length === 0" class="dashboard__empty">
            No strength workouts logged yet. Start tracking to see your progression.
        </div>

        <div v-else class="dashboard__grid">
            <Card v-for="progression in progressions" :key="progression.exerciseId">
                <template #title>{{ progression.exerciseName }}</template>
                <template #content>
                    <ExerciseCardStats :progression="progression" />
                    <div class="dashboard__chart-heading">Estimated 1RM Evolution</div>
                    <div class="dashboard__chart-wrapper">
                        <Chart type="line" :data="chartData(progression)" :options="chartOptions" />
                    </div>

                    <div class="dashboard__footer">
                        <div class="dashboard__last-trained">
                            Last trained: {{ daysAgoLabel(progression.lastTrained) }}
                        </div>
                        <button
                            class="dashboard__history-toggle"
                            @click="toggleHistory(progression.exerciseId)"
                        >
                            <span>Training History</span>
                            <ChevronUp v-if="expandedHistory[progression.exerciseId]" :size="14" />
                            <ChevronDown v-else :size="14" />
                        </button>
                        <div v-if="expandedHistory[progression.exerciseId]" class="dashboard__history">
                            <div class="dashboard__history-header">
                                <span>Date</span>
                                <span>Sets</span>
                            </div>
                            <div
                                v-for="dp in [...progression.dataPoints].reverse()"
                                :key="dp.date"
                                class="dashboard__history-row"
                            >
                                <span>{{ formatDate(dp.date) }}</span>
                                <div class="dashboard__history-sets">
                                    <div v-for="(set, i) in formatSets(dp.sets)" :key="i" class="dashboard__history-set">
                                        <span>{{ set.text }}</span>
                                        <span v-if="set.badge" class="dashboard__set-badge">×{{ set.badge }}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </template>
            </Card>
        </div>
    </div>
</template>

<style scoped>
.dashboard {
    padding: 1.5rem;
    overflow-x: hidden;
}

.dashboard__loading,
.dashboard__empty {
    color: var(--p-text-muted-color);
    text-align: center;
    padding: 3rem 0;
}

.dashboard__grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 12px;
}

.dashboard__chart-heading {
    font-size: 0.7rem;
    font-weight: 600;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    color: var(--p-text-muted-color);
    margin-bottom: 0.5rem;
}

.dashboard__chart-wrapper {
    position: relative;
    height: 220px;
}

.dashboard__chart-wrapper :deep(canvas) {
    max-width: 100% !important;
}

.dashboard__footer {
    margin-top: 0.75rem;
}

.dashboard__last-trained {
    font-size: 0.75rem;
    color: var(--p-text-muted-color);
    margin-bottom: 0.5rem;
}

.dashboard__history-toggle {
    display: flex;
    align-items: center;
    gap: 4px;
    background: none;
    border: none;
    padding: 0;
    cursor: pointer;
    font-size: 0.7rem;
    font-weight: 600;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    color: var(--p-text-muted-color);
    width: 100%;
}

.dashboard__history {
    margin-top: 0.5rem;
}

.dashboard__history-header,
.dashboard__history-row {
    display: grid;
    grid-template-columns: 2fr 3fr;
    gap: 0.25rem;
    padding: 4px 0;
    font-size: 0.75rem;
}

.dashboard__history-sets {
    display: flex;
    flex-direction: column;
    gap: 1px;
}

.dashboard__history-set {
    display: flex;
    align-items: center;
    gap: 8px;
}

.dashboard__set-badge {
    font-size: 0.65rem;
    font-weight: 600;
    color: var(--p-text-muted-color);
    background: var(--p-content-border-color);
    border-radius: 4px;
    padding: 1px 4px;
}

.dashboard__history-header {
    color: var(--p-text-muted-color);
    border-bottom: 1px solid var(--p-content-border-color);
    padding-bottom: 4px;
    margin-bottom: 2px;
}

.dashboard__history-row + .dashboard__history-row {
    border-top: 1px solid var(--p-content-border-color);
}
</style>
