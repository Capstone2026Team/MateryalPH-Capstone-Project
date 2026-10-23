import { useCallback, useEffect, useState } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import { Banknote, Clock, FileText, RefreshCw, Undo2 } from 'lucide-react'
import { ALL_DATES, Button, ConfirmDialog, ControlBar, DateFilter, DocumentExportButton, EmptyState, FilterChips, FilterPanel, FilterTabs, Pagination, RefundStatusBadge, StatCard, StatusBadge, StatusMessage, formatManilaDateTime, formatPesoCentavos } from '@materyalph/web-ui'
import {
  confirmReimbursement, getSummary, listCancellationRequests, listRefunds, listReimbursements, retryRefund,
  type AdminCancellationRequestRow, type AdminOrderOperationsSummary, type AdminRefundRow, type AdminReimbursementRow,
} from '../lib/order-operations-api'
import { readableVerificationError } from '../lib/vendor-verification-api'
import { AdminShell, ErrorState, LoadingState, PageHeader } from './PhaseThreeAdminPages'

type View = 'refunds' | 'reimbursements' | 'requests'
type RefundState = 'REFUND_FAILED' | 'REFUND_PENDING' | 'REFUNDED'
const VIEWS: { value: View; label: string }[] = [{ value: 'refunds', label: 'Refunds' }, { value: 'reimbursements', label: 'Cash reimbursements' }, { value: 'requests', label: 'Open cancellation requests' }]
const REFUND_STATUSES: { value: RefundState; label: string }[] = [
  { value: 'REFUND_FAILED', label: 'Failed' },
  { value: 'REFUND_PENDING', label: 'Awaiting provider' },
  { value: 'REFUNDED', label: 'Processed' },
]
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
    setSummaryError(null)
    getSummary().then(value => { if (active) setSummary(value) }).catch(async cause => { const text = await readableVerificationError(cause); if (active) setSummaryError(text) })
    return () => { active = false }
  }, [attempt])
  const chips = VIEWS.map(item => ({ ...item, count: summary ? (item.value === 'refunds' ? summary.refundsTotal : item.value === 'reimbursements' ? summary.reimbursementsTotal : summary.cancellationRequestsOpen) : undefined }))
  return <AdminShell activeHref="/order-operations"><div className="grid min-w-0 gap-4">
    <PageHeader compact eyebrow="Orders" title="Orders and refunds" description="Monitor refund status, Vendor cash reimbursements, and Buyer cancellation requests. Refunds return only to the original payment method. All figures are TEST."
      actions={<><Link to="/invoices" className="inline-flex min-h-11 items-center gap-2 rounded-control px-4 text-sm font-semibold text-action-primary underline-offset-4 hover:underline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-focus-ring"><FileText size={16} aria-hidden="true" />Invoice Request Log</Link><Button variant="secondary" onClick={reload}><RefreshCw size={16} aria-hidden="true" />Refresh</Button></>} />
    {summaryError ? <ErrorState message={summaryError} onRetry={reload} /> : summary && <dl aria-label="Order operations summary" className="grid min-w-0 gap-4 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-5 xl:[&_dt]:min-h-10 xl:[&_dt]:items-start">
      {[['Failed refunds', summary.refundsFailed], ['Refunds awaiting provider', summary.refundsPending], ['Reimbursements pending', summary.reimbursementsPending], ['Open cancellation requests', summary.cancellationRequestsOpen], ['Vendor cancellations (30 days)', summary.nfrEvents30Days]].map(([label, value]) =>
        <StatCard key={String(label)} label={String(label)} value={value} />)}
    </dl>}
    <FilterTabs appearance="tabs" label="Order operations view" chips={chips} value={view} onChange={value => setParams({ view: value })} />
    {view === 'refunds' && <RefundList onChanged={reload} refreshVersion={attempt} />}
    {view === 'reimbursements' && <ReimbursementList onChanged={reload} refreshVersion={attempt} />}
    {view === 'requests' && <RequestList refreshVersion={attempt} />}
  </div></AdminShell>
}

