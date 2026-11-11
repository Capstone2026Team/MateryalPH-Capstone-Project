import { AsyncLoading } from '@materyalph/web-ui'
import { useCallback, useEffect, useState, type ReactNode } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import { AlertTriangle, ArrowRight, CheckCircle2, ClipboardList, Clock, Percent, Scale, ShoppingCart, Undo2, Wallet } from 'lucide-react'
import {
  AnalyticsChartCard, AnalyticsDashboardLayout, AnalyticsSummary, AssociationRuleList, BarList, Button, ChartDataTable, DashboardHeader, DashboardPanel, DashboardQueueList, DateFilter, EmptyState, ForecastNote, InfoNote, KpiCard, KpiBreakdown, RankedList, ScoreOverview, ScoreCalculationDetails, SectionWorkspace, StatusBadge,
  SegmentScatter, ShareBar, StatusMessage, TrendLineChart, analyticsDay, disputeIssueLabel, disputeStateLabel, formatChartDay, formatCompactCentavos, formatCount, formatDurationSeconds,
  formatManilaDateTime, formatPesoCentavos, formatDeductionCentavos, sumChartAmounts, useAutomaticRefresh, usePortalResource, type ForecastView, type TrendMarker, type VizColor,
  VendorRecentActivity,
} from '@materyalph/web-ui'
import type { DashboardAction, DashboardForecast, DashboardRate, VendorDashboardOrders } from '@materyalph/api-client-ts'
import { getVendorDashboardInsights, type VendorDashboardInsights } from '../lib/dashboard-api'
import { readableApiError } from '../lib/auth-api'
import { listVendorTeamActivity, readableOnboardingError } from '../lib/onboarding-api'
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
export function VendorInsightsWorkspace({ storeName, overviewFooter, overviewAside, canViewProductAnalytics = false, canViewRecentActivity = false }: { storeName: string; overviewFooter?: ReactNode; overviewAside?: ReactNode; canViewProductAnalytics?: boolean; canViewRecentActivity?: boolean }) {
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

  const header = <DashboardHeader eyebrow={storeName} description="Your store at a glance. Switch sections to focus on the work that matters today." status={<StatusBadge label="Active" tone="success" />} actions={data ? <p className="text-xs text-text-secondary">Updated {formatManilaDateTime(data.generatedAt)} · Updates automatically</p> : undefined} />
  const dateControls = <DateFilter title="Dashboard dates" value={range} disabled={pending && !data} onChange={changeDates} />
  if (!data) return <div className="mp-analytics space-y-3">{header}<div className="flex flex-wrap items-center gap-3">{dateControls}</div>
    {message ? <div className="space-y-3"><StatusMessage tone="error">{message}</StatusMessage><Button variant="secondary" onClick={() => void refresh()}>Retry</Button></div>
      : <AsyncLoading compact label="Loading your store dashboard…" />}
    {overviewAside}
    {overviewFooter}
  </div>
  const periodLabel = `previous ${data.period.days} days`
  return <div className="mp-analytics space-y-3">
    {header}
    {message && <StatusMessage tone="error">{message} Showing the last successful update.</StatusMessage>}
    <SectionWorkspace dashboard actions={dateControls} sections={[
      { label: 'Overview', content: <OverviewSection data={data} periodLabel={periodLabel} footer={overviewFooter} aside={overviewAside} productAnalytics={canViewProductAnalytics} recentActivity={canViewRecentActivity} /> },
      { label: 'Traffic & Volume', content: <TrafficSection data={data} productAnalytics={canViewProductAnalytics} /> },
      { label: 'Disputes & Quality', content: <QualitySection data={data} /> },
    ]} />
  </div>
}

