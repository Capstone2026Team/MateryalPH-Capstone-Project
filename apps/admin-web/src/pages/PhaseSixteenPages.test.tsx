import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter, Route, Routes, useLocation } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import { ResponseError, parseDate } from '@materyalph/api-client-ts'
import * as operations from '../lib/operations-api'
import * as geo from '../lib/geo-analytics-api'
import { AdminPlatformSettingsPage } from './PlatformSettingsPage'
import { AdminEnforcementDetailPage } from './EnforcementPages'
import { AdminAuditSearchPage } from './AuditSearchPage'
import { AdminIntegrationHealthPage } from './IntegrationHealthPages'
import { AdminGeoAnalyticsPage } from './GeoAnalyticsPage'

vi.mock('../lib/operations-api', async original => ({ ...await original<typeof import('../lib/operations-api')>(), listSettings: vi.fn(), settingHistory: vi.fn(), updateSetting: vi.fn(),
  getEnforcement: vi.fn(), applyEnforcement: vi.fn(), declineEnforcement: vi.fn(), liftEnforcement: vi.fn(), searchAudit: vi.fn(), getAudit: vi.fn(), auditActions: vi.fn(),
  integrationOverview: vi.fn(), operationFailures: vi.fn(), operationRetries: vi.fn(), retryOperation: vi.fn(), requestExport: vi.fn() }))
vi.mock('../lib/geo-analytics-api', async original => ({ ...await original<typeof import('../lib/geo-analytics-api')>(), getGeoDashboard: vi.fn(), getGeoDemand: vi.fn(), getGeoBoundaries: vi.fn() }))
vi.mock('../lib/finance-api', async original => ({ ...await original<typeof import('../lib/finance-api')>(), financeKpis: vi.fn() }))
vi.mock('../lib/trust-api', async original => ({ ...await original<typeof import('../lib/trust-api')>(), listAdminAnalytics: vi.fn(() => new Promise(() => undefined)), listRuns: vi.fn(() => new Promise(() => undefined)) }))
vi.mock('./PhaseThreeAdminPages', async original => ({ ...await original<typeof import('./PhaseThreeAdminPages')>(), AdminShell: ({ children }: { children: React.ReactNode }) => <main>{children}</main> }))

const problem = (status: number, code: string, message: string, details: Record<string, unknown> = {}) =>
  new ResponseError(new Response(JSON.stringify({ data: null, meta: { correlation_id: 'corr-123' }, errors: [{ code, message, details }] }), { status, headers: { 'Content-Type': 'application/json' } }), message)
const at = (path: string, element: React.ReactNode, pattern = path.split('?')[0] ?? path) => render(<MemoryRouter initialEntries={[path]}><Routes><Route path={pattern} element={<>{element}<LocationProbe /></>} /></Routes></MemoryRouter>)
function LocationProbe() { const location = useLocation(); return <output data-testid="location">{location.search}</output> }

beforeEach(() => vi.clearAllMocks())

const weights = { key: 'ranking.srs.default_weights', group: 'Ranking', label: 'Item-Based SRS default weights', description: 'Default weights.', validationRule: 'Whole percentages; the total must be exactly 100%.',
  appliesTo: 'New Item-Based searches.', value: { distance: 30, price: 25, vps: 20, stock: 15, rating: 10 }, defaultValue: { distance: 30, price: 25, vps: 20, stock: 15, rating: 10 }, version: 2,
  previousValue: { distance: 35, price: 25, vps: 20, stock: 10, rating: 10 }, lastReason: 'Pilot feedback on distance weighting.', updatedAt: new Date('2026-10-01T02:00:00Z'), updatedBy: 'Super Admin', editable: true }

