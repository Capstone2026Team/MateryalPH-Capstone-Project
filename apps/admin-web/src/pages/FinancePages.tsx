import { useCallback, useEffect, useState, type FormEvent, type ReactNode } from 'react'
import { Link, useParams, useSearchParams } from 'react-router-dom'
import { ArrowLeft, RefreshCw } from 'lucide-react'
import {
  Button, DemoLabel, FilterChips, PaymentAttemptBadge, StatusBadge, StatusMessage, ThresholdPanel, WithholdingStatusBadge, formatManilaDateTime, formatPesoCentavos,
} from '@materyalph/web-ui'
import {
  approveFeeCredit, approveStatement, draftStatements, getAccumulator, listAccumulators, listChannelFees, listPayments, listReviewItems, listStatements, resolveOverlap, resolveReviewItem,
  runReconciliation, type ChannelFeeVersion, type FinanceReviewItem, type Page, type WithholdingAccumulatorDetail, type WithholdingAccumulatorView,
} from '../lib/finance-api'
import { readableVerificationError } from '../lib/vendor-verification-api'
import { record, records, type JsonRecord } from '../lib/admin-format'
import { AdminShell, ErrorState, LoadingState, PageHeader } from './PhaseThreeAdminPages'

type View = 'payments' | 'queue' | 'withholding' | 'statements' | 'channels'
const VIEWS: { value: View; label: string }[] = [
  { value: 'queue', label: 'Work queue' }, { value: 'payments', label: 'Payment log' }, { value: 'withholding', label: 'Withholding threshold' },
  { value: 'statements', label: 'Commission statements' }, { value: 'channels', label: 'Channel fees' },
]

/**
 * Admin finance on the existing finance.* permissions. Every action is authorized again on the server; a 403
 * renders the explanation, never hidden data. Preparer and reviewer must differ for credits and adjustments.
 */
export function AdminFinancePage() {
  const [params, setParams] = useSearchParams()
  const view = (VIEWS.some(item => item.value === params.get('view')) ? params.get('view') : 'queue') as View
  const [notice, setNotice] = useState<{ tone: 'success' | 'error'; text: string } | null>(null)
  const [busy, setBusy] = useState(false)
  async function reconcile() {
    setBusy(true); setNotice(null)
    try { const counts = await runReconciliation(); setNotice({ tone: 'success', text: `Reconciliation ran: ${Number(counts.reconciled ?? 0)} attempts, ${Number(counts.webhooks ?? 0)} webhooks, ${Number(counts.refunds ?? 0)} compensation refunds checked.` }) }
    catch (cause) { setNotice({ tone: 'error', text: await readableVerificationError(cause) }) }
    finally { setBusy(false) }
  }
  return <AdminShell activeHref="/finance"><div className="grid min-w-0 gap-6">
    <PageHeader eyebrow="Finance" title="Transactions and finance" description="Verified payments, reconciliation exceptions, FIN-04A withholding accumulators and monthly commission statements. Figures are TEST/DEMO; no BIR filing occurs."
      actions={<><DemoLabel /><Button variant="secondary" disabled={busy} onClick={() => void reconcile()}><RefreshCw size={16} aria-hidden="true" />{busy ? 'Reconciling…' : 'Run reconciliation'}</Button></>} />
    {notice && <StatusMessage tone={notice.tone}>{notice.text}</StatusMessage>}
    <FilterChips label="Finance view" chips={VIEWS} value={view} onChange={value => setParams({ view: value })} />
    {view === 'queue' && <ReviewQueue />}
    {view === 'payments' && <PaymentLog />}
    {view === 'withholding' && <Accumulators />}
    {view === 'statements' && <Statements />}
    {view === 'channels' && <ChannelFees />}
  </div></AdminShell>
}

