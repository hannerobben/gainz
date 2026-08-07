export function walkDotColor(steps: number): string {
    const opacity = Math.min(steps / 10000, 1);
    return `rgba(193, 122, 48, ${opacity})`;
}
