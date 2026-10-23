import { DocumentExportButton } from '@materyalph/web-ui'
import { useEffect, useId, useRef, useState, type ReactNode } from 'react'
import { Link, useNavigate, useParams, useSearchParams } from 'react-router-dom'
import { Award, BarChart3, Download, EyeOff, Gauge, PencilLine, Star } from 'lucide-react'
import {
  ActiveFilters, AnalyticsNullState, Button, BuyerRatingForm, ChartDataTable, DatasetNotice, DateFilter, FilterTabs, Toolbar, InfoNote, InsightPanel, MaterialThumbnail, PriceTrendPanel, ReviewRatingSummary, SampleMeter, Select, StatusBadge, StatusMessage, SuppressionNotice, TrendLineChart, TrendSummary,
  analyticsDay, dateComparisonPreset, formatAnalyticsDate, formatChartDay, formatManilaDateTime, formatPhpDecimal, manilaToday, type BuyerRatingSubmission, type DateFilterRange, type PricePoint,
} from '@materyalph/web-ui'
import { ProductAnalyticsDetail, ProductAnalyticsWorkspace } from './ProductAnalyticsPages'
import type { VendorAnalyticsPoint, VendorAnalyticsRow } from '@materyalph/api-client-ts'
import {
  editBuyerRating, exportVendorAnalytics, getOrderReviews, getStorePerformance, getVendorAnalyticsDetail, listVendorAnalytics, rateBuyer,
  type StorePerformance, type VendorAnalyticsFilters, type VendorMaterialsAnalyticsDetail, type VendorMaterialsAnalyticsList, type VendorOrderReviews,
} from '../lib/trust-api'
import { readableOrderError } from '../lib/orders-api'
import { storeName } from '../lib/catalog-access'
import { useOnboardingSnapshot } from '../lib/vendor-status'
import { ErrorState, LoadingState, PageHeader, VendorShell } from './PhaseThreeVendorPages'
import { ReviewDetailsWorkspace, ReviewsWorkspace } from './VendorReviewPages'
import { newIdempotencyKey } from '../lib/onboarding-api'

const RADII = [5, 10, 20, 30, 40, 50]

/** Shell + role gate shared by the Phase 14 Vendor pages; the API enforces the same permission on every request. */
function TrustShell({ activeHref, permission, deniedText, children }: { activeHref: string; permission: string | string[]; deniedText: string; children: ReactNode | ((permissions: string[]) => ReactNode) }) {
  const { snapshot, loading, error, refresh } = useOnboardingSnapshot()
  if (loading) return <VendorShell activeHref={activeHref} accountLabel="Vendor" navigationData={null}><LoadingState label="Loading…" /></VendorShell>
  if (error || !snapshot) return <VendorShell activeHref={activeHref} accountLabel="Vendor" navigationData={null}><ErrorState message={error ?? 'This page is unavailable.'} onRetry={() => void refresh()} /></VendorShell>
  const allowed = (Array.isArray(permission) ? permission : [permission]).some(item => snapshot.permissions.includes(item))
  return <VendorShell activeHref={activeHref} accountLabel={storeName(snapshot)} navigationData={snapshot}>
    {allowed ? (typeof children === 'function' ? children(snapshot.permissions) : children) : <StatusMessage tone="error">{deniedText}</StatusMessage>}
  </VendorShell>
}

function useAnalyticsFilters(): [VendorAnalyticsFilters, (next: Partial<VendorAnalyticsFilters>) => void] {
  const [params, setParams] = useSearchParams()
  const filters: VendorAnalyticsFilters = {
    radiusKm: RADII.includes(Number(params.get('radius'))) ? Number(params.get('radius')) : 50,
    presetDays: params.get('start') && params.get('end') ? null : [7, 30, 90].includes(Number(params.get('days'))) ? Number(params.get('days')) : 30,
    startDate: params.get('start'), endDate: params.get('end'), q: params.get('q') ?? undefined,
  }
  const update = (next: Partial<VendorAnalyticsFilters>) => {
    const merged = { ...filters, ...next }
    const query = new URLSearchParams()
    query.set('radius', String(merged.radiusKm))
    if (merged.startDate && merged.endDate) { query.set('start', merged.startDate); query.set('end', merged.endDate) } else query.set('days', String(merged.presetDays ?? 30))
    if (merged.q) query.set('q', merged.q)
    setParams(query, { replace: true })
  }
  return [filters, update]
}

function AnalyticsFilterBar({ filters, onChange, busy, window }: { filters: VendorAnalyticsFilters; onChange: (next: Partial<VendorAnalyticsFilters>) => void; busy: boolean; window?: VendorMaterialsAnalyticsList['window'] | undefined }) {
  const radiusId = useId()
  const end = analyticsDay(window?.latestAvailableDate) ?? manilaToday()
  const range: DateFilterRange = filters.startDate && filters.endDate ? { label: 'Custom range', from: filters.startDate, to: filters.endDate } : dateComparisonPreset(filters.presetDays ?? 30, end)
  const applyRange = (next: DateFilterRange) => {
    const preset = [7, 30, 90].find(days => next.label === `${days}-day comparison`)
    onChange(preset ? { presetDays: preset, startDate: null, endDate: null } : { startDate: next.from, endDate: next.to, presetDays: null })
  }
  return <div className="flex min-w-0 flex-col gap-3 sm:flex-row sm:flex-wrap sm:items-end">
    <Select id={radiusId} className="w-full sm:w-56" label="Radius around your store" value={filters.radiusKm} disabled={busy} onChange={event => onChange({ radiusKm: Number(event.target.value) })}>{RADII.map(radius => <option key={radius} value={radius}>{radius} km</option>)}</Select>
    <DateFilter title="Price comparison dates" value={range} onChange={applyRange} disabled={busy} allowAllDates={false} allowOpenEnded={false} minRangeDays={2} maxRangeDays={366} maxDate={manilaToday()} presets={[7, 30, 90].map(days => dateComparisonPreset(days, end))} />
  </div>
}

