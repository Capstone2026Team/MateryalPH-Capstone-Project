import { useState } from 'react'
import { RefreshCw } from 'lucide-react'
import { Link, useLocation, useParams, useSearchParams } from 'react-router-dom'
import { BackNavigation, Button, DateFilter, EmptyState, FilterPanel, FilterTabs, OrderAuditDetails, OrderStateRows, PageHeader, Pagination, RefundStatusBadge, ResponsiveRecordList, SearchInput, formatManilaDateTime, formatPesoCentavos, type RecordColumn } from '@materyalph/web-ui'
import { type ListAdminAuditOrdersRequest, type ListAdminRefundsStateEnum, type ListAdminRefundsTriggerEnum } from '@materyalph/api-client-ts'
import { getAuditOrder, listAuditOrders, orderAuditBasePath, type OrderSummary } from '../lib/order-audit-api'
import { listRefunds, listAuditReimbursements, type AdminRefundRow, type AdminReimbursementRow } from '../lib/order-operations-api'
import { dateQuery } from '../lib/admin-format'
import { useAdminQueue } from '../lib/use-admin-queue'
import { useLoad, control } from '../lib/operations-hooks'
import { AdminShell, ErrorState, LoadingState } from './PhaseThreeAdminPages'

const words = (value: string) => value.replaceAll('_', ' ').toLowerCase()
const ORDER_STATES = ['AWAITING_VENDOR_CONFIRMATION', 'AWAITING_BUYER_APPROVAL', 'AWAITING_NRPC_ACCEPTANCE', 'AWAITING_PAYMENT', 'CONFIRMED', 'PROCESSING', 'READY_FOR_PICKUP', 'OUT_FOR_DELIVERY', 'DELIVERED', 'PICKED_UP', 'COMPLETED', 'CANCELLATION_REQUESTED', 'DECLINED', 'EXPIRED', 'CANCELLED', 'DISPUTED'] as const
const REFUND_STATES = ['REFUND_PENDING', 'REFUNDED', 'REFUND_FAILED'] as const

export function AuditNavigation() {
  const [params, setParams] = useSearchParams()
  return <FilterTabs appearance="tabs" label="Audit view" value={params.get('view') === 'transactions' ? 'transactions' : 'events'} chips={[{ value: 'events', label: 'Audit events' }, { value: 'transactions', label: 'Orders & refunds' }]} onChange={view => setParams(view === 'transactions' ? { view } : {})} />
}

