import { useCallback, useEffect, useRef, useState, type ReactNode } from 'react'
import { Link, useNavigate, useParams, useSearchParams } from 'react-router-dom'
import { ArrowLeft, Download, FileDown, Gavel, Handshake, Info, Paperclip, RefreshCw, Scale, Send, ShieldAlert, Upload } from 'lucide-react'
import {
  Button, ConfirmDialog, DisputeDeadlines, DisputeStatusBadge, DisputeTimeline, FileSelectionReview, FormDialog, FilterTabs, Toolbar, InfoNote, EmptyState, PageHeader as SharedPageHeader, OriginalPaymentMethodNotice, RefundTimeline, ResponsiveRecordList, StatusBadge, StatusMessage,
  disputeIssueLabel, disputeRemedyLabel, disputeRoleLabel, formatManilaDateTime, formatPesoCentavos, type RecordColumn,
} from '@materyalph/web-ui'
import {
  addEvidence, answerClarification, answerProposal, appeal, disputeApiBasePath, downloadExport, escalate, fileDispute, getDispute, getEligibility, listDisputes, listExports, propose,
  recordReplacement, requestExport, respond, sendMessage,
  type DisputeDetail, type DisputeEligibility, type DisputeExport, type DisputeGroup, type DisputeListMeta, type DisputeSummary,
} from '../lib/disputes-api'
import { readableOrderError, pesoInputToCentavos } from '../lib/orders-api'
import { newIdempotencyKey } from '../lib/onboarding-api'
import { storeName } from '../lib/catalog-access'
import { useOnboardingSnapshot } from '../lib/vendor-status'
import { ErrorState, LoadingState, PageHeader, VendorShell } from './PhaseThreeVendorPages'

const control = 'min-h-12 w-full min-w-0 rounded-control border border-border-default bg-surface-primary px-3 text-base font-normal'
const GROUPS: { value: DisputeGroup; label: string }[] = [
  { value: 'ACTIVE', label: 'Active' }, { value: 'NEEDS_RESPONSE', label: 'Needs your response' }, { value: 'ADMIN_REVIEW', label: 'Admin review' },
  { value: 'DECIDED', label: 'Remedy in progress' }, { value: 'CONCLUDED', label: 'Concluded' }, { value: 'ALL', label: 'All' },
]
const POSITIONS: Record<string, string> = {
  ACCEPT_REQUEST: 'Accept the requested remedy', OFFER_REPLACEMENT: 'Offer a replacement', OFFER_REFUND: 'Offer a refund (Owner only)', REJECT_WITH_EVIDENCE: 'Reject, with evidence',
  REQUEST_ADMIN_REVIEW: 'Ask MateryalPH to review',
}
const VENDOR_ISSUES = ['PHYSICAL_PAYMENT_NOT_RECEIVED', 'PICKUP_NO_SHOW', 'ABUSIVE_COMMUNICATION', 'FALSE_EVIDENCE', 'INACCESSIBLE_DELIVERY_SITE']
const RESPONSIBLE: Record<string, string> = { BUYER: 'The Buyer', VENDOR: 'Your store', BOTH: 'Both parties', ADMIN: 'MateryalPH', REQUESTED_PARTY: 'The requested party', NONE: '—' }

type Snapshot = NonNullable<ReturnType<typeof useOnboardingSnapshot>['snapshot']>

function DisputeAccessGate({ activeHref, children }: { activeHref: string; children: (snapshot: Snapshot) => ReactNode }) {
  const { snapshot, loading, error, refresh } = useOnboardingSnapshot()
  if (loading) return <VendorShell activeHref={activeHref} accountLabel="Vendor" navigationData={null}><LoadingState label="Loading cases…" /></VendorShell>
  if (error || !snapshot) return <VendorShell activeHref={activeHref} accountLabel="Vendor" navigationData={null}><ErrorState message={error ?? 'Cases are unavailable.'} onRetry={() => void refresh()} /></VendorShell>
  const allowed = snapshot.permissions.includes('portal.disputes') || snapshot.permissions.includes('disputes.fulfillment_evidence')
  return <VendorShell activeHref={activeHref} accountLabel={storeName(snapshot)} navigationData={snapshot}>
    {allowed ? children(snapshot) : <StatusMessage tone="error">Disputes &amp; Appeals are not available to your role. The store Owner controls whether Store Staff and Customer Service handle cases.</StatusMessage>}
  </VendorShell>
}

// ── List ────────────────────────────────────────────────────────────────────────────────────────────

export function VendorDisputesPage() {
  return <DisputeAccessGate activeHref="/disputes">{snapshot => <DisputesWorkspace canExport={snapshot.permissions.includes('disputes.export')} />}</DisputeAccessGate>
}

