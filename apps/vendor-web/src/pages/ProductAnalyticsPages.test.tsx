import { act, fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import { parseDate, ResponseError } from '@materyalph/api-client-ts'
import { PortalResourceProvider } from '@materyalph/web-ui'
import * as api from '../lib/product-analytics-api'
import * as trust from '../lib/trust-api'
import * as catalog from '../lib/catalog-api'
import type { ProductAnalyticsRow, VendorProductAnalytics, VendorProductAnalyticsDetail } from '../lib/product-analytics-api'
import { useOnboardingSnapshot } from '../lib/vendor-status'
import { VendorProductAnalyticsOverviewPage, VendorProductAnalyticsPage, VendorStorePerformancePage } from './TrustPages'
import { ProductInsightStrip } from './ProductAnalyticsPages'

vi.mock('../lib/product-analytics-api', async original => ({ ...await original<typeof import('../lib/product-analytics-api')>(), getProductAnalytics: vi.fn(), getProductAnalyticsDetail: vi.fn(), getProductSummaries: vi.fn() }))
vi.mock('../lib/trust-api', async original => ({ ...await original<typeof import('../lib/trust-api')>(), getStorePerformance: vi.fn(), listReviews: vi.fn() }))
vi.mock('../lib/catalog-api', async original => ({ ...await original<typeof import('../lib/catalog-api')>(), getListing: vi.fn(), getCatalogFileUrl: vi.fn() }))
vi.mock('../lib/vendor-status', async original => ({ ...await original<typeof import('../lib/vendor-status')>(), useOnboardingSnapshot: vi.fn() }))
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
    forecast: { horizonDays: 7, views: forecast }, topSelling: [top], topPerforming: [top], mostViewed: [top, second], topRated: null,
    categories: [{ category: 'Cement', views: 12, orders: 4, valueCentavos: sales ? 480000 : null }, { category: 'Steel', views: 5, orders: 0, valueCentavos: sales ? 0 : null }],
    segments: { state: 'INSUFFICIENT_DATA', reason: 'At least four products with views or orders in the period are needed to group them.', features: [], segments: [], points: [] },
    basketRules: { baskets: 4, rules: [], windowDays: 90 },
    suggestions: [{ key: 'RESTOCK_VIEWED:l2', kind: 'RESTOCK_VIEWED', priority: 'HIGH', title: 'Restock Deformed Bar 10mm', detail: '5 Buyers viewed it in this period, but no variant has stock available to sell.', technique: 'Product views × stock status.', href: '/products/inventory', listingId: 'l2', product: 'Deformed Bar 10mm' }],
    products: { items: [top, second], meta: { page: 1, perPage: 20, total: 2, lastPage: 1, sort: 'views' } },
  } as unknown as VendorProductAnalytics
}

function productDetail(): VendorProductAnalyticsDetail {
  const data = overview()
  return {
    generatedAt: data.generatedAt, period: data.period, access: data.access, definitions: data.definitions, tracking: data.tracking, product: row({ segment: 'Popular and converting' }),
    kpis: { views: delta(12, 6), viewers: delta(10, 5), orders: delta(4, 2), buyers: 3, conversion: rate(3, 10), storeConversion: rate(3, 15), valueCentavos: null, products: 2 },
    series: data.series, forecast: { horizonDays: 7, views: forecast }, unusualDays: { state: 'INSUFFICIENT_DATA', days: [] }, basketRules: data.basketRules, suggestions: [],
  } as unknown as VendorProductAnalyticsDetail
}

