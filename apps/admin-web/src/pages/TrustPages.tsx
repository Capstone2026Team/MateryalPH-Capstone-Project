import { useEffect, useState, type FormEvent } from 'react'
import { Link, useParams, useSearchParams } from 'react-router-dom'
import { Download, Search } from 'lucide-react'
import {
  AnalyticsNullState, BadgeList, Button, DatasetNotice, FilterChips, PriceTrendPanel, ScoreTile, StarRatingDisplay, StatusBadge, StatusMessage, TrendSummary,
  analyticsDay, formatAnalyticsDate, formatManilaDateTime, formatPhpDecimal, type PricePoint,
} from '@materyalph/web-ui'
import { readableApiError } from '../lib/auth-api'
import {
  correctRun, excludeSource, exportAdminAnalytics, getAdminAnalyticsDetail, getModeration, getScore, liftSuppression, listAdminAnalytics, listModeration, listRuns, listScores, listSources, moderate, revokeExclusion, suppressBadge,
  type AdminAnalyticsFilters, type AdminMaterialsAnalyticsDetail, type AdminMaterialsAnalyticsList, type AdminScoreDetail, type AdminScoreRow, type AnalyticsRun, type AnalyticsSource, type ModerationAction, type ModerationDetail, type ModerationQueueRow, type ModerationState,
} from '../lib/trust-api'
import { AdminShell, ErrorState, LoadingState, PageHeader } from './PhaseThreeAdminPages'

const control = 'min-h-12 w-full min-w-0 rounded-control border border-border-default bg-surface-primary px-3 text-base font-normal'
const PRESETS = [{ value: '7', label: '7 days' }, { value: '30', label: '30 days' }, { value: '90', label: '90 days' }]

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
  const filters: AdminAnalyticsFilters = { presetDays: [7, 30, 90].includes(Number(params.get('days'))) ? Number(params.get('days')) : 30, startDate: null, endDate: null,
    psgcCode: params.get('psgc') ?? undefined, q: params.get('q') ?? undefined }
  return [filters, next => {
    const merged = { ...filters, ...next }
    const query = new URLSearchParams({ days: String(merged.presetDays ?? 30) })
    if (merged.psgcCode) query.set('psgc', merged.psgcCode)
    if (merged.q) query.set('q', merged.q)
    setParams(query, { replace: true })
  }]
}

function AdminFilters({ filters, onChange }: { filters: AdminAnalyticsFilters; onChange: (next: Partial<AdminAnalyticsFilters>) => void }) {
  const [psgc, setPsgc] = useState(filters.psgcCode ?? '')
  const [q, setQ] = useState(filters.q ?? '')
  return <div className="grid gap-4 border-b border-border-default pb-5">
    <FilterChips label="Comparison period" value={String(filters.presetDays ?? 30)} chips={PRESETS} onChange={value => onChange({ presetDays: Number(value) })} />
    <form className="grid gap-3 md:grid-cols-[minmax(0,14rem)_minmax(0,1fr)_auto] md:items-end" onSubmit={(event: FormEvent) => { event.preventDefault(); onChange({ psgcCode: psgc.trim() || undefined, q: q.trim() || undefined }) }}>
      <label className="grid gap-2 text-sm font-semibold">PSGC area code<input className={control} value={psgc} onChange={event => setPsgc(event.target.value)} placeholder="Blank = Philippines" inputMode="numeric" /></label>
      <label className="grid gap-2 text-sm font-semibold">Search materials<input className={control} value={q} onChange={event => setQ(event.target.value)} /></label>
      <Button type="submit" variant="secondary"><Search size={16} aria-hidden="true" />Apply</Button>
    </form>
    <p className="text-xs text-text-secondary">Payment, order-state and transaction filters do not apply to listed-price history.</p>
  </div>
}