function DisputesWorkspace({ canExport }: { canExport: boolean }) {
  const [params, setParams] = useSearchParams()
  const group = (GROUPS.some(item => item.value === params.get('group')) ? params.get('group') : 'ACTIVE') as DisputeGroup
  const q = params.get('q') ?? ''
  const page = Math.max(1, Number(params.get('page') ?? '1') || 1)
  const [query, setQuery] = useState(q)
  const [rows, setRows] = useState<DisputeSummary[] | null>(null)
  const [meta, setMeta] = useState<DisputeListMeta | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  const update = (patch: Record<string, string>) => setParams(current => {
    const next = new URLSearchParams(current)
    for (const [key, value] of Object.entries(patch)) { if (value) next.set(key, value); else next.delete(key) }
    if (!('page' in patch)) next.delete('page')
    return next
  }, { replace: true })
  useEffect(() => {
    let active = true
    setError(null)
    listDisputes({ group, q, page }).then(result => { if (active) { setRows(result.items); setMeta(result.meta) } }).catch(async cause => { const text = await readableOrderError(cause); if (active) setError(text) })
    return () => { active = false }
  }, [group, q, page, attempt])
  const columns: RecordColumn<DisputeSummary>[] = [
    { key: 'case', header: 'Case', cell: row => <CaseIdentity row={row} /> },
    { key: 'issue', header: 'Issue · requested', cell: row => <span className="grid gap-0.5"><span className="font-semibold">{disputeIssueLabel(row.issueType)}</span><span className="text-xs text-text-secondary">{disputeRemedyLabel(row.requestedRemedy)}{row.requestedAmountCentavos ? ` · ${formatPesoCentavos(row.requestedAmountCentavos)}` : ''}</span></span> },
    { key: 'status', header: 'Status', cell: row => <span className="grid justify-items-start gap-1"><DisputeStatusBadge status={row.status} /><span className="text-xs text-text-secondary">Next: {RESPONSIBLE[row.responsibleParty] ?? row.responsibleParty}</span></span> },
    { key: 'deadline', header: 'Deadline', cell: row => row.nextDeadline ? <span className="grid gap-0.5"><span className="font-semibold">{row.nextDeadline.kind.replaceAll('_', ' ').toLowerCase().replace(/^\w/, letter => letter.toUpperCase())}</span><span className="text-xs text-text-secondary">{row.nextDeadline.label}</span></span> : <span className="text-text-secondary">—</span> },
    { key: 'refund', header: 'Refund', cell: row => row.refundState === 'NOT_REQUESTED' ? <span className="text-text-secondary">None</span> : row.refundState.replaceAll('_', ' ').toLowerCase() },
    { key: 'action', header: 'Action', cell: row => <Link to={`/disputes/${row.id}`} className="inline-flex min-h-11 items-center justify-center rounded-control border border-border-default bg-surface-primary px-4 text-sm font-semibold hover:bg-surface-canvas">Open case</Link> },
  ]
  return <div className="grid min-w-0 gap-6">
    <PageHeader eyebrow="Store Operations" title="Disputes & Appeals" description="Track cases, respond to requests and follow agreed or decided remedies." />
    <InfoNote>Respond within 48 hours, agree a remedy within 72 hours, answer MateryalPH's clarification requests and follow decided remedies. Filing a case never creates a refund; refunds return only to the Buyer's original payment method.</InfoNote>
    <FilterTabs label="Filter cases" value={group} onChange={value => update({ group: value })} chips={GROUPS.map(item => ({ value: item.value, label: item.label, count: meta?.counts?.[item.value] }))} />
    <Toolbar search={{ label: 'Search by Case ID or Order ID', placeholder: 'Case ID or Order ID', value: query, onChange: setQuery, maxLength: 120, onSubmit: event => { event.preventDefault(); update({ q: query.trim() }) } }} />
    {error ? <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} />
      : rows === null ? <div className="grid gap-3" aria-busy="true" aria-label="Loading cases">{[0, 1, 2].map(index => <div key={index} className="h-20 animate-pulse rounded-surface bg-surface-canvas motion-reduce:animate-none" />)}</div>
        : rows.length === 0 ? <EmptyState icon={<Scale size={24} aria-hidden="true" />} message={q ? `No case matches “${q}”.` : 'No cases in this view.'} action={<Button variant="secondary" onClick={() => { setQuery(''); update({ group: 'ALL', q: '' }) }}>View all cases</Button>} />
          : <div className="grid gap-3"><ResponsiveRecordList caption="Cases" rows={rows} columns={columns} rowKey={row => row.id} cardTitle={row => <CaseIdentity row={row} />} cardAction={row => <Link to={`/disputes/${row.id}`} className="inline-flex min-h-11 items-center font-semibold text-action-primary">Open case</Link>} />
            {meta && meta.total !== undefined && meta.perPage !== undefined && meta.total > meta.perPage && <nav aria-label="Case pages" className="flex flex-wrap items-center justify-between gap-3 text-sm"><span className="text-text-secondary">Page {meta.page} · {meta.total} cases</span>
              <span className="flex gap-2"><Button variant="secondary" disabled={page <= 1} onClick={() => update({ page: String(page - 1) })}>Previous</Button><Button variant="secondary" disabled={!meta.hasMore} onClick={() => update({ page: String(page + 1) })}>Next</Button></span></nav>}
          </div>}
    {canExport && <ExportsPanel group={group} />}
  </div>
}

function CaseIdentity({ row }: { row: DisputeSummary }) {
  return <span className="grid min-w-0 gap-0.5">
    <Link to={`/disputes/${row.id}`} className="font-semibold text-action-primary underline-offset-4 hover:underline">{row.reference}</Link>
    <span className="text-xs text-text-secondary">Order {row.orderReference}{row.buyerName ? ` · ${row.buyerName}` : ''}</span>
    <span className="text-xs text-text-secondary">{row.filedByParty === 'VENDOR' ? 'Filed by your store' : 'Filed by the Buyer'}{row.filedAt ? ` · ${formatManilaDateTime(row.filedAt)}` : ''}</span>
  </span>
}

function ExportsPanel({ group }: { group: DisputeGroup }) {
  const [exports, setExports] = useState<DisputeExport[] | null>(null)
  const [message, setMessage] = useState<{ tone: 'success' | 'error'; text: string } | null>(null)
  const [busy, setBusy] = useState(false)
  const load = useCallback(() => { listExports().then(setExports).catch(async cause => setMessage({ tone: 'error', text: await readableOrderError(cause) })) }, [])
  useEffect(() => { load() }, [load])
  return <section aria-labelledby="exports-heading" className="grid gap-3 border-t border-border-default pt-5">
    <div className="flex flex-wrap items-center justify-between gap-3">
      <div><h2 id="exports-heading" className="text-base font-semibold">Case exports</h2><p className="text-sm text-text-secondary">A CSV of case headers only — no evidence, contacts or protected finance. Access is checked again when the file is built and downloaded.</p></div>
      <Button variant="secondary" disabled={busy} onClick={() => void (async () => { setBusy(true); setMessage(null); try { await requestExport(group); setMessage({ tone: 'success', text: 'Export requested. It appears below when ready.' }); load() } catch (cause) { setMessage({ tone: 'error', text: await readableOrderError(cause) }) } finally { setBusy(false) } })()}>
        <FileDown size={16} aria-hidden="true" />{busy ? 'Requesting…' : 'Export these cases'}</Button>
    </div>
    {message && <StatusMessage tone={message.tone}>{message.text}</StatusMessage>}
    {exports && exports.length > 0 && <ul className="grid divide-y divide-border-default rounded-surface border border-border-default bg-surface-primary text-sm">{exports.map(item => <li key={item.id} className="flex flex-wrap items-center justify-between gap-3 px-4 py-2">
      <span>{formatManilaDateTime(item.requestedAt)} · {item.state === 'READY' ? `${item.rowCount ?? 0} cases` : item.state === 'REVOKED' ? 'Revoked — access changed' : item.state.toLowerCase()}</span>
      {item.state === 'READY' && <Button variant="quiet" onClick={() => void downloadExport(item.id).catch(async cause => setMessage({ tone: 'error', text: await readableOrderError(cause) }))}><Download size={15} aria-hidden="true" />Download CSV</Button>}
    </li>)}</ul>}
  </section>
}

