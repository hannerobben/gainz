import {supabase} from './supabase.ts';
import type {AppUserContract} from '../model/user.contract.ts';
import type {User} from '@supabase/supabase-js';

export class AuthApi {
    public static async getAuthUser(): Promise<User | null> {
        const { data } = await supabase.auth.getSession();
        return data.session?.user || null;
    }

    public static async getAppUser(authUserId: string): Promise<AppUserContract | undefined> {
        const { data, error } = await supabase
            .from('users')
            .select('*')
            .eq('id', authUserId)
            .single();

        if (error) return undefined;
        return data ?? undefined;
    }

    public static async getAllUsers(): Promise<AppUserContract[]> {
        const {data, error} = await supabase.from('users').select('*').order('display_name');
        if (error) return [];
        return data ?? [];
    }
}
