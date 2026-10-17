import { Link } from 'react-router-dom'
import { ArrowRight, Clock, PackageCheck, Scale, ShoppingCart, Undo2, Users, Wallet } from 'lucide-react'
import {
  AssociationRuleList, BarList, ChartDataTable, DashboardPanel, ForecastNote, IndicatorClassBadge, InfoNote, KpiCard, MethodNote, SegmentScatter, ShareBar, TrendLineChart,
  analyticsDay, formatChartDay, formatCompactCentavos, formatCount, formatDurationSeconds, formatPesoCentavos, type ForecastView, type TrendMarker, type VizColor,
} from '@materyalph/web-ui'
import type { AdminDashboardMarketplace, AdminDashboardVendorHealth, DashboardForecast, GeoCell, GeoRate, OperationsQueue } from '@materyalph/api-client-ts'

const SLOTS: VizColor[] = ['--mp-viz-series-1', '--mp-viz-series-2', '--mp-viz-series-3', '--mp-viz-series-4', '--mp-viz-series-5', '--mp-viz-series-6']
const CLASS_SLOTS: Record<string, VizColor> = { HEALTHY: '--mp-viz-series-3', WATCH: '--mp-viz-series-4', BELOW_WATCH_LEVEL: '--mp-viz-series-2', BUILDING_TRACK_RECORD: '--mp-viz-series-1' }
const day = (value: Date | string) => analyticsDay(value) ?? ''
const cellText = (cell: GeoCell, format: (value: number) => string) => (cell.suppressed ? 'Suppressed' : cell.value === null || cell.value === undefined ? '—' : format(cell.value))
const rateText = (rate: GeoRate) => (rate.suppressed ? 'Suppressed' : rate.percent ? `${rate.percent}%` : '—')
const rateHint = (rate: GeoRate, noun: string) => (rate.suppressed ? (rate.reason ?? 'Below the small-cell threshold.') : !rate.denominator ? `No ${noun} in this period.` : `${formatCount(rate.numerator ?? 0)} of ${formatCount(rate.denominator)} ${noun}.`)

function forecastView(forecast: DashboardForecast): ForecastView {
  return { state: forecast.state, direction: forecast.direction, changePercent: forecast.changePercent ?? null, expectedTotal: forecast.expectedTotal ?? null, points: forecast.points,
    weekdayStrength: forecast.weekdayStrength ?? null, observedDays: forecast.observedDays }
}

function trendForecast(forecast: DashboardForecast) {
  return forecast.state === 'OK' ? { label: 'Forecast', labels: forecast.points.map(point => day(point.date)), values: forecast.points.map(point => point.value), lower: forecast.points.map(point => point.lower), upper: forecast.points.map(point => point.upper) } : null
}

function anomalyMarkers(forecast: DashboardForecast, labels: string[]): TrendMarker[] {
  return forecast.anomalies.map(anomaly => ({ index: labels.indexOf(day(anomaly.date)), label: `Anomaly: ${anomaly.deviation > 0 ? 'above' : 'below'} the expected value` })).filter(marker => marker.index >= 0)
}

/** Headline marketplace KPIs from the disclosure-controlled read model; suppressed cells say so. */
export function MarketplaceKpis({ marketplace, periodLabel }: { marketplace: AdminDashboardMarketplace; periodLabel: string }) {
  const k = marketplace.kpis
  return <dl className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
    <KpiCard label="Gross GMV" value={cellText(k.grossGmvCentavos, formatPesoCentavos)} hint={`Confirmed orders, ${periodLabel}; excludes the Buyer processing fee.`} icon={<Wallet size={16} aria-hidden="true" />} sparkline={marketplace.series.map(point => point.grossGmvCentavos ?? null)} accent />
    <KpiCard label="Net GMV" value={cellText(k.netGmvCentavos, formatPesoCentavos)} hint="After cancellations and dispute-conclusion refunds." />
    <KpiCard label="Confirmed orders" value={cellText(k.orderVolume, value => formatCount(value))} hint="Vendor child orders first confirmed in the period." icon={<ShoppingCart size={16} aria-hidden="true" />} sparkline={marketplace.series.map(point => point.orderVolume ?? null)} />
    <KpiCard label="Fulfillment rate" value={rateText(k.fulfillmentRate)} hint={rateHint(k.fulfillmentRate, 'orders due')} icon={<PackageCheck size={16} aria-hidden="true" />} />
  </dl>
}