// ── Detail ──────────────────────────────────────────────────────────────────────────────────────────

export function VendorDisputeDetailPage() {
  const { caseId = '' } = useParams()
  return <DisputeAccessGate activeHref="/disputes">{() => <DisputeWorkspace caseId={caseId} />}</DisputeAccessGate>
}

type Changed = (detail: DisputeDetail, message: string) => void

function DisputeWorkspace({ caseId }: { caseId: string }) {
  const [detail, setDetail] = useState<DisputeDetail | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [notice, setNotice] = useState<{ tone: 'success' | 'error' | 'info'; text: string } | null>(null)
  const [attempt, setAttempt] = useState(0)
  const reload = useCallback(() => setAttempt(value => value + 1), [])
  useEffect(() => {
    let active = true
    setError(null)
    getDispute(caseId).then(loaded => { if (active) setDetail(loaded) }).catch(async cause => { const text = await readableOrderError(cause); if (active) setError(text) })
    return () => { active = false }
  }, [caseId, attempt])
  const changed: Changed = (next, text) => { setDetail(next); setNotice({ tone: 'success', text }); window.scrollTo({ top: 0, behavior: 'smooth' }) }
  if (error) return <div className="grid gap-4"><BackLink /><ErrorState message={error} onRetry={reload} /></div>
  if (!detail) return <div className="grid gap-4"><BackLink /><LoadingState label="Loading case…" /></div>
  const actions = new Set(detail.availableActions)
  return <div className="grid min-w-0 gap-6">
    <BackLink />
    <SharedPageHeader eyebrow="Case" title={detail.reference} status={<DisputeStatusBadge status={detail.status} />} description={`${disputeIssueLabel(detail.issueType)} · ${detail.caseKind === 'POST_COMPLETION_RETURN' ? 'Post-completion return' : 'Transaction case'}`} actions={<><Link to={`/orders/${detail.order.id}`} className="inline-flex min-h-11 items-center rounded-control border border-border-default bg-surface-primary px-4 text-sm font-semibold">Order {detail.order.reference}</Link><Button variant="secondary" onClick={reload}><RefreshCw size={16} aria-hidden="true" />Refresh</Button></>} />
    <p className="text-sm text-text-secondary">Requested {disputeRemedyLabel(detail.requestedRemedy).toLowerCase()}{detail.requestedAmountCentavos ? ` of ${formatPesoCentavos(detail.requestedAmountCentavos)}` : ''}</p>
    {notice && <StatusMessage tone={notice.tone}>{notice.text}</StatusMessage>}
    <DisputeDeadlines deadlines={detail.deadlines} onExpire={reload} partyNote={deadline => deadline.responsibleParty === 'VENDOR' ? 'Your store must act before this time.' : deadline.responsibleParty === 'BUYER' ? 'Waiting for the Buyer.' : deadline.kind === 'APPEAL' ? 'Either party may appeal once until this time.' : 'Both parties may act until this time.'} />
    {detail.limitedView && <StatusMessage tone="info">You can see this case because its order is assigned to you. You can add fulfillment evidence only; the Owner, Store Manager and permitted staff handle the case.</StatusMessage>}
    <div className="grid min-w-0 gap-6 xl:grid-cols-[minmax(0,1fr)_24rem]">
      <div className="grid min-w-0 content-start gap-6">
        {!detail.limitedView && <CaseFacts detail={detail} />}
        <section aria-labelledby="timeline-heading" className="grid gap-4 rounded-surface border border-border-default bg-surface-primary p-4 sm:p-5">
          <h2 id="timeline-heading" className="text-lg font-semibold">Case timeline</h2>
          <DisputeTimeline entries={detail.timeline} apiBasePath={disputeApiBasePath} onLinkExpired={reload} />
        </section>
        {!detail.limitedView && detail.decisions.length > 0 && <DecisionsPanel detail={detail} />}
        {!detail.limitedView && (detail.refunds.length > 0 || (detail.reimbursements?.length ?? 0) > 0) && <section aria-labelledby="case-refunds-heading" className="grid gap-3 rounded-surface border border-border-default bg-surface-primary p-4">
          <h2 id="case-refunds-heading" className="text-base font-semibold">Dispute-Conclusion Refunds</h2>
          <RefundTimeline timeline={{ refunds: detail.refunds, reimbursements: detail.reimbursements ?? [], noLongerDueCentavos: 0 }} audience="VENDOR" />
          <p className="text-xs text-text-secondary">Refunds go to the Buyer's original payment method only. Retry a failed refund from the order after funding is resolved.</p>
        </section>}
      </div>
      <aside className="grid min-w-0 content-start gap-4" aria-label="Case actions">
        {actions.size === 0 && <p className="rounded-surface border border-border-default bg-surface-primary p-4 text-sm text-text-secondary">{['RESOLVED', 'CLOSED_INCONCLUSIVE'].includes(detail.status) ? 'This case has concluded. Its history stays on record.' : 'There is nothing for your role to do right now.'}</p>}
        {actions.has('RESPOND') && <RespondForm detail={detail} onChanged={changed} />}
        {actions.has('ANSWER_PROPOSAL') && <ProposalsPanel detail={detail} onChanged={changed} />}
        {actions.has('PROPOSE') && <ProposeForm detail={detail} onChanged={changed} />}
        {actions.has('ANSWER_CLARIFICATION') && <ClarificationPanel detail={detail} onChanged={changed} />}
        {actions.has('RECORD_REPLACEMENT') && <ReplacementPanel detail={detail} onChanged={changed} />}
        {actions.has('APPEAL') && <AppealForm detail={detail} onChanged={changed} />}
        {(actions.has('ADD_EVIDENCE') || actions.has('ADD_FULFILLMENT_EVIDENCE')) && <EvidenceForm caseId={detail.id} fulfillment={actions.has('ADD_FULFILLMENT_EVIDENCE')} onChanged={changed} />}
        {actions.has('MESSAGE') && <MessageForm caseId={detail.id} onChanged={changed} />}
        {actions.has('ESCALATE') && <EscalatePanel detail={detail} onChanged={changed} />}
      </aside>
    </div>
  </div>
}

