import { ALL_DATES, Button, DateFilter, EventTimeline, FactList, FilterTabs, InfoNote, ReasonedDecisionForm, SearchInput, SidePanel, StatusBadge, Toolbar } from '@materyalph/web-ui'
import { ArrowLeft, Plus, RefreshCw, Search } from 'lucide-react'
import { useRef, useState, type FormEvent } from 'react'
import { Link, useNavigate, useParams, useSearchParams } from 'react-router-dom'
import { Pager, Panel } from '../components/OperationsKit'
import { control, label as humanize, labelClass, manilaDateTime, useLoad, useProtectedAction } from '../lib/operations-hooks'
import {
  applyEnforcement, declineEnforcement, getEnforcement, getSubject, isConflict, liftEnforcement, listEnforcement, newKey, problemText, recordEnforcement, searchSubjects,
  type EnforcementDetail, type EnforcementSubjectMatch, type EnforcementSummary,
} from '../lib/operations-api'
import { AdminShell, ErrorState, LoadingState, PageHeader } from './PhaseThreeAdminPages'
import { dateQuery } from '../lib/admin-format'

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

export function AdminEnforcementQueuePage({ subjectType, activeHref = '/enforcement' }: { subjectType?: SubjectType; activeHref?: string }) {
  const [searchParams] = useSearchParams()
  const [state, setState] = useState(searchParams.get('state') ?? 'REFERRED')
  const [source, setSource] = useState('')
  const [type, setType] = useState<string>(subjectType ?? '')
  const [page, setPage] = useState(1)
  const [recording, setRecording] = useState(false)
  const [range, setRange] = useState(ALL_DATES)
  const list = useLoad(() => listEnforcement({ ...(state ? { state: state as never } : {}), ...(source ? { source: source as never } : {}), ...(type ? { subjectType: type as never } : {}), ...dateQuery(range), page }), [state, source, type, range.from, range.to, page])
  const buyers = subjectType === 'BUYER'
  return <AdminShell activeHref={activeHref}><div className="space-y-6">
    <PageHeader eyebrow={buyers ? 'Marketplace' : 'Compliance & quality'} title={buyers ? 'Buyer Management' : 'Enforcement'} description={buyers ? 'Review Buyer accounts referred for enforcement and record graduated sanctions. Contact details, coordinates and payment data are never shown.' : 'Warnings, Temporary Restrictions, Suspensions and Permanent Bans for Buyers and Vendors, including dispute referrals. Every sanction records a reason and a continuation plan for open orders.'}
      actions={<><Button variant="secondary" disabled={list.loading} onClick={list.retry}><RefreshCw size={16} aria-hidden="true" />Refresh</Button><Button onClick={() => setRecording(true)}><Plus size={16} aria-hidden="true" />Record action</Button></>} />
    <InfoNote>Refunds always proceed regardless of sanctions. Lifting a Vendor sanction returns the store to its readiness state; it never re-activates a store directly.</InfoNote>
    <FilterTabs label="Enforcement state" value={state} onChange={value => { setState(value); setPage(1) }} chips={[{ value: 'REFERRED', label: 'Awaiting decision' }, { value: 'APPLIED', label: 'Applied' }, { value: 'EFFECTIVE', label: 'Warnings' }, { value: 'LIFTED', label: 'Lifted' }, { value: 'DECLINED', label: 'Declined' }, { value: '', label: 'All' }]} />
    <Toolbar filters={<>
      <DateFilter title="Enforcement recorded dates" value={range} onChange={value => { setRange(value); setPage(1) }} />
      {!subjectType && <label className="sr-only" htmlFor="enforcement-subject">Subject type</label>}
      {!subjectType && <select id="enforcement-subject" className={`${control} w-auto`} value={type} onChange={event => { setType(event.target.value); setPage(1) }}><option value="">Buyers and Vendors</option><option value="BUYER">Buyers</option><option value="VENDOR_ORGANIZATION">Vendors</option></select>}
      <label className="sr-only" htmlFor="enforcement-source">Source</label>
      <select id="enforcement-source" className={`${control} w-auto`} value={source} onChange={event => { setSource(event.target.value); setPage(1) }}><option value="">All sources</option><option value="DISPUTE_REFERRAL">Dispute referrals</option><option value="DIRECT">Direct Admin actions</option></select>
      {(state || source || range.from || range.to || (!subjectType && type)) && <Button variant="quiet" onClick={() => { setState(''); setSource(''); setType(subjectType ?? ''); setRange(ALL_DATES); setPage(1) }}>Reset filters</Button>}
    </>} />
    {list.error ? <ErrorState message={list.error} onRetry={list.retry} /> : !list.data ? <LoadingState /> : list.data.items.length === 0
      ? <p className="rounded-surface border border-dashed border-border-default bg-surface-primary px-6 py-10 text-center text-sm text-text-secondary">No enforcement records match this view.</p>
      : <EnforcementTable items={list.data.items} />}
    {list.data && <Pager page={page} lastPage={list.data.lastPage} total={list.data.total} busy={list.loading} onChange={setPage} />}
    {recording && <RecordActionPanel initialType={subjectType ?? 'BUYER'} lockType={Boolean(subjectType)} onClose={() => setRecording(false)} />}
  </div></AdminShell>
}

