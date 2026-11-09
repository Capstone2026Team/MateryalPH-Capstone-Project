import { Minus, TrendingDown, TrendingUp } from 'lucide-react'
import './metric-trend.css'

/** A recorded comparison shared by summary strips and individual KPI cards. */
export function MetricTrend({ changePercent, comparison, unavailable }: { changePercent?: number | null | undefined; comparison?: string | undefined; unavailable?: string | undefined }) {
  if (changePercent == null || !Number.isFinite(changePercent)) {
    return unavailable ? <dd className="mp-analytics-change mp-analytics-change-unavailable"><span className="mp-analytics-change-badge"><Minus size={13} aria-hidden="true" />No comparison</span>{' '}<span>{unavailable}</span></dd> : null
  }
  const change = Number(changePercent.toFixed(1))
  const direction = change === 0 ? 'flat' : change < 0 ? 'down' : 'up'
  const Icon = direction === 'flat' ? Minus : direction === 'down' ? TrendingDown : TrendingUp
  return <dd className="mp-analytics-change" data-direction={direction}>
    <span className="mp-analytics-change-badge"><Icon size={13} aria-hidden="true" /><span className="sr-only">{direction === 'flat' ? 'No change: ' : direction === 'down' ? 'Decrease: ' : 'Increase: '}</span><strong>{change > 0 ? '+' : ''}{change.toFixed(1)}%</strong></span>
    {comparison && <>{' '}<span>{comparison}</span></>}
  </dd>
}
