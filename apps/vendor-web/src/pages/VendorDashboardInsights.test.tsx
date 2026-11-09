import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import { ResponseError } from '@materyalph/api-client-ts'
import { dateFilterPreset } from '@materyalph/web-ui'
import { VendorInsightsWorkspace } from './VendorDashboardInsights'
import * as api from '../lib/dashboard-api'
import { vendorInsightsFixture } from '../test/dashboard-insights-fixture'
import * as onboarding from '../lib/onboarding-api'

vi.mock('../lib/dashboard-api', async original => ({ ...await original<typeof import('../lib/dashboard-api')>(), getVendorDashboardInsights: vi.fn() }))
vi.mock('../lib/onboarding-api', async original => ({ ...await original<typeof import('../lib/onboarding-api')>(), listVendorTeamActivity: vi.fn() }))

beforeEach(() => {
  vi.clearAllMocks()
  vi.mocked(api.getVendorDashboardInsights).mockResolvedValue(vendorInsightsFixture())
  vi.mocked(onboarding.listVendorTeamActivity).mockResolvedValue({ data: [], meta: { currentPage: 1, lastPage: 1, total: 0, totalEvents: 0, succeededEvents: 0, failedEvents: 0, categories: [] }, errors: [] })
})

const open = () => render(<MemoryRouter><VendorInsightsWorkspace storeName="Sample Supply" overviewFooter={<p>Store workspace footer</p>} /></MemoryRouter>)

test('Recent activity follows Priority actions only when the viewer has activity access', async () => {
  const restricted = open()
  await screen.findByRole('region', { name: 'Priority actions' })
  expect(screen.queryByRole('region', { name: 'Recent activity' })).not.toBeInTheDocument()
  expect(onboarding.listVendorTeamActivity).not.toHaveBeenCalled()
  restricted.unmount()
  render(<MemoryRouter><VendorInsightsWorkspace storeName="Sample Supply" canViewRecentActivity /></MemoryRouter>)
  const history = await screen.findByRole('region', { name: 'Recent activity' })
  expect(history.previousElementSibling).toBe(screen.getByRole('region', { name: 'Priority actions' }))
  expect(within(history).getByRole('link', { name: 'View all' })).toHaveAttribute('href', '/preview/tracking')
  expect(await screen.findByText(/No activity recorded yet/)).toBeVisible()
  expect(onboarding.listVendorTeamActivity).toHaveBeenCalledWith({ page: 1 })
  fireEvent.click(screen.getByRole('tab', { name: 'Traffic & Volume' }))
  expect(screen.queryByRole('region', { name: 'Recent activity' })).not.toBeInTheDocument()
})

test('the Owner overview shows live KPIs, the orders chart with its forecast, priority actions and incoming requests', async () => {
  open()
  expect(await screen.findByText('Gross sales', { selector: 'dt span' })).toBeVisible()
  const summary = within(screen.getByRole('region', { name: 'At a glance' }))
  expect(summary.getByText('₱72,000.00')).toBeVisible()
  expect(summary.getAllByRole('term').map(term => term.textContent)).toEqual(['Earnings', 'Gross sales', 'Average order value', 'Orders confirmed'])
  expect(summary.getByText('Gross sales').closest('dl')).not.toHaveClass('mp-metric-card-accent')
  expect(summary.getByText('Earnings').closest('dl')).toHaveClass('mp-metric-card-accent')
  expect(summary.getByText('₱70,000.00')).toBeVisible()
  expect(summary.getByText('₱1,000.00')).toBeVisible()
  const changes = screen.getAllByText('+20.0%')
  expect(changes).toHaveLength(2)
  changes.forEach(change => expect(change.closest('dd')).toHaveTextContent('+20.0% vs previous 30 days'))
  expect(screen.getByRole('img', { name: /Orders confirmed per day/ })).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'How this is calculated: Order activity' }))
  const explanation = screen.getByRole('dialog', { name: 'Order activity' })
  const outlook = within(explanation)
  fireEvent.click(outlook.getByText('7-day outlook'))
  expect(outlook.getByText(/Next 7 days: about/)).toBeVisible()
  fireEvent.keyDown(explanation, { key: 'Escape' })
  expect(screen.getByRole('link', { name: /MP-ORD-1001/ })).toHaveAttribute('href', '/orders/0192f000-0000-7000-8000-000000000001')
  const actions = screen.getByRole('region', { name: 'Priority actions' })
  expect(within(actions).getByText('Cases awaiting your response')).toBeVisible()
  expect(screen.getByText('Store workspace footer')).toBeVisible()
  const range = dateFilterPreset(30)
  expect(api.getVendorDashboardInsights).toHaveBeenCalledWith({ from: range.from, to: range.to })
  expect(summary.getByText('Sep 10 – Oct 9')).toBeVisible()
  expect(screen.queryByRole('button', { name: 'Clear all' })).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: /Remove Last 30 days/ })).not.toBeInTheDocument()
})

