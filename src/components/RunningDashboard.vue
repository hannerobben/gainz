<script setup lang="ts">
import {ref, computed, onMounted, watch} from 'vue';
import {Crown} from 'lucide-vue-next';
import {SECONDARY_COLOR} from '../colors.ts';
import {useUsersStore} from '../stores/users.store.ts';
import {RunsApi} from '../supabase/runs.api.ts';
import dayjs from 'dayjs';

const usersStore = useUsersStore();

type RunEntry = {date: string; duration: number; seconds: number; distance: number};

const runs = ref<RunEntry[]>([]);
const loading = ref(true);

async function load() {
    if (!usersStore.activeUser) return;
    loading.value = true;
    runs.value = await RunsApi.getAll(usersStore.activeUser.id);
    loading.value = false;
}

onMounted(load);
watch(() => usersStore.activeUser?.id, load);

const totalDistance = computed(() =>
    Math.round(runs.value.reduce((sum, r) => sum + r.distance, 0) * 10) / 10
);

function totalMinutes(r: RunEntry): number {
    return r.duration + r.seconds / 60;
}

const avgPace = computed(() => {
    if (runs.value.length === 0) return null;
    const totalMins = runs.value.reduce((sum, r) => sum + totalMinutes(r), 0);
    const totalKm = runs.value.reduce((sum, r) => sum + r.distance, 0);
    if (totalKm === 0) return null;
    const paceMin = totalMins / totalKm;
    const mins = Math.floor(paceMin);
    const secs = Math.round((paceMin - mins) * 60);
    return `${mins}:${String(secs).padStart(2, '0')}`;
});

const summaryChartData = computed(() => ({
    labels: runs.value.map(r => r.date),
    datasets: [{
        label: 'Distance (km)',
        data: runs.value.map(r => r.distance),
        borderColor: SECONDARY_COLOR,
        pointBackgroundColor: SECONDARY_COLOR,
        fill: false,
        tension: 0.3,
        pointRadius: 3,
    }],
}));

const summaryChartOptions = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
        legend: {display: false},
        tooltip: {
            callbacks: {
                label: (ctx: {parsed: {y: number}}) => ` ${ctx.parsed.y} km`,
            },
        },
    },
    scales: {
        x: {display: false},
        y: {
            grid: {color: 'rgba(255,255,255,0.1)'},
            ticks: {color: 'rgba(255,255,255,0.6)', callback: (v: number) => `${parseFloat(v.toFixed(1))} km`},
            border: {display: false},
        },
    },
};

function formatRaceTime(minutes: number): string {
    const h = Math.floor(minutes / 60);
    const m = Math.floor(minutes % 60);
    const s = Math.round((minutes - Math.floor(minutes)) * 60);
    if (h > 0) return `${h}:${String(m).padStart(2, '0')}:${String(s).padStart(2, '0')}`;
    return `${m}:${String(s).padStart(2, '0')}`;
}

const best5k = computed(() => {
    const eligible = runs.value.filter(r => r.distance >= 5);
    if (eligible.length === 0) return null;
    const best = eligible.reduce((b, r) => (totalMinutes(r) / r.distance) < (totalMinutes(b) / b.distance) ? r : b);
    return formatRaceTime((totalMinutes(best) / best.distance) * 5);
});

const best10k = computed(() => {
    const eligible = runs.value.filter(r => r.distance >= 10);
    if (eligible.length === 0) return null;
    const best = eligible.reduce((b, r) => (totalMinutes(r) / r.distance) < (totalMinutes(b) / b.distance) ? r : b);
    return formatRaceTime((totalMinutes(best) / best.distance) * 10);
});

const longestRun = computed(() => {
    if (runs.value.length === 0) return null;
    return Math.max(...runs.value.map(r => r.distance));
});

const bestWeek = computed(() => {
    if (runs.value.length === 0) return null;
    const weekMap = new Map<string, number>();
    for (const r of runs.value) {
        const key = dayjs(r.date).startOf('week').format('YYYY-MM-DD');
        weekMap.set(key, (weekMap.get(key) ?? 0) + r.distance);
    }
    return Math.round(Math.max(...weekMap.values()) * 10) / 10;
});

