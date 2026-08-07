import {defineStore} from 'pinia';
import type {Exercise} from '../model/exercise.contract.ts';
import {ExercisesApi} from '../supabase/exercises.api.ts';

export const useExercisesStore = defineStore('exercises-store', {
    state: (): {exercises: Exercise[]} => ({exercises: []}),
    actions: {
        async getAll() {
            this.exercises = await ExercisesApi.getAll();
        }
    }
});