function OverviewSection({ data, periodLabel, footer, aside, productAnalytics, recentActivity }: { data: VendorDashboardInsights; periodLabel: string; footer: ReactNode; aside: ReactNode; productAnalytics: boolean; recentActivity: boolean }) {
  const orders = data.orders
  const awaiting = data.actions.find(action => action.key === 'ORDER_CONFIRMATION')
  const assigned = data.actions.find(action => action.key === 'ASSIGNED_FULFILLMENT')
  const sales = data.access.salesValue ? orders?.kpis.grossSalesCentavos : null
  const earnings = data.access.salesValue ? orders?.kpis.netSalesCentavos : null
  return <AnalyticsDashboardLayout stretchAside={recentActivity} aside={<>
      {aside}
      <StockPanel data={data} />
      <DashboardPanel divided density="compact" title="Priority actions" description="Work waiting for your role, most urgent first."><ActionList actions={data.actions} /></DashboardPanel>
      {recentActivity && <VendorRecentActivity list={listVendorTeamActivity} explainError={readableOnboardingError} action={<Link to="/preview/tracking" className="inline-flex min-h-11 items-center gap-1 text-xs font-medium text-action-primary">View all<ArrowRight size={13} aria-hidden="true" /></Link>} />}
    </>}>
    <AnalyticsSummary density="compact" context={`${formatChartDay(day(data.period.from))} – ${formatChartDay(day(data.period.to))}`} featured={sales
      ? { label: 'Earnings', value: formatPesoCentavos(earnings?.value ?? null), hint: 'After cancellations and completed refunds, before commission and business costs.', icon: <Wallet size={17} />, changePercent: earnings?.changePercent, comparison: `vs ${periodLabel}`, comparisonUnavailable: earnings?.previous === 0 ? `No earnings in ${periodLabel}` : 'Previous period comparison unavailable', calculation: <><p><strong>Earnings</strong> = gross sales − completed refund deductions − remaining cancelled-order value. Completed online refunds and confirmed cash reimbursements are deducted once, up to the sale value.</p><p>Uses orders first confirmed in the selected period, not refund payout dates. This is before commission, other charges and business costs. The Sales trend calculation shows the amount breakdown.</p></> }
      : orders ? { label: 'Fulfillment rate', value: rateText(orders.kpis.fulfillmentRate), hint: rateHint(orders.kpis.fulfillmentRate, 'orders due'), calculation: <><p>Confirmed, non-cancelled orders due for fulfillment in the selected period that were completed by the period’s end ÷ all confirmed, non-cancelled orders due in that period × 100.</p><p>Uses the expected fulfillment date in Asia/Manila. With no orders due, the rate is unavailable.</p></> } : { label: 'Orders assigned to you', value: formatCount(assigned?.count ?? null) }} metrics={[
        ...(sales && orders ? [
          { label: 'Gross sales', value: formatPesoCentavos(sales.value), hint: 'Confirmed order value before cancellations, returns and refunds.', icon: <Wallet size={15} />, changePercent: sales.changePercent, comparison: `vs ${periodLabel}`, comparisonUnavailable: sales.previous === 0 ? `No sales in ${periodLabel}` : 'Previous period comparison unavailable', calculation: <><p>Adds the value of your store’s orders first confirmed in the selected period, including materials, NRPC and delivery, before cancellations, returns and refunds. E-wallet transaction fees are excluded.</p><p>Dates use Asia/Manila. The comparison uses the preceding period of the same length; a percentage is unavailable when the previous total is zero.</p></> },
          { label: 'Average order value', value: formatPesoCentavos(orders.kpis.averageOrderValueCentavos?.value ?? null), hint: orders.kpis.averageOrderValueCentavos?.previous === 0 ? `Nothing to compare in ${periodLabel}.` : 'Gross sales divided by orders confirmed.', icon: <Wallet size={15} />, calculation: <><p><strong>Average order value</strong> = gross sales ÷ orders first confirmed in the selected period, rounded to the nearest centavo.</p><p>Uses the same confirmed orders as Gross sales, including orders later cancelled or refunded. With no confirmed orders, the average is unavailable.</p></> },
        ] : [{ label: awaiting ? 'Awaiting your decision' : 'Assigned orders', value: formatCount(awaiting?.count ?? assigned?.count ?? null), icon: <ClipboardList size={15} />, hint: awaiting?.detail }]),
        { label: 'Orders confirmed', value: formatCount(orders?.kpis.orderVolume.value ?? null), icon: <ShoppingCart size={15} />, changePercent: orders?.kpis.orderVolume.changePercent, comparison: `vs ${periodLabel}`, ...(orders ? { comparisonUnavailable: orders.kpis.orderVolume.previous === 0 ? `No confirmed orders in ${periodLabel}` : 'Previous period comparison unavailable', calculation: <><p>Counts your store’s orders first confirmed during the selected dates in Asia/Manila. Each order counts once, even if it is later completed, cancelled or disputed.</p><p>The comparison uses the preceding period of the same length. A previous count of zero has no percentage comparison.</p></> } : {}) },
        ...(!sales ? [{ label: orders ? 'Median response' : 'Out of stock', value: orders ? formatDurationSeconds(orders.kpis.responseTime.medianSeconds) : formatCount(data.stock?.outOfStock ?? null), icon: <Clock size={15} />, hint: orders ? 'Time to first order decision' : 'Variants needing attention' }] : []),
      ]} />
      <div className="mp-card-group mp-analytics-cards mp-analytics-overview">
        {orders && <>{data.access.salesValue && <SalesTrendPanel orders={orders} />}<OrdersTrendPanel orders={orders} />
          <SalesByCategoryPanel orders={orders} sales={data.access.salesValue} />
        </>}
        {data.performance && <DashboardPanel density="compact" title="Store performance" description="Published scores and progress toward eligibility."
          action={<Link to="/performance" className="mp-analytics-page-link inline-flex min-h-11 items-center gap-1 text-xs font-semibold text-action-primary">View performance<ArrowRight size={14} aria-hidden="true" /></Link>}
          calculation={<ScoreCalculationDetails scores={data.performance.scores} />}><ScoreOverview compact scores={data.performance.scores} /></DashboardPanel>}
        {orders && <TopProductsPanel orders={orders} sales={data.access.salesValue} productAnalytics={productAnalytics} period={data.period} />}
        {!orders && <DashboardPanel density="compact" title="Your workspace"><p className="text-xs leading-5 text-text-secondary">Store-wide order measures are available to the Owner, Store Manager, Store Staff and Customer Service. Your dashboard shows the work assigned to your role.</p></DashboardPanel>}
      </div>
      {orders && <ProductInsightsOverview orders={orders} sales={data.access.salesValue} />}
      {orders && <IncomingOrdersPanel orders={orders} />}
      {footer}
    </AnalyticsDashboardLayout>
}

