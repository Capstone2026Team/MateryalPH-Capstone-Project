import { fireEvent, render, screen, within } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import { PriceTrendPanel } from '@materyalph/web-ui'
import * as api from '../lib/trust-api'
import type { VendorMaterialsAnalyticsDetail, VendorMaterialsAnalyticsList } from '../lib/trust-api'
import { useOnboardingSnapshot } from '../lib/vendor-status'
import { VendorMaterialPriceDetailsPage, VendorMaterialsAnalyticsPage, VendorStorePerformancePage } from './TrustPages'

vi.mock('../lib/trust-api', async original => ({ ...await original<typeof import('../lib/trust-api')>(), listVendorAnalytics: vi.fn(), getVendorAnalyticsDetail: vi.fn(), getStorePerformance: vi.fn(), exportVendorAnalytics: vi.fn() }))
vi.mock('../lib/vendor-status', () => ({ useOnboardingSnapshot: vi.fn() }))
vi.mock('../lib/catalog-access', async original => ({ ...await original<typeof import('../lib/catalog-access')>(), storeName: () => 'Test Supply' }))
vi.mock('./PhaseThreeVendorPages', async original => ({ ...await original<typeof import('./PhaseThreeVendorPages')>(), VendorShell: ({ children }: { children: React.ReactNode }) => <main>{children}</main> }))

const snapshot = (permissions: string[]) => vi.mocked(useOnboardingSnapshot).mockReturnValue({ snapshot: { permissions }, loading: false, error: null, refresh: vi.fn() } as unknown as ReturnType<typeof useOnboardingSnapshot>)
const group = {
  groupId: 'g1', displayName: '4-inch CHB — DemoBlock', material: { id: 'm1', name: 'Concrete hollow block' }, category: { id: 'c1', code: 'MASONRY', name: 'Masonry' },
  specification: { brand: 'DemoBlock', attributes: [{ key: 'thickness_mm', value: '100' }] }, unit: { code: 'PC', name: 'Piece' },
}
const envelope = { audience: 'VENDOR', scope: {}, sourceKind: 'PUBLIC_LISTING', dataset: { kind: 'DEMO', label: 'DEMO — Simulated Marketplace Data' }, window: { presetDays: 30, maxDays: 365, presets: [7, 30, 90] },
  currentAsOf: new Date('2026-10-04T02:00:00Z'), snapshot: { date: new Date('2026-10-04T00:00:00Z'), observedAt: new Date('2026-10-03T16:10:00Z'), revision: 1 }, updateSchedule: 'Updated daily at 00:10 Asia/Manila', explanation: 'Listed-price movement.' }
const listing = (rows: unknown[]): VendorMaterialsAnalyticsList => ({ ...envelope, items: rows }) as unknown as VendorMaterialsAnalyticsList
const suppressedRow = { ...group, startPoint: { date: new Date('2026-09-04'), status: 'SUPPRESSED', label: 'Insufficient Competitor Data' }, endPoint: { date: new Date('2026-10-04'), status: 'SUPPRESSED', label: 'Insufficient Competitor Data' },
  trend: { reason: 'INSUFFICIENT_COMPETITOR_DATA', label: 'Insufficient Competitor Data' }, currentCompetitors: { status: 'SUPPRESSED', label: 'Insufficient Competitor Data' },
  ownOffer: { listingId: 'own-listing', variantId: 'v1', displayName: 'Our CHB', priceCentavos: 8000, normalizedPhp: '80.00', taxLabel: 'Non-VAT seller', priceAsOf: new Date('2026-10-01T00:00:00Z') } }
const openList = () => render(<MemoryRouter initialEntries={['/analytics/materials']}><Routes><Route path="/analytics/materials" element={<VendorMaterialsAnalyticsPage />} /></Routes></MemoryRouter>)

beforeEach(() => { vi.clearAllMocks() })

test('every role other than Owner and Store Manager is denied before any analytics request', () => {
  for (const permissions of [['portal.orders', 'portal.disputes'], ['portal.products', 'inventory.view'], ['portal.fulfillment']]) {
    snapshot(permissions)
    const view = openList()
    expect(screen.getByText(/Owner and Store Manager only/)).toBeInTheDocument()
    view.unmount()
  }
  expect(api.listVendorAnalytics).not.toHaveBeenCalled()
})

test('a suppressed competitor row states the reason with no count and keeps the own price separate', async () => {
  snapshot(['materials_analytics.view_competitors'])
  vi.mocked(api.listVendorAnalytics).mockResolvedValue(listing([suppressedRow]))
  openList()
  const table = await screen.findByRole('table', { name: 'Masonry comparable variants' })
  expect(within(table).getAllByText('Insufficient Competitor Data').length).toBeGreaterThan(0)
  expect(within(table).queryByText(/competitors ·/)).not.toBeInTheDocument()
  expect(within(table).getByText('₱80.00')).toBeInTheDocument()
  expect(screen.getByText('DEMO — Simulated Marketplace Data')).toBeInTheDocument()
  expect(within(table).getByRole('link', { name: 'View details for 4-inch CHB — DemoBlock' })).toBeInTheDocument()
})