export function AdminMaterialsAnalyticsPage() {
  const [filters, setFilters] = useAdminFilters()
  const list = useLoad<AdminMaterialsAnalyticsList>(() => listAdminAnalytics(filters), [JSON.stringify(filters)])
  const runs = useLoad<AnalyticsRun[]>(() => listRuns(), [])
  const [exportError, setExportError] = useState<string | null>(null)
  const download = async () => {
    setExportError(null)
    try { const blob = await exportAdminAnalytics(filters); const link = document.createElement('a'); link.href = URL.createObjectURL(blob); link.download = 'materials-analytics-aggregates.csv'; link.click(); URL.revokeObjectURL(link.href) }
    catch (cause) { setExportError(await readableApiError(cause)) }
  }
  return <AdminShell activeHref="/analytics/materials"><div className="space-y-6">
    <PageHeader eyebrow="Marketplace Analytics" title="Materials Analytics" description="Equal-Vendor daily averages of public Tier 2 listed prices by PSGC area, including Philippines-wide scope. Not an official price index."
      actions={<Button variant="secondary" onClick={() => void download()}><Download size={16} aria-hidden="true" />Export CSV</Button>} />
    {exportError && <StatusMessage tone="error">{exportError}</StatusMessage>}
    <AdminFilters filters={filters} onChange={setFilters} />
    {list.error ? <ErrorState message={list.error} onRetry={list.retry} /> : !list.data ? <LoadingState /> : <>
      <DatasetNotice label={list.data.dataset.label ?? 'Listed-price history'} updateSchedule={list.data.updateSchedule} snapshotAt={list.data.snapshot?.observedAt ? list.data.snapshot.observedAt.toISOString() : null} currentAsOf={list.data.currentAsOf.toISOString()} explanation={list.data.explanation} />
      {list.data.items.length === 0 ? <AnalyticsNullState title="No comparable materials in this scope" reason="No published observation or current offer matches this area and period." />
        : <div className="overflow-x-auto rounded-control border border-border-default"><table className="w-full min-w-[860px] text-sm">
          <caption className="sr-only">Comparable material averages</caption>
          <thead className="bg-surface-canvas text-left text-xs uppercase tracking-[0.08em] text-text-secondary"><tr><th className="px-4 py-2" scope="col">Material / variant</th><th className="px-4 py-2" scope="col">Average (end)</th><th className="px-4 py-2" scope="col">Vendors</th><th className="px-4 py-2" scope="col">Change</th><th className="px-4 py-2" scope="col">Current offers</th><th className="px-4 py-2" scope="col"><span className="sr-only">Action</span></th></tr></thead>
          <tbody className="divide-y divide-border-default">{list.data.items.map(row => <tr key={row.groupId}>
            <td className="px-4 py-3"><p className="font-semibold">{row.displayName}</p><p className="text-xs text-text-secondary">{row.category.name} · per {row.unit.name}</p></td>
            <td className="px-4 py-3 tabular-nums">{row.endPoint.averagePhp ? formatPhpDecimal(row.endPoint.averagePhp) : <span className="text-text-secondary">{row.endPoint.label ?? '—'}</span>}{row.endPoint.status === 'LIMITED_DATA' && <p className="text-xs text-text-secondary">Limited Local Data — 1 Vendor</p>}</td>
            <td className="px-4 py-3 tabular-nums">{row.endPoint.vendorCount ?? '—'}</td>
            <td className="px-4 py-3"><TrendSummary compact trend={row.trend} /></td>
            <td className="px-4 py-3 tabular-nums">{row.current.vendorCount} Vendors · {row.current.listingCount} listings</td>
            <td className="px-4 py-3 text-right"><Link className="inline-flex min-h-11 items-center font-semibold text-action-primary" to={`/analytics/materials/${row.groupId}${window.location.search}`} aria-label={`View details for ${row.displayName}`}>View details</Link></td>
          </tr>)}</tbody></table></div>}
    </>}
    <section aria-labelledby="runs" className="space-y-3">
      <h2 id="runs" className="text-lg font-semibold">Daily snapshot health</h2>
      {runs.error ? <ErrorState message={runs.error} onRetry={runs.retry} /> : !runs.data ? <LoadingState /> : runs.data.length === 0 ? <p className="text-sm text-text-secondary">No capture has run yet. The job runs daily at 00:10 Asia/Manila.</p>
        : <ul className="divide-y divide-border-default border-y border-border-default">{runs.data.slice(0, 10).map(run => <li key={run.id} className="flex flex-wrap items-center gap-3 py-2 text-sm">
          <span className="font-semibold">{formatAnalyticsDate(run.snapshotDate, true)}</span><StatusBadge label={`${run.state} · rev ${run.revision}`} tone={run.state === 'PUBLISHED' ? 'success' : run.state === 'FAILED' ? 'error' : 'neutral'} />
          <span className="text-text-secondary">{run.observedAt ? `Captured ${formatManilaDateTime(run.observedAt)}` : ''}{run.delayed ? ' · delayed capture' : ''} · {run.vendors} Vendors · {run.selected} selected of {run.observations}</span>{run.errorCode && <span className="text-status-error">{run.errorCode}</span>}
        </li>)}</ul>}
    </section>
  </div></AdminShell>
}

