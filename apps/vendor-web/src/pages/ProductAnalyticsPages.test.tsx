import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import { parseDate, ResponseError } from '@materyalph/api-client-ts'
import * as api from '../lib/product-analytics-api'
import * as trust from '../lib/trust-api'
import type { ProductAnalyticsRow, VendorProductAnalytics, VendorProductAnalyticsDetail } from '../lib/product-analytics-api'
import { useOnboardingSnapshot } from '../lib/vendor-status'
import { VendorProductAnalyticsPage, VendorStorePerformancePage } from './TrustPages'
import { ProductInsightStrip } from './ProductAnalyticsPages'

vi.mock('../lib/product-analytics-api', async original => ({ ...await original<typeof import('../lib/product-analytics-api')>(), getProductAnalytics: vi.fn(), getProductAnalyticsDetail: vi.fn(), getProductSummaries: vi.fn() }))
vi.mock('../lib/trust-api', async original => ({ ...await original<typeof import('../lib/trust-api')>(), getStorePerformance: vi.fn() }))
vi.mock('../lib/vendor-status', () => ({ useOnboardingSnapshot: vi.fn() }))
vi.mock('../lib/catalog-access', async original => ({ ...await original<typeof import('../lib/catalog-access')>(), storeName: () => 'Test Supply' }))
vi.mock('./PhaseThreeVendorPages', async original => ({ ...await original<typeof import('./PhaseThreeVendorPages')>(), VendorShell: ({ children }: { children: React.ReactNode }) => <main>{children}</main> }))

const snapshot = (permissions: string[]) => vi.mocked(useOnboardingSnapshot).mockReturnValue({ snapshot: { permissions }, loading: false, error: null, refresh: vi.fn() } as unknown as ReturnType<typeof useOnboardingSnapshot>)
const rate = (numerator: number, denominator: number) => ({ percent: denominator === 0 ? null : ((numerator / denominator) * 100).toFixed(2), numerator, denominator })
const delta = (value: number, previous: number) => ({ value, previous, changePercent: previous === 0 ? null : Math.round(((value - previous) / previous) * 1000) / 10 })
const forecast = { state: 'INSUFFICIENT_DATA', observedDays: 2, direction: 'UNKNOWN', points: [], anomalies: [] }

function row(overrides: Partial<ProductAnalyticsRow> = {}): ProductAnalyticsRow {
  return { listingId: 'l1', name: 'Portland Cement 40kg', sku: 'CEM-40', category: 'Cement', status: 'ACTIVE', stockStatus: 'IN_STOCK', views: 12, previousViews: 6, viewsChangePercent: 100, viewers: 10, converted: 3,
    conversion: rate(3, 10), conversionLowerBound: 0.1078, orders: 4, previousOrders: 2, buyers: 3, valueCentavos: null, segment: null, rankViews: 1, rankOrders: 1, ...overrides } as ProductAnalyticsRow
}

