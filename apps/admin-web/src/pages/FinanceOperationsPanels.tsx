import {
  ALL_DATES, Button, ChartDataTable, DashboardPanel, DateFilter, FilterChips, KpiCard, MethodNote, StatusBadge, StatusMessage, Toolbar, TrendLineChart,
  analyticsDay, formatChartDay, formatChartMonth, formatCompactCentavos, formatPesoCentavos,
} from '@materyalph/web-ui'
import { useState, type FormEvent } from 'react'
import { Link } from 'react-router-dom'
import { Banknote, Landmark, Percent, ReceiptText } from 'lucide-react'
import { Paged, Panel, Table } from '../components/OperationsKit'
import { financeKpis, listTaxAdjustments, postTaxAdjustment, prepareTaxAdjustment, remittanceQueue, reviewTaxAdjustment, taxEvidenceQueue, type CertificateImpact, type FinanceKpis, type TaxAdjustment } from '../lib/finance-api'
import { readableVerificationError } from '../lib/vendor-verification-api'
import { label as humanize, useLoad, usePaged } from '../lib/operations-hooks'
import { ErrorState, LoadingState } from './PhaseThreeAdminPages'

const iso = (date: Date) => analyticsDay(date) ?? 'Not recorded'

/** Commerce (GMV) and finance amounts are kept in separate groups and are never summed together; only finance figures appear here. */
export function FinanceKpiPanel() {
  const [range, setRange] = useState(ALL_DATES)
  const kpis = useLoad(() => financeKpis(range.from, range.to), [range.from, range.to])
  return <section aria-labelledby="kpi-heading" className="grid min-w-0 gap-5">
    <div className="flex flex-wrap items-end justify-between gap-3"><div className="min-w-0"><h2 id="kpi-heading" className="text-lg font-semibold">Platform earnings analytics</h2>{kpis.data && <p className="mt-1 text-sm text-text-secondary">{kpis.data.scenario}</p>}</div>
      <DateFilter title="Transaction dates" value={range} onChange={setRange} /></div>
    {kpis.error ? <ErrorState message={kpis.error} onRetry={kpis.retry} /> : !kpis.data ? <LoadingState /> : <PlatformEarnings data={kpis.data} />}
  </section>
}

const minus = (centavos: number) => formatPesoCentavos(centavos === 0 ? 0 : -centavos)