function SalesByCategoryPanel({ orders, sales }: { orders: VendorDashboardOrders; sales: boolean }) {
  return <DashboardPanel scrollBody density="compact" title="Sales by category" description={sales ? 'Product sales after discounts · VAT included.' : 'Share of orders with remaining sales.'}
    calculation={<><p>Uses the same surviving orders, first-confirmation dates and frozen product amounts as Finance and Product Analytics. Cancelled and fully refunded sales are excluded.</p><p>Product values are before partial refunds and exclude delivery. Product sales plus delivery minus completed partial refunds equals Earnings. Finance shows the amount breakdown.</p><p>Category share uses all product sales. When there are more than six categories, the smaller categories are grouped under Other categories. Order counts are distinct within each category and should not be added across categories.</p></>}>
    <ShareBar variant="donut" totalLabel={sales ? 'Sales' : 'Matches'} label="Category share" empty="No categories sold in this period." formatValue={value => sales ? formatPesoCentavos(value) : formatCount(value)} formatTotal={value => sales ? formatCompactCentavos(value) : formatCount(value, true)}
      segments={orders.products.categories.map((category, index) => ({ key: category.category, label: category.category, value: sales ? category.valueCentavos ?? 0 : category.orders, colorVar: SLOTS[index % SLOTS.length] ?? '--mp-viz-series-1' }))} />
  </DashboardPanel>
}

function TopProductsPanel({ orders, sales, productAnalytics, period }: { orders: VendorDashboardOrders; sales: boolean; productAnalytics: boolean; period: VendorDashboardInsights['period'] }) {
  const top = orders.products.top.slice(0, 5)
  const leadingValue = sales ? top[0]?.valueCentavos ?? 0 : top[0]?.orders ?? 0
  const analyticsHref = `/analytics/products?${new URLSearchParams({ from: day(period.from), to: day(period.to) })}`
  return <DashboardPanel scrollBody density="compact" title="Top products" description={sales ? 'Top five by product sales value, matching Finance.' : 'Top five by orders with remaining sales.'}
    action={productAnalytics ? <Link to={analyticsHref} className="mp-analytics-page-link inline-flex min-h-11 items-center gap-1 text-xs font-semibold text-action-primary">Product analytics<ArrowRight size={14} aria-hidden="true" /></Link> : undefined}
    calculation={<><p>Uses the same surviving confirmed orders and frozen material amounts as Finance and Product Analytics. Cancelled and fully refunded sales are excluded.</p><p>Product values include Vendor discounts and VAT, exclude delivery, and are before partial refunds. Finance shows how these values reconcile to Earnings.</p><p>Bars compare each product with the first-ranked product. Order and Buyer counts are distinct for each product and should not be added across products. The Product analytics link keeps these reporting dates.</p></>}>
    <RankedList compact label="Top products in this period" empty="No product sales in this period." items={top.map((product, index) => ({
      key: `${index}-${product.name}`, label: product.name, title: product.name,
      meta: `${product.category} · ${formatCount(product.orders)} ${product.orders === 1 ? 'order' : 'orders'} · ${formatCount(product.buyers)} ${product.buyers === 1 ? 'Buyer' : 'Buyers'}`,
      value: sales ? formatPesoCentavos(product.valueCentavos ?? null) : `${formatCount(product.orders)} ${product.orders === 1 ? 'order' : 'orders'}`,
      share: leadingValue > 0 ? (sales ? product.valueCentavos ?? 0 : product.orders) / leadingValue : 0,
    }))} />
  </DashboardPanel>
}