/** All-history by default. Queries, date boundaries and pagination survive opening and returning from an order. */
export function AdminOrderAuditBrowser() {
  const [params, setParams] = useSearchParams()
  const refunds = params.get('records') === 'refunds'
  const cash = params.get('records') === 'cash'
  const page = Math.max(1, Math.min(1000, Number(params.get('page')) || 1))
  const [draft, setDraft] = useState(params.get('q') ?? '')
  const change = (updates: Record<string, string>) => setParams(current => { const next = new URLSearchParams(current); next.delete('page'); for (const [key, value] of Object.entries(updates)) { if (value) next.set(key, value); else next.delete(key) }; return next })
  const range = { label: params.get('dateLabel') ?? 'All time', from: params.get('from') ?? '', to: params.get('to') ?? '' }
  const state = params.get('state') ?? ''
  const orderState = ORDER_STATES.find(value => value === state)
  const refundState = REFUND_STATES.find(value => value === state)
  const method = ['ONLINE', 'CASH_ON_DELIVERY', 'IN_STORE'].find(value => value === params.get('method')) as ListAdminAuditOrdersRequest['paymentMethod']
  const trigger = ['CANCELLATION', 'DISPUTE_CONCLUSION', 'TECHNICAL_COMPENSATION', 'FEE_CREDIT'].find(value => value === params.get('trigger')) as ListAdminRefundsTriggerEnum | undefined
  const filters = { page, ...(params.get('q') ? { q: params.get('q')! } : {}), ...(orderState ? { orderState } : {}), ...(method ? { paymentMethod: method } : {}), ...dateQuery(range) }
  const orders = useAdminQueue(`audit-orders:${JSON.stringify([refunds, cash, filters])}`, () => refunds || cash ? Promise.resolve(null) : listAuditOrders(filters))
  const refundRows = useAdminQueue(`audit-refunds:${JSON.stringify([refunds, page, refundState, trigger, range.from, range.to])}`, () => refunds ? listRefunds(page, refundState as ListAdminRefundsStateEnum | undefined, range, trigger) : Promise.resolve(null))
  const reimbursements = useAdminQueue(`audit-cash:${JSON.stringify([cash, page, range.from, range.to])}`, () => cash ? listAuditReimbursements(page, range) : Promise.resolve(null))
  const query = cash ? reimbursements : refunds ? refundRows : orders
  const href = (id: string) => `/audit/orders/${id}?${params}`
  const orderColumns: RecordColumn<OrderSummary>[] = [
    { key: 'order', header: 'Order · parties', cell: row => <span className="grid gap-1"><Link className="inline-flex min-h-11 items-center font-semibold text-action-primary hover:underline" to={href(row.id)}>{row.reference}</Link><span>{row.buyer?.displayName ?? 'Buyer'} · {row.vendor.name}</span><span className="text-xs text-text-secondary">{words(row.procurementType)} · {row.lineCount} items</span></span> },
    { key: 'states', header: 'Status', cell: row => <OrderStateRows states={row.states} /> },
    { key: 'method', header: 'Payment · fulfillment', cell: row => `${words(row.paymentMethod)} · ${words(row.fulfillmentMethod)}` },
    { key: 'amount', header: 'Order value', cell: row => <span className="font-semibold tabular-nums">{formatPesoCentavos(row.commercialTotalCentavos)}{row.deliveryPending && <span className="block text-xs font-normal">Delivery fee pending</span>}</span> },
    { key: 'date', header: 'Submitted (Manila)', cell: row => row.submittedAt ? formatManilaDateTime(row.submittedAt) : 'Not recorded' },
    { key: 'action', header: 'Action', cell: row => <Link to={href(row.id)} className="inline-flex min-h-11 items-center font-semibold text-action-primary hover:underline">View order</Link> },
  ]
  const refundColumns: RecordColumn<AdminRefundRow>[] = [
    { key: 'order', header: 'Order / statement', cell: row => row.orderId ? <Link to={href(row.orderId)} className="inline-flex min-h-11 items-center font-semibold text-action-primary hover:underline">{row.orderReference}</Link> : row.statementReference ?? 'Platform fee' },
    { key: 'vendor', header: 'Vendor · trigger', cell: row => <span className="grid gap-1"><span>{row.vendorName ?? 'Vendor'}</span><span className="text-xs text-text-secondary">{words(row.trigger)}</span></span> },
    { key: 'amount', header: 'Refund amount', cell: row => formatPesoCentavos(row.amountCentavos) },
    { key: 'status', header: 'Status', cell: row => <span className="grid justify-items-start gap-1"><RefundStatusBadge displayState={row.displayState} /><span className="text-xs text-text-secondary">{row.evidenceOrigin} · attempt {row.attemptNumber}{row.failureCode ? ` · ${row.failureCode}` : ''}</span></span> },
    { key: 'date', header: 'Requested / completed', cell: row => <span className="grid gap-1"><span>{row.requestedAt ? formatManilaDateTime(row.requestedAt) : 'Not recorded'}</span><span>{row.completedAt ? formatManilaDateTime(row.completedAt) : 'Not completed'}</span></span> },
    { key: 'action', header: 'Action', cell: row => row.orderId ? <Link to={href(row.orderId)} className="inline-flex min-h-11 items-center font-semibold text-action-primary hover:underline">View order</Link> : <span className="text-xs text-text-secondary">Statement refund</span> },
  ]
  const cashColumns: RecordColumn<AdminReimbursementRow>[] = [
    { key: 'order', header: 'Order', cell: row => <Link to={href(row.orderId!)} className="inline-flex min-h-11 items-center font-semibold text-action-primary hover:underline">{row.orderReference}</Link> },
    { key: 'vendor', header: 'Vendor', cell: row => row.vendorName ?? 'Vendor' },
    { key: 'amount', header: 'Reimbursement', cell: row => formatPesoCentavos(row.amountCentavos) },
    { key: 'method', header: 'Payment method', cell: row => words(row.method) },
    { key: 'state', header: 'Status and evidence', cell: row => <span className="grid gap-1"><span>{row.state === 'REIMBURSEMENT_CONFIRMED' ? row.confirmedByReview ? 'Confirmed by review' : 'Confirmed by Buyer' : 'Pending reimbursement confirmation'}</span><span className="text-xs text-text-secondary">{row.hasEvidence ? 'Evidence recorded' : 'No evidence recorded'}</span></span> },
    { key: 'date', header: 'Reimbursed (Manila)', cell: row => row.reimbursedAt ? formatManilaDateTime(row.reimbursedAt) : 'Not recorded' },
    { key: 'action', header: 'Action', cell: row => <Link to={href(row.orderId!)} className="inline-flex min-h-11 items-center font-semibold text-action-primary hover:underline">View order</Link> },
  ]
  const hasMore = cash ? reimbursements.data?.hasMore : refunds ? refundRows.data?.hasMore : orders.data?.meta.hasMore
  return <section className="grid min-w-0 gap-4" aria-label="Platform orders and refunds">
    <div><h2 className="text-lg font-semibold">Platform orders & refund transactions</h2><p className="mt-1 text-sm text-text-secondary">All marketplace order states and recorded refund instructions. Open an order to review its items, payments, fulfillment, refunds and history in view mode.</p></div>
    <FilterTabs appearance="chips" label="Transaction records" value={cash ? 'cash' : refunds ? 'refunds' : 'orders'} chips={[{ value: 'orders', label: 'All orders' }, { value: 'refunds', label: 'Online refunds' }, { value: 'cash', label: 'Cash reimbursements' }]} onChange={records => change({ records, state: '' })} />
    <FilterPanel compact columns={refunds ? 2 : 4} label="Transaction filters"
      footer={<div className="mp-filter-date"><span>{cash ? 'Reimbursement recorded dates' : refunds ? 'Refund requested dates' : 'Order submitted dates'}</span><DateFilter title="Transaction dates" value={range} onChange={value => change({ from: value.from, to: value.to, dateLabel: value.label })} /></div>}
      actions={<><Button variant="quiet" onClick={() => { setDraft(''); setParams({ view: 'transactions', ...(cash ? { records: 'cash' } : refunds ? { records: 'refunds' } : {}) }) }}>Reset filters</Button><Button variant="secondary" disabled={query.loading} onClick={query.retry}><RefreshCw size={16} aria-hidden="true" />{query.loading && query.data ? 'Refreshing…' : 'Refresh'}</Button></>}>
      {!cash && <>
        {!refunds && <form role="search" aria-label="Order search" className="grid min-w-0 gap-1.5 sm:col-span-2" onSubmit={event => { event.preventDefault(); change({ q: draft.trim() }) }}>
          <span className="text-xs font-medium text-text-secondary">Order, Buyer or Vendor</span>
          <div className="flex min-w-0 flex-col gap-2 sm:flex-row"><SearchInput className="flex-1" label="Order, Buyer or Vendor" placeholder="Order reference, Buyer or Vendor" value={draft} maxLength={120} onChange={setDraft} /><Button type="submit">Search orders</Button></div>
        </form>}
        <label>Status<select className={control} value={state} onChange={event => change({ state: event.target.value })}><option value="">All statuses</option>{(refunds ? REFUND_STATES : ORDER_STATES).map(value => <option key={value} value={value}>{words(value)}</option>)}</select></label>
        {refunds ? <label>Refund trigger<select className={control} value={trigger ?? ''} onChange={event => change({ trigger: event.target.value })}><option value="">All triggers</option>{['CANCELLATION', 'DISPUTE_CONCLUSION', 'TECHNICAL_COMPENSATION', 'FEE_CREDIT'].map(value => <option key={value} value={value}>{words(value)}</option>)}</select></label> : <label>Payment method<select className={control} value={method ?? ''} onChange={event => change({ method: event.target.value })}><option value="">All methods</option>{['ONLINE', 'CASH_ON_DELIVERY', 'IN_STORE'].map(value => <option key={value} value={value}>{words(value)}</option>)}</select></label>}
      </>}
    </FilterPanel>
    {query.error && <ErrorState message={query.error} onRetry={query.retry} />}
    {!query.data ? query.loading && <LoadingState /> : cash ? reimbursements.data && (reimbursements.data.items.length ? <ResponsiveRecordList caption="Cash reimbursement transactions" rows={reimbursements.data.items} columns={cashColumns} rowKey={row => row.id} cardTitle={row => row.orderReference} /> : <EmptyState message="No cash reimbursements match these dates." />) : refunds ? refundRows.data && (refundRows.data.items.length ? <ResponsiveRecordList caption="Platform refund transactions" rows={refundRows.data.items} columns={refundColumns} rowKey={row => row.id} cardTitle={row => row.orderReference ?? row.statementReference ?? 'Refund'} /> : <EmptyState message="No refunds match these filters." />) : orders.data && (orders.data.items.length ? <ResponsiveRecordList caption="Platform orders" rows={orders.data.items} columns={orderColumns} rowKey={row => row.id} cardTitle={row => row.reference} /> : <EmptyState message="No orders match these filters." />)}
    {(page > 1 || hasMore) && <Pagination page={page} hasMore={Boolean(hasMore)} busy={query.loading} onChange={next => setParams(current => { const result = new URLSearchParams(current); result.set('page', String(next)); return result })} />}
  </section>
}