function usePaged<T>(load: (page: number) => Promise<Page<T>>, deps: unknown[]) {
  const [page, setPage] = useState(1)
  const [data, setData] = useState<Page<T> | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  const reload = useCallback(() => setAttempt(value => value + 1), [])
  useEffect(() => {
    let active = true
    setData(null); setError(null)
    load(page).then(value => { if (active) setData(value) }).catch(async cause => { const text = await readableVerificationError(cause); if (active) setError(text) })
    return () => { active = false }
    // eslint-disable-next-line react-hooks/exhaustive-deps -- reload on page, attempt and caller filters only.
  }, [page, attempt, ...deps])
  return { page, setPage, data, error, reload }
}

function Paged<T>({ state, empty, children }: { state: ReturnType<typeof usePaged<T>>; empty: string; children: (items: T[]) => ReactNode }) {
  if (state.error) return <ErrorState message={state.error} onRetry={state.reload} />
  if (!state.data) return <LoadingState />
  if (state.data.items.length === 0) return <p className="rounded-surface border border-dashed border-border-default bg-surface-primary p-8 text-center text-sm text-text-secondary">{empty}</p>
  return <div className="grid gap-4">{children(state.data.items)}
    {(state.page > 1 || state.data.hasMore) && <div className="flex items-center justify-between gap-3"><Button variant="secondary" disabled={state.page === 1} onClick={() => state.setPage(state.page - 1)}>Previous</Button><span className="text-sm text-text-secondary">Page {state.page} · {state.data.total} total</span><Button variant="secondary" disabled={!state.data.hasMore} onClick={() => state.setPage(state.page + 1)}>Next</Button></div>}
  </div>
}

function Table({ caption, headers, children }: { caption: string; headers: string[]; children: ReactNode }) {
  return <div className="min-w-0 overflow-x-auto rounded-surface border border-border-default bg-surface-primary"><table className="w-full min-w-[46rem] border-collapse text-left text-sm"><caption className="sr-only">{caption}</caption>
    <thead className="bg-surface-canvas text-xs uppercase tracking-wide text-text-secondary"><tr>{headers.map(header => <th key={header} scope="col" className="px-4 py-3 font-semibold">{header}</th>)}</tr></thead>
    <tbody className="divide-y divide-border-default">{children}</tbody></table></div>
}

const KIND_LABELS: Record<string, string> = {
  RECONCILIATION_EXCEPTION: 'Reconciliation exception', PAYMENT_MISMATCH: 'Payment mismatch', LATE_CAPTURE_COMPENSATION: 'Late capture compensated', OVERLAP_UNRESOLVED: 'Outside-platform overlap',
  THRESHOLD_ADJUSTMENT_REQUIRED: 'Threshold adjustment review', BASE_REVIEW_REQUIRED: 'Remittance base review', FEE_OVERPAYMENT: 'Fee overpayment', STATEMENT_OVERDUE: 'Statement overdue',
  FEE_CREDIT_PROPOSAL: 'Fee credit awaiting approval', PAID_FEE_CREDIT_PAYABLE: 'Credit on paid statement',
}

function ReviewQueue() {
  const [state, setStateFilter] = useState<'OPEN' | 'RESOLVED'>('OPEN')
  const paged = usePaged(page => listReviewItems(page, state), [state])
  return <section className="grid gap-4" aria-labelledby="queue-heading">
    <div className="flex flex-wrap items-center justify-between gap-3"><h2 id="queue-heading" className="text-lg font-semibold">Finance work queue</h2>
      <FilterChips label="Item state" chips={[{ value: 'OPEN', label: 'Open' }, { value: 'RESOLVED', label: 'Resolved' }]} value={state} onChange={value => setStateFilter(value as 'OPEN' | 'RESOLVED')} /></div>
    <Paged state={paged} empty={state === 'OPEN' ? 'No open finance work. Mismatches, late captures, overlap reviews and overdue statements appear here.' : 'No resolved items yet.'}>
      {items => <ul className="grid gap-3">{items.map(item => <ReviewItemRow key={item.id} item={item} onDone={paged.reload} />)}</ul>}
    </Paged>
  </section>
}

