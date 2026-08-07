import {supabase} from './supabase.ts';
import type {Run} from '../model/run.contract.ts';

function toLocalDateStr(date: Date): string {
    return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
}

export class RunsApi {
    public static async getByDate(userId: string, date: Date): Promise<Run | null> {
        const {data, error} = await supabase
            .from('runs')
            .select('id, duration, distance')
            .eq('user_id', userId)
            .eq('date', toLocalDateStr(date))
            .maybeSingle();

        if (error || !data) return null;
        return {id: data.id as string, duration: data.duration as number, distance: Number(data.distance)};
    }

    public static async create(date: Date, userId: string, duration: number, distance: number): Promise<void> {
        const {error} = await supabase
            .from('runs')
            .insert({user_id: userId, date: toLocalDateStr(date), duration, distance});

        if (error) throw error;
    }

    public static async update(id: string, duration: number, distance: number): Promise<void> {
        const {error} = await supabase
            .from('runs')
            .update({duration, distance})
            .eq('id', id);

        if (error) throw error;
    }

    public static async delete(id: string): Promise<void> {
        const {error} = await supabase.from('runs').delete().eq('id', id);
        if (error) throw error;
    }

    public static async getDates(userId: string, year: number): Promise<{date: string; duration: number; distance: number}[]> {
        const {data, error} = await supabase
            .from('runs')
            .select('date, duration, distance')
            .eq('user_id', userId)
            .gte('date', `${year}-01-01`)
            .lte('date', `${year}-12-31`);

        if (error || !data) return [];
        return data.map(r => ({date: r.date as string, duration: r.duration as number, distance: Number(r.distance)}));
    }
}