export function GmvTrendPanel({ marketplace }: { marketplace: AdminDashboardMarketplace }) {
  const labels = marketplace.series.map(point => day(point.date))
  const forecast = marketplace.forecast.grossGmv
  return <DashboardPanel title="GMV trend and 7-day forecast" description="Daily gross and net GMV. Suppressed days are gaps, never zero; the shaded region is a forecast.">
    <div className="grid gap-4">
      <TrendLineChart title="Gross and net GMV per day" labels={labels} formatLabel={formatChartDay} formatValue={value => formatCompactCentavos(Math.round(value))} emptyReason="No visible order activity in this period."
        series={[{ key: 'gross', label: 'Gross GMV', colorVar: '--mp-viz-series-1', values: marketplace.series.map(point => point.grossGmvCentavos ?? null) }, { key: 'net', label: 'Net GMV', colorVar: '--mp-viz-series-2', values: marketplace.series.map(point => point.netGmvCentavos ?? null) }]}
        forecast={trendForecast(forecast)} markers={anomalyMarkers(forecast, labels)} />
      <ForecastNote forecast={forecastView(forecast)} horizonDays={marketplace.forecast.horizonDays} unit="in gross GMV" formatValue={value => formatPesoCentavos(Math.round(value))} />
      <ChartDataTable caption="GMV per day" rowHeader="Date" rows={labels.map(formatChartDay)} columns={[
        { key: 'gross', header: 'Gross GMV', values: marketplace.series.map(point => (point.suppressed ? 'Suppressed' : formatPesoCentavos(point.grossGmvCentavos ?? null))) },
        { key: 'net', header: 'Net GMV', values: marketplace.series.map(point => (point.suppressed ? 'Suppressed' : formatPesoCentavos(point.netGmvCentavos ?? null))) },
        { key: 'orders', header: 'Orders', values: marketplace.series.map(point => (point.suppressed ? 'Suppressed' : formatCount(point.orderVolume ?? 0))) },
      ]} />
      <MethodNote>Time-series analysis on the daily read model: least-squares trend plus a weekday pattern with a 95% prediction band; diamonds mark days more than three standard deviations from the fitted value. Suppressed days are never fitted. {marketplace.disclosure.description}</MethodNote>
    </div>
  </DashboardPanel>
}

export function OrderVolumePanel({ marketplace }: { marketplace: AdminDashboardMarketplace }) {
  const labels = marketplace.series.map(point => day(point.date))
  const forecast = marketplace.forecast.orderVolume
  return <DashboardPanel title="Order volume and forecast" description="Confirmed Vendor child orders per day.">
    <div className="grid gap-4">
      <TrendLineChart title="Confirmed orders per day" labels={labels} formatLabel={formatChartDay} formatValue={value => formatCount(Math.round(value * 10) / 10)} emptyReason="No visible order activity in this period."
        series={[{ key: 'orders', label: 'Confirmed orders', colorVar: '--mp-viz-series-1', values: marketplace.series.map(point => point.orderVolume ?? null), kind: 'bar' }, { key: 'average', label: '7-day average', colorVar: '--mp-viz-series-2', values: marketplace.series.map(point => point.volumeAverage ?? null) }]}
        forecast={trendForecast(forecast)} markers={anomalyMarkers(forecast, labels)} />
      <ForecastNote forecast={forecastView(forecast)} horizonDays={marketplace.forecast.horizonDays} unit="orders" formatValue={value => formatCount(Math.round(value))} />
    </div>
  </DashboardPanel>
}

