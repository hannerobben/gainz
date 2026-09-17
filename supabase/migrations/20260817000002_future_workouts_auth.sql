grant select, insert, update, delete on public.future_workouts to authenticated;

alter table public.future_workouts enable row level security;

create policy "users manage own future workouts"
    on public.future_workouts
    for all
    to authenticated
    using (user_id = auth.uid())
    with check (user_id = auth.uid());