/** Headline cards with their calculation, then the same figures over time and as a composition, then the remaining records. */
function PlatformEarnings({ data }: { data: FinanceKpis }) {
  const figure = (key: string) => data.finance.find(item => item.key === key)?.valueCentavos ?? 0
  const points = data.trend ?? []
  const monthly = data.trendGranularity !== 'DAY'
  const unit = monthly ? 'month' : 'day'
  const dates = points.map(point => analyticsDay(point.period) ?? '')
  const formatLabel = monthly ? formatChartMonth : formatChartDay
  const rows = dates.map(formatLabel)
  const netCommission = points.map(point => point.earnedCentavos - point.creditsCentavos)
  const netCollected = points.map(point => point.collectedCentavos - point.refundedCentavos)
  const earnedNet = figure('net_commission')
  const receivables = figure('receivables')
  const overdue = figure('overdue')
  const chartValue = (value: number) => formatCompactCentavos(Math.round(value))
  const column = (header: string, values: number[]) => ({ key: header, header, values: values.map(value => formatPesoCentavos(value)) })
  return <>
    <p className="-mt-2 text-xs text-text-secondary">{points.length === 0 ? 'No commission activity is recorded for these dates.'
      : `Charted by ${unit} · ${formatLabel(dates[0] ?? '')}${points.length > 1 ? ` – ${formatLabel(dates.at(-1) ?? '')}` : ''} (Asia/Manila)`}</p>
    <Readiness counts={data.counts} />
    <dl aria-label="Platform earnings summary" className="grid gap-4 md:grid-cols-2 2xl:grid-cols-4">
      <KpiCard label="Net platform earnings" value={formatPesoCentavos(figure('net_platform_earnings'))} icon={<Landmark size={16} aria-hidden="true" />} accent
        sparkline={points.map(point => Math.max(0, point.netEarningsCentavos))} hint="Commission revenue after credits and fee VAT, less processing costs."
        collapsibleBreakdown breakdown={{ caption: 'Net platform earnings calculation', rows: [
          { key: 'revenue', label: 'Commission revenue, excluding VAT', amount: formatPesoCentavos(figure('platform_revenue')) },
          { key: 'processing', label: 'Platform processing costs', amount: minus(figure('processing_expense')) },
          { key: 'total', label: 'Net platform earnings', amount: formatPesoCentavos(figure('net_platform_earnings')), total: true },
        ] }} />
      <KpiCard label="Net commission earned" value={formatPesoCentavos(earnedNet)} icon={<Percent size={16} aria-hidden="true" />}
        sparkline={netCommission.map(value => Math.max(0, value))} hint="Saved order rates on completed materials, excluding VAT, after approved credits."
        collapsibleBreakdown breakdown={{ caption: 'Net commission earned calculation', rows: [
          { key: 'earned', label: 'Total commission earned', amount: formatPesoCentavos(figure('earned_commission')) },
          { key: 'credits', label: 'Approved commission credits', amount: minus(figure('fee_credits')) },
          { key: 'total', label: 'Net commission earned', amount: formatPesoCentavos(earnedNet), total: true },
        ] }} />
      <KpiCard label="Net collected commissions" value={formatPesoCentavos(figure('net_collected'))} icon={<Banknote size={16} aria-hidden="true" />}
        sparkline={netCollected.map(value => Math.max(0, value))} hint="Cash received for commission bills, by collection date."
        collapsibleBreakdown breakdown={{ caption: 'Net collected commissions calculation', rows: [
          { key: 'collected', label: 'Collected commissions', amount: formatPesoCentavos(figure('collected')) },
          { key: 'refunded', label: 'Refunded commissions', amount: minus(figure('refunded_commissions')) },
          { key: 'total', label: 'Net collected commissions', amount: formatPesoCentavos(figure('net_collected')), total: true },
        ] }} />
      <KpiCard label="Outstanding receivables" value={formatPesoCentavos(receivables)} icon={<ReceiptText size={16} aria-hidden="true" />}
        hint={`Pending commissions of ${formatPesoCentavos(figure('pending_commissions'))} also include unbilled earnings and draft bills.`}
        collapsibleBreakdown breakdown={{ caption: 'Outstanding receivables calculation', rows: [
          { key: 'current', label: 'Issued, not yet due', amount: formatPesoCentavos(Math.max(0, receivables - overdue)) },
          { key: 'overdue', label: 'Overdue', amount: formatPesoCentavos(overdue) },
          { key: 'total', label: 'Outstanding receivables', amount: formatPesoCentavos(receivables), total: true },
        ] }} />
    </dl>

    <div className="grid gap-5">
      <DashboardPanel title="Commission earned and collected" description={`Commission earned each ${unit}, with the cash collected, approved credits and confirmed refunds.`}>
        <div className="grid gap-4">
          <TrendLineChart title={`Commission earned, collected, credited and refunded per ${unit}`} labels={dates} formatLabel={formatLabel} formatValue={chartValue} emptyReason="No commission activity in this period." series={[
            { key: 'earned', label: 'Earned', colorVar: '--mp-viz-series-1', values: points.map(point => point.earnedCentavos), kind: 'bar' },
            { key: 'collected', label: 'Collected', colorVar: '--mp-viz-series-2', values: points.map(point => point.collectedCentavos) },
            { key: 'credits', label: 'Approved credits', colorVar: '--mp-viz-series-3', values: points.map(point => point.creditsCentavos) },
            { key: 'refunded', label: 'Confirmed refunds', colorVar: '--mp-viz-series-4', values: points.map(point => point.refundedCentavos) },
          ]} />
          <ChartDataTable caption={`${monthly ? 'Monthly' : 'Daily'} commission activity`} rowHeader={monthly ? 'Month' : 'Date'} rows={rows} columns={[
            column('Earned', points.map(point => point.earnedCentavos)), column('Approved credits', points.map(point => point.creditsCentavos)),
            column('Collected', points.map(point => point.collectedCentavos)), column('Refunded', points.map(point => point.refundedCentavos)), column('Net platform earnings', points.map(point => point.netEarningsCentavos))]} />
        </div>
      </DashboardPanel>
    </div>

    <DashboardPanel title="Other recorded figures" description="Billing, VAT and tax records kept apart from platform earnings.">
      <dl className="grid gap-3 sm:grid-cols-2 xl:grid-cols-4">
        {[['billed', 'Issued commission bills'], ['fee_vat', 'Output VAT on fees'], ['assessed_cwt', 'Assessed CWT (simulated)'], ['reported_deductions', 'Provider-reported deductions']].map(([key, label]) =>
          <div key={key} className="min-w-0 rounded-control bg-surface-canvas px-4 py-3"><dt className="text-xs font-semibold text-text-secondary">{label}</dt><dd className="mt-1 break-words text-lg font-semibold tabular-nums text-text-strong">{formatPesoCentavos(figure(String(key)))}</dd></div>)}
      </dl>
    </DashboardPanel>

    <MethodNote label="What every figure means">
      <dl className="grid gap-3 md:grid-cols-2">{data.finance.map(item => <div key={item.key}><dt className="font-semibold text-text-strong">{item.label}</dt><dd>{item.definition}</dd></div>)}</dl>
    </MethodNote>
  </>
}