function AnalyticsRangeHint() {
  return <p className="text-xs leading-5 text-text-secondary">Compare the latest published snapshot with 7, 30 or 90 days earlier, or choose two dates.</p>
}

export function VendorMaterialsAnalyticsPage() {
  return <TrustShell activeHref="/analytics/materials" permission="materials_analytics.view_competitors" deniedText="Materials Analytics is available to the Owner and Store Manager only.">
    <MaterialsAnalyticsWorkspace />
  </TrustShell>
}

function MaterialsAnalyticsWorkspace() {
  const [filters, setFilters] = useAnalyticsFilters()
  const [params, setParams] = useSearchParams()
  const cursor = params.get('cursor')
  const [previousCursors, setPreviousCursors] = useState<(string | null)[]>([])
  const [data, setData] = useState<VendorMaterialsAnalyticsList | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  const [query, setQuery] = useState(filters.q ?? '')
  const [exporting, setExporting] = useState(false)
  const key = JSON.stringify(filters)
  useEffect(() => { setPreviousCursors([]) }, [key])
  useEffect(() => { setQuery(filters.q ?? '') }, [filters.q])
  useEffect(() => {
    let active = true
    setData(null); setError(null)
    // A changed scope ignores any response still in flight for the previous one.
    listVendorAnalytics(filters, cursor).then(result => { if (active) setData(result) }).catch(async cause => { const text = await readableOrderError(cause); if (active) setError(text) })
    return () => { active = false }
    // eslint-disable-next-line react-hooks/exhaustive-deps -- key captures every filter value
  }, [key, cursor, attempt])
  const download = async () => {
    setExporting(true)
    try {
      const blob = await exportVendorAnalytics(filters)
      const link = document.createElement('a'); link.href = URL.createObjectURL(blob); link.download = 'materials-analytics-competitor-averages.csv'; link.click(); URL.revokeObjectURL(link.href)
    } catch (cause) { setError(await readableOrderError(cause)) } finally { setExporting(false) }
  }
  const groups = new Map<string, VendorAnalyticsRow[]>()
  data?.items.forEach(row => groups.set(row.category.name, [...(groups.get(row.category.name) ?? []), row]))
  return <div className="space-y-6">
    <PageHeader eyebrow="Analytics" title="Materials Analytics" description="Compare nearby public listed prices for manual price planning."
      actions={<><DocumentExportButton basePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} audience="vendor" types={['MATERIALS_ANALYTICS']} filters={{ ...(filters.startDate && filters.endDate ? { start_date: filters.startDate, end_date: filters.endDate } : { preset_days: filters.presetDays ?? 30 }), radius_km: filters.radiusKm, ...(filters.q ? { q: filters.q } : {}) }} /><Button variant="secondary" onClick={() => void download()} disabled={exporting || !data}><Download size={16} aria-hidden="true" />{exporting ? 'Preparing…' : 'Export CSV'}</Button></>} />
    <InfoNote>Daily average public listed prices of competing stores near you, for manual price planning. Your own store is never part of these averages.</InfoNote>
    <Toolbar searchFirst alignEnd filters={<AnalyticsFilterBar filters={filters} window={data?.window} busy={data === null && !error} onChange={setFilters} />} search={{ label: 'Search materials', placeholder: 'Material, variant or brand', value: query, onChange: setQuery, onSubmit: event => { event.preventDefault(); setFilters({ q: query.trim() || undefined }) } }} />
    <AnalyticsRangeHint />
    <ActiveFilters filters={[
      ...(filters.q ? [{ key: 'q', label: `Search: ${filters.q}`, onRemove: () => setFilters({ q: undefined }) }] : []),
      ...(filters.radiusKm !== 50 ? [{ key: 'radius', label: `${filters.radiusKm} km radius`, onRemove: () => setFilters({ radiusKm: 50 }) }] : []),
      ...(filters.startDate || filters.presetDays !== 30 ? [{ key: 'dates', label: filters.startDate ? 'Custom comparison dates' : `${filters.presetDays}-day comparison`, onRemove: () => setFilters({ presetDays: 30, startDate: null, endDate: null }) }] : []),
    ]} onClear={() => { setQuery(''); setFilters({ q: undefined, radiusKm: 50, presetDays: 30, startDate: null, endDate: null }) }} />
    {error ? <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} />
      : !data ? <LoadingState label="Loading competitor averages…" />
        : <>
          <DatasetNotice label={data.dataset.label ?? 'Listed-price history'} updateSchedule={data.updateSchedule} snapshotAt={data.snapshot?.observedAt ? data.snapshot.observedAt.toISOString() : null} currentAsOf={data.currentAsOf.toISOString()} explanation="Competitor values appear only when at least three competing stores contribute. Below that, values and counts are withheld." />
          {data.items.length === 0 ? <AnalyticsNullState title="No comparable materials to show" reason={data.window.latestAvailableDate ? 'None of your comparable listings or nearby competitor groups have displayable data in this period. Try a larger radius or a longer period.' : 'No daily snapshot has been published yet. The first capture runs at 00:10 Asia/Manila.'} />
            : [...groups.entries()].map(([category, rows]) => <section key={category} aria-labelledby={`cat-${category}`} className="space-y-2">
              <details open className="group rounded-surface border border-border-default bg-surface-primary">
                <summary className="flex min-h-12 cursor-pointer items-center justify-between gap-3 px-4 text-base font-semibold" id={`cat-${category}`}>{category}<span className="text-sm font-normal text-text-secondary">{rows.length} variant{rows.length === 1 ? '' : 's'}</span></summary>
                <div className="overflow-x-auto border-t border-border-default">
                  <table className="w-full min-w-[760px] text-sm">
                    <caption className="sr-only">{category} comparable variants</caption>
                    <thead className="bg-surface-canvas text-left text-xs uppercase tracking-[0.08em] text-text-secondary"><tr><th className="px-4 py-2" scope="col">Material / variant</th><th className="px-4 py-2" scope="col">Competitor average</th><th className="px-4 py-2" scope="col">Change</th><th className="px-4 py-2" scope="col">Your price</th><th className="px-4 py-2" scope="col"><span className="sr-only">Action</span></th></tr></thead>
                    <tbody className="divide-y divide-border-default">{rows.map(row => <tr key={row.groupId}>
                      <td className="px-4 py-3"><div className="flex items-center gap-3"><MaterialThumbnail url={row.image?.url} categoryCode={row.category.code} size="sm" /><div><p className="font-semibold">{row.displayName}</p><p className="text-xs text-text-secondary">{row.material.name} · per {row.unit.name}</p></div></div></td>
                      <td className="px-4 py-3">{row.endPoint.status === 'OK' ? <><p className="font-semibold tabular-nums">{formatPhpDecimal(row.endPoint.averagePhp)}</p><p className="text-xs text-text-secondary">{row.endPoint.competitorCount} competitors · {formatAnalyticsDate(row.endPoint.date, true)}</p></> : row.endPoint.status === 'MISSING_DAY' ? <span className="text-text-secondary">No snapshot on {formatAnalyticsDate(row.endPoint.date, true)}</span> : <SuppressionNotice />}</td>
                      <td className="px-4 py-3"><TrendSummary compact trend={row.trend} /></td>
                      <td className="px-4 py-3">{row.ownOffer ? <><p className="font-semibold tabular-nums">{formatPhpDecimal(row.ownOffer.normalizedPhp)}</p><p className="text-xs text-text-secondary">{row.ownOffer.taxLabel}</p></> : <span className="text-text-secondary">Not listed</span>}</td>
                      <td className="px-4 py-3 text-right"><Link className="inline-flex min-h-11 items-center gap-1 font-semibold text-action-primary underline-offset-4 hover:underline" to={`/analytics/materials/${row.groupId}?${params.toString()}`} aria-label={`View details for ${row.displayName}`}>View details</Link></td>
                    </tr>)}</tbody>
                  </table>
                </div>
              </details>
            </section>)}
          {(previousCursors.length > 0 || data.nextCursor) && <nav aria-label="Material analytics pages" className="flex flex-wrap items-center justify-between gap-3 text-sm"><span className="text-text-secondary">Page {previousCursors.length + 1}</span><span className="flex gap-2"><Button variant="secondary" disabled={previousCursors.length === 0} onClick={() => { const previous = previousCursors.at(-1); setPreviousCursors(values => values.slice(0, -1)); setParams(current => { const next = new URLSearchParams(current); if (previous) next.set('cursor', previous); else next.delete('cursor'); return next }, { replace: true }) }}>Previous</Button><Button variant="secondary" disabled={!data.nextCursor} onClick={() => { setPreviousCursors(values => [...values, cursor]); setParams(current => { const next = new URLSearchParams(current); next.set('cursor', data.nextCursor!); return next }, { replace: true }) }}>Next</Button></span></nav>}
        </>}
  </div>
}