function ReviewItemRow({ item, onDone }: { item: FinanceReviewItem; onDone: () => void }) {
  const [resolution, setResolution] = useState('')
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const vendor = record(item.vendor)
  async function act(event?: FormEvent) {
    event?.preventDefault()
    setError(null)
    if (item.kind !== 'FEE_CREDIT_PROPOSAL' && resolution.trim().length < 10) { setError('Describe the resolution in at least 10 characters.'); return }
    setBusy(true)
    try { if (item.kind === 'FEE_CREDIT_PROPOSAL') await approveFeeCredit(item.id); else await resolveReviewItem(item.id, resolution.trim()); onDone() }
    catch (cause) { setError(await readableVerificationError(cause)) } finally { setBusy(false) }
  }
  return <li className="grid gap-3 rounded-surface border border-border-default bg-surface-primary p-4">
    <div className="flex flex-wrap items-start justify-between gap-2">
      <div><p className="font-semibold">{KIND_LABELS[item.kind] ?? item.kind}</p><p className="text-sm text-text-secondary">{String(vendor.name ?? 'Platform')} · {item.reasonCode.replaceAll('_', ' ').toLowerCase()} · {formatManilaDateTime(item.createdAt)}</p></div>
      <StatusBadge label={item.state === 'OPEN' ? 'Open' : 'Resolved'} tone={item.state === 'OPEN' ? 'warning' : 'success'} />
    </div>
    <p className="text-sm">{item.summary}</p>
    <details className="text-sm"><summary className="min-h-11 cursor-pointer font-semibold text-text-secondary">Expected and reported values</summary>
      <dl className="mt-2 grid gap-1">{Object.entries({ ...record(item.expected), ...Object.fromEntries(Object.entries(record(item.reported)).map(([key, value]) => [`reported ${key}`, value])) }).map(([key, value]) =>
        <div key={key} className="flex flex-wrap justify-between gap-3"><dt className="text-text-secondary">{key.replaceAll('_', ' ')}</dt><dd className="font-mono text-xs">{typeof value === 'object' ? JSON.stringify(value) : String(value)}</dd></div>)}</dl></details>
    {item.resolution && <p className="text-sm text-text-secondary">Resolution: {item.resolution}</p>}
    {error && <StatusMessage tone="error">{error}</StatusMessage>}
    {item.state === 'OPEN' && item.kind === 'OVERLAP_UNRESOLVED' && <Link className="text-sm font-semibold text-action-primary underline" to={`/finance/accumulators/${item.sourceId}`}>Record the overlap on the accumulator</Link>}
    {item.state === 'OPEN' && item.kind === 'FEE_CREDIT_PROPOSAL' && <div><Button disabled={busy} onClick={() => void act()}>{busy ? 'Approving…' : 'Approve credit (different reviewer)'}</Button></div>}
    {item.state === 'OPEN' && !['OVERLAP_UNRESOLVED', 'FEE_CREDIT_PROPOSAL'].includes(item.kind) && <form className="grid gap-2 sm:grid-cols-[minmax(0,1fr)_auto] sm:items-end" onSubmit={event => void act(event)}>
      <label className="grid gap-1.5 text-sm font-semibold">Resolution<input className="min-h-12 rounded-control border border-border-default px-3 text-base font-normal" value={resolution} onChange={event => setResolution(event.target.value)} disabled={busy} maxLength={2000} /></label>
      <Button type="submit" variant="secondary" disabled={busy}>{busy ? 'Saving…' : 'Resolve'}</Button>
    </form>}
  </li>
}