function Readiness({ counts }: { counts: Record<string, number> }) {
  const rows = [
    { key: 'unreconciled_remittances', label: 'Unreconciled remittances', href: '/finance?view=remittances' },
    { key: 'draft_statements', label: 'Draft commission statements', href: '/finance?view=statements' },
    { key: 'pending_commission_credits', label: 'Commission credits awaiting approval', href: '/finance?view=statements' },
  ]
  return <Panel title="Finance actions" description="Review reconciliation exceptions and issue monthly commission statements.">
    <ul className="grid gap-2 sm:grid-cols-2">{rows.map(row => { const value = counts[row.key] ?? 0; return <li key={row.key} className="flex items-center justify-between gap-3 rounded-control border border-border-default px-3 py-2 text-sm">
      <span className="flex items-center gap-2"><StatusBadge tone={value === 0 ? 'success' : 'warning'} label={value === 0 ? 'Clear' : String(value)} />{row.label}</span>{value > 0 && <Link className="inline-flex min-h-11 items-center font-semibold text-action-primary underline-offset-4 hover:underline" to={row.href}>Open</Link>}</li> })}</ul>
  </Panel>
}

export function RemittanceQueue() {
  const [state, setStateFilter] = useState('RECONCILIATION_EXCEPTION')
  const [range, setRange] = useState(ALL_DATES)
  const paged = usePaged(page => remittanceQueue(page, state || undefined, range), [state, range.from, range.to])
  return <section className="grid gap-4" aria-labelledby="remittance-heading">
    <div className="flex flex-wrap items-center justify-between gap-3"><h2 id="remittance-heading" className="text-lg font-semibold">Remittance reconciliation</h2>
      <FilterChips label="Reconciliation state" chips={[{ value: 'RECONCILIATION_EXCEPTION', label: 'Exceptions' }, { value: 'PENDING', label: 'Pending' }, { value: 'RECONCILED', label: 'Reconciled' }, { value: '', label: 'All' }]} value={state} onChange={setStateFilter} /></div>
    <p className="text-sm text-text-secondary">FIN-05 components with the FIN-04A threshold status before and after each remittance. Exceptions are resolved from their finance work item; taxpayer identifiers are masked.</p>
    <Toolbar filters={<><DateFilter title="Remittance dates" value={range} onChange={setRange} />{(range.from || range.to) && <Button variant="quiet" onClick={() => setRange(ALL_DATES)}>Reset dates</Button>}</>} />
    <Paged state={paged} empty="No remittances in this state.">
      {items => <Table caption="Remittance assessments" headers={['Order / Vendor', 'Gross basis', 'Withheld (W)', 'Reported', 'Threshold', 'States', 'Work item']}>
        {items.map(row => { const parts = row.components as Record<string, number | null>; return <tr key={row.id} className="align-top">
          <td className="px-4 py-3"><p className="font-semibold">{row.orderReference}</p><p className="text-[13px] text-text-secondary">{row.vendorName} · taxpayer …{row.taxpayerKeySuffix}</p></td>
          <td className="px-4 py-3 tabular-nums">{formatPesoCentavos(parts.gross_basis_centavos ?? 0)}</td>
          <td className="px-4 py-3 tabular-nums">{formatPesoCentavos(parts.withheld_centavos ?? 0)}</td>
          <td className="px-4 py-3 tabular-nums">{parts.reported_withheld_centavos === null || parts.reported_withheld_centavos === undefined ? '—' : formatPesoCentavos(parts.reported_withheld_centavos)}</td>
          <td className="px-4 py-3 text-[13px]">{humanize(row.thresholdStatusBefore ?? 'NONE')} → {humanize(row.thresholdStatusAfter ?? 'NONE')}{row.gEffectiveAfterCentavos !== null && row.gEffectiveAfterCentavos !== undefined && <p className="text-text-secondary">G effective {formatPesoCentavos(row.gEffectiveAfterCentavos)}</p>}</td>
          <td className="px-4 py-3 text-[13px]"><p>Calculation: {humanize(row.calculationState)}</p><p>Evidence: {humanize(row.deductionEvidenceState)}</p><p><StatusBadge label={humanize(row.reconciliationState)} tone={row.reconciliationState === 'RECONCILED' ? 'success' : row.reconciliationState === 'PENDING' ? 'neutral' : 'error'} /></p></td>
          <td className="px-4 py-3">{row.reviewItemId ? <Link className="inline-flex min-h-11 items-center font-semibold text-action-primary underline-offset-4 hover:underline" to="/finance?view=queue">Open work queue</Link> : '—'}</td>
        </tr> })}
      </Table>}
    </Paged>
  </section>
}