export function VendorMaterialPriceDetailsPage() {
  return <TrustShell activeHref="/analytics/materials" permission="materials_analytics.view_competitors" deniedText="Materials Analytics is available to the Owner and Store Manager only.">
    <MaterialPriceDetails />
  </TrustShell>
}

function MaterialPriceDetails() {
  const { groupId = '' } = useParams()
  const navigate = useNavigate()
  const [filters, setFilters] = useAnalyticsFilters()
  const [params] = useSearchParams()
  const [detail, setDetail] = useState<VendorMaterialsAnalyticsDetail | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  const key = JSON.stringify(filters) + groupId
  useEffect(() => {
    let active = true
    setDetail(null); setError(null)
    getVendorAnalyticsDetail(groupId, filters).then(result => { if (active) setDetail(result) }).catch(async cause => { const text = await readableOrderError(cause); if (active) setError(text) })
    return () => { active = false }
    // eslint-disable-next-line react-hooks/exhaustive-deps -- key captures every filter value
  }, [key, attempt])
  const back = <Link to={`/analytics/materials?${params.toString()}`} className="inline-flex min-h-11 items-center text-sm font-semibold text-action-primary">← Materials Analytics</Link>
  if (error) return <div className="space-y-4">{back}<ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} /></div>
  if (!detail) return <div className="space-y-4">{back}<LoadingState label="Loading price details…" /></div>
  const group = detail.group
  const points: PricePoint[] = detail.series.map((point: VendorAnalyticsPoint) => ({ date: analyticsDay(point.date) ?? '', value: point.averagePhp ?? null, status: point.status, label: point.label ?? null, count: point.competitorCount ?? null, participantsChanged: point.participantsChanged ?? null }))
  return <div className="space-y-6">
    {back}
    <div className="flex items-start gap-4"><MaterialThumbnail url={group.image?.url} alt={group.image ? (group.image.altText ?? `Your listing photo for ${group.displayName}`) : ''} categoryCode={group.category.code} size="lg" /><div className="min-w-0 flex-1"><PageHeader eyebrow={`${group.category.name} · ${group.material.name}`} title={group.displayName} description={`Competitor average public listed price per ${group.unit.name}, excluding your store.`} /></div></div>
    <p className="text-[13px] text-text-secondary">Specifications: {[group.specification.brand, ...group.specification.attributes.map(attribute => `${attribute.key.replaceAll('_', ' ')} ${attribute.value}`)].filter(Boolean).join(' · ')}</p>
    <div className="grid gap-2"><AnalyticsFilterBar filters={filters} window={detail.window} busy={false} onChange={setFilters} /><AnalyticsRangeHint /></div>
    <DatasetNotice label={detail.dataset.label ?? 'Listed-price history'} updateSchedule={detail.updateSchedule} snapshotAt={detail.snapshot?.observedAt ? detail.snapshot.observedAt.toISOString() : null} currentAsOf={detail.currentAsOf.toISOString()} explanation={detail.explanation} />
    {detail.variants.length > 1 && <Select className="max-w-md" label="Comparable variant" value={group.groupId} onChange={event => navigate(`/analytics/materials/${event.target.value}?${params.toString()}`)}>{detail.variants.map(variant => <option key={variant.groupId} value={variant.groupId}>{variant.displayName}</option>)}</Select>}
    <section className="grid gap-6 border-y border-border-default py-6 lg:grid-cols-3" aria-label="Summary">
      <div><p className="text-xs font-semibold uppercase tracking-[0.12em] text-text-secondary">Competitor average · {formatAnalyticsDate(group.endPoint.date, true)}</p>{group.endPoint.status === 'OK' ? <p className="mt-1 text-2xl font-semibold tabular-nums">{formatPhpDecimal(group.endPoint.averagePhp)}</p> : <div className="mt-2"><SuppressionNotice label={group.endPoint.label ?? 'Insufficient Competitor Data'} /></div>}</div>
      <div><p className="text-xs font-semibold uppercase tracking-[0.12em] text-text-secondary">Change over the period</p><div className="mt-2"><TrendSummary trend={group.trend} /></div></div>
      <div><p className="text-xs font-semibold uppercase tracking-[0.12em] text-text-secondary">Your current price</p>
        {group.ownOffer ? <><p className="mt-1 text-2xl font-semibold tabular-nums">{formatPhpDecimal(group.ownOffer.normalizedPhp)}</p><p className="text-xs text-text-secondary">{group.ownOffer.displayName} · {group.ownOffer.taxLabel} · since {formatManilaDateTime(group.ownOffer.priceAsOf)}</p>
          {detail.canEditOwnListing && <Link to={`/products/${group.ownOffer.listingId}`} className="mt-2 inline-flex min-h-11 items-center gap-1 font-semibold text-action-primary"><PencilLine size={16} aria-hidden="true" />Edit My Listing</Link>}</>
          : <p className="mt-1 text-sm text-text-secondary">You have no current comparable listing for this variant.</p>}
      </div>
    </section>
    <PriceTrendPanel title={`Competitor average for ${group.displayName}`} unit={group.unit.name} points={points} countLabel="Competitors"
      emptyReason="No date in this period has at least three competing stores within your radius, so no competitor value can be shown. Try a larger radius or a longer period." />
    <p className="text-xs text-text-secondary">Analytics never changes your prices. Editing your listing opens the normal editor; saving creates an audited price version.</p>
  </div>
}

