insert into public.strength_exercises (name, description, category, movement_pattern, muscle_groups, equipment) values
    -- L-sit prep
    ('Parallel Bar Support Hold', 'Isometric hold on parallel bars with straight arms and body suspended above the bars.', 'core', 'core', '{"triceps","shoulders","core"}', 'bodyweight'),
    ('Seated Leg Raise', 'Seated on the floor in a pike, press both hands into the floor and attempt to lift the legs — trains hip flexor compression for L-sit.', 'core', 'core', '{"hip_flexors","core","quads"}', 'bodyweight'),
    ('Tuck L-Sit', 'L-sit progression with knees bent and tucked, feet off the floor, body suspended on hands.', 'core', 'core', '{"core","hip_flexors","triceps","shoulders"}', 'bodyweight'),
    ('One-Leg L-Sit', 'L-sit progression with one leg fully extended horizontal and one leg tucked.', 'core', 'core', '{"core","hip_flexors","quads","triceps"}', 'bodyweight'),
    ('L-Sit', 'Full L-sit with both legs extended horizontal and body suspended on the hands.', 'core', 'core', '{"core","hip_flexors","quads","triceps","shoulders"}', 'bodyweight'),
    ('Straddle L-Sit', 'L-sit variation with legs straddled wide — slightly easier than full L-sit due to shorter lever arm.', 'core', 'core', '{"core","hip_flexors","quads","triceps","shoulders"}', 'bodyweight'),

    -- Handstand prep
    ('Pike Push-Up', 'Push-up from a pike (inverted-V) position to build pressing strength for handstand push-ups.', 'push', 'vertical_push', '{"shoulders","triceps","upper_chest"}', 'bodyweight'),
    ('Wall Plank', 'Feet on wall, hands on floor with body forming a 90° angle — foundational inverted pressing position.', 'push', 'vertical_push', '{"shoulders","core","triceps"}', 'bodyweight'),
    ('Donkey Kick', 'From a pike position, kick both feet up toward a handstand to practice the kick-up motion and air awareness.', 'push', 'vertical_push', '{"shoulders","core"}', 'bodyweight'),
    ('Frog Stand', 'Balance on both hands with knees resting on the backs of your triceps — the entry point to hand balancing.', 'push', 'vertical_push', '{"shoulders","core","wrists"}', 'bodyweight'),
    ('Wall Handstand Hold', 'Handstand with heels against the wall for supported balance and straight-body alignment practice.', 'push', 'vertical_push', '{"shoulders","triceps","core","wrists"}', 'bodyweight'),
    ('Handstand Shoulder Tap', 'Wall handstand with alternating shoulder taps to train one-arm balance and midline stability.', 'push', 'vertical_push', '{"shoulders","core","wrists"}', 'bodyweight'),
    ('Handstand Push-Up', 'Full-range press from handstand: lower until the crown of the head touches the floor and press back to lockout.', 'push', 'vertical_push', '{"shoulders","triceps","upper_chest"}', 'bodyweight'),
    ('Freestanding Handstand', 'Unsupported handstand balance away from the wall — the goal of the handstand progression.', 'push', 'vertical_push', '{"shoulders","core","wrists","forearms"}', 'bodyweight'),

    -- Other calisthenics skills
    ('Pistol Squat', 'Single-leg squat to full depth with the non-working leg extended forward throughout.', 'legs', 'knee_dominant', '{"quads","glutes","hamstrings","core"}', 'bodyweight'),
    ('Dragon Flag', 'Full-body lever from a bench: from a vertical position lower a rigid plank body toward horizontal and press back up.', 'core', 'core', '{"core","lats","shoulders","hip_flexors"}', 'bodyweight'),
    ('Tuck Front Lever', 'Front lever progression: hang from a bar horizontally with knees tucked to chest.', 'pull', 'horizontal_pull', '{"lats","core","shoulders","biceps"}', 'bodyweight'),
    ('Front Lever', 'Full front lever — hang from a bar with the body rigid and perfectly horizontal, legs fully extended.', 'pull', 'horizontal_pull', '{"lats","core","shoulders","biceps"}', 'bodyweight'),
    ('Ring Dip', 'Dip performed on gymnastic rings with added instability and shoulder-stability demands.', 'push', 'vertical_push', '{"chest","triceps","shoulders"}', 'bodyweight'),
    ('Muscle-Up', 'Explosive pull-up that transitions above the bar or rings into a dip lockout.', 'pull', 'vertical_pull', '{"lats","biceps","triceps","shoulders","chest"}', 'bodyweight');

-- ─── L-sit prep ───────────────────────────────────────────────────────────────

