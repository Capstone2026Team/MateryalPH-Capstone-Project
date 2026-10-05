import { useEffect, useId, useState, type FormEvent, type ReactNode } from 'react'
import { Link, useNavigate, useParams, useSearchParams } from 'react-router-dom'
import { Download, Flag, LineChart, PencilLine, RefreshCw, Search, Star } from 'lucide-react'
import {
  AnalyticsNullState, Button, DatasetNotice, FilterChips, PriceTrendPanel, ScoreTile, StarRatingDisplay, StarRatingInput, StatusBadge, StatusMessage, SuppressionNotice, TrendSummary,
  formatAnalyticsDate, formatManilaDateTime, formatPhpDecimal, type PricePoint,
} from '@materyalph/web-ui'
import type { VendorAnalyticsPoint, VendorAnalyticsRow } from '@materyalph/api-client-ts'
import {
  editBuyerRating, exportVendorAnalytics, getOrderReviews, getStorePerformance, getVendorAnalyticsDetail, listReviews, listVendorAnalytics, rateBuyer, reportReview,
  type FlagReason, type ReviewTab, type StorePerformance, type VendorAnalyticsFilters, type VendorMaterialsAnalyticsDetail, type VendorMaterialsAnalyticsList, type VendorOrderReviews, type VendorReviewRow,
} from '../lib/trust-api'
import { readableOrderError } from '../lib/orders-api'
import { storeName } from '../lib/catalog-access'
import { useOnboardingSnapshot } from '../lib/vendor-status'
import { ErrorState, LoadingState, PageHeader, VendorShell } from './PhaseThreeVendorPages'

const control = 'min-h-12 w-full min-w-0 rounded-control border border-border-default bg-surface-primary px-3 text-base font-normal'
const RADII = [5, 10, 20, 30, 40, 50]
const PRESETS = [{ value: '7', label: '7 days' }, { value: '30', label: '30 days' }, { value: '90', label: '90 days' }, { value: 'custom', label: 'Custom' }]

