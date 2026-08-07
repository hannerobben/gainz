create table public.walks (
    id          uuid primary key default gen_random_uuid(),
    user_id     uuid not null references public.users(id) on delete cascade,
    date        date not null,
    step_count  integer not null
);

grant select, insert, update, delete on public.walks to anon;