grant select, insert, update, delete on public.workouts to authenticated;
grant select, insert, update, delete on public.workout_exercise_sets to authenticated;

alter table public.workouts enable row level security;
alter table public.workout_exercise_sets enable row level security;

create policy "users manage own workouts"
    on public.workouts
    for all
    to authenticated
    using (user_id = auth.uid())
    with check (user_id = auth.uid());

create policy "users manage own workout sets"
    on public.workout_exercise_sets
    for all
    to authenticated
    using (
        exists (
            select 1 from public.workouts w
            where w.id = workout_exercise_sets.workout_id
            and w.user_id = auth.uid()
        )
    )
    with check (
        exists (
            select 1 from public.workouts w
            where w.id = workout_exercise_sets.workout_id
            and w.user_id = auth.uid()
        )
    );