const ADJUSTMENT_KINDS: Record<string, string> = { REFUND_AFTER_ASSESSMENT: 'Refund after assessment', DISPUTE_REFUND_AFTER_ASSESSMENT: 'Dispute refund after assessment' }
const ADJUSTMENT_STATES: Record<string, { label: string; tone: 'warning' | 'info' | 'success' | 'error' | 'neutral' }> = {
  ADJUSTMENT_REQUIRED: { label: 'Needs preparation', tone: 'warning' }, UNDER_REVIEW: { label: 'Under review', tone: 'info' }, APPROVED: { label: 'Approved — ready to post', tone: 'info' },
  POSTED: { label: 'Posted', tone: 'success' }, REJECTED: { label: 'Rejected', tone: 'error' }, NOT_REQUIRED: { label: 'Not required', tone: 'neutral' },
}

/** FIN-07 withholding corrections after a refund. DEMO: nothing here files with the BIR or moves money. */
export function TaxAdjustmentQueue() {
  const [state, setStateFilter] = useState('')
  const [range, setRange] = useState(ALL_DATES)
  const paged = usePaged(page => listTaxAdjustments(page, state || undefined, range), [state, range.from, range.to])
  return <section className="grid gap-4" aria-labelledby="adjustments-heading">
    <div className="flex flex-wrap items-center justify-between gap-3"><h2 id="adjustments-heading" className="text-lg font-semibold">Tax adjustments</h2>
      <FilterChips label="Adjustment state" chips={[{ value: '', label: 'All' }, { value: 'ADJUSTMENT_REQUIRED', label: 'Needs preparation' }, { value: 'UNDER_REVIEW', label: 'Under review' }, { value: 'APPROVED', label: 'Approved' },
        { value: 'POSTED', label: 'Posted' }, { value: 'REJECTED', label: 'Rejected' }, { value: 'NOT_REQUIRED', label: 'Not required' }]} value={state} onChange={setStateFilter} /></div>
    <p className="text-sm text-text-secondary">A refund after a withholding was recorded opens a review here. One finance user prepares the corrected withholding and a different one approves it before it is posted as a linked entry. The original assessment and the FIN-04A counter are never rewritten, and a refund never restores relief. A fully refunded collection in an uncrossed year is voided and needs no review. DEMO — no real funds or BIR filing.</p>
    <Toolbar filters={<><DateFilter title="Adjustment opened dates" value={range} onChange={setRange} />{(range.from || range.to) && <Button variant="quiet" onClick={() => setRange(ALL_DATES)}>Reset dates</Button>}</>} />
    <Paged state={paged} empty="No tax adjustments in this state.">
      {items => <ul className="grid gap-3">{items.map(item => <TaxAdjustmentRow key={item.id} item={item} onDone={paged.reload} />)}</ul>}
    </Paged>
  </section>
}

