<script setup lang="ts">
import {ref, computed, onMounted, reactive, watch} from 'vue';
import {useUsersStore} from '../stores/users.store.ts';
import {SECONDARY_COLOR} from '../colors.ts';
import {WorkoutApi, type ExerciseProgression} from '../supabase/workout.api.ts';
import ExerciseCardStats from './ExerciseCardStats.vue';
import dayjs from 'dayjs';
import {ChevronDown, ChevronUp, ChevronRight, Info} from 'lucide-vue-next';

const usersStore = useUsersStore();

const progressions = ref<ExerciseProgression[]>([]);
const loading = ref(true);
const expandedHistory = reactive<Record<string, boolean>>({});
const collapsedCards = reactive<Record<string, boolean>>({});

function toggleHistory(id: string) {
    expandedHistory[id] = !expandedHistory[id];
}

function toggleCard(id: string) {
    collapsedCards[id] = !collapsedCards[id];
}

function expandAll() {
    for (const p of progressions.value) collapsedCards[p.exerciseId] = false;
}

function collapseAll() {
    for (const p of progressions.value) collapsedCards[p.exerciseId] = true;
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
    legs: SECONDARY_COLOR,
    core: '#ddb160'
};

function categoryLabel(cat: string): string {
    const prefix = cat === 'push' || cat === 'pull' ? 'Arms: ' : '';
    return prefix + cat.charAt(0).toUpperCase() + cat.slice(1);
}

const trainingStats = computed(() => {
    const allDates = new Set<string>();
    for (const p of progressions.value) {
        for (const dp of p.dataPoints) allDates.add(dp.date);
    }
    const daysTrained = allDates.size;
    const weeks = new Set([...allDates].map(d => dayjs(d).startOf('week').format('YYYY-MM-DD')));
    const weeksTrained = weeks.size;
    const avgPerWeek = weeksTrained > 0 ? +(daysTrained / weeksTrained).toFixed(1) : 0;
    return {weeksTrained, daysTrained, avgPerWeek};
});

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
            position: 'left' as const,
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

const strengthTrend = computed(() => {
    const changes: number[] = [];
    for (const p of progressions.value) {
        if (p.isBodyweight || p.dataPoints.length < 2) continue;
        const first = p.dataPoints[0].e1rm;
        const last = p.dataPoints[p.dataPoints.length - 1].e1rm;
        if (first > 0) changes.push((last - first) / first * 100);
    }
    if (changes.length === 0) return null;
    return changes.reduce((a, b) => a + b, 0) / changes.length;
});

const atPrCount = computed(() => {
    let count = 0;
    for (const p of progressions.value) {
        if (p.dataPoints.length === 0) continue;
        const max = Math.max(...p.dataPoints.map(dp => dp.e1rm));
        if (p.dataPoints[p.dataPoints.length - 1].e1rm >= max) count++;
    }
    return count;
});

const volumeTrend = computed(() => {
    const volumeByDate = new Map<string, number>();
    for (const p of progressions.value) {
        for (const dp of p.dataPoints) {
            const vol = dp.sets.reduce((sum, s) => sum + (s.load ?? 0) * (s.reps ?? 0), 0);
            volumeByDate.set(dp.date, (volumeByDate.get(dp.date) ?? 0) + vol);
        }
    }
    const sorted = [...volumeByDate.entries()].sort((a, b) => a[0].localeCompare(b[0]));
    if (sorted.length < 5) return null;
    const recent = sorted.slice(-4);
    const prev = sorted.slice(-8, -4);
    if (prev.length === 0) return null;
    const recentAvg = recent.reduce((s, [, v]) => s + v, 0) / recent.length;
    const prevAvg = prev.reduce((s, [, v]) => s + v, 0) / prev.length;
    if (prevAvg === 0) return null;
    return (recentAvg - prevAvg) / prevAvg * 100;
});

function formatTrend(val: number | null): string {
    if (val === null) return '—';
    const sign = val >= 0 ? '+' : '';
    return `${sign}${val.toFixed(1)}%`;
}

function trendClass(val: number | null): string {
    if (val === null || val === 0) return '';
    return val > 0 ? 'trend-up' : 'trend-down';
}