test('platform settings show version, previous value and rule; the fixed rules have no control; weights must total 100', async () => {
  vi.mocked(operations.listSettings).mockResolvedValue({ items: [weights] as never, canManage: true, fixed: [
    { key: 'ranking.vps_weights', label: 'VPS weights', value: { vcs: 50, ohs: 50 }, reason: 'VPS is fixed at 50% VCS and 50% OHS.' },
    { key: 'orders.nrpc_cap', label: 'NRPC platform cap', value: null, reason: 'There is no platform-wide numeric NRPC cap.' }] })
  vi.mocked(operations.updateSetting).mockRejectedValue(problem(409, 'SETTING_VERSION_CONFLICT', 'A newer version exists.'))
  at('/settings', <AdminPlatformSettingsPage />)
  expect(await screen.findByText('Version 2')).toBeInTheDocument()
  expect(screen.getByText(/Distance: 35/)).toBeInTheDocument()
  expect(screen.getByText('Whole percentages; the total must be exactly 100%.')).toBeInTheDocument()
  const fixed = screen.getByRole('heading', { name: 'Fixed rules (no control)' }).closest('section') as HTMLElement
  expect(within(fixed).getByText(/No cap/)).toBeInTheDocument()
  expect(within(fixed).queryByRole('button')).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Change' }))
  fireEvent.change(await screen.findByLabelText('Distance'), { target: { value: '40' } })
  expect(screen.getByText(/must total exactly 100%/)).toBeInTheDocument()
  fireEvent.change(screen.getByLabelText('Distance'), { target: { value: '30' } })
  expect(screen.getByText(/Total: 100%/)).toBeInTheDocument()
  fireEvent.change(screen.getByLabelText(/^Reason/), { target: { value: 'Align with the pilot ranking review.' } })
  fireEvent.click(screen.getByRole('button', { name: 'Save new version' }))
  await waitFor(() => expect(operations.updateSetting).toHaveBeenCalledWith('ranking.srs.default_weights', weights.value, 2, 'Align with the pilot ranking review.'))
  expect(await screen.findByText(/saved a newer version/)).toBeInTheDocument()
})

const enforcement = { id: 'act-1', subjectType: 'VENDOR_ORGANIZATION', subjectId: 'org-1', subjectName: 'Test Supply', action: 'SUSPENSION', actionLabel: 'Suspension', state: 'REFERRED', source: 'DISPUTE_REFERRAL',
  caseId: 'case-1', caseReference: 'DSP-0001', reason: 'Repeated non-delivery confirmed in the dispute.', durationDays: null, continuationPlan: null, issuedRole: 'ORDER_DISPUTE_ADMIN', appliedRole: null,
  createdAt: new Date('2026-10-08T00:00:00Z'), appliedAt: null, expiresAt: null, liftedAt: null, liftReason: null, lockVersion: 4, scope: 'Marketplace activity', restorationCondition: 'Complete the corrective plan.',
  continuationNote: null, priorSubjectState: null, allowedActions: ['APPLY', 'DECLINE'],
  subjectReview: { subjectType: 'VENDOR_ORGANIZATION', subjectId: 'org-1', displayName: 'Test Supply', maskedEmail: null, accountStatus: 'ACTIVE', storeActivationStatus: 'ACTIVE', openOrders: 2, ordersTotal: 9, disputesTotal: 3, disputesOpen: 1, commerceRestrictedUntil: null },
  events: [{ event: 'REFERRED', fromState: null, toState: 'REFERRED', before: null, after: null, reason: 'Recommended by the dispute decision.', actor: 'Order Admin', actorRole: 'ORDER_DISPUTE_ADMIN', correlationId: 'corr-ref', occurredAt: new Date('2026-10-08T00:00:00Z') }] }

