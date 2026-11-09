import { BackNavigation, DocumentExportButton } from '@materyalph/web-ui'
import type { GeoActiveUsers, GeoCell, GeoChild, GeoRate } from '@materyalph/api-client-ts'
import {
  Button, CalculationHelp, ChoroplethLegend, DateFilter, DemandHeatmap, DashboardPanel, FilterDisclosure, FilterTabs, GeoChoroplethMap, InfoNote, KpiCard, PageHeader, Pagination, SortableDataTable, TrendLineChart,
  analyticsDay, choroplethThresholds, dateFilterPreset, formatAnalyticsDate, formatPesoCentavos, manilaToday, type GeoAreaValue, type GeoFeature, type SortableColumn,
} from '@materyalph/web-ui'
import { Clock3, EyeOff, MapPinned, RefreshCw } from 'lucide-react'
import { useEffect, useMemo, useState, type FormEvent, type ReactNode } from 'react'
import { useSearchParams } from 'react-router-dom'
import { control, label as humanize, labelClass, manilaDateTime, useLoad } from '../lib/operations-hooks'
import { exportFilters, getGeoBoundaries, getGeoDashboard, getGeoDemand, getGeoFilterOptions, type GeoDashboard, type GeoFilters } from '../lib/geo-analytics-api'
import { AdminShell, ErrorState, LoadingState } from './PhaseThreeAdminPages'
import { MaterialsAnalyticsSection } from './TrustPages'
import { useAnalyticsResource } from '../lib/use-analytics-resource'
import { MarketplacePaymentAnalytics } from './MarketplacePaymentAnalytics'

const iso = (date: Date) => date.toISOString().slice(0, 10)
const daysAgo = (days: number) => { const date = new Date(`${manilaToday()}T00:00:00Z`); date.setUTCDate(date.getUTCDate() - days); return iso(date) }
const count = (value: number) => value.toLocaleString('en-PH')
const percent = (value: number) => `${value.toFixed(2)}%`
function duration(seconds: number | null | undefined): string {
  if (seconds === null || seconds === undefined) return '—'
  if (seconds < 60) return `${seconds} s`
  const minutes = Math.round(seconds / 60)
  return minutes < 60 ? `${minutes} min` : `${Math.floor(minutes / 60)} h ${minutes % 60} min`
}

type Metric = { key: string; label: string; format: (value: number) => string; value: (child: GeoChild) => number | null; suppressed: (child: GeoChild) => boolean }
const rateValue = (rate: GeoRate) => rate.percent === null || rate.percent === undefined ? null : Number(rate.percent)
const METRICS: Metric[] = [
  { key: 'gross', label: 'Gross sales', format: value => formatPesoCentavos(value), value: child => child.grossGmvCentavos.value ?? null, suppressed: child => child.grossGmvCentavos.suppressed },
  { key: 'net', label: 'Net sales', format: value => formatPesoCentavos(value), value: child => child.netGmvCentavos.value ?? null, suppressed: child => child.netGmvCentavos.suppressed },
  { key: 'orders', label: 'Orders', format: count, value: child => child.orderVolume.value ?? null, suppressed: child => child.orderVolume.suppressed },
  { key: 'buyers', label: 'Registered Buyers', format: count, value: child => child.registeredBuyers.value ?? null, suppressed: child => child.registeredBuyers.suppressed },
  { key: 'vendors', label: 'Vendors', format: count, value: child => child.vendorCount, suppressed: () => false },
  { key: 'fulfillment', label: 'Fulfillment rate', format: percent, value: child => rateValue(child.fulfillmentRate), suppressed: child => Boolean(child.fulfillmentRate.suppressed) },
  { key: 'cancellation', label: 'Cancellation rate', format: percent, value: child => rateValue(child.cancellationRate), suppressed: child => Boolean(child.cancellationRate.suppressed) },
  { key: 'dispute', label: 'Dispute rate', format: percent, value: child => rateValue(child.disputeRate), suppressed: child => Boolean(child.disputeRate.suppressed) },
]
const TRANSACTION_OPTIONS: { key: keyof GeoFilters; label: string; options: string[] }[] = [
  { key: 'procurementType', label: 'Procurement type', options: ['ITEM_BASED', 'PROJECT_BASED'] },
  { key: 'fulfillmentMethod', label: 'Fulfillment', options: ['DELIVERY', 'PICKUP'] },
  { key: 'paymentMethod', label: 'Payment', options: ['ONLINE', 'CASH_ON_DELIVERY', 'IN_STORE'] },
  { key: 'orderState', label: 'Order state', options: ['CONFIRMED', 'PROCESSING', 'READY_FOR_PICKUP', 'OUT_FOR_DELIVERY', 'DELIVERED', 'PICKED_UP', 'COMPLETED', 'DISPUTED', 'CANCELLATION_REQUESTED', 'CANCELLED'] },
]

