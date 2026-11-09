import { Banknote, RefreshCw, ShoppingCart, Store, Undo2 } from 'lucide-react'
import {
  AnalyticsChartCard, AnalyticsSummary, BarList, Button, ChartDataTable, ControlBar, DashboardPanel, DateFilter,
  FinanceBreakdownPanel, ShareBar, TrendLineChart, analyticsDay, formatChartDay, formatChartMonth,
  formatCompactCentavos, formatPesoCentavos, type DateFilterRange,
} from '@materyalph/web-ui'
import { financeKpis, type FinanceKpis } from '../lib/finance-api'
import { useAnalyticsResource } from '../lib/use-analytics-resource'
import { ErrorState, LoadingState } from './PhaseThreeAdminPages'

const minus = (amount: number) => formatPesoCentavos(amount === 0 ? 0 : -amount)
const plural = (count: number, word: string) => `${count.toLocaleString('en-PH')} ${word}${count === 1 ? '' : 's'}`

/** Existing finance authorization and nationwide event-date projection; never represented as a geographic query. */
export function MarketplacePaymentAnalytics({ range, onRangeChange }: { range: DateFilterRange; onRangeChange: (range: DateFilterRange) => void }) {
  const payments = useAnalyticsResource(`marketplace-payments-${range.from}-${range.to}`, () => financeKpis(range.from, range.to, { localForbidden: true }))
  return <section aria-label="Marketplace payment analytics" className="mp-analytics mp-analytics-main">
    <ControlBar tabs={<p className="text-xs text-text-secondary">Philippines-wide · Payment and refund dates · Asia/Manila</p>}
      actions={<><DateFilter title="Marketplace payment dates" value={range} onChange={onRangeChange} allowAllDates={false} allowOpenEnded={false} maxRangeDays={366} /><Button variant="secondary" disabled={payments.loading} onClick={payments.retry}><RefreshCw size={16} aria-hidden="true" />Refresh payments</Button></>} />
    <p className="text-xs leading-5 text-text-secondary">Buyer payments belong to Vendors. Online payments settle to each Vendor’s Xendit account; cash stays with the Vendor. These totals cover all areas and are separate from platform commission revenue.</p>
    {payments.error ? <ErrorState message={payments.error} onRetry={payments.retry} /> : !payments.data ? <LoadingState /> : <MarketplacePaymentFigures data={payments.data} />}
  </section>
}

