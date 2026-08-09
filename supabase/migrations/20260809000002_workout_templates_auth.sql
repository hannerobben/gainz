grant select, insert, update, delete on public.workout_templates to authenticated;
grant select, insert, update, delete on public.workout_template_exercises to authenticated;

alter table public.workout_templates enable row level security;
alter table public.workout_template_exercises enable row level security;

create policy "users manage own templates"
    on public.workout_templates
    for all
    to authenticated
    using (user_id = auth.uid())
    with check (user_id = auth.uid());

create policy "users manage own template exercises"
    on public.workout_template_exercises
    for all
    to authenticated
    using (
        template_id in (
            select id from public.workout_templates where user_id = auth.uid()
        )
    )
    with check (
        template_id in (
            select id from public.workout_templates where user_id = auth.uid()
        )
    );
