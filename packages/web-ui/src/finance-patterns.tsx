import { Fragment, useId, type ReactNode } from 'react'
import type { FinanceKpi, VendorCommissionAssessment, WithholdingCalculationBreakdown } from '@materyalph/api-client-ts'
import { AlertOctagon, BadgeCheck, Banknote, CalendarDays, CircleDashed, Clock, CreditCard, FileWarning, FlaskConical, History, Percent, Search, ShieldCheck, XCircle } from 'lucide-react'
import { formatPesoCentavos } from './order-patterns'
import { ProgressBar, StatusBadge } from './portal-shell'
import { DenseLedgerTable, formatManilaDateTime, type DateLike, type LedgerColumn } from './stock-ledger'
import { KpiBreakdown, KpiCard, type KpiBreakdownData } from './chart-patterns'
import { CalculationHelp } from './calculation-help'
import { DashboardPanel } from './dashboard-patterns'
import './finance-overview.css'

type Tone = 'success' | 'warning' | 'error' | 'info' | 'neutral'

/** One consistent payment definition and visual hierarchy for calendar-month and calendar-year totals. */
export function CommissionPaymentSummary({ title, period, annual = false, action }: {
  title: string; annual?: boolean; action?: ReactNode;
  period: { label: string; resetsAt: Date; collectedCentavos: number; refundedCentavos: number; netCollectedCentavos: number };
}) {
  return <DashboardPanel density="compact" title={title} description={`${annual ? 'Calendar year' : 'Calendar month'} · ${period.label}`}
    calculation={<><p>Confirmed payments from your store applied to commission statements, less completed commission refunds in this {annual ? 'year' : 'month'}.</p><p>Payments use their allocation date; refunds use their completion date, even if the original payment was in an earlier period. Pending or failed payments and refunds are excluded.</p><p>Buyer payments, unpaid bills, estimates and approved credits without a cash refund are excluded. Totals use Philippine time (Asia/Manila).</p></>}
    footer={<div className="grid gap-2"><p className="text-xs leading-5 text-text-secondary">Resets {formatManilaDateTime(period.resetsAt)}.<br />{annual ? 'Completed years remain in annual payment history.' : 'Starts again each month; included in the annual total.'}</p>{action && <div>{action}</div>}</div>}>
    <div className="mp-commission-payment-total"><span>Net paid commission</span><strong>{formatPesoCentavos(period.netCollectedCentavos)}</strong><span>Confirmed payments − completed refunds</span></div>
    <FinanceBreakdownPanel title="Payment breakdown" caption={`${annual ? 'Annual' : 'Monthly'} commission payments`} rows={[
      { key: 'collected', label: 'Payments collected', amount: formatPesoCentavos(period.collectedCentavos) },
      { key: 'refunds', label: 'Completed refunds', amount: formatPesoCentavos(-period.refundedCentavos || 0) },
    ]} />
  </DashboardPanel>
}

/** Compact, always-visible calculation using the same rows as dashboard metrics. */
export function FinanceBreakdownPanel({ title, hint, caption, rows, calculation, children }: KpiBreakdownData & { title: string; hint?: ReactNode; calculation?: ReactNode; children?: ReactNode }) {
  return <section className="mp-finance-breakdown" aria-label={caption}>
    {calculation ? <header className="mp-finance-breakdown-heading"><h3>{title}</h3><CalculationHelp title={title}>{calculation}</CalculationHelp></header> : <h3>{title}</h3>}
    {hint && <p className="mp-finance-caption">{hint}</p>}
    <KpiBreakdown caption={caption} rows={rows} />
    {children}
  </section>
}

/** Shared explanation for the posted commission adjustment, distinct from a cash refund. */
export function CommissionCreditsExplanation() {
  return <div className="mp-commission-credit-explanation">
    <p>Approved commission credits reverse part of an earned commission after an executed return or dispute award, or an independently approved correction.</p>
    <p>An unpaid bill is reduced. For a paid bill, the credit is owed back to the Vendor; the cash refund is recorded separately when confirmed.</p>
    <p><strong>Example:</strong> ₱500.00 commission − ₱50.00 approved credit = ₱450.00 commission after credits. The credit reduces earnings once.</p>
  </div>
}

function FinanceAnnualScope({ taxableYear }: { taxableYear: number }) {
  return <p className="mp-threshold-period"><strong><CalendarDays size={16} aria-hidden="true" />Annual · {taxableYear}</strong><span>Full taxable year. Not affected by the date filter.</span></p>
}

/** Annual platform collection tracking, separate from Vendor withholding accumulators and earned revenue. */
export function PlatformCollectionsThreshold({ figures, thresholdCentavos, taxableYear, showThreshold = true }: { figures: readonly FinanceKpi[]; thresholdCentavos: number; taxableYear: number; showThreshold?: boolean }) {
  const value = (key: string) => figures.find(figure => figure.key === key)?.valueCentavos
  const counted = value('net_collected')
  const remaining = counted === undefined ? undefined : Math.max(0, thresholdCentavos - counted)
  const percent = counted === undefined || thresholdCentavos <= 0 ? 0 : Math.max(0, Math.min(100, counted / thresholdCentavos * 100))
  const amount = (centavos: number | undefined) => centavos === undefined ? '—' : formatPesoCentavos(centavos)
  const refunds = value('refunded_commissions')
  return <div className="mp-threshold mp-platform-collections" data-show-threshold={showThreshold}>
    <FinanceAnnualScope taxableYear={taxableYear} />
    <div className="mp-threshold-progress">
      <dl className="mp-threshold-metrics">
        <div><dt>{showThreshold ? 'Annual gross remittances' : 'Annual net commission collections'}</dt><dd>{amount(counted)}</dd></div>
        {showThreshold && <div><dt>Remaining to threshold</dt><dd>{amount(remaining)}</dd></div>}
      </dl>
      {showThreshold && counted !== undefined && <>
        <ProgressBar value={percent} label={`${percent > 0 && percent < 0.1 ? 'Less than 0.1' : Math.floor(percent * 10) / 10}% of annual threshold · ${formatPesoCentavos(thresholdCentavos)}`} />
        <p className="mp-threshold-caption">{counted > thresholdCentavos ? 'Threshold crossed.' : counted === thresholdCentavos ? 'Threshold reached.' : 'Threshold not crossed.'}</p>
      </>}
    </div>
    <div className="mp-platform-collection-breakdown border-t border-border-default pt-3">
      <FinanceBreakdownPanel title="Recorded annual collections" caption={showThreshold ? 'Platform annual threshold calculation' : 'Platform annual collections calculation'} rows={[
        { key: 'collected', label: 'Successful commission payments', amount: amount(value('collected')) },
        { key: 'refunds', label: 'Confirmed commission refunds', amount: amount(refunds === undefined || refunds === 0 ? refunds : -refunds) },
        { key: 'counted', label: showThreshold ? 'Gross remittances counted' : 'Net annual commission collections', amount: amount(counted), total: true },
      ]} />
    </div>
    <p className="mp-finance-caption">Full taxable year, regardless of the selected platform earnings dates. Unpaid commissions and Buyer order payments are excluded. VAT and processing costs are not deducted from this collection total.</p>
    <p className="mp-finance-caption">{showThreshold && 'Collection threshold tracking only. '}Collection totals do not establish tax relief or withholding status. Any applicable withholding treatment is confirmed through Xendit.</p>
  </div>
}

