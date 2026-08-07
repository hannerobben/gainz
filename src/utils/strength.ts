export function estimatedOneRepMax(weightKg: number, reps: number): number {
    if (reps === 1) return weightKg;
    return weightKg * (1 + reps / 30);
}

export function setVolume(weightKg: number, reps: number): number {
    return weightKg * reps;
}

export function totalVolume(sets: { load: number; reps: number }[]): number {
    return sets.reduce((sum, s) => sum + setVolume(s.load, s.reps), 0);
}