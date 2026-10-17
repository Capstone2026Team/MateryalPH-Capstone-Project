import { useCallback, useEffect, useState, type ReactNode } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import { AlertTriangle, ArrowRight, Boxes, CheckCircle2, ClipboardList, Clock, PackageCheck, Scale, ShoppingCart, Undo2, Wallet } from 'lucide-react'
import {
  ActiveFilters, ALL_DATES, AssociationRuleList, BarList, Button, ChartDataTable, DashboardPanel, DateFilter, ForecastNote, IndicatorClassBadge, InfoNote, KpiCard, MethodNote, ScoreTile, SectionWorkspace,
  SegmentScatter, ShareBar, StatusMessage, TrendLineChart, analyticsDay, disputeIssueLabel, disputeStateLabel, formatChartDay, formatCompactCentavos, formatCount, formatDurationSeconds,
  dateFilterLabel, formatManilaDateTime, formatPesoCentavos, orderStateLabel, useAutomaticRefresh, usePortalResource, type ForecastView, type ShareSegment, type TrendMarker, type VizColor,
} from '@materyalph/web-ui'
import type { DashboardAction, DashboardForecast, DashboardRate, VendorDashboardOrders } from '@materyalph/api-client-ts'
import { getVendorDashboardInsights, type VendorDashboardInsights } from '../lib/dashboard-api'
import { readableApiError } from '../lib/auth-api'
import { dateRangeFromParams, dateRangePatch } from '../lib/date-filters'

const SLOTS: VizColor[] = ['--mp-viz-series-1', '--mp-viz-series-2', '--mp-viz-series-3', '--mp-viz-series-4', '--mp-viz-series-5', '--mp-viz-series-6']
const TYPE_LABELS: Record<string, string> = { ITEM_BASED: 'Item-Based', PROJECT_BASED: 'Project-Based', DELIVERY: 'Delivery', PICKUP: 'Self-Pickup', ONLINE: 'Online payment', CASH_ON_DELIVERY: 'Cash on Delivery', IN_STORE: 'In-Store Payment' }
const CONVERTS_FROM: Record<string, string> = { CONFIRMED: 'ORDER_REQUESTS', COMPLETED: 'CONFIRMED' }
const typeLabel = (key: string) => TYPE_LABELS[key] ?? key.toLowerCase().replaceAll('_', ' ')
const rateText = (rate: DashboardRate) => (rate.percent === null || rate.percent === undefined ? '—' : `${rate.percent}%`)
const rateHint = (rate: DashboardRate, noun: string) => (rate.denominator === 0 ? `No ${noun} in this period.` : `${formatCount(rate.numerator)} of ${formatCount(rate.denominator)} ${noun}.`)
const day = (value: Date | string) => analyticsDay(value) ?? ''

function forecastView(forecast: DashboardForecast): ForecastView {
  return { state: forecast.state, direction: forecast.direction, changePercent: forecast.changePercent ?? null, expectedTotal: forecast.expectedTotal ?? null, points: forecast.points,
    weekdayStrength: forecast.weekdayStrength ?? null, observedDays: forecast.observedDays }
}

/**
 * The live Vendor Dashboard: one request per period returns every section the member's fixed role may see. A section
 * without its grant arrives as null and is explained, never shown empty. Peso values are Owner-only.
 */
