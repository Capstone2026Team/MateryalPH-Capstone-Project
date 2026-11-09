import { AdminDashboardApi, ResponseError, serializeDate, type AdminDashboardInsights, type GeoCell } from '@materyalph/api-client-ts'
import { createWebApiConfiguration } from '@materyalph/web-ui'
import { dateQuery, type CalendarRange } from './admin-format'

export type { AdminDashboardInsights }
export type InsightsPeriod = 30 | 90
export type InsightsDataset = 'TEST' | 'DEMO'

const api = () => new AdminDashboardApi(createWebApiConfiguration(import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1', { refreshSession: true }))

/** Permission-scoped insights; a section outside the Admin's role arrives as null. */
export async function getAdminDashboardInsights(days: InsightsPeriod, dataset: InsightsDataset, range?: CalendarRange): Promise<AdminDashboardInsights> {
  return (await api().getAdminDashboardInsights({ ...(range?.from && range.to ? dateQuery(range) : { days }), dataset })).data
}

const calendarDayMs = 86_400_000

/** The immediately preceding inclusive period, calculated in calendar days independently of the browser timezone. */
export function previousInsightsRange(range: CalendarRange): CalendarRange | null {
  const calendarDate = (value: string): number | null => {
    if (!/^\d{4}-\d{2}-\d{2}$/.test(value)) return null
    const date = new Date(`${value}T00:00:00.000Z`)
    return Number.isFinite(date.valueOf()) && date.toISOString().slice(0, 10) === value ? date.valueOf() : null
  }
  const from = calendarDate(range.from)
  const to = calendarDate(range.to)
  if (from === null || to === null || from > to) return null
  const days = (to - from) / calendarDayMs + 1
  if (days > 366) return null
  const previousFrom = new Date(from - days * calendarDayMs).toISOString().slice(0, 10)
  const previousTo = new Date(from - calendarDayMs).toISOString().slice(0, 10)
  return previousFrom >= '0001-01-01' ? { from: previousFrom, to: previousTo } : null
}

export type AdminDashboardInsightsComparison = {
  current: AdminDashboardInsights
  previous: AdminDashboardInsights | null
  previousRange: CalendarRange | null
  comparisonError: unknown | null
}

const matchesRange = (insights: AdminDashboardInsights, range: CalendarRange) => !insights.marketplace
  || (serializeDate(insights.marketplace.period.from) === range.from && serializeDate(insights.marketplace.period.to) === range.to)

const comparableDatasets = (current: AdminDashboardInsights, previous: AdminDashboardInsights) => {
  const currentMarket = current.marketplace
  const previousMarket = previous.marketplace
  return currentMarket?.dataset.available === true && previousMarket?.dataset.available === true
    && currentMarket.dataset.environment === previousMarket.dataset.environment && currentMarket.scope.code === previousMarket.scope.code
}

/** A comparison read may fail independently, but lost authentication/authorization must reach the resource store. */
export async function getAdminDashboardInsightsComparison(days: InsightsPeriod, dataset: InsightsDataset, range: CalendarRange): Promise<AdminDashboardInsightsComparison> {
  const previousRange = previousInsightsRange(range)
  const [current, comparison] = await Promise.all([
    getAdminDashboardInsights(days, dataset, range),
    previousRange ? getAdminDashboardInsights(days, dataset, previousRange)
      .then(previous => ({ previous, comparisonError: null }))
      .catch((cause: unknown) => {
        if (cause instanceof ResponseError && [401, 403].includes(cause.response.status)) throw cause
        return { previous: null, comparisonError: cause }
      }) : Promise.resolve({ previous: null, comparisonError: null }),
  ])
  const previous = previousRange && matchesRange(current, range) && comparison.previous && matchesRange(comparison.previous, previousRange) && comparableDatasets(current, comparison.previous)
    ? comparison.previous : null
  return { current, previous, previousRange, comparisonError: comparison.comparisonError }
}

/** Missing, protected and zero baselines have no percentage; never turn an unavailable value into zero. */
export function dashboardMetricChange(current: GeoCell | null | undefined, previous: GeoCell | null | undefined): number | null {
  if (!current || !previous || current.suppressed || previous.suppressed) return null
  const value = current.value
  const baseline = previous.value
  if (typeof value !== 'number' || typeof baseline !== 'number' || !Number.isFinite(value) || !Number.isFinite(baseline) || baseline <= 0) return null
  const change = (value - baseline) / baseline * 100
  return Number.isFinite(change) ? change : null
}
