import { DocumentExportButton } from '@materyalph/web-ui'
import { useEffect, useState, type FormEvent } from 'react'
import { Link, useParams, useSearchParams } from 'react-router-dom'
import { ArrowLeft, ArrowRight, CheckCircle2, ClipboardCheck, Download, Flag, Inbox, Package, Search, ShieldCheck, Store, UserRound } from 'lucide-react'
import type { ReviewRatings } from '@materyalph/api-client-ts'
import {
  AnalyticsNullState, BadgeList, BadgeStatusList, Button, DateFilter, DatasetNotice, EventTimeline, FactList, FilterTabs, MaterialThumbnail, PriceTrendPanel, ReasonedDecisionForm, ReviewDetailContent, ReviewRatingSummary, ScoreSummaryGrid, SearchInput, StatusBadge, StatusMessage, TrendSummary,
  analyticsDay, dateComparisonPreset, formatAnalyticsDate, formatManilaDateTime, formatPhpDecimal, manilaToday, type PricePoint,
  type ReviewPresentationRow,
} from '@materyalph/web-ui'
import { readableApiError } from '../lib/auth-api'
import {
  correctRun, excludeSource, exportAdminAnalytics, getAdminAnalyticsDetail, getModeration, getScore, liftSuppression, listAdminAnalytics, listModeration, listRuns, listScores, listSources, moderate, revokeExclusion, suppressBadge,
  type AdminAnalyticsFilters, type AdminMaterialsAnalyticsDetail, type AdminMaterialsAnalyticsList, type AdminScoreDetail, type AdminScoreRow, type AnalyticsSource, type ModerationAction, type ModerationDetail, type ModerationQueueRow, type ModerationState,
} from '../lib/trust-api'
import { AdminShell, ErrorState, LoadingState, PageHeader } from './PhaseThreeAdminPages'
import { Pager, Panel } from '../components/OperationsKit'
import { numberValue, record, records, stringValue, statusLabel } from '../lib/admin-format'
import { useAnalyticsResource } from '../lib/use-analytics-resource'

const control = 'min-h-12 w-full min-w-0 rounded-control border border-border-default bg-surface-primary px-3 text-base font-normal'

function useLoad<T>(load: () => Promise<T>, deps: unknown[]): { data: T | null; error: string | null; retry: () => void; set: (value: T) => void } {
  const [data, setData] = useState<T | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  useEffect(() => {
    let active = true
    setData(null); setError(null)
    load().then(result => { if (active) setData(result) }).catch(async cause => { const text = await readableApiError(cause); if (active) setError(text) })
    return () => { active = false }
    // eslint-disable-next-line react-hooks/exhaustive-deps -- callers pass every dependency of load
  }, [...deps, attempt])
  return { data, error, retry: () => setAttempt(value => value + 1), set: setData }
}

function useAdminFilters(): [AdminAnalyticsFilters, (next: Partial<AdminAnalyticsFilters>) => void] {
  const [params, setParams] = useSearchParams()
  const filters: AdminAnalyticsFilters = { presetDays: [7, 30, 90].includes(Number(params.get('days'))) ? Number(params.get('days')) : 30, startDate: params.get('priceFrom'), endDate: params.get('priceTo'),
    psgcCode: params.get('psgc') ?? undefined, q: params.get('q') ?? undefined }
  return [filters, next => {
    const merged = { ...filters, ...next }
    // Other query parameters (the geographic dashboard's filters) are preserved.
    const query = new URLSearchParams(params)
    query.set('days', String(merged.presetDays ?? 30))
    if (merged.startDate && merged.endDate) { query.set('priceFrom', merged.startDate); query.set('priceTo', merged.endDate) } else { query.delete('priceFrom'); query.delete('priceTo') }
    if (merged.psgcCode) query.set('psgc', merged.psgcCode); else query.delete('psgc')
    if (merged.q) query.set('q', merged.q); else query.delete('q')
    setParams(query, { replace: true })
  }]
}

const detailQuery = (filters: AdminAnalyticsFilters) => {
  const query = new URLSearchParams({ days: String(filters.presetDays ?? 30) })
  if (filters.startDate && filters.endDate) { query.set('priceFrom', filters.startDate); query.set('priceTo', filters.endDate) }
  if (filters.psgcCode) query.set('psgc', filters.psgcCode)
  if (filters.q) query.set('q', filters.q)
  return `?${query.toString()}`
}

function MaterialsDateControl({ filters, onChange, window }: { filters: AdminAnalyticsFilters; onChange: (next: Partial<AdminAnalyticsFilters>) => void; window?: AdminMaterialsAnalyticsList['window'] | undefined }) {
  const end = analyticsDay(window?.latestAvailableDate) ?? analyticsDay(window?.endDate) ?? manilaToday()
  const range = filters.startDate && filters.endDate ? { label: 'Custom range', from: filters.startDate, to: filters.endDate } : dateComparisonPreset(filters.presetDays ?? 30, end)
  return <DateFilter title="Listed price dates" value={range} allowAllDates={false} allowOpenEnded={false} minRangeDays={2} maxRangeDays={366} maxDate={manilaToday()} presets={[7, 30, 90].map(days => dateComparisonPreset(days, end))} onChange={value => { const days = [7, 30, 90].find(days => value.label === `${days}-day comparison`); onChange(days ? { startDate: null, endDate: null, presetDays: days } : { startDate: value.from, endDate: value.to, presetDays: null }) }} />
}

function AdminFilters({ filters, onChange, areaLabel, window }: { filters: AdminAnalyticsFilters; onChange: (next: Partial<AdminAnalyticsFilters>) => void; areaLabel?: string | undefined; window?: AdminMaterialsAnalyticsList['window'] | undefined }) {
  const [q, setQ] = useState(filters.q ?? '')
  return <div className="grid gap-4 border-b border-border-default pb-5">
    <div className="flex flex-wrap items-center gap-3"><MaterialsDateControl filters={filters} onChange={onChange} window={window} /><Button variant="quiet" onClick={() => { setQ(''); onChange({ presetDays: 30, startDate: null, endDate: null, q: undefined }) }}>Reset filters</Button></div>
    <form className="grid gap-3 md:grid-cols-[minmax(0,1fr)_auto] md:items-end" onSubmit={(event: FormEvent) => { event.preventDefault(); onChange({ q: q.trim() || undefined }) }}>
      <SearchInput label="Search materials" placeholder="Search materials" value={q} onChange={setQ} />
      <Button type="submit" variant="secondary"><Search size={16} aria-hidden="true" />Apply</Button>
    </form>
    <p className="text-xs text-text-secondary">Scope: {areaLabel ?? 'Philippines'} (PSGC area; no radius applies). Payment, order-state and other transaction filters are not applicable to listed-price history.</p>
  </div>
}

