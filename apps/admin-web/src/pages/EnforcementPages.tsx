import { BackNavigation, dateFilterPreset, dateRangePatch, Button, DateFilter, EventTimeline, EvidenceFilesPicker, FactList, FilterPanel, FilterTabs, FormDialog, InfoNote, PrivateEvidenceGallery, QueueSectionLinks, QueueSurface, useQueueStatusCounts, ReasonedDecisionForm, ResponsiveRecordList, SearchInput, StatusBadge, type RecordColumn } from '@materyalph/web-ui'
import { Plus, RefreshCw, Search } from 'lucide-react'
import { useId, useRef, useState, type FormEvent } from 'react'
import { Link, useNavigate, useParams, useSearchParams } from 'react-router-dom'
import { Pager, Panel } from '../components/OperationsKit'
import { control, label as humanize, labelClass, manilaDateTime, useLoad, useProtectedAction } from '../lib/operations-hooks'
import {
  apiProblem, applyEnforcement, declineEnforcement, getEnforcement, getEnforcementEvidenceLink, getSubject, isConflict, liftEnforcement, listEnforcement, newKey, problemText, recordEnforcement, searchSubjects, uploadEnforcementEvidence,
  type EnforcementDetail, type EnforcementSubjectMatch, type EnforcementSummary,
} from '../lib/operations-api'
import { AdminShell, ErrorState, LoadingState, PageHeader } from './PhaseThreeAdminPages'
import { dateQuery } from '../lib/admin-format'
import { useAdminQueue, useQueueParams } from '../lib/use-admin-queue'

type SubjectType = 'BUYER' | 'VENDOR_ORGANIZATION'
const ACTIONS = ['WARNING', 'TEMPORARY_RESTRICTION', 'SUSPENSION', 'PERMANENT_BAN'] as const
const PLANS = ['CONTINUE', 'MONITORED_FULFILLMENT', 'CANCELLATION_REVIEW', 'REPLACEMENT', 'REFUND', 'NO_OPEN_ORDERS'] as const
const PLAN_HELP: Record<string, string> = {
  CONTINUE: 'Open orders continue normally under monitoring of the case.', MONITORED_FULFILLMENT: 'Open orders continue with Order & Dispute monitoring.',
  CANCELLATION_REVIEW: 'Order & Dispute reviews each open order for cancellation.', REPLACEMENT: 'Order & Dispute arranges replacement supply where possible.',
  REFUND: 'Unfulfilled paid orders are refunded through the refund workflow.', NO_OPEN_ORDERS: 'The subject has no open orders.',
}
const ACTION_EFFECT: Record<string, Record<SubjectType, string>> = {
  WARNING: { BUYER: 'A recorded warning; no access changes.', VENDOR_ORGANIZATION: 'A recorded warning; no store changes.' },
  TEMPORARY_RESTRICTION: { BUYER: 'Blocks new orders, quotations, inquiries and conversations until the duration ends.', VENDOR_ORGANIZATION: 'The store becomes Restricted and leaves discovery until the duration ends.' },
  SUSPENSION: { BUYER: 'The Buyer account is Suspended and every session is revoked.', VENDOR_ORGANIZATION: 'The store becomes Suspended and leaves discovery until lifted.' },
  PERMANENT_BAN: { BUYER: 'The account is deactivated; Super Admin only, with identity verification.', VENDOR_ORGANIZATION: 'The store is banned; Super Admin only, with identity verification.' },
}
const stateTone = (state: string) => state === 'APPLIED' ? 'error' : state === 'REFERRED' ? 'warning' : state === 'EFFECTIVE' ? 'info' : state === 'LIFTED' ? 'success' : 'neutral'
const subjectLabel = (type: string) => type === 'BUYER' ? 'Buyer' : 'Vendor'
const ENFORCEMENT_STATES = [{ value: 'REFERRED', label: 'Awaiting decision' }, { value: 'APPLIED', label: 'Applied' }, { value: 'EFFECTIVE', label: 'Warnings' }, { value: 'LIFTED', label: 'Lifted' }, { value: 'DECLINED', label: 'Declined' }]
const enforcementError = async (cause: unknown) => problemText(await apiProblem(cause))

