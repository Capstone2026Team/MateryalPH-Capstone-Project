import { DocumentExportButton } from '@materyalph/web-ui'
import type { GeoActiveUsers, GeoCell, GeoChild, GeoRate } from '@materyalph/api-client-ts'
import {
  Button, ChoroplethLegend, DateFilter, DemandHeatmap, FilterTabs, GeoBreadcrumbs, GeoChoroplethMap, InfoNote, KpiCard, SidePanel, SortableDataTable, TrendLineChart,
  analyticsDay, choroplethThresholds, formatPesoCentavos, manilaToday, type GeoAreaValue, type GeoFeature, type SortableColumn,
} from '@materyalph/web-ui'
import { Clock3, Download, EyeOff, RefreshCw, ShoppingCart, Store, Users, Wallet } from 'lucide-react'
import { useEffect, useMemo, useRef, useState, type FormEvent, type ReactNode } from 'react'
import { useSearchParams } from 'react-router-dom'
import { control, label as humanize, labelClass, manilaDateTime, useLoad } from '../lib/operations-hooks'
import { exportFilters, getGeoBoundaries, getGeoDashboard, getGeoDemand, type GeoDashboard, type GeoFilters } from '../lib/geo-analytics-api'
import { apiProblem, newKey, problemText, requestExport } from '../lib/operations-api'
import { AdminShell, ErrorState, LoadingState, PageHeader } from './PhaseThreeAdminPages'
import { MaterialsAnalyticsSection } from './TrustPages'
import { useAnalyticsResource } from '../lib/use-analytics-resource'

const browserKey = import.meta.env.VITE_GOOGLE_MAPS_BROWSER_KEY?.trim() || undefined
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
  { key: 'gross', label: 'Gross GMV', format: value => formatPesoCentavos(value), value: child => child.grossGmvCentavos.value ?? null, suppressed: child => child.grossGmvCentavos.suppressed },
  { key: 'net', label: 'Net GMV', format: value => formatPesoCentavos(value), value: child => child.netGmvCentavos.value ?? null, suppressed: child => child.netGmvCentavos.suppressed },
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
    from: params.get('from') ?? daysAgo(89), to: params.get('to') ?? daysAgo(0), granularity: (['DAY', 'WEEK', 'MONTH'].includes(params.get('granularity') ?? '') ? params.get('granularity') : 'WEEK') as GeoFilters['granularity'],
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

function RateKpi({ label, rate }: { label: string; rate: GeoRate }) {
  return <KpiCard label={label} hint={rate.suppressed ? undefined : rate.denominator ? `${count(rate.numerator ?? 0)} of ${count(rate.denominator)}` : 'No eligible orders'}
    value={rate.suppressed ? <span className="text-lg"><CellValue cell={{ suppressed: true }} format={percent} reason={rate.reason} /></span> : rate.percent === null || rate.percent === undefined ? '—' : `${rate.percent}%`} />
}

function CellKpi({ label, cell, format, hint, icon, accent = false }: { label: string; cell: GeoCell; format: (value: number) => string; hint?: string; icon?: ReactNode; accent?: boolean }) {
  return <KpiCard label={label} value={<span className={cell.suppressed ? 'text-lg' : 'tabular-nums'}><CellValue cell={cell} format={format} reason={cell.reason} /></span>}
    hint={cell.suppressed ? undefined : hint} icon={icon} accent={accent} />
}

function ActiveUsersKpi({ label, activity }: { label: string; activity: GeoActiveUsers }) {
  return <KpiCard label={label} icon={<Users size={16} aria-hidden="true" />}
    value={<><span className={activity.mau.suppressed ? 'text-lg' : 'tabular-nums'}><CellValue cell={activity.mau} format={count} reason={activity.mau.reason} /></span> <span className="text-sm font-normal text-text-secondary" title="Monthly active users">MAU</span></>}
    hint={<span className="mt-3 grid gap-2 border-t border-border-default pt-3">
      {(['dau', 'wau'] as const).map(window => <span key={window} className="flex flex-wrap items-center justify-between gap-x-3 gap-y-1">
        <span>{window === 'dau' ? 'Daily (DAU)' : 'Weekly (WAU)'}</span>
        <span className="font-semibold tabular-nums text-text-strong"><CellValue cell={activity[window]} format={count} reason={activity[window].reason} /></span>
      </span>)}
    </span>} />
}

