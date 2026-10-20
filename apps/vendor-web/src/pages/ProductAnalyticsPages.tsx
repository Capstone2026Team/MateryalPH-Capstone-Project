import { useCallback, useEffect, useState, type ReactNode } from 'react'
import { Link, useParams, useSearchParams } from 'react-router-dom'
import { ArrowDownRight, ArrowRight, ArrowUpRight, BarChart3, Eye, Minus, MousePointerClick, PencilLine, ShoppingCart, Users, Wallet } from 'lucide-react'
import {
  AssociationRuleList, BarList, ChartDataTable, ForecastNote, InfoNote, InsightList, InsightPanel, KpiCard, Pagination, PeriodSelector, RankedList, ResponsiveRecordList, Select, SegmentScatter,
  ShareBar, Sparkline, StatusBadge, StatusMessage, TrendLineChart, analyticsDay, formatChartDay, formatCount, formatPesoCentavos, usePortalResource,
  type ForecastView, type InsightItem, type RecordColumn, type TrendMarker, type VizColor,
} from '@materyalph/web-ui'
import type { DashboardForecast, DashboardRate, ProductAnalyticsSeriesPoint } from '@materyalph/api-client-ts'
import {
  ANALYTICS_PERIODS, getProductAnalytics, getProductAnalyticsDetail, parsePeriod,
  type ProductAnalyticsRow, type ProductAnalyticsSuggestion, type ProductSort, type ProductSummary,
} from '../lib/product-analytics-api'
import { readableApiError } from '../lib/auth-api'
import { ProductReviewsSection } from './VendorReviewPages'
import { ErrorState, LoadingState, PageHeader } from './PhaseThreeVendorPages'

const SLOTS: VizColor[] = ['--mp-viz-series-1', '--mp-viz-series-2', '--mp-viz-series-3', '--mp-viz-series-4', '--mp-viz-series-5', '--mp-viz-series-6']
const STOCK: Record<string, { label: string; tone: 'success' | 'warning' | 'error' }> = { IN_STOCK: { label: 'In stock', tone: 'success' }, LIMITED_STOCK: { label: 'Limited stock', tone: 'warning' }, OUT_OF_STOCK: { label: 'Out of stock', tone: 'error' } }
const SORTS: { value: ProductSort; label: string }[] = [{ value: 'views', label: 'Most viewed' }, { value: 'orders', label: 'Most ordered' }, { value: 'conversion', label: 'Best conversion' }, { value: 'value', label: 'Highest sales value' }]
const day = (value: Date | string) => analyticsDay(value) ?? ''
const percent = (rate: DashboardRate) => (rate.percent === null || rate.percent === undefined ? '—' : `${rate.percent}%`)
const link = 'inline-flex min-h-11 items-center gap-1 text-sm font-semibold text-action-primary underline-offset-4 hover:underline'

function forecastView(forecast: DashboardForecast): ForecastView {
  return { state: forecast.state, direction: forecast.direction, changePercent: forecast.changePercent ?? null, expectedTotal: forecast.expectedTotal ?? null, points: forecast.points,
    weekdayStrength: forecast.weekdayStrength ?? null, observedDays: forecast.observedDays }
}

function useErrorText(error: unknown): string | null {
  const [text, setText] = useState<string | null>(null)
  useEffect(() => {
    let active = true
    setText(null)
    if (error) void readableApiError(error).then(message => { if (active) setText(message) })
    return () => { active = false }
  }, [error])
  return text
}

/** "Since …" note when view recording started inside the period, so a short history is never read as low demand. */
function TrackingNote({ since, from }: { since: Date | null | undefined; from: Date }) {
  const start = since ? day(since) : null
  if (start && start <= day(from)) return null
  return <InfoNote>{start ? `Product views are recorded from ${formatChartDay(start)}. Days before that show no views because none were collected.` : 'No product views have been recorded yet. A view is counted when a signed-in Buyer opens one of your products in the Buyer app.'}</InfoNote>
}

function suggestionItems(items: ProductAnalyticsSuggestion[]): InsightItem[] {
  return items.map(item => ({ key: item.key, priority: item.priority, title: item.title, detail: item.detail, technique: item.technique,
    action: <Link className={link} to={item.href}>{item.kind === 'RESTOCK_VIEWED' || item.kind === 'REORDER_SOON' ? 'Open inventory' : item.href.startsWith('/products/') && !item.href.includes('inventory') ? 'Edit listing' : 'View details'}<ArrowRight size={14} aria-hidden="true" /></Link> }))
}

