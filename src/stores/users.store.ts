import {defineStore} from 'pinia';
import type {AppUserContract} from '../model/user.contract.ts';
import {AuthApi} from '../supabase/auth.api.ts';

export const useUsersStore = defineStore('users-store', {
    state: (): {
        allUsers: AppUserContract[];
        activeUser: AppUserContract | null;
    } => ({allUsers: [], activeUser: null}),
    actions: {
        async loadUsers(authUserId: string) {
            this.allUsers = await AuthApi.getAllUsers();
            this.activeUser = this.allUsers.find(u => u.id === authUserId) ?? null;
        },
        setActiveUser(user: AppUserContract) {
            this.activeUser = user;
        }
    }
});