export function VendorInsightsWorkspace({ overviewFooter, overviewAside, canViewProductAnalytics = false }: { overviewFooter?: ReactNode; overviewAside?: ReactNode; canViewProductAnalytics?: boolean }) {
  const [params, setParams] = useSearchParams()
  const range = dateRangeFromParams(params)
  const loader = useCallback(() => getVendorDashboardInsights({ ...(range.from ? { from: range.from } : {}), ...(range.to ? { to: range.to } : {}) }), [range.from, range.to])
  const { data, error, pending, refresh } = usePortalResource(`vendor-dashboard-insights-${range.from}-${range.to}`, loader)
  const changeDates = (nextRange: typeof range) => setParams(current => { const next = new URLSearchParams(current); for (const [key, value] of Object.entries(dateRangePatch(nextRange))) { if (value) next.set(key, value); else next.delete(key) } return next }, { replace: true })
  const [message, setMessage] = useState<string | null>(null)
  useEffect(() => {
    let active = true
    setMessage(null)
    if (error) void readableApiError(error).then(text => { if (active) setMessage(text) })
    return () => { active = false }
  }, [error])
  useAutomaticRefresh(refresh, { enabled: !pending, intervalMs: error ? 120_000 : 60_000 })

  const toolbar = <div className="grid gap-3"><div className="flex flex-wrap items-center justify-between gap-3">
    <DateFilter title="Dashboard dates" value={range} disabled={pending && !data} onChange={changeDates} />
    {data && <p className="text-xs text-text-secondary">Updated {formatManilaDateTime(data.generatedAt)} · {formatChartDay(day(data.period.from))} – {formatChartDay(day(data.period.to))}</p>}
  </div><ActiveFilters filters={range.from || range.to ? [{ key: 'dates', label: dateFilterLabel(range), onRemove: () => changeDates(ALL_DATES) }] : []} onClear={() => changeDates(ALL_DATES)} /></div>
  if (!data) return <div className="space-y-5">{toolbar}
    {message ? <div className="space-y-3"><StatusMessage tone="error">{message}</StatusMessage><Button variant="secondary" onClick={() => void refresh()}>Retry</Button></div>
      : <p role="status" className="text-sm text-text-secondary">Loading your store dashboard…</p>}
    {overviewAside}
    {overviewFooter}
  </div>
  const periodLabel = `previous ${data.period.days} days`
  return <div className="space-y-5">
    {toolbar}
    {message && <StatusMessage tone="error">{message} Showing the last successful update.</StatusMessage>}
    <SectionWorkspace dashboard sections={[
      { label: 'Overview', content: <OverviewSection data={data} periodLabel={periodLabel} footer={overviewFooter} aside={overviewAside} /> },
      { label: 'Performance', content: <PerformanceSection data={data} /> },
      { label: 'Action Items & Alerts', content: <ActionsSection data={data} /> },
      { label: 'Sales & Revenue', content: <SalesSection data={data} periodLabel={periodLabel} productAnalytics={canViewProductAnalytics} /> },
      { label: 'Traffic & Volume', content: <TrafficSection data={data} productAnalytics={canViewProductAnalytics} /> },
      { label: 'Disputes & Quality', content: <QualitySection data={data} /> },
    ]} />
  </div>
}

function OverviewSection({ data, periodLabel, footer, aside }: { data: VendorDashboardInsights; periodLabel: string; footer: ReactNode; aside: ReactNode }) {
  const orders = data.orders
  const awaiting = data.actions.find(action => action.key === 'ORDER_CONFIRMATION')
  const assigned = data.actions.find(action => action.key === 'ASSIGNED_FULFILLMENT')
  return <>
    <dl className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
      {awaiting && <KpiCard label="Order requests awaiting decision" value={formatCount(awaiting.count)} hint={awaiting.detail ?? 'Decide within the Vendor-response window.'} icon={<ClipboardList size={16} aria-hidden="true" />} accent />}
      {assigned && <KpiCard label="Orders assigned to you" value={formatCount(assigned.count)} hint="Open fulfillment work in your name." icon={<PackageCheck size={16} aria-hidden="true" />} accent />}
      {orders && <KpiCard label="Orders confirmed" value={formatCount(orders.kpis.orderVolume.value)} delta={{ changePercent: orders.kpis.orderVolume.changePercent, periodLabel }} sparkline={orders.series.map(point => point.orders)} icon={<ShoppingCart size={16} aria-hidden="true" />} />}
      {orders && (orders.kpis.grossSalesCentavos
        ? <KpiCard label="Gross sales" value={formatPesoCentavos(orders.kpis.grossSalesCentavos.value)} delta={{ changePercent: orders.kpis.grossSalesCentavos.changePercent, periodLabel }} sparkline={orders.series.map(point => point.grossSalesCentavos ?? null)} icon={<Wallet size={16} aria-hidden="true" />} hint="Before cancellations, returns and refunds." />
        : <KpiCard label="Fulfillment rate" value={rateText(orders.kpis.fulfillmentRate)} hint={rateHint(orders.kpis.fulfillmentRate, 'orders due')} icon={<PackageCheck size={16} aria-hidden="true" />} />)}
      {orders && <KpiCard label="Median response time" value={formatDurationSeconds(orders.kpis.responseTime.medianSeconds)} icon={<Clock size={16} aria-hidden="true" />}
        hint={orders.kpis.responseTime.answered + orders.kpis.responseTime.unanswered === 0 ? 'No order requests in this period.' : `90th percentile ${formatDurationSeconds(orders.kpis.responseTime.p90Seconds)} · ${formatCount(orders.kpis.responseTime.unanswered)} awaiting a first decision.`} />}
      {data.stock && !orders && <KpiCard label="Variants out of stock" value={formatCount(data.stock.outOfStock)} hint={`${formatCount(data.stock.limitedStock)} at or below their reorder level.`} icon={<Boxes size={16} aria-hidden="true" />} />}
    </dl>
    <div className="grid items-start gap-5 xl:grid-cols-3">
      <div className="min-w-0 xl:col-span-2">{orders ? <OrdersTrendPanel orders={orders} /> : <DashboardPanel title="Store-wide order trends"><p className="text-sm text-text-secondary">Store-wide order measures are available to the Owner, Store Manager, Store Staff and Customer Service. Your dashboard shows the work assigned to your role.</p></DashboardPanel>}</div>
      <div className="min-w-0 space-y-5">
        <DashboardPanel title="Priority actions" description="Work waiting for your role, most urgent first."><ActionList actions={data.actions} compact /></DashboardPanel>
        {aside}
      </div>
    </div>
    {orders && <DashboardPanel title="Incoming order requests" description="Oldest response deadline first." action={<Link to="/orders" className="inline-flex min-h-11 items-center gap-1 text-sm font-semibold text-action-primary">All orders<ArrowRight size={14} aria-hidden="true" /></Link>}>
      {orders.incoming.length === 0 ? <p className="text-sm text-text-secondary">No order requests are waiting for a decision. You’re all caught up.</p>
        : <ul className="divide-y divide-border-default">{orders.incoming.map(order => <li key={order.orderId}><Link to={`/orders/${order.orderId}`} className="flex min-h-11 flex-wrap items-center justify-between gap-3 py-3 hover:text-action-primary">
          <span className="min-w-0"><span className="block text-sm font-semibold text-text-strong">{order.reference}</span><span className="block text-xs text-text-secondary">{formatCount(order.lineCount)} {order.lineCount === 1 ? 'item' : 'items'} · {typeLabel(order.procurementType)} · {typeLabel(order.fulfillmentMethod)}</span></span>
          <span className="text-right"><span className="block text-sm font-semibold tabular-nums text-text-strong">{formatPesoCentavos(order.totalCentavos)}</span>{order.dueAt && <span className="block text-xs text-text-secondary">Decide by {formatManilaDateTime(order.dueAt)}</span>}</span>
        </Link></li>)}</ul>}
    </DashboardPanel>}
    {footer}
  </>
}

