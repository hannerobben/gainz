insert into public.strength_exercises (name, description, category, movement_pattern, muscle_groups, equipment) values
    -- Push / Horizontal push
    ('Bench Press',          'Flat barbell bench press.',                        'push', 'horizontal_push', '{"chest","front_delt","triceps"}',          'barbell'),
    ('Incline Bench Press',  'Barbell press on an incline bench.',               'push', 'horizontal_push', '{"upper_chest","front_delt","triceps"}',     'barbell'),
    ('Dumbbell Bench Press', 'Flat dumbbell press with greater range of motion.','push', 'horizontal_push', '{"chest","front_delt","triceps"}',          'dumbbell'),
    ('Push-Up',              'Bodyweight horizontal push.',                      'push', 'horizontal_push', '{"chest","front_delt","triceps"}',          'bodyweight'),
    ('Cable Fly',            'Cable chest fly for stretch and squeeze.',         'push', 'horizontal_push', '{"chest"}',                                 'cable'),

    -- Push / Vertical push
    ('Overhead Press',       'Standing barbell shoulder press.',                 'push', 'vertical_push',   '{"front_delt","triceps","upper_chest"}',     'barbell'),
    ('Dumbbell Shoulder Press','Seated or standing dumbbell press overhead.',   'push', 'vertical_push',   '{"front_delt","triceps"}',                  'dumbbell'),
    ('Lateral Raise',        'Dumbbell lateral raise for side delts.',           'push', 'vertical_push',   '{"side_delt"}',                             'dumbbell'),
    ('Cable Lateral Raise',  'Cable lateral raise for constant tension.',        'push', 'vertical_push',   '{"side_delt"}',                             'cable'),

    -- Pull / Horizontal pull
    ('Barbell Row',          'Bent-over barbell row.',                           'pull', 'horizontal_pull', '{"lats","rhomboids","rear_delt","biceps"}',  'barbell'),
    ('Dumbbell Row',         'Single-arm dumbbell row.',                         'pull', 'horizontal_pull', '{"lats","rhomboids","rear_delt","biceps"}',  'dumbbell'),
    ('Cable Row',            'Seated cable row with narrow or wide grip.',       'pull', 'horizontal_pull', '{"lats","rhomboids","rear_delt","biceps"}',  'cable'),
    ('Face Pull',            'Cable face pull for rear delts and rotator cuff.', 'pull', 'horizontal_pull', '{"rear_delt","rotator_cuff"}',              'cable'),
    ('Machine Row',          'Chest-supported machine row.',                     'pull', 'horizontal_pull', '{"lats","rhomboids","rear_delt"}',           'machine'),

    -- Pull / Vertical pull
    ('Pull-Up',              'Bodyweight pull-up with overhand grip.',           'pull', 'vertical_pull',   '{"lats","biceps","rear_delt"}',             'bodyweight'),
    ('Chin-Up',              'Bodyweight chin-up with underhand grip.',          'pull', 'vertical_pull',   '{"lats","biceps"}',                         'bodyweight'),
    ('Lat Pulldown',         'Cable lat pulldown to chest.',                     'pull', 'vertical_pull',   '{"lats","biceps","rear_delt"}',             'cable'),

    -- Legs / Knee dominant
    ('Squat',           'Barbell back squat.',                              'legs', 'knee_dominant',   '{"quads","glutes","hamstrings","core"}',     'barbell'),
    ('Leg Press',            'Machine leg press.',                               'legs', 'knee_dominant',   '{"quads","glutes"}',                        'machine'),
    ('Leg Extension',        'Machine knee extension for quad isolation.',       'legs', 'knee_dominant',   '{"quads"}',                                 'machine'),
    ('Bulgarian Split Squat','Rear-foot-elevated split squat.',                  'legs', 'knee_dominant',   '{"quads","glutes"}',                        'dumbbell'),
    ('Lunge',                'Walking or stationary lunge.',                     'legs', 'knee_dominant',   '{"quads","glutes","hamstrings"}',            'dumbbell'),

    -- Legs / Hip dominant
    ('Deadlift',             'Conventional barbell deadlift.',                   'legs', 'hip_dominant',    '{"hamstrings","glutes","erectors","traps"}', 'barbell'),
    ('Romanian Deadlift',    'Hip-hinge with slight knee bend, high hip.',       'legs', 'hip_dominant',    '{"hamstrings","glutes","erectors"}',         'barbell'),
    ('Hip Thrust',           'Barbell hip thrust for glute isolation.',          'legs', 'hip_dominant',    '{"glutes","hamstrings"}',                   'barbell'),
    ('Leg Curl',             'Machine lying or seated leg curl.',                'legs', 'hip_dominant',    '{"hamstrings"}',                            'machine'),
    ('Good Morning',         'Barbell good morning for posterior chain.',        'legs', 'hip_dominant',    '{"hamstrings","glutes","erectors"}',         'barbell'),
    ('Kettlebell Swing',     'Hip-hinge power movement.',                        'legs', 'hip_dominant',    '{"glutes","hamstrings","core"}',             'kettlebell'),

    -- Core
    ('Plank',                'Isometric core hold.',                             'core', 'core',            '{"core","shoulders"}',                      'bodyweight'),
    ('Ab Wheel Rollout',     'Core rollout for anti-extension strength.',        'core', 'core',            '{"core"}',                                  'bodyweight'),
    ('Cable Crunch',         'Kneeling cable crunch for rectus abdominis.',      'core', 'core',            '{"core"}',                                  'cable'),
    ('Hanging Leg Raise',    'Hanging knee or leg raise.',                       'core', 'core',            '{"core","hip_flexors"}',                    'bodyweight'),
    ('Pallof Press',         'Anti-rotation cable core exercise.',               'core', 'core',            '{"core","obliques"}',                       'cable'),
    ('Russian Twist',        'Rotational core exercise with bodyweight or load.', 'core', 'core',            '{"obliques","core"}',                       'bodyweight'),
    ('Dead Bug',             'Contralateral limb movement for core stability.',   'core', 'core',            '{"core","hip_flexors"}',                    'bodyweight'),

    -- Accessory
    ('Bicep Curl',           'Dumbbell or barbell bicep curl.',                  'pull', 'accessory',       '{"biceps"}',                                'dumbbell'),
    ('Hammer Curl',          'Neutral-grip curl for brachialis.',                'pull', 'accessory',       '{"biceps","brachialis"}',                   'dumbbell'),
    ('Tricep Pushdown',      'Cable pushdown for tricep isolation.',             'push', 'accessory',       '{"triceps"}',                               'cable'),
    ('Skull Crusher',        'Barbell or dumbbell lying tricep extension.',      'push', 'accessory',       '{"triceps"}',                               'barbell'),
    ('Calf Raise',           'Standing or seated calf raise.',                   'legs', 'accessory',       '{"calves"}',                                'machine'),
    ('Rear Delt Fly',        'Dumbbell or machine rear delt isolation.',         'pull', 'accessory',       '{"rear_delt"}',                             'dumbbell'),
    ('Shrug',                'Barbell or dumbbell trap shrug.',                  'pull', 'accessory',       '{"traps"}',                                 'barbell');

