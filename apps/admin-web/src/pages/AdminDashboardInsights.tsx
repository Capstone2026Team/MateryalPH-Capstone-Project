import { useState } from 'react'
import { Link } from 'react-router-dom'
import { ArrowRight, Clock, PackageCheck, Scale, ShoppingCart, Store, Undo2, Users, Wallet } from 'lucide-react'
import {
  AnalyticsChartCard, AnalyticsSummary, AnalyticsDetails, AssociationRuleList, BarList, ChartDataTable, DashboardPanel, FilterTabs, ForecastNote, IndicatorClassBadge, InfoNote, KpiCard, MethodNote, SegmentScatter, ShareBar, TrendLineChart,
  analyticsDay, formatChartDay, formatCompactCentavos, formatCount, formatDurationSeconds, formatPesoCentavos, type ForecastView, type TrendMarker, type VizColor,
} from '@materyalph/web-ui'
import type { AdminDashboardMarketplace, AdminDashboardVendorHealth, DashboardForecast, GeoCell, GeoRate, OperationsQueue } from '@materyalph/api-client-ts'
import type { CalendarRange } from '../lib/admin-format'
import { dashboardMetricChange } from '../lib/dashboard-insights-api'

const SLOTS: VizColor[] = ['--mp-viz-series-1', '--mp-viz-series-2', '--mp-viz-series-3', '--mp-viz-series-4', '--mp-viz-series-5', '--mp-viz-series-6']
const CLASS_SLOTS: Record<string, VizColor> = { HEALTHY: '--mp-viz-success', WATCH: '--mp-viz-warning', BELOW_WATCH_LEVEL: '--mp-viz-error', BUILDING_TRACK_RECORD: '--mp-viz-series-2' }
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
  return <dl className="mp-card-group grid gap-3 sm:grid-cols-2 xl:grid-cols-4">
    <KpiCard appearance="financial" density="compact" label="Gross sales" value={cellText(k.grossGmvCentavos, formatPesoCentavos)} hint={`Confirmed orders, ${periodLabel}; excludes the E-wallet transaction fee.`} icon={<Wallet size={16} aria-hidden="true" />} accent />
    <KpiCard appearance="financial" density="compact" label="Net sales" value={cellText(k.netGmvCentavos, formatPesoCentavos)} hint="After cancellations and completed refunds." icon={<Wallet size={16} aria-hidden="true" />} />
    <KpiCard density="compact" label="Confirmed orders" value={cellText(k.orderVolume, value => formatCount(value))} hint="Vendor child orders first confirmed in the period." icon={<ShoppingCart size={16} aria-hidden="true" />} />
    <KpiCard density="compact" label="Fulfillment rate" value={rateText(k.fulfillmentRate)} hint={rateHint(k.fulfillmentRate, 'orders due')} icon={<PackageCheck size={16} aria-hidden="true" />} />
  </dl>
}

export function GmvTrendPanel({ marketplace, wide = false }: { marketplace: AdminDashboardMarketplace; wide?: boolean }) {
  const labels = marketplace.series.map(point => day(point.date))
  const forecast = marketplace.forecast.grossGmv
  return <AnalyticsChartCard wide={wide} title="Marketplace value" description="Gross and net order value for the selected dates." calculation={<>
      <p>Gross sales is confirmed Vendor order value before refunds, excluding the E-wallet transaction fee. Net sales deducts cancelled and refunded commercial value. These are marketplace sales, separate from platform commission earnings.</p>
      <ForecastNote forecast={forecastView(forecast)} horizonDays={marketplace.forecast.horizonDays} unit="in gross sales" formatValue={value => formatPesoCentavos(Math.round(value))} />
      <MethodNote>Time-series analysis on the daily read model: least-squares trend plus a weekday pattern with a 95% prediction band; diamonds mark days more than three standard deviations from the fitted value. Suppressed days are never fitted. {marketplace.disclosure.description}</MethodNote>
    </>}>
      <TrendLineChart variant="area" title="Gross and net sales per day" labels={labels} formatLabel={formatChartDay} formatValue={value => formatCompactCentavos(Math.round(value))} emptyReason="No visible order activity in this period."
        series={[{ key: 'gross', label: 'Gross sales', colorVar: '--mp-viz-series-1', values: marketplace.series.map(point => point.grossGmvCentavos ?? null) }, { key: 'net', label: 'Net sales', colorVar: '--mp-viz-series-2', values: marketplace.series.map(point => point.netGmvCentavos ?? null) }]}
        forecast={trendForecast(forecast)} markers={anomalyMarkers(forecast, labels)} />
      <ChartDataTable caption="GMV per day" rowHeader="Date" rows={labels.map(formatChartDay)} columns={[
        { key: 'gross', header: 'Gross sales', values: marketplace.series.map(point => (point.suppressed ? 'Suppressed' : formatPesoCentavos(point.grossGmvCentavos ?? null))) },
        { key: 'net', header: 'Net sales', values: marketplace.series.map(point => (point.suppressed ? 'Suppressed' : formatPesoCentavos(point.netGmvCentavos ?? null))) },
        { key: 'orders', header: 'Orders', values: marketplace.series.map(point => (point.suppressed ? 'Suppressed' : formatCount(point.orderVolume ?? 0))) },
      ]} />
  </AnalyticsChartCard>
}