function listing(): catalog.CatalogListing {
  return {
    id: 'l1', displayName: 'Portland Cement 40kg', vendorSku: 'CEM-40', status: 'ACTIVE', description: 'General construction cement for concrete and masonry.',
    brand: 'Sample Cement', material: { id: 'm1', code: 'CEMENT', name: 'Portland cement', regulated: true }, technicalAttributes: { cement_type: 'Type I' },
    media: [
      { id: 'photo1', fileId: 'file1', status: 'READY', scanState: 'CLEAN', altText: 'Portland Cement front view' },
      { id: 'photo2', fileId: 'file2', status: 'READY', scanState: 'CLEAN', altText: 'Portland Cement side view' },
      { id: 'photo3', fileId: 'file3', status: 'REMOVED', scanState: 'CLEAN' },
      { id: 'photo4', fileId: 'file4', status: 'READY', scanState: 'PENDING' },
    ], variants: [{ id: 'v1', active: true, sku: 'CEM-40-BAG', label: '40 kg bag', unitCode: 'BAG', price: { amountCentavos: 28550 }, attributes: { weight_kg: '40' } }],
  } as unknown as catalog.CatalogListing
}

beforeEach(() => {
  vi.clearAllMocks()
  vi.mocked(catalog.getListing).mockResolvedValue(listing())
  vi.mocked(catalog.getCatalogFileUrl).mockImplementation(async fileId => `https://media.example.test/${fileId}.png`)
  vi.mocked(api.getProductAnalyticsDetail).mockResolvedValue(productDetail())
})

const qualityPerformance = (published = true) => ({ calculated: true, scores: [{ key: 'MQS', value: '4.00', published, sampleCount: published ? 6 : 4, minimumSample: 5, window: 'Rolling 90 days', statusText: published ? 'Published' : 'Needs 5 eligible product ratings' }] }) as unknown as trust.StorePerformance

test.each([
  { permissions: ['catalog.manage', 'scores.view_store', 'reviews.view'], scores: true, ratings: true },
  { permissions: ['catalog.manage', 'reviews.view'], scores: false, ratings: true },
  { permissions: ['catalog.manage'], scores: false, ratings: false },
])('product quality respects independent score and review grants: $permissions', async ({ permissions, scores, ratings }) => {
  snapshot(permissions)
  const data = overview()
  data.topRated = ratings ? [{ listingId: 'l2', name: 'Deformed Bar 10mm', category: 'Steel', average: '4.80', count: 12 }] : null
  vi.mocked(api.getProductAnalytics).mockResolvedValue(data)
  vi.mocked(trust.getStorePerformance).mockResolvedValue(qualityPerformance())
  render(<PortalResourceProvider><MemoryRouter initialEntries={['/analytics/products']}><VendorProductAnalyticsOverviewPage /></MemoryRouter></PortalResourceProvider>)
  await screen.findByRole('region', { name: 'Product views and orders' })
  if (scores) {
    expect(await screen.findByRole('figure', { name: 'Material quality (MQS): 4.00 out of 5' })).toBeVisible()
    expect(screen.getByText('6 eligible ratings')).toBeVisible()
    expect(trust.getStorePerformance).toHaveBeenCalledTimes(1)
    fireEvent.click(screen.getByRole('radio', { name: '7 days' }))
    await waitFor(() => expect(api.getProductAnalytics).toHaveBeenLastCalledWith(7, 'views', 1))
    expect(trust.getStorePerformance).toHaveBeenCalledTimes(1)
  } else {
    expect(screen.queryByRole('region', { name: 'Material quality (MQS)' })).not.toBeInTheDocument()
    expect(trust.getStorePerformance).not.toHaveBeenCalled()
  }
  if (ratings) {
    const ranked = within(screen.getByRole('list', { name: 'Top-rated products' }))
    expect(ranked.getByRole('link', { name: 'Deformed Bar 10mm' })).toHaveAttribute('href', '/analytics/products/l2')
    expect(ranked.getByText('4.80 / 5')).toBeVisible()
    expect(ranked.getByText('12 ratings')).toBeVisible()
    expect(screen.getByText(/Individual product averages are separate/)).toBeVisible()
  } else expect(screen.queryByRole('region', { name: 'Top-rated products' })).not.toBeInTheDocument()
})

