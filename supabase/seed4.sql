insert into public.strength_exercises (name, description, category, movement_pattern, muscle_groups, equipment) values
    ('Kettlebell Crunch',        'Weighted crunch holding a kettlebell at the chest for added resistance.',        'core', 'core',         '{"core"}',                     'kettlebell'),
    ('Barbell Walking Lunge',    'Walking lunge with a barbell across the upper back for added load.',            'legs', 'knee_dominant', '{"quads","glutes","hamstrings"}', 'barbell'),
    ('Bent-Over Reverse Fly',    'Bent-over raise with dumbbells to isolate the rear delts and upper back.',      'pull', 'accessory',     '{"rear_delt","rhomboids"}',    'dumbbell'),
    ('Back Extension',           'Hip-hinge hold or raise on a hyperextension bench for the posterior chain.',    'legs', 'hip_dominant',  '{"erectors","glutes","hamstrings"}', 'bodyweight'),
    ('Walking Glute Bridge',     'Bodyweight glute bridge performed with alternating steps at the top.',          'legs', 'hip_dominant',  '{"glutes","hamstrings"}',      'bodyweight'),
    ('Oblique Roll Back',        'Seated V-position twist and roll back to train the obliques and deep core.',    'core', 'core',         '{"obliques","core"}',          'bodyweight'),
    ('Toe Tap',                  'Lying leg lower and tap to the floor, targeting the lower abs.',                'core', 'core',         '{"core","hip_flexors"}',       'bodyweight');

update public.strength_exercises set how_to = $howto$
<h2>How to Kettlebell Crunch</h2>
<ol>
  <li><strong>Start position</strong>: lie on your back, knees bent, feet flat on the floor. Hold a kettlebell by the horns against your chest with both hands.</li>
  <li><strong>Brace</strong>: press your lower back gently into the floor and engage your core before moving.</li>
  <li><strong>Curl up</strong>: exhale and lift your shoulder blades off the floor by flexing your spine, keeping the kettlebell close to your chest throughout.</li>
  <li><strong>Squeeze</strong>: hold the top position briefly, focusing on contracting the abs rather than pulling with the neck.</li>
  <li><strong>Lower under control</strong> back to the start and repeat.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Pulling on the neck</strong>: keep your chin off your chest and let your abs do the work, not your hands or neck flexors.</li>
  <li><strong>Using momentum</strong>: a slow, controlled curl trains the abs far better than a fast, jerky one.</li>
  <li><strong>Kettlebell drifting away from the chest</strong>: keep it close to your sternum to avoid excess strain on the lower back and shoulders.</li>
  <li><strong>Feet popping up</strong>: keep your feet planted flat throughout to isolate the abs rather than the hip flexors.</li>
</ul>
$howto$ where name = 'Kettlebell Crunch';

update public.strength_exercises set how_to = $howto$
<h2>How to Barbell Walking Lunge</h2>
<ol>
  <li><strong>Set up</strong>: rest a barbell across your upper back as in a back squat, hands gripping just outside shoulder width. Stand tall with feet hip-width apart.</li>
  <li><strong>Brace</strong>: engage your core to keep your torso upright throughout the movement.</li>
  <li><strong>Step forward</strong> with one leg into a long stride, lowering your hips until both knees are bent around 90°, back knee hovering just above the floor.</li>
  <li><strong>Drive through the front heel</strong> to push yourself up and forward into the next step, bringing the back leg through into the following lunge.</li>
  <li><strong>Continue walking</strong> for the target number of steps, keeping your torso tall and knees tracking over your toes.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Knee caving inward</strong>: keep the front knee tracking in line with your toes on every step.</li>
  <li><strong>Torso leaning too far forward</strong>: stay upright to keep the load balanced over your hips rather than your lower back.</li>
  <li><strong>Short, choppy steps</strong>: too short a stride shifts stress onto the front knee — take a stride long enough to load the glutes and hamstrings.</li>
  <li><strong>Back knee slamming the floor</strong>: lower with control and stop just above the ground.</li>
</ul>
$howto$ where name = 'Barbell Walking Lunge';

update public.strength_exercises set how_to = $howto$
<h2>How to Bent-Over Reverse Fly</h2>
<ol>
  <li><strong>Set up</strong>: hold a dumbbell in each hand, hinge at the hips until your torso is close to parallel with the floor, knees slightly bent, back flat.</li>
  <li><strong>Start position</strong>: let the dumbbells hang directly below your shoulders, palms facing each other, a slight bend in the elbows.</li>
  <li><strong>Raise</strong>: with a small, fixed elbow bend, lift both arms out to the sides in an arc until they reach shoulder height, leading with the elbows.</li>
  <li><strong>Squeeze</strong>: pause briefly at the top, pulling your shoulder blades together.</li>
  <li><strong>Lower under control</strong> back to the start position and repeat.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Standing too upright</strong>: a shallow hinge shifts the movement toward a lateral raise instead of targeting the rear delts. Keep your torso closer to horizontal.</li>
  <li><strong>Using momentum from the legs or back</strong>: keep the hips still — the movement should come entirely from the shoulders.</li>
  <li><strong>Raising the arms too high</strong>: stop at shoulder height; going higher recruits the traps instead of the rear delts.</li>
  <li><strong>Rounding the lower back</strong>: keep a flat back throughout by bracing your core before you begin.</li>
</ul>
$howto$ where name = 'Bent-Over Reverse Fly';