update public.strength_exercises set how_to = $howto$
<h2>How to Parallel Bar Support Hold</h2>
<ol>
  <li><strong>Set up</strong>: grip two parallel bars (dip bars, gymnastics p-bars, chairs, or push-up handles) at roughly hip width. Grip firmly with wrists neutral.</li>
  <li><strong>Mount</strong>: jump or press yourself up so your arms are fully locked out and your body is suspended above the bars.</li>
  <li><strong>Body position</strong>: depress your shoulder blades (push your shoulders down away from your ears), squeeze your glutes, and point your toes down. Keep your torso upright.</li>
  <li><strong>Hold</strong>: breathe steadily and maintain the locked-arm, depressed-shoulder position for the target duration.</li>
  <li><strong>Dismount</strong>: lower yourself down under control — do not drop.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Shrugging the shoulders</strong>: letting the shoulders rise toward the ears collapses the support position and puts strain on the neck. Actively push your shoulders down throughout.</li>
  <li><strong>Bent elbows</strong>: the support hold requires fully locked arms. If you cannot lock out, build tricep strength with dips first.</li>
  <li><strong>Piked or leaning hips</strong>: keep your torso vertical. Do not lean forward excessively or let your hips drift behind the bar line.</li>
  <li><strong>Not breathing</strong>: holding your breath cuts the hold short. Practise slow nasal breathing through the hold.</li>
</ul>
$howto$ where name = 'Parallel Bar Support Hold';

update public.strength_exercises set how_to = $howto$
<h2>How to Seated Leg Raise</h2>
<ol>
  <li><strong>Start position</strong>: sit on the floor with legs fully extended in front of you, hands flat beside your hips, fingers pointing forward. Sit tall with a neutral spine.</li>
  <li><strong>Press</strong>: push both palms firmly into the floor and attempt to lift your legs off the ground by flexing your hip flexors. Your aim is to create as much compression as possible.</li>
  <li><strong>Lift</strong>: if you can, lift both legs a few centimetres off the floor while keeping them straight. Hold for 1–3 seconds.</li>
  <li><strong>Lower under control</strong>: bring the legs back down slowly without losing spinal position.</li>
  <li><strong>Progress</strong>: as hip flexor strength improves, lift higher and hold longer. Eventually perform these on elevated surfaces (parallettes, books) to allow more range.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Rounding the lower back</strong>: if your pelvis tilts back and your lower back rounds, you have lost the position. Focus on sitting tall before pressing.</li>
  <li><strong>Bending the knees</strong>: this shortens the lever and makes the exercise easier but less specific to L-sit. Keep legs fully straight.</li>
  <li><strong>Pushing off the floor with momentum</strong>: the lift must come from hip flexor compression, not a floor bounce. Slow and deliberate.</li>
  <li><strong>Weak wrist position</strong>: if wrists hurt, use fists or parallettes to take the wrists out of extension.</li>
</ul>
$howto$ where name = 'Seated Leg Raise';

update public.strength_exercises set how_to = $howto$
<h2>How to Tuck L-Sit</h2>
<ol>
  <li><strong>Set up</strong>: use parallel bars, parallettes, dip bars, or the floor with hands beside your hips. Assume the support hold with arms locked and shoulders depressed.</li>
  <li><strong>Tuck</strong>: lift both feet off the floor by bending your knees and drawing them toward your chest. Keep elbows locked and shoulders down.</li>
  <li><strong>Hold</strong>: maintain the tuck with your shins roughly parallel to the floor. Breathe steadily. Aim for 3 × 10–15 seconds before progressing.</li>
  <li><strong>Lower</strong>: set your feet down under control rather than dropping suddenly.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Shoulders rising toward the ears</strong>: the moment shoulders shrug, the support structure collapses. Keep them depressed throughout.</li>
  <li><strong>Bent arms</strong>: the arms must remain fully locked. Bent arms indicate you need more support-hold strength first.</li>
  <li><strong>Hips dropping below the hands</strong>: if your hips are very low, elevate the surface (use higher parallettes) so you have room to tuck without touching the floor.</li>
  <li><strong>Holding breath</strong>: practice breathing through the hold from the start; this becomes critical in the full L-sit.</li>
</ul>
$howto$ where name = 'Tuck L-Sit';