function EnforcementTable({ items }: { items: EnforcementSummary[] }) {
  return <div className="overflow-x-auto rounded-surface border border-border-default bg-surface-primary"><table className="w-full min-w-[880px] text-left text-sm">
    <caption className="sr-only">Enforcement records</caption>
    <thead className="bg-surface-canvas text-[13px] text-text-secondary"><tr>{['Subject', 'Action', 'State', 'Source', 'Recorded', 'Ends', ''].map(head => <th key={head} scope="col" className="px-4 py-3 font-semibold">{head || <span className="sr-only">Open</span>}</th>)}</tr></thead>
    <tbody className="divide-y divide-border-default">{items.map(item => <tr key={item.id}>
      <th scope="row" className="px-4 py-3 text-left font-normal"><p className="font-semibold">{item.subjectName}</p><p className="text-[13px] text-text-secondary">{subjectLabel(item.subjectType)}</p></th>
      <td className="px-4 py-3">{item.actionLabel}{item.durationDays ? <p className="text-[13px] text-text-secondary">{item.durationDays} days</p> : null}</td>
      <td className="px-4 py-3"><StatusBadge label={humanize(item.state)} tone={stateTone(item.state)} /></td>
      <td className="px-4 py-3">{item.source === 'DISPUTE_REFERRAL' ? <>Dispute referral{item.caseReference && <p className="text-[13px] text-text-secondary">{item.caseReference}</p>}</> : 'Direct'}</td>
      <td className="px-4 py-3">{manilaDateTime(item.createdAt)}</td>
      <td className="px-4 py-3">{item.expiresAt ? manilaDateTime(item.expiresAt) : '—'}</td>
      <td className="px-4 py-3 text-right"><Link className="inline-flex min-h-11 items-center font-semibold text-action-primary underline-offset-4 hover:underline" to={`/enforcement/${item.id}`} aria-label={`Open ${item.actionLabel} for ${item.subjectName}`}>Open</Link></td>
    </tr>)}</tbody>
  </table></div>
}

