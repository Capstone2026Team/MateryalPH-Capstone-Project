import {
  ALL_DATES, BarList, Button, ChartDataTable, ControlBar, DashboardPanel, DateFilter, FilterChips, KpiCard, MethodNote, ShareBar, StatusBadge, Toolbar, TrendLineChart,
  analyticsDay, formatChartDay, formatChartMonth, formatCompactCentavos, formatPesoCentavos,
} from '@materyalph/web-ui'
import { useState } from 'react'
import { Link } from 'react-router-dom'
import { Banknote, Landmark, Percent, ReceiptText, ShoppingCart, Store, Undo2, Wallet } from 'lucide-react'
import { Paged, Table } from '../components/OperationsKit'
import { financeKpis, remittanceQueue, type FinanceKpi, type FinanceKpis } from '../lib/finance-api'
import { label as humanize, useLoad, usePaged } from '../lib/operations-hooks'
import { ErrorState, LoadingState } from './PhaseThreeAdminPages'

/**
 * Platform Finance overview. Platform money (commission earned, its cash and its debt) and marketplace money (order
 * value, Buyer payments and refunds, which belong to Vendors and Buyers) are separate groups and never summed together.
 */
export function FinanceKpiPanel() {
  const [range, setRange] = useState(ALL_DATES)
  const kpis = useLoad(() => financeKpis(range.from, range.to), [range.from, range.to])
  return <section aria-label="Platform finance figures" className="grid min-w-0 gap-4">
    <ControlBar tabs={<h2 id="platform-money-heading" className="text-base font-semibold text-text-strong">Platform earnings and funds</h2>}
      actions={<DateFilter title="Transaction dates" value={range} onChange={setRange} />} />
    {kpis.error ? <ErrorState message={kpis.error} onRetry={kpis.retry} /> : !kpis.data ? <LoadingState /> : <FinanceOverview data={kpis.data} />}
  </section>
}

const minus = (centavos: number) => formatPesoCentavos(centavos === 0 ? 0 : -centavos)
const plural = (count: number, word: string) => `${count.toLocaleString('en-PH')} ${word}${count === 1 ? '' : 's'}`

function figureOf(items: FinanceKpi[]) {
  return (key: string) => items.find(item => item.key === key)?.valueCentavos ?? 0
}

function GroupHeading({ id, title, description }: { id: string; title: string; description?: string }) {
  return <div className="min-w-0 border-b border-border-default pb-2"><h2 id={id} className="text-base font-semibold text-text-strong">{title}</h2>{description && <p className="mt-0.5 text-sm text-text-secondary">{description}</p>}</div>
}

