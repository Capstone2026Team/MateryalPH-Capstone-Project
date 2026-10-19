import { DocumentExportButton } from '@materyalph/web-ui'
import { useEffect, useState, type FormEvent } from 'react'
import { Link, useParams, useSearchParams } from 'react-router-dom'
import { ArrowLeft, ExternalLink, RefreshCw } from 'lucide-react'
import {
  ALL_DATES, Button, DateFilter, DemoLabel, FilterChips, PaymentAttemptBadge, StatusBadge, StatusMessage, ThresholdPanel, Toolbar, WithholdingStatusBadge, formatManilaDateTime, formatPesoCentavos,
} from '@materyalph/web-ui'
import {
  approveFeeCredit, approveStatement, draftStatements, getAccumulator, listAccumulators, listChannelFees, listPayments, listReviewItems, listStatements, resolveOverlap, resolveReviewItem,
  runReconciliation, type ChannelFeeVersion, type FinanceReviewItem, type WithholdingAccumulatorDetail, type WithholdingAccumulatorView,
} from '../lib/finance-api'
import { readableVerificationError } from '../lib/vendor-verification-api'
import { record, records, type JsonRecord } from '../lib/admin-format'
import { AdminShell, ErrorState, LoadingState, PageHeader } from './PhaseThreeAdminPages'
import { Paged, Table } from '../components/OperationsKit'
import { FinanceKpiPanel, RemittanceQueue, TaxAdjustmentQueue, TaxEvidenceQueue } from './FinanceOperationsPanels'
import { usePaged } from '../lib/operations-hooks'
import { CommissionPolicyPanel } from './CommissionPolicyPanel'

type View = 'overview' | 'payments' | 'queue' | 'remittances' | 'evidence' | 'adjustments' | 'withholding' | 'statements' | 'overdue' | 'channels'
const VIEWS: { value: View; label: string }[] = [
  { value: 'overview', label: 'Platform earnings' }, { value: 'statements', label: 'Commission management' }, { value: 'overdue', label: 'Overdue debt' }, { value: 'payments', label: 'Payment status' },
  { value: 'queue', label: 'Work queue' }, { value: 'remittances', label: 'Remittance reconciliation' }, { value: 'evidence', label: 'Tax evidence' },
  { value: 'adjustments', label: 'Tax adjustments' }, { value: 'withholding', label: 'Withholding threshold' }, { value: 'channels', label: 'Channel fees' },
]
const PRIMARY_VIEWS = [{ value: 'overview', label: 'Overview' }, { value: 'statements', label: 'Commission management' }, { value: 'payments', label: 'Payments and refunds' }, { value: 'queue', label: 'Reconciliation' }]

/**
 * Admin finance on the existing finance.* permissions. Every action is authorized again on the server; a 403
 * renders the explanation, never hidden data. Preparer and reviewer must differ for credits and adjustments.
 */