test('an empty published history renders an explicit null state, never an empty chart', async () => {
  snapshot(['materials_analytics.view_competitors'])
  vi.mocked(api.listVendorAnalytics).mockResolvedValue(listing([]))
  openList()
  expect(await screen.findByRole('region', { name: 'No comparable materials to show' })).toBeInTheDocument()
  expect(screen.queryByRole('img')).not.toBeInTheDocument()
})

test('details show the gap-aware graph, a synchronized sortable table, the trend text and Edit My Listing', async () => {
  snapshot(['materials_analytics.view_competitors', 'catalog.manage'])
  const series = [
    { date: new Date('2026-10-02'), status: 'OK', averagePhp: '110.00', competitorCount: 3, participantsChanged: null },
    { date: new Date('2026-10-03'), status: 'MISSING_DAY', label: 'No snapshot recorded for this date' },
    { date: new Date('2026-10-04'), status: 'OK', averagePhp: '121.00', competitorCount: 4, participantsChanged: true },
  ]
  const okRow = { ...suppressedRow, endPoint: { date: new Date('2026-10-04'), status: 'OK', averagePhp: '121.00', competitorCount: 4 }, trend: { changePercent: '10.00', direction: 'INCREASING', compositionChanged: true, startDate: new Date('2026-10-02'), endDate: new Date('2026-10-04') } }
  vi.mocked(api.getVendorAnalyticsDetail).mockResolvedValue({ ...envelope, group: okRow, variants: [group], series, canEditOwnListing: true } as unknown as VendorMaterialsAnalyticsDetail)
  render(<MemoryRouter initialEntries={['/analytics/materials/g1']}><Routes><Route path="/analytics/materials/:groupId" element={<VendorMaterialPriceDetailsPage />} /></Routes></MemoryRouter>)
  expect(await screen.findByText('+10.00% · Increasing')).toBeInTheDocument()
  expect(screen.getByRole('link', { name: /Edit My Listing/ })).toHaveAttribute('href', '/products/own-listing')
  const table = screen.getByRole('table', { name: /daily values/ })
  expect(within(table).getByText('No snapshot recorded for this date')).toBeInTheDocument()
  expect(within(table).getByText('Participants changed')).toBeInTheDocument()
  fireEvent.click(within(table).getByRole('button', { name: /Show Oct 4, 2026 on the graph/ }))
  expect(screen.getByText(/₱121.00 per Piece · 4 Vendors · Participating Vendors changed/)).toBeInTheDocument()
  fireEvent.click(within(table).getByRole('button', { name: /Average per Piece/ }))
  expect(within(table).getAllByRole('row')[1]).toHaveTextContent('₱110.00')
})

test('the graph moves between days with the keyboard and announces exact values', () => {
  render(<PriceTrendPanel title="Average" unit="bag" emptyReason="none" points={[{ date: '2026-10-01', value: '100.00', status: 'OK', count: 2 }, { date: '2026-10-02', value: null, status: 'MISSING_DAY', label: 'No snapshot' }, { date: '2026-10-03', value: '110.00', status: 'OK', count: 2 }]} />)
  const graph = screen.getByRole('img')
  fireEvent.keyDown(graph, { key: 'Home' })
  expect(screen.getByText(/₱100.00 per bag · 2 Vendors/)).toBeInTheDocument()
  fireEvent.keyDown(graph, { key: 'ArrowRight' })
  expect(screen.getByText(/No snapshot/, { selector: 'p' })).toBeInTheDocument()
})

test('Store Performance shows the sample-gate state instead of an unearned score', async () => {
  snapshot(['scores.view_store'])
  vi.mocked(api.getStorePerformance).mockResolvedValue({ calculated: true, label: 'New Vendor — Building Track Record', asOf: new Date('2026-10-04'), nextOhsRecalculationOn: new Date('2026-10-05'), history: [], badgeMetrics: [], badges: [],
    scores: [{ key: 'MQS', value: undefined, published: false, sampleCount: 4, minimumSample: 5, window: 'Rolling 90 days', statusText: 'New Vendor — Building Track Record — needs 5 eligible product ratings' }],
    operations: null, ratingComponents: {}, completedOrders: {} } as unknown as api.StorePerformance)
  render(<MemoryRouter><VendorStorePerformancePage /></MemoryRouter>)
  expect(await screen.findByText('Not published')).toBeInTheDocument()
  expect(screen.getByText('Rolling 90 days · 4 of 5 needed')).toBeInTheDocument()
  expect(screen.getByText('New Vendor — Building Track Record')).toBeInTheDocument()
})