test('Overview shows ranked products, demand groups and associations with a permitted analytics link', async () => {
  const fixture = vendorInsightsFixture()
  fixture.orders!.products.top.push(...Array.from({ length: 5 }, (_, index) => ({ ...fixture.orders!.products.top[0]!, name: `Additional product ${index + 1}` })))
  vi.mocked(api.getVendorDashboardInsights).mockResolvedValue(fixture)
  render(<MemoryRouter><VendorInsightsWorkspace storeName="Sample Supply" canViewProductAnalytics /></MemoryRouter>)
  const productsCard = await screen.findByRole('region', { name: 'Top products' })
  const performance = screen.getByRole('region', { name: 'Store performance' })
  expect(productsCard.previousElementSibling).toBe(performance)
  expect(within(performance).getByRole('link', { name: 'View performance' })).toHaveAttribute('href', '/performance')
  expect(productsCard.parentElement).toHaveClass('mp-analytics-overview')
  expect(screen.getAllByRole('region', { name: 'Top products' })).toHaveLength(1)
  const products = within(productsCard)
  expect(products.getByRole('link', { name: 'Product analytics' })).toHaveAttribute('href', '/analytics/products?from=2026-09-10&to=2026-10-09')
  const rows = products.getAllByRole('listitem')
  expect(rows).toHaveLength(5)
  expect(products.queryByText('Additional product 4')).not.toBeInTheDocument()
  expect(rows[0]).toHaveTextContent('Portland Cement Type 1')
  expect(rows[0]).toHaveTextContent('₱40,000.00')
  expect(rows[0]).toHaveTextContent('Cement · 40 orders · 22 Buyers')
  expect(screen.getByRole('img', { name: /Products by orders and distinct Buyers/ })).toBeVisible()
  const patterns = within(screen.getByRole('region', { name: 'Frequently ordered together' }))
  expect(patterns.getByText('70% confidence')).toBeVisible()
  expect(patterns.getByText(/1.60× more often than chance · in 14 orders/)).toBeVisible()
  expect(screen.queryByRole('tab', { name: 'Sales & Revenue' })).not.toBeInTheDocument()
})

test('insufficient product data keeps short reasons and hides the unauthorized analytics link', async () => {
  const fixture = vendorInsightsFixture()
  fixture.orders!.products.top = []
  fixture.orders!.products.segments = { ...fixture.orders!.products.segments, state: 'INSUFFICIENT_DATA', reason: 'At least four products with orders are needed.', points: [], segments: [] }
  fixture.orders!.products.basketRules = { baskets: 6, windowDays: 90, rules: [] }
  vi.mocked(api.getVendorDashboardInsights).mockResolvedValue(fixture)
  open()
  const products = within(await screen.findByRole('region', { name: 'Top products' }))
  expect(products.queryByRole('link', { name: 'Product analytics' })).not.toBeInTheDocument()
  expect(products.getByText('No product sales in this period.')).toBeVisible()
  expect(screen.getByText('At least four products with orders are needed.')).toBeVisible()
  expect(screen.getByText(/No pattern yet.*6 orders checked/)).toBeVisible()
  expect(screen.queryByText(/% confidence/)).not.toBeInTheDocument()
})

