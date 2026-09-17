import {supabase} from './supabase.ts';
import type {FutureWorkout} from '../model/future-workout.contract.ts';

function toLocalDateStr(date: Date): string {
    return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
}

export class FutureWorkoutsApi {
    public static async getByDate(userId: string, date: Date): Promise<FutureWorkout[]> {
        const {data, error} = await supabase
            .from('future_workouts')
            .select('id, type')
            .eq('user_id', userId)
            .eq('date', toLocalDateStr(date));

        if (error || !data) return [];
        return data.map(r => ({id: r.id as string, type: r.type as string}));
    }

    public static async create(date: Date, userId: string, type: string): Promise<void> {
        const {error} = await supabase
            .from('future_workouts')
            .insert({user_id: userId, date: toLocalDateStr(date), type});

        if (error) throw error;
    }

    public static async delete(id: string): Promise<void> {
        const {error} = await supabase.from('future_workouts').delete().eq('id', id);
        if (error) throw error;
    }

    public static async getDates(userId: string, year: number): Promise<{date: string; type: string}[]> {
        const {data, error} = await supabase
            .from('future_workouts')
            .select('date, type')
            .eq('user_id', userId)
            .gte('date', `${year}-01-01`)
            .lte('date', `${year}-12-31`);

        if (error || !data) return [];
        return data.map(r => ({date: r.date as string, type: r.type as string}));
    }
}
