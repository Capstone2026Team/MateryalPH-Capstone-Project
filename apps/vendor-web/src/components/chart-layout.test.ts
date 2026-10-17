import { describe, expect, test } from 'vitest'
import { chartLabelWidth, chartLeftInset, chartMinimumWidth, chartTicks, type ChartTick } from '../../../../packages/web-ui/src/chart-layout'

function bounds(tick: ChartTick): [number, number] {
  const width = chartLabelWidth(tick.label)
  const left = tick.textAnchor === 'start' ? tick.x : tick.textAnchor === 'end' ? tick.x - width : tick.x - width / 2
  return [left, left + width]
}

describe('shared portal chart label layout', () => {
  test('has no ticks for an empty period and centers a single period', () => {
    expect(chartTicks([], 72, 456)).toEqual([])
    expect(chartTicks(['Oct 9'], 72, 456)).toEqual([{ index: 0, label: 'Oct 9', x: 264, textAnchor: 'middle' }])
  })

  test.each([420, 480, 720, 1366])('keeps dense daily labels separated inside a %i px canvas', canvasWidth => {
    const labels = Array.from({ length: 366 }, (_, index) => new Date(Date.UTC(2026, 0, index + 1)).toISOString().slice(0, 10))
    const left = chartLeftInset(['₱0', '₱750,000', '₱1,500,000'])
    const width = Math.max(canvasWidth, chartMinimumWidth(labels, left, 24))
    const ticks = chartTicks(labels, left, width - 24)
    expect(ticks[0]?.index).toBe(0)
    expect(ticks[ticks.length - 1]?.index).toBe(labels.length - 1)
    for (let index = 0; index < ticks.length; index++) {
      const tick = ticks[index]!
      const [begin, end] = bounds(tick)
      expect(begin).toBeGreaterThanOrEqual(left)
      expect(end).toBeLessThanOrEqual(width - 24)
      expect(tick.x).toBeCloseTo(left + tick.index * (width - left - 24) / (labels.length - 1))
      if (index > 0) expect(begin - bounds(ticks[index - 1]!)[1]).toBeGreaterThanOrEqual(16)
    }
  })

  test('shows more dates as a chart grows without changing the dates or their positions', () => {
    const labels = Array.from({ length: 31 }, (_, index) => `Oct ${index + 1}`)
    const narrow = chartTicks(labels, 72, 456)
    const wide = chartTicks(labels, 72, 1342)
    expect(wide.length).toBeGreaterThan(narrow.length)
    expect(wide.every(tick => tick.label === labels[tick.index])).toBe(true)
  })

  test('reserves enough left space for large currency values', () => {
    const labels = ['₱0.00', '₱123,456,789.00']
    const left = chartLeftInset(labels)
    expect(left).toBeGreaterThanOrEqual(174)
    expect(left - 8 - chartLabelWidth(labels[1]!)).toBeGreaterThanOrEqual(12)
  })

  test('expands the scrollable canvas when long edge labels would collide', () => {
    const labels = ['October 2026 reporting period', 'November 2026 reporting period']
    const width = chartMinimumWidth(labels, 72, 24)
    expect(width).toBeGreaterThan(480)
    const ticks = chartTicks(labels, 72, width - 24)
    expect(ticks).toHaveLength(2)
    expect(bounds(ticks[1]!)[0] - bounds(ticks[0]!)[1]).toBeGreaterThanOrEqual(16)
  })

  test('omits an interior scatter tick when formatted values would collide', () => {
    const labels = ['₱0.00', '₱123,456,789.00', '₱246,913,578.00']
    const ticks = chartTicks(labels, 72, 340)
    expect(ticks.map(tick => tick.index)).toEqual([0, 2])
  })
})