export function AdminOrderAuditPage() {
  const { orderId = '' } = useParams()
  const { search } = useLocation()
  const [params] = useSearchParams()
  const caseId = params.get('caseId') ?? undefined
  const order = useLoad(() => getAuditOrder(orderId, caseId), [orderId, caseId])
  const caseParams = new URLSearchParams(params); caseParams.delete('caseId')
  const back = caseId ? `/disputes/${encodeURIComponent(caseId)}${caseParams.size ? `?${caseParams}` : ''}` : `/audit${search || '?view=transactions'}`
  return <AdminShell activeHref={caseId ? '/disputes' : '/audit'}><div className="grid min-w-0 gap-4">
    <BackNavigation><Link to={back}>{caseId ? 'Return to dispute' : 'Return to orders & refunds'}</Link></BackNavigation>
    <PageHeader compact eyebrow="Read-only audit" title={order.data?.reference ?? 'Order details'} description="Review the recorded transaction and its history." actions={<Button variant="secondary" onClick={order.retry}>Refresh</Button>} />
    {order.error ? <ErrorState message={order.error} onRetry={order.retry} /> : !order.data ? <LoadingState /> : <OrderAuditDetails order={order.data} apiBasePath={orderAuditBasePath} relatedCase={order.data.dispute ? <Link to={`/disputes/${order.data.dispute.caseId}`} className="inline-flex min-h-11 items-center font-semibold text-action-primary hover:underline">View dispute {order.data.dispute.reference}</Link> : undefined} />}
  </div></AdminShell>
}
