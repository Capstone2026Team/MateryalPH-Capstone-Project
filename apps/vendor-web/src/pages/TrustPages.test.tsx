import { fireEvent, render, screen, within } from '@testing-library/react'
import { MemoryRouter } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import { PriceTrendPanel } from '@materyalph/web-ui'
import * as api from '../lib/trust-api'
import { useOnboardingSnapshot } from '../lib/vendor-status'
import { VendorStorePerformancePage } from './TrustPages'
import { getVendorDashboardInsights, type VendorDashboardInsights } from '../lib/dashboard-api'

vi.mock('../lib/trust-api', async original => ({ ...await original<typeof import('../lib/trust-api')>(), getStorePerformance: vi.fn() }))
vi.mock('../lib/vendor-status', () => ({ useOnboardingSnapshot: vi.fn() }))
vi.mock('../lib/dashboard-api', () => ({ getVendorDashboardInsights: vi.fn() }))
vi.mock('../lib/catalog-access', async original => ({ ...await original<typeof import('../lib/catalog-access')>(), storeName: () => 'Test Supply' }))
vi.mock('./PhaseThreeVendorPages', async original => ({ ...await original<typeof import('./PhaseThreeVendorPages')>(), VendorShell: ({ children }: { children: React.ReactNode }) => <main>{children}</main> }))

const snapshot = (permissions: string[]) => vi.mocked(useOnboardingSnapshot).mockReturnValue({ snapshot: { permissions }, loading: false, error: null, refresh: vi.fn() } as unknown as ReturnType<typeof useOnboardingSnapshot>)
const performance = (): api.StorePerformance => ({ calculated: true, label: 'VPS 4.10 of 5', asOf: new Date('2026-11-05'), nextOhsRecalculationOn: new Date('2026-11-09'), history: [], badgeMetrics: [], badges: [],
  scores: (['VPS', 'VCS', 'MQS', 'OHS'] as const).map(key => ({ key, value: key === 'OHS' ? '3.90' : '4.30', published: true, sampleCount: 12, minimumSample: key === 'OHS' ? 10 : 5, window: 'Rolling 90 days', statusText: 'Published' })), ratingComponents: { service_quality: '4.20', speed: '4.40' }, completedOrders: { last_90_days: 12, total: 15 } })
const signals = (orders = true): VendorDashboardInsights => ({ access: { orders }, orders: orders ? { kpis: { fulfillmentRate: { percent: '100.00', numerator: 13, denominator: 13 }, cancellationRate: { percent: '13.33', numerator: 2, denominator: 15 }, disputeRate: { percent: '13.33', numerator: 2, denominator: 15 }, responseTime: { meanSeconds: 3480, medianSeconds: 120, p90Seconds: 10800, answered: 15, unanswered: 0 } } } : null,
  performance: { asOf: new Date('2026-11-05'), classification: { _class: 'BELOW_WATCH_LEVEL', label: 'Below workflow watch level', path: ['Published VPS is below 3.00.', 'Published OHS is below 2.50.'] } } } as VendorDashboardInsights)
beforeEach(() => { vi.clearAllMocks(); vi.mocked(getVendorDashboardInsights).mockResolvedValue(signals()) })

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
  expect((await screen.findAllByText('Not yet published')).length).toBeGreaterThan(0)
  expect(screen.getByRole('meter', { name: 'MQS sample' })).toHaveAttribute('aria-valuetext', '4 of 5')
  expect(screen.getByText('4 of 5 needed')).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'How this is calculated: Vendor performance (VPS)' }))
  expect(screen.getByText(/Rolling 90 days · 4 eligible samples · 5 minimum/)).toBeVisible()
  fireEvent.keyDown(document, { key: 'Escape' })
  expect(screen.getByText('New Vendor — Building Track Record')).toBeInTheDocument()
  expect(screen.getByRole('button', { name: 'How this is calculated: Material quality (MQS)' })).toBeInTheDocument()
  expect(screen.queryByRole('tab', { name: 'Product analytics' })).not.toBeInTheDocument()
})

test('product managers without the score grant cannot open Store Performance', () => {
  snapshot(['catalog.manage', 'portal.performance'])
  render(<MemoryRouter><VendorStorePerformancePage /></MemoryRouter>)
  expect(screen.getByText('Store Performance is available to the Owner and Store Manager only.')).toBeInTheDocument()
  expect(api.getStorePerformance).not.toHaveBeenCalled()
  expect(getVendorDashboardInsights).not.toHaveBeenCalled()
})