export function OrderVolumePanel({ marketplace, wide = false }: { marketplace: AdminDashboardMarketplace; wide?: boolean }) {
  const labels = marketplace.series.map(point => day(point.date))
  const forecast = marketplace.forecast.orderVolume
  return <AnalyticsChartCard wide={wide} title="Order activity" description="Confirmed orders by day." calculation={<>
      <p>Counts Vendor child orders first confirmed on each date in Asia/Manila. The optional table also shows the 7-day average, which smooths daily changes. Suppressed periods stay hidden.</p>
      <ForecastNote forecast={forecastView(forecast)} horizonDays={marketplace.forecast.horizonDays} unit="orders" formatValue={value => formatCount(Math.round(value))} />
    </>}>
      <TrendLineChart integerAxis variant="bar" title="Confirmed orders per day" labels={labels} formatLabel={formatChartDay} formatValue={value => formatCount(Math.round(value))} emptyReason="No visible order activity in this period."
        series={[{ key: 'orders', label: 'Confirmed orders', colorVar: '--mp-viz-series-1', values: marketplace.series.map(point => point.orderVolume ?? null) }]}
        forecast={trendForecast(forecast)} markers={anomalyMarkers(forecast, labels)} />
      <ChartDataTable caption="Order activity per day" rowHeader="Date" rows={labels.map(formatChartDay)} columns={[
        { key: 'orders', header: 'Confirmed orders', values: marketplace.series.map(point => point.suppressed ? 'Suppressed' : formatCount(point.orderVolume ?? null)) },
        { key: 'average', header: '7-day average', values: marketplace.series.map(point => point.suppressed ? 'Suppressed' : formatCount(point.volumeAverage ?? null)) },
      ]} />
  </AnalyticsChartCard>
}

export function CategoryInsights({ marketplace }: { marketplace: AdminDashboardMarketplace }) {
  const categories = marketplace.categories
  return <div className="grid gap-4">
    <DashboardPanel density="compact" title="Category demand" description="Confirmed orders containing each category in the period.">
      <BarList label="Category demand" empty="No category demand above the small-cell threshold in this period." items={categories.demand.map(item => ({ key: item.category, label: item.category, value: item.orders, display: `${formatCount(item.orders)} orders` }))} />
      {categories.suppressedCategories > 0 && <p className="mt-3 text-xs text-text-secondary">{formatCount(categories.suppressedCategories)} categories with fewer than {categories.minimumBuyers} distinct Buyers are not shown.</p>}
    </DashboardPanel>
    <AnalyticsDetails title="Categories ordered together">
    <DashboardPanel density="compact" title="Categories ordered together" description="Association rules across confirmed orders in the period.">
      <div className="grid gap-3">
        <AssociationRuleList countLabel="orders" empty={`No category pattern meets the minimum of ${categories.minimumBuyers} distinct Buyers (${formatCount(categories.baskets)} orders checked).`}
          rules={categories.rules.map(rule => ({ antecedent: rule.antecedent, consequent: rule.consequent, confidence: rule.confidence, lift: rule.lift, supportCount: rule.supportCount }))} />
        <MethodNote>Association rule mining (Apriori): confidence is how often orders with the first categories also contain the last one; lift above 1 means more often than chance. Every rule needs at least {categories.minimumBuyers} distinct Buyers, the same small-cell rule as the rest of the dashboard. It supports Vendor recruitment and category planning; it is not an official market statistic.</MethodNote>
      </div>
    </DashboardPanel>
    </AnalyticsDetails>
  </div>
}