test('applying a referred sanction targets the exact case and version, needs an order plan and reports a stale conflict', async () => {
  vi.mocked(operations.getEnforcement).mockResolvedValue(enforcement as never)
  vi.mocked(operations.applyEnforcement).mockRejectedValue(problem(409, 'ENFORCEMENT_VERSION_CONFLICT', 'This case changed after you opened it.'))
  at('/enforcement/act-1', <AdminEnforcementDetailPage />, '/enforcement/:actionId')
  expect(await screen.findByText(/Referred from dispute DSP-0001/)).toBeInTheDocument()
  expect(screen.getByText('corr-ref', { exact: false })).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Apply Suspension' }))
  expect(screen.getByText('Suspension for Test Supply')).toBeInTheDocument()
  expect(screen.queryByLabelText(/No Open Orders/)).not.toBeInTheDocument()
  fireEvent.click(screen.getByLabelText(/Monitored Fulfillment/))
  fireEvent.change(screen.getByLabelText(/^Reason/), { target: { value: 'Upholding the dispute recommendation after review.' } })
  fireEvent.click(screen.getByRole('button', { name: 'Apply' }))
  await waitFor(() => expect(operations.applyEnforcement).toHaveBeenCalledWith('act-1', { continuationPlan: 'MONITORED_FULFILLMENT', lockVersion: 4, reason: 'Upholding the dispute recommendation after review.' }))
  expect(await screen.findByText(/changed after you opened it. Reload/)).toBeInTheDocument()
  expect(screen.getByRole('button', { name: 'Reload latest' })).toBeInTheDocument()
})

test('audit search is read-only: no edit or delete control and no detail link without the sensitive permission', async () => {
  vi.mocked(operations.auditActions).mockResolvedValue(['ENFORCEMENT_APPLIED'])
  vi.mocked(operations.searchAudit).mockResolvedValue({ items: [{ id: 'a1', createdAt: new Date('2026-10-09T01:00:00Z'), actor: 'Super Admin', actorRole: 'SUPER_ADMIN', action: 'ENFORCEMENT_APPLIED', resourceType: 'ENFORCEMENT_ACTION',
    resourceId: null, organization: null, organizationId: null, succeeded: true, reason: 'Upheld.', correlationId: 'corr-a1', hasDetail: true }] as never, nextCursor: 'next', canViewDetail: false, canExport: false })
  at('/audit', <AdminAuditSearchPage />)
  expect(await screen.findByText('ENFORCEMENT_APPLIED', { selector: 'span' })).toBeInTheDocument()
  expect(screen.queryByRole('button', { name: /edit|delete|annotate/i })).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'ENFORCEMENT_APPLIED' })).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: /Export CSV/ })).not.toBeInTheDocument()
  expect(screen.getByRole('button', { name: 'Load older entries' })).toBeInTheDocument()
})

test('audit date Apply preserves the applied actor and supports an open-ended Manila range; Cancel and Reset are safe', async () => {
  vi.mocked(operations.auditActions).mockResolvedValue([])
  vi.mocked(operations.searchAudit).mockResolvedValue({ items: [], nextCursor: null, canViewDetail: false, canExport: false })
  at('/audit', <AdminAuditSearchPage />)
  await screen.findByText('No audit entries match these filters.')
  fireEvent.change(screen.getByLabelText('Actor name or email'), { target: { value: 'Finance reviewer' } })
  fireEvent.click(screen.getByRole('button', { name: 'Search' }))
  await waitFor(() => expect(operations.searchAudit).toHaveBeenLastCalledWith({ actor: 'Finance reviewer' }))
  const calls = vi.mocked(operations.searchAudit).mock.calls.length
  fireEvent.click(screen.getByRole('button', { name: 'All dates' }))
  fireEvent.change(screen.getByLabelText('From'), { target: { value: '2026-10-01' } })
  fireEvent.click(screen.getByRole('button', { name: 'Cancel' }))
  expect(operations.searchAudit).toHaveBeenCalledTimes(calls)
  fireEvent.click(screen.getByRole('button', { name: 'All dates' }))
  fireEvent.change(screen.getByLabelText('From'), { target: { value: '2026-10-01' } })
  fireEvent.click(screen.getByRole('button', { name: 'Apply' }))
  await waitFor(() => expect(operations.searchAudit).toHaveBeenLastCalledWith({ actor: 'Finance reviewer', from: parseDate('2026-10-01') }))
  fireEvent.click(screen.getByRole('button', { name: 'Reset filters' }))
  await waitFor(() => expect(operations.searchAudit).toHaveBeenLastCalledWith({}))
})