/** Reuses the posted platform earnings figures without recalculating revenue from collections. */
export function PlatformEarningsBreakdown({ figures, title = 'Net platform earnings' }: { figures: readonly FinanceKpi[] | null; title?: string }) {
  const amount = (key: string, deduction = false) => {
    const value = figures?.find(figure => figure.key === key)?.valueCentavos
    return value === undefined ? '—' : formatPesoCentavos(deduction && value !== 0 ? -value : value)
  }
  return <FinanceBreakdownPanel title={title} caption="Net platform earnings calculation"
    calculation={<><p>Platform commission charges after approved credits − output VAT on fees = commission revenue excluding VAT. Subtract recorded platform processing costs to get Net platform earnings.</p><p>Earnings, approved credits and processing costs use their recorded event dates in Asia/Manila. Commission collections and refunds are separate cash events; they do not recognize or reverse earnings again. Buyer payments and Vendor withholding are excluded.</p></>}
    rows={[
      { key: 'commission', label: 'Platform commission charges', amount: amount('net_commission') },
      { key: 'vat', label: 'Output VAT on fees', amount: amount('fee_vat', true) },
      { key: 'revenue', label: 'Commission revenue, excluding VAT', amount: amount('platform_revenue'), total: true },
      { key: 'processing', label: 'Platform processing costs', amount: amount('processing_expense', true) },
      { key: 'total', label: 'Net platform earnings', amount: amount('net_platform_earnings'), total: true },
    ]} />
}

/** Related financial records align in columns when there is enough room. */
export function FinanceSummaryColumns({ children }: { children: ReactNode }) {
  return <div className="mp-finance-summary-columns">{children}</div>
}

/** A finance management ledger and its supporting policy/actions share one responsive workspace. */
export function FinanceManagementLayout({ children, aside }: { children: ReactNode; aside: ReactNode }) {
  return <div className="mp-finance-management"><div className="mp-finance-main">{children}</div><aside className="mp-finance-aside" aria-label="Commission policy and billing">{aside}</aside></div>
}

/** One ledger surface with labelled mobile records and contained desktop scrolling. */
export function FinanceTransactionList<T>({ caption, hint, columns, rows, rowKey, paymentKind, embedded = false }: {
  caption: string; hint?: ReactNode; columns: LedgerColumn<T>[]; rows: T[]; rowKey: (row: T) => string; paymentKind?: ((row: T) => 'ONLINE' | 'PHYSICAL') | undefined; embedded?: boolean
}) {
  return <section className={`mp-finance-transactions${embedded ? ' mp-finance-transactions-embedded' : ' mp-card'}`} aria-label={`${caption} records`}>
    {!embedded && <header className="mp-finance-transactions-heading">
      <div><h2>{caption}</h2>{hint && <p>{hint}</p>}</div>
      <DemoLabel>DEMO — No real funds or BIR filing</DemoLabel>
    </header>}
    <DenseLedgerTable caption={caption} columns={columns} rows={rows} rowKey={rowKey} rowClassName={row => paymentKind ? `mp-finance-payment-${paymentKind(row).toLowerCase()}` : ''} responsive compact />
  </section>
}

/** Text and icons identify the payment method alongside its color. */
export function FinancePaymentMethod({ kind }: { kind: 'ONLINE' | 'PHYSICAL' | 'REMITTANCE' }) {
  const Icon = kind === 'PHYSICAL' ? Banknote : kind === 'REMITTANCE' ? Percent : CreditCard
  return <span className="mp-finance-payment-method" data-kind={kind}><Icon size={14} aria-hidden="true" />{kind === 'PHYSICAL' ? 'Physical payment' : kind === 'REMITTANCE' ? 'Remittance assessment' : 'Online payment'}</span>
}

export type FinancePaymentAssessment = {
  calculationState: string; grossBasisCentavos: number | null; withheldCentavos: number | null; expectedCashCentavos: number | null
  orderAfterRefundsCentavos: number | null; netRemittanceCentavos: number | null
  orderPaymentCentavos: number | null; principalRefundsCentavos: number | null
  collectedCentavos: number | null; refundsCentavos: number | null; providerChargeCentavos: number | null
  deliveryCentavos: number | null; materialVatCentavos: number | null; effectiveRateBasisPoints: number | null
  thresholdStatus: string; deductionEvidence: string; reconciliationState: string; at: DateLike
}

/** Explain the original assessment using its saved allocations and effective rate. */
function PaymentTaxBreakdown({ assessment }: { assessment: FinancePaymentAssessment }) {
  const posted = assessment.calculationState === 'POSTED'
  const complete = [assessment.collectedCentavos, assessment.refundsCentavos, assessment.deliveryCentavos, assessment.materialVatCentavos, assessment.providerChargeCentavos].every(amount => amount !== null)
  return <div className="mp-finance-tax-breakdown">
    <p>The tax basis is the recorded portion of this payment used to calculate withholding tax.</p>
    <ol className="mp-finance-tax-steps">
      <li>
        <h4><span aria-hidden="true">1</span>Find the tax basis</h4>
        <p>Start with the payment received, then remove the recorded exclusions.</p>
        <FinanceCalculationBreakdown caption="Tax basis calculation" rows={[
          { key: 'collected', label: 'Payment received', amountCentavos: assessment.collectedCentavos },
          { key: 'refunds', label: 'Refunds before assessment', amountCentavos: assessment.refundsCentavos, deduction: true },
          { key: 'delivery', label: 'Separately billed delivery', amountCentavos: assessment.deliveryCentavos, deduction: true },
          { key: 'vat', label: 'Included material VAT', amountCentavos: assessment.materialVatCentavos, deduction: true },
          { key: 'provider', label: 'Payment provider charge', amountCentavos: assessment.providerChargeCentavos, deduction: true },
        ]} totalLabel={posted ? 'Tax basis' : 'Tax basis · needs review'} totalCentavos={assessment.grossBasisCentavos} />
        {!complete && <p>Some original amounts are unavailable (—). The recorded tax basis is retained; missing amounts are not treated as zero.</p>}
      </li>
      <li>
        <h4><span aria-hidden="true">2</span>Apply the withholding rate</h4>
        <WithholdingStatusBadge status={assessment.thresholdStatus} />
        {posted ? <FinanceWithholdingCalculation basisCentavos={assessment.grossBasisCentavos} rateBasisPoints={assessment.effectiveRateBasisPoints} withheldCentavos={assessment.withheldCentavos} /> : <p>Calculation needs review. These original amounts are not a finalized withholding calculation.</p>}
        <p>{assessment.effectiveRateBasisPoints === null ? 'The original effective rate is unavailable. ' : ''}The standard rate is 0.5%; approved relief can reduce it. Withholding is rounded half-up to the nearest centavo.</p>
      </li>
    </ol>
    <div className="mp-finance-tax-context">
      <p>{assessment.at ? `Assessed ${formatManilaDateTime(assessment.at)}.` : 'Original recorded assessment.'} Later refunds do not recalculate the posted basis or lower a crossed annual threshold.</p>
      <p>Delivery and included VAT are excluded from the tax basis but remain in the Vendor payment. Commission is billed separately.</p>
    </div>
  </div>
}

