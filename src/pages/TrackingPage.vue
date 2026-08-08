<script setup lang="ts">
import {computed, nextTick, onMounted, ref, watch} from 'vue';
import {ChevronLeft, ChevronRight} from 'lucide-vue-next';
import DayDetailDialog from '../components/DayDetailDialog.vue';
import WorkoutTypeSelector from '../components/WorkoutTypeSelector.vue';
import CreateStrengthWorkoutDialog from '../components/CreateStrengthWorkoutDialog.vue';
import LogWalkDialog from '../components/LogWalkDialog.vue';
import LogRunDialog from '../components/LogRunDialog.vue';
import {useUsersStore} from '../stores/users.store.ts';
import {WorkoutsApi} from '../supabase/workouts.api.ts';
import {WalksApi} from '../supabase/walks.api.ts';
import {RunsApi} from '../supabase/runs.api.ts';
import type {Workout} from '../model/workout.contract.ts';
import type {Walk} from '../model/walk.contract.ts';
import type {Run} from '../model/run.contract.ts';
import {walkDotColor} from '../utils/walk-color.ts';

const selectedFilters = ref(new Set<string>(['strength']));

const DAY_LABELS = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
const MONTH_LABELS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

const usersStore = useUsersStore();

const currentYear = new Date().getFullYear();
const selectedYear = ref(currentYear);

const workoutDates = ref<Map<string, Set<string>>>(new Map());
const walkDates = ref<Map<string, number>>(new Map());
const runDates = ref<Map<string, number>>(new Map());

