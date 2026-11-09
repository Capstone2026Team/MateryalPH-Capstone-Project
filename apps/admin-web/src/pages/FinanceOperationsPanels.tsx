import {
  dateRangeFromParams, AnalyticsChartCard, AnalyticsSummary, Button, CalculationHelp, ChartDataTable, CommissionCreditsExplanation, DashboardPanel, DateFilter, DenseLedgerTable, Field, FilterChips, FinanceBreakdownPanel, FinanceQueueWorkspace, FinanceRecordFacts, FormDialog, PlatformEarningsBreakdown, MethodNote, PaymentChannelList, StatusBadge, StatusMessage, TrendLineChart,
  analyticsDay, formatChartDay, formatChartMonth, formatCompactCentavos, formatManilaDateTime, formatPesoCentavos,
  type DateFilterRange,
} from '@materyalph/web-ui'
import { useId, useState } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import { Landmark, Percent, Wallet } from 'lucide-react'
import { Paged } from '../components/OperationsKit'
import { approveRemittanceReconciliation, financeKpis, listChannelFees, remittanceQueue, type FinanceKpi, type FinanceKpis, type RemittanceQueueRow } from '../lib/finance-api'
import { label as humanize, useLoad, usePaged, useProtectedAction } from '../lib/operations-hooks'
import { problemText } from '../lib/operations-api'
import { ErrorState, LoadingState } from './PhaseThreeAdminPages'

/**
 * Platform Finance overview: commission earnings, collected fees and billing debt.
 * Buyer/Vendor marketplace payments are presented separately in Marketplace Analytics.
 */
export function FinanceKpiPanel({ range }: { range: DateFilterRange }) {
  const kpis = useLoad(() => financeKpis(range.from, range.to), [range.from, range.to])
  return <section aria-label="Platform finance figures" className="mp-analytics grid min-w-0 gap-3">
    {kpis.error ? <ErrorState message={kpis.error} onRetry={kpis.retry} /> : !kpis.data ? <LoadingState /> : <FinanceOverview data={kpis.data} />}
  </section>
}

const minus = (centavos: number) => formatPesoCentavos(centavos === 0 ? 0 : -centavos)

function figureOf(items: FinanceKpi[]) {
  return (key: string) => items.find(item => item.key === key)?.valueCentavos ?? 0
}