const weeklyDistance = computed(() => {
    if (runs.value.length === 0) return null;
    const weekMap = new Map<string, number>();
    for (const r of runs.value) {
        const key = dayjs(r.date).startOf('week').format('YYYY-MM-DD');
        weekMap.set(key, (weekMap.get(key) ?? 0) + r.distance);
    }
    const total = [...weekMap.values()].reduce((sum, d) => sum + d, 0);
    return Math.round((total / weekMap.size) * 10) / 10;
});

const runsPerWeek = computed(() => {
    if (runs.value.length === 0) return null;
    if (runs.value.length === 1) return 1;
    const first = dayjs(runs.value[0].date);
    const last = dayjs(runs.value[runs.value.length - 1].date);
    const weeks = Math.max(1, last.diff(first, 'week') + 1);
    return Math.round((runs.value.length / weeks) * 10) / 10;
});

const weeklyBarData = computed(() => {
    const weekMap = new Map<string, number>();
    for (const r of runs.value) {
        const key = dayjs(r.date).startOf('week').format('YYYY-MM-DD');
        weekMap.set(key, Math.round(((weekMap.get(key) ?? 0) + r.distance) * 10) / 10);
    }
    const sorted = [...weekMap.keys()].sort();
    const entries: [string, number][] = [];
    let current = dayjs(sorted[0]).startOf('week');
    const lastRun = dayjs(sorted[sorted.length - 1]).startOf('week');
    const thisWeek = dayjs().startOf('week');
    const last = lastRun.isAfter(thisWeek) ? lastRun : thisWeek;
    while (!current.isAfter(last)) {
        const key = current.format('YYYY-MM-DD');
        entries.push([key, weekMap.get(key) ?? 0]);
        current = current.add(1, 'week');
    }
    if (entries.length > 30) entries.splice(0, entries.length - 30);
    return {
        labels: entries.map(([k]) => dayjs(k).format('MMM D')),
        datasets: [{
            data: entries.map(([, v]) => v),
            backgroundColor: SECONDARY_COLOR,
            borderRadius: 4,
            borderSkipped: false,
        }],
    };
});

const weeklyBarOptions = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
        legend: {display: false},
        tooltip: {
            callbacks: {
                label: (ctx: {parsed: {y: number}}) => ` ${ctx.parsed.y} km`,
            },
        },
    },
    scales: {
        x: {grid: {display: false}, ticks: {font: {size: 10}}},
        y: {
            grid: {color: '#f0f0f0'},
            ticks: {callback: (v: number) => `${v}`, font: {size: 10}},
            border: {display: false},
        },
    },
};

function formatDate(date: string): string {
    return dayjs(date).format('MMM D, YYYY');
}

function formatDuration(run: RunEntry): string {
    const totalSecs = run.duration * 60 + run.seconds;
    const h = Math.floor(totalSecs / 3600);
    const m = Math.floor((totalSecs % 3600) / 60);
    const s = totalSecs % 60;
    if (h > 0) return `${h}:${String(m).padStart(2, '0')}:${String(s).padStart(2, '0')}`;
    return `${m}:${String(s).padStart(2, '0')}`;
}

function pace(run: RunEntry): string {
    if (run.distance === 0) return '—';
    const paceMin = totalMinutes(run) / run.distance;
    const mins = Math.floor(paceMin);
    const secs = Math.round((paceMin - mins) * 60);
    return `${mins}:${String(secs).padStart(2, '0')} /km`;
}

const scatterChartData = computed(() => {
    const points = runs.value
        .filter(r => totalMinutes(r) > 0 && r.distance > 0)
        .map(r => ({
            x: r.distance,
            y: Math.round((r.distance / totalMinutes(r)) * 60 * 10) / 10,
            date: r.date,
        }));

    const datasets: object[] = [{
        data: points,
        backgroundColor: SECONDARY_COLOR,
        pointRadius: 5,
        pointHoverRadius: 7,
    }];

    if (points.length >= 2) {
        const n = points.length;
        const sumX = points.reduce((s, p) => s + p.x, 0);
        const sumY = points.reduce((s, p) => s + p.y, 0);
        const sumXY = points.reduce((s, p) => s + p.x * p.y, 0);
        const sumX2 = points.reduce((s, p) => s + p.x * p.x, 0);
        const m = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
        const b = (sumY - m * sumX) / n;
        const xs = points.map(p => p.x);
        const minX = Math.min(...xs);
        const maxX = Math.max(...xs);
        datasets.push({
            data: [{x: minX, y: m * minX + b}, {x: maxX, y: m * maxX + b}],
            showLine: true,
            borderColor: 'rgba(193, 122, 48, 0.45)',
            borderWidth: 2,
            borderDash: [5, 5],
            pointRadius: 0,
            fill: false,
            tension: 0,
        });
    }

    return {datasets};
});