test('shows published ratings, server health and operational cards with distinct definitions', async () => {
  snapshot(['scores.view_store', 'orders.confirm'])
  vi.mocked(api.getStorePerformance).mockResolvedValue(performance())
  render(<MemoryRouter><VendorStorePerformancePage /></MemoryRouter>)
  expect(await screen.findByRole('figure', { name: 'Community rating (VCS): 4.30 out of 5' })).toBeVisible()
  expect(screen.getByRole('figure', { name: 'Material quality (MQS): 4.30 out of 5' })).toBeVisible()
  expect(screen.getByRole('figure', { name: 'Operational health (OHS): 3.90 out of 5' })).toBeVisible()
  expect(screen.getByText('12 eligible orders')).toBeVisible()
  const standing = screen.getByRole('region', { name: 'Public standing' })
  expect(standing.querySelector('svg.lucide-star')).toBeInTheDocument()
  expect(within(standing).getByRole('heading', { name: 'Vendor performance (VPS)' })).toBeVisible()
  expect(standing.querySelector('[data-score-key="VCS"]')).toHaveTextContent('4.30 / 5')
  expect(standing.querySelector('[data-score-key="OHS"]')).toHaveTextContent('3.90 / 5')
  expect(screen.getByText('Below workflow watch level')).toBeVisible()
  expect(screen.getByText('Published OHS is below 2.50.')).toBeVisible()
  expect(screen.getByText('58 min')).toBeVisible()
  expect(screen.getByText('Median 2 min · 90th percentile 3.0 h')).toBeVisible()
  expect(getVendorDashboardInsights).toHaveBeenCalledWith(30)
  fireEvent.click(screen.getByRole('button', { name: 'How this is calculated: Cancelled orders' }))
  expect(screen.getByRole('dialog')).toHaveTextContent('separate from the Vendor-caused Non-Fulfillment Rate')
  fireEvent.keyDown(document, { key: 'Escape' })
  expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
})

test('distinguishes on-time fulfillment from completion and places history beside the operational cards', async () => {
  snapshot(['scores.view_store', 'orders.confirm'])
  const data = performance()
  data.badgeMetrics = [{ key: 'FRR', value: '50.00', sampleCount: 6, window: 'Trailing 90 days', definition: 'On or before the confirmed date' }]
  vi.mocked(api.getStorePerformance).mockResolvedValue(data)
  render(<MemoryRouter><VendorStorePerformancePage /></MemoryRouter>)
  expect(await screen.findByText('On-time fulfillment (FRR)')).toBeVisible()
  expect(screen.getByText('Trailing 90 days · 6 fulfilled orders')).toBeVisible()
  const metrics = screen.getByRole('region', { name: 'Operational performance' })
  for (const label of ['Order completion rate', 'Cancelled orders', 'Orders with disputes', 'Average order decision time']) expect(within(metrics).getByText(label)).toBeVisible()
  expect(within(metrics).getByText('All causes · Buyer and Vendor')).toBeVisible()
  expect(within(metrics).getByText('First human decision on an order request')).toBeVisible()
  expect(screen.queryByText('Fulfillment rate')).not.toBeInTheDocument()
  expect(screen.queryByText('Fulfillment Reliability Rate (FRR)')).not.toBeInTheDocument()
  const history = screen.getByRole('region', { name: 'Score history' })
  expect(metrics.closest('.mp-performance-operations')).toContainElement(history)
  expect(history.compareDocumentPosition(screen.getByRole('region', { name: 'Community rating (VCS)' })) & Node.DOCUMENT_POSITION_FOLLOWING).toBeTruthy()
  fireEvent.click(within(metrics).getByRole('button', { name: 'How this is calculated: Order completion rate' }))
  expect(screen.getByRole('dialog')).toHaveTextContent('Completion by period end is separate from On-time fulfillment (FRR)')
})