/** Vendor Finance composition, using platform earnings, commission collections and billing records. */
function FinanceOverview({ data }: { data: FinanceKpis }) {
  const finance = figureOf(data.finance)
  const points = data.trend ?? []
  const monthly = data.trendGranularity !== 'DAY'
  const unit = monthly ? 'month' : 'day'
  const dates = points.map(point => analyticsDay(point.period) ?? '')
  const formatLabel = monthly ? formatChartMonth : formatChartDay
  const rows = dates.map(formatLabel)
  const chartValue = (value: number) => formatCompactCentavos(Math.round(value))
  const column = (header: string, values: number[]) => ({ key: header, header, values: values.map(value => formatPesoCentavos(value)) })
  const receivables = finance('receivables')
  const overdue = finance('overdue')
  return <>
    {points.length === 0 && <p className="text-sm text-text-secondary">No financial activity is recorded for these dates.</p>}
    <section aria-label="Platform earnings overview" className="mp-finance-overview">
      <p className="text-xs text-text-secondary">Charted by {unit} · Asia/Manila. Earnings and payments use their recorded event dates.</p>
      <AnalyticsSummary density="compact" title="Platform earnings" context={data.period.from && data.period.to ? `${formatChartDay(analyticsDay(data.period.from) ?? '')} – ${formatChartDay(analyticsDay(data.period.to) ?? '')} · Asia/Manila` : 'Selected transaction dates · Asia/Manila'} featured={{ label: 'Net platform earnings', value: formatPesoCentavos(finance('net_platform_earnings')), icon: <Landmark size={17} />, hint: 'Commission revenue less processing costs' }} metrics={[
        { label: 'Platform commission charges', value: formatPesoCentavos(finance('net_commission')), icon: <Percent size={17} />, hint: 'After approved commission credits' },
        { label: 'Net commission collections', value: formatPesoCentavos(finance('net_collected')), icon: <Wallet size={17} />, hint: 'Successful payments less confirmed refunds' },
      ]} />
      <div className="mp-finance-main">
      <div className="mp-finance-report-row">
      <AnalyticsChartCard title="Commission activity" description={`Commission earned and payments received per ${unit}.`}
        calculation={<p>Commission is earned on completed orders, after approved credits. Collections record successful Vendor payments separately; they are not earned revenue a second time.</p>}>
        <TrendLineChart variant="bar" title={`Platform commission charges, payments, credits and refunds per ${unit}`} labels={dates} formatLabel={formatLabel} formatValue={chartValue} formatTooltipValue={value => formatPesoCentavos(Math.round(value))} emptyReason="No commission activity in this period." series={[
          { key: 'earned', label: 'Commission earned', colorVar: '--mp-viz-series-1', values: points.map(point => point.earnedCentavos), kind: 'bar' },
          { key: 'collected', label: 'Payments received', colorVar: '--mp-viz-series-2', values: points.map(point => point.collectedCentavos) },
        ]} />
        <ChartDataTable caption={`${monthly ? 'Monthly' : 'Daily'} commission activity`} rowHeader={monthly ? 'Month' : 'Date'} rows={rows} columns={[
          column('Platform commission charges before credits', points.map(point => point.earnedCentavos)), column('Approved credits', points.map(point => point.creditsCentavos)),
          column('Collected', points.map(point => point.collectedCentavos)), column('Commission refunds', points.map(point => point.refundedCentavos)), column('Net platform earnings', points.map(point => point.netEarningsCentavos)),
        ]} />
      </AnalyticsChartCard>
      <DashboardPanel density="compact" title="Financial calculations" description="Commission earnings and collected payments use their own event dates.">
        <div className="mp-finance-calculations">
          <PlatformEarningsBreakdown figures={data.finance} />
          <FinanceBreakdownPanel title="Platform commission charges" caption="Platform commission charges calculation" rows={[
            { key: 'earned', label: 'Platform commission charges before credits', amount: formatPesoCentavos(finance('earned_commission')) },
            { key: 'credits', label: <span className="inline-flex items-center gap-2"><span>Approved commission credits</span><CalculationHelp title="Approved commission credits"><CommissionCreditsExplanation /></CalculationHelp></span>, amount: minus(finance('fee_credits')) },
            { key: 'net', label: 'Platform commission charges', amount: formatPesoCentavos(finance('net_commission')), total: true },
          ]} />
          <FinanceBreakdownPanel title="Net commission collections" caption="Net commission collections calculation" rows={[
            { key: 'collected', label: 'Commission payments collected', amount: formatPesoCentavos(finance('collected')) },
            { key: 'refunds', label: 'Commission refunds to Vendors', amount: minus(finance('refunded_commissions')) },
            { key: 'net', label: 'Net commission collections', amount: formatPesoCentavos(finance('net_collected')), total: true },
          ]} />
        </div>
      </DashboardPanel>
      </div>
      <div className="mp-finance-report-row">
        <AnalyticsChartCard title="Commission adjustments" description={`Approved fee credits and confirmed refunds per ${unit}.`}
          calculation={<p>Approved credits reduce commission earnings on their approval date. Confirmed refunds reduce collected cash on their successful refund date. These are separate events.</p>}>
          <TrendLineChart variant="area" title={`Commission credits and refunds per ${unit}`} labels={dates} formatLabel={formatLabel} formatValue={chartValue} formatTooltipValue={value => formatPesoCentavos(Math.round(value))} emptyReason="No commission credits or refunds in this period." series={[
            { key: 'credits', label: 'Approved credits', colorVar: '--mp-viz-series-3', values: points.map(point => point.creditsCentavos) },
            { key: 'refunds', label: 'Commission refunds', colorVar: '--mp-viz-series-4', values: points.map(point => point.refundedCentavos) },
          ]} />
          <ChartDataTable caption={`${monthly ? 'Monthly' : 'Daily'} commission adjustments`} rowHeader={monthly ? 'Month' : 'Date'} rows={rows} columns={[
            column('Approved credits', points.map(point => point.creditsCentavos)), column('Commission refunds', points.map(point => point.refundedCentavos)),
          ]} />
        </AnalyticsChartCard>
        <DashboardPanel density="compact" title="Deductions and tax records" description="Recorded charges and evidence. Vendor withholding is separate from platform earnings.">
          <dl className="mp-finance-fee-totals">{[
            { key: 'processing_expense', label: 'Platform processing costs', hint: 'Provider charges on commission payments; absorbed by the platform.' },
            { key: 'fee_vat', label: 'Output VAT on fees', hint: 'The VAT portion of commission charges, under the recorded platform tax profile.' },
            { key: 'fee_credits', label: 'Approved commission credits', hint: 'Already deducted from platform commission charges.' },
            { key: 'assessed_cwt', label: 'Creditable withholding tax', hint: 'Vendor tax credit records. Never platform revenue or a second platform deduction.' },
            { key: 'reported_deductions', label: 'Provider-reported deductions', hint: 'Reconciliation evidence; not added to platform processing costs.' },
          ].map(item => <div key={item.key}><dt className="flex min-h-11 items-center justify-between gap-2 text-xs text-text-secondary"><span>{item.label}</span><CalculationHelp title={item.label}><p>{data.finance.find(figure => figure.key === item.key)?.definition ?? item.hint}</p></CalculationHelp></dt><dd className="text-base font-semibold tabular-nums">{formatPesoCentavos(finance(item.key))}</dd><dd className="mp-finance-caption">{item.hint}</dd></div>)}</dl>
        </DashboardPanel>
      </div>
      <DashboardPanel density="compact" title="Commission billing" description="Issued statements and current balances, filtered by statement issue date."
        action={<Link className="inline-flex min-h-11 items-center text-xs font-semibold text-action-primary underline underline-offset-4" to="/finance?view=statements">Manage statements</Link>}>
        <div className="grid gap-4">
          <dl className="mp-finance-product-totals">{[
            ['Issued commission bills', finance('billed')], ['Outstanding receivables', receivables], ['Overdue receivables', overdue],
          ].map(([label, amount]) => <div key={label}><dt>{label}</dt><dd>{formatPesoCentavos(Number(amount))}</dd></div>)}</dl>
          <FinanceBreakdownPanel title="Outstanding receivables" caption="Outstanding receivables calculation" rows={[
            { key: 'current', label: 'Issued, not yet due', amount: formatPesoCentavos(Math.max(0, receivables - overdue)) },
            { key: 'overdue', label: 'Overdue', amount: formatPesoCentavos(overdue) },
            { key: 'total', label: 'Outstanding receivables', amount: formatPesoCentavos(receivables), total: true },
          ]} />
        </div>
      </DashboardPanel>
      <FinanceOverviewChannels />
      </div>

    </section>

    <MethodNote label="What every figure means">
      <p className="mb-2">{data.scenario}</p>
      {points.length > 0 && <p className="mb-4">{`Charted by ${unit} · ${formatLabel(dates[0] ?? '')}${points.length > 1 ? ` – ${formatLabel(dates.at(-1) ?? '')}` : ''} (Asia/Manila)`}</p>}
      <div className="grid gap-4 md:grid-cols-2">{[['Platform figures', data.finance]].map(([title, items]) => <div key={String(title)} className="min-w-0">
        <p className="font-semibold text-text-strong">{String(title)}</p>
        <dl className="mt-2 grid gap-2">{(items as FinanceKpi[]).map(item => <div key={item.key}><dt className="font-semibold text-text-strong">{item.label}</dt><dd>{item.definition}</dd></div>)}</dl>
      </div>)}</div>
    </MethodNote>
  </>
}