update public.strength_exercises set how_to = $howto$
<h2>How to One-Leg L-Sit</h2>
<ol>
  <li><strong>Start from a tuck L-sit</strong>: assume your tuck position with both knees tucked and body suspended.</li>
  <li><strong>Extend one leg</strong>: straighten one leg fully so it is horizontal and parallel to the floor. Keep the other leg tucked.</li>
  <li><strong>Hold</strong>: breathe and maintain the position. The extended leg increases the lever on that side of the hip — resist with your hip flexor and core. Aim for 3 × 5–10 seconds each side.</li>
  <li><strong>Switch</strong>: tuck the extended leg, extend the other, or alternate between sets.</li>
  <li><strong>Progress</strong>: when each side feels solid, work on extending both legs simultaneously to reach the full L-sit.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Letting the extended leg drop</strong>: the leg must be horizontal, not angled toward the floor. If it sags, your hip flexor compression is the limiting factor — train seated leg raises.</li>
  <li><strong>Rotating toward the extended leg</strong>: the hips should remain level. Avoid twisting your torso to compensate.</li>
  <li><strong>Losing shoulder depression on the loaded side</strong>: the shoulder on the side of the extended leg tends to rise. Keep both shoulders equally depressed.</li>
</ul>
$howto$ where name = 'One-Leg L-Sit';

update public.strength_exercises set how_to = $howto$
<h2>How to L-Sit</h2>
<ol>
  <li><strong>Set up</strong>: use parallettes, parallel bars, or dip bars. Assume the support hold: arms locked, shoulders depressed, body upright.</li>
  <li><strong>Compress</strong>: engage your hip flexors forcefully and raise both legs simultaneously until they are fully extended and horizontal — your body forms the letter L.</li>
  <li><strong>Active position</strong>: toes pointed, quads tight so knees are locked, lower back slightly rounded to tilt the pelvis, shoulders pressed down. Every muscle is working.</li>
  <li><strong>Hold</strong>: breathe shallowly and maintain the position. Any duration is a win — build toward 3 × 10 seconds, then 3 × 30 seconds over months.</li>
  <li><strong>Lower</strong>: slowly release the legs down rather than collapsing.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Legs below horizontal</strong>: the legs must be at least parallel to the floor. Below horizontal is not an L-sit — it is a tuck or partial. Train the one-leg variant until compression is strong enough.</li>
  <li><strong>Bent knees</strong>: lock the quads. Bent knees shorten the lever and are a sign the hip flexors are not yet strong enough for the full position.</li>
  <li><strong>Shoulders shrugging</strong>: the most common failure point. If your shoulders rise, you are losing the structure. Stop, reset, and go again for less time.</li>
  <li><strong>Skipping progressions</strong>: jumping to the L-sit without adequate support hold and compression work leads to frustration. Master the tuck and one-leg variants first.</li>
</ul>
$howto$ where name = 'L-Sit';

update public.strength_exercises set how_to = $howto$
<h2>How to Straddle L-Sit</h2>
<ol>
  <li><strong>Set up</strong>: assume the support hold on parallettes or parallel bars — arms locked, shoulders depressed.</li>
  <li><strong>Lift and straddle</strong>: raise both legs off the floor and spread them wide to the sides. The wider the straddle, the shorter the effective lever, making this slightly easier than the full L-sit.</li>
  <li><strong>Hold</strong>: keep legs as horizontal as possible, toes pointed, quads tight. Breathe through the hold.</li>
  <li><strong>Use as a bridge</strong>: the straddle L-sit sits between the tuck and the full L-sit in the progression — use it to build hip-flexor compression and support strength at a partially extended lever.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Legs drooping below horizontal</strong>: even in the straddle, legs should be parallel to the floor or higher. If they drop, return to tuck work.</li>
  <li><strong>Uneven leg height</strong>: both legs should be at the same height. Imbalance points to a weaker side — address it with single-leg work.</li>
  <li><strong>Using the straddle as a permanent avoidance</strong>: the straddle is a stepping stone, not a destination. Progress toward bringing the legs together over time.</li>
</ul>
$howto$ where name = 'Straddle L-Sit';

-- ─── Handstand prep ───────────────────────────────────────────────────────────

update public.strength_exercises set how_to = $howto$
<h2>How to Pike Push-Up</h2>
<ol>
  <li><strong>Start position</strong>: place your hands on the floor slightly wider than shoulder width, then walk your feet in close so your hips are high and your body forms an inverted V (pike/downward-dog position).</li>
  <li><strong>Head position</strong>: look back between your feet or at your navel — your head is below your heart already.</li>
  <li><strong>Lower</strong>: bend your elbows and lower the crown of your head toward the floor between your hands. Elbows track outward at roughly 45–60°.</li>
  <li><strong>Press</strong>: push the floor away and straighten your arms back to the start. Your hips should stay high throughout — do not let them drop toward a push-up position mid-rep.</li>
  <li><strong>Progress</strong>: elevate your feet on a box to increase the loading angle as you get stronger.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Hips dropping during the press</strong>: if your hips sink toward the floor partway through, you are losing the pike angle. Keep hips high for the entire rep.</li>
  <li><strong>Too wide a stance</strong>: feet too far back reduces the vertical angle and turns this into a decline push-up. Walk feet in close to the hands.</li>
  <li><strong>Head not touching the floor</strong>: only going partway is a partial rep. Lower fully so the crown makes contact, then press — this builds the full range needed for handstand push-ups.</li>
  <li><strong>Elbows flaring at 90°</strong>: keep elbows at a moderate angle. Extreme flare stresses the shoulder joint.</li>
