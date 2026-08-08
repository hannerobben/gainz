<script setup lang="ts">
import {ref, computed, onMounted, reactive, watch} from 'vue';
import {useUsersStore} from '../stores/users.store.ts';
import {WorkoutApi, type ExerciseProgression} from '../supabase/workout.api.ts';
import ExerciseCardStats from './ExerciseCardStats.vue';
import dayjs from 'dayjs';
import {ChevronDown, ChevronUp} from 'lucide-vue-next';

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

function formatSets(sets: {load: number; reps: number}[], isBodyweight: boolean): {text: string; badge: number | null}[] {
    if (sets.length === 0) return [];
    const groups: {text: string; count: number}[] = [];
    for (const set of sets) {
        const text = isBodyweight ? `${set.reps} reps` : `${set.load} kg × ${set.reps}`;
        const last = groups[groups.length - 1];
        if (last && last.text === text) {
            last.count++;
        } else {
            groups.push({text, count: 1});
        }
    }
    return groups.map(g => ({text: g.text, badge: g.count > 1 ? g.count : null}));
}

const CATEGORY_COLORS: Record<string, string> = {
    push: '#4A7FC1',
    pull: '#5A9E5A',
    legs: '#C17A30',
    core: '#ddb160'
};

function categoryLabel(cat: string): string {
    const prefix = cat === 'push' || cat === 'pull' ? 'Arms: ' : '';
    return prefix + cat.charAt(0).toUpperCase() + cat.slice(1);
}

const varietyChartData = computed(() => {
    const counts = new Map<string, number>();
    for (const p of progressions.value) {
        counts.set(p.category, (counts.get(p.category) ?? 0) + 1);
    }
    const sorted = [...counts.entries()].sort((a, b) => b[1] - a[1]);
    return {
        labels: sorted.map(([cat]) => categoryLabel(cat)),
        datasets: [{
            data: sorted.map(([, count]) => count),
            backgroundColor: sorted.map(([cat]) => CATEGORY_COLORS[cat] ?? '#999'),
            borderWidth: 0
        }]
    };
});

const varietyChartOptions = {
    responsive: true,
    maintainAspectRatio: false,
    cutout: '65%',
    plugins: {
        legend: {
            position: 'right' as const,
            labels: {color: '#ffffff', font: {size: 12}, padding: 12, boxWidth: 12}
        },
        tooltip: {
            callbacks: {
                label: (ctx: {parsed: number}) => ` ${ctx.parsed} exercises`
            }
        }
    }
};

async function load() {
    if (!usersStore.activeUser) return;
    loading.value = true;
    const result = await WorkoutApi.getStrengthProgression(usersStore.activeUser.id);
    progressions.value = result.sort((a, b) => b.dataPoints.length - a.dataPoints.length);
    loading.value = false;
}

onMounted(load);
watch(() => usersStore.activeUser?.id, load);

function chartData(progression: ExerciseProgression) {
    return {
        labels: progression.dataPoints.map(p => p.date),
        datasets: [{
            label: 'e1RM (kg)',
            data: progression.dataPoints.map(p => p.e1rm),
            borderColor: '#C17A30',
            pointBackgroundColor: '#C17A30',
            fill: false,
            tension: 0.3,
            pointRadius: 4,
        }],
    };
}

function chartOptions(isBodyweight: boolean) {
    return {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: {display: false},
            tooltip: {
                callbacks: {
                    label: (ctx: {parsed: {y: number}}) =>
                        isBodyweight ? `${ctx.parsed.y} reps` : `${ctx.parsed.y} kg`,
                },
            },
        },
        scales: {
            x: {grid: {display: false}},
            y: {
                title: {display: true, text: isBodyweight ? 'Max Reps' : 'e1RM (kg)'},
                ticks: {callback: (v: number) => isBodyweight ? `${v}` : `${v} kg`},
            },
        },
    };
}
</script>