export function AdminGeoAnalyticsPage() {
  const [params] = useSearchParams()
  const [filters, setFilters] = useGeoFilters()
  const dashboard = useAnalyticsResource(`geo-${JSON.stringify(filters)}`, () => getGeoDashboard(filters))
  const boundaries = useLoad(() => getGeoBoundaries(filters.area), [filters.area])
  const [view, setView] = useState(params.get('view') === 'materials' ? 'materials' : 'trends')
  const data = dashboard.data
  const scopeName = data?.scope.name ?? 'Philippines'
  return <AdminShell activeHref="/analytics"><div className="space-y-6">
    <PageHeader eyebrow="Marketplace Analytics" title="Philippine geographic analytics" description="Daily aggregate facts by PSGC area: Philippines → Region → Province or independent/highly urbanized city → City or Municipality. Buyer coordinates are never stored or shown."
      actions={<><Button variant="secondary" disabled={dashboard.loading} onClick={dashboard.retry}><RefreshCw size={16} aria-hidden="true" />Refresh</Button><GeoExportButton filters={filters} /></>} />
    {data && <DatasetLine dashboard={data} />}
    <GeoFilterBar filters={filters} onApply={setFilters} dashboard={data} />
    {dashboard.error ? <ErrorState message={dashboard.error} onRetry={dashboard.retry} /> : !data ? <LoadingState /> : !data.dataset.available
      ? <p className="rounded-surface border border-dashed border-border-default bg-surface-primary px-6 py-10 text-center text-sm text-text-secondary">No aggregation has published yet. Marketplace facts refresh every minute while the scheduler is running, or can be re-run from Integration & Job Health.</p>
      : <>
        <KpiGrid dashboard={data} onSelectArea={code => setFilters({ area: code })} />
        <AreaExplorer dashboard={data} features={(boundaries.data?.features ?? []) as unknown as GeoFeature[]} missingCodes={boundaries.data?.missingCodes ?? []} onDrill={code => setFilters({ area: code })} />
        <UnresolvedNotice unresolved={data.unresolved} />
        <FilterTabs appearance="tabs" label="Analytics section" value={view} onChange={setView} chips={[{ value: 'trends', label: 'Trends & activity' }, { value: 'demand', label: 'Category & material demand' }, { value: 'materials', label: 'Materials Analytics' }]} />
        {view === 'trends' && <TrendsSection dashboard={data} />}
        {view === 'demand' && <DemandSection filters={filters} />}
        {view === 'materials' && <MaterialsAnalyticsSection psgcCode={filters.area} areaLabel={scopeName} />}
        <details className="rounded-surface border border-border-default bg-surface-primary p-4"><summary className="min-h-11 cursor-pointer content-center font-semibold">Metric definitions and disclosure rule</summary>
          <dl className="mt-3 grid gap-3 md:grid-cols-2">{Object.entries(data.definitions).map(([key, value]) => <div key={key}><dt className="text-sm font-semibold">{humanize(key)}</dt><dd className="text-sm text-text-secondary">{value}</dd></div>)}
            {data.disclosure.minimumPersons > 1 && <div><dt className="text-sm font-semibold">Small-cell suppression</dt><dd className="text-sm text-text-secondary">{data.disclosure.description} Where only one sibling would be hidden, the smallest other sibling is hidden too (complementary suppression) so it cannot be recovered by subtraction.</dd></div>}</dl>
        </details>
      </>}
  </div></AdminShell>
}