test('integration health shows masked statuses and a retry needs a reason; no secret value is rendered', async () => {
  vi.mocked(operations.integrationOverview).mockResolvedValue({ generatedAt: new Date(), environment: { app: 'Local', commerce: 'TEST — LIVE commerce disabled' }, canRetry: true,
    integrations: [{ key: 'google_maps', label: 'Google Maps, Places and Routes', status: 'NOT_CONFIGURED', detail: 'No server key configured; geocoding and routes use manual fallbacks.', environment: null, lastEventAt: null }],
    queues: { connection: 'Redis', outbox_backlog: 0, dead_letters: 1, failed_jobs: 0, status: 'DEGRADED' }, scheduledTasks: [], analytics: { geo_aggregation: { status: 'NO_RUN_RECORDED' }, materials_snapshot: { status: 'STALE' }, psgc: { status: 'HEALTHY', boundaries: {} } } } as never)
  vi.mocked(operations.operationFailures).mockResolvedValue({ items: [{ kind: 'OUTBOX_EVENT', reference: 'evt-1', label: 'NotificationRequested', queue: 'ORDER', failure: 'Delivery failed', attempts: 5, failedAt: new Date(), retryable: true, retryNote: null }] as never, total: 1, lastPage: 1 })
  vi.mocked(operations.operationRetries).mockResolvedValue([])
  vi.mocked(operations.retryOperation).mockResolvedValue({ targetType: 'OUTBOX_EVENT', reference: 'evt-1', label: 'NotificationRequested', outcome: 'QUEUED', correlationId: 'corr-r1' })
  at('/integrations', <AdminIntegrationHealthPage />)
  expect((await screen.findAllByText('Not Configured')).length).toBeGreaterThan(0)
  expect(screen.getAllByText('Degraded').length).toBeGreaterThan(0)
  fireEvent.click(screen.getByRole('tab', { name: 'Failures & retries' }))
  fireEvent.click(await screen.findByRole('button', { name: 'Retry' }))
  fireEvent.click(screen.getByRole('button', { name: 'Queue retry' }))
  expect(operations.retryOperation).not.toHaveBeenCalled()
  fireEvent.change(screen.getByLabelText(/^Reason/), { target: { value: 'Mail provider recovered; resend the notice.' } })
  fireEvent.click(screen.getByRole('button', { name: 'Queue retry' }))
  await waitFor(() => expect(operations.retryOperation).toHaveBeenCalledWith({ targetType: 'OUTBOX_EVENT', reference: 'evt-1', reason: 'Mail provider recovered; resend the notice.' }, expect.any(String)))
  expect(document.body.textContent).not.toMatch(/sk_|secret_key|xnd_/i)
})

const cell = (value: number | null, suppressed = false) => ({ value, suppressed, reason: suppressed ? 'Fewer than 5 distinct persons; counted in the parent total.' : null })
const rate = (percent: string | null, numerator: number | null, denominator: number | null, suppressed = false) => ({ percent, numerator, denominator, suppressed, reason: suppressed ? 'Fewer than 5 distinct Buyers.' : null })
const child = (code: string, name: string, gross: number | null, suppressed = false) => ({ code, name, level: 'REGION', levelLabel: 'Region', drillable: true, vendorCount: 3,
  registeredBuyers: { value: suppressed ? null : 12, suppressed }, grossGmvCentavos: { value: gross, suppressed }, netGmvCentavos: { value: gross, suppressed }, orderVolume: { value: suppressed ? null : 7, suppressed },
  fulfillmentRate: rate('90.00', 9, 10), cancellationRate: rate('5.00', 1, 20), disputeRate: rate('0.00', 0, 9), medianResponseSeconds: 600, responseSuppressed: false, suppressed,
  suppressionReason: suppressed ? 'SMALL_CELL' : null, suppressionNote: suppressed ? 'Fewer than 5 distinct Buyers' : null })