test('category and top-product cards keep matching product amounts and reporting dates without an inline breakdown', async () => {
  const fixture = vendorInsightsFixture()
  fixture.period = { ...fixture.period, from: new Date('2026-10-07'), to: new Date('2026-11-05') }
  fixture.orders!.products.top = [{ name: 'Rerolled steel bar', category: 'Steel and Reinforcement', orders: 4, buyers: 2, valueCentavos: 2940650 }]
  fixture.orders!.products.categories = [{ category: 'Steel and Reinforcement', orders: 4, valueCentavos: 2940650 }]
  fixture.orders!.products.salesBreakdown = { productSalesCentavos: 2940650, deliveryCentavos: 93075, refundsCentavos: 0, netSalesCentavos: 3033725 }
  vi.mocked(api.getVendorDashboardInsights).mockResolvedValue(fixture)
  render(<MemoryRouter><VendorInsightsWorkspace storeName="Sample Supply" canViewProductAnalytics /></MemoryRouter>)
  const categories = await screen.findByRole('region', { name: 'Sales by category' })
  expect(within(categories).queryByRole('table')).not.toBeInTheDocument()
  expect(within(categories).getByRole('listitem')).toHaveTextContent('₱29,406.50 · 100.0%')
  const top = screen.getByRole('region', { name: 'Top products' })
  expect(within(top).getByRole('listitem')).toHaveTextContent('₱29,406.50')
  expect(within(top).getByRole('link', { name: 'Product analytics' })).toHaveAttribute('href', '/analytics/products?from=2026-10-07&to=2026-11-05')
  expect(categories).not.toHaveAttribute('data-content-sized')
  expect(top).not.toHaveAttribute('data-content-sized')
  expect(within(categories).getByRole('region', { name: 'Sales by category list' })).toHaveAttribute('tabindex', '0')
  expect(within(top).getByRole('region', { name: 'Top products list' })).toHaveAttribute('tabindex', '0')
})

test('category calculation help retains the product-to-net-sales explanation', async () => {
  const fixture = vendorInsightsFixture()
  fixture.orders!.products.salesBreakdown = { productSalesCentavos: 100000, deliveryCentavos: 10000, refundsCentavos: 25000, netSalesCentavos: 85000 }
  vi.mocked(api.getVendorDashboardInsights).mockResolvedValue(fixture)
  open()
  const categories = within(await screen.findByRole('region', { name: 'Sales by category' }))
  expect(categories.queryByRole('table')).not.toBeInTheDocument()
  fireEvent.click(categories.getByRole('button', { name: 'How this is calculated: Sales by category' }))
  expect(within(screen.getByRole('dialog', { name: 'Sales by category' })).getByText(/Product sales plus delivery minus completed partial refunds equals Earnings/)).toBeVisible()
})

test('each overview chart explains its calculation without expanding the card', async () => {
  open()
  await screen.findByRole('region', { name: 'Sales trend' })
  for (const title of ['Sales trend', 'Order activity', 'Sales by category', 'Store performance', 'Top products', 'Product demand segments', 'Frequently ordered together', 'Stock status']) {
    const card = within(screen.getByRole('region', { name: title }))
    const trigger = card.getByRole('button', { name: `How this is calculated: ${title}` })
    expect(trigger.closest('header')).toHaveClass('mp-card-header')
    fireEvent.click(trigger)
    const explanation = screen.getByRole('dialog', { name: title })
    expect(explanation).toBeVisible()
    if (title === 'Store performance') {
      expect(within(explanation).getByText(/50% Community rating/)).toBeVisible()
      expect(within(explanation).getByText(/confirmed listing violations/)).toBeVisible()
    }
    fireEvent.keyDown(explanation, { key: 'Escape' })
    expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
  }
  expect(screen.queryByText('Score details')).not.toBeInTheDocument()
})

