import { useCallback, useEffect, useState, type ReactNode } from 'react'
import { Link, useLocation, useNavigate, useParams, useSearchParams } from 'react-router-dom'
import { ArrowDownRight, ArrowRight, ArrowUpRight, BarChart3, Eye, Minus, MousePointerClick, ShoppingCart, Wallet } from 'lucide-react'
import { BackNavigation,
  AnalyticsChartCard, AnalyticsSummary, AnalyticsDetails, AssociationRuleList, AsyncLoading, BarList, ChartDataTable, DashboardPanel, MaterialQualityCard, MethodNote, InfoNote, InsightList, InsightPanel, Pagination, PeriodSelector, RankedList, ResponsiveRecordList, SegmentedControl, SegmentScatter,
  ProductDetailWorkspace, ShareBar, Sparkline, StatusBadge, StatusMessage, TrendLineChart, analyticsDay, formatChartDay, formatCount, formatPesoCentavos, usePortalResource,
  type InsightItem, type RecordColumn, type TrendMarker, type VizColor,
} from '@materyalph/web-ui'
import type { DashboardRate, ProductAnalyticsSeriesPoint } from '@materyalph/api-client-ts'
import {
  ANALYTICS_PERIODS, getProductAnalytics, getProductAnalyticsDetail, parsePeriod,
  type AnalyticsPeriod, type ProductAnalyticsRow, type ProductAnalyticsSuggestion, type ProductSort, type ProductSummary, type VendorProductAnalytics,
} from '../lib/product-analytics-api'
import { readableApiError } from '../lib/auth-api'
import { ProductReviewsSection } from './VendorReviewPages'
import { ErrorState, LoadingState } from './PhaseThreeVendorPages'
import { ProductAnalyticsProduct } from './ProductAnalyticsProduct'
import { useProductAnalyticsListing } from '../lib/product-analytics-context'
import { getStorePerformance, type StorePerformance } from '../lib/trust-api'

const SLOTS: VizColor[] = ['--mp-viz-series-1', '--mp-viz-series-2', '--mp-viz-series-3', '--mp-viz-series-4', '--mp-viz-series-5', '--mp-viz-series-6']
const STOCK: Record<string, { label: string; tone: 'success' | 'warning' | 'error' }> = { IN_STOCK: { label: 'In stock', tone: 'success' }, LIMITED_STOCK: { label: 'Limited stock', tone: 'warning' }, OUT_OF_STOCK: { label: 'Out of stock', tone: 'error' } }
const SORTS: { value: ProductSort; label: string }[] = [{ value: 'views', label: 'Most viewed' }, { value: 'orders', label: 'Most ordered' }, { value: 'conversion', label: 'Best conversion' }, { value: 'value', label: 'Highest sales value' }]
const day = (value: Date | string) => analyticsDay(value) ?? ''
const percent = (rate: DashboardRate) => (rate.percent === null || rate.percent === undefined ? '—' : `${rate.percent}%`)
const link = 'inline-flex min-h-11 items-center gap-1 text-sm font-semibold text-action-primary underline-offset-4 hover:underline'

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

function ViewsTrend({ series, markers = [], method, subject = 'your products' }: { series: ProductAnalyticsSeriesPoint[]; markers?: TrendMarker[]; method: ReactNode; subject?: string }) {
  const labels = series.map(point => day(point.date))
  return <AnalyticsChartCard title="Product views and orders" description={`Views and confirmed orders for ${subject}.`} details={<>
    <ChartDataTable caption="Product views and orders per day" rowHeader="Date" rows={labels.map(formatChartDay)} columns={[
      { key: 'views', header: 'Product views', values: series.map(point => formatCount(point.views)) },
      { key: 'orders', header: 'Orders', values: series.map(point => formatCount(point.orders)) },
      ...(series.some(point => point.valueCentavos !== null && point.valueCentavos !== undefined) ? [{ key: 'value', header: 'Sales value', values: series.map(point => formatPesoCentavos(point.valueCentavos ?? null)) }] : []),
    ]} /><MethodNote>{method}</MethodNote></>}>
    <TrendLineChart title="Product views and orders per day" labels={labels} formatLabel={formatChartDay} formatValue={value => formatCount(Math.round(value * 10) / 10)} emptyReason="No views or orders in this period."
      series={[{ key: 'views', label: 'Product views', colorVar: '--mp-viz-series-1', values: series.map(point => point.views), kind: 'bar' }, { key: 'orders', label: 'Orders', colorVar: '--mp-viz-series-2', values: series.map(point => point.orders) }]}
      markers={markers} />
  </AnalyticsChartCard>
}