update public.strength_exercises set how_to = $howto$
<h2>How to Squat</h2>
<ol>
  <li><strong>Set up the bar</strong> at upper-chest height. Step under it so the bar rests on your upper traps (high bar) or rear delts (low bar). Grip just outside shoulder width.</li>
  <li><strong>Unrack</strong> by standing tall — do not squat the bar out. Take two steps back.</li>
  <li><strong>Stance</strong>: feet roughly shoulder-width apart, toes turned out 15–30°.</li>
  <li><strong>Brace</strong>: take a deep breath into your belly, create intra-abdominal pressure, and squeeze your core tight before descending.</li>
  <li><strong>Descend</strong> by breaking at the hips and knees simultaneously. Keep your chest up and knees tracking over your toes.</li>
  <li><strong>Depth</strong>: aim for at least parallel (hip crease below knee). Go deeper if mobility allows.</li>
  <li><strong>Drive up</strong> by pushing the floor away. Keep your chest up — do not let your hips shoot up faster than your torso.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Knees caving inward (valgus)</strong>: actively push your knees out in line with your toes throughout the lift.</li>
  <li><strong>Heels rising</strong>: a sign of limited ankle mobility. Work on ankle stretches or use a small heel elevation.</li>
  <li><strong>Forward lean becoming excessive</strong>: keep your chest tall; if you collapse forward, the weight is too heavy or core is not braced.</li>
  <li><strong>Half-reps</strong>: stopping above parallel shifts load away from glutes and hamstrings and increases knee stress.</li>
  <li><strong>Breath lost mid-rep</strong>: maintain your brace the entire way down and up; exhale only at the top.</li>