test('MQS can retry independently while top-rated products and analytics remain readable', async () => {
  snapshot(['catalog.manage', 'scores.view_store', 'reviews.view'])
  const data = overview()
  data.topRated = []
  vi.mocked(api.getProductAnalytics).mockResolvedValue(data)
  vi.mocked(trust.getStorePerformance).mockRejectedValueOnce(new Error('Score unavailable')).mockResolvedValue(qualityPerformance(false))
  render(<MemoryRouter><VendorProductAnalyticsOverviewPage /></MemoryRouter>)
  const quality = within(await screen.findByRole('region', { name: 'Product quality' }))
  expect(screen.getByRole('region', { name: 'Product views and orders' })).toBeVisible()
  expect(screen.getByText(/No rated products yet/)).toBeVisible()
  fireEvent.click(await quality.findByRole('button', { name: /Try again/ }))
  expect(await quality.findByRole('figure', { name: 'Material quality (MQS): not published' })).toBeVisible()
  expect(quality.getByText('4 eligible ratings')).toBeVisible()
  expect(quality.getByText('Needs 5 eligible product ratings')).toBeVisible()
  expect(quality.queryByText('4.00')).not.toBeInTheDocument()
  expect(api.getProductAnalytics).toHaveBeenCalledTimes(1)
})

test('a product manager without score access opens Product analytics directly, with no peso values and an explained panel each', async () => {
  snapshot(['catalog.manage', 'portal.products'])
  vi.mocked(api.getProductAnalytics).mockResolvedValue(overview(false))
  render(<MemoryRouter initialEntries={['/analytics/products']}><VendorProductAnalyticsOverviewPage /></MemoryRouter>)
  expect(await screen.findByRole('region', { name: 'Product views and orders' })).toBeInTheDocument()
  expect(screen.getByRole('heading', { name: 'Product Analytics', level: 1 })).toBeInTheDocument()
  expect(screen.queryByRole('tab')).not.toBeInTheDocument()
  expect(trust.getStorePerformance).not.toHaveBeenCalled()
  expect(api.getProductAnalytics).toHaveBeenCalledWith(30, 'views', 1)
  expect(screen.getByText('20.00%')).toBeInTheDocument()
  expect(screen.queryByText(/₱/)).not.toBeInTheDocument()
  const selling = screen.getByRole('list', { name: 'Top selling products' })
  expect(within(selling).getByRole('link', { name: 'Portland Cement 40kg' })).toHaveAttribute('href', '/analytics/products/l1')
  expect(within(selling).getByText('4 orders')).toBeInTheDocument()
  expect(screen.getByText('Restock Deformed Bar 10mm')).toBeInTheDocument()
  expect(screen.getByRole('link', { name: /Open inventory/ })).toHaveAttribute('href', '/products/inventory')
  expect(screen.getByText('Act now')).toBeInTheDocument()
  expect(screen.getByRole('region', { name: 'Product performance segments' })).toBeVisible()
  expect(screen.getByRole('region', { name: 'Product demand patterns' }).closest('details')).toBeNull()
  expect(screen.queryByRole('combobox', { name: 'Sort products' })).not.toBeInTheDocument()
  expect(screen.getByRole('radio', { name: 'Most viewed' })).toBeChecked()
  for (const title of ['Product views and orders', 'Top selling products', 'Top performing products', 'Most viewed products', 'Suggestions', 'Category share', 'Frequently ordered together', 'Product performance segments', 'Views by category', 'All products']) {
    const panel = screen.getByRole('region', { name: title })
    expect(within(panel).getByLabelText(`Chart details for ${title}`), title).toBeInTheDocument()
  }
  expect(screen.queryByRole('radio', { name: 'Highest sales value' })).not.toBeInTheDocument()
})