/** Display the original assessment values; never recalculate tax from a later retained payment. */
export function FinanceWithholdingCalculation({ basisCentavos, rateBasisPoints, withheldCentavos }: { basisCentavos: number | null; rateBasisPoints: number | null; withheldCentavos: number | null }) {
  return <dl className="mp-finance-tax-rate">
    <div><dt>Tax basis</dt><dd><FinanceAmount centavos={basisCentavos} /></dd></div>
    <div><dt>× Applied rate</dt><dd>{rateBasisPoints === null ? '—' : `${rateBasisPoints / 100}%`}</dd></div>
    <div className="mp-finance-remittance-total"><dt>Withholding tax</dt><dd><FinanceAmount centavos={withheldCentavos} total /></dd></div>
  </dl>
}

/** Keep recorded tax beside its payment; voided figures remain history rather than current cash. */
export function FinancePaymentRemittance({ reference, physical, assessment }: { reference: string; physical: boolean; assessment: FinancePaymentAssessment | null }) {
  if (physical) return <span className="mp-finance-record-note">Not applicable · Direct Vendor payment</span>
  if (!assessment) return <span className="mp-finance-record-note">Not assessed</span>
  const voided = assessment.calculationState === 'VOIDED'
  const review = assessment.calculationState === 'BASE_REVIEW_REQUIRED'
  const fullyRefunded = assessment.orderAfterRefundsCentavos === 0
  const historyOnly = voided || fullyRefunded || assessment.orderAfterRefundsCentavos === null
  const originalCalculation = <FinanceCalculationBreakdown caption="Recorded provider reconciliation" rows={[
    { key: 'collections', label: 'Provider collection, including Buyer fees', amountCentavos: assessment.collectedCentavos },
    { key: 'refunds', label: 'Refunds allocated at assessment', amountCentavos: assessment.refundsCentavos, deduction: true },
    { key: 'provider', label: 'Provider charge in original record', amountCentavos: assessment.providerChargeCentavos, deduction: true },
    { key: 'withholding', label: 'Recorded withholding tax', amountCentavos: assessment.withheldCentavos, deduction: true },
  ]} totalLabel="Original expected cash" totalCentavos={assessment.expectedCashCentavos} />
  const details = <CalculationHelp title={`Remittance details · ${reference}`} label="View breakdown" wide>
    <p><strong>Order amount after refunds</strong> matches the annual retained online payments list: the order payment less completed principal refunds. It includes delivery and included VAT. Buyer-paid fees stay separate.</p>
    <p><strong>Net remittance</strong> is the order amount after refunds less the recorded withholding tax. Commission is billed separately. This is an estimate, not an available Xendit balance.</p>
    <p>Tax assessed at {formatManilaDateTime(assessment.at)}. Later refunds do not rewrite the original tax basis or withholding.</p>
    {historyOnly && <p>{voided ? 'Original assessment · voided.' : fullyRefunded ? 'Fully refunded payment.' : 'Historical assessment without a linked payment.'} The original figures below are history, not current remittance cash.</p>}
    {!historyOnly && <FinanceCalculationBreakdown caption="Order payment calculation" rows={[
      { key: 'principal', label: 'Order payment', amountCentavos: assessment.orderPaymentCentavos },
      { key: 'refunds', label: 'Completed order refunds', amountCentavos: assessment.principalRefundsCentavos, deduction: true },
      { key: 'withholding', label: 'Withholding tax', amountCentavos: assessment.withheldCentavos, deduction: true },
    ]} totalLabel="Net remittance" totalCentavos={assessment.netRemittanceCentavos} />}
    {historyOnly ? originalCalculation : <details><summary className="inline-flex min-h-11 cursor-pointer items-center font-semibold text-action-primary">Original provider reconciliation</summary>{originalCalculation}</details>}
    <p>Withholding basis: <FinanceAmount centavos={assessment.grossBasisCentavos} />.</p>
    <WithholdingStatusBadge status={assessment.thresholdStatus} />
    <p>Deduction evidence: {assessment.deductionEvidence.replaceAll('_', ' ').toLowerCase()}. Reconciliation: {assessment.reconciliationState.replaceAll('_', ' ').toLowerCase()}.</p>
  </CalculationHelp>
  return <div className="mp-finance-payment-remittance">
    {historyOnly ? <div className="mp-finance-remittance-heading"><span className="mp-finance-record-note">{voided ? 'Voided — fully refunded' : review ? 'Calculation needs review' : fullyRefunded ? 'Fully refunded · Tax record retained' : 'Historical assessment'}</span></div> : <>
      {review && <span className="mp-finance-record-note">Calculation needs review</span>}
      <dl className="mp-finance-remittance-summary">
        <div><dt>Order after refunds</dt><dd><FinanceAmount centavos={assessment.orderAfterRefundsCentavos} /></dd></div>
        <div><dt>Withholding tax</dt><dd><FinanceAmount centavos={assessment.withheldCentavos} deduction /></dd></div>
        <div className="mp-finance-remittance-total"><dt>Net remittance</dt><dd><FinanceAmount centavos={assessment.netRemittanceCentavos} total /></dd></div>
      </dl>
    </>}
    <div className="mp-finance-remittance-basis">
      {voided ? details : <CalculationHelp title={`Tax basis · ${reference}`} label="View breakdown" wide><PaymentTaxBreakdown assessment={assessment} /></CalculationHelp>}
    </div>
  </div>
}

/** Signed deductions are visual only; recorded values and totals stay authoritative. */
export function FinanceAmount({ centavos, deduction = false, total = false }: { centavos: number | null | undefined; deduction?: boolean; total?: boolean }) {
  const amount = centavos === null || centavos === undefined ? null : deduction && centavos !== 0 ? -Math.abs(centavos) : centavos
  return <span className={`mp-finance-amount${total ? ' mp-finance-amount-total' : ''}`}>{amount === null ? '—' : formatPesoCentavos(amount)}</span>
}

/** Keep the original rate and every recorded amount together in desktop and mobile records. */
export function CommissionOrderTable({ rows }: { rows: VendorCommissionAssessment[] }) {
  return <div className="mp-commission-orders"><DenseLedgerTable caption="Commission by order" rows={rows} rowKey={row => row.id} responsive compact columns={[
    { key: 'order', header: 'Order', cell: row => <span className="font-semibold">{row.orderReference}</span> },
    { key: 'basis', header: 'Materials value', className: 'tabular-nums', headerClassName: 'text-right', cell: row => <div className="mp-commission-amount"><span>{formatPesoCentavos(row.commissionBasisCentavos)}</span><span className="mp-commission-secondary">Commission rate <strong>{(row.commissionBasisPoints / 100).toFixed(2)}%</strong></span></div> },
    { key: 'estimated', header: 'Estimated commission', className: 'tabular-nums', headerClassName: 'text-right', cell: row => <div className="mp-commission-amount">{formatPesoCentavos(row.estimatedCentavos)}</div> },
    { key: 'charges', header: 'Commission charged', className: 'tabular-nums', headerClassName: 'text-right', cell: row => <div className="mp-commission-amount"><span>{formatPesoCentavos(row.earnedCentavos)}</span><span className="mp-commission-secondary">Fee reduction {formatPesoCentavos(row.creditedCentavos === 0 ? 0 : -row.creditedCentavos)}</span></div> },
    { key: 'net', header: 'Final commission', className: 'tabular-nums', headerClassName: 'text-right', cell: row => <div className="mp-commission-amount font-semibold">{formatPesoCentavos(row.netCentavos)}</div> },
    { key: 'status', header: 'Status', cell: row => <div className="mp-commission-status"><StatusBadge label={row.disputeHold ? 'Dispute hold' : row.state === 'EARNED' ? 'Charged' : row.state === 'ESTIMATED' ? 'Estimated' : 'Cancelled'} tone={row.disputeHold ? 'warning' : row.state === 'EARNED' ? 'success' : row.state === 'ESTIMATED' ? 'info' : 'error'} />{row.earnedAt && <span className="mp-commission-secondary">{formatManilaDateTime(row.earnedAt)}</span>}</div> },
  ]} /></div>
}

