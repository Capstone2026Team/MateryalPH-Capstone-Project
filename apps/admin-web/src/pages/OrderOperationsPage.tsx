import { useCallback, useEffect, useState } from 'react'
import { useSearchParams } from 'react-router-dom'
import { Banknote, Clock, RefreshCw, Undo2 } from 'lucide-react'
import { Button, ConfirmDialog, FilterChips, RefundStatusBadge, StatusBadge, StatusMessage, formatManilaDateTime, formatPesoCentavos } from '@materyalph/web-ui'
import {
  confirmReimbursement, getSummary, listCancellationRequests, listRefunds, listReimbursements, retryRefund,
  type AdminCancellationRequestRow, type AdminOrderOperationsSummary, type AdminRefundRow, type AdminReimbursementRow,
} from '../lib/order-operations-api'
import { readableVerificationError } from '../lib/vendor-verification-api'
import { AdminShell, ErrorState, LoadingState, PageHeader } from './PhaseThreeAdminPages'

type View = 'refunds' | 'reimbursements' | 'requests'
const VIEWS: { value: View; label: string }[] = [{ value: 'refunds', label: 'Refunds' }, { value: 'reimbursements', label: 'Cash reimbursements' }, { value: 'requests', label: 'Open cancellation requests' }]
const TRIGGERS: Record<string, string> = { CANCELLATION: 'Cancellation', DISPUTE_CONCLUSION: 'Dispute conclusion', TECHNICAL_COMPENSATION: 'Technical compensation', FEE_CREDIT: 'Platform fee credit' }

/**
 * Order operations for Order and Dispute Staff and Super Admin: refund exceptions with an authorized retry to the
 * original payment, evidenced Vendor cash reimbursements and open Buyer cancellation requests. Admins never hold,
 * receive or disburse money; every action is authorized again on the server and a 403 is explained.
 */