/** The Materials Analytics list (MAT), embedded in the geographic dashboard; the dashboard's PSGC area is its scope. */
export function MaterialsAnalyticsSection({ psgcCode, areaLabel }: { psgcCode: string | null; areaLabel: string }) {
  const [stored, setFilters] = useAdminFilters()
  const filters: AdminAnalyticsFilters = { ...stored, psgcCode: psgcCode ?? undefined }
  const list = useAnalyticsResource(`materials-${JSON.stringify(filters)}`, () => listAdminAnalytics(filters))
  const runs = useAnalyticsResource('material-runs', listRuns)
  const [exportError, setExportError] = useState<string | null>(null)
  const download = async () => {
    setExportError(null)
    try { const blob = await exportAdminAnalytics(filters); const link = document.createElement('a'); link.href = URL.createObjectURL(blob); link.download = 'materials-analytics-aggregates.csv'; link.click(); URL.revokeObjectURL(link.href) }
    catch (cause) { setExportError(await readableApiError(cause)) }
  }
  return <section aria-labelledby="materials-analytics" className="space-y-5">
    <div className="flex flex-wrap items-end justify-between gap-3"><div><h2 id="materials-analytics" className="text-xl font-semibold">Materials Analytics</h2><p className="mt-1 max-w-3xl text-sm text-text-secondary">Equal-Vendor daily averages of public Tier 2 listed prices for {areaLabel}. Not an official price index.</p></div>
      <div className="flex flex-wrap gap-2"><DocumentExportButton basePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} audience="admin" types={['MATERIALS_ANALYTICS']} filters={{ ...(filters.startDate && filters.endDate ? { start_date: filters.startDate, end_date: filters.endDate } : { preset_days: filters.presetDays ?? 30 }), ...(filters.psgcCode ? { psgc_code: filters.psgcCode } : {}), ...(filters.q ? { q: filters.q } : {}) }} /><Button variant="secondary" onClick={() => void download()}><Download size={16} aria-hidden="true" />Export CSV</Button></div></div>
    {exportError && <StatusMessage tone="error">{exportError}</StatusMessage>}
    <AdminFilters filters={filters} onChange={next => setFilters({ ...next, psgcCode: undefined })} areaLabel={areaLabel} window={list.data?.window} />
    {list.error ? <ErrorState message={list.error} onRetry={list.retry} /> : !list.data ? <LoadingState /> : <>
      <DatasetNotice label={list.data.dataset.label ?? 'Listed-price history'} updateSchedule={list.data.updateSchedule} snapshotAt={list.data.snapshot?.observedAt ? list.data.snapshot.observedAt.toISOString() : null} currentAsOf={list.data.currentAsOf.toISOString()} explanation={list.data.explanation} />
      {list.data.items.length === 0 ? <AnalyticsNullState title="No comparable materials in this scope" reason="No published observation or current offer matches this area and period." />
        : <div className="overflow-x-auto rounded-control border border-border-default"><table className="w-full min-w-[860px] text-sm">
          <caption className="sr-only">Comparable material averages</caption>
          <thead className="bg-surface-canvas text-left text-xs uppercase tracking-[0.08em] text-text-secondary"><tr><th className="px-4 py-2" scope="col">Material / variant</th><th className="px-4 py-2" scope="col">Average (end)</th><th className="px-4 py-2" scope="col">Vendors</th><th className="px-4 py-2" scope="col">Change</th><th className="px-4 py-2" scope="col">Current offers</th><th className="px-4 py-2" scope="col"><span className="sr-only">Action</span></th></tr></thead>
          <tbody className="divide-y divide-border-default">{list.data.items.map(row => <tr key={row.groupId}>
            <td className="px-4 py-3"><div className="flex items-center gap-3"><MaterialThumbnail url={row.image?.url} categoryCode={row.category.code} size="sm" /><div><p className="font-semibold">{row.displayName}</p><p className="text-xs text-text-secondary">{row.category.name} · per {row.unit.name}</p></div></div></td>
            <td className="px-4 py-3 tabular-nums">{row.endPoint.averagePhp ? formatPhpDecimal(row.endPoint.averagePhp) : <span className="text-text-secondary">{row.endPoint.label ?? '—'}</span>}{row.endPoint.status === 'LIMITED_DATA' && <p className="text-xs text-text-secondary">Limited Local Data — 1 Vendor</p>}</td>
            <td className="px-4 py-3 tabular-nums">{row.endPoint.vendorCount ?? '—'}</td>
            <td className="px-4 py-3"><TrendSummary compact trend={row.trend} /></td>
            <td className="px-4 py-3 tabular-nums">{row.current.vendorCount} Vendors · {row.current.listingCount} listings</td>
            <td className="px-4 py-3 text-right"><Link className="inline-flex min-h-11 items-center font-semibold text-action-primary" to={`/analytics/materials/${row.groupId}${detailQuery(filters)}`} aria-label={`View details for ${row.displayName}`}>View details</Link></td>
          </tr>)}</tbody></table></div>}
    </>}
    <section aria-labelledby="runs" className="space-y-3">
      <h3 id="runs" className="text-lg font-semibold">Daily snapshot health</h3>
      {runs.error ? <ErrorState message={runs.error} onRetry={runs.retry} /> : !runs.data ? <LoadingState /> : runs.data.length === 0 ? <p className="text-sm text-text-secondary">No capture has run yet. The job runs daily at 00:10 Asia/Manila.</p>
        : <ul className="divide-y divide-border-default border-y border-border-default">{runs.data.slice(0, 10).map(run => <li key={run.id} className="flex flex-wrap items-center gap-3 py-2 text-sm">
          <span className="font-semibold">{formatAnalyticsDate(run.snapshotDate, true)}</span><StatusBadge label={`${run.state} · rev ${run.revision}`} tone={run.state === 'PUBLISHED' ? 'success' : run.state === 'FAILED' ? 'error' : 'neutral'} />
          <span className="text-text-secondary">{run.observedAt ? `Captured ${formatManilaDateTime(run.observedAt)}` : ''}{run.delayed ? ' · delayed capture' : ''} · {run.vendors} Vendors · {run.selected} selected of {run.observations}</span>{run.errorCode && <span className="text-status-error">{run.errorCode}</span>}
        </li>)}</ul>}
    </section>
  </section>
}

export function AdminMaterialPriceDetailsPage() {
  const { groupId = '' } = useParams()
  const [filters, setFilters] = useAdminFilters()
  const detail = useAnalyticsResource(`material-${groupId}-${JSON.stringify(filters)}`, () => getAdminAnalyticsDetail(groupId, filters))
  const back = new URLSearchParams({ view: 'materials', days: String(filters.presetDays ?? 30) })
  if (filters.startDate && filters.endDate) { back.set('priceFrom', filters.startDate); back.set('priceTo', filters.endDate) }
  if (filters.psgcCode) back.set('area', filters.psgcCode)
  return <AdminShell activeHref="/analytics"><div className="space-y-6">
    <Link className="inline-flex min-h-11 items-center text-sm font-semibold text-action-primary" to={`/analytics?${back.toString()}`}>← Marketplace Analytics</Link>
    {detail.error ? <ErrorState message={detail.error} onRetry={detail.retry} /> : !detail.data ? <LoadingState /> : <MaterialDetail detail={detail.data} filters={filters} onChange={setFilters} />}
  </div></AdminShell>
}

function MaterialDetail({ detail, filters, onChange }: { detail: AdminMaterialsAnalyticsDetail; filters: AdminAnalyticsFilters; onChange: (next: Partial<AdminAnalyticsFilters>) => void }) {
  const group = detail.group
  const points: PricePoint[] = detail.series.map(point => ({ date: analyticsDay(point.date) ?? '', value: point.averagePhp ?? null, status: point.status, label: point.label ?? null, count: point.vendorCount ?? null, participantsChanged: point.participantsChanged ?? null }))
  return <>
    <div className="flex items-start gap-4"><MaterialThumbnail url={group.image?.url} alt={group.image ? (group.image.altText ?? `Listing photo for ${group.displayName}`) : ''} categoryCode={group.category.code} size="lg" /><div className="min-w-0 flex-1"><PageHeader eyebrow={`${group.category.name} · ${group.material.name}`} title={group.displayName} description={`Average public listed price per ${group.unit.name}. Current: ${group.current.vendorCount} Vendors, ${group.current.listingCount} listings.`} actions={<MaterialsDateControl filters={filters} onChange={onChange} window={detail.window} />} /></div></div>
    <div className="flex flex-wrap items-center gap-6 border-b border-border-default pb-5"><TrendSummary trend={group.trend} /></div>
    <PriceTrendPanel title={`Average for ${group.displayName}`} unit={group.unit.name} points={points} emptyReason="No published observation in this scope and period." />
    {detail.canInspectSources ? <SourceInspection groupId={group.groupId} dates={points.filter(point => point.value !== null).map(point => point.date)} /> : <p className="text-sm text-text-secondary">Source inspection requires the materials_analytics.inspect_sources permission.</p>}
  </>
}