function overview(sales = false): VendorProductAnalytics {
  const top = row(sales ? { valueCentavos: 480000 } : {})
  const second = row({ listingId: 'l2', name: 'Deformed Bar 10mm', category: 'Steel', views: 5, viewers: 5, converted: 0, conversion: rate(0, 5), conversionLowerBound: 0, orders: 0, buyers: 0, stockStatus: 'OUT_OF_STOCK', rankViews: 2, rankOrders: null, valueCentavos: sales ? 0 : null })
  return {
    generatedAt: new Date('2026-10-10T03:00:00Z'), period: { days: 30, from: parseDate('2026-09-11'), to: parseDate('2026-10-10'), timezone: 'Asia/Manila' }, access: { salesValue: sales },
    definitions: { views: 'Product views: one signed-in Buyer per day.', orders: 'Confirmed orders.', forecast: 'Least-squares trend.', top_selling: 'Ranked by orders.', top_performing: 'Wilson 95% lower bound.', most_viewed: 'Ranked by views.', categories: 'By category.', segments: 'K-Means.', basket_rules: 'Apriori.', suggestions: 'Planning suggestions.', conversion: 'Viewers who ordered.', stock: 'Stock rules.' },
    tracking: { viewsSince: parseDate('2026-09-01') },
    kpis: { views: delta(17, 6), viewers: delta(15, 5), productsViewed: { value: 2, total: 2 }, orders: delta(4, 2), conversion: rate(3, 15), valueCentavos: sales ? delta(480000, 200000) : null },
    series: [{ date: parseDate('2026-10-09'), views: 9, orders: 2, valueCentavos: sales ? 240000 : null }, { date: parseDate('2026-10-10'), views: 8, orders: 2, valueCentavos: sales ? 240000 : null }],
    forecast: { horizonDays: 7, views: forecast }, topSelling: [top], topPerforming: [top], mostViewed: [top, second],
    categories: [{ category: 'Cement', views: 12, orders: 4, valueCentavos: sales ? 480000 : null }, { category: 'Steel', views: 5, orders: 0, valueCentavos: sales ? 0 : null }],
    segments: { state: 'INSUFFICIENT_DATA', reason: 'At least four products with views or orders in the period are needed to group them.', features: [], segments: [], points: [] },
    basketRules: { baskets: 4, rules: [], windowDays: 90 },
    suggestions: [{ key: 'RESTOCK_VIEWED:l2', kind: 'RESTOCK_VIEWED', priority: 'HIGH', title: 'Restock Deformed Bar 10mm', detail: '5 Buyers viewed it in this period, but no variant has stock available to sell.', technique: 'Product views × stock status.', href: '/products/inventory', listingId: 'l2', product: 'Deformed Bar 10mm' }],
    products: { items: [top, second], meta: { page: 1, perPage: 20, total: 2, lastPage: 1, sort: 'views' } },
  } as unknown as VendorProductAnalytics
}

beforeEach(() => { vi.clearAllMocks() })

test('a product manager without score access opens Product analytics directly, with no peso values and an explained panel each', async () => {
  snapshot(['catalog.manage', 'portal.products'])
  vi.mocked(api.getProductAnalytics).mockResolvedValue(overview(false))
  render(<MemoryRouter initialEntries={['/performance']}><VendorStorePerformancePage /></MemoryRouter>)
  expect(await screen.findByRole('region', { name: 'Product views and orders' })).toBeInTheDocument()
  expect(screen.queryByRole('tab')).not.toBeInTheDocument()
  expect(trust.getStorePerformance).not.toHaveBeenCalled()
  expect(api.getProductAnalytics).toHaveBeenCalledWith(30, 'views', 1)
  expect(screen.getByText('20.00%')).toBeInTheDocument()
  expect(screen.queryByText(/₱/)).not.toBeInTheDocument()
  const selling = screen.getByRole('list', { name: 'Top selling products' })
  expect(within(selling).getByRole('link', { name: 'Portland Cement 40kg' })).toHaveAttribute('href', '/performance/products/l1')
  expect(within(selling).getByText('4 orders')).toBeInTheDocument()
  expect(screen.getByText('Restock Deformed Bar 10mm')).toBeInTheDocument()
  expect(screen.getByRole('link', { name: /Open inventory/ })).toHaveAttribute('href', '/products/inventory')
  expect(screen.getByText('Act now')).toBeInTheDocument()
  for (const title of ['Product views and orders', 'Top selling products', 'Top performing products', 'Most viewed products', 'Suggestions', 'Category share', 'Frequently ordered together', 'Product performance segments', 'All products']) {
    const panel = screen.getByRole('region', { name: title })
    expect(within(panel).getByText('How this is calculated'), title).toBeInTheDocument()
  }
  expect(screen.queryByRole('option', { name: 'Highest sales value' })).not.toBeInTheDocument()
})

test('the Owner sees both tabs, peso values, and the period and sort reach the request', async () => {
  snapshot(['scores.view_store', 'catalog.manage', 'finance.view'])
  vi.mocked(trust.getStorePerformance).mockResolvedValue({ calculated: false } as unknown as trust.StorePerformance)
  vi.mocked(api.getProductAnalytics).mockResolvedValue(overview(true))
  render(<MemoryRouter initialEntries={['/performance']}><VendorStorePerformancePage /></MemoryRouter>)
  expect(await screen.findByRole('region', { name: 'No daily calculation yet' })).toBeInTheDocument()
  fireEvent.click(screen.getByRole('tab', { name: 'Product analytics' }))
  expect((await screen.findAllByText('₱4,800.00')).length).toBeGreaterThan(0)
  fireEvent.click(screen.getByLabelText('90 days'))
  await waitFor(() => expect(api.getProductAnalytics).toHaveBeenLastCalledWith(90, 'views', 1))
  fireEvent.change(screen.getByRole('combobox', { name: 'Sort products' }), { target: { value: 'value' } })
  await waitFor(() => expect(api.getProductAnalytics).toHaveBeenLastCalledWith(90, 'value', 1))
})