test('OHS lists its operational components inside the score card and all page sections stay open', async () => {
  snapshot(['scores.view_store', 'orders.confirm'])
  const data = performance()
  data.operations = { rates: { NFR: '28.57', LSR: '16.67', RR: '0.00', ODR: '14.29' }, penalties: { NFR: '1.50', LSR: '1.25', RR: '0.00', ODR: '1.25', LVD: '0.00' }, numerators: { NFR: 2, LSR: 1, RR: 0, ODR: 1 }, denominators: { NFR: 7, LSR: 6, RR: 5, ODR: 7 }, listing_violations: 0 }
  data.history = [{ date: new Date('2026-11-04'), vps: '4.30' }, { date: new Date('2026-11-05'), vps: '4.30' }]
  data.badgeMetrics = [{ key: 'CRR', value: '80.00', sampleCount: 5, window: 'Trailing 30 days', definition: 'Human replies within 12 hours' }]
  vi.mocked(api.getStorePerformance).mockResolvedValue(data)
  render(<MemoryRouter><VendorStorePerformancePage /></MemoryRouter>)
  const ohs = await screen.findByRole('region', { name: 'Operational health (OHS)' })
  for (const name of ['Non-Fulfillment Rate (NFR)', 'Late Shipment Rate (LSR)', 'Return Rate (RR)', 'Order Defect Rate (ODR)', 'Listing Violation Deduction (LVD)']) expect(within(ohs).getByText(name)).toBeVisible()
  expect(within(ohs).getByText('28.57%')).toBeVisible()
  expect(within(ohs).getByText('2 of 7 · Penalty −1.50')).toBeVisible()
  expect(within(ohs).getByText('0 of 5 · Penalty None')).toBeVisible()
  expect(screen.queryByRole('table', { name: 'Published score history' })).not.toBeInTheDocument()
  expect(screen.getByText('Customer Response Rate (CRR)')).toBeVisible()
  expect(document.querySelector('[data-store-performance]')?.querySelector('details, summary, select, [aria-haspopup="menu"]')).toBeNull()
  const metrics = screen.getByRole('region', { name: 'Operational performance' })
  expect(metrics.compareDocumentPosition(ohs) & Node.DOCUMENT_POSITION_FOLLOWING).toBeTruthy()
  fireEvent.click(within(ohs).getByRole('button', { name: 'How this is calculated: Operational health (OHS)' }))
  expect(screen.getByRole('dialog')).toHaveTextContent('Bands: No penalty to 2%')
  expect(screen.getByRole('dialog')).toHaveTextContent('0.10 for one violation')
})

test('the VPS component bars do not publish an ineligible component even if it carries a value', async () => {
  snapshot(['scores.view_store'])
  const data = performance()
  Object.assign(data.scores.find(score => score.key === 'OHS')!, { published: false, value: '4.99', statusText: 'Needs 10 eligible orders' })
  vi.mocked(api.getStorePerformance).mockResolvedValue(data)
  render(<MemoryRouter><VendorStorePerformancePage /></MemoryRouter>)
  const standing = await screen.findByRole('region', { name: 'Public standing' })
  const ohs = standing.querySelector('[data-score-key="OHS"]')!
  expect(ohs).toHaveTextContent('Not published')
  expect(ohs).toHaveTextContent('Needs 10 eligible orders')
  expect(ohs).not.toHaveTextContent('4.99')
  const healthCard = screen.getByRole('region', { name: 'Operational health (OHS)' })
  expect(within(healthCard).getByRole('figure', { name: 'Operational health (OHS): not published' })).toBeVisible()
  expect(healthCard).not.toHaveTextContent('4.99')
  expect(healthCard.querySelector('.mp-review-ring-value')).toBeNull()
})

test('score summaries keep exact values and show criterion graphics with a neutral missing material score', async () => {
  snapshot(['scores.view_store'])
  const data = performance()
  Object.assign(data.scores.find(score => score.key === 'MQS')!, { published: false, value: '4.99', sampleCount: 4, statusText: 'Needs 5 eligible product ratings' })
  vi.mocked(api.getStorePerformance).mockResolvedValue(data)
  render(<MemoryRouter><VendorStorePerformancePage /></MemoryRouter>)
  const community = await screen.findByRole('region', { name: 'Community rating (VCS)' })
  expect(within(community).getByRole('figure', { name: 'Community rating (VCS): 4.30 out of 5' })).toBeVisible()
  expect(within(community).getByText('4.20')).toBeVisible()
  expect(within(community).getByText('4.40')).toBeVisible()
  const material = screen.getByRole('region', { name: 'Material quality (MQS)' })
  expect(within(material).getByRole('figure', { name: 'Material quality (MQS): not published' })).toBeVisible()
  expect(material).not.toHaveTextContent('4.99')
  expect(within(material).getByRole('meter', { name: 'MQS sample' })).toHaveAttribute('aria-valuetext', '4 of 5')
  expect(material.querySelector('.mp-performance-criterion-track > span')).toHaveStyle({ width: '0%' })
  expect(community.querySelectorAll('.mp-performance-criterion-icon')).toHaveLength(3)
  expect(within(community).getByText('Rating breakdown')).toBeVisible()
})