/** Provider facts use the reference's accent card without inventing payout data. */
export function FinanceProviderCard({ title, status, items, note, action, summary, children }: { title: string; status: ReactNode; items: [string, ReactNode][]; note?: ReactNode; action: ReactNode; summary?: ReactNode; children?: ReactNode }) {
  return <section aria-label={title} className="mp-finance-provider">
    {summary && <div className="mp-finance-provider-summary">{summary}</div>}
    <header><h2>{title}</h2>{status}</header>
    <dl>{items.map(([label, value]) => <div key={label}><dt>{label}</dt><dd>{value}</dd></div>)}</dl>
    {note && <p>{note}</p>}
    <div className="mp-finance-provider-action">{action}</div>
    {children && <div className="mp-finance-provider-content">{children}</div>}
  </section>
}

/** One commission-policy summary for both accounting and Vendor monitoring. */
export function CommissionRateSummary({ rateLabel, effectiveFrom, nextRateLabel, nextEffectiveFrom, actions, layout = 'inline' }: {
  rateLabel?: string | undefined; effectiveFrom?: DateLike | undefined; nextRateLabel?: string | undefined; nextEffectiveFrom?: DateLike | undefined; actions?: ReactNode; layout?: 'inline' | 'panel'
}) {
  return <section aria-label="Commission rate" data-layout={layout} className="mp-commission-rate flex min-w-0 flex-wrap items-center justify-between gap-4 mp-card mp-card-padded">
    <div className="flex min-w-0 items-start gap-3"><Percent size={20} className="mt-1 shrink-0 text-action-primary" aria-hidden="true" />
      <div className="min-w-0"><p className="text-sm font-semibold text-text-strong">Current commission rate <span className="ml-2 text-xl tabular-nums">{rateLabel ?? 'Not configured'}</span></p>
        <p className="mt-1 text-xs text-text-secondary">{effectiveFrom ? `Effective ${formatManilaDateTime(effectiveFrom)}` : 'An approved policy is required.'}</p>
        <p className="mt-1 text-sm text-text-secondary">Completed materials after discounts, excluding materials VAT. Billed monthly.</p>
        {nextRateLabel && <p className="mt-2 text-sm font-semibold text-text-strong">Scheduled: {nextRateLabel} · {formatManilaDateTime(nextEffectiveFrom)}</p>}
      </div>
    </div>
    {actions && <div className="flex flex-wrap items-center gap-2">{actions}</div>}
  </section>
}

export type FinanceCalculationRow = { key: string; label: string; note?: string; detail?: ReactNode; amountCentavos: number | null; deduction?: boolean }

/** Display recorded calculation components; the authoritative total is supplied by the API. */
export function FinanceCalculationBreakdown({ caption, rows, totalLabel, totalCentavos, minusSigns = false, emphasizeTotal = false }: {
  caption: string; rows: readonly FinanceCalculationRow[]; totalLabel: string; totalCentavos: number | null; minusSigns?: boolean; emphasizeTotal?: boolean
}) {
  return <div className="overflow-hidden rounded-control border border-border-default">
    <table className="w-full border-collapse text-sm">
      <caption className="sr-only">{caption}</caption>
      <thead className="bg-surface-canvas text-xs text-text-secondary"><tr><th scope="col" className="px-4 py-2.5 text-left font-semibold">Item</th><th scope="col" className="whitespace-nowrap px-4 py-2.5 text-right font-semibold">Amount</th></tr></thead>
      <tbody>{rows.map(row => <Fragment key={row.key}><tr className="border-t border-border-default">
        <th scope="row" className="px-4 py-3 text-left font-normal text-text-secondary">{row.label}{row.note && <span className="mt-1 block text-xs leading-5">{row.note}</span>}</th>
        <td className="whitespace-nowrap px-4 py-3 text-right font-medium tabular-nums text-text-strong">{row.amountCentavos === null ? '—' : formatPesoCentavos(row.deduction && row.amountCentavos !== 0 ? -row.amountCentavos : row.amountCentavos).replace('-', minusSigns ? '−' : '-')}</td>
      </tr>{row.detail && <tr><td colSpan={2} className="mp-finance-subcalculation">{row.detail}</td></tr>}</Fragment>)}</tbody>
      <tfoot><tr className={`border-t border-border-default ${emphasizeTotal ? 'bg-brand-orange-50 text-text-strong' : 'bg-surface-canvas text-text-strong'}`}><th scope="row" className={`px-4 ${emphasizeTotal ? 'py-4' : 'py-3.5'} text-left font-semibold`}>{totalLabel}</th><td className={`whitespace-nowrap px-4 ${emphasizeTotal ? 'py-4' : 'py-3.5'} text-right font-semibold tabular-nums ${emphasizeTotal ? 'text-2xl' : ''}`}>{totalCentavos === null ? '—' : formatPesoCentavos(totalCentavos)}</td></tr></tfoot>
    </table>
  </div>
}

/** Visible label for every simulated figure (FIN-12). Text, not color, carries the meaning. */
export function DemoLabel({ children = 'DEMO — simulated figures' }: { children?: ReactNode }) {
  return <span className="inline-flex min-h-7 items-center gap-1.5 rounded-pill border border-amber-300 bg-amber-50 px-2.5 text-xs font-semibold uppercase tracking-wide text-amber-900">
    <FlaskConical size={14} aria-hidden="true" />{children}
  </span>
}

const withholdingStatus: Record<string, { label: string; tone: Tone; icon: typeof ShieldCheck }> = {
  RELIEF_ACTIVE: { label: 'Relief active — no withholding', tone: 'success', icon: ShieldCheck },
  SUBJECT_STANDARD: { label: 'Subject to withholding — standard', tone: 'warning', icon: Percent },
  SUBJECT_THRESHOLD_BREACHED: { label: 'Subject to withholding — threshold crossed', tone: 'error', icon: AlertOctagon },
  SUBJECT_PRIOR_YEAR: { label: 'Subject to withholding — prior year above threshold', tone: 'warning', icon: History },
  UNDER_REVIEW: { label: 'Under review — standard rate applies', tone: 'info', icon: Search },
  NOT_STARTED: { label: 'No remittance assessed this taxable year', tone: 'neutral', icon: CircleDashed },
}

