import type {Exercise} from './exercise.contract.ts';

export interface WorkoutSet {
    load: number | null;
    reps: number | null;
}

export interface WorkoutExerciseEntry {
    exercise: Exercise;
    sets: WorkoutSet[];
}

export interface Workout {
    id: string;
    date: string;
    entries: WorkoutExerciseEntry[];
}
