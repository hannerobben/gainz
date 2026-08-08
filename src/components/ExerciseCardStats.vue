<script setup lang="ts">
import { computed } from 'vue';
import type { ExerciseProgression } from '../supabase/workout.api.ts';

const props = defineProps<{ progression: ExerciseProgression }>();

function kgDelta(current: number, past: number): { text: string; cls: string } {
    const diff = Math.round((current - past) * 10) / 10;
    if (diff > 0) return { text: `↑ +${diff} kg`, cls: 'positive' };
    if (diff < 0) return { text: `↓ ${Math.abs(diff)} kg`, cls: 'negative' };
    return { text: '—', cls: 'neutral' };
}

function repDelta(current: number, past: number): { text: string; cls: string } {
    const diff = current - past;
    if (diff > 0) return { text: `↑ +${diff} reps`, cls: 'positive' };
    if (diff < 0) return { text: `↓ ${Math.abs(diff)} reps`, cls: 'negative' };
    return { text: '—', cls: 'neutral' };
}

function pctDelta(current: number, past: number): { text: string; cls: string } {
    if (past === 0) return { text: '—', cls: 'neutral' };
    const pct = Math.round(((current - past) / past) * 100);
    if (pct > 0) return { text: `↑ +${pct}%`, cls: 'positive' };
    if (pct < 0) return { text: `↓ ${pct}%`, cls: 'negative' };
    return { text: '—', cls: 'neutral' };
}

type StatEntry = { value: string; delta: { text: string; cls: string } | null };

const bwStats = computed(() => {
    const { currentStats: c, eightWeeksAgoStats: p } = props.progression;
    return {
        maxReps: { value: `${c.bestSetReps} reps`, delta: p ? repDelta(c.bestSetReps, p.bestSetReps) : null } as StatEntry,
        totalReps: { value: c.totalVolume.toLocaleString() + ' reps', delta: p ? pctDelta(c.totalVolume, p.totalVolume) : null } as StatEntry,
    };
});

const weightedStats = computed(() => {
    const { currentStats: c, eightWeeksAgoStats: p } = props.progression;
    return {
        bestSet: { value: `${c.bestSetLoad} kg × ${c.bestSetReps}`, delta: p ? kgDelta(c.bestSetLoad, p.bestSetLoad) : null } as StatEntry,
        e1rm: { value: `${c.e1rm} kg`, delta: p ? kgDelta(c.e1rm, p.e1rm) : null } as StatEntry,
        volume: { value: c.totalVolume.toLocaleString() + ' kg', delta: p ? pctDelta(c.totalVolume, p.totalVolume) : null } as StatEntry,
    };
});
</script>

<template>
    <div class="card-stats">
        <div class="card-stats__heading">Current Performance</div>

        <div v-if="progression.isBodyweight" class="card-stats__cols card-stats__cols--2">
            <div class="card-stats__col">
                <div class="card-stats__label">Max Reps</div>
                <div class="card-stats__value">{{ bwStats.maxReps.value }}</div>
                <template v-if="bwStats.maxReps.delta">
                    <div :class="['card-stats__delta', `card-stats__delta--${bwStats.maxReps.delta.cls}`]">
                        {{ bwStats.maxReps.delta.text }}
                    </div>
                    <div class="card-stats__since">vs 8 weeks ago</div>
                </template>
            </div>

            <div class="card-stats__col">
                <div class="card-stats__label">Total Reps</div>
                <div class="card-stats__value">{{ bwStats.totalReps.value }}</div>
                <template v-if="bwStats.totalReps.delta">
                    <div :class="['card-stats__delta', `card-stats__delta--${bwStats.totalReps.delta.cls}`]">
                        {{ bwStats.totalReps.delta.text }}
                    </div>
                    <div class="card-stats__since">vs 8 weeks ago</div>
                </template>
            </div>
        </div>

        <div v-else class="card-stats__cols">
            <div class="card-stats__col">
                <div class="card-stats__label">Best Set</div>
                <div class="card-stats__value">{{ weightedStats.bestSet.value }}</div>
                <template v-if="weightedStats.bestSet.delta">
                    <div :class="['card-stats__delta', `card-stats__delta--${weightedStats.bestSet.delta.cls}`]">
                        {{ weightedStats.bestSet.delta.text }}
                    </div>
                    <div class="card-stats__since">vs 8 weeks ago</div>
                </template>
            </div>

            <div class="card-stats__col">
                <div class="card-stats__label">Estimated 1RM</div>
                <div class="card-stats__value">{{ weightedStats.e1rm.value }}</div>
                <template v-if="weightedStats.e1rm.delta">
                    <div :class="['card-stats__delta', `card-stats__delta--${weightedStats.e1rm.delta.cls}`]">
                        {{ weightedStats.e1rm.delta.text }}
                    </div>
                    <div class="card-stats__since">vs 8 weeks ago</div>
                </template>
            </div>

            <div class="card-stats__col">
                <div class="card-stats__label">Total Volume</div>
                <div class="card-stats__value">{{ weightedStats.volume.value }}</div>
                <template v-if="weightedStats.volume.delta">
                    <div :class="['card-stats__delta', `card-stats__delta--${weightedStats.volume.delta.cls}`]">
                        {{ weightedStats.volume.delta.text }}
                    </div>
                    <div class="card-stats__since">vs 8 weeks ago</div>
                </template>
            </div>
        </div>
    </div>
</template>

<style scoped lang="scss">
.card-stats {
    padding-bottom: 1rem;

    &__heading {
        font-size: 0.7rem;
        font-weight: 600;
        letter-spacing: 0.08em;
        text-transform: uppercase;
        color: var(--p-text-muted-color);
        margin-bottom: 0.5rem;
    }

    &__cols {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 4px;

        &--2 {
            grid-template-columns: repeat(2, 1fr);
        }
    }

    &__col {
        display: flex;
        flex-direction: column;
        gap: 2px;
        background: #f6f6f6;
        padding: 6px 8px;
        border-radius: 6px;
    }

    &__label {
        font-size: 0.7rem;
        color: var(--p-text-muted-color);
    }

    &__value {
        font-size: 0.95rem;
        font-weight: 600;
    }

    &__delta {
        font-size: 0.75rem;
        font-weight: 500;

        &--positive { color: var(--p-green-500); }
        &--negative { color: var(--p-red-500); }
        &--neutral  { color: var(--p-text-muted-color); }
    }

    &__since {
        font-size: 0.65rem;
        color: #9faec3;
    }
}
</style>
