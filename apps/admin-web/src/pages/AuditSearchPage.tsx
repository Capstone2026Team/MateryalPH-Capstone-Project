import { DocumentExportButton } from '@materyalph/web-ui'
import { ActiveFilters, Button, DateFilter, FactList, InfoNote, SearchInput, SidePanel, StatusBadge } from '@materyalph/web-ui'
import { dateQuery } from '../lib/admin-format'
import { Download, Search, X } from 'lucide-react'
import { useEffect, useRef, useState, type FormEvent } from 'react'
import { control, labelClass, manilaDateTime, useLoad } from '../lib/operations-hooks'
import { apiProblem, auditActions, getAudit, newKey, problemText, requestExport, searchAudit, type AuditEvent } from '../lib/operations-api'
import { AdminShell, ErrorState, LoadingState, PageHeader } from './PhaseThreeAdminPages'

type Filters = { actor: string; actorRole: string; action: string; resourceType: string; resourceId: string; result: string; correlationId: string; reason: string; from: string; to: string }
const EMPTY: Filters = { actor: '', actorRole: '', action: '', resourceType: '', resourceId: '', result: '', correlationId: '', reason: '', from: '', to: '' }
const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i

function request(filters: Filters, cursor?: string) {
  return {
    ...(filters.actor ? { actor: filters.actor } : {}), ...(filters.actorRole ? { actorRole: filters.actorRole } : {}), ...(filters.action ? { action: filters.action } : {}),
    ...(filters.resourceType ? { resourceType: filters.resourceType } : {}), ...(filters.resourceId ? { resourceId: filters.resourceId } : {}),
    ...(filters.result ? { result: filters.result as never } : {}), ...(filters.correlationId ? { correlationId: filters.correlationId } : {}), ...(filters.reason ? { reason: filters.reason } : {}),
    ...dateQuery(filters),
    ...(cursor ? { cursor } : {}),
  }
}

function exportFilters(filters: Filters): Record<string, string> {
  const snake: Record<string, string> = { actor: 'actor', actorRole: 'actor_role', action: 'action', resourceType: 'resource_type', result: 'result', correlationId: 'correlation_id', reason: 'reason' }
  const out: Record<string, string> = {}
  for (const [key, name] of Object.entries(snake)) { const value = filters[key as keyof Filters]; if (value) out[name] = value }
  if (filters.from) out.from = filters.from
  if (filters.to) out.to = filters.to
  return out
}

