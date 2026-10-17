import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import { ResponseError } from '@materyalph/api-client-ts'
import { dateFilterPreset } from '@materyalph/web-ui'
import { VendorInsightsWorkspace } from './VendorDashboardInsights'
import * as api from '../lib/dashboard-api'
import { vendorInsightsFixture } from '../test/dashboard-insights-fixture'

vi.mock('../lib/dashboard-api', async original => ({ ...await original<typeof import('../lib/dashboard-api')>(), getVendorDashboardInsights: vi.fn() }))

beforeEach(() => {
  vi.clearAllMocks()
  vi.mocked(api.getVendorDashboardInsights).mockResolvedValue(vendorInsightsFixture())
})

const open = () => render(<MemoryRouter><VendorInsightsWorkspace overviewFooter={<p>Store workspace footer</p>} /></MemoryRouter>)

test('the Owner overview shows live KPIs, the orders chart with its forecast, priority actions and incoming requests', async () => {
  open()
  expect(await screen.findByText('Gross sales')).toBeVisible()
  expect(screen.getByText('₱72,000.00')).toBeVisible()
  expect(screen.getAllByText('+20.0% vs previous 30 days').length).toBe(2)
  expect(screen.getByRole('img', { name: /Orders confirmed per day/ })).toBeInTheDocument()
  expect(screen.getByText(/Next 7 days: about/)).toBeVisible()
  expect(screen.getByRole('link', { name: /MP-ORD-1001/ })).toHaveAttribute('href', '/orders/0192f000-0000-7000-8000-000000000001')
  const actions = screen.getByRole('region', { name: 'Priority actions' })
  expect(within(actions).getByText('Cases awaiting your response')).toBeVisible()
  expect(screen.getByText('Store workspace footer')).toBeVisible()
  expect(api.getVendorDashboardInsights).toHaveBeenCalledWith({})
})

test('the chart is keyboard-readable and its values are available as a table', async () => {
  open()
  const chart = await screen.findByRole('img', { name: /Orders confirmed per day/ })
  fireEvent.keyDown(chart, { key: 'Home' })
  expect(within(chart.closest('figure')!).getByRole('status')).toHaveTextContent(/Orders confirmed 2; Order requests 3/)
  fireEvent.keyDown(chart, { key: 'End' })
  expect(within(chart.closest('figure')!).getByRole('status')).toHaveTextContent(/Forecast 3 \(95% range 1 to 4\.5\)/)
  fireEvent.click(screen.getAllByText('View as table')[0]!)
  expect(screen.getByRole('table', { name: 'Orders per day' })).toBeInTheDocument()
})

test('changing the period requests that period', async () => {
  HTMLDialogElement.prototype.showModal = function () { this.open = true }
  HTMLDialogElement.prototype.close = function () { this.open = false }
  open()
  await screen.findByText('Gross sales')
  fireEvent.click(screen.getByRole('button', { name: 'All dates' }))
  fireEvent.click(screen.getByRole('button', { name: 'Last 90 days' }))
  fireEvent.click(screen.getByRole('button', { name: 'Apply' }))
  const range = dateFilterPreset(90)
  await waitFor(() => expect(api.getVendorDashboardInsights).toHaveBeenCalledWith({ from: range.from, to: range.to }))
})

test('sales tab shows mining results: segments, ordered-together rules and a forecast that explains missing data', async () => {
  open()
  await screen.findByText('Gross sales')
  fireEvent.click(screen.getByRole('button', { name: 'Sales & Revenue' }))
  expect(await screen.findByText('Average order value')).toBeVisible()
  expect(screen.getByText(/Not enough activity for a forecast yet/)).toBeVisible()
  expect(screen.getByRole('img', { name: /Products by orders and distinct Buyers/ })).toBeInTheDocument()
  expect(screen.getAllByText('High demand').length).toBeGreaterThan(1)
  expect(screen.getByText('70% confidence')).toBeVisible()
  expect(screen.getByText(/1.60× more often than chance/)).toBeVisible()
})