export function AdminFinancePage() {
  const [params, setParams] = useSearchParams()
  const view = (VIEWS.some(item => item.value === params.get('view')) ? params.get('view') : 'overview') as View
  const primary = ['statements', 'overdue'].includes(view) ? 'statements' : ['payments', 'channels'].includes(view) ? 'payments' : view === 'overview' ? 'overview' : 'queue'
  const [refresh, setRefresh] = useState(0)
  const [notice, setNotice] = useState<{ tone: 'success' | 'error'; text: string } | null>(null)
  const [busy, setBusy] = useState(false)
  async function reconcile() {
    setBusy(true); setNotice(null)
    try { const counts = await runReconciliation(); setNotice({ tone: 'success', text: `Reconciliation ran: ${Number(counts.reconciled ?? 0)} attempts, ${Number(counts.webhooks ?? 0)} webhooks, ${Number(counts.refunds ?? 0)} compensation refunds checked.` }); setRefresh(value => value + 1) }
    catch (cause) { setNotice({ tone: 'error', text: await readableVerificationError(cause) }) }
    finally { setBusy(false) }
  }
  return <AdminShell activeHref="/finance"><div className="grid min-w-0 gap-6">
    <PageHeader eyebrow="Finance" title="Platform accounting" description="Monitor platform earnings, collect commission bills and review financial exceptions."
      actions={<Button variant="secondary" disabled={busy} onClick={() => void reconcile()}><RefreshCw size={16} aria-hidden="true" />{busy ? 'Reconciling…' : 'Run reconciliation'}</Button>} />
    {notice && <StatusMessage tone={notice.tone}>{notice.text}</StatusMessage>}
    <FilterChips label="Finance view" chips={PRIMARY_VIEWS} value={primary} appearance="tabs" onChange={value => setParams({ view: value })} />
    {primary === 'payments' && <FilterChips label="Payment sections" chips={VIEWS.filter(item => ['payments', 'channels'].includes(item.value))} value={view} onChange={value => setParams({ view: value })} />}
    {primary === 'queue' && <FilterChips label="Reconciliation sections" chips={VIEWS.filter(item => ['queue', 'remittances', 'evidence', 'withholding'].includes(item.value))} value={view} onChange={value => setParams({ view: value })} />}
    <div key={`${view}-${refresh}`} className="grid min-w-0 gap-6">
    {view === 'overview' && <FinanceKpiPanel />}
    {view === 'queue' && <ReviewQueue />}
    {view === 'remittances' && <RemittanceQueue />}
    {view === 'evidence' && <TaxEvidenceQueue />}
    {view === 'adjustments' && <TaxAdjustmentQueue />}
    {view === 'payments' && <PaymentLog />}
    {view === 'withholding' && <Accumulators />}
    {primary === 'statements' && <><CommissionPolicyPanel /><FilterChips label="Commission sections" chips={[{ value: 'statements', label: 'All statements' }, { value: 'overdue', label: 'Overdue debt' }]} value={view} onChange={value => setParams({ view: value })} /><Statements overdue={view === 'overdue'} />{view === 'statements' && <ReviewQueue kind="FEE_CREDIT_PROPOSAL" title="Commission credit approvals" empty="No commission credits awaiting approval." />}</>}
    {view === 'channels' && <ChannelFees />}
    </div>
  </div></AdminShell>
}

const KIND_LABELS: Record<string, string> = {
  RECONCILIATION_EXCEPTION: 'Reconciliation exception', PAYMENT_MISMATCH: 'Payment mismatch', LATE_CAPTURE_COMPENSATION: 'Late capture compensated', OVERLAP_UNRESOLVED: 'Outside-platform overlap',
  THRESHOLD_ADJUSTMENT_REQUIRED: 'Threshold adjustment review', BASE_REVIEW_REQUIRED: 'Remittance base review', FEE_OVERPAYMENT: 'Fee overpayment', STATEMENT_OVERDUE: 'Statement overdue',
  FEE_CREDIT_PROPOSAL: 'Fee credit awaiting approval', PAID_FEE_CREDIT_PAYABLE: 'Credit on paid statement',
}