test('Priority actions keeps all six authorized queues visible when nothing is waiting', async () => {
  const fixture = vendorInsightsFixture()
  fixture.actions.splice(2, 0, { key: 'FULFILLMENT_DUE_TODAY', label: 'Orders due for fulfillment today', count: 0, severity: 'ACTION', href: '/orders', detail: null })
  fixture.actions.push({ key: 'LIMITED_STOCK', label: 'Variants at or below reorder level', count: 0, severity: 'ACTION', href: '/products/inventory', detail: null })
  fixture.actions = fixture.actions.map(action => ({ ...action, count: 0, severity: 'ACTION', detail: null }))
  vi.mocked(api.getVendorDashboardInsights).mockResolvedValue(fixture)
  open()
  const actions = within(await screen.findByRole('region', { name: 'Priority actions' }))
  expect(actions.getByText('Work waiting for your role, most urgent first.')).toBeVisible()
  expect(actions.getAllByRole('listitem')).toHaveLength(6)
  expect(actions.getByRole('list')).toHaveClass('mp-analytics-queue')
  expect(actions.getAllByText('Nothing waiting.')).toHaveLength(6)
  expect(actions.getAllByText('0', { exact: true })).toHaveLength(6)
  const links = actions.getAllByRole('link')
  fixture.actions.forEach((action, index) => {
    expect(links[index]).toHaveTextContent(action.label)
    expect(links[index]).toHaveAttribute('href', action.href)
  })
})

test('Order activity stays keyboard-readable without a three-dot menu or table view', async () => {
  open()
  const chart = await screen.findByRole('img', { name: /Orders confirmed per day/ })
  fireEvent.keyDown(chart, { key: 'Home' })
  expect(within(chart.closest('figure')!).getByRole('status')).toHaveTextContent(/Orders confirmed 2; Order requests 3/)
  fireEvent.click(within(chart.closest('figure')!).getByRole('button', { name: 'Show forecast' }))
  fireEvent.keyDown(chart, { key: 'End' })
  expect(within(chart.closest('figure')!).getByRole('status')).toHaveTextContent(/Forecast 3 \(95% range 1 to 4\.5\)/)
  const card = within(screen.getByRole('region', { name: 'Order activity' }))
  expect(card.queryByLabelText('Chart details for Order activity')).not.toBeInTheDocument()
  expect(card.queryByText('View as table')).not.toBeInTheDocument()
  expect(card.queryByRole('table', { hidden: true })).not.toBeInTheDocument()
  expect(card.getByRole('button', { name: 'How this is calculated: Order activity' })).toBeVisible()
})

test('the sales overview uses the authorized total and daily series with exact peso tooltips', async () => {
  open()
  const card = within(await screen.findByRole('region', { name: 'Sales trend' }))
  expect(card.getByText('Total gross sales')).toBeVisible()
  expect(card.getByText('₱72,000.00')).toBeVisible()
  expect(card.getByRole('list', { name: 'Selected period totals' })).toBeVisible()
  expect(card.queryByLabelText('Chart details for Sales trend')).not.toBeInTheDocument()
  const chart = card.getByRole('img', { name: /Earnings, refunds and cancelled sales per day/ })
  expect(chart.closest('figure')).toHaveAttribute('data-chart-variant', 'bar')
  fireEvent.focus(chart)
  const tooltip = within(card.getByRole('tooltip'))
  expect(tooltip.getByText('Earnings')).toBeVisible()
  expect(tooltip.getByText('₱1,900.00')).toBeVisible()
  expect(tooltip.getByText('Refunds')).toBeVisible()
  expect(tooltip.getByText('-₱100.00')).toBeVisible()
  expect(card.queryByRole('button', { name: 'Show forecast' })).not.toBeInTheDocument()
  fireEvent.keyDown(chart, { key: 'Escape' })
  expect(card.queryByRole('tooltip')).not.toBeInTheDocument()
  fireEvent.click(card.getByText('View as table'))
  expect(card.getByRole('table', { name: 'Sales per day' })).toBeVisible()
})