</ul>
$howto$ where name = 'Pike Push-Up';

update public.strength_exercises set how_to = $howto$
<h2>How to Wall Plank</h2>
<ol>
  <li><strong>Set up</strong>: stand facing a wall, place both hands on the floor about 30–40 cm from the wall, fingers spread and pointing forward.</li>
  <li><strong>Walk feet up</strong>: walk your feet up the wall until your hips are over your shoulders and your body forms a 90° angle at the hips — torso vertical, legs horizontal.</li>
  <li><strong>Align</strong>: push actively through the floor (protract and depress the scapulae), squeeze your core and glutes, and aim for a vertical torso with legs parallel to the floor.</li>
  <li><strong>Hold</strong>: build from 10 seconds toward 60 seconds before progressing to full wall handstand work. Breathe steadily.</li>
  <li><strong>Dismount</strong>: walk your feet back down the wall slowly — do not drop suddenly.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Hands too far from the wall</strong>: if hands are far out, the torso will angle rather than being vertical. Walk hands closer to the wall to achieve the true 90° position.</li>
  <li><strong>Passive shoulders (shrugging or sinking)</strong>: actively push the floor away so the scapulae protract and elevate. A sinking shoulder position collapses the structure.</li>
  <li><strong>Holding breath</strong>: learn nasal breathing in this position — it transfers directly to the handstand.</li>
  <li><strong>Skipping this step</strong>: the wall plank builds the shoulder endurance, wrist conditioning, and spatial awareness needed before kicking up to a full handstand.</li>
</ul>
$howto$ where name = 'Wall Plank';

update public.strength_exercises set how_to = $howto$
<h2>How to Donkey Kick</h2>
<ol>
  <li><strong>Start position</strong>: stand with feet hip-width apart, bend forward and place both hands on the floor about shoulder-width apart, forming a pike position with bent knees.</li>
  <li><strong>Kick</strong>: jump lightly off both feet, driving your hips upward over your hands. Both legs leave the floor simultaneously and kick toward a handstand. You are not trying to hold a handstand — just getting comfortable with inversion.</li>
  <li><strong>Land</strong>: bring your feet back to the floor softly under control. Reset and repeat for reps.</li>
  <li><strong>Build awareness</strong>: over sessions, kick higher and hold the inverted moment longer. The goal is to become comfortable with your weight over your hands and your hips overhead.</li>
  <li><strong>Progress to a wall</strong>: once the kick feels natural, practise near a wall so you can catch yourself and build toward the full wall handstand hold.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Fear of inversion</strong>: this is the point of donkey kicks — gradual exposure. Start with small kicks and build confidence before going all-out.</li>
  <li><strong>Bent arms</strong>: arms must be locked out when your hips are overhead to support your weight safely. If your arms bend, reduce the kick height.</li>
  <li><strong>Hands too close together</strong>: a too-narrow hand placement is unstable. Keep hands roughly shoulder-width apart.</li>
  <li><strong>Looking up aggressively</strong>: maintain a neutral neck or look slightly forward between your hands, not up at the ceiling — excessive neck extension causes pain over time.</li>
</ul>
$howto$ where name = 'Donkey Kick';

update public.strength_exercises set how_to = $howto$
<h2>How to Frog Stand</h2>
<ol>
  <li><strong>Set up</strong>: squat down and place both hands flat on the floor, shoulder-width apart, fingers spread wide. Fingers should point forward or slightly outward.</li>
  <li><strong>Position knees</strong>: rest the inside of each knee against the back of the corresponding tricep (just above the elbow). Your knees act as shelves on your upper arms.</li>
  <li><strong>Lean forward</strong>: shift your weight forward over your hands slowly. Your feet will naturally leave the floor as your centre of mass passes over your hands.</li>
  <li><strong>Balance</strong>: hold still. Focus on small finger adjustments (press fingertips into the floor to stop tipping forward; press the heel of the palm to stop tipping back). Start with 3–5 second holds and build to 30+ seconds.</li>
  <li><strong>Progress</strong>: once balanced easily, begin straightening the arms slightly and lifting the knees off the triceps — this is the bridge to the crow pose and eventually the tuck handstand.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Fear of falling forward</strong>: the biggest barrier. Set up over a cushion initially. You will almost never fall — your arms naturally stop the tilt. Learn to lean further forward than feels comfortable.</li>
  <li><strong>Arms too bent</strong>: extremely bent arms make balance harder, not easier. Aim for about 90° at the elbow.</li>
  <li><strong>Looking at the floor directly below</strong>: look about 30–40 cm ahead of your hands. This keeps your neck neutral and helps your proprioception.</li>
  <li><strong>Wrist pain</strong>: wrists must be conditioned gradually. If they ache, reduce hold time and add daily wrist mobility work.</li>