function OrdersTrendPanel({ orders }: { orders: VendorDashboardOrders }) {
  const labels = orders.series.map(point => day(point.date))
  const forecast = orders.forecast.orders
  const markers: TrendMarker[] = orders.unusualDays.days.map(item => ({ index: labels.indexOf(day(item.date)), label: 'Unusual day' })).filter(marker => marker.index >= 0)
  return <DashboardPanel title="Orders and 7-day forecast" description="Confirmed orders per day with order requests received; the shaded region is a forecast.">
    <div className="grid gap-4">
      <TrendLineChart title="Orders confirmed per day" labels={labels} formatLabel={formatChartDay} formatValue={value => formatCount(Math.round(value * 10) / 10)} emptyReason="No orders in this period."
        series={[{ key: 'orders', label: 'Orders confirmed', colorVar: '--mp-viz-series-1', values: orders.series.map(point => point.orders), kind: 'bar' }, { key: 'requests', label: 'Order requests', colorVar: '--mp-viz-series-2', values: orders.series.map(point => point.orderRequests) }]}
        forecast={forecast.state === 'OK' ? { label: 'Forecast', labels: forecast.points.map(point => day(point.date)), values: forecast.points.map(point => point.value), lower: forecast.points.map(point => point.lower), upper: forecast.points.map(point => point.upper) } : null}
        markers={markers} />
      <ForecastNote forecast={forecastView(forecast)} horizonDays={orders.forecast.horizonDays} unit="orders" formatValue={value => formatCount(Math.round(value))} />
      <ChartDataTable caption="Orders per day" rowHeader="Date" rows={labels.map(formatChartDay)} columns={[
        { key: 'orders', header: 'Orders confirmed', values: orders.series.map(point => formatCount(point.orders)) },
        { key: 'requests', header: 'Order requests', values: orders.series.map(point => formatCount(point.orderRequests)) },
        { key: 'average', header: '7-day average', values: orders.series.map(point => point.ordersAverage === null || point.ordersAverage === undefined ? null : formatCount(point.ordersAverage)) },
      ]} />
      <MethodNote>Time-series analysis: a least-squares trend plus a weekday pattern is fitted to up to 90 days of confirmed orders; the band is a 95% prediction range. Diamonds mark unusual days found by DBSCAN density clustering. Estimates support planning only and never change a score, price or ranking.</MethodNote>
    </div>
  </DashboardPanel>
}