test('the sales card totals the full period when its latest day is zero and reconciles earnings', async () => {
  const fixture = vendorInsightsFixture()
  fixture.orders!.kpis.grossSalesCentavos = { value: 3487020, previous: 0 }
  fixture.orders!.kpis.netSalesCentavos = { value: 3062275, previous: 0 }
  fixture.orders!.series = [
    { date: new Date('2026-10-20T00:00:00Z'), orders: 5, orderRequests: 5, grossSalesCentavos: 3169800, netSalesCentavos: 2933800, refundsCentavos: 236000, cancellationDeductionsCentavos: 0 },
    { date: new Date('2026-10-21T00:00:00Z'), orders: 3, orderRequests: 3, grossSalesCentavos: 317220, netSalesCentavos: 128475, refundsCentavos: 0, cancellationDeductionsCentavos: 188745 },
    { date: new Date('2026-11-04T00:00:00Z'), orders: 0, orderRequests: 0, grossSalesCentavos: 0, netSalesCentavos: 0, refundsCentavos: 0, cancellationDeductionsCentavos: 0 },
  ]
  vi.mocked(api.getVendorDashboardInsights).mockResolvedValue(fixture)
  open()
  const card = within(await screen.findByRole('region', { name: 'Sales trend' }))
  expect(card.getByText('₱34,870.20')).toBeVisible()
  expect(card.getByText('₱30,622.75')).toBeVisible()
  expect(card.getByText('-₱2,360.00', { selector: '.mp-trend-series-value' })).toBeVisible()
  expect(card.getByText('-₱1,887.45', { selector: '.mp-trend-series-value' })).toBeVisible()
  expect(card.getByText('Cancelled sales', { selector: 'span' }).closest('li')).toBeInTheDocument()
  expect(card.queryByText('Other cancellation deductions', { selector: 'span' })).not.toBeInTheDocument()
  expect(card.queryByText(/Latest day/)).not.toBeInTheDocument()
  const chart = card.getByRole('img', { name: /Earnings, refunds and cancelled sales per day/ })
  fireEvent.focus(chart)
  expect(within(card.getByRole('tooltip')).getByText('₱29,338.00')).toBeVisible()
  expect(within(card.getByRole('tooltip')).getByText('-₱2,360.00')).toBeVisible()
  fireEvent.keyDown(chart, { key: 'ArrowRight' })
  expect(within(card.getByRole('tooltip')).getByText('Cancelled sales')).toBeVisible()
  expect(within(card.getByRole('tooltip')).getByText('-₱1,887.45')).toBeVisible()
  expect(chart.querySelector('[data-bar-series="cancellations"]')).toBeInTheDocument()
  fireEvent.keyDown(chart, { key: 'End' })
  expect(within(card.getByRole('tooltip')).getAllByText('-₱0.00')).toHaveLength(2)
  expect(card.getByText('₱30,622.75')).toBeVisible()
  fireEvent.click(card.getByRole('button', { name: 'How this is calculated: Sales trend' }))
  const rows = within(screen.getByRole('table', { name: 'Earnings for the selected period' })).getAllByRole('row')
  expect(rows.map(row => row.textContent)).toEqual(['Gross sales₱34,870.20', 'Refunds-₱2,360.00', 'Cancelled sales-₱1,887.45', 'Earnings₱30,622.75'])
})

test.each([0, 3487020])('Vendor summary keeps comparison badges when the previous period is zero (sales %s)', async value => {
  const fixture = vendorInsightsFixture()
  fixture.period.days = 33
  fixture.orders!.kpis.grossSalesCentavos = { value, previous: 0, changePercent: null }
  fixture.orders!.kpis.netSalesCentavos = { value: value === 0 ? 0 : 3062275, previous: 0, changePercent: null }
  fixture.orders!.kpis.averageOrderValueCentavos = { value: value === 0 ? null : 435878, previous: 0 }
  fixture.orders!.kpis.orderVolume = { value: value === 0 ? 0 : 8, previous: 0, changePercent: null }
  vi.mocked(api.getVendorDashboardInsights).mockResolvedValue(fixture)
  open()
  const summary = within(await screen.findByRole('region', { name: 'At a glance' }))
  expect(summary.getAllByText('No comparison')).toHaveLength(3)
  expect(summary.getByText('No sales in previous 33 days')).toBeVisible()
  expect(summary.getByText('No earnings in previous 33 days')).toBeVisible()
  expect(summary.getByText('Nothing to compare in previous 33 days.')).toBeVisible()
  expect(summary.getByText('No confirmed orders in previous 33 days')).toBeVisible()
  expect(within(summary.getByText('Gross sales', { selector: 'dt span' }).closest('dl')!).getByText(value === 0 ? '₱0.00' : '₱34,870.20')).toBeVisible()
  expect(summary.queryByText(/%/)).not.toBeInTheDocument()
})