test('the Owner opens scores and product analytics separately, with peso values and working period and sort filters', async () => {
  snapshot(['scores.view_store', 'catalog.manage', 'finance.view'])
  vi.mocked(trust.getStorePerformance).mockResolvedValue({ calculated: false } as unknown as trust.StorePerformance)
  vi.mocked(api.getProductAnalytics).mockResolvedValue(overview(true))
  const scores = render(<MemoryRouter initialEntries={['/performance']}><VendorStorePerformancePage /></MemoryRouter>)
  expect(await screen.findByRole('region', { name: 'No daily calculation yet' })).toBeInTheDocument()
  expect(screen.queryByRole('tab')).not.toBeInTheDocument()
  expect(api.getProductAnalytics).not.toHaveBeenCalled()
  scores.unmount()
  render(<MemoryRouter initialEntries={['/analytics/products?page=2&sort=orders']}><VendorProductAnalyticsOverviewPage /></MemoryRouter>)
  expect((await screen.findAllByText('₱4,800.00')).length).toBeGreaterThan(0)
  expect(api.getProductAnalytics).toHaveBeenLastCalledWith(30, 'orders', 2)
  expect(screen.getByRole('radio', { name: 'Most ordered' })).toBeChecked()
  fireEvent.click(screen.getByLabelText('90 days'))
  await waitFor(() => expect(api.getProductAnalytics).toHaveBeenLastCalledWith(90, 'orders', 1))
  fireEvent.click(screen.getByRole('radio', { name: 'Highest sales value' }))
  await waitFor(() => expect(api.getProductAnalytics).toHaveBeenLastCalledWith(90, 'value', 1))
  expect(screen.getByRole('radio', { name: 'Highest sales value' })).toBeChecked()
})

test('roles without either grant are denied before any request, and a failed load can be retried', async () => {
  snapshot(['portal.orders'])
  const view = render(<MemoryRouter><VendorProductAnalyticsOverviewPage /></MemoryRouter>)
  expect(screen.getByText(/Product analytics is available to roles that manage products/)).toBeInTheDocument()
  expect(api.getProductAnalytics).not.toHaveBeenCalled()
  view.unmount()

  snapshot(['catalog.manage'])
  vi.mocked(api.getProductAnalytics).mockRejectedValueOnce(new ResponseError(new Response(JSON.stringify({ errors: [{ code: 'SERVER', message: 'Analytics are unavailable.' }] }), { status: 503 }))).mockResolvedValue(overview())
  render(<MemoryRouter initialEntries={['/analytics/products']}><VendorProductAnalyticsOverviewPage /></MemoryRouter>)
  fireEvent.click(await screen.findByRole('button', { name: /Try again/ }))
  expect(await screen.findByRole('region', { name: 'Product views and orders' })).toBeInTheDocument()
})

test('changing product sort keeps the analytics panels mounted and returning to most viewed restores its rows', async () => {
  snapshot(['catalog.manage', 'finance.view'])
  let resolveOrders!: (value: VendorProductAnalytics) => void
  vi.mocked(api.getProductAnalytics).mockImplementation(async (_period, sort) => sort === 'orders'
    ? new Promise(resolve => { resolveOrders = resolve }) : overview(true))
  render(<PortalResourceProvider><MemoryRouter initialEntries={['/analytics/products']}><VendorProductAnalyticsOverviewPage /></MemoryRouter></PortalResourceProvider>)
  const panel = await screen.findByRole('region', { name: 'All products' })
  const chart = screen.getByRole('region', { name: 'Product views and orders' })
  const summary = screen.getByRole('region', { name: 'At a glance' })
  fireEvent.click(within(panel).getByRole('radio', { name: 'Most ordered' }))
  await waitFor(() => expect(api.getProductAnalytics).toHaveBeenLastCalledWith(30, 'orders', 1))
  expect(within(panel).getByText('Loading products…')).toBeVisible()
  expect(within(panel).getByRole('radio', { name: 'Most ordered' })).toBeChecked()
  expect(screen.getByRole('region', { name: 'Product views and orders' })).toBe(chart)
  expect(screen.getByRole('region', { name: 'At a glance' })).toBe(summary)
  expect(screen.queryByText('Loading product analytics…')).not.toBeInTheDocument()
  const ordered = overview(true)
  ordered.products.items.reverse()
  ordered.products.meta.sort = 'orders'
  await act(async () => resolveOrders(ordered))
  expect(within(within(panel).getByRole('table', { name: 'Product measures' })).getAllByRole('row')[1]).toHaveTextContent('Deformed Bar 10mm')
  fireEvent.click(within(panel).getByRole('radio', { name: 'Most viewed' }))
  expect(screen.getByRole('region', { name: 'All products' })).toBe(panel)
  expect(within(within(panel).getByRole('table', { name: 'Product measures' })).getAllByRole('row')[1]).toHaveTextContent('Portland Cement 40kg')
  expect(api.getProductAnalytics).toHaveBeenCalledTimes(2)
})