</ul>
$howto$ where name = 'Frog Stand';

update public.strength_exercises set how_to = $howto$
<h2>How to Wall Handstand Hold</h2>
<ol>
  <li><strong>Set up</strong>: stand about 60 cm from the wall facing away from it. Place both hands on the floor shoulder-width apart, 10–15 cm from the wall, fingers spread.</li>
  <li><strong>Kick up</strong>: kick one leg up first, then the other, so both heels rest lightly against the wall. You should not be slamming into the wall or relying on it heavily — it is just a safety net.</li>
  <li><strong>Align your body</strong>: push the floor away actively (protract scapulae), squeeze your glutes, core, and quads, and point your toes. Your body should be as close to a straight vertical line as possible — not arched.</li>
  <li><strong>Balance</strong>: hold for target duration, breathing slowly. Use small finger pressure to make micro-adjustments.</li>
  <li><strong>Come down</strong>: bring one foot down at a time back to the floor. Never just fall sideways.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Banana handstand (excessive arch)</strong>: arching the lower back to compensate for tight shoulders is the most common handstand error. Work on shoulder flexibility and keep ribs in.</li>
  <li><strong>Relying too heavily on the wall</strong>: if you are pressing both feet firmly into the wall, you are not training balance. The wall should catch you, not support you.</li>
  <li><strong>Shrugging shoulders / passive arms</strong>: actively push the floor away throughout. Passive shoulders collapse the structure.</li>
  <li><strong>Wrists not warmed up</strong>: always spend 2–3 minutes on wrist circles, wrist extensions, and compression before handstand work.</li>
  <li><strong>Facing the wall</strong>: facing the wall builds a different habit. Train chest-to-wall (back facing the wall as described above) so your body learns the straight-line position from the beginning.</li>
</ul>
$howto$ where name = 'Wall Handstand Hold';

update public.strength_exercises set how_to = $howto$
<h2>How to Handstand Shoulder Tap</h2>
<ol>
  <li><strong>Start from a wall handstand</strong>: kick up into your chest-to-wall handstand with heels lightly touching the wall.</li>
  <li><strong>Shift weight</strong>: slowly shift all your weight onto your right hand by leaning slightly toward it. Your left side will become lighter.</li>
  <li><strong>Tap</strong>: lift your left hand and lightly tap your left shoulder. Hold for 1 second, then return the hand to the floor.</li>
  <li><strong>Repeat the other side</strong>: shift weight to the left hand, lift and tap your right shoulder.</li>
  <li><strong>Build up</strong>: start with 3–5 taps per side per set, moving slowly. Speed is the enemy of balance here.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Rushing the weight shift</strong>: jerking your hand off the floor before your weight is centered over the other hand leads to a fall. Shift slowly, tap, return slowly.</li>
  <li><strong>Losing body tension during the tap</strong>: the body must stay rigid. Do not let your hips twist or your arch increase the moment one hand leaves the floor.</li>
  <li><strong>Too much wall reliance</strong>: if your feet press the wall hard the entire time, you are not training the one-arm loading. Aim for just heels grazing the wall.</li>
  <li><strong>Skipping this step</strong>: shoulder taps are a prerequisite for freestanding handstand — they train the lateral weight distribution and one-arm stability directly.</li>
</ul>
$howto$ where name = 'Handstand Shoulder Tap';