function ProductInsightsOverview({ orders, sales }: { orders: VendorDashboardOrders; sales: boolean }) {
  const { segments, basketRules } = orders.products
  const points = segments.state === 'OK' ? segments.points : []
  return <div className="mp-card-group mp-product-overview">
    <section aria-label="Product demand patterns" className="mp-product-demand">
      <header><h2 className="text-sm font-semibold text-text-strong">Product demand patterns</h2><p className="mt-1 text-xs leading-5 text-text-secondary">Demand groups for this period and materials often ordered together.</p></header>
      <div className="mp-product-patterns">
        <AnalyticsChartCard title="Product demand segments" description="Products grouped by similar demand." calculation={<>
          <p>K-Means groups products using confirmed orders and distinct Buyers{sales ? ', plus material sales value' : ''}. Features are standardized before grouping. The number of groups is selected using the silhouette score.</p>
          <p>Groups describe your store’s demand patterns. They do not change prices, listings or Buyer recommendations.</p>
          {segments.state === 'OK' && <dl className="grid gap-3">{segments.segments.map(segment => <div key={segment.id}><dt>{segment.label} · {formatCount(segment.size)} {segment.size === 1 ? 'product' : 'products'}</dt><dd>About {formatCount(segment.averageOrders)} orders and {formatCount(segment.averageBuyers)} Buyers per product{sales && segment.averageValueCentavos != null ? ` · ${formatPesoCentavos(segment.averageValueCentavos)}` : ''}.</dd><dd>Examples: {segment.examples.join(', ')}.</dd></div>)}</dl>}
          {points.length > 0 && <ChartDataTable caption="Product demand data" rowHeader="Product" rows={points.map(point => point.name)} columns={[{ key: 'group', header: 'Demand group', values: points.map(point => point.segment) }, { key: 'orders', header: 'Orders', values: points.map(point => formatCount(point.orders)) }, { key: 'buyers', header: 'Distinct Buyers', values: points.map(point => formatCount(point.buyers)) }]} />}
        </>}>
          <SegmentScatter compact title="Products by orders and distinct Buyers" xLabel="Orders" yLabel="Distinct Buyers" groups={points.length > 0 ? segments.segments.map(segment => segment.label) : []}
            points={points.map((point, index) => ({ key: `${index}-${point.name}`, label: point.name, x: point.orders, y: point.buyers, group: point.segment }))} emptyReason={segments.reason ?? 'At least four products with orders in the period are needed to group them.'} />
        </AnalyticsChartCard>
        <AnalyticsChartCard title="Frequently ordered together" description={`Materials in the same confirmed order · last ${basketRules.windowDays} days.`} calculation={<>
          <p>Apriori finds materials that occur together in confirmed orders. A pattern needs at least two orders from two distinct Buyers within the last {basketRules.windowDays} days.</p>
          <p><strong>Confidence</strong> is the share of orders containing the first materials that also include the second materials. <strong>Lift</strong> compares that share with chance; above 1 means they occur together more often.</p>
          <p>Use these patterns for stocking decisions. They do not create bundles or recommendations for Buyers.</p>
        </>}>
          <AssociationRuleList compact countLabel="orders" rules={basketRules.rules} empty={`No pattern yet. A pair needs at least two orders from two different Buyers (${formatCount(basketRules.baskets)} orders checked).`} />
        </AnalyticsChartCard>
      </div>
    </section>
  </div>
}

function OrdersTrendPanel({ orders }: { orders: VendorDashboardOrders }) {
  const labels = orders.series.map(point => day(point.date))
  const forecast = orders.forecast.orders
  const markers: TrendMarker[] = orders.unusualDays.days.map(item => ({ index: labels.indexOf(day(item.date)), label: 'Unusual day' })).filter(marker => marker.index >= 0)
  return <AnalyticsChartCard title="Order activity" description="Requests received and orders confirmed each day." calculation={<><p><strong>Order requests</strong> counts requests received by your store each day. <strong>Orders confirmed</strong> counts Vendor child orders first confirmed on each day. Dates use Asia/Manila.</p><p>The two events can happen on different days, so the chart is an activity view rather than a same-day conversion rate.</p><p>When available, the forecast uses up to 90 days of history, a least-squares trend and a weekday pattern, with a 95% prediction range. It needs at least seven active days and is a planning estimate. Diamonds mark unusual days found by DBSCAN density clustering.</p>
      <ForecastNote forecast={forecastView(forecast)} horizonDays={orders.forecast.horizonDays} unit="orders" formatValue={value => formatCount(Math.round(value))} />
    </>}>
      <TrendLineChart variant="bar" title="Orders confirmed per day" labels={labels} formatLabel={formatChartDay} formatValue={value => formatCount(Math.round(value * 10) / 10)} emptyReason="No orders in this period."
        series={[{ key: 'orders', label: 'Orders confirmed', colorVar: '--mp-viz-series-1', values: orders.series.map(point => point.orders), kind: 'bar' }, { key: 'requests', label: 'Order requests', colorVar: '--mp-viz-series-2', values: orders.series.map(point => point.orderRequests), kind: 'line' }]}
        forecast={forecast.state === 'OK' ? { label: 'Forecast', labels: forecast.points.map(point => day(point.date)), values: forecast.points.map(point => point.value), lower: forecast.points.map(point => point.lower), upper: forecast.points.map(point => point.upper) } : null}
        markers={markers} />
  </AnalyticsChartCard>
}

