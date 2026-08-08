import { supabase } from './supabase.ts';
import { estimatedOneRepMax, setVolume } from '../utils/strength.ts';

export interface E1RMDataPoint {
    date: string;
    e1rm: number;
    bestSetLoad: number;
    bestSetReps: number;
    totalVolume: number;
    sets: { load: number; reps: number }[];
}

export interface SessionStats {
    e1rm: number;
    bestSetLoad: number;
    bestSetReps: number;
    totalVolume: number;
}

export interface ExerciseProgression {
    exerciseId: string;
    exerciseName: string;
    category: string;
    isBodyweight: boolean;
    dataPoints: E1RMDataPoint[];
    lastTrained: string;
    currentStats: SessionStats;
    eightWeeksAgoStats: SessionStats | null;
    allTimePr: { value: number; label: string };
}

export class WorkoutApi {
    static async getStrengthProgression(userId: string): Promise<ExerciseProgression[]> {
        const { data, error } = await supabase
            .from('workout_exercise_sets')
            .select(`
                load,
                reps,
                workout:workouts!inner(date, user_id),
                exercise:strength_exercises!inner(id, name, equipment, category)
            `)
            .eq('workout.user_id', userId)
            .eq('workout.type', 'strength')
            .not('load', 'is', null)
            .not('reps', 'is', null)
            .order('workout(date)', { ascending: true });

        if (error || !data) return [];

        type DateEntry = {
            bestE1rm: number;
            bestSetLoad: number;
            bestSetReps: number;
            totalVolume: number;
            sets: { load: number; reps: number }[];
        };

        const byExercise = new Map<string, { name: string; equipment: string; category: string; byDate: Map<string, DateEntry> }>();

        for (const row of data) {
            const exercise = row.exercise as unknown as { id: string; name: string; equipment: string; category: string };
            const workout = row.workout as unknown as { date: string };
            const bw = exercise.equipment === 'bodyweight';
            const e1rm = bw ? 0 : estimatedOneRepMax(row.load!, row.reps!);
            const vol = bw ? row.reps! : setVolume(row.load!, row.reps!);

            if (!byExercise.has(exercise.id)) {
                byExercise.set(exercise.id, { name: exercise.name, equipment: exercise.equipment, category: exercise.category, byDate: new Map() });
            }

            const entry = byExercise.get(exercise.id)!;
            const dateEntry = entry.byDate.get(workout.date);

            if (!dateEntry) {
                entry.byDate.set(workout.date, {
                    bestE1rm: bw ? row.reps! : Math.round(e1rm * 10) / 10,
                    bestSetLoad: row.load!,
                    bestSetReps: row.reps!,
                    totalVolume: vol,
                    sets: [{ load: row.load!, reps: row.reps! }],
                });
            } else {
                dateEntry.totalVolume += vol;
                dateEntry.sets.push({ load: row.load!, reps: row.reps! });
                if (bw ? row.reps! > dateEntry.bestSetReps : e1rm > dateEntry.bestE1rm) {
                    dateEntry.bestE1rm = bw ? row.reps! : Math.round(e1rm * 10) / 10;
                    dateEntry.bestSetLoad = row.load!;
                    dateEntry.bestSetReps = row.reps!;
                }
            }
        }

        const targetMs = Date.now() - 56 * 24 * 60 * 60 * 1000;

        return Array.from(byExercise.entries()).map(([id, { name, equipment, category, byDate }]) => {
            const isBodyweight = equipment === 'bodyweight';
            const dataPoints: E1RMDataPoint[] = Array.from(byDate.entries()).map(([date, s]) => ({
                date,
                e1rm: s.bestE1rm,
                bestSetLoad: s.bestSetLoad,
                bestSetReps: s.bestSetReps,
                totalVolume: Math.round(s.totalVolume),
                sets: s.sets,
            }));

            const last = dataPoints[dataPoints.length - 1];
            const currentStats: SessionStats = {
                e1rm: last.e1rm,
                bestSetLoad: last.bestSetLoad,
                bestSetReps: last.bestSetReps,
                totalVolume: last.totalVolume,
            };

            const history = dataPoints.slice(0, -1);
            let eightWeeksAgoStats: SessionStats | null = null;
            if (history.length > 0) {
                const closest = history.reduce((best, dp) =>
                    Math.abs(new Date(dp.date).getTime() - targetMs) <
                    Math.abs(new Date(best.date).getTime() - targetMs)
                        ? dp
                        : best
                );
                eightWeeksAgoStats = {
                    e1rm: closest.e1rm,
                    bestSetLoad: closest.bestSetLoad,
                    bestSetReps: closest.bestSetReps,
                    totalVolume: closest.totalVolume,
                };
            }

            const prValue = isBodyweight
                ? Math.max(...dataPoints.map(dp => dp.bestSetReps))
                : Math.max(...dataPoints.map(dp => dp.bestSetLoad));
            const allTimePr = {
                value: prValue,
                label: isBodyweight ? `${prValue} reps` : `${prValue} kg`,
            };

            return {
                exerciseId: id,
                exerciseName: name,
                category,
                isBodyweight,
                dataPoints,
                lastTrained: last.date,
                currentStats,
                eightWeeksAgoStats,
                allTimePr,
            };
        });
    }
}