</ul>
$howto$ where name = 'Squat';

update public.strength_exercises set how_to = $howto$
<h2>How to Romanian Deadlift</h2>
<ol>
  <li><strong>Start standing</strong> with the bar in a hip-width grip, arms straight, bar against your thighs.</li>
  <li><strong>Hinge at the hips</strong>: push your hips back as far as possible while keeping a slight bend in the knees (they stay almost locked).</li>
  <li><strong>Lower the bar</strong> by letting it slide down your legs — it should stay in contact with your shins the whole way. Keep your back flat and chest up.</li>
  <li><strong>Go until you feel a strong hamstring stretch</strong> — typically mid-shin for most people. Do not chase depth at the cost of a rounded lower back.</li>
  <li><strong>Drive your hips forward</strong> to return to standing. Squeeze your glutes at the top.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Rounding the lower back</strong>: the most common and dangerous error. If you round, you have gone too deep — stop higher.</li>
  <li><strong>Bending the knees too much</strong>: this turns it into a conventional deadlift. Keep knees soft but nearly straight to keep tension on the hamstrings.</li>
  <li><strong>Bar drifting away from the body</strong>: keep the bar dragging along your legs throughout; letting it drift forward increases lower-back strain.</li>
  <li><strong>Looking up too hard</strong>: maintain a neutral neck — your gaze should follow the floor about two metres ahead, not straight up.</li>
  <li><strong>Using too much weight too soon</strong>: the RDL is a stretch-under-load exercise; load only what lets you feel the hamstrings, not the spine.</li>
</ul>
$howto$ where name = 'Romanian Deadlift';

update public.strength_exercises set how_to = $howto$
<h2>How to Hip Thrust</h2>
<ol>
  <li><strong>Set up</strong>: sit on the floor with your upper back against a stable bench (shoulder-blade height). Roll the barbell over your hips and pad it if needed.</li>
  <li><strong>Foot position</strong>: plant feet flat on the floor, roughly hip-width apart, toes slightly out. Shins should be close to vertical at the top.</li>
  <li><strong>Drive through your heels</strong> to push your hips up until your torso is parallel to the floor (a straight line from knees to shoulders).</li>
  <li><strong>Squeeze your glutes hard</strong> at the top for a full second. Avoid hyperextending your lower back.</li>
  <li><strong>Lower under control</strong> back to the floor and repeat — do not let the bar bounce.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Hyperextending the lower back at the top</strong>: your hips should be in a posterior tilt at lockout — ribs down, glutes squeezed, not lumbar arched.</li>
  <li><strong>Feet too far forward or back</strong>: if your shins are not close to vertical at the top, adjust your foot position — too far forward works the hamstrings more; too close loads the quads.</li>
  <li><strong>Not reaching full hip extension</strong>: half-range robs you of peak glute activation. Lock out fully on every rep.</li>
  <li><strong>Chin tucked to chest or head craning back</strong>: keep a neutral neck with a slight chin tuck throughout.</li>
  <li><strong>Bench sliding away</strong>: always brace the bench against a wall or use a proper hip-thrust bench.</li>
