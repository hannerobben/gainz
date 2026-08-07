create table public.runs (
    id          uuid primary key default gen_random_uuid(),
    user_id     uuid not null references public.users(id) on delete cascade,
    date        date not null,
    duration    integer not null,
    distance    numeric not null
);

grant select, insert, update, delete on public.runs to anon;