function BackLink() {
  return <Link to="/disputes" className="inline-flex min-h-11 w-fit items-center gap-2 text-sm font-semibold text-text-secondary hover:text-text-strong"><ArrowLeft size={16} aria-hidden="true" />All cases</Link>
}

function CaseFacts({ detail }: { detail: DisputeDetail }) {
  return <section aria-labelledby="facts-heading" className="grid gap-4 rounded-surface border border-border-default bg-surface-primary p-4 sm:p-5">
    <h2 id="facts-heading" className="text-lg font-semibold">Original complaint</h2>
    {detail.description && <p className="whitespace-pre-line break-words">{detail.description}</p>}
    {detail.affectedLines.length > 0 && <div className="grid gap-2"><h3 className="text-sm font-semibold">Affected lines</h3><ul className="grid gap-1 text-sm">{detail.affectedLines.map(line => <li key={line.orderLineId} className="flex flex-wrap justify-between gap-x-3">
      <span>{line.displayName}{line.variantLabel ? ` · ${line.variantLabel}` : ''}</span><span className="tabular-nums text-text-secondary">{formatPesoCentavos(line.lineTotalCentavos)}</span></li>)}</ul></div>}
    <dl className="grid gap-x-6 gap-y-2 border-t border-border-default pt-3 text-sm sm:grid-cols-2">
      <div><dt className="text-text-secondary">Filed by</dt><dd className="font-semibold">{detail.filedByParty === 'VENDOR' ? 'Your store' : 'The Buyer'}{detail.filedAt ? ` · ${formatManilaDateTime(detail.filedAt)}` : ''}</dd></div>
      <div><dt className="text-text-secondary">Store handler</dt><dd className="font-semibold">{detail.handler.vendor ? `${detail.handler.vendor.displayName} · ${disputeRoleLabel(detail.handler.vendor.role)}` : 'Not yet assigned'}</dd></div>
      <div><dt className="text-text-secondary">MateryalPH review</dt><dd className="font-semibold">{detail.handler.adminAssigned ? 'Assigned' : 'Not assigned'}</dd></div>
      <div><dt className="text-text-secondary">Order status</dt><dd className="font-semibold">{detail.order.orderState.replaceAll('_', ' ').toLowerCase()}</dd></div>
    </dl>
    {detail.originalPaymentMethod && <OriginalPaymentMethodNotice label={detail.originalPaymentMethod.label} notice={detail.originalPaymentMethod.notice} />}
  </section>
}

function DecisionsPanel({ detail }: { detail: DisputeDetail }) {
  return <section aria-labelledby="decisions-heading" className="grid gap-3 rounded-surface border border-border-default bg-surface-primary p-4 sm:p-5">
    <h2 id="decisions-heading" className="flex items-center gap-2 text-lg font-semibold"><Gavel size={18} aria-hidden="true" />Decisions</h2>
    <ul className="grid gap-3">{detail.decisions.map(decision => <li key={decision.id} className={`grid gap-1 border-l-4 pl-3 ${decision.current ? 'border-action-primary' : 'border-border-default'}`}>
      <p className="font-semibold">Version {decision.version} · {decision.kind === 'MUTUAL_AGREEMENT' ? 'Agreement' : decision.kind === 'APPEAL_DECISION' ? `Appeal ${decision.appealResult?.toLowerCase() ?? ''}` : 'Admin decision'} · {disputeRemedyLabel(decision.outcome)}{decision.awardedCentavos > 0 ? ` · ${formatPesoCentavos(decision.awardedCentavos)}` : ''}</p>
      {decision.decidedAt && <p className="text-xs text-text-secondary">{formatManilaDateTime(decision.decidedAt)}{decision.current ? ' · current' : ' · superseded, kept on record'}</p>}
      {decision.reason && <p className="text-sm">{decision.reason}</p>}
      {decision.evidenceLimitation && <p className="text-sm text-text-secondary">Evidence limitation: {decision.evidenceLimitation}</p>}
    </li>)}</ul>
    {detail.appeal && <p className="text-sm text-text-secondary">Appeal by {detail.appeal.appellantParty === 'VENDOR' ? 'your store' : 'the Buyer'} ({detail.appeal.grounds === 'NEW_EVIDENCE' ? 'new evidence' : 'material process error'}) · {detail.appeal.state === 'OPEN' ? 'under review' : 'decided'}</p>}
  </section>
}

function ActionCard({ title, icon, children }: { title: string; icon: ReactNode; children: ReactNode }) {
  return <section className="grid gap-3 rounded-surface border border-border-default bg-surface-primary p-4" aria-label={title}><h2 className="flex items-center gap-2 text-base font-semibold">{icon}{title}</h2>{children}</section>
}

function useSubmission() {
  const key = useRef(newIdempotencyKey())
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState<string | null>(null)
  async function run(task: (idempotencyKey: string) => Promise<void>) {
    setBusy(true); setError(null)
    try { await task(key.current); key.current = newIdempotencyKey() } catch (cause) { key.current = newIdempotencyKey(); setError(await readableOrderError(cause)) } finally { setBusy(false) }
  }
  return { busy, error, setError, run }
}