test('a slower earlier sort cannot replace the selected product order', async () => {
  snapshot(['catalog.manage'])
  let resolveOrders!: (value: VendorProductAnalytics) => void
  const conversion = overview()
  conversion.products.items.reverse()
  conversion.products.meta.sort = 'conversion'
  vi.mocked(api.getProductAnalytics).mockImplementation(async (_period, sort) => {
    if (sort === 'orders') return new Promise(resolve => { resolveOrders = resolve })
    return sort === 'conversion' ? conversion : overview()
  })
  render(<PortalResourceProvider><MemoryRouter initialEntries={['/analytics/products']}><VendorProductAnalyticsOverviewPage /></MemoryRouter></PortalResourceProvider>)
  const panel = await screen.findByRole('region', { name: 'All products' })
  fireEvent.click(within(panel).getByRole('radio', { name: 'Most ordered' }))
  await waitFor(() => expect(api.getProductAnalytics).toHaveBeenLastCalledWith(30, 'orders', 1))
  fireEvent.click(within(panel).getByRole('radio', { name: 'Best conversion' }))
  await waitFor(() => expect(within(panel).queryByText('Loading products…')).not.toBeInTheDocument())
  await act(async () => resolveOrders(overview()))
  expect(within(panel).getByRole('radio', { name: 'Best conversion' })).toBeChecked()
  expect(within(within(panel).getByRole('table', { name: 'Product measures' })).getAllByRole('row')[1]).toHaveTextContent('Deformed Bar 10mm')
})

test('a failed product sort retries inside its panel while the charts stay open', async () => {
  snapshot(['catalog.manage'])
  vi.mocked(api.getProductAnalytics).mockResolvedValueOnce(overview())
    .mockRejectedValueOnce(new TypeError('Failed to fetch')).mockResolvedValue(overview())
  render(<PortalResourceProvider><MemoryRouter initialEntries={['/analytics/products']}><VendorProductAnalyticsOverviewPage /></MemoryRouter></PortalResourceProvider>)
  const panel = await screen.findByRole('region', { name: 'All products' })
  const chart = screen.getByRole('region', { name: 'Product views and orders' })
  fireEvent.click(within(panel).getByRole('radio', { name: 'Most ordered' }))
  fireEvent.click(await within(panel).findByRole('button', { name: /Try again/ }))
  expect(await within(panel).findByRole('table', { name: 'Product measures' })).toBeVisible()
  expect(screen.getByRole('region', { name: 'Product views and orders' })).toBe(chart)
  expect(api.getProductAnalytics).toHaveBeenLastCalledWith(30, 'orders', 1)
})

