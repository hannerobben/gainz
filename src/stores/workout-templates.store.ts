import {defineStore} from 'pinia';
import type {WorkoutTemplate} from '../model/workout-template.contract.ts';
import {WorkoutTemplatesApi} from '../supabase/workout-templates.api.ts';

export const useWorkoutTemplatesStore = defineStore('workout-templates-store', {
    state: (): {templates: WorkoutTemplate[]} => ({templates: []}),
    actions: {
        async getAll(userId: string) {
            this.templates = await WorkoutTemplatesApi.getAll(userId);
        }
    }
});