/**
 * Store Performance: "Scores & badges" for the Owner and Store Manager (scores.view_store) and "Product analytics" for
 * every role that manages products (catalog.manage). A tab without its grant is absent; the API checks both again.
 */
export function VendorStorePerformancePage() {
  return <TrustShell activeHref="/performance" permission={['scores.view_store', 'catalog.manage']} deniedText="Store Performance is available to the Owner, Store Manager and roles that manage products.">
    {permissions => <PerformanceTabs canScores={permissions.includes('scores.view_store')} canProducts={permissions.includes('catalog.manage')} />}
  </TrustShell>
}

export function VendorProductAnalyticsPage() {
  return <TrustShell activeHref="/products" permission="catalog.manage" deniedText="Product analytics is available to roles that manage products.">
    {permissions => <ProductAnalyticsDetail canViewReviews={permissions.includes('reviews.view')} />}
  </TrustShell>
}

function PerformanceTabs({ canScores, canProducts }: { canScores: boolean; canProducts: boolean }) {
  const [params, setParams] = useSearchParams()
  const tabs = [...(canScores ? [{ value: 'scores', label: 'Scores & badges', icon: <Gauge size={16} aria-hidden="true" /> }] : []), ...(canProducts ? [{ value: 'products', label: 'Product analytics', icon: <BarChart3 size={16} aria-hidden="true" /> }] : [])]
  const requested = params.get('tab')
  const tab = tabs.some(item => item.value === requested) ? requested : tabs[0]?.value
  return <div className="space-y-6">
    <PageHeader eyebrow="Analytics" title="Store Performance" description={tab === 'products' ? 'See which products Buyers view, order and convert on, with suggestions on what to do next.' : 'Track your published scores, the operational events behind them and your badges.'} />
    {tabs.length > 1 && <FilterTabs appearance="tabs" label="Store Performance sections" value={tab ?? ''} chips={tabs} onChange={value => setParams(value === 'products' ? { tab: 'products' } : {}, { replace: true })} />}
    {tab === 'products' ? <ProductAnalyticsWorkspace /> : <PerformanceWorkspace />}
  </div>
}