test('a role without finance.view never sees peso figures and is told why', async () => {
  const fixture = vendorInsightsFixture()
  vi.mocked(api.getVendorDashboardInsights).mockResolvedValue({ ...fixture, access: { ...fixture.access, salesValue: false },
    orders: { ...fixture.orders!, kpis: { ...fixture.orders!.kpis, grossSalesCentavos: null, netSalesCentavos: null, averageOrderValueCentavos: null }, forecast: { ...fixture.orders!.forecast, sales: null },
      series: fixture.orders!.series.map(point => ({ ...point, grossSalesCentavos: null, netSalesCentavos: null, salesAverageCentavos: null })),
      products: { ...fixture.orders!.products, top: fixture.orders!.products.top.map(product => ({ ...product, valueCentavos: null })), categories: fixture.orders!.products.categories.map(category => ({ ...category, valueCentavos: null })) } } })
  open()
  expect(await screen.findByText('Fulfillment rate')).toBeVisible()
  expect(screen.queryByText('Gross sales')).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Sales & Revenue' }))
  expect(await screen.findByText(/Peso sales and earnings figures are available to the Vendor Owner/)).toBeVisible()
  expect(screen.queryByText(/₱40,000.00/)).not.toBeInTheDocument()
})

test('assigned-work roles get their own work and a reason instead of store-wide charts', async () => {
  vi.mocked(api.getVendorDashboardInsights).mockResolvedValue(vendorInsightsFixture({ access: { orders: false, salesValue: false, performance: false, stock: false, disputes: false, assignedFulfillment: true },
    orders: null, performance: null, stock: null, disputes: null, actions: [{ key: 'ASSIGNED_FULFILLMENT', label: 'Orders assigned to you', count: 3, severity: 'ACTION', href: '/orders', detail: null }] }))
  open()
  expect(await screen.findByText(/Store-wide order measures are available to the Owner/)).toBeVisible()
  expect(screen.getAllByText('Orders assigned to you')[0]).toBeVisible()
  fireEvent.click(screen.getByRole('button', { name: 'Performance' }))
  expect(await screen.findByText(/Store-wide performance is available to the Owner and Store Manager/)).toBeVisible()
})

test('traffic never invents store visits and quality shows case measures', async () => {
  open()
  await screen.findByText('Gross sales')
  fireEvent.click(screen.getByRole('button', { name: 'Traffic & Volume' }))
  expect(await screen.findByText(/does not record storefront visits/)).toBeVisible()
  expect(screen.getByText('90% of order requests')).toBeVisible()
  expect(screen.queryByText(/of buyer inquiries|of quotations published/)).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Disputes & Quality' }))
  expect(await screen.findByText('Open cases')).toBeVisible()
  expect(screen.getByText('1 awaiting your response.')).toBeVisible()
})

test('performance shows the workflow-threshold indicator with its reason', async () => {
  open()
  await screen.findByText('Gross sales')
  fireEvent.click(screen.getByRole('button', { name: 'Performance' }))
  expect(await screen.findByText('Watch')).toBeVisible()
  expect(screen.getByText('Outside the no-penalty band: LSR.')).toBeVisible()
  expect(screen.getByText(/Band: low · penalty 0.25/)).toBeVisible()
})

test('a failed load explains the problem and retries on request', async () => {
  vi.mocked(api.getVendorDashboardInsights).mockRejectedValueOnce(new ResponseError(new Response(JSON.stringify({ data: null, meta: {}, errors: [{ code: 'SERVICE_UNAVAILABLE', message: 'The dashboard is temporarily unavailable.' }] }), { status: 503 })))
  open()
  expect(await screen.findByText('The dashboard is temporarily unavailable.')).toBeVisible()
  fireEvent.click(screen.getByRole('button', { name: 'Retry' }))
  expect(await screen.findByText('Gross sales')).toBeVisible()
})