/** Shell + role gate shared by the Phase 14 Vendor pages; the API enforces the same permission on every request. */
function TrustShell({ activeHref, permission, deniedText, children }: { activeHref: string; permission: string; deniedText: string; children: ReactNode }) {
  const { snapshot, loading, error, refresh } = useOnboardingSnapshot()
  if (loading) return <VendorShell activeHref={activeHref} accountLabel="Vendor" navigationData={null}><LoadingState label="Loading…" /></VendorShell>
  if (error || !snapshot) return <VendorShell activeHref={activeHref} accountLabel="Vendor" navigationData={null}><ErrorState message={error ?? 'This page is unavailable.'} onRetry={() => void refresh()} /></VendorShell>
  return <VendorShell activeHref={activeHref} accountLabel={storeName(snapshot)} navigationData={snapshot}>
    {snapshot.permissions.includes(permission) ? children : <StatusMessage tone="error">{deniedText}</StatusMessage>}
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

function AnalyticsFilterBar({ filters, onChange, busy }: { filters: VendorAnalyticsFilters; onChange: (next: Partial<VendorAnalyticsFilters>) => void; busy: boolean }) {
  const [custom, setCustom] = useState(Boolean(filters.startDate))
  const [start, setStart] = useState(filters.startDate ?? '')
  const [end, setEnd] = useState(filters.endDate ?? '')
  const [rangeError, setRangeError] = useState<string | null>(null)
  const radiusId = useId()
  const applyCustom = (event: FormEvent) => {
    event.preventDefault()
    if (!start || !end || start >= end) { setRangeError('Choose a start date before the end date.'); return }
    if ((Date.parse(end) - Date.parse(start)) / 86400000 > 365) { setRangeError('Choose a range of at most 365 days.'); return }
    setRangeError(null)
    onChange({ startDate: start, endDate: end, presetDays: null })
  }
  return <div className="grid gap-4 border-b border-border-default pb-5">
    <div className="grid gap-4 lg:grid-cols-[minmax(0,12rem)_minmax(0,1fr)] lg:items-end">
      <label className="grid gap-2 text-sm font-semibold" htmlFor={radiusId}>Radius around your store
        <select id={radiusId} className={control} value={filters.radiusKm} disabled={busy} onChange={event => onChange({ radiusKm: Number(event.target.value) })}>{RADII.map(radius => <option key={radius} value={radius}>{radius} km</option>)}</select>
      </label>
      <FilterChips label="Comparison period" disabled={busy} value={custom ? 'custom' : String(filters.presetDays ?? 30)} chips={PRESETS}
        onChange={value => { if (value === 'custom') { setCustom(true); return } setCustom(false); onChange({ presetDays: Number(value), startDate: null, endDate: null }) }} />
    </div>
    {custom && <form className="grid gap-3 sm:grid-cols-[minmax(0,1fr)_minmax(0,1fr)_auto] sm:items-end" onSubmit={applyCustom} noValidate>
      <label className="grid gap-2 text-sm font-semibold">Start date<input className={control} type="date" value={start} max={end || undefined} onChange={event => setStart(event.target.value)} aria-invalid={rangeError ? true : undefined} /></label>
      <label className="grid gap-2 text-sm font-semibold">End date<input className={control} type="date" value={end} min={start || undefined} max={new Date().toISOString().slice(0, 10)} onChange={event => setEnd(event.target.value)} /></label>
      <Button type="submit" variant="secondary" disabled={busy}>Apply dates</Button>
      {rangeError && <p className="text-sm text-status-error sm:col-span-3" role="alert">{rangeError}</p>}
    </form>}
  </div>
}

export function VendorMaterialsAnalyticsPage() {
  return <TrustShell activeHref="/analytics/materials" permission="materials_analytics.view_competitors" deniedText="Materials Analytics is available to the Owner and Store Manager only.">
    <MaterialsAnalyticsWorkspace />
  </TrustShell>
}

function MaterialsAnalyticsWorkspace() {
  const [filters, setFilters] = useAnalyticsFilters()
  const [data, setData] = useState<VendorMaterialsAnalyticsList | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  const [query, setQuery] = useState(filters.q ?? '')
  const [exporting, setExporting] = useState(false)
  const key = JSON.stringify(filters)
  useEffect(() => {
    let active = true
    setData(null); setError(null)
    // A changed scope ignores any response still in flight for the previous one.
    listVendorAnalytics(filters).then(result => { if (active) setData(result) }).catch(async cause => { const text = await readableOrderError(cause); if (active) setError(text) })
    return () => { active = false }
    // eslint-disable-next-line react-hooks/exhaustive-deps -- key captures every filter value
  }, [key, attempt])
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
    <PageHeader eyebrow="Analytics" title="Materials Analytics" description="Daily average public listed prices of competing stores near you, for manual price planning. Your own store is never part of these averages."
      actions={<Button variant="secondary" onClick={() => void download()} disabled={exporting || !data}><Download size={16} aria-hidden="true" />{exporting ? 'Preparing…' : 'Export CSV'}</Button>} />
    <AnalyticsFilterBar filters={filters} busy={data === null && !error} onChange={setFilters} />
    <form className="flex max-w-xl gap-2" role="search" onSubmit={event => { event.preventDefault(); setFilters({ q: query.trim() || undefined }) }}>
      <label className="sr-only" htmlFor="analytics-search">Search materials</label>
      <input id="analytics-search" className={control} placeholder="Search material, variant or brand" value={query} onChange={event => setQuery(event.target.value)} />
      <Button type="submit" variant="secondary"><Search size={16} aria-hidden="true" />Search</Button>
    </form>
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
                      <td className="px-4 py-3"><p className="font-semibold">{row.displayName}</p><p className="text-xs text-text-secondary">{row.material.name} · per {row.unit.name}</p></td>
                      <td className="px-4 py-3">{row.endPoint.status === 'OK' ? <><p className="font-semibold tabular-nums">{formatPhpDecimal(row.endPoint.averagePhp)}</p><p className="text-xs text-text-secondary">{row.endPoint.competitorCount} competitors · {formatAnalyticsDate(String(row.endPoint.date), true)}</p></> : row.endPoint.status === 'MISSING_DAY' ? <span className="text-text-secondary">No snapshot on {formatAnalyticsDate(String(row.endPoint.date), true)}</span> : <SuppressionNotice />}</td>
                      <td className="px-4 py-3"><TrendSummary compact trend={row.trend} /></td>
                      <td className="px-4 py-3">{row.ownOffer ? <><p className="font-semibold tabular-nums">{formatPhpDecimal(row.ownOffer.normalizedPhp)}</p><p className="text-xs text-text-secondary">{row.ownOffer.taxLabel}</p></> : <span className="text-text-secondary">Not listed</span>}</td>
                      <td className="px-4 py-3 text-right"><Link className="inline-flex min-h-11 items-center gap-1 font-semibold text-action-primary underline-offset-4 hover:underline" to={`/analytics/materials/${row.groupId}?${new URLSearchParams(window.location.search).toString()}`} aria-label={`View details for ${row.displayName}`}>View details</Link></td>
                    </tr>)}</tbody>
                  </table>
                </div>
              </details>
            </section>)}
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
  const back = <Link to={`/analytics/materials${window.location.search}`} className="inline-flex min-h-11 items-center text-sm font-semibold text-action-primary">← Materials Analytics</Link>
  if (error) return <div className="space-y-4">{back}<ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} /></div>
  if (!detail) return <div className="space-y-4">{back}<LoadingState label="Loading price details…" /></div>
  const group = detail.group
  const points: PricePoint[] = detail.series.map((point: VendorAnalyticsPoint) => ({ date: String(point.date instanceof Date ? point.date.toISOString().slice(0, 10) : point.date), value: point.averagePhp ?? null, status: point.status, label: point.label ?? null, count: point.competitorCount ?? null, participantsChanged: point.participantsChanged ?? null }))
  return <div className="space-y-6">
    {back}
    <PageHeader eyebrow={`${group.category.name} · ${group.material.name}`} title={group.displayName} description={`Competitor average public listed price per ${group.unit.name}, excluding your store. Specifications: ${[group.specification.brand, ...group.specification.attributes.map(attribute => `${attribute.key.replaceAll('_', ' ')} ${attribute.value}`)].filter(Boolean).join(' · ')}.`} />
    <AnalyticsFilterBar filters={filters} busy={false} onChange={setFilters} />
    <DatasetNotice label={detail.dataset.label ?? 'Listed-price history'} updateSchedule={detail.updateSchedule} snapshotAt={detail.snapshot?.observedAt ? detail.snapshot.observedAt.toISOString() : null} currentAsOf={detail.currentAsOf.toISOString()} explanation={detail.explanation} />
    {detail.variants.length > 1 && <label className="grid max-w-md gap-2 text-sm font-semibold">Comparable variant
      <select className={control} value={group.groupId} onChange={event => navigate(`/analytics/materials/${event.target.value}${window.location.search}`)}>{detail.variants.map(variant => <option key={variant.groupId} value={variant.groupId}>{variant.displayName}</option>)}</select>
    </label>}
    <section className="grid gap-6 border-y border-border-default py-6 lg:grid-cols-3" aria-label="Summary">
      <div><p className="text-xs font-semibold uppercase tracking-[0.12em] text-text-secondary">Competitor average · {formatAnalyticsDate(String(group.endPoint.date), true)}</p>{group.endPoint.status === 'OK' ? <p className="mt-1 text-2xl font-semibold tabular-nums">{formatPhpDecimal(group.endPoint.averagePhp)}</p> : <div className="mt-2"><SuppressionNotice label={group.endPoint.label ?? 'Insufficient Competitor Data'} /></div>}</div>
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

