-- Allow any authenticated user to read/write any user's data.

drop policy "users manage own workouts" on public.workouts;
create policy "authenticated users manage any workout"
    on public.workouts for all to authenticated
    using (true) with check (true);

drop policy "users manage own workout sets" on public.workout_exercise_sets;
create policy "authenticated users manage any workout set"
    on public.workout_exercise_sets for all to authenticated
    using (true) with check (true);

drop policy "users manage own walks" on public.walks;
create policy "authenticated users manage any walk"
    on public.walks for all to authenticated
    using (true) with check (true);

drop policy "users manage own runs" on public.runs;
create policy "authenticated users manage any run"
    on public.runs for all to authenticated
    using (true) with check (true);