function PaymentLog() {
  const [state, setStateFilter] = useState('')
  const paged = usePaged(page => listPayments(page, state || undefined), [state])
  return <section className="grid gap-4" aria-labelledby="payments-heading">
    <div className="flex flex-wrap items-center justify-between gap-3"><h2 id="payments-heading" className="text-lg font-semibold">Payment log</h2>
      <FilterChips label="Attempt state" chips={[{ value: '', label: 'All' }, { value: 'PENDING', label: 'Pending' }, { value: 'UNCERTAIN', label: 'Uncertain' }, { value: 'PAID', label: 'Paid' }, { value: 'EXPIRED', label: 'Expired' }]} value={state} onChange={setStateFilter} /></div>
    <Paged state={paged} empty="No payment attempts match this filter.">
      {items => <Table caption="Payment attempts" headers={['Reference', 'Vendor', 'Purpose', 'Status', 'Total', 'Origin', 'Reconciliation', 'Created']}>
        {items.map(row => <tr key={String(row.id)}><td className="px-4 py-3 font-semibold">{String(row.reference ?? '—')}</td><td className="px-4 py-3">{String(row.vendor_name ?? '—')}</td>
          <td className="px-4 py-3">{String(row.purpose).replaceAll('_', ' ').toLowerCase()}</td><td className="px-4 py-3"><PaymentAttemptBadge status={String(row.status)} /></td>
          <td className="px-4 py-3 tabular-nums">{formatPesoCentavos(Number(row.total_centavos))}</td><td className="px-4 py-3">{String(row.evidence_origin)}</td>
          <td className="px-4 py-3">{String(row.reconciliation_state).replaceAll('_', ' ').toLowerCase()}{row.late_capture ? ' · late capture' : ''}</td><td className="px-4 py-3">{formatManilaDateTime(row.created_at as string)}</td></tr>)}
      </Table>}
    </Paged>
  </section>
}

function Accumulators() {
  const paged = usePaged(page => listAccumulators(page), [])
  return <section className="grid gap-4" aria-labelledby="withholding-heading">
    <h2 id="withholding-heading" className="text-lg font-semibold">FIN-04A withholding accumulators</h2>
    <Paged state={paged} empty="No accumulators yet. One is created per taxpayer and taxable year at the first simulated remittance.">
      {items => <Table caption="Withholding accumulators" headers={['Vendor', 'Year', 'Effective total', 'Remaining', 'Status', 'Crossed']}>
        {items.map((row: WithholdingAccumulatorView) => <tr key={row.id}><td className="px-4 py-3"><Link className="font-semibold text-action-primary underline" to={`/finance/accumulators/${row.id}`}>{String(record(row.vendor).name ?? '—')}</Link></td>
          <td className="px-4 py-3">{row.taxableYear}</td><td className="px-4 py-3 tabular-nums">{formatPesoCentavos(row.gEffectiveCentavos)}</td><td className="px-4 py-3 tabular-nums">{formatPesoCentavos(row.remainingAllowanceCentavos)}</td>
          <td className="px-4 py-3"><WithholdingStatusBadge status={row.status} /></td><td className="px-4 py-3">{row.crossedAt ? formatManilaDateTime(row.crossedAt) : '—'}</td></tr>)}
      </Table>}
    </Paged>
  </section>
}

