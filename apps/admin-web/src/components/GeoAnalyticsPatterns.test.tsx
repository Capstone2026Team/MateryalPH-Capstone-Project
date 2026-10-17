import { fireEvent, render, screen, within } from '@testing-library/react'
import { expect, test, vi } from 'vitest'
import {
  ChoroplethLegend, DemandHeatmap, GeoBreadcrumbs, GeoChoroplethMap, HealthBadge, ReasonedDecisionForm, SortableDataTable, TrendLineChart, choroplethBin, choroplethThresholds, type GeoAreaValue,
} from '@materyalph/web-ui'

const areas: GeoAreaValue[] = [
  { code: '1300000000', name: 'National Capital Region', levelLabel: 'Region', value: 900, suppressed: false, drillable: true },
  { code: '0400000000', name: 'CALABARZON', levelLabel: 'Region', value: 120, suppressed: false, drillable: true },
  { code: '0300000000', name: 'Central Luzon', levelLabel: 'Region', value: null, suppressed: true, drillable: true, note: 'Fewer than 5 distinct Buyers' },
]

test('bins are equal-count, light to dark, with zero kept as no activity', () => {
  const thresholds = choroplethThresholds([10, 20, 30, 40, 50, null, 0])
  expect(thresholds).toEqual([20, 30, 40, 50])
  expect(choroplethBin(0, thresholds)).toBe(0)
  expect(choroplethBin(null, thresholds)).toBe(0)
  expect(choroplethBin(10, thresholds)).toBe(1)
  expect(choroplethBin(50, thresholds)).toBe(5)
})

test('without a browser key the map falls back to keyboard tiles that announce exact values and suppression', () => {
  const onSelect = vi.fn()
  const onFocus = vi.fn()
  render(<GeoChoroplethMap features={[]} areas={areas} thresholds={choroplethThresholds(areas.map(area => area.value))} metricLabel="Orders" formatValue={value => value.toLocaleString('en-PH')} focusedCode="1300000000" selectedCode={null} onFocus={onFocus} onSelect={onSelect} />)
  expect(screen.getByText(/interactive map is not configured/)).toBeInTheDocument()
  const tiles = screen.getByRole('list', { name: 'Orders by area' })
  const ncr = within(tiles).getByRole('button', { name: /National Capital Region/ })
  expect(screen.getByRole('status')).toHaveTextContent('National Capital Region · Region: 900 orders · Select to drill down')
  expect(within(tiles).getByRole('button', { name: /Central Luzon/ })).toHaveTextContent('Suppressed')
  fireEvent.focus(ncr)
  expect(onFocus).toHaveBeenCalledWith('1300000000')
  fireEvent.click(ncr)
  expect(onSelect).toHaveBeenCalledWith(areas[0])
})

test('the legend names every bin, the no-activity state and the hatched suppressed state', () => {
  render(<ChoroplethLegend title="Gross GMV by region" thresholds={[100, 500]} formatValue={value => `₱${value}`} />)
  expect(screen.getByText('No activity')).toBeInTheDocument()
  expect(screen.getByText('Below ₱100')).toBeInTheDocument()
  expect(screen.getByText('₱500 and above')).toBeInTheDocument()
  expect(screen.getByText('Suppressed small cell')).toBeInTheDocument()
})

test('the table sorts with aria-sort, keeps suppressed values last and selects a row by keyboard button', () => {
  const onSelectRow = vi.fn()
  render(<SortableDataTable caption="Regions" rows={areas} rowKey={area => area.code} onSelectRow={onSelectRow} rowLabel={area => `Drill into ${area.name}`}
    columns={[{ key: 'name', header: 'Region', cell: area => area.name, sortValue: area => area.name }, { key: 'value', header: 'Orders', numeric: true, cell: area => area.suppressed ? 'Suppressed' : String(area.value), sortValue: area => area.value }]} />)
  const header = screen.getByRole('columnheader', { name: /Orders/ })
  expect(header).toHaveAttribute('aria-sort', 'none')
  fireEvent.click(within(header).getByRole('button'))
  expect(header).toHaveAttribute('aria-sort', 'descending')
  const rows = screen.getAllByRole('row').slice(1)
  expect(rows.map(row => within(row).getAllByRole('cell')[0]?.textContent)).toEqual(['900', '120', 'Suppressed'])
  fireEvent.click(screen.getByRole('button', { name: 'Drill into CALABARZON' }))
  expect(onSelectRow).toHaveBeenCalledWith(areas[1])
})