export function AreaSegmentsPanel({ marketplace }: { marketplace: AdminDashboardMarketplace }) {
  const areas = marketplace.areas
  return <DashboardPanel density="compact" title={`Market segments by ${areas.childrenLabel.toLowerCase()}`} description="Areas grouped by supply and demand; supports Vendor recruitment decisions."
    action={<Link to="/analytics" className="inline-flex min-h-11 items-center gap-1 text-sm font-semibold text-action-primary">Marketplace Analytics<ArrowRight size={14} aria-hidden="true" /></Link>}>
    {areas.state !== 'OK' ? <SegmentScatter title="Areas by active Vendors and confirmed orders" xLabel="Active Vendors" yLabel="Confirmed orders" groups={[]} points={[]} emptyReason={`${areas.reason ?? 'Not enough areas with data to show segments.'}${areas.excludedSuppressed > 0 ? ` ${formatCount(areas.excludedSuppressed)} areas with a suppressed cell are left out.` : ''}`} /> : <div className="grid gap-3">
      <SegmentScatter title="Areas by active Vendors and confirmed orders" xLabel="Active Vendors" yLabel="Confirmed orders" groups={areas.segments.map(segment => segment.label)}
        points={areas.points.map(point => ({ key: point.name, label: point.name, x: point.vendors, y: point.orders, group: point.segment }))} />
      <ul className="grid gap-4 md:grid-cols-2 xl:grid-cols-4">{areas.segments.map(segment => <li key={segment.id} className="grid gap-1 border-l-2 border-border-default pl-4 text-sm">
        <span className="font-semibold text-text-strong">{segment.label}</span>
        <span className="text-text-secondary">{formatCount(segment.size)} areas · about {formatCount(segment.averageVendors)} Vendors, {formatCount(segment.averageBuyers)} Buyers, {formatCount(segment.averageOrders)} orders and {formatCompactCentavos(segment.averageGmvCentavos)} GMV each</span>
        <span className="text-xs text-text-secondary">e.g. {segment.examples.join(', ')}</span></li>)}</ul>
      <div className="grid items-stretch gap-4 lg:grid-cols-2">
        <div className="grid gap-2"><h3 className="text-sm font-semibold text-text-strong">Recruitment signals</h3><p className="text-xs text-text-secondary">Most confirmed orders per active Vendor placed in the area.</p>
          <BarList label="Recruitment signals" empty="No area has visible orders yet." colorVar="--mp-viz-series-2" items={areas.recruitment.map(item => ({ key: item.code, label: item.name, value: item.ordersPerVendor, display: `${formatCount(item.ordersPerVendor)} per Vendor`, detail: `${formatCount(item.orders)} orders · ${formatCount(item.vendors)} active Vendors` }))} /></div>
        <div className="grid gap-2"><h3 className="text-sm font-semibold text-text-strong">Unusual areas</h3><p className="text-xs text-text-secondary">Supply and demand far from every other area (DBSCAN noise).</p>
          {areas.unusual.length === 0 ? <p className="text-sm text-text-secondary">No area stands apart from the others.</p>
            : <ul className="divide-y divide-border-default text-sm">{areas.unusual.map(item => <li key={item.code} className="flex justify-between gap-3 py-2"><span className="font-semibold text-text-strong">{item.name}</span><span className="text-text-secondary">{formatCount(item.vendors)} Vendors · {formatCount(item.orders)} orders</span></li>)}</ul>}</div>
      </div>
      <MethodNote>Clustering: K-Means on standardized active Vendors, registered Buyers, confirmed orders and gross sales, with the number of groups chosen by the best silhouette score{areas.silhouette !== null && areas.silhouette !== undefined ? ` (${areas.silhouette.toFixed(2)})` : ''}. DBSCAN marks isolated areas. {formatCount(areas.considered)} areas grouped; {formatCount(areas.excludedSuppressed)} with a suppressed cell left out. Segments describe patterns, not merit.</MethodNote>
    </div>}
  </DashboardPanel>
}