export function AdminEnforcementQueuePage({ subjectType, activeHref = '/enforcement' }: { subjectType?: SubjectType; activeHref?: string }) {
  const { params, page, range, change, setPage, context } = useQueueParams()
  const state = ENFORCEMENT_STATES.some(item => item.value === params.get('state')) ? params.get('state')! : 'REFERRED'
  const source = params.get('source') ?? ''
  const type = subjectType ?? params.get('subject') ?? ''
  const [recording, setRecording] = useState(false)
  const list = useAdminQueue(`enforcement:${JSON.stringify([state, source, type, range.from, range.to, page])}`, () => listEnforcement({ state: state as never, ...(source ? { source: source as never } : {}), ...(type ? { subjectType: type as never } : {}), ...dateQuery(range), page }), enforcementError)
  const items = list.data?.items ?? []
  const counts = useQueueStatusCounts(list.data?.counts, Boolean(list.error))
  const reset = () => change({ state: 'REFERRED', source: '', subject: '', ...dateRangePatch(dateFilterPreset(30)) })
  const buyers = subjectType === 'BUYER'
  return <AdminShell activeHref={activeHref}><div className="mp-queue-workspace">
    <PageHeader eyebrow={buyers ? 'Marketplace' : 'Compliance & quality'} title={buyers ? 'Buyer Management' : 'Enforcement'} description={buyers ? 'Review Buyer accounts referred for enforcement and record graduated sanctions. Contact details, coordinates and payment data are never shown.' : 'Warnings, Temporary Restrictions, Suspensions and Permanent Bans for Buyers and Vendors, including dispute referrals. Every sanction records a reason and a continuation plan for open orders.'}
      actions={<><Button variant="secondary" disabled={list.loading} onClick={() => void list.retry()}><RefreshCw size={16} aria-hidden="true" />{list.loading && list.data ? 'Refreshing…' : 'Refresh'}</Button><Button onClick={() => setRecording(true)}><Plus size={16} aria-hidden="true" />Record action</Button></>} />

    <InfoNote>Refunds always proceed regardless of sanctions. Lifting a Vendor sanction returns the store to its readiness state; it never re-activates a store directly.</InfoNote>
    <FilterTabs appearance="chips" label="Enforcement state" value={state} onChange={value => change({ state: value })} chips={ENFORCEMENT_STATES.map(item => ({ ...item, count: counts[item.value] }))} />
    <FilterPanel compact columns={2} label="Enforcement filters" footer={<div className="mp-filter-date"><span>Recorded dates</span><DateFilter title="Enforcement recorded dates" value={range} onChange={value => change(dateRangePatch(value))} /></div>} actions={<Button variant="quiet" onClick={reset}>Reset filters</Button>}>
      {!subjectType && <label>Subject type<select className={control} value={type} onChange={event => change({ subject: event.target.value })}><option value="">Buyers and Vendors</option><option value="BUYER">Buyers</option><option value="VENDOR_ORGANIZATION">Vendors</option></select></label>}
      <label>Source<select className={control} value={source} onChange={event => change({ source: event.target.value })}><option value="">All sources</option><option value="DISPUTE_REFERRAL">Dispute referrals</option><option value="DIRECT">Direct Admin actions</option></select></label>
    </FilterPanel>
    <QueueSurface title={ENFORCEMENT_STATES.find(item => item.value === state)!.label} description="Open a record to review its reason, order continuation plan and decision history." count={list.data?.total ?? null} shown={items.length} loaded={Boolean(list.data)} busy={list.loading} error={list.error && <ErrorState message={list.error} onRetry={list.retry} />} emptyTitle={page > 1 ? 'No enforcement records on this page.' : 'No enforcement records match this view.'} emptyDescription="No records match the selected state, subjects, source and recorded dates." emptyAction={page > 1 ? <Button variant="secondary" onClick={() => setPage(1)}>Return to first page</Button> : undefined}
      footer={list.data && (page > 1 || list.data.lastPage > 1) && <Pager page={page} lastPage={list.data.lastPage} total={list.data.total} busy={list.loading} onChange={setPage} />}>
      <EnforcementTable items={items} context={context} />
    </QueueSurface>
    {recording && <RecordActionDialog initialType={subjectType ?? 'BUYER'} lockType={Boolean(subjectType)} onClose={() => setRecording(false)} />}
  </div></AdminShell>
}