function SourceInspection({ groupId, dates }: { groupId: string; dates: string[] }) {
  const [date, setDate] = useState(dates.at(-1) ?? '')
  const [reason, setReason] = useState('')
  const [rows, setRows] = useState<AnalyticsSource[] | null>(null)
  const [runId, setRunId] = useState('')
  const [selected, setSelected] = useState<string[]>([])
  const [correction, setCorrection] = useState('')
  const [message, setMessage] = useState<{ tone: 'error' | 'success'; text: string } | null>(null)
  const inspect = async (event: FormEvent) => {
    event.preventDefault(); setMessage(null)
    if (reason.trim().length < 10) { setMessage({ tone: 'error', text: 'Record a reason of at least 10 characters; inspections are audited.' }); return }
    try { const result = await listSources(groupId, date, reason.trim()); setRows(result.items); setRunId(result.runId); setSelected([]) } catch (cause) { setMessage({ tone: 'error', text: await readableApiError(cause) }) }
  }
  const correct = async () => {
    try { await correctRun(runId, selected, correction.trim()); setMessage({ tone: 'success', text: 'A reviewed replacement revision was published. Original observations are retained.' }); setRows(null) }
    catch (cause) { setMessage({ tone: 'error', text: await readableApiError(cause) }) }
  }
  return <section aria-labelledby="sources" className="space-y-4 border-t border-border-default pt-6">
    <h2 id="sources" className="text-lg font-semibold">Inspect sources</h2>
    <form className="grid gap-3 md:grid-cols-[minmax(0,12rem)_minmax(0,1fr)_auto] md:items-end" onSubmit={inspect}>
      <label className="grid gap-2 text-sm font-semibold">Snapshot date<select className={control} value={date} onChange={event => setDate(event.target.value)}>{dates.map(value => <option key={value} value={value}>{formatAnalyticsDate(value, true)}</option>)}</select></label>
      <label className="grid gap-2 text-sm font-semibold">Reason (audited)<input className={control} value={reason} onChange={event => setReason(event.target.value)} /></label>
      <Button type="submit" variant="secondary" disabled={!date}>Inspect</Button>
    </form>
    {message && <StatusMessage tone={message.tone}>{message.text}</StatusMessage>}
    {rows && (rows.length === 0 ? <p className="text-sm text-text-secondary">No observations for this date.</p> : <>
      <div className="overflow-x-auto rounded-control border border-border-default"><table className="w-full min-w-[820px] text-sm"><caption className="sr-only">Source observations</caption>
        <thead className="bg-surface-canvas text-left text-xs uppercase tracking-[0.08em] text-text-secondary"><tr><th className="px-3 py-2" scope="col">Exclude</th><th className="px-3 py-2" scope="col">Store / listing</th><th className="px-3 py-2" scope="col">Price version</th><th className="px-3 py-2" scope="col">Per unit</th><th className="px-3 py-2" scope="col">Captured</th><th className="px-3 py-2" scope="col">Selection</th></tr></thead>
        <tbody className="divide-y divide-border-default">{rows.map(row => <tr key={row.observationId}>
          <td className="px-3 py-2"><input type="checkbox" className="h-5 w-5" aria-label={`Exclude ${row.storeName} ${row.displayName}`} checked={selected.includes(row.observationId)} onChange={event => setSelected(current => event.target.checked ? [...current, row.observationId] : current.filter(id => id !== row.observationId))} /></td>
          <td className="px-3 py-2"><p className="font-semibold">{row.storeName}</p><p className="text-xs text-text-secondary">{row.displayName}{row.variantLabel ? ` · ${row.variantLabel}` : ''}</p></td>
          <td className="px-3 py-2 tabular-nums">v{row.priceVersion} · {formatPhpDecimal(String(row.ordinaryPayableCentavos / 100))}</td>
          <td className="px-3 py-2 tabular-nums">{row.normalizedPhpExact}</td><td className="px-3 py-2">{formatManilaDateTime(row.capturedAt)}</td>
          <td className="px-3 py-2">{row.selectedForAverage ? 'Selected' : (row.exclusionReason ?? 'Excluded')}</td>
        </tr>)}</tbody></table></div>
      {selected.length > 0 && <div className="grid max-w-xl gap-3"><label className="grid gap-2 text-sm font-semibold">Correction reason<textarea className="min-h-20 rounded-control border border-border-default p-3 text-base font-normal" value={correction} onChange={event => setCorrection(event.target.value)} /></label>
        <Button className="w-fit" disabled={correction.trim().length < 10} onClick={() => void correct()}>Publish corrected revision ({selected.length} excluded)</Button></div>}
    </>)}
  </section>
}

const SCORE_NAMES = { vps: 'Vendor Performance Score', vcs: 'Vendor Community Score', mqs: 'Material Quality Score', ohs: 'Operational Health Score' }
const scorePage = (value: string | null) => Math.min(500, Math.max(1, Number.isInteger(Number(value)) ? Number(value) : 1))

export function AdminScoresPage() {
  const [params, setParams] = useSearchParams()
  const applied = params.get('q') ?? ''
  const page = scorePage(params.get('page'))
  const [q, setQ] = useState(applied)
  useEffect(() => { setQ(applied) }, [applied])
  const list = useLoad<{ items: AdminScoreRow[]; total: number; perPage?: number }>(() => listScores(applied, page), [applied, page])
  const update = (query: string, nextPage = 1) => { const next = new URLSearchParams(); if (query) next.set('q', query); if (nextPage > 1) next.set('page', String(nextPage)); setParams(next) }
  const query = params.toString() ? `?${params.toString()}` : ''
  return <AdminShell activeHref="/scores"><div className="space-y-6">
    <PageHeader eyebrow="Compliance & quality" title="Score & Badge Monitoring" description="Monitor Vendor performance, automatic badges, and the source records behind every published score." />
    <div className="flex items-start gap-3 text-sm text-text-secondary"><ShieldCheck size={20} className="shrink-0 text-action-primary" aria-hidden="true" /><p>Scores and badges are calculated automatically. Authorized Admins can investigate sources and record documented exclusions or badge suppressions.</p></div>
    <section aria-labelledby="score-directory" className="min-w-0 overflow-hidden rounded-surface border border-border-default bg-surface-primary">
      <div className="grid gap-4 border-b border-border-default p-4 sm:p-5 lg:grid-cols-[1fr_minmax(320px,540px)] lg:items-center">
        <div><div className="flex flex-wrap items-center gap-2"><h2 id="score-directory" className="text-lg font-semibold">Vendor performance</h2>{list.data && <StatusBadge label={`${list.data.total} ${list.data.total === 1 ? 'store' : 'stores'}`} />}</div><p className="mt-1 text-sm text-text-secondary">{applied ? `Search results for “${applied}”` : 'Active stores, ordered by store name.'}</p></div>
        <form className="flex min-w-0 flex-wrap gap-2" role="search" onSubmit={event => { event.preventDefault(); update(q.trim()) }}><SearchInput id="score-search" label="Search stores" placeholder="Search by store name" maxLength={120} value={q} onChange={setQ} className="w-full basis-full sm:w-auto sm:basis-0 sm:flex-1" /><Button type="submit" variant="secondary">Search</Button>{applied && <Button variant="quiet" onClick={() => { setQ(''); update('') }}>Reset search</Button>}</form>
      </div>
      {list.error ? <div className="p-5"><ErrorState message={list.error} onRetry={list.retry} /></div> : !list.data ? <div className="p-5"><LoadingState /></div> : list.data.items.length === 0 ? <div className="grid justify-items-center gap-3 px-5 py-14 text-center"><Store size={28} aria-hidden="true" className="text-text-secondary" /><h3 className="text-lg font-semibold">{applied ? 'No matching stores' : page > 1 ? 'No stores on this page' : 'No active stores yet'}</h3><p className="max-w-md text-sm text-text-secondary">{applied ? 'Try another store name or clear your search to see all active stores.' : 'Active Vendor stores will appear here with their latest published performance.'}</p>{(applied || page > 1) && <Button variant="secondary" onClick={() => { setQ(''); update('') }}>View all stores</Button>}</div>
        : <>
          <div aria-hidden="true" className="hidden grid-cols-[minmax(0,2fr)_minmax(200px,1.4fr)_minmax(100px,.7fr)_minmax(140px,1fr)_112px] gap-5 border-b border-border-default bg-surface-canvas px-5 py-3 text-xs font-semibold uppercase tracking-wide text-text-secondary xl:grid"><span>Store & public standing</span><span>Published scores</span><span>Response & reliability</span><span>Badges & investigations</span><span className="text-right">Details</span></div>
          <ul className="divide-y divide-border-default">{list.data.items.map(row => <li key={row.vendorId} className="grid min-w-0 gap-5 p-4 transition-colors hover:bg-surface-canvas motion-reduce:transition-none sm:p-5 md:grid-cols-2 xl:grid-cols-[minmax(0,2fr)_minmax(200px,1.4fr)_minmax(100px,.7fr)_minmax(140px,1fr)_112px] xl:items-center">
            <div className="min-w-0"><Link className="inline-flex min-h-11 items-center break-words font-semibold text-text-strong underline-offset-4 hover:text-action-primary hover:underline" to={`/scores/${row.vendorId}${query}`}>{row.storeName}</Link><p className="mt-1 text-xs leading-5 text-text-secondary">{row.scores.label}</p></div>
            <dl className="grid grid-cols-4 gap-3">{(['vps', 'vcs', 'mqs', 'ohs'] as const).map(key => <div key={key}><dt className="text-xs font-semibold text-text-secondary"><abbr title={SCORE_NAMES[key]} className="no-underline">{key.toUpperCase()}</abbr></dt><dd className="mt-1 text-sm font-semibold tabular-nums">{row.scores[key] ?? <span className="font-normal text-text-secondary" aria-label="Not published">—</span>}</dd></div>)}</dl>
            <dl className="grid grid-cols-2 gap-3 xl:grid-cols-1 xl:gap-1">{(['crr', 'frr'] as const).map(key => <div key={key} className="flex flex-wrap items-center gap-x-2"><dt className="text-xs text-text-secondary"><abbr className="no-underline" title={key === 'crr' ? 'Customer Response Rate' : 'Fulfillment Reliability Rate'}>{key.toUpperCase()}</abbr></dt><dd className="text-sm tabular-nums">{row[key] != null ? `${row[key]}%` : '—'}</dd></div>)}</dl>
            <div className="space-y-2"><BadgeList badges={row.scores.badges} empty="No earned badges" /><div className="flex flex-wrap gap-1">{row.activeSuppressions > 0 && <StatusBadge label={`${row.activeSuppressions} suppressed`} tone="warning" />}{row.activeExclusions > 0 && <StatusBadge label={`${row.activeExclusions} excluded`} tone="info" />}</div></div>
            <Link className="inline-flex min-h-11 items-center gap-2 text-sm font-semibold text-action-primary underline-offset-4 hover:underline xl:justify-end whitespace-nowrap" to={`/scores/${row.vendorId}${query}`} aria-label={`View performance for ${row.storeName}`}>View details<ArrowRight size={16} aria-hidden="true" /></Link>
          </li>)}</ul>
        </>}
      {list.data && list.data.total > 0 && <div className="border-t border-border-default px-5 py-4"><p className="text-xs text-text-secondary">Scores use a 1–5 scale. A dash means the metric is not published or has no eligible data.</p>{list.data.total > (list.data.perPage ?? 20) && <Pager page={page} lastPage={Math.ceil(list.data.total / (list.data.perPage ?? 20))} total={list.data.total} onChange={next => update(applied, next)} />}</div>}
    </section>
  </div></AdminShell>
}

