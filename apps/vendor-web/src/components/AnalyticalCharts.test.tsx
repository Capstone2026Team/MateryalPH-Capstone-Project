import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { expect, test, vi } from 'vitest'
import { AnalyticsControls, AnalyticsDetails, BarList, CalculationHelp, PriceTrendChart, ScoreOverview, SegmentScatter, ShareBar, TrendLineChart, formatDeductionCentavos, sumChartAmounts, type TrendSeries } from '@materyalph/web-ui'

const series = (values: (number | null)[]): TrendSeries[] => [{ key: 'orders', label: 'Orders', colorVar: '--mp-viz-series-1', values }]
const trend = { title: 'Daily orders', labels: ['Oct 1', 'Oct 2', 'Oct 3'], series: series([3, 2, 5]), formatValue: String, emptyReason: 'No recorded orders.' }

test('period amounts retain missing values and deductions carry their sign', () => {
  expect(sumChartAmounts([12500, 0, 7500])).toBe(20000)
  expect(sumChartAmounts([12500, null])).toBeNull()
  expect(sumChartAmounts([])).toBeNull()
  expect(formatDeductionCentavos(236000)).toBe('-₱2,360.00')
  expect(formatDeductionCentavos(0)).toBe('-₱0.00')
  expect(formatDeductionCentavos(null)).toBe('—')
})

test('empty and suppressed charts retain a neutral frame and reason without invented numeric values', () => {
  const { rerender } = render(<TrendLineChart {...trend} labels={[]} series={series([])} />)
  expect(screen.getByRole('img', { name: 'Daily orders: No recorded orders.' })).toBeVisible()
  expect(screen.queryByRole('status')).not.toBeInTheDocument()
  rerender(<TrendLineChart {...trend} series={series([null, null, null])} emptyReason="Every day is suppressed." />)
  const empty = screen.getByRole('img', { name: 'Daily orders: Every day is suppressed.' })
  expect(empty.querySelectorAll('text')).toHaveLength(0)
  expect(empty.closest('figure')).toHaveAttribute('data-chart-empty', 'line')
  rerender(<BarList label="Top products" empty="No product activity." items={[]} />)
  expect(screen.getByRole('img', { name: 'Top products: No product activity.' })).toBeVisible()
  rerender(<ShareBar variant="donut" label="Order mix" empty="No confirmed orders." segments={[{ key: 'item', label: 'Item-Based', value: 0, colorVar: '--mp-viz-series-1' }]} />)
  expect(screen.getByRole('img', { name: 'Order mix: No confirmed orders.' }).querySelectorAll('circle')).toHaveLength(1)
  rerender(<SegmentScatter title="Segments" xLabel="Orders" yLabel="Buyers" groups={[]} points={[]} emptyReason="Not enough published data." />)
  expect(screen.getByRole('img', { name: 'Segments: Not enough published data.' })).toBeVisible()
  rerender(<PriceTrendChart title="Cement prices" unit="bag" points={[{ date: '2026-10-01', value: null, status: 'INSUFFICIENT_SAMPLE' }]} focusedDate={null} onFocusDate={vi.fn()} emptyReason="Insufficient Competitor Data" />)
  expect(screen.getByRole('img', { name: 'Cement prices: Insufficient Competitor Data' })).toBeVisible()
})

test('real zero series stay keyboard-readable and use neutral ink', () => {
  render(<TrendLineChart {...trend} variant="bar" series={series([0, 0, 0])} />)
  const chart = screen.getByRole('img', { name: /Daily orders/ })
  fireEvent.keyDown(chart, { key: 'Home' })
  expect(within(chart.closest('figure')!).getByRole('status')).toHaveTextContent('Oct 1: Orders 0')
  expect(chart.closest('figure')).toHaveClass('mp-viz-muted')
  expect(screen.queryByText(trend.emptyReason)).not.toBeInTheDocument()
})

test.each([1, 2, 3, 7])('integer count axes use distinct whole-number ticks for a maximum of %s', maximum => {
  render(<TrendLineChart {...trend} integerAxis variant="bar" formatValue={value => String(Math.round(value))} series={series([0, maximum, 0])} />)
  const chart = screen.getByRole('img', { name: /Daily orders/ })
  const ticks = [...chart.querySelectorAll('g > text')].map(tick => Number(tick.textContent))
  expect(ticks.length).toBeGreaterThanOrEqual(2)
  expect(new Set(ticks).size).toBe(ticks.length)
  expect(ticks.every(Number.isInteger)).toBe(true)
  expect(ticks[0]).toBe(0)
  expect(ticks.at(-1)).toBeGreaterThanOrEqual(maximum)
  fireEvent.keyDown(chart, { key: 'Home' })
  fireEvent.keyDown(chart, { key: 'ArrowRight' })
  expect(screen.getByRole('status')).toHaveTextContent(`Oct 2: Orders ${maximum}`)
})

