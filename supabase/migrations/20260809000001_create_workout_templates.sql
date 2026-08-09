create table public.workout_templates (
    id         uuid primary key default gen_random_uuid(),
    user_id    uuid not null references public.users(id) on delete cascade,
    name       text not null,
    created_at timestamptz not null default now()
);

create table public.workout_template_exercises (
    id          uuid primary key default gen_random_uuid(),
    template_id uuid not null references public.workout_templates(id) on delete cascade,
    exercise_id uuid not null references public.strength_exercises(id) on delete restrict,
    position    integer not null
);

grant select, insert, update, delete on public.workout_templates to anon;
grant select, insert, update, delete on public.workout_template_exercises to anon;