function useGeoFilters(): [GeoFilters, (next: Partial<GeoFilters>) => void] {
  const [params, setParams] = useSearchParams()
  const filters: GeoFilters = {
    dataset: 'TEST', area: /^\d{10}$/.test(params.get('area') ?? '') ? params.get('area') : null,
    from: params.get('from') ?? daysAgo(29), to: params.get('to') ?? daysAgo(0), granularity: (['DAY', 'WEEK', 'MONTH'].includes(params.get('granularity') ?? '') ? params.get('granularity') : 'WEEK') as GeoFilters['granularity'],
    procurementType: params.get('procurementType') ?? '', categoryId: params.get('categoryId') ?? '', materialId: params.get('materialId') ?? '',
    fulfillmentMethod: params.get('fulfillmentMethod') ?? '', paymentMethod: params.get('paymentMethod') ?? '', orderState: params.get('orderState') ?? '',
  }
  return [filters, next => {
    const query = new URLSearchParams(params)
    for (const [key, value] of Object.entries({ ...filters, ...next })) { if (value) query.set(key, String(value)); else query.delete(key) }
    query.delete('psgc')
    setParams(query)
  }]
}

/** One value cell: suppressed cells say so in text, with the rule as a tooltip and accessible description. */
function CellValue({ cell, format, reason }: { cell: { value?: number | null | undefined; suppressed: boolean }; format: (value: number) => string; reason?: string | null | undefined }) {
  if (cell.suppressed) return <span className="inline-flex items-center gap-1.5 text-text-secondary" title={reason ?? 'Suppressed small cell'} aria-label={`Suppressed: ${reason ?? 'Small cell'}`}><EyeOff size={16} aria-hidden="true" className="shrink-0" />Suppressed</span>
  return <>{cell.value === null || cell.value === undefined ? '—' : format(cell.value)}</>
}

function GeoMetricHelp({ dashboard, definitions }: { dashboard: GeoDashboard; definitions: string[] }) {
  return <>
    <p><strong>{dashboard.scope.name}</strong> · {formatAnalyticsDate(dashboard.period.from, true)} – {formatAnalyticsDate(dashboard.period.to, true)} · Asia/Manila</p>
    {definitions.map(key => <p key={key}>{dashboard.definitions[key] ?? 'The calculation definition is unavailable for this metric.'}</p>)}
    {dashboard.disclosure.minimumPersons > 1 && <p>{dashboard.disclosure.description}</p>}
  </>
}

function RateKpi({ label, rate, calculation }: { label: string; rate: GeoRate; calculation: ReactNode }) {
  return <KpiCard density="compact" label={label} hint={rate.suppressed ? undefined : rate.denominator ? `${count(rate.numerator ?? 0)} of ${count(rate.denominator)}` : 'No eligible orders'}
    calculation={calculation}
    value={rate.suppressed ? <span className="text-lg"><CellValue cell={{ suppressed: true }} format={percent} reason={rate.reason} /></span> : rate.percent === null || rate.percent === undefined ? '—' : `${rate.percent}%`} />
}

function CellKpi({ label, cell, format, hint, accent = false, className = '', calculation }: { label: string; cell: GeoCell; format: (value: number) => string; hint?: string; accent?: boolean; className?: string; calculation: ReactNode }) {
  return <KpiCard density="compact" className={className} label={label} value={<span className={cell.suppressed ? 'text-lg' : 'tabular-nums'}><CellValue cell={cell} format={format} reason={cell.reason} /></span>}
    hint={cell.suppressed ? undefined : hint} calculation={calculation} accent={accent && !cell.suppressed} />
}

function ActiveUsersKpi({ label, activity, calculation }: { label: string; activity: GeoActiveUsers; calculation: ReactNode }) {
  return <KpiCard density="compact" label={label} calculation={calculation}
    value={<><span className={activity.mau.suppressed ? 'text-lg' : 'tabular-nums'}><CellValue cell={activity.mau} format={count} reason={activity.mau.reason} /></span> <span className="text-sm font-normal text-text-secondary" title="Monthly active users">MAU</span></>}
    hint={<span className="mp-geo-activity-breakdown">
      {(['dau', 'wau'] as const).map(window => <span key={window}>
        <span title={window === 'dau' ? 'Daily active users' : 'Weekly active users'}>{window.toUpperCase()}</span>
        <span className="font-semibold tabular-nums text-text-strong"><CellValue cell={activity[window]} format={count} reason={activity[window].reason} /></span>
      </span>)}
    </span>} />
}

function AnalyticsSectionTabs() {
  const [params, setParams] = useSearchParams()
  const view = ['demand', 'materials', 'payments'].includes(params.get('view') ?? '') ? params.get('view')! : 'trends'
  return <FilterTabs appearance="tabs" label="Analytics section" value={view} onChange={value => { const next = new URLSearchParams(params); next.set('view', value); setParams(next) }} chips={[
    { value: 'trends', label: 'Trends & activity' }, { value: 'demand', label: 'Category & material demand' }, { value: 'payments', label: 'Marketplace payments' }, { value: 'materials', label: 'Materials Analytics' },
  ]} />
}