export function VendorStorePerformancePage() {
  return <TrustShell activeHref="/performance" permission="scores.view_store" deniedText="Store Performance is available to the Owner and Store Manager.">
    <PerformanceWorkspace />
  </TrustShell>
}

const RATE_NAMES: Record<string, string> = { NFR: 'Non-Fulfillment Rate', LSR: 'Late Shipment Rate', RR: 'Return Rate', ODR: 'Order Defect Rate' }

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
  return <div className="space-y-6">
    <PageHeader eyebrow="Analytics" title="Store Performance" description="Scores from verified-purchase ratings and system-recorded order events, calculated daily at 00:30 Asia/Manila. The formulas and thresholds are the platform's published rules." />
    {!data.calculated ? <AnalyticsNullState title="No daily calculation yet" reason="Your first scores appear after the next daily calculation. Until the sample minimums are met your store shows New Vendor — Building Track Record." />
      : <>
        <section aria-label="Scores" className="grid gap-6 border-b border-border-default pb-6 sm:grid-cols-2 xl:grid-cols-4">
          {data.scores.map(score => <ScoreTile key={score.key} name={score.key} value={score.value ?? null} published={score.published} sample={score.sampleCount} minimum={score.minimumSample} window={score.window} status={score.statusText} />)}
        </section>
        <p className="text-sm text-text-secondary">Public label: <strong className="text-text-strong">{data.label}</strong> · As of {data.asOf ? formatAnalyticsDate(String(data.asOf instanceof Date ? data.asOf.toISOString().slice(0, 10) : data.asOf), true) : '—'} · OHS recalculated weekly (next {formatAnalyticsDate(String(data.nextOhsRecalculationOn instanceof Date ? data.nextOhsRecalculationOn.toISOString().slice(0, 10) : data.nextOhsRecalculationOn), true)})</p>
        {operations?.rates && <section aria-labelledby="ohs-components" className="space-y-3">
          <h2 id="ohs-components" className="text-lg font-semibold">Operational Health components (trailing 30 days)</h2>
          <div className="overflow-x-auto rounded-control border border-border-default"><table className="w-full min-w-[560px] text-sm">
            <thead className="bg-surface-canvas text-left text-xs uppercase tracking-[0.08em] text-text-secondary"><tr><th className="px-4 py-2" scope="col">Metric</th><th className="px-4 py-2" scope="col">Events</th><th className="px-4 py-2" scope="col">Rate</th><th className="px-4 py-2" scope="col">Penalty</th></tr></thead>
            <tbody className="divide-y divide-border-default">{Object.entries(operations.rates).map(([key, rate]) => <tr key={key}><th scope="row" className="px-4 py-2 text-left font-semibold">{RATE_NAMES[key] ?? key}</th>
              <td className="px-4 py-2 tabular-nums">{operations.numerators?.[key] ?? 0} of {operations.denominators?.[key] ?? 0}</td><td className="px-4 py-2 tabular-nums">{rate}%</td><td className="px-4 py-2 tabular-nums">−{operations.penalties?.[key] ?? '0.00'}</td></tr>)}
              <tr><th scope="row" className="px-4 py-2 text-left font-semibold">Listing Violation Deduction (90 days)</th><td className="px-4 py-2 tabular-nums">{operations.listingViolations ?? operations.listing_violations ?? 0}</td><td className="px-4 py-2">—</td><td className="px-4 py-2 tabular-nums">−{operations.penalties?.LVD ?? '0.00'}</td></tr>
            </tbody></table></div>
        </section>}
        <section aria-labelledby="badge-metrics" className="grid gap-4 sm:grid-cols-2">
          <h2 id="badge-metrics" className="sr-only">Badge metrics</h2>
          {data.badgeMetrics.map(metric => <div key={metric.key} className="border-l-2 border-border-default pl-4"><p className="text-xs font-semibold uppercase tracking-[0.12em] text-text-secondary">{metric.key === 'CRR' ? 'Customer Response Rate' : 'Fulfillment Reliability Rate'}</p>
            <p className="text-xl font-semibold tabular-nums">{metric.value ? `${metric.value}%` : '—'}</p><p className="text-xs text-text-secondary">{metric.definition} · {metric.window} · {metric.sampleCount} counted</p></div>)}
        </section>
        <section aria-labelledby="badges" className="space-y-3">
          <h2 id="badges" className="text-lg font-semibold">Badges</h2>
          <p className="text-sm text-text-secondary">Badges are awarded and removed automatically; they cannot be requested or assigned manually.</p>
          <ul className="grid gap-3 md:grid-cols-2">{data.badges.map(badge => <li key={badge.code} className="grid gap-1 border-l-2 border-border-default pl-4">
            <span className="flex flex-wrap items-center gap-2"><span className="font-semibold">{badge.name}</span><StatusBadge label={badge.status === 'EARNED' ? 'Earned' : badge.status === 'SUPPRESSED' ? 'Suppressed by review' : 'Not earned'} tone={badge.status === 'EARNED' ? 'success' : badge.status === 'SUPPRESSED' ? 'warning' : 'neutral'} /></span>
            <span className="text-sm text-text-secondary">{badge.description}</span>
            {badge.scopes.length > 0 && <span className="text-xs text-text-secondary">{badge.scopes.map(scope => scope.scopeLabel).filter(Boolean).join(' · ')}</span>}
          </li>)}</ul>
        </section>
      </>}
  </div>
}