/** FIN-04A status as text plus icon; the canonical value is never shown as EXEMPT or SUBJECT_TO_WITHHOLDING. */
export function WithholdingStatusBadge({ status }: { status: string }) {
  const meta = withholdingStatus[status] ?? withholdingStatus.NOT_STARTED!
  const Icon = meta.icon
  return <StatusBadge label={meta.label} tone={meta.tone} icon={<Icon size={14} aria-hidden="true" />} />
}

export type ThresholdPanelData = {
  taxableYear: number
  thresholdCentavos: number
  cumulativeGrossCentavos: number
  remainingAllowanceCentavos: number
  localGrossCentavos: number
  externalDeclaredCentavos: number
  externalOverlapCentavos: number
  externalOverlapState: string
  percentOfThreshold: number
  advisory: boolean
  status: string
  reasonCode?: string | null | undefined
  crossedAt?: DateLike
  priorYearTotalCentavos?: number | null | undefined
  finalForYearNotice: string
  calculationBreakdown?: {
    assessedPayments?: number; paymentPrincipalCentavos?: number; buyerProcessingFeesCentavos?: number
    collectionsCentavos: number; refundsCentavos: number; deliveryCentavos: number; materialVatCentavos: number
    providerChargesCentavos: number; grossBasisCentavos: number; withheldCentavos: number; assessedCashCentavos: number
    withholdingBreakdown?: WithholdingCalculationBreakdown | null | undefined
  } | null | undefined
}

/**
 * FIN-04A threshold panel: taxable year, cumulative gross remittances in pesos, the remaining allowance floored at
 * zero, status as text and icon, the crossing date and time in Asia/Manila, and the plain sentence that crossing
 * is final for the year. The meter is decorative reinforcement of the stated numbers, never the only signal.
 */
export function ThresholdPanel({ data, headingLevel = 2, showDemoLabel = true, layout = 'standard', hasApprovedDeclaration, paymentBreakdown }: { data: ThresholdPanelData; headingLevel?: 2 | 3; showDemoLabel?: boolean; layout?: 'standard' | 'overview'; hasApprovedDeclaration?: boolean; paymentBreakdown?: ReactNode }) {
  if (layout === 'overview') return <ThresholdOverview data={data} headingLevel={headingLevel} showDemoLabel={showDemoLabel} hasApprovedDeclaration={hasApprovedDeclaration} paymentBreakdown={paymentBreakdown} />
  const Heading = headingLevel === 2 ? 'h2' : 'h3'
  const percent = Math.max(0, Math.min(100, data.percentOfThreshold))
  const breached = data.crossedAt !== null && data.crossedAt !== undefined
  const meterTone = breached ? 'bg-red-700' : data.advisory ? 'bg-amber-600' : 'bg-action-primary'
  const calculation = data.calculationBreakdown
  return <section className="grid min-w-0 gap-4" aria-labelledby="threshold-heading">
    <div className="flex flex-wrap items-center justify-between gap-3">
      <div className="flex min-w-0 items-start gap-3">
        <div className="min-w-0">
        <Heading id="threshold-heading" className="text-lg font-semibold text-text-strong">Gross-remittance threshold — taxable year {data.taxableYear}</Heading>
        <p className="mt-1 text-sm leading-6 text-text-secondary">Tracks this taxpayer’s annual ₱500,000.00 withholding tax threshold. It is separate from Net sales and Xendit cash revenue estimates.</p>
        </div>
      </div>
      <div className="flex min-w-0 max-w-full flex-wrap gap-2 [&>span]:max-w-full [&>span]:whitespace-normal"><WithholdingStatusBadge status={data.status} />{showDemoLabel && <DemoLabel />}</div>
    </div>
    {breached && <div role="status" className="flex gap-3 rounded-control border border-red-300 bg-red-50 p-3 text-sm text-red-900"><AlertOctagon className="mt-0.5 shrink-0" size={18} aria-hidden="true" />
      <p><strong>Threshold crossed on {formatManilaDateTime(data.crossedAt)} (Asia/Manila).</strong> {data.finalForYearNotice}</p></div>}
    {!breached && data.advisory && <div role="status" className="flex gap-3 rounded-control border border-amber-300 bg-amber-50 p-3 text-sm text-amber-900"><Clock className="mt-0.5 shrink-0" size={18} aria-hidden="true" />
      <p><strong>Advisory: 80% of the threshold reached.</strong> Withholding will apply to the whole remittance that crosses ₱500,000.00 and to every later one this taxable year.</p></div>}
    <dl className="mp-card-group grid min-w-0 gap-3 sm:grid-cols-2 lg:grid-cols-4">
      <Figure label="Cumulative gross remittances" value={formatPesoCentavos(data.cumulativeGrossCentavos)} accent />
      <Figure label="Remaining allowance" value={formatPesoCentavos(Math.max(0, data.remainingAllowanceCentavos))} hint="Never below ₱0.00" />
      <Figure label="Threshold" value={formatPesoCentavos(data.thresholdCentavos)} />
      <Figure label="Crossing date and time" value={breached ? `${formatManilaDateTime(data.crossedAt)} (Asia/Manila)` : 'Not crossed'} icon={<Clock size={16} />} />
    </dl>
    <div className="grid gap-1.5">
      <div className="flex flex-wrap justify-between gap-2 text-xs font-semibold text-text-secondary"><span>{percent}% of threshold</span><span>{formatPesoCentavos(data.thresholdCentavos)}</span></div>
      <div className="h-2.5 overflow-hidden rounded-full bg-surface-canvas ring-1 ring-border-default" aria-hidden="true"><div className={`h-full ${meterTone}`} style={{ width: `${percent}%` }} /></div>
    </div>
    <dl className="grid gap-x-8 gap-y-2 border-t border-border-default pt-3 text-sm sm:grid-cols-2">
      <SmallFigure label="On-platform gross" value={formatPesoCentavos(data.localGrossCentavos)} />
      <SmallFigure label="Declared outside-platform" value={`${formatPesoCentavos(data.externalDeclaredCentavos)}${data.externalOverlapState === 'UNRESOLVED' ? ' (overlap under review)' : data.externalOverlapCentavos > 0 ? ` less ${formatPesoCentavos(data.externalOverlapCentavos)} already counted` : ''}`} />
      {data.priorYearTotalCentavos !== null && data.priorYearTotalCentavos !== undefined && <SmallFigure label="Prior taxable year total" value={formatPesoCentavos(data.priorYearTotalCentavos)} />}
      {data.reasonCode && <SmallFigure label="Status reason" value={data.reasonCode.replaceAll('_', ' ').toLowerCase()} />}
    </dl>
    <p className="text-sm leading-6 text-text-secondary">{data.finalForYearNotice}</p>
    {calculation && <div className="grid min-w-0 gap-6 lg:grid-cols-2">
      <div className="min-w-0">
        <p className="font-semibold text-text-strong">On-platform threshold calculation</p>
        <ThresholdBasisCalculation data={data} />
      </div>
      <div className="min-w-0">
        <p className="font-semibold text-text-strong">Remittance cash for these assessments</p>
        <ThresholdCashCalculation calculation={calculation} />
      </div>
    </div>}
    <div className="rounded-control border border-border-default bg-surface-canvas p-3 text-sm leading-6 text-text-secondary">
      <p className="font-semibold text-text-strong">How this is calculated</p>
      <p className="mt-1">The threshold measures the qualifying gross basis. Estimated remittance cash includes delivery and material VAT, and deducts withholding. Withholding does not reduce the threshold basis. Commission is billed separately.</p>
      <p className="mt-2">This panel covers taxable year {data.taxableYear} across stores with the same taxpayer identity, regardless of the Earnings date filter. Cumulative gross is on-platform gross plus declared outside-platform gross, less confirmed overlap.</p>
      <p className="mt-2">These are the amounts recorded at assessment. Earnings reflects later confirmed refunds. Before the year crosses {formatPesoCentavos(data.thresholdCentavos)}, a fully refunded collection is voided and removed from this threshold total; a partial refund does not change the posted basis. After crossing, refunds do not reduce this counter or restore relief.</p>
    </div>
  </section>
}

