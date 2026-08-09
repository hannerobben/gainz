import type {Exercise} from './exercise.contract.ts';

export interface WorkoutTemplate {
    id: string;
    name: string;
    created_at: string;
    exercises: Exercise[];
}