const productLink = (row: ProductAnalyticsRow) => <Link className="hover:text-action-primary hover:underline" to={`/analytics/products/${row.listingId}`}>{row.name}</Link>

/** Scores keep their own loading/retry boundary and their published 90-day window. */
function ProductMaterialQuality({ data, error, onRetry }: { data: StorePerformance | null; error: unknown; onRetry: () => void }) {
  const message = useErrorText(error)
  if (!data) return <DashboardPanel density="compact" title="Material quality (MQS)" description="Quality across your sold materials">
    {message ? <ErrorState message={message} onRetry={onRetry} /> : <LoadingState label="Loading material quality…" />}
  </DashboardPanel>
  return <div className="mp-product-quality-score">
    {message && <StatusMessage tone="error">{message} Showing the last successful score.</StatusMessage>}
    <MaterialQualityCard score={data.scores?.find(score => score.key === 'MQS')} />
  </div>
}

/**
 * Store-wide Product Analytics loads per period; table sorting and pagination have their own loading boundary.
 * Peso values arrive only for the Owner. Every panel states what it is for and how it is calculated.
 */
export function ProductAnalyticsWorkspace({ canViewScores = false }: { canViewScores?: boolean }) {
  const [params, setParams] = useSearchParams()
  const period = parsePeriod(params.get('days'))
  const update = (patch: Record<string, string | null>) => setParams(current => { const next = new URLSearchParams(current); for (const [key, value] of Object.entries(patch)) { if (value) next.set(key, value); else next.delete(key) } return next }, { replace: true })
  const loader = useCallback(() => getProductAnalytics(period, 'views', 1), [period])
  const { data, error, pending, refresh } = usePortalResource(`vendor-product-analytics-overview-${period}`, loader)
  const quality = usePortalResource('vendor-product-material-quality', getStorePerformance, canViewScores)
  const message = useErrorText(error)
  const toolbar = <div className="mp-product-analytics-toolbar">
    <PeriodSelector label="Period" value={period} options={ANALYTICS_PERIODS} disabled={pending && !data} onChange={value => update({ days: String(value), page: null })} />
    {data && <p className="text-xs text-text-secondary">{formatChartDay(day(data.period.from))} – {formatChartDay(day(data.period.to))} · Asia/Manila · updated {new Date(data.generatedAt).toLocaleTimeString('en-PH', { hour: 'numeric', minute: '2-digit' })}</p>}
  </div>
  if (!data) return <div className="mp-analytics space-y-3">{toolbar}{message ? <ErrorState message={message} onRetry={() => void refresh()} /> : <LoadingState label="Loading product analytics…" />}</div>
  const sales = data.access.salesValue
  const kpis = data.kpis
  const periodLabel = `previous ${data.period.days} days`
  const leaderSelling = Math.max(1, ...data.topSelling.map(row => (sales ? row.valueCentavos ?? 0 : row.orders)))
  const leaderViews = Math.max(1, ...data.mostViewed.map(row => row.views))
  const definitions = data.definitions
  return <div className="mp-analytics mp-product-analytics">
    {toolbar}
    {message && <StatusMessage tone="error">{message} Showing the last successful update.</StatusMessage>}
    <TrackingNote since={data.tracking.viewsSince} from={data.period.from} />
    <div className="mp-product-analytics-overview" data-has-quality={canViewScores || undefined}>
      <AnalyticsSummary density="compact" title="At a glance" featured={sales && kpis.valueCentavos
        ? { label: 'Product sales value', value: formatPesoCentavos(kpis.valueCentavos.value), icon: <Wallet size={16} aria-hidden="true" />, hint: 'Materials after discounts, VAT included. Before partial refunds; delivery excluded.', changePercent: kpis.valueCentavos.changePercent, comparison: `vs ${periodLabel}`, comparisonUnavailable: kpis.valueCentavos.previous === 0 ? `No sales in ${periodLabel}` : 'Previous period comparison unavailable' }
        : { label: 'Product views', value: formatCount(kpis.views.value), changePercent: kpis.views.changePercent, comparison: `vs ${periodLabel}`, comparisonUnavailable: kpis.views.previous === 0 ? `No views in ${periodLabel}` : 'Previous period comparison unavailable' }} metrics={[
          { label: 'Product views', value: formatCount(kpis.views.value), icon: <Eye size={15} />, hint: `${formatCount(kpis.viewers.value)} distinct Buyers · ${formatCount(kpis.productsViewed.value)} of ${formatCount(kpis.productsViewed.total)} products viewed.` },
          { label: 'View-to-order conversion', value: percent(kpis.conversion), icon: <MousePointerClick size={15} />, hint: kpis.conversion.denominator === 0 ? 'No viewers in this period.' : `${formatCount(kpis.conversion.numerator)} of ${formatCount(kpis.conversion.denominator)} viewers ordered a product they viewed.` },
          { label: 'Orders with your products', value: formatCount(kpis.orders.value), icon: <ShoppingCart size={15} />, changePercent: kpis.orders.changePercent, comparison: `vs ${periodLabel}`, comparisonUnavailable: kpis.orders.previous === 0 ? `No orders in ${periodLabel}` : 'Previous period comparison unavailable' },
        ]} />

      {canViewScores && <section aria-label="Product quality" className="mp-product-analytics-quality">
        <ProductMaterialQuality data={quality.data} error={quality.error} onRetry={() => void quality.refresh()} />
      </section>}
    </div>

    <div className="mp-product-analytics-columns">
      <div className="mp-product-analytics-trend">
        <ViewsTrend series={data.series} method={<>{definitions.views} {definitions.orders}</>} />
        {data.suggestions.length > 0 && <InsightPanel title="Suggestions" purpose="Actions based on product demand and stock." method={definitions.suggestions} scrollBody>
          <InsightList compact items={suggestionItems(data.suggestions)} empty="No suggestions right now. They appear as Buyers view and order your products." />
        </InsightPanel>}
      </div>
      <div className="mp-product-analytics-rankings">
        {data.topRated != null && <DashboardPanel density="compact" title="Top-rated products" description="Highest product ratings across your published products · All time" calculation={definitions.top_rated}>
          <RankedList label="Top-rated products" empty="No rated products yet. Products appear here after receiving an eligible, visible Product Quality rating." items={data.topRated.map(row => ({ key: row.listingId,
            label: <Link className="hover:text-action-primary hover:underline" to={`/analytics/products/${row.listingId}`}>{row.name}</Link>, title: row.name, meta: row.category,
            value: `${row.average} / 5`, detail: `${formatCount(row.count)} ${row.count === 1 ? 'rating' : 'ratings'}`, share: Number(row.average) / 5 }))} />
          <p className="mt-4 text-xs leading-5 text-text-secondary">Individual product averages are separate from your store’s rolling 90-day MQS. The selected analytics period does not change these ratings.</p>
        </DashboardPanel>}
        <InsightPanel title="Top selling products" purpose={sales ? 'Top 3 by sales value.' : 'Top 3 by confirmed orders.'} method={definitions.top_selling}>
          <RankedList label="Top selling products" empty="No product was ordered in this period." items={data.topSelling.slice(0, 3).map(row => ({ key: row.listingId, label: productLink(row), title: row.name, meta: row.category,
            value: sales ? formatPesoCentavos(row.valueCentavos ?? null) : `${formatCount(row.orders)} orders`, detail: sales ? `${formatCount(row.orders)} orders · ${formatCount(row.buyers)} Buyers` : `${formatCount(row.buyers)} Buyers`,
            share: (sales ? row.valueCentavos ?? 0 : row.orders) / leaderSelling }))} />
        </InsightPanel>
        <InsightPanel title="Top performing products" purpose="Top 3 by reliable view-to-order conversion." method={definitions.top_performing}>
          <RankedList label="Top performing products" colorVar="--mp-viz-series-3" empty="No viewer has ordered a product they viewed in this period yet." items={data.topPerforming.slice(0, 3).map(row => ({ key: row.listingId, label: productLink(row), title: row.name, meta: row.category,
            value: percent(row.conversion), detail: `${formatCount(row.converted)} of ${formatCount(row.viewers)} viewers`, share: row.conversionLowerBound ?? 0 }))} />
        </InsightPanel>
        <InsightPanel title="Category share" purpose={sales ? 'Sales value by material category.' : 'Confirmed orders by material category.'} method={definitions.categories}>
          <ShareBar variant="donut" label="Category share" empty="No category had orders in this period." formatValue={value => (sales ? formatPesoCentavos(value) : formatCount(value))}
            segments={data.categories.map((category, index) => ({ key: category.category, label: category.category, value: sales ? category.valueCentavos ?? 0 : category.orders, colorVar: SLOTS[index % SLOTS.length] ?? '--mp-viz-series-1' }))} />
        </InsightPanel>
      </div>

    </div>

    <ProductAnalyticsProducts overview={data} period={period} />
    <section aria-label="Product demand patterns" className="mp-product-demand">
      <header className="mp-product-analytics-section-heading"><h2>Product demand patterns</h2><p>Explore Buyer attention, ordering patterns and product groups.</p></header>
      <div className="mp-product-patterns">
        <InsightPanel title="Most viewed products" purpose="Where Buyer attention goes. A product viewed often but rarely ordered may need a price or listing review." method={definitions.most_viewed}>
          <RankedList label="Most viewed products" colorVar="--mp-viz-series-2" empty="No product was viewed in this period." items={data.mostViewed.map(row => ({ key: row.listingId, label: productLink(row), title: row.name, meta: row.category,
            value: `${formatCount(row.views)} views`, detail: `${percent(row.conversion)} converted`, share: row.views / leaderViews }))} />
        </InsightPanel>
        <InsightPanel title="Frequently ordered together" purpose="Products Buyers order in the same order — useful for stocking pairs and offering them together in quotations." method={definitions.basket_rules}>
          <AssociationRuleList countLabel="orders" empty={`No pattern yet: a pair must appear in at least two orders from two different Buyers (${formatCount(data.basketRules.baskets)} orders checked in the last ${data.basketRules.windowDays} days).`}
            rules={data.basketRules.rules.map(rule => ({ antecedent: rule.antecedent, consequent: rule.consequent, confidence: rule.confidence, lift: rule.lift, supportCount: rule.supportCount }))} />
        </InsightPanel>
        <InsightPanel title="Views by category" purpose="Buyer attention across your material categories." method={definitions.categories}>
          <BarList label="Views by category" colorVar="--mp-viz-series-2" empty="No category was viewed in this period." items={data.categories.map(category => ({ key: category.category, label: category.category, value: category.views, display: `${formatCount(category.views)} views`, detail: `${formatCount(category.orders)} orders` }))} />
        </InsightPanel>
        <InsightPanel title="Product performance segments" purpose="Your products grouped by similar views, conversion and orders, so you can treat each group differently." method={<>{definitions.segments}{data.segments.silhouette !== null && data.segments.silhouette !== undefined ? ` Silhouette ${data.segments.silhouette.toFixed(2)} (closer to 1 means clearer groups).` : ''}</>}>
          {data.segments.state !== 'OK' ? <SegmentScatter compact title="Products by views and conversion" xLabel="Product views" yLabel="Conversion %" groups={[]} points={[]} emptyReason={data.segments.reason ?? 'Not enough products with activity to group yet.'} /> : <>
            <SegmentScatter title="Products by views and conversion" xLabel="Product views" yLabel="Conversion %" groups={data.segments.segments.map(segment => segment.label)} formatY={value => `${Math.round(value)}%`}
              points={data.segments.points.map(point => ({ key: point.listingId, label: point.name, x: point.views, y: point.conversionPercent, group: point.segment }))} />
            <ul className="mp-product-analytics-segments">{data.segments.segments.map(segment => <li key={segment.id} className="grid gap-1 border-l-2 border-border-default pl-4 text-sm">
              <span className="font-semibold text-text-strong">{segment.label}</span>
              <span className="text-text-secondary">{formatCount(segment.size)} products · about {formatCount(segment.averageViews)} views, {formatCount(segment.averageConversionPercent)}% conversion and {formatCount(segment.averageOrders)} orders each</span>
              <span className="text-xs text-text-secondary">e.g. {segment.examples.join(', ')}</span></li>)}</ul>
          </>}
        </InsightPanel>
      </div>
    </section>
  </div>
}