function DatasetLine({ dashboard }: { dashboard: GeoDashboard }) {
  const dataset = dashboard.dataset
  return <p className="flex flex-wrap items-center gap-2 text-sm text-text-secondary">
    <span>{dataset.throughDate ? `Facts through ${dataset.throughDate}` : 'No facts yet'}{dataset.lastAggregatedAt ? ` · aggregated ${manilaDateTime(dataset.lastAggregatedAt)}` : ''}{dataset.revision ? ` · revision ${dataset.revision}` : ''} · Updates automatically</span>
  </p>
}

function GeoFilterBar({ filters, onApply, dashboard }: { filters: GeoFilters; onApply: (next: Partial<GeoFilters>) => void; dashboard: GeoDashboard | null }) {
  const [draft, setDraft] = useState(filters)
  useEffect(() => { setDraft(filters) }, [filters])
  const demand = useLoad(() => getGeoDemand({ ...filters, categoryId: '', materialId: '' }, 'ORDER_COUNT'), [filters.dataset, filters.area, filters.from, filters.to])
  const materials = useLoad(() => draft.categoryId ? getGeoDemand({ ...filters, categoryId: draft.categoryId, materialId: '' }, 'ORDER_COUNT') : Promise.resolve(null), [filters.dataset, filters.area, filters.from, filters.to, draft.categoryId])
  const transaction = dashboard?.filterApplicability.find(item => !['area', 'period'].includes(item.filter))
  const submit = (event: FormEvent) => { event.preventDefault(); onApply(draft) }
  const set = (key: keyof GeoFilters) => (event: { target: { value: string } }) => setDraft(current => ({ ...current, [key]: event.target.value, ...(key === 'categoryId' ? { materialId: '' } : {}) }))
  return <form onSubmit={submit} aria-label="Dashboard filters" className="grid gap-4 rounded-surface border border-border-default bg-surface-primary p-4">
    <div className="flex flex-wrap items-center gap-3"><DateFilter title="Marketplace activity dates" value={{ label: 'Custom range', from: filters.from, to: filters.to }} allowAllDates={false} allowOpenEnded={false} maxRangeDays={366} onChange={range => { const next = { ...draft, from: range.from, to: range.to }; setDraft(next); onApply(next) }} /><p className="text-xs text-text-secondary">Inclusive Asia/Manila dates · up to one year</p></div>
    <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
      <label className={labelClass}>Trend interval<select className={control} value={draft.granularity} onChange={set('granularity')}><option value="DAY">Daily</option><option value="WEEK">Weekly</option><option value="MONTH">Monthly</option></select></label>
      <label className={labelClass}>Category<select className={control} value={draft.categoryId} onChange={set('categoryId')}><option value="">All categories</option>{(demand.data?.columns ?? []).map(column => <option key={column.id} value={column.id}>{column.name}</option>)}</select></label>
      <label className={labelClass}>Material<select className={control} value={draft.materialId} disabled={!draft.categoryId} onChange={set('materialId')}><option value="">{draft.categoryId ? 'All materials' : 'Choose a category first'}</option>{(materials.data?.columns ?? []).map(column => <option key={column.id} value={column.id}>{column.name}</option>)}</select></label>
      {TRANSACTION_OPTIONS.map(option => <label key={option.key} className={labelClass}>{option.label}<select className={control} value={String(draft[option.key] ?? '')} onChange={set(option.key)}><option value="">Any</option>{option.options.map(value => <option key={value} value={value}>{humanize(value)}</option>)}</select></label>)}
    </div>
    <div className="flex flex-wrap items-center justify-between gap-3">
      <p className="max-w-4xl text-[13px] text-text-secondary">{transaction ? `${transaction.note} Not applicable to: ${transaction.notApplicableTo.map(item => humanize(item)).join(', ')}.` : 'Category, material, procurement, fulfillment, payment and order-state filters apply to order metrics only; they are not applicable to Vendor and Buyer counts, active users, response time or Materials Analytics prices.'} No distance radius applies; geography uses PSGC areas.</p>
      <div className="flex gap-2"><Button type="submit">Apply filters</Button><Button variant="secondary" onClick={() => onApply({ procurementType: '', categoryId: '', materialId: '', fulfillmentMethod: '', paymentMethod: '', orderState: '', from: daysAgo(89), to: daysAgo(1), granularity: 'WEEK' })}>Reset</Button></div>
    </div>
  </form>
}