const dashboard = {
  scope: { code: null, name: 'Philippines', level: null, levelLabel: 'Country', label: 'Philippines', breadcrumbs: [{ code: null, name: 'Philippines', level: null }], childrenLabel: 'Regions', drillable: true, psgcVersion: null },
  dataset: { environment: 'TEST', label: 'Recorded Marketplace Activity', demo: false, lastAggregatedAt: new Date('2026-10-09T17:00:00Z'), throughDate: '2026-10-08', revision: 3, available: true },
  period: { from: new Date('2026-07-12'), to: new Date('2026-10-08'), granularity: 'WEEK' }, filters: {},
  filterApplicability: [{ filter: 'payment_method', appliesTo: ['ORDERS'], notApplicableTo: ['VENDOR_COUNT', 'MATERIALS_ANALYTICS_PRICES'], note: 'Transaction filters apply to order metrics only.' }],
  disclosure: { minimumPersons: 5, method: 'ROLL_UP_TO_PARENT', description: 'Person-derived cells with fewer than 5 distinct Buyers or users are suppressed.' },
  kpis: { vendorCount: cell(6), registeredBuyers: cell(24), grossGmvCentavos: cell(1250000), netGmvCentavos: cell(1100000), orderVolume: cell(14), fulfillmentRate: rate('92.86', 13, 14), cancellationRate: rate(null, null, null, true),
    disputeRate: rate('0.00', 0, 13), responseTime: { suppressed: false, reason: null, meanSeconds: 900, medianSeconds: 600, p90Seconds: 3600, answered: 14, unanswered: 1 },
    activeUsers: { buyer: { dau: cell(null, true), wau: cell(8), mau: cell(20) }, vendor: { dau: cell(2), wau: cell(4), mau: cell(6) } } },
  trends: [{ bucket: new Date('2026-09-28T00:00:00Z'), grossGmvCentavos: 1250000, netGmvCentavos: 1100000, orderVolume: 14, suppressed: false, reason: null }],
  activityTrend: [{ date: new Date('2026-10-08T00:00:00Z'), buyerDau: null, buyerWau: 8, buyerMau: 20, vendorDau: 2, vendorWau: 4, vendorMau: 6 }],
  children: [child('1300000000', 'National Capital Region', 1000000), child('0300000000', 'Central Luzon', null, true)],
  unresolved: { orders: 1, vendors: 0, registeredBuyers: 0, responses: 0, activity: 0 }, definitions: { gross_gmv: 'Confirmed order value before cancellations and refunds.' },
}

test('the geographic dashboard separates gross and net GMV, shows suppression with its reason, unresolved geography and drills by keyboard', async () => {
  vi.mocked(geo.getGeoDashboard).mockResolvedValue(dashboard as never)
  vi.mocked(geo.getGeoDemand).mockResolvedValue({ columns: [{ id: 'cat-1', name: 'Cement' }], rows: [], scope: dashboard.scope, dimension: 'CATEGORY', measure: 'ORDER_COUNT', unit: null, notComparableLines: 0, definition: '' } as never)
  vi.mocked(geo.getGeoBoundaries).mockResolvedValue({ type: 'FeatureCollection', features: [], missingCodes: ['1300000000', '0300000000'], psgcVersion: { id: 'v', label: '2026' } } as never)
  at('/analytics', <AdminGeoAnalyticsPage />)
  const kpis = await screen.findByRole('list', { name: 'Key metrics for Philippines' }).catch(() => screen.findByLabelText('Key metrics for Philippines'))
  expect(within(kpis).getByText('Gross GMV')).toBeInTheDocument()
  expect(within(kpis).getByText('Net GMV')).toBeInTheDocument()
  expect(within(kpis).getByText('13 of 14')).toBeInTheDocument()
  expect(within(kpis).getAllByText('Suppressed').length).toBeGreaterThan(0)
  expect(screen.getByText(/Unresolved geography/)).toBeInTheDocument()
  expect(screen.getByText(/Not applicable to: Vendor Count, Materials Analytics Prices/)).toBeInTheDocument()
  expect(screen.getByText(/Small cell: Fewer than 5 distinct Buyers/)).toBeInTheDocument()
  expect(document.body.textContent).not.toMatch(/latitude|longitude|coordinates:/i)
  fireEvent.click(screen.getByRole('button', { name: 'Drill into National Capital Region' }))
  await waitFor(() => expect(screen.getByTestId('location').textContent).toContain('area=1300000000'))
  await waitFor(() => expect(geo.getGeoDashboard).toHaveBeenLastCalledWith(expect.objectContaining({ area: '1300000000' })))
})