export function ActionList({ actions, compact = false }: { actions: DashboardAction[]; compact?: boolean }) {
  if (actions.length === 0) return <p className="text-sm text-text-secondary">No action items apply to your role.</p>
  const sorted = [...actions].sort((a, b) => Number(b.count > 0) - Number(a.count > 0) || Number(b.severity === 'ALERT') - Number(a.severity === 'ALERT') || b.count - a.count)
  const visible = compact ? sorted.slice(0, 5) : sorted
  return <ul className="divide-y divide-border-default">{visible.map(action => {
    const Icon = action.count === 0 ? CheckCircle2 : action.severity === 'ALERT' ? AlertTriangle : ClipboardList
    return <li key={action.key}><Link to={action.href} className="flex min-h-11 items-start gap-3 py-3 first:pt-0 hover:text-action-primary">
      <Icon size={18} className={`mt-0.5 shrink-0 ${action.count === 0 ? 'text-status-success' : action.severity === 'ALERT' ? 'text-status-error' : 'text-action-primary'}`} aria-hidden="true" />
      <span className="min-w-0 flex-1"><span className="block text-sm font-semibold text-text-strong">{action.label}</span>
        <span className="block text-xs text-text-secondary">{action.count === 0 ? 'Nothing waiting.' : action.severity === 'ALERT' ? 'Needs attention now.' : 'Waiting for action.'}{action.detail ? ` ${action.detail}` : ''}</span></span>
      <span className={`rounded-pill px-2 text-sm font-semibold tabular-nums ${action.count > 0 ? 'bg-brand-orange-50 text-action-primary' : 'bg-surface-canvas text-text-secondary'}`}>{formatCount(action.count)}</span>
    </Link></li>
  })}</ul>
}

function PerformanceSection({ data }: { data: VendorDashboardInsights }) {
  const performance = data.performance
  const orders = data.orders
  if (!performance && !orders) return <InfoNote>Store-wide performance is available to the Owner and Store Manager. Your attributed work appears in each module you use.</InfoNote>
  const history = performance?.history ?? []
  const historyNumber = (value: string | null | undefined) => (value === null || value === undefined ? null : Number(value))
  const bands = performance?.classification.bands ?? {}
  const operations = (performance?.operations ?? null) as { rates?: Record<string, string>; penalties?: Record<string, string> } | null
  return <>
    {performance && <div className="grid items-start gap-5 xl:grid-cols-3">
      <DashboardPanel title="Store health indicator" description={performance.asOf ? `Scores as of ${formatChartDay(day(performance.asOf))}.` : 'Scores have not been calculated yet.'}>
        <div className="grid gap-3"><IndicatorClassBadge value={performance.classification._class} label={performance.classification.label} />
          <ul className="list-disc space-y-1 pl-5 text-sm text-text-strong">{performance.classification.path.map(reason => <li key={reason}>{reason}</li>)}</ul>
          <MethodNote>Classification: a fixed decision tree over the System Workflow thresholds (VPS below 3.00 or OHS below 2.50, then any OHS metric outside its no-penalty band). It is an indicator only and changes no score, badge, ranking or discovery.</MethodNote></div>
      </DashboardPanel>
      <div className="xl:col-span-2"><DashboardPanel title="Published scores" description="The same formulas and sample gates as Store Performance.">
        <div className="grid gap-5 sm:grid-cols-2 xl:grid-cols-4">{performance.scores.map(score => <ScoreTile key={score.key} name={score.key} value={score.value ?? null} published={score.published} sample={score.sampleCount} minimum={score.minimumSample} window={score.window} status={score.statusText} />)}</div>
        <Link to="/performance" className="mt-4 inline-flex min-h-11 items-center gap-1 text-sm font-semibold text-action-primary">Open Store Performance<ArrowRight size={14} aria-hidden="true" /></Link>
      </DashboardPanel></div>
    </div>}
    {operations?.rates && <DashboardPanel title="Operational health bands" description="Trailing 30-day OHS rates and the System Workflow penalty band each one falls in.">
      <ul className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">{(['NFR', 'LSR', 'RR', 'ODR'] as const).map(metric => <li key={metric} className="grid gap-1 border-l-2 border-border-default pl-4">
        <span className="text-xs font-semibold uppercase tracking-[0.12em] text-text-secondary">{{ NFR: 'Non-fulfillment', LSR: 'Late shipment', RR: 'Return rate', ODR: 'Order defects' }[metric]}</span>
        <span className="text-2xl font-semibold tabular-nums text-text-strong">{operations.rates?.[metric] ?? '—'}%</span>
        <span className="text-xs text-text-secondary">Band: {(bands[metric] ?? 'NONE').toLowerCase().replace('none', 'no penalty')} · penalty {operations.penalties?.[metric] ?? '0.00'}</span>
      </li>)}</ul>
    </DashboardPanel>}
    {performance && history.some(point => point.vps || point.ohs) && <DashboardPanel title="Score history" description="Daily snapshots of the published VPS and OHS (1.00–5.00).">
      <TrendLineChart title="VPS and OHS history" labels={history.map(point => day(point.date))} formatLabel={formatChartDay} formatValue={value => value.toFixed(2)} emptyReason="No published scores yet."
        series={[{ key: 'vps', label: 'VPS', colorVar: '--mp-viz-series-1', values: history.map(point => historyNumber(point.vps)) }, { key: 'ohs', label: 'OHS', colorVar: '--mp-viz-series-2', values: history.map(point => historyNumber(point.ohs)) }]} />
    </DashboardPanel>}
    {orders && <dl className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
      <KpiCard label="Fulfillment rate" value={rateText(orders.kpis.fulfillmentRate)} hint={rateHint(orders.kpis.fulfillmentRate, 'orders due')} icon={<PackageCheck size={16} aria-hidden="true" />} />
      <KpiCard label="Cancellation rate (all causes)" value={rateText(orders.kpis.cancellationRate)} hint={rateHint(orders.kpis.cancellationRate, 'confirmed orders')} icon={<Undo2 size={16} aria-hidden="true" />} />
      <KpiCard label="Dispute rate" value={rateText(orders.kpis.disputeRate)} hint={rateHint(orders.kpis.disputeRate, 'confirmed orders')} icon={<Scale size={16} aria-hidden="true" />} />
      <KpiCard label="Mean response time" value={formatDurationSeconds(orders.kpis.responseTime.meanSeconds)} hint={`Median ${formatDurationSeconds(orders.kpis.responseTime.medianSeconds)} · 90th percentile ${formatDurationSeconds(orders.kpis.responseTime.p90Seconds)}.`} icon={<Clock size={16} aria-hidden="true" />} />
    </dl>}
    {performance && performance.badgeMetrics.length > 0 && <DashboardPanel title="Badge metrics"><dl className="grid gap-4 sm:grid-cols-2">{performance.badgeMetrics.map(metric => <div key={metric.key} className="grid gap-1">
      <dt className="text-xs font-semibold text-text-secondary">{metric.key} · {metric.window}</dt><dd className="text-2xl font-semibold tabular-nums">{metric.value ? `${metric.value}%` : '—'}</dd><dd className="text-xs text-text-secondary">{metric.definition} · {formatCount(metric.sampleCount)} in sample</dd></div>)}</dl></DashboardPanel>}
  </>
}

