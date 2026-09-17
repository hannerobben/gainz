create table public.future_workouts (
    id          uuid primary key default gen_random_uuid(),
    user_id     uuid not null references public.users(id) on delete cascade,
    date        date not null,
    type        text not null
);

grant select, insert, update, delete on public.future_workouts to anon;
