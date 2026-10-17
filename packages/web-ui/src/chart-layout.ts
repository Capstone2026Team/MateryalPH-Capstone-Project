const AXIS_FONT_SIZE = 11
const TICK_GAP = 16

/** Reserve one em per character, conservatively allowing for wide glyphs in the portal font. */
export function chartLabelWidth(label: string): number {
  return Array.from(label).length * AXIS_FONT_SIZE
}

/** Keep formatted amounts inside the canvas, with space between the label and the plot. */
export function chartLeftInset(labels: string[], minimum = 56): number {
  return Math.max(minimum, ...labels.map(label => chartLabelWidth(label) + 20))
}

/** Very long edge labels get a scrollable canvas rather than overlapping or smaller text. */
export function chartMinimumWidth(labels: string[], left: number, right: number, minimum = 480): number {
  const first = chartLabelWidth(labels[0] ?? '')
  const last = labels.length > 1 ? chartLabelWidth(labels[labels.length - 1] ?? '') : 0
  return Math.max(minimum, left + right + Math.max(240, first + last + TICK_GAP, ...labels.map(chartLabelWidth)))
}

export type ChartTick = { index: number; label: string; x: number; textAnchor: 'start' | 'middle' | 'end' }

/** Choose non-overlapping ticks at their data positions; edge labels stay inside the plot. */
export function chartTicks(labels: string[], start: number, end: number): ChartTick[] {
  if (labels.length === 0) return []
  if (labels.length === 1) return [{ index: 0, label: labels[0] ?? '', x: (start + end) / 2, textAnchor: 'middle' }]
  const first: ChartTick = { index: 0, label: labels[0] ?? '', x: start, textAnchor: 'start' }
  const last: ChartTick = { index: labels.length - 1, label: labels[labels.length - 1] ?? '', x: end, textAnchor: 'end' }
  const lastLeft = end - chartLabelWidth(last.label)
  let previousRight = start + chartLabelWidth(first.label)
  const ticks = [first]
  if (previousRight + TICK_GAP > lastLeft) return ticks
  for (let index = 1; index < labels.length - 1; index++) {
    const label = labels[index] ?? ''
    const x = start + index * (end - start) / (labels.length - 1)
    const halfWidth = chartLabelWidth(label) / 2
    if (x - halfWidth < previousRight + TICK_GAP || x + halfWidth + TICK_GAP > lastLeft) continue
    ticks.push({ index, label, x, textAnchor: 'middle' })
    previousRight = x + halfWidth
  }
  ticks.push(last)
  return ticks
}