export function VendorHealthPanel({ health }: { health: AdminDashboardVendorHealth }) {
  const segments = health.segments
  return <div className="grid gap-4">
    <DashboardPanel density="compact" title="Vendor health indicator" description={`${formatCount(health.total)} active Tier 2 Vendors, classified by the System Workflow thresholds.`}
      action={<Link to="/scores" className="inline-flex min-h-11 items-center gap-1 text-sm font-semibold text-action-primary">Score Monitoring<ArrowRight size={14} aria-hidden="true" /></Link>}>
      <div className="grid gap-3">
        <ShareBar variant="donut" label="Vendors by health indicator" empty="No active Vendors yet." segments={health.classes.map(item => ({ key: item.key, label: item.label, value: item.count, colorVar: CLASS_SLOTS[item.key] ?? '--mp-viz-series-1' }))} />
        {health.attention.length > 0 && <ul className="divide-y divide-border-default">{health.attention.map(vendor => <li key={vendor.vendorId} className="grid gap-1 py-3">
          <div className="flex flex-wrap items-center justify-between gap-2"><Link to={`/scores/${vendor.vendorId}`} className="text-sm font-semibold text-text-strong hover:text-action-primary">{vendor.storeName}</Link><IndicatorClassBadge value={vendor._class} label={vendor.label} /></div>
          <p className="text-xs text-text-secondary">VPS {vendor.vps ?? '—'} · OHS {vendor.ohs ?? '—'} · {vendor.reasons.join(' ')}</p></li>)}</ul>}
        <MethodNote>Classification: a fixed decision tree using only published scores and the System Workflow thresholds (VPS below 3.00 or OHS below 2.50, then any OHS metric outside its no-penalty band). It creates no flag, warning or sanction; enforcement remains a reasoned Admin decision.</MethodNote>
      </div>
    </DashboardPanel>
    <AnalyticsDetails title="Vendor performance groups">
    <DashboardPanel density="compact" title="Vendor performance segments" description="Vendors with a published VPS, grouped by score and volume.">
      {segments.state !== 'OK' ? <ShareBar label="Vendors by performance segment" segments={[]} empty={segments.reason ?? 'No Vendor performance segments in this period.'} /> : <div className="grid gap-3">
        <ShareBar label="Vendors by performance segment" empty="No Vendor performance segments in this period." segments={segments.segments.map((segment, index) => ({ key: String(segment.id), label: segment.label, value: segment.size, colorVar: SLOTS[index % SLOTS.length]! }))} />
        <ul className="grid gap-4 sm:grid-cols-2">{segments.segments.map((segment, index) => <li key={segment.id} className="grid gap-1 border-l-4 pl-4 text-sm" style={{ borderColor: `var(${SLOTS[index % SLOTS.length]})` }}>
          <span className="font-semibold text-text-strong">{segment.label}</span>
          <span className="text-text-secondary">{formatCount(segment.size)} Vendors · VPS {segment.averageVps.toFixed(2)} · OHS {segment.averageOhs.toFixed(2)} · {formatCount(segment.averageCompletedOrders)} completed orders (90 days)</span></li>)}</ul>
        <MethodNote>K-Means on standardized VPS, OHS and completed orders; groups chosen by the best silhouette score{segments.silhouette !== null && segments.silhouette !== undefined ? ` (${segments.silhouette.toFixed(2)})` : ''}. {formatCount(segments.considered)} Vendors considered.</MethodNote>
      </div>}
    </DashboardPanel>
    </AnalyticsDetails>
  </div>
}