export function AdminAccumulatorPage() {
  const { accumulatorId = '' } = useParams()
  const [data, setData] = useState<WithholdingAccumulatorDetail | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  useEffect(() => {
    let active = true
    setError(null)
    getAccumulator(accumulatorId).then(value => { if (active) setData(value) }).catch(async cause => { const text = await readableVerificationError(cause); if (active) setError(text) })
    return () => { active = false }
  }, [accumulatorId, attempt])
  const back = <Link to="/finance?view=withholding" className="inline-flex min-h-11 w-fit items-center gap-2 text-sm font-semibold text-text-secondary hover:text-text-strong"><ArrowLeft size={16} aria-hidden="true" />Withholding accumulators</Link>
  return <AdminShell activeHref="/finance"><div className="grid min-w-0 gap-6">
    {back}
    {error ? <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} /> : !data ? <LoadingState /> : <>
      <PageHeader eyebrow="Vendor Tax Profile" title={`${String(record(data.vendor).name ?? 'Vendor')} — taxable year ${data.taxableYear}`} description={`Taxpayer key …${data.taxpayerKeySuffix}. Raw TIN is never shown; masked value only.`} actions={<DemoLabel />} />
      <div className="rounded-surface border border-border-default bg-surface-primary p-4 sm:p-6">
        <ThresholdPanel data={{ taxableYear: data.taxableYear, thresholdCentavos: data.thresholdCentavos, cumulativeGrossCentavos: data.gEffectiveCentavos, remainingAllowanceCentavos: data.remainingAllowanceCentavos,
          localGrossCentavos: data.gAccumulatedCentavos, externalDeclaredCentavos: data.gExternalDeclaredCentavos, externalOverlapCentavos: data.gExternalOverlapCentavos, externalOverlapState: data.externalOverlapState,
          percentOfThreshold: Math.min(100, Math.floor(data.gEffectiveCentavos * 100 / data.thresholdCentavos)), advisory: data.gEffectiveCentavos * 100 >= data.thresholdCentavos * 80 && !data.breached,
          status: data.status, reasonCode: data.reasonCode, crossedAt: data.crossedAt, priorYearTotalCentavos: data.priorYearTotalCentavos,
          finalForYearNotice: 'Crossing is final for the taxable year: a refund or a later declaration never restores relief; corrections open adjustment reviews.' }} />
      </div>
      <dl className="grid gap-x-6 gap-y-3 rounded-surface border border-border-default bg-surface-primary p-4 text-sm sm:grid-cols-2 lg:grid-cols-4">
        {Object.entries(record(data.taxProfile)).map(([key, value]) => <div key={key}><dt className="text-xs font-semibold uppercase tracking-wide text-text-secondary">{key.replaceAll('_', ' ')}</dt><dd className="font-semibold">{value === null || value === undefined || value === '' ? '—' : String(value)}</dd></div>)}
      </dl>
      {data.status === 'UNDER_REVIEW' && data.externalOverlapState === 'UNRESOLVED' && <OverlapForm detail={data} onSaved={setData} />}
      <section className="grid gap-3" aria-labelledby="events-heading"><h2 id="events-heading" className="text-lg font-semibold">Status history</h2>
        <ol className="grid divide-y divide-border-default rounded-surface border border-border-default bg-surface-primary">{records(data.events).map((event, index) => <li key={index} className="flex flex-wrap items-center justify-between gap-2 px-4 py-3 text-sm">
          <span className="flex flex-wrap items-center gap-2"><WithholdingStatusBadge status={String(event.to_status)} /><span className="text-text-secondary">{String(event.reason_code).replaceAll('_', ' ').toLowerCase()} · {String(event.actor_type)}</span></span>
          <span className="tabular-nums">{formatPesoCentavos(Number(event.g_before_centavos))} → {formatPesoCentavos(Number(event.g_after_centavos))} · {formatManilaDateTime(event.occurred_at as string)}</span></li>)}</ol></section>
      <section className="grid gap-3" aria-labelledby="assessments-heading"><h2 id="assessments-heading" className="text-lg font-semibold">Remittance assessments (SIMULATED)</h2>
        <Table caption="Assessments" headers={['Order', 'Base G', 'CWT W', 'Before → after', 'Status after', 'Evidence']}>{records(data.assessments).map(row => <tr key={String(row.id)}>
          <td className="px-4 py-3 font-semibold">{String(row.order_reference)}</td><td className="px-4 py-3 tabular-nums">{formatPesoCentavos(Number(row.gross_basis_centavos))}</td><td className="px-4 py-3 tabular-nums">{formatPesoCentavos(Number(row.withheld_centavos))}</td>
          <td className="px-4 py-3 tabular-nums">{formatPesoCentavos(Number(row.g_effective_before_centavos))} → {formatPesoCentavos(Number(row.g_effective_after_centavos))}</td><td className="px-4 py-3">{String(row.threshold_status_after).replaceAll('_', ' ').toLowerCase()}</td>
          <td className="px-4 py-3">{String(row.deduction_evidence_state).replaceAll('_', ' ').toLowerCase()}</td></tr>)}</Table></section>
    </>}
  </div></AdminShell>
}