test('missing Vendor comparison data shows a badge without fabricating a percentage', async () => {
  const fixture = vendorInsightsFixture()
  fixture.orders!.kpis.grossSalesCentavos = { value: 3487020, previous: 1000000 }
  fixture.orders!.kpis.netSalesCentavos = { value: 3062275, previous: 1000000 }
  fixture.orders!.kpis.orderVolume = { value: 8, previous: 6, changePercent: null }
  vi.mocked(api.getVendorDashboardInsights).mockResolvedValue(fixture)
  open()
  const summary = within(await screen.findByRole('region', { name: 'At a glance' }))
  expect(summary.getAllByText('No comparison')).toHaveLength(3)
  expect(summary.getAllByText('Previous period comparison unavailable')).toHaveLength(3)
  expect(summary.queryByText(/%/)).not.toBeInTheDocument()
})

test('changing the period requests that period', async () => {
  HTMLDialogElement.prototype.showModal = function () { this.open = true }
  HTMLDialogElement.prototype.close = function () { this.open = false }
  open()
  await screen.findByText('Gross sales', { selector: 'dt span' })
  fireEvent.click(screen.getByRole('button', { name: 'Last 30 days' }))
  fireEvent.click(screen.getByRole('button', { name: 'Last 90 days' }))
  fireEvent.click(screen.getByRole('button', { name: 'Apply' }))
  const range = dateFilterPreset(90)
  await waitFor(() => expect(api.getVendorDashboardInsights).toHaveBeenCalledWith({ from: range.from, to: range.to }))
})

test('the dashboard keeps Overview, Traffic and Quality without Performance or Sales sections', async () => {
  open()
  await screen.findByText('Gross sales', { selector: 'dt span' })
  expect(screen.getAllByRole('tab').map(tab => tab.textContent)).toEqual(['Overview', 'Traffic & Volume', 'Disputes & Quality'])
  expect(screen.getByText('Average order value')).toBeVisible()
  expect(screen.getByRole('region', { name: 'Store performance' })).toBeVisible()
})

test('a role without finance.view sees operational counts without sales values', async () => {
  const fixture = vendorInsightsFixture()
  vi.mocked(api.getVendorDashboardInsights).mockResolvedValue({ ...fixture, access: { ...fixture.access, salesValue: false },
    orders: { ...fixture.orders!, kpis: { ...fixture.orders!.kpis, grossSalesCentavos: null, netSalesCentavos: null, averageOrderValueCentavos: null }, forecast: { ...fixture.orders!.forecast, sales: null },
      series: fixture.orders!.series.map(point => ({ ...point, grossSalesCentavos: null, netSalesCentavos: null, salesAverageCentavos: null })),
      products: { ...fixture.orders!.products, top: fixture.orders!.products.top.map(product => ({ ...product, valueCentavos: null })), categories: fixture.orders!.products.categories.map(category => ({ ...category, valueCentavos: null })), salesBreakdown: null } } })
  open()
  expect(await screen.findByText('Fulfillment rate')).toBeVisible()
  expect(screen.queryByText('Gross sales')).not.toBeInTheDocument()
  expect(screen.queryByText('Earnings')).not.toBeInTheDocument()
  expect(screen.queryByText('Average order value')).not.toBeInTheDocument()
  const products = within(screen.getByRole('region', { name: 'Top products' }))
  expect(products.getByText('40 orders')).toBeVisible()
  expect(products.queryByText(/₱/)).not.toBeInTheDocument()
  expect(screen.queryByText(/₱40,000.00/)).not.toBeInTheDocument()
})