export function AdminMaterialPriceDetailsPage() {
  const { groupId = '' } = useParams()
  const [filters] = useAdminFilters()
  const detail = useLoad<AdminMaterialsAnalyticsDetail>(() => getAdminAnalyticsDetail(groupId, filters), [groupId, JSON.stringify(filters)])
  return <AdminShell activeHref="/analytics/materials"><div className="space-y-6">
    <Link className="inline-flex min-h-11 items-center text-sm font-semibold text-action-primary" to={`/analytics/materials${window.location.search}`}>← Materials Analytics</Link>
    {detail.error ? <ErrorState message={detail.error} onRetry={detail.retry} /> : !detail.data ? <LoadingState /> : <MaterialDetail detail={detail.data} />}
  </div></AdminShell>
}

function MaterialDetail({ detail }: { detail: AdminMaterialsAnalyticsDetail }) {
  const group = detail.group
  const points: PricePoint[] = detail.series.map(point => ({ date: analyticsDay(point.date) ?? '', value: point.averagePhp ?? null, status: point.status, label: point.label ?? null, count: point.vendorCount ?? null, participantsChanged: point.participantsChanged ?? null }))
  return <>
    <PageHeader eyebrow={`${group.category.name} · ${group.material.name}`} title={group.displayName} description={`Average public listed price per ${group.unit.name}. Current: ${group.current.vendorCount} Vendors, ${group.current.listingCount} listings.`} />
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

export function AdminScoresPage() {
  const [q, setQ] = useState('')
  const [applied, setApplied] = useState('')
  const list = useLoad<{ items: AdminScoreRow[]; total: number }>(() => listScores(applied), [applied])
  return <AdminShell activeHref="/scores"><div className="space-y-6">
    <PageHeader eyebrow="Compliance & quality" title="Score & Badge Monitoring" description="Published Vendor scores, sample sizes and automatic badges. Admins can investigate sources and suppress a badge for a documented case, but never assign a score or award a badge." />
    <form className="flex max-w-xl gap-2" role="search" onSubmit={event => { event.preventDefault(); setApplied(q.trim()) }}><label className="sr-only" htmlFor="score-search">Search stores</label><input id="score-search" className={control} value={q} onChange={event => setQ(event.target.value)} placeholder="Store name" /><Button type="submit" variant="secondary">Search</Button></form>
    {list.error ? <ErrorState message={list.error} onRetry={list.retry} /> : !list.data ? <LoadingState /> : list.data.items.length === 0 ? <AnalyticsNullState title="No active stores" reason="No active store matches this search." />
      : <div className="overflow-x-auto rounded-control border border-border-default"><table className="w-full min-w-[820px] text-sm"><caption className="sr-only">Vendor scores</caption>
        <thead className="bg-surface-canvas text-left text-xs uppercase tracking-[0.08em] text-text-secondary"><tr><th className="px-4 py-2" scope="col">Store</th><th className="px-4 py-2" scope="col">Public label</th><th className="px-4 py-2" scope="col">VCS / MQS / OHS</th><th className="px-4 py-2" scope="col">CRR / FRR</th><th className="px-4 py-2" scope="col">Badges</th><th className="px-4 py-2" scope="col">Reviews</th></tr></thead>
        <tbody className="divide-y divide-border-default">{list.data.items.map(row => <tr key={row.vendorId}>
          <td className="px-4 py-3"><Link className="font-semibold text-action-primary underline-offset-4 hover:underline" to={`/scores/${row.vendorId}`}>{row.storeName}</Link></td>
          <td className="px-4 py-3">{row.scores.label}</td><td className="px-4 py-3 tabular-nums">{row.scores.vcs ?? '—'} / {row.scores.mqs ?? '—'} / {row.scores.ohs ?? '—'}</td><td className="px-4 py-3 tabular-nums">{row.crr ? `${row.crr}%` : '—'} / {row.frr ? `${row.frr}%` : '—'}</td>
          <td className="px-4 py-3"><BadgeList badges={row.scores.badges} empty="None" /></td>
          <td className="px-4 py-3">{row.activeSuppressions > 0 && <StatusBadge label={`${row.activeSuppressions} suppressed`} tone="warning" />} {row.activeExclusions > 0 && <StatusBadge label={`${row.activeExclusions} excluded`} tone="info" />}</td>
        </tr>)}</tbody></table></div>}
  </div></AdminShell>
}

export function AdminScoreDetailPage() {
  const { vendorId = '' } = useParams()
  const detail = useLoad<AdminScoreDetail>(() => getScore(vendorId), [vendorId])
  return <AdminShell activeHref="/scores"><div className="space-y-6">
    <Link className="inline-flex min-h-11 items-center text-sm font-semibold text-action-primary" to="/scores">← Score & Badge Monitoring</Link>
    {detail.error ? <ErrorState message={detail.error} onRetry={detail.retry} /> : !detail.data ? <LoadingState /> : <ScoreDetail data={detail.data} onChanged={detail.retry} />}
  </div></AdminShell>
}

function ScoreDetail({ data, onChanged }: { data: AdminScoreDetail; onChanged: () => void }) {
  const [message, setMessage] = useState<{ tone: 'error' | 'success'; text: string } | null>(null)
  const [exclusion, setExclusion] = useState({ orderId: '', reasonCode: 'FRAUD' as 'FRAUD' | 'DUPLICATE' | 'TEST' | 'INVALID_SOURCE', note: '' })
  const [suppression, setSuppression] = useState({ badgeCode: 'FAST_RESPONDER', reasonCode: 'FRAUD' as 'FRAUD' | 'COMPLIANCE', caseReference: '', note: '' })
  const act = async (action: () => Promise<unknown>, success: string) => { setMessage(null); try { await action(); setMessage({ tone: 'success', text: success }); onChanged() } catch (cause) { setMessage({ tone: 'error', text: await readableApiError(cause) }) } }
  const events = (data.sourceEvents as { items?: Record<string, unknown>[] } | undefined)?.items ?? []
  return <>
    <PageHeader eyebrow="Score & Badge Monitoring" title={data.storeName ?? 'Vendor'} description={`${data.label ?? ''} · As of ${formatAnalyticsDate(data.asOf ?? null, true)}`} />
    {message && <StatusMessage tone={message.tone}>{message.text}</StatusMessage>}
    <section className="grid gap-6 border-b border-border-default pb-6 sm:grid-cols-2 xl:grid-cols-4" aria-label="Scores">{(data.scores ?? []).map(score => <ScoreTile key={score.key} name={score.key} value={score.value ?? null} published={score.published} sample={score.sampleCount} minimum={score.minimumSample} window={score.window} status={score.statusText} />)}</section>
    <section aria-labelledby="badge-states" className="space-y-2"><h2 id="badge-states" className="text-lg font-semibold">Badges</h2>
      <ul className="grid gap-2 md:grid-cols-2">{(data.badges ?? []).map(badge => <li key={badge.code} className="flex flex-wrap items-center gap-2 border-l-2 border-border-default pl-3"><span className="font-semibold">{badge.name}</span><StatusBadge label={badge.status === 'EARNED' ? 'Earned' : badge.status === 'SUPPRESSED' ? 'Suppressed' : 'Not earned'} tone={badge.status === 'EARNED' ? 'success' : badge.status === 'SUPPRESSED' ? 'warning' : 'neutral'} /></li>)}</ul>
      {(data.suppressions as Record<string, string | null>[] | undefined ?? []).filter(row => !row.lifted_at && !row.liftedAt).map(row => <p key={String(row.id)} className="flex flex-wrap items-center gap-2 text-sm">{String(row.badge_name ?? row.badgeName)} suppressed · {String(row.case_reference ?? row.caseReference)}
        {data.canInvestigate && <ReasonAction label="Lift" prompt="Reason for lifting this suppression" onConfirm={reason => act(() => liftSuppression(String(row.id), reason), 'Suppression lifted.')} />}</p>)}
    </section>
    {data.canInvestigate && <section aria-labelledby="investigate" className="grid gap-6 border-t border-border-default pt-6 lg:grid-cols-2"><h2 id="investigate" className="sr-only">Investigation</h2>
      <form className="grid gap-3" onSubmit={event => { event.preventDefault(); void act(() => excludeSource(data.vendorId ?? '', exclusion.orderId.trim(), exclusion.reasonCode, exclusion.note.trim()), 'The order is excluded from later snapshots.') }}>
        <h3 className="font-semibold">Exclude a score source order</h3>
        <label className="grid gap-2 text-sm font-semibold">Order ID<input className={control} value={exclusion.orderId} onChange={event => setExclusion({ ...exclusion, orderId: event.target.value })} /></label>
        <label className="grid gap-2 text-sm font-semibold">Reason<select className={control} value={exclusion.reasonCode} onChange={event => setExclusion({ ...exclusion, reasonCode: event.target.value as typeof exclusion.reasonCode })}>{['FRAUD', 'DUPLICATE', 'TEST', 'INVALID_SOURCE'].map(code => <option key={code} value={code}>{code.replaceAll('_', ' ').toLowerCase()}</option>)}</select></label>
        <label className="grid gap-2 text-sm font-semibold">Finding (audited)<textarea className="min-h-20 rounded-control border border-border-default p-3 text-base font-normal" value={exclusion.note} onChange={event => setExclusion({ ...exclusion, note: event.target.value })} /></label>
        <Button type="submit" variant="secondary" className="w-fit">Exclude order</Button>
      </form>
      <form className="grid gap-3" onSubmit={event => { event.preventDefault(); void act(() => suppressBadge(data.vendorId ?? '', suppression.badgeCode, suppression.reasonCode, suppression.caseReference.trim(), suppression.note.trim()), 'Badge display suppressed.') }}>
        <h3 className="font-semibold">Suppress a badge (documented fraud or compliance case)</h3>
        <label className="grid gap-2 text-sm font-semibold">Badge<select className={control} value={suppression.badgeCode} onChange={event => setSuppression({ ...suppression, badgeCode: event.target.value })}>{(data.badges ?? []).map(badge => <option key={badge.code} value={badge.code}>{badge.name}</option>)}</select></label>
        <label className="grid gap-2 text-sm font-semibold">Reason<select className={control} value={suppression.reasonCode} onChange={event => setSuppression({ ...suppression, reasonCode: event.target.value as 'FRAUD' | 'COMPLIANCE' })}><option value="FRAUD">Fraud</option><option value="COMPLIANCE">Compliance</option></select></label>
        <label className="grid gap-2 text-sm font-semibold">Case reference<input className={control} value={suppression.caseReference} onChange={event => setSuppression({ ...suppression, caseReference: event.target.value })} /></label>
        <label className="grid gap-2 text-sm font-semibold">Finding (audited)<textarea className="min-h-20 rounded-control border border-border-default p-3 text-base font-normal" value={suppression.note} onChange={event => setSuppression({ ...suppression, note: event.target.value })} /></label>
        <Button type="submit" variant="secondary" className="w-fit">Suppress badge</Button>
      </form>
    </section>}
    <section aria-labelledby="exclusions" className="space-y-2"><h2 id="exclusions" className="text-lg font-semibold">Exclusions</h2>
      {(data.exclusions as Record<string, string | null>[] | undefined ?? []).length === 0 ? <p className="text-sm text-text-secondary">No exclusions.</p> : <ul className="divide-y divide-border-default border-y border-border-default">{(data.exclusions as Record<string, string | null>[]).map(row => <li key={String(row.id)} className="flex flex-wrap items-center gap-2 py-2 text-sm">
        <span className="font-semibold">{String(row.order_reference ?? row.orderReference)}</span><span>{String(row.reason_code ?? row.reasonCode)}</span><span className="text-text-secondary">{String(row.note)}</span>{(row.revoked_at ?? row.revokedAt) ? <StatusBadge label="Reversed" /> : data.canInvestigate && <ReasonAction label="Reverse" prompt="Reason for restoring this order to scores" onConfirm={reason => act(() => revokeExclusion(String(row.id), reason), 'Exclusion reversed.')} />}
      </li>)}</ul>}
    </section>
    <section aria-labelledby="events" className="space-y-2"><h2 id="events" className="text-lg font-semibold">Recent source events</h2>
      {events.length === 0 ? <p className="text-sm text-text-secondary">No events yet.</p> : <div className="overflow-x-auto rounded-control border border-border-default"><table className="w-full min-w-[640px] text-sm"><caption className="sr-only">Source events</caption>
        <thead className="bg-surface-canvas text-left text-xs uppercase tracking-[0.08em] text-text-secondary"><tr><th className="px-3 py-2" scope="col">Metric</th><th className="px-3 py-2" scope="col">Value</th><th className="px-3 py-2" scope="col">Order</th><th className="px-3 py-2" scope="col">When</th></tr></thead>
        <tbody className="divide-y divide-border-default">{events.map(event => <tr key={String(event.id)}><td className="px-3 py-2">{String(event.metric)}</td><td className="px-3 py-2">{String(event.value)}</td><td className="px-3 py-2">{String(event.order_reference ?? event.orderReference ?? '—')}{event.excluded ? ' (excluded)' : ''}</td><td className="px-3 py-2">{formatManilaDateTime(String(event.occurred_at ?? event.occurredAt))}</td></tr>)}</tbody></table></div>}
    </section>
  </>
}

/** An inline, labelled reason field for an audited reversal (at least 10 characters). */
function ReasonAction({ label, prompt, onConfirm }: { label: string; prompt: string; onConfirm: (reason: string) => Promise<void> }) {
  const [open, setOpen] = useState(false)
  const [reason, setReason] = useState('')
  if (!open) return <Button variant="quiet" onClick={() => setOpen(true)}>{label}</Button>
  return <span className="inline-flex flex-wrap items-end gap-2"><label className="grid gap-1 text-xs font-semibold">{prompt}<input className="min-h-11 rounded-control border border-border-default px-2 text-sm font-normal" value={reason} onChange={event => setReason(event.target.value)} /></label>
    <Button variant="secondary" disabled={reason.trim().length < 10} onClick={() => void onConfirm(reason.trim()).then(() => setOpen(false))}>Confirm</Button><Button variant="quiet" onClick={() => setOpen(false)}>Cancel</Button></span>
}

const QUEUE_STATES: { value: ModerationState; label: string }[] = [{ value: 'NEEDS_ACTION', label: 'Needs action' }, { value: 'CORRECTION_REQUESTED', label: 'Correction requested' }, { value: 'REMOVED', label: 'Removed' }, { value: 'ALL', label: 'All' }]
const ACTION_LABELS: Record<string, string> = { DISMISS_FLAG: 'Dismiss flag', REQUEST_CORRECTION: 'Request correction (7 days)', HIDE_PENDING_REVIEW: 'Hide pending review', REMOVE: 'Remove', RESTORE: 'Restore' }

export function AdminReviewModerationPage() {
  const [state, setState] = useState<ModerationState>('NEEDS_ACTION')
  const queue = useLoad<{ items: ModerationQueueRow[]; total: number }>(() => listModeration(state), [state])
  return <AdminShell activeHref="/reviews"><div className="space-y-6">
    <PageHeader eyebrow="Compliance & quality" title="Review Moderation" description="Reported and hidden verified-purchase reviews. Every decision needs a reason; the original content and history are preserved. A Vendor can never remove a review." />
    <FilterChips label="Queue" value={state} chips={QUEUE_STATES} onChange={value => setState(value as ModerationState)} />
    {queue.error ? <ErrorState message={queue.error} onRetry={queue.retry} /> : !queue.data ? <LoadingState /> : queue.data.items.length === 0 ? <AnalyticsNullState title="Nothing to moderate" reason="No review matches this queue." />
      : <ul className="divide-y divide-border-default border-y border-border-default">{queue.data.items.map(row => <li key={row.id} className="grid gap-1 py-3">
        <p className="flex flex-wrap items-center gap-2"><Link className="font-semibold text-action-primary underline-offset-4 hover:underline" to={`/reviews/${row.id}`}>{row.type === 'PRODUCT' ? 'Product review' : row.type === 'VENDOR' ? 'Store rating' : 'Buyer rating'} · {row.storeName}</Link><StatusBadge label={row.moderationState.replaceAll('_', ' ').toLowerCase()} tone={row.moderationState === 'REMOVED' ? 'error' : 'warning'} />{row.openFlags > 0 && <StatusBadge label={`${row.openFlags} open report${row.openFlags === 1 ? '' : 's'}`} tone="info" />}</p>
        <p className="text-sm text-text-secondary">{row.displayName} · Order {row.orderReference}</p>{row.comment && <p className="text-sm">{row.comment}</p>}
      </li>)}</ul>}
  </div></AdminShell>
}

export function AdminReviewModerationDetailPage() {
  const { reviewId = '' } = useParams()
  const detail = useLoad<ModerationDetail>(() => getModeration(reviewId), [reviewId])
  const [action, setAction] = useState<ModerationAction | ''>('')
  const [reason, setReason] = useState('')
  const [message, setMessage] = useState<{ tone: 'error' | 'success'; text: string } | null>(null)
  const submit = async (event: FormEvent) => {
    event.preventDefault(); setMessage(null)
    if (!action || !detail.data) return
    if (reason.trim().length < 10) { setMessage({ tone: 'error', text: 'Record a reason of at least 10 characters.' }); return }
    try { detail.set(await moderate(reviewId, action, reason.trim(), Number(detail.data.lockVersion ?? 1))); setReason(''); setAction(''); setMessage({ tone: 'success', text: 'Decision recorded.' }) } catch (cause) { setMessage({ tone: 'error', text: await readableApiError(cause) }) }
  }
  const data = detail.data
  return <AdminShell activeHref="/reviews"><div className="space-y-6">
    <Link className="inline-flex min-h-11 items-center text-sm font-semibold text-action-primary" to="/reviews">← Review Moderation</Link>
    {detail.error ? <ErrorState message={detail.error} onRetry={detail.retry} /> : !data ? <LoadingState /> : <>
      <PageHeader eyebrow="Review Moderation" title={`${data.displayName ?? 'Review'} · ${String((data.verifiedPurchase as Record<string, unknown> | undefined)?.store_name ?? (data.verifiedPurchase as Record<string, unknown> | undefined)?.storeName ?? '')}`} description={data.authorDisplayRule ?? ''} />
      {message && <StatusMessage tone={message.tone}>{message.text}</StatusMessage>}
      <section className="grid gap-2 border-b border-border-default pb-5" aria-label="Review content">
        <p className="flex flex-wrap gap-4">{Object.entries(data.ratings ?? {}).filter(([, value]) => typeof value === 'number').map(([key, value]) => <span key={key} className="inline-flex items-center gap-2 text-sm"><span className="text-text-secondary">{key.replace(/([A-Z])/g, ' $1').toLowerCase()}</span><StarRatingDisplay value={Number(value)} label={key} /></span>)}</p>
        {data.comment && <p>{data.comment}</p>}
        <p className="text-xs text-text-secondary">State: {String(data.moderationState).replaceAll('_', ' ').toLowerCase()} · Visibility: {String(data.visibility ?? '').replaceAll('_', ' ').toLowerCase()}{data.relatedDispute ? ` · Related dispute ${String((data.relatedDispute as Record<string, unknown>).reference)}` : ''}</p>
      </section>
      {(data.availableActions ?? []).length > 0 && <form className="grid max-w-xl gap-3" onSubmit={submit}>
        <label className="grid gap-2 text-sm font-semibold">Decision<select className={control} value={action} onChange={event => setAction(event.target.value as ModerationAction)}><option value="">Choose…</option>{(data.availableActions ?? []).map(value => <option key={value} value={value}>{ACTION_LABELS[value] ?? value}</option>)}</select></label>
        <label className="grid gap-2 text-sm font-semibold">Reason (recorded and audited)<textarea className="min-h-24 rounded-control border border-border-default p-3 text-base font-normal" value={reason} onChange={event => setReason(event.target.value)} /></label>
        <Button className="w-fit" type="submit" disabled={!action}>Record decision</Button>
      </form>}
      <section aria-labelledby="history" className="space-y-2"><h2 id="history" className="text-lg font-semibold">Moderation history</h2>
        <ol className="divide-y divide-border-default border-y border-border-default">{(data.history as Record<string, string | null>[] | undefined ?? []).map((entry, index) => <li key={index} className="py-2 text-sm"><span className="font-semibold">{ACTION_LABELS[String(entry.action)] ?? String(entry.action).replaceAll('_', ' ').toLowerCase()}</span> · {String(entry.actor_role ?? entry.actorRole ?? '')} · {formatManilaDateTime(String(entry.at))}{entry.reason ? <p className="text-text-secondary">{entry.reason}</p> : null}</li>)}</ol>
      </section>
      <section aria-labelledby="revisions" className="space-y-2"><h2 id="revisions" className="text-lg font-semibold">Revisions (original preserved)</h2>
        <ol className="divide-y divide-border-default border-y border-border-default">{(data.revisions as Record<string, unknown>[] | undefined ?? []).map(revision => <li key={String(revision.revision)} className="py-2 text-sm"><span className="font-semibold">Revision {String(revision.revision)} · {String(revision.reason).toLowerCase()}</span><p className="text-text-secondary">{String((revision.content as Record<string, unknown> | undefined)?.comment ?? '')}</p></li>)}</ol>
      </section>
    </>}
  </div></AdminShell>
}