function ViewsTrend({ series, forecast, markers = [], horizonDays, method, subject = 'your products' }: { series: ProductAnalyticsSeriesPoint[]; forecast: DashboardForecast; markers?: TrendMarker[]; horizonDays: number; method: ReactNode; subject?: string }) {
  const labels = series.map(point => day(point.date))
  return <InsightPanel title="Product views and orders" purpose={`Daily demand for ${subject}: Buyers who opened it (bars) and confirmed orders that included it (line). The shaded region is a 7-day views forecast.`} method={method}>
    <TrendLineChart title="Product views and orders per day" labels={labels} formatLabel={formatChartDay} formatValue={value => formatCount(Math.round(value * 10) / 10)} emptyReason="No views or orders in this period."
      series={[{ key: 'views', label: 'Product views', colorVar: '--mp-viz-series-1', values: series.map(point => point.views), kind: 'bar' }, { key: 'orders', label: 'Orders', colorVar: '--mp-viz-series-2', values: series.map(point => point.orders) }]}
      forecast={forecast.state === 'OK' ? { label: 'Views forecast', labels: forecast.points.map(point => day(point.date)), values: forecast.points.map(point => point.value), lower: forecast.points.map(point => point.lower), upper: forecast.points.map(point => point.upper) } : null}
      markers={markers} />
    <ForecastNote forecast={forecastView(forecast)} horizonDays={horizonDays} unit="product views" formatValue={value => formatCount(Math.round(value))} />
    <ChartDataTable caption="Product views and orders per day" rowHeader="Date" rows={labels.map(formatChartDay)} columns={[
      { key: 'views', header: 'Product views', values: series.map(point => formatCount(point.views)) },
      { key: 'orders', header: 'Orders', values: series.map(point => formatCount(point.orders)) },
      ...(series.some(point => point.valueCentavos !== null && point.valueCentavos !== undefined) ? [{ key: 'value', header: 'Sales value', values: series.map(point => formatPesoCentavos(point.valueCentavos ?? null)) }] : []),
    ]} />
  </InsightPanel>
}

const productLink = (row: ProductAnalyticsRow) => <Link className="hover:text-action-primary hover:underline" to={`/performance/products/${row.listingId}`}>{row.name}</Link>

/**
 * Store-wide Product Analytics (Store Performance → Product analytics). One request per period and table page; peso
 * values arrive only for the Owner. Every panel states what it is for and how it is calculated.
 */
