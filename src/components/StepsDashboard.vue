<script setup lang="ts">
import {ref, computed, onMounted, watch} from 'vue';
import {ChevronLeft, ChevronRight} from 'lucide-vue-next';
import {SECONDARY_COLOR} from '../colors.ts';
import {useUsersStore} from '../stores/users.store.ts';
import {WalksApi} from '../supabase/walks.api.ts';
import dayjs from 'dayjs';

const usersStore = useUsersStore();

const currentYear = new Date().getFullYear();
const selectedYear = ref(currentYear);

const stepsData = ref<{date: string; stepCount: number}[]>([]);
const loading = ref(true);

async function load() {
    if (!usersStore.activeUser) return;
    loading.value = true;
    stepsData.value = await WalksApi.getDates(usersStore.activeUser.id, selectedYear.value);
    loading.value = false;
}

onMounted(load);
watch(selectedYear, load);
watch(() => usersStore.activeUser?.id, load);

const dateRange = computed(() => {
    const start = dayjs(`${selectedYear.value}-01-01`);
    const end =
        selectedYear.value === currentYear
            ? dayjs()
            : dayjs(`${selectedYear.value}-12-31`);
    const dates: string[] = [];
    let cur = start;
    while (cur.isBefore(end) || cur.isSame(end, 'day')) {
        dates.push(cur.format('YYYY-MM-DD'));
        cur = cur.add(1, 'day');
    }
    return dates;
});

const stepMap = computed(() => new Map(stepsData.value.map(s => [s.date, s.stepCount])));

const dailySteps = computed(() => dateRange.value.map(d => stepMap.value.get(d) ?? 0));

const daysLogged = computed(() => stepsData.value.filter(s => s.stepCount > 0).length);

const avgSteps = computed(() => {
    if (daysLogged.value === 0) return null;
    const total = stepsData.value.reduce((sum, s) => sum + s.stepCount, 0);
    return Math.round(total / daysLogged.value);
});

const bestDay = computed(() =>
    stepsData.value.length === 0 ? null : Math.max(...stepsData.value.map(s => s.stepCount))
);

const goalDays = computed(() => stepsData.value.filter(s => s.stepCount >= 10000).length);

const bestStreak = computed(() => {
    const sorted = stepsData.value
        .filter(s => s.stepCount >= 10000)
        .map(s => s.date)
        .sort();
    if (sorted.length === 0) return 0;
    let best = 1;
    let current = 1;
    for (let i = 1; i < sorted.length; i++) {
        if (dayjs(sorted[i]).diff(dayjs(sorted[i - 1]), 'day') === 1) {
            best = Math.max(best, ++current);
        } else {
            current = 1;
        }
    }
    return best;
});

const chartData = computed(() => ({
    labels: dateRange.value,
    datasets: [
        {
            type: 'bar' as const,
            data: dailySteps.value,
            backgroundColor: dailySteps.value.map(s => s >= 10000 ? SECONDARY_COLOR : 'rgba(193, 122, 48, 0.5)'),
            borderRadius: 2,
            borderSkipped: false,
        },
        {
            type: 'line' as const,
            data: Array(dateRange.value.length).fill(10000),
            borderColor: 'rgba(193, 122, 48, 0.55)',
            borderWidth: 1.5,
            borderDash: [6, 3],
            pointRadius: 0,
            fill: false,
        },
    ],
}));

const chartHeight = computed(() => Math.max(450, dateRange.value.length * 8));

const chartOptions = computed(() => ({
    responsive: true,
    maintainAspectRatio: false,
    indexAxis: 'y' as const,
    plugins: {
        legend: {display: false},
        tooltip: {
            filter: (item: {datasetIndex: number}) => item.datasetIndex === 0,
            callbacks: {
                title: (items: {label: string}[]) =>
                    dayjs(items[0].label).format('MMM D, YYYY'),
                label: (ctx: {parsed: {x: number}}) =>
                    ` ${ctx.parsed.x.toLocaleString()} steps`,
            },
        },
    },
    scales: {
        x: {
            max: bestDay.value ?? undefined,
            grid: {color: 'rgba(0,0,0,0.06)'},
            ticks: {
                color: 'rgba(0,0,0,0.5)',
                font: {size: 10},
                callback: (v: number) => (v >= 1000 ? `${v / 1000}k` : `${v}`),
            },
            border: {display: false},
        },
        y: {
            reverse: true,
            grid: {display: false},
            border: {display: false},
            ticks: {
                color: 'rgba(0,0,0,0.35)',
                font: {size: 9},
                callback: (value: number) => {
                    const date = dateRange.value[value];
                    if (!date) return '';
                    return dayjs(date).date() === 1 ? dayjs(date).format('MMM') : '';
                },
            },
        },
    },
}));