function ChangeText({ value }: { value: number | null | undefined }) {
  const Icon = value === null || value === undefined || value === 0 ? Minus : value > 0 ? ArrowUpRight : ArrowDownRight
  return <span className="inline-flex items-center gap-0.5 text-xs text-text-secondary"><Icon size={12} aria-hidden="true" />{value === null || value === undefined ? 'new' : `${value > 0 ? '+' : ''}${value.toFixed(1)}%`}</span>
}

/** Keep the panel, controls and table height mounted while a different sort or page is requested. */
function ProductAnalyticsProducts({ overview, period }: { overview: VendorProductAnalytics; period: AnalyticsPeriod }) {
  const [params, setParams] = useSearchParams()
  const sort = (SORTS.some(item => item.value === params.get('sort')) ? params.get('sort') : 'views') as ProductSort
  const page = Math.max(1, Number(params.get('page') ?? '1') || 1)
  const initial = sort === 'views' && page === 1
  const loader = useCallback(() => getProductAnalytics(period, sort, page), [period, sort, page])
  const resource = usePortalResource(`vendor-product-analytics-${period}-${sort}-${page}`, loader, !initial)
  const data = initial ? overview : resource.data
  const message = useErrorText(initial ? null : resource.error)
  const pending = !initial && (resource.pending || (!data && !resource.error))
  const products = data?.products ?? overview.products
  const sales = overview.access.salesValue && (data?.access.salesValue ?? false)
  const update = (patch: Record<string, string | null>) => setParams(current => {
    const next = new URLSearchParams(current)
    for (const [key, value] of Object.entries(patch)) { if (value) next.set(key, value); else next.delete(key) }
    return next
  }, { replace: true, preventScrollReset: true })
  return <InsightPanel title="All products" purpose={`${formatCount(products.meta.total)} published products · Compare views, orders and conversion for the selected dates.`} method={<>{overview.definitions.conversion} {overview.definitions.stock}</>}>
    <SegmentedControl label="Sort products" value={sort} options={SORTS.filter(item => overview.access.salesValue || item.value !== 'value')} onChange={value => update({ sort: value, page: null })} />
    {pending && data && <AsyncLoading compact label="Updating products…" />}
    <div className="grid min-w-0" aria-busy={pending}>
      <div aria-hidden={!data || undefined} className={`min-w-0 [grid-area:1/1]${data ? '' : ' invisible'}`}>
        <ProductTable rows={products.items} sales={data ? sales : overview.access.salesValue} />
        {products.meta.lastPage > 1 && <Pagination page={data ? products.meta.page : page} lastPage={products.meta.lastPage} total={products.meta.total} busy={pending || !data} onChange={next => update({ page: String(next) })} />}
      </div>
      {!data && <div className="min-w-0 self-start [grid-area:1/1]">{message ? <ErrorState message={message} onRetry={() => void resource.refresh()} /> : <AsyncLoading label="Loading products…" />}</div>}
    </div>
  </InsightPanel>
}