function RecordActionPanel({ initialType, lockType, onClose }: { initialType: SubjectType; lockType: boolean; onClose: () => void }) {
  const navigate = useNavigate()
  const [type, setType] = useState<SubjectType>(initialType)
  const [query, setQuery] = useState('')
  const [matches, setMatches] = useState<EnforcementSubjectMatch[] | null>(null)
  const [subjectId, setSubjectId] = useState('')
  const [action, setAction] = useState<(typeof ACTIONS)[number]>('WARNING')
  const [form, setForm] = useState({ scope: 'Marketplace activity', durationDays: '7', restoration: '', plan: '', note: '' })
  const [error, setError] = useState<string | null>(null)
  const [fields, setFields] = useState<Record<string, string>>({})
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
    const scope = JSON.stringify(input)
    if (key.current.scope !== scope) key.current = { scope, value: newKey() }
    const result = await run(action === 'PERMANENT_BAN' ? 'Verify to record a Permanent Ban' : 'Verify to record this sanction', () => recordEnforcement(input, key.current.value))
    if (result.ok) navigate(`/enforcement/${result.value.id}`)
    else { setFields(result.problem.fields); setError(problemText(result.problem)) }
  }
  const selected = matches?.find(match => match.id === subjectId)
  return <SidePanel open title="Record enforcement action" description="Search by exact Buyer email or Vendor store name. The subject is told the action, reason and restoration path." onClose={onClose}>
    <div className="grid gap-5">
      <form role="search" onSubmit={event => void search(event)} className="grid gap-3">
        {!lockType && <label className={labelClass}>Subject type<select className={control} value={type} onChange={event => { setType(event.target.value as SubjectType); setMatches(null); setSubjectId('') }}><option value="BUYER">Buyer</option><option value="VENDOR_ORGANIZATION">Vendor</option></select></label>}
        <div className={labelClass}><span>{type === 'BUYER' ? 'Exact Buyer email' : 'Store or registered name'}</span><div className="flex min-w-0 flex-wrap gap-2"><SearchInput label={type === 'BUYER' ? 'Exact Buyer email' : 'Store or registered name'} value={query} minLength={type === 'BUYER' ? 5 : 2} required type={type === 'BUYER' ? 'email' : 'search'} onChange={setQuery} className="flex-1 basis-48" /><Button type="submit" variant="secondary" disabled={busy}><Search size={16} aria-hidden="true" />Find</Button></div></div>
      </form>
      {matches && (matches.length === 0 ? <p className="text-sm text-text-secondary">No matching account. Buyer search needs the exact email address.</p>
        : <fieldset className="grid gap-2"><legend className="text-sm font-semibold">Select the subject</legend>{matches.map(match => <label key={match.id} className={`flex min-h-11 items-center gap-3 rounded-control border px-3 py-2 text-sm ${match.id === subjectId ? 'border-action-primary bg-brand-orange-50' : 'border-border-default'}`}><input type="radio" name="subject" checked={match.id === subjectId} onChange={() => setSubjectId(match.id)} /><span className="min-w-0 flex-1"><span className="font-semibold">{match.displayName}</span> · {humanize(match.status)}</span></label>)}</fieldset>)}
      {subjectId && (subject.error ? <ErrorState message={subject.error} onRetry={subject.retry} /> : !subject.data ? <LoadingState /> : <>
        <FactList facts={[{ label: 'Account status', value: humanize(subject.data.accountStatus) }, ...(subject.data.storeActivationStatus ? [{ label: 'Store activation', value: humanize(subject.data.storeActivationStatus) }] : []),
          { label: 'Open orders', value: subject.data.openOrders }, { label: 'Disputes (open / total)', value: `${subject.data.disputesOpen} / ${subject.data.disputesTotal}` },
          ...(subject.data.commerceRestrictedUntil ? [{ label: 'Commerce restricted until', value: manilaDateTime(subject.data.commerceRestrictedUntil) }] : [])]} />
        <ReasonedDecisionForm title="Sanction" target={`${selected?.displayName ?? subject.data.displayName} (${subjectLabel(type)})`} before={humanize(subject.data.storeActivationStatus ?? subject.data.accountStatus)} after={ACTION_EFFECT[action]?.[type]}
          submitLabel={action === 'WARNING' ? 'Record warning' : 'Apply sanction'} variant={action === 'WARNING' ? 'primary' : 'danger'} busy={busy} error={error} minReason={10} maxReason={2000} onSubmit={reason => void submit(reason)}>
          <label className={labelClass}>Action<select className={control} value={action} onChange={event => setAction(event.target.value as (typeof ACTIONS)[number])}>{ACTIONS.map(item => <option key={item} value={item}>{humanize(item)}</option>)}</select></label>
          <label className={labelClass}>Scope<input className={control} maxLength={160} value={form.scope} onChange={event => setForm({ ...form, scope: event.target.value })} /></label>
          {action === 'TEMPORARY_RESTRICTION' && <label className={labelClass}>Duration (days)<input className={control} type="number" min={1} max={365} value={form.durationDays} onChange={event => setForm({ ...form, durationDays: event.target.value })} aria-invalid={Boolean(fields.duration_days)} />{fields.duration_days && <span role="alert" className="text-sm font-normal text-status-error">{fields.duration_days}</span>}</label>}
          {(action === 'TEMPORARY_RESTRICTION' || action === 'SUSPENSION') && <label className={labelClass}>Restoration condition<textarea className={`${control} min-h-20 py-2`} maxLength={2000} value={form.restoration} onChange={event => setForm({ ...form, restoration: event.target.value })} aria-invalid={Boolean(fields.restoration_condition)} />{fields.restoration_condition && <span role="alert" className="text-sm font-normal text-status-error">{fields.restoration_condition}</span>}</label>}
          {action !== 'WARNING' && <PlanFields plans={plans} openOrders={openOrders} plan={form.plan} note={form.note} error={fields.continuation_plan} onChange={(plan, note) => setForm({ ...form, plan, note })} />}
        </ReasonedDecisionForm>
      </>)}
      {error && !subjectId && <p role="alert" className="text-sm text-status-error">{error}</p>}
    </div>
    {dialog}
  </SidePanel>
}