/** The same channel grid used in Vendor Finance, with the platform's published TEST schedule. */
function FinanceOverviewChannels() {
  const channels = useLoad(listChannelFees, [])
  return <DashboardPanel density="compact" title="Online payment channels" description="Published TEST rates for commission payments. The platform absorbs these processing charges.">
    {channels.error ? <ErrorState message={channels.error} onRetry={channels.retry} /> : !channels.data ? <LoadingState /> : <PaymentChannelList layout="grid" caption="Commission payment channels" channels={channels.data.map(channel => ({
      code: channel.code, displayName: channel.displayName, available: channel.enabled, refundSupported: channel.refundSupported,
      unavailableReason: channel.disabledReason,
      rateLabel: `${(channel.ratePpm / 10000).toFixed(2)}%${channel.fixedCentavos > 0 ? ` + ${formatPesoCentavos(channel.fixedCentavos)}` : ''} · ${channel.rateIncludesVat ? 'VAT included' : `${channel.feeVatBasisPoints / 100}% VAT on fee`}`,
    }))} />}
  </DashboardPanel>
}

export function RemittanceQueue() {
  const [params] = useSearchParams()
  const [state, setStateFilter] = useState(() => {
    const requested = params.get('state')
    return requested === 'PENDING' || requested === 'ALL' ? 'PENDING' : requested === 'RECONCILED' ? 'RECONCILED' : 'RECONCILIATION_EXCEPTION'
  })
  const [range, setRange] = useState(() => dateRangeFromParams(params))
  const [approving, setApproving] = useState<RemittanceQueueRow | null>(null)
  const [notice, setNotice] = useState('')
  const paged = usePaged(page => remittanceQueue(page, state, range), [state, range.from, range.to])
  return <FinanceQueueWorkspace title="Remittance reconciliation" description="Recorded tax amounts and FIN-04A threshold changes. Taxpayer identifiers are masked."
    filters={<FilterChips label="Reconciliation state" chips={[{ value: 'RECONCILIATION_EXCEPTION', label: 'Exceptions' }, { value: 'PENDING', label: 'Pending' }, { value: 'RECONCILED', label: 'Reconciled' }]} value={state} onChange={setStateFilter} />}
    dateFilter={<DateFilter title="Remittance dates" value={range} onChange={setRange} persistSelection={!params.has('from') && !params.has('to')} />}
    note={state === 'PENDING' ? <p>Matching TEST remittances reconcile automatically. Missed records are retried every minute. Superadmin or Finance Admin can use backup approval after the same source checks. This does not confirm a BIR payment.</p> : <p>TEST reconciliation does not confirm a BIR payment. Resolve exceptions through the finance work queue.</p>}>
    {notice && <div className="p-4"><StatusMessage tone="success">{notice}</StatusMessage></div>}
    <Paged embedded state={paged} empty="No remittances in this state.">
      {items => <div className="mp-finance-reconciliation-ledger"><DenseLedgerTable<RemittanceQueueRow> compact responsive caption="Remittance assessments" rows={items} rowKey={row => row.id} columns={[
        { key: 'order', header: 'Order / Vendor', cell: row => <div className="grid gap-1"><p className="font-semibold">{row.orderReference}</p><p className="text-[13px] text-text-secondary">{row.vendorName}</p><p className="text-xs text-text-secondary">Taxpayer …{row.taxpayerKeySuffix}</p></div> },
        { key: 'amounts', header: 'Recorded amounts', cell: row => <FinanceRecordFacts items={[
          ['Tax basis', formatPesoCentavos(Number(row.components.gross_basis_centavos ?? 0))],
          ['Withholding', formatPesoCentavos(Number(row.components.withheld_centavos ?? 0))],
          ['Reported', row.components.reported_withheld_centavos === null || row.components.reported_withheld_centavos === undefined ? '—' : formatPesoCentavos(Number(row.components.reported_withheld_centavos))],
        ]} /> },
        { key: 'threshold', header: 'Withholding threshold', cell: row => <FinanceRecordFacts items={[
          ['Before', humanize(row.thresholdStatusBefore ?? 'NONE')], ['After', humanize(row.thresholdStatusAfter ?? 'NONE')],
          ...(row.gEffectiveAfterCentavos !== null && row.gEffectiveAfterCentavos !== undefined ? [['Recorded total', formatPesoCentavos(row.gEffectiveAfterCentavos)] as [string, string]] : []),
        ]} /> },
        { key: 'states', header: 'Reconciliation / review', cell: row => <div className="grid justify-items-start gap-2 text-[13px]">
          <StatusBadge label={row.calculationState === 'VOIDED' ? 'Voided · History' : humanize(row.reconciliationState)} tone={row.calculationState === 'VOIDED' ? 'neutral' : row.reconciliationState === 'RECONCILED' ? 'success' : row.reconciliationState === 'PENDING' ? 'neutral' : 'error'} />
          <div className="grid gap-1 text-text-secondary"><p>Calculation: {humanize(row.calculationState)}</p><p>Evidence: {humanize(row.deductionEvidenceState)}</p></div>
          {row.reconciliationMethod && <p>{row.reconciliationMethod === 'AUTOMATIC' ? 'Automatic · Demo' : 'Backup approval · Demo'}{row.reconciliationActorRole && row.reconciliationActorRole !== 'SYSTEM' ? ` · ${row.reconciliationActorRole === 'ADMIN_SUPERADMIN' ? 'Superadmin' : 'Finance Admin'}` : ''}</p>}
          {row.reconciledAt && <p className="text-xs text-text-secondary">{formatManilaDateTime(row.reconciledAt)}</p>}
          {row.canApproveReconciliation && <Button variant="secondary" onClick={() => { setNotice(''); setApproving(row) }}>Backup approval</Button>}
          {row.reviewItemId && <Link className="inline-flex min-h-11 items-center font-semibold text-action-primary underline-offset-4 hover:underline" to="/audit">Audit log</Link>}
        </div> },
      ]} /></div>}
    </Paged>
    {approving && <RemittanceApprovalDialog row={approving} onClose={() => setApproving(null)} onSaved={() => { setApproving(null); setNotice('Recorded TEST remittance reconciled through backup approval.'); paged.reload() }} />}
  </FinanceQueueWorkspace>
}