const scatterChartOptions = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
        legend: {display: false},
        tooltip: {
            filter: (item: {datasetIndex: number}) => item.datasetIndex === 0,
            callbacks: {
                label: (ctx: {raw: {x: number; y: number; date: string}}) =>
                    ` ${dayjs(ctx.raw.date).format('MMM D')} · ${ctx.raw.x} km · ${ctx.raw.y} km/h`,
            },
        },
    },
    scales: {
        x: {
            grid: {color: '#f0f0f0'},
            ticks: {font: {size: 10}, callback: (v: number) => `${v} km`},
            border: {display: false},
        },
        y: {
            grid: {color: '#f0f0f0'},
            ticks: {font: {size: 10}, callback: (v: number) => `${v}`},
            border: {display: false},
        },
    },
};
</script>

<template>
    <div v-if="loading" class="state-msg">Loading run data…</div>

    <div v-else-if="runs.length === 0" class="state-msg">
        No runs logged yet. Start tracking to see your progress.
    </div>

    <template v-else>
        <div class="summary-card">
            <div class="summary-card__stats">
                <div class="summary-card__stat">
                    <span class="summary-card__label">Distance</span>
                    <span class="summary-card__value">{{ totalDistance }} <span class="summary-card__unit">km</span></span>
                </div>
                <div class="summary-card__stat">
                    <span class="summary-card__label">Avg Pace</span>
                    <span class="summary-card__value">{{ avgPace }} <span class="summary-card__unit">/km</span></span>
                </div>
                <div class="summary-card__stat">
                    <span class="summary-card__label">Runs</span>
                    <span class="summary-card__value">{{ runs.length }}</span>
                </div>
            </div>
            <div class="summary-card__chart">
                <Chart type="line" :data="summaryChartData" :options="summaryChartOptions" />
            </div>
        </div>

        <div class="metrics-card">
            <div class="metrics-section">
                <div class="metrics-section__heading">
                    <Crown :size="16" :color="SECONDARY_COLOR" />
                    <span>Records</span>
                </div>
                <div class="metrics-section__items">
                    <div class="metrics-item">
                        <span class="metrics-item__label">Best 5K</span>
                        <span class="metrics-item__value">{{ best5k ?? '—' }}</span>
                    </div>
                    <div class="metrics-item">
                        <span class="metrics-item__label">Best 10K</span>
                        <span class="metrics-item__value">{{ best10k ?? '—' }}</span>
                    </div>
                    <div class="metrics-item">
                        <span class="metrics-item__label">Longest run</span>
                        <span class="metrics-item__value">{{ longestRun ?? '—' }}<span v-if="longestRun" class="metrics-item__unit"> km</span></span>
                    </div>
                    <div class="metrics-item">
                        <span class="metrics-item__label">Best week</span>
                        <span class="metrics-item__value">{{ bestWeek ?? '—' }}<span v-if="bestWeek" class="metrics-item__unit"> km</span></span>
                    </div>
                </div>
            </div>
        </div>

        <div class="weekly-chart-card">
            <div class="weekly-chart-card__heading">Distance per week</div>
            <div class="weekly-chart-card__chart">
                <Chart type="bar" :data="weeklyBarData" :options="weeklyBarOptions" />
            </div>
        </div>

        <div class="metrics-card">
            <div class="metrics-section">
                <div class="metrics-section__heading metrics-section__heading--muted">
                    <span>Averages</span>
                </div>
                <div class="metrics-section__items">
                    <div class="metrics-item">
                        <span class="metrics-item__label">Weekly distance</span>
                        <span class="metrics-item__value">{{ weeklyDistance ?? '—' }}<span v-if="weeklyDistance" class="metrics-item__unit"> km</span></span>
                    </div>
                    <div class="metrics-item">
                        <span class="metrics-item__label">Runs / week</span>
                        <span class="metrics-item__value">{{ runsPerWeek ?? '—' }}</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="scatter-card">
            <div class="scatter-card__heading">Distance vs Speed</div>
            <div class="scatter-card__chart">
                <Chart type="scatter" :data="scatterChartData" :options="scatterChartOptions" />
            </div>
        </div>

        <div class="run-list">
            <div class="run-list__header">
                <span>Date</span>
                <span>KM</span>
                <span>Time</span>
                <span>Pace</span>
            </div>
            <div v-for="run in [...runs].reverse()" :key="run.date" class="run-list__row">
                <span>{{ formatDate(run.date) }}</span>
                <span>{{ run.distance }} km</span>
                <span>{{ formatDuration(run) }}</span>
                <span>{{ pace(run) }}</span>
            </div>
        </div>
    </template>