function ReviewQueue({ kind, title = 'Finance work queue', empty }: { kind?: string; title?: string; empty?: string }) {
  const [state, setStateFilter] = useState<'OPEN' | 'RESOLVED'>('OPEN')
  const [range, setRange] = useState(ALL_DATES)
  const paged = usePaged(page => listReviewItems(page, state, kind, range), [state, kind, range.from, range.to])
  return <section className="grid gap-4" aria-labelledby="queue-heading">
    <div className="flex flex-wrap items-center justify-between gap-3"><h2 id="queue-heading" className="text-lg font-semibold">{title}</h2>
      <FilterChips label="Item state" chips={[{ value: 'OPEN', label: 'Open' }, { value: 'RESOLVED', label: 'Resolved' }]} value={state} onChange={value => setStateFilter(value as 'OPEN' | 'RESOLVED')} /></div>
    <Toolbar filters={<><DateFilter title="Work item recorded dates" value={range} onChange={setRange} />{(range.from || range.to) && <Button variant="quiet" onClick={() => setRange(ALL_DATES)}>Reset dates</Button>}</>} />
    <Paged state={paged} empty={state === 'OPEN' ? (empty ?? 'No open finance work. Mismatches, late captures, overlap reviews and overdue statements appear here.') : 'No resolved items yet.'}>
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
  const [range, setRange] = useState(ALL_DATES)
  const paged = usePaged(page => listPayments(page, state || undefined, range), [state, range.from, range.to])
  return <section className="grid gap-4" aria-labelledby="payments-heading">
    <div className="flex flex-wrap items-center justify-between gap-3"><h2 id="payments-heading" className="text-lg font-semibold">Payment log</h2>
      <FilterChips label="Attempt state" chips={[{ value: '', label: 'All' }, { value: 'PENDING', label: 'Pending' }, { value: 'UNCERTAIN', label: 'Uncertain' }, { value: 'PAID', label: 'Paid' }, { value: 'FAILED', label: 'Failed' }, { value: 'EXPIRED', label: 'Expired' }, { value: 'CANCELLED', label: 'Cancelled' }]} value={state} onChange={setStateFilter} /></div>
    <Toolbar filters={<><DateFilter title="Payment request dates" value={range} onChange={setRange} />{(state || range.from || range.to) && <Button variant="quiet" onClick={() => { setStateFilter(''); setRange(ALL_DATES) }}>Reset filters</Button>}</>} />
    <Paged state={paged} empty="No payment attempts match this filter.">
      {items => <Table caption="Payment attempts" headers={['Reference', 'Vendor', 'Purpose', 'Status', 'Total', 'Refunded', 'Net collected', 'Origin', 'Reconciliation', 'Created']}>
        {items.map(row => <tr key={String(row.id)}><td className="px-4 py-3 font-semibold">{String(row.reference ?? '—')}</td><td className="px-4 py-3">{String(row.vendor_name ?? '—')}</td>
          <td className="px-4 py-3">{String(row.purpose).replaceAll('_', ' ').toLowerCase()}</td><td className="px-4 py-3"><PaymentAttemptBadge status={String(row.status)} /></td>
          <td className="px-4 py-3 tabular-nums">{formatPesoCentavos(Number(row.total_centavos))}</td>
          <td className="px-4 py-3 tabular-nums">{formatPesoCentavos(Number(row.refunded_centavos ?? 0))}{Number(row.refund_pending_count ?? 0) > 0 && <p className="text-sm text-text-secondary">Refund pending</p>}{Number(row.refund_failed_count ?? 0) > 0 && <p className="text-sm text-text-secondary">Refund failed</p>}</td>
          <td className="px-4 py-3 tabular-nums">{formatPesoCentavos(Number(row.net_collected_centavos ?? 0))}</td><td className="px-4 py-3">{String(row.evidence_origin)} · {String(row.gateway_mode ?? 'TEST')}</td>
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

function Statements({ overdue = false }: { overdue?: boolean }) {
  const [state, setStateFilter] = useState('')
  const [range, setRange] = useState(ALL_DATES)
  const paged = usePaged(page => listStatements(page, state || undefined, overdue, range), [state, overdue, range.from, range.to])
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
    <div className="flex flex-wrap items-center justify-between gap-3"><h2 id="statements-heading" className="text-lg font-semibold">{overdue ? 'Overdue commission debt' : 'Commission fee management'}</h2>
      <div className="flex flex-wrap items-center gap-3"><FilterChips label="Statement state" chips={[{ value: '', label: 'All' }, ...(!overdue ? [{ value: 'DRAFT', label: 'Draft' }] : []), { value: 'ISSUED', label: 'Issued' }, { value: 'PARTIALLY_PAID', label: 'Partially paid' }, ...(!overdue ? [{ value: 'PAID', label: 'Settled' }, { value: 'VOIDED', label: 'Voided' }] : [])]} value={state} onChange={setStateFilter} />
        {!overdue && <Button variant="secondary" disabled={busy !== null} onClick={() => void draft()}>{busy === 'draft' ? 'Drafting…' : 'Draft last month'}</Button>}</div></div>
    <p className="text-sm text-text-secondary">Drafted automatically at 00:05 on the first (Asia/Manila); approve by the third. Due on the fifteenth, or twelve days after a late issue.</p>
    <Toolbar filters={<><DateFilter title="Statement issue dates" value={range} onChange={setRange} />{(range.from || range.to) && <Button variant="quiet" onClick={() => setRange(ALL_DATES)}>Reset dates</Button>}</>} />
    {message && <StatusMessage tone={message.tone}>{message.text}</StatusMessage>}
    <Paged state={paged} empty="No statements match these filters. Completed orders are included in the next monthly draft.">
      {items => <Table caption="Commission statements" headers={['Statement', 'Vendor', 'Period', 'Charges', 'Credits', 'Paid before refunds', 'Outstanding', 'Due (Asia/Manila)', 'Status / Action']}>
        {items.map(row => <tr key={String(row.id)}><td className="px-4 py-3 font-semibold">{String(row.reference)}</td><td className="px-4 py-3">{String(row.vendor_name)}</td>
          <td className="px-4 py-3">{String(row.period_start)} – {String(row.period_end)}</td>
          <td className="px-4 py-3 tabular-nums">{formatPesoCentavos(Number(row.charges_centavos))}</td><td className="px-4 py-3 tabular-nums">{formatPesoCentavos(Number(row.credits_centavos))}</td>
          <td className="px-4 py-3 tabular-nums">{formatPesoCentavos(Number(row.paid_centavos))}</td><td className="px-4 py-3 tabular-nums">{formatPesoCentavos(Number(row.outstanding_centavos))}</td>
          <td className="px-4 py-3">{String(row.due_on)}{row.overdue ? ' · overdue' : ''}</td>
          <td className="px-4 py-3">{row.state === 'DRAFT' ? <Button variant="secondary" disabled={busy !== null} onClick={() => void approve(row)}>{busy === row.id ? 'Approving…' : 'Approve and issue'}</Button> : <StatusBadge label={row.overdue ? 'Overdue' : row.state === 'PAID' ? 'Settled' : String(row.state).replaceAll('_', ' ').toLowerCase()} tone={row.overdue ? 'error' : row.state === 'PAID' ? 'success' : 'neutral'} />}<div className="mt-2"><DocumentExportButton basePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} audience="admin" types={['FEE_STATEMENT']} resourceId={String(row.id)} title={String(row.reference)} /></div></td></tr>)}
      </Table>}
    </Paged>
  </section>
}

/** Xendit's own dashboard; the platform account signs in there, never through MateryalPH. */
const XENDIT_DASHBOARD_URL = 'https://dashboard.xendit.co/'

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
  const enabled = rows.filter(row => row.enabled).length
  return <section className="grid gap-4" aria-labelledby="channels-heading">
    <div className="grid gap-5 rounded-surface border border-border-default bg-surface-primary p-4 sm:p-5 lg:grid-cols-[minmax(0,1fr)_minmax(0,22rem)] lg:gap-8">
      <div className="min-w-0">
        <h2 id="channels-heading" className="text-lg font-semibold">TEST channel fee schedule</h2>
        <p className="mt-1 text-sm leading-6 text-text-secondary">{rows.find(row => row.enabled)?.sourceReference}</p>
        <p className="mt-2 text-xs font-semibold text-text-secondary">{enabled} enabled · {rows.length - enabled} disabled</p>
      </div>
      <div className="grid content-start gap-2 border-t border-border-default pt-5 lg:border-l lg:border-t-0 lg:pl-8 lg:pt-0">
        <p className="text-sm font-semibold text-text-strong">Platform Xendit account</p>
        <p className="text-xs leading-5 text-text-secondary">Opens Xendit’s own sign-in in a new tab. Log in with the MateryalPH platform account; MateryalPH never stores or shows its Xendit credentials.</p>
        <a className="mt-1 inline-flex min-h-11 w-fit items-center gap-2 rounded-control bg-action-primary px-4 text-sm font-semibold text-white hover:bg-action-primary-pressed" href={XENDIT_DASHBOARD_URL} target="_blank" rel="noopener noreferrer">
          <ExternalLink size={16} aria-hidden="true" />Open Xendit dashboard<span className="sr-only"> (opens in a new tab)</span></a>
      </div>
    </div>
    <Table caption="Channel fee versions" headers={['Channel', 'Version', 'Rate', 'Fixed', 'Fee VAT', 'Refunds', 'Status']}>
      {rows.map(row => <tr key={row.code}><td className="px-4 py-3 font-semibold">{row.displayName}</td><td className="px-4 py-3">v{row.version}</td><td className="px-4 py-3 tabular-nums">{(row.ratePpm / 10000).toFixed(2)}%</td>
        <td className="px-4 py-3 tabular-nums">{formatPesoCentavos(row.fixedCentavos)}</td><td className="px-4 py-3">{row.rateIncludesVat ? 'Included' : `${row.feeVatBasisPoints / 100}% added`}</td>
        <td className="px-4 py-3">{row.refundSupported ? 'Supported' : 'No route'}</td><td className="px-4 py-3"><StatusBadge label={row.enabled ? 'Enabled' : 'Disabled'} tone={row.enabled ? 'success' : 'neutral'} /></td></tr>)}
    </Table>
  </section>
}