export function ProductAnalyticsWorkspace() {
  const [params, setParams] = useSearchParams()
  const period = parsePeriod(params.get('days'))
  const sort = (SORTS.some(item => item.value === params.get('sort')) ? params.get('sort') : 'views') as ProductSort
  const page = Math.max(1, Number(params.get('page') ?? '1') || 1)
  const update = (patch: Record<string, string | null>) => setParams(current => { const next = new URLSearchParams(current); for (const [key, value] of Object.entries(patch)) { if (value) next.set(key, value); else next.delete(key) } return next }, { replace: true })
  const loader = useCallback(() => getProductAnalytics(period, sort, page), [period, sort, page])
  const { data, error, pending, refresh } = usePortalResource(`vendor-product-analytics-${period}-${sort}-${page}`, loader)
  const message = useErrorText(error)
  const toolbar = <div className="flex flex-wrap items-center justify-between gap-3">
    <PeriodSelector label="Period" value={period} options={ANALYTICS_PERIODS} disabled={pending && !data} onChange={value => update({ days: String(value), page: null })} />
    {data && <p className="text-xs text-text-secondary">{formatChartDay(day(data.period.from))} – {formatChartDay(day(data.period.to))} · Asia/Manila · updated {new Date(data.generatedAt).toLocaleTimeString('en-PH', { hour: 'numeric', minute: '2-digit' })}</p>}
  </div>
  if (!data) return <div className="space-y-5">{toolbar}{message ? <ErrorState message={message} onRetry={() => void refresh()} /> : <LoadingState label="Loading product analytics…" />}</div>
  const sales = data.access.salesValue
  const kpis = data.kpis
  const periodLabel = `previous ${data.period.days} days`
  const leaderSelling = Math.max(1, ...data.topSelling.map(row => (sales ? row.valueCentavos ?? 0 : row.orders)))
  const leaderViews = Math.max(1, ...data.mostViewed.map(row => row.views))
  const definitions = data.definitions
  return <div className="space-y-5">
    {toolbar}
    {message && <StatusMessage tone="error">{message} Showing the last successful update.</StatusMessage>}
    <TrackingNote since={data.tracking.viewsSince} from={data.period.from} />
    <dl aria-label="Product analytics summary" className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
      <KpiCard label="Product views" value={formatCount(kpis.views.value)} delta={{ changePercent: kpis.views.changePercent, periodLabel }} sparkline={data.series.map(point => point.views)} icon={<Eye size={16} aria-hidden="true" />} accent
        hint={`${formatCount(kpis.viewers.value)} distinct Buyers · ${formatCount(kpis.productsViewed.value)} of ${formatCount(kpis.productsViewed.total)} products viewed.`} />
      <KpiCard label="View-to-order conversion" value={percent(kpis.conversion)} icon={<MousePointerClick size={16} aria-hidden="true" />}
        hint={kpis.conversion.denominator === 0 ? 'No viewers in this period.' : `${formatCount(kpis.conversion.numerator)} of ${formatCount(kpis.conversion.denominator)} viewers ordered a product they viewed.`} />
      <KpiCard label="Orders with your products" value={formatCount(kpis.orders.value)} delta={{ changePercent: kpis.orders.changePercent, periodLabel }} sparkline={data.series.map(point => point.orders)} icon={<ShoppingCart size={16} aria-hidden="true" />} hint="Confirmed orders in the period, excluding fully refunded." />
      {sales && kpis.valueCentavos
        ? <KpiCard label="Product sales value" value={formatPesoCentavos(kpis.valueCentavos.value)} delta={{ changePercent: kpis.valueCentavos.changePercent, periodLabel }} icon={<Wallet size={16} aria-hidden="true" />} hint="Line value; fully refunded orders excluded." />
        : <KpiCard label="Buyers viewing" value={formatCount(kpis.viewers.value)} delta={{ changePercent: kpis.viewers.changePercent, periodLabel }} icon={<Users size={16} aria-hidden="true" />} hint="Distinct Buyers who opened at least one of your products. Peso values are available to the Owner." />}
    </dl>

    <ViewsTrend series={data.series} forecast={data.forecast.views} horizonDays={data.forecast.horizonDays} method={<>{definitions.views} {definitions.orders} {definitions.forecast}</>} />

    <div className="flex items-center gap-3"><h2 className="text-xs font-semibold uppercase tracking-widest text-action-primary">Top performance</h2><div className="h-px flex-1 bg-border-default" /></div>
    <div className="grid items-start gap-5 xl:grid-cols-3">
      <InsightPanel title="Top selling products" purpose={sales ? 'Your best sellers by sales value, to plan stock and pricing.' : 'Your best sellers by confirmed orders, to plan stock.'} method={definitions.top_selling}>
        <RankedList label="Top selling products" empty="No product was ordered in this period." items={data.topSelling.map(row => ({ key: row.listingId, label: productLink(row), title: row.name, meta: row.category,
          value: sales ? formatPesoCentavos(row.valueCentavos ?? null) : `${formatCount(row.orders)} orders`, detail: sales ? `${formatCount(row.orders)} orders · ${formatCount(row.buyers)} Buyers` : `${formatCount(row.buyers)} Buyers`,
          share: (sales ? row.valueCentavos ?? 0 : row.orders) / leaderSelling }))} />
      </InsightPanel>
      <InsightPanel title="Top performing products" purpose="Products that turn views into orders most reliably — the ones worth keeping in stock and featuring." method={definitions.top_performing}>
        <RankedList label="Top performing products" colorVar="--mp-viz-series-3" empty="No viewer has ordered a product they viewed in this period yet." items={data.topPerforming.map(row => ({ key: row.listingId, label: productLink(row), title: row.name, meta: row.category,
          value: percent(row.conversion), detail: `${formatCount(row.converted)} of ${formatCount(row.viewers)} viewers`, share: row.conversionLowerBound ?? 0 }))} />
      </InsightPanel>
      <InsightPanel title="Most viewed products" purpose="Where Buyer attention goes. A product viewed often but rarely ordered may need a price or listing review." method={definitions.most_viewed}>
        <RankedList label="Most viewed products" colorVar="--mp-viz-series-2" empty="No product was viewed in this period." items={data.mostViewed.map(row => ({ key: row.listingId, label: productLink(row), title: row.name, meta: row.category,
          value: `${formatCount(row.views)} views`, detail: `${percent(row.conversion)} converted`, share: row.views / leaderViews }))} />
      </InsightPanel>
    </div>

    <InsightPanel title="Suggestions" purpose="What to do next, worked out from your own views, orders, stock and mining results. Nothing changes until you act." method={definitions.suggestions}>
      <InsightList items={suggestionItems(data.suggestions)} empty="No suggestions right now. They appear as Buyers view and order your products." />
    </InsightPanel>

    <div className="grid items-start gap-5 xl:grid-cols-2">
      <InsightPanel title="Category share" purpose={sales ? 'How your sales value splits across material categories.' : 'How your orders split across material categories.'} method={definitions.categories}>
        <ShareBar label="Category share" empty="No category had orders in this period." formatValue={value => (sales ? formatPesoCentavos(value) : formatCount(value))}
          segments={data.categories.map((category, index) => ({ key: category.category, label: category.category, value: sales ? category.valueCentavos ?? 0 : category.orders, colorVar: SLOTS[index % SLOTS.length] ?? '--mp-viz-series-1' }))} />
        <BarList label="Views by category" colorVar="--mp-viz-series-2" empty="No category was viewed in this period." items={data.categories.map(category => ({ key: category.category, label: category.category, value: category.views, display: `${formatCount(category.views)} views`, detail: `${formatCount(category.orders)} orders` }))} />
      </InsightPanel>
      <InsightPanel title="Frequently ordered together" purpose="Products Buyers order in the same order — useful for stocking pairs and offering them together in quotations." method={definitions.basket_rules}>
        <AssociationRuleList countLabel="orders" empty={`No pattern yet: a pair must appear in at least two orders from two different Buyers (${formatCount(data.basketRules.baskets)} orders checked in the last ${data.basketRules.windowDays} days).`}
          rules={data.basketRules.rules.map(rule => ({ antecedent: rule.antecedent, consequent: rule.consequent, confidence: rule.confidence, lift: rule.lift, supportCount: rule.supportCount }))} />
      </InsightPanel>
    </div>

    <InsightPanel title="Product performance segments" purpose="Your products grouped by similar views, conversion and orders, so you can treat each group differently." method={<>{definitions.segments}{data.segments.silhouette !== null && data.segments.silhouette !== undefined ? ` Silhouette ${data.segments.silhouette.toFixed(2)} (closer to 1 means clearer groups).` : ''}</>}>
      {data.segments.state !== 'OK' ? <p className="text-sm text-text-secondary">{data.segments.reason ?? 'Not enough products with activity to group yet.'}</p> : <>
        <SegmentScatter title="Products by views and conversion" xLabel="Product views" yLabel="Conversion %" groups={data.segments.segments.map(segment => segment.label)} formatY={value => `${Math.round(value)}%`}
          points={data.segments.points.map(point => ({ key: point.listingId, label: point.name, x: point.views, y: point.conversionPercent, group: point.segment }))} />
        <ul className="grid gap-4 md:grid-cols-2 xl:grid-cols-4">{data.segments.segments.map(segment => <li key={segment.id} className="grid gap-1 border-l-2 border-border-default pl-4 text-sm">
          <span className="font-semibold text-text-strong">{segment.label}</span>
          <span className="text-text-secondary">{formatCount(segment.size)} products · about {formatCount(segment.averageViews)} views, {formatCount(segment.averageConversionPercent)}% conversion and {formatCount(segment.averageOrders)} orders each</span>
          <span className="text-xs text-text-secondary">e.g. {segment.examples.join(', ')}</span></li>)}</ul>
      </>}
    </InsightPanel>

    <InsightPanel title="All products" purpose="Every published product with its measures for the period. Open a product for its own trend, forecast and suggestions." method={<>{definitions.conversion} {definitions.stock}</>}
      action={<div className="w-48"><Select label="Sort products" hideLabel value={sort} onChange={event => update({ sort: event.target.value, page: null })}>{SORTS.filter(item => sales || item.value !== 'value').map(item => <option key={item.value} value={item.value}>{item.label}</option>)}</Select></div>}>
      <ProductTable rows={data.products.items} sales={sales} />
      {data.products.meta.lastPage > 1 && <Pagination page={data.products.meta.page} lastPage={data.products.meta.lastPage} total={data.products.meta.total} busy={pending} onChange={next => update({ page: String(next) })} />}
    </InsightPanel>
  </div>
}