test('area fills break at missing days and focus keeps the missing value explicit', () => {
  render(<TrendLineChart {...trend} variant="area" series={series([3, null, 5])} />)
  const chart = screen.getByRole('img', { name: /Daily orders/ })
  const fill = chart.querySelector('path[fill-opacity]')
  expect(fill?.getAttribute('d')?.match(/M/g)).toHaveLength(2)
  expect(fill?.getAttribute('d')?.match(/Z/g)).toHaveLength(2)
  fireEvent.keyDown(chart, { key: 'Home' })
  fireEvent.keyDown(chart, { key: 'ArrowRight' })
  expect(within(chart.closest('figure')!).getByRole('status')).toHaveTextContent('Oct 2: Orders suppressed or no value')
})

test('grouped columns remain within their plot and still print exact values on focus', () => {
  render(<TrendLineChart {...trend} variant="bar" series={[...series([3, 2, 5]), { key: 'requests', label: 'Requests', colorVar: '--mp-viz-series-2', values: [5, 4, 6] }]} />)
  const chart = screen.getByRole('img', { name: /Daily orders/ })
  const grid = chart.querySelector('line')!
  const left = Number(grid.getAttribute('x1')), right = Number(grid.getAttribute('x2'))
  const bars = chart.querySelectorAll('rect[fill^="var(--mp-viz-series-"]')
  expect(bars).toHaveLength(6)
  bars.forEach(bar => {
    expect(Number(bar.getAttribute('x'))).toBeGreaterThanOrEqual(left)
    expect(Number(bar.getAttribute('x')) + Number(bar.getAttribute('width'))).toBeLessThanOrEqual(right)
  })
  fireEvent.keyDown(chart, { key: 'End' })
  expect(within(chart.closest('figure')!).getByRole('status')).toHaveTextContent('Oct 3: Orders 5; Requests 6')
})

test('overview columns expose exact values, missing buckets and dismissible tooltips', () => {
  render(<TrendLineChart {...trend} variant="bar" series={[...series([3, null, 0]), { key: 'average', label: 'Average', colorVar: '--mp-viz-series-2', values: [2.125, 2, 0] }]}
    formatValue={value => `${Math.round(value)}K`} formatTooltipValue={value => value.toFixed(2)}
    overview={{ label: 'Total orders', value: '3', context: 'Latest day · Oct 3', seriesValues: ['0', '0'] }} />)
  const chart = screen.getByRole('img', { name: /Daily orders/ })
  fireEvent.mouseEnter(chart.querySelector('[data-trend-bucket="0"]')!)
  const tooltip = screen.getByRole('tooltip')
  expect(within(tooltip).getByText('3.00')).toBeVisible()
  expect(within(tooltip).getByText('2.13')).toBeVisible()
  expect(chart).toHaveAttribute('aria-describedby', tooltip.id)
  fireEvent.mouseEnter(tooltip)
  expect(tooltip).toBeVisible()
  fireEvent.keyDown(chart, { key: 'ArrowRight' })
  expect(within(screen.getByRole('tooltip')).getByText('Unavailable')).toBeVisible()
  expect(screen.getByRole('status')).toHaveTextContent('Oct 2: Orders suppressed or no value; Average 2.00')
  fireEvent.keyDown(document, { key: 'Escape' })
  expect(screen.queryByRole('tooltip')).not.toBeInTheDocument()
  fireEvent.focus(chart)
  fireEvent.keyDown(chart, { key: 'End' })
  expect(screen.getByRole('status')).toHaveTextContent('Oct 3: Orders 0.00; Average 0.00')
  fireEvent.pointerDown(document.body)
  expect(screen.queryByRole('tooltip')).not.toBeInTheDocument()
})

test('overview forecasts retain their future dates and prediction ranges', () => {
  render(<TrendLineChart {...trend} variant="bar" overview={{ label: 'Total orders', value: '10', context: 'Latest day · Oct 3', seriesValues: ['5'] }}
    forecast={{ label: 'Forecast', labels: ['Oct 4'], values: [6], lower: [3], upper: [9] }} />)
  fireEvent.click(screen.getByRole('button', { name: 'Show forecast' }))
  fireEvent.keyDown(screen.getByRole('img'), { key: 'End' })
  const tooltip = within(screen.getByRole('tooltip'))
  expect(tooltip.getByText('Oct 4')).toBeVisible()
  expect(tooltip.getByText('Forecast')).toBeVisible()
  expect(tooltip.getByText('95% range')).toBeVisible()
  expect(tooltip.getByText('3 to 9')).toBeVisible()
})