export function CategoryInsights({ marketplace }: { marketplace: AdminDashboardMarketplace }) {
  const categories = marketplace.categories
  return <div className="grid items-start gap-5 xl:grid-cols-2">
    <DashboardPanel title="Category demand" description="Confirmed orders containing each category in the period.">
      <BarList label="Category demand" empty="No category demand above the small-cell threshold in this period." items={categories.demand.map(item => ({ key: item.category, label: item.category, value: item.orders, display: `${formatCount(item.orders)} orders` }))} />
      {categories.suppressedCategories > 0 && <p className="mt-3 text-xs text-text-secondary">{formatCount(categories.suppressedCategories)} categories with fewer than {categories.minimumBuyers} distinct Buyers are not shown.</p>}
    </DashboardPanel>
    <DashboardPanel title="Categories ordered together" description="Association rules across confirmed orders in the period.">
      <div className="grid gap-4">
        <AssociationRuleList countLabel="orders" empty={`No category pattern meets the minimum of ${categories.minimumBuyers} distinct Buyers (${formatCount(categories.baskets)} orders checked).`}
          rules={categories.rules.map(rule => ({ antecedent: rule.antecedent, consequent: rule.consequent, confidence: rule.confidence, lift: rule.lift, supportCount: rule.supportCount }))} />
        <MethodNote>Association rule mining (Apriori): confidence is how often orders with the first categories also contain the last one; lift above 1 means more often than chance. Every rule needs at least {categories.minimumBuyers} distinct Buyers, the same small-cell rule as the rest of the dashboard. It supports Vendor recruitment and category planning; it is not an official market statistic.</MethodNote>
      </div>
    </DashboardPanel>
  </div>
}

export function AreaSegmentsPanel({ marketplace }: { marketplace: AdminDashboardMarketplace }) {
  const areas = marketplace.areas
  return <DashboardPanel title={`Market segments by ${areas.childrenLabel.toLowerCase()}`} description="Areas grouped by supply and demand; supports Vendor recruitment decisions."
    action={<Link to="/analytics" className="inline-flex min-h-11 items-center gap-1 text-sm font-semibold text-action-primary">Marketplace Analytics<ArrowRight size={14} aria-hidden="true" /></Link>}>
    {areas.state !== 'OK' ? <p className="text-sm text-text-secondary">{areas.reason}{areas.excludedSuppressed > 0 ? ` ${formatCount(areas.excludedSuppressed)} areas with a suppressed cell are left out.` : ''}</p> : <div className="grid gap-5">
      <SegmentScatter title="Areas by active Vendors and confirmed orders" xLabel="Active Vendors" yLabel="Confirmed orders" groups={areas.segments.map(segment => segment.label)}
        points={areas.points.map(point => ({ key: point.name, label: point.name, x: point.vendors, y: point.orders, group: point.segment }))} />
      <ul className="grid gap-4 md:grid-cols-2 xl:grid-cols-4">{areas.segments.map(segment => <li key={segment.id} className="grid gap-1 border-l-2 border-border-default pl-4 text-sm">
        <span className="font-semibold text-text-strong">{segment.label}</span>
        <span className="text-text-secondary">{formatCount(segment.size)} areas · about {formatCount(segment.averageVendors)} Vendors, {formatCount(segment.averageBuyers)} Buyers, {formatCount(segment.averageOrders)} orders and {formatCompactCentavos(segment.averageGmvCentavos)} GMV each</span>
        <span className="text-xs text-text-secondary">e.g. {segment.examples.join(', ')}</span></li>)}</ul>
      <div className="grid items-start gap-5 lg:grid-cols-2">
        <div className="grid gap-2"><h3 className="text-sm font-semibold text-text-strong">Recruitment signals</h3><p className="text-xs text-text-secondary">Most confirmed orders per active Vendor placed in the area.</p>
          <BarList label="Recruitment signals" empty="No area has visible orders yet." colorVar="--mp-viz-series-2" items={areas.recruitment.map(item => ({ key: item.code, label: item.name, value: item.ordersPerVendor, display: `${formatCount(item.ordersPerVendor)} per Vendor`, detail: `${formatCount(item.orders)} orders · ${formatCount(item.vendors)} active Vendors` }))} /></div>
        <div className="grid gap-2"><h3 className="text-sm font-semibold text-text-strong">Unusual areas</h3><p className="text-xs text-text-secondary">Supply and demand far from every other area (DBSCAN noise).</p>
          {areas.unusual.length === 0 ? <p className="text-sm text-text-secondary">No area stands apart from the others.</p>
            : <ul className="divide-y divide-border-default text-sm">{areas.unusual.map(item => <li key={item.code} className="flex justify-between gap-3 py-2"><span className="font-semibold text-text-strong">{item.name}</span><span className="text-text-secondary">{formatCount(item.vendors)} Vendors · {formatCount(item.orders)} orders</span></li>)}</ul>}</div>
      </div>
      <MethodNote>Clustering: K-Means on standardized active Vendors, registered Buyers, confirmed orders and gross GMV, with the number of groups chosen by the best silhouette score{areas.silhouette !== null && areas.silhouette !== undefined ? ` (${areas.silhouette.toFixed(2)})` : ''}. DBSCAN marks isolated areas. {formatCount(areas.considered)} areas grouped; {formatCount(areas.excludedSuppressed)} with a suppressed cell left out. Segments describe patterns, not merit.</MethodNote>
    </div>}
  </DashboardPanel>
}