test('assigned-work roles get their own work and a reason instead of store-wide charts', async () => {
  vi.mocked(api.getVendorDashboardInsights).mockResolvedValue(vendorInsightsFixture({ access: { orders: false, salesValue: false, performance: false, stock: false, disputes: false, assignedFulfillment: true },
    orders: null, performance: null, stock: null, disputes: null, actions: [{ key: 'ASSIGNED_FULFILLMENT', label: 'Orders assigned to you', count: 3, severity: 'ACTION', href: '/orders', detail: null }] }))
  open()
  expect(await screen.findByText(/Store-wide order measures are available to the Owner/)).toBeVisible()
  expect(screen.getAllByText('Orders assigned to you')[0]).toBeVisible()
  expect(screen.queryByRole('region', { name: 'Top products' })).not.toBeInTheDocument()
  expect(screen.queryByRole('link', { name: 'View performance' })).not.toBeInTheDocument()
  expect(screen.queryByRole('region', { name: 'Product demand patterns' })).not.toBeInTheDocument()
  expect(screen.queryByRole('tab', { name: 'Performance' })).not.toBeInTheDocument()
  expect(screen.queryByRole('tab', { name: 'Sales & Revenue' })).not.toBeInTheDocument()
})

test('traffic never invents store visits and quality shows case measures', async () => {
  open()
  await screen.findByText('Gross sales', { selector: 'dt span' })
  fireEvent.click(screen.getByRole('tab', { name: 'Traffic & Volume' }))
  expect(await screen.findByText(/does not record storefront visits/)).toBeVisible()
  expect(screen.getByText('90% of order requests')).toBeVisible()
  expect(screen.queryByText(/of buyer inquiries|of quotations published/)).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('tab', { name: 'Disputes & Quality' }))
  expect(await screen.findByText('Open cases')).toBeVisible()
  expect(screen.getByText('1 awaiting your response.')).toBeVisible()
})

test('summary metrics explain the same confirmed-order cohort and earnings deductions', async () => {
  open()
  const summary = within(await screen.findByRole('region', { name: 'At a glance' }))
  for (const [title, definition] of [
    ['Gross sales', /including materials, NRPC and delivery/],
    ['Earnings', /gross sales − completed refund deductions − remaining cancelled-order value/],
    ['Average order value', /rounded to the nearest centavo/],
    ['Orders confirmed', /Each order counts once/],
  ] as const) {
    const trigger = summary.getByRole('button', { name: `How this is calculated: ${title}` })
    expect(trigger.textContent).toBe('')
    expect(trigger.closest('dt')).toHaveClass('mp-kpi-label')
    expect(trigger.querySelector('svg')).toHaveAttribute('aria-hidden', 'true')
    expect(trigger.closest('dt')!.querySelector('.mp-kpi-icon svg')).toHaveClass(title === 'Orders confirmed' ? 'lucide-shopping-cart' : 'lucide-wallet')
    fireEvent.click(trigger)
    const explanation = screen.getByRole('dialog', { name: title })
    expect(within(explanation).getByText(definition)).toBeVisible()
    fireEvent.keyDown(explanation, { key: 'Escape' })
    expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
  }
})

test('traffic cards explain independent stages, shares and dates and expose daily values as a table', async () => {
  open()
  await screen.findByRole('region', { name: 'Sales trend' })
  fireEvent.click(screen.getByRole('tab', { name: 'Traffic & Volume' }))
  for (const [title, definition] of [
    ['Demand funnel', /Stages are counted separately and may belong to different journeys/],
    ['Order mix', /their totals must not be added together/],
    ['Requests and confirmations per day', /requested on one day and confirmed on another/],
  ] as const) {
    const card = within(screen.getByRole('region', { name: title }))
    fireEvent.click(card.getByRole('button', { name: `How this is calculated: ${title}` }))
    const explanation = screen.getByRole('dialog', { name: title })
    expect(within(explanation).getByText(definition)).toBeVisible()
    fireEvent.keyDown(explanation, { key: 'Escape' })
  }
  const daily = within(screen.getByRole('region', { name: 'Requests and confirmations per day' }))
  fireEvent.click(daily.getByLabelText('Chart details for Requests and confirmations per day'))
  fireEvent.click(daily.getByText('View as table'))
  const rows = within(daily.getByRole('table')).getAllByRole('row')
  expect(rows).toHaveLength(31)
  expect(rows[1]).toHaveTextContent('Sep 10')
})