function EnforcementTable({ items, context }: { items: EnforcementSummary[]; context: string }) {
  const identity = (item: EnforcementSummary) => <div><p className="font-semibold">{item.subjectName}</p><p className="text-xs text-text-secondary">{subjectLabel(item.subjectType)}</p></div>
  const columns: RecordColumn<EnforcementSummary>[] = [
    { key: 'subject', header: 'Subject', cell: identity },
    { key: 'action', header: 'Action', cell: item => <>{item.actionLabel}{item.durationDays ? <p className="text-xs text-text-secondary">{item.durationDays} days</p> : null}</> },
    { key: 'state', header: 'State', cell: item => <StatusBadge label={humanize(item.state)} tone={stateTone(item.state)} /> },
    { key: 'source', header: 'Source', cell: item => item.source === 'DISPUTE_REFERRAL' ? <>Dispute referral{item.caseReference && <p className="text-xs text-text-secondary">{item.caseReference}</p>}</> : 'Direct' },
    { key: 'recorded', header: 'Recorded', cell: item => manilaDateTime(item.createdAt) },
    { key: 'ends', header: 'Ends', cell: item => item.expiresAt ? manilaDateTime(item.expiresAt) : '—' },
    { key: 'open', header: 'Review', cell: item => <Link className="inline-flex min-h-11 items-center font-semibold text-action-primary underline-offset-4 hover:underline" to={`/enforcement/${item.id}${context}`} aria-label={`Open ${item.actionLabel} for ${item.subjectName}`}>Open</Link> },
  ]
  return <ResponsiveRecordList compact tableClassName="mp-queue-record-table" caption="Enforcement records" rows={items} columns={columns} rowKey={item => item.id} cardTitle={identity} />
}