test('breadcrumbs mark the current level and navigate to ancestors', () => {
  const onSelect = vi.fn()
  render(<GeoBreadcrumbs items={[{ code: null, name: 'Philippines' }, { code: '1300000000', name: 'National Capital Region' }]} onSelect={onSelect} />)
  expect(screen.getByText('National Capital Region')).toHaveAttribute('aria-current', 'page')
  fireEvent.click(screen.getByRole('button', { name: 'Philippines' }))
  expect(onSelect).toHaveBeenCalledWith(null)
})

test('the trend chart reads exact values with the keyboard and shows an empty reason', () => {
  const { rerender } = render(<TrendLineChart title="GMV" labels={['2026-10-01', '2026-10-02']} formatValue={value => `₱${value}`} emptyReason="No order activity."
    series={[{ key: 'gross', label: 'Gross GMV', colorVar: '--mp-viz-series-1', values: [100, null] }, { key: 'net', label: 'Net GMV', colorVar: '--mp-viz-series-2', values: [80, null] }]} />)
  const chart = screen.getByRole('img')
  fireEvent.keyDown(chart, { key: 'Home' })
  expect(screen.getByRole('status')).toHaveTextContent('2026-10-01: Gross GMV ₱100; Net GMV ₱80')
  fireEvent.keyDown(chart, { key: 'ArrowRight' })
  expect(screen.getByRole('status')).toHaveTextContent('Gross GMV suppressed or no value')
  rerender(<TrendLineChart title="GMV" labels={[]} formatValue={String} emptyReason="No order activity." series={[]} />)
  expect(screen.getByText('No order activity.')).toBeInTheDocument()
})

test('the heatmap prints every value as text and labels suppressed cells', () => {
  render(<DemandHeatmap caption="Category demand" formatValue={String} columns={[{ id: 'c1', name: 'Cement' }]} rows={[{ code: 'a', name: 'Manila', cells: [{ value: 12, suppressed: false }] }, { code: 'b', name: 'Pasay', cells: [{ value: null, suppressed: true, reason: 'Fewer than 5 Buyers' }] }]} />)
  expect(screen.getByRole('cell', { name: '12' })).toBeInTheDocument()
  expect(screen.getByRole('cell', { name: 'Suppressed' })).toHaveAttribute('title', 'Fewer than 5 Buyers')
})

test('a reasoned decision names its target and version and refuses a short reason', () => {
  const onSubmit = vi.fn()
  const { rerender } = render(<ReasonedDecisionForm title="Apply Suspension" target="Suspension for Test Supply" version={3} before="Active" after="Suspended" submitLabel="Apply" onSubmit={onSubmit} />)
  expect(screen.getByText('Suspension for Test Supply')).toBeInTheDocument()
  expect(screen.getByText('3')).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Apply' }))
  expect(screen.getByRole('alert')).toHaveTextContent('at least 10 characters')
  expect(onSubmit).not.toHaveBeenCalled()
  fireEvent.change(screen.getByLabelText(/Reason/), { target: { value: 'Repeated verified non-delivery complaints.' } })
  fireEvent.click(screen.getByRole('button', { name: 'Apply' }))
  expect(onSubmit).toHaveBeenCalledWith('Repeated verified non-delivery complaints.')
  const onReload = vi.fn()
  rerender(<ReasonedDecisionForm title="Apply Suspension" target="Suspension for Test Supply" version={3} submitLabel="Apply" conflict="This case changed after you opened it." onReload={onReload} onSubmit={onSubmit} />)
  fireEvent.click(screen.getByRole('button', { name: 'Reload latest' }))
  expect(onReload).toHaveBeenCalled()
})

test('health is an icon and a word, never colour alone', () => {
  render(<HealthBadge state="FAILING" />)
  expect(screen.getByText('Failing')).toBeInTheDocument()
})