function ActionsSection({ data }: { data: VendorDashboardInsights }) {
  const pipeline = (data.orders?.pipeline ?? []).filter(item => item.count > 0)
  const stock = data.stock
  return <>
    <DashboardPanel title="Action items" description="Every item links to the module where you act on it."><ActionList actions={data.actions} /></DashboardPanel>
    <div className="grid items-start gap-5 xl:grid-cols-2">
      {data.orders && <DashboardPanel title="Open orders by state" description="Where today’s orders are in the order journey.">
        <BarList label="Open orders by state" empty="No open orders right now." items={pipeline.map(item => ({ key: item.state, label: orderStateLabel(item.state), value: item.count, display: formatCount(item.count) }))} />
      </DashboardPanel>}
      {stock && <DashboardPanel title="Stock status" description="Available to sell = on hand − hard reserved." action={<Link to="/products/inventory" className="inline-flex min-h-11 items-center gap-1 text-sm font-semibold text-action-primary">Inventory<ArrowRight size={14} aria-hidden="true" /></Link>}>
        <div className="grid gap-4">
          <ShareBar label="Variants by stock status" empty="No active variants yet." segments={[{ key: 'in', label: 'In stock', value: stock.inStock, colorVar: '--mp-viz-series-3' }, { key: 'limited', label: 'Limited stock', value: stock.limitedStock, colorVar: '--mp-viz-series-4' }, { key: 'out', label: 'Out of stock', value: stock.outOfStock, colorVar: '--mp-viz-series-2' }]} />
          {stock.attention.length > 0 && <ul className="divide-y divide-border-default text-sm">{stock.attention.map(item => <li key={`${item.name}-${item.variant ?? ''}`} className="flex items-center justify-between gap-3 py-2">
            <span className="min-w-0"><span className="block font-semibold text-text-strong">{item.name}</span>{item.variant && <span className="block text-xs text-text-secondary">{item.variant}</span>}</span>
            <span className="text-right text-xs"><span className="inline-flex items-center gap-1 font-semibold text-text-strong">{item.status === 'OUT_OF_STOCK' ? <AlertTriangle size={14} className="text-status-error" aria-hidden="true" /> : <Clock size={14} className="text-action-primary" aria-hidden="true" />}{item.status === 'OUT_OF_STOCK' ? 'Out of stock' : 'Limited stock'}</span>
              <span className="block text-text-secondary">{item.available} available{item.reorderLevel ? ` · reorder at ${item.reorderLevel}` : ''}</span></span></li>)}</ul>}
        </div>
      </DashboardPanel>}
    </div>
  </>
}

const productAnalyticsLink = <Link to="/performance?tab=products" className="inline-flex min-h-11 items-center gap-1 text-sm font-semibold text-action-primary">Product analytics<ArrowRight size={14} aria-hidden="true" /></Link>

