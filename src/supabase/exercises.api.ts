import {supabase} from './supabase.ts';
import type {Exercise} from '../model/exercise.contract.ts';

export class ExercisesApi {
    public static async getAll(): Promise<Exercise[]> {
        const {data, error} = await supabase.from('strength_exercises').select('*');
        if (error) return [];
        return data ?? [];
    }
}