function TaxAdjustmentRow({ item, onDone }: { item: TaxAdjustment; onDone: () => void }) {
  const meta = ADJUSTMENT_STATES[item.state] ?? { label: humanize(item.state), tone: 'neutral' as const }
  const before = item.beforeValues as Record<string, unknown>
  const after = item.afterValues as Record<string, unknown>
  const [mode, setMode] = useState<'PREPARE' | 'REVIEW' | null>(null)
  const [amount, setAmount] = useState(() => typeof after.proposed_withheld_centavos === 'number' ? (after.proposed_withheld_centavos / 100).toFixed(2) : '')
  const [impact, setImpact] = useState<CertificateImpact>('NONE')
  const [evidence, setEvidence] = useState('')
  const [reason, setReason] = useState('')
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const can = (action: string) => item.allowedActions.some(value => value === action)
  async function run(task: () => Promise<unknown>) {
    setBusy(true); setError(null)
    try { await task(); setMode(null); onDone() } catch (cause) { setError(await readableVerificationError(cause)) } finally { setBusy(false) }
  }
  function prepare(event: FormEvent) {
    event.preventDefault()
    const text = amount.trim().replaceAll(',', '')
    if (!/^\d{1,11}(\.\d{1,2})?$/.test(text)) { setError('Enter the corrected withholding in pesos, for example 0.00.'); return }
    if (reason.trim().length < 10) { setError('Give the reason in at least 10 characters.'); return }
    const [whole, fraction = ''] = text.split('.')
    void run(() => prepareTaxAdjustment(item.id, Number(whole) * 100 + Number(fraction.padEnd(2, '0')), reason.trim(), impact, evidence.trim()))
  }
  function review(decision: 'APPROVED' | 'REJECTED') {
    if (reason.trim().length < 10) { setError('Give the reason in at least 10 characters.'); return }
    void run(() => reviewTaxAdjustment(item.id, decision, reason.trim()))
  }
  const field = 'min-h-12 w-full rounded-control border border-border-default bg-surface-primary px-3 text-base font-normal'
  return <li className="grid gap-3 rounded-surface border border-border-default bg-surface-primary p-4">
    <div className="flex flex-wrap items-start justify-between gap-2">
      <div className="min-w-0"><p className="font-semibold">{ADJUSTMENT_KINDS[item.kind] ?? humanize(item.kind)}</p>
        <p className="text-sm text-text-secondary">{item.orderReference ?? 'No order'} · {item.vendorName ?? 'Vendor'} · {formatPesoCentavos(item.amountCentavos)} refunded · {iso(item.periodStart)} – {iso(item.periodEnd)}</p></div>
      <StatusBadge label={meta.label} tone={meta.tone} />
    </div>
    <p className="text-sm">{item.reason}</p>
    <dl className="grid gap-x-6 gap-y-1 text-sm sm:grid-cols-2">
      <div className="flex justify-between gap-3"><dt className="text-text-secondary">Withheld at assessment</dt><dd className="tabular-nums">{formatPesoCentavos(Number(before.withheld_centavos ?? 0))}</dd></div>
      {typeof after.proposed_withheld_centavos === 'number' && <div className="flex justify-between gap-3"><dt className="text-text-secondary">Proposed corrected withholding</dt><dd className="tabular-nums">{formatPesoCentavos(after.proposed_withheld_centavos)}</dd></div>}
      {typeof after.certificate_impact === 'string' && <div className="flex justify-between gap-3"><dt className="text-text-secondary">Certificate impact</dt><dd>{humanize(after.certificate_impact)}</dd></div>}
      {item.preparer && <div className="flex justify-between gap-3"><dt className="text-text-secondary">Prepared by</dt><dd>{item.preparer}</dd></div>}
      {item.reviewer && <div className="flex justify-between gap-3"><dt className="text-text-secondary">Reviewed by</dt><dd>{item.reviewer}</dd></div>}
    </dl>
    {typeof after.note === 'string' && <p className="text-sm text-text-secondary">{after.note}</p>}
    {item.separationNote && <p className="text-sm text-text-secondary">{item.separationNote}</p>}
    {error && <StatusMessage tone="error">{error}</StatusMessage>}
    {mode === 'PREPARE' && <form className="grid gap-3 sm:grid-cols-2" onSubmit={prepare}>
      <label className="grid gap-1.5 text-sm font-semibold">Corrected withholding (₱)<input className={field} inputMode="decimal" value={amount} onChange={event => setAmount(event.target.value)} disabled={busy} /></label>
      <label className="grid gap-1.5 text-sm font-semibold">Certificate impact<select className={field} value={impact} onChange={event => setImpact(event.target.value as CertificateImpact)} disabled={busy}>
        <option value="NONE">None</option><option value="REISSUE_REQUIRED">Certificate reissue required</option><option value="AMENDMENT_REQUIRED">Amendment required</option></select></label>
      <label className="grid gap-1.5 text-sm font-semibold sm:col-span-2">Reason<input className={field} value={reason} onChange={event => setReason(event.target.value)} disabled={busy} maxLength={2000} /></label>
      <label className="grid gap-1.5 text-sm font-semibold sm:col-span-2">Refund evidence reference (optional)<input className={field} value={evidence} onChange={event => setEvidence(event.target.value)} disabled={busy} maxLength={200} /></label>
      <div className="flex flex-wrap gap-2 sm:col-span-2"><Button type="submit" disabled={busy}>{busy ? 'Saving…' : 'Send for review'}</Button><Button variant="quiet" disabled={busy} onClick={() => setMode(null)}>Cancel</Button></div>
    </form>}
    {mode === 'REVIEW' && <div className="grid gap-3">
      <label className="grid gap-1.5 text-sm font-semibold">Decision reason<input className={field} value={reason} onChange={event => setReason(event.target.value)} disabled={busy} maxLength={2000} /></label>
      <div className="flex flex-wrap gap-2"><Button disabled={busy} onClick={() => review('APPROVED')}>Approve</Button><Button variant="secondary" disabled={busy} onClick={() => review('REJECTED')}>Reject</Button><Button variant="quiet" disabled={busy} onClick={() => setMode(null)}>Cancel</Button></div>
    </div>}
    {mode === null && <div className="flex flex-wrap gap-2">
      {can('PREPARE') && <Button variant="secondary" onClick={() => { setError(null); setMode('PREPARE') }}>{item.state === 'REJECTED' ? 'Prepare again' : 'Prepare correction'}</Button>}
      {(can('APPROVE') || can('REJECT')) && <Button variant="secondary" onClick={() => { setError(null); setReason(''); setMode('REVIEW') }}>Review (different user)</Button>}
      {can('POST') && <Button disabled={busy} onClick={() => void run(() => postTaxAdjustment(item.id))}>{busy ? 'Posting…' : 'Post linked entry'}</Button>}
    </div>}
  </li>
}