</ul>
$howto$ where name = 'Hip Thrust';

update public.strength_exercises set how_to = $howto$
<h2>How to Bench Press</h2>
<ol>
  <li><strong>Lie on the bench</strong> with eyes directly under the bar. Plant your feet flat on the floor (or on the bench if mobility requires).</li>
  <li><strong>Grip</strong>: slightly wider than shoulder width, wrists neutral (not bent back). Wrap your thumbs around the bar.</li>
  <li><strong>Set your shoulders</strong>: retract and depress your shoulder blades (pull them together and down) and keep them pinned to the bench throughout.</li>
  <li><strong>Unrack</strong> by locking your arms out and shifting the bar horizontally over your lower chest before lowering.</li>
  <li><strong>Lower the bar</strong> in a slight arc to your lower chest / upper abdomen. Flare your elbows to about 45–75° — not straight out, not tucked to your sides.</li>
  <li><strong>Touch and press</strong>: lightly touch your chest, then drive the bar back up along the same arc to lockout. Keep your leg drive active throughout.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Elbows flared at 90°</strong>: excessive flare places extreme stress on the shoulder joint. Keep elbows at a moderate angle relative to your torso.</li>
  <li><strong>Bouncing the bar off the chest</strong>: this uses momentum instead of muscle and risks injury. Lower under control and pause if needed.</li>
  <li><strong>Lifting your butt off the bench</strong>: reduces range of motion and can strain the lower back. Keep your glutes on the bench.</li>
  <li><strong>Losing shoulder blade position</strong>: if your shoulders roll forward during the press, the weight is too heavy or you are fatiguing — rack the bar.</li>
  <li><strong>Open grip (thumbless)</strong>: the bar can roll off your palms. Always use a closed grip with thumbs wrapped around.</li>
</ul>
$howto$ where name = 'Bench Press';

update public.strength_exercises set how_to = $howto$
<h2>How to Plank</h2>
<ol>
  <li><strong>Start position</strong>: forearms on the floor, elbows directly under your shoulders. Feet together or hip-width apart, toes on the floor.</li>
  <li><strong>Body alignment</strong>: form a straight line from your heels through your hips to the crown of your head.</li>
  <li><strong>Brace your core</strong>: imagine someone is about to punch you in the stomach — create tension throughout your entire trunk.</li>
  <li><strong>Squeeze your glutes and quads</strong>: this supports your hips and prevents sagging.</li>
  <li><strong>Keep your head neutral</strong>: gaze at the floor about 15–20 cm in front of your hands, not up or tucked to your chest.</li>
  <li><strong>Breathe steadily</strong> throughout — short, controlled breaths rather than holding your breath.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Hips sagging toward the floor</strong>: the most common error; it compresses the lower back. If you cannot hold position, drop to your knees or shorten the hold.</li>
  <li><strong>Hips piked up too high</strong>: this offloads the core and turns it into a rest position. Drive your hips down to a neutral line.</li>
  <li><strong>Holding your breath</strong>: creates unnecessary blood-pressure spikes and shortens how long you can hold. Learn to breathe through the brace.</li>
  <li><strong>Shrugging your shoulders up to your ears</strong>: keep your shoulders packed down and away from your ears — elbows pressing into the floor, not shoulders riding up.</li>
  <li><strong>Chasing time at the cost of form</strong>: a 20-second perfect plank is worth more than a 2-minute saggy one. Stop when form breaks.</li>
</ul>
$howto$ where name = 'Plank';