type ScoreNotice = { tone: 'error' | 'success'; text: string }
export function AdminScoreDetailPage() {
  const { vendorId = '' } = useParams()
  const [params, setParams] = useSearchParams()
  const eventPage = scorePage(params.get('eventsPage'))
  const detail = useLoad<AdminScoreDetail>(() => getScore(vendorId, eventPage), [vendorId, eventPage])
  const [notice, setNotice] = useState<ScoreNotice | null>(null)
  const [revision, setRevision] = useState(0)
  useEffect(() => { setNotice(null) }, [vendorId])
  const back = new URLSearchParams(params); back.delete('eventsPage')
  return <AdminShell activeHref="/scores"><div className="space-y-6">
    <Link className="inline-flex min-h-11 items-center gap-2 text-sm font-semibold text-action-primary" to={`/scores${back.size ? `?${back}` : ''}`}><ArrowLeft size={16} aria-hidden="true" />Score & Badge Monitoring</Link>
    {notice && <StatusMessage tone={notice.tone}>{notice.text}</StatusMessage>}
    {detail.error ? <ErrorState message={detail.error} onRetry={detail.retry} /> : !detail.data ? <LoadingState /> : <ScoreDetail key={`${vendorId}-${revision}`} data={detail.data} onChanged={message => { setRevision(value => value + 1); setNotice({ tone: 'success', text: message }); detail.retry() }} eventPage={eventPage} onEventPage={page => { const next = new URLSearchParams(params); if (page > 1) next.set('eventsPage', String(page)); else next.delete('eventsPage'); setParams(next, { preventScrollReset: true }) }} />}
  </div></AdminShell>
}

function ScoreDetail({ data, onChanged, eventPage, onEventPage }: { data: AdminScoreDetail; onChanged: (message: string) => void; eventPage: number; onEventPage: (page: number) => void }) {
  const events = records(record(data.sourceEvents).items)
  const meta = record(record(data.sourceEvents).meta)
  const total = numberValue(meta.total, events.length)
  const perPage = Math.max(1, numberValue(meta.per_page, 20))
  const exclusions = records(data.exclusions), suppressions = records(data.suppressions)
  return <>
    <PageHeader eyebrow="Score & Badge Monitoring" title={data.storeName ?? 'Vendor'} description="Published performance, badge eligibility, and audited source investigations." actions={<StatusBadge label={data.canInvestigate ? 'Investigation access' : 'Read-only access'} tone="info" />} />
    <section aria-label="Public standing" className="flex flex-wrap items-center justify-between gap-4 border-l-4 border-action-primary bg-surface-primary px-5 py-4"><div><p className="text-xs font-semibold uppercase tracking-wide text-text-secondary">Public standing</p><p className="mt-1 text-lg font-semibold">{data.label || 'No public standing available'}</p></div><div className="text-sm"><p className="text-xs text-text-secondary">Latest score snapshot</p><p className="mt-1 font-semibold">{data.asOf ? formatAnalyticsDate(data.asOf, true) : 'Awaiting first calculation'}</p></div></section>
    <section aria-labelledby="published-scores" className="space-y-4"><div><h2 id="published-scores" className="text-lg font-semibold">Published scores</h2><p className="mt-1 text-sm text-text-secondary">Daily performance snapshots. Operational health is recalculated weekly; publication depends on eligible samples.</p></div>{data.scores?.length ? <ScoreSummaryGrid scores={data.scores} /> : <AnalyticsNullState title="No score snapshot available" reason="Scores will appear after a calculation has been completed." />}</section>
    <div className="grid items-start gap-6 2xl:grid-cols-[minmax(0,2fr)_minmax(300px,1fr)]">
      <Panel id="badge-states" title="Automatic badges" description="Eligibility comes from the published criteria below. Awards and removals are automatic."><BadgeStatusList badges={data.badges ?? []} /></Panel>
      <Panel id="badge-metrics" title="Response & reliability" description="Supporting metrics used to determine badge eligibility.">
        {!data.badgeMetrics?.length ? <p className="text-sm text-text-secondary">No supporting metrics available yet.</p> : <dl className="grid gap-5 sm:grid-cols-2 2xl:grid-cols-1">{data.badgeMetrics.map(metric => <div key={metric.key} className="space-y-2"><dt className="text-sm font-semibold">{metric.key === 'CRR' ? 'Customer Response Rate' : 'Fulfillment Reliability Rate'} <span className="text-text-secondary">({metric.key})</span></dt><dd className="text-3xl font-semibold tabular-nums">{metric.value != null ? `${metric.value}%` : <span className="text-lg text-text-secondary">No eligible data</span>}</dd><dd className="text-xs text-text-secondary">{metric.window} · {metric.sampleCount} eligible samples</dd><dd className="text-xs leading-5 text-text-secondary">{metric.definition}</dd></div>)}</dl>}
      </Panel>
    </div>
    <Panel id="score-sources" title="Source events" description="System-recorded events behind the scores. Exclusion removes an order’s sources from later calculations; the original events remain available.">
      {events.length === 0 ? <div className="flex items-start gap-3 py-5"><Inbox size={24} aria-hidden="true" className="shrink-0 text-text-secondary" /><div><p className="font-semibold">No source events {eventPage > 1 ? 'on this page' : 'yet'}</p><p className="mt-1 text-sm text-text-secondary">Order and response activity will appear here when recorded.</p>{eventPage > 1 && <Button variant="quiet" onClick={() => onEventPage(1)}>Return to first page</Button>}</div></div> : <div className="overflow-x-auto" role="region" aria-label="Scrollable source events" tabIndex={0}><table className="w-full min-w-[660px] text-left text-sm"><caption className="sr-only">Score source events</caption><thead className="border-b border-border-default text-xs uppercase tracking-wide text-text-secondary"><tr>{['Metric / source', 'Value', 'Order', 'Recorded', 'Status'].map(label => <th key={label} scope="col" className="px-3 py-3">{label}</th>)}</tr></thead><tbody className="divide-y divide-border-default">{events.map(event => <tr key={stringValue(event.id)}><th scope="row" className="px-3 py-4 font-normal"><p className="font-semibold">{stringValue(event.metric)}</p><p className="mt-1 text-xs text-text-secondary">{statusLabel(stringValue(event.source_kind))}</p></th><td className="px-3 py-4 tabular-nums">{stringValue(event.value, '—')}</td><td className="px-3 py-4"><p>{stringValue(event.order_reference, 'No linked order')}</p>{typeof event.order_id === 'string' && <p className="mt-1 text-xs text-text-secondary">ID: {event.order_id}</p>}</td><td className="px-3 py-4 text-xs text-text-secondary">{formatManilaDateTime(stringValue(event.occurred_at))}</td><td className="px-3 py-4"><StatusBadge label={event.excluded ? 'Excluded' : 'Recorded'} tone={event.excluded ? 'warning' : 'neutral'} /></td></tr>)}</tbody></table></div>}
      {total > perPage && <Pager page={eventPage} lastPage={Math.ceil(total / perPage)} total={total} onChange={onEventPage} />}
    </Panel>
    {data.canInvestigate ? <section aria-labelledby="score-investigation" className="space-y-4"><div><h2 id="score-investigation" className="text-lg font-semibold">Investigation actions</h2><p className="mt-1 text-sm text-text-secondary">Document the finding and review its effect before submitting. Each action is recorded in the audit history.</p></div><ScoreInvestigation data={data} onChanged={onChanged} /></section> : <p className="flex items-start gap-2 text-sm text-text-secondary"><ShieldCheck size={18} className="shrink-0" aria-hidden="true" />You have read-only access. Source exclusions and badge suppressions require investigation permission.</p>}
    <div className="grid items-start gap-6 lg:grid-cols-2"><Panel id="score-exclusions" title="Source exclusions" description="Recorded exclusions and reversals for this Vendor."><ScoreAdjustments rows={exclusions} kind="exclusion" canInvestigate={Boolean(data.canInvestigate)} onChanged={onChanged} /></Panel><Panel id="score-suppressions" title="Badge suppressions" description="Documented cases affecting public badge display."><ScoreAdjustments rows={suppressions} kind="suppression" canInvestigate={Boolean(data.canInvestigate)} onChanged={onChanged} /></Panel></div>
    <Panel id="badge-history" title="Badge history" description="Recent automatic awards and removals, with up to 100 records retained in this view.">{!data.badgeHistory?.length ? <p className="py-3 text-sm text-text-secondary">No badges have been awarded yet.</p> : <ul className="divide-y divide-border-default">{records(data.badgeHistory).map(row => <li key={stringValue(row.id)} className="space-y-2 py-4 text-sm"><div className="flex flex-wrap items-center gap-2"><span className="font-semibold">{stringValue(row.name)}</span><StatusBadge label={row.revoked_at ? 'Removed automatically' : 'Awarded automatically'} tone={row.revoked_at ? 'neutral' : 'success'} /></div><p className="text-xs text-text-secondary">Awarded {formatManilaDateTime(stringValue(row.earned_at))}{row.scope_label ? ` · ${stringValue(row.scope_label)}` : ''}</p>{Boolean(row.revoked_at) && <p className="text-xs text-text-secondary">Removed {formatManilaDateTime(stringValue(row.revoked_at))} · {statusLabel(stringValue(row.revocation_reason))}</p>}</li>)}</ul>}</Panel>
  </>
}

