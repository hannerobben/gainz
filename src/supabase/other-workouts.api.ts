import {supabase} from './supabase.ts';
import type {OtherWorkout} from '../model/other-workout.contract.ts';

function toLocalDateStr(date: Date): string {
    return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
}

export class OtherWorkoutsApi {
    public static async getByDate(userId: string, date: Date, type: string): Promise<OtherWorkout | null> {
        const {data, error} = await supabase
            .from('other_workouts')
            .select('id, type')
            .eq('user_id', userId)
            .eq('date', toLocalDateStr(date))
            .eq('type', type)
            .maybeSingle();

        if (error || !data) return null;
        return {id: data.id as string, type: data.type as string};
    }

    public static async create(date: Date, userId: string, type: string): Promise<void> {
        const {error} = await supabase
            .from('other_workouts')
            .insert({user_id: userId, date: toLocalDateStr(date), type});

        if (error) throw error;
    }

    public static async delete(id: string): Promise<void> {
        const {error} = await supabase.from('other_workouts').delete().eq('id', id);
        if (error) throw error;
    }

    public static async getDates(userId: string, year: number, type: string): Promise<{date: string}[]> {
        const {data, error} = await supabase
            .from('other_workouts')
            .select('date')
            .eq('user_id', userId)
            .eq('type', type)
            .gte('date', `${year}-01-01`)
            .lte('date', `${year}-12-31`);

        if (error || !data) return [];
        return data.map(r => ({date: r.date as string}));
    }
}
