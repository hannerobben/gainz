import {supabase} from './supabase.ts';
import type {WorkoutTemplate} from '../model/workout-template.contract.ts';
import type {Exercise} from '../model/exercise.contract.ts';

export class WorkoutTemplatesApi {
    public static async getAll(userId: string): Promise<WorkoutTemplate[]> {
        const {data, error} = await supabase
            .from('workout_templates')
            .select('id, name, created_at, workout_template_exercises(position, exercise:strength_exercises(*))')
            .eq('user_id', userId)
            .order('created_at', {ascending: false});

        if (error || !data) return [];

        return data.map(row => ({
            id: row.id as string,
            name: row.name as string,
            created_at: row.created_at as string,
            exercises: (row.workout_template_exercises as unknown as {position: number; exercise: Exercise}[])
                .sort((a, b) => a.position - b.position)
                .map(te => te.exercise)
        }));
    }

    public static async create(userId: string, name: string, exerciseIds: string[]): Promise<void> {
        const {data, error} = await supabase
            .from('workout_templates')
            .insert({user_id: userId, name})
            .select('id')
            .single();

        if (error || !data) throw error ?? new Error('Failed to create template');

        const templateId = data.id as string;
        const entries = exerciseIds.map((exerciseId, position) => ({
            template_id: templateId,
            exercise_id: exerciseId,
            position
        }));

        const {error: linkError} = await supabase
            .from('workout_template_exercises')
            .insert(entries);

        if (linkError) throw linkError;
    }

    public static async update(templateId: string, name: string, exerciseIds: string[]): Promise<void> {
        const {error: nameError} = await supabase
            .from('workout_templates')
            .update({name})
            .eq('id', templateId);

        if (nameError) throw nameError;

        const {error: deleteError} = await supabase
            .from('workout_template_exercises')
            .delete()
            .eq('template_id', templateId);

        if (deleteError) throw deleteError;

        const entries = exerciseIds.map((exerciseId, position) => ({
            template_id: templateId,
            exercise_id: exerciseId,
            position
        }));

        const {error: insertError} = await supabase
            .from('workout_template_exercises')
            .insert(entries);

        if (insertError) throw insertError;
    }
}