export function VendorHealthPanel({ health }: { health: AdminDashboardVendorHealth }) {
  const segments = health.segments
  return <div className="grid items-start gap-5 xl:grid-cols-2">
    <DashboardPanel title="Vendor health indicator" description={`${formatCount(health.total)} active Tier 2 Vendors, classified by the System Workflow thresholds.`}
      action={<Link to="/scores" className="inline-flex min-h-11 items-center gap-1 text-sm font-semibold text-action-primary">Score Monitoring<ArrowRight size={14} aria-hidden="true" /></Link>}>
      <div className="grid gap-4">
        <ShareBar label="Vendors by health indicator" empty="No active Vendors yet." segments={health.classes.map(item => ({ key: item.key, label: item.label, value: item.count, colorVar: CLASS_SLOTS[item.key] ?? '--mp-viz-series-1' }))} />
        {health.attention.length > 0 && <ul className="divide-y divide-border-default">{health.attention.map(vendor => <li key={vendor.vendorId} className="grid gap-1 py-3">
          <div className="flex flex-wrap items-center justify-between gap-2"><Link to={`/scores/${vendor.vendorId}`} className="text-sm font-semibold text-text-strong hover:text-action-primary">{vendor.storeName}</Link><IndicatorClassBadge value={vendor._class} label={vendor.label} /></div>
          <p className="text-xs text-text-secondary">VPS {vendor.vps ?? '—'} · OHS {vendor.ohs ?? '—'} · {vendor.reasons.join(' ')}</p></li>)}</ul>}
        <MethodNote>Classification: a fixed decision tree using only published scores and the System Workflow thresholds (VPS below 3.00 or OHS below 2.50, then any OHS metric outside its no-penalty band). It creates no flag, warning or sanction; enforcement remains a reasoned Admin decision.</MethodNote>
      </div>
    </DashboardPanel>
    <DashboardPanel title="Vendor performance segments" description="Vendors with a published VPS, grouped by score and volume.">
      {segments.state !== 'OK' ? <p className="text-sm text-text-secondary">{segments.reason}</p> : <div className="grid gap-4">
        <ul className="grid gap-4 sm:grid-cols-2">{segments.segments.map((segment, index) => <li key={segment.id} className="grid gap-1 border-l-4 pl-4 text-sm" style={{ borderColor: `var(${SLOTS[index % SLOTS.length]})` }}>
          <span className="font-semibold text-text-strong">{segment.label}</span>
          <span className="text-text-secondary">{formatCount(segment.size)} Vendors · VPS {segment.averageVps.toFixed(2)} · OHS {segment.averageOhs.toFixed(2)} · {formatCount(segment.averageCompletedOrders)} completed orders (90 days)</span></li>)}</ul>
        <MethodNote>K-Means on standardized VPS, OHS and completed orders; groups chosen by the best silhouette score{segments.silhouette !== null && segments.silhouette !== undefined ? ` (${segments.silhouette.toFixed(2)})` : ''}. {formatCount(segments.considered)} Vendors considered.</MethodNote>
      </div>}
    </DashboardPanel>
  </div>
}