function ScoreInvestigation({ data, onChanged }: { data: AdminScoreDetail; onChanged: (message: string) => void }) {
  const [mode, setMode] = useState('exclude')
  const [orderId, setOrderId] = useState('')
  const [reasonCode, setReasonCode] = useState<'FRAUD' | 'DUPLICATE' | 'TEST' | 'INVALID_SOURCE'>('FRAUD')
  const [badgeCode, setBadgeCode] = useState(data.badges?.find(badge => badge.status !== 'SUPPRESSED')?.code ?? '')
  const [suppressionReason, setSuppressionReason] = useState<'FRAUD' | 'COMPLIANCE'>('FRAUD')
  const [caseReference, setCaseReference] = useState('')
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const submit = async (note: string) => {
    if (busy || !data.canInvestigate || !data.vendorId) return
    if (mode === 'exclude' && !/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(orderId.trim())) { setError('Enter a valid Order ID. Use the ID shown with a source event, not the order reference.'); return }
    if (mode === 'suppress' && (!badgeCode || caseReference.trim().length < 3)) { setError('Choose a badge and enter a case reference of at least 3 characters.'); return }
    setBusy(true); setError(null)
    try {
      if (mode === 'exclude') await excludeSource(data.vendorId, orderId.trim(), reasonCode, note)
      else await suppressBadge(data.vendorId, badgeCode, suppressionReason, caseReference.trim(), note)
      onChanged(mode === 'exclude' ? 'Source exclusion recorded. This order is excluded from later score calculations.' : 'Badge suppression recorded. The badge is hidden from public display.')
    } catch (cause) { setError(await readableApiError(cause)); setBusy(false) }
  }
  return <div className="grid items-start gap-4 lg:grid-cols-[minmax(220px,1fr)_minmax(0,2fr)]"><div className="space-y-4"><FilterTabs label="Investigation type" value={mode} onChange={value => { if (!busy) { setMode(value); setError(null) } }} disabled={busy} chips={[{ value: 'exclude', label: 'Exclude order' }, { value: 'suppress', label: 'Suppress badge' }]} /><p className="text-sm leading-6 text-text-secondary">{mode === 'exclude' ? 'Use a confirmed fraud, duplicate, test, or invalid-source finding. All reviews and metric events for the selected order are excluded from later snapshots. Existing snapshots are preserved.' : 'Suppress badge display for a documented fraud or compliance case. Eligibility and automatic award rules remain in effect. A suppression can later be lifted with a recorded reason.'}</p></div>
    <ReasonedDecisionForm key={mode} title={mode === 'exclude' ? 'Exclude a score source order' : 'Suppress a badge'} target={data.storeName ?? 'Vendor'} submitLabel={mode === 'exclude' ? 'Record exclusion' : 'Record suppression'} maxReason={2000} busy={busy} error={error} onSubmit={note => void submit(note)} submitDisabled={mode === 'suppress' && !badgeCode}>
      <fieldset disabled={busy} className="grid min-w-0 gap-4">
        {mode === 'exclude' ? <><label className="grid gap-2 text-sm font-semibold">Order ID<input className={control} value={orderId} onChange={event => setOrderId(event.target.value)} aria-describedby="exclusion-order-hint" required /></label><p id="exclusion-order-hint" className="-mt-2 text-xs text-text-secondary">Use the full ID shown in Source events for an order belonging to this Vendor.</p><label className="grid gap-2 text-sm font-semibold">Finding category<select className={control} value={reasonCode} onChange={event => setReasonCode(event.target.value as typeof reasonCode)}>{['FRAUD', 'DUPLICATE', 'TEST', 'INVALID_SOURCE'].map(code => <option key={code} value={code}>{statusLabel(code)}</option>)}</select></label></>
          : <><label className="grid gap-2 text-sm font-semibold">Badge<select className={control} value={badgeCode} onChange={event => setBadgeCode(event.target.value as typeof badgeCode)} required>{!badgeCode && <option value="">No badges available to suppress</option>}{(data.badges ?? []).filter(badge => badge.status !== 'SUPPRESSED').map(badge => <option key={badge.code} value={badge.code}>{badge.name}</option>)}</select></label><div className="grid gap-4 sm:grid-cols-2"><label className="grid gap-2 text-sm font-semibold">Finding category<select className={control} value={suppressionReason} onChange={event => setSuppressionReason(event.target.value as typeof suppressionReason)}><option value="FRAUD">Fraud</option><option value="COMPLIANCE">Compliance</option></select></label><label className="grid gap-2 text-sm font-semibold">Case reference<input className={control} value={caseReference} maxLength={120} onChange={event => setCaseReference(event.target.value)} required /></label></div></>}
      </fieldset>
    </ReasonedDecisionForm>
  </div>
}