update public.strength_exercises set how_to = $howto$
<h2>How to Handstand Push-Up</h2>
<ol>
  <li><strong>Kick up to a wall handstand</strong>: chest facing the wall, heels resting lightly against it. Hands shoulder-width or slightly wider, fingers spread.</li>
  <li><strong>Lower slowly</strong>: bend your elbows and lower your head toward the floor between your hands. Elbows track forward at roughly 45° — not straight out, not tucked to the body.</li>
  <li><strong>Bottom position</strong>: the crown of your head lightly touches the floor. Elbows are at or just past 90°.</li>
  <li><strong>Press</strong>: push the floor away explosively and return to full lockout. Actively push your shoulders up at lockout (scapular elevation).</li>
  <li><strong>Breathing</strong>: inhale on the way down, exhale forcefully on the press.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Elbows flaring at 90°</strong>: wide elbows put enormous stress on the shoulder joint. Keep them at a 45° angle from the torso, similar to a pike push-up.</li>
  <li><strong>Partial range of motion</strong>: only going halfway does not build the strength needed. Touch the floor on every rep with control.</li>
  <li><strong>Arching the back excessively</strong>: an arched handstand push-up compensates for poor shoulder mobility. Work on shoulder flexibility alongside strength.</li>
  <li><strong>Not locking out at the top</strong>: full lockout with shoulder elevation is required. A partial lockout means the shoulder muscles never reach full shortening.</li>
  <li><strong>Attempting without prerequisite strength</strong>: you should be able to hold a wall handstand for 60 seconds and do 10+ pike push-ups before attempting HSPUs.</li>
</ul>
$howto$ where name = 'Handstand Push-Up';

update public.strength_exercises set how_to = $howto$
<h2>How to Freestanding Handstand</h2>
<ol>
  <li><strong>Kick up</strong>: from standing, step forward with one foot, place hands on the floor shoulder-width apart, and kick your legs up over your hands. The kick should be deliberate — not a slam, not timid.</li>
  <li><strong>Find vertical</strong>: your legs should come to vertical together. Use your core to stop the legs from overshooting. Think of stacking hips over shoulders over hands.</li>
  <li><strong>Balance</strong>: maintain balance through continuous micro-adjustments at the wrists and fingers. Press fingertips when falling forward; press heel of palm when falling back. The handstand is never truly static — it is constantly being rebalanced.</li>
  <li><strong>Body shape</strong>: squeeze glutes, core tight, ribs in, toes pointed, arms fully locked, shoulders elevated (pushing the floor away). One long line from hands to toes.</li>
  <li><strong>Exit safely</strong>: pirouette out (turn one hand 90°, come down sideways) or step down with one foot. Never fall headfirst backward — always have an exit plan.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Trying to hold perfectly still</strong>: balance is dynamic. Trying to freeze often causes panic and a fall. Relax into the constant micro-adjustments.</li>
  <li><strong>Banana shape</strong>: arching the lower back and flaring the ribs is the most common long-term flaw. It makes balance harder, not easier. Commit to the hollow/straight body shape from the start.</li>
  <li><strong>Looking at the floor directly below</strong>: look 20–30 cm ahead of your hands. Staring straight down compresses the cervical spine and disrupts your visual balance cues.</li>
  <li><strong>Skipping the wall</strong>: the freestanding handstand requires a solid wall handstand base. If you cannot hold 60 seconds on the wall cleanly, continue wall work before going free.</li>
  <li><strong>Inconsistent kick</strong>: kicking too hard every time means overshooting; too soft means undershooting. Train a consistent, measured kick — this is a skill in itself.</li>
</ul>
$howto$ where name = 'Freestanding Handstand';

-- ─── Other calisthenics skills ────────────────────────────────────────────────

update public.strength_exercises set how_to = $howto$
<h2>How to Pistol Squat</h2>
<ol>
  <li><strong>Start position</strong>: stand on one foot with the other leg extended forward and slightly off the floor. Arms extended forward for counterbalance.</li>
  <li><strong>Descend</strong>: hinge at the hip and bend the standing knee, lowering yourself slowly. The extended leg stays straight and lifts higher as you descend to counterbalance.</li>
  <li><strong>Bottom position</strong>: aim for the hip crease below the standing knee — a full single-leg squat. The heel of the standing foot stays flat on the floor. The extended leg is parallel to the floor or higher.</li>
  <li><strong>Drive up</strong>: push through the entire standing foot and drive your hips forward to return to standing. Avoid pushing off the floor with the extended leg's heel.</li>
</ol>
<h2>Preparatory progressions</h2>
<ul>
  <li><strong>Assisted pistol</strong>: hold a pole or TRX strap for balance and assistance on the way up while building strength.</li>
  <li><strong>Box pistol</strong>: squat down to a box or chair instead of full depth to build the pattern with reduced range.</li>
  <li><strong>Counterweight pistol</strong>: hold a light dumbbell or plate in front as a counterbalance — makes the balance significantly easier.</li>