/** Action strip, the platform group with its chart, the marketplace group with its charts, then supporting records. */
function FinanceOverview({ data }: { data: FinanceKpis }) {
  const finance = figureOf(data.finance)
  const market = figureOf(data.commerce)
  const count = (key: string) => data.counts[key] ?? 0
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
  const pendingRefunds = market('pending_buyer_refunds')
  const otherRefunds = market('other_refunds')
  return <>
    {points.length === 0 && <p className="text-sm text-text-secondary">No financial activity is recorded for these dates.</p>}
    <FinanceAttention counts={data.counts} />

    <section aria-labelledby="platform-money-heading" className="grid min-w-0 gap-4">
      <dl aria-label="Platform earnings and funds" className="grid gap-4 md:grid-cols-2">
        <KpiCard label="Net platform earnings" value={formatPesoCentavos(finance('net_platform_earnings'))} icon={<Landmark size={16} aria-hidden="true" />} accent
          sparkline={points.map(point => point.netEarningsCentavos)}
          hint="Commission after approved credits and output VAT, less platform processing costs."
          breakdown={{ caption: 'Net platform earnings calculation', rows: [
            { key: 'commission', label: 'Net commission earned', amount: formatPesoCentavos(finance('net_commission')) },
            { key: 'vat', label: 'Output VAT on fees', amount: minus(finance('fee_vat')) },
            { key: 'revenue', label: 'Commission revenue, excluding VAT', amount: formatPesoCentavos(finance('platform_revenue')), total: true },
            { key: 'processing', label: 'Platform processing costs', amount: minus(finance('processing_expense')) },
            { key: 'total', label: 'Net platform earnings', amount: formatPesoCentavos(finance('net_platform_earnings')), total: true },
          ] }} />
        <KpiCard label="Net commission earned" value={formatPesoCentavos(finance('net_commission'))} icon={<Percent size={16} aria-hidden="true" />}
          sparkline={points.map(point => point.earnedCentavos - point.creditsCentavos)}
          hint="Each order’s saved rate on completed materials, excluding VAT, after approved credits."
          breakdown={{ caption: 'Net commission earned calculation', rows: [
            { key: 'earned', label: 'Commission earned at completion', amount: formatPesoCentavos(finance('earned_commission')) },
            { key: 'credits', label: 'Approved commission credits', amount: minus(finance('fee_credits')) },
            { key: 'total', label: 'Net commission earned', amount: formatPesoCentavos(finance('net_commission')), total: true },
          ] }} />
        <KpiCard label="Platform-held funds" value={formatPesoCentavos(finance('net_collected'))} icon={<Wallet size={16} aria-hidden="true" />}
          sparkline={points.map(point => point.collectedCentavos - point.refundedCentavos)}
          hint="Commission paid into the MateryalPH account, less commission refunds. Buyer payments never pass through it."
          breakdown={{ caption: 'Platform-held funds calculation', rows: [
            { key: 'collected', label: 'Commission payments collected', amount: formatPesoCentavos(finance('collected')) },
            { key: 'refunded', label: 'Commission refunds to Vendors', amount: minus(finance('refunded_commissions')) },
            { key: 'total', label: 'Platform-held funds', amount: formatPesoCentavos(finance('net_collected')), total: true },
          ] }} />
        <KpiCard label="Outstanding receivables" value={formatPesoCentavos(receivables)} icon={<ReceiptText size={16} aria-hidden="true" />}
          hint={`Issued commission bills not yet paid. ${formatPesoCentavos(finance('pending_commissions'))} is pending in total, including unbilled earnings and draft bills.`}
          breakdown={{ caption: 'Outstanding receivables calculation', rows: [
            { key: 'current', label: 'Issued, not yet due', amount: formatPesoCentavos(Math.max(0, receivables - overdue)) },
            { key: 'overdue', label: 'Overdue', amount: formatPesoCentavos(overdue) },
            { key: 'total', label: 'Outstanding receivables', amount: formatPesoCentavos(receivables), total: true },
          ] }} />
      </dl>
      <DashboardPanel title="Commission activity" description={`Commission earned each ${unit}, with commission cash collected, approved credits and confirmed commission refunds.`}>
        <div className="grid gap-4">
          <TrendLineChart title={`Commission earned, collected, credited and refunded per ${unit}`} labels={dates} formatLabel={formatLabel} formatValue={chartValue} emptyReason="No commission activity in this period." series={[
            { key: 'earned', label: 'Earned', colorVar: '--mp-viz-series-1', values: points.map(point => point.earnedCentavos), kind: 'bar' },
            { key: 'collected', label: 'Collected', colorVar: '--mp-viz-series-2', values: points.map(point => point.collectedCentavos) },
            { key: 'credits', label: 'Approved credits', colorVar: '--mp-viz-series-3', values: points.map(point => point.creditsCentavos) },
            { key: 'refunded', label: 'Commission refunds', colorVar: '--mp-viz-series-4', values: points.map(point => point.refundedCentavos) },
          ]} />
          <ChartDataTable caption={`${monthly ? 'Monthly' : 'Daily'} commission activity`} rowHeader={monthly ? 'Month' : 'Date'} rows={rows} columns={[
            column('Earned', points.map(point => point.earnedCentavos)), column('Approved credits', points.map(point => point.creditsCentavos)),
            column('Collected', points.map(point => point.collectedCentavos)), column('Commission refunds', points.map(point => point.refundedCentavos)), column('Net platform earnings', points.map(point => point.netEarningsCentavos))]} />
        </div>
      </DashboardPanel>
    </section>

    <section aria-labelledby="marketplace-money-heading" className="grid min-w-0 gap-4">
      <GroupHeading id="marketplace-money-heading" title="Marketplace payments" description="Money that belongs to Vendors and Buyers. Online payments settle to each Vendor’s own Xendit account and cash is kept by the Vendor; none of it is platform revenue." />
      <dl aria-label="Marketplace payments" className="grid gap-4 md:grid-cols-2">
        <KpiCard label="Gross merchandise value" value={formatPesoCentavos(market('gross_gmv'))} icon={<ShoppingCart size={16} aria-hidden="true" />}
          sparkline={points.map(point => point.gmvCentavos)}
          hint={`${plural(count('confirmed_orders'), 'confirmed order')}, by confirmation date, before cancellations and refunds.`}
          breakdown={{ caption: 'Gross merchandise value calculation', rows: [
            { key: 'gross', label: 'Gross merchandise value', amount: formatPesoCentavos(market('gross_gmv')) },
            { key: 'cancelled', label: 'Cancelled order value', amount: minus(market('cancelled_gmv')) },
            { key: 'refunded', label: 'Refunded order value', amount: minus(market('refunded_gmv')) },
            { key: 'total', label: 'Net merchandise value', amount: formatPesoCentavos(market('net_gmv')), total: true },
          ] }} />
        <KpiCard label="Buyer payments received" value={formatPesoCentavos(market('buyer_payments'))} icon={<Banknote size={16} aria-hidden="true" />}
          sparkline={points.map(point => point.buyerPaymentsCentavos)}
          hint={`Includes ${formatPesoCentavos(market('buyer_processing_fees'))} in Buyer processing fees, which cover the payment provider.`}
          breakdown={{ caption: 'Buyer payments received calculation', rows: [
            { key: 'online', label: 'Verified online payments', amount: formatPesoCentavos(market('online_payments')) },
            { key: 'cod', label: 'Cash on Delivery collected', amount: formatPesoCentavos(market('cash_on_delivery')) },
            { key: 'store', label: 'In-Store payments collected', amount: formatPesoCentavos(market('in_store')) },
            { key: 'total', label: 'Buyer payments received', amount: formatPesoCentavos(market('buyer_payments')), total: true },
          ] }} />
        <KpiCard label="Refunds to Buyers" value={formatPesoCentavos(market('buyer_refunds'))} icon={<Undo2 size={16} aria-hidden="true" />}
          sparkline={points.map(point => point.buyerRefundsCentavos)}
          hint={pendingRefunds > 0 ? `${formatPesoCentavos(pendingRefunds)} more in ${plural(count('pending_buyer_refunds'), 'refund')} still in progress.` : 'Confirmed refunds only. No refunds are in progress.'}
          breakdown={{ caption: 'Refunds to Buyers calculation', rows: [
            { key: 'cancellation', label: 'Cancellation refunds', amount: formatPesoCentavos(market('cancellation_refunds')) },
            { key: 'dispute', label: 'Dispute-conclusion refunds', amount: formatPesoCentavos(market('dispute_refunds')) },
            ...(otherRefunds > 0 ? [{ key: 'other', label: 'Other online refunds', amount: formatPesoCentavos(otherRefunds) }] : []),
            { key: 'cash', label: 'Cash reimbursements', amount: formatPesoCentavos(market('cash_reimbursements')) },
            { key: 'total', label: 'Refunds to Buyers', amount: formatPesoCentavos(market('buyer_refunds')), total: true },
          ] }} />
        <KpiCard label="Net Vendor collections" value={formatPesoCentavos(market('net_buyer_payments'))} icon={<Store size={16} aria-hidden="true" />}
          sparkline={points.map(point => point.buyerPaymentsCentavos - point.buyerRefundsCentavos)}
          hint="What Vendors kept from Buyer payments after refunds, before their own commission bills."
          breakdown={{ caption: 'Net Vendor collections calculation', rows: [
            { key: 'received', label: 'Buyer payments received', amount: formatPesoCentavos(market('buyer_payments')) },
            { key: 'refunds', label: 'Refunds to Buyers', amount: minus(market('buyer_refunds')) },
            { key: 'total', label: 'Net Vendor collections', amount: formatPesoCentavos(market('net_buyer_payments')), total: true },
          ] }} />
      </dl>
      <div className="grid min-w-0 gap-4 xl:grid-cols-3">
        <div className="min-w-0 xl:col-span-2"><DashboardPanel title="Marketplace volume" description={`Order value confirmed each ${unit}, with Buyer payments received and refunds returned.`}>
          <div className="grid gap-4">
            <TrendLineChart title={`Gross merchandise value, Buyer payments and refunds per ${unit}`} labels={dates} formatLabel={formatLabel} formatValue={chartValue} emptyReason="No marketplace activity in this period." series={[
              { key: 'gmv', label: 'Gross merchandise value', colorVar: '--mp-viz-series-1', values: points.map(point => point.gmvCentavos), kind: 'bar' },
              { key: 'payments', label: 'Buyer payments', colorVar: '--mp-viz-series-2', values: points.map(point => point.buyerPaymentsCentavos) },
              { key: 'refunds', label: 'Refunds to Buyers', colorVar: '--mp-viz-series-4', values: points.map(point => point.buyerRefundsCentavos) },
            ]} />
            <ChartDataTable caption={`${monthly ? 'Monthly' : 'Daily'} marketplace volume`} rowHeader={monthly ? 'Month' : 'Date'} rows={rows} columns={[
              column('Gross merchandise value', points.map(point => point.gmvCentavos)), column('Buyer payments', points.map(point => point.buyerPaymentsCentavos)), column('Refunds to Buyers', points.map(point => point.buyerRefundsCentavos))]} />
          </div>
        </DashboardPanel></div>
        <PaymentMethods methods={data.paymentMethods ?? []} />
      </div>
    </section>

    <DashboardPanel title="Billing and tax records" description="Kept apart from earnings: output VAT is owed on commission, and CWT is the Vendors’ simulated withholding.">
      <dl className="grid gap-3 sm:grid-cols-2 xl:grid-cols-4">
        {[['billed', 'Issued commission bills'], ['fee_vat', 'Output VAT on fees'], ['assessed_cwt', 'Assessed CWT (simulated)'], ['reported_deductions', 'Provider-reported deductions']].map(([key = '', label]) =>
          <div key={key} className="min-w-0 rounded-control bg-surface-canvas px-4 py-3"><dt className="text-xs font-semibold text-text-secondary">{label}</dt><dd className="mt-1 break-words text-lg font-semibold tabular-nums text-text-strong">{formatPesoCentavos(finance(key))}</dd></div>)}
      </dl>
    </DashboardPanel>

    <MethodNote label="What every figure means">
      <p className="mb-2">{data.scenario}</p>
      {points.length > 0 && <p className="mb-4">{`Charted by ${unit} · ${formatLabel(dates[0] ?? '')}${points.length > 1 ? ` – ${formatLabel(dates.at(-1) ?? '')}` : ''} (Asia/Manila)`}</p>}
      <div className="grid gap-4 md:grid-cols-2">{[['Platform figures', data.finance], ['Marketplace figures', data.commerce]].map(([title, items]) => <div key={String(title)} className="min-w-0">
        <p className="font-semibold text-text-strong">{String(title)}</p>
        <dl className="mt-2 grid gap-2">{(items as FinanceKpi[]).map(item => <div key={item.key}><dt className="font-semibold text-text-strong">{item.label}</dt><dd>{item.definition}</dd></div>)}</dl>
      </div>)}</div>
    </MethodNote>
  </>
}

