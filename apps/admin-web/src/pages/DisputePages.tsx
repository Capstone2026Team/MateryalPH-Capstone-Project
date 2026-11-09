import { BackNavigation } from '@materyalph/web-ui'
import { useCallback, useEffect, useRef, useState, type ReactNode } from 'react'
import { Link, useParams, useSearchParams } from 'react-router-dom'
import { Gavel, Info, RefreshCw, Scale, ShieldAlert, UserRoundCheck } from 'lucide-react'
import {
  dateRangePatch, Button, ConfirmDialog, DateFilter, DisputeDeadlines, DisputeStatusBadge, DisputeTimeline, FilterPanel, FilterTabs, InfoNote, OriginalPaymentMethodNotice, QueueSectionLinks, QueueSurface, useQueueStatusCounts, RefundTimeline, ResponsiveRecordList, StatusMessage, type RecordColumn,
  DisputeComplaintDetails, disputeIssueLabel, disputeRemedyLabel, disputeRoleLabel, formatManilaDateTime, formatPesoCentavos,
} from '@materyalph/web-ui'
import {
  adminApiBasePath, assignToMe, confirmRemedy, decide, decideAppeal, escalateCase, getCase, listQueue, newKey, requestClarification,
  type DecisionInput, type DisputeDetail, type DisputeSanctionInput, type DisputeSummary, type QueueStatus,
} from '../lib/disputes-api'
import { readableVerificationError } from '../lib/vendor-verification-api'
import { AdminShell, ErrorState, LoadingState, PageHeader } from './PhaseThreeAdminPages'
import { Pager } from '../components/OperationsKit'
import { useAdminQueue, useQueueParams } from '../lib/use-admin-queue'

const control = 'min-h-12 w-full min-w-0 rounded-control border border-border-default bg-surface-primary px-3 text-base font-normal'
const STATUSES: { value: QueueStatus; label: string }[] = [
  { value: 'NEEDS_ADMIN', label: 'Needs Admin' }, { value: 'WITH_PARTIES', label: 'With the parties' }, { value: 'REMEDY_TRACKING', label: 'Remedy tracking' }, { value: 'CONCLUDED', label: 'Concluded' },
]
const SANCTION_LABELS: Record<string, string> = { WARNING: 'Warning', TEMPORARY_RESTRICTION: 'Temporary restriction', SUSPENSION: 'Suspension', PERMANENT_BAN: 'Permanent ban' }
const METRIC_LABELS: Record<string, string> = { VALIDATED_DEFECT_RETURN: 'Validated defect return', VENDOR_NON_FULFILLMENT: 'Vendor-caused non-fulfillment', MISREPRESENTED_LISTING: 'Misrepresented listing' }
const peso = (value: string): number | null => { const text = value.trim().replaceAll(',', ''); if (!/^\d{1,11}(\.\d{1,2})?$/.test(text)) return null; const [whole, fraction = ''] = text.split('.'); return Number(whole) * 100 + Number(fraction.padEnd(2, '0')) }

