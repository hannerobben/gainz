create type public.workout_type as enum (
    'strength',
    'running',
    'steps'
);

create table public.workouts (
    id         uuid primary key default gen_random_uuid(),
    user_id    uuid not null references public.users(id) on delete cascade,
    date       date not null,
    type       public.workout_type not null
);

create table public.workout_exercise_sets (
    id          uuid primary key default gen_random_uuid(),
    workout_id  uuid not null references public.workouts(id) on delete cascade,
    exercise_id uuid not null references public.strength_exercises(id) on delete restrict,
    set_number  integer not null,
    load        numeric,
    reps        integer
);

grant select, insert, update, delete on public.workouts to anon;
grant select, insert, update, delete on public.workout_exercise_sets to anon;