/** Current account snapshots and selected-period money retain their independent permissions and disclosure rules. */
export function AdminOverviewKpis({ activeBuyers, activeVendors, inactiveVendors, marketplace, previousMarketplace, range, platformEarningsCentavos, platformEarningsUnavailableReason, platformEarningsChangePercent, platformEarningsComparisonUnavailable = 'Previous period comparison unavailable.', marketplaceUnavailableReason }: {
  activeBuyers: number | null; activeVendors: number | null; inactiveVendors: number | null; marketplace: AdminDashboardMarketplace | null; range: CalendarRange;
  platformEarningsCentavos: number | null; platformEarningsUnavailableReason: string; marketplaceUnavailableReason: string;
  platformEarningsChangePercent?: number | null; platformEarningsComparisonUnavailable?: string; previousMarketplace?: AdminDashboardMarketplace | null;
}) {
  const count = (value: number | null) => (value === null ? '—' : formatCount(value))
  const periodDays = Math.round((Date.parse(range.to) - Date.parse(range.from)) / 86_400_000) + 1
  const comparison = `vs previous ${periodDays} ${periodDays === 1 ? 'day' : 'days'}`
  const net = marketplace?.kpis.netGmvCentavos
  const previousNet = previousMarketplace?.kpis.netGmvCentavos
  const netComparisonUnavailable = net?.suppressed || previousNet?.suppressed ? 'Hidden by privacy controls.' : previousNet?.value === 0 ? 'No net marketplace value in the previous period.' : 'Previous period comparison unavailable.'
  return <AnalyticsSummary density="compact" context={`Amounts: ${formatChartDay(range.from)} – ${formatChartDay(range.to)} · Asia/Manila`} featured={
    { label: 'Platform earnings', value: formatPesoCentavos(platformEarningsCentavos), hint: platformEarningsCentavos === null ? platformEarningsUnavailableReason : 'Net collected commissions · TEST.', icon: <Wallet size={17} aria-hidden="true" />, changePercent: platformEarningsCentavos === null ? null : platformEarningsChangePercent, comparison, ...(platformEarningsCentavos === null ? {} : { comparisonUnavailable: platformEarningsComparisonUnavailable }), calculation: <><p><strong>Net collected commissions</strong> = verified Vendor commission payments allocated to monthly bills − confirmed commission refunds. Uses the same selected-period total as the Platform earnings chart.</p><p>Payments and refunds use their respective event dates in Asia/Manila. Unpaid bills, pending or failed payments and unallocated overpayments are excluded. Recorded TEST transactions only.</p><p>Collections include applicable fee VAT and are before platform processing costs. They are separate from accrued Net platform earnings, Buyer payments and marketplace sales.</p><p>Percentage change compares this total with the immediately preceding {periodDays}-day period. A zero, negative or unavailable previous total has no percentage comparison.</p></> }
  } metrics={[
    { label: 'Net marketplace value', value: net ? cellText(net, formatPesoCentavos) : '—', hint: marketplace ? 'After cancellations and completed refunds.' : marketplaceUnavailableReason, icon: <ShoppingCart size={16} aria-hidden="true" />, changePercent: dashboardMetricChange(net, previousNet), comparison, ...(marketplace ? { comparisonUnavailable: netComparisonUnavailable } : {}), calculation: <><p><strong>Net marketplace value</strong> = confirmed commercial order value − cancelled order value − completed refund deductions, without deducting cancellation refunds twice. Uses the same net total as the Marketplace value chart.</p><p>Orders use their confirmation date within the selected dates in Asia/Manila. E-wallet transaction fees are excluded. This is marketplace sales value, separate from platform commissions. Values below the privacy threshold stay suppressed.</p><p>Percentage change compares visible totals with the immediately preceding {periodDays}-day period. A zero or unavailable previous total has no percentage comparison; a suppressed total cannot produce a percentage.</p></> },
    { label: 'Active Buyers', value: count(activeBuyers), hint: activeBuyers === null ? 'Outside your role scope.' : 'Buyer accounts with ACTIVE status.', icon: <Users size={16} aria-hidden="true" />, calculation: <p>Current Buyer accounts with ACTIVE status, within your directory permissions. This account snapshot does not change with the selected activity dates and is separate from meaningful Buyer activity below.</p> },
    { label: 'Active Tier 2 Vendors', value: count(activeVendors), hint: activeVendors === null ? 'Outside your role scope.' : `Active account and activated store${inactiveVendors === null ? '' : ` · ${formatCount(inactiveVendors)} more stores not yet active`}.`, icon: <Store size={16} aria-hidden="true" />, calculation: <p>Current Tier 2 Vendors with an active account and an activated store, within your directory permissions. Stores not yet active are shown separately. This snapshot does not change with the selected activity dates.</p> },
  ]} />
}