function toDateKey(year: number, month: number, day: number): string {
    return `${year}-${String(month + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
}

async function fetchWorkoutDates(year: number) {
    if (!usersStore.activeUser) return;
    const [entries, walks, runs] = await Promise.all([
        WorkoutsApi.getDates(usersStore.activeUser.id, year),
        WalksApi.getDates(usersStore.activeUser.id, year),
        RunsApi.getDates(usersStore.activeUser.id, year)
    ]);
    const map = new Map<string, Set<string>>();
    for (const {date, type} of entries) {
        if (!map.has(date)) map.set(date, new Set());
        map.get(date)!.add(type);
    }
    workoutDates.value = map;
    walkDates.value = new Map(walks.map(w => [w.date, w.stepCount]));
    runDates.value = new Map(runs.map(r => [r.date, r.distance]));
}

function hasWorkout(month: number, dayNumber: number): boolean {
    const key = toDateKey(selectedYear.value, month, dayNumber);
    return (workoutDates.value.get(key)?.size ?? 0) > 0;
}

function walkSteps(month: number, dayNumber: number): number {
    return walkDates.value.get(toDateKey(selectedYear.value, month, dayNumber)) ?? 0;
}

function runDistance(month: number, dayNumber: number): number {
    return runDates.value.get(toDateKey(selectedYear.value, month, dayNumber)) ?? 0;
}

function dotClasses(cell: {dayNumber: number; month: number; isToday: boolean}) {
    const filters = selectedFilters.value;
    const isSteps = filters.has('steps');
    const hasStr = !isSteps && filters.has('strength') && hasWorkout(cell.month, cell.dayNumber);
    const hasRun = !isSteps && filters.has('running') && runDistance(cell.month, cell.dayNumber) > 0;
    return {
        'dot--today': cell.isToday,
        'dot--clickable': true,
        'dot--worked': hasStr && !hasRun,
        'dot--ran': hasRun && !hasStr,
        'dot--split': hasStr && hasRun,
        'dot--walked': isSteps && walkSteps(cell.month, cell.dayNumber) > 0,
    };
}

function dotStyle(month: number, dayNumber: number) {
    const filters = selectedFilters.value;
    if (filters.has('steps')) {
        const steps = walkSteps(month, dayNumber);
        if (steps === 0) return undefined;
        const color = walkDotColor(steps);
        return {backgroundColor: color, borderColor: color};
    }
    const hasStr = filters.has('strength') && hasWorkout(month, dayNumber);
    const hasRun = filters.has('running') && runDistance(month, dayNumber) > 0;
    if (hasStr && hasRun) {
        return {background: 'linear-gradient(to right, #4A7FC1 50%, #5A9E5A 50%)', borderColor: '#4A7FC1'};
    }
    if (hasRun) {
        return {backgroundColor: '#5A9E5A', borderColor: '#5A9E5A'};
    }
    return undefined;
}

const selectedDateTypes = computed<string[]>(() => {
    if (!selectedDate.value) return [];
    const key = toDateKey(
        selectedDate.value.getFullYear(),
        selectedDate.value.getMonth(),
        selectedDate.value.getDate()
    );
    return Array.from(workoutDates.value.get(key) ?? []);
});

watch(selectedYear, year => fetchWorkoutDates(year));
watch(() => usersStore.activeUser?.id, () => fetchWorkoutDates(selectedYear.value));

function daysInYear(year: number): number {
    return (year % 4 === 0 && year % 100 !== 0) || year % 400 === 0 ? 366 : 365;
}

function jan1Offset(year: number): number {
    const day = new Date(year, 0, 1).getDay();
    return day === 0 ? 6 : day - 1;
}

const selectedDate = ref<Date | null>(null);
const strengthWorkoutDate = ref<Date | null>(null);
const existingWorkout = ref<Workout | null>(null);
const walkDate = ref<Date | null>(null);
const existingWalk = ref<Walk | null>(null);
const runDate = ref<Date | null>(null);
const existingRun = ref<Run | null>(null);

async function openStrengthWorkout() {
    const date = selectedDate.value;
    selectedDate.value = null;
    if (!date || !usersStore.activeUser) return;
    existingWorkout.value = await WorkoutsApi.getByDate(usersStore.activeUser.id, date);
    strengthWorkoutDate.value = date;
}

async function openWalk() {
    const date = selectedDate.value;
    selectedDate.value = null;
    if (!date || !usersStore.activeUser) return;
    existingWalk.value = await WalksApi.getByDate(usersStore.activeUser.id, date);
    walkDate.value = date;
}

async function openRun() {
    const date = selectedDate.value;
    selectedDate.value = null;
    if (!date || !usersStore.activeUser) return;
    existingRun.value = await RunsApi.getByDate(usersStore.activeUser.id, date);
    runDate.value = date;
}

function openDay(cell: {dayNumber: number; month: number; isToday: boolean} | null) {
    if (!cell) return;
    selectedDate.value = new Date(selectedYear.value, cell.month, cell.dayNumber);
}

const scrollTargetEl = ref<HTMLElement | null>(null);

const scrollTargetIndex = computed(() => {
    const idx = weeks.value.findIndex(w => w.cells.some(c => c?.isToday));
    return idx === -1 ? 0 : Math.max(0, idx - 9);
});

onMounted(async () => {
    await nextTick();
    scrollTargetEl.value?.scrollIntoView();
    fetchWorkoutDates(selectedYear.value);
});

const weeks = computed(() => {
    const year = selectedYear.value;
    const offset = jan1Offset(year);
    const totalDays = daysInYear(year);
    const totalCells = offset + totalDays;
    const rows = Math.ceil(totalCells / 7);

    const today = new Date();
    const cells: Array<{dayNumber: number; month: number; isToday: boolean} | null> = [
        ...Array(offset).fill(null),
        ...Array.from({length: totalDays}, (_, i) => {
            const date = new Date(year, 0, 1 + i);
            return {
                dayNumber: date.getDate(),
                month: date.getMonth(),
                isToday:
                    date.getFullYear() === today.getFullYear() &&
                    date.getMonth() === today.getMonth() &&
                    date.getDate() === today.getDate()
            };
        })
    ];

    while (cells.length < rows * 7) cells.push(null);

    return Array.from({length: rows}, (_, row) => {
        const weekCells = cells.slice(row * 7, row * 7 + 7);
        const firstOfMonth = weekCells.find(c => c?.dayNumber === 1);
        return {
            monthLabel: firstOfMonth ? MONTH_LABELS[firstOfMonth.month] : null,
            isCurrentMonth: firstOfMonth
                ? year === today.getFullYear() && firstOfMonth.month === today.getMonth()
                : false,
            cells: weekCells
        };
    });
});
</script>

<template>
    <div class="tracking-page">
        <div class="sticky-header">
            <WorkoutTypeSelector v-model="selectedFilters" />
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
            <div class="day-labels">
                <span class="month-spacer" />
                <span v-for="label in DAY_LABELS" :key="label" class="day-label">{{ label }}</span>
            </div>
        </div>

        <div class="calendar-grid">
        <div class="weeks">
                <div
                    v-for="(week, wi) in weeks"
                    :key="wi"
                    class="week-row"
                    :ref="(el) => { if (wi === scrollTargetIndex) scrollTargetEl = el as HTMLElement }"
                >
                    <span class="month-label" :class="{'month-label--current': week.isCurrentMonth}">{{ week.monthLabel }}</span>
                    <div
                        v-for="(cell, di) in week.cells"
                        :key="di"
                        class="dot"
                        :class="cell === null ? {'dot--empty': true} : dotClasses(cell)"
                        :style="cell !== null ? dotStyle(cell.month, cell.dayNumber) : undefined"
                        @click="openDay(cell)"
                    >
                        <span v-if="cell" class="dot-number">{{ cell.dayNumber }}</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <DayDetailDialog
        :date="selectedDate"
        :existing-types="selectedDateTypes"
        @close="selectedDate = null"
        @open-strength-workout="openStrengthWorkout"
        @open-run="openRun"
        @open-walk="openWalk"
    />
    <CreateStrengthWorkoutDialog
        :date="strengthWorkoutDate"
        :existing-workout="existingWorkout"
        @close="strengthWorkoutDate = null; existingWorkout = null"
        @saved="strengthWorkoutDate = null; existingWorkout = null; fetchWorkoutDates(selectedYear)"
    />
    <LogWalkDialog
        :date="walkDate"
        :existing-walk="existingWalk"
        @close="walkDate = null; existingWalk = null"
        @saved="walkDate = null; existingWalk = null; fetchWorkoutDates(selectedYear)"
    />
    <LogRunDialog
        :date="runDate"
        :existing-run="existingRun"
        @close="runDate = null; existingRun = null"
        @saved="runDate = null; existingRun = null; fetchWorkoutDates(selectedYear)"
    />
</template>

<style scoped>
.tracking-page {
    padding: 0 16px 16px 16px;
    display: flex;
    flex-direction: column;
}

.sticky-header {
    position: sticky;
    top: 0;
    background: whitesmoke;
    z-index: 1;
    padding: 16px 0 8px;
    display: flex;
    flex-direction: column;
    gap: 8px;
}


.year-selector {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 16px;
}

.year-btn {
    background: none;
    border: none;
    cursor: pointer;
    padding: 4px;
    display: flex;
    align-items: center;
    color: #0a0d2e;
    border-radius: 50%;
    transition: background 0.15s;

    &:hover {
        background: #E8E9F2;
    }
}

.year-btn--disabled {
    color: #D5D5D5;
    cursor: default;

    &:hover {
        background: none;
    }
}

.year-label {
    font-size: 1rem;
    font-weight: 700;
    color: #0a0d2e;
    min-width: 48px;
    text-align: center;
}

.day-labels {
    display: grid;
    grid-template-columns: 28px repeat(7, 1fr);
    gap: 4px;
}

.month-spacer {
    display: block;
}

.day-label {
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 0.7rem;
    font-weight: 600;
    color: #BEBEBE;
    text-transform: uppercase;
}

.weeks {
    display: flex;
    flex-direction: column;
    gap: 4px;
}

.week-row {
    display: grid;
    grid-template-columns: 28px repeat(7, 1fr);
    gap: 4px;
    align-items: center;
}

.month-label {
    font-size: 0.7rem;
    font-weight: 600;
    color: #BEBEBE;
    text-align: right;
    padding-right: 4px;
    line-height: 1;
}

.month-label--current {
    color: #0a0d2e;
    font-weight: 700;
}

.dot {
    aspect-ratio: 1;
    border-radius: 50%;
    background: #ffffff;
    border: 1px solid #D5D5D5;
    display: flex;
    align-items: center;
    justify-content: center;
}

.dot--empty {
    background: transparent;
    border-color: transparent;
}

.dot--clickable {
    cursor: pointer;

    &:hover {
        border-color: #9E9E9E;
    }
}

.dot-number {
    font-size: 0.65rem;
    color: #BEBEBE;
    line-height: 1;
}

.dot--today {
    border-color: #0a0d2e !important;
    border-width: 2px;

    .dot-number {
        color: #0a0d2e;
        font-weight: 700;
    }
}

.dot--worked {
    background: #4A7FC1;
    border-color: #4A7FC1;

    .dot-number {
        color: #ffffff;
        font-weight: 600;
    }
}

.dot--walked {
    .dot-number {
        color: #ffffff;
        font-weight: 600;
    }
}

.dot--ran {
    .dot-number {
        color: #ffffff;
        font-weight: 600;
    }
}

.dot--split {
    .dot-number {
        color: #ffffff;
        font-weight: 600;
    }
}
</style>