/** Dispute and Appeal Queue for Order and Dispute Staff: deadlines, handler, requested remedy and refund state. */
export function AdminDisputeQueuePage() {
  const { params, page, range, change, setPage, context } = useQueueParams()
  const status = (STATUSES.some(item => item.value === params.get('status')) ? params.get('status') : 'NEEDS_ADMIN') as QueueStatus
  const queue = useAdminQueue(`disputes:${JSON.stringify([status, page, range.from, range.to])}`, () => listQueue(status, page, range))
  const rows = queue.data?.items ?? [], meta = queue.data?.meta
  const counts = useQueueStatusCounts(meta?.counts, Boolean(queue.error))
  const total = typeof meta?.total === 'number' ? meta.total : null
  const lastPage = Math.max(1, Math.ceil((total ?? 0) / (meta?.perPage ?? 25)), meta?.hasMore ? page + 1 : 1)
  const href = (id: string) => `/disputes/${id}${context}`
  const identity = (row: DisputeSummary) => <span className="grid min-w-0 gap-0.5"><Link to={href(row.id)} className="inline-flex min-h-11 items-center font-semibold text-action-primary underline-offset-4 hover:underline">{row.reference}</Link><span className="text-xs text-text-secondary">Order {row.orderReference}</span><span className="text-xs text-text-secondary">{row.buyerName ?? 'Buyer'} v. {row.vendorName}</span></span>
  const columns: RecordColumn<DisputeSummary>[] = [
    { key: 'case', header: 'Case · parties', cell: identity },
    { key: 'issue', header: 'Issue · requested remedy', cell: row => <span className="grid gap-0.5"><span className="font-semibold">{disputeIssueLabel(row.issueType)}</span><span className="text-xs text-text-secondary">{disputeRemedyLabel(row.requestedRemedy)}{row.requestedAmountCentavos ? ` · ${formatPesoCentavos(row.requestedAmountCentavos)}` : ''}</span></span> },
    { key: 'status', header: 'Status · handler', cell: row => <span className="grid justify-items-start gap-1"><DisputeStatusBadge status={row.status} /><span className="text-xs text-text-secondary">{row.assignedToAdmin ? 'Assigned to Admin' : 'Unassigned'}</span></span> },
    { key: 'deadline', header: 'Next deadline', cell: row => row.nextDeadline ? <span className="grid gap-0.5"><span className="font-medium">{row.nextDeadline.kind.replaceAll('_', ' ').toLowerCase()}</span><span className="text-xs text-text-secondary">{row.nextDeadline.label}</span></span> : <span className="text-text-secondary">No open deadline</span> },
    { key: 'refund', header: 'Refund', cell: row => <span className="text-xs text-text-secondary">{row.refundState === 'NOT_REQUESTED' ? 'None' : row.refundState.replaceAll('_', ' ').toLowerCase()}</span> },
    { key: 'action', header: 'Action', cell: row => <Link to={href(row.id)} className="inline-flex min-h-11 items-center justify-center rounded-control border border-border-default bg-surface-primary px-4 text-sm font-semibold hover:bg-surface-canvas">Review case</Link> },
  ]
  return <AdminShell activeHref="/disputes"><div className="mp-queue-workspace">
    <PageHeader eyebrow="Compliance & quality" title="Disputes & Appeals" description="Review escalated cases, decide appeals and follow remedies through completion."
      actions={<Button variant="secondary" disabled={queue.loading} onClick={() => void queue.retry()}><RefreshCw size={16} aria-hidden="true" />{queue.loading && queue.data ? 'Refreshing…' : 'Refresh'}</Button>} />

    <InfoNote>Check both parties’ evidence, request clarification when needed and record a reasoned decision with a conflict check. Refunds return only to the original payment; Admins never hold or disburse money.</InfoNote>
    <FilterTabs appearance="chips" label="Case queue" value={status} onChange={value => change({ status: value })} chips={STATUSES.map(item => ({ value: item.value, label: item.label, count: counts[item.value] }))} />
    <FilterPanel compact label="Case filters" footer={<div className="mp-filter-date"><span>Case opened dates</span><DateFilter title="Case opened dates" value={range} onChange={value => change(dateRangePatch(value))} /></div>} />
    <QueueSurface title={STATUSES.find(item => item.value === status)!.label} description="Review the case, requested remedy, assigned handler and next deadline before recording a decision." count={total} shown={rows.length} loaded={Boolean(queue.data)} busy={queue.loading} error={queue.error && <ErrorState message={queue.error} onRetry={queue.retry} />} emptyTitle={page > 1 ? 'No cases on this page.' : 'No cases in this queue.'} emptyDescription="No cases match this queue and case-opened period. Choose another queue or adjust the dates." emptyAction={page > 1 ? <Button variant="secondary" onClick={() => setPage(1)}>Return to first page</Button> : undefined}
      footer={queue.data && (page > 1 || lastPage > 1) && <Pager page={page} lastPage={lastPage} total={meta?.total} busy={queue.loading} onChange={setPage} />}>
      <ResponsiveRecordList compact tableClassName="mp-queue-record-table" caption="Admin dispute and appeal cases" rows={rows} columns={columns} rowKey={row => row.id} cardTitle={identity} />
    </QueueSurface>
  </div></AdminShell>
}

type Changed = (detail: DisputeDetail, text: string) => void

/** One case: chronological timeline, decision support and the decision, clarification and appeal forms. */
export function AdminDisputeCasePage() {
  const { caseId = '' } = useParams()
  return <DisputeCase key={caseId} caseId={caseId} />
}