export function AdminGeoAnalyticsPage() {
  const [params] = useSearchParams()
  const [filters, setFilters] = useGeoFilters()
  const dashboard = useAnalyticsResource(`geo-${JSON.stringify(filters)}`, () => getGeoDashboard(filters))
  const boundaries = useLoad(() => getGeoBoundaries(filters.area), [filters.area])
  const view = params.get('view') === 'materials' ? 'materials' : params.get('view') === 'demand' ? 'demand' : params.get('view') === 'payments' ? 'payments' : 'trends'
  const defaults = dateFilterPreset(30)
  const data = dashboard.data
  const scopeName = data?.scope.name ?? 'Philippines'
  const introduction = <div className="grid min-w-0 gap-3">
    <section aria-label="Analytics header" className="grid min-w-0 gap-3 mp-card mp-card-padded">
      <PageHeader compact eyebrow="Marketplace Analytics" title="Philippine geographic analytics" description="Marketplace activity by region, province and city. Buyer coordinates are never shown." />
      <div className="flex min-w-0 flex-wrap items-center justify-between gap-x-4 gap-y-2">
        {data ? <DatasetLine dashboard={data} /> : <p className="text-sm text-text-secondary">{dashboard.error ? 'Marketplace activity unavailable.' : 'Loading marketplace activity…'}</p>}
        <div className="flex min-w-0 flex-wrap items-center gap-2"><Button variant="secondary" disabled={dashboard.loading} onClick={dashboard.retry}><RefreshCw size={16} aria-hidden="true" />Refresh</Button><GeoExportButton filters={filters} /></div>
      </div>
    </section>
    <GeoFilterBar filters={filters} onApply={setFilters} dashboard={data} />
  </div>
  return <AdminShell activeHref="/analytics"><div className="mp-analytics mp-geographic-analytics min-w-0 space-y-3">
    {!(data?.dataset.available && !dashboard.error) && introduction}
    {dashboard.error ? <ErrorState message={dashboard.error} onRetry={dashboard.retry} /> : !data ? <LoadingState /> : !data.dataset.available
      ? <p className="rounded-surface border border-dashed border-border-default bg-surface-primary px-6 py-10 text-center text-sm text-text-secondary">No aggregation has published yet. Marketplace facts refresh every minute while the scheduler is running, or can be re-run from Platform Monitoring.</p>
      : <>
        <GeographicOverview dashboard={data} introduction={introduction} features={(boundaries.data?.features ?? []) as unknown as GeoFeature[]} missingCodes={boundaries.data?.missingCodes ?? []} onSelectArea={code => setFilters({ area: code })} />
        <UnresolvedNotice unresolved={data.unresolved} />
      </>}
    <AnalyticsSectionTabs />
    {view === 'payments' && <MarketplacePaymentAnalytics range={{ label: filters.from === defaults.from && filters.to === defaults.to ? defaults.label : 'Custom range', from: filters.from, to: filters.to }} onRangeChange={range => setFilters({ from: range.from, to: range.to })} />}
    {data?.dataset.available && !dashboard.error && <>
        {view === 'trends' && <TrendsSection dashboard={data} />}
        {view === 'demand' && <DemandSection filters={filters} />}
        {view === 'materials' && <MaterialsAnalyticsSection psgcCode={filters.area} areaLabel={scopeName} />}
        <details className="mp-card mp-card-padded"><summary className="min-h-11 cursor-pointer content-center font-semibold">Metric definitions and disclosure rule</summary>
          <dl className="mt-3 grid gap-3 md:grid-cols-2">{Object.entries(data.definitions).map(([key, value]) => <div key={key}><dt className="text-sm font-semibold">{humanize(key)}</dt><dd className="text-sm text-text-secondary">{value}</dd></div>)}
            {data.disclosure.minimumPersons > 1 && <div><dt className="text-sm font-semibold">Small-cell suppression</dt><dd className="text-sm text-text-secondary">{data.disclosure.description} Where only one sibling would be hidden, the smallest other sibling is hidden too (complementary suppression) so it cannot be recovered by subtraction.</dd></div>}</dl>
        </details>
      </>}
  </div></AdminShell>
}

function DatasetLine({ dashboard }: { dashboard: GeoDashboard }) {
  const dataset = dashboard.dataset
  return <div className="grid min-w-0 gap-1.5 text-text-secondary">
    <p className="flex items-center gap-2 text-sm font-medium text-text-strong"><Clock3 size={16} aria-hidden="true" className="shrink-0 text-text-secondary" />{dataset.throughDate ? `Facts through ${formatAnalyticsDate(dataset.throughDate, true)}` : 'No facts yet'}</p>
    <p className="flex flex-wrap gap-x-3 gap-y-1 text-xs leading-5">{dataset.lastAggregatedAt && <span>Aggregated <time dateTime={dataset.lastAggregatedAt.toISOString()}>{manilaDateTime(dataset.lastAggregatedAt)}</time></span>}{dataset.revision ? <span>Revision {dataset.revision}</span> : null}<span>Updates automatically</span></p>
  </div>
}

