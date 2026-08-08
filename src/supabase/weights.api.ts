import {supabase} from './supabase.ts';
import type {Weight} from '../model/weight.contract.ts';

function toLocalDateStr(date: Date): string {
    return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
}

export class WeightsApi {
    public static async getAll(userId: string): Promise<Weight[]> {
        const {data, error} = await supabase
            .from('user_weights')
            .select('id, date, weight')
            .eq('user_id', userId)
            .order('date', {ascending: true});

        if (error || !data) return [];
        return data.map(r => ({id: r.id as string, date: r.date as string, weight: Number(r.weight)}));
    }

    public static async getByDate(userId: string, date: Date): Promise<Weight | null> {
        const {data, error} = await supabase
            .from('user_weights')
            .select('id, date, weight')
            .eq('user_id', userId)
            .eq('date', toLocalDateStr(date))
            .maybeSingle();

        if (error || !data) return null;
        return {id: data.id as string, date: data.date as string, weight: Number(data.weight)};
    }

    public static async create(date: Date, userId: string, weight: number): Promise<void> {
        const {error} = await supabase
            .from('user_weights')
            .insert({user_id: userId, date: toLocalDateStr(date), weight});

        if (error) throw error;
    }

    public static async update(id: string, weight: number): Promise<void> {
        const {error} = await supabase
            .from('user_weights')
            .update({weight})
            .eq('id', id);

        if (error) throw error;
    }

    public static async delete(id: string): Promise<void> {
        const {error} = await supabase.from('user_weights').delete().eq('id', id);
        if (error) throw error;
    }
}
