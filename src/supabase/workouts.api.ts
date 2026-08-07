import {supabase} from './supabase.ts';
import type {Workout, WorkoutExerciseEntry} from '../model/workout.contract.ts';
import type {Exercise} from '../model/exercise.contract.ts';

function toLocalDateStr(date: Date): string {
    return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
}

export class WorkoutsApi {
    public static async create(date: Date, userId: string, entries: WorkoutExerciseEntry[]): Promise<void> {
        const dateStr = toLocalDateStr(date);

        const {data: workout, error: workoutError} = await supabase
            .from('workouts')
            .insert({user_id: userId, date: dateStr, type: 'strength'})
            .select('id')
            .single();

        if (workoutError || !workout) throw workoutError;

        const sets = entries.flatMap((entry, _ei) =>
            entry.sets.map((set, si) => ({
                workout_id: workout.id,
                exercise_id: entry.exercise.id,
                set_number: si + 1,
                load: set.load,
                reps: set.reps
            }))
        );

        if (sets.length === 0) return;

        const {error: setsError} = await supabase.from('workout_exercise_sets').insert(sets);
        if (setsError) throw setsError;
    }

    public static async getByDate(userId: string, date: Date): Promise<Workout | null> {
        const dateStr = toLocalDateStr(date);

        const {data, error} = await supabase
            .from('workouts')
            .select(`
                id,
                workout_exercise_sets (
                    set_number, load, reps,
                    exercise:strength_exercises (
                        id, name, description, image_url, category, movement_pattern, muscle_groups, equipment
                    )
                )
            `)
            .eq('user_id', userId)
            .eq('date', dateStr)
            .eq('type', 'strength')
            .maybeSingle();

        if (error || !data) return null;

        type RawSet = {set_number: number; load: number | null; reps: number | null; exercise: Exercise};
        const raw = (data.workout_exercise_sets as unknown as RawSet[]).sort((a, b) => a.set_number - b.set_number);

        const exerciseMap = new Map<string, WorkoutExerciseEntry>();
        for (const s of raw) {
            if (!exerciseMap.has(s.exercise.id)) {
                exerciseMap.set(s.exercise.id, {exercise: s.exercise, sets: []});
            }
            exerciseMap.get(s.exercise.id)!.sets.push({load: s.load, reps: s.reps});
        }

        return {id: data.id, date: dateStr, entries: Array.from(exerciseMap.values())};
    }

    public static async getAll(userId: string): Promise<Workout[]> {
        const {data, error} = await supabase
            .from('workouts')
            .select(`
                id,
                date,
                workout_exercise_sets (
                    set_number, load, reps,
                    exercise:strength_exercises (
                        id, name, description, image_url, category, movement_pattern, muscle_groups, equipment
                    )
                )
            `)
            .eq('user_id', userId)
            .eq('type', 'strength')
            .order('date', {ascending: false});

        if (error || !data) return [];

        type RawSet = {set_number: number; load: number | null; reps: number | null; exercise: Exercise};

        return data.map(workout => {
            const raw = (workout.workout_exercise_sets as unknown as RawSet[]).sort(
                (a, b) => a.set_number - b.set_number
            );
            const exerciseMap = new Map<string, WorkoutExerciseEntry>();
            for (const s of raw) {
                if (!exerciseMap.has(s.exercise.id)) {
                    exerciseMap.set(s.exercise.id, {exercise: s.exercise, sets: []});
                }
                exerciseMap.get(s.exercise.id)!.sets.push({load: s.load, reps: s.reps});
            }
            return {id: workout.id, date: workout.date, entries: Array.from(exerciseMap.values())};
        });
    }

    public static async update(workoutId: string, entries: WorkoutExerciseEntry[]): Promise<void> {
        const {error: deleteError} = await supabase
            .from('workout_exercise_sets')
            .delete()
            .eq('workout_id', workoutId);

        if (deleteError) throw deleteError;

        const sets = entries.flatMap((entry, _ei) =>
            entry.sets.map((set, si) => ({
                workout_id: workoutId,
                exercise_id: entry.exercise.id,
                set_number: si + 1,
                load: set.load,
                reps: set.reps
            }))
        );

        if (sets.length === 0) return;

        const {error: setsError} = await supabase.from('workout_exercise_sets').insert(sets);
        if (setsError) throw setsError;
    }

    public static async delete(workoutId: string): Promise<void> {
        const {error} = await supabase.from('workouts').delete().eq('id', workoutId);
        if (error) throw error;
    }

    public static async getDates(userId: string, year: number): Promise<{date: string; type: string}[]> {
        const {data, error} = await supabase
            .from('workouts')
            .select('date, type')
            .eq('user_id', userId)
            .gte('date', `${year}-01-01`)
            .lte('date', `${year}-12-31`);

        if (error || !data) return [];
        return data as {date: string; type: string}[];
    }
}
