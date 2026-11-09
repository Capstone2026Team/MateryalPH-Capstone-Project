import { useCallback, useEffect, useState } from 'react'
import { ResponseError, serializeDate } from '@materyalph/api-client-ts'
import { useAutomaticRefresh, usePortalResource } from '@materyalph/web-ui'
import { financeKpis, type FinanceKpis } from './finance-api'
import type { CalendarRange } from './admin-format'
import { readableVerificationError } from './vendor-verification-api'
import { dashboardMetricChange, previousInsightsRange } from './dashboard-insights-api'

const matchesRange = ({ period }: FinanceKpis, range: CalendarRange) => period.from !== null && period.to !== null
  && serializeDate(period.from) === range.from && serializeDate(period.to) === range.to

/** One independently authorized Finance snapshot for the overview card and its chart. */
export function useAdminPlatformEarnings({ from, to }: CalendarRange) {
  const load = useCallback(async () => {
    const previousRange = previousInsightsRange({ from, to })
    const [current, previous] = await Promise.all([
      financeKpis(from, to, { localForbidden: true }),
      previousRange ? financeKpis(previousRange.from, previousRange.to, { localForbidden: true }).catch((cause: unknown) => {
        if (cause instanceof ResponseError && [401, 403].includes(cause.response.status)) throw cause
        return null
      }) : Promise.resolve(null),
    ])
    const datesMatch = matchesRange(current, { from, to }) && previousRange && previous && matchesRange(previous, previousRange)
    return { current, previous: datesMatch ? previous : null }
  }, [from, to])
  const { data: snapshot, error, pending, refresh } = usePortalResource(`admin-dashboard-platform-earnings-comparison-${from}-${to}`, load)
  const data = snapshot?.current ?? null
  const denied = error instanceof ResponseError && error.response.status === 403
  const [message, setMessage] = useState<string | null>(null)
  useEffect(() => {
    let active = true
    setMessage(null)
    if (error) void readableVerificationError(error).then(value => { if (active) setMessage(value) })
    return () => { active = false }
  }, [error])
  useAutomaticRefresh(refresh, { enabled: !pending && !denied, intervalMs: error ? 120_000 : 30_000 })
  const netCollectedCentavos = data?.finance.find(item => item.key === 'net_collected')?.valueCentavos ?? null
  const previousNet = snapshot?.previous?.finance.find(item => item.key === 'net_collected')?.valueCentavos ?? null
  const changePercent = dashboardMetricChange({ value: netCollectedCentavos, suppressed: false }, { value: previousNet, suppressed: false })
  const comparisonUnavailable = previousNet === 0 ? 'No net collections in the previous period.' : previousNet !== null && previousNet < 0 ? 'Previous period net collections were negative.' : 'Previous period comparison unavailable.'
  const unavailableReason = denied ? 'Needs Finance access.' : error ? 'Platform earnings could not be loaded.' : data ? 'Commission total is unavailable.' : 'Loading platform earnings…'
  return { data, error, refresh, denied, message, netCollectedCentavos, unavailableReason, changePercent, comparisonUnavailable }
}

export type AdminPlatformEarningsResource = ReturnType<typeof useAdminPlatformEarnings>
