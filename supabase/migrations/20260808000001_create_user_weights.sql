create table public.user_weights (
    id          uuid primary key default gen_random_uuid(),
    user_id     uuid not null references public.users(id) on delete cascade,
    date        date not null,
    weight      numeric not null
);

grant select, insert, update, delete on public.user_weights to anon;