export function GeoFilterBar({ filters, onApply, dashboard }: { filters: GeoFilters; onApply: (next: Partial<GeoFilters>) => void; dashboard: GeoDashboard | null }) {
  const [draft, setDraft] = useState(filters)
  const defaultRange = dateFilterPreset(30)
  useEffect(() => { setDraft(filters) }, [filters])
  const categories = useAnalyticsResource('geo-filter-categories', () => getGeoFilterOptions())
  const materials = useAnalyticsResource(`geo-filter-materials-${draft.categoryId}`, () => draft.categoryId ? getGeoFilterOptions(draft.categoryId) : Promise.resolve([]))
  const transaction = dashboard?.filterApplicability.find(item => !['area', 'period'].includes(item.filter))
  const submit = (event: FormEvent) => { event.preventDefault(); onApply(draft) }
  const set = (key: keyof GeoFilters) => (event: { target: { value: string } }) => setDraft(current => ({ ...current, [key]: event.target.value, ...(key === 'categoryId' ? { materialId: '' } : {}) }))
  const refinements = [filters.categoryId, filters.materialId, filters.procurementType, filters.fulfillmentMethod, filters.paymentMethod, filters.orderState].filter(Boolean).length
  return <FilterDisclosure summary={<div className="flex flex-wrap items-center gap-x-4 gap-y-1 leading-5"><span>{formatAnalyticsDate(filters.from, true)} – {formatAnalyticsDate(filters.to, true)}</span><span>{filters.granularity === 'DAY' ? 'Daily' : filters.granularity === 'MONTH' ? 'Monthly' : 'Weekly'} trends</span>{refinements > 0 && <span className="font-medium text-text-strong">{refinements} {refinements === 1 ? 'refinement' : 'refinements'}</span>}</div>}>
    <form onSubmit={submit} aria-label="Dashboard filters" className="grid min-w-0 gap-5">
    <div className="flex flex-wrap items-center gap-x-4 gap-y-2 border-b border-border-default pb-5"><DateFilter title="Marketplace activity dates" value={{ label: filters.from === defaultRange.from && filters.to === defaultRange.to ? defaultRange.label : 'Custom range', from: filters.from, to: filters.to }} allowAllDates={false} allowOpenEnded={false} maxRangeDays={366} onChange={range => { const next = { ...draft, from: range.from, to: range.to }; setDraft(next); onApply(next) }} /><p className="text-xs leading-5 text-text-secondary">Inclusive Asia/Manila dates · up to one year</p></div>
    <fieldset className="min-w-0"><legend className="mb-3 text-sm font-semibold text-text-strong">Trend and materials</legend><div className="grid min-w-0 gap-4 sm:grid-cols-2 xl:grid-cols-3">
      <label className={labelClass}>Trend interval<select className={control} value={draft.granularity} onChange={set('granularity')}><option value="DAY">Daily</option><option value="WEEK">Weekly</option><option value="MONTH">Monthly</option></select></label>
      <label className={labelClass}>Category<select className={control} value={draft.categoryId} disabled={categories.loading && !categories.data} onChange={set('categoryId')}><option value="">{categories.loading && !categories.data ? 'Loading categories…' : 'All categories'}</option>{(categories.data ?? []).map(column => <option key={column.id} value={column.id}>{column.name}</option>)}</select></label>
      <label className={labelClass}>Material<select className={control} value={draft.materialId} disabled={!draft.categoryId || (materials.loading && !materials.data)} onChange={set('materialId')}><option value="">{!draft.categoryId ? 'Choose a category first' : materials.loading && !materials.data ? 'Loading materials…' : 'All materials'}</option>{(materials.data ?? []).map(column => <option key={column.id} value={column.id}>{column.name}</option>)}</select></label>
    </div></fieldset>
    {categories.error && <ErrorState message={categories.error} onRetry={categories.retry} />}
    {draft.categoryId && materials.error && <ErrorState message={materials.error} onRetry={materials.retry} />}
    <fieldset className="min-w-0 border-t border-border-default pt-5"><legend className="pr-3 text-sm font-semibold text-text-strong">Order filters</legend><div className="grid min-w-0 gap-4 sm:grid-cols-2 xl:grid-cols-4">
      {TRANSACTION_OPTIONS.map(option => <label key={option.key} className={labelClass}>{option.label}<select className={control} value={String(draft[option.key] ?? '')} onChange={set(option.key)}><option value="">Any</option>{option.options.map(value => <option key={value} value={value}>{humanize(value)}</option>)}</select></label>)}
    </div></fieldset>
    <div className="grid min-w-0 gap-4 border-t border-border-default pt-5 lg:grid-cols-[minmax(0,1fr)_auto] lg:items-end">
      <p className="max-w-4xl text-[13px] leading-6 text-text-secondary">{transaction ? `${transaction.note} Not applicable to: ${transaction.notApplicableTo.map(item => humanize(item)).join(', ')}.` : 'Category, material, procurement, fulfillment, payment and order-state filters apply to order metrics only; they are not applicable to Vendor and Buyer counts, active users, response time or Materials Analytics prices.'} No distance radius applies; geography uses PSGC areas.</p>
      <div className="flex flex-wrap gap-2"><Button type="submit">Apply filters</Button><Button variant="secondary" onClick={() => onApply({ procurementType: '', categoryId: '', materialId: '', fulfillmentMethod: '', paymentMethod: '', orderState: '', from: daysAgo(29), to: daysAgo(0), granularity: 'WEEK' })}>Reset</Button></div>
    </div>
    </form>
  </FilterDisclosure>
}

function GeographicOverview({ dashboard, introduction, features, missingCodes, onSelectArea }: { dashboard: GeoDashboard; introduction: ReactNode; features: GeoFeature[]; missingCodes: string[]; onSelectArea: (code: string | null) => void }) {
  const kpis = dashboard.kpis
  const response = kpis.responseTime
  const hasSuppression = [kpis.registeredBuyers, kpis.grossGmvCentavos, kpis.netGmvCentavos, kpis.orderVolume,
    kpis.fulfillmentRate, kpis.cancellationRate, kpis.disputeRate, response,
    ...Object.values(kpis.activeUsers.buyer), ...Object.values(kpis.activeUsers.vendor)].some(cell => cell.suppressed)
  return <section aria-label={`${dashboard.scope.name} overview`} className="grid min-w-0 gap-3">
    <AreaExplorer dashboard={dashboard} features={features} missingCodes={missingCodes} onDrill={onSelectArea} introduction={<div className="grid min-w-0 gap-3">
      {introduction}
      {hasSuppression && <aside aria-label="Metric privacy" title={dashboard.disclosure.description} className="flex min-w-0 items-start gap-2 text-xs leading-5 text-text-secondary">
        <EyeOff size={16} aria-hidden="true" className="mt-0.5 shrink-0" />
        <div className="min-w-0"><p className="font-semibold text-text-strong">Privacy-protected metrics</p>
          <p>Metrics from fewer than {dashboard.disclosure.minimumPersons} people are suppressed. Public storefront counts remain visible.</p>
        </div>
      </aside>}
    </div>} metrics={<KpiGrid dashboard={dashboard} />} />
  </section>
}