export function TaxEvidenceQueue() {
  const [state, setStateFilter] = useState('PENDING')
  const [range, setRange] = useState(ALL_DATES)
  const paged = usePaged(page => taxEvidenceQueue(page, state || undefined, range), [state, range.from, range.to])
  return <section className="grid gap-4" aria-labelledby="evidence-heading">
    <div className="flex flex-wrap items-center justify-between gap-3"><h2 id="evidence-heading" className="text-lg font-semibold">Tax evidence</h2>
      <FilterChips label="Review state" chips={[{ value: 'PENDING', label: 'Pending' }, { value: 'APPROVED', label: 'Approved' }, { value: 'REJECTED', label: 'Rejected' }, { value: '', label: 'All' }]} value={state} onChange={setStateFilter} /></div>
    <p className="text-sm text-text-secondary">Sworn Declarations and other FIN-04 evidence. Decisions are made in the Vendor verification case. A declaration never reverses a crossed FIN-04A threshold for that year.</p>
    <Toolbar filters={<><DateFilter title="Evidence submission dates" value={range} onChange={setRange} />{(range.from || range.to) && <Button variant="quiet" onClick={() => setRange(ALL_DATES)}>Reset dates</Button>}</>} />
    <Paged state={paged} empty="No tax evidence in this state.">
      {items => <Table caption="Tax evidence" headers={['Vendor', 'Evidence', 'Taxable year', 'Validity', 'Review', 'Decision']}>
        {items.map(row => <tr key={row.id} className="align-top"><td className="px-4 py-3 font-semibold">{row.vendor.name}</td><td className="px-4 py-3">{humanize(row.evidenceType)}<p className="text-[13px] text-text-secondary">{humanize(row.origin)} · profile v{row.taxProfileVersion}</p></td>
          <td className="px-4 py-3">{row.taxableYear ?? '—'}</td><td className="px-4 py-3 text-[13px]">{row.validFrom ? iso(row.validFrom) : '—'} – {row.validUntil ? iso(row.validUntil) : 'open'}</td>
          <td className="px-4 py-3"><StatusBadge label={humanize(row.reviewState)} tone={row.reviewState === 'APPROVED' ? 'success' : row.reviewState === 'REJECTED' ? 'error' : 'warning'} />{row.note && <p className="mt-1 text-[13px] text-text-secondary">{row.note}</p>}</td>
          <td className="px-4 py-3"><Link className="inline-flex min-h-11 items-center font-semibold text-action-primary underline-offset-4 hover:underline" to={row.decisionHref}>Open case</Link></td></tr>)}
      </Table>}
    </Paged>
  </section>
}