function FilePicker({ id, label, files, onChange, max = 5, disabled = false }: { id: string; label: string; files: File[]; onChange: (files: File[]) => void; max?: number; disabled?: boolean }) {
  const input = useRef<HTMLInputElement>(null)
  return <div className="grid min-w-0 gap-3">
    <label htmlFor={id} className="text-sm font-semibold">{label}</label>
    <label className={`relative inline-flex min-h-11 w-fit items-center justify-center gap-2 rounded-control border border-border-default px-4 text-sm font-semibold focus-within:ring-2 focus-within:ring-focus-ring focus-within:ring-offset-2 ${disabled ? 'opacity-50' : 'cursor-pointer hover:bg-surface-canvas'}`}>
      <Upload size={16} aria-hidden="true" />{files.length ? 'Change files' : 'Choose files'}
      <input ref={input} id={id} type="file" multiple={max > 1} accept="image/png,image/jpeg,application/pdf" disabled={disabled} aria-describedby={`${id}-hint`} className="sr-only" onChange={event => {
        const chosen = Array.from(event.target.files ?? [])
        if (chosen.length) onChange(chosen.slice(0, max))
      }} />
    </label>
    <p id={`${id}-hint`} className="text-xs text-text-secondary">JPG, PNG or PDF, up to {max} file{max === 1 ? '' : 's'}. Files are scanned and stored privately.</p>
    <FileSelectionReview files={files} disabled={disabled} onRemove={index => {
      if (input.current) input.current.value = ''
      onChange(files.filter((_, position) => position !== index))
    }} />
  </div>
}

function RespondForm({ detail, onChanged }: { detail: DisputeDetail; onChanged: Changed }) {
  const canRefund = Boolean(detail.permissions?.canOfferRefund)
  const [position, setPosition] = useState('OFFER_REPLACEMENT')
  const [body, setBody] = useState('')
  const [amount, setAmount] = useState('')
  const [files, setFiles] = useState<File[]>([])
  const { busy, error, setError, run } = useSubmission()
  const refundAccept = position === 'ACCEPT_REQUEST' && ['FULL_REFUND', 'PARTIAL_REFUND', 'RETURN_AND_REFUND'].includes(detail.requestedRemedy)
  return <ActionCard title="Respond to the Buyer" icon={<Send size={16} aria-hidden="true" />}>
    <p className="text-sm text-text-secondary">A response opens 72 hours for both parties to agree. A rejection needs evidence.</p>
    <form className="grid gap-3" noValidate onSubmit={event => { event.preventDefault(); void run(async key => {
      if (body.trim().length < 10) { setError('Write your response in at least 10 characters.'); return }
      const centavos = amount.trim() ? pesoInputToCentavos(amount) : undefined
      if (amount.trim() && centavos === null) { setError('Enter a valid peso amount.'); return }
      if (position === 'REJECT_WITH_EVIDENCE' && files.length === 0) { setError('Attach the evidence for a rejection.'); return }
      onChanged(await respond(detail.id, { position, body: body.trim(), ...(position === 'OFFER_REFUND' && centavos ? { amountCentavos: centavos } : {}), files }, key), 'Response sent. The mutual-resolution period has started.')
    }) }}>
      <label className="grid gap-2 text-sm font-semibold">Your response<select className={control} value={position} onChange={event => setPosition(event.target.value)}>
        {Object.entries(POSITIONS).filter(([value]) => value !== 'OFFER_REFUND' || canRefund).map(([value, text]) => <option key={value} value={value}>{text}</option>)}</select></label>
      {refundAccept && !canRefund && <p className="text-sm text-amber-900">Accepting a refund is a voluntary financial refund that only the Owner can agree to. Offer a replacement or ask the Owner.</p>}
      {position === 'OFFER_REFUND' && <label className="grid gap-2 text-sm font-semibold">Refund amount (leave blank for a full refund)<input className={control} inputMode="decimal" value={amount} onChange={event => setAmount(event.target.value)} placeholder="0.00" /></label>}
      <label className="grid gap-2 text-sm font-semibold">Explanation<textarea className={`${control} min-h-24 py-2`} maxLength={4000} value={body} onChange={event => setBody(event.target.value)} /></label>
      <FilePicker id="respond-files" label="Evidence" files={files} onChange={setFiles} />
      {error && <p role="alert" className="text-sm text-status-error">{error}</p>}
      <Button type="submit" disabled={busy || (refundAccept && !canRefund)}>{busy ? 'Sending…' : 'Send response'}</Button>
    </form>
  </ActionCard>
}

function ProposalsPanel({ detail, onChanged }: { detail: DisputeDetail; onChanged: Changed }) {
  const open = detail.proposals.filter(proposal => proposal.canAnswer)
  const [confirming, setConfirming] = useState<{ id: string; accept: boolean } | null>(null)
  const { busy, error, run } = useSubmission()
  return <ActionCard title="The Buyer's proposal" icon={<Handshake size={16} aria-hidden="true" />}>
    {open.map(proposal => <div key={proposal.id} className="grid gap-2 rounded-control border border-border-default p-3">
      <p className="font-semibold">{disputeRemedyLabel(proposal.remedy)}{proposal.amountCentavos ? ` · ${formatPesoCentavos(proposal.amountCentavos)}` : ''}</p>
      <p className="text-sm">{proposal.terms}</p>
      <div className="flex flex-wrap gap-2"><Button onClick={() => setConfirming({ id: proposal.id, accept: true })}>Accept</Button><Button variant="secondary" onClick={() => setConfirming({ id: proposal.id, accept: false })}>Reject</Button></div>
    </div>)}
    {error && <p role="alert" className="text-sm text-status-error">{error}</p>}
    <ConfirmDialog open={confirming !== null} tone={confirming?.accept ? 'primary' : 'danger'} busy={busy} title={confirming?.accept ? 'Accept this resolution?' : 'Reject this proposal?'}
      confirmLabel={confirming?.accept ? 'Accept and record the agreement' : 'Reject proposal'} onCancel={() => setConfirming(null)}
      onConfirm={() => void run(async key => { if (!confirming) return; onChanged(await answerProposal(detail.id, confirming.id, confirming.accept, key), confirming.accept ? 'Agreement recorded. The agreed remedy is now being carried out.' : 'Proposal rejected.'); setConfirming(null) })}>
      <p className="text-text-secondary">{confirming?.accept ? 'The agreement is final. A refund goes only to the Buyer\'s original payment method and the case resolves once the remedy is complete.' : 'You can still propose another remedy or ask MateryalPH to review.'}</p>
    </ConfirmDialog>
  </ActionCard>
}