function RefundList({ onChanged, refreshVersion }: { onChanged: () => void; refreshVersion: number }) {
  const [state, setState] = useState<RefundState>('REFUND_FAILED')
  const [range, setRange] = useState(ALL_DATES)
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
    listRefunds(page, state, range).then(value => { if (active) { setRows(value.items); setMore(value.hasMore) } }).catch(async cause => { const text = await readableVerificationError(cause); if (active) setError(text) })
    return () => { active = false }
  }, [page, state, range, attempt, refreshVersion])
  async function retry(row: AdminRefundRow) {
    setRetrying(row.id); setNotice(null)
    try { await retryRefund(row.id); setNotice({ tone: 'success', text: 'Refund re-sent to the original payment. It stays pending until the provider confirms it.' }); setAttempt(value => value + 1); onChanged() }
    catch (cause) { setNotice({ tone: 'error', text: await readableVerificationError(cause) }) } finally { setRetrying(null) }
  }
  return <section className="grid min-w-0 gap-4" aria-label="Refunds">
    <FilterPanel label="Refund filters">
      <ControlBar tabs={<div className="grid min-w-0 gap-2">
        <p className="text-sm font-semibold">Status</p>
        <FilterChips label="Refund status" chips={REFUND_STATUSES} value={state} onChange={value => { setPage(1); setState(value as RefundState) }} />
      </div>} actions={<>
        <div className="grid min-w-0 gap-2"><p className="text-sm font-semibold">Requested dates</p><div className="flex min-w-0"><DateFilter title="Refund requested dates" value={range} onChange={value => { setRange(value); setPage(1) }} /></div></div>
        {(state !== 'REFUND_FAILED' || range.from || range.to) && <Button variant="quiet" className="self-end" onClick={() => { setState('REFUND_FAILED'); setRange(ALL_DATES); setPage(1) }}>Reset filters</Button>}
      </>} />
    </FilterPanel>
    {notice && <StatusMessage tone={notice.tone}>{notice.text}</StatusMessage>}
    {error ? <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} /> : rows === null ? <LoadingState /> : rows.length === 0
      ? <EmptyState message="No refunds in this status." />
      : <ul className="grid min-w-0 divide-y divide-border-default rounded-surface border border-border-default bg-surface-primary">{rows.map(row => <li key={row.id} className="grid min-w-0 gap-4 p-4 sm:p-5 xl:grid-cols-[minmax(0,1fr)_auto] xl:items-start">
        <div className="flex min-w-0 items-start gap-3">
          <span className="grid size-10 shrink-0 place-items-center rounded-control bg-surface-canvas text-text-secondary"><Undo2 size={18} aria-hidden="true" /></span>
          <div className="grid min-w-0 gap-2">
            <div><h2 className="break-words text-base font-semibold">{row.orderReference ?? row.statementReference ?? 'Platform fee'}</h2><p className="mt-1 break-words text-sm text-text-secondary">{TRIGGERS[row.trigger] ?? row.trigger} · {row.vendorName ?? 'Vendor'}</p></div>
            <div className="flex min-w-0 flex-wrap"><RefundStatusBadge displayState={row.displayState} /></div>
            {row.requestedAt && <p className="flex items-start gap-2 text-sm text-text-secondary"><Clock size={15} aria-hidden="true" className="mt-0.5 shrink-0" /><span className="min-w-0 break-words">Requested {formatManilaDateTime(row.requestedAt)}</span></p>}
            {(row.attemptNumber > 1 || row.failureCode || row.evidenceOrigin === 'SIMULATED') && <div className="flex min-w-0 flex-wrap items-center gap-x-3 gap-y-2 text-xs text-text-secondary">
              {row.attemptNumber > 1 && <span>Attempt {row.attemptNumber}</span>}{row.failureCode && <span className="break-all">{row.failureCode}</span>}{row.evidenceOrigin === 'SIMULATED' && <StatusBadge label="SIMULATED" tone="warning" />}
            </div>}
          </div>
        </div>
        <div className="grid min-w-0 gap-3 border-t border-border-default pt-4 xl:justify-items-end xl:border-0 xl:pt-0">
          <div className="flex flex-wrap items-baseline justify-between gap-x-4 gap-y-1 xl:grid xl:justify-items-end"><p className="text-xs text-text-secondary">Refund amount</p><p className="text-lg font-semibold tabular-nums">{formatPesoCentavos(row.amountCentavos)}</p></div>
          {(row.orderId || row.canRetry) && <div className="flex min-w-0 flex-col gap-2 sm:flex-row sm:flex-wrap xl:justify-end">
            {row.orderId && <DocumentExportButton basePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} audience="admin" types={['PURCHASE_ORDER', 'OPERATIONAL_ORDER', 'PAYMENT_CONFIRMATION']} resourceId={row.orderId} title={row.orderReference ?? 'Order'} />}
            {row.canRetry && <Button variant="secondary" className="whitespace-normal" disabled={retrying === row.id} onClick={() => void retry(row)}>{retrying === row.id ? 'Retrying…' : 'Retry after funding is resolved'}</Button>}
          </div>}
        </div>
      </li>)}</ul>}
    {(page > 1 || more) && <Pagination page={page} hasMore={more} busy={rows === null} onChange={setPage} />}
  </section>
}