const SCORE_NAMES: Record<string, string> = { VPS: 'Vendor Performance Score', VCS: 'Vendor Community Score', MQS: 'Material Quality Score', OHS: 'Operational Health Score' }
const SCORE_FORMULAS: Record<string, string> = { VPS: 'VCS × 0.50 + OHS × 0.50', VCS: '(Service Quality + Speed + MQS) ÷ 3', MQS: 'Average verified Product Quality rating', OHS: '5.00 − NFR − LSR − RR − ODR − LVD penalties' }
const RATE_ROWS: { key: 'NFR' | 'LSR' | 'RR' | 'ODR'; name: string; definition: string; bands: string }[] = [
  { key: 'NFR', name: 'Non-Fulfillment Rate', definition: 'Vendor-caused cancellations or refunds ÷ eligible confirmed orders', bands: 'No penalty to 2% · 0.25 to 5% · 0.75 to 10% · 1.50 above' },
  { key: 'LSR', name: 'Late Shipment Rate', definition: 'Orders dispatched or made ready after the confirmed date ÷ eligible fulfilled orders', bands: 'No penalty to 3% · 0.25 to 8% · 0.75 to 15% · 1.25 above' },
  { key: 'RR', name: 'Return Rate', definition: 'Validated defect, wrong-item or incomplete-order returns ÷ fulfilled orders', bands: 'No penalty to 2% · 0.25 to 5% · 0.50 to 10% · 1.00 above' },
  { key: 'ODR', name: 'Order Defect Rate', definition: 'Confirmed defect claims, chargebacks or severe issues ÷ eligible orders', bands: 'No penalty to 1% · 0.25 to 3% · 0.75 to 6% · 1.25 above' },
]
const penaltyText = (value: string | undefined) => (value === undefined || Number(value) === 0 ? 'None' : `−${value}`)

