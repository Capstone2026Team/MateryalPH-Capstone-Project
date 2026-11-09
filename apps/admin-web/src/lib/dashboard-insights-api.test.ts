import { afterEach, expect, test, vi } from 'vitest'
import { AdminDashboardApi, ResponseError, parseDate, type AdminDashboardInsights, type AdminDashboardInsightsEnvelope, type GeoCell } from '@materyalph/api-client-ts'
import { dashboardMetricChange, getAdminDashboardInsightsComparison, previousInsightsRange } from './dashboard-insights-api'
import type { CalendarRange } from './admin-format'

afterEach(() => vi.restoreAllMocks())

const range = { from: '2026-10-01', to: '2026-10-30' }
const cell = (value: number | null, suppressed = false): GeoCell => ({ value, suppressed })
const envelope = (data: AdminDashboardInsights): AdminDashboardInsightsEnvelope => ({ data, meta: {}, errors: [] })

function insights(period: CalendarRange): AdminDashboardInsights {
  const emptyCell = cell(0)
  const rate = { percent: null, numerator: 0, denominator: 0, suppressed: false, reason: null }
  const forecast = { state: 'INSUFFICIENT_DATA' as const, observedDays: 0, direction: 'UNKNOWN' as const, changePercent: null, rSquared: null, points: [], anomalies: [] }
  return {
    generatedAt: new Date('2026-10-30T00:00:00Z'), access: { marketplace: true, vendorHealth: false }, definitions: {}, vendorHealth: null,
    marketplace: {
      scope: { code: null, name: 'Philippines', level: null, levelLabel: 'Country', label: 'Philippines', breadcrumbs: [], childrenLabel: 'Regions', drillable: true, psgcVersion: null },
      dataset: { environment: 'TEST', label: 'Recorded Marketplace Activity', demo: false, lastAggregatedAt: new Date('2026-10-30T00:00:00Z'), throughDate: '2026-10-30', revision: 1, available: true },
      period: { from: parseDate(period.from), to: parseDate(period.to), granularity: 'DAY', days: 30 },
      disclosure: { minimumPersons: 5, method: 'ROLL_UP_TO_PARENT', description: 'Small cells are suppressed.' },
      kpis: {
        vendorCount: emptyCell, registeredBuyers: emptyCell, grossGmvCentavos: emptyCell, netGmvCentavos: emptyCell, orderVolume: emptyCell,
        fulfillmentRate: rate, cancellationRate: rate, disputeRate: rate,
        responseTime: { suppressed: false, reason: null, meanSeconds: null, medianSeconds: null, p90Seconds: null, answered: 0, unanswered: 0 },
        activeUsers: { buyer: { dau: emptyCell, wau: emptyCell, mau: emptyCell }, vendor: { dau: emptyCell, wau: emptyCell, mau: emptyCell } },
      },
      series: [], forecast: { horizonDays: 7, grossGmv: forecast, orderVolume: forecast }, activity: [],
      areas: { childrenLabel: 'Regions', considered: 0, excludedSuppressed: 0, features: [], state: 'INSUFFICIENT_DATA', reason: null, k: null, segments: [], silhouette: null, unusual: [], recruitment: [], points: [] },
      categories: { demand: [], suppressedCategories: 0, rules: [], baskets: 0, minimumBuyers: 5 },
    },
  }
}

test.each([
  [{ from: '2026-01-01', to: '2026-01-01' }, { from: '2025-12-31', to: '2025-12-31' }],
  [{ from: '2024-03-01', to: '2024-03-31' }, { from: '2024-01-30', to: '2024-02-29' }],
  [{ from: '2026-03-07', to: '2026-03-10' }, { from: '2026-03-03', to: '2026-03-06' }],
  [range, { from: '2026-09-01', to: '2026-09-30' }],
])('the preceding period preserves inclusive day count across calendar boundaries: %o', (current, previous) => {
  expect(previousInsightsRange(current)).toEqual(previous)
})

test.each([
  { from: '', to: '2026-10-30' },
  { from: '2026-02-30', to: '2026-03-03' },
  { from: '2026-10-30', to: '2026-10-01' },
  { from: '2025-01-01', to: '2026-01-02' },
  { from: '0001-01-01', to: '0001-01-01' },
])('an invalid or unsupported calendar period has no comparison: %o', current => {
  expect(previousInsightsRange(current)).toBeNull()
})

