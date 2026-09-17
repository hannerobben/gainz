create table public.other_workouts (
    id          uuid primary key default gen_random_uuid(),
    user_id     uuid not null references public.users(id) on delete cascade,
    date        date not null,
    type        text not null
);

grant select, insert, update, delete on public.other_workouts to anon;
