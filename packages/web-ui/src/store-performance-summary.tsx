import type { StorePerformance } from '@materyalph/api-client-ts'
import type { ReactNode } from 'react'
import { BadgeCheck, MessageCircle, ShieldCheck, Timer, UsersRound } from 'lucide-react'
import { AnalyticsChartCard } from './analytics-layout'
import { TrendLineChart } from './geo-analytics-patterns'
import { analyticsDay, formatAnalyticsDate } from './analytics-patterns'
import { formatChartDay } from './chart-patterns'
import { PerformanceBadges, PerformanceRateMetric } from './performance-achievements'
import { publishedScoreValue, ScoreCalculationDetails } from './score-overview'
import { MaterialQualityCard, PublishedRatingCard, ScoreBreakdown, VendorPerformanceCard } from './store-performance-overview'

const RATE_ROWS: { key: 'NFR' | 'LSR' | 'RR' | 'ODR'; name: string; definition: string; bands: string }[] = [
  { key: 'NFR', name: 'Non-Fulfillment Rate', definition: 'Vendor-caused cancellations or refunds ÷ eligible confirmed orders', bands: 'No penalty to 2% · 0.25 to 5% · 0.75 to 10% · 1.50 above' },
  { key: 'LSR', name: 'Late Shipment Rate', definition: 'Orders dispatched or made ready after the confirmed date ÷ eligible fulfilled orders', bands: 'No penalty to 3% · 0.25 to 8% · 0.75 to 15% · 1.25 above' },
  { key: 'RR', name: 'Return Rate', definition: 'Validated defect, wrong-item or incomplete-order returns ÷ fulfilled orders', bands: 'No penalty to 2% · 0.25 to 5% · 0.50 to 10% · 1.00 above' },
  { key: 'ODR', name: 'Order Defect Rate', definition: 'Confirmed defect claims, chargebacks or severe issues ÷ eligible orders', bands: 'No penalty to 1% · 0.25 to 3% · 0.75 to 6% · 1.25 above' },
]
const penaltyText = (value: string | undefined) => value === undefined ? '—' : Number(value) === 0 ? 'None' : `−${value}`
export function PerformanceScoreHistory({ history }: { history: NonNullable<StorePerformance['history']> }) {
  const number = (value: string | null | undefined) => (value === null || value === undefined ? null : Number(value))
  return <div className="mp-performance-history">
    <AnalyticsChartCard title="Score history" description="Published scores over the last 30 daily calculations." calculation="Each point is that day's published value from the 00:30 Asia/Manila calculation. A gap means the score was not published that day.">
      {history.some(point => point.vps || point.vcs || point.mqs || point.ohs) ? <TrendLineChart title="Published score history" labels={history.map(point => analyticsDay(point.date) ?? '')} formatLabel={formatChartDay} formatValue={value => value.toFixed(2)} emptyReason="No published scores yet."
        series={[{ key: 'vps', label: 'VPS', colorVar: '--mp-viz-series-1', values: history.map(point => number(point.vps)) }, { key: 'vcs', label: 'VCS', colorVar: '--mp-viz-series-2', values: history.map(point => number(point.vcs)) },
          { key: 'mqs', label: 'MQS', colorVar: '--mp-viz-series-3', values: history.map(point => number(point.mqs)) }, { key: 'ohs', label: 'OHS', colorVar: '--mp-viz-series-4', values: history.map(point => number(point.ohs)) }]} /> : <p className="mp-performance-history-empty">No published history yet. Eligible scores will appear here after the daily calculation.</p>}
    </AnalyticsChartCard>
  </div>
}