function ThresholdBasisCalculation({ data, compact = false }: { data: ThresholdPanelData; compact?: boolean }) {
  const calculation = data.calculationBreakdown
  if (!calculation) return null
  return <div className="mp-threshold-calculation-content"><FinanceCalculationBreakdown caption="On-platform threshold calculation" rows={[
    { key: 'collected', label: compact ? 'Online payments' : calculation.assessedPayments === undefined ? 'Assessed online payments' : `Assessed online payments (${calculation.assessedPayments})`,
      ...(!compact && calculation.paymentPrincipalCentavos !== undefined && calculation.buyerProcessingFeesCentavos !== undefined ? { note: `${formatPesoCentavos(calculation.paymentPrincipalCentavos)} order amounts + ${formatPesoCentavos(calculation.buyerProcessingFeesCentavos)} E-wallet transaction fees` } : {}), amountCentavos: compact ? calculation.collectionsCentavos - calculation.refundsCentavos - calculation.providerChargesCentavos : calculation.collectionsCentavos },
    ...(!compact ? [{ key: 'refunds', label: 'Refunds allocated before assessment', amountCentavos: calculation.refundsCentavos, deduction: true }] : []),
    { key: 'delivery', label: compact ? 'Delivery' : 'Separately billed delivery', amountCentavos: calculation.deliveryCentavos, deduction: true },
    { key: 'vat', label: compact ? 'Material VAT' : 'Included material VAT', amountCentavos: calculation.materialVatCentavos, deduction: true },
    ...(!compact ? [{ key: 'provider', label: 'Provider charges', amountCentavos: calculation.providerChargesCentavos, deduction: true }] : []),
  ]} totalLabel={compact ? 'Total gross threshold' : 'On-platform gross toward threshold'} totalCentavos={data.localGrossCentavos} /></div>
}

function ThresholdCashCalculation({ calculation }: { calculation: NonNullable<ThresholdPanelData['calculationBreakdown']> }) {
  return <FinanceCalculationBreakdown caption="Remittance cash for these assessments" rows={[
    { key: 'collected', label: 'Total Online payment collected', amountCentavos: calculation.collectionsCentavos - calculation.refundsCentavos - calculation.providerChargesCentavos },
    { key: 'withheld', label: 'Creditable withholding tax', amountCentavos: calculation.withheldCentavos, deduction: true },
  ]} totalLabel="Estimated cash at assessment" totalCentavos={calculation.assessedCashCentavos} />
}

export function formatWithholdingCalculation(grossBasisCentavos: number, rateBasisPoints: number): string {
  return `${formatPesoCentavos(grossBasisCentavos)} tax basis × ${rateBasisPoints / 100}% · Rounded per payment`
}

function WithholdingTaxCalculation({ data }: { data: ThresholdPanelData }) {
  const calculation = data.calculationBreakdown
  const breakdown = calculation?.withholdingBreakdown
  return <div className="grid min-w-0 gap-3">
    <p>Taxable year {data.taxableYear} · TEST figures · All stores with the same taxpayer identity.</p>
    <p>For each payment: tax basis × recorded tax rate, rounded to centavos. Add those recorded tax amounts to get the total.</p>
    {calculation && breakdown ? <>
      <FinanceCalculationBreakdown caption="Withholding tax calculation" rows={[
        ...breakdown.payments.map(payment => ({ key: payment.id, label: payment.orderReference,
          note: formatWithholdingCalculation(payment.grossBasisCentavos, payment.rateBasisPoints), amountCentavos: payment.withheldCentavos })),
        ...(breakdown.remainingPayments > 0 ? [{ key: 'remaining', label: `Other assessments (${breakdown.remainingPayments})`,
          note: `${formatPesoCentavos(breakdown.remainingBasisCentavos)} combined tax basis · Recorded tax amounts added together`, amountCentavos: breakdown.remainingWithheldCentavos }] : []),
      ]} totalLabel="Total withholding tax" totalCentavos={calculation.withheldCentavos} />
      <p>First five payments from this store; the rest are combined. Later refunds do not change recorded tax.</p>
    </> : <p>Payment calculation details are unavailable. {calculation ? 'The total shown is the recorded yearly withholding tax.' : 'The recorded yearly total is also unavailable.'}</p>}
  </div>
}

