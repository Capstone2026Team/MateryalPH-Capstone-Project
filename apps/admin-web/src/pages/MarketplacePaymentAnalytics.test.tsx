import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter, useLocation } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import { ResponseError } from '@materyalph/api-client-ts'
import * as finance from '../lib/finance-api'
import * as geography from '../lib/geo-analytics-api'
import { AdminGeoAnalyticsPage } from './GeoAnalyticsPage'
import { marketplacePaymentsFixture } from '../test/marketplace-payments-fixture'
import { geoDashboardFixture } from '../test/geo-dashboard-fixture'

vi.mock('../lib/finance-api', async original => ({ ...await original<typeof import('../lib/finance-api')>(), financeKpis: vi.fn() }))
vi.mock('../lib/geo-analytics-api', async original => ({ ...await original<typeof import('../lib/geo-analytics-api')>(), getGeoDashboard: vi.fn(), getGeoBoundaries: vi.fn(), getGeoFilterOptions: vi.fn() }))
vi.mock('./PhaseThreeAdminPages', async original => ({ ...await original<typeof import('./PhaseThreeAdminPages')>(), AdminShell: ({ children }: { children: React.ReactNode }) => <main>{children}</main> }))

function Query() { return <output data-testid="query">{useLocation().search}</output> }
function open() {
  return render(<MemoryRouter initialEntries={['/analytics?view=payments&area=1300000000&categoryId=steel&from=2026-10-01&to=2026-10-31']}><AdminGeoAnalyticsPage /><Query /></MemoryRouter>)
}

beforeEach(() => {
  vi.clearAllMocks()
  vi.mocked(finance.financeKpis).mockResolvedValue(marketplacePaymentsFixture())
  vi.mocked(geography.getGeoDashboard).mockResolvedValue(geoDashboardFixture())
  vi.mocked(geography.getGeoBoundaries).mockResolvedValue({ type: 'FeatureCollection', features: [], missingCodes: [], psgcVersion: { id: 'sample', label: 'Sample PSGC' } })
  vi.mocked(geography.getGeoFilterOptions).mockResolvedValue([])
})

test('marketplace payments belong to Analytics and retain their nationwide finance scope and exact calculations', async () => {
  open()
  await screen.findByRole('region', { name: 'Philippines overview' })
  expect(await screen.findByRole('heading', { name: 'Philippine geographic analytics', level: 1 })).toBeInTheDocument()
  expect(screen.getByRole('tab', { name: 'Marketplace payments', selected: true })).toBeInTheDocument()
  expect(screen.getByText(/Philippines-wide/)).toBeInTheDocument()
  await screen.findByRole('heading', { name: 'Payment calculations' })
  expect(finance.financeKpis).toHaveBeenCalledWith('2026-10-01', '2026-10-31', { localForbidden: true })
  expect(geography.getGeoDashboard).toHaveBeenCalledWith(expect.objectContaining({ area: '1300000000', categoryId: 'steel' }))
  expect(await screen.findByRole('region', { name: 'Philippines overview' })).toBeInTheDocument()
  expect(screen.getByRole('region', { name: 'Interactive map for Philippines' })).toBeInTheDocument()
  expect(screen.getByRole('region', { name: 'Marketplace payment analytics' }).querySelectorAll('.mp-metric-card')).toHaveLength(4)
  expect(screen.queryByText('View payment calculations')).not.toBeInTheDocument()
  const gmv = within(screen.getByRole('table', { name: 'Gross sales calculation' }))
  expect(gmv.getByRole('row', { name: /^Cancelled order value/ })).toHaveTextContent('-₱5,000.00')
  expect(gmv.getByRole('row', { name: /^Net sales/ })).toHaveTextContent('₱24,000.00')
  const received = within(screen.getByRole('table', { name: 'Buyer payments received calculation' }))
  expect(received.getByRole('row', { name: /^Cash on Delivery collected/ })).toHaveTextContent('₱6,000.00')
  expect(received.getByRole('row', { name: /^Buyer payments received/ })).toHaveTextContent('₱30,000.00')
  const refunds = within(screen.getByRole('table', { name: 'Refunds to Buyers calculation' }))
  expect(refunds.queryByRole('row', { name: /^Other online refunds/ })).not.toBeInTheDocument()
  expect(refunds.getByRole('row', { name: /^Refunds to Buyers/ })).toHaveTextContent('₱3,500.00')
  expect(within(screen.getByRole('table', { name: 'Net Vendor collections calculation' })).getByRole('row', { name: /^Net Vendor collections/ })).toHaveTextContent('₱26,500.00')
  expect(screen.getByText(/₱250.00 more in 1 refund still in progress/)).toBeInTheDocument()
  expect(screen.getByText(/3 confirmed orders, by confirmation date/)).toBeInTheDocument()
  const methods = within(screen.getByRole('list', { name: 'Buyer payments per method' }))
  expect(methods.getAllByRole('listitem').map(row => row.textContent)).toEqual([
    'GCash₱20,500.002 payments · 68.3%', 'Cash on Delivery₱6,000.001 cash record · 20.0%', 'In-Store Payment₱3,500.001 cash record · 11.7%',
  ])
  expect(screen.getByRole('table', { name: 'Daily marketplace volume' })).toBeInTheDocument()
  expect(screen.getByRole('img', { name: /Gross sales, Buyer payments and refunds per day/ })).toBeInTheDocument()
})