test('roles without either grant are denied before any request, and a failed load can be retried', async () => {
  snapshot(['portal.orders'])
  const view = render(<MemoryRouter><VendorStorePerformancePage /></MemoryRouter>)
  expect(screen.getByText(/Store Performance is available to the Owner/)).toBeInTheDocument()
  expect(api.getProductAnalytics).not.toHaveBeenCalled()
  view.unmount()

  snapshot(['catalog.manage'])
  vi.mocked(api.getProductAnalytics).mockRejectedValueOnce(new ResponseError(new Response(JSON.stringify({ errors: [{ code: 'SERVER', message: 'Analytics are unavailable.' }] }), { status: 503 }))).mockResolvedValue(overview())
  render(<MemoryRouter initialEntries={['/performance?tab=products']}><VendorStorePerformancePage /></MemoryRouter>)
  fireEvent.click(await screen.findByRole('button', { name: /Try again/ }))
  expect(await screen.findByRole('region', { name: 'Product views and orders' })).toBeInTheDocument()
})

test('a product page shows its standing, funnel, suggestions and an edit shortcut', async () => {
  snapshot(['catalog.manage'])
  const data = overview()
  vi.mocked(api.getProductAnalyticsDetail).mockResolvedValue({
    generatedAt: data.generatedAt, period: data.period, access: data.access, definitions: data.definitions, tracking: data.tracking, product: row({ segment: 'Popular and converting' }),
    kpis: { views: delta(12, 6), viewers: delta(10, 5), orders: delta(4, 2), buyers: 3, conversion: rate(3, 10), storeConversion: rate(3, 15), valueCentavos: null, products: 2 },
    series: data.series, forecast: { horizonDays: 7, views: forecast }, unusualDays: { state: 'INSUFFICIENT_DATA', days: [] }, basketRules: data.basketRules, suggestions: [],
  } as unknown as VendorProductAnalyticsDetail)
  render(<MemoryRouter initialEntries={['/performance/products/l1']}><Routes><Route path="/performance/products/:listingId" element={<VendorProductAnalyticsPage />} /></Routes></MemoryRouter>)
  expect(await screen.findByRole('heading', { name: 'Portland Cement 40kg' })).toBeInTheDocument()
  expect(api.getProductAnalyticsDetail).toHaveBeenCalledWith('l1', 30)
  expect(screen.getByText('#1 of 2 by views')).toBeInTheDocument()
  expect(screen.getByText('Segment: Popular and converting')).toBeInTheDocument()
  expect(screen.getByText(/Store average 20.00%/)).toBeInTheDocument()
  expect(screen.getByRole('link', { name: /Edit listing/ })).toHaveAttribute('href', '/products/l1')
  expect(screen.getByText('No suggestions for this product right now.')).toBeInTheDocument()
  expect(within(screen.getByRole('list', { name: 'From view to order' })).getByText('Viewers who ordered it')).toBeInTheDocument()
})

test('the My Products strip states 30-day views, orders and conversion and links to the product analytics', () => {
  render(<MemoryRouter><ProductInsightStrip listingId="l1" summary={{ listingId: 'l1', views: 12, previousViews: 6, viewsChangePercent: 100, viewers: 10, orders: 4, conversion: rate(3, 10), dailyViews: [0, 2, 10] }} /></MemoryRouter>)
  expect(screen.getByText('Last 30 days')).toBeInTheDocument()
  expect(screen.getByText('12')).toBeInTheDocument()
  expect(screen.getByText('+100.0%')).toBeInTheDocument()
  expect(screen.getByText('30.00%')).toBeInTheDocument()
  expect(screen.getByRole('link', { name: 'View product analytics' })).toHaveAttribute('href', '/performance/products/l1')
})