<template>
    <div v-if="loading" class="state-msg">Loading progression data…</div>

    <div v-else-if="progressions.length === 0" class="state-msg">
        No strength workouts logged yet. Start tracking to see your progression.
    </div>

    <template v-else>
        <div class="variety-card">
            <div class="variety-card__label">Exercise Variety</div>
            <div class="variety-card__total">{{ progressions.length }} exercises trained</div>
            <div class="variety-card__chart">
                <Chart type="doughnut" :data="varietyChartData" :options="varietyChartOptions" />
            </div>
        </div>

        <div class="grid">
            <Card v-for="progression in progressions" :key="progression.exerciseId">
                <template #title>
                    <div class="card-title">
                        <span>{{ progression.exerciseName }}</span>
                        <span class="pr-badge">PR {{ progression.allTimePr.label }}</span>
                    </div>
                </template>
                <template #content>
                    <ExerciseCardStats :progression="progression" />
                    <div class="chart-heading">Estimated 1RM Evolution</div>
                    <div class="chart-wrapper">
                        <Chart type="line" :data="chartData(progression)" :options="chartOptions(progression.isBodyweight)" />
                    </div>

                    <div class="footer">
                        <div class="last-trained">Last trained: {{ daysAgoLabel(progression.lastTrained) }}</div>
                        <button class="history-toggle" @click="toggleHistory(progression.exerciseId)">
                            <span>Training History</span>
                            <ChevronUp v-if="expandedHistory[progression.exerciseId]" :size="14" />
                            <ChevronDown v-else :size="14" />
                        </button>
                        <div v-if="expandedHistory[progression.exerciseId]" class="history">
                            <div class="history-header">
                                <span>Date</span>
                                <span>Sets</span>
                            </div>
                            <div
                                v-for="dp in [...progression.dataPoints].reverse()"
                                :key="dp.date"
                                class="history-row"
                            >
                                <span>{{ formatDate(dp.date) }}</span>
                                <div class="history-sets">
                                    <div v-for="(set, i) in formatSets(dp.sets, progression.isBodyweight)" :key="i" class="history-set">
                                        <span>{{ set.text }}</span>
                                        <span v-if="set.badge" class="set-badge">×{{ set.badge }}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </template>
            </Card>
        </div>
    </template>
</template>

<style scoped>
.state-msg {
    color: var(--p-text-muted-color);
    text-align: center;
    padding: 3rem 0;
}

.variety-card {
    background: #0a0d2e;
    border-radius: 12px;
    padding: 16px;
    color: #ffffff;
    margin-bottom: 1rem;
}

.variety-card__label {
    font-size: 0.7rem;
    font-weight: 600;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    color: rgba(255, 255, 255, 0.5);
    margin-bottom: 2px;
}

.variety-card__total {
    font-size: 1.2rem;
    font-weight: 700;
    margin-bottom: 12px;
}

.variety-card__chart {
    position: relative;
    height: 160px;
}

.grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 12px;
}

.chart-heading {
    font-size: 0.7rem;
    font-weight: 600;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    color: var(--p-text-muted-color);
    margin-bottom: 0.5rem;
}

.chart-wrapper {
    position: relative;
    padding-bottom: 20px;
}

.chart-wrapper :deep(canvas) {
    max-width: 100% !important;
}

.footer {
    border: none;
}

.last-trained {
    font-size: 0.75rem;
    color: var(--p-text-muted-color);
    margin-bottom: 0.5rem;
  margin-top: 10px;
}

.history-toggle {
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

.history {
    margin-top: 0.5rem;
}

.history-header,
.history-row {
    display: grid;
    grid-template-columns: 2fr 3fr;
    gap: 0.25rem;
    padding: 4px 0;
    font-size: 0.75rem;
}

.history-sets {
    display: flex;
    flex-direction: column;
    gap: 1px;
}

.history-set {
    display: flex;
    align-items: center;
    gap: 8px;
}

.set-badge {
    font-size: 0.65rem;
    font-weight: 600;
    color: var(--p-text-muted-color);
    background: var(--p-content-border-color);
    border-radius: 4px;
    padding: 1px 4px;
}

.history-header {
    color: var(--p-text-muted-color);
    border-bottom: 1px solid var(--p-content-border-color);
    padding-bottom: 4px;
    margin-bottom: 2px;
}

.history-row + .history-row {
    border-top: 1px solid var(--p-content-border-color);
}

.card-title {
    display: flex;
    align-items: center;
    justify-content: space-between;
    width: 100%;
}

.pr-badge {
    font-size: 0.65rem;
    font-weight: 700;
    letter-spacing: 0.06em;
    text-transform: uppercase;
    color: #C17A30;
    background: rgba(201, 168, 76, 0.12);
    border: 1px solid rgba(201, 168, 76, 0.35);
    border-radius: 999px;
    padding: 2px 8px;
    white-space: nowrap;
}
</style>