function ProductTable({ rows, sales }: { rows: ProductAnalyticsRow[]; sales: boolean }) {
  if (rows.length === 0) return <p className="text-sm text-text-secondary">No published products yet. Products appear here after you publish them.</p>
  const columns: RecordColumn<ProductAnalyticsRow>[] = [
    { key: 'product', header: 'Product', cell: row => <span className="grid"><Link className="font-semibold text-action-primary underline-offset-4 hover:underline" to={`/analytics/products/${row.listingId}`}>{row.name}</Link><span className="text-xs text-text-secondary">{row.category}{row.sku ? ` · SKU ${row.sku}` : ''}</span></span> },
    { key: 'views', header: 'Views', cell: row => <span className="grid whitespace-nowrap tabular-nums"><span>{formatCount(row.views)} <ChangeText value={row.viewsChangePercent} /></span><span className="text-xs text-text-secondary">{formatCount(row.viewers)} Buyers</span></span> },
    { key: 'conversion', header: 'Conversion', cell: row => <span className="whitespace-nowrap tabular-nums">{percent(row.conversion)}</span> },
    { key: 'orders', header: 'Orders', cell: row => <span className="whitespace-nowrap tabular-nums">{formatCount(row.orders)}</span> },
    ...(sales ? [{ key: 'value', header: 'Sales value', cell: (row: ProductAnalyticsRow) => <span className="whitespace-nowrap tabular-nums">{formatPesoCentavos(row.valueCentavos ?? null)}</span> }] : []),
    { key: 'segment', header: 'Segment', cell: row => row.segment ?? <span className="text-text-secondary">—</span> },
    { key: 'stock', header: 'Stock', cell: row => <StatusBadge label={STOCK[row.stockStatus]?.label ?? row.stockStatus} tone={STOCK[row.stockStatus]?.tone ?? 'neutral'} /> },
  ]
  return <ResponsiveRecordList compact caption="Product measures" rows={rows} columns={columns} rowKey={row => row.listingId} tableClassName="[&_th]:whitespace-nowrap" cardTitle={row => <Link className="text-action-primary underline" to={`/analytics/products/${row.listingId}`}>{row.name}</Link>} />
}