function ScoreAdjustments({ rows, kind, canInvestigate, onChanged }: { rows: Record<string, unknown>[]; kind: 'exclusion' | 'suppression'; canInvestigate: boolean; onChanged: (message: string) => void }) {
  const [selected, setSelected] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const exclusion = kind === 'exclusion'
  const reverse = async (id: string, reason: string) => {
    if (busy || !canInvestigate) return
    setBusy(true); setError(null)
    try { if (exclusion) await revokeExclusion(id, reason); else await liftSuppression(id, reason); onChanged(exclusion ? 'Exclusion reversed. The order can contribute to later calculations if eligible.' : 'Suppression lifted. Public badge display follows automatic eligibility.'); }
    catch (cause) { setError(await readableApiError(cause)); setBusy(false) }
  }
  if (!rows.length) return <div className="flex items-start gap-3 py-3"><CheckCircle2 size={20} aria-hidden="true" className="shrink-0 text-text-secondary" /><div><p className="text-sm font-semibold">{exclusion ? 'No source exclusions' : 'No badge suppressions'}</p><p className="mt-1 text-xs leading-5 text-text-secondary">{exclusion ? 'No orders have been excluded through investigation.' : 'No badge display restrictions have been recorded.'}</p></div></div>
  return <ul className="divide-y divide-border-default">{rows.map(row => {
    const id = stringValue(row.id), reversedAt = row[exclusion ? 'revoked_at' : 'lifted_at']
    const name = stringValue(row[exclusion ? 'order_reference' : 'badge_name'], 'Record unavailable')
    return <li key={id} className="space-y-3 py-4"><div className="flex flex-wrap items-center justify-between gap-2"><p className="break-words text-sm font-semibold">{name}</p><StatusBadge label={reversedAt ? (exclusion ? 'Reversed' : 'Lifted') : (exclusion ? 'Excluded' : 'Suppressed')} tone={reversedAt ? 'neutral' : 'warning'} /></div><p className="text-xs text-text-secondary">{statusLabel(stringValue(row.reason_code))}{row.case_reference ? ` · ${stringValue(row.case_reference)}` : ''}</p><p className="whitespace-pre-wrap break-words text-sm">{stringValue(row.note)}</p><p className="text-xs text-text-secondary">{statusLabel(stringValue(row.created_role))} · {formatManilaDateTime(stringValue(row.created_at))}</p>
      {reversedAt ? <div className="border-l-2 border-border-default pl-3 text-xs text-text-secondary"><p>{exclusion ? 'Reversed' : 'Lifted'} {formatManilaDateTime(stringValue(reversedAt))}</p><p className="mt-1 whitespace-pre-wrap break-words">{stringValue(row[exclusion ? 'revoke_reason' : 'lift_reason'])}</p></div> : canInvestigate && (selected === id ? <div className="space-y-2"><ReasonedDecisionForm title={exclusion ? 'Reverse exclusion' : 'Lift suppression'} target={name} submitLabel={exclusion ? 'Confirm reversal' : 'Confirm lift'} maxReason={2000} busy={busy} error={error} onSubmit={reason => void reverse(id, reason)} /><Button variant="quiet" disabled={busy} onClick={() => { setSelected(null); setError(null) }}>Cancel</Button></div> : <Button variant="secondary" disabled={busy} onClick={() => { setSelected(id); setError(null) }}>{exclusion ? 'Reverse exclusion' : 'Lift suppression'}</Button>)}
    </li>
  })}</ul>
}

const QUEUE_STATES: { value: ModerationState; label: string }[] = [{ value: 'NEEDS_ACTION', label: 'Needs action' }, { value: 'CORRECTION_REQUESTED', label: 'Correction requested' }, { value: 'REMOVED', label: 'Removed' }, { value: 'ALL', label: 'All reviews' }]
const QUEUE_COPY: Record<string, { description: string; empty: string; hint: string }> = {
  NEEDS_ACTION: { description: 'Reported reviews and reviews hidden pending a decision. Most recently updated first.', empty: 'No reviews need action', hint: 'There are no reported reviews or reviews pending a decision in this queue.' },
  CORRECTION_REQUESTED: { description: 'Reviews hidden after an author correction was requested. Most recently updated first.', empty: 'No corrections requested', hint: 'Reviews appear here when an Admin requests a correction from the author.' },
  REMOVED: { description: 'Reviews removed from public view, with their original content retained. Most recently updated first.', empty: 'No removed reviews', hint: 'Reviews removed through moderation appear here with their decision history.' },
  ALL: { description: 'All verified-purchase reviews, including reviews with no moderation action. Most recently updated first.', empty: 'No reviews yet', hint: 'Verified-purchase feedback will appear here after it is submitted.' },
}
const ACTION_LABELS: Record<string, string> = { FLAG_RAISED: 'Report submitted', DISMISS_FLAG: 'Dismiss flag', REQUEST_CORRECTION: 'Request correction (7 days)', HIDE_PENDING_REVIEW: 'Hide pending review', REMOVE: 'Remove', RESTORE: 'Restore' }
const ACTION_EFFECTS: Record<ModerationAction, string> = {
  DISMISS_FLAG: 'Dismiss open reports and clear the moderation flag. Dispute and reveal restrictions still apply.',
  HIDE_PENDING_REVIEW: 'Hide this review from public view while it is under review.',
  REQUEST_CORRECTION: 'Hide this review and allow the author one correction within 7 days. A correction returns it to the queue and stays hidden until restored.',
  REMOVE: 'Permanently remove this review from public view for a documented guideline violation. This decision is final; the original content remains in the audit history.',
  RESTORE: 'Clear the moderation restriction. The review becomes public only when any dispute and reveal restrictions are also cleared.',
}
const MODERATION_STATUSES: Record<string, { label: string; tone: 'neutral' | 'warning' | 'error' | 'info' }> = {
  NONE: { label: 'No moderation action', tone: 'neutral' }, FLAGGED: { label: 'Reported', tone: 'warning' },
  HIDDEN_PENDING_REVIEW: { label: 'Hidden pending review', tone: 'warning' }, CORRECTION_REQUESTED: { label: 'Correction requested', tone: 'info' }, REMOVED: { label: 'Removed', tone: 'error' },
}
const VISIBILITY_LABELS: Record<string, string> = { PUBLIC: 'Public', HIDDEN_UNTIL_REVEAL: 'Hidden until reveal', WITHHELD_ACTIVE_DISPUTE: 'Withheld during an active dispute', HIDDEN_BY_MODERATION: 'Hidden by moderation', REMOVED: 'Removed from public view', EXCLUDED_BY_INVESTIGATION: 'Excluded by investigation' }
const MODERATION_ACTORS: Record<string, string> = { ADMIN_SUPERADMIN: 'Super Admin', ADMIN_USER_MANAGEMENT: 'User Management Staff' }
const reviewTypeLabel = (type: string | undefined) => type === 'PRODUCT' ? 'Product review' : type === 'VENDOR' ? 'Store rating' : type === 'BUYER' ? 'Buyer rating' : 'Review'
const reviewTypeIcon = (type: string | undefined) => type === 'PRODUCT' ? Package : type === 'VENDOR' ? Store : UserRound

function ModerationStatus({ state }: { state: string | undefined }) {
  const status = MODERATION_STATUSES[state ?? ''] ?? { label: 'Status unavailable', tone: 'neutral' as const }
  return <StatusBadge {...status} />
}

function moderationDate(value: unknown): Date | undefined {
  const date = value instanceof Date ? value : typeof value === 'string' && value ? new Date(value) : undefined
  return date && Number.isFinite(date.getTime()) ? date : undefined
}

function ModerationTime({ value }: { value: unknown }) {
  const date = moderationDate(value)
  return date ? <time dateTime={date.toISOString()}>{formatManilaDateTime(date)}</time> : <>Time unavailable</>
}

/** Revision snapshots keep their original snake_case keys, unlike generated review ratings. */
function revisionRatings(content: Record<string, unknown>): ReviewRatings {
  const result: ReviewRatings = {}
  const fields = { rating: 'productQuality', service_quality: 'serviceQuality', speed_rating: 'speedRating', inquiry_seriousness: 'inquirySeriousness', communication_quality: 'communicationQuality', payment_reliability: 'paymentReliability' } as const
  for (const [source, target] of Object.entries(fields)) {
    const value = content[source]
    if (typeof value === 'number') result[target] = value
  }
  if (content.speed_kind === 'DELIVERY_SPEED' || content.speed_kind === 'PROCESSING_SPEED') result.speedKind = content.speed_kind
  return result
}