function OverlapForm({ detail, onSaved }: { detail: WithholdingAccumulatorDetail; onSaved: (detail: WithholdingAccumulatorDetail) => void }) {
  const [amount, setAmount] = useState('')
  const [reason, setReason] = useState('')
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState<string | null>(null)
  async function submit(event: FormEvent) {
    event.preventDefault()
    setError(null)
    const text = amount.trim().replaceAll(',', '')
    if (!/^\d{1,11}(\.\d{1,2})?$/.test(text)) { setError('Enter the overlap in pesos, for example 1,000.00.'); return }
    const [whole, fraction = ''] = text.split('.')
    const centavos = Number(whole) * 100 + Number(fraction.padEnd(2, '0'))
    if (centavos > detail.gExternalDeclaredCentavos) { setError(`The overlap cannot exceed the declared ${formatPesoCentavos(detail.gExternalDeclaredCentavos)}.`); return }
    if (reason.trim().length < 10) { setError('Give the evidence basis in at least 10 characters.'); return }
    setBusy(true)
    try { onSaved(await resolveOverlap(detail.id, centavos, detail.lockVersion, reason.trim())) } catch (cause) { setError(await readableVerificationError(cause)) } finally { setBusy(false) }
  }
  return <form className="grid gap-3 rounded-surface border border-amber-300 bg-amber-50 p-4" onSubmit={event => void submit(event)} aria-labelledby="overlap-heading">
    <h2 id="overlap-heading" className="text-lg font-semibold text-amber-950">Record the outside-platform overlap</h2>
    <p className="text-sm text-amber-950">The Vendor declared {formatPesoCentavos(detail.gExternalDeclaredCentavos)} outside the platform. Record the part already represented in MateryalPH remittances. A resulting total above ₱500,000.00 breaches for the rest of the year. Requires finance.review_tax.</p>
    <label className="grid gap-1.5 text-sm font-semibold">Overlap already counted (₱)<input className="min-h-12 rounded-control border border-border-default bg-surface-primary px-3 text-base font-normal" inputMode="decimal" value={amount} onChange={event => setAmount(event.target.value)} disabled={busy} /></label>
    <label className="grid gap-1.5 text-sm font-semibold">Evidence basis<textarea className="min-h-20 rounded-control border border-border-default bg-surface-primary px-3 py-2 text-base font-normal" value={reason} onChange={event => setReason(event.target.value)} disabled={busy} maxLength={2000} /></label>
    {error && <StatusMessage tone="error">{error}</StatusMessage>}
    <div><Button type="submit" disabled={busy}>{busy ? 'Saving…' : 'Record overlap'}</Button></div>
  </form>
}