export function ActiveUsersPanel({ marketplace }: { marketplace: AdminDashboardMarketplace }) {
  const [view, setView] = useState('daily')
  const users = marketplace.kpis.activeUsers
  const points = marketplace.activity
  const labels = points.map(point => day(point.date))
  const count = (value: number | null | undefined) => formatCount(value ?? 0)
  const chart = (title: string, buyers: (number | null)[], vendors: (number | null)[], variant: 'bar' | 'line') => <TrendLineChart integerAxis variant={variant} title={title} labels={labels} formatLabel={formatChartDay} formatValue={value => formatCount(Math.round(value))} emptyReason="Every day is below the small-cell threshold or has no activity."
    series={[{ key: 'buyers', label: 'Buyers', colorVar: '--mp-viz-series-1', values: buyers }, { key: 'vendors', label: 'Vendor users', colorVar: '--mp-viz-series-2', values: vendors }]} />
  const endingDay = labels.at(-1)
  return <DashboardPanel wide density="compact" title="Active Buyers and Vendor users" description="Distinct people taking a meaningful action, shown separately for each group." calculation={<>
    <p>Daily, 7-day and 30-day counts are distinct people in each window ending on the last day shown{endingDay ? ` (${formatChartDay(endingDay)})` : ''}. A person can appear in more than one window; do not add the figures together.</p>
    <p>Buyers qualify by submitting an order, accepting or countering a quotation, or confirming/reporting fulfillment. Vendor users qualify through a human operational action such as publishing a quotation, manually confirming an order or recording fulfillment.</p>
    <p>App opens, page views, automated jobs and auto-accept never count. {marketplace.disclosure.description} Suppressed counts remain hidden and appear as gaps in the charts; a recorded zero stays zero.</p>
    <p>The charts follow the selected dates in Asia/Manila. Rolling 30-day activity uses the 30-day window ending on each plotted date.</p>
  </>}>
    <div className="grid min-w-0 gap-4">
      <div className="grid min-w-0 gap-4 rounded-control bg-surface-canvas p-3 sm:grid-cols-2 sm:gap-6 sm:p-4">
        {([['Buyers', users.buyer, Users], ['Vendor users', users.vendor, Store]] as const).map(([label, group, Icon]) => <section key={label} aria-label={`${label} activity`} className="min-w-0">
          <h3 className="flex items-center gap-2 text-xs font-semibold text-text-strong"><Icon size={16} aria-hidden="true" />{label}</h3>
          <dl className="mt-3 grid min-w-0 grid-cols-3 gap-2">{([['Daily', group.dau], ['7 days', group.wau], ['30 days', group.mau]] as const).map(([period, cell]) => <div key={period} className="min-w-0">
            <dt className="text-xs text-text-secondary">{period}</dt>
            <dd className={`mt-1 break-words font-semibold tabular-nums text-text-strong ${cell.suppressed ? 'text-xs leading-5' : 'text-xl leading-6'}`} title={cell.suppressed ? cell.reason ?? 'Below the privacy threshold.' : undefined}>{cellText(cell, formatCount)}</dd>
          </div>)}</dl>
        </section>)}
      </div>
      <p className="text-xs leading-5 text-text-secondary">{endingDay ? `Windows ending ${formatChartDay(endingDay)} · ` : ''}Small counts are suppressed for privacy.</p>
      <FilterTabs appearance="tabs" label="Activity window" value={view} onChange={setView} chips={[{ value: 'daily', label: 'Daily activity' }, { value: 'monthly', label: '30-day activity' }]} />
      {view === 'daily' ? chart('Daily active Buyers and Vendor users', points.map(point => point.buyerDau ?? null), points.map(point => point.vendorDau ?? null), 'bar')
        : chart('Rolling 30-day active Buyers and Vendor users', points.map(point => point.buyerMau ?? null), points.map(point => point.vendorMau ?? null), 'line')}
      <ChartDataTable caption="Active Buyers and Vendor users per day" rowHeader="Date" rows={labels.map(formatChartDay)} columns={[
        { key: 'buyer_dau', header: 'Buyers (daily)', values: points.map(point => (point.buyerDau == null ? 'Suppressed' : count(point.buyerDau))) },
        { key: 'vendor_dau', header: 'Vendor users (daily)', values: points.map(point => (point.vendorDau == null ? 'Suppressed' : count(point.vendorDau))) },
        { key: 'buyer_mau', header: 'Buyers (30 days)', values: points.map(point => (point.buyerMau == null ? 'Suppressed' : count(point.buyerMau))) },
        { key: 'vendor_mau', header: 'Vendor users (30 days)', values: points.map(point => (point.vendorMau == null ? 'Suppressed' : count(point.vendorMau))) },
      ]} />
    </div>
  </DashboardPanel>
}