function MarketplacePaymentFigures({ data }: { data: FinanceKpis }) {
  const value = (key: string) => data.commerce.find(item => item.key === key)?.valueCentavos ?? 0
  const definition = (key: string) => <p>{data.commerce.find(item => item.key === key)?.definition ?? 'Recorded marketplace transactions for the selected dates.'}</p>
  const points = data.trend ?? []
  const monthly = data.trendGranularity !== 'DAY'
  const unit = monthly ? 'month' : 'day'
  const dates = points.map(point => analyticsDay(point.period) ?? '')
  const formatLabel = monthly ? formatChartMonth : formatChartDay
  const pending = value('pending_buyer_refunds')
  const other = value('other_refunds')
  const methods = data.paymentMethods ?? []
  const total = methods.reduce((sum, method) => sum + method.amountCentavos, 0)
  const byKind = (kind: string) => methods.filter(method => method.kind === kind).reduce((sum, method) => sum + method.amountCentavos, 0)
  return <>
    <AnalyticsSummary density="compact" title="Marketplace payments" featured={{ label: 'Gross sales', value: formatPesoCentavos(value('gross_gmv')), icon: <ShoppingCart size={17} />, calculation: definition('gross_gmv'), hint: 'Confirmed order value' }} metrics={[
      { label: 'Buyer payments received', value: formatPesoCentavos(value('buyer_payments')), icon: <Banknote size={17} />, calculation: definition('buyer_payments'), hint: 'Verified online and recorded cash' },
      { label: 'Refunds to Buyers', value: formatPesoCentavos(value('buyer_refunds')), icon: <Undo2 size={17} />, calculation: definition('buyer_refunds'), hint: 'Confirmed refunds only' },
      { label: 'Net Vendor collections', value: formatPesoCentavos(value('net_buyer_payments')), icon: <Store size={17} />, calculation: definition('net_buyer_payments'), hint: 'Buyer payments after refunds' },
    ]} />
    <div className="grid min-w-0 gap-3 xl:grid-cols-[minmax(0,1.7fr)_minmax(0,1fr)]">
      <AnalyticsChartCard title="Marketplace volume" description={`Confirmed sales, payments received and refunds returned per ${unit}.`}
        calculation={<p>Sales use order confirmation dates. Payments use verified capture or cash-record dates; refunds use their successful refund or reimbursement dates. Each event is counted once.</p>}>
        <TrendLineChart variant="area" title={`Gross sales, Buyer payments and refunds per ${unit}`} labels={dates} formatLabel={formatLabel}
          formatValue={amount => formatCompactCentavos(Math.round(amount))} formatTooltipValue={amount => formatPesoCentavos(Math.round(amount))}
          emptyReason="No marketplace activity in this period." series={[
            { key: 'sales', label: 'Gross sales', colorVar: '--mp-viz-series-1', values: points.map(point => point.gmvCentavos), kind: 'bar' },
            { key: 'payments', label: 'Buyer payments', colorVar: '--mp-viz-series-2', values: points.map(point => point.buyerPaymentsCentavos) },
            { key: 'refunds', label: 'Refunds to Buyers', colorVar: '--mp-viz-series-4', values: points.map(point => point.buyerRefundsCentavos) },
          ]} />
        <ChartDataTable caption={`${monthly ? 'Monthly' : 'Daily'} marketplace volume`} rowHeader={monthly ? 'Month' : 'Date'} rows={dates.map(formatLabel)} columns={[
          { key: 'sales', header: 'Gross sales', values: points.map(point => formatPesoCentavos(point.gmvCentavos)) },
          { key: 'payments', header: 'Buyer payments', values: points.map(point => formatPesoCentavos(point.buyerPaymentsCentavos)) },
          { key: 'refunds', header: 'Refunds to Buyers', values: points.map(point => formatPesoCentavos(point.buyerRefundsCentavos)) },
        ]} />
      </AnalyticsChartCard>
      <DashboardPanel density="compact" title="Buyer payments by method" description="Verified online channels and recorded cash, by payment or record date.">
        <div className="grid gap-4">
          <ShareBar label="Buyer payments, online and cash" empty="No Buyer payments in this period." formatValue={formatCompactCentavos} segments={[
            { key: 'online', label: 'Online', value: byKind('ONLINE'), colorVar: '--mp-viz-series-2' },
            { key: 'cash', label: 'Cash', value: byKind('PHYSICAL'), colorVar: '--mp-viz-series-5' },
          ]} />
          {methods.length > 0 && <BarList label="Buyer payments per method" colorVar="--mp-viz-series-2" empty="No Buyer payments in this period." items={methods.map(method => ({
            key: method.method, label: method.label, value: method.amountCentavos, display: formatPesoCentavos(method.amountCentavos),
            detail: `${plural(method.payments, method.kind === 'PHYSICAL' ? 'cash record' : 'payment')}${total > 0 ? ` · ${(method.amountCentavos / total * 100).toFixed(1)}%` : ''}`,
          }))} />}
        </div>
      </DashboardPanel>
    </div>
    <DashboardPanel density="compact" title="Payment calculations" description="Recorded components behind the totals. Sales and collections use separate event dates.">
      <div className="grid min-w-0 gap-5 lg:grid-cols-2">
        <FinanceBreakdownPanel title="Gross sales" caption="Gross sales calculation" hint={`${plural(data.counts.confirmed_orders ?? 0, 'confirmed order')}, by confirmation date, before cancellations and refunds.`} rows={[
          { key: 'gross', label: 'Gross sales', amount: formatPesoCentavos(value('gross_gmv')) },
          { key: 'cancelled', label: 'Cancelled order value', amount: minus(value('cancelled_gmv')) },
          { key: 'refunded', label: 'Refunded order value', amount: minus(value('refunded_gmv')) },
          { key: 'net', label: 'Net sales', amount: formatPesoCentavos(value('net_gmv')), total: true },
        ]} />
        <FinanceBreakdownPanel title="Buyer payments received" caption="Buyer payments received calculation" hint={`Includes ${formatPesoCentavos(value('buyer_processing_fees'))} in Buyer-paid processing fees.`} rows={[
          { key: 'online', label: 'Verified online payments', amount: formatPesoCentavos(value('online_payments')) },
          { key: 'cod', label: 'Cash on Delivery collected', amount: formatPesoCentavos(value('cash_on_delivery')) },
          { key: 'store', label: 'In-Store payments collected', amount: formatPesoCentavos(value('in_store')) },
          { key: 'total', label: 'Buyer payments received', amount: formatPesoCentavos(value('buyer_payments')), total: true },
        ]} />
        <FinanceBreakdownPanel title="Refunds to Buyers" caption="Refunds to Buyers calculation" hint={pending > 0 ? `${formatPesoCentavos(pending)} more in ${plural(data.counts.pending_buyer_refunds ?? 0, 'refund')} still in progress.` : 'Confirmed refunds only. No refunds are in progress.'} rows={[
          { key: 'cancellation', label: 'Cancellation refunds', amount: formatPesoCentavos(value('cancellation_refunds')) },
          { key: 'dispute', label: 'Dispute-conclusion refunds', amount: formatPesoCentavos(value('dispute_refunds')) },
          ...(other > 0 ? [{ key: 'other', label: 'Other online refunds', amount: formatPesoCentavos(other) }] : []),
          { key: 'cash', label: 'Cash reimbursements', amount: formatPesoCentavos(value('cash_reimbursements')) },
          { key: 'total', label: 'Refunds to Buyers', amount: formatPesoCentavos(value('buyer_refunds')), total: true },
        ]} />
        <FinanceBreakdownPanel title="Net Vendor collections" caption="Net Vendor collections calculation" hint="What Vendors kept after refunds, before their commission bills." rows={[
          { key: 'received', label: 'Buyer payments received', amount: formatPesoCentavos(value('buyer_payments')) },
          { key: 'refunds', label: 'Refunds to Buyers', amount: minus(value('buyer_refunds')) },
          { key: 'net', label: 'Net Vendor collections', amount: formatPesoCentavos(value('net_buyer_payments')), total: true },
        ]} />
      </div>
    </DashboardPanel>
  </>
}