export function RecordActionDialog({ initialType, initialSubjectId = '', lockType, onClose, onRecorded }: { initialType: SubjectType; initialSubjectId?: string; lockType: boolean; onClose: () => void; onRecorded?: () => void }) {
  const navigate = useNavigate()
  const [type, setType] = useState<SubjectType>(initialType)
  const [query, setQuery] = useState('')
  const [matches, setMatches] = useState<EnforcementSubjectMatch[] | null>(null)
  const [subjectId, setSubjectId] = useState(initialSubjectId)
  const [action, setAction] = useState<(typeof ACTIONS)[number]>('WARNING')
  const [form, setForm] = useState({ scope: 'Marketplace activity', durationDays: '7', restoration: '', plan: '', note: '' })
  const [error, setError] = useState<string | null>(null)
  const [fields, setFields] = useState<Record<string, string>>({})
  const [files, setFiles] = useState<File[]>([])
  const uploaded = useRef(new Map<File, string>())
  const formId = useId()
  const key = useRef({ scope: '', value: newKey() })
  const subject = useLoad(() => subjectId ? getSubject(type, subjectId) : Promise.resolve(null), [type, subjectId])
  const { run, busy, dialog } = useProtectedAction()
  const openOrders = subject.data?.openOrders ?? 0
  const plans = PLANS.filter(plan => openOrders > 0 ? plan !== 'NO_OPEN_ORDERS' : plan === 'NO_OPEN_ORDERS' || plan === 'CONTINUE')
  async function search(event: FormEvent) {
    event.preventDefault(); setError(null)
    const result = await run('Search', () => searchSubjects(type, query.trim()))
    if (result.ok) setMatches(result.value); else setError(problemText(result.problem))
  }
  async function submit(reason: string) {
    setError(null); setFields({})
    const input = { subjectType: type, subjectId, action, reason, scope: form.scope.trim() || 'Marketplace activity',
      ...(action === 'TEMPORARY_RESTRICTION' ? { durationDays: Number(form.durationDays) } : {}), ...(form.restoration.trim() ? { restorationCondition: form.restoration.trim() } : {}),
      ...(action !== 'WARNING' && form.plan ? { continuationPlan: form.plan as never } : {}), ...(action !== 'WARNING' && form.note.trim() ? { continuationNote: form.note.trim() } : {}) }
    const result = await run(action === 'PERMANENT_BAN' ? 'Verify to record a Permanent Ban' : 'Verify to record this sanction', async () => {
      const evidenceFileIds: string[] = []
      for (const file of files) {
        let id = uploaded.current.get(file)
        if (!id) { id = (await uploadEnforcementEvidence(type, subjectId, file)).id; uploaded.current.set(file, id) }
        evidenceFileIds.push(id)
      }
      const request = { ...input, evidenceFileIds: new Set(evidenceFileIds) }
      const scope = JSON.stringify({ ...input, evidenceFileIds })
      if (key.current.scope !== scope) key.current = { scope, value: newKey() }
      return recordEnforcement(request, key.current.value)
    })
    if (result.ok) { if (onRecorded) onRecorded(); else navigate(`/enforcement/${result.value.id}`) }
    else { setFields(result.problem.fields); setError(problemText(result.problem)) }
  }
  const selected = matches?.find(match => match.id === subjectId)
  const allowed = subject.data?.recordableActions ?? []
  const canRecord = Boolean(subject.data && allowed.includes(action))
  return <FormDialog open size="compact" initialFocus="title" title="Record enforcement action" description="Review the account, explain the action and attach supporting proof." busy={busy} onClose={onClose}
    footer={<div className="flex flex-wrap items-center justify-between gap-3"><p className="max-w-sm text-xs text-text-secondary">Submitting records the decision and queues an email and in-app notification for the affected {type === 'BUYER' ? 'Buyer' : 'Vendor Owner'}.</p><div className="flex flex-wrap gap-2"><Button variant="secondary" disabled={busy} onClick={onClose}>Cancel</Button>{canRecord && <Button type="submit" form={formId} variant={action === 'WARNING' ? 'primary' : 'danger'} disabled={busy}>{busy ? 'Recording…' : action === 'WARNING' ? 'Record warning & notify' : 'Apply sanction & notify'}</Button>}</div></div>}>
    <div className="grid gap-4">
      {!initialSubjectId && <form role="search" onSubmit={event => void search(event)} className="grid gap-3">
        {!lockType && <label className={labelClass}>Subject type<select className={control} disabled={busy} value={type} onChange={event => { setType(event.target.value as SubjectType); setMatches(null); setSubjectId(''); setFiles([]); uploaded.current.clear() }}><option value="BUYER">Buyer</option><option value="VENDOR_ORGANIZATION">Vendor</option></select></label>}
        <div className={labelClass}><span>{type === 'BUYER' ? 'Exact Buyer email' : 'Store or registered name'}</span><div className="flex min-w-0 flex-wrap gap-2"><SearchInput label={type === 'BUYER' ? 'Exact Buyer email' : 'Store or registered name'} value={query} minLength={type === 'BUYER' ? 5 : 2} required type={type === 'BUYER' ? 'email' : 'search'} onChange={setQuery} className="flex-1 basis-48" /><Button type="submit" variant="secondary" disabled={busy}><Search size={16} aria-hidden="true" />Find</Button></div></div>
      </form>}
      {matches && (matches.length === 0 ? <p className="text-sm text-text-secondary">No matching account. Buyer search needs the exact email address.</p>
        : <fieldset disabled={busy} className="grid gap-2"><legend className="text-sm font-semibold">Select the subject</legend>{matches.map(match => <label key={match.id} className={`flex min-h-11 items-center gap-3 rounded-control border px-3 py-2 text-sm ${match.id === subjectId ? 'border-action-primary bg-brand-orange-50' : 'border-border-default'}`}><input type="radio" name="subject" checked={match.id === subjectId} onChange={() => { setSubjectId(match.id); setFiles([]); uploaded.current.clear() }} /><span className="min-w-0 flex-1"><span className="font-semibold">{match.displayName}</span> · {humanize(match.status)}</span></label>)}</fieldset>)}
      {subjectId && (subject.error ? <ErrorState message={subject.error} onRetry={subject.retry} /> : !subject.data ? <LoadingState /> : <>
        <div className="border-b border-border-default pb-4"><p className="mb-3 text-sm font-semibold">{subject.data.displayName} <span className="font-normal text-text-secondary">· {subjectLabel(type)}</span></p><FactList facts={[{ label: 'Account status', value: humanize(subject.data.accountStatus) }, ...(subject.data.storeActivationStatus ? [{ label: 'Store activation', value: humanize(subject.data.storeActivationStatus) }] : []),
          { label: 'Open orders', value: subject.data.openOrders }, { label: 'Disputes (open / total)', value: `${subject.data.disputesOpen} / ${subject.data.disputesTotal}` },
          ...(subject.data.commerceRestrictedUntil ? [{ label: 'Commerce restricted until', value: manilaDateTime(subject.data.commerceRestrictedUntil) }] : [])]} /></div>
        {allowed.length === 0 ? <InfoNote>Your role can review enforcement. Recording an action requires User Management permission.</InfoNote> : <ReasonedDecisionForm id={formId} appearance="plain" hideSubmit title="Action details" target={`${selected?.displayName ?? subject.data.displayName} (${subjectLabel(type)})`} before={humanize(subject.data.storeActivationStatus ?? subject.data.accountStatus)} after={ACTION_EFFECT[action]?.[type]}
          submitLabel="Record & notify" submitDisabled={!canRecord} variant={action === 'WARNING' ? 'primary' : 'danger'} busy={busy} error={error} minReason={10} maxReason={2000} onSubmit={reason => void submit(reason)}
          afterReason={<EvidenceFilesPicker files={files} onChange={setFiles} disabled={busy} />}>
          <fieldset disabled={busy} className="grid min-w-0 gap-4 sm:grid-cols-2">
          <label className={labelClass}>Action<select className={control} value={action} onChange={event => setAction(event.target.value as (typeof ACTIONS)[number])}>{allowed.map(item => <option key={item} value={item}>{humanize(item)}</option>)}</select></label>
          <label className={labelClass}>Scope<input className={control} maxLength={160} value={form.scope} onChange={event => setForm({ ...form, scope: event.target.value })} /></label>
          </fieldset>
          {action === 'TEMPORARY_RESTRICTION' && <label className={labelClass}>Duration (days)<input className={control} type="number" min={1} max={365} value={form.durationDays} onChange={event => setForm({ ...form, durationDays: event.target.value })} aria-invalid={Boolean(fields.duration_days)} />{fields.duration_days && <span role="alert" className="text-sm font-normal text-status-error">{fields.duration_days}</span>}</label>}
          {(action === 'TEMPORARY_RESTRICTION' || action === 'SUSPENSION') && <label className={labelClass}>Restoration condition<textarea className={`${control} min-h-20 py-2`} maxLength={2000} value={form.restoration} onChange={event => setForm({ ...form, restoration: event.target.value })} aria-invalid={Boolean(fields.restoration_condition)} />{fields.restoration_condition && <span role="alert" className="text-sm font-normal text-status-error">{fields.restoration_condition}</span>}</label>}
          {action !== 'WARNING' && <PlanFields plans={plans} openOrders={openOrders} plan={form.plan} note={form.note} error={fields.continuation_plan} onChange={(plan, note) => setForm({ ...form, plan, note })} />}
        </ReasonedDecisionForm>}
      </>)}
      {error && !subjectId && <p role="alert" className="text-sm text-status-error">{error}</p>}
    </div>
    {dialog}
  </FormDialog>
}