update public.strength_exercises set how_to = $howto$
<h2>How to Back Extension</h2>
<ol>
  <li><strong>Set up</strong>: position yourself face-down on a hyperextension bench with your hips resting on the pad and ankles secured under the footpads.</li>
  <li><strong>Start position</strong>: cross your arms over your chest or place hands behind your head. Lower your torso by hinging at the hips until it is just past parallel with the floor, keeping your back flat.</li>
  <li><strong>Raise</strong>: squeeze your glutes and hamstrings to lift your torso back up until your body forms a straight line from ankles to head. Avoid hyperextending past neutral.</li>
  <li><strong>Squeeze</strong> briefly at the top, then lower under control back to the start.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Hyperextending at the top</strong>: stop at a straight line — arching further past neutral stresses the lumbar spine without added benefit.</li>
  <li><strong>Rounding the back on the way down</strong>: keep your spine neutral throughout; a rounded lower back under load is the main injury risk here.</li>
  <li><strong>Using momentum</strong>: control both the lowering and raising phases rather than bouncing out of the bottom position.</li>
  <li><strong>Hips positioned too low or high on the pad</strong>: your hip crease should sit right at the edge of the pad to allow a full, safe range of motion.</li>
</ul>
$howto$ where name = 'Back Extension';

update public.strength_exercises set how_to = $howto$
<h2>How to Walking Glute Bridge</h2>
<ol>
  <li><strong>Start position</strong>: lie on your back, knees bent, feet flat on the floor hip-width apart, arms resting at your sides.</li>
  <li><strong>Bridge up</strong>: drive through your heels and squeeze your glutes to lift your hips until your body forms a straight line from shoulders to knees.</li>
  <li><strong>Walk</strong>: while holding the bridged position, take small alternating steps — lifting one heel slightly and stepping it out, then the other, keeping your hips level throughout.</li>
  <li><strong>Maintain height</strong>: do not let your hips drop as you step; keep the bridge height constant on both sides.</li>
  <li><strong>Lower under control</strong> back to the floor once you've completed the target number of steps.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Hips dropping while stepping</strong>: this is the main point of the exercise — keep the glutes engaged hard enough to hold hip height on every step.</li>
  <li><strong>Hips rotating side to side</strong>: keep your hips square and level; avoid letting one side dip or rotate as you shift weight.</li>
  <li><strong>Overarching the lower back</strong>: focus on squeezing the glutes to extend the hips rather than arching the spine to gain height.</li>
  <li><strong>Steps too large</strong>: small, controlled steps keep tension on the glutes; large steps encourage the hips to sag.</li>
</ul>
$howto$ where name = 'Walking Glute Bridge';

update public.strength_exercises set how_to = $howto$
<h2>How to Oblique Roll Back</h2>
<ol>
  <li><strong>Start position</strong>: sit on the floor with knees bent, feet flat, leaning back slightly into a V-position with your chest up and spine long.</li>
  <li><strong>Rotate</strong>: twist your torso to one side, then slowly roll backward and down toward that same side, feeling the obliques engage as your lower back rounds slightly.</li>
  <li><strong>Roll back to centre</strong>: use your core to pull yourself back up to the seated V-position, rotating through centre.</li>
  <li><strong>Repeat to the other side</strong>: rotate and roll back the opposite way, alternating sides each rep.</li>
  <li><strong>Control the tempo</strong>: move slowly in both directions — this is a controlled roll, not a fast crunch.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Rolling straight back instead of rotating</strong>: the rotation through the obliques is the key element — make sure you twist before rolling back.</li>
  <li><strong>Using arm swing to generate momentum</strong>: keep the movement driven by the core, not by flailing the arms.</li>
  <li><strong>Rolling too far back onto the neck</strong>: stay on the upper back/shoulder blades — never roll onto the neck.</li>
  <li><strong>Moving too quickly</strong>: a fast roll relies on momentum rather than muscle; slow down to keep tension on the obliques.</li>
</ul>
$howto$ where name = 'Oblique Roll Back';

update public.strength_exercises set how_to = $howto$
<h2>How to Toe Tap</h2>
<ol>
  <li><strong>Start position</strong>: lie on your back with hips and knees bent to 90° (tabletop position), lower back pressed into the floor, arms resting at your sides or hands under your lower back for support.</li>
  <li><strong>Brace</strong>: engage your core and maintain the lower-back-to-floor contact throughout — this is what keeps the lower abs working.</li>
  <li><strong>Lower one leg</strong>: slowly extend one leg down until your toes lightly tap the floor, keeping the knee bent at roughly the same angle.</li>
  <li><strong>Return</strong>: bring the leg back to the tabletop position, then repeat with the other leg, alternating sides.</li>
  <li><strong>Breathe</strong>: exhale as you lower each leg; keep the movement slow and controlled rather than swinging the legs down.</li>
</ol>
<h2>Common mistakes to avoid</h2>
<ul>
  <li><strong>Lower back arching off the floor</strong>: if your back lifts as you lower a leg, you've gone too far — shorten the range of motion.</li>
  <li><strong>Moving too fast</strong>: quick, bouncy taps reduce time under tension for the lower abs. Slow the descent down.</li>
  <li><strong>Letting the resting leg drift</strong>: keep the stationary leg fixed in the tabletop position rather than letting it sag or straighten.</li>
  <li><strong>Holding the breath</strong>: breathe steadily throughout instead of bracing with held breath.</li>
</ul>
$howto$ where name = 'Toe Tap';
