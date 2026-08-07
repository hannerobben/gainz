create type public.exercise_category as enum (
    'push',
    'pull',
    'legs',
    'core'
);

create type public.movement_pattern as enum (
    'horizontal_push',
    'vertical_push',
    'horizontal_pull',
    'vertical_pull',
    'knee_dominant',
    'hip_dominant',
    'carry',
    'core',
    'accessory'
);

create type public.equipment as enum (
    'barbell',
    'dumbbell',
    'machine',
    'cable',
    'bodyweight',
    'kettlebell'
);

create table public.strength_exercises (
    id               uuid primary key default gen_random_uuid(),
    name             text not null,
    description      text,
    image_url        text,
    category         public.exercise_category not null,
    movement_pattern public.movement_pattern not null,
    muscle_groups    text[] not null default '{}',
    equipment        public.equipment not null
);

grant select, insert, update, delete on public.strength_exercises to anon;
