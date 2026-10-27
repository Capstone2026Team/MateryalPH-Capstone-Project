import { useCallback, useEffect, useState } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import { AlertCircle, Banknote, Clock, FileText, RefreshCw, Undo2, XCircle } from 'lucide-react'
import { ALL_DATES, Button, ConfirmDialog, ControlBar, DateFilter, DocumentExportButton, EmptyState, FilterChips, FilterPanel, FilterTabs, Pagination, RefundStatusBadge, ResponsiveRecordList, StatCard, StatusBadge, StatusMessage, buttonClassName, formatManilaDateTime, formatPesoCentavos, type RecordColumn } from '@materyalph/web-ui'
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
const referenceClass = 'break-words font-semibold text-text-strong'
const amountClass = 'whitespace-nowrap font-semibold tabular-nums text-text-strong'
const methodLabel = (method: string) => ({ IN_STORE: 'In-Store Payment', CASH_ON_DELIVERY: 'Cash on Delivery' } as Record<string, string>)[method] ?? method.replaceAll('_', ' ')

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
  return <AdminShell activeHref="/order-operations"><div className="grid min-w-0 gap-6">
    <PageHeader eyebrow="Tracking" title="Orders & Refunds Logs" description="Review refund activity, Vendor cash reimbursements and Buyer cancellation requests."
      actions={<><Link to="/invoices" className={buttonClassName('secondary')}><FileText size={16} aria-hidden="true" />Invoice Request Log</Link><Button variant="secondary" onClick={reload}><RefreshCw size={16} aria-hidden="true" />Refresh</Button></>} />
    <div className="flex min-w-0 flex-wrap items-center justify-between gap-x-6 gap-y-2 rounded-control border border-border-default bg-surface-primary px-4 py-3 text-xs leading-5 text-text-secondary"><span>TEST records · Refunds return to the original payment method.</span><span>Dates and deadlines in Asia/Manila</span></div>
    <section aria-labelledby="order-summary-heading" className="grid gap-3">
      <div className="flex flex-wrap items-baseline justify-between gap-x-4 gap-y-1"><h2 id="order-summary-heading" className="text-sm font-semibold">Activity overview</h2><p className="text-xs text-text-secondary">Current exceptions · Vendor cancellations over the last 30 days</p></div>
      {summaryError ? <ErrorState message={summaryError} onRetry={reload} /> : !summary ? <LoadingState /> : <dl aria-label="Order operations summary" className="grid min-w-0 gap-3 sm:grid-cols-2 sm:[&>div:last-child]:col-span-2 lg:grid-cols-3 xl:grid-cols-5 xl:[&>div:last-child]:col-span-1 xl:[&_dt]:min-h-10 xl:[&_dt]:items-start">
        <StatCard label="Failed refunds" value={summary.refundsFailed} icon={<AlertCircle size={16} aria-hidden="true" />} />
        <StatCard label="Refunds awaiting provider" value={summary.refundsPending} icon={<Clock size={16} aria-hidden="true" />} />
        <StatCard label="Reimbursements pending" value={summary.reimbursementsPending} icon={<Banknote size={16} aria-hidden="true" />} />
        <StatCard label="Open cancellation requests" value={summary.cancellationRequestsOpen} icon={<FileText size={16} aria-hidden="true" />} />
        <StatCard label="Vendor cancellations (30 days)" value={summary.nfrEvents30Days} icon={<XCircle size={16} aria-hidden="true" />} />
      </dl>}
    </section>
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
  const columns: RecordColumn<AdminRefundRow>[] = [
    { key: 'reference', header: 'Order / statement', cell: row => <span className={referenceClass}>{row.orderReference ?? row.statementReference ?? 'Platform fee'}</span> },
    { key: 'vendor', header: 'Vendor & reason', cell: row => <div className="grid gap-1 lg:min-w-36"><span className="font-medium">{row.vendorName ?? 'Vendor'}</span><span className="text-xs text-text-secondary">{TRIGGERS[row.trigger] ?? row.trigger}</span></div> },
    { key: 'amount', header: 'Refund amount', className: amountClass, cell: row => <span className={amountClass}>{formatPesoCentavos(row.amountCentavos)}</span> },
    { key: 'status', header: 'Status', cell: row => <div className="grid gap-2 lg:min-w-44"><RefundStatusBadge displayState={row.displayState} />{row.evidenceOrigin === 'SIMULATED' && <span><StatusBadge label="SIMULATED" tone="warning" /></span>}{row.attemptNumber > 1 && <span className="text-xs text-text-secondary">Attempt {row.attemptNumber}</span>}{row.failureCode && <span className="break-all text-xs text-status-error">{row.failureCode}</span>}</div> },
    { key: 'requested', header: 'Requested', cell: row => <span className="text-text-secondary">{row.requestedAt ? formatManilaDateTime(row.requestedAt) : 'Not recorded'}</span> },
    { key: 'actions', header: 'Actions', cell: row => <div className="flex min-w-0 flex-wrap gap-2">{row.orderId && <DocumentExportButton basePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} audience="admin" types={['PURCHASE_ORDER', 'OPERATIONAL_ORDER', 'PAYMENT_CONFIRMATION']} resourceId={row.orderId} title={row.orderReference ?? 'Order'} />}{row.canRetry && <Button variant="secondary" className="max-w-56 whitespace-normal text-left" disabled={retrying === row.id} onClick={() => void retry(row)}>{retrying === row.id ? 'Retrying…' : 'Retry after funding is resolved'}</Button>}{!row.orderId && !row.canRetry && <span className="text-xs text-text-secondary">No actions available</span>}</div> },
  ]
  return <section className="grid min-w-0 gap-4" aria-label="Refunds">
    <div><h2 className="text-lg font-semibold">Refund log</h2><p className="mt-1 text-sm leading-6 text-text-secondary">Track refund instructions, provider confirmations and failed attempts.</p></div>
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
      : <ResponsiveRecordList caption="Refund records" rows={rows} columns={columns} rowKey={row => row.id} cardTitle={row => <span className="flex items-start gap-2"><Undo2 size={18} className="mt-0.5 shrink-0 text-action-primary" aria-hidden="true" />{row.orderReference ?? row.statementReference ?? 'Platform fee'}</span>} />}
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
  const columns: RecordColumn<AdminReimbursementRow>[] = [
    { key: 'reference', header: 'Order', cell: row => <span className={referenceClass}>{row.orderReference}</span> },
    { key: 'vendor', header: 'Vendor', cell: row => row.vendorName ?? 'Vendor' },
    { key: 'amount', header: 'Reimbursement amount', className: amountClass, cell: row => <span className={amountClass}>{formatPesoCentavos(row.amountCentavos)}</span> },
    { key: 'method', header: 'Payment method', cell: row => methodLabel(row.method) },
    { key: 'status', header: 'Status & evidence', cell: row => <div className="grid gap-2 lg:min-w-44"><StatusBadge label={row.state === 'REIMBURSEMENT_CONFIRMED' ? (row.confirmedByReview ? 'Confirmed by review' : 'Confirmed by the Buyer') : row.hasEvidence ? 'Vendor evidence recorded — awaiting confirmation' : 'Awaiting Vendor evidence'} tone={row.state === 'REIMBURSEMENT_CONFIRMED' ? 'success' : 'warning'} /></div> },
    { key: 'date', header: 'Reimbursed', cell: row => <span className="text-text-secondary">{row.reimbursedAt ? formatManilaDateTime(row.reimbursedAt) : 'Not recorded'}</span> },
    { key: 'actions', header: 'Action', cell: row => row.canDecide ? <Button variant="secondary" className="whitespace-normal" onClick={() => { setTarget(row); setDialogError(null) }}>Confirm with reason</Button> : <span className="text-xs text-text-secondary">{row.state === 'REIMBURSEMENT_CONFIRMED' ? 'Confirmation recorded' : 'Awaiting confirmation'}</span> },
  ]
  const filters = <FilterPanel label="Reimbursement filters"><div className="flex min-w-0 flex-wrap items-end gap-4"><div className="grid min-w-0 gap-2"><p className="text-sm font-semibold">Recorded dates</p><div className="flex min-w-0"><DateFilter title="Reimbursement recorded dates" value={range} onChange={setRange} /></div></div>{(range.from || range.to) && <Button variant="quiet" className="sm:ml-auto" onClick={() => setRange(ALL_DATES)}>Reset dates</Button>}</div></FilterPanel>
  if (error) return <section className="grid gap-4">{filters}<ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} /></section>
  if (rows === null) return <section className="grid gap-4">{filters}<LoadingState /></section>
  return <section className="grid min-w-0 gap-4" aria-label="Cash reimbursements">
    <div><h2 className="text-lg font-semibold">Cash reimbursement log</h2><p className="mt-1 max-w-3xl text-sm leading-6 text-text-secondary">Track cash returned directly by the Vendor, evidence and Buyer acknowledgment. MateryalPH never moves this money.</p></div>
    {filters}
    {rows.length === 0 ? <EmptyState message="No cash reimbursements." />
      : <ResponsiveRecordList caption="Cash reimbursement records" rows={rows} columns={columns} rowKey={row => row.id} cardTitle={row => <span className="flex items-start gap-2"><Banknote size={18} className="mt-0.5 shrink-0 text-action-primary" aria-hidden="true" />{row.orderReference}</span>} />}
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
  const columns: RecordColumn<AdminCancellationRequestRow>[] = [
    { key: 'reference', header: 'Order', cell: row => <span className={referenceClass}>{row.orderReference}</span> },
    { key: 'vendor', header: 'Vendor', cell: row => row.vendorName ?? 'Vendor' },
    { key: 'reason', header: 'Cancellation reason', cell: row => row.reasonCode.toLowerCase().replaceAll('_', ' ') },
    { key: 'deadline', header: 'Vendor response due', cell: row => <span className="text-text-secondary">{row.responseDueAt ? formatManilaDateTime(row.responseDueAt) : 'Not recorded'}</span> },
    { key: 'status', header: 'Status', cell: row => <StatusBadge label={row.overdue ? 'Past due — finalizing automatically' : 'Awaiting Vendor response'} tone={row.overdue ? 'warning' : 'neutral'} /> },
    { key: 'documents', header: 'Documents', cell: row => row.orderId ? <DocumentExportButton basePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} audience="admin" types={['PURCHASE_ORDER', 'OPERATIONAL_ORDER', 'PAYMENT_CONFIRMATION']} resourceId={row.orderId} title={row.orderReference} /> : <span className="text-xs text-text-secondary">No linked order</span> },
  ]
  if (error) return <section className="grid gap-4">{filters}<ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} /></section>
  if (rows === null) return <section className="grid gap-4">{filters}<LoadingState /></section>
  return <section className="grid min-w-0 gap-4" aria-label="Open cancellation requests">
    <div><h2 className="text-lg font-semibold">Cancellation request log</h2><p className="mt-1 max-w-3xl text-sm leading-6 text-text-secondary">Buyer requests during preparation. The Vendor has 24 hours to finalize; an unanswered request is finalized automatically with a full refund.</p></div>
    {filters}
    {rows.length === 0 ? <EmptyState message="No open cancellation requests." />
      : <ResponsiveRecordList caption="Cancellation request records" rows={rows} columns={columns} rowKey={row => row.id} cardTitle={row => <span className="flex items-start gap-2"><Clock size={18} className="mt-0.5 shrink-0 text-action-primary" aria-hidden="true" />{row.orderReference}</span>} />}
  </section>
}