function PerformanceWorkspace() {
  const [data, setData] = useState<StorePerformance | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  useEffect(() => {
    let active = true
    setData(null); setError(null)
    getStorePerformance().then(result => { if (active) setData(result) }).catch(async cause => { const text = await readableOrderError(cause); if (active) setError(text) })
    return () => { active = false }
  }, [attempt])
  if (error) return <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} />
  if (!data) return <LoadingState label="Loading store performance…" />
  const operations = data.operations as { rates?: Record<string, string>; penalties?: Record<string, string>; numerators?: Record<string, number>; denominators?: Record<string, number>; listingViolations?: number; listing_violations?: number } | null
  const completed = data.completedOrders as { last90Days?: number; last_90_days?: number; total?: number } | undefined
  const history = data.history ?? []
  const number = (value: string | null | undefined) => (value === null || value === undefined ? null : Number(value))
  if (!data.calculated) return <AnalyticsNullState title="No daily calculation yet" reason="Your first scores appear after the next daily calculation at 00:30 Asia/Manila. Until the sample minimums are met your store shows New Vendor — Building Track Record." />
  return <div className="space-y-5">
    <section aria-label="Public standing" className="flex flex-col gap-4 rounded-surface border border-border-default bg-surface-primary p-5 md:flex-row md:items-center md:justify-between">
      <div className="min-w-0"><p className="text-xs font-semibold uppercase tracking-[0.12em] text-text-secondary">What Buyers see</p><p className="mt-1 text-xl font-semibold text-text-strong">{data.label}</p>
        <p className="mt-1 text-sm text-text-secondary">Scores come from verified-purchase ratings and system-recorded order events, recalculated daily at 00:30 Asia/Manila.</p></div>
      <dl className="grid shrink-0 grid-cols-2 gap-x-8 gap-y-2 text-sm sm:grid-cols-3">
        <div><dt className="text-xs text-text-secondary">Scores as of</dt><dd className="font-semibold">{formatAnalyticsDate(data.asOf, true)}</dd></div>
        <div><dt className="text-xs text-text-secondary">Next OHS update</dt><dd className="font-semibold">{formatAnalyticsDate(data.nextOhsRecalculationOn, true)}</dd></div>
        <div><dt className="text-xs text-text-secondary">Completed orders (90 days)</dt><dd className="font-semibold tabular-nums">{completed?.last90Days ?? completed?.last_90_days ?? 0} <span className="font-normal text-text-secondary">of {completed?.total ?? 0} total</span></dd></div>
      </dl>
    </section>

    <InsightPanel title="Published scores" purpose="Your four platform scores on a 1.00–5.00 scale. Each one appears only after its sample minimum is met, so a new store is never shown an unearned score."
      method={<>VPS = (VCS × 0.50) + (OHS × 0.50), published only when VCS and OHS are both eligible. VCS = (Service Quality + Delivery/Processing Speed + MQS) ÷ 3 over a rolling 90 days, after 5 eligible Vendor ratings. MQS = average eligible Product Quality rating over a rolling 90 days, after 5 eligible product ratings. OHS = 5.00 minus the penalties below (kept between 1.00 and 5.00), after 10 eligible orders in the trailing 30 days, recalculated every Monday.</>}>
      <ul className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">{data.scores.map(score => <li key={score.key} className="flex min-w-0 flex-col gap-2 rounded-control border border-border-default p-4">
        <div className="flex items-start justify-between gap-2"><div className="min-w-0"><p className="text-sm font-semibold text-text-strong">{score.key}</p><p className="text-xs text-text-secondary">{SCORE_NAMES[score.key] ?? score.key}</p></div>
          <StatusBadge label={score.published ? 'Published' : 'Building'} tone={score.published ? 'success' : 'neutral'} /></div>
        <p className="text-3xl font-semibold leading-tight tabular-nums text-text-strong">{score.published && score.value ? score.value : <span className="text-lg text-text-secondary">Not yet published</span>}</p>
        {score.minimumSample ? <SampleMeter label={`${score.key} sample`} value={score.sampleCount ?? 0} minimum={score.minimumSample} /> : null}
        <p className="mt-auto text-xs text-text-secondary">{SCORE_FORMULAS[score.key] ?? ''} · {score.key === 'VPS' ? 'recalculated daily' : score.window}</p>
      </li>)}</ul>
      {data.label.startsWith('New Vendor') && <p className="text-xs text-text-secondary">Until VCS and OHS both meet their minimums, your public label stays “New Vendor — Building Track Record”.</p>}
    </InsightPanel>

    {history.some(point => point.vps || point.vcs || point.mqs || point.ohs) && <InsightPanel title="Score history" purpose="How your published scores moved over the last 30 daily calculations, to see whether recent changes are helping."
      method="Each point is that day's published value from the 00:30 Asia/Manila calculation. A gap means the score was not published that day.">
      <TrendLineChart title="Published score history" labels={history.map(point => analyticsDay(point.date) ?? '')} formatLabel={formatChartDay} formatValue={value => value.toFixed(2)} emptyReason="No published scores yet."
        series={[{ key: 'vps', label: 'VPS', colorVar: '--mp-viz-series-1', values: history.map(point => number(point.vps)) }, { key: 'vcs', label: 'VCS', colorVar: '--mp-viz-series-2', values: history.map(point => number(point.vcs)) },
          { key: 'mqs', label: 'MQS', colorVar: '--mp-viz-series-3', values: history.map(point => number(point.mqs)) }, { key: 'ohs', label: 'OHS', colorVar: '--mp-viz-series-4', values: history.map(point => number(point.ohs)) }]} />
      <ChartDataTable caption="Published score history" rowHeader="Date" rows={history.map(point => formatChartDay(analyticsDay(point.date) ?? ''))} columns={(['vps', 'vcs', 'mqs', 'ohs'] as const).map(key => ({ key, header: key.toUpperCase(), values: history.map(point => point[key] ?? null) }))} />
    </InsightPanel>}

    {operations?.rates && <InsightPanel title="Operational health (trailing 30 days)" purpose="The order events behind your OHS. Each rate above its no-penalty band lowers OHS by the penalty shown — the fastest place to improve your score."
      method="Rates are counted from system-recorded order events in the trailing 30 days (listing violations: 90 days). Penalty bands are the System Workflow’s published rules; LVD is 0.10 for one violation, 0.30 for two to three, 0.60 for four to five and 1.00 for six or more.">
      <div className="overflow-x-auto"><table className="w-full min-w-[640px] text-sm">
        <caption className="sr-only">Operational health components</caption>
        <thead className="border-b border-border-default text-left text-xs uppercase tracking-[0.08em] text-text-secondary"><tr><th className="py-2 pr-4" scope="col">Metric</th><th className="px-4 py-2 text-right" scope="col">Events</th><th className="px-4 py-2 text-right" scope="col">Rate</th><th className="py-2 pl-4 text-right" scope="col">Penalty</th></tr></thead>
        <tbody className="divide-y divide-border-default">{RATE_ROWS.map(row => <tr key={row.key}>
          <th scope="row" className="py-3 pr-4 text-left align-top font-normal"><span className="block font-semibold text-text-strong">{row.name} ({row.key})</span><span className="block text-xs text-text-secondary">{row.definition}</span><span className="block text-xs text-text-secondary">Bands: {row.bands}</span></th>
          <td className="px-4 py-3 text-right align-top tabular-nums">{operations.numerators?.[row.key] ?? 0} of {operations.denominators?.[row.key] ?? 0}</td>
          <td className="px-4 py-3 text-right align-top font-semibold tabular-nums">{operations.rates?.[row.key] ?? '0.00'}%</td>
          <td className="py-3 pl-4 text-right align-top tabular-nums">{penaltyText(operations.penalties?.[row.key])}</td></tr>)}
          <tr><th scope="row" className="py-3 pr-4 text-left align-top font-normal"><span className="block font-semibold text-text-strong">Listing Violation Deduction (LVD)</span><span className="block text-xs text-text-secondary">Active confirmed listing violations, trailing 90 days</span></th>
            <td className="px-4 py-3 text-right align-top tabular-nums">{operations.listingViolations ?? operations.listing_violations ?? 0}</td><td className="px-4 py-3 text-right align-top text-text-secondary">—</td><td className="py-3 pl-4 text-right align-top tabular-nums">{penaltyText(operations.penalties?.LVD)}</td></tr>
        </tbody></table></div>
    </InsightPanel>}

    <div className="grid items-start gap-5 xl:grid-cols-2">
      <InsightPanel title="Badge metrics" purpose="The two rates that decide the Fast Responder and On-Time badges." method="CRR = eligible inquiries answered by a person within 12 hours ÷ eligible inquiries × 100 (trailing 30 days). FRR = orders fulfilled on or before the confirmed date ÷ eligible fulfilled orders × 100 (trailing 90 days).">
        <dl className="grid gap-5 sm:grid-cols-2">{data.badgeMetrics.map(metric => <div key={metric.key} className="grid gap-1">
          <dt className="text-xs font-semibold text-text-secondary">{metric.key === 'CRR' ? 'Customer Response Rate (CRR)' : 'Fulfillment Reliability Rate (FRR)'}</dt>
          <dd className="text-3xl font-semibold tabular-nums text-text-strong">{metric.value ? `${metric.value}%` : '—'}</dd>
          {metric.value && <dd aria-hidden="true" className="h-1.5 rounded-pill bg-surface-canvas"><span className="block h-1.5 rounded-pill bg-action-primary" style={{ width: `${Math.min(100, Number(metric.value))}%` }} /></dd>}
          <dd className="text-xs text-text-secondary">{metric.window} · {metric.sampleCount} counted</dd></div>)}</dl>
      </InsightPanel>
      <InsightPanel title="Badges" purpose="Badges appear on your storefront. They are awarded and removed automatically each day; they cannot be requested or assigned manually."
        method="Each badge checks its published threshold in the daily calculation, for example Fast Responder needs CRR of at least 85% from 10 or more inquiries in the last 30 days.">
        <ul className="grid gap-2">{data.badges.map(badge => <li key={badge.code} className="flex items-start gap-3 rounded-control bg-surface-canvas px-3 py-2.5">
          <Award size={18} className={`mt-0.5 shrink-0 ${badge.status === 'EARNED' ? 'text-action-primary' : 'text-text-secondary'}`} aria-hidden="true" />
          <span className="min-w-0 flex-1"><span className="flex flex-wrap items-center gap-2"><span className="text-sm font-semibold text-text-strong">{badge.name}</span>
            <StatusBadge label={badge.status === 'EARNED' ? 'Earned' : badge.status === 'SUPPRESSED' ? 'Suppressed by review' : 'Not earned'} tone={badge.status === 'EARNED' ? 'success' : badge.status === 'SUPPRESSED' ? 'warning' : 'neutral'} /></span>
            <span className="block text-xs leading-5 text-text-secondary">{badge.description}</span>
            {badge.scopes.length > 0 && <span className="block text-xs text-text-secondary">{badge.scopes.map(scope => scope.scopeLabel).filter(Boolean).join(' · ')}</span>}</span>
        </li>)}</ul>
      </InsightPanel>
    </div>
  </div>
}