update public.strength_exercises set how_to = $howto$
<h2>How to Barbell Row</h2>
<ol>
  <li><strong>Set up</strong>: load the bar on the floor or in a rack at mid-shin height. Stand with feet hip-width apart, toes under the bar.</li>
  <li><strong>Hinge</strong>: push your hips back until your torso is roughly 45° to the floor (or more horizontal for a heavier, stricter row). Keep your back flat and core braced.</li>
  <li><strong>Grip</strong>: overhand (pronated) grip just outside shoulder width. Arms hang straight down from the bar.</li>
  <li><strong>Pull</strong>: drive your elbows back and up, pulling the bar into your lower chest / upper abdomen. Lead with the elbows, not the hands.</li>
  <li><strong>Squeeze</strong>: hold for a brief moment at the top with shoulder blades fully retracted.</li>
  <li><strong>Lower under control</strong>: resist the bar on the way down to get eccentric benefit; do not let it crash.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Using momentum / jerking the bar</strong>: a slight body swing is acceptable under heavy load, but swinging on every rep means the weight is too heavy. The back, not the hips, should do the work.</li>
  <li><strong>Rounding the lower back</strong>: maintain a neutral spine throughout. If your lower back rounds, reduce the weight or raise your torso angle.</li>
  <li><strong>Pulling to the wrong point</strong>: bar pulled to the upper chest works the rear delts; pulled to the abdomen targets the lats more. Choose intentionally and stay consistent.</li>
  <li><strong>Elbows flaring too wide</strong>: for lat emphasis keep elbows closer to the body; wide flare shifts load to the rear delts and can stress the shoulders.</li>
  <li><strong>Head craning upward</strong>: keep a neutral neck — do not look up at the ceiling while rowing.</li>
</ul>
$howto$ where name = 'Barbell Row';

update public.strength_exercises set how_to = $howto$
<h2>How to Push-Up</h2>
<ol>
  <li><strong>Start position</strong>: hands slightly wider than shoulder width, fingers pointing forward or slightly out. Arms straight, body forming a rigid plank from heels to head.</li>
  <li><strong>Brace everything</strong>: squeeze your glutes, quads, and core before you move — the body should travel as one unit.</li>
  <li><strong>Lower</strong>: bend your elbows and lower your chest toward the floor. Elbows should track at roughly 45° from your torso — not straight out, not fully tucked.</li>
  <li><strong>Bottom position</strong>: chest close to or lightly touching the floor, elbows not fully splayed, hips level.</li>
  <li><strong>Press</strong>: push the floor away explosively, returning to the straight-arm starting position. Fully protract (spread) your shoulder blades at the top.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Sagging hips</strong>: if your lower back arches and hips drop toward the floor, your core is not braced. Drop to your knees to maintain full tension.</li>
  <li><strong>Piked hips</strong>: hips pushed up to the ceiling reduces range of motion and offloads the chest. Keep a straight line from heels to shoulders.</li>
  <li><strong>Half-range reps</strong>: not reaching a full chest-to-floor depth cuts the exercise short. Lower fully on every rep.</li>
  <li><strong>Elbows flared at 90°</strong>: wide elbows place high stress on the shoulder joint. Keep them at a 45° angle.</li>
  <li><strong>Head dropping toward the floor</strong>: maintain a neutral neck — do not let your chin lead the descent.</li>
</ul>
$howto$ where name = 'Push-Up';

update public.strength_exercises set how_to = $howto$
<h2>How to Overhead Press</h2>
<ol>
  <li><strong>Set up</strong>: hold the bar at shoulder height with a grip just outside shoulder width, elbows slightly in front of the bar. Unrack or clean the bar to this position.</li>
  <li><strong>Stance</strong>: feet hip-width apart, glutes and core braced, ribs down — do not let your lower back arch excessively.</li>
  <li><strong>Press</strong>: drive the bar straight up. As the bar passes your face, push your head slightly forward so the bar travels in a vertical line. Lock out fully overhead, arms straight, bar over your mid-foot.</li>
  <li><strong>Lower</strong>: bring the bar back to the front-rack position under control. Reset your brace before the next rep.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Excessive lower-back arch (pressing from a layback)</strong>: a slight lean-back to clear your face is fine, but arching your lumbar heavily to compensate for poor shoulder mobility turns it into a standing incline press and risks the spine. Keep ribs down.</li>
  <li><strong>Bar drifting forward</strong>: the bar should stay over your mid-foot and travel in a straight vertical line. Letting it drift forward puts extreme leverage on the lower back.</li>
  <li><strong>Elbows too far behind the bar</strong>: if your elbows are behind the bar rather than slightly in front, you will press the bar out in an arc instead of straight up.</li>
  <li><strong>Not locking out</strong>: full lockout overhead (active shoulder shrug at the top) is required for shoulder stability and to fully load the deltoids.</li>
  <li><strong>Using leg drive unintentionally</strong>: keep the legs still. If you need to dip and drive, you are performing a push press — which is valid but a different exercise.</li>