function ChangeText({ value }: { value: number | null | undefined }) {
  const Icon = value === null || value === undefined || value === 0 ? Minus : value > 0 ? ArrowUpRight : ArrowDownRight
  return <span className="inline-flex items-center gap-0.5 text-xs text-text-secondary"><Icon size={12} aria-hidden="true" />{value === null || value === undefined ? 'new' : `${value > 0 ? '+' : ''}${value.toFixed(1)}%`}</span>
}

function ProductTable({ rows, sales }: { rows: ProductAnalyticsRow[]; sales: boolean }) {
  if (rows.length === 0) return <p className="text-sm text-text-secondary">No published products yet. Products appear here after you publish them.</p>
  const columns: RecordColumn<ProductAnalyticsRow>[] = [
    { key: 'product', header: 'Product', cell: row => <span className="grid"><Link className="font-semibold text-action-primary underline-offset-4 hover:underline" to={`/performance/products/${row.listingId}`}>{row.name}</Link><span className="text-xs text-text-secondary">{row.category}{row.sku ? ` · SKU ${row.sku}` : ''}</span></span> },
    { key: 'views', header: 'Views', cell: row => <span className="grid whitespace-nowrap tabular-nums"><span>{formatCount(row.views)} <ChangeText value={row.viewsChangePercent} /></span><span className="text-xs text-text-secondary">{formatCount(row.viewers)} Buyers</span></span> },
    { key: 'conversion', header: 'Conversion', cell: row => <span className="whitespace-nowrap tabular-nums">{percent(row.conversion)}</span> },
    { key: 'orders', header: 'Orders', cell: row => <span className="whitespace-nowrap tabular-nums">{formatCount(row.orders)}</span> },
    ...(sales ? [{ key: 'value', header: 'Sales value', cell: (row: ProductAnalyticsRow) => <span className="whitespace-nowrap tabular-nums">{formatPesoCentavos(row.valueCentavos ?? null)}</span> }] : []),
    { key: 'segment', header: 'Segment', cell: row => row.segment ?? <span className="text-text-secondary">—</span> },
    { key: 'stock', header: 'Stock', cell: row => <StatusBadge label={STOCK[row.stockStatus]?.label ?? row.stockStatus} tone={STOCK[row.stockStatus]?.tone ?? 'neutral'} /> },
  ]
  return <ResponsiveRecordList caption="Product measures" rows={rows} columns={columns} rowKey={row => row.listingId} cardTitle={row => <Link className="text-action-primary underline" to={`/performance/products/${row.listingId}`}>{row.name}</Link>} />
}