function SalesSection({ data, periodLabel, productAnalytics }: { data: VendorDashboardInsights; periodLabel: string; productAnalytics: boolean }) {
  const orders = data.orders
  if (!orders) return <InfoNote>Sales measures are available to the Owner, Store Manager, Store Staff and Customer Service.</InfoNote>
  const kpis = orders.kpis
  const sales = data.access.salesValue
  const labels = orders.series.map(point => day(point.date))
  const salesForecast = orders.forecast.sales
  const products = orders.products
  const markers: TrendMarker[] = orders.unusualDays.days.map(item => ({ index: labels.indexOf(day(item.date)), label: 'Unusual day' })).filter(marker => marker.index >= 0)
  const categorySegments: ShareSegment[] = products.categories.map((category, index) => ({ key: category.category, label: category.category, value: sales ? category.valueCentavos ?? 0 : category.orders, colorVar: SLOTS[index % SLOTS.length] ?? '--mp-viz-series-1' }))
  return <>
    {sales && kpis.grossSalesCentavos ? <dl className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
      <KpiCard label="Gross sales" value={formatPesoCentavos(kpis.grossSalesCentavos.value)} delta={{ changePercent: kpis.grossSalesCentavos.changePercent, periodLabel }} icon={<Wallet size={16} aria-hidden="true" />} hint="Confirmed order value before cancellations, returns and refunds." accent />
      <KpiCard label="Net sales" value={formatPesoCentavos(kpis.netSalesCentavos?.value)} delta={kpis.netSalesCentavos ? { changePercent: kpis.netSalesCentavos.changePercent, periodLabel } : null} hint="After cancellations and refunds already paid back to Buyers." />
      <KpiCard label="Average order value" value={formatPesoCentavos(kpis.averageOrderValueCentavos?.value ?? null)} hint={kpis.averageOrderValueCentavos?.previous ? `${formatPesoCentavos(kpis.averageOrderValueCentavos.previous)} in the ${periodLabel}.` : `Nothing to compare in the ${periodLabel}.`} />
      <KpiCard label="Orders confirmed" value={formatCount(kpis.orderVolume.value)} delta={{ changePercent: kpis.orderVolume.changePercent, periodLabel }} icon={<ShoppingCart size={16} aria-hidden="true" />} />
    </dl> : <InfoNote>Peso sales and earnings figures are available to the Vendor Owner. Your view shows order counts.</InfoNote>}
    {sales && salesForecast && <DashboardPanel title="Sales and 7-day forecast" description="Gross sales per day; the shaded region is a forecast with its 95% range.">
      <div className="grid gap-4">
        <TrendLineChart title="Gross sales per day" labels={labels} formatLabel={formatChartDay} formatValue={value => formatCompactCentavos(Math.round(value))} emptyReason="No sales in this period."
          series={[{ key: 'gross', label: 'Gross sales', colorVar: '--mp-viz-series-1', values: orders.series.map(point => point.grossSalesCentavos ?? null), kind: 'bar' }, { key: 'average', label: '7-day average', colorVar: '--mp-viz-series-2', values: orders.series.map(point => point.salesAverageCentavos ?? null) }]}
          forecast={salesForecast.state === 'OK' ? { label: 'Forecast', labels: salesForecast.points.map(point => day(point.date)), values: salesForecast.points.map(point => point.value), lower: salesForecast.points.map(point => point.lower), upper: salesForecast.points.map(point => point.upper) } : null}
          markers={markers} />
        <ForecastNote forecast={forecastView(salesForecast)} horizonDays={orders.forecast.horizonDays} unit="in gross sales" formatValue={value => formatPesoCentavos(Math.round(value))} />
        <ChartDataTable caption="Sales per day" rowHeader="Date" rows={labels.map(formatChartDay)} columns={[
          { key: 'gross', header: 'Gross sales', values: orders.series.map(point => formatPesoCentavos(point.grossSalesCentavos ?? null)) },
          { key: 'net', header: 'Net sales', values: orders.series.map(point => formatPesoCentavos(point.netSalesCentavos ?? null)) },
          { key: 'orders', header: 'Orders', values: orders.series.map(point => formatCount(point.orders)) },
        ]} />
        <p className="text-xs text-text-secondary">Internal operational view — not a tax invoice, accounting record or tax return. Commission and withholding are in Earnings and Transaction History.</p>
      </div>
    </DashboardPanel>}
    <div className="grid items-start gap-5 xl:grid-cols-2">
      <DashboardPanel title="Top products" description={sales ? 'By sales value in the period.' : 'By orders in the period.'} action={productAnalytics ? productAnalyticsLink : undefined}>
        <BarList label="Top products" empty="No products sold in this period." items={products.top.map(product => ({ key: product.name, label: product.name, value: sales ? product.valueCentavos ?? 0 : product.orders,
          display: sales ? formatPesoCentavos(product.valueCentavos ?? null) : `${formatCount(product.orders)} orders`, detail: `${product.category} · ${formatCount(product.orders)} orders · ${formatCount(product.buyers)} Buyers` }))} />
      </DashboardPanel>
      <DashboardPanel title="Category share" description={sales ? 'Share of sales value by category.' : 'Share of orders by category.'}>
        <ShareBar label="Category share" empty="No categories sold in this period." segments={categorySegments} formatValue={value => (sales ? formatPesoCentavos(value) : formatCount(value))} />
      </DashboardPanel>
    </div>
    <SegmentsPanel orders={orders} sales={sales} />
    <DashboardPanel title="Frequently ordered together" description={`Materials that appear in the same confirmed order more often than chance, last ${products.basketRules.windowDays} days.`}>
      <div className="grid gap-4">
        <AssociationRuleList countLabel="orders" empty={`No pattern yet: a pair must appear in at least two orders from two different Buyers (${formatCount(products.basketRules.baskets)} orders checked).`}
          rules={products.basketRules.rules.map(rule => ({ antecedent: rule.antecedent, consequent: rule.consequent, confidence: rule.confidence, lift: rule.lift, supportCount: rule.supportCount }))} />
        <MethodNote>Association rule mining (Apriori): confidence is how often orders with the first materials also contain the last one; lift above 1 means more often than chance. Use it for stocking and bundles. It is co-occurrence, not a recommendation shown to Buyers.</MethodNote>
      </div>
    </DashboardPanel>
  </>
}