function Statements() {
  const [state, setStateFilter] = useState('DRAFT')
  const paged = usePaged(page => listStatements(page, state || undefined), [state])
  const [message, setMessage] = useState<{ tone: 'success' | 'error'; text: string } | null>(null)
  const [busy, setBusy] = useState<string | null>(null)
  async function draft() {
    setBusy('draft'); setMessage(null)
    try { const count = await draftStatements(); setMessage({ tone: 'success', text: count > 0 ? `Drafted ${count} statement(s) for last month.` : 'No new statements to draft; drafting is idempotent.' }); paged.reload() }
    catch (cause) { setMessage({ tone: 'error', text: await readableVerificationError(cause) }) } finally { setBusy(null) }
  }
  async function approve(row: JsonRecord) {
    setBusy(String(row.id)); setMessage(null)
    try { await approveStatement(String(row.id), Number(row.lock_version)); setMessage({ tone: 'success', text: `${String(row.reference)} issued. The Owner was notified.` }); paged.reload() }
    catch (cause) { setMessage({ tone: 'error', text: await readableVerificationError(cause) }) } finally { setBusy(null) }
  }
  return <section className="grid gap-4" aria-labelledby="statements-heading">
    <div className="flex flex-wrap items-center justify-between gap-3"><h2 id="statements-heading" className="text-lg font-semibold">Commission statements</h2>
      <div className="flex flex-wrap items-center gap-3"><FilterChips label="Statement state" chips={[{ value: 'DRAFT', label: 'Draft' }, { value: 'ISSUED', label: 'Issued' }, { value: 'PARTIALLY_PAID', label: 'Partially paid' }, { value: 'PAID', label: 'Paid' }]} value={state} onChange={setStateFilter} />
        <Button variant="secondary" disabled={busy !== null} onClick={() => void draft()}>{busy === 'draft' ? 'Drafting…' : 'Draft last month'}</Button></div></div>
    <p className="text-sm text-text-secondary">Drafted automatically at 00:05 on the first (Asia/Manila); approve by the third. Due on the fifteenth, or twelve days after a late issue.</p>
    {message && <StatusMessage tone={message.tone}>{message.text}</StatusMessage>}
    <Paged state={paged} empty="No statements in this state.">
      {items => <Table caption="Commission statements" headers={['Statement', 'Vendor', 'Period', 'Outstanding', 'Due', 'Action']}>
        {items.map(row => <tr key={String(row.id)}><td className="px-4 py-3 font-semibold">{String(row.reference)}</td><td className="px-4 py-3">{String(row.vendor_name)}</td>
          <td className="px-4 py-3">{String(row.period_start)} – {String(row.period_end)}</td><td className="px-4 py-3 tabular-nums">{formatPesoCentavos(Number(row.outstanding_centavos))}</td>
          <td className="px-4 py-3">{String(row.due_on)}{row.overdue ? ' · overdue' : ''}</td>
          <td className="px-4 py-3">{row.state === 'DRAFT' ? <Button variant="secondary" disabled={busy !== null} onClick={() => void approve(row)}>{busy === row.id ? 'Approving…' : 'Approve and issue'}</Button> : String(row.state).replaceAll('_', ' ').toLowerCase()}</td></tr>)}
      </Table>}
    </Paged>
  </section>
}

function ChannelFees() {
  const [rows, setRows] = useState<ChannelFeeVersion[] | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  useEffect(() => {
    let active = true
    setError(null)
    listChannelFees().then(value => { if (active) setRows(value) }).catch(async cause => { const text = await readableVerificationError(cause); if (active) setError(text) })
    return () => { active = false }
  }, [attempt])
  if (error) return <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} />
  if (!rows) return <LoadingState />
  return <section className="grid gap-3" aria-labelledby="channels-heading">
    <h2 id="channels-heading" className="text-lg font-semibold">TEST channel fee schedule</h2>
    <p className="text-sm text-text-secondary">{rows.find(row => row.enabled)?.sourceReference}</p>
    <Table caption="Channel fee versions" headers={['Channel', 'Version', 'Rate', 'Fixed', 'Fee VAT', 'Refunds', 'Status']}>
      {rows.map(row => <tr key={row.code}><td className="px-4 py-3 font-semibold">{row.displayName}</td><td className="px-4 py-3">v{row.version}</td><td className="px-4 py-3 tabular-nums">{(row.ratePpm / 10000).toFixed(2)}%</td>
        <td className="px-4 py-3 tabular-nums">{formatPesoCentavos(row.fixedCentavos)}</td><td className="px-4 py-3">{row.rateIncludesVat ? 'Included' : `${row.feeVatBasisPoints / 100}% added`}</td>
        <td className="px-4 py-3">{row.refundSupported ? 'Supported' : 'No route'}</td><td className="px-4 py-3"><StatusBadge label={row.enabled ? 'Enabled' : 'Disabled'} tone={row.enabled ? 'success' : 'neutral'} /></td></tr>)}
    </Table>
  </section>
}
