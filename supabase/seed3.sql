-- Workout templates for L-sit and Handstand progressions.
-- Assigns templates to the first user found in public.users.
-- Run seed2.sql first so the referenced exercises exist.

do $$
declare
    uid            uuid;

    -- template ids
    lsit1_id       uuid;
    lsit2_id       uuid;
    lsit3_id       uuid;
    lsit4_id       uuid;

    hs1_id         uuid;
    hs2_id         uuid;
    hs3_id         uuid;
    hs4_id         uuid;

    -- exercise ids — L-sit track
    ex_support     uuid;
    ex_seated_lr   uuid;
    ex_tuck_lsit   uuid;
    ex_oneleg_lsit uuid;
    ex_straddle    uuid;
    ex_lsit        uuid;
    ex_hang_lr     uuid;
    ex_dead_bug    uuid;
    ex_plank       uuid;

    -- exercise ids — handstand track
    ex_pike_pu     uuid;
    ex_wall_plank  uuid;
    ex_donkey      uuid;
    ex_frog        uuid;
    ex_wall_hs     uuid;
    ex_hs_tap      uuid;
    ex_hspu        uuid;
    ex_free_hs     uuid;
begin
    -- resolve user
    select id into uid from public.users limit 1;
    if uid is null then
        raise exception 'No users found — create a user before running this seed.';
    end if;

    -- resolve exercise ids
    select id into ex_support     from public.strength_exercises where name = 'Parallel Bar Support Hold';
    select id into ex_seated_lr   from public.strength_exercises where name = 'Seated Leg Raise';
    select id into ex_tuck_lsit   from public.strength_exercises where name = 'Tuck L-Sit';
    select id into ex_oneleg_lsit from public.strength_exercises where name = 'One-Leg L-Sit';
    select id into ex_straddle    from public.strength_exercises where name = 'Straddle L-Sit';
    select id into ex_lsit        from public.strength_exercises where name = 'L-Sit';
    select id into ex_hang_lr     from public.strength_exercises where name = 'Hanging Leg Raise';
    select id into ex_dead_bug    from public.strength_exercises where name = 'Dead Bug';
    select id into ex_plank       from public.strength_exercises where name = 'Plank';

    select id into ex_pike_pu     from public.strength_exercises where name = 'Pike Push-Up';
    select id into ex_wall_plank  from public.strength_exercises where name = 'Wall Plank';
    select id into ex_donkey      from public.strength_exercises where name = 'Donkey Kick';
    select id into ex_frog        from public.strength_exercises where name = 'Frog Stand';
    select id into ex_wall_hs     from public.strength_exercises where name = 'Wall Handstand Hold';
    select id into ex_hs_tap      from public.strength_exercises where name = 'Handstand Shoulder Tap';
    select id into ex_hspu        from public.strength_exercises where name = 'Handstand Push-Up';
    select id into ex_free_hs     from public.strength_exercises where name = 'Freestanding Handstand';

    -- ─── L-sit Level 1 — Support & Compression Foundation ───────────────────
    -- Goal: build locked-arm support holds and first hip-flexor compression.
    -- Target: 3 × 20 s support hold, able to lift feet slightly in seated raise.
    insert into public.workout_templates (user_id, name)
        values (uid, 'L-sit Level 1 — Support & Compression')
        returning id into lsit1_id;

    insert into public.workout_template_exercises (template_id, exercise_id, position) values
        (lsit1_id, ex_plank,     1),   -- core base
        (lsit1_id, ex_dead_bug,  2),   -- anti-extension core control
        (lsit1_id, ex_seated_lr, 3),   -- hip flexor compression
        (lsit1_id, ex_support,   4);   -- straight-arm support hold

    -- ─── L-sit Level 2 — Tuck L-Sit ─────────────────────────────────────────
    -- Goal: hold a tuck L-sit with feet fully off the floor.
    -- Target: 3 × 15 s tuck hold on parallettes or dip bars.
    insert into public.workout_templates (user_id, name)
        values (uid, 'L-sit Level 2 — Tuck Hold')
        returning id into lsit2_id;

    insert into public.workout_template_exercises (template_id, exercise_id, position) values
        (lsit2_id, ex_seated_lr,  1),  -- compression warm-up
        (lsit2_id, ex_support,    2),  -- reinforce locked-arm support
        (lsit2_id, ex_hang_lr,    3),  -- hip flexor strength from hang
        (lsit2_id, ex_tuck_lsit,  4);  -- main skill work

    -- ─── L-sit Level 3 — One-Leg & Straddle ─────────────────────────────────
    -- Goal: extend one or both legs partially — bridge to full L-sit.
    -- Target: 3 × 10 s each side one-leg, 3 × 10 s straddle.
    insert into public.workout_templates (user_id, name)
        values (uid, 'L-sit Level 3 — One-Leg & Straddle')
        returning id into lsit3_id;

    insert into public.workout_template_exercises (template_id, exercise_id, position) values
        (lsit3_id, ex_seated_lr,   1),  -- compression
        (lsit3_id, ex_hang_lr,     2),  -- hip flexor loading
        (lsit3_id, ex_tuck_lsit,   3),  -- warm into the skill
        (lsit3_id, ex_oneleg_lsit, 4),  -- one-leg work
        (lsit3_id, ex_straddle,    5);  -- straddle work

    -- ─── L-sit Level 4 — Full L-Sit ──────────────────────────────────────────
    -- Goal: hold a full L-sit with both legs extended and horizontal.
    -- Target: 3 × 10 s full L-sit.
    insert into public.workout_templates (user_id, name)
        values (uid, 'L-sit Level 4 — Full L-Sit')
        returning id into lsit4_id;

    insert into public.workout_template_exercises (template_id, exercise_id, position) values
        (lsit4_id, ex_seated_lr,   1),  -- compression activation
        (lsit4_id, ex_hang_lr,     2),  -- hip flexor loading
        (lsit4_id, ex_oneleg_lsit, 3),  -- warm-up into full
        (lsit4_id, ex_straddle,    4),  -- straddle attempts
        (lsit4_id, ex_lsit,        5);  -- full L-sit

    -- ─── Handstand Level 1 — Wrist Prep & Basic Inversion ───────────────────
    -- Goal: condition wrists, build shoulder pressing base, get comfortable inverted.
    -- Target: 3 × 10 pike push-ups, 3 × 20 s wall plank, frog stand balance attempts.
    insert into public.workout_templates (user_id, name)
        values (uid, 'Handstand Level 1 — Wrist Prep & Inversion')
        returning id into hs1_id;

    insert into public.workout_template_exercises (template_id, exercise_id, position) values
        (hs1_id, ex_plank,      1),  -- shoulder endurance base
        (hs1_id, ex_pike_pu,    2),  -- vertical pressing strength
        (hs1_id, ex_wall_plank, 3),  -- inverted body position
        (hs1_id, ex_frog,       4);  -- hand-balance intro

    -- ─── Handstand Level 2 — Wall Handstand ──────────────────────────────────
    -- Goal: hold a straight-body chest-to-wall handstand with confidence.
    -- Target: 3 × 30 s wall handstand hold, comfortable kick-up.
    insert into public.workout_templates (user_id, name)
        values (uid, 'Handstand Level 2 — Wall Handstand')
        returning id into hs2_id;

    insert into public.workout_template_exercises (template_id, exercise_id, position) values
        (hs2_id, ex_pike_pu,    1),  -- pressing strength
        (hs2_id, ex_wall_plank, 2),  -- 90° alignment drill
        (hs2_id, ex_donkey,     3),  -- kick-up practice
        (hs2_id, ex_wall_hs,    4);  -- main hold work

    -- ─── Handstand Level 3 — Balance & Shoulder Taps ────────────────────────
    -- Goal: develop one-arm weight shift and midline stability on the wall.
    -- Target: 3 × 5 shoulder taps each side, 3 × 45 s wall handstand.
    insert into public.workout_templates (user_id, name)
        values (uid, 'Handstand Level 3 — Balance & Shoulder Taps')
        returning id into hs3_id;

    insert into public.workout_template_exercises (template_id, exercise_id, position) values
        (hs3_id, ex_wall_hs,  1),  -- quality hold warm-up
        (hs3_id, ex_hs_tap,   2),  -- shoulder tap drills
        (hs3_id, ex_pike_pu,  3),  -- elevated pike push-ups
        (hs3_id, ex_free_hs,  4);  -- first freestanding attempts (bail freely)

    -- ─── Handstand Level 4 — Freestanding & HSPU ────────────────────────────
    -- Goal: achieve a freestanding handstand hold and begin handstand push-ups.
    -- Target: 5 s freestanding hold, 3 × 3 handstand push-ups on the wall.
    insert into public.workout_templates (user_id, name)
        values (uid, 'Handstand Level 4 — Freestanding & HSPU')
        returning id into hs4_id;

    insert into public.workout_template_exercises (template_id, exercise_id, position) values
        (hs4_id, ex_wall_hs,  1),  -- quality hold warm-up
        (hs4_id, ex_hs_tap,   2),  -- balance drills
        (hs4_id, ex_free_hs,  3),  -- freestanding skill work
        (hs4_id, ex_hspu,     4);  -- handstand push-ups

end $$;