/** One product's analytics (route /performance/products/:listingId); the shell checks catalog.manage and the API checks it again. */
export function ProductAnalyticsDetail({ canViewReviews = false }: { canViewReviews?: boolean }) {
  const { listingId = '' } = useParams()
  const [params, setParams] = useSearchParams()
  const period = parsePeriod(params.get('days'))
  const loader = useCallback(() => getProductAnalyticsDetail(listingId, period), [listingId, period])
  const { data, error, pending, refresh } = usePortalResource(`vendor-product-analytics-${listingId}-${period}`, loader)
  const message = useErrorText(error)
  const back = <div className="flex flex-wrap gap-x-6"><Link to={`/performance?tab=products&days=${period}`} className={link}>← Product analytics</Link><Link to="/products" className={link}>My Products</Link></div>
  if (!data) return <div className="space-y-4">{back}{message ? <ErrorState message={message} onRetry={() => void refresh()} /> : <LoadingState label="Loading product analytics…" />}</div>
  const product = data.product
  const kpis = data.kpis
  const sales = data.access.salesValue
  const periodLabel = `previous ${data.period.days} days`
  const labels = data.series.map(point => day(point.date))
  const markers: TrendMarker[] = data.unusualDays.days.map(item => ({ index: labels.indexOf(day(item.date)), label: 'Unusual day' })).filter(marker => marker.index >= 0)
  const definitions = data.definitions
  return <div className="space-y-6">
    {back}
    <PageHeader eyebrow={`Product analytics · ${product.category}`} title={product.name} description={`${product.sku ? `SKU ${product.sku} · ` : ''}How Buyers find, view and order this product.`}
      actions={<><PeriodSelector label="Period" value={period} options={ANALYTICS_PERIODS} disabled={pending} onChange={value => setParams(current => { const next = new URLSearchParams(current); next.set('days', String(value)); return next }, { replace: true })} />
        <Link className="inline-flex min-h-11 items-center gap-2 rounded-control border border-border-default bg-surface-primary px-4 text-sm font-semibold hover:bg-surface-canvas" to={`/products/${product.listingId}`}><PencilLine size={16} aria-hidden="true" />Edit listing</Link></>} />
    {message && <StatusMessage tone="error">{message} Showing the last successful update.</StatusMessage>}
    <TrackingNote since={data.tracking.viewsSince} from={data.period.from} />
    <ul aria-label="Product standing" className="flex flex-wrap gap-2 text-sm">
      <li className="rounded-pill border border-border-default bg-surface-primary px-3 py-1">{product.rankViews ? `#${product.rankViews} of ${kpis.products} by views` : 'Not viewed in this period'}</li>
      <li className="rounded-pill border border-border-default bg-surface-primary px-3 py-1">{product.rankOrders ? `#${product.rankOrders} of ${kpis.products} by orders` : 'No orders in this period'}</li>
      {product.segment && <li className="rounded-pill border border-border-default bg-surface-primary px-3 py-1">Segment: {product.segment}</li>}
      <li><StatusBadge label={STOCK[product.stockStatus]?.label ?? product.stockStatus} tone={STOCK[product.stockStatus]?.tone ?? 'neutral'} /></li>
    </ul>
    <dl aria-label="Product summary" className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
      <KpiCard label="Product views" value={formatCount(kpis.views.value)} delta={{ changePercent: kpis.views.changePercent, periodLabel }} sparkline={data.series.map(point => point.views)} icon={<Eye size={16} aria-hidden="true" />} accent hint={`${formatCount(kpis.viewers.value)} distinct Buyers.`} />
      <KpiCard label="View-to-order conversion" value={percent(kpis.conversion)} icon={<MousePointerClick size={16} aria-hidden="true" />} hint={`Store average ${percent(kpis.storeConversion)} · ${formatCount(kpis.conversion.numerator)} of ${formatCount(kpis.conversion.denominator)} viewers ordered.`} />
      <KpiCard label="Orders" value={formatCount(kpis.orders.value)} delta={{ changePercent: kpis.orders.changePercent, periodLabel }} icon={<ShoppingCart size={16} aria-hidden="true" />} hint={`${formatCount(kpis.buyers)} distinct Buyers ordered.`} />
      {sales && kpis.valueCentavos
        ? <KpiCard label="Sales value" value={formatPesoCentavos(kpis.valueCentavos.value)} delta={{ changePercent: kpis.valueCentavos.changePercent, periodLabel }} icon={<Wallet size={16} aria-hidden="true" />} hint="Line value; fully refunded orders left out." />
        : <KpiCard label="Rank by orders" value={product.rankOrders ? `#${product.rankOrders}` : '—'} icon={<BarChart3 size={16} aria-hidden="true" />} hint={`Among ${formatCount(kpis.products)} published products.`} />}
    </dl>
    <ViewsTrend series={data.series} forecast={data.forecast.views} horizonDays={data.forecast.horizonDays} markers={markers} subject="this product"
      method={<>{definitions.views} {definitions.forecast} {definitions.unusual_days}{data.unusualDays.state !== 'OK' ? ' Unusual days need at least eight active days.' : ''}</>} />
    <div className="grid items-start gap-5 xl:grid-cols-2">
      <InsightPanel title="From view to order" purpose="How many Buyers saw this product and how many went on to order it, compared with your store." method={definitions.conversion}>
        <BarList label="From view to order" items={[
          { key: 'views', label: 'Product views', value: kpis.views.value, display: formatCount(kpis.views.value), detail: 'One per Buyer per day.' },
          { key: 'viewers', label: 'Buyers who viewed', value: kpis.viewers.value, display: formatCount(kpis.viewers.value) },
          { key: 'converted', label: 'Viewers who ordered it', value: kpis.conversion.numerator, display: formatCount(kpis.conversion.numerator), detail: `${percent(kpis.conversion)} of viewers · store ${percent(kpis.storeConversion)}` },
        ]} empty="No views in this period." />
      </InsightPanel>
      <InsightPanel title="Frequently ordered with" purpose="Products that appear in the same orders as this one — candidates to keep in stock together." method={definitions.basket_rules}>
        <AssociationRuleList countLabel="orders" empty={`No pattern with this product yet (${formatCount(data.basketRules.baskets)} store orders checked in the last ${data.basketRules.windowDays} days).`}
          rules={data.basketRules.rules.map(rule => ({ antecedent: rule.antecedent, consequent: rule.consequent, confidence: rule.confidence, lift: rule.lift, supportCount: rule.supportCount }))} />
      </InsightPanel>
    </div>
    <InsightPanel title="Suggestions for this product" purpose="Next steps worked out from this product’s views, orders, stock and trend." method={definitions.suggestions}>
      <InsightList items={suggestionItems(data.suggestions)} empty="No suggestions for this product right now." />
    </InsightPanel>
    <p className="text-xs text-text-secondary">Analytics never changes your listing, price or ranking. Values are an internal operational view, not a tax invoice or accounting record.</p>
    <ProductReviewsSection listingId={product.listingId} canView={canViewReviews} />
  </div>
}