test('product pagination stays within its panel and changing the sort returns to page one', async () => {
  snapshot(['catalog.manage'])
  vi.mocked(api.getProductAnalytics).mockImplementation(async (_period, sort = 'views', page = 1) => {
    const data = overview()
    data.products.meta = { ...data.products.meta, sort, page, total: 22, lastPage: 2 }
    return data
  })
  render(<PortalResourceProvider><MemoryRouter initialEntries={['/analytics/products']}><VendorProductAnalyticsOverviewPage /></MemoryRouter></PortalResourceProvider>)
  const panel = await screen.findByRole('region', { name: 'All products' })
  const chart = screen.getByRole('region', { name: 'Product views and orders' })
  fireEvent.click(within(panel).getByRole('button', { name: 'Next' }))
  await waitFor(() => expect(api.getProductAnalytics).toHaveBeenLastCalledWith(30, 'views', 2))
  fireEvent.click(within(panel).getByRole('radio', { name: 'Most ordered' }))
  await waitFor(() => expect(api.getProductAnalytics).toHaveBeenLastCalledWith(30, 'orders', 1))
  expect(screen.getByRole('region', { name: 'Product views and orders' })).toBe(chart)
})

test.each([false, true])('Vendor product summary keeps unavailable-comparison indicators (sales access %s)', async sales => {
  snapshot(['catalog.manage', ...(sales ? ['finance.view'] : [])])
  const data = overview(sales)
  data.kpis.views = delta(17, 0)
  data.kpis.orders = delta(4, 0)
  if (sales) data.kpis.valueCentavos = delta(480000, 0)
  vi.mocked(api.getProductAnalytics).mockResolvedValue(data)
  render(<MemoryRouter><VendorProductAnalyticsOverviewPage /></MemoryRouter>)
  const summary = within(await screen.findByRole('region', { name: 'At a glance' }))
  expect(summary.getAllByText('No comparison')).toHaveLength(2)
  expect(summary.getByText(sales ? 'No sales in previous 30 days' : 'No views in previous 30 days')).toBeVisible()
  expect(summary.getByText('No orders in previous 30 days')).toBeVisible()
  if (!sales) expect(summary.queryByText(/₱/)).not.toBeInTheDocument()
})

test('a product page shows its standing, funnel, suggestions and an edit shortcut', async () => {
  snapshot(['catalog.manage'])
  render(<MemoryRouter initialEntries={['/analytics/products/l1']}><Routes><Route path="/analytics/products/:listingId" element={<VendorProductAnalyticsPage />} /></Routes></MemoryRouter>)
  expect(await screen.findByRole('heading', { name: 'Portland Cement 40kg' })).toBeInTheDocument()
  expect(api.getProductAnalyticsDetail).toHaveBeenCalledWith('l1', 30)
  expect(screen.getByText('#1 of 2 by views')).toBeInTheDocument()
  expect(screen.getByText('Segment: Popular and converting')).toBeInTheDocument()
  expect(screen.getByText(/Store average 20.00%/)).toBeInTheDocument()
  expect(screen.getByRole('link', { name: /Edit listing/ })).toHaveAttribute('href', '/products/l1')
  fireEvent.click(screen.getByText('More product insights', { exact: true }))
  expect(screen.getByText('No suggestions for this product right now.')).toBeInTheDocument()
  expect(within(screen.getByRole('list', { name: 'From view to order' })).getByText('Viewers who ordered it')).toBeInTheDocument()
})

