import type { ReactNode } from 'react'
import { AlertTriangle, CheckCircle2, ClipboardCheck, Clock3, MessageSquareText, Package, PackageCheck, ShoppingBag, Timer, Truck } from 'lucide-react'
import type { VendorTeamPerformance, VendorTeamReplyTime } from '@materyalph/api-client-ts'
import { ChartDataTable, KpiCard, MethodNote, formatChartDay, formatChartMonth, formatCount, formatDurationSeconds } from './chart-patterns'
import { DashboardPanel } from './dashboard-patterns'
import { TrendLineChart } from './geo-analytics-patterns'
import { formatPesoCentavos } from './order-patterns'

type Kpi = { key: string; label: string; value: ReactNode; hint: string; icon: ReactNode }
type Row = { label: string; value: string; hidden?: boolean }

const icon = (Icon: typeof Clock3) => <Icon size={16} aria-hidden="true" />
const count = (value: number) => formatCount(value)
const rate = (part: number, whole: number) => whole > 0 ? `${Math.round((part / whole) * 100)}%` : '—'
const replyHint = (reply: VendorTeamReplyTime) => reply.measured > 0 ? `Median ${formatDurationSeconds(reply.medianSeconds)} · ${count(reply.measured)} ${reply.measured === 1 ? 'reply' : 'replies'} measured` : 'No Buyer message answered in this period'

const trendTitles: Record<string, { title: string; unit: string; empty: string }> = {
  SALES: { title: 'Confirmed sales', unit: 'sales', empty: 'No attributed sale was confirmed in this period.' },
  INVENTORY_UPDATES: { title: 'Product and stock updates', unit: 'updates', empty: 'No product or stock update was recorded in this period.' },
  HANDOVERS: { title: 'Completed handovers', unit: 'handovers', empty: 'No delivery or pickup handover was recorded in this period.' },
  ACTIONS: { title: 'Recorded actions', unit: 'actions', empty: 'No action was recorded in this period.' },
}

/** The headline figures a role is measured by; every other figure sits in the breakdown cards below. */
function headline(data: VendorTeamPerformance): Kpi[] {
  const { sales, orders, quotations, inventory, fulfillment } = data
  const salesCard = (): Kpi | null => sales ? { key: 'sales', label: 'Confirmed sales', value: count(sales.orders), hint: `${count(sales.completed)} completed · ${count(sales.cancelled)} cancelled after confirmation`, icon: icon(ShoppingBag) } : null
  const valueCard = (): Kpi | null => sales && data.salesValueVisible ? { key: 'value', label: 'Sales value', value: formatPesoCentavos(sales.valueCentavos ?? 0), hint: 'Materials payable of attributed sales', icon: icon(ShoppingBag) } : null
  const replyCard = (reply: VendorTeamReplyTime, label = 'Average reply time'): Kpi => ({ key: `reply-${label}`, label, value: formatDurationSeconds(reply.averageSeconds), hint: replyHint(reply), icon: icon(Timer) })
  const cards: (Kpi | null)[] = (() => {
    switch (data.role) {
      case 'CUSTOMER_SERVICE':
        return [salesCard(), valueCard() ?? (sales ? { key: 'conversations', label: 'Conversations handled', value: count(sales.conversations), hint: `${count(sales.messages)} messages sent`, icon: icon(MessageSquareText) } : null),
          sales ? replyCard(sales.reply) : null, sales ? { key: 'awaiting', label: 'Awaiting your reply', value: count(sales.awaitingReply), hint: 'Buyers waiting now in conversations this member handles', icon: icon(Clock3) } : null]
      case 'STORE_STAFF':
        return [salesCard(), valueCard() ?? (quotations ? { key: 'published', label: 'Quotations published', value: count(quotations.published), hint: `${count(quotations.accepted)} accepted by Buyers`, icon: icon(ClipboardCheck) } : null),
          sales ? replyCard(sales.reply) : null, orders ? { key: 'confirmed', label: 'Orders confirmed', value: count(orders.confirmed + orders.revised), hint: `${count(orders.revised)} with changes · ${count(orders.declined)} declined`, icon: icon(CheckCircle2) } : null]
      case 'INVENTORY':
        return inventory ? [
          { key: 'stock', label: 'Stock updates', value: count(inventory.stockUpdates), hint: `${count(inventory.stockConfirmations)} stock confirmations`, icon: icon(Package) },
          { key: 'listings', label: 'Listing changes', value: count(inventory.listingUpdates + inventory.listingsCreated), hint: `${count(inventory.listingsCreated)} new listings`, icon: icon(ClipboardCheck) },
          { key: 'compliance', label: 'Compliance submissions', value: count(inventory.complianceSubmissions), hint: 'PS/ICC evidence sent for review', icon: icon(CheckCircle2) },
          { key: 'unsuccessful', label: 'Unsuccessful attempts', value: count(inventory.unsuccessful), hint: 'Rejected product or stock changes', icon: icon(AlertTriangle) },
        ] : []
      case 'FULFILLMENT':
        return fulfillment ? [
          { key: 'handovers', label: 'Completed handovers', value: count(fulfillment.handovers), hint: `${count(fulfillment.milestones)} milestones recorded`, icon: icon(PackageCheck) },
          { key: 'on-time', label: 'On-time handovers', value: rate(fulfillment.onTime, fulfillment.onTimeMeasured), hint: `${count(fulfillment.onTime)} of ${count(fulfillment.onTimeMeasured)} on or before the promised date`, icon: icon(Clock3) },
          { key: 'active', label: 'Orders in progress', value: count(fulfillment.active), hint: `${count(fulfillment.assigned)} assigned in this period`, icon: icon(Truck) },
          replyCard(fulfillment.reply, 'Fulfillment chat reply time'),
        ] : []
      default:
        return [salesCard(), valueCard() ?? (orders ? { key: 'confirmed', label: 'Orders confirmed', value: count(orders.confirmed + orders.revised), hint: `${count(orders.declined)} declined`, icon: icon(CheckCircle2) } : null),
          fulfillment ? { key: 'handovers', label: 'Completed handovers', value: count(fulfillment.handovers), hint: `${rate(fulfillment.onTime, fulfillment.onTimeMeasured)} on time`, icon: icon(PackageCheck) } : null,
          inventory ? { key: 'stock', label: 'Stock updates', value: count(inventory.stockUpdates), hint: `${count(inventory.listingUpdates + inventory.listingsCreated)} listing changes`, icon: icon(Package) } : null]
    }
  })()
  return cards.filter((card): card is Kpi => card !== null)
}