test('loads current and preceding dates in parallel through the existing generated client', async () => {
  const current = insights(range)
  const previousRange = previousInsightsRange(range)!
  const previous = insights(previousRange)
  let finishCurrent: (value: AdminDashboardInsightsEnvelope) => void = () => undefined
  const currentRequest = new Promise<AdminDashboardInsightsEnvelope>(resolve => { finishCurrent = resolve })
  const get = vi.spyOn(AdminDashboardApi.prototype, 'getAdminDashboardInsights').mockReturnValueOnce(currentRequest).mockResolvedValueOnce(envelope(previous))
  const result = getAdminDashboardInsightsComparison(30, 'TEST', range)
  expect(get).toHaveBeenCalledTimes(2)
  expect(get).toHaveBeenNthCalledWith(1, { dataset: 'TEST', from: parseDate(range.from), to: parseDate(range.to) })
  expect(get).toHaveBeenNthCalledWith(2, { dataset: 'TEST', from: parseDate(previousRange.from), to: parseDate(previousRange.to) })
  finishCurrent(envelope(current))
  await expect(result).resolves.toEqual({ current, previous, previousRange, comparisonError: null })
})

test('a comparison failure preserves current content without manufacturing a zero baseline', async () => {
  const current = insights(range)
  const failure = new Error('Comparison unavailable')
  vi.spyOn(AdminDashboardApi.prototype, 'getAdminDashboardInsights').mockResolvedValueOnce(envelope(current)).mockRejectedValueOnce(failure)
  await expect(getAdminDashboardInsightsComparison(30, 'TEST', range)).resolves.toEqual({ current, previous: null, previousRange: previousInsightsRange(range), comparisonError: failure })
})

test.each([401, 403])('a comparison HTTP %s rejects so the resource store cannot retain unauthorized content', async status => {
  const failure = new ResponseError(new Response(null, { status }))
  vi.spyOn(AdminDashboardApi.prototype, 'getAdminDashboardInsights').mockResolvedValueOnce(envelope(insights(range))).mockRejectedValueOnce(failure)
  await expect(getAdminDashboardInsightsComparison(30, 'TEST', range)).rejects.toBe(failure)
})

test('a failed current request still rejects when the comparison succeeds', async () => {
  const failure = new Error('Current period unavailable')
  vi.spyOn(AdminDashboardApi.prototype, 'getAdminDashboardInsights').mockRejectedValueOnce(failure).mockResolvedValueOnce(envelope(insights(previousInsightsRange(range)!)))
  await expect(getAdminDashboardInsightsComparison(30, 'TEST', range)).rejects.toBe(failure)
})

test('a response for other dates cannot become the preceding-period comparison', async () => {
  vi.spyOn(AdminDashboardApi.prototype, 'getAdminDashboardInsights').mockResolvedValue(envelope(insights(range)))
  expect((await getAdminDashboardInsightsComparison(30, 'TEST', range)).previous).toBeNull()
})

test.each(['current', 'previous'] as const)('an absent or unavailable %s marketplace cannot produce a comparison', async side => {
  for (const missing of [true, false]) {
    const current = insights(range)
    const previous = insights(previousInsightsRange(range)!)
    const target = side === 'current' ? current : previous
    if (missing) target.marketplace = null
    else target.marketplace!.dataset.available = false
    const get = vi.spyOn(AdminDashboardApi.prototype, 'getAdminDashboardInsights').mockResolvedValueOnce(envelope(current)).mockResolvedValueOnce(envelope(previous))
    expect((await getAdminDashboardInsightsComparison(30, 'TEST', range)).previous).toBeNull()
    get.mockRestore()
  }
})

test.each(['environment', 'scope'] as const)('a different dataset %s cannot produce a comparison', async mismatch => {
  const current = insights(range)
  const previous = insights(previousInsightsRange(range)!)
  if (mismatch === 'environment') previous.marketplace!.dataset.environment = 'DEMO'
  else previous.marketplace!.scope.code = '1300000000'
  vi.spyOn(AdminDashboardApi.prototype, 'getAdminDashboardInsights').mockResolvedValueOnce(envelope(current)).mockResolvedValueOnce(envelope(previous))
  expect((await getAdminDashboardInsightsComparison(30, 'TEST', range)).previous).toBeNull()
})

test('percentage changes use visible actual totals and preserve increase, decrease and unchanged values', () => {
  expect(dashboardMetricChange(cell(1124), cell(1000))).toBeCloseTo(12.4)
  expect(dashboardMetricChange(cell(968), cell(1000))).toBeCloseTo(-3.2)
  expect(dashboardMetricChange(cell(1000), cell(1000))).toBe(0)
  expect(dashboardMetricChange(cell(0), cell(1000))).toBe(-100)
})

test('suppressed, missing, nonfinite and zero baselines never produce percentage indicators', () => {
  for (const [current, previous] of [
    [cell(100), cell(0)], [cell(0), cell(0)], [cell(100), null], [undefined, cell(100)], [cell(null), cell(100)],
    [cell(100), cell(null)], [cell(100, true), cell(100)], [cell(100), cell(100, true)], [cell(NaN), cell(100)], [cell(100), cell(Infinity)],
  ]) expect(dashboardMetricChange(current, previous)).toBeNull()
})
