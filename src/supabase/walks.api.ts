import {supabase} from './supabase.ts';
import type {Walk} from '../model/walk.contract.ts';

function toLocalDateStr(date: Date): string {
    return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
}

export class WalksApi {
    public static async getByDate(userId: string, date: Date): Promise<Walk | null> {
        const {data, error} = await supabase
            .from('walks')
            .select('id, step_count')
            .eq('user_id', userId)
            .eq('date', toLocalDateStr(date))
            .maybeSingle();

        if (error || !data) return null;
        return {id: data.id as string, stepCount: data.step_count as number};
    }

    public static async create(date: Date, userId: string, stepCount: number): Promise<void> {
        const {error} = await supabase
            .from('walks')
            .insert({user_id: userId, date: toLocalDateStr(date), step_count: stepCount});

        if (error) throw error;
    }

    public static async update(id: string, stepCount: number): Promise<void> {
        const {error} = await supabase
            .from('walks')
            .update({step_count: stepCount})
            .eq('id', id);

        if (error) throw error;
    }

    public static async delete(id: string): Promise<void> {
        const {error} = await supabase.from('walks').delete().eq('id', id);
        if (error) throw error;
    }

    public static async getDates(userId: string, year: number): Promise<{date: string; stepCount: number}[]> {
        const {data, error} = await supabase
            .from('walks')
            .select('date, step_count')
            .eq('user_id', userId)
            .gte('date', `${year}-01-01`)
            .lte('date', `${year}-12-31`);

        if (error || !data) return [];
        return data.map(r => ({date: r.date as string, stepCount: r.step_count as number}));
    }
}