function StatRows({ rows }: { rows: Row[] }) {
  return <dl className="divide-y divide-border-default">{rows.filter(row => !row.hidden).map(row => <div key={row.label} className="flex items-baseline justify-between gap-4 py-2.5 text-sm first:pt-0 last:pb-0">
    <dt className="min-w-0 text-text-secondary">{row.label}</dt><dd className="shrink-0 font-semibold tabular-nums text-text-strong">{row.value}</dd>
  </div>)}</dl>
}

function breakdown(data: VendorTeamPerformance): { title: string; description: string; rows: Row[] }[] {
  const { sales, quotations, orders, disputes, inventory, fulfillment } = data
  const publishes = data.role !== 'CUSTOMER_SERVICE'
  return [
    sales && { title: 'Sales and conversations', description: 'Sales follow the inquiry handler or the person who confirmed the order.', rows: [
      { label: 'Confirmed sales', value: count(sales.orders) }, { label: 'Completed', value: count(sales.completed) }, { label: 'Cancelled after confirmation', value: count(sales.cancelled) },
      { label: 'Sales value', value: formatPesoCentavos(sales.valueCentavos ?? 0), hidden: !data.salesValueVisible },
      { label: 'Conversations handled', value: count(sales.conversations) }, { label: 'Messages sent', value: count(sales.messages) }, { label: 'Buyers awaiting a reply now', value: count(sales.awaitingReply) },
      { label: 'Average reply time', value: formatDurationSeconds(sales.reply.averageSeconds) }, { label: 'Median reply time', value: formatDurationSeconds(sales.reply.medianSeconds) },
    ] },
    quotations && { title: 'Quotations', description: publishes ? 'Drafts prepared, terms published and quotations Buyers accepted.' : 'Customer Service prepares drafts; publishing stays with authorized roles.', rows: [
      { label: 'Drafts prepared', value: count(quotations.drafts) }, { label: 'Published', value: count(quotations.published), hidden: !publishes }, { label: 'Accepted by Buyers', value: count(quotations.accepted), hidden: !publishes },
    ] },
    orders && { title: 'Order confirmations', description: 'Manual decisions on orders awaiting the store.', rows: [
      { label: 'Confirmed as ordered', value: count(orders.confirmed) }, { label: 'Confirmed with changes', value: count(orders.revised) }, { label: 'Declined', value: count(orders.declined) },
    ] },
    disputes && { title: 'Disputes', description: 'Cases this member handles for the store.', rows: [
      { label: 'Cases handled', value: count(disputes.handled) }, { label: 'Resolved or closed', value: count(disputes.resolved) }, { label: 'Open now', value: count(disputes.open) },
    ] },
    inventory && { title: 'Products and inventory', description: 'Successful catalog, stock and compliance changes.', rows: [
      { label: 'Stock updates', value: count(inventory.stockUpdates) }, { label: 'Stock confirmations', value: count(inventory.stockConfirmations) }, { label: 'New listings', value: count(inventory.listingsCreated) },
      { label: 'Listing changes', value: count(inventory.listingUpdates) }, { label: 'Compliance submissions', value: count(inventory.complianceSubmissions) }, { label: 'Auto-accept allotment changes', value: count(inventory.allotmentUpdates) },
      { label: 'Unsuccessful attempts', value: count(inventory.unsuccessful) },
    ] },
    fulfillment && { title: 'Fulfillment', description: 'Assigned orders, recorded milestones and the order fulfillment chat.', rows: [
      { label: 'Orders assigned', value: count(fulfillment.assigned) }, { label: 'Orders in progress now', value: count(fulfillment.active) }, { label: 'Completed handovers', value: count(fulfillment.handovers) },
      { label: 'On time', value: `${count(fulfillment.onTime)} of ${count(fulfillment.onTimeMeasured)}` }, { label: 'Milestones recorded', value: count(fulfillment.milestones) }, { label: 'Proofs recorded', value: count(fulfillment.proofs) },
      { label: 'Vehicle issues reported', value: count(fulfillment.vehicleIssues) }, { label: 'Messages sent', value: count(fulfillment.messages) }, { label: 'Buyers awaiting a reply now', value: count(fulfillment.awaitingReply) },
      { label: 'Average reply time', value: formatDurationSeconds(fulfillment.reply.averageSeconds) },
    ] },
  ].filter((card): card is { title: string; description: string; rows: Row[] } => Boolean(card))
}