function ProposeForm({ detail, onChanged }: { detail: DisputeDetail; onChanged: Changed }) {
  const canRefund = Boolean(detail.permissions?.canOfferRefund)
  const [remedy, setRemedy] = useState('REPLACEMENT')
  const [amount, setAmount] = useState('')
  const [terms, setTerms] = useState('')
  const { busy, error, setError, run } = useSubmission()
  return <ActionCard title="Propose a resolution" icon={<Handshake size={16} aria-hidden="true" />}>
    <form className="grid gap-3" noValidate onSubmit={event => { event.preventDefault(); void run(async key => {
      if (terms.trim().length < 10) { setError('Describe the terms in at least 10 characters.'); return }
      const centavos = remedy === 'PARTIAL_REFUND' ? pesoInputToCentavos(amount) : undefined
      if (remedy === 'PARTIAL_REFUND' && !centavos) { setError('Enter the partial refund amount.'); return }
      onChanged(await propose(detail.id, { remedy, terms: terms.trim(), ...(centavos ? { amountCentavos: centavos } : {}) }, key), 'Proposal sent to the Buyer.')
    }) }}>
      <label className="grid gap-2 text-sm font-semibold">Remedy<select className={control} value={remedy} onChange={event => setRemedy(event.target.value)}>
        <option value="REPLACEMENT">Replacement</option>{canRefund && <option value="FULL_REFUND">Full refund</option>}{canRefund && <option value="PARTIAL_REFUND">Partial refund</option>}<option value="NO_FURTHER_ACTION">No further action</option></select></label>
      {!canRefund && <p className="text-xs text-text-secondary">Refund proposals are a voluntary financial refund that only the Owner can make.</p>}
      {remedy === 'PARTIAL_REFUND' && <label className="grid gap-2 text-sm font-semibold">Amount<input className={control} inputMode="decimal" value={amount} placeholder="0.00" onChange={event => setAmount(event.target.value)} /></label>}
      <label className="grid gap-2 text-sm font-semibold">Terms<textarea className={`${control} min-h-20 py-2`} maxLength={2000} value={terms} onChange={event => setTerms(event.target.value)} /></label>
      {error && <p role="alert" className="text-sm text-status-error">{error}</p>}
      <Button type="submit" variant="secondary" disabled={busy}>{busy ? 'Sending…' : 'Send proposal'}</Button>
    </form>
  </ActionCard>
}

function ClarificationPanel({ detail, onChanged }: { detail: DisputeDetail; onChanged: Changed }) {
  const clarification = detail.clarifications.find(row => row.canAnswer)
  const [response, setResponse] = useState('')
  const [files, setFiles] = useState<File[]>([])
  const { busy, error, setError, run } = useSubmission()
  if (!clarification) return null
  return <ActionCard title="MateryalPH asked a question" icon={<Info size={16} aria-hidden="true" />}>
    <p className="text-sm font-semibold">{clarification.question}</p>
    {clarification.dueAt && <p className="text-xs text-text-secondary">Answer by {formatManilaDateTime(clarification.dueAt)} (Asia/Manila).</p>}
    <form className="grid gap-3" noValidate onSubmit={event => { event.preventDefault(); void run(async key => {
      if (response.trim().length < 5) { setError('Write your answer.'); return }
      onChanged(await answerClarification(detail.id, clarification.id, response.trim(), files, key), 'Answer sent to MateryalPH.')
    }) }}>
      <label className="grid gap-2 text-sm font-semibold">Your answer<textarea className={`${control} min-h-24 py-2`} maxLength={4000} value={response} onChange={event => setResponse(event.target.value)} /></label>
      <FilePicker id="clarify-files" label="Supporting files (optional)" files={files} onChange={setFiles} />
      {error && <p role="alert" className="text-sm text-status-error">{error}</p>}
      <Button type="submit" disabled={busy}>{busy ? 'Sending…' : 'Send answer'}</Button>
    </form>
  </ActionCard>
}

function ReplacementPanel({ detail, onChanged }: { detail: DisputeDetail; onChanged: Changed }) {
  const remedy = detail.remedies.find(row => row.canRecord)
  const [note, setNote] = useState('')
  const [files, setFiles] = useState<File[]>([])
  const { busy, error, setError, run } = useSubmission()
  if (!remedy) return null
  return <ActionCard title="Record the replacement" icon={<Paperclip size={16} aria-hidden="true" />}>
    <p className="text-sm text-text-secondary">After you provide the replacement, record it here. The Buyer confirms receipt before the case resolves.</p>
    <form className="grid gap-3" noValidate onSubmit={event => { event.preventDefault(); void run(async key => {
      if (note.trim().length < 10) { setError('Describe the replacement in at least 10 characters.'); return }
      onChanged(await recordReplacement(detail.id, remedy.id, note.trim(), files[0] ?? null, key), 'Replacement recorded. The Buyer has been asked to confirm it.')
    }) }}>
      <label className="grid gap-2 text-sm font-semibold">What was replaced<textarea className={`${control} min-h-20 py-2`} maxLength={500} value={note} onChange={event => setNote(event.target.value)} /></label>
      <FilePicker id="replacement-file" label="Proof (optional)" files={files} onChange={setFiles} max={1} />
      {error && <p role="alert" className="text-sm text-status-error">{error}</p>}
      <Button type="submit" disabled={busy}>{busy ? 'Recording…' : 'Record replacement'}</Button>
    </form>
  </ActionCard>
}