export function VendorReviewsPage() {
  return <TrustShell activeHref="/reviews" permission="reviews.view" deniedText="Ratings and reviews are not available to your role.">
    <ReviewsWorkspace />
  </TrustShell>
}

export function VendorReviewDetailPage() {
  return <TrustShell activeHref="/reviews" permission="reviews.view" deniedText="Ratings and reviews are not available to your role.">
    <ReviewDetailsWorkspace />
  </TrustShell>
}

/** Order-detail panel: the store rates the Buyer (CCS) within the 14-day window and sees the Buyer's ratings after the blind reveal. */
export function OrderReviewPanel({ orderId, canRate }: { orderId: string; canRate: boolean }) {
  return <OrderReviewWorkspace key={orderId} orderId={orderId} canRate={canRate} />
}

function OrderReviewWorkspace({ orderId, canRate }: { orderId: string; canRate: boolean }) {
  const headingId = useId()
  const [data, setData] = useState<VendorOrderReviews | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  const [editing, setEditing] = useState(false)
  const [notice, setNotice] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  const [formError, setFormError] = useState<string | null>(null)
  const pending = useRef(false)
  const submission = useRef<{ fingerprint: string; key: string } | null>(null)
  const mounted = useRef(false)
  useEffect(() => { mounted.current = true; return () => { mounted.current = false } }, [])
  useEffect(() => {
    let active = true
    setData(null); setError(null); setFormError(null)
    getOrderReviews(orderId).then(result => {
      if (active) { setData(result); setEditing(canRate && result.canSubmitBuyerRating && !result.buyerRating) }
    }).catch(async cause => { const text = await readableOrderError(cause); if (active) setError(text) })
    return () => { active = false }
  }, [orderId, canRate, attempt])
  const own = data?.buyerRating
  const editable = canRate && Boolean(data?.canSubmitBuyerRating || own?.canEdit)
  const submit = async (ratings: BuyerRatingSubmission) => {
    if (pending.current || !editable) return
    pending.current = true
    setBusy(true); setFormError(null)
    try {
      const fingerprint = JSON.stringify(ratings)
      if (!submission.current || submission.current.fingerprint !== fingerprint) submission.current = { fingerprint, key: newIdempotencyKey() }
      const updated = own ? await editBuyerRating(own.id, own.lockVersion, ratings) : await rateBuyer(orderId, ratings, submission.current.key)
      if (mounted.current) {
        setData(updated); setEditing(false); submission.current = null
        setNotice(own ? 'Your rating correction was saved.' : 'Your Buyer rating was submitted.')
      }
    } catch (cause) {
      const text = await readableOrderError(cause)
      if (mounted.current) setFormError(text)
    } finally { pending.current = false; if (mounted.current) setBusy(false) }
  }
  return <section aria-labelledby={headingId} className="grid min-w-0 gap-5 rounded-surface border border-border-default bg-surface-primary p-4 sm:p-5">
    <div className="flex flex-wrap items-start justify-between gap-3">
      <div><h2 id={headingId} className="flex items-center gap-2 text-lg font-semibold"><Star className="text-action-primary" size={20} aria-hidden="true" />Ratings</h2><p className="mt-1 text-sm text-text-secondary">Feedback for this completed purchase.</p></div>
      {data && <StatusBadge label={data.state === 'OPEN' ? 'Rating window open' : data.state === 'CLOSED' ? 'Rating window closed' : 'Not yet eligible'} tone={data.state === 'OPEN' ? 'info' : 'neutral'} />}
    </div>
    {error ? <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} /> : !data ? <LoadingState label="Loading ratings…" /> : <>
      {data.state === 'NOT_COMPLETED' ? <p className="text-sm text-text-secondary">Ratings become available once the order is completed.</p> : <>
        {notice && <StatusMessage tone="success">{notice}</StatusMessage>}
        <div className="grid gap-2 text-sm text-text-secondary">
          <p className="flex items-start gap-2"><EyeOff size={16} className="mt-0.5 shrink-0" aria-hidden="true" />{data.rules.blindReveal}</p>
          {data.closesAtLabel && <p>{data.state === 'OPEN' ? 'Submit by' : 'Window closed'} <span className="font-medium text-text-strong">{data.closesAtLabel}</span></p>}
        </div>
        {data.withheldForDispute && <StatusMessage>Publication is withheld while a related dispute is active.</StatusMessage>}
        {editing && editable ? <div className="grid min-w-0 gap-3">
          <div><h3 className="text-base font-semibold">{own ? 'Correct your Buyer rating' : 'Rate this Buyer'}</h3>
            {own && <p className="mt-1 text-sm text-text-secondary">Corrections available until {own.correctionRequested && own.correctionDueAt ? formatManilaDateTime(own.correctionDueAt) : own.editableUntilLabel}.</p>}
          </div>
          <BuyerRatingForm key={`${own?.id ?? 'new'}-${own?.lockVersion ?? 0}`} editing={Boolean(own)} busy={busy} error={formError} commentMax={data.rules.commentMax}
            initialValues={{ inquirySeriousness: own?.ratings.inquirySeriousness ?? null, communicationQuality: own?.ratings.communicationQuality ?? null, paymentReliability: own?.ratings.paymentReliability ?? null, comment: own?.comment ?? '' }}
            onSubmit={ratings => void submit(ratings)} onCancel={() => { setEditing(false); setFormError(null) }} />
        </div> : <div className="grid gap-3">
          {own ? <><h3 className="text-sm font-semibold">Your store's rating of this Buyer</h3><ReviewRatingSummary ratings={own.ratings} />{own.comment && <p className="whitespace-pre-wrap break-words text-sm">{own.comment}</p>}<p className="text-xs text-text-secondary">{own.canEdit ? `You can correct this rating until ${own.correctionRequested && own.correctionDueAt ? formatManilaDateTime(own.correctionDueAt) : own.editableUntilLabel}.` : 'This rating is locked.'}</p></>
            : data.state === 'CLOSED' ? <p className="text-sm text-text-secondary">The submission window has ended.</p> : !canRate ? <p className="text-sm text-text-secondary">Your role can view ratings but cannot rate this Buyer.</p> : null}
          {editable && <Button className="w-fit" variant="secondary" onClick={() => { setNotice(null); setFormError(null); setEditing(true) }}>{own ? 'Correct rating' : 'Rate Buyer'}</Button>}
        </div>}
        {data.revealed && <div className="grid gap-3 border-t border-border-default pt-4"><h3 className="text-sm font-semibold">The Buyer's ratings</h3>{data.received.length === 0 ? <p className="text-sm text-text-secondary">No Buyer ratings are available to view.</p> : data.received.map(review => <div key={review.id} className="grid min-w-0 gap-2 border-l-2 border-border-default pl-3"><ReviewRatingSummary ratings={review.ratings} />{review.comment && <p className="whitespace-pre-wrap break-words text-sm">{review.comment}</p>}</div>)}</div>}
      </>}
    </>}
  </section>
}

