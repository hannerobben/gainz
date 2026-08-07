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
    dataPoints: E1RMDataPoint[];
    lastTrained: string;
    currentStats: SessionStats;
    eightWeeksAgoStats: SessionStats | null;
}

export class WorkoutApi {
    static async getStrengthProgression(userId: string): Promise<ExerciseProgression[]> {
        const { data, error } = await supabase
            .from('workout_exercise_sets')
            .select(`
                load,
                reps,
                workout:workouts!inner(date, user_id),
                exercise:strength_exercises!inner(id, name)
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

        const byExercise = new Map<string, { name: string; byDate: Map<string, DateEntry> }>();

        for (const row of data) {
            const exercise = row.exercise as unknown as { id: string; name: string };
            const workout = row.workout as unknown as { date: string };
            const e1rm = estimatedOneRepMax(row.load!, row.reps!);
            const vol = setVolume(row.load!, row.reps!);

            if (!byExercise.has(exercise.id)) {
                byExercise.set(exercise.id, { name: exercise.name, byDate: new Map() });
            }

            const entry = byExercise.get(exercise.id)!;
            const dateEntry = entry.byDate.get(workout.date);

            if (!dateEntry) {
                entry.byDate.set(workout.date, {
                    bestE1rm: Math.round(e1rm * 10) / 10,
                    bestSetLoad: row.load!,
                    bestSetReps: row.reps!,
                    totalVolume: vol,
                    sets: [{ load: row.load!, reps: row.reps! }],
                });
            } else {
                dateEntry.totalVolume += vol;
                dateEntry.sets.push({ load: row.load!, reps: row.reps! });
                if (e1rm > dateEntry.bestE1rm) {
                    dateEntry.bestE1rm = Math.round(e1rm * 10) / 10;
                    dateEntry.bestSetLoad = row.load!;
                    dateEntry.bestSetReps = row.reps!;
                }
            }
        }

        const targetMs = Date.now() - 56 * 24 * 60 * 60 * 1000;

        return Array.from(byExercise.entries()).map(([id, { name, byDate }]) => {
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

            return {
                exerciseId: id,
                exerciseName: name,
                dataPoints,
                lastTrained: last.date,
                currentStats,
                eightWeeksAgoStats,
            };
        });
    }
}