export function VendorReviewsPage() {
  return <TrustShell activeHref="/reviews" permission="reviews.view" deniedText="Ratings and reviews are not available to your role.">
    <ReviewsWorkspace />
  </TrustShell>
}

const TABS: { value: ReviewTab; label: string }[] = [{ value: 'VENDOR', label: 'Store ratings' }, { value: 'PRODUCT', label: 'Product reviews' }, { value: 'BUYER', label: 'Your Buyer ratings' }]
const FLAG_REASONS: { value: FlagReason; label: string }[] = [{ value: 'OFFENSIVE', label: 'Offensive language' }, { value: 'PERSONAL_INFORMATION', label: 'Personal information' }, { value: 'SPAM', label: 'Spam' },
  { value: 'IRRELEVANT', label: 'Not about this purchase' }, { value: 'CONFLICT_OF_INTEREST', label: 'Conflict of interest' }, { value: 'FALSE_CLAIM', label: 'False claim' }, { value: 'OTHER', label: 'Other' }]

function ReviewsWorkspace() {
  const [tab, setTab] = useState<ReviewTab>('VENDOR')
  const [page, setPage] = useState(1)
  const [rows, setRows] = useState<VendorReviewRow[] | null>(null)
  const [total, setTotal] = useState(0)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  const [reporting, setReporting] = useState<VendorReviewRow | null>(null)
  const [notice, setNotice] = useState<string | null>(null)
  useEffect(() => {
    let active = true
    setRows(null); setError(null)
    listReviews(tab, page).then(result => { if (active) { setRows(result.items); setTotal(Number(result.meta.total ?? 0)) } }).catch(async cause => { const text = await readableOrderError(cause); if (active) setError(text) })
    return () => { active = false }
  }, [tab, page, attempt])
  return <div className="space-y-6">
    <PageHeader eyebrow="Store operations" title="Ratings & Reviews" description="Verified-purchase ratings appear after both sides submit or 14 days after completion. You can report a review for moderation; reviews are never deleted by a store." />
    <FilterChips label="Review type" value={tab} chips={TABS} onChange={value => { setTab(value as ReviewTab); setPage(1) }} />
    {notice && <StatusMessage tone="success">{notice}</StatusMessage>}
    {error ? <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} /> : !rows ? <LoadingState label="Loading reviews…" />
      : rows.length === 0 ? <AnalyticsNullState title="No reviews yet" reason={tab === 'BUYER' ? 'Rate Buyers from a completed order\'s detail page within 14 days of completion.' : 'Published verified-purchase reviews of your store appear here.'} />
        : <ul className="divide-y divide-border-default border-y border-border-default">{rows.map(row => <li key={row.id} className="grid gap-2 py-4">
          <div className="flex flex-wrap items-center justify-between gap-2">
            <p className="font-semibold">{row.displayName} <span className="text-sm font-normal text-text-secondary">· Order <Link className="text-action-primary underline-offset-4 hover:underline" to={`/orders/${row.orderId}`}>{row.orderReference}</Link></span></p>
            {row.canReport && <Button variant="quiet" onClick={() => { setReporting(row); setNotice(null) }}><Flag size={16} aria-hidden="true" />Report</Button>}
          </div>
          <RatingLine ratings={row.ratings} />
          {row.comment && <p className="text-sm text-text-strong">{row.comment}</p>}
          <p className="text-xs text-text-secondary">{row.submittedAt ? formatManilaDateTime(row.submittedAt) : ''}{row.edited ? ' · Edited' : ''}{row.variantLabel ? ` · ${row.variantLabel}` : ''}{row.verifiedPurchase ? ' · Verified purchase' : ''}</p>
        </li>)}</ul>}
    {total > 20 && <div className="flex gap-2"><Button variant="secondary" disabled={page === 1} onClick={() => setPage(value => value - 1)}>Previous</Button><Button variant="secondary" disabled={page * 20 >= total} onClick={() => setPage(value => value + 1)}>Next</Button></div>}
    {reporting && <ReportForm review={reporting} onClose={sent => { setReporting(null); if (sent) setNotice('Report sent. Our moderation team will review it; the review stays unchanged until then.') }} />}
  </div>
}