export function ActionList({ actions, empty = 'No action items apply to your role.' }: { actions: DashboardAction[]; empty?: string }) {
  const sorted = [...actions].sort((a, b) => Number(b.count > 0) - Number(a.count > 0) || Number(b.severity === 'ALERT') - Number(a.severity === 'ALERT') || b.count - a.count)
  return <DashboardQueueList empty={empty} items={sorted.map(action => ({ ...action, attention: action.count > 0 && action.severity === 'ALERT', detail: `${action.count === 0 ? 'Nothing waiting.' : action.severity === 'ALERT' ? 'Needs attention now.' : 'Waiting for action.'}${action.detail ? ` ${action.detail}` : ''}` }))} renderLink={(action, content) => <Link to={action.href}>{content}</Link>} />
}

function StockPanel({ data }: { data: VendorDashboardInsights }) {
  const stock = data.stock
  if (!stock) return null
  return <DashboardPanel density="compact" title="Stock status" description="Current inventory." calculation={<><p><strong>Available to sell</strong> = quantity on hand − hard-reserved quantity. Counts active variants on listings that have not been removed, using current stock across all dates.</p><p><strong>Active</strong> counts variants on active listings. <strong>Not active</strong> includes variants on draft, inactive, temporarily hidden, pending and rejected listings. Stock availability is separate from listing status.</p><p><strong>Out of stock</strong> means no inventory record or available quantity at or below zero. <strong>Limited stock</strong> means positive available quantity at or below its configured reorder level. The remaining variants are In stock. Each variant belongs to one group.</p></>} action={<Link to="/products/inventory" className="inline-flex min-h-11 items-center gap-1 text-sm font-semibold text-action-primary">Inventory<ArrowRight size={14} aria-hidden="true" /></Link>}>
      <div className="grid gap-3">
        <dl aria-label="Inventory listing status" className="grid grid-cols-2 divide-x divide-border-default border-b border-border-default pb-3 text-sm">
          <div className="pr-3"><dt className="text-xs text-text-secondary">Active</dt><dd className="mt-1 text-lg font-semibold tabular-nums">{formatCount(stock.active)}</dd></div>
          <div className="pl-3"><dt className="text-xs text-text-secondary">Not active</dt><dd className="mt-1 text-lg font-semibold tabular-nums">{formatCount(stock.inactive)}</dd></div>
        </dl>
        <ShareBar variant="donut" totalLabel="Variants" label="Variants by stock status" empty="No active variants yet." segments={[{ key: 'in', label: 'In stock', value: stock.inStock, colorVar: '--mp-viz-success' }, { key: 'limited', label: 'Limited stock', value: stock.limitedStock, colorVar: '--mp-viz-warning' }, { key: 'out', label: 'Out of stock', value: stock.outOfStock, colorVar: '--mp-viz-error' }]} />

      </div>
    </DashboardPanel>
}

function IncomingOrdersPanel({ orders }: { orders: VendorDashboardOrders }) {
  return <DashboardPanel density="compact" title="Incoming order requests" action={<Link to="/orders" className="inline-flex min-h-11 items-center gap-1 text-xs font-medium text-action-primary">All orders<ArrowRight size={13} aria-hidden="true" /></Link>}>
    {orders.incoming.length === 0 ? <p className="text-xs leading-5 text-text-secondary">No order requests are waiting for a decision. You’re all caught up.</p> : <div className="overflow-x-auto"><table className="w-full min-w-[460px] text-left text-xs">
      <thead className="border-b border-border-default text-[10px] text-text-secondary"><tr>{['Order', 'Type', 'Amount', 'Response deadline'].map(label => <th key={label} scope="col" className="px-2 py-2 font-medium first:pl-0 last:text-right">{label}</th>)}</tr></thead>
      <tbody className="divide-y divide-border-default">{orders.incoming.map(order => <tr key={order.orderId}>
        <td className="py-3 pr-2"><Link to={`/orders/${order.orderId}`} className="inline-flex min-h-11 items-center font-semibold text-text-strong hover:text-action-primary">{order.reference}</Link><span className="block text-[10px] text-text-secondary">{formatCount(order.lineCount)} items</span></td>
        <td className="px-2 py-3 text-[10px] text-text-secondary">{typeLabel(order.procurementType)}<span className="block">{typeLabel(order.fulfillmentMethod)}</span></td>
        <td className="px-2 py-3 whitespace-nowrap font-medium tabular-nums">{formatPesoCentavos(order.totalCentavos)}</td>
        <td className="py-3 pl-2 text-right text-[10px] text-text-secondary">{order.dueAt ? formatManilaDateTime(order.dueAt) : '—'}</td>
      </tr>)}</tbody>
    </table></div>}
  </DashboardPanel>
}