test('a shorter date selection drops an out-of-range focus', () => {
  const { rerender } = render(<TrendLineChart {...trend} />)
  fireEvent.keyDown(screen.getByRole('img'), { key: 'End' })
  expect(screen.getByRole('status')).toHaveTextContent('Oct 3: Orders 5')
  rerender(<TrendLineChart {...trend} labels={['Oct 1']} series={series([3])} />)
  expect(screen.getByRole('status')).not.toHaveTextContent('Oct 3')
  fireEvent.keyDown(screen.getByRole('img'), { key: 'Home' })
  expect(screen.getByRole('status')).toHaveTextContent('Oct 1: Orders 3')
})

test('donuts give every category an exact count and share, including zero categories', () => {
  render(<ShareBar variant="donut" label="Procurement mix" empty="No orders." segments={[
    { key: 'item', label: 'Item-Based', value: 3, colorVar: '--mp-viz-series-1' },
    { key: 'project', label: 'Project-Based', value: 1, colorVar: '--mp-viz-series-2' },
    { key: 'other', label: 'Other', value: 0, colorVar: '--mp-viz-series-3' },
  ]} />)
  expect(screen.getByRole('img', { name: 'Procurement mix, total 4' })).toBeVisible()
  const rows = screen.getAllByRole('listitem')
  expect(rows.map(row => row.textContent)).toEqual(['Item-Based3 · 75.0%', 'Project-Based1 · 25.0%', 'Other0 · 0.0%'])
})

test('a compact donut center retains exact monetary values in the accessible summary and category list', () => {
  render(<ShareBar variant="donut" totalLabel="Sales" label="Category sales" empty="No sales." formatValue={value => `₱${(value / 100).toFixed(2)}`} formatTotal={() => '₱252K'} segments={[
    { key: 'cement', label: 'Cement', value: 25_242_000, colorVar: '--mp-viz-series-1' },
  ]} />)
  expect(screen.getByRole('img', { name: 'Category sales, sales ₱252420.00' })).toHaveTextContent('₱252K')
  expect(screen.getByRole('listitem')).toHaveTextContent('Cement₱252420.00 · 100.0%')
})

test('forecasts are optional and keep their future dates and confidence range separate from observed values', () => {
  render(<TrendLineChart {...trend} forecast={{ label: 'Forecast', labels: ['Oct 4'], values: [6], lower: [3], upper: [9] }} markers={[{ index: 1, label: 'Unusual day' }]} />)
  const chart = screen.getByRole('img', { name: /Daily orders/ })
  expect(screen.queryByText('Forecast (95% range)')).not.toBeInTheDocument()
  expect(screen.queryByText('Marked period')).not.toBeInTheDocument()
  fireEvent.keyDown(chart, { key: 'End' })
  expect(screen.getByRole('status')).toHaveTextContent('Oct 3: Orders 5')
  fireEvent.click(screen.getByRole('button', { name: 'Show forecast' }))
  fireEvent.keyDown(chart, { key: 'End' })
  expect(screen.getByRole('status')).toHaveTextContent('Oct 4: Forecast 6 (95% range 3 to 9)')
  fireEvent.click(screen.getByRole('button', { name: 'Hide forecast' }))
  expect(screen.queryByText('Forecast (95% range)')).not.toBeInTheDocument()
})

test('demand points reveal the product, segment and exact counts on hover and keyboard navigation', async () => {
  const points = [
    { key: 'steel', label: 'Deformed steel bar 10 mm', x: 24, y: 12, group: 'High demand' },
    { key: 'sand', label: 'Washed sand', x: 4, y: 3, group: 'Low demand' },
  ]
  const props = { title: 'Product demand', xLabel: 'Orders', yLabel: 'Distinct Buyers', groups: ['High demand', 'Low demand'], points }
  const { rerender } = render(<SegmentScatter {...props} />)
  const chart = screen.getByRole('img', { name: /Product demand/ })
  expect(screen.queryByRole('tooltip')).not.toBeInTheDocument()
  fireEvent.mouseEnter(chart.querySelector('[data-scatter-point="steel"]')!)
  const details = screen.getByRole('tooltip')
  expect(within(details).getByText('Deformed steel bar 10 mm')).toBeVisible()
  expect(within(details).getByText('High demand')).toBeVisible()
  expect(within(details).getByText('24')).toBeVisible()
  expect(within(details).getByText('12')).toBeVisible()
  expect(chart).toHaveAttribute('aria-describedby', details.id)
  fireEvent.mouseLeave(chart)
  fireEvent.mouseEnter(details)
  await new Promise(resolve => setTimeout(resolve, 180))
  expect(screen.getByRole('tooltip')).toBeVisible()
  fireEvent.keyDown(document, { key: 'Escape' })
  expect(screen.queryByRole('tooltip')).not.toBeInTheDocument()
  fireEvent.focus(chart)
  expect(within(screen.getByRole('tooltip')).getByText('Washed sand')).toBeVisible()
  fireEvent.keyDown(chart, { key: 'ArrowRight' })
  expect(within(screen.getByRole('tooltip')).getByText('Deformed steel bar 10 mm')).toBeVisible()
  expect(screen.getByRole('status')).toHaveTextContent('Deformed steel bar 10 mm · High demand · Orders 24 · Distinct Buyers 12')
  rerender(<SegmentScatter {...props} points={[points[1]!]} />)
  expect(screen.queryByRole('tooltip')).not.toBeInTheDocument()
  fireEvent.click(chart.querySelector('[data-scatter-point="sand"]')!)
  expect(within(screen.getByRole('tooltip')).getByText('Washed sand')).toBeVisible()
  fireEvent.pointerDown(document.body)
  expect(screen.queryByRole('tooltip')).not.toBeInTheDocument()
})