/** Buyer payments by method: online against cash, then each channel. Each row prints its amount and count. */
function PaymentMethods({ methods }: { methods: NonNullable<FinanceKpis['paymentMethods']> }) {
  const total = methods.reduce((sum, method) => sum + method.amountCentavos, 0)
  const sum = (kind: string) => methods.filter(method => method.kind === kind).reduce((value, method) => value + method.amountCentavos, 0)
  const share = (value: number) => total === 0 ? '' : ` · ${((value / total) * 100).toFixed(1)}%`
  return <DashboardPanel title="Buyer payments by method" description="Verified online channels and recorded cash, by payment or record date.">
    <div className="grid gap-5">
      <ShareBar label="Buyer payments, online and cash" formatValue={value => formatCompactCentavos(value)} empty="No Buyer payments in this period." segments={[
        { key: 'online', label: 'Online', value: sum('ONLINE'), colorVar: '--mp-viz-series-2' },
        { key: 'cash', label: 'Cash', value: sum('PHYSICAL'), colorVar: '--mp-viz-series-5' },
      ]} />
      {methods.length > 0 && <BarList label="Buyer payments per method" colorVar="--mp-viz-series-2" empty="No Buyer payments in this period." items={methods.map(method => ({
        key: method.method, label: method.label, value: method.amountCentavos, display: formatPesoCentavos(method.amountCentavos),
        detail: `${plural(method.payments, method.kind === 'PHYSICAL' ? 'cash record' : 'payment')}${share(method.amountCentavos)}`,
      }))} />}
    </div>
  </DashboardPanel>
}