function KpiGrid({ dashboard }: { dashboard: GeoDashboard }) {
  const kpis = dashboard.kpis
  const response = kpis.responseTime
  const help = (key: string) => <GeoMetricHelp dashboard={dashboard} definitions={[key]} />
  return <section aria-label={`Key metrics for ${dashboard.scope.name}`} className="mp-geo-metrics">
    <section aria-labelledby="geo-commerce" className="mp-geo-metric-section mp-geo-commerce">
      <h3 id="geo-commerce" className="text-sm font-semibold text-text-strong">Commerce</h3>
      <dl className="mp-geo-metric-grid">
        <CellKpi label="Gross sales" cell={kpis.grossGmvCentavos} format={formatPesoCentavos} hint="Confirmed order value" calculation={help('gross_gmv')} accent />
        <CellKpi label="Net sales" cell={kpis.netGmvCentavos} format={formatPesoCentavos} hint="After cancellations and refunds" calculation={help('net_gmv')} />
        <CellKpi label="Orders" cell={kpis.orderVolume} format={count} hint="Confirmed Vendor orders" calculation={help('order_volume')} />
      </dl>
    </section>
    <section aria-labelledby="geo-community" className="mp-geo-metric-section">
      <h3 id="geo-community" className="text-sm font-semibold text-text-strong">Community & activity</h3>
      <dl className="mp-geo-metric-grid">
        <CellKpi label="Vendors (public storefronts)" cell={kpis.vendorCount} format={count} hint="Activated Tier 2 stores" calculation={help('vendor_count')} />
        <CellKpi label="Registered Buyers" cell={kpis.registeredBuyers} format={count} hint="By primary saved location" calculation={help('registered_buyers')} />
        <ActiveUsersKpi label="Active Buyers" activity={kpis.activeUsers.buyer} calculation={help('active_users')} />
        <ActiveUsersKpi label="Active Vendor users" activity={kpis.activeUsers.vendor} calculation={help('active_users')} />
      </dl>
    </section>
    <section aria-labelledby="geo-performance" className="mp-geo-metric-section">
      <h3 id="geo-performance" className="text-sm font-semibold text-text-strong">Order performance</h3>
      <dl className="mp-geo-metric-grid">
        <RateKpi label="Fulfillment rate" rate={kpis.fulfillmentRate} calculation={help('fulfillment_rate')} />
        <RateKpi label="Cancellation rate" rate={kpis.cancellationRate} calculation={help('cancellation_rate')} />
        <RateKpi label="Dispute rate" rate={kpis.disputeRate} calculation={help('dispute_rate')} />
        <KpiCard density="compact" label="Vendor response time" calculation={help('response_time')}
          hint={response.suppressed ? undefined : <span className="grid gap-1"><span>Mean {duration(response.meanSeconds)} · p90 {duration(response.p90Seconds)}</span><span>{count(response.answered ?? 0)} answered · {count(response.unanswered ?? 0)} unanswered</span></span>}
          value={response.suppressed ? <span className="text-lg"><CellValue cell={{ suppressed: true }} format={count} reason={response.reason} /></span> : <><span className="text-sm font-normal text-text-secondary">Median</span> {duration(response.medianSeconds)}</>} />
      </dl>
    </section>
  </section>
}