function KpiGrid({ dashboard, onSelectArea }: { dashboard: GeoDashboard; onSelectArea: (code: string | null) => void }) {
  const kpis = dashboard.kpis
  const response = kpis.responseTime
  const hasSuppression = [kpis.registeredBuyers, kpis.grossGmvCentavos, kpis.netGmvCentavos, kpis.orderVolume,
    kpis.fulfillmentRate, kpis.cancellationRate, kpis.disputeRate, response,
    ...Object.values(kpis.activeUsers.buyer), ...Object.values(kpis.activeUsers.vendor)].some(cell => cell.suppressed)
  return <section aria-label={`Key metrics for ${dashboard.scope.name}`} className="grid min-w-0 gap-5">
    <header className="grid gap-3 border-b border-border-default pb-4">
      {dashboard.scope.breadcrumbs.length > 1 && <GeoBreadcrumbs items={dashboard.scope.breadcrumbs.map(item => ({ code: item.code ?? null, name: item.name }))} onSelect={onSelectArea} />}
      <div className="flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
        <div className="min-w-0"><h2 className="text-xl font-semibold text-text-strong">{dashboard.scope.name} overview</h2>
          <p className="mt-1 text-sm text-text-secondary">The selected area applies to every panel, including Materials Analytics.</p>
        </div>
        {hasSuppression && <aside aria-label="Metric privacy" title={dashboard.disclosure.description} className="flex min-w-0 items-start gap-2 text-xs leading-5 text-text-secondary lg:max-w-sm">
          <EyeOff size={16} aria-hidden="true" className="mt-0.5 shrink-0" />
          <div className="min-w-0"><p className="font-semibold text-text-strong">Privacy-protected metrics</p>
            <p>Metrics from fewer than {dashboard.disclosure.minimumPersons} people are suppressed. Public storefront counts remain visible.</p>
          </div>
        </aside>}
      </div>
    </header>
    <section aria-labelledby="geo-commerce" className="grid gap-3">
      <h3 id="geo-commerce" className="text-sm font-semibold text-text-strong">Commerce</h3>
      <dl className="grid gap-4 md:grid-cols-3">
        <CellKpi label="Gross GMV" cell={kpis.grossGmvCentavos} format={formatPesoCentavos} hint="Before discounts, refunds and cancellations." icon={<Wallet size={16} aria-hidden="true" />} accent />
        <CellKpi label="Net GMV" cell={kpis.netGmvCentavos} format={formatPesoCentavos} hint="After discounts, cancellations and refunds." />
        <CellKpi label="Orders" cell={kpis.orderVolume} format={count} icon={<ShoppingCart size={16} aria-hidden="true" />} />
      </dl>
    </section>
    <section aria-labelledby="geo-community" className="grid gap-3">
      <h3 id="geo-community" className="text-sm font-semibold text-text-strong">Community & activity</h3>
      <dl className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <CellKpi label="Vendors (public storefronts)" cell={kpis.vendorCount} format={count} hint="Activated Tier 2 stores." icon={<Store size={16} aria-hidden="true" />} />
        <CellKpi label="Registered Buyers" cell={kpis.registeredBuyers} format={count} icon={<Users size={16} aria-hidden="true" />} />
        <ActiveUsersKpi label="Active Buyers" activity={kpis.activeUsers.buyer} />
        <ActiveUsersKpi label="Active Vendor users" activity={kpis.activeUsers.vendor} />
      </dl>
    </section>
    <section aria-labelledby="geo-performance" className="grid gap-3">
      <h3 id="geo-performance" className="text-sm font-semibold text-text-strong">Order performance</h3>
      <dl className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <RateKpi label="Fulfillment rate" rate={kpis.fulfillmentRate} />
        <RateKpi label="Cancellation rate" rate={kpis.cancellationRate} />
        <RateKpi label="Dispute rate" rate={kpis.disputeRate} />
        <KpiCard label="Vendor response time" icon={<Clock3 size={16} aria-hidden="true" />}
          hint={response.suppressed ? undefined : `Mean ${duration(response.meanSeconds)} · p90 ${duration(response.p90Seconds)} · ${count(response.answered ?? 0)} answered, ${count(response.unanswered ?? 0)} unanswered`}
          value={response.suppressed ? <span className="text-lg"><CellValue cell={{ suppressed: true }} format={count} reason={response.reason} /></span> : <><span className="text-sm font-normal text-text-secondary">Median</span> {duration(response.medianSeconds)}</>} />
      </dl>
    </section>
  </section>
}

