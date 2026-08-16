<script setup lang="ts">
import {ref, computed, onMounted, watch} from 'vue';
import {ChevronLeft, ChevronRight} from 'lucide-vue-next';
import {SECONDARY_COLOR} from '../colors.ts';
import {walkDotColor} from '../utils/walk-color.ts';
import {useUsersStore} from '../stores/users.store.ts';
import {WalksApi} from '../supabase/walks.api.ts';
import dayjs from 'dayjs';
import isoWeek from 'dayjs/plugin/isoWeek';
dayjs.extend(isoWeek);
import LoadingSpinner from './LoadingSpinner.vue';

const usersStore = useUsersStore();

const currentYear = new Date().getFullYear();
const selectedYear = ref(currentYear);

const stepsData = ref<{date: string; stepCount: number}[]>([]);
const loading = ref(true);
const viewMode = ref<'daily' | 'weekly' | 'monthly'>('daily');
const VIEW_MODES = ['daily', 'weekly', 'monthly'] as const;
const DAILY_GOAL = 8000;
const WEEK_DAY_LABELS = ['M', 'T', 'W', 'T', 'F', 'S', 'S'] as const;

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

const weeklyAgg = computed(() => {
    const map = new Map<string, number>();
    const labels: string[] = [];
    for (const date of dateRange.value) {
        const key = dayjs(date).startOf('isoWeek').format('YYYY-MM-DD');
        if (!map.has(key)) {
            labels.push(date);
            map.set(key, 0);
        }
        map.set(key, map.get(key)! + (stepMap.value.get(date) ?? 0));
    }
    return {labels, steps: [...map.values()]};
});

const monthlyAgg = computed(() => {
    const map = new Map<string, number>();
    const labels: string[] = [];
    for (const date of dateRange.value) {
        const key = dayjs(date).format('YYYY-MM');
        if (!map.has(key)) {
            labels.push(key);
            map.set(key, 0);
        }
        map.set(key, map.get(key)! + (stepMap.value.get(date) ?? 0));
    }
    return {labels, steps: [...map.values()]};
});

const daysLogged = computed(() => stepsData.value.filter(s => s.stepCount > 0).length);

const avgSteps = computed(() => {
    if (daysLogged.value === 0) return null;
    const total = stepsData.value.reduce((sum, s) => sum + s.stepCount, 0);
    return Math.round(total / daysLogged.value);
});

const bestDay = computed(() =>
    stepsData.value.length === 0 ? null : Math.max(...stepsData.value.map(s => s.stepCount))
);

const goalDays = computed(() => stepsData.value.filter(s => s.stepCount >= DAILY_GOAL).length);