test('the score gauge uses published values and never reveals an unpublished numeric score', () => {
  render(<ScoreOverview scores={[
    { key: 'VPS', value: '4.70', published: true, sampleCount: 20, minimumSample: 10, window: 'Daily', statusText: 'Published' },
    { key: 'MQS', value: '4.99', published: false, sampleCount: 4, minimumSample: 5, window: 'Rolling 90 days', statusText: 'Needs 5 eligible product ratings' },
  ]} />)
  expect(screen.getByRole('img', { name: 'VPS: 4.70 out of 5' })).toBeVisible()
  expect(screen.queryByText(/4\.99/)).not.toBeInTheDocument()
  expect(screen.getByRole('meter', { name: 'MQS sample' })).toHaveAttribute('aria-valuetext', '4 of 5')
  expect(screen.getByText('Needs 5 eligible product ratings')).toBeVisible()
})

test('an unpublished score keeps a grey gauge and its eligibility reason', () => {
  render(<ScoreOverview scores={[{ key: 'VPS', value: '4.80', published: false, sampleCount: 0, minimumSample: 10, window: 'Daily', statusText: 'Building track record' }]} />)
  const gauge = screen.getByRole('img', { name: 'VPS: Not published' })
  expect(gauge.querySelectorAll('path')).toHaveLength(1)
  expect(screen.queryByText('4.80')).not.toBeInTheDocument()
  expect(screen.getByText('Building track record')).toBeVisible()
})

test('supporting analysis starts closed and remains reachable through its disclosure', () => {
  render(<AnalyticsDetails title="Demand patterns"><p>Detailed product analysis</p></AnalyticsDetails>)
  const summary = screen.getByText('Demand patterns')
  expect(summary.closest('details')).not.toHaveAttribute('open')
  fireEvent.click(summary)
  expect(summary.closest('details')).toHaveAttribute('open')
  expect(screen.getByText('Detailed product analysis')).toBeVisible()
})


test('chart details close with Escape and return keyboard focus to their trigger', async () => {
  render(<AnalyticsControls title="Sales"><p>Exact sales and calculation details</p></AnalyticsControls>)
  const trigger = screen.getByLabelText('Chart details for Sales')
  const details = trigger.closest('details')!
  expect(details).not.toHaveAttribute('open')
  fireEvent.click(trigger)
  await waitFor(() => expect(screen.getByText('Exact sales and calculation details')).toBeVisible())
  fireEvent.keyDown(details, { key: 'Escape' })
  expect(details).not.toHaveAttribute('open')
  expect(trigger).toHaveFocus()
})

test('calculation help opens a floating explanation on click and supports keyboard and outside dismissal', () => {
  render(<><CalculationHelp title="Sales trend"><p>Gross sales calculation</p></CalculationHelp><button type="button">Outside control</button></>)
  const trigger = screen.getByRole('button', { name: 'How this is calculated: Sales trend' })
  fireEvent.mouseOver(trigger)
  expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
  fireEvent.click(trigger)
  const explanation = screen.getByRole('dialog', { name: 'Sales trend' })
  expect(explanation).toHaveFocus()
  expect(explanation.closest('details')).toBeNull()
  expect(trigger).toHaveAttribute('aria-expanded', 'true')
  expect(screen.getByText('Gross sales calculation')).toBeVisible()
  fireEvent.keyDown(explanation, { key: 'Escape' })
  expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
  expect(trigger).toHaveFocus()
  fireEvent.click(trigger)
  fireEvent.click(screen.getByRole('button', { name: 'Close calculation explanation' }))
  expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
  expect(trigger).toHaveFocus()
  fireEvent.click(trigger)
  fireEvent.pointerDown(screen.getByRole('button', { name: 'Outside control' }))
  expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
  fireEvent.click(trigger)
  fireEvent.focusIn(screen.getByRole('button', { name: 'Outside control' }))
  expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
})