export function AdminOrderOperationsPage() {
  const [params, setParams] = useSearchParams()
  const view = (VIEWS.some(item => item.value === params.get('view')) ? params.get('view') : 'refunds') as View
  const [summary, setSummary] = useState<AdminOrderOperationsSummary | null>(null)
  const [summaryError, setSummaryError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  const reload = useCallback(() => setAttempt(value => value + 1), [])
  useEffect(() => {
    let active = true
    getSummary().then(value => { if (active) setSummary(value) }).catch(async cause => { const text = await readableVerificationError(cause); if (active) setSummaryError(text) })
    return () => { active = false }
  }, [attempt])
  const chips = VIEWS.map(item => ({ ...item, count: summary ? (item.value === 'refunds' ? summary.refundsFailed : item.value === 'reimbursements' ? summary.reimbursementsPending : summary.cancellationRequestsOpen) : undefined }))
  return <AdminShell activeHref="/order-operations"><div className="grid min-w-0 gap-6">
    <PageHeader eyebrow="Orders" title="Orders and refunds" description="Cancellation Refunds and their provider status, Vendor cash reimbursements and open Buyer cancellation requests. Refunds return only to the original payment method; figures are TEST."
      actions={<Button variant="secondary" onClick={reload}><RefreshCw size={16} aria-hidden="true" />Refresh</Button>} />
    {summaryError ? <ErrorState message={summaryError} onRetry={reload} /> : summary && <dl className="grid gap-x-6 gap-y-3 border-b border-border-default pb-5 sm:grid-cols-2 lg:grid-cols-5">
      {[['Failed refunds', summary.refundsFailed], ['Refunds awaiting provider', summary.refundsPending], ['Reimbursements pending', summary.reimbursementsPending], ['Open cancellation requests', summary.cancellationRequestsOpen], ['Vendor cancellations (30 days)', summary.nfrEvents30Days]].map(([label, value]) =>
        <div key={String(label)} className="grid gap-1"><dt className="text-xs font-semibold uppercase tracking-wide text-text-secondary">{label}</dt><dd className="text-2xl font-semibold tabular-nums">{value}</dd></div>)}
    </dl>}
    <FilterChips label="Order operations view" chips={chips} value={view} onChange={value => setParams({ view: value })} />
    {view === 'refunds' && <RefundList onChanged={reload} />}
    {view === 'reimbursements' && <ReimbursementList onChanged={reload} />}
    {view === 'requests' && <RequestList />}
  </div></AdminShell>
}

function RefundList({ onChanged }: { onChanged: () => void }) {
  const [state, setState] = useState<'REFUND_FAILED' | 'REFUND_PENDING' | 'REFUNDED' | ''>('REFUND_FAILED')
  const [page, setPage] = useState(1)
  const [rows, setRows] = useState<AdminRefundRow[] | null>(null)
  const [more, setMore] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [notice, setNotice] = useState<{ tone: 'success' | 'error'; text: string } | null>(null)
  const [retrying, setRetrying] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  useEffect(() => {
    let active = true
    setRows(null); setError(null)
    listRefunds(page, state || undefined).then(value => { if (active) { setRows(value.items); setMore(value.hasMore) } }).catch(async cause => { const text = await readableVerificationError(cause); if (active) setError(text) })
    return () => { active = false }
  }, [page, state, attempt])
  async function retry(row: AdminRefundRow) {
    setRetrying(row.id); setNotice(null)
    try { await retryRefund(row.id); setNotice({ tone: 'success', text: 'Refund re-sent to the original payment. It stays pending until the provider confirms it.' }); setAttempt(value => value + 1); onChanged() }
    catch (cause) { setNotice({ tone: 'error', text: await readableVerificationError(cause) }) } finally { setRetrying(null) }
  }
  return <section className="grid gap-4" aria-label="Refunds">
    <label className="grid max-w-xs gap-2 text-sm font-semibold">Status<select className="min-h-12 rounded-control border border-border-default bg-surface-primary px-3 text-base font-normal" value={state} onChange={event => { setPage(1); setState(event.target.value as typeof state) }}>
      <option value="REFUND_FAILED">Failed</option><option value="REFUND_PENDING">Awaiting provider</option><option value="REFUNDED">Processed</option><option value="">All</option></select></label>
    {notice && <StatusMessage tone={notice.tone}>{notice.text}</StatusMessage>}
    {error ? <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} /> : rows === null ? <LoadingState /> : rows.length === 0
      ? <p className="rounded-surface border border-dashed border-border-default px-6 py-10 text-center text-sm text-text-secondary">No refunds in this status.</p>
      : <ul className="grid divide-y divide-border-default rounded-surface border border-border-default bg-surface-primary">{rows.map(row => <li key={row.id} className="grid gap-2 px-4 py-3 sm:grid-cols-[minmax(0,1fr)_auto] sm:items-center">
        <div className="grid min-w-0 gap-1">
          <p className="flex flex-wrap items-center gap-2 font-semibold"><Undo2 size={15} aria-hidden="true" />{TRIGGERS[row.trigger] ?? row.trigger} · {row.orderReference ?? row.statementReference ?? 'Platform fee'} · <span className="tabular-nums">{formatPesoCentavos(row.amountCentavos)}</span></p>
          <RefundStatusBadge displayState={row.displayState} />
          <p className="text-sm text-text-secondary">{row.vendorName ?? 'Vendor'}{row.requestedAt ? ` · requested ${formatManilaDateTime(row.requestedAt)}` : ''}{row.attemptNumber > 1 ? ` · attempt ${row.attemptNumber}` : ''}{row.failureCode ? ` · ${row.failureCode}` : ''}{row.evidenceOrigin === 'SIMULATED' ? ' · SIMULATED' : ''}</p>
        </div>
        {row.canRetry && <Button variant="secondary" disabled={retrying === row.id} onClick={() => void retry(row)}>{retrying === row.id ? 'Retrying…' : 'Retry after funding is resolved'}</Button>}
      </li>)}</ul>}
    {(page > 1 || more) && <nav aria-label="Refund pages" className="flex gap-2"><Button variant="secondary" disabled={page <= 1} onClick={() => setPage(page - 1)}>Previous</Button><Button variant="secondary" disabled={!more} onClick={() => setPage(page + 1)}>Next</Button></nav>}
  </section>
}