function AreaExplorer({ dashboard, features, missingCodes, onDrill }: { dashboard: GeoDashboard; features: GeoFeature[]; missingCodes: string[]; onDrill: (code: string) => void }) {
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
  if (children.length === 0) return <p className="rounded-surface border border-dashed border-border-default bg-surface-primary px-6 py-10 text-center text-sm text-text-secondary">{dashboard.scope.drillable ? 'No sub-areas have recorded activity in this period.' : `${dashboard.scope.name} is the most detailed level shown. Barangay-level figures are not published.`}</p>
  return <section aria-labelledby="area-explorer" className="grid gap-4">
    <div className="flex flex-wrap items-end justify-between gap-3">
      <div><h2 id="area-explorer" className="text-xl font-semibold">{dashboard.scope.childrenLabel} in {dashboard.scope.name}</h2><p className="mt-1 text-sm text-text-secondary">Select an area on the map or in the table to drill down. Both views stay in sync.</p></div>
      <label className={`${labelClass} w-full sm:w-64`}>Map metric<select className={control} value={metricKey} onChange={event => setMetricKey(event.target.value)}>{METRICS.map(item => <option key={item.key} value={item.key}>{item.label}</option>)}</select></label>
    </div>
    <div className="grid min-w-0 gap-5">
      <div className="grid min-w-0 gap-4 rounded-surface border border-border-default bg-surface-primary p-4 sm:p-5">
        <GeoChoroplethMap browserKey={browserKey} features={features} areas={areas} thresholds={thresholds} metricLabel={metric.label} formatValue={metric.format} focusedCode={focused} selectedCode={selected} onFocus={setFocused} onSelect={area => choose(area.code)} missingCodes={missingCodes} />
        <div className="border-t border-border-default pt-4"><ChoroplethLegend title={`${metric.label} by ${dashboard.scope.childrenLabel.toLowerCase()}`} thresholds={thresholds} formatValue={metric.format} /></div>
      </div>
      <div className="grid min-w-0 gap-3">
        <div className="flex flex-wrap items-baseline justify-between gap-2"><h3 className="text-base font-semibold text-text-strong">Area comparison</h3><p className="text-[13px] text-text-secondary">{count(children.length)} areas · Sort by a column or scroll to compare all metrics.</p></div>
        <SortableDataTable caption={`${dashboard.scope.childrenLabel} in ${dashboard.scope.name}`} columns={columns} rows={children} rowKey={child => child.code} focusedKey={focused} selectedKey={selected}
          onFocusRow={setFocused} onSelectRow={child => choose(child.code)} rowLabel={child => child.drillable ? `Drill into ${child.name}` : `Select ${child.name}`} initialSort={{ key: 'gross', direction: 'descending' }} />
      </div>
    </div>
  </section>
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
  return <div className="grid gap-5">
    <div className="grid min-w-0 gap-5 xl:grid-cols-2">
      <figure className="m-0 grid min-w-0 gap-3 rounded-surface border border-border-default bg-surface-primary p-4"><figcaption className="text-base font-semibold">Gross and net GMV</figcaption>
        <TrendLineChart title="Gross and net GMV" labels={labels} formatValue={value => formatPesoCentavos(Math.round(value))} emptyReason="No order activity in this period." series={[{ key: 'gross', label: 'Gross GMV', colorVar: '--mp-viz-series-1', values: gross }, { key: 'net', label: 'Net GMV', colorVar: '--mp-viz-series-2', values: net }]} /></figure>
      <figure className="m-0 grid min-w-0 gap-3 rounded-surface border border-border-default bg-surface-primary p-4"><figcaption className="text-base font-semibold">Order volume</figcaption>
        <TrendLineChart title="Order volume" labels={labels} formatValue={value => count(Math.round(value))} emptyReason="No order activity in this period." series={[{ key: 'orders', label: 'Orders', colorVar: '--mp-viz-series-1', values: orders }]} /></figure>
      <figure className="m-0 grid min-w-0 gap-3 rounded-surface border border-border-default bg-surface-primary p-4 xl:col-span-2"><figcaption className="text-base font-semibold">Daily active users</figcaption>
        <TrendLineChart title="Daily active Buyers and Vendor users" labels={activityLabels} formatValue={value => count(Math.round(value))} emptyReason="No active-user facts in this period, or every day is suppressed."
          series={[{ key: 'buyers', label: 'Buyer DAU', colorVar: '--mp-viz-series-1', values: dashboard.activityTrend.map(point => point.buyerDau ?? null) }, { key: 'vendors', label: 'Vendor DAU', colorVar: '--mp-viz-series-2', values: dashboard.activityTrend.map(point => point.vendorDau ?? null) }]} /></figure>
    </div>
    <div><Button variant="secondary" aria-expanded={table} onClick={() => setTable(value => !value)}>{table ? 'Hide trend tables' : 'Show trend tables'}</Button></div>
    {table && <div className="grid gap-5 xl:grid-cols-2">
      <SortableDataTable caption="Order trend by period" rows={dashboard.trends} rowKey={point => point.bucket.toISOString()} columns={[
        { key: 'bucket', header: 'Period starting', cell: point => analyticsDay(point.bucket) ?? 'Not recorded', sortValue: point => analyticsDay(point.bucket) ?? '' },
        { key: 'gross', header: 'Gross GMV', numeric: true, cell: point => <CellValue cell={{ value: point.grossGmvCentavos, suppressed: point.suppressed }} format={formatPesoCentavos} reason={point.reason} />, sortValue: point => point.suppressed ? null : point.grossGmvCentavos ?? null },
        { key: 'net', header: 'Net GMV', numeric: true, cell: point => <CellValue cell={{ value: point.netGmvCentavos, suppressed: point.suppressed }} format={formatPesoCentavos} reason={point.reason} />, sortValue: point => point.suppressed ? null : point.netGmvCentavos ?? null },
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

function DemandSection({ filters }: { filters: GeoFilters }) {
  const [measure, setMeasure] = useState<'ORDER_COUNT' | 'QUANTITY' | 'VALUE'>('ORDER_COUNT')
  const effective = measure === 'QUANTITY' && !filters.materialId ? 'ORDER_COUNT' : measure
  const demand = useAnalyticsResource(`demand-${JSON.stringify(filters)}-${effective}`, () => getGeoDemand(filters, effective))
  const format = (value: number) => effective === 'VALUE' ? formatPesoCentavos(value) : count(value)
  return <section aria-labelledby="demand" className="grid gap-4">
    <div className="flex flex-wrap items-end justify-between gap-3">
      <div><h2 id="demand" className="text-xl font-semibold">{demand.data?.dimension === 'MATERIAL' ? 'Material demand' : 'Category demand'} by area</h2><p className="mt-1 max-w-3xl text-sm text-text-secondary">{demand.data?.definition ?? 'Confirmed order lines by area.'} Choose a category in the filters to see its materials.</p></div>
      <label className={`${labelClass} w-full sm:w-56`}>Measure<select className={control} value={effective} onChange={event => setMeasure(event.target.value as typeof measure)}><option value="ORDER_COUNT">Orders</option><option value="QUANTITY" disabled={!filters.materialId}>Quantity (choose a material)</option><option value="VALUE">Line value</option></select></label>
    </div>
    {demand.error ? <ErrorState message={demand.error} onRetry={demand.retry} /> : !demand.data ? <LoadingState /> : <>
      <DemandHeatmap caption={`${demand.data.dimension === 'MATERIAL' ? 'Material' : 'Category'} demand by ${demand.data.scope.childrenLabel.toLowerCase()}`} columns={demand.data.columns} formatValue={format}
        rows={demand.data.rows.map(row => ({ code: row.code, name: row.name, cells: row.cells.map(cell => ({ value: cell.value === null || cell.value === undefined ? null : Number(cell.value), suppressed: cell.suppressed, reason: cell.reason ?? null })) }))} />
      {demand.data.unit && <p className="text-[13px] text-text-secondary">Quantities are in {demand.data.unit}.</p>}
      {demand.data.notComparableLines > 0 && <p className="text-[13px] text-text-secondary">{count(demand.data.notComparableLines)} order lines use a unit that cannot be normalized and are excluded from quantity totals.</p>}
    </>}
  </section>
}

function GeoExportButton({ filters }: { filters: GeoFilters }) {
  const [open, setOpen] = useState(false)
  const [purpose, setPurpose] = useState('')
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<{ tone: 'error' | 'success'; text: string } | null>(null)
  const key = useRef({ scope: '', value: newKey() })
  async function submit(event: FormEvent) {
    event.preventDefault()
    if (purpose.trim().length < 10) { setMessage({ tone: 'error', text: 'State the purpose of this export in at least 10 characters.' }); return }
    const payload = exportFilters(filters)
    const scope = JSON.stringify([payload, purpose.trim()])
    if (key.current.scope !== scope) key.current = { scope, value: newKey() }
    setBusy(true); setMessage(null)
    try { const outcome = await requestExport('GEO_ANALYTICS', payload, purpose.trim(), key.current.value); setMessage({ tone: 'success', text: outcome === 'DOWNLOADED' ? 'Downloaded. The file carries the dataset label and the same suppression as this page.' : 'The export is still generating; it will be listed with your exports when ready.' }) }
    catch (cause) { setMessage({ tone: 'error', text: problemText(await apiProblem(cause)) }) } finally { setBusy(false) }
  }
  return <>
    <DocumentExportButton basePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} audience="admin" types={['GEO_ANALYTICS']} filters={exportFilters(filters)} />
    <Button variant="secondary" onClick={() => setOpen(true)}><Download size={16} aria-hidden="true" />Export CSV</Button>
    {open && <SidePanel open title="Export geographic analytics" description="Requires the aggregate export permission. The export uses the current area, period and filters, with suppressed cells left blank." onClose={() => setOpen(false)}>
      <form onSubmit={event => void submit(event)} className="grid gap-5">
        <label className={labelClass}>Purpose (recorded)<textarea className={`${control} min-h-20 py-2`} maxLength={500} value={purpose} onChange={event => setPurpose(event.target.value)} /></label>
        {message && <p role={message.tone === 'error' ? 'alert' : 'status'} className={`rounded-control border px-4 py-3 text-sm ${message.tone === 'error' ? 'border-status-error/30 bg-red-50 text-red-900' : 'border-status-success/30 bg-green-50 text-green-900'}`}>{message.text}</p>}
        <div className="flex justify-end"><Button type="submit" disabled={busy}>{busy ? 'Generating…' : 'Generate export'}</Button></div>
      </form>
    </SidePanel>}
  </>
}