function AreaExplorer({ dashboard, introduction, features, missingCodes, onDrill, metrics }: { dashboard: GeoDashboard; introduction: ReactNode; features: GeoFeature[]; missingCodes: string[]; onDrill: (code: string | null) => void; metrics: ReactNode }) {
  const [metricKey, setMetricKey] = useState('gross')
  const [focused, setFocused] = useState<string | null>(null)
  const [selected, setSelected] = useState<string | null>(null)
  const metric = METRICS.find(item => item.key === metricKey) ?? METRICS[0]!
  const children = dashboard.children
  const areas: GeoAreaValue[] = useMemo(() => children.map(child => ({ code: child.code, name: child.name, levelLabel: child.levelLabel, drillable: child.drillable,
    suppressed: metric.suppressed(child), value: metric.suppressed(child) ? null : metric.value(child), note: child.suppressionNote ?? null })), [children, metric])
  const thresholds = useMemo(() => choroplethThresholds(areas.map(area => area.value)), [areas])
  const choose = (code: string) => { const child = children.find(item => item.code === code); if (child?.drillable) onDrill(code); else setSelected(code) }
  const columns: SortableColumn<GeoChild>[] = [
    { key: 'name', header: dashboard.scope.childrenLabel, cell: child => child.name, sortValue: child => child.name },
    ...METRICS.map(item => ({ key: item.key, header: item.label, numeric: true, sortValue: (child: GeoChild) => item.suppressed(child) ? null : item.value(child),
      cell: (child: GeoChild) => <CellValue cell={{ value: item.value(child), suppressed: item.suppressed(child) }} format={item.format} reason={child.suppressionNote} /> })),
    { key: 'response', header: 'Median response', numeric: true, sortValue: child => child.responseSuppressed ? null : child.medianResponseSeconds ?? null, cell: child => child.responseSuppressed ? <CellValue cell={{ suppressed: true }} format={count} reason={child.suppressionNote} /> : duration(child.medianResponseSeconds) },
    { key: 'disclosure', header: 'Disclosure', minWidth: 288, cell: child => child.suppressed ? <span className="text-[13px]">{child.suppressionReason === 'COMPLEMENTARY' ? 'Complementary suppression' : 'Small cell'}{child.suppressionNote ? `: ${child.suppressionNote}` : ''}</span> : <span className="text-[13px] text-text-secondary">Shown</span> },
  ]
  const metricDefinition = { gross: 'gross_gmv', net: 'net_gmv', orders: 'order_volume', buyers: 'registered_buyers', vendors: 'vendor_count', fulfillment: 'fulfillment_rate', cancellation: 'cancellation_rate', dispute: 'dispute_rate' }[metric.key]!
  return <div className="grid min-w-0 items-start gap-3 xl:grid-cols-[minmax(0,1.2fr)_minmax(20rem,0.8fr)] xl:grid-rows-[auto_auto_1fr] 2xl:grid-cols-[minmax(0,1fr)_28rem]">
      <div className="order-1 min-w-0 xl:col-start-1 xl:row-start-1">{introduction}</div>
      <div className="order-3 min-w-0 xl:col-start-1 xl:row-start-2">{metrics}</div>
      <section aria-label={`Interactive map for ${dashboard.scope.name}`} className="mp-geo-map-panel order-2 grid min-w-0 gap-3 mp-card mp-card-padded xl:sticky xl:top-20 xl:col-start-2 xl:row-span-3 xl:row-start-1">
        <header className="grid min-w-0 gap-2 border-b border-border-default pb-3">
          <div className="flex min-w-0 flex-wrap items-center justify-between gap-2"><p className="inline-flex items-center gap-2 text-xs font-semibold text-action-primary"><MapPinned size={15} aria-hidden="true" />{dashboard.scope.code ? 'Selected area' : 'National overview'}</p>{dashboard.scope.code && <BackNavigation><button type="button" onClick={() => onDrill(null)}>Back to Philippines</button></BackNavigation>}</div>
          <div className="flex min-w-0 flex-wrap items-end justify-between gap-3">
            <div className="min-w-0 flex-1 basis-48"><h3 id="area-explorer" className="break-words text-lg font-semibold text-text-strong">{dashboard.scope.code ? dashboard.scope.name : 'Philippines map'}</h3><p className="mt-1 text-[13px] leading-5 text-text-secondary">{dashboard.scope.code ? `Showing the selected area. Explore its ${dashboard.scope.childrenLabel.toLowerCase()} when boundaries are available.` : 'Click a region to view its map and marketplace activity.'}</p></div>
            <div className="flex w-full items-end gap-1 sm:w-auto"><label className={`${labelClass} min-w-0 flex-1 sm:w-40`}>Map metric<select className={control} value={metricKey} onChange={event => setMetricKey(event.target.value)}>{METRICS.map(item => <option key={item.key} value={item.key}>{item.label}</option>)}</select></label><CalculationHelp title={`${metric.label} by area`}><GeoMetricHelp dashboard={dashboard} definitions={[metricDefinition]} /><p>Select an area to apply it to all analytics panels. Unshaded reference boundaries provide geographic context only.</p></CalculationHelp></div>
          </div>
        </header>
        <GeoChoroplethMap renderer="outline" layout="portrait" showNames scope={{ code: dashboard.scope.code ?? null, name: dashboard.scope.name }} features={features} areas={areas} thresholds={thresholds} metricLabel={metric.label} formatValue={metric.format} focusedCode={focused} selectedCode={selected} onFocus={setFocused} onSelect={area => choose(area.code)} missingCodes={missingCodes} />
        {children.length === 0 ? <p className="rounded-control border border-dashed border-border-default p-4 text-[13px] leading-6 text-text-secondary">{dashboard.scope.drillable ? 'No sub-areas have recorded activity in this period.' : `${dashboard.scope.name} is the most detailed level shown. Barangay-level figures are not published.`}</p>
          : <div className="border-t border-border-default pt-3"><ChoroplethLegend title={`${metric.label} by ${dashboard.scope.childrenLabel.toLowerCase()}`} thresholds={thresholds} formatValue={metric.format} /></div>}
      </section>
    {children.length > 0 &&
      <div className="mp-geo-comparison order-4 grid min-w-0 gap-2 xl:col-start-1 xl:row-start-3">
        <div className="flex flex-wrap items-center justify-between gap-2"><div><h3 className="text-sm font-semibold text-text-strong">Area comparison</h3><p className="text-xs leading-5 text-text-secondary">{count(children.length)} areas · Sort columns or select an area to explore. Scroll for more.</p></div><CalculationHelp title="Area comparison"><p>Rows use the same area, dates and applicable filters as the map and key metrics. Sort a column to compare values; suppressed and unavailable values stay last.</p><p>Public storefront counts remain visible. Person-derived metrics follow the disclosure rule.</p><p>{dashboard.disclosure.description}</p></CalculationHelp></div>
        <SortableDataTable density="compact" caption={`${dashboard.scope.childrenLabel} in ${dashboard.scope.name}`} columns={columns} rows={children} rowKey={child => child.code} focusedKey={focused} selectedKey={selected}
          onFocusRow={setFocused} onSelectRow={child => choose(child.code)} rowLabel={child => child.drillable ? `Drill into ${child.name}` : `Select ${child.name}`} initialSort={{ key: 'gross', direction: 'descending' }} />
      </div>
    }
  </div>
}