function ReimbursementList({ onChanged }: { onChanged: () => void }) {
  const [rows, setRows] = useState<AdminReimbursementRow[] | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [target, setTarget] = useState<AdminReimbursementRow | null>(null)
  const [reason, setReason] = useState('')
  const [busy, setBusy] = useState(false)
  const [dialogError, setDialogError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  useEffect(() => {
    let active = true
    setRows(null); setError(null)
    listReimbursements().then(value => { if (active) setRows(value) }).catch(async cause => { const text = await readableVerificationError(cause); if (active) setError(text) })
    return () => { active = false }
  }, [attempt])
  async function decide() {
    if (!target || reason.trim().length < 10) { setDialogError('Record the reason for this decision in at least 10 characters.'); return }
    setBusy(true); setDialogError(null)
    try { await confirmReimbursement(target.id, reason.trim()); setTarget(null); setReason(''); setAttempt(value => value + 1); onChanged() }
    catch (cause) { setDialogError(await readableVerificationError(cause)) } finally { setBusy(false) }
  }
  if (error) return <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} />
  if (rows === null) return <LoadingState />
  return <section className="grid gap-4" aria-label="Cash reimbursements">
    <p className="text-sm text-text-secondary">Cash the Buyer paid the Vendor directly on a cancelled order. The Vendor returns it with evidence; the Buyer's acknowledgment or a reasoned decision here confirms it. MateryalPH never moves this money.</p>
    {rows.length === 0 ? <p className="rounded-surface border border-dashed border-border-default px-6 py-10 text-center text-sm text-text-secondary">No cash reimbursements.</p>
      : <ul className="grid divide-y divide-border-default rounded-surface border border-border-default bg-surface-primary">{rows.map(row => <li key={row.id} className="grid gap-2 px-4 py-3 sm:grid-cols-[minmax(0,1fr)_auto] sm:items-center">
        <div className="grid gap-1">
          <p className="flex items-center gap-2 font-semibold"><Banknote size={15} aria-hidden="true" />{row.orderReference} · <span className="tabular-nums">{formatPesoCentavos(row.amountCentavos)}</span></p>
          <StatusBadge label={row.state === 'REIMBURSEMENT_CONFIRMED' ? (row.confirmedByReview ? 'Confirmed by review' : 'Confirmed by the Buyer') : row.hasEvidence ? 'Vendor evidence recorded — awaiting confirmation' : 'Awaiting Vendor evidence'}
            tone={row.state === 'REIMBURSEMENT_CONFIRMED' ? 'success' : 'warning'} />
          <p className="text-sm text-text-secondary">{row.vendorName ?? 'Vendor'}{row.reimbursedAt ? ` · reimbursed ${formatManilaDateTime(row.reimbursedAt)}` : ''}</p>
        </div>
        {row.canDecide && <Button variant="secondary" onClick={() => { setTarget(row); setDialogError(null) }}>Confirm with reason</Button>}
      </li>)}</ul>}
    <ConfirmDialog open={target !== null} tone="primary" title="Confirm this cash reimbursement?" confirmLabel="Confirm reimbursement" busy={busy} onCancel={() => setTarget(null)} onConfirm={() => void decide()}>
      <div className="grid gap-3 text-text-strong">
        <p className="text-text-secondary">Use this only after reviewing the Vendor's evidence when the Buyer cannot or does not acknowledge it. The decision and reason are audited.</p>
        <label className="grid gap-2 text-sm font-semibold">Reason<textarea className="min-h-20 rounded-control border border-border-default px-3 py-2 text-base font-normal" maxLength={2000} value={reason} onChange={event => setReason(event.target.value)} /></label>
        {dialogError && <p role="alert" className="text-sm text-status-error">{dialogError}</p>}
      </div>
    </ConfirmDialog>
  </section>
}

function RequestList() {
  const [rows, setRows] = useState<AdminCancellationRequestRow[] | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  useEffect(() => {
    let active = true
    listCancellationRequests().then(value => { if (active) setRows(value) }).catch(async cause => { const text = await readableVerificationError(cause); if (active) setError(text) })
    return () => { active = false }
  }, [attempt])
  if (error) return <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} />
  if (rows === null) return <LoadingState />
  return <section className="grid gap-4" aria-label="Open cancellation requests">
    <p className="text-sm text-text-secondary">Buyer requests during preparation. The Vendor has 24 hours to finalize; an unanswered request is finalized automatically with a full refund.</p>
    {rows.length === 0 ? <p className="rounded-surface border border-dashed border-border-default px-6 py-10 text-center text-sm text-text-secondary">No open cancellation requests.</p>
      : <ul className="grid divide-y divide-border-default rounded-surface border border-border-default bg-surface-primary">{rows.map(row => <li key={row.id} className="grid gap-1 px-4 py-3">
        <p className="font-semibold">{row.orderReference} · {row.vendorName ?? 'Vendor'}</p>
        <p className="flex flex-wrap items-center gap-2 text-sm text-text-secondary"><Clock size={14} aria-hidden="true" />{row.reasonCode.toLowerCase().replaceAll('_', ' ')}{row.responseDueAt ? ` · Vendor response due ${formatManilaDateTime(row.responseDueAt)}` : ''}
          {row.overdue && <StatusBadge label="Past due — finalizing automatically" tone="warning" />}</p>
      </li>)}</ul>}
  </section>
}