/** Finance work waiting on an Admin. Each item links to its queue; an empty queue needs no action strip. */
function FinanceAttention({ counts }: { counts: Record<string, number> }) {
  const items = [
    { key: 'open_work_items', label: 'Finance work items', href: '/finance?view=queue' },
    { key: 'unreconciled_remittances', label: 'Unreconciled remittances', href: '/finance?view=remittances' },
    { key: 'draft_statements', label: 'Draft commission statements', href: '/finance?view=statements' },
    { key: 'pending_commission_credits', label: 'Commission credits awaiting approval', href: '/finance?view=statements' },
    { key: 'overdue_statements', label: 'Overdue commission bills', href: '/finance?view=overdue' },
  ].map(item => ({ ...item, value: counts[item.key] ?? 0 })).filter(item => item.value > 0)
  if (items.length === 0) return null
  return <section aria-labelledby="finance-attention-heading" className="flex min-w-0 flex-wrap items-center gap-x-4 gap-y-2 rounded-surface border border-border-default bg-surface-primary px-4 py-3">
    <h3 id="finance-attention-heading" className="text-sm font-semibold text-text-strong">Finance actions</h3>
    <ul className="flex min-w-0 flex-wrap gap-2">{items.map(item => <li key={item.key}><Link className="inline-flex min-h-11 items-center gap-2 rounded-control border border-border-default px-3 text-sm font-semibold text-text-strong hover:bg-surface-canvas focus-visible:outline-2 focus-visible:outline-focus-ring" to={item.href}>
      <StatusBadge tone="warning" label={String(item.value)} />{item.label}</Link></li>)}</ul>
  </section>
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