function UnresolvedNotice({ unresolved }: { unresolved: GeoDashboard['unresolved'] }) {
  const total = unresolved.orders + unresolved.vendors + unresolved.registeredBuyers + unresolved.responses + unresolved.activity
  if (total === 0) return null
  return <InfoNote><span className="font-semibold">Unresolved geography</span> (counted in the Philippines total, never assigned to an area): {count(unresolved.orders)} orders, {count(unresolved.vendors)} Vendors, {count(unresolved.registeredBuyers)} registered Buyers, {count(unresolved.responses)} responses and {count(unresolved.activity)} activity records lack a resolvable PSGC code, for example a Buyer with no saved primary location or a Vendor without a verified business address.</InfoNote>
}

function TrendsSection({ dashboard }: { dashboard: GeoDashboard }) {
  const labels = dashboard.trends.map(point => analyticsDay(point.bucket) ?? '')
  const gross = dashboard.trends.map(point => point.suppressed ? null : point.grossGmvCentavos ?? null)
  const net = dashboard.trends.map(point => point.suppressed ? null : point.netGmvCentavos ?? null)
  const orders = dashboard.trends.map(point => point.suppressed ? null : point.orderVolume ?? null)
  const activityLabels = dashboard.activityTrend.map(point => analyticsDay(point.date) ?? '')
  const [table, setTable] = useState(false)
  return <div className="mp-analytics grid gap-3">
    <div className="grid min-w-0 gap-3 xl:grid-cols-2">
      <DashboardPanel density="compact" title="Gross and net sales" description="Order value for the selected area and dates." calculation={<GeoMetricHelp dashboard={dashboard} definitions={['gross_gmv', 'net_gmv']} />}>
        <TrendLineChart variant="area" title="Gross and net sales" labels={labels} formatValue={value => formatPesoCentavos(Math.round(value))} emptyReason="No order activity in this period." series={[{ key: 'gross', label: 'Gross sales', colorVar: '--mp-viz-series-1', values: gross }, { key: 'net', label: 'Net sales', colorVar: '--mp-viz-series-2', values: net }]} /></DashboardPanel>
      <DashboardPanel density="compact" title="Order volume" description="Confirmed orders in the selected area." calculation={<GeoMetricHelp dashboard={dashboard} definitions={['order_volume']} />}>
        <TrendLineChart variant="bar" title="Order volume" labels={labels} formatValue={value => count(Math.round(value))} emptyReason="No order activity in this period." series={[{ key: 'orders', label: 'Orders', colorVar: '--mp-viz-series-1', values: orders }]} /></DashboardPanel>
      <div className="xl:col-span-2"><DashboardPanel density="compact" title="Daily active users" description="Buyers and Vendor users with recorded activity." calculation={<GeoMetricHelp dashboard={dashboard} definitions={['active_users']} />}>
        <TrendLineChart variant="bar" title="Daily active Buyers and Vendor users" labels={activityLabels} formatValue={value => count(Math.round(value))} emptyReason="No active-user facts in this period, or every day is suppressed."
          series={[{ key: 'buyers', label: 'Buyer DAU', colorVar: '--mp-viz-series-1', values: dashboard.activityTrend.map(point => point.buyerDau ?? null) }, { key: 'vendors', label: 'Vendor DAU', colorVar: '--mp-viz-series-2', values: dashboard.activityTrend.map(point => point.vendorDau ?? null) }]} /></DashboardPanel></div>
    </div>
    <div><Button variant="secondary" aria-expanded={table} onClick={() => setTable(value => !value)}>{table ? 'Hide trend tables' : 'Show trend tables'}</Button></div>
    {table && <div className="mp-card-group grid gap-5 xl:grid-cols-2">
      <SortableDataTable caption="Order trend by period" rows={dashboard.trends} rowKey={point => point.bucket.toISOString()} columns={[
        { key: 'bucket', header: 'Period starting', cell: point => analyticsDay(point.bucket) ?? 'Not recorded', sortValue: point => analyticsDay(point.bucket) ?? '' },
        { key: 'gross', header: 'Gross sales', numeric: true, cell: point => <CellValue cell={{ value: point.grossGmvCentavos, suppressed: point.suppressed }} format={formatPesoCentavos} reason={point.reason} />, sortValue: point => point.suppressed ? null : point.grossGmvCentavos ?? null },
        { key: 'net', header: 'Net sales', numeric: true, cell: point => <CellValue cell={{ value: point.netGmvCentavos, suppressed: point.suppressed }} format={formatPesoCentavos} reason={point.reason} />, sortValue: point => point.suppressed ? null : point.netGmvCentavos ?? null },
        { key: 'orders', header: 'Orders', numeric: true, cell: point => <CellValue cell={{ value: point.orderVolume, suppressed: point.suppressed }} format={count} reason={point.reason} />, sortValue: point => point.suppressed ? null : point.orderVolume ?? null },
      ]} />
      <SortableDataTable caption="Active users by day" rows={dashboard.activityTrend} rowKey={point => point.date.toISOString()} columns={[
        { key: 'date', header: 'Date', cell: point => analyticsDay(point.date) ?? 'Not recorded', sortValue: point => analyticsDay(point.date) ?? '' },
        ...(['buyerDau', 'buyerWau', 'buyerMau', 'vendorDau', 'vendorWau', 'vendorMau'] as const).map(key => ({ key, header: `${key.startsWith('buyer') ? 'Buyer' : 'Vendor'} ${key.slice(-3).toUpperCase()}`, numeric: true,
          cell: (point: GeoDashboard['activityTrend'][number]) => point[key] === null || point[key] === undefined ? <CellValue cell={{ suppressed: true }} format={count} /> : count(point[key] ?? 0), sortValue: (point: GeoDashboard['activityTrend'][number]) => point[key] ?? null })),
      ]} />
    </div>}
  </div>
}