export function AdminReviewModerationPage() {
  const [params, setParams] = useSearchParams()
  const state = QUEUE_STATES.find(item => item.value === params.get('state'))?.value ?? 'NEEDS_ACTION'
  const requestedPage = Number(params.get('page'))
  const page = Number.isSafeInteger(requestedPage) && requestedPage >= 1 && requestedPage <= 500 ? requestedPage : 1
  const from = analyticsDay(params.get('from')) ?? '', to = analyticsDay(params.get('to')) ?? ''
  const range = { label: from || to ? 'Custom range' : 'All dates', from, to }
  const change = (patch: Record<string, string>) => setParams(current => {
    const next = new URLSearchParams(current)
    for (const [key, value] of Object.entries(patch)) { if (value) next.set(key, value); else next.delete(key) }
    return next
  })
  const resetDates = () => change({ from: '', to: '', page: '' })
  const copy = QUEUE_COPY[state] ?? QUEUE_COPY.NEEDS_ACTION!
  const label = QUEUE_STATES.find(item => item.value === state)?.label
  const context = params.size ? `?${params.toString()}` : ''
  const queue = useLoad<{ items: ModerationQueueRow[]; total: number; perPage?: number }>(() => listModeration(state, page, range), [state, page, range.from, range.to])
  return <AdminShell activeHref="/reviews"><div className="mx-auto max-w-[1440px] space-y-6">
    <PageHeader eyebrow="Compliance & quality" title="Review Moderation" description="Review reported feedback, inspect supporting evidence, and record a reasoned decision." />
    <FilterTabs appearance="tabs" label="Moderation queue" value={state} chips={QUEUE_STATES} onChange={value => change({ state: value, page: '' })} />
    <section className="min-w-0 overflow-hidden rounded-surface border border-border-default bg-surface-primary" aria-labelledby="moderation-queue-title">
      <div className="flex flex-wrap items-start justify-between gap-4 border-b border-border-default p-5 sm:px-6">
        <div className="min-w-0 max-w-2xl"><div className="flex flex-wrap items-center gap-3"><h2 id="moderation-queue-title" className="text-lg font-semibold">{label}</h2>{queue.data && <StatusBadge label={`${queue.data.total.toLocaleString()} ${queue.data.total === 1 ? 'review' : 'reviews'}`} />}</div><p className="mt-2 text-sm leading-6 text-text-secondary">{copy.description}</p></div>
        <div className="flex max-w-full flex-wrap items-center gap-2"><DateFilter title="Review submission dates" value={range} onChange={value => change({ from: value.from, to: value.to, page: '' })} />{(from || to) && <Button variant="quiet" onClick={resetDates}>Reset dates</Button>}</div>
      </div>
      {queue.error ? <div className="p-6"><ErrorState message={queue.error} onRetry={queue.retry} /></div> : !queue.data ? <div className="p-6"><LoadingState /></div> : queue.data.items.length === 0 ? <div role="status" className="flex min-h-72 flex-col items-center justify-center gap-4 px-6 py-12 text-center">
        <span className="grid h-14 w-14 place-items-center rounded-full border border-border-default bg-surface-canvas text-text-secondary">{state === 'NEEDS_ACTION' && !from && !to ? <CheckCircle2 size={26} aria-hidden="true" /> : <Inbox size={26} aria-hidden="true" />}</span>
        <div className="max-w-md"><h3 className="text-base font-semibold">{from || to ? 'No reviews in this date range' : page > 1 ? 'No reviews on this page' : copy.empty}</h3><p className="mt-2 text-sm leading-6 text-text-secondary">{from || to ? 'Try another submission date range or reset dates to see the full queue.' : page > 1 ? 'The queue may have changed. Return to the first page to see the latest reviews.' : copy.hint}</p></div>
        {from || to ? <Button variant="secondary" onClick={resetDates}>View all dates</Button> : page > 1 ? <Button variant="secondary" onClick={() => change({ page: '' })}>Return to first page</Button> : state !== 'ALL' && <Button variant="secondary" onClick={() => change({ state: 'ALL', page: '' })}>Browse all reviews<ArrowRight size={16} aria-hidden="true" /></Button>}
      </div> : <ul aria-label="Reviews in this queue" className="divide-y divide-border-default">{queue.data.items.map(row => {
        const Icon = reviewTypeIcon(row.type)
        return <li key={row.id} className="grid min-w-0 gap-4 p-5 sm:px-6 lg:grid-cols-[minmax(0,1fr)_minmax(11rem,14rem)] lg:gap-6">
          <div className="flex min-w-0 items-start gap-3"><span className="grid h-11 w-11 shrink-0 place-items-center rounded-control border border-border-default bg-surface-canvas text-text-secondary"><Icon size={21} aria-hidden="true" /></span>
            <div className="min-w-0 space-y-2"><p className="text-xs font-medium text-text-secondary">{reviewTypeLabel(row.type)}</p><Link className="inline-flex min-h-11 max-w-full items-center break-words text-base font-semibold text-text-strong underline-offset-4 hover:text-action-primary hover:underline" to={`/reviews/${row.id}${context}`}>{row.storeName}</Link><p className="break-words text-sm text-text-secondary">{row.type === 'BUYER' ? 'Submitted by' : 'Buyer'}: {row.displayName} · Order {row.orderReference}</p><ReviewRatingSummary ratings={row.ratings} />{row.comment && <p className="line-clamp-2 whitespace-pre-wrap break-words text-sm leading-6">{row.comment}</p>}<p className="text-xs leading-5 text-text-secondary">Submitted <ModerationTime value={row.submittedAt} /></p></div>
          </div>
          <div className="flex min-w-0 flex-wrap items-center justify-between gap-3 lg:flex-col lg:items-end lg:justify-start"><ModerationStatus state={row.moderationState} />{row.openFlags > 0 ? <span className="inline-flex items-center gap-1.5 text-xs font-medium"><Flag size={14} aria-hidden="true" />{row.openFlags} open {row.openFlags === 1 ? 'report' : 'reports'}</span> : <span className="text-xs text-text-secondary">No open reports</span>}<Link to={`/reviews/${row.id}${context}`} aria-label={`View ${reviewTypeLabel(row.type).toLowerCase()} by ${row.displayName} for ${row.orderReference}`} className="inline-flex min-h-11 items-center gap-2 rounded-control px-3 text-sm font-semibold text-action-primary hover:bg-surface-canvas">View review<ArrowRight size={16} aria-hidden="true" /></Link></div>
        </li>
      })}</ul>}
      {queue.data && queue.data.total > (queue.data.perPage ?? 20) && <div className="px-5 py-4 sm:px-6"><Pager page={page} lastPage={Math.max(1, Math.ceil(queue.data.total / (queue.data.perPage ?? 20)))} total={queue.data.total} onChange={value => change({ page: String(value) })} /></div>}
    </section>
    <p className="flex items-start gap-2 text-xs leading-5 text-text-secondary"><ShieldCheck size={16} className="mt-0.5 shrink-0" aria-hidden="true" />Every decision requires a reason. Original content and decision history are preserved; Vendors cannot remove reviews.</p>
  </div></AdminShell>
}

export function AdminReviewModerationDetailPage() {
  const { reviewId = '' } = useParams()
  const [params] = useSearchParams()
  return <ModerationDetailPage key={reviewId} reviewId={reviewId} back={`/reviews${params.size ? `?${params.toString()}` : ''}`} />
}