function SalesTrendPanel({ orders }: { orders: VendorDashboardOrders }) {
  const labels = orders.series.map(point => day(point.date))
  const earnings = orders.kpis.netSalesCentavos?.value ?? null
  const refunds = sumChartAmounts(orders.series.map(point => point.refundsCentavos))
  const cancellations = sumChartAmounts(orders.series.map(point => point.cancellationDeductionsCentavos))
  return <AnalyticsChartCard wide title="Sales trend" description="Daily earnings, refunds and cancelled sales." calculation={<><KpiBreakdown caption="Earnings for the selected period" rows={[
    { key: 'gross', label: 'Gross sales', amount: formatPesoCentavos(orders.kpis.grossSalesCentavos?.value ?? null) },
    { key: 'refunds', label: 'Refunds', amount: formatDeductionCentavos(refunds) },
    { key: 'cancellations', label: 'Cancelled sales', amount: formatDeductionCentavos(cancellations) },
    { key: 'earnings', label: 'Earnings', amount: formatPesoCentavos(earnings), total: true },
  ]} /><p><strong>Earnings</strong> = gross sales − completed refunds − cancelled sales. E-wallet transaction fees are excluded. Earnings are before commission, other charges and business costs, not profit.</p><p><strong>Refunds</strong> includes completed online refund principal and confirmed cash reimbursements, limited to the sale value. Pending or failed refunds and late-capture compensation are excluded. The minus sign marks a deduction already reflected in Earnings.</p><p><strong>Cancelled sales</strong> removes cancelled order value that has not already been counted as refunded, so cancellation refunds are never deducted twice.</p><p>All headline amounts total the selected period. Bars and tooltips show individual days, grouped by the order’s first confirmation date in Asia/Manila rather than its refund payout date.</p><p>Internal operational view — not a tax invoice, accounting record or tax return. Platform commission charges and creditable withholding tax are shown in Finance.</p></>}>
      <TrendLineChart variant="bar" title="Earnings, refunds and cancelled sales per day" labels={labels} formatLabel={formatChartDay} formatValue={value => formatCompactCentavos(Math.round(value))} formatTooltipValue={value => formatPesoCentavos(Math.round(value))} emptyReason="No sales in this period."
        overview={{ label: 'Total gross sales', value: formatPesoCentavos(orders.kpis.grossSalesCentavos?.value ?? null), context: 'Selected period totals', seriesValues: [formatPesoCentavos(earnings), formatDeductionCentavos(refunds), formatDeductionCentavos(cancellations)] }}
        series={[{ key: 'net', label: 'Earnings', colorVar: '--mp-viz-series-1', values: orders.series.map(point => point.netSalesCentavos ?? null) }, { key: 'refunds', label: 'Refunds', colorVar: '--mp-viz-series-2', values: orders.series.map(point => point.refundsCentavos ?? null), formatValue: value => formatDeductionCentavos(Math.round(value)) }, { key: 'cancellations', label: 'Cancelled sales', colorVar: '--mp-viz-series-5', values: orders.series.map(point => point.cancellationDeductionsCentavos ?? null), formatValue: value => formatDeductionCentavos(Math.round(value)) }]} />
      <ChartDataTable caption="Sales per day" rowHeader="Date" rows={labels.map(formatChartDay)} columns={[
        { key: 'gross', header: 'Gross sales', values: orders.series.map(point => formatPesoCentavos(point.grossSalesCentavos ?? null)) },
        { key: 'net', header: 'Earnings', values: orders.series.map(point => formatPesoCentavos(point.netSalesCentavos ?? null)) },
        { key: 'refunds', header: 'Refunds', values: orders.series.map(point => formatDeductionCentavos(point.refundsCentavos)) },
        { key: 'cancellations', header: 'Cancelled sales', values: orders.series.map(point => formatDeductionCentavos(point.cancellationDeductionsCentavos)) },
        { key: 'orders', header: 'Orders', values: orders.series.map(point => formatCount(point.orders)) },
      ]} />
  </AnalyticsChartCard>
}