export function ActivityPanel({ marketplace, audience }: { marketplace: AdminDashboardMarketplace; audience: 'both' | 'vendor' }) {
  const labels = marketplace.activity.map(point => day(point.date))
  const series = audience === 'vendor'
    ? [{ key: 'vendor_dau', label: 'Vendor users (daily)', colorVar: '--mp-viz-series-1' as VizColor, values: marketplace.activity.map(point => point.vendorDau ?? null) }, { key: 'vendor_mau', label: 'Vendor users (30-day)', colorVar: '--mp-viz-series-2' as VizColor, values: marketplace.activity.map(point => point.vendorMau ?? null) }]
    : [{ key: 'buyer_dau', label: 'Active Buyers (daily)', colorVar: '--mp-viz-series-1' as VizColor, values: marketplace.activity.map(point => point.buyerDau ?? null) }, { key: 'vendor_dau', label: 'Active Vendor users (daily)', colorVar: '--mp-viz-series-2' as VizColor, values: marketplace.activity.map(point => point.vendorDau ?? null) }]
  return <DashboardPanel title={audience === 'vendor' ? 'Active Vendor users' : 'Meaningful active users'} description="Only human operational actions count; app opens, page views and auto-accept never do. Small counts are suppressed.">
    <TrendLineChart title="Active users per day" labels={labels} formatLabel={formatChartDay} formatValue={value => formatCount(Math.round(value))} emptyReason="Every day is below the small-cell threshold or has no activity." series={series} />
  </DashboardPanel>
}

export function CaseRatesPanel({ marketplace }: { marketplace: AdminDashboardMarketplace }) {
  const k = marketplace.kpis
  return <dl className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
    <KpiCard label="Dispute rate" value={rateText(k.disputeRate)} hint={rateHint(k.disputeRate, 'confirmed orders')} icon={<Scale size={16} aria-hidden="true" />} accent />
    <KpiCard label="Cancellation rate" value={rateText(k.cancellationRate)} hint={rateHint(k.cancellationRate, 'confirmed orders')} icon={<Undo2 size={16} aria-hidden="true" />} />
    <KpiCard label="Median Vendor response" value={k.responseTime.suppressed ? 'Suppressed' : formatDurationSeconds(k.responseTime.medianSeconds)} hint={k.responseTime.suppressed ? (k.responseTime.reason ?? '') : `Mean ${formatDurationSeconds(k.responseTime.meanSeconds)} · 90th percentile ${formatDurationSeconds(k.responseTime.p90Seconds)}.`} icon={<Clock size={16} aria-hidden="true" />} />
    <KpiCard label="Monthly active Buyers" value={cellText(k.activeUsers.buyer.mau, value => formatCount(value))} hint={`${cellText(k.activeUsers.vendor.mau, value => formatCount(value))} monthly active Vendor users.`} icon={<Users size={16} aria-hidden="true" />} />
  </dl>
}

/** Queue counts as one ranked chart above the queue cards, so the heaviest queue is obvious at a glance. */
export function QueueLoadChart({ queues = [], groups }: { queues?: OperationsQueue[] | undefined; groups?: string[] }) {
  const visible = (groups ? queues.filter(queue => groups.includes(queue.group)) : queues).filter(queue => queue.count > 0).sort((a, b) => b.count - a.count)
  return <DashboardPanel title="Queue load" description="Pending items per queue within your permissions.">
    <BarList label="Queue load" empty="Every queue in your scope is clear." colorVar="--mp-viz-series-2" items={visible.map(queue => ({ key: queue.key, label: queue.label, value: queue.count, display: formatCount(queue.count), detail: queue.group }))} />
  </DashboardPanel>
}

export function MarketplaceUnavailable({ reason, allowed }: { reason: string | null | undefined; allowed: boolean }) {
  return <InfoNote>{allowed ? (reason ?? 'Marketplace insights are unavailable right now.') : 'Marketplace charts and forecasts need aggregate analytics access (analytics.view_aggregates).'}</InfoNote>
}