export function CaseRatesPanel({ marketplace }: { marketplace: AdminDashboardMarketplace }) {
  const k = marketplace.kpis
  return <dl className="mp-card-group grid gap-3 sm:grid-cols-2 xl:grid-cols-4">
    <KpiCard density="compact" label="Dispute rate" value={rateText(k.disputeRate)} hint={rateHint(k.disputeRate, 'confirmed orders')} icon={<Scale size={16} aria-hidden="true" />} accent />
    <KpiCard density="compact" label="Cancellation rate" value={rateText(k.cancellationRate)} hint={rateHint(k.cancellationRate, 'confirmed orders')} icon={<Undo2 size={16} aria-hidden="true" />} />
    <KpiCard density="compact" label="Median Vendor response" value={k.responseTime.suppressed ? 'Suppressed' : formatDurationSeconds(k.responseTime.medianSeconds)} hint={k.responseTime.suppressed ? (k.responseTime.reason ?? '') : `Mean ${formatDurationSeconds(k.responseTime.meanSeconds)} · 90th percentile ${formatDurationSeconds(k.responseTime.p90Seconds)}.`} icon={<Clock size={16} aria-hidden="true" />} />
    <KpiCard density="compact" label="Monthly active Buyers" value={cellText(k.activeUsers.buyer.mau, value => formatCount(value))} hint={`${cellText(k.activeUsers.vendor.mau, value => formatCount(value))} monthly active Vendor users.`} icon={<Users size={16} aria-hidden="true" />} />
  </dl>
}

/** Queue counts as one ranked chart above the queue cards, so the heaviest queue is obvious at a glance. */
export function QueueLoadChart({ queues = [], groups }: { queues?: OperationsQueue[] | undefined; groups?: string[] }) {
  const visible = (groups ? queues.filter(queue => groups.includes(queue.group)) : queues).filter(queue => queue.count > 0).sort((a, b) => b.count - a.count)
  return <DashboardPanel density="compact" title="Queue load" description="Pending items per queue within your permissions.">
    <BarList label="Queue load" empty="Every queue in your scope is clear." colorVar="--mp-viz-series-2" items={visible.map(queue => ({ key: queue.key, label: queue.label, value: queue.count, display: formatCount(queue.count), detail: queue.group }))} />
  </DashboardPanel>
}

export function MarketplaceUnavailable({ reason, allowed }: { reason: string | null | undefined; allowed: boolean }) {
  return <InfoNote>{allowed ? (reason ?? 'Marketplace insights are unavailable right now.') : 'Marketplace charts and forecasts need aggregate analytics access (analytics.view_aggregates).'}</InfoNote>
}

export function CategoryDemandCard({ marketplace }: { marketplace: AdminDashboardMarketplace }) {
  const categories = marketplace.categories
  return <DashboardPanel density="compact" title="Category demand" description="Top categories by confirmed orders" calculation={<p>Counts are confirmed orders containing the category. An order can appear in more than one category. The donut totals matches across the shown categories; its shares use that total. Categories below {categories.minimumBuyers} distinct Buyers are suppressed.</p>}>
    <ShareBar variant="donut" totalLabel="Shown matches" label="Category demand" empty="No category demand above the small-cell threshold in this period." segments={categories.demand.slice(0, 4).map((item, index) => ({ key: item.category, label: item.category, value: item.orders, colorVar: SLOTS[index % SLOTS.length]! }))} />
    {categories.suppressedCategories > 0 && <p className="mp-analytics-note mt-2">{formatCount(categories.suppressedCategories)} categories below the privacy threshold are not shown.</p>}
  </DashboardPanel>
}

export function VendorHealthOverview({ health }: { health: AdminDashboardVendorHealth }) {
  return <DashboardPanel density="compact" title="Vendor health" description="Active Tier 2 stores by operational standing" calculation={<p>Classification uses published System Workflow thresholds. It creates no flag, sanction or performance badge.</p>}>
    <ShareBar variant="donut" label="Vendors by health indicator" empty="No active Vendors yet." segments={health.classes.map(item => ({ key: item.key, label: item.label, value: item.count, colorVar: CLASS_SLOTS[item.key] ?? '--mp-viz-series-1' }))} />
  </DashboardPanel>
}