function SegmentsPanel({ orders, sales }: { orders: VendorDashboardOrders; sales: boolean }) {
  const segments = orders.products.segments
  return <DashboardPanel title="Product demand segments" description="Products grouped by similar demand in the period.">
    {segments.state !== 'OK' ? <p className="text-sm text-text-secondary">{segments.reason ?? 'Not enough products with orders to group yet.'}</p> : <div className="grid gap-5">
      <SegmentScatter title="Products by orders and distinct Buyers" xLabel="Orders" yLabel="Distinct Buyers" groups={segments.segments.map(segment => segment.label)}
        points={segments.points.map(point => ({ key: point.name, label: point.name, x: point.orders, y: point.buyers, group: point.segment }))} />
      <ul className="grid gap-4 md:grid-cols-2 xl:grid-cols-4">{segments.segments.map(segment => <li key={segment.id} className="grid gap-1 border-l-2 border-border-default pl-4 text-sm">
        <span className="font-semibold text-text-strong">{segment.label}</span>
        <span className="text-text-secondary">{formatCount(segment.size)} products · about {formatCount(segment.averageOrders)} orders and {formatCount(segment.averageBuyers)} Buyers each{sales && segment.averageValueCentavos !== null && segment.averageValueCentavos !== undefined ? ` · ${formatPesoCentavos(segment.averageValueCentavos)}` : ''}</span>
        <span className="text-xs text-text-secondary">e.g. {segment.examples.join(', ')}</span></li>)}</ul>
      <MethodNote>K-Means clustering on {segments.features.join(', ').toLowerCase()} (standardized), with the number of groups chosen by the best silhouette score{segments.silhouette !== null && segments.silhouette !== undefined ? ` (${segments.silhouette.toFixed(2)}; closer to 1 means clearer groups)` : ''}. Groups describe demand patterns only.</MethodNote>
    </div>}
  </DashboardPanel>
}