export function DemandSection({ filters }: { filters: GeoFilters }) {
  const [measure, setMeasure] = useState<'ORDER_COUNT' | 'QUANTITY' | 'VALUE'>('ORDER_COUNT')
  const effective = measure === 'QUANTITY' && !filters.materialId ? 'ORDER_COUNT' : measure
  const selection = `${JSON.stringify(filters)}-${effective}`
  const [position, setPosition] = useState({ selection, page: 1 })
  const page = position.selection === selection ? position.page : 1
  const demand = useAnalyticsResource(`demand-${selection}-${page}`, () => getGeoDemand(filters, effective, page))
  const format = (value: number) => effective === 'VALUE' ? formatPesoCentavos(value) : count(value)
  const pagination = demand.data?.columnPagination
  const dimension = filters.categoryId || filters.materialId ? 'Material' : 'Category'
  return <section aria-labelledby="demand" className="grid min-w-0 gap-5 mp-card mp-card-padded">
    <div className="flex flex-col gap-4 border-b border-border-default pb-5 lg:flex-row lg:items-end lg:justify-between">
      <div className="min-w-0"><div className="flex items-center justify-between gap-2"><h2 id="demand" className="text-lg font-semibold text-text-strong">{dimension} demand by area</h2>{demand.data && <CalculationHelp title={`${dimension} demand by area`}><p>{demand.data.definition}</p><p>Choose a category in the dashboard filters to compare its materials. This is a recorded marketplace indicator, not an official government market statistic.</p></CalculationHelp>}</div><p className="mt-1.5 max-w-3xl text-sm leading-6 text-text-secondary">Compare confirmed marketplace demand across {demand.data?.scope.childrenLabel.toLowerCase() ?? 'areas'}. Categories and materials without matching orders show 0.</p>
        {demand.data && <p className="mt-3 inline-flex max-w-full items-center gap-2 text-[13px] font-medium text-text-strong"><MapPinned size={16} aria-hidden="true" className="shrink-0 text-text-secondary" /><span className="min-w-0 break-words">{demand.data.scope.name}</span><span className="shrink-0 font-normal text-text-secondary">· {dimension === 'Material' ? 'Materials' : 'Categories'}</span></p>}
      </div>
      <label className={`${labelClass} w-full shrink-0 sm:w-56`}>Measure<select className={control} value={effective} onChange={event => setMeasure(event.target.value as typeof measure)}><option value="ORDER_COUNT">Orders</option><option value="QUANTITY" disabled={!filters.materialId}>Quantity{filters.materialId ? '' : ' (select material)'}</option><option value="VALUE">Line value</option></select></label>
    </div>
    {demand.error ? <ErrorState message={demand.error} onRetry={demand.retry} /> : !demand.data ? <LoadingState /> : <>
      <DemandHeatmap caption={`${dimension} demand by ${demand.data.scope.childrenLabel.toLowerCase()}`} columns={demand.data.columns} formatValue={format}
        rows={demand.data.rows.map(row => ({ code: row.code, name: row.name, cells: row.cells.map(cell => ({ value: cell.value === null || cell.value === undefined ? null : Number(cell.value), suppressed: cell.suppressed, reason: cell.reason ?? null })) }))} />
      {pagination && <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between"><p className="text-[13px] text-text-secondary">{pagination.total} {dimension === 'Material' ? 'materials' : 'categories'} · up to 8 per page{demand.data.unit ? ` · Quantities in ${demand.data.unit}` : ''}</p><Pagination page={page} lastPage={pagination.lastPage} busy={demand.loading} onChange={next => setPosition({ selection, page: next })} /></div>}
      {demand.data.notComparableLines > 0 && <p className="text-[13px] text-text-secondary">{count(demand.data.notComparableLines)} order lines use a unit that cannot be normalized and are excluded from quantity totals.</p>}
    </>}
  </section>
}

export function GeoExportButton({ filters }: { filters: GeoFilters }) {
  const context = { basePath: import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1', audience: 'admin' as const, types: ['GEO_ANALYTICS'] as const, filters: exportFilters(filters) }
  return <>
    <DocumentExportButton {...context} />
    <DocumentExportButton {...context} format="CSV" />
  </>
}
