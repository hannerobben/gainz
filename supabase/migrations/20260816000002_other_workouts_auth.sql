grant select, insert, update, delete on public.other_workouts to authenticated;

alter table public.other_workouts enable row level security;

create policy "users manage own other workouts"
    on public.other_workouts
    for all
    to authenticated
    using (user_id = auth.uid())
    with check (user_id = auth.uid());
