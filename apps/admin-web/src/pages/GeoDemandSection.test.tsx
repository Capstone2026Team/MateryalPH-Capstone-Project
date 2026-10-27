import { fireEvent, render, screen, waitFor } from '@testing-library/react'
import { beforeEach, expect, test, vi } from 'vitest'
import type { GeoDemand } from '@materyalph/api-client-ts'
import { DemandSection } from './GeoAnalyticsPage'
import { getGeoDemand, type GeoFilters } from '../lib/geo-analytics-api'

vi.mock('../lib/geo-analytics-api', async importOriginal => ({
  ...await importOriginal<typeof import('../lib/geo-analytics-api')>(),
  getGeoDemand: vi.fn(),
}))

const filters: GeoFilters = { dataset: 'TEST', area: null, from: '2026-10-01', to: '2026-10-27', granularity: 'WEEK', categoryId: '', materialId: '', procurementType: '', fulfillmentMethod: '', paymentMethod: '', orderState: '' }

function result(page = 1): GeoDemand {
  const columns = page === 1 ? [{ id: 'cement', name: 'Cement' }, { id: 'aggregates', name: 'Aggregates' }] : [{ id: 'steel', name: 'Steel and Reinforcement' }]
  return {
    scope: { code: null, name: 'Philippines', level: null, levelLabel: 'Country', label: 'Philippines', breadcrumbs: [], childrenLabel: 'Regions', drillable: true, psgcVersion: null },
    dataset: { environment: 'TEST', label: 'Recorded Marketplace Activity', demo: false, lastAggregatedAt: null, throughDate: null, revision: null, available: true },
    measure: 'ORDER_COUNT', unit: null, dimension: 'CATEGORY', columns,
    columnPagination: { currentPage: page, lastPage: 2, total: 3 },
    rows: [{ code: '1300000000', name: 'NCR', level: 'REGION', cells: columns.map(column => ({ column: column.id, value: column.id === 'steel' ? 8 : 0, suppressed: false, reason: null })) }],
    notComparableLines: 0, definition: 'Order count counts confirmed orders containing each category. Quantity uses approved canonical unit conversions.',
  }
}

beforeEach(() => vi.mocked(getGeoDemand).mockReset().mockImplementation(async (_filters, _measure, page) => result(page)))

test('shows categories with zero demand, pages to recorded Steel demand, and keeps the definition in expandable help', async () => {
  render(<DemandSection filters={filters} />)
  await screen.findByRole('columnheader', { name: 'Cement' })
  expect(screen.getByRole('columnheader', { name: 'Aggregates' })).toBeVisible()
  expect(screen.getAllByRole('cell', { name: '0' })).toHaveLength(2)
  expect(screen.getByText('No confirmed demand in this view')).toBeVisible()
  expect(screen.getByText('Philippines')).toBeVisible()
  const details = screen.getByText('How demand is measured').closest('details')!
  expect(details.open).toBe(false)
  fireEvent.click(screen.getByRole('button', { name: 'Next' }))
  await screen.findByRole('columnheader', { name: 'Steel and Reinforcement' })
  expect(screen.getByRole('cell', { name: '8' })).toBeVisible()
  expect(screen.queryByText('No confirmed demand in this view')).not.toBeInTheDocument()
  expect(screen.getByRole('button', { name: 'Next' })).toBeDisabled()
  expect(getGeoDemand).toHaveBeenLastCalledWith(filters, 'ORDER_COUNT', 2)
})

test('changing category, geography or measure resets category pagination and retains the full API filter scope', async () => {
  const { rerender } = render(<DemandSection filters={filters} />)
  await screen.findByRole('columnheader', { name: 'Cement' })
  fireEvent.click(screen.getByRole('button', { name: 'Next' }))
  await screen.findByRole('columnheader', { name: 'Steel and Reinforcement' })
  const next = { ...filters, categoryId: 'cement', area: '1300000000', paymentMethod: 'ONLINE' }
  rerender(<DemandSection filters={next} />)
  await waitFor(() => expect(getGeoDemand).toHaveBeenLastCalledWith(next, 'ORDER_COUNT', 1))
  await screen.findByRole('columnheader', { name: 'Cement' })
  fireEvent.change(screen.getByRole('combobox', { name: 'Measure' }), { target: { value: 'VALUE' } })
  await waitFor(() => expect(getGeoDemand).toHaveBeenLastCalledWith(next, 'VALUE', 1))
  expect(screen.getByRole('option', { name: /Quantity/ })).toBeDisabled()
})