/** Read-only, append-only audit search. There is deliberately no edit, delete or annotate control anywhere on this page. */
export function AdminAuditSearchPage() {
  const [draft, setDraft] = useState<Filters>(EMPTY)
  const [applied, setApplied] = useState<Filters>(EMPTY)
  const [dateLabel, setDateLabel] = useState('All dates')
  const [items, setItems] = useState<AuditEvent[]>([])
  const [cursor, setCursor] = useState<string | null>(null)
  const [flags, setFlags] = useState({ canViewDetail: false, canExport: false })
  const [state, setState] = useState<'loading' | 'ready' | 'more'>('loading')
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  const [selected, setSelected] = useState<AuditEvent | null>(null)
  const actions = useLoad(auditActions, [])
  useEffect(() => {
    let active = true
    setState('loading'); setError(null)
    searchAudit(request(applied)).then(result => { if (!active) return; setItems(result.items); setCursor(result.nextCursor); setFlags({ canViewDetail: result.canViewDetail, canExport: result.canExport }) })
      .catch(async cause => { const text = problemText(await apiProblem(cause)); if (active) setError(text) }).finally(() => { if (active) setState('ready') })
    return () => { active = false }
  }, [applied, attempt])
  async function more() {
    if (!cursor) return
    setState('more'); setError(null)
    try { const result = await searchAudit(request(applied, cursor)); setItems(current => [...current, ...result.items]); setCursor(result.nextCursor) }
    catch (cause) { setError(problemText(await apiProblem(cause))) } finally { setState('ready') }
  }
  function apply(event: FormEvent) {
    event.preventDefault()
    if (draft.resourceId && !UUID.test(draft.resourceId)) { setError('Resource ID must be a full UUID.'); return }
    setApplied({ ...draft })
  }
  const set = (key: keyof Filters) => (event: { target: { value: string } }) => setDraft(current => ({ ...current, [key]: event.target.value }))
  return <AdminShell activeHref="/audit"><div className="space-y-6">
    <PageHeader eyebrow="Tracking" title="Audit Log" description="Search the append-only record of authentication, authorization and every Admin, Vendor and system decision. Entries cannot be edited or deleted."
      actions={flags.canExport ? <ExportButton filters={applied} /> : undefined} />
    <InfoNote>Credentials, tokens, OTPs and payment details are never stored in audit entries. Opening an entry's before/after detail is itself audited.</InfoNote>
    <form onSubmit={apply} role="search" aria-label="Audit search" className="grid gap-4 rounded-surface border border-border-default bg-surface-primary p-4">
      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <div className={labelClass}><span>Actor name or email</span><SearchInput label="Actor name or email" value={draft.actor} maxLength={120} onChange={value => setDraft(current => ({ ...current, actor: value }))} /></div>
        <label className={labelClass}>Actor role<input className={control} value={draft.actorRole} maxLength={48} onChange={set('actorRole')} placeholder="e.g. SUPER_ADMIN" /></label>
        <label className={labelClass}>Action<select className={control} value={draft.action} onChange={set('action')}><option value="">Any action</option>{(actions.data ?? []).map(action => <option key={action} value={action}>{action}</option>)}</select></label>
        <label className={labelClass}>Result<select className={control} value={draft.result} onChange={set('result')}><option value="">Succeeded or failed</option><option value="SUCCEEDED">Succeeded</option><option value="FAILED">Failed</option></select></label>
        <label className={labelClass}>Resource type<input className={control} value={draft.resourceType} maxLength={80} onChange={set('resourceType')} placeholder="e.g. ENFORCEMENT_ACTION" /></label>
        <label className={labelClass}>Resource ID<input className={control} value={draft.resourceId} onChange={set('resourceId')} placeholder="Full UUID" /></label>
        <label className={labelClass}>Correlation ID<input className={control} value={draft.correlationId} maxLength={80} onChange={set('correlationId')} /></label>
        <div className={labelClass}><span>Reason contains</span><SearchInput label="Reason contains" value={draft.reason} maxLength={120} onChange={value => setDraft(current => ({ ...current, reason: value }))} /></div>
      </div>
      <div className="flex flex-wrap items-center gap-2"><DateFilter title="Audit event dates" value={{ label: dateLabel, from: applied.from, to: applied.to }} onChange={range => { setDateLabel(range.label); setDraft(current => ({ ...current, from: range.from, to: range.to })); setApplied(current => ({ ...current, from: range.from, to: range.to })) }} /><Button type="submit"><Search size={16} aria-hidden="true" />Search</Button><Button variant="secondary" onClick={() => { setDraft(EMPTY); setApplied(EMPTY); setDateLabel('All dates') }}><X size={16} aria-hidden="true" />Reset filters</Button></div>
    </form>
    <ActiveFilters filters={Object.entries(applied).filter(([key, value]) => value && !['from', 'to'].includes(key)).map(([key, value]) => ({ key, label: `${key.replace(/([A-Z])/g, ' $1')}: ${value}`, onRemove: () => { setDraft(current => ({ ...current, [key]: '' })); setApplied(current => ({ ...current, [key]: '' })) } }))} onClear={() => { setDraft(EMPTY); setApplied(EMPTY); setDateLabel('All dates') }} />
    {error && <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} />}
    {state === 'loading' ? <LoadingState /> : items.length === 0 && !error ? <p className="rounded-surface border border-dashed border-border-default bg-surface-primary px-6 py-10 text-center text-sm text-text-secondary">No audit entries match these filters.</p> : items.length > 0 && <>
      <div className="overflow-x-auto rounded-surface border border-border-default bg-surface-primary"><table className="w-full min-w-[980px] text-left text-sm">
        <caption className="sr-only">Audit entries, newest first</caption>
        <thead className="bg-surface-canvas text-[13px] text-text-secondary"><tr>{['Recorded (Manila)', 'Actor', 'Action', 'Resource', 'Result', 'Reason', 'Correlation ID'].map(head => <th key={head} scope="col" className="px-3 py-3 font-semibold">{head}</th>)}</tr></thead>
        <tbody className="divide-y divide-border-default">{items.map(item => <tr key={item.id} className="align-top">
          <td className="px-3 py-3 whitespace-nowrap">{manilaDateTime(item.createdAt)}</td>
          <td className="px-3 py-3">{item.actor}{item.actorRole && <p className="text-[13px] text-text-secondary">{item.actorRole}</p>}</td>
          <th scope="row" className="px-3 py-3 text-left font-normal">{flags.canViewDetail && item.hasDetail ? <button type="button" onClick={() => setSelected(item)} className="min-h-11 text-left font-semibold text-action-primary underline underline-offset-4">{item.action}</button> : <span className="font-semibold">{item.action}</span>}</th>
          <td className="px-3 py-3">{item.resourceType}{item.organization && <p className="text-[13px] text-text-secondary">{item.organization}</p>}{item.resourceId && <p className="break-all text-[13px] text-text-secondary">{item.resourceId}</p>}</td>
          <td className="px-3 py-3"><StatusBadge label={item.succeeded ? 'Succeeded' : 'Failed'} tone={item.succeeded ? 'success' : 'error'} /></td>
          <td className="max-w-64 px-3 py-3 break-words">{item.reason ?? '—'}</td>
          <td className="px-3 py-3 break-all text-[13px]">{item.correlationId}</td>
        </tr>)}</tbody>
      </table></div>
      <div className="flex flex-wrap items-center gap-3"><p className="text-sm text-text-secondary">{items.length.toLocaleString('en-PH')} entries shown</p>{cursor && <Button variant="secondary" disabled={state === 'more'} onClick={() => void more()}>{state === 'more' ? 'Loading…' : 'Load older entries'}</Button>}</div>
    </>}
    {selected && <AuditDetail event={selected} onClose={() => setSelected(null)} />}
  </div></AdminShell>
}