</ul>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Heel rising off the floor</strong>: caused by limited ankle dorsiflexion. Work on ankle mobility or use a small heel elevation until mobility improves.</li>
  <li><strong>Knee caving inward</strong>: drive the knee outward in line with the toes throughout the descent. Valgus under single-leg load is a significant injury risk.</li>
  <li><strong>Falling backward at the bottom</strong>: increase counterbalance (arms forward, hold a light weight) and build posterior chain flexibility with deep single-leg holds.</li>
  <li><strong>Rushing the descent</strong>: lower slowly (3–4 seconds) to control the movement and build strength through the full range.</li>
</ul>
$howto$ where name = 'Pistol Squat';

update public.strength_exercises set how_to = $howto$
<h2>How to Dragon Flag</h2>
<ol>
  <li><strong>Set up</strong>: lie on a flat bench with both hands gripping something solid behind your head (the bench uprights, a pole, or the bench edge). Pull your shoulders down away from your ears and brace your grip tight throughout.</li>
  <li><strong>Initiate</strong>: from lying, perform a reverse crunch to drive your hips and legs straight up so your entire body is vertical above your shoulder blades. Only your upper back and shoulders remain in contact with the bench.</li>
  <li><strong>Lower</strong>: with the body rigid and perfectly straight (do not pike at the hips), lower your legs toward the bench in a slow, controlled arc. The goal is a plank held at every angle on the way down.</li>
  <li><strong>Stop before touching</strong>: reverse the motion just before your legs reach the bench and raise back to vertical. Do not rest on the bench between reps.</li>
  <li><strong>Breathe</strong>: exhale on the way up, inhale on the controlled descent.</li>
</ol>
<h2>Progressions</h2>
<ul>
  <li><strong>Tuck dragon flag</strong>: same movement but knees tucked to chest throughout — shorter lever, much easier entry point.</li>
  <li><strong>Single-leg dragon flag</strong>: one leg extended, one tucked — intermediate between tuck and full.</li>
</ul>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Piking at the hips</strong>: the most common error. If your hips bend, you are no longer doing a dragon flag — you are doing a leg raise. Maintain a rigid plank the entire descent.</li>
  <li><strong>Descending too fast</strong>: the dragon flag is an eccentric-strength exercise. Lower in at least 3–5 seconds. Dropping fast bypasses the strength stimulus entirely.</li>
  <li><strong>Insufficient upper-body anchor</strong>: grip the bench with maximum force. Loose grip means the upper back slides and the movement breaks down.</li>
  <li><strong>Attempting full before tuck is solid</strong>: master the tuck version with slow, controlled reps before attempting the straight-body version.</li>
</ul>
$howto$ where name = 'Dragon Flag';

update public.strength_exercises set how_to = $howto$
<h2>How to Tuck Front Lever</h2>
<ol>
  <li><strong>Grip the bar</strong>: hang from a pull-up bar with an overhand grip, hands shoulder-width or slightly wider apart.</li>
  <li><strong>Initiate</strong>: from a dead hang, pull your scapulae down and together (depress and retract), then raise your hips by compressing through your core and lat engagement.</li>
  <li><strong>Tuck position</strong>: bring your knees to your chest and hold your hips at bar height so your body is horizontal. Your back should be facing the ceiling, torso parallel to the floor.</li>
  <li><strong>Hold</strong>: arms remain straight — this is not a row. The work comes from lats and core keeping you horizontal, not from bending the arms. Aim for 3 × 5–10 second holds.</li>
  <li><strong>Lower down</strong>: lower your hips back to a dead hang under control.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Bent arms</strong>: the front lever is a straight-arm strength skill. Bending the arms makes it easier but trains a different movement. Keep arms fully locked.</li>
  <li><strong>Hips dropping below bar height</strong>: if your hips are lower than your hands, the angle is wrong. Pull your hips higher using lat and core compression.</li>
  <li><strong>Passive scapulae</strong>: without active scapular depression and retraction the shoulder joint is unsupported. Actively pull the shoulder blades down and together before and throughout the hold.</li>
  <li><strong>Head craning up</strong>: maintain a neutral neck. Looking forward strains the cervical spine in this inverted position.</li>
</ul>
$howto$ where name = 'Tuck Front Lever';