test('payment dates refresh the existing projection and preserve geographic query context for returning to its tabs', async () => {
  open()
  await screen.findByRole('heading', { name: 'Payment calculations' })
  fireEvent.click(screen.getByRole('button', { name: /Oct 1.*Oct 31/ }))
  fireEvent.change(screen.getByLabelText('From'), { target: { value: '2026-10-04' } })
  fireEvent.change(screen.getByLabelText('To'), { target: { value: '2026-10-10' } })
  fireEvent.click(screen.getByRole('button', { name: 'Apply' }))
  await waitFor(() => expect(finance.financeKpis).toHaveBeenLastCalledWith('2026-10-04', '2026-10-10', { localForbidden: true }))
  const query = new URLSearchParams(screen.getByTestId('query').textContent!)
  expect(query.get('view')).toBe('payments')
  expect(query.get('area')).toBe('1300000000')
  expect(query.get('categoryId')).toBe('steel')
})

test('finance access denial stays inside the payments tab and does not display protected totals', async () => {
  vi.mocked(finance.financeKpis).mockRejectedValue(new ResponseError(new Response(JSON.stringify({ errors: [{ code: 'PERMISSION_DENIED', message: 'Finance access is required for payment totals.' }] }), { status: 403 }), 'denied'))
  open()
  expect(await screen.findByText('Finance access is required for payment totals.')).toBeInTheDocument()
  expect(screen.getByRole('tab', { name: 'Trends & activity' })).toBeInTheDocument()
  expect(screen.queryByRole('heading', { name: 'Marketplace payments' })).not.toBeInTheDocument()
  expect(screen.getByRole('button', { name: 'Try again' })).toBeInTheDocument()
  expect(await screen.findByRole('region', { name: 'Philippines overview' })).toBeInTheDocument()
})

test('empty payment records retain zero amounts and a failed request can be retried', async () => {
  vi.mocked(finance.financeKpis).mockRejectedValueOnce(new Error('Payment totals unavailable')).mockResolvedValue({ ...marketplacePaymentsFixture(), commerce: [], counts: {}, paymentMethods: [], trend: [] })
  open()
  await screen.findByText('Payment totals unavailable')
  fireEvent.click(screen.getByRole('button', { name: 'Try again' }))
  expect(await screen.findByText('No Buyer payments in this period.')).toBeInTheDocument()
  expect(screen.getAllByText('₱0.00').length).toBeGreaterThan(4)
})

test('switching payment tabs preserves the geographic map, its selected metric and query context', async () => {
  open()
  await screen.findByRole('region', { name: 'Philippines overview' })
  fireEvent.change(screen.getByRole('combobox', { name: 'Map metric' }), { target: { value: 'orders' } })
  fireEvent.click(screen.getByRole('tab', { name: 'Trends & activity' }))
  expect(screen.getByRole('combobox', { name: 'Map metric' })).toHaveValue('orders')
  expect(screen.queryByRole('region', { name: 'Marketplace payment analytics' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('tab', { name: 'Marketplace payments' }))
  expect(screen.getByRole('heading', { name: 'Philippine geographic analytics', level: 1 })).toBeInTheDocument()
  expect(screen.getByRole('combobox', { name: 'Map metric' })).toHaveValue('orders')
  expect(geography.getGeoDashboard).toHaveBeenCalledTimes(1)
  expect(geography.getGeoBoundaries).toHaveBeenCalledTimes(1)
  expect(screen.getByTestId('query')).toHaveTextContent('area=1300000000&categoryId=steel')
})

test('a geographic request failure keeps the geographic header and independent payment totals available', async () => {
  vi.mocked(geography.getGeoDashboard).mockRejectedValue(new Error('Geographic activity unavailable'))
  open()
  expect(await screen.findByText('Geographic activity unavailable')).toBeInTheDocument()
  expect(screen.getByRole('heading', { name: 'Philippine geographic analytics', level: 1 })).toBeInTheDocument()
  expect(await screen.findByRole('heading', { name: 'Payment calculations' })).toBeInTheDocument()
})