export function StorePerformanceSummary({ data, metrics, health }: { data: Partial<Omit<StorePerformance, 'ohsCalculatedOn'>>; metrics?: ReactNode; health?: ReactNode }) {
  const operations = data.operations as { rates?: Record<string, string>; penalties?: Record<string, string>; numerators?: Record<string, number>; denominators?: Record<string, number>; listingViolations?: number; listing_violations?: number } | null
  const completed = data.completedOrders as { last90Days?: number; last_90_days?: number; total?: number } | undefined
  const history = data.history ?? []
  const scores = data.scores ?? []
  const ratingComponents = data.ratingComponents ?? {}
  const score = (key: string) => scores.find(item => item.key === key)
  const rating = (value: unknown) => { const parsed = typeof value === 'string' || typeof value === 'number' ? Number(value) : NaN; return Number.isFinite(parsed) && parsed >= 1 && parsed <= 5 ? parsed : null }
  const operationRows = [...RATE_ROWS.map(row => ({ key: row.key, label: `${row.name} (${row.key})`,
    value: operations?.rates?.[row.key] == null ? '—' : `${operations.rates[row.key]}%`,
    detail: `${operations?.numerators?.[row.key] ?? '—'} of ${operations?.denominators?.[row.key] ?? '—'} · Penalty ${penaltyText(operations?.penalties?.[row.key])}`,
  })), { key: 'LVD', label: 'Listing Violation Deduction (LVD)', value: String(operations?.listingViolations ?? operations?.listing_violations ?? '—'), detail: `Confirmed violations · Penalty ${penaltyText(operations?.penalties?.LVD)}` }]
  return <div className="mp-analytics space-y-3" data-store-performance>
    <div className="mp-performance-primary">
      <VendorPerformanceCard score={score('VPS')} components={scores.filter(item => item.key === 'VCS' || item.key === 'OHS')} publicLabel={data.label ?? 'New Vendor — Building Track Record'} facts={[
        { label: 'Scores as of', value: formatAnalyticsDate(data.asOf, true) },
        { label: 'Next OHS update', value: formatAnalyticsDate(data.nextOhsRecalculationOn, true) },
        { label: 'Completed orders (90 days)', value: <>{completed?.last90Days ?? completed?.last_90_days ?? 0} <span className="font-normal text-text-secondary">of {completed?.total ?? 0} total</span></> },
      ]} calculation={<ScoreCalculationDetails scores={scores} />} />
      <div className="mp-performance-achievements">
        <PerformanceBadges badges={data.badges ?? []} />
        <AnalyticsChartCard title="Badge metrics" description="The rates behind the Fast Responder and On-Time badges." calculation="CRR = eligible inquiries answered by a person within 12 hours ÷ eligible inquiries × 100 (trailing 30 days). FRR = orders fulfilled on or before the confirmed date ÷ eligible fulfilled orders × 100 (trailing 90 days).">
          <dl className="mp-performance-response-metrics">{(data.badgeMetrics ?? []).map(metric => <PerformanceRateMetric key={metric.key} kind={metric.key} label={metric.key === 'CRR' ? 'Customer Response Rate (CRR)' : 'On-time fulfillment (FRR)'} value={metric.value} detail={`${metric.window} · ${metric.sampleCount} ${metric.key === 'FRR' ? 'fulfilled orders' : 'inquiries'}`} />)}</dl>
        </AnalyticsChartCard>
      </div>
    </div>
    <div className="mp-performance-operations" data-with-metrics={Boolean(metrics) || undefined}>
      {metrics}
      <PerformanceScoreHistory history={history} />
    </div>
    <div className="mp-performance-overview" aria-label="Published store scores">
      <PublishedRatingCard title="Community rating (VCS)" description="Service and purchase experience" icon={<UsersRound size={26} />} score={score('VCS')} criteria={[
        { label: 'Service Quality', icon: <MessageCircle size={15} />, value: rating(ratingComponents.service_quality ?? ratingComponents.serviceQuality) },
        { label: 'Delivery / Processing Speed', icon: <Timer size={15} />, value: rating(ratingComponents.speed) },
        { label: 'Material quality (MQS)', icon: <BadgeCheck size={15} />, value: publishedScoreValue(score('MQS')) },
      ]} calculation="VCS = (Service Quality + Delivery/Processing Speed + MQS) ÷ 3. Published after at least five eligible Vendor ratings and an eligible MQS over a rolling 90 days. The speed criterion combines eligible delivery and processing ratings." note="Rolling 90 days · Eligible verified-purchase ratings. The ring shows the published VCS." />
      <MaterialQualityCard score={score('MQS')} />
      <PublishedRatingCard title="Operational health (OHS)" description="System-recorded order performance" icon={<ShieldCheck size={26} />} score={score('OHS')} sampleLabel="eligible orders" criteria={[]} calculation={<div className="grid gap-3">
        <p>OHS starts at 5.00 minus the workflow penalties below, limited to 1.00–5.00. Requires at least 10 eligible orders in the trailing 30 days and recalculates every Monday.</p>
        <dl className="grid gap-3">{RATE_ROWS.map(row => <div key={row.key}><dt className="font-semibold">{row.name} ({row.key})</dt><dd>{row.definition}. Trailing 30 days.</dd><dd>Bands: {row.bands}.</dd></div>)}</dl>
        <p>Listing Violation Deduction (LVD): active confirmed listing violations over 90 days. Penalties: 0.10 for one violation, 0.30 for two to three, 0.60 for four to five and 1.00 for six or more.</p>
      </div>} note={`Trailing 30 days · Recalculated weekly. Next update ${formatAnalyticsDate(data.nextOhsRecalculationOn, true)}. Listing violations: 90 days.`}>
        {operations?.rates ? <ScoreBreakdown rows={operationRows} /> : <p className="text-xs text-text-secondary">Operational event details are not available for this calculation.</p>}
      </PublishedRatingCard>
    </div>

    {health}
  </div>
}