/** Compact Vendor view of recorded taxpayer-year threshold components. */
function ThresholdOverview({ data, headingLevel, showDemoLabel, hasApprovedDeclaration, paymentBreakdown }: { data: ThresholdPanelData; headingLevel: 2 | 3; showDemoLabel: boolean; hasApprovedDeclaration?: boolean | undefined; paymentBreakdown?: ReactNode }) {
  const headingId = useId()
  const Heading = headingLevel === 2 ? 'h2' : 'h3'
  const crossed = data.crossedAt !== null && data.crossedAt !== undefined
  const percent = data.thresholdCentavos > 0 ? Math.max(0, Math.min(100, data.cumulativeGrossCentavos / data.thresholdCentavos * 100)) : 0
  const progressLabel = percent > 0 && percent < 0.1 ? 'Less than 0.1%' : `${Math.floor(percent * 10) / 10}%`
  const withholdingApplies = ['SUBJECT_STANDARD', 'SUBJECT_THRESHOLD_BREACHED', 'SUBJECT_PRIOR_YEAR', 'UNDER_REVIEW'].includes(data.status)
  const missingDeclaration = data.status === 'SUBJECT_STANDARD' && data.reasonCode === 'NO_DECLARATION'
  const withholdingOnly = data.status !== 'RELIEF_ACTIVE' && (hasApprovedDeclaration === false || missingDeclaration)
  const statusExplanation: Record<string, string> = {
    RELIEF_ACTIVE: 'Approved relief applies while the qualifying annual total stays within the threshold.',
    SUBJECT_STANDARD: missingDeclaration ? 'Tax applies to the tax basis shown below, regardless of the annual total. A Sworn Declaration must be reviewed and approved before relief can apply.' : 'Standard withholding applies. Being below the threshold does not automatically grant relief.',
    SUBJECT_THRESHOLD_BREACHED: 'Withholding applies to the full crossing remittance and every later remittance this taxable year. Refunds or later declarations do not restore relief.',
    SUBJECT_PRIOR_YEAR: 'The prior year exceeded the threshold. Standard withholding continues until a new relief basis is reviewed.',
    UNDER_REVIEW: 'Your threshold information is under review. Standard withholding applies while the review is pending.',
    NOT_STARTED: 'No remittance assessment is recorded for this taxable year.',
  }
  return <section className="mp-threshold" aria-labelledby={headingId}>
    <header className="mp-threshold-heading"><div><Heading id={headingId}>{withholdingOnly ? 'Withholding tax' : 'Gross-remittance threshold'}</Heading><p>All stores with the same taxpayer identity</p></div>
      <dl className="mp-threshold-tax-total" aria-label="Total withholding tax"><div>
        <dt>Total withholding tax<CalculationHelp title="Total withholding tax" wide><WithholdingTaxCalculation data={data} /></CalculationHelp></dt>
        <dd>{formatPesoCentavos(data.calculationBreakdown?.withheldCentavos)}{!data.calculationBreakdown && <span>Recorded total unavailable</span>}</dd>
      </div></dl>
      {showDemoLabel && <DemoLabel />}
    </header>
    <FinanceAnnualScope taxableYear={data.taxableYear} />
    <div className="mp-threshold-top">
      <div className="mp-threshold-progress">
        {!withholdingOnly && <dl className="mp-threshold-metrics">
          <div><dt>Counted toward threshold</dt><dd>{formatPesoCentavos(data.cumulativeGrossCentavos)}</dd></div>
          <div><dt>Remaining to threshold</dt><dd>{formatPesoCentavos(Math.max(0, data.remainingAllowanceCentavos))}</dd></div>
        </dl>}
        {withholdingApplies && <div className="mp-threshold-withholding-bar" role="note" aria-label="Tax is withheld"><Percent size={18} aria-hidden="true" /><strong>Tax is withheld</strong></div>}
        {!withholdingOnly && <div className="mp-threshold-meter-label"><span>{progressLabel} of annual threshold</span><span>{formatPesoCentavos(data.thresholdCentavos)}</span></div>}
        {!withholdingOnly && !withholdingApplies && <div className="mp-threshold-meter" aria-hidden="true"><span data-tone={crossed ? 'crossed' : data.advisory ? 'advisory' : 'normal'} style={{ width: `${percent}%` }} /></div>}
        {(!withholdingOnly || crossed) && <p className="mp-threshold-caption">{crossed ? <>Threshold crossed on {formatManilaDateTime(data.crossedAt)}.</> : 'Threshold not crossed.'}</p>}
        {!crossed && missingDeclaration && <div className="mp-threshold-withholding-notice" role="note" aria-label="Why tax is withheld">
          <FileWarning size={20} aria-hidden="true" />
          <div><p className="mp-threshold-withholding-title">Why tax is withheld</p><p>Tax is withheld because no approved Sworn Declaration is on record.</p></div>
        </div>}
        {!withholdingOnly && !crossed && data.advisory && <p role="status" className="mp-threshold-advisory">80% of the threshold reached. The full crossing remittance will be subject to withholding.</p>}
      </div>
      <section className="mp-threshold-treatment" aria-label="Current withholding status">
        <h3>Withholding status</h3><WithholdingStatusBadge status={data.status} />
        <p>{statusExplanation[data.status] ?? 'Review the recorded withholding status for this taxable year.'}</p>
      </section>
    </div>
    {data.calculationBreakdown && <div className="mp-threshold-breakdown">
      <section className="mp-threshold-calculation" aria-label="On-platform threshold calculation">
        <header><h3>On-platform threshold calculation</h3><CalculationHelp title="On-platform threshold calculation"><p>Online payments - delivery - material VAT = tax basis. This is the amount used to calculate withholding tax. Discounts are already reflected in order amounts; Buyer-paid fees are excluded.</p><p>Sales returns and discounts, separately billed delivery and VAT are excluded under <a className="font-semibold text-action-primary underline" href="https://bir-cdn.bir.gov.ph/BIR/pdf/RR%20No.%2016-2023%203.pdf" target="_blank" rel="noreferrer">BIR RR No. 16-2023</a>.</p><p>These amounts were saved when tax was assessed. The retained-payment list below subtracts completed partial refunds and omits fully refunded payments. {withholdingOnly ? 'Later refunds do not rewrite posted tax assessments.' : 'Later refunds do not rewrite posted tax assessments or restore relief after an annual threshold crossing.'}</p></CalculationHelp></header>
        <p className="mp-threshold-scope">Tax basis is the amount from online payments used to calculate withholding tax. Buyer-paid fees are excluded.</p>
        <ThresholdBasisCalculation data={data} compact />
      </section>
    </div>}
    {paymentBreakdown && <div className="mp-threshold-payments">{paymentBreakdown}</div>}
  </section>
}

function Figure({ label, value, hint, accent = false, icon = <Banknote size={16} /> }: { label: string; value: string; hint?: string; accent?: boolean; icon?: ReactNode }) {
  return <KpiCard appearance="financial" density="compact" label={label} value={value} hint={hint} accent={accent} icon={icon} />
}

function SmallFigure({ label, value }: { label: string; value: string }) {
  return <div className="flex min-w-0 flex-wrap justify-between gap-x-3 gap-y-1"><dt className="text-text-secondary">{label}</dt><dd className="max-w-full font-semibold tabular-nums text-text-strong [overflow-wrap:anywhere]">{value}</dd></div>
}

const attemptStatus: Record<string, { label: string; tone: Tone; icon: typeof ShieldCheck }> = {
  PENDING: { label: 'Pending verification', tone: 'warning', icon: Clock },
  PAID: { label: 'Paid — verified by provider', tone: 'success', icon: BadgeCheck },
  FAILED: { label: 'Failed — not charged', tone: 'error', icon: XCircle },
  EXPIRED: { label: 'Expired — not charged', tone: 'neutral', icon: CircleDashed },
  CAPTURED_LATE_REFUND_PENDING: { label: 'Late capture — refund queued', tone: 'info', icon: History },
  // Cash on Delivery / In-Store obligations: a Vendor record, never provider verification.
  PHYSICAL_COLLECTED: { label: 'Collected — Vendor record', tone: 'success', icon: Banknote },
  PHYSICAL_PARTIAL: { label: 'Partially collected', tone: 'info', icon: Banknote },
  PHYSICAL_TO_RECORD: { label: 'Handed over — cash not recorded', tone: 'warning', icon: Clock },
  PHYSICAL_AWAITING: { label: 'Awaiting delivery or pickup', tone: 'neutral', icon: CircleDashed },
  PHYSICAL_RELEASED: { label: 'Not collected — order cancelled', tone: 'neutral', icon: CircleDashed },
}

const paidRefundStatus: Record<string, { label: string; tone: Tone; icon: typeof ShieldCheck }> = {
  REFUNDED: { label: 'Paid — refunded', tone: 'neutral', icon: History },
  PARTIALLY_REFUNDED: { label: 'Paid — partially refunded', tone: 'info', icon: History },
  REFUND_PENDING: { label: 'Paid — refund pending', tone: 'warning', icon: Clock },
  REFUND_FAILED: { label: 'Paid — refund failed', tone: 'error', icon: XCircle },
}