test('badge graphics preserve statuses and the earned count while response graphics distinguish zero from missing', async () => {
  snapshot(['scores.view_store'])
  const data = performance()
  data.badges = [
    { code: 'FAST_RESPONDER', name: 'Fast Responder', status: 'EARNED', description: 'Human responses follow the workflow threshold.', scopes: [] },
    { code: 'ON_TIME', name: 'On-Time', status: 'NOT_EARNED', description: 'On-time fulfillment follows the workflow threshold.', scopes: [] },
    { code: 'TRUSTED_SUPPLIER', name: 'Trusted Supplier', status: 'SUPPRESSED', description: 'Trust follows the published requirements.', scopes: [] },
  ]
  data.badgeMetrics = [
    { key: 'CRR', value: '0.00', sampleCount: 5, window: 'Trailing 30 days', definition: 'Human replies within 12 hours' },
    { key: 'FRR', sampleCount: 0, window: 'Trailing 90 days', definition: 'On-time fulfillment' },
  ]
  vi.mocked(api.getStorePerformance).mockResolvedValue(data)
  render(<MemoryRouter><VendorStorePerformancePage /></MemoryRouter>)
  const badges = await screen.findByRole('region', { name: 'Badges' })
  expect(badges).toHaveTextContent('1 of 3 earned')
  expect(within(badges).getByText('Earned', { exact: true })).toBeVisible()
  expect(within(badges).getByText('Not earned', { exact: true })).toBeVisible()
  expect(within(badges).getByText('Suppressed by review')).toBeVisible()
  expect(within(badges).queryByRole('button')).not.toBeInTheDocument()
  const metrics = screen.getByRole('region', { name: 'Badge metrics' })
  expect(within(metrics).getByText('0.00%')).toBeVisible()
  expect(within(metrics).getByText('—')).toBeVisible()
  expect(within(metrics).getByText('Trailing 90 days · 0 fulfilled orders')).toBeVisible()
})

test('keeps scores visible when supplemental metrics fail and retries that request independently', async () => {
  snapshot(['scores.view_store'])
  vi.mocked(api.getStorePerformance).mockResolvedValue(performance())
  vi.mocked(getVendorDashboardInsights).mockRejectedValueOnce(new Error('Connection unavailable')).mockResolvedValueOnce(signals())
  render(<MemoryRouter><VendorStorePerformancePage /></MemoryRouter>)
  expect(await screen.findByRole('figure', { name: 'Community rating (VCS): 4.30 out of 5' })).toBeVisible()
  const retry = await screen.findAllByRole('button', { name: 'Retry health and metrics' })
  fireEvent.click(retry[0]!)
  expect(await screen.findByText('58 min')).toBeVisible()
  expect(api.getStorePerformance).toHaveBeenCalledTimes(1)
})

test('omits order measures when the API withholds the section and never treats no data as zero', async () => {
  snapshot(['scores.view_store'])
  vi.mocked(api.getStorePerformance).mockResolvedValue(performance())
  vi.mocked(getVendorDashboardInsights).mockResolvedValue(signals(false))
  render(<MemoryRouter><VendorStorePerformancePage /></MemoryRouter>)
  expect(await screen.findByText('Below workflow watch level')).toBeVisible()
  expect(screen.queryByRole('region', { name: 'Operational performance' })).not.toBeInTheDocument()
})

test('empty operational denominators show unavailable values and first calculation keeps its explanation', async () => {
  snapshot(['scores.view_store'])
  vi.mocked(api.getStorePerformance).mockResolvedValue({ ...performance(), calculated: false, label: 'New Vendor — Building Track Record', scores: [] })
  const data = signals()
  for (const rate of [data.orders!.kpis.fulfillmentRate, data.orders!.kpis.cancellationRate, data.orders!.kpis.disputeRate]) Object.assign(rate, { percent: null, numerator: 0, denominator: 0 })
  Object.assign(data.orders!.kpis.responseTime, { meanSeconds: null, medianSeconds: null, p90Seconds: null, answered: 0 })
  vi.mocked(getVendorDashboardInsights).mockResolvedValue(data)
  render(<MemoryRouter><VendorStorePerformancePage /></MemoryRouter>)
  expect(await screen.findByText('No daily calculation yet')).toBeVisible()
  expect(screen.getByText('No orders due in this period.')).toBeVisible()
  const metrics = screen.getByRole('region', { name: 'Operational performance' })
  expect(within(metrics).getAllByText('—')).toHaveLength(4)
  expect(within(metrics).queryByText('0.00%')).not.toBeInTheDocument()
})
