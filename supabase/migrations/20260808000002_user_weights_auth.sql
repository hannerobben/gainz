grant select, insert, update, delete on public.user_weights to authenticated;

alter table public.user_weights enable row level security;

create policy "users manage own weights"
    on public.user_weights
    for all
    to authenticated
    using (user_id = auth.uid())
    with check (user_id = auth.uid());