function ModerationDetailPage({ reviewId, back }: { reviewId: string; back: string }) {
  const detail = useLoad<ModerationDetail>(() => getModeration(reviewId), [reviewId])
  const [action, setAction] = useState<ModerationAction | ''>('')
  const [busy, setBusy] = useState(false)
  const [refreshing, setRefreshing] = useState(false)
  const [message, setMessage] = useState<{ tone: 'error' | 'success'; text: string } | null>(null)
  const submit = async (reason: string) => {
    if (busy || refreshing || !detail.data) return
    if (!action) { setMessage({ tone: 'error', text: 'Choose a moderation decision.' }); return }
    setMessage(null); setBusy(true)
    try { detail.set(await moderate(reviewId, action, reason, Number(detail.data.lockVersion ?? 1))); setAction(''); setMessage({ tone: 'success', text: 'Decision recorded. The original review and decision history are preserved.' }) } catch (cause) { setMessage({ tone: 'error', text: await readableApiError(cause) }) }
    finally { setBusy(false) }
  }
  const refresh = async () => {
    if (busy || refreshing) return
    setRefreshing(true)
    try { detail.set(await getModeration(reviewId)); setAction(''); setMessage(null) } catch (cause) { setMessage({ tone: 'error', text: await readableApiError(cause) }) }
    finally { setRefreshing(false) }
  }
  const data = detail.data
  const purchase = record(data?.verifiedPurchase), dispute = record(data?.relatedDispute)
  const storeName = stringValue(purchase.store_name ?? purchase.storeName, 'Store unavailable')
  const orderReference = stringValue(purchase.order_reference ?? purchase.orderReference, 'Reference unavailable')
  const flags = records(data?.flags), history = records(data?.history), revisions = records(data?.revisions)
  const submittedAt = moderationDate(revisions[0]?.created_at ?? revisions[0]?.createdAt)
  const type = data?.type === 'PRODUCT' || data?.type === 'VENDOR' || data?.type === 'BUYER' ? data.type : undefined
  const review: ReviewPresentationRow = { ...(type ? { type } : {}), ...(data?.ratings ? { ratings: data.ratings } : {}), ...(data?.comment ? { comment: data.comment } : {}), displayName: data?.displayName || 'Author unavailable', verifiedPurchase: true, ...(submittedAt ? { submittedAt } : {}), edited: revisions.length > 1, media: data?.media ?? [] }
  return <AdminShell activeHref="/reviews"><div className="mx-auto max-w-[1440px] space-y-6">
    <Link className="inline-flex min-h-11 items-center gap-2 rounded-control text-sm font-semibold text-action-primary underline-offset-4 hover:underline" to={back}><ArrowLeft size={17} aria-hidden="true" />Review Moderation</Link>
    {detail.error ? <ErrorState message={detail.error} onRetry={detail.retry} /> : !data ? <LoadingState /> : <>
      <PageHeader eyebrow="Review Moderation" title={reviewTypeLabel(data.type)} description={`${data.displayName || 'Author unavailable'} · ${storeName}`} actions={<ModerationStatus state={data.moderationState} />} />
      {message && <StatusMessage tone={message.tone}>{message.text}</StatusMessage>}
      <div className="grid min-w-0 items-start gap-6 xl:grid-cols-[minmax(0,1fr)_minmax(20rem,24rem)]">
        <div className="min-w-0 space-y-6">
          <ReviewDetailContent review={review} apiBasePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} onRefreshMedia={() => void refresh()} refreshingMedia={refreshing || busy} />
          <Panel id="review-reports" title="Reports" description="Reasons submitted for moderation, including resolved reports.">
            {flags.length === 0 ? <p className="text-sm leading-6 text-text-secondary">No reports have been submitted for this review.</p> : <ul className="divide-y divide-border-default">{flags.map((flag, index) => <li key={stringValue(flag.id, String(index))} className="space-y-2 py-4 first:pt-0 last:pb-0">
              <div className="flex flex-wrap items-start justify-between gap-2"><h3 className="inline-flex items-center gap-2 text-sm font-semibold"><Flag size={16} aria-hidden="true" />{statusLabel(stringValue(flag.reason_code ?? flag.reasonCode, 'Reason unavailable'))}</h3><StatusBadge label={statusLabel(stringValue(flag.state, 'Unknown'))} tone={flag.state === 'OPEN' ? 'warning' : 'neutral'} /></div>
              <p className="text-xs leading-5 text-text-secondary">Reported by {statusLabel(stringValue(flag.reporter_party ?? flag.reporterParty, 'Unknown'))} · <ModerationTime value={flag.created_at ?? flag.createdAt} /></p>{stringValue(flag.details) && <p className="whitespace-pre-wrap break-words text-sm leading-6">{stringValue(flag.details)}</p>}
            </li>)}</ul>}
          </Panel>
        </div>
        <div className="min-w-0 space-y-6 xl:row-span-2">
          <Panel id="review-context" title="Review context" actions={<ShieldCheck size={20} className="text-text-secondary" aria-hidden="true" />}>
            <FactList columns={1} facts={[{ label: 'Verified purchase', value: orderReference }, { label: 'Store', value: storeName }, { label: 'Public visibility', value: VISIBILITY_LABELS[data.visibility ?? ''] ?? 'Visibility unavailable' }, { label: 'Author display rule', value: data.authorDisplayRule ?? 'Not recorded' }, { label: 'Related dispute', value: dispute.reference ? <span>{stringValue(dispute.reference)}{dispute.status ? <span className="mt-1 block text-xs text-text-secondary">{statusLabel(stringValue(dispute.status))}</span> : null}</span> : 'No related dispute' }]} />
          </Panel>
          {(data.availableActions ?? []).length > 0 ? <ReasonedDecisionForm key={data.lockVersion ?? 1} title="Record a decision" target={`${reviewTypeLabel(data.type)} · ${orderReference}`} version={data.lockVersion ?? null} submitLabel="Record decision" variant={action === 'REMOVE' ? 'danger' : 'primary'} maxReason={2000} busy={busy || refreshing} submitDisabled={!action} onSubmit={reason => void submit(reason)}>
            <p className="text-sm leading-6 text-text-secondary">Choose the action supported by the evidence. The reason is required and kept in the audit history.</p>
            <label className="grid gap-2 text-sm font-semibold">Decision<select className={control} value={action} disabled={busy || refreshing} onChange={event => { setAction(event.target.value as ModerationAction); setMessage(null) }}><option value="">Choose a decision</option>{(data.availableActions ?? []).map(value => <option key={value} value={value}>{ACTION_LABELS[value] ?? value}</option>)}</select></label>
            {action && <p role="status" className="border-l-2 border-action-primary pl-3 text-sm leading-6">{ACTION_EFFECTS[action]}</p>}
          </ReasonedDecisionForm> : <Panel id="review-decision-status" title="Decision status" actions={<ClipboardCheck size={20} aria-hidden="true" />}><p className="text-sm leading-6 text-text-secondary">{data.moderationState === 'REMOVED' ? 'This review has been removed. The decision is final; its original content and history remain available for audit.' : 'No moderation actions are available for this review.'}</p></Panel>}
          <Button variant="secondary" disabled={busy || refreshing} onClick={() => void refresh()} className="w-full">{refreshing ? 'Refreshing…' : 'Refresh review'}</Button>
        </div>
        <div className="min-w-0 space-y-6 xl:col-start-1">
          <Panel id="review-history" title="Moderation history" description="Recorded reports and Admin decisions, in chronological order.">
            <EventTimeline label="Moderation history" events={history.filter(entry => moderationDate(entry.at)).map((entry, index) => ({ id: String(index), title: ACTION_LABELS[stringValue(entry.action)] ?? statusLabel(stringValue(entry.action)), at: moderationDate(entry.at)!, actor: MODERATION_ACTORS[stringValue(entry.actor_role ?? entry.actorRole)] ?? statusLabel(stringValue(entry.actor_role ?? entry.actorRole)), detail: <div className="space-y-1">{entry.from_state && entry.to_state ? <p className="text-xs text-text-secondary">{MODERATION_STATUSES[stringValue(entry.from_state)]?.label ?? statusLabel(stringValue(entry.from_state))} → {MODERATION_STATUSES[stringValue(entry.to_state)]?.label ?? statusLabel(stringValue(entry.to_state))}</p> : null}{stringValue(entry.reason) && <p className="whitespace-pre-wrap leading-6">{entry.action === 'FLAG_RAISED' ? statusLabel(stringValue(entry.reason)) : stringValue(entry.reason)}</p>}</div> }))} formatDate={formatManilaDateTime} empty="No moderation decisions have been recorded." />
          </Panel>
          <Panel id="review-revisions" title="Revisions (original preserved)" description="Read-only snapshots retain the original rating and comment alongside later corrections.">
            {revisions.length === 0 ? <p className="text-sm text-text-secondary">No revision snapshots are available.</p> : <ol className="divide-y divide-border-default">{revisions.map((revision, index) => {
              const content = record(revision.content)
              return <li key={String(revision.revision ?? index)} className="space-y-3 py-4 first:pt-0 last:pb-0"><div className="flex flex-wrap items-start justify-between gap-2"><h3 className="text-sm font-semibold">Revision {numberValue(revision.revision, index + 1)} · {stringValue(revision.reason, 'Recorded').replaceAll('_', ' ').toLowerCase()}</h3>{index === 0 && <StatusBadge label="Original submission" />}</div><p className="text-xs text-text-secondary"><ModerationTime value={revision.created_at ?? revision.createdAt} /></p><ReviewRatingSummary ratings={revisionRatings(content)} /><p className="whitespace-pre-wrap break-words text-sm leading-6 text-text-secondary">{stringValue(content.comment).trim() || 'No written comment was included.'}</p></li>
            })}</ol>}
          </Panel>
        </div>
      </div>
    </>}
  </div></AdminShell>
}