</ul>
$howto$ where name = 'Overhead Press';

update public.strength_exercises set how_to = $howto$
<h2>How to Dead Bug</h2>
<ol>
  <li><strong>Start position</strong>: lie on your back, arms pointing straight up toward the ceiling, hips and knees bent to 90° (tabletop position), lower back pressed firmly into the floor.</li>
  <li><strong>Brace</strong>: exhale fully and press your lower back into the floor before every rep. Maintain this contact throughout — this is the whole point of the exercise.</li>
  <li><strong>Lower opposite limbs</strong>: slowly extend your right arm overhead and your left leg toward the floor simultaneously. Move only as far as you can without your lower back lifting off.</li>
  <li><strong>Return</strong>: bring both limbs back to the start position, then repeat on the other side (left arm, right leg).</li>
  <li><strong>Breathe</strong>: exhale as you lower the limbs; inhale as you return. Slow, controlled movement — 3–5 seconds per direction.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Lower back lifting off the floor</strong>: this is the most common and most important error. The moment your back peels up, you have lost core stability. Shorten your range of motion rather than compensating.</li>
  <li><strong>Moving too fast</strong>: speed kills the benefit. The slower and more controlled the movement, the more anti-extension demand on the core.</li>
  <li><strong>Holding your breath</strong>: you should be exhaling steadily during the lowering phase — breath control is part of the exercise.</li>
  <li><strong>Moving same-side arm and leg</strong>: the contralateral (opposite) pattern is intentional for neurological benefit. Ipsilateral (same-side) movement is a different, easier exercise.</li>
  <li><strong>Arms and legs touching the floor</strong>: stopping just above the floor keeps constant tension. Resting removes it.</li>
</ul>
$howto$ where name = 'Dead Bug';

update public.strength_exercises set how_to = $howto$
<h2>How to Russian Twist</h2>
<ol>
  <li><strong>Start position</strong>: sit on the floor, knees bent, feet flat or slightly elevated. Lean back until your torso is at roughly 45° — enough to feel your abs engaged.</li>
  <li><strong>Hold a weight</strong> (plate, dumbbell, or medicine ball) with both hands at chest height, arms slightly extended.</li>
  <li><strong>Brace your core</strong> and lift your feet off the floor if you want more challenge. Keep your spine neutral — do not round your lower back.</li>
  <li><strong>Rotate</strong>: twist your torso to one side, bringing the weight toward the floor beside your hip. The movement comes from your thoracic spine — think of rotating your ribcage, not just swinging your arms.</li>
  <li><strong>Return through centre</strong> and rotate to the other side. One rep = both sides.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Rounding the lower back</strong>: leaning back too far collapses the lumbar spine. Stay at 45° with a neutral, braced spine.</li>
  <li><strong>Swinging the arms instead of rotating the torso</strong>: the weight should move because your ribcage rotates, not because your arms are flailing. Keep arms relatively fixed and drive from the obliques.</li>
  <li><strong>Twisting too fast</strong>: ballistic rotation with a load can stress the lumbar discs. Control the movement in both directions.</li>
  <li><strong>Holding your breath</strong>: exhale on each rotation, inhale through centre.</li>
  <li><strong>Feet too high or legs fully extended</strong>: this dramatically increases hip-flexor involvement and reduces oblique focus. A modest foot elevation or feet flat is sufficient.</li>
</ul>
$howto$ where name = 'Russian Twist';