function AppealForm({ detail, onChanged }: { detail: DisputeDetail; onChanged: Changed }) {
  const [grounds, setGrounds] = useState('NEW_EVIDENCE')
  const [statement, setStatement] = useState('')
  const [files, setFiles] = useState<File[]>([])
  const [confirm, setConfirm] = useState(false)
  const { busy, error, setError, run } = useSubmission()
  const appealDue = detail.deadlines.find(deadline => deadline.kind === 'APPEAL')
  return <ActionCard title="Appeal the decision" icon={<Scale size={16} aria-hidden="true" />}>
    <p className="text-sm text-text-secondary">One appeal per case{appealDue ? `, until ${appealDue.label}` : ''}, with new relevant evidence or a material process error. The original decision stays on record.</p>
    <form className="grid gap-3" noValidate onSubmit={event => { event.preventDefault()
      if (statement.trim().length < 20) { setError('Explain the appeal in at least 20 characters.'); return }
      if (grounds === 'NEW_EVIDENCE' && files.length === 0) { setError('Attach the new evidence.'); return }
      setError(null); setConfirm(true) }}>
      <label className="grid gap-2 text-sm font-semibold">Grounds<select className={control} value={grounds} onChange={event => setGrounds(event.target.value)}><option value="NEW_EVIDENCE">New relevant evidence</option><option value="MATERIAL_PROCESS_ERROR">Material process error</option></select></label>
      <label className="grid gap-2 text-sm font-semibold">Statement<textarea className={`${control} min-h-24 py-2`} maxLength={4000} value={statement} onChange={event => setStatement(event.target.value)} /></label>
      <FilePicker id="appeal-files" label={grounds === 'NEW_EVIDENCE' ? 'New evidence (required)' : 'Supporting files (optional)'} files={files} onChange={setFiles} />
      {error && <p role="alert" className="text-sm text-status-error">{error}</p>}
      <Button type="submit" variant="secondary">File appeal</Button>
    </form>
    <ConfirmDialog open={confirm} tone="primary" busy={busy} title="File the case's one appeal?" confirmLabel="File appeal" onCancel={() => setConfirm(false)}
      onConfirm={() => void run(async key => { onChanged(await appeal(detail.id, grounds, statement.trim(), files, key), 'Appeal filed. A reviewer who did not make the decision will review it.'); setConfirm(false) })}>
      <p className="text-text-secondary">This case allows one appeal in total. You cannot file another one after this.</p>
    </ConfirmDialog>
  </ActionCard>
}

function EvidenceForm({ caseId, fulfillment, onChanged }: { caseId: string; fulfillment: boolean; onChanged: Changed }) {
  const [files, setFiles] = useState<File[]>([])
  const [description, setDescription] = useState('')
  const { busy, error, setError, run } = useSubmission()
  return <ActionCard title={fulfillment ? 'Add fulfillment evidence' : 'Add evidence'} icon={<Paperclip size={16} aria-hidden="true" />}>
    <form className="grid gap-3" noValidate onSubmit={event => { event.preventDefault(); void run(async key => {
      if (files.length === 0) { setError('Choose at least one file.'); return }
      onChanged(await addEvidence(caseId, files, description.trim() || undefined, key), 'Evidence added to the case.'); setFiles([]); setDescription('')
    }) }}>
      <FilePicker id="evidence-files" label="Files" files={files} onChange={setFiles} />
      <label className="grid gap-2 text-sm font-semibold">Description (optional)<input className={control} maxLength={500} value={description} onChange={event => setDescription(event.target.value)} /></label>
      {error && <p role="alert" className="text-sm text-status-error">{error}</p>}
      <Button type="submit" variant="secondary" disabled={busy}>{busy ? 'Uploading…' : 'Add to case'}</Button>
      <p className="text-xs text-text-secondary">Evidence is labelled with your name, role and the time. It cannot be edited or removed later.</p>
    </form>
  </ActionCard>
}

function MessageForm({ caseId, onChanged }: { caseId: string; onChanged: Changed }) {
  const [body, setBody] = useState('')
  const { busy, error, setError, run } = useSubmission()
  return <ActionCard title="Message on the case" icon={<Send size={16} aria-hidden="true" />}>
    <form className="grid gap-3" noValidate onSubmit={event => { event.preventDefault(); void run(async key => {
      if (body.trim().length < 2) { setError('Write a message.'); return }
      onChanged(await sendMessage(caseId, body.trim(), key), 'Message added to the case.'); setBody('')
    }) }}>
      <label className="sr-only" htmlFor="case-message">Message</label>
      <textarea id="case-message" className={`${control} min-h-20 py-2`} maxLength={2000} value={body} onChange={event => setBody(event.target.value)} />
      {error && <p role="alert" className="text-sm text-status-error">{error}</p>}
      <Button type="submit" variant="secondary" disabled={busy}>{busy ? 'Sending…' : 'Send message'}</Button>
    </form>
  </ActionCard>
}

function EscalatePanel({ detail, onChanged }: { detail: DisputeDetail; onChanged: Changed }) {
  const [open, setOpen] = useState(false)
  const [reason, setReason] = useState('')
  const { busy, error, setError, run } = useSubmission()
  return <ActionCard title="Ask MateryalPH to review" icon={<ShieldAlert size={16} aria-hidden="true" />}>
    <p className="text-sm text-text-secondary">If you cannot agree, Order and Dispute Staff review the evidence and decide.</p>
    <Button variant="secondary" onClick={() => setOpen(true)}>Request Admin review</Button>
    <ConfirmDialog open={open} tone="primary" busy={busy} title="Send this case to Admin review?" confirmLabel="Request review" onCancel={() => setOpen(false)}
      onConfirm={() => void run(async key => { if (reason.trim().length < 10) { setError('Give a reason of at least 10 characters.'); return } onChanged(await escalate(detail.id, reason.trim(), key), 'The case is now with MateryalPH Admin review.'); setOpen(false) })}>
      <label className="grid gap-2 text-sm font-semibold text-text-strong">Reason<textarea className={`${control} min-h-20 py-2`} maxLength={2000} value={reason} onChange={event => setReason(event.target.value)} /></label>
      {error && <p role="alert" className="text-sm text-status-error">{error}</p>}
    </ConfirmDialog>
  </ActionCard>
}

// ── File a case (Vendor issues) ─────────────────────────────────────────────────────────────────────

