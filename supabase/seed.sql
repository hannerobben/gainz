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
