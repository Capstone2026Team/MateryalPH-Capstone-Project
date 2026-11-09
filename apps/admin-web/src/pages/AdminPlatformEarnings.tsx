import { AsyncLoading } from '@materyalph/web-ui'
import {
  AnalyticsChartCard, Button, ChartDataTable, DashboardPanel, KpiBreakdown, StatusMessage, TrendLineChart,
  analyticsDay, formatChartDay, formatChartMonth, formatCompactCentavos, formatDeductionCentavos, formatPesoCentavos,
} from '@materyalph/web-ui'
import type { FinanceKpis } from '../lib/finance-api'
import type { AdminPlatformEarningsResource } from '../lib/use-admin-platform-earnings'

const refundAmount = (centavos: number | null) => centavos === 0 ? formatPesoCentavos(0) : formatDeductionCentavos(centavos)

/** Finance is independently authorized; missing finance.view must not clear the operational dashboard. */
export function AdminPlatformEarnings({ resource: { data, error, refresh, denied, message } }: { resource: AdminPlatformEarningsResource }) {
  if (!data) return <DashboardPanel wide density="compact" title="Platform earnings" description="Vendor commission payments and confirmed refunds.">
    {denied ? <p className="text-sm text-text-secondary">Platform earnings is outside your role scope. Finance access is required.</p>
      : error ? <div className="grid gap-3"><StatusMessage tone="error">{message ?? 'Platform earnings could not be loaded.'}</StatusMessage><Button variant="secondary" className="w-fit" onClick={() => void refresh()}>Retry platform earnings</Button></div>
        : <AsyncLoading compact label="Loading platform earnings…" />}
  </DashboardPanel>
  return <PlatformEarningsChart data={data} />
}

/** A paid-commission view, using the same allocated collections and successful fee refunds as Finance. */
export function PlatformEarningsChart({ data }: { data: FinanceKpis }) {
  const amount = (key: string) => data.finance.find(item => item.key === key)?.valueCentavos ?? null
  const points = data.trend ?? []
  const labels = points.map(point => analyticsDay(point.period) ?? '')
  const monthly = data.trendGranularity === 'MONTH'
  const unit = monthly ? 'month' : 'day'
  const formatLabel = monthly ? formatChartMonth : formatChartDay
  const collected = amount('collected')
  const refunded = amount('refunded_commissions')
  const net = amount('net_collected')
  return <AnalyticsChartCard wide title="Platform earnings" description={`${monthly ? 'Monthly' : 'Daily'} Vendor commission payments and confirmed refunds · TEST.`} calculation={<>
    <KpiBreakdown caption="Collected commission calculation" rows={[
      { key: 'collected', label: 'Commission payments', amount: formatPesoCentavos(collected) },
      { key: 'refunds', label: 'Commission refunds', amount: refundAmount(refunded) },
      { key: 'net', label: 'Net collected commissions', amount: formatPesoCentavos(net), total: true },
    ]} />
    <p><strong>Net collected commissions</strong> = verified Vendor commission payments allocated to monthly bills − confirmed commission refunds to Vendors. Partial statement payments count only for the amount actually allocated. Unpaid bills, pending or failed payments, late captures and unallocated overpayments are excluded.</p>
    <p>Payments use their collection date; refunds use their successful refund date, in Asia/Manila. A refund in this period can relate to a payment from an earlier period. Refund bars show the deduction amount, and the table shows the resulting signed net collection for each {unit}.</p>
    <p>This is a commission collections view. Collected amounts include any applicable fee VAT and are before platform processing costs; they are separate from Finance’s earned commission revenue and Net platform earnings. Payment collection never earns the same fee again. Buyer sales, E-wallet transaction fees and creditable withholding tax are excluded.</p>
    <p>Commission bills retain each order’s saved rate on completed materials after discounts, excluding materials VAT. No rate is applied again to marketplace sales for this chart.</p>
  </>}>
    <TrendLineChart variant="bar" title={`Commission payments and refunds per ${unit}`} labels={labels} formatLabel={formatLabel}
      formatValue={value => formatCompactCentavos(Math.round(value))} formatTooltipValue={value => formatPesoCentavos(Math.round(value))} emptyReason="No commission payments or refunds in this period."
      overview={{ label: 'Net collected commissions', value: formatPesoCentavos(net), context: 'Selected period commission totals', seriesValues: [formatPesoCentavos(collected), refundAmount(refunded)] }}
      series={[
        { key: 'collected', label: 'Commission payments', colorVar: '--mp-viz-series-1', values: points.map(point => point.collectedCentavos) },
        { key: 'refunds', label: 'Commission refunds', colorVar: '--mp-viz-series-2', values: points.map(point => point.refundedCentavos), formatValue: value => refundAmount(Math.round(value)) },
      ]} />
    <ChartDataTable caption={`Commission payments per ${unit}`} rowHeader={monthly ? 'Month' : 'Date'} rows={labels.map(formatLabel)} columns={[
      { key: 'collected', header: 'Commission payments', values: points.map(point => formatPesoCentavos(point.collectedCentavos)) },
      { key: 'refunds', header: 'Commission refunds', values: points.map(point => refundAmount(point.refundedCentavos)) },
      { key: 'net', header: 'Net collected commissions', values: points.map(point => formatPesoCentavos(point.collectedCentavos - point.refundedCentavos)) },
    ]} />
  </AnalyticsChartCard>
}