const bestStreak = computed(() => {
    const sorted = stepsData.value
        .filter(s => s.stepCount >= DAILY_GOAL)
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

const currentWeekSteps = computed(() => {
    if (selectedYear.value !== currentYear) return 0;
    const start = dayjs().startOf('isoWeek');
    return dateRange.value
        .filter(d => !dayjs(d).isBefore(start))
        .reduce((sum, d) => sum + (stepMap.value.get(d) ?? 0), 0);
});

const weekDailyAvg = computed(() => {
    const daysElapsed = Math.max(1, dayjs().diff(dayjs().startOf('isoWeek'), 'day') + 1);
    return Math.round(currentWeekSteps.value / daysElapsed);
});

const weekProgress = computed(() => Math.min((currentWeekSteps.value / (DAILY_GOAL * 7)) * 100, 100));

const currentWeekDays = computed(() => {
    const today = dayjs();
    const dow = today.day();
    const monday = today.subtract(dow === 0 ? 6 : dow - 1, 'day');
    return Array.from({length: 7}, (_, i) => {
        const day = monday.add(i, 'day');
        const dateStr = day.format('YYYY-MM-DD');
        const isFuture = day.isAfter(today, 'day');
        return {
            label: WEEK_DAY_LABELS[i],
            steps: isFuture ? null : (stepMap.value.get(dateStr) ?? 0),
            isFuture,
            isToday: day.isSame(today, 'day'),
        };
    });
});

function buildDatasets(steps: number[], goals: number[]) {
    return [
        {
            type: 'bar' as const,
            data: steps,
            backgroundColor: steps.map((s, i) => s >= goals[i] ? SECONDARY_COLOR : 'rgba(193, 122, 48, 0.5)'),
            borderRadius: 2,
            borderSkipped: false,
        },
        {
            type: 'line' as const,
            data: goals,
            borderColor: 'rgba(193, 122, 48, 0.55)',
            borderWidth: 1.5,
            borderDash: [6, 3],
            pointRadius: 0,
            fill: false,
        },
    ];
}

const chartData = computed(() => {
    if (viewMode.value === 'weekly') {
        const {labels, steps} = weeklyAgg.value;
        return {labels, datasets: buildDatasets(steps, Array(labels.length).fill(DAILY_GOAL * 7))};
    }
    if (viewMode.value === 'monthly') {
        const {labels, steps} = monthlyAgg.value;
        return {labels, datasets: buildDatasets(steps, labels.map(l => dayjs(l).daysInMonth() * DAILY_GOAL))};
    }
    return {
        labels: dateRange.value,
        datasets: buildDatasets(dailySteps.value, Array(dateRange.value.length).fill(DAILY_GOAL)),
    };
});

const chartHeight = computed(() => {
    if (viewMode.value === 'weekly') return Math.max(250, weeklyAgg.value.labels.length * 14);
    if (viewMode.value === 'monthly') return Math.max(200, monthlyAgg.value.labels.length * 28);
    return Math.max(450, dateRange.value.length * 8);
});

const chartOptions = computed(() => ({
    responsive: true,
    maintainAspectRatio: false,
    indexAxis: 'y' as const,
    plugins: {
        legend: {display: false},
        tooltip: {
            filter: (item: {datasetIndex: number}) => item.datasetIndex === 0,
            callbacks: {
                title: (items: {label: string}[]) => {
                    const lbl = items[0].label;
                    if (viewMode.value === 'weekly') return `Week of ${dayjs(lbl).format('MMM D, YYYY')}`;
                    if (viewMode.value === 'monthly') return dayjs(lbl).format('MMMM YYYY');
                    return dayjs(lbl).format('MMM D, YYYY');
                },
                label: (ctx: {parsed: {x: number}}) =>
                    ` ${ctx.parsed.x.toLocaleString()} steps`,
            },
        },
    },
    scales: {
        x: {
            max: viewMode.value === 'weekly'
                ? (weeklyAgg.value.steps.length > 0 ? Math.max(...weeklyAgg.value.steps) : undefined)
                : viewMode.value === 'monthly'
                ? (monthlyAgg.value.steps.length > 0 ? Math.max(...monthlyAgg.value.steps) : undefined)
                : (bestDay.value ?? undefined),
            grid: {color: 'rgba(0,0,0,0.06)'},
            ticks: {
                color: 'rgba(0,0,0,0.5)',
                font: {size: 10},
                callback: (v: number) => (v >= 1000 ? `${parseFloat((v / 1000).toFixed(1))}k` : `${v}`),
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
                    if (viewMode.value === 'weekly') {
                        const date = weeklyAgg.value.labels[value];
                        if (!date) return '';
                        if (value === 0) return dayjs(date).format('MMM');
                        const prev = weeklyAgg.value.labels[value - 1];
                        return dayjs(date).month() !== dayjs(prev).month() ? dayjs(date).format('MMM') : '';
                    }
                    if (viewMode.value === 'monthly') {
                        const label = monthlyAgg.value.labels[value];
                        return label ? dayjs(label).format('MMM') : '';
                    }
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

function fmtShort(n: number): string {
    return n >= 1000 ? `${(n / 1000).toFixed(1)}k` : `${n}`;
}
</script>

<template>
    <div v-if="loading" class="state-center">
        <LoadingSpinner />
    </div>

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
                        <span class="summary-card__label">Goal Days 8k</span>
                        <span class="summary-card__value">
                            {{ goalDays }}
                            <span class="summary-card__unit">/ {{ daysLogged }}</span>
                        </span>
                    </div>
                    <div class="summary-card__stat">
                        <span class="summary-card__label">Best Streak 8k</span>
                        <span class="summary-card__value">{{ bestStreak }}<span class="summary-card__unit"> days</span></span>
                    </div>
                </div>
            </div>

            <div v-if="selectedYear === currentYear" class="week-card">
                <div class="week-card__heading">Current Week</div>
                <div class="week-card__stats">
                    <div class="week-card__stat">
                      <span class="week-card__label">Daily Avg</span>
                      <span class="week-card__value">{{ fmt(weekDailyAvg) }}</span>
                    </div>
                    <div class="week-card__stat">
                        <span class="week-card__label">Total Steps</span>
                        <span class="week-card__value">{{ fmt(currentWeekSteps) }}</span>
                    </div>
                </div>
                <div class="week-card__progress-label">
                    <span>Progress to {{ fmt(DAILY_GOAL * 7) }}</span>
                    <span>{{ fmt(currentWeekSteps) }} / {{ fmt(DAILY_GOAL * 7) }}</span>
                </div>
                <div class="week-card__progress-track">
                    <div class="week-card__progress-fill" :style="{width: weekProgress + '%'}"></div>
                </div>
                <div class="week-days">
                    <div
                        v-for="(day, i) in currentWeekDays"
                        :key="i"
                        class="week-day"
                        :class="{'week-day--today': day.isToday, 'week-day--future': day.isFuture, 'week-day--active': day.steps !== null && day.steps > 0}"
                        :style="day.steps ? {backgroundColor: walkDotColor(day.steps), borderColor: walkDotColor(day.steps)} : undefined"
                    >
                        <span class="week-day__label">{{ day.label }}</span>
                        <span class="week-day__steps">{{ day.isFuture ? '-' : fmtShort(day.steps ?? 0) }}</span>
                    </div>
                </div>
            </div>



            <div class="chart-card">
              <div class="view-toggle">
                <button
                    v-for="mode in VIEW_MODES"
                    :key="mode"
                    class="view-btn"
                    :class="{'view-btn--active': viewMode === mode}"
                    @click="viewMode = mode"
                >{{ mode }}</button>
              </div>
                <div class="chart-card__heading">{{ viewMode }} steps</div>
                <div class="chart-card__chart" :style="{height: chartHeight + 'px'}">
                    <Chart type="bar" :data="chartData" :options="chartOptions" />
                </div>
            </div>
        </template>
    </template>
</template>

<style scoped>
.state-center {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 3rem 0;
}

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
    margin-bottom: 1rem;
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

.view-toggle {
    display: flex;
    justify-content: center;
    gap: 6px;
    margin-bottom: 1rem;
}

.view-btn {
    background: none;
    border: 1px solid var(--p-content-border-color);
    cursor: pointer;
    padding: 4px 14px;
    border-radius: 20px;
    font-size: 0.8rem;
    font-weight: 500;
    color: var(--p-text-muted-color);
    text-transform: capitalize;
    transition: all 0.15s;
}

.view-btn:hover {
    background: #e8e9f2;
}

.view-btn--active {
    background: var(--primary-color);
    border-color: var(--primary-color);
    color: #ffffff;
}

.view-btn--active:hover {
    background: var(--primary-color);
}

.summary-card {
    background: var(--primary-color);
    border-radius: 12px;
    padding: 16px;
    color: #ffffff;
    margin-bottom: 12px;
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
  text-align: center;
}

.chart-card__chart {
    position: relative;
}

.chart-card__chart :deep(div),
.chart-card__chart :deep(canvas) {
    height: 100% !important;
}

.week-card {
    background: var(--p-card-background);
    border-radius: 12px;
    border: 1px solid var(--p-content-border-color);
    padding: 12px 14px 14px;
    margin-bottom: 12px;
}

.week-card__heading {
    font-size: 0.65rem;
    font-weight: 700;
    letter-spacing: 0.1em;
    text-transform: uppercase;
    color: var(--p-text-muted-color);
    margin-bottom: 10px;
}

.week-card__stats {
    display: flex;
    gap: 4px;
    margin-bottom: 14px;
}

.week-card__stat {
    display: flex;
    flex-direction: column;
    gap: 2px;
   flex: 1;
  padding: 4px 8px;
  background: #f6f6f6;
  border-radius: 6px;
}

.week-card__label {
    font-size: 0.7rem;
    font-weight: 600;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    color: var(--p-text-muted-color);
}

.week-card__value {
    font-size: 1.2rem;
    font-weight: 700;
}

.week-card__progress-label {
    display: flex;
    justify-content: space-between;
    font-size: 0.72rem;
    color: var(--p-text-muted-color);
    margin-bottom: 6px;
}

.week-card__progress-track {
    height: 8px;
    background: rgba(0, 0, 0, 0.08);
    border-radius: 4px;
    overflow: hidden;
}

.week-card__progress-fill {
    height: 100%;
    background: var(--primary-color);
    border-radius: 4px;
    transition: width 0.4s ease;
}

.week-days {
    display: flex;
    gap: 12px;
    margin-top: 12px;
}

.week-day {
    flex: 1;
    aspect-ratio: 1;
    border-radius: 50%;
    background: #ffffff;
    border: 1px solid #d5d5d5;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 1px;
}

.week-day--today {
    border-color: var(--primary-color) !important;
    border-width: 2px;
}

.week-day--future {
    border-color: #ebebeb;
}

.week-day__label {
    font-size: 0.5rem;
    font-weight: 700;
    color: #bebebe;
    line-height: 1;
}

.week-day__steps {
    font-size: 0.45rem;
    color: #bebebe;
    line-height: 1;
}

.week-day--active .week-day__label,
.week-day--active .week-day__steps {
    color: #ffffff;
}
</style>