function PlanFields({ plans, openOrders, plan, note, error, onChange }: { plans: readonly string[]; openOrders: number; plan: string; note: string; error?: string | undefined; onChange: (plan: string, note: string) => void }) {
  return <fieldset className="grid gap-2">
    <legend className="text-sm font-semibold">Continuation plan for existing orders ({openOrders} open)</legend>
    <div className="grid gap-2 sm:grid-cols-2">{plans.map(item => <label key={item} className="flex min-h-11 items-start gap-3 rounded-control border border-border-default px-3 py-2 text-sm"><input type="radio" name="continuation-plan" className="mt-1" checked={plan === item} onChange={() => onChange(item, note)} /><span><span className="font-semibold">{humanize(item)}</span><span className="block text-text-secondary">{PLAN_HELP[item]}</span></span></label>)}</div>
    {error && <span role="alert" className="text-sm text-status-error">{error}</span>}
    <label className={labelClass}>Plan note (optional)<textarea className={`${control} min-h-16 py-2`} maxLength={2000} value={note} onChange={event => onChange(plan, event.target.value)} /></label>
  </fieldset>
}

export function AdminEnforcementDetailPage() {
  const { actionId = '' } = useParams()
  return <EnforcementDetailView key={actionId} actionId={actionId} />
}

function EnforcementDetailView({ actionId }: { actionId: string }) {
  const detail = useLoad(() => getEnforcement(actionId), [actionId])
  const [params] = useSearchParams()
  const backHref = `/enforcement${params.size ? `?${params.toString()}` : ''}`
  return <AdminShell activeHref="/enforcement"><div className="mp-queue-workspace">
    <BackNavigation><Link to={backHref}>Back to Enforcement</Link></BackNavigation>
    {detail.error ? <ErrorState message={detail.error} onRetry={detail.retry} /> : !detail.data ? <LoadingState /> : <EnforcementCase detail={detail.data} onChanged={detail.set} onReload={detail.retry} />}
  </div></AdminShell>
}