function chartData(progression: ExerciseProgression) {
    return {
        labels: progression.dataPoints.map(p => p.date),
        datasets: [{
            label: 'e1RM (kg)',
            data: progression.dataPoints.map(p => p.e1rm),
            borderColor: SECONDARY_COLOR,
            pointBackgroundColor: SECONDARY_COLOR,
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

            <div class="variety-card__stats">
                <div class="variety-stat">
                    <span class="variety-stat__label">Weeks trained</span>
                    <span class="variety-stat__value">{{ trainingStats.weeksTrained }}</span>
                </div>
                <div class="variety-stat">
                    <span class="variety-stat__label">Days trained</span>
                    <span class="variety-stat__value">{{ trainingStats.daysTrained }}</span>
                </div>
                <div class="variety-stat">
                    <span class="variety-stat__label">Avg / week</span>
                    <span class="variety-stat__value">{{ trainingStats.avgPerWeek }}</span>
                </div>
            </div>
          <div class="variety-card__label">Exercise Variety</div>
            <div class="variety-card__chart">
                <Chart type="doughnut" :data="varietyChartData" :options="varietyChartOptions" :height="120"/>
            </div>
        </div>

        <div class="progress-card">
            <div class="progress-card__label">Progress Snapshot</div>
            <div class="progress-stats">
                <div class="progress-stat-row">
                    <span class="progress-stat-label">
                        Strength trend
                        <Info :size="14" class="metric-info" v-tooltip.top="'Average % change in estimated 1RM from your first to your latest session, across all weighted exercises with at least 2 sessions.'" />
                    </span>
                    <span class="progress-stat-value" :class="trendClass(strengthTrend)">{{ formatTrend(strengthTrend) }}</span>
                </div>
                <div class="progress-stat-row">
                    <span class="progress-stat-label">
                        At PR
                        <Info :size="14" class="metric-info" v-tooltip.top="'Number of exercises where your most recent session equals your all-time best estimated 1RM.'" />
                    </span>
                    <span class="progress-stat-value">{{ atPrCount }} / {{ progressions.length }}</span>
                </div>
                <div class="progress-stat-row">
                    <span class="progress-stat-label">
                        Volume trend
                        <Info :size="14" class="metric-info" v-tooltip.top="'Compares average total training volume (load × reps across all exercises) of your last 4 sessions vs the 4 before that.'" />
                    </span>
                    <span class="progress-stat-value" :class="trendClass(volumeTrend)">{{ formatTrend(volumeTrend) }}</span>
                </div>
            </div>
        </div>

        <div class="exercises-header">
            <span class="exercises-title">Exercises</span>
            <div class="exercises-actions">
                <button class="action-btn" @click="expandAll">Expand all</button>
                <span class="actions-divider">|</span>
                <button class="action-btn" @click="collapseAll">Collapse all</button>
            </div>
        </div>

        <div class="grid">
            <Card v-for="progression in progressions" :key="progression.exerciseId" :class="{'card-collapsed': collapsedCards[progression.exerciseId]}">
                <template #title>
                    <div class="card-title" @click="toggleCard(progression.exerciseId)">
                        <div class="card-title-left">
                            <ChevronRight v-if="collapsedCards[progression.exerciseId]" :size="16" class="card-chevron" />
                            <ChevronDown v-else :size="16" class="card-chevron" />
                            <span>{{ progression.exerciseName }}</span>
                        </div>
                        <span class="pr-badge">PR {{ progression.allTimePr.label }}</span>
                    </div>
                </template>
                <template #content>
                    <div v-if="!collapsedCards[progression.exerciseId]">
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
    background: var(--primary-color);
    border-radius: 12px;
    padding: 16px;
    color: #ffffff;
    margin-bottom: 8px;
}

.variety-card__label {
    font-size: 0.7rem;
    font-weight: 600;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    color: rgba(255, 255, 255, 0.5);
    margin-bottom: 8px;
    border-top: 1px solid #343434;
    padding-top: 14px;
}

.variety-card__stats {
    display: flex;
    gap: 24px;
    justify-content: space-between;
    margin-bottom: 10px;
}

.variety-stat {
    display: flex;
    flex-direction: column;
    gap: 2px;
}

.variety-stat__label {
    font-size: 0.7rem;
    font-weight: 600;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    color: rgba(255, 255, 255, 0.5);
}

.variety-stat__value {
    font-size: 1.2rem;
    font-weight: 700;
    color: #ffffff;
}

.variety-card__chart {
    position: relative;
    height: 120px;
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

.progress-card {
    background: var(--p-card-background);
    border: 1px solid var(--p-content-border-color);
    border-radius: 12px;
    padding: 16px;
    margin-bottom: 1rem;
}

.progress-card__label {
    font-size: 0.7rem;
    font-weight: 600;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    color: var(--p-text-muted-color);
    margin-bottom: 12px;
}

.progress-stats {
    display: flex;
    flex-direction: column;
    gap: 0;
}

.progress-stat-row + .progress-stat-row {
    border-top: 1px solid var(--p-content-border-color);
    margin-top: 8px;
    padding-top: 8px;
}

.progress-stat-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.progress-stat-label {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 0.85rem;
    color: var(--p-text-color);
}

.progress-stat-value {
    font-size: 0.85rem;
    font-weight: 700;
}

.trend-up {
    color: #6fcf97;
}

.trend-down {
    color: #eb5757;
}

.metric-info {
    color: var(--p-text-muted-color);
    cursor: default;
    opacity: 0.6;
}

.exercises-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 8px;
}

.exercises-title {
    font-size: 0.7rem;
    font-weight: 600;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    color: var(--p-text-muted-color);
}

.exercises-actions {
    display: flex;
    align-items: center;
    gap: 8px;
}

.actions-divider {
    color: var(--p-text-muted-color);
    font-size: 0.7rem;
    opacity: 0.4;
}

.action-btn {
    background: none;
    border: none;
    padding: 0;
    cursor: pointer;
    font-size: 0.7rem;
    font-weight: 600;
    letter-spacing: 0.06em;
    text-transform: lowercase;
    color: #afafaf;
}

.card-title {
    display: flex;
    align-items: center;
    justify-content: space-between;
    width: 100%;
    cursor: pointer;
    user-select: none;
}

.card-title-left {
    display: flex;
    align-items: center;
    gap: 6px;
}

.card-chevron {
    flex-shrink: 0;
    color: var(--p-text-muted-color);
}

:deep(.card-collapsed .p-card-body) {
    gap: 0 !important;
}

.pr-badge {
    font-size: 0.65rem;
    font-weight: 700;
    letter-spacing: 0.06em;
    text-transform: uppercase;
    color: var(--secondary-color);
    background: rgba(201, 168, 76, 0.12);
    border: 1px solid rgba(201, 168, 76, 0.35);
    border-radius: 999px;
    padding: 2px 8px;
    white-space: nowrap;
}
</style>