</template>

<style scoped>
.state-msg {
    color: var(--p-text-muted-color);
    text-align: center;
    padding: 3rem 0;
}

.summary-card {
    background: var(--primary-color);
    border-radius: 12px;
    padding: 16px;
    color: #ffffff;
    margin-bottom: 1rem;
}

.summary-card__stats {
    display: flex;
    gap: 24px;
    margin-bottom: 16px;
    justify-content: space-between;
}

.summary-card__stat {
    display: flex;
    flex-direction: column;
    gap: 2px;
}

.summary-card__label {
    font-size: 0.7rem;
    font-weight: 600;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    color: rgba(255, 255, 255, 0.5);
}

.summary-card__value {
    font-size: 1.2rem;
    font-weight: 700;
}

.summary-card__unit {
    font-size: 0.85rem;
    font-weight: 400;
    color: rgba(255, 255, 255, 0.6);
}

.summary-card__chart {
    position: relative;
    height: 160px;
}

.scatter-card {
    background: var(--p-card-background);
    border-radius: 12px;
    border: 1px solid var(--p-content-border-color);
    padding: 12px 14px 14px;
    margin-bottom: 12px;
}

.scatter-card__heading {
    font-size: 0.85rem;
    font-weight: 700;
    letter-spacing: 0.1em;
    text-transform: uppercase;
    color: var(--p-text-muted-color);
    margin-bottom: 10px;
}

.scatter-card__chart {
    position: relative;
    height: 180px;
}

.weekly-chart-card {
    background: var(--p-card-background);
    border-radius: 12px;
    border: 1px solid var(--p-content-border-color);
    padding: 12px 14px 14px;
    margin-bottom: 12px;
}

.weekly-chart-card__heading {
    font-size: 0.85rem;
    font-weight: 700;
    letter-spacing: 0.1em;
    text-transform: uppercase;
    color: var(--p-text-muted-color);
    margin-bottom: 10px;
}

.weekly-chart-card__chart {
    position: relative;
    height: 140px;
}

.metrics-card {
    border-radius: 12px;
    border: 1px solid var(--p-content-border-color);
    overflow: hidden;
    margin-bottom: 12px;
}

.metrics-section {
    padding: 12px 14px;
    background: var(--p-card-background);
}

.metrics-section__heading {
    display: flex;
    align-items: center;
    gap: 5px;
    font-size: 0.85rem;
    font-weight: 700;
    letter-spacing: 0.1em;
    text-transform: uppercase;
    color: var(--secondary-color);
    margin-bottom: 10px;
}

.metrics-section__heading--muted {
    color: var(--p-text-muted-color);
}

.metrics-section__items {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 8px;
}

.metrics-item {
    display: flex;
    flex-direction: column;
    gap: 1px;
    padding: 4px 8px;
    background: #f6f6f6;
    border-radius: 6px;
}

.metrics-item__label {
    font-size: 0.75rem;
    color: var(--p-text-muted-color);
}

.metrics-item__value {
    font-size: 1.5rem;
    font-weight: 700;
    color: var(--primary-color);
}

.metrics-item__unit {
    font-size: 0.8rem;
    font-weight: 400;
    color: var(--p-text-muted-color);
}

.run-list {
    background: var(--p-card-background);
    border-radius: 12px;
    border: 1px solid var(--p-content-border-color);
    overflow: hidden;
}

.run-list__header,
.run-list__row {
    display: grid;
    grid-template-columns: 2fr 1fr 1fr 1.5fr;
    gap: 0.5rem;
    padding: 8px 12px;
    font-size: 0.75rem;
}

.run-list__header {
    font-size: 0.7rem;
    font-weight: 600;
    letter-spacing: 0.06em;
    text-transform: uppercase;
    color: var(--p-text-muted-color);
    border-bottom: 1px solid var(--p-content-border-color);
}

.run-list__row + .run-list__row {
    border-top: 1px solid var(--p-content-border-color);
}
</style>