function EnforcementCase({ detail, onChanged, onReload }: { detail: EnforcementDetail; onChanged: (next: EnforcementDetail) => void; onReload: () => void }) {
  const [mode, setMode] = useState<'APPLY' | 'DECLINE' | 'LIFT' | null>(null)
  const [plan, setPlan] = useState({ plan: '', note: '' })
  const [error, setError] = useState<string | null>(null)
  const [conflict, setConflict] = useState<string | null>(null)
  const [fields, setFields] = useState<Record<string, string>>({})
  const { run, busy, dialog } = useProtectedAction()
  const review = detail.subjectReview
  const openOrders = review.openOrders ?? 0
  const plans = PLANS.filter(item => openOrders > 0 ? item !== 'NO_OPEN_ORDERS' : item === 'NO_OPEN_ORDERS' || item === 'CONTINUE')
  const type = detail.subjectType as SubjectType
  async function decide(reason: string) {
    if (!mode) return
    setError(null); setConflict(null); setFields({})
    const title = detail.action === 'PERMANENT_BAN' ? 'Verify to decide a Permanent Ban' : 'Verify to record this decision'
    const result = await run(title, () => mode === 'APPLY' ? applyEnforcement(detail.id, { continuationPlan: plan.plan as never, ...(plan.note.trim() ? { continuationNote: plan.note.trim() } : {}), lockVersion: detail.lockVersion, reason })
      : mode === 'DECLINE' ? declineEnforcement(detail.id, detail.lockVersion, reason) : liftEnforcement(detail.id, detail.lockVersion, reason))
    if (result.ok) { onChanged(result.value); setMode(null); return }
    if (isConflict(result.problem)) setConflict('This case changed after you opened it. Reload to review the current state before deciding.')
    else { setFields(result.problem.fields); setError(problemText(result.problem)) }
  }
  const after = mode === 'APPLY' ? ACTION_EFFECT[detail.action]?.[type] : mode === 'DECLINE' ? 'Declined; no sanction is applied.' : mode === 'LIFT' ? (type === 'VENDOR_ORGANIZATION' ? 'Lifted; the store returns to its readiness state (never directly Active).' : 'Lifted; the Buyer regains access.') : undefined
  return <>
    <PageHeader compact eyebrow={`${subjectLabel(detail.subjectType)} enforcement`} title={`${detail.actionLabel}: ${detail.subjectName}`} description={detail.source === 'DISPUTE_REFERRAL' ? `Referred from dispute ${detail.caseReference ?? ''}. Order & Dispute recommends; User Management decides.` : 'Recorded directly by an authorized Admin.'} />
    <div className="flex flex-wrap gap-2"><StatusBadge label={humanize(detail.state)} tone={stateTone(detail.state)} />{detail.expiresAt && <StatusBadge label={`Ends ${manilaDateTime(detail.expiresAt)}`} tone="info" />}</div>
    <QueueSectionLinks links={[{ href: '#enforcement-sanction', label: 'Sanction' }, { href: '#enforcement-account', label: 'Account review' }, ...(detail.allowedActions.length ? [{ href: '#enforcement-decision', label: 'Decision' }] : []), { href: '#enforcement-history', label: 'History' }]} />
    <div className="mp-queue-detail-columns">
      <div className="mp-queue-detail-stack">
        <Panel id="enforcement-sanction" title="Sanction">
          <FactList facts={[{ label: 'Reason', value: detail.reason }, { label: 'Scope', value: detail.scope }, { label: 'Duration', value: detail.durationDays ? `${detail.durationDays} days` : 'Not time-limited' },
            { label: 'Restoration condition', value: detail.restorationCondition ?? 'None stated' }, { label: 'Continuation plan', value: detail.continuationPlan ? humanize(detail.continuationPlan) : 'Not yet recorded' },
            { label: 'Plan note', value: detail.continuationNote ?? '—' }, { label: 'Issued by role', value: detail.issuedRole ?? 'System' }, { label: 'Applied by role', value: detail.appliedRole ?? '—' },
            ...(detail.liftReason ? [{ label: 'Lift reason', value: detail.liftReason }] : [])]} />
        </Panel>
        {Boolean(detail.evidence?.length) && <Panel title="Proof attachments" description="Private supporting evidence retained with this decision."><PrivateEvidenceGallery apiBasePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} layout="thumbnails" items={detail.evidence.map(file => ({ id: file.id, label: file.name, loadUrl: () => getEnforcementEvidenceLink(detail.id, file.id) }))} /></Panel>}
        <Panel id="enforcement-history" title="History" description="Append-only; each entry has its actor, reason and correlation ID.">
          <EventTimeline label="Enforcement history" formatDate={manilaDateTime} events={detail.events.map((event, index) => ({ id: `${event.correlationId}-${index}`, title: `${humanize(event.event)} · ${humanize(event.fromState ?? 'NEW')} → ${humanize(event.toState)}`, at: event.occurredAt,
            actor: `${event.actor} (${event.actorRole})`, tone: event.event === 'APPLIED' ? 'error' : event.event === 'LIFTED' || event.event === 'EXPIRED' ? 'success' : 'neutral',
            detail: <><p>{event.reason}</p><p className="break-all text-[13px] text-text-secondary">Correlation ID {event.correlationId}</p></> }))} />
        </Panel>
      </div>
      <div className="mp-queue-detail-stack">
        <Panel id="enforcement-account" title="Account review" description="Account facts only: no contact details, coordinates, documents or payment data.">
          <FactList columns={1} facts={[{ label: 'Account', value: `${review.displayName}${review.maskedEmail ? ` · ${review.maskedEmail}` : ''}` }, { label: 'Account status', value: humanize(review.accountStatus) },
            ...(review.storeActivationStatus ? [{ label: 'Store activation', value: humanize(review.storeActivationStatus) }] : []), { label: 'Orders (open / total)', value: `${review.openOrders} / ${review.ordersTotal}` },
            { label: 'Disputes (open / total)', value: `${review.disputesOpen} / ${review.disputesTotal}` }]} />
        </Panel>
        {detail.allowedActions.length > 0 && <Panel id="enforcement-decision" title="Decision">
          {!mode ? <div className="flex flex-wrap gap-2">
            {detail.allowedActions.includes('APPLY') && <Button variant="danger" onClick={() => setMode('APPLY')}>Apply {detail.actionLabel}</Button>}
            {detail.allowedActions.includes('DECLINE') && <Button variant="secondary" onClick={() => setMode('DECLINE')}>Decline referral</Button>}
            {detail.allowedActions.includes('LIFT') && <Button variant="secondary" onClick={() => setMode('LIFT')}>Lift sanction</Button>}
          </div> : <ReasonedDecisionForm title={mode === 'APPLY' ? `Apply ${detail.actionLabel}` : mode === 'DECLINE' ? 'Decline referral' : 'Lift sanction'} target={`${detail.actionLabel} for ${detail.subjectName}`} version={detail.lockVersion}
            before={humanize(review.storeActivationStatus ?? review.accountStatus)} after={after} submitLabel={mode === 'APPLY' ? 'Apply' : mode === 'DECLINE' ? 'Decline' : 'Lift'} variant={mode === 'APPLY' ? 'danger' : 'primary'}
            busy={busy} error={error} conflict={conflict} onReload={onReload} minReason={10} maxReason={2000} onSubmit={reason => void decide(reason)}>
            {mode === 'APPLY' && <PlanFields plans={plans} openOrders={openOrders} plan={plan.plan} note={plan.note} error={fields.continuation_plan} onChange={(next, note) => setPlan({ plan: next, note })} />}
            <Button variant="quiet" className="w-fit" onClick={() => { setMode(null); setError(null); setConflict(null) }}>Cancel</Button>
          </ReasonedDecisionForm>}
        </Panel>}
      </div>
    </div>
    {dialog}
  </>
}