/** Role-based Team Tracking statistics for one member: headline figures, the role's trend and a breakdown by work area. */
export function TeamPerformanceStatistics({ data }: { data: VendorTeamPerformance }) {
  const trend = trendTitles[data.trend.metric] ?? trendTitles.ACTIONS!
  const monthly = data.trend.granularity === 'MONTH'
  const labels = data.trend.points.map(point => point.date)
  const values = data.trend.points.map(point => point.value)
  const formatLabel = monthly ? formatChartMonth : formatChartDay
  const cards = breakdown(data)
  return <div className="grid gap-5">
    <dl className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">{headline(data).map((card, index) => <KpiCard key={card.key} label={card.label} value={card.value} hint={card.hint} icon={card.icon} accent={index === 0} />)}</dl>
    <DashboardPanel title={trend.title} description={`${monthly ? 'By month' : 'By day'}, ${formatChartDay(data.trend.from)} to ${formatChartDay(data.trend.to)} (Asia/Manila).`}>
      <div className="grid gap-4">
        {values.some(value => value > 0)
          ? <TrendLineChart title={trend.title} labels={labels} formatLabel={formatLabel} formatValue={value => formatCount(value, true)} emptyReason={trend.empty}
            series={[{ key: 'value', label: trend.title, colorVar: '--mp-viz-series-1', values, kind: 'bar' }]} />
          : <p className="rounded-control border border-dashed border-border-default px-4 py-8 text-center text-sm text-text-secondary">{trend.empty}</p>}
        <ChartDataTable caption={`${trend.title} by ${monthly ? 'month' : 'day'}`} rowHeader={monthly ? 'Month' : 'Day'} rows={labels.map(formatLabel)} columns={[{ key: 'value', header: trend.title, values: values.map(value => formatCount(value)) }]} />
      </div>
    </DashboardPanel>
    {cards.length > 0 && <div className="grid gap-5 lg:grid-cols-2">{cards.map(card => <DashboardPanel key={card.title} title={card.title} description={card.description}><StatRows rows={card.rows} /></DashboardPanel>)}</div>}
    <MethodNote>
      <p>Figures come only from records that store who did the work. A sale counts once the order is confirmed: a quotation order belongs to whoever handled the inquiry when the Buyer accepted, any other order to the person who confirmed it, and auto-accepted orders belong to no one.</p>
      <p className="mt-2">Reply time runs from the first unanswered Buyer message to the next store reply and is credited to whoever sent that reply. It is elapsed time, including hours the store is closed. On-time handovers compare the delivery or pickup date with the order&apos;s promised fulfillment date.</p>
      <p className="mt-2">{data.salesValueVisible ? 'Sales value is the materials payable of attributed sales.' : 'Peso values are visible to the Owner only.'} Recorded actions in this period: {count(data.activity.total)} ({count(data.activity.unsuccessful)} unsuccessful).</p>
    </MethodNote>
  </div>
}