function PlanFields({ plans, openOrders, plan, note, error, onChange }: { plans: readonly string[]; openOrders: number; plan: string; note: string; error?: string | undefined; onChange: (plan: string, note: string) => void }) {
  return <fieldset className="grid gap-2">
    <legend className="text-sm font-semibold">Continuation plan for existing orders ({openOrders} open)</legend>
    {plans.map(item => <label key={item} className="flex min-h-11 items-start gap-3 rounded-control border border-border-default px-3 py-2 text-sm"><input type="radio" name="continuation-plan" className="mt-1" checked={plan === item} onChange={() => onChange(item, note)} /><span><span className="font-semibold">{humanize(item)}</span><span className="block text-text-secondary">{PLAN_HELP[item]}</span></span></label>)}
    {error && <span role="alert" className="text-sm text-status-error">{error}</span>}
    <label className={labelClass}>Plan note (optional)<textarea className={`${control} min-h-16 py-2`} maxLength={2000} value={note} onChange={event => onChange(plan, event.target.value)} /></label>
  </fieldset>
}

export function AdminEnforcementDetailPage() {
  const { actionId = '' } = useParams()
  const detail = useLoad(() => getEnforcement(actionId), [actionId])
  const backHref = '/enforcement'
  return <AdminShell activeHref={backHref}><div className="space-y-6">
    <Link to={backHref} className="inline-flex min-h-11 items-center gap-2 text-sm font-semibold text-action-primary"><ArrowLeft size={16} aria-hidden="true" />Back to Enforcement</Link>
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
    <div className="grid items-start gap-5 xl:grid-cols-[minmax(0,1.3fr)_minmax(0,1fr)]">
      <div className="grid min-w-0 gap-5">
        <Panel title="Sanction">
          <FactList facts={[{ label: 'Reason', value: detail.reason }, { label: 'Scope', value: detail.scope }, { label: 'Duration', value: detail.durationDays ? `${detail.durationDays} days` : 'Not time-limited' },
            { label: 'Restoration condition', value: detail.restorationCondition ?? 'None stated' }, { label: 'Continuation plan', value: detail.continuationPlan ? humanize(detail.continuationPlan) : 'Not yet recorded' },
            { label: 'Plan note', value: detail.continuationNote ?? '—' }, { label: 'Issued by role', value: detail.issuedRole ?? 'System' }, { label: 'Applied by role', value: detail.appliedRole ?? '—' },
            ...(detail.liftReason ? [{ label: 'Lift reason', value: detail.liftReason }] : [])]} />
        </Panel>
        <Panel title="History" description="Append-only; each entry has its actor, reason and correlation ID.">
          <EventTimeline label="Enforcement history" formatDate={manilaDateTime} events={detail.events.map((event, index) => ({ id: `${event.correlationId}-${index}`, title: `${humanize(event.event)} · ${humanize(event.fromState ?? 'NEW')} → ${humanize(event.toState)}`, at: event.occurredAt,
            actor: `${event.actor} (${event.actorRole})`, tone: event.event === 'APPLIED' ? 'error' : event.event === 'LIFTED' || event.event === 'EXPIRED' ? 'success' : 'neutral',
            detail: <><p>{event.reason}</p><p className="break-all text-[13px] text-text-secondary">Correlation ID {event.correlationId}</p></> }))} />
        </Panel>
      </div>
      <div className="grid min-w-0 gap-5">
        <Panel title="Account review" description="Account facts only: no contact details, coordinates, documents or payment data.">
          <FactList columns={1} facts={[{ label: 'Account', value: `${review.displayName}${review.maskedEmail ? ` · ${review.maskedEmail}` : ''}` }, { label: 'Account status', value: humanize(review.accountStatus) },
            ...(review.storeActivationStatus ? [{ label: 'Store activation', value: humanize(review.storeActivationStatus) }] : []), { label: 'Orders (open / total)', value: `${review.openOrders} / ${review.ordersTotal}` },
            { label: 'Disputes (open / total)', value: `${review.disputesOpen} / ${review.disputesTotal}` }]} />
        </Panel>
        {detail.allowedActions.length > 0 && <Panel title="Decision">
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