update public.strength_exercises set how_to = $howto$
<h2>How to Front Lever</h2>
<ol>
  <li><strong>Grip the bar</strong>: overhand grip, hands shoulder-width or slightly wider. Fully depress and retract your scapulae before initiating.</li>
  <li><strong>Raise to position</strong>: from a dead hang (or from tucked), extend your body fully and raise your hips to bar height by engaging the lats, core, and glutes simultaneously. Your body forms a rigid plank parallel to the floor, face down.</li>
  <li><strong>Active position</strong>: arms fully locked, hips at bar height, legs together and fully extended, glutes and quads squeezed, toes pointed. Every muscle active. Lats are the primary driver keeping you horizontal.</li>
  <li><strong>Hold</strong>: build from 1–3 second holds toward 10+ seconds over months of training. The full front lever typically takes 1–2 years of dedicated work.</li>
  <li><strong>Lower</strong>: return to a dead hang under full control.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Hips below bar level</strong>: the hips must be at bar height for a true front lever. Even a slight droop means you have not yet achieved the position — continue with advanced tuck or straddle front lever progressions.</li>
  <li><strong>Bent arms</strong>: arms must be fully straight. Any elbow bend is not a front lever.</li>
  <li><strong>Skipping progressions</strong>: tuck → advanced tuck → straddle → one-leg → full. Jumping ahead leads to compensation and injury. Each progression may take weeks or months to solidify.</li>
  <li><strong>Neglecting pulling strength</strong>: the front lever requires enormous lat strength. Support your front lever training with weighted pull-ups, lat pulldowns, and horizontal rows.</li>
</ul>
$howto$ where name = 'Front Lever';

update public.strength_exercises set how_to = $howto$
<h2>How to Ring Dip</h2>
<ol>
  <li><strong>Mount the rings</strong>: jump or press yourself up to the support hold position with rings at hip height. Lock your arms out, turn the rings out so palms face forward or slightly outward (false grip not required here), and depress your shoulders.</li>
  <li><strong>Stabilise first</strong>: before dipping, hold the top support position for 2–3 seconds until the rings stop wobbling. Ring dips require significant stabilisation — do not rush.</li>
  <li><strong>Lower</strong>: bend your elbows and lower your body. Keep elbows tracking slightly behind you and rings close to your sides. Lower until your shoulders are at or just below ring height.</li>
  <li><strong>Press</strong>: drive yourself back up to full lockout. At the top, actively turn the rings out (external rotation) and squeeze hard — this is the ring dip lockout and it trains shoulder stability directly.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Attempting ring dips without bar dip mastery</strong>: you should be able to do 10+ clean bar dips before attempting ring dips. The instability of rings multiplies the demands considerably.</li>
  <li><strong>Rings too wide</strong>: rings should be set just outside hip width, not very wide. Wider rings increase the instability without being productive.</li>
  <li><strong>Not turning the rings out at the top</strong>: the external-rotation lockout is part of the technique. Skipping it trains a passive lockout and misses key shoulder stability work.</li>
  <li><strong>Leaning too far forward</strong>: slight forward lean is normal and shifts load to the chest. Excessive forward lean strains the shoulders and loses the pressing angle.</li>
  <li><strong>Jerky or ballistic reps</strong>: ring dips must be slow and controlled, especially on the way down. Ballistic lowering on unstable rings is a shoulder-injury risk.</li>
</ul>
$howto$ where name = 'Ring Dip';

update public.strength_exercises set how_to = $howto$
<h2>How to Muscle-Up</h2>
<ol>
  <li><strong>Prerequisites</strong>: you should have 10+ strict pull-ups and 10+ bar dips before attempting the muscle-up.</li>
  <li><strong>Grip</strong>: use a false grip (wrist over the bar, not fingers wrapping under) — this is essential for the transition. It feels awkward at first; build it with dead hangs and ring rows.</li>
  <li><strong>The pull</strong>: initiate like a pull-up but more explosive and with a slight backward lean at the bottom. Pull the bar toward your lower chest/upper abdomen rather than your chin.</li>
  <li><strong>The transition</strong>: as the bar reaches chest height, drive your elbows back and over the bar simultaneously. Your chest passes over the bar and your body transitions from pulling to pushing.</li>
  <li><strong>The dip</strong>: from the position above the bar, press to full lockout just as in a dip.</li>
  <li><strong>Lower</strong>: to perform negatives, lower slowly back through the transition and into the hang position.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>No false grip</strong>: attempting a muscle-up without a false grip forces a difficult wrist rotation mid-transition. Learn the false grip as its own skill before the full movement.</li>
  <li><strong>Pulling to the chin instead of the chest</strong>: a chin-level pull leaves you far below the bar for the transition. The explosive pull must bring the bar to the lower chest.</li>
  <li><strong>Using only a kip without strength</strong>: a kipping muscle-up earned before a strict one is a compensation. Build the strict pulling and pushing strength first for long-term shoulder health.</li>
  <li><strong>Skipping the transition drill</strong>: practice jumping to the top of the bar position and lowering through the transition (negative muscle-up) — this builds transition strength directly and teaches the pattern safely.</li>
  <li><strong>Attempting on rings before the bar</strong>: the bar muscle-up is significantly easier than the ring muscle-up. Always learn bar first.</li>
</ul>
$howto$ where name = 'Muscle-Up';