/** The compact 30-day analytics line on a My Products card or row, with the shortcut into the product's analytics. */
export function ProductInsightStrip({ listingId, summary, compact = false }: { listingId: string; summary: ProductSummary | undefined; compact?: boolean }) {
  const shortcut = <Link className="inline-flex min-h-11 items-center gap-1 text-sm font-semibold text-action-primary underline-offset-4 hover:underline" to={`/performance/products/${listingId}`} aria-label="View product analytics"><BarChart3 size={14} aria-hidden="true" />Analytics</Link>
  if (!summary) return compact ? shortcut : <div className="flex items-center justify-between gap-2 border-t border-border-default px-4 py-1 text-xs text-text-secondary"><span>Analytics loading…</span>{shortcut}</div>
  const stats = <dl className="flex flex-wrap items-center gap-x-4 gap-y-1 text-xs text-text-secondary">
    <div className="flex items-center gap-1"><dt className="inline-flex items-center gap-1"><Eye size={12} aria-hidden="true" /><span className="sr-only">Views, last 30 days</span></dt><dd className="inline-flex items-center gap-1"><strong className="font-semibold tabular-nums text-text-strong">{formatCount(summary.views)}</strong> views<ChangeText value={summary.viewsChangePercent} /></dd></div>
    <div className="flex items-center gap-1"><dt className="sr-only">Orders, last 30 days</dt><dd><strong className="font-semibold tabular-nums text-text-strong">{formatCount(summary.orders)}</strong> orders</dd></div>
    <div className="flex items-center gap-1"><dt className="sr-only">View-to-order conversion</dt><dd><strong className="font-semibold tabular-nums text-text-strong">{percent(summary.conversion)}</strong> conversion</dd></div>
  </dl>
  if (compact) return <div className="grid gap-1">{stats}{shortcut}</div>
  return <div className="grid gap-1 border-t border-border-default px-4 py-2">
    <div className="flex items-center justify-between gap-2"><span className="text-[11px] font-semibold uppercase tracking-[0.08em] text-text-secondary">Last 30 days</span>{shortcut}</div>
    {stats}
    {summary.dailyViews.some(value => value > 0) && <div className="w-full" aria-hidden="true"><Sparkline values={summary.dailyViews} /></div>}
  </div>
}

/** Store Performance opened on its Product analytics tab. */
const PRODUCT_ANALYTICS_HREF = '/performance?tab=products'

export function ProductAnalyticsShortcut({ label = 'Product analytics' }: { label?: string }) {
  return <Link className="inline-flex min-h-11 items-center gap-2 rounded-control border border-border-default bg-surface-primary px-4 text-sm font-semibold text-text-strong hover:bg-surface-canvas" to={PRODUCT_ANALYTICS_HREF}><BarChart3 size={16} aria-hidden="true" />{label}</Link>
}