function fmt(n: number): string {
    return n.toLocaleString();
}
</script>

<template>
    <div v-if="loading" class="state-msg">Loading step data…</div>

    <template v-else>
        <div class="year-selector">
            <button class="year-btn" @click="selectedYear--">
                <ChevronLeft :size="18" />
            </button>
            <span class="year-label">{{ selectedYear }}</span>
            <button
                class="year-btn"
                :class="{'year-btn--disabled': selectedYear >= currentYear}"
                :disabled="selectedYear >= currentYear"
                @click="selectedYear++"
            >
                <ChevronRight :size="18" />
            </button>
        </div>

        <div v-if="stepsData.length === 0" class="state-msg">
            No steps logged for {{ selectedYear }}. Start tracking to see your progress.
        </div>

        <template v-else>
            <div class="summary-card">
                <div class="summary-card__stats">
                    <div class="summary-card__stat">
                        <span class="summary-card__label">Avg Steps</span>
                        <span class="summary-card__value">{{ avgSteps !== null ? fmt(avgSteps) : '—' }}</span>
                    </div>
                    <div class="summary-card__stat">
                        <span class="summary-card__label">Best Day</span>
                        <span class="summary-card__value">{{ bestDay !== null ? fmt(bestDay) : '—' }}</span>
                    </div>
                    <div class="summary-card__stat">
                        <span class="summary-card__label">Goal Days 10k</span>
                        <span class="summary-card__value">
                            {{ goalDays }}
                            <span class="summary-card__unit">/ {{ daysLogged }}</span>
                        </span>
                    </div>
                    <div class="summary-card__stat">
                        <span class="summary-card__label">Best Streak 10k</span>
                        <span class="summary-card__value">{{ bestStreak }}<span class="summary-card__unit"> days</span></span>
                    </div>
                </div>
            </div>

            <div class="chart-card">
                <div class="chart-card__heading">Daily steps</div>
                <div class="chart-card__chart" :style="{height: chartHeight + 'px'}">
                    <Chart type="bar" :data="chartData" :options="chartOptions" />
                </div>
            </div>
        </template>
    </template>
</template>

<style scoped>
.state-msg {
    color: var(--p-text-muted-color);
    text-align: center;
    padding: 3rem 0;
}

.year-selector {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 16px;
    margin-bottom: 1.5rem;
}

.year-btn {
    background: none;
    border: none;
    cursor: pointer;
    padding: 4px;
    display: flex;
    align-items: center;
    color: var(--primary-color);
    border-radius: 50%;
    transition: background 0.15s;
}

.year-btn:hover {
    background: #e8e9f2;
}

.year-btn--disabled {
    color: #d5d5d5;
    cursor: default;
}

.year-btn--disabled:hover {
    background: none;
}

.year-label {
    font-size: 1rem;
    font-weight: 700;
    color: var(--primary-color);
    min-width: 48px;
    text-align: center;
}

.summary-card {
    background: var(--primary-color);
    border-radius: 12px;
    padding: 16px;
    color: #ffffff;
    margin-bottom: 1rem;
}

.summary-card__stats {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 16px 24px;
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
    white-space: nowrap;
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

.chart-card {
    background: var(--p-card-background);
    border-radius: 12px;
    border: 1px solid var(--p-content-border-color);
    padding: 12px 14px 14px;
    margin-bottom: 1rem;
}

.chart-card__heading {
    font-size: 0.65rem;
    font-weight: 700;
    letter-spacing: 0.1em;
    text-transform: uppercase;
    color: var(--p-text-muted-color);
    margin-bottom: 10px;
}

.chart-card__chart {
    position: relative;
}

.chart-card__chart :deep(div),
.chart-card__chart :deep(canvas) {
    height: 100% !important;
}
</style>
