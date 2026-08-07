grant select, insert, update, delete on public.runs to authenticated;

alter table public.runs enable row level security;

create policy "users manage own runs"
    on public.runs
    for all
    to authenticated
    using (user_id = auth.uid())
    with check (user_id = auth.uid());