function ReimbursementList({ onChanged, refreshVersion }: { onChanged: () => void; refreshVersion: number }) {
  const [range, setRange] = useState(ALL_DATES)
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
    listReimbursements(range).then(value => { if (active) setRows(value) }).catch(async cause => { const text = await readableVerificationError(cause); if (active) setError(text) })
    return () => { active = false }
  }, [attempt, range, refreshVersion])
  async function decide() {
    if (!target || reason.trim().length < 10) { setDialogError('Record the reason for this decision in at least 10 characters.'); return }
    setBusy(true); setDialogError(null)
    try { await confirmReimbursement(target.id, reason.trim()); setTarget(null); setReason(''); setAttempt(value => value + 1); onChanged() }
    catch (cause) { setDialogError(await readableVerificationError(cause)) } finally { setBusy(false) }
  }
  const filters = <FilterPanel label="Reimbursement filters"><div className="flex min-w-0 flex-wrap items-end gap-4"><div className="grid min-w-0 gap-2"><p className="text-sm font-semibold">Recorded dates</p><div className="flex min-w-0"><DateFilter title="Reimbursement recorded dates" value={range} onChange={setRange} /></div></div>{(range.from || range.to) && <Button variant="quiet" className="sm:ml-auto" onClick={() => setRange(ALL_DATES)}>Reset dates</Button>}</div></FilterPanel>
  if (error) return <section className="grid gap-4">{filters}<ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} /></section>
  if (rows === null) return <section className="grid gap-4">{filters}<LoadingState /></section>
  return <section className="grid min-w-0 gap-4" aria-label="Cash reimbursements">
    {filters}
    <p className="max-w-3xl text-sm leading-6 text-text-secondary">Cash the Buyer paid the Vendor directly on a cancelled order. The Vendor returns it with evidence; the Buyer's acknowledgment or a reasoned decision here confirms it. MateryalPH never moves this money.</p>
    {rows.length === 0 ? <EmptyState message="No cash reimbursements." />
      : <ul className="grid min-w-0 divide-y divide-border-default rounded-surface border border-border-default bg-surface-primary">{rows.map(row => <li key={row.id} className="grid min-w-0 gap-4 p-4 sm:p-5 xl:grid-cols-[minmax(0,1fr)_auto] xl:items-start">
        <div className="flex min-w-0 items-start gap-3">
          <span className="grid size-10 shrink-0 place-items-center rounded-control bg-surface-canvas text-text-secondary"><Banknote size={18} aria-hidden="true" /></span>
          <div className="grid min-w-0 gap-2">
            <div><h2 className="break-words text-base font-semibold">{row.orderReference}</h2><p className="mt-1 break-words text-sm text-text-secondary">{row.vendorName ?? 'Vendor'}</p></div>
            <div className="flex min-w-0 flex-wrap"><StatusBadge label={row.state === 'REIMBURSEMENT_CONFIRMED' ? (row.confirmedByReview ? 'Confirmed by review' : 'Confirmed by the Buyer') : row.hasEvidence ? 'Vendor evidence recorded — awaiting confirmation' : 'Awaiting Vendor evidence'}
              tone={row.state === 'REIMBURSEMENT_CONFIRMED' ? 'success' : 'warning'} /></div>
            {row.reimbursedAt && <p className="flex items-start gap-2 text-sm text-text-secondary"><Clock size={15} aria-hidden="true" className="mt-0.5 shrink-0" /><span className="min-w-0 break-words">Reimbursed {formatManilaDateTime(row.reimbursedAt)}</span></p>}
          </div>
        </div>
        <div className="grid min-w-0 gap-3 border-t border-border-default pt-4 xl:justify-items-end xl:border-0 xl:pt-0">
          <div className="flex flex-wrap items-baseline justify-between gap-x-4 gap-y-1 xl:grid xl:justify-items-end"><p className="text-xs text-text-secondary">Reimbursement amount</p><p className="text-lg font-semibold tabular-nums">{formatPesoCentavos(row.amountCentavos)}</p></div>
          {row.canDecide && <Button variant="secondary" onClick={() => { setTarget(row); setDialogError(null) }}>Confirm with reason</Button>}
        </div>
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

function RequestList({ refreshVersion }: { refreshVersion: number }) {
  const [range, setRange] = useState(ALL_DATES)
  const [rows, setRows] = useState<AdminCancellationRequestRow[] | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  useEffect(() => {
    let active = true
    setRows(null); setError(null)
    listCancellationRequests(range).then(value => { if (active) setRows(value) }).catch(async cause => { const text = await readableVerificationError(cause); if (active) setError(text) })
    return () => { active = false }
  }, [attempt, range, refreshVersion])
  const filters = <FilterPanel label="Cancellation request filters"><div className="flex min-w-0 flex-wrap items-end gap-4"><div className="grid min-w-0 gap-2"><p className="text-sm font-semibold">Requested dates</p><div className="flex min-w-0"><DateFilter title="Cancellation request dates" value={range} onChange={setRange} /></div></div>{(range.from || range.to) && <Button variant="quiet" className="sm:ml-auto" onClick={() => setRange(ALL_DATES)}>Reset dates</Button>}</div></FilterPanel>
  if (error) return <section className="grid gap-4">{filters}<ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} /></section>
  if (rows === null) return <section className="grid gap-4">{filters}<LoadingState /></section>
  return <section className="grid min-w-0 gap-4" aria-label="Open cancellation requests">
    {filters}
    <p className="max-w-3xl text-sm leading-6 text-text-secondary">Buyer requests during preparation. The Vendor has 24 hours to finalize; an unanswered request is finalized automatically with a full refund.</p>
    {rows.length === 0 ? <EmptyState message="No open cancellation requests." />
      : <ul className="grid min-w-0 divide-y divide-border-default rounded-surface border border-border-default bg-surface-primary">{rows.map(row => <li key={row.id} className="grid min-w-0 gap-4 p-4 sm:p-5 xl:grid-cols-[minmax(0,1fr)_auto] xl:items-start">
        <div className="flex min-w-0 items-start gap-3">
          <span className="grid size-10 shrink-0 place-items-center rounded-control bg-surface-canvas text-text-secondary"><Clock size={18} aria-hidden="true" /></span>
          <div className="grid min-w-0 gap-2">
            <div><h2 className="break-words text-base font-semibold">{row.orderReference}</h2><p className="mt-1 break-words text-sm text-text-secondary">{row.vendorName ?? 'Vendor'} · {row.reasonCode.toLowerCase().replaceAll('_', ' ')}</p></div>
            {row.responseDueAt && <p className="break-words text-sm text-text-secondary">Vendor response due {formatManilaDateTime(row.responseDueAt)}</p>}
            {row.overdue && <div className="flex min-w-0 flex-wrap"><StatusBadge label="Past due — finalizing automatically" tone="warning" /></div>}
          </div>
        </div>
        {row.orderId && <div className="flex min-w-0 border-t border-border-default pt-4 xl:justify-end xl:border-0 xl:pt-0"><DocumentExportButton basePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} audience="admin" types={['PURCHASE_ORDER', 'OPERATIONAL_ORDER', 'PAYMENT_CONFIRMATION']} resourceId={row.orderId} title={row.orderReference} /></div>}
      </li>)}</ul>}
  </section>
}