function TrafficSection({ data, productAnalytics }: { data: VendorDashboardInsights; productAnalytics: boolean }) {
  const orders = data.orders
  return <div className="mp-analytics-detail">
    <InfoNote>MateryalPH does not record storefront visits. Activity below uses recorded inquiries, quotations and orders.{productAnalytics && <> <Link className="font-semibold text-action-primary underline underline-offset-4" to="/analytics/products">Open product analytics</Link></>}</InfoNote>
    {!orders ? <p className="text-sm text-text-secondary">Store-wide volume is available to the Owner, Store Manager, Store Staff and Customer Service.</p> : <>
      <div className="mp-card-group mp-analytics-detail-grid">
        <AnalyticsChartCard title="Demand funnel" description="Recorded activity in the selected period." calculation={<><p>Counts Buyer sales conversations opened, quotation publications and order requests submitted during the selected dates. Confirmed orders are grouped by their first confirmation date; completions are counted among those orders.</p><p><strong>Confirmation rate</strong> = orders confirmed ÷ order requests × 100. <strong>Completion rate</strong> = completed confirmed orders ÷ confirmed orders × 100. A rate is omitted when its denominator is zero.</p><p>Stages are counted separately and may belong to different journeys. An Item-Based order does not require an inquiry or quotation. These rates compare period totals, not a tracked same-day conversion journey. Dates use Asia/Manila.</p></>}>
          <BarList label="Demand funnel" empty="No activity in this period." colorVar="--mp-viz-series-1" items={orders.funnel.map(stage => {
            // Conversion is shown only where a stage is a subset of the one before it; Item-Based orders need no inquiry or quotation.
            const before = orders.funnel.find(item => item.key === CONVERTS_FROM[stage.key])
            return { key: stage.key, label: stage.label, value: stage.count, display: formatCount(stage.count), detail: before && before.count > 0 ? `${Math.round((stage.count / before.count) * 100)}% of ${before.label.toLowerCase()}` : null }
          })} />
          <p className="mt-3 text-xs text-text-secondary">Stages are counted separately; an order request does not always follow an inquiry.</p>
        </AnalyticsChartCard>
        <AnalyticsChartCard title="Order mix" description="How confirmed orders are distributed." calculation={<><p>Groups orders first confirmed in the selected period by procurement type, fulfillment method and payment method. Each order contributes once to each grouping, using its recorded commercial arrangement.</p><p><strong>Share</strong> = orders in that category ÷ confirmed orders in the grouping × 100. The three groupings describe the same orders, so their totals must not be added together.</p><p>These are order counts, not sales value or payment collections. Later cancellations and disputes do not erase the original confirmation.</p></>}>
          <div className="mp-analytics-mix">{([['procurement', 'Procurement type'], ['fulfillment', 'Fulfillment method'], ['payment', 'Payment method']] as const).map(([key, title]) => <div key={key} className="mp-analytics-mix-section">
            <h3>{title}</h3>
            <ShareBar variant="donut" label={title} empty="No confirmed orders yet." segments={orders.mix[key].map((item, index) => ({ key: item.key, label: typeLabel(item.key), value: item.count, colorVar: SLOTS[index % SLOTS.length] ?? '--mp-viz-series-1' }))} />
          </div>)}</div>
        </AnalyticsChartCard>
      </div>
      <AnalyticsChartCard title="Requests and confirmations per day" description="Daily order activity · Asia/Manila." calculation={<><p><strong>Order requests</strong> counts requests submitted to your store that day. <strong>Orders confirmed</strong> counts orders first confirmed that day.</p><p>An order can be requested on one day and confirmed on another. The two bars show activity, not a same-day conversion rate. Zero means no recorded activity; missing data remains unavailable.</p></>} details={<ChartDataTable caption="Requests and confirmations per day" rowHeader="Date" rows={orders.series.map(point => formatChartDay(day(point.date)))} columns={[
        { key: 'requests', header: 'Order requests', values: orders.series.map(point => formatCount(point.orderRequests)) },
        { key: 'orders', header: 'Orders confirmed', values: orders.series.map(point => formatCount(point.orders)) },
      ]} />}>
        <TrendLineChart integerAxis variant="bar" title="Order requests and confirmed orders" labels={orders.series.map(point => day(point.date))} formatLabel={formatChartDay} formatValue={value => formatCount(Math.round(value))} emptyReason="No activity in this period."
          series={[{ key: 'requests', label: 'Order requests', colorVar: '--mp-viz-series-1', values: orders.series.map(point => point.orderRequests) }, { key: 'orders', label: 'Orders confirmed', colorVar: '--mp-viz-series-2', values: orders.series.map(point => point.orders) }]} />
      </AnalyticsChartCard>
    </>}
  </div>
}