test('the gallery and product details stay on the left while the analytics period preserves the selected photo', async () => {
  snapshot(['catalog.manage'])
  render(<MemoryRouter initialEntries={['/analytics/products/l1']}><Routes><Route path="/analytics/products/:listingId" element={<VendorProductAnalyticsPage />} /></Routes></MemoryRouter>)
  const information = within(await screen.findByRole('region', { name: 'Product information' }))
  expect(await information.findByRole('img', { name: 'Portland Cement front view' })).toHaveAttribute('src', 'https://media.example.test/file1.png')
  expect(information.getByText('General construction cement for concrete and masonry.')).toBeVisible()
  expect(information.getByText('Sample Cement')).toBeVisible()
  expect(information.getByText('₱285.50 / bag')).toBeVisible()
  expect(catalog.getCatalogFileUrl).toHaveBeenCalledTimes(2)
  expect(catalog.getCatalogFileUrl).not.toHaveBeenCalledWith('file3')
  expect(catalog.getCatalogFileUrl).not.toHaveBeenCalledWith('file4')
  const second = information.getByRole('button', { name: 'View product photo 2 of 2' })
  fireEvent.click(second)
  expect(information.getByRole('img', { name: 'Portland Cement side view' })).toHaveAttribute('src', 'https://media.example.test/file2.png')
  const analytics = within(screen.getByRole('region', { name: 'Product analytics and reviews' }))
  expect(analytics.getByRole('region', { name: 'Product views and orders' })).toBeVisible()
  expect(analytics.queryByText('Product sales value')).not.toBeInTheDocument()
  fireEvent.click(analytics.getByRole('radio', { name: '7 days' }))
  await waitFor(() => expect(api.getProductAnalyticsDetail).toHaveBeenLastCalledWith('l1', 7))
  await analytics.findByRole('region', { name: 'Product views and orders' })
  expect(information.getByRole('button', { name: 'View product photo 2 of 2' })).toHaveAttribute('aria-pressed', 'true')
  expect(catalog.getListing).toHaveBeenCalledTimes(1)
})

test('a failed photo URL can be refreshed without blocking analytics or the saved product details', async () => {
  snapshot(['catalog.manage'])
  vi.mocked(catalog.getCatalogFileUrl).mockRejectedValueOnce(new Error('Expired photo link.'))
  render(<MemoryRouter initialEntries={['/analytics/products/l1']}><Routes><Route path="/analytics/products/:listingId" element={<VendorProductAnalyticsPage />} /></Routes></MemoryRouter>)
  expect(await screen.findByText('This product photo is unavailable.')).toBeVisible()
  expect(screen.getByText('General construction cement for concrete and masonry.')).toBeVisible()
  expect(screen.getByRole('region', { name: 'Product views and orders' })).toBeVisible()
  fireEvent.click(screen.getByRole('button', { name: 'Retry photos' }))
  expect(await screen.findByRole('img', { name: 'Portland Cement front view' })).toBeVisible()
  expect(api.getProductAnalyticsDetail).toHaveBeenCalledTimes(1)
})

test('unavailable catalog details recover independently while analytics remain readable', async () => {
  snapshot(['catalog.manage'])
  vi.mocked(catalog.getListing).mockRejectedValueOnce(new Error('Product details unavailable.'))
  render(<MemoryRouter initialEntries={['/analytics/products/l1']}><Routes><Route path="/analytics/products/:listingId" element={<VendorProductAnalyticsPage />} /></Routes></MemoryRouter>)
  const information = within(await screen.findByRole('region', { name: 'Product information' }))
  fireEvent.click(await information.findByRole('button', { name: /Try again/ }))
  expect(await information.findByRole('img', { name: 'Portland Cement front view' })).toBeVisible()
  expect(screen.getByRole('region', { name: 'Product views and orders' })).toBeVisible()
  expect(api.getProductAnalyticsDetail).toHaveBeenCalledTimes(1)
})