function DisputeCase({ caseId }: { caseId: string }) {
  const [params] = useSearchParams()
  const [detail, setDetail] = useState<DisputeDetail | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [notice, setNotice] = useState<string | null>(null)
  const [assignBusy, setAssignBusy] = useState(false)
  const [assignError, setAssignError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  const reload = useCallback(() => setAttempt(value => value + 1), [])
  useEffect(() => {
    let active = true
    setError(null)
    getCase(caseId).then(value => { if (active) setDetail(value) }).catch(async cause => { const text = await readableVerificationError(cause); if (active) setError(text) })
    return () => { active = false }
  }, [caseId, attempt])
  const changed: Changed = (next, text) => { setDetail(next); setNotice(text); window.scrollTo({ top: 0, behavior: window.matchMedia?.('(prefers-reduced-motion: reduce)').matches ? 'auto' : 'smooth' }) }
  const back = <BackNavigation><Link to={`/disputes${params.size ? `?${params.toString()}` : ''}`}>Case queue</Link></BackNavigation>
  if (error) return <AdminShell activeHref="/disputes"><div className="grid gap-4">{back}<ErrorState message={error} onRetry={reload} /></div></AdminShell>
  if (!detail) return <AdminShell activeHref="/disputes"><div className="grid gap-4">{back}<LoadingState /></div></AdminShell>
  const actions = new Set(detail.availableActions)
  const admin = detail.admin
  return <AdminShell activeHref="/disputes"><div className="mp-queue-workspace">
    {back}
    <PageHeader compact eyebrow={`${disputeIssueLabel(detail.issueType)} · ${detail.caseKind === 'POST_COMPLETION_RETURN' ? 'post-completion return' : 'transaction case'}`} title={detail.reference}
      description={`Order ${detail.order.reference} · ${admin?.buyer.displayName ?? 'Buyer'} v. ${admin?.vendor.displayName ?? 'Store'} · requested ${disputeRemedyLabel(detail.requestedRemedy).toLowerCase()}${detail.requestedAmountCentavos ? ` (${formatPesoCentavos(detail.requestedAmountCentavos)})` : ''}`}
      actions={<><DisputeStatusBadge status={detail.status} />{actions.has('ASSIGN_TO_ME') && <Button variant="secondary" disabled={assignBusy} aria-busy={assignBusy} onClick={() => {
        if (assignBusy) return
        setAssignBusy(true); setAssignError(null)
        void assignToMe(detail.id).then(next => changed(next, 'The case is assigned to you.')).catch(async cause => setAssignError(await readableVerificationError(cause))).finally(() => setAssignBusy(false))
      }}><UserRoundCheck size={16} aria-hidden="true" />{assignBusy ? 'Assigning…' : 'Assign to me'}</Button>}
        <Button variant="secondary" onClick={reload}><RefreshCw size={16} aria-hidden="true" />Refresh</Button></>} />
    {notice && <StatusMessage tone="success">{notice}</StatusMessage>}
    {assignError && <StatusMessage tone="error">{assignError}</StatusMessage>}
    <QueueSectionLinks links={[{ href: '#complaint-heading', label: 'Complaint & evidence' }, { href: '#admin-timeline-heading', label: 'Timeline' }, ...(detail.decisions.length ? [{ href: '#admin-decisions-heading', label: 'Decisions' }] : []), ...(detail.refunds.length || detail.remedies.length ? [{ href: '#admin-remedies-heading', label: 'Remedies' }] : []), { href: '#dispute-actions', label: 'Review actions' }]} />
    <DisputeDeadlines deadlines={detail.deadlines} onExpire={reload} />
    <section className="flex min-w-0 flex-wrap items-center justify-between gap-3 mp-card mp-card-padded" aria-label="Linked order">
      <div><h2 className="font-semibold">Order {detail.order.reference}</h2><p className="mt-1 text-sm text-text-secondary">Review all order items, recorded payments, fulfillment evidence, cancellation, refunds and status history before assessing this case.</p></div>
      <Link className="inline-flex min-h-11 items-center rounded-control border border-border-default px-4 text-sm font-semibold text-action-primary hover:underline" to={`/audit/orders/${detail.order.id}?${new URLSearchParams({ ...Object.fromEntries(params), caseId: detail.id })}`}>View full order · read only</Link>
    </section>
    <div className="mp-queue-detail-columns">
      <div className="mp-queue-detail-stack">
        <section aria-labelledby="complaint-heading" className="grid gap-3 mp-card mp-card-padded">
          <h2 id="complaint-heading" className="text-lg font-semibold">Original complaint</h2>
          <DisputeComplaintDetails detail={detail} />
          {detail.affectedLines.length > 0 && <ul className="grid gap-1 text-sm">{detail.affectedLines.map(line => <li key={line.orderLineId} className="flex flex-wrap justify-between gap-x-3"><span>{line.displayName}</span>
            <span className="tabular-nums text-text-secondary">{formatPesoCentavos(line.lineTotalCentavos)} · {formatPesoCentavos(line.refundableCentavos)} still refundable</span></li>)}</ul>}
          {detail.originalPaymentMethod && <OriginalPaymentMethodNotice label={detail.originalPaymentMethod.label} notice={detail.originalPaymentMethod.notice} />}
        </section>
        <section aria-labelledby="admin-timeline-heading" className="grid gap-4 mp-card mp-card-padded">
          <h2 id="admin-timeline-heading" className="text-lg font-semibold">Case timeline</h2>
          <DisputeTimeline entries={detail.timeline} apiBasePath={adminApiBasePath} onLinkExpired={reload} />
        </section>
        {detail.decisions.length > 0 && <section aria-labelledby="admin-decisions-heading" className="grid gap-3 mp-card mp-card-padded">
          <h2 id="admin-decisions-heading" className="flex items-center gap-2 text-lg font-semibold"><Gavel size={18} aria-hidden="true" />Decisions (immutable)</h2>
          <ul className="grid gap-3">{detail.decisions.map(decision => <li key={decision.id} className={`grid gap-1 border-l-4 pl-3 ${decision.current ? 'border-action-primary' : 'border-border-default'}`}>
            <p className="font-semibold">v{decision.version} · {decision.kind.replaceAll('_', ' ').toLowerCase()} · {disputeRemedyLabel(decision.outcome)}{decision.awardedCentavos ? ` · ${formatPesoCentavos(decision.awardedCentavos)}` : ''}{decision.appealResult ? ` · ${decision.appealResult.toLowerCase()}` : ''}</p>
            <p className="text-xs text-text-secondary">{decision.deciderName ?? disputeRoleLabel(decision.deciderRole)}{decision.decidedAt ? ` · ${formatManilaDateTime(decision.decidedAt)}` : ''}{decision.enforceable ? ' · immediately enforceable' : ''}</p>
            {decision.reason && <p className="text-sm">{decision.reason}</p>}
            {decision.evidenceLimitation && <p className="text-sm text-text-secondary">Evidence limitation: {decision.evidenceLimitation}</p>}
          </li>)}</ul>
        </section>}
        {(detail.refunds.length > 0 || detail.remedies.length > 0) && <section aria-labelledby="admin-remedies-heading" className="grid gap-3 mp-card mp-card-padded">
          <h2 id="admin-remedies-heading" className="text-lg font-semibold">Remedies</h2>
          <ul className="grid gap-2 text-sm">{detail.remedies.map(remedy => <li key={remedy.id} className="flex flex-wrap items-center justify-between gap-2 rounded-control border border-border-default p-3">
            <span><strong>{remedy.kind.replaceAll('_', ' ').toLowerCase()}</strong>{remedy.amountCentavos ? ` · ${formatPesoCentavos(remedy.amountCentavos)}` : ''} · {remedy.state.toLowerCase()}{remedy.note ? ` — ${remedy.note}` : ''}</span>
            {remedy.canConfirm && <ConfirmRemedy caseId={detail.id} remedyId={remedy.id} onChanged={changed} />}
          </li>)}</ul>
          {detail.refunds.length > 0 && <RefundTimeline timeline={{ refunds: detail.refunds, reimbursements: detail.reimbursements ?? [], noLongerDueCentavos: 0 }} audience="ADMIN" />}
        </section>}
      </div>
      <aside id="dispute-actions" className="mp-queue-detail-stack" aria-label="Review actions">
        {admin && <section className="grid gap-2 mp-card mp-card-padded text-sm" aria-label="Decision support">
          <h2 className="flex items-center gap-2 text-base font-semibold"><Info size={16} aria-hidden="true" />Decision support</h2>
          <p>Refundable now: <strong className="tabular-nums">{formatPesoCentavos(admin.refundable.onlineCentavos)}</strong> online{admin.refundable.cashCentavos > 0 ? <>, <strong className="tabular-nums">{formatPesoCentavos(admin.refundable.cashCentavos)}</strong> cash by Vendor reimbursement</> : ''}.</p>
          {admin.alreadyAwardedCentavos > 0 && <p>Already awarded in this case: <strong className="tabular-nums">{formatPesoCentavos(admin.alreadyAwardedCentavos)}</strong>. A new award pays only the difference.</p>}
          <p>Prior cases: Buyer {admin.buyer.priorCases} · Store {admin.vendor.priorCases}</p>
        </section>}
        {actions.has('DECIDE') && <DecisionForm detail={detail} mode="DECISION" onChanged={changed} />}
        {actions.has('DECIDE_APPEAL') && <DecisionForm detail={detail} mode="APPEAL" onChanged={changed} />}
        {actions.has('REQUEST_CLARIFICATION') && <ClarificationForm caseId={detail.id} onChanged={changed} />}
        {actions.has('ESCALATE') && <EscalateForm caseId={detail.id} onChanged={changed} />}
        {actions.size === 0 && <p className="mp-card mp-card-padded text-sm text-text-secondary">No review action is available for this case state or your role.</p>}
      </aside>
    </div>
  </div></AdminShell>
}

function Card({ title, icon, children }: { title: string; icon: ReactNode; children: ReactNode }) {
  return <section className="grid gap-3 mp-card mp-card-padded" aria-label={title}><h2 className="flex items-center gap-2 text-base font-semibold">{icon}{title}</h2>{children}</section>
}

type SanctionDraft = { subject: 'BUYER' | 'VENDOR'; action: string; reason: string; durationDays: string; restorationCondition: string }

function DecisionForm({ detail, mode, onChanged }: { detail: DisputeDetail; mode: 'DECISION' | 'APPEAL'; onChanged: Changed }) {
  const admin = detail.admin
  const conflictBlocked = mode === 'APPEAL' && Boolean(admin?.appealReviewerConflict)
  const [result, setResult] = useState('AFFIRMED')
  const [outcome, setOutcome] = useState('PARTIAL_REFUND')
  const [amount, setAmount] = useState('')
  const [lines, setLines] = useState<string[]>(() => detail.affectedLines.map(line => line.orderLineId))
  const [reason, setReason] = useState('')
  const [enforceable, setEnforceable] = useState(false)
  const [limitation, setLimitation] = useState('')
  const [metric, setMetric] = useState('')
  const [sanctions, setSanctions] = useState<SanctionDraft[]>([])
  const [conflict, setConflict] = useState(false)
  const [errors, setErrors] = useState<Record<string, string>>({})
  const [confirming, setConfirming] = useState(false)
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<string | null>(null)
  const key = useRef(newKey())
  const needsOutcome = mode === 'DECISION' || result !== 'AFFIRMED'
  function validate(): DecisionInput | null {
    const local: Record<string, string> = {}
    const centavos = outcome === 'PARTIAL_REFUND' && needsOutcome ? peso(amount) : null
    if (needsOutcome && outcome === 'PARTIAL_REFUND' && !centavos) local.amount = 'Enter the awarded amount.'
    if (needsOutcome && outcome === 'PARTIAL_REFUND' && lines.length === 0) local.lines = 'Select the affected lines.'
    if (reason.trim().length < 20) local.reason = 'Give the reason in at least 20 characters.'
    if (mode === 'DECISION' && admin?.unansweredClarification && limitation.trim().length === 0) local.limitation = 'Record how the unanswered clarification limits the evidence.'
    sanctions.forEach((sanction, index) => {
      if (sanction.reason.trim().length < 10) local[`sanction-${index}`] = 'Each sanction needs a reason of at least 10 characters.'
      else if (sanction.action === 'TEMPORARY_RESTRICTION' && !(Number(sanction.durationDays) > 0)) local[`sanction-${index}`] = 'Enter the restriction duration in days.'
      else if (['TEMPORARY_RESTRICTION', 'SUSPENSION'].includes(sanction.action) && !sanction.restorationCondition.trim()) local[`sanction-${index}`] = 'State the restoration condition.'
    })
    if (!conflict) local.conflict = 'Confirm the conflict-of-interest check.'
    setErrors(local)
    if (Object.keys(local).length) return null
    return { outcome, reason: reason.trim(), ...(centavos ? { amountCentavos: centavos } : {}), affectedLineIds: outcome === 'PARTIAL_REFUND' ? lines : [], enforceable, conflictCheckConfirmed: conflict,
      ...(limitation.trim() ? { evidenceLimitation: limitation.trim() } : {}), ...(metric ? { metricEvent: metric } : {}), lockVersion: detail.lockVersion,
      sanctions: sanctions.map((sanction): DisputeSanctionInput => ({ subject: sanction.subject, action: sanction.action as DisputeSanctionInput['action'], reason: sanction.reason.trim(),
        ...(sanction.durationDays ? { durationDays: Number(sanction.durationDays) } : {}), ...(sanction.restorationCondition.trim() ? { restorationCondition: sanction.restorationCondition.trim() } : {}) })) }
  }
  async function submit() {
    const input = validate()
    if (!input) { setConfirming(false); return }
    setBusy(true); setMessage(null)
    try {
      const next = mode === 'APPEAL' ? await decideAppeal(detail.id, { ...input, result }, key.current) : await decide(detail.id, input, key.current)
      key.current = newKey(); setConfirming(false)
      onChanged(next, mode === 'APPEAL' ? 'Appeal decided. The decision is final and its remedy is being carried out.' : enforceable ? 'Decision issued and its remedy started.' : 'Decision issued. It becomes final when the five-business-day appeal window lapses unappealed.')
    } catch (cause) { key.current = newKey(); setConfirming(false); setMessage(await readableVerificationError(cause)) } finally { setBusy(false) }
  }
  const outcomes = (admin?.outcomes ?? []).filter(code => code !== 'NO_FURTHER_ACTION')
  return <Card title={mode === 'APPEAL' ? 'Decide the appeal' : 'Decision'} icon={<Gavel size={16} aria-hidden="true" />}>
    {conflictBlocked && <StatusMessage tone="error">You made the appealed decision. Another Order and Dispute Staff member or a Super Admin must review this appeal.</StatusMessage>}
    {message && <StatusMessage tone="error">{message}</StatusMessage>}
    <form className="grid gap-4" noValidate onSubmit={event => { event.preventDefault(); if (validate()) setConfirming(true) }}>
      {mode === 'APPEAL' && <fieldset className="grid gap-2"><legend className="text-sm font-semibold">Appeal result</legend>{['AFFIRMED', 'MODIFIED', 'REVERSED'].map(value => <label key={value} className="flex min-h-11 items-center gap-3 text-sm">
        <input type="radio" name="appeal-result" className="h-5 w-5 accent-action-primary" checked={result === value} onChange={() => setResult(value)} />{value.charAt(0) + value.slice(1).toLowerCase()}</label>)}</fieldset>}
      {needsOutcome && <label className="grid gap-2 text-sm font-semibold">Remedy (required)<select className={control} value={outcome} onChange={event => setOutcome(event.target.value)}>{outcomes.map(code => <option key={code} value={code}>{disputeRemedyLabel(code)}</option>)}</select></label>}
      {needsOutcome && outcome === 'PARTIAL_REFUND' && <>
        <label className="grid gap-2 text-sm font-semibold">Awarded amount (₱, case total)<input className={control} inputMode="decimal" value={amount} placeholder="0.00" aria-invalid={Boolean(errors.amount)} onChange={event => setAmount(event.target.value)} /></label>
        {errors.amount && <p role="alert" className="text-sm text-status-error">{errors.amount}</p>}
        <fieldset className="grid gap-1"><legend className="text-sm font-semibold">Affected lines</legend>{detail.affectedLines.map(line => <label key={line.orderLineId} className="flex min-h-11 items-center gap-3 text-sm">
          <input type="checkbox" className="h-5 w-5 accent-action-primary" checked={lines.includes(line.orderLineId)} onChange={event => setLines(current => event.target.checked ? [...current, line.orderLineId] : current.filter(id => id !== line.orderLineId))} />
          {line.displayName} · up to {formatPesoCentavos(line.refundableCentavos)}</label>)}</fieldset>
        {errors.lines && <p role="alert" className="text-sm text-status-error">{errors.lines}</p>}
      </>}
      <label className="grid gap-2 text-sm font-semibold">Reason (required)<textarea className={`${control} min-h-28 py-2`} maxLength={4000} value={reason} aria-invalid={Boolean(errors.reason)} onChange={event => setReason(event.target.value)} /></label>
      {errors.reason && <p role="alert" className="text-sm text-status-error">{errors.reason}</p>}
      {mode === 'DECISION' && admin?.unansweredClarification && <>
        <label className="grid gap-2 text-sm font-semibold">Evidence limitation (required — a clarification went unanswered)<textarea className={`${control} min-h-20 py-2`} maxLength={2000} value={limitation} onChange={event => setLimitation(event.target.value)} /></label>
        {errors.limitation && <p role="alert" className="text-sm text-status-error">{errors.limitation}</p>}
      </>}
      <label className="grid gap-2 text-sm font-semibold">Confirmed metric event (optional)<select className={control} value={metric} onChange={event => setMetric(event.target.value)}><option value="">None</option>{(admin?.metricEvents ?? []).map(code => <option key={code} value={code}>{METRIC_LABELS[code] ?? code}</option>)}</select>
        <span className="text-xs font-normal text-text-secondary">Scores are recalculated from confirmed events; there is no manual score change.</span></label>
      <fieldset className="grid gap-3"><legend className="text-sm font-semibold">Sanctions (optional)</legend>
        <p className="text-xs text-text-secondary">A warning takes effect when the decision is final. Restriction, suspension and ban are recorded and referred to User Management Staff.</p>
        {sanctions.map((sanction, index) => <div key={index} className="grid gap-2 rounded-control border border-border-default p-3">
          <div className="grid gap-2 sm:grid-cols-2">
            <label className="grid gap-1 text-sm font-semibold">Subject<select className={control} value={sanction.subject} onChange={event => setSanctions(current => current.map((row, i) => i === index ? { ...row, subject: event.target.value as 'BUYER' | 'VENDOR' } : row))}><option value="VENDOR">Store</option><option value="BUYER">Buyer</option></select></label>
            <label className="grid gap-1 text-sm font-semibold">Action<select className={control} value={sanction.action} onChange={event => setSanctions(current => current.map((row, i) => i === index ? { ...row, action: event.target.value } : row))}>{Object.entries(SANCTION_LABELS).map(([value, text]) => <option key={value} value={value}>{text}</option>)}</select></label>
          </div>
          <label className="grid gap-1 text-sm font-semibold">Reason<input className={control} maxLength={1000} value={sanction.reason} onChange={event => setSanctions(current => current.map((row, i) => i === index ? { ...row, reason: event.target.value } : row))} /></label>
          {sanction.action === 'TEMPORARY_RESTRICTION' && <label className="grid gap-1 text-sm font-semibold">Duration (days)<input className={control} inputMode="numeric" value={sanction.durationDays} onChange={event => setSanctions(current => current.map((row, i) => i === index ? { ...row, durationDays: event.target.value } : row))} /></label>}
          {sanction.action !== 'WARNING' && <label className="grid gap-1 text-sm font-semibold">Restoration condition<input className={control} maxLength={1000} value={sanction.restorationCondition} onChange={event => setSanctions(current => current.map((row, i) => i === index ? { ...row, restorationCondition: event.target.value } : row))} /></label>}
          {errors[`sanction-${index}`] && <p role="alert" className="text-sm text-status-error">{errors[`sanction-${index}`]}</p>}
          <Button variant="quiet" className="w-fit" onClick={() => setSanctions(current => current.filter((_, i) => i !== index))}>Remove sanction</Button>
        </div>)}
        {sanctions.length < 4 && <Button variant="secondary" className="w-fit" onClick={() => setSanctions(current => [...current, { subject: 'VENDOR', action: 'WARNING', reason: '', durationDays: '', restorationCondition: '' }])}>Add sanction</Button>}
      </fieldset>
      {mode === 'DECISION' && <label className="flex min-h-11 items-start gap-3 text-sm"><input type="checkbox" className="mt-0.5 h-5 w-5 accent-action-primary" checked={enforceable} onChange={event => setEnforceable(event.target.checked)} />
        <span><strong>Immediately enforceable.</strong> Otherwise the remedy starts only when the five-business-day appeal window ends unappealed.</span></label>}
      <label className="flex min-h-11 items-start gap-3 rounded-control border border-border-default bg-surface-canvas p-3 text-sm"><input type="checkbox" className="mt-0.5 h-5 w-5 accent-action-primary" checked={conflict} aria-invalid={Boolean(errors.conflict)} onChange={event => setConflict(event.target.checked)} />
        <span><strong>Conflict check.</strong> I have no personal, financial or account connection to either party.</span></label>
      {errors.conflict && <p role="alert" className="text-sm text-status-error">{errors.conflict}</p>}
      <Button type="submit" disabled={conflictBlocked || busy}>{mode === 'APPEAL' ? 'Review appeal decision' : 'Review decision'}</Button>
    </form>
    <ConfirmDialog open={confirming} tone="primary" busy={busy} title={mode === 'APPEAL' ? 'Record this final appeal decision?' : 'Issue this decision?'} confirmLabel="Record decision" onCancel={() => setConfirming(false)} onConfirm={() => void submit()}>
      <p className="text-text-secondary">{needsOutcome ? disputeRemedyLabel(outcome) : 'The original decision is affirmed'}{needsOutcome && outcome === 'PARTIAL_REFUND' && peso(amount) ? ` of ${formatPesoCentavos(peso(amount))}` : ''}. Decisions are immutable; a later change needs a new version.</p>
    </ConfirmDialog>
  </Card>
}

function ClarificationForm({ caseId, onChanged }: { caseId: string; onChanged: Changed }) {
  const [parties, setParties] = useState<('BUYER' | 'VENDOR')[]>(['BUYER'])
  const [question, setQuestion] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  return <Card title="Request clarification" icon={<Info size={16} aria-hidden="true" />}>
    <p className="text-sm text-text-secondary">Each requested party has 24 hours. Silence alone never proves fault.</p>
    <form className="grid gap-3" noValidate onSubmit={event => { event.preventDefault(); void (async () => {
      if (parties.length === 0 || question.trim().length < 10) { setError('Choose who must answer and write the question (at least 10 characters).'); return }
      setBusy(true); setError(null)
      try { onChanged(await requestClarification(caseId, parties, question.trim()), 'Clarification requested.'); setQuestion('') } catch (cause) { setError(await readableVerificationError(cause)) } finally { setBusy(false) }
    })() }}>
      <fieldset className="flex flex-wrap gap-4"><legend className="sr-only">Requested parties</legend>{(['BUYER', 'VENDOR'] as const).map(party => <label key={party} className="flex min-h-11 items-center gap-2 text-sm">
        <input type="checkbox" className="h-5 w-5 accent-action-primary" checked={parties.includes(party)} onChange={event => setParties(current => event.target.checked ? [...current, party] : current.filter(value => value !== party))} />{party === 'BUYER' ? 'Buyer' : 'Store'}</label>)}</fieldset>
      <label className="grid gap-2 text-sm font-semibold">Question<textarea className={`${control} min-h-20 py-2`} maxLength={2000} value={question} onChange={event => setQuestion(event.target.value)} /></label>
      {error && <p role="alert" className="text-sm text-status-error">{error}</p>}
      <Button type="submit" variant="secondary" disabled={busy}>{busy ? 'Sending…' : 'Send request'}</Button>
    </form>
  </Card>
}

function EscalateForm({ caseId, onChanged }: { caseId: string; onChanged: Changed }) {
  const [reason, setReason] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  return <Card title="Direct escalation" icon={<ShieldAlert size={16} aria-hidden="true" />}>
    <p className="text-sm text-text-secondary">For a safety or compliance matter that cannot wait for the parties.</p>
    <form className="grid gap-3" noValidate onSubmit={event => { event.preventDefault(); void (async () => {
      if (reason.trim().length < 10) { setError('Give a reason of at least 10 characters.'); return }
      setBusy(true); setError(null)
      try { onChanged(await escalateCase(caseId, reason.trim()), 'Case escalated to Admin review.') } catch (cause) { setError(await readableVerificationError(cause)) } finally { setBusy(false) }
    })() }}>
      <label className="grid gap-2 text-sm font-semibold">Reason<textarea className={`${control} min-h-20 py-2`} maxLength={2000} value={reason} onChange={event => setReason(event.target.value)} /></label>
      {error && <p role="alert" className="text-sm text-status-error">{error}</p>}
      <Button type="submit" variant="secondary" disabled={busy}>Escalate</Button>
    </form>
  </Card>
}

function ConfirmRemedy({ caseId, remedyId, onChanged }: { caseId: string; remedyId: string; onChanged: Changed }) {
  const [open, setOpen] = useState(false)
  const [reason, setReason] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  return <>
    <Button variant="secondary" onClick={() => setOpen(true)}><Scale size={15} aria-hidden="true" />Confirm with reason</Button>
    <ConfirmDialog open={open} tone="primary" busy={busy} title="Confirm the replacement by review?" confirmLabel="Confirm replacement" onCancel={() => setOpen(false)} onConfirm={() => void (async () => {
      if (reason.trim().length < 10) { setError('Give a reason of at least 10 characters.'); return }
      setBusy(true); setError(null)
      try { onChanged(await confirmRemedy(caseId, remedyId, reason.trim()), 'Replacement confirmed by review.'); setOpen(false) } catch (cause) { setError(await readableVerificationError(cause)) } finally { setBusy(false) }
    })()}>
      <p className="text-text-secondary">Use this after reviewing the Vendor's record when the Buyer cannot or does not confirm.</p>
      <label className="grid gap-2 text-sm font-semibold text-text-strong">Reason<textarea className={`${control} min-h-20 py-2`} maxLength={2000} value={reason} onChange={event => setReason(event.target.value)} /></label>
      {error && <p role="alert" className="text-sm text-status-error">{error}</p>}
    </ConfirmDialog>
  </>
}
