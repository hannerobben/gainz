<script setup lang="ts">
import {ref, computed, onMounted, watch} from 'vue';
import {Plus} from 'lucide-vue-next';
import {SECONDARY_COLOR} from '../colors.ts';
import {useUsersStore} from '../stores/users.store.ts';
import {WeightsApi} from '../supabase/weights.api.ts';
import type {Weight} from '../model/weight.contract.ts';
import LogWeightDialog from '../components/LogWeightDialog.vue';
import dayjs from 'dayjs';

const usersStore = useUsersStore();
const weights = ref<Weight[]>([]);
const loading = ref(true);
const dialogVisible = ref(false);
const editingWeight = ref<Weight | null>(null);

async function load() {
    if (!usersStore.activeUser) return;
    loading.value = true;
    weights.value = await WeightsApi.getAll(usersStore.activeUser.id);
    loading.value = false;
}

onMounted(load);
watch(() => usersStore.activeUser?.id, load);

function openAdd() {
    editingWeight.value = null;
    dialogVisible.value = true;
}

function openEdit(w: Weight) {
    editingWeight.value = w;
    dialogVisible.value = true;
}

function onSaved() {
    dialogVisible.value = false;
    editingWeight.value = null;
    load();
}

function onClose() {
    dialogVisible.value = false;
    editingWeight.value = null;
}

const latest = computed(() => weights.value.length > 0 ? weights.value[weights.value.length - 1].weight : null);
const lowest = computed(() => weights.value.length === 0 ? null : Math.min(...weights.value.map(w => w.weight)));
const highest = computed(() => weights.value.length === 0 ? null : Math.max(...weights.value.map(w => w.weight)));

const chartData = computed(() => ({
    labels: weights.value.map(w => w.date),
    datasets: [{
        label: 'Weight (kg)',
        data: weights.value.map(w => w.weight),
        borderColor: SECONDARY_COLOR,
        pointBackgroundColor: SECONDARY_COLOR,
        fill: false,
        tension: 0.3,
        pointRadius: 3,
    }],
}));

const chartOptions = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
        legend: {display: false},
        tooltip: {
            callbacks: {
                label: (ctx: {parsed: {y: number}}) => ` ${ctx.parsed.y.toFixed(1)} kg`,
            },
        },
    },
    scales: {
        x: {display: false},
        y: {
            grid: {color: 'rgba(255,255,255,0.1)'},
            ticks: {color: 'rgba(255,255,255,0.6)', callback: (v: number) => `${Number(v).toFixed(1)} kg`},
            border: {display: false},
        },
    },
};

function formatDate(date: string): string {
    return dayjs(date).format('MMM D, YYYY');
}
</script>

<template>
    <div class="weight-page">
        <div v-if="loading" class="state-center">
            <ProgressSpinner />
        </div>

        <template v-else>
            <div v-if="weights.length > 0" class="summary-card">
                <div class="summary-card__stats">
                    <div class="summary-card__stat">
                        <span class="summary-card__label">Current</span>
                        <span class="summary-card__value">{{ latest }} <span class="summary-card__unit">kg</span></span>
                    </div>
                    <div class="summary-card__stat">
                        <span class="summary-card__label">Lowest</span>
                        <span class="summary-card__value">{{ lowest }} <span class="summary-card__unit">kg</span></span>
                    </div>
                    <div class="summary-card__stat">
                        <span class="summary-card__label">Highest</span>
                        <span class="summary-card__value">{{ highest }} <span class="summary-card__unit">kg</span></span>
                    </div>
                </div>
                <div class="summary-card__chart">
                    <Chart type="line" :data="chartData" :options="chartOptions" />
                </div>
            </div>

            <div v-if="weights.length === 0" class="empty-state">
                No weight entries yet. Tap + to log your first entry.
            </div>

            <div v-else class="weight-list">
                <div class="weight-list__header">
                    <span>Date</span>
                    <span>Weight</span>
                </div>
                <div
                    v-for="w in [...weights].reverse()"
                    :key="w.id"
                    class="weight-list__row"
                    @click="openEdit(w)"
                >
                    <span>{{ formatDate(w.date) }}</span>
                    <span>{{ w.weight }} kg</span>
                </div>
            </div>
        </template>

        <button class="fab" @click="openAdd">
            <Plus :size="24" />
        </button>
    </div>

    <LogWeightDialog
        :visible="dialogVisible"
        :existing-weight="editingWeight"
        @close="onClose"
        @saved="onSaved"
    />
</template>

<style scoped>
.weight-page {
    padding: 16px;
    padding-bottom: 80px;
    display: flex;
    flex-direction: column;
    gap: 16px;
    min-height: 100%;
}

.state-center {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
}

.summary-card {
    background: var(--primary-color);
    border-radius: 12px;
    padding: 16px;
    color: #ffffff;
}

.summary-card__stats {
    display: flex;
    gap: 24px;
    margin-bottom: 12px;
  justify-content: space-around;
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

.empty-state {
    color: var(--p-text-muted-color);
    text-align: center;
    padding: 3rem 0;
}

.weight-list {
    background: white;
    border-radius: 12px;
    border: 1px solid var(--p-content-border-color);
    overflow: hidden;
}

.weight-list__header,
.weight-list__row {
    display: grid;
    grid-template-columns: 2fr 1fr;
    gap: 0.5rem;
    padding: 8px 12px;
    font-size: 0.75rem;
}

.weight-list__header {
    font-size: 0.7rem;
    font-weight: 600;
    letter-spacing: 0.06em;
    text-transform: uppercase;
    color: var(--p-text-muted-color);
    border-bottom: 1px solid var(--p-content-border-color);
}

.weight-list__row {
    cursor: pointer;

    &:hover {
        background: var(--p-content-border-color);
    }
}

.weight-list__row + .weight-list__row {
    border-top: 1px solid var(--p-content-border-color);
}

.fab {
    position: fixed;
    bottom: calc(60px + 16px);
    right: 16px;
    width: 52px;
    height: 52px;
    border-radius: 50%;
    background: var(--secondary-color);
    color: #ffffff;
    border: none;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
    z-index: 10;
    transition: background 0.15s;

    &:hover {
        background: #a86628;
    }
}
</style>