function RatingLine({ ratings: given }: { ratings: VendorReviewRow['ratings'] }) {
  const ratings = given ?? {}
  const entries: [string, number | undefined][] = [['Service Quality', ratings.serviceQuality], [ratings.speedKind === 'DELIVERY_SPEED' ? 'Delivery Speed' : 'Processing Speed', ratings.speedRating], ['Product Quality', ratings.productQuality],
    ['Inquiry Seriousness', ratings.inquirySeriousness], ['Communication Quality', ratings.communicationQuality], ['Payment Reliability', ratings.paymentReliability]]
  return <div className="flex flex-wrap gap-x-6 gap-y-1">{entries.filter((entry): entry is [string, number] => typeof entry[1] === 'number').map(([label, value]) => <span key={label} className="inline-flex items-center gap-2 text-sm"><span className="text-text-secondary">{label}</span><StarRatingDisplay value={value} label={label} /></span>)}</div>
}

function ReportForm({ review, onClose }: { review: VendorReviewRow; onClose: (sent: boolean) => void }) {
  const [reason, setReason] = useState<FlagReason>('OFFENSIVE')
  const [details, setDetails] = useState('')
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const submit = async (event: FormEvent) => {
    event.preventDefault(); setBusy(true); setError(null)
    try { await reportReview(review.id ?? '', reason, details.trim() || null); onClose(true) } catch (cause) { setError(await readableOrderError(cause)) } finally { setBusy(false) }
  }
  return <form className="grid max-w-xl gap-3 rounded-surface border border-border-default bg-surface-primary p-5" onSubmit={submit} aria-labelledby="report-title">
    <h2 id="report-title" className="text-lg font-semibold">Report review by {review.displayName}</h2>
    <label className="grid gap-2 text-sm font-semibold">Reason<select className={control} value={reason} onChange={event => setReason(event.target.value as FlagReason)}>{FLAG_REASONS.map(item => <option key={item.value} value={item.value}>{item.label}</option>)}</select></label>
    <label className="grid gap-2 text-sm font-semibold">Details (optional)<textarea className="min-h-24 rounded-control border border-border-default p-3 text-base font-normal" maxLength={1000} value={details} onChange={event => setDetails(event.target.value)} /></label>
    {error && <StatusMessage tone="error">{error}</StatusMessage>}
    <div className="flex gap-2"><Button type="submit" disabled={busy}>{busy ? 'Sending…' : 'Send report'}</Button><Button type="button" variant="secondary" onClick={() => onClose(false)}>Cancel</Button></div>
  </form>
}

