export type ExerciseCategory = 'push' | 'pull' | 'legs' | 'core';

export type MovementPattern =
    | 'horizontal_push'
    | 'vertical_push'
    | 'horizontal_pull'
    | 'vertical_pull'
    | 'knee_dominant'
    | 'hip_dominant'
    | 'carry'
    | 'core'
    | 'accessory';

export type Equipment =
    | 'barbell'
    | 'dumbbell'
    | 'machine'
    | 'cable'
    | 'bodyweight'
    | 'kettlebell';

export interface Exercise {
    id: string;
    name: string;
    description: string | null;
    image_url: string | null;
    category: ExerciseCategory;
    movement_pattern: MovementPattern;
    muscle_groups: string[];
    equipment: Equipment;
}