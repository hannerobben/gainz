grant select, insert, update, delete on public.walks to authenticated;

alter table public.walks enable row level security;

create policy "users manage own walks"
    on public.walks
    for all
    to authenticated
    using (user_id = auth.uid())
    with check (user_id = auth.uid());