const lateRefundStatus: Record<string, { label: string; tone: Tone; icon: typeof ShieldCheck }> = {
  REFUNDED: { label: 'Late capture — refunded', tone: 'neutral', icon: History },
  REFUND_FAILED: { label: 'Late capture — refund failed', tone: 'error', icon: XCircle },
}

/** One payment attempt's status as text plus icon. Pending is never shown as success. */
export function PaymentAttemptBadge({ status, refundStatus }: { status: string; refundStatus?: string | undefined }) {
  const meta = (refundStatus ? (status === 'PAID' ? paidRefundStatus[refundStatus] : status === 'CAPTURED_LATE_REFUND_PENDING' ? lateRefundStatus[refundStatus] : undefined) : undefined)
    ?? attemptStatus[status] ?? attemptStatus.PENDING!
  const Icon = meta.icon
  return <StatusBadge label={meta.label} tone={meta.tone} icon={<Icon size={14} aria-hidden="true" />} />
}

export type PaymentChannelRow = { code: string; displayName: string; available: boolean; unavailableReason?: string | null | undefined; refundSupported: boolean; rateLabel: string; feeCentavos?: number | null | undefined; totalCentavos?: number | null | undefined }

const unavailableText: Record<string, string> = {
  REFUND_ROUTE_UNAVAILABLE: 'Not offered: no approved refund route', PROVIDER_NOT_CONFIGURED: 'Provider not configured',
  ADAPTER_UNSUPPORTED: 'Not supported by the provider configuration', BELOW_CHANNEL_MINIMUM: 'Below channel minimum', ABOVE_CHANNEL_MAXIMUM: 'Above channel maximum',
}

/** Configured online channels with their DEMO rate and availability reason; amounts show only when quoted. */
export function PaymentChannelList({ channels, caption, showAmounts = false, layout = 'compact' }: { channels: PaymentChannelRow[]; caption: string; showAmounts?: boolean; layout?: 'compact' | 'columns' | 'grid' }) {
  const columns = layout === 'columns'
  const rate = (channel: PaymentChannelRow) => channel.available ? `${channel.rateLabel} · DEMO rate` : (unavailableText[channel.unavailableReason ?? ''] ?? 'Unavailable')
  return <div className="min-w-0">
    {columns && <div aria-hidden="true" className="hidden grid-cols-[minmax(0,1fr)_minmax(0,1.5fr)_auto] gap-4 border-b border-border-default pb-3 text-xs font-semibold text-text-secondary md:grid"><span>Payment channel</span><span>Published DEMO rate</span><span>Availability</span></div>}
    <ul data-layout={layout} className={`mp-payment-channel-list grid ${layout === 'grid' ? '' : 'divide-y divide-border-default'} ${layout === 'compact' ? 'mp-card' : ''}`} aria-label={caption}>
    {channels.length === 0 && <li className="px-4 py-5 text-sm text-text-secondary">No online payment channels are configured.</li>}
    {channels.map(channel => <li key={channel.code} className={columns ? 'grid min-w-0 grid-cols-[minmax(0,1fr)_auto] items-start gap-x-4 gap-y-1 py-4 text-sm md:grid-cols-[minmax(0,1fr)_minmax(0,1.5fr)_auto]' : 'flex min-h-11 flex-wrap items-center justify-between gap-x-4 gap-y-1 px-4 py-2.5 text-sm'}>
      <span className="grid min-w-0 gap-0.5"><span className="font-semibold text-text-strong [overflow-wrap:anywhere]">{channel.displayName}</span>{!columns && <span className="text-xs text-text-secondary">{rate(channel)}</span>}</span>
      {columns && <span className="col-start-1 row-start-2 text-xs leading-5 text-text-secondary [overflow-wrap:anywhere] md:col-start-2 md:row-start-1">{rate(channel)}</span>}
      {channel.available
        ? <span className={`flex items-center gap-2 text-sm font-semibold text-green-800 ${columns ? 'col-start-2 row-start-1 md:col-start-3' : ''}`}><BadgeCheck className="shrink-0" size={16} aria-hidden="true" />{showAmounts && channel.totalCentavos !== null && channel.totalCentavos !== undefined ? `${formatPesoCentavos(channel.totalCentavos)} incl. ${formatPesoCentavos(channel.feeCentavos ?? 0)} fee` : 'Available'}</span>
        : <span className={`flex items-center gap-2 text-sm font-semibold text-text-secondary ${columns ? 'col-start-2 row-start-1 md:col-start-3' : ''}`}><XCircle className="shrink-0" size={16} aria-hidden="true" />Disabled</span>}
    </li>)}
    </ul>
  </div>
}

/** A titled section with a divider; split layout keeps settings context beside its details on wide screens. */
export function FinanceSection({ id, title, description, badge, icon, children, layout = 'stacked' }: { id: string; title: string; description?: string; badge?: ReactNode; icon?: ReactNode; children: ReactNode; layout?: 'stacked' | 'split' | 'compact' }) {
  const split = layout === 'split'
  return <section aria-labelledby={`${id}-heading`} className={`grid min-w-0 gap-5 border-t border-border-default pt-6 first:border-t-0 first:pt-0 ${split ? 'xl:grid-cols-[minmax(0,1fr)_minmax(0,2fr)] xl:gap-10 xl:pt-8' : ''} ${layout === 'compact' ? 'mp-finance-section-compact' : ''}`}>
    <div className={split ? (icon ? 'grid min-w-0 content-start grid-cols-[2.5rem_minmax(0,1fr)] gap-3' : 'min-w-0 space-y-3') : 'flex min-w-0 flex-wrap items-start justify-between gap-3'}>
      <div className={`flex min-w-0 max-w-3xl items-start gap-3 ${icon && split ? 'col-span-2' : ''}`}>
        {icon && <span aria-hidden="true" className="grid size-10 shrink-0 place-items-center rounded-control bg-surface-canvas text-text-secondary">{icon}</span>}
        <div className="min-w-0"><h2 id={`${id}-heading`} className="text-lg font-semibold leading-7 text-text-strong">{title}</h2>{description && <p className="mt-2 text-sm leading-6 text-text-secondary">{description}</p>}</div>
      </div>
      {badge && <div className={`min-w-0 max-w-full [&>span]:max-w-full [&>span]:whitespace-normal ${icon && split ? 'col-start-2' : ''}`}>{badge}</div>}
    </div>
    <div className="grid min-w-0 content-start gap-4">{children}</div>
  </section>
}

/** Readable finance facts with consistent spacing and wrapping for provider names and reconciliation times. */
export function FinanceDetails({ items, appearance = 'plain' }: { items: [string, ReactNode][]; appearance?: 'plain' | 'rows' | 'compact' }) {
  const rows = appearance === 'rows'
  return <dl className={`grid min-w-0 gap-x-8 gap-y-5 sm:grid-cols-2 ${appearance === 'compact' ? 'mp-finance-details-compact' : ''}`}>{items.map(([label, value]) => <div key={label} className={`min-w-0 space-y-2 ${rows ? 'border-b border-border-default pb-4' : ''}`}>
    <dt className={`text-xs text-text-secondary ${rows ? 'font-semibold' : 'font-medium'}`}>{label}</dt>
    <dd className="text-sm font-semibold leading-6 text-text-strong [overflow-wrap:anywhere]">{value}</dd>
  </div>)}</dl>
}