function QualitySection({ data }: { data: VendorDashboardInsights }) {
  const disputes = data.disputes
  const orders = data.orders
  if (!disputes && !orders) return <InfoNote>Case and quality measures are available to roles that handle orders and disputes.</InfoNote>
  return <div className="mp-analytics-detail">
    <dl className="mp-card-group mp-analytics-detail-metrics">
      {disputes && <KpiCard density="compact" label="Open cases" value={formatCount(disputes.open)} hint={`${formatCount(disputes.awaitingResponse)} awaiting your response.`} icon={<Scale size={16} aria-hidden="true" />} accent={disputes.awaitingResponse > 0} calculation={<><p>Counts your store’s currently active cases across all dates, regardless of the selected reporting period. Includes cases awaiting a response, mutual resolution, Admin review or clarification, plus decided cases and open appeals that have not closed.</p><p><strong>Awaiting your response</strong> counts cases currently waiting for the Vendor’s response. A closed case is excluded even if it was filed in the selected period.</p></>} />}
      {orders && <KpiCard density="compact" label="Dispute rate" value={rateText(orders.kpis.disputeRate)} hint={rateHint(orders.kpis.disputeRate, 'confirmed orders')} icon={<Percent size={16} aria-hidden="true" />} calculation={<><p><strong>Dispute rate</strong> = confirmed orders with at least one dispute case ÷ all orders first confirmed in the selected period × 100.</p><p>{rateHint(orders.kpis.disputeRate, 'confirmed orders')} Each order is counted once, regardless of how many cases it has or whether its case is still open. Dates use Asia/Manila.</p><p>When there are no confirmed orders, the rate is unavailable rather than 0%.</p></>} />}
      {disputes && <KpiCard density="compact" label="Validated returns" value={formatCount(disputes.validatedReturns)} hint="Defect, wrong-item or incomplete-order returns confirmed in the period." icon={<Undo2 size={16} aria-hidden="true" />} calculation={<><p>Counts recorded validations of defect, wrong-item or incomplete-order returns during the selected period, using the validation date in Asia/Manila.</p><p>A reported issue or an opened dispute alone does not count as a validated return. This is a count of validated return records, not refunded pesos.</p></>} />}
      {disputes && <KpiCard density="compact" label="Fulfillment issues reported" value={formatCount(disputes.fulfillmentIssues)} hint="Reported by Buyers in the period." icon={<AlertTriangle size={16} aria-hidden="true" />} calculation={<><p>Counts Buyer fulfillment issue reports created during the selected dates in Asia/Manila, including reports that have since been resolved.</p><p>Reports are counted separately, so one order can contribute more than one report. A report does not by itself establish Vendor fault or a validated return.</p></>} />}
    </dl>
    <div className="mp-card-group mp-analytics-detail-grid">
      {disputes && <>
        <AnalyticsChartCard title="Cases filed per day" description="New cases in the selected period · Asia/Manila." calculation={<><p>Counts cases filed against your store on each calendar day in the selected period. The filing date determines the day, even if the case is now closed.</p><p>The bars total <strong>{formatCount(disputes.filedInPeriod)} {disputes.filedInPeriod === 1 ? 'case' : 'cases'} filed</strong> in the period. This can differ from the current Open cases count, which includes active cases from any date.</p></>} details={<ChartDataTable caption="Cases filed per day" rowHeader="Date" rows={disputes.series.map(point => formatChartDay(day(point.date)))} columns={[{ key: 'cases', header: 'Cases filed', values: disputes.series.map(point => formatCount(point.cases)) }]} />}>
          <TrendLineChart integerAxis variant="bar" title="Dispute cases filed per day" labels={disputes.series.map(point => day(point.date))} formatLabel={formatChartDay} formatValue={value => formatCount(value)} emptyReason="No cases in this period."
            series={[{ key: 'cases', label: 'Cases filed', colorVar: '--mp-viz-series-1', values: disputes.series.map(point => point.cases), kind: 'bar' }]} />
        </AnalyticsChartCard>
        <AnalyticsChartCard title="Issue types" description="Filed cases grouped by their reported issue." calculation={<><p>Groups cases filed in the selected period by their recorded issue type. Each case contributes once, including cases that have since closed.</p><p>Counts total the same cases as Cases filed per day. A reported issue type is not a final finding of fault or a validated return.</p></>}>
          {disputes.issueTypes.length ? <ShareBar variant="donut" totalLabel="Cases" label="Issue types" empty="No cases filed in this period." segments={disputes.issueTypes.map((item, index) => ({ key: item.key, label: disputeIssueLabel(item.key), value: item.count, colorVar: SLOTS[index % SLOTS.length]! }))} /> : <EmptyState icon={false} message="No cases filed in this period." />}
        </AnalyticsChartCard>
        <AnalyticsChartCard title="Open cases by status" description="Current workload across all dates." calculation={<><p>Groups your store’s currently active cases by their latest status, regardless of the selected reporting dates. Resolved and closed-inconclusive cases are excluded.</p><p><strong>Status share</strong> = cases in that status ÷ all currently open cases × 100. Each case belongs to one status, and the counts total Open cases.</p></>}>
          {disputes.open > 0 ? <ShareBar variant="donut" totalLabel="Cases" label="Open cases by status" empty="No open cases." segments={disputes.statuses.map((item, index) => ({ key: item.key, label: disputeStateLabel(item.key), value: item.count, colorVar: SLOTS[index % SLOTS.length] ?? '--mp-viz-series-1' }))} /> : <EmptyState icon={<CheckCircle2 size={24} aria-hidden="true" />} message="No open cases. There are no active cases to group by status." />}
        </AnalyticsChartCard>
      </>}
      {orders && <AnalyticsChartCard title="Cancellation" description="All causes · confirmed orders in the selected period." calculation={<><p><strong>Cancellation rate</strong> = orders first confirmed in the selected period that are now cancelled ÷ all orders first confirmed in that period × 100.</p><p>{rateHint(orders.kpis.cancellationRate, 'confirmed orders')} Counts all causes, including Buyer and Vendor cancellations. Requests declined or expired before confirmation are excluded.</p><p>This is separate from the Vendor-caused cancellation rate used for scoring in Store Performance. With no confirmed orders, the rate is unavailable rather than 0%.</p></>}>
        <p className="mp-analytics-detail-value">{rateText(orders.kpis.cancellationRate)}</p><p className="mt-1 text-xs text-text-secondary">{rateHint(orders.kpis.cancellationRate, 'confirmed orders')}</p>
        <p className="mt-3 text-xs leading-5 text-text-secondary">The Vendor-caused rate used for scoring is available in Store Performance.</p>
      </AnalyticsChartCard>}
    </div>
  </div>
}