test('reviews in the analytics panel retain their listing filter and independent pagination', async () => {
  snapshot(['catalog.manage', 'reviews.view'])
  vi.mocked(trust.listReviews).mockResolvedValue({ items: [{ id: 'r1', type: 'PRODUCT', displayName: 'Alex Reyes', ratings: { productQuality: 4 }, media: [], product: { listingId: 'l1', name: 'Portland Cement 40kg', variantLabel: '40 kg' } }], meta: { total: 24, page: 1, perPage: 20, summary: { count: 24, average: 4, distribution: [5, 4, 3, 2, 1].map(stars => ({ stars, count: stars === 4 ? 24 : 0 })) } } })
  render(<MemoryRouter initialEntries={['/analytics/products/l1?days=7&reviews_page=2']}><Routes><Route path="/analytics/products/:listingId" element={<VendorProductAnalyticsPage />} /></Routes></MemoryRouter>)
  const analytics = within(await screen.findByRole('region', { name: 'Product analytics and reviews' }))
  expect(await analytics.findByText('Alex Reyes')).toBeVisible()
  expect(trust.listReviews).toHaveBeenCalledWith('PRODUCT', 2, { listingId: 'l1' })
  fireEvent.click(analytics.getByRole('button', { name: /Previous/ }))
  await waitFor(() => expect(trust.listReviews).toHaveBeenLastCalledWith('PRODUCT', 1, { listingId: 'l1' }))
  expect(api.getProductAnalyticsDetail).toHaveBeenLastCalledWith('l1', 7)
})

test('the My Products strip states 30-day views, orders and conversion without a separate analytics link', () => {
  render(<MemoryRouter><ProductInsightStrip summary={{ listingId: 'l1', views: 12, previousViews: 6, viewsChangePercent: 100, viewers: 10, orders: 4, conversion: rate(3, 10), dailyViews: [0, 2, 10] }} /></MemoryRouter>)
  expect(screen.getByText('Last 30 days')).toBeInTheDocument()
  expect(screen.getByText('12')).toBeInTheDocument()
  expect(screen.getByText('+100.0%')).toBeInTheDocument()
  expect(screen.getByText('30.00%')).toBeInTheDocument()
  expect(screen.queryByRole('link')).not.toBeInTheDocument()
})

test('Return restores the catalog entry context and rejects external return destinations', async () => {
  snapshot(['catalog.manage'])
  const view = render(<MemoryRouter initialEntries={[{ pathname: '/analytics/products/l1', state: { returnTo: '/products?q=cement&status=ACTIVE&page=2' } }]}><Routes>
    <Route path="/analytics/products/:listingId" element={<VendorProductAnalyticsPage />} />
    <Route path="/products" element={<h1>Filtered catalog</h1>} />
  </Routes></MemoryRouter>)
  await screen.findByRole('heading', { name: 'Portland Cement 40kg' })
  expect(screen.queryByRole('link', { name: 'My Products' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Return' }))
  expect(await screen.findByRole('heading', { name: 'Filtered catalog' })).toBeInTheDocument()
  view.unmount()
  render(<MemoryRouter initialEntries={[{ pathname: '/analytics/products/l1', search: '?days=7', state: { returnTo: 'https://example.test' } }]}><Routes>
    <Route path="/analytics/products/:listingId" element={<VendorProductAnalyticsPage />} />
    <Route path="/analytics/products" element={<h1>Product analytics overview</h1>} />
  </Routes></MemoryRouter>)
  await screen.findByRole('heading', { name: 'Portland Cement 40kg' })
  fireEvent.click(screen.getByRole('button', { name: 'Return' }))
  expect(await screen.findByRole('heading', { name: 'Product analytics overview' })).toBeInTheDocument()
})

test('the former Store Performance product tab redirects to the standalone page and retains filters', async () => {
  snapshot(['catalog.manage'])
  vi.mocked(api.getProductAnalytics).mockResolvedValue(overview())
  render(<MemoryRouter initialEntries={['/performance?tab=products&days=90&sort=orders&page=2']}><Routes>
    <Route path="/performance" element={<VendorStorePerformancePage />} />
    <Route path="/analytics/products" element={<VendorProductAnalyticsOverviewPage />} />
  </Routes></MemoryRouter>)
  expect(await screen.findByRole('heading', { name: 'Product Analytics', level: 1 })).toBeInTheDocument()
  expect(api.getProductAnalytics).toHaveBeenCalledWith(90, 'orders', 2)
  expect(trust.getStorePerformance).not.toHaveBeenCalled()
})