test('quality metrics distinguish current cases from period rates without fake empty status bars', async () => {
  const fixture = vendorInsightsFixture()
  fixture.disputes = { ...fixture.disputes!, open: 0, awaitingResponse: 0, statuses: [], series: fixture.disputes!.series.map((point, index) => ({ ...point, cases: index === 0 ? 1 : 0 })) }
  fixture.orders!.kpis.disputeRate = { percent: null, numerator: 0, denominator: 0 }
  fixture.orders!.kpis.cancellationRate = { percent: null, numerator: 0, denominator: 0 }
  vi.mocked(api.getVendorDashboardInsights).mockResolvedValue(fixture)
  open()
  await screen.findByRole('region', { name: 'Sales trend' })
  fireEvent.click(screen.getByRole('tab', { name: 'Disputes & Quality' }))
  const status = within(screen.getByRole('region', { name: 'Open cases by status' }))
  expect(status.getByText('No open cases. There are no active cases to group by status.')).toBeVisible()
  expect(status.queryByRole('img')).not.toBeInTheDocument()
  expect(within(screen.getByRole('region', { name: 'Cancellation' })).getByText('—')).toBeVisible()
  const ticks = [...screen.getByRole('img', { name: /Dispute cases filed per day/ }).querySelectorAll('g > text')].map(tick => tick.textContent)
  expect(ticks).toEqual(['0', '1'])
  for (const [title, definition] of [
    ['Open cases', /currently active cases across all dates/],
    ['Dispute rate', /Each order is counted once/],
    ['Validated returns', /using the validation date/],
    ['Fulfillment issues reported', /one order can contribute more than one report/],
    ['Cases filed per day', /1 case filed/],
    ['Issue types', /Each case contributes once/],
    ['Open cases by status', /regardless of the selected reporting dates/],
    ['Cancellation', /Requests declined or expired before confirmation are excluded/],
  ] as const) {
    fireEvent.click(screen.getByRole('button', { name: `How this is calculated: ${title}` }))
    const explanation = screen.getByRole('dialog', { name: title })
    expect(within(explanation).getByText(definition)).toBeVisible()
    fireEvent.keyDown(explanation, { key: 'Escape' })
  }
  const daily = within(screen.getByRole('region', { name: 'Cases filed per day' }))
  fireEvent.click(daily.getByLabelText('Chart details for Cases filed per day'))
  fireEvent.click(daily.getByText('View as table'))
  expect(within(daily.getByRole('table')).getAllByRole('row')[1]).toHaveTextContent('1')
})

test('quality explanations follow the authorized sections when store-wide order data is absent', async () => {
  const fixture = vendorInsightsFixture()
  vi.mocked(api.getVendorDashboardInsights).mockResolvedValue({ ...fixture, orders: null, access: { ...fixture.access, orders: false, salesValue: false } })
  open()
  await screen.findByRole('region', { name: 'Priority actions' })
  fireEvent.click(screen.getByRole('tab', { name: 'Disputes & Quality' }))
  expect(screen.getByRole('button', { name: 'How this is calculated: Open cases' })).toBeVisible()
  expect(screen.queryByRole('button', { name: 'How this is calculated: Dispute rate' })).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'How this is calculated: Cancellation' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('tab', { name: 'Traffic & Volume' }))
  expect(screen.queryByRole('button', { name: /How this is calculated/ })).not.toBeInTheDocument()
})

test('a failed load explains the problem and retries on request', async () => {
  vi.mocked(api.getVendorDashboardInsights).mockRejectedValueOnce(new ResponseError(new Response(JSON.stringify({ data: null, meta: {}, errors: [{ code: 'SERVICE_UNAVAILABLE', message: 'The dashboard is temporarily unavailable.' }] }), { status: 503 })))
  open()
  expect(await screen.findByText('The dashboard is temporarily unavailable.')).toBeVisible()
  fireEvent.click(screen.getByRole('button', { name: 'Retry' }))
  expect(await screen.findByText('Gross sales', { selector: 'dt span' })).toBeVisible()
})