export function VendorFileDisputePage() {
  const [params] = useSearchParams()
  return <DisputeAccessGate activeHref="/disputes">{() => <FileDisputeWorkspace orderId={params.get('order') ?? ''} />}</DisputeAccessGate>
}

export function FileDisputeDialog({ orderId, onClose }: { orderId: string; onClose: () => void }) {
  const [busy, setBusy] = useState(false)
  return <FormDialog open title="File a case" description="Report a Buyer issue on this order and provide supporting evidence." busy={busy} onClose={onClose} footer={null}>
    <FileDisputeWorkspace orderId={orderId} modal onBusyChange={setBusy} />
  </FormDialog>
}

function FileDisputeWorkspace({ orderId, modal = false, onBusyChange }: { orderId: string; modal?: boolean; onBusyChange?: (busy: boolean) => void }) {
  const navigate = useNavigate()
  const [attempt, setAttempt] = useState(0)
  const [eligibility, setEligibility] = useState<DisputeEligibility | null>(null)
  const [loadError, setLoadError] = useState<string | null>(null)
  const [issueType, setIssueType] = useState(VENDOR_ISSUES[0]!)
  const [remedy, setRemedy] = useState('PAYMENT_OF_BALANCE')
  const [description, setDescription] = useState('')
  const [lines, setLines] = useState<string[]>([])
  const [files, setFiles] = useState<File[]>([])
  const [errors, setErrors] = useState<Record<string, string>>({})
  const { busy, error, run } = useSubmission()
  useEffect(() => { onBusyChange?.(busy) }, [busy, onBusyChange])
  useEffect(() => {
    let active = true
    setLoadError(null)
    getEligibility(orderId).then(value => { if (active) setEligibility(value) }).catch(async cause => { const text = await readableOrderError(cause); if (active) setLoadError(text) })
    return () => { active = false }
  }, [orderId, attempt])
  if (loadError) return <ErrorState message={loadError} onRetry={() => setAttempt(value => value + 1)} />
  if (!eligibility) return <LoadingState label="Checking the order…" />
  return <div className={`grid min-w-0 gap-6 ${modal ? '' : 'max-w-3xl'}`}>
    {!modal && <><Link to={`/orders/${orderId}`} className="inline-flex min-h-11 w-fit items-center gap-2 text-sm font-semibold text-text-secondary hover:text-text-strong"><ArrowLeft size={16} aria-hidden="true" />Back to the order</Link>
    <PageHeader eyebrow="Disputes & Appeals" title="File a case" description="Report a Buyer issue on this order and provide supporting evidence." /></>}
    <InfoNote>For a Buyer issue on this order such as an unpaid cash balance, a pickup no-show, abusive communication, false evidence or an inaccessible delivery site. The Buyer has 48 hours to respond.</InfoNote>
    {!eligibility.available ? <StatusMessage tone="error">{eligibility.reason}{eligibility.activeCaseId && <> <Link className="font-semibold underline" to={`/disputes/${eligibility.activeCaseId}`}>Open the active case</Link></>}</StatusMessage>
      : <form aria-label="File a case" className={modal ? 'grid min-w-0 gap-5' : 'grid gap-5 rounded-surface border border-border-default bg-surface-primary p-4 sm:p-6'} noValidate onSubmit={event => { event.preventDefault()
        if (busy) return
        const local: Record<string, string> = {}
        if (description.trim().length < 20) local.description = 'Describe the issue in at least 20 characters.'
        setErrors(local)
        if (Object.keys(local).length) return
        void run(async key => { const created = await fileDispute({ orderId, issueType, requestedRemedy: remedy, description: description.trim(), affectedLineIds: lines, files }, key); navigate(`/disputes/${created.id}`) })
      }}>
        <div className="grid gap-4 sm:grid-cols-2">
          <label className="grid gap-2 text-sm font-semibold">Issue<select className={control} value={issueType} onChange={event => setIssueType(event.target.value)}>{eligibility.issueTypes.map(code => <option key={code} value={code}>{disputeIssueLabel(code)}</option>)}</select></label>
          <label className="grid gap-2 text-sm font-semibold">Requested remedy<select className={control} value={remedy} onChange={event => setRemedy(event.target.value)}>{eligibility.requestedRemedies.map(code => <option key={code} value={code}>{disputeRemedyLabel(code)}</option>)}</select></label>
        </div>
        {eligibility.lines.length > 0 && <fieldset className="grid gap-2"><legend className="text-sm font-semibold">Affected lines (optional)</legend>{eligibility.lines.map(line => <label key={line.orderLineId} className="flex min-h-11 items-center gap-3 text-sm">
          <input type="checkbox" className="h-5 w-5 accent-action-primary" checked={lines.includes(line.orderLineId)} onChange={event => setLines(current => event.target.checked ? [...current, line.orderLineId] : current.filter(id => id !== line.orderLineId))} />
          <span>{line.displayName}{line.variantLabel ? ` · ${line.variantLabel}` : ''}</span></label>)}</fieldset>}
        <label className="grid gap-2 text-sm font-semibold">What happened<textarea className={`${control} min-h-28 py-2`} maxLength={4000} value={description} aria-invalid={Boolean(errors.description)} aria-describedby={errors.description ? 'description-error' : undefined} onChange={event => setDescription(event.target.value)} /></label>
        {errors.description && <p id="description-error" role="alert" className="text-sm text-status-error">{errors.description}</p>}
        <FilePicker id="file-case-files" label="Evidence" files={files} onChange={setFiles} disabled={busy} />
        <OriginalPaymentMethodNotice label={eligibility.originalPaymentMethod.label} notice={eligibility.refundDestinationNotice} />
        <p className="flex items-start gap-2 text-sm text-text-secondary"><Info size={16} className="mt-0.5 shrink-0" aria-hidden="true" />Filing creates a Case ID only. It never creates or changes a refund.</p>
        {error && <StatusMessage tone="error">{error}</StatusMessage>}
        <div className="flex flex-wrap gap-3"><Button type="submit" disabled={busy}>{busy ? 'Filing…' : 'File case'}</Button><StatusBadge label="Buyer response window: 48 hours" tone="neutral" /></div>
      </form>}
  </div>
}