function AuditDetail({ event, onClose }: { event: AuditEvent; onClose: () => void }) {
  const detail = useLoad(() => getAudit(event.id), [event.id])
  const json = (value: unknown) => value === null || value === undefined ? 'Not recorded' : <pre className="max-h-72 overflow-auto rounded-control bg-surface-canvas p-3 text-[13px] whitespace-pre-wrap break-all">{JSON.stringify(value, null, 2)}</pre>
  return <SidePanel open title={event.action} description={`${manilaDateTime(event.createdAt)} · ${event.actor}`} onClose={onClose}>
    {detail.error ? <ErrorState message={detail.error} onRetry={detail.retry} /> : !detail.data ? <LoadingState /> : <div className="grid gap-4">
      <FactList columns={1} facts={[{ label: 'Resource', value: `${detail.data.resourceType}${detail.data.resourceId ? ` · ${detail.data.resourceId}` : ''}` }, { label: 'Result', value: detail.data.succeeded ? 'Succeeded' : 'Failed' },
        { label: 'Reason', value: detail.data.reason ?? '—' }, { label: 'Correlation ID', value: <span className="break-all">{detail.data.correlationId}</span> }, { label: 'Before', value: json(detail.data.before) }, { label: 'After', value: json(detail.data.after) }]} />
      <p className="text-[13px] text-text-secondary">{detail.data.redactionNote}</p>
    </div>}
  </SidePanel>
}

function ExportButton({ filters }: { filters: Filters }) {
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
    try { const outcome = await requestExport('AUDIT_LOG', payload, purpose.trim(), key.current.value); setMessage({ tone: 'success', text: outcome === 'DOWNLOADED' ? 'The export was generated and downloaded. The export itself is audited.' : 'The export is still generating. It will be listed with your exports when ready.' }) }
    catch (cause) { setMessage({ tone: 'error', text: problemText(await apiProblem(cause)) }) } finally { setBusy(false) }
  }
  return <>
    <DocumentExportButton basePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} audience="admin" types={['AUDIT_LOG']} filters={exportFilters(filters)} />
    <Button variant="secondary" onClick={() => setOpen(true)}><Download size={16} aria-hidden="true" />Export CSV</Button>
    {open && <SidePanel open title="Export audit entries" description="Uses the current search filters; up to 5,000 rows without before/after payloads." onClose={() => setOpen(false)}>
      <form onSubmit={event => void submit(event)} className="grid gap-5">
        <label className={labelClass}>Purpose (recorded)<textarea className={`${control} min-h-20 py-2`} maxLength={500} value={purpose} onChange={event => setPurpose(event.target.value)} /></label>
        {message && <p role={message.tone === 'error' ? 'alert' : 'status'} className={`rounded-control border px-4 py-3 text-sm ${message.tone === 'error' ? 'border-status-error/30 bg-red-50 text-red-900' : 'border-status-success/30 bg-green-50 text-green-900'}`}>{message.text}</p>}
        <div className="flex justify-end"><Button type="submit" disabled={busy}>{busy ? 'Generating…' : 'Generate export'}</Button></div>
      </form>
    </SidePanel>}
  </>
}