/** One product's analytics (route /analytics/products/:listingId); the shell checks catalog.manage and the API checks it again. */
export function ProductAnalyticsDetail({ canViewReviews = false }: { canViewReviews?: boolean }) {
  const location = useLocation()
  const navigate = useNavigate()
  const { listingId = '' } = useParams()
  const [params, setParams] = useSearchParams()
  const period = parsePeriod(params.get('days'))
  const loader = useCallback(() => getProductAnalyticsDetail(listingId, period), [listingId, period])
  const { data, error, pending, refresh } = usePortalResource(`vendor-product-analytics-${listingId}-${period}`, loader)
  const context = useProductAnalyticsListing(listingId)
  const contextMessage = useErrorText(context.error)
  const message = useErrorText(error)
  const returnTo = location.state && typeof location.state === 'object' && 'returnTo' in location.state && typeof location.state.returnTo === 'string' && /^\/products(?:\?[^#]*)?$/.test(location.state.returnTo) ? location.state.returnTo : null
  const back = <BackNavigation><button type="button" onClick={() => {
    if (returnTo) navigate(returnTo)
    else if (typeof window.history.state?.idx === 'number' && window.history.state.idx > 0) navigate(-1)
    else navigate(`/analytics/products?days=${period}`)
  }}>Return</button></BackNavigation>
  const information = <ProductAnalyticsProduct product={data?.product ?? { listingId, name: context.data?.listing.displayName ?? 'Product', sku: context.data?.listing.vendorSku ?? null, category: context.data?.listing.material?.name ?? 'Product' }} context={context.data} error={contextMessage} refreshing={context.pending} onRetry={() => void context.refresh()} />
  if (!data) return <div className="space-y-3">{back}<ProductDetailWorkspace information={information}>{message ? <ErrorState message={message} onRetry={() => void refresh()} /> : <LoadingState label="Loading product analytics…" />}</ProductDetailWorkspace></div>
  const product = data.product
  const kpis = data.kpis
  const sales = data.access.salesValue
  const periodLabel = `previous ${data.period.days} days`
  const labels = data.series.map(point => day(point.date))
  const markers: TrendMarker[] = data.unusualDays.days.map(item => ({ index: labels.indexOf(day(item.date)), label: 'Unusual day' })).filter(marker => marker.index >= 0)
  const definitions = data.definitions
  return <div className="space-y-3">
    {back}
    <ProductDetailWorkspace information={information}>
    <div className="flex min-w-0 flex-wrap items-start justify-between gap-4">
      <div><h2 className="text-lg font-semibold">Analytics &amp; reviews</h2><p className="mt-1 text-xs text-text-secondary">Views and orders across all variants.</p></div>
      <PeriodSelector label="Period" value={period} options={ANALYTICS_PERIODS} disabled={pending} onChange={value => setParams(current => { const next = new URLSearchParams(current); next.set('days', String(value)); return next }, { replace: true })} />
    </div>
    {message && <StatusMessage tone="error">{message} Showing the last successful update.</StatusMessage>}
    <TrackingNote since={data.tracking.viewsSince} from={data.period.from} />
    <ul aria-label="Product standing" className="flex flex-wrap gap-2 text-sm">
      <li className="rounded-pill border border-border-default bg-surface-primary px-3 py-1">{product.rankViews ? `#${product.rankViews} of ${kpis.products} by views` : 'Not viewed in this period'}</li>
      <li className="rounded-pill border border-border-default bg-surface-primary px-3 py-1">{product.rankOrders ? `#${product.rankOrders} of ${kpis.products} by orders` : 'No orders in this period'}</li>
      {product.segment && <li className="rounded-pill border border-border-default bg-surface-primary px-3 py-1">Segment: {product.segment}</li>}
      <li><StatusBadge label={STOCK[product.stockStatus]?.label ?? product.stockStatus} tone={STOCK[product.stockStatus]?.tone ?? 'neutral'} /></li>
    </ul>
    <AnalyticsSummary density="compact" featured={{ label: 'Product views', value: formatCount(kpis.views.value), icon: <Eye size={16} aria-hidden="true" />, hint: `${formatCount(kpis.viewers.value)} distinct Buyers.`, changePercent: kpis.views.changePercent, comparison: `vs ${periodLabel}`, comparisonUnavailable: kpis.views.previous === 0 ? `No views in ${periodLabel}` : 'Previous period comparison unavailable' }} metrics={[
      { label: 'View-to-order conversion', value: percent(kpis.conversion), icon: <MousePointerClick size={16} aria-hidden="true" />, hint: `Store average ${percent(kpis.storeConversion)} · ${formatCount(kpis.conversion.numerator)} of ${formatCount(kpis.conversion.denominator)} viewers ordered.` },
      { label: 'Orders', value: formatCount(kpis.orders.value), icon: <ShoppingCart size={16} aria-hidden="true" />, hint: `${formatCount(kpis.buyers)} distinct Buyers ordered.`, changePercent: kpis.orders.changePercent, comparison: `vs ${periodLabel}`, comparisonUnavailable: kpis.orders.previous === 0 ? `No orders in ${periodLabel}` : 'Previous period comparison unavailable' },
      sales && kpis.valueCentavos ? { label: 'Product sales value', value: formatPesoCentavos(kpis.valueCentavos.value), icon: <Wallet size={16} aria-hidden="true" />, hint: 'Before partial refunds; delivery excluded. Cancelled and fully refunded sales excluded.', changePercent: kpis.valueCentavos.changePercent, comparison: `vs ${periodLabel}`, comparisonUnavailable: kpis.valueCentavos.previous === 0 ? `No sales in ${periodLabel}` : 'Previous period comparison unavailable' }
        : { label: 'Rank by orders', value: product.rankOrders ? `#${product.rankOrders}` : '—', icon: <BarChart3 size={16} aria-hidden="true" />, hint: `Among ${formatCount(kpis.products)} published products.` },
    ]} />
    <ViewsTrend series={data.series} markers={markers} subject="this product"
      method={<>{definitions.views} {definitions.orders} {definitions.unusual_days}{data.unusualDays.state !== 'OK' ? ' Unusual days need at least eight active days.' : ''}</>} />
    <AnalyticsDetails title="More product insights">
    <div className="mp-card-group grid items-stretch gap-5">
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
    </AnalyticsDetails>
    <p className="text-xs text-text-secondary">Analytics never changes your listing, price or ranking. Values are an internal operational view, not a tax invoice or accounting record.</p>
    <ProductReviewsSection listingId={product.listingId} canView={canViewReviews} compact />
    </ProductDetailWorkspace>
  </div>
}

/** Read-only 30-day measures; the product card provides the primary navigation. */
export function ProductInsightStrip({ summary, compact = false }: { summary: ProductSummary | undefined; compact?: boolean }) {
  if (!summary) return <div className={compact ? 'text-xs text-text-secondary' : 'mp-product-insight-strip text-xs text-text-secondary'}>Analytics loading…</div>
  const stats = <dl className="mp-product-insight-stats" data-compact={compact || undefined}>
    <div><dt>Views<span className="sr-only">, last 30 days</span></dt><dd><strong>{formatCount(summary.views)}</strong><ChangeText value={summary.viewsChangePercent} /></dd></div>
    <div><dt>Orders<span className="sr-only">, last 30 days</span></dt><dd><strong>{formatCount(summary.orders)}</strong></dd></div>
    <div><dt>Conversion<span className="sr-only">, view to order</span></dt><dd><strong>{percent(summary.conversion)}</strong></dd></div>
  </dl>
  if (compact) return stats
  return <div className="mp-product-insight-strip">
    <span>Last 30 days</span>
    {stats}
    <div className="mp-product-insight-sparkline" aria-hidden="true">{summary.dailyViews.some(value => value > 0) && <Sparkline values={summary.dailyViews} />}</div>
  </div>
}

/** Standalone Product Analytics workspace. */
const PRODUCT_ANALYTICS_HREF = '/analytics/products'

export function ProductAnalyticsShortcut({ label = 'Product analytics' }: { label?: string }) {
  return <Link className="inline-flex min-h-11 items-center gap-2 rounded-control border border-border-default bg-surface-primary px-4 text-sm font-semibold text-text-strong hover:bg-surface-canvas" to={PRODUCT_ANALYTICS_HREF}><BarChart3 size={16} aria-hidden="true" />{label}</Link>
}