function RemittanceApprovalDialog({ row, onClose, onSaved }: { row: RemittanceQueueRow; onClose: () => void; onSaved: () => void }) {
  const formId = useId()
  const [key] = useState(() => crypto.randomUUID())
  const [reason, setReason] = useState('')
  const [error, setError] = useState('')
  const action = useProtectedAction()
  async function save() {
    if (action.busy) return
    setError('')
    if (reason.trim().length < 10) { setError('Describe the approval reason in at least 10 characters.'); return }
    const result = await action.run('Approve recorded remittance reconciliation', () => approveRemittanceReconciliation(row.id, row.sourceVersion, reason.trim(), key))
    if (result.ok) onSaved()
    else setError(problemText(result.problem))
  }
  return <>
    <FormDialog open size="compact" title="Backup remittance approval" description="Superadmin and Finance Admin only. The recorded collection, calculation and ledger must match. Approval cannot override a mismatch or record a BIR payment." busy={action.busy} onClose={onClose}
      footer={<div className="flex justify-end gap-3"><Button variant="secondary" disabled={action.busy} onClick={onClose}>Cancel</Button><Button type="submit" form={formId} disabled={action.busy}>{action.busy ? 'Approving…' : 'Approve reconciliation'}</Button></div>}>
      <form id={formId} onSubmit={event => { event.preventDefault(); void save() }}><fieldset className="grid gap-4" disabled={action.busy}>
        <p className="text-sm"><strong>{row.orderReference}</strong> · {row.vendorName}</p>
        <p className="text-sm">Recorded withholding: {formatPesoCentavos(Number(row.components.withheld_centavos ?? 0))} · TEST / Demo</p>
        {error && <StatusMessage tone="error">{error}</StatusMessage>}
        <Field label="Approval reason" required minLength={10} maxLength={2000} value={reason} onChange={event => setReason(event.target.value)} hint="Explain why backup approval is needed and which recorded sources you checked." />
      </fieldset></form>
    </FormDialog>
    {action.dialog}
  </>
}