/** Order-detail panel: the store rates the Buyer (CCS) within the 14-day window and sees the Buyer's ratings after the blind reveal. */
export function OrderReviewPanel({ orderId, canRate }: { orderId: string; canRate: boolean }) {
  const [data, setData] = useState<VendorOrderReviews | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  const [values, setValues] = useState<{ inquirySeriousness: number | null; communicationQuality: number | null; paymentReliability: number | null; comment: string }>({ inquirySeriousness: null, communicationQuality: null, paymentReliability: null, comment: '' })
  const [busy, setBusy] = useState(false)
  const [formError, setFormError] = useState<string | null>(null)
  useEffect(() => {
    let active = true
    // Roles without review access simply do not see the panel; the API refuses them on every request.
    getOrderReviews(orderId).then(result => { if (active) setData(result) }).catch(async cause => { if ((cause as { response?: Response }).response?.status === 403) return; const text = await readableOrderError(cause); if (active) setError(text) })
    return () => { active = false }
  }, [orderId, attempt])
  if (error) return <StatusMessage tone="error">{error} <Button variant="quiet" onClick={() => { setError(null); setAttempt(value => value + 1) }}><RefreshCw size={14} aria-hidden="true" />Retry</Button></StatusMessage>
  if (!data || data.state === 'NOT_COMPLETED') return null
  const own = data.buyerRating
  const submit = async (event: FormEvent) => {
    event.preventDefault()
    if (!values.inquirySeriousness || !values.communicationQuality || !values.paymentReliability) { setFormError('Rate all three criteria.'); return }
    setBusy(true); setFormError(null)
    const ratings = { inquirySeriousness: values.inquirySeriousness, communicationQuality: values.communicationQuality, paymentReliability: values.paymentReliability, comment: values.comment.trim() || null }
    try { setData(own ? await editBuyerRating(own.id, own.lockVersion, ratings) : await rateBuyer(orderId, ratings)) } catch (cause) { setFormError(await readableOrderError(cause)) } finally { setBusy(false) }
  }
  return <section aria-labelledby="order-reviews" className="space-y-4 border-t border-border-default pt-6">
    <div className="flex flex-wrap items-center gap-3"><Star className="text-action-primary" size={20} aria-hidden="true" /><h2 id="order-reviews" className="text-lg font-semibold">Ratings</h2>
      <StatusBadge label={data.state === 'OPEN' ? 'Rating window open' : 'Rating window closed'} tone={data.state === 'OPEN' ? 'info' : 'neutral'} /></div>
    <p className="text-sm text-text-secondary">{data.rules.blindReveal}{data.closesAtLabel ? ` Window closes ${data.closesAtLabel}.` : ''}{data.withheldForDispute ? ' Publication is withheld while a related dispute is active.' : ''}</p>
    {own && !own.canEdit ? <div className="grid gap-1"><p className="text-sm font-semibold">Your store's rating of this Buyer</p><RatingLine ratings={own.ratings} />{own.comment && <p className="text-sm">{own.comment}</p>}</div>
      : (canRate && (data.canSubmitBuyerRating || own?.canEdit)) ? <form className="grid gap-4" onSubmit={submit} noValidate>
        <p className="text-sm font-semibold">{own ? `Correct your rating (until ${own.editableUntilLabel ?? ''})` : 'Rate this Buyer'}</p>
        <div className="grid gap-4 md:grid-cols-3">
          <StarRatingInput legend="Inquiry Seriousness" name="inquiry" value={values.inquirySeriousness ?? own?.ratings.inquirySeriousness ?? null} onChange={value => setValues(current => ({ ...current, inquirySeriousness: value }))} />
          <StarRatingInput legend="Communication Quality" name="communication" value={values.communicationQuality ?? own?.ratings.communicationQuality ?? null} onChange={value => setValues(current => ({ ...current, communicationQuality: value }))} />
          <StarRatingInput legend="Payment Reliability" name="payment" value={values.paymentReliability ?? own?.ratings.paymentReliability ?? null} onChange={value => setValues(current => ({ ...current, paymentReliability: value }))} />
        </div>
        <label className="grid gap-2 text-sm font-semibold">Comment (optional, up to 1,000 characters)<textarea className="min-h-20 rounded-control border border-border-default p-3 text-base font-normal" maxLength={1000} value={values.comment} onChange={event => setValues(current => ({ ...current, comment: event.target.value }))} /></label>
        {formError && <StatusMessage tone="error">{formError}</StatusMessage>}
        <Button className="w-fit" type="submit" disabled={busy}>{busy ? 'Saving…' : own ? 'Save correction' : 'Submit rating'}</Button>
      </form> : null}
    {data.revealed && data.received.length > 0 && <div className="grid gap-3"><p className="text-sm font-semibold">The Buyer's ratings</p>{data.received.map(review => <div key={review.id} className="grid gap-1 border-l-2 border-border-default pl-3"><RatingLine ratings={review.ratings} />{review.comment && <p className="text-sm">{review.comment}</p>}</div>)}</div>}
    {!data.revealed && <p className="inline-flex items-center gap-2 text-sm text-text-secondary"><LineChart size={14} aria-hidden="true" />The Buyer's ratings stay hidden until both sides submit or the window ends.</p>}
  </section>
}