export function UserPopulationPanel({ buyers, vendors }: { buyers: number | null; vendors: number | null }) {
  const groups = [{ key: 'buyers', label: 'Buyer accounts', value: buyers }, { key: 'vendors', label: 'Tier 2 Vendor stores', value: vendors }]
  return <DashboardPanel density="compact" title="Marketplace participants" description="Current active accounts and stores, by participant type." calculation={<p>Buyer accounts have ACTIVE status. Tier 2 Vendors have both an active account and an activated store. Vendor stores and individual people are different units, so these counts are shown separately. The center counts records: one active Buyer account or one activated Tier 2 store is one record. This current snapshot is independent of the selected activity dates; it excludes Admins and unactivated stores. Shares are available only when both groups are in your role scope.</p>}>
    {buyers !== null && vendors !== null ? <ShareBar variant="donut" totalLabel="Records" label="Active marketplace participants by type" empty="No active participants in your scope." segments={groups.map((group, index) => ({ key: group.key, label: group.label, value: group.value ?? 0, colorVar: SLOTS[index % SLOTS.length]! }))} />
      : <dl className="grid gap-3 text-sm">{groups.filter(group => group.value !== null).map(group => <div key={group.key} className="flex justify-between gap-3"><dt>{group.label}</dt><dd className="font-semibold tabular-nums">{formatCount(group.value)}</dd></div>)}</dl>}
    {groups.filter(group => group.value === null).map(group => <p key={group.key} className="mt-2 text-xs text-text-secondary">{group.label}: outside your role scope.</p>)}
    <p className="mt-4 text-xs text-text-secondary">Account status snapshot · activity trends below follow the selected dates.</p>
  </DashboardPanel>
}

/** Derived only from visible aggregates; never reconstruct a suppressed amount or count. */
export function MarketplacePerformancePanel({ marketplace }: { marketplace: AdminDashboardMarketplace }) {
  const k = marketplace.kpis
  const hidden = k.grossGmvCentavos.suppressed || k.orderVolume.suppressed
  const gross = k.grossGmvCentavos.value, orders = k.orderVolume.value
  const average = hidden ? 'Suppressed' : gross == null || orders == null || orders === 0 ? '—' : formatPesoCentavos(Math.round(gross / orders))
  return <DashboardPanel density="compact" title="Marketplace at a glance" description="Order size and fulfillment for the selected dates." calculation={<>
    <p>Average confirmed order value = gross sales ÷ confirmed Vendor child orders, rounded to the nearest centavo for display. It uses the same period and exclusions as Marketplace value. With no confirmed orders the average is unavailable; if either input is suppressed, the average is also suppressed.</p>
    <p>Fulfillment rate = eligible orders completed by the reporting cutoff ÷ confirmed orders due for fulfillment in the period. Cancellation rate = confirmed orders finalized as cancelled ÷ eligible confirmed orders. Each rate uses its own eligible cohort; they do not add up to 100%.</p>
    <p>{marketplace.disclosure.description}</p>
  </>}>
    <dl className="grid grid-cols-2 gap-4 border-b border-border-default pb-4">
      <div><dt className="text-xs text-text-secondary">Average confirmed order value</dt><dd className="mt-2 text-xl font-semibold tabular-nums text-text-strong">{average}</dd></div>
      <div><dt className="text-xs text-text-secondary">Confirmed orders</dt><dd className="mt-2 text-xl font-semibold tabular-nums text-text-strong">{cellText(k.orderVolume, formatCount)}</dd></div>
    </dl>
    <ul className="mt-4 grid gap-4" aria-label="Marketplace order rates">{([['Fulfillment rate', k.fulfillmentRate, '--mp-viz-success'], ['Cancellation rate', k.cancellationRate, '--mp-viz-warning']] as const).map(([label, item, color]) => {
      const percent = !item.suppressed && item.percent != null ? Number(item.percent) : null
      return <li key={label} className="grid gap-1.5"><div className="flex justify-between gap-3 text-xs"><span className="font-medium">{label}</span><span className="tabular-nums">{rateText(item)}</span></div>
        {percent !== null && Number.isFinite(percent) && <div aria-hidden="true" className="h-1.5 overflow-hidden rounded-full bg-surface-canvas"><div className="h-full rounded-full" style={{ width: `${Math.max(0, Math.min(100, percent))}%`, background: `var(${color})` }} /></div>}
        <p className="text-xs text-text-secondary">{rateHint(item, label === 'Fulfillment rate' ? 'orders due' : 'confirmed orders')}</p></li>
    })}</ul>
  </DashboardPanel>
}