function TrafficSection({ data, productAnalytics }: { data: VendorDashboardInsights; productAnalytics: boolean }) {
  const orders = data.orders
  return <>
    <InfoNote>{data.traffic.storeVisits.reason} Volume below uses inquiries, quotations and orders the platform records.{productAnalytics && <> <Link className="font-semibold text-action-primary underline underline-offset-4" to="/performance?tab=products">Open product analytics</Link></>}</InfoNote>
    {!orders ? <p className="text-sm text-text-secondary">Store-wide volume is available to the Owner, Store Manager, Store Staff and Customer Service.</p> : <>
      <div className="grid items-start gap-5 xl:grid-cols-2">
        <DashboardPanel title="Demand funnel" description="From first contact to completed orders in the period.">
          <BarList label="Demand funnel" empty="No activity in this period." colorVar="--mp-viz-series-1" items={orders.funnel.map(stage => {
            // Conversion is shown only where a stage is a subset of the one before it; Item-Based orders need no inquiry or quotation.
            const before = orders.funnel.find(item => item.key === CONVERTS_FROM[stage.key])
            return { key: stage.key, label: stage.label, value: stage.count, display: formatCount(stage.count), detail: before && before.count > 0 ? `${Math.round((stage.count / before.count) * 100)}% of ${before.label.toLowerCase()}` : null }
          })} />
          <p className="mt-3 text-xs text-text-secondary">Stages are counted separately; an order request does not always follow an inquiry.</p>
        </DashboardPanel>
        <DashboardPanel title="Order mix" description="Confirmed orders in the period.">
          <div className="grid gap-5">{([['procurement', 'Procurement type'], ['fulfillment', 'Fulfillment method'], ['payment', 'Payment method']] as const).map(([key, title]) => <div key={key} className="grid gap-2">
            <h3 className="text-xs font-semibold uppercase tracking-[0.12em] text-text-secondary">{title}</h3>
            <ShareBar label={title} empty="No confirmed orders yet." segments={orders.mix[key].map((item, index) => ({ key: item.key, label: typeLabel(item.key), value: item.count, colorVar: SLOTS[index % SLOTS.length] ?? '--mp-viz-series-1' }))} />
          </div>)}</div>
        </DashboardPanel>
      </div>
      <DashboardPanel title="Requests and confirmations per day">
        <TrendLineChart title="Order requests and confirmed orders" labels={orders.series.map(point => day(point.date))} formatLabel={formatChartDay} formatValue={value => formatCount(Math.round(value))} emptyReason="No activity in this period."
          series={[{ key: 'requests', label: 'Order requests', colorVar: '--mp-viz-series-1', values: orders.series.map(point => point.orderRequests) }, { key: 'orders', label: 'Orders confirmed', colorVar: '--mp-viz-series-2', values: orders.series.map(point => point.orders) }]} />
      </DashboardPanel>
    </>}
  </>
}

function QualitySection({ data }: { data: VendorDashboardInsights }) {
  const disputes = data.disputes
  const orders = data.orders
  if (!disputes && !orders) return <InfoNote>Case and quality measures are available to roles that handle orders and disputes.</InfoNote>
  return <>
    <dl className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
      {disputes && <KpiCard label="Open cases" value={formatCount(disputes.open)} hint={`${formatCount(disputes.awaitingResponse)} awaiting your response.`} icon={<Scale size={16} aria-hidden="true" />} accent={disputes.awaitingResponse > 0} />}
      {orders && <KpiCard label="Dispute rate" value={rateText(orders.kpis.disputeRate)} hint={rateHint(orders.kpis.disputeRate, 'confirmed orders')} />}
      {disputes && <KpiCard label="Validated returns" value={formatCount(disputes.validatedReturns)} hint="Defect, wrong-item or incomplete-order returns confirmed in the period." icon={<Undo2 size={16} aria-hidden="true" />} />}
      {disputes && <KpiCard label="Fulfillment issues reported" value={formatCount(disputes.fulfillmentIssues)} hint="Reported by Buyers in the period." icon={<AlertTriangle size={16} aria-hidden="true" />} />}
    </dl>
    {disputes && <div className="grid items-start gap-5 xl:grid-cols-2">
      <DashboardPanel title="Cases filed per day">
        <TrendLineChart title="Dispute cases filed per day" labels={disputes.series.map(point => day(point.date))} formatLabel={formatChartDay} formatValue={value => formatCount(Math.round(value))} emptyReason="No cases in this period."
          series={[{ key: 'cases', label: 'Cases filed', colorVar: '--mp-viz-series-2', values: disputes.series.map(point => point.cases), kind: 'bar' }]} />
      </DashboardPanel>
      <DashboardPanel title="Issue types" description="Cases filed in the period.">
        <BarList label="Issue types" empty="No cases filed in this period." colorVar="--mp-viz-series-2" items={disputes.issueTypes.map(item => ({ key: item.key, label: disputeIssueLabel(item.key), value: item.count, display: formatCount(item.count) }))} />
        {disputes.statuses.length > 0 && <div className="mt-5 grid gap-2"><h3 className="text-xs font-semibold uppercase tracking-[0.12em] text-text-secondary">Open cases by status</h3>
          <ShareBar label="Open cases by status" empty="No open cases." segments={disputes.statuses.map((item, index) => ({ key: item.key, label: disputeStateLabel(item.key), value: item.count, colorVar: SLOTS[index % SLOTS.length] ?? '--mp-viz-series-1' }))} /></div>}
      </DashboardPanel>
    </div>}
    {orders && <DashboardPanel title="Cancellation" description="All causes, for the confirmed orders in the period. The Vendor-caused rate used for scoring is under Performance.">
      <p className="text-3xl font-semibold tabular-nums text-text-strong">{rateText(orders.kpis.cancellationRate)}</p><p className="mt-1 text-xs text-text-secondary">{rateHint(orders.kpis.cancellationRate, 'confirmed orders')}</p>
    </DashboardPanel>}
  </>
}
