import { manilaToday, shouldRotateIdempotencyKey } from '@materyalph/web-ui'
import { useNavigationRefresh } from '@materyalph/web-ui'
import { DocumentExportButton } from '@materyalph/web-ui'
import { useCallback, useEffect, useId, useMemo, useRef, useState, type MouseEvent, type ReactNode } from 'react'
import { Link, Navigate, useParams, useSearchParams } from 'react-router-dom'
import { ArrowLeft, Bot, CheckCircle2, Store, MapPin, MessageSquare, PackageSearch, ShieldAlert, Truck } from 'lucide-react'
import {
  ActiveFilters, ALL_DATES, Button, CountBadge, DateFilter, DeliveryArrangementFields, FormDialog, OrderHistory, OrderProgress, SidePanel, ConfirmDialog, DeadlineCountdown, Field, FilterTabs, MoneyBreakdown, NrpcPreparationEditor, Pagination, Toolbar, VendorDiscountEditor, EmptyState, OrderSummaryCard, OrderStateRows, ProfileDetails, ResponsiveRecordList, Select, StatusMessage,
  dateFilterLabel, deliveryPlanVehicleOptions, formatManilaDateTime, formatPesoCentavos, nrpcPreparationAssessment, orderStateLabel, type NrpcPreparedMaterial, type RecordColumn,
} from '@materyalph/web-ui'
import {
  apiFailure, confirmOrder, declineOrder, getDeliveryPlan, getOrder, listOrders, quantityText, readableOrderError, orderFieldErrors,
  type ClosedOrderState, type DeliveryPlan, type DeliveryVehicleSelection, type OrderDetail, type OrderGroup, type OrderLine, type OrderListMeta, type OrderSummary, type VendorOrderConfirmRequest, type VendorOrderDeclineReason,
} from '../lib/orders-api'
import type { ChatQuotationDiscount, DeliveryPlanVehicle } from '@materyalph/api-client-ts'
import { deliveryChoiceFee, mobilizationLabel, mobilizationTotal } from '../lib/delivery-fee'
import { parsePesoInput } from '../../../../packages/web-ui/src/money-input'
import { orderDiscountForSave, orderDiscountPreview } from '../lib/order-discount'
import { newIdempotencyKey } from '../lib/onboarding-api'
import { storeName } from '../lib/catalog-access'
import { useOnboardingSnapshot } from '../lib/vendor-status'
import { OrderReviewPanel } from './TrustPages'
import { ErrorState, LoadingState, PageHeader, VendorShell } from './PhaseThreeVendorPages'
import { OrderPaymentPanel } from './OrderPaymentPanel'
import { CancellationPanel, FulfillmentWorkspace, RefundsPanel } from './OrderFulfillmentPanels'
import { OrderInvoicePanel } from './InvoicePages'
import { DisputeStatusBadge } from '@materyalph/web-ui'
import { FulfillmentConversationDialog } from './FulfillmentConversationDialog'
import { FileDisputeDialog } from './DisputePages'
import { dateRangeFromParams, dateRangePatch } from '../lib/date-filters'
import { useFulfillmentUnreadCount } from '../lib/use-fulfillment-unread-count'

type VisibleOrderGroup = Exclude<OrderGroup, 'ALL'>
const GROUPS: { value: VisibleOrderGroup; label: string }[] = [
  { value: 'NEW', label: 'New requests' }, { value: 'WAITING_ON_BUYER', label: 'Waiting on Buyer' }, { value: 'AWAITING_PAYMENT', label: 'Awaiting payment' },
  { value: 'CONFIRMED', label: 'Processing' }, { value: 'CLOSED', label: 'Closed' },
]
const EMPTY: Record<VisibleOrderGroup, string> = {
  NEW: 'No new requests yet.',
  WAITING_ON_BUYER: 'Nothing is waiting on a Buyer decision.', AWAITING_PAYMENT: 'No confirmed orders are waiting for payment.',
  CONFIRMED: 'No orders are being prepared or fulfilled right now.', CLOSED: 'No completed, declined, expired or cancelled orders yet.',
}
const CLOSED_STATES: { value: ClosedOrderState; label: string }[] = [
  { value: 'COMPLETED', label: 'Completed' }, { value: 'CANCELLED', label: 'Cancelled' },
  { value: 'EXPIRED', label: 'Expired' }, { value: 'DECLINED', label: 'Declined' },
]
const DECLINE_LABELS: Record<string, string> = { STOCK_UNAVAILABLE: 'Stock unavailable', OPERATIONAL_INABILITY: 'Operational inability', DELIVERY_INABILITY: 'Cannot deliver', COMPLIANCE_RESTRICTION: 'Compliance restriction', BUYER_AGREEMENT: 'Agreed with the Buyer', OTHER: 'Other' }
const control = 'min-h-12 w-full min-w-0 rounded-control border border-border-default bg-surface-primary px-3 text-base font-normal'

function stateOf(states: { family: string; state: string }[], family: string): string {
  return states.find(row => row.family === family)?.state ?? ''
}

function OrderAccessGate({ activeHref, children }: { activeHref: string; children: (snapshot: NonNullable<ReturnType<typeof useOnboardingSnapshot>['snapshot']>) => ReactNode }) {
  const { snapshot, loading, error, refresh } = useOnboardingSnapshot()
  if (loading) return <VendorShell activeHref={activeHref} accountLabel="Vendor" navigationData={null}><LoadingState label="Loading orders…" /></VendorShell>
  if (error || !snapshot) return <VendorShell activeHref={activeHref} accountLabel="Vendor" navigationData={null}><ErrorState message={error ?? 'Orders are unavailable.'} onRetry={() => void refresh()} /></VendorShell>
  const allowed = snapshot.permissions.includes('portal.orders')
  return <VendorShell activeHref={activeHref} accountLabel={storeName(snapshot)} navigationData={snapshot}>
    {allowed ? children(snapshot) : <StatusMessage tone="error">Your role does not include Orders. Ask the store Owner if you need order access.</StatusMessage>}
  </VendorShell>
}

// ── List ────────────────────────────────────────────────────────────────────────────────────────

export function VendorOrdersPage() {
  return <OrderAccessGate activeHref="/orders">{snapshot => <OrdersWorkspace canMessage={snapshot.permissions.includes('portal.messages')} canViewReviews={snapshot.permissions.includes('reviews.view')} canRateBuyer={snapshot.permissions.includes('reviews.rate_buyer')} />}</OrderAccessGate>
}

function OrdersWorkspace({ canMessage, canViewReviews, canRateBuyer }: { canMessage: boolean; canViewReviews: boolean; canRateBuyer: boolean }) {
  const [searchParams, setSearchParams] = useSearchParams()
  const group = GROUPS.find(item => item.value === searchParams.get('group'))?.value ?? 'NEW'
  const closedState = group === 'CLOSED' ? CLOSED_STATES.find(item => item.value === searchParams.get('closed_state'))?.value : undefined
  const q = searchParams.get('q') ?? ''
  const range = dateRangeFromParams(searchParams)
  const selectedOrder = searchParams.get('order')
  const openOrder = (event: MouseEvent<HTMLAnchorElement>, id: string) => {
    if (event.button !== 0 || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return
    event.preventDefault()
    setSearchParams(current => { const next = new URLSearchParams(current); next.set('order', id); return next })
  }
  const closeOrder = () => {
    setSearchParams(current => { const next = new URLSearchParams(current); next.delete('order'); return next }, { replace: true })
    setAttempt(value => value + 1)
  }
  const page = Math.max(1, Number(searchParams.get('page') ?? '1') || 1)
  const [query, setQuery] = useState(q)
  useEffect(() => { setQuery(q) }, [q])
  const [rows, setRows] = useState<OrderSummary[]>([])
  const [meta, setMeta] = useState<OrderListMeta | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  useNavigationRefresh(() => setAttempt(value => value + 1))
  const request = useRef(0)
  const setParams = (patch: Record<string, string>) => setSearchParams(current => {
    const next = new URLSearchParams(current)
    next.delete('status_group')
    for (const [key, value] of Object.entries(patch)) { if (value) next.set(key, value); else next.delete(key) }
    if (!('page' in patch)) next.delete('page')
    return next
  }, { replace: true })

  useEffect(() => {
    const id = ++request.current
    setLoading(true); setError(null)
    listOrders({ group, q, page, ...(closedState ? { closedState } : {}), ...(range.from ? { from: range.from } : {}), ...(range.to ? { to: range.to } : {}) }).then(result => { if (id === request.current) { setRows(result.items); setMeta(result.meta) } })
      .catch(async cause => { const text = await readableOrderError(cause); if (id === request.current) setError(text) })
      .finally(() => { if (id === request.current) setLoading(false) })
  }, [group, closedState, q, page, range.from, range.to, attempt])

  const chips = GROUPS.map(item => ({ value: item.value, label: item.label, count: meta?.counts[item.value] }))

  return <div className="grid min-w-0 gap-6">
    <PageHeader eyebrow="Store Operations" title="Orders" description="Review incoming requests and track payment and fulfillment across your orders." />
    <FilterTabs label="Filter orders by status" chips={chips} value={group} disabled={loading} onChange={value => setParams({ group: value, closed_state: '' })} />
    <Toolbar searchFirst filters={<>{group === 'CLOSED' && <Select label="Closed status" hideLabel className="sm:min-w-52" value={closedState ?? ''} onChange={event => setParams({ closed_state: event.target.value })}>
      <option value="">All closed orders</option>
      {CLOSED_STATES.map(item => <option key={item.value} value={item.value}>{item.label}</option>)}
    </Select>}<DateFilter title="Order submission dates" value={range} onChange={next => setParams(dateRangePatch(next))} /></>} search={{ label: 'Search by Order ID or Buyer', placeholder: 'Order ID or Buyer name', value: query, onChange: setQuery, maxLength: 120, onSubmit: event => { event.preventDefault(); setParams({ q: query.trim() }) } }} />
    <ActiveFilters filters={[
      ...(q ? [{ key: 'q', label: `Search: ${q}`, onRemove: () => setParams({ q: '' }) }] : []),
      ...(closedState ? [{ key: 'closed_state', label: orderStateLabel(closedState), onRemove: () => setParams({ closed_state: '' }) }] : []),
      ...(range.from || range.to ? [{ key: 'dates', label: dateFilterLabel(range), onRemove: () => setParams(dateRangePatch(ALL_DATES)) }] : []),
    ]} onClear={() => { setQuery(''); setParams({ q: '', closed_state: '', ...dateRangePatch(ALL_DATES) }) }} />
    {error ? <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} />
      : loading && rows.length === 0 ? <div className="grid gap-3" aria-busy="true" aria-label="Loading orders">{[0, 1, 2].map(index => <div key={index} className="h-20 animate-pulse rounded-surface bg-surface-canvas motion-reduce:animate-none" />)}</div>
        : rows.length === 0 ? <EmptyState message={q || range.from || range.to ? 'No orders match these filters.' : closedState ? `No ${orderStateLabel(closedState).toLowerCase()} orders yet.` : EMPTY[group]} action={q || closedState || range.from || range.to ? <Button variant="secondary" onClick={() => { setQuery(''); setParams({ group, closed_state: '', q: '', ...dateRangePatch(ALL_DATES) }) }}>Clear filters</Button> : undefined} />
          : <div aria-busy={loading}>
            <ul aria-label={GROUPS.find(item => item.value === group)?.label ?? 'Orders'} className="grid min-w-0 gap-4">
              {rows.map(row => <li key={row.id} className="min-w-0"><OrderSummaryCard order={row} identity={<OrderIdentity row={row} onOpen={openOrder} />} action={<ActionLink row={row} onOpen={openOrder} />} /></li>)}
            </ul>
            {meta && meta.total > meta.perPage && <div className="mt-4"><Pagination page={page} lastPage={Math.ceil(meta.total / meta.perPage)} total={meta.total} busy={loading} onChange={next => setParams({ page: String(next) })} /></div>}
          </div>}
    {selectedOrder && <SidePanel key={selectedOrder} open title={rows.find(row => row.id === selectedOrder)?.reference ?? 'Order details'} description={rows.find(row => row.id === selectedOrder)?.firstLine.displayName ?? 'Order review'} closeLabel="Close order details" padded={false} onClose={closeOrder}>
      <OrderDetailWorkspace key={selectedOrder} orderId={selectedOrder} canMessage={canMessage} canViewReviews={canViewReviews} canRateBuyer={canRateBuyer} onOrderChanged={() => setAttempt(value => value + 1)} panel />
    </SidePanel>}
  </div>
}

function OrderIdentity({ row, onOpen }: { row: OrderSummary; onOpen?: (event: MouseEvent<HTMLAnchorElement>, id: string) => void }) {
  return <div className="grid min-w-0 gap-1">
    <Link to={`/orders/${row.id}`} onClick={event => onOpen?.(event, row.id)} className="w-fit break-all text-xs font-semibold text-action-primary underline-offset-4 hover:underline">{row.reference}</Link>
    <h2 className="break-words text-base font-semibold text-text-strong">{row.firstLine.displayName}{row.lineCount > 1 ? ` + ${row.lineCount - 1} more` : ''}</h2>
    <p className="break-words text-sm text-text-secondary">{row.buyer?.displayName ?? 'Buyer'} · {row.procurementType === 'PROJECT_BASED' ? 'Project-Based' : 'Item-Based'}</p>
  </div>
}

function ActionLink({ row, onOpen }: { row: OrderSummary; onOpen?: (event: MouseEvent<HTMLAnchorElement>, id: string) => void }) {
  const confirm = row.primaryAction === 'CONFIRM'
  return <Link to={`/orders/${row.id}`} onClick={event => onOpen?.(event, row.id)} className={`inline-flex min-h-11 items-center justify-center gap-2 rounded-control px-4 text-sm font-semibold border border-border-default bg-surface-primary text-text-strong hover:bg-surface-canvas`}>
    {confirm ? 'Review request' : 'View order'}
  </Link>
}

// ── Detail ──────────────────────────────────────────────────────────────────────────────────────

export function VendorOrderDetailPage() {
  const { orderId = '' } = useParams()
  return <OrderAccessGate activeHref="/orders">{snapshot => snapshot.permissions.includes('portal.fulfillment') && !snapshot.permissions.includes('fulfillment.assign')
    ? <Navigate to={`/fulfillment/${orderId}`} replace />
    : <OrderDetailWorkspace key={orderId} orderId={orderId} canMessage={snapshot.permissions.includes('portal.messages')} canViewReviews={snapshot.permissions.includes('reviews.view')} canRateBuyer={snapshot.permissions.includes('reviews.rate_buyer')} />}</OrderAccessGate>
}

function OrderDetailWorkspace({ orderId, panel = false, canMessage = false, canViewReviews = false, canRateBuyer = false, onOrderChanged }: { orderId: string; panel?: boolean; canMessage?: boolean; canViewReviews?: boolean; canRateBuyer?: boolean; onOrderChanged?: () => void }) {
  const [order, setOrder] = useState<OrderDetail | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [notice, setNotice] = useState<{ tone: 'success' | 'error' | 'info'; text: string } | null>(null)
  const [attempt, setAttempt] = useState(0)
  const readVersion = useRef(0)
  const load = useCallback(() => setAttempt(value => value + 1), [])
  useNavigationRefresh(load)
  useEffect(() => {
    let active = true
    const version = ++readVersion.current
    setError(null)
    getOrder(orderId).then(loaded => { if (active && version === readVersion.current) setOrder(current => current && current.id === loaded.id && current.lockVersion > loaded.lockVersion ? current : loaded) }).catch(async cause => {
      const text = await readableOrderError(cause)
      const failure = await apiFailure(cause)
      if (active && version === readVersion.current) {
        if (['ORDER_NOT_FOUND', 'PERMISSION_DENIED', 'UNAUTHENTICATED', 'MEMBERSHIP_NOT_ACTIVE'].includes(failure?.code ?? '')) setOrder(null)
        setError(text)
      }
    })
    return () => { active = false }
  }, [orderId, attempt])

  if (error && !order) return <div className="grid gap-4 p-5">{!panel && <BackLink />}<ErrorState message={error} onRetry={load} /></div>
  if (!order) return <div className="grid gap-4 p-5">{!panel && <BackLink />}<LoadingState label="Loading order…" /></div>
  const orderState = stateOf(order.states, 'ORDER')
  const inFulfillment = Boolean(order.acceptedAt) && !['AWAITING_VENDOR_CONFIRMATION', 'AWAITING_BUYER_APPROVAL', 'AWAITING_NRPC_ACCEPTANCE', 'AWAITING_PAYMENT', 'DECLINED', 'EXPIRED'].includes(orderState)
  const changed = (next: OrderDetail, text: string) => { readVersion.current++; setOrder(current => current && current.lockVersion > next.lockVersion ? current : next); setError(null); setNotice({ tone: 'success', text }); onOrderChanged?.() }
  const deadline = orderState === 'AWAITING_VENDOR_CONFIRMATION' ? { at: order.deadlines.vendorResponseDueAt, label: 'Respond within' }
    : orderState === 'AWAITING_BUYER_APPROVAL' || orderState === 'AWAITING_NRPC_ACCEPTANCE' ? { at: order.deadlines.buyerResponseDueAt, label: 'Buyer decides within' }
      : orderState === 'AWAITING_PAYMENT' ? { at: order.deadlines.paymentExpiresAt, label: 'Payment window' } : null

  if (panel) return <OrderPanelContent order={order} canMessage={canMessage} canViewReviews={canViewReviews} canRateBuyer={canRateBuyer} notice={notice} onChanged={changed} onReload={load} />

  const information: [string, ReactNode][] = [
    ['Buyer', order.buyer?.displayName ?? '—'],
    ['Requested', formatManilaDateTime(order.submittedAt)],
    ['Fulfillment', order.fulfillmentMethod === 'DELIVERY' ? 'Site Delivery' : 'Self-Pickup'],
    ['Payment method', order.paymentMethod === 'ONLINE' ? 'Online payment' : order.paymentMethod === 'CASH_ON_DELIVERY' ? 'Cash on Delivery' : 'In-Store Payment'],
    ['Source', order.confirmationSource === 'AUTO_ACCEPT' ? 'Auto-accepted' : order.confirmationSource === 'MANUAL' ? 'Manual confirmation' : 'Manual review'],
  ]
  if (order.expectedFulfillmentDate) information.push([
    order.fulfillmentMethod === 'DELIVERY' ? 'Delivery date' : 'Ready for pickup',
    order.expectedFulfillmentDate.toLocaleDateString('en-PH', { month: 'short', day: 'numeric', year: 'numeric' }),
  ])

  return <div className="grid min-w-0 gap-6">
    <BackLink />
    <PageHeader eyebrow="Job order" title={order.reference} status={orderState} description={primaryDescription(order)} />
    {error && <StatusMessage tone="error">{error} The last loaded order is shown. <Button variant="quiet" onClick={load}>Retry</Button></StatusMessage>}
    <div className="min-w-0 rounded-surface border border-border-default bg-surface-primary px-4 pt-4 sm:px-5 sm:pt-5">
      <ProfileDetails title="Order information" columns={3} items={information} action={<div className="flex min-w-0 flex-wrap items-start gap-2">
        <DocumentExportButton basePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} audience="vendor" types={['PURCHASE_ORDER', 'OPERATIONAL_ORDER', 'PAYMENT_CONFIRMATION']} resourceId={order.id} title={order.reference} />
        {canMessage && <OrderMessageButton order={order} />}
      </div>} />
    </div>
    {deadline?.at && <DeadlineCountdown at={deadline.at} label={deadline.label} onExpire={load} />}
    {notice && <StatusMessage tone={notice.tone}>{notice.text}</StatusMessage>}
    {order.projectContext?.note != null && <StatusMessage tone="info">Informational Note: {String(order.projectContext.note)} · No response required</StatusMessage>}
    <div className="grid min-w-0 items-start gap-4 sm:gap-6 xl:grid-cols-[minmax(0,1fr)_22rem]">
      <div className="grid min-w-0 content-start gap-4 sm:gap-5">
        {order.primaryAction === 'CONFIRM' && order.permissions?.canConfirm
          ? <ConfirmationWorkspace order={order} onDone={changed} onReload={load} />
          : <LinesPanel order={order} />}
        {order.primaryAction === 'CONFIRM' && !order.permissions?.canConfirm && <StatusMessage tone="error">Your role can view this request but cannot confirm or decline it.</StatusMessage>}
        {inFulfillment && <FulfillmentWorkspace order={order} onChanged={changed} onReload={load} />}
        {order.invoice && <OrderInvoicePanel orderId={order.id} />}
        {orderState === 'COMPLETED' && canViewReviews && <OrderReviewPanel orderId={order.id} canRate={canRateBuyer} />}
        {order.autoAccept && <AutoAcceptPanelView order={order} />}
      </div>
      <aside className="grid min-w-0 content-start gap-4" aria-label="Order summary">
        <section aria-labelledby="status-heading" className="grid w-full min-w-0 gap-2">
          <h2 id="status-heading" className="text-base font-semibold">Status</h2>
          <OrderStateRows states={order.states} />
        </section>
        <div className="rounded-surface border border-border-default bg-surface-primary p-4"><MoneyBreakdown money={order.money} title="Buyer payment breakdown" /><p className="mt-3 border-t border-border-default pt-3 text-xs text-text-secondary">The Buyer total never includes your monthly commission or merchant withholding; those are settled separately.</p></div>
        <OrderPaymentPanel order={order} onChanged={load} />
        <CasePanel order={order} />
        <CancellationPanel order={order} onChanged={changed} />
        <RefundsPanel order={order} onChanged={changed} />
        <DestinationPanel order={order} />
        {order.nrpc && <NrpcSummary order={order} />}
        <OrderHistory events={order.timeline} />
      </aside>
    </div>
  </div>
}

function OrderMessageButton({ order }: { order: OrderDetail }) {
  const [open, setOpen] = useState(false)
  const thread = order.fulfillment?.thread
  const conversationId = thread?.available ? thread.conversationId : null
  const unreadCount = useFulfillmentUnreadCount(conversationId)
  const countId = useId()
  const noticeId = `fulfillment-message-notice-${order.id}`
  return <div className="ml-auto grid justify-items-end gap-2">
    <Button variant="secondary" disabled={!conversationId} aria-haspopup="dialog" aria-describedby={conversationId ? countId : noticeId} onClick={() => setOpen(true)}><MessageSquare size={16} aria-hidden="true" />Message<CountBadge count={unreadCount} /></Button>
    <span id={countId} className="sr-only" role="status">{unreadCount > 0 ? `${unreadCount} unread fulfillment messages` : 'No unread fulfillment messages'}</span>
    {!conversationId && <p id={noticeId} className="max-w-xs text-xs text-text-secondary">{thread?.notice ?? 'Fulfillment Messages open when the order is ready for pickup or out for delivery.'}</p>}
    {open && conversationId && <FulfillmentConversationDialog conversationId={conversationId} onClose={() => setOpen(false)} />}
  </div>
}

function OrderPanelContent({ order, notice, onChanged, onReload, canMessage, canViewReviews, canRateBuyer }: {
  canMessage: boolean;
  canViewReviews: boolean; canRateBuyer: boolean;
  order: OrderDetail; notice: { tone: 'success' | 'error' | 'info'; text: string } | null
  onChanged: (order: OrderDetail, text: string) => void; onReload: () => void
}) {
  const [review, setReview] = useState(false)
  const [decline, setDecline] = useState(false)
  const state = stateOf(order.states, 'ORDER')
  const canReview = order.primaryAction === 'CONFIRM' && order.permissions?.canConfirm
  const changed = (next: OrderDetail, text: string) => { setReview(false); setDecline(false); onChanged(next, text) }
  const deadline = order.deadlines.vendorResponseDueAt && state === 'AWAITING_VENDOR_CONFIRMATION' ? { at: order.deadlines.vendorResponseDueAt, label: 'Respond within' }
    : order.deadlines.buyerResponseDueAt && ['AWAITING_BUYER_APPROVAL', 'AWAITING_NRPC_ACCEPTANCE'].includes(state) ? { at: order.deadlines.buyerResponseDueAt, label: 'Buyer response' }
      : order.deadlines.paymentExpiresAt && state === 'AWAITING_PAYMENT' ? { at: order.deadlines.paymentExpiresAt, label: 'Payment window' } : null
  return <div className="grid min-w-0">
    <div className="grid min-w-0 gap-4 p-5">
      <div className="flex flex-wrap items-start gap-3 border-b border-border-default pb-5">
        <span className="grid h-11 w-11 shrink-0 place-items-center rounded-control bg-surface-canvas text-action-primary"><Store size={20} aria-hidden="true" /></span>
        <div className="min-w-[8rem] flex-1"><h3 className="break-words text-sm font-semibold">{order.buyer?.displayName ?? 'Buyer'}</h3><p className="text-xs text-text-secondary">{order.procurementType === 'PROJECT_BASED' ? 'Project-Based' : 'Item-Based'} · {order.reference}</p><p className="mt-1 text-xs text-text-secondary">Requested {formatManilaDateTime(order.submittedAt)}</p></div>
        {canMessage && <OrderMessageButton order={order} />}
      </div>
      {notice && <StatusMessage tone={notice.tone}>{notice.text}</StatusMessage>}
      <section className="grid gap-2" aria-label="Order status"><h3 className="text-xs font-semibold uppercase tracking-wide text-text-secondary">Order status</h3><OrderProgress state={stateOf(order.states, 'ORDER')} fulfillmentMethod={order.fulfillmentMethod} /></section>
      {deadline && <DeadlineCountdown at={deadline.at} label={deadline.label} onExpire={onReload} />}

      <section aria-label="Order items" className="min-w-0">
        <h3 className="mb-3 text-xs font-semibold uppercase tracking-wide text-text-secondary">Order items ({order.lines.length})</h3>
        <div role="region" aria-label="Order items table" tabIndex={0} className="overflow-x-auto">
        <table className="min-w-[340px] text-xs" style={{ tableLayout: 'auto' }}><caption className="sr-only">Ordered materials and prices</caption><thead className="border-y border-border-default bg-surface-canvas text-text-secondary"><tr><th scope="col" className="w-[40%] p-2 text-left">Material</th><th scope="col" className="whitespace-nowrap p-2 text-right">Qty</th><th scope="col" className="whitespace-nowrap p-2 text-right">Unit price</th><th scope="col" className="whitespace-nowrap p-2 text-right">Total</th></tr></thead>
          <tbody>{order.lines.map(line => <tr key={line.id} className="border-b border-border-default"><th scope="row" className="p-2 text-left font-medium">{line.displayName}<span className="block text-text-secondary">{line.variantLabel}</span>{line.change && <span className="block text-action-primary">{orderStateLabel(line.change)}</span>}</th><td className="whitespace-nowrap p-2 text-right">{quantityText(line.confirmedQuantity ?? line.requestedQuantity)} {line.unitCode}</td><td className="whitespace-nowrap p-2 text-right tabular-nums">{formatPesoCentavos(line.unitPriceCentavos)}</td><td className="whitespace-nowrap p-2 text-right font-semibold tabular-nums">{formatPesoCentavos(line.lineTotalCentavos)}</td></tr>)}</tbody>
        </table>
        </div>
      </section>
      <MoneyBreakdown money={order.money} title="Order total" compact />
      <section className="grid gap-3 border-t border-border-default pt-5" aria-label="Delivery and payment">
        <h3 className="text-xs font-semibold uppercase tracking-wide text-text-secondary">Delivery & payment</h3>
        <dl className="divide-y divide-border-default text-xs">
          {[
            ['Fulfillment', order.fulfillmentMethod === 'DELIVERY' ? 'Site Delivery' : 'Self-Pickup'],
            ['Address', order.destination?.type === 'PICKUP' ? order.destination.storeAddress : (order.destination?.alternateDropOff ?? order.destination?.intended)?.formattedAddress],
            ['Expected fulfillment', order.expectedFulfillmentDate ? new Intl.DateTimeFormat('en-PH', { dateStyle: 'medium' }).format(new Date(order.expectedFulfillmentDate)) : null],
            ['Confirmed vehicle', order.delivery.confirmed?.vehicles.map(vehicle => `${vehicle.name} · ${vehicle.numberOfVehicles} vehicle(s), ${vehicle.totalVehicleTrips} trip(s)`).join('; ')],
            ['Payment method', order.paymentMethod === 'ONLINE' ? 'Online payment' : order.paymentMethod === 'CASH_ON_DELIVERY' ? 'Cash on Delivery' : 'In-Store Payment'],
            ['Payment status', orderStateLabel(stateOf(order.states, 'PAYMENT'))],
          ].filter(([, value]) => Boolean(value)).map(([label, value]) => <div key={label} className="flex justify-between gap-4 py-2"><dt className="shrink-0 text-text-secondary">{label}</dt><dd className="min-w-0 break-words text-right font-medium">{value}</dd></div>)}
        </dl>
      </section>
      {order.destination?.accessInstructions && <section className="grid gap-2"><h3 className="text-xs font-semibold uppercase text-text-secondary">Access instructions</h3><p className="rounded-control bg-surface-canvas p-3 text-sm">{order.destination.accessInstructions}</p></section>}
      {order.states.some(row => (row.family === 'REFUND' && ['REFUND_PENDING', 'REFUND_FAILED', 'PARTIALLY_REFUNDED'].includes(row.state)) || (row.family === 'DISPUTE' && ['OPEN_AWAITING_RESPONSE', 'MUTUAL_RESOLUTION', 'ESCALATED_ADMIN_REVIEW', 'AWAITING_CLARIFICATION', 'APPEAL_OPEN'].includes(row.state))) && <StatusMessage tone="info">This order has an active refund or dispute. <Link to={`/orders/${order.id}`} className="underline">View full order for details</Link>.</StatusMessage>}
      {order.primaryAction === 'CONFIRM' && !order.permissions?.canConfirm && <StatusMessage tone="info">Your role can view this request but cannot confirm it.</StatusMessage>}
      {state === 'COMPLETED' && canViewReviews && <OrderReviewPanel orderId={order.id} canRate={canRateBuyer} />}
    </div>
    <div className="mp-side-panel__actions grid gap-2">
      <div className="flex flex-wrap gap-3">
        {order.primaryAction === 'CONFIRM' && order.permissions?.canDecline && <Button variant="secondary" onClick={() => setDecline(true)}>Decline request</Button>}
        {canReview && <Button className="flex-1" onClick={() => setReview(true)}>Review & confirm order</Button>}
      </div>
      <Link to={`/orders/${order.id}`} className="inline-flex min-h-11 items-center text-sm font-semibold text-action-primary">Open full order</Link>
    </div>
    {review && canReview && <FormDialog open title="Review and confirm" description={order.reference} footer={null} onClose={() => setReview(false)}>
      <ConfirmationWorkspace order={order} onDone={changed} onReload={onReload} />
    </FormDialog>}
    <DeclineDialog open={decline} order={order} onClose={() => setDecline(false)} onDone={changed} />
  </div>
}

function primaryDescription(order: OrderDetail): string {
  switch (order.primaryAction) {
    case 'CONFIRM': return 'Confirm the quantities you can supply and the fulfillment date. Confirming reserves the stock; nothing is charged until the Buyer pays.'
    case 'WAITING_FOR_BUYER': return 'Your confirmed version is with the Buyer. The stock stays reserved until they approve, reject or the window ends.'
    case 'WAITING_FOR_PAYMENT': return 'The Buyer accepted the order. The stock is reserved until payment is verified or the 24-hour payment window ends.'
    case 'PREPARE_WHEN_AVAILABLE': case 'START_PREPARATION': return 'Payment conditions are met. Start preparing and record each fulfillment milestone with its proof.'
    case 'MARK_READY': return 'Preparation is under way. Mark the order ready when every line is set aside for pickup.'
    case 'DISPATCH': return 'Preparation is under way. Dispatch on the accepted vehicle and trip when the load leaves the store.'
    case 'RECORD_PICKUP': return 'The order is ready for pickup. Record the handover with the receiver when the Buyer collects it.'
    case 'RECORD_DELIVERY': return 'The order is out for delivery. Record delivery with a photo and the receiver name. There is no live tracking.'
    case 'AWAIT_RECEIPT': return 'Fulfillment proof is recorded. The Buyer confirms receipt or it is confirmed automatically 48 hours later unless a problem is open.'
    case 'RESPOND_TO_CANCELLATION': return 'The Buyer asked to cancel during preparation. Finalize the request within 24 hours; milestones are paused.'
    default: return order.terminalReasonCode ? `This order is closed (${order.terminalReasonCode.toLowerCase().replaceAll('_', ' ')}).` : 'This order is closed.'
  }
}

/** Open this order's case, or file a Buyer issue without leaving the order. */
function CasePanel({ order }: { order: OrderDetail }) {
  const [filing, setFiling] = useState(false)
  if (!order.dispute && !order.permissions?.canFileDispute) return null
  return <section aria-labelledby="case-heading" className="grid gap-3 rounded-surface border border-border-default bg-surface-primary p-4">
    <h2 id="case-heading" className="flex items-center gap-2 text-base font-semibold"><ShieldAlert size={16} aria-hidden="true" />Dispute</h2>
    {order.dispute ? <div className="grid gap-2"><DisputeStatusBadge status={order.dispute.status} /><Link to={`/disputes/${order.dispute.caseId}`} className="font-semibold text-action-primary underline-offset-4 hover:underline">Open case {order.dispute.reference}</Link></div>
      : <><p className="text-sm text-text-secondary">Report a Buyer issue such as an unpaid cash balance, a pickup no-show or abusive communication. Filing never creates a refund.</p><Button variant="secondary" className="w-fit" aria-haspopup="dialog" onClick={() => setFiling(true)}>File a case</Button>
        {filing && <FileDisputeDialog orderId={order.id} onClose={() => setFiling(false)} />}</>}
  </section>
}

function BackLink() {
  return <Link to="/orders" className="inline-flex min-h-11 w-fit items-center gap-2 text-sm font-semibold text-text-secondary hover:text-text-strong"><ArrowLeft size={16} aria-hidden="true" />All orders</Link>
}

function LineIdentity({ line }: { line: OrderLine }) {
  return <span className="flex min-w-0 items-start gap-3">
    {line.image ? <img src={line.image.url} alt="" className="h-12 w-12 shrink-0 rounded-control border border-border-default object-cover" /> : <span className="grid h-12 w-12 shrink-0 place-items-center rounded-control bg-surface-canvas"><PackageSearch size={18} aria-hidden="true" /></span>}
    <span className="grid min-w-0 gap-0.5"><span className="break-words font-semibold">{line.displayName}</span><span className="text-xs text-text-secondary">{[line.variantLabel, line.brand, line.vatLabel].filter(Boolean).join(' · ')}</span></span>
  </span>
}

function LinesPanel({ order }: { order: OrderDetail }) {
  const columns: RecordColumn<OrderLine>[] = [
    { key: 'item', header: 'Item', cell: line => <LineIdentity line={line} /> },
    { key: 'requested', header: 'Requested', cell: line => `${quantityText(line.requestedQuantity)} ${line.unitName}` },
    { key: 'confirmed', header: 'Confirmed', cell: line => line.confirmedQuantity === null ? '—' : <span className={line.change ? 'font-semibold text-amber-900' : ''}>{quantityText(line.confirmedQuantity)} {line.unitName}{line.change === 'LINE_REMOVED' ? ' (removed)' : ''}</span> },
    { key: 'price', header: 'Unit price', cell: line => <span className="tabular-nums">{formatPesoCentavos(line.unitPriceCentavos)}{line.volumeTierApplied && <span className="block text-xs text-text-secondary">Volume tier</span>}</span> },
    { key: 'total', header: 'Line total', cell: line => <span className="font-semibold tabular-nums">{formatPesoCentavos(line.lineTotalCentavos)}</span> },
  ]
  return <section aria-labelledby="lines-heading" className="grid gap-3">
    <h2 id="lines-heading" className="text-lg font-semibold">Line items</h2>
    <ResponsiveRecordList caption="Order lines" rows={order.lines} columns={columns} rowKey={line => line.id} cardTitle={line => <LineIdentity line={line} />} />
    {order.changes.length > 0 && <p className="text-sm text-text-secondary">This version changes {order.changes.length} item{order.changes.length === 1 ? '' : 's'} from the Buyer's request.</p>}
  </section>
}

// ── Confirmation workspace ──────────────────────────────────────────────────────────────────────

type DeliveryChoice = { key: string; vehicleId: string; numberOfVehicles: number; trips: number; perTrip: number; mobilizationFee: number; mobilizationBasis: string | null }

function deliveryChoice(key: string, option: DeliveryPlanVehicle): DeliveryChoice {
  return { key, vehicleId: option.vehicleId, numberOfVehicles: option.numberOfVehicles ?? 1, trips: option.totalVehicleTrips ?? 1, perTrip: option.perTripCentavos,
    mobilizationFee: option.mobilizationFeeCentavos ?? 0, mobilizationBasis: option.mobilizationBasis ?? null }
}

function ConfirmationWorkspace({ order, onDone, onReload }: { order: OrderDetail; onDone: (order: OrderDetail, message: string) => void; onReload: () => void }) {
  const permissions = order.permissions ?? { canConfirm: false, canRevise: false, canSetNrpc: false, canConfirmDelivery: false, canDecline: false, canViewInventory: false }
  const [quantities, setQuantities] = useState<Record<string, string>>(() => Object.fromEntries(order.lines.map(line => [line.id, quantityText(line.requestedQuantity)])))
  const [discount, setDiscount] = useState<ChatQuotationDiscount>({ scope: order.money.discount?.scope ?? 'MATERIALS', percent: order.money.discount?.percent ?? '' })
  const canSetNrpc = permissions.canSetNrpc && ['CASH_ON_DELIVERY', 'IN_STORE'].includes(order.paymentMethod)
  const [nrpcSelected, setNrpcOn] = useState(false)
  const nrpcOn = canSetNrpc && nrpcSelected
  const [nrpcReason, setNrpcReason] = useState('')
  const [nrpcLines, setNrpcLines] = useState<Record<string, number | null>>({})
  const [readyDate, setReadyDate] = useState(() => manilaToday())
  const [plan, setPlan] = useState<DeliveryPlan | null>(null)
  const [planBusy, setPlanBusy] = useState(false)
  const [choices, setChoices] = useState<DeliveryChoice[]>([])
  const [deliveryDate, setDeliveryDate] = useState(() => manilaToday())
  const [arrangement, setArrangement] = useState('')
  const [accessConfirmed, setAccessConfirmed] = useState(false)
  const [heavyAccess, setHeavyAccess] = useState(false)
  const [manualNote, setManualNote] = useState('')
  const [changeReason, setChangeReason] = useState('')
  const [planReload, setPlanReload] = useState(0)
  const [errors, setErrors] = useState<Record<string, string>>({})
  const [message, setMessage] = useState<string | null>(null)
  const [shortLines, setShortLines] = useState<Record<string, string>>({})
  const [confirmOpen, setConfirmOpen] = useState(false)
  const [declineOpen, setDeclineOpen] = useState(false)
  const [busy, setBusy] = useState(false)
  const idempotencyKey = useRef(newIdempotencyKey())
  const delivery = order.fulfillmentMethod === 'DELIVERY'

  const changed = order.lines.some(line => quantityText(line.requestedQuantity) !== (quantities[line.id] ?? '').trim()) || (permissions.canRevise && (parsePesoInput(discount.percent.trim() || '0') ?? 0) > 0)
  const nrpcValues = { reason: nrpcReason, allocations: nrpcLines }
  const deliveryFee = choices.reduce((sum, choice) => sum + deliveryChoiceFee(choice), 0)
  const recommendationChanged = Boolean(plan?.groups.some(group => {
    const recommended = group.candidates[0]
    if (!recommended) return false
    const choice = choices.find(item => item.key === group.key)
    return choice && (choice.vehicleId !== recommended.vehicleId || choice.numberOfVehicles !== recommended.numberOfVehicles || choice.trips !== recommended.totalVehicleTrips)
  })) || Boolean(order.delivery.estimate?.options?.length && order.delivery.estimate.options.every(option => option.vehicleId) && choices.length && (
    deliveryFee !== order.delivery.estimate.feeMinCentavos ||
    JSON.stringify(choices.map(item => [item.vehicleId, item.numberOfVehicles, item.trips]).sort()) !== JSON.stringify(order.delivery.estimate.options.map(item => [item.vehicleId, item.vehicles, item.trips]).sort())
  ))
  const planInput = JSON.stringify(order.lines.map(line => ({ orderLineId: line.id, confirmedQuantity: (quantities[line.id] ?? '0').trim() || '0' })))
  useEffect(() => {
    if (!delivery || !permissions.canConfirmDelivery) return
    let current = true
    setPlan(null); setChoices([]); setPlanBusy(true)
    const timer = window.setTimeout(() => {
      // This is our own serialized form input; stable content avoids resetting choices on a background refresh.
      void getDeliveryPlan(order.id, JSON.parse(planInput) as Parameters<typeof getDeliveryPlan>[1]).then(next => {
        if (!current) return
        setPlan(next)
        setChoices(next.groups.flatMap(group => { const first = group.candidates[0]; return first ? [deliveryChoice(group.key, first)] : [] }))
        setMessage(null)
      }).catch(async cause => { const error = await readableOrderError(cause); if (current) setMessage(error) }).finally(() => { if (current) setPlanBusy(false) })
    }, 350)
    return () => { current = false; window.clearTimeout(timer) }
  }, [delivery, permissions.canConfirmDelivery, order.id, planInput, planReload])
  const nrpcPayable = orderDiscountPreview(order.lines, quantities, discount, order.fulfillmentMethod, deliveryFee)
  const nrpcMaterials: NrpcPreparedMaterial[] = order.lines.map(line => ({ id: line.id, name: line.displayName, detail: [line.variantLabel, `${quantities[line.id] ?? line.requestedQuantity} ${line.unitCode}`].filter(Boolean).join(' · '), payableCentavos: nrpcPayable.valid ? nrpcPayable.linePayableCentavos[line.id] ?? 0 : null }))
  const nrpcAssessment = nrpcPreparationAssessment(nrpcMaterials, nrpcValues, { min: 10, max: 1000 })
  const nextStep = changed || delivery ? 'The Buyer reviews and approves this version within 24 hours before paying.' : nrpcOn ? 'The Buyer reviews and accepts the NRPC within 24 hours before paying.' : 'The order becomes payable right away with a 24-hour payment window.'

  async function loadPlan() {
    setPlanReload(value => value + 1)
  }

  function validate(): VendorOrderConfirmRequest | null {
    const local: Record<string, string> = {}
    const lines = order.lines.map((line, index) => {
      const value = (quantities[line.id] ?? '').trim()
      if (!/^\d{1,7}(\.\d{1,4})?$/.test(value)) local[`lines.${index}.confirmed_quantity`] = 'Enter a quantity of zero or more.'
      else if (Number(value) > Number(line.requestedQuantity)) local[`lines.${index}.confirmed_quantity`] = 'Cannot exceed the requested quantity.'
      return { orderLineId: line.id, confirmedQuantity: value }
    })
    if (lines.every(line => Number(line.confirmedQuantity) === 0)) local.lines = 'Keep at least one line, or decline the order instead.'
    if (!nrpcPayable.valid) local.discount = nrpcPayable.message
    const percentage = orderDiscountForSave(discount)
    const request: VendorOrderConfirmRequest = { lockVersion: order.lockVersion, lines, ...(permissions.canRevise && percentage ? { discount: percentage } : {}) }
    if (nrpcOn) {
      if (nrpcAssessment.reasonError) local['nrpc.reason'] = nrpcAssessment.reasonError
      const allocationError = nrpcAssessment.allocationError ?? Object.values(nrpcAssessment.lineErrors)[0]
      if (allocationError) local['nrpc.lines'] = allocationError
      if (nrpcAssessment.totalCentavos !== null && nrpcAssessment.totalCentavos > 100000000000) local['nrpc.amount_centavos'] = 'The preparation cost exceeds the supported request amount.'
      request.nrpc = { amountCentavos: nrpcAssessment.totalCentavos ?? 0, reason: nrpcReason.trim(), lines: Object.entries(nrpcLines).map(([orderLineId, principalCentavos]) => ({ orderLineId, principalCentavos: principalCentavos ?? 0 })) }
    }
    if (delivery) {
      if (!deliveryDate || deliveryDate < manilaToday()) local['delivery.fulfillment_date'] = 'Choose a delivery date from today onward.'
      if (!plan || plan.groups.length === 0 || plan.groups.some(group => !choices.some(choice => choice.key === group.key && deliveryPlanVehicleOptions(group).some(vehicle => vehicle.vehicleId === choice.vehicleId)))) local.delivery = 'Load the vehicle options and choose an eligible vehicle for every line.'
      if (!accessConfirmed) local['delivery.access_confirmed'] = 'Confirm the drop-off is accessible for the chosen vehicles.'
      if (choices.some(choice => plan?.eligibleVehicles.some(vehicle => vehicle.vehicleId === choice.vehicleId && vehicle.heavyClassification === 'HEAVY')) && !heavyAccess) local['delivery.heavy_vehicle_access_confirmed'] = 'Confirm heavy-vehicle access for the selected vehicles.'
      if (arrangement.trim().length < 5) local['delivery.arrangement'] = 'Describe the delivery arrangement for the Buyer.'
      if (plan?.status === 'MANUAL_REVIEW_REQUIRED' && manualNote.trim().length < 10) local['delivery.manual_review_note'] = 'Record your manual load review (at least 10 characters).'
      if (recommendationChanged && changeReason.trim().length < 10) local['delivery.change_reason'] = 'Explain the change for the Buyer (at least 10 characters).'
      request.delivery = {
        vehicles: choices.map((choice): DeliveryVehicleSelection => ({ vehicleId: choice.vehicleId, numberOfVehicles: choice.numberOfVehicles, totalVehicleTrips: choice.trips, groupKey: choice.key })),
        finalFeeCentavos: deliveryFee, fulfillmentDate: new Date(`${deliveryDate}T00:00:00`), arrangement: arrangement.trim(), accessConfirmed, heavyVehicleAccessConfirmed: heavyAccess,
        manualReviewNote: plan?.status === 'MANUAL_REVIEW_REQUIRED' ? manualNote.trim() : null,
        changeReason: recommendationChanged ? changeReason.trim() : null,
      }
    } else {
      if (!readyDate || readyDate < manilaToday()) local['pickup.ready_date'] = 'Choose a ready-for-pickup date from today onward.'
      request.pickup = { readyDate: new Date(`${readyDate}T00:00:00`) }
    }
    setErrors(local)
    return Object.keys(local).length ? null : request
  }

  async function submit() {
    const request = validate()
    setConfirmOpen(false)
    if (!request) { setMessage('Review the highlighted fields.'); return }
    setBusy(true); setMessage(null); setShortLines({})
    try {
      const next = await confirmOrder(order.id, request, idempotencyKey.current)
      idempotencyKey.current = newIdempotencyKey()
      onDone(next, changed || delivery ? 'Sent to the Buyer for approval. The confirmed stock is reserved.' : nrpcOn ? 'NRPC sent to the Buyer. The confirmed stock is reserved.' : 'Order confirmed and stock reserved. The Buyer has 24 hours to pay.')
    } catch (cause) {
      if (shouldRotateIdempotencyKey(cause)) idempotencyKey.current = newIdempotencyKey()
      const failure = await apiFailure(cause)
      setErrors(await orderFieldErrors(cause))
      if (failure?.code === 'STOCK_INSUFFICIENT' && Array.isArray(failure.details.lines)) {
        setShortLines(Object.fromEntries((failure.details.lines as { order_line_id: string; available_to_sell: string }[]).map(item => [item.order_line_id, item.available_to_sell])))
        setMessage('Available stock is lower than a confirmed quantity. Nothing was reserved. Lower the quantity to propose a revision.')
      } else if (failure?.code === 'STALE_VERSION' || failure?.code === 'ORDER_STATE_CONFLICT') {
        setMessage('This order changed since you opened it. Reloading the current version…'); onReload()
      } else setMessage(await readableOrderError(cause))
    } finally { setBusy(false) }
  }

  return <form className="grid min-w-0 gap-6" onSubmit={event => { event.preventDefault(); if (validate()) setConfirmOpen(true); else setMessage('Review the highlighted fields.') }} noValidate aria-labelledby="confirm-heading">
    <section className="grid gap-4 rounded-surface border border-border-default bg-surface-primary p-4 sm:p-5">
      <div><h2 id="confirm-heading" className="text-lg font-semibold">Confirm what you can supply</h2>
        <p className="mt-1 text-sm text-text-secondary">Prices come from the Buyer's request and never increase. Lowering a quantity or adding a discount sends a revision to the Buyer.{!permissions.canRevise && ' Your role can confirm the request as submitted or decline it; only the Owner, Store Manager or Store Staff can publish a revision.'}</p></div>
      {message && <StatusMessage tone="error">{message}</StatusMessage>}
      {errors.lines && <p className="text-sm text-status-error" role="alert">{errors.lines}</p>}
      <ul className="grid gap-3">{order.lines.map((line, index) => <li key={line.id} className="grid min-w-0 gap-3 border-t border-border-default pt-3 first:border-t-0 first:pt-0 md:grid-cols-[minmax(0,1fr)_12rem] md:items-start">
        <div className="grid min-w-0 gap-2"><LineIdentity line={line} />
          <p className="text-sm text-text-secondary">Requested <strong className="text-text-strong">{quantityText(line.requestedQuantity)} {line.unitName}</strong> at {formatPesoCentavos(line.unitPriceCentavos)} · {line.inventory ? <>Available now <strong className={Number(line.inventory.availableToSell) < Number(line.requestedQuantity) ? 'text-status-error' : 'text-text-strong'}>{quantityText(line.inventory.availableToSell)}</strong> ({quantityText(line.inventory.quantityOnHand)} on hand, {quantityText(line.inventory.hardReservedQuantity)} reserved)</> : 'Inventory hidden for your role'}</p>
          {shortLines[line.id] && <p className="text-sm font-semibold text-status-error" role="alert">Only {quantityText(shortLines[line.id])} {line.unitName} can be reserved now.</p>}
        </div>
        <Field label={`Confirmed quantity (${line.unitCode})`} name={`lines.${index}.confirmed_quantity`} inputMode="decimal" value={quantities[line.id] ?? ''} disabled={busy || !permissions.canRevise} error={errors[`lines.${index}.confirmed_quantity`]} onChange={event => setQuantities(current => ({ ...current, [line.id]: event.target.value }))} hint={permissions.canRevise ? 'Set 0 to remove the line.' : undefined} />
      </li>)}</ul>
      {permissions.canRevise && <VendorDiscountEditor discount={discount} fulfillmentMethod={order.fulfillmentMethod} preview={nrpcPayable} deliveryPending={delivery && (!plan || choices.length === 0)} disabled={busy} onChange={value => { setDiscount(value); setErrors(current => Object.fromEntries(Object.entries(current).filter(([field]) => field !== 'discount' && !field.startsWith('discount.')))) }} />}
      {errors.discount && <p className="text-sm text-status-error" role="alert">{errors.discount}</p>}
    </section>

    <section className="grid gap-4 rounded-surface border border-border-default bg-surface-primary p-4 sm:p-5" aria-labelledby="fulfillment-heading">
      <h2 id="fulfillment-heading" className="flex items-center gap-2 text-lg font-semibold">{delivery ? <Truck size={18} aria-hidden="true" /> : <Store size={18} aria-hidden="true" />}{delivery ? 'Delivery arrangement' : 'Ready-for-pickup date'}</h2>
      {!delivery && <div className="max-w-xs"><Field label="Ready for pickup on" name="pickup.ready_date" type="date" min={manilaToday()} value={readyDate} disabled={busy} error={errors['pickup.ready_date']} onChange={event => setReadyDate(event.target.value)} hint="Philippine date. Store hours stay informational." /></div>}
      {delivery && !permissions.canConfirmDelivery && <StatusMessage tone="error">Only the Owner or Store Manager can confirm the delivery vehicles, trips and fee for this order.</StatusMessage>}
      {delivery && permissions.canConfirmDelivery && <DeliveryPlanner plan={plan} busy={planBusy || busy} onLoad={() => void loadPlan()} choices={choices} setChoices={setChoices} fee={deliveryFee} errors={errors}
        date={deliveryDate} setDate={setDeliveryDate} arrangement={arrangement} setArrangement={setArrangement} access={accessConfirmed} setAccess={setAccessConfirmed} heavy={heavyAccess} setHeavy={setHeavyAccess} note={manualNote} setNote={setManualNote} recommendationChanged={recommendationChanged} changeReason={changeReason} setChangeReason={setChangeReason} />}
    </section>

    {canSetNrpc && <NrpcPreparationEditor enabled={nrpcOn} value={nrpcValues} materials={nrpcMaterials} reasonLimits={{ min: 10, max: 1000 }} disabled={busy} termsAvailable={order.nrpcTerms?.available} termsVersion={order.nrpcTerms?.version} errors={errors} onToggle={enabled => { setNrpcOn(enabled); setErrors(current => Object.fromEntries(Object.entries(current).filter(([field]) => !field.startsWith('nrpc.')))) }} onChange={value => {
      setNrpcReason(value.reason)
      setNrpcLines(value.allocations)
      setErrors(current => Object.fromEntries(Object.entries(current).filter(([field]) => !field.startsWith('nrpc.'))))
    }} />}

    <div className="flex flex-col gap-3 border-t border-border-default pt-5 sm:flex-row sm:items-center sm:justify-between">
      <p className="flex items-start gap-2 text-sm text-text-secondary"><CheckCircle2 size={16} className="mt-0.5 shrink-0 text-status-success" aria-hidden="true" />{nextStep}</p>
      <div className="flex flex-col-reverse gap-3 sm:flex-row">
        {permissions.canDecline && <Button variant="secondary" disabled={busy} onClick={() => setDeclineOpen(true)}>Decline request</Button>}
        <Button type="submit" disabled={busy || (delivery && !permissions.canConfirmDelivery)}>{busy ? 'Confirming…' : changed || delivery ? 'Send to Buyer for approval' : nrpcOn ? 'Confirm and send NRPC' : 'Confirm order'}</Button>
      </div>
    </div>
    <ConfirmDialog open={confirmOpen} tone="primary" title="Reserve stock and confirm?" confirmLabel={changed || delivery ? 'Send to Buyer' : 'Confirm order'} busy={busy} onCancel={() => setConfirmOpen(false)} onConfirm={() => void submit()}>
      <p>The confirmed quantities are reserved for this order now. {nextStep}</p>
      {delivery && <p className="mt-2">Delivery fee: <strong>{formatPesoCentavos(nrpcPayable.valid ? nrpcPayable.deliveryPayable : deliveryFee)}</strong>, after any delivery discount.</p>}
    </ConfirmDialog>
    <DeclineDialog open={declineOpen} order={order} onClose={() => setDeclineOpen(false)} onDone={onDone} />
  </form>
}

function DeliveryPlanner({ plan, busy, onLoad, choices, setChoices, fee, errors, date, setDate, arrangement, setArrangement, access, setAccess, heavy, setHeavy, note, setNote, recommendationChanged, changeReason, setChangeReason }: {
  plan: DeliveryPlan | null; busy: boolean; onLoad: () => void; choices: DeliveryChoice[]; setChoices: (next: DeliveryChoice[]) => void; fee: number; errors: Record<string, string>
  date: string; setDate: (value: string) => void; arrangement: string; setArrangement: (value: string) => void; access: boolean; setAccess: (value: boolean) => void
  heavy: boolean; setHeavy: (value: boolean) => void; note: string; setNote: (value: string) => void
  recommendationChanged: boolean; changeReason: string; setChangeReason: (value: string) => void
}) {
  const vehicles = useMemo(() => new Map((plan?.eligibleVehicles ?? []).map(vehicle => [vehicle.vehicleId, vehicle])), [plan])
  if (!plan) return <div className="grid justify-items-start gap-3">
    <p className="text-sm text-text-secondary">{busy ? 'Calculating the system recommendation and delivery fee…' : 'The delivery recommendation could not be loaded. Retry to confirm vehicles and trips.'}</p>
    <Button variant="secondary" disabled={busy} onClick={onLoad}><Truck size={16} aria-hidden="true" />{busy ? 'Loading options…' : 'Load vehicle options'}</Button>
    {errors.delivery && <p className="text-sm text-status-error" role="alert">{errors.delivery}</p>}
  </div>
  const update = (key: string, patch: Partial<DeliveryChoice>) => setChoices(choices.map(choice => choice.key === key ? { ...choice, ...patch } : choice))
  const anyHeavy = choices.some(choice => vehicles.get(choice.vehicleId)?.heavyClassification === 'HEAVY')
  return <div className="grid gap-5">
    <p className="text-sm text-text-secondary">Route {(plan.route.distanceMeters / 1000).toFixed(1)} km to the {plan.endpoint.kind === 'ALTERNATE_DROP_OFF' ? 'alternate drop-off' : 'intended destination'}. {plan.notice}</p>
    {plan.status === 'MANUAL_REVIEW_REQUIRED' && <StatusMessage tone="info">{plan.groups.some(group => group.manualReviewReasons.includes('UNIT_DIMENSIONS_REQUIRE_MANUAL_REVIEW')) ? 'The automatic dimension check could not confirm a fit. You can confirm the delivery manually: check the actual load, choose the vehicles and trips, and record how you will carry it.' : 'Some load measurements are missing. Review the load manually, choose vehicles and trips, and record your review.'}</StatusMessage>}
    {plan.groups.map(group => {
      const choice = choices.find(item => item.key === group.key)
      const options = deliveryPlanVehicleOptions(group)
      return <fieldset key={group.key} className="grid min-w-0 gap-3 border-t border-border-default pt-4">
        <legend className="text-sm font-semibold">{group.label}</legend>
        <div className="grid gap-2">{options.map(option => <label key={option.vehicleId} className={`flex min-h-11 min-w-0 cursor-pointer flex-wrap items-center gap-3 rounded-control border px-3 py-2 text-sm ${choice?.vehicleId === option.vehicleId ? 'border-action-primary bg-brand-orange-50' : 'border-border-default'}`}>
          <input type="radio" name={`vehicle-${group.key}`} className="h-4 w-4 accent-action-primary" disabled={busy} checked={choice?.vehicleId === option.vehicleId} onChange={() => {
            const next = deliveryChoice(group.key, option)
            setChoices(choice ? choices.map(item => item.key === group.key ? next : item) : [...choices, next])
          }} />
          <span className="min-w-0 flex-1"><span className="font-semibold">{option.name}</span>{option.recommended && <span className="block text-xs font-semibold text-action-primary">System recommendation · lowest eligible delivery fee</span>} <span className="text-text-secondary">{[option.brand, option.heavyClassification === 'HEAVY' ? 'Heavy vehicle' : null, option.mixerCapacityM3 ? `${quantityText(option.mixerCapacityM3)} m³ drum` : null].filter(Boolean).join(' · ')}</span>
            {option.volumePlan && <span className="block text-xs text-text-secondary">{option.volumePlan.fullTrips > 0 ? `${option.volumePlan.fullTrips} × ${option.volumePlan.fullLoadM3} m³ + ` : ''}{option.volumePlan.lastTripM3} m³ of {option.volumePlan.totalM3} m³</span>}</span>
          <span className="tabular-nums text-text-secondary">{formatPesoCentavos(option.perTripCentavos)} per trip{(option.mobilizationFeeCentavos ?? 0) > 0 && <> + {formatPesoCentavos(option.mobilizationFeeCentavos ?? 0)} mobilization {mobilizationLabel(option.mobilizationBasis)}</>}</span>
        </label>)}{options.length === 0 && <p className="text-sm text-status-error">No configured vehicle is eligible for this load and drop-off. Review your fleet or contact the Buyer.</p>}</div>
        {choice && <div className="grid gap-3 sm:grid-cols-2">
          <Field label="Vehicles used" name={`vehicles-${group.key}`} type="number" disabled={busy} min={1} max={vehicles.get(choice.vehicleId)?.numberAvailable ?? 1} value={choice.numberOfVehicles} onChange={event => update(group.key, { numberOfVehicles: Math.max(1, Number(event.target.value) || 1) })} />
          <Field label="Total trips" name={`trips-${group.key}`} type="number" disabled={busy} min={1} value={choice.trips} onChange={event => update(group.key, { trips: Math.max(1, Number(event.target.value) || 1) })} />
        </div>}
      </fieldset>
    })}
    <p className="text-sm">Delivery fee before discount: <strong className="tabular-nums">{formatPesoCentavos(fee)}</strong> <span className="text-text-secondary">(per-trip rate × trips{choices.some(choice => mobilizationTotal(choice) > 0) ? ', plus mixer mobilization' : ''}; the Buyer sees this before paying)</span></p>
    <div className="grid gap-4 sm:grid-cols-2">
      <Field label="Delivery date" name="delivery.fulfillment_date" type="date" min={manilaToday()} error={errors['delivery.fulfillment_date']} value={date} onChange={event => setDate(event.target.value)} />
    </div>
    <DeliveryArrangementFields disabled={busy} showHeavyAccess={anyHeavy} manualReviewRequired={plan.status === 'MANUAL_REVIEW_REQUIRED'} recommendationChanged={recommendationChanged} errors={errors} value={{ arrangement, accessConfirmed: access, heavyAccessConfirmed: heavy, manualReviewNote: note, ...(recommendationChanged ? { changeReason } : {}) }} onChange={patch => {
      if (patch.changeReason !== undefined) setChangeReason(patch.changeReason)
      if (patch.arrangement !== undefined) setArrangement(patch.arrangement)
      if (patch.accessConfirmed !== undefined) setAccess(patch.accessConfirmed)
      if (patch.heavyAccessConfirmed !== undefined) setHeavy(patch.heavyAccessConfirmed)
      if (patch.manualReviewNote !== undefined) setNote(patch.manualReviewNote)
    }} />
  </div>
}

function DeclineDialog({ open, order, onClose, onDone }: { open: boolean; order: OrderDetail; onClose: () => void; onDone: (order: OrderDetail, message: string) => void }) {
  const [code, setCode] = useState<VendorOrderDeclineReason>('STOCK_UNAVAILABLE')
  const [reason, setReason] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  async function decline() {
    if (reason.trim().length < 5) { setError('Give the Buyer a short reason (at least 5 characters).'); return }
    setBusy(true); setError(null)
    try { onDone(await declineOrder(order.id, order.lockVersion, code, reason.trim()), 'Request declined. The Buyer was notified and nothing was reserved.'); onClose() }
    catch (cause) { setError(await readableOrderError(cause)) } finally { setBusy(false) }
  }
  return <ConfirmDialog open={open} title="Decline this request?" confirmLabel="Decline request" busy={busy} onCancel={onClose} onConfirm={() => void decline()}>
    <div className="grid gap-3 text-text-strong">
      <p className="text-text-secondary">The Buyer is told the reason. Nothing is charged and no stock was reserved.</p>
      <label className="grid gap-2 text-sm font-semibold">Reason<select className={control} value={code} onChange={event => setCode(event.target.value as VendorOrderDeclineReason)}>{(order.declineReasons ?? []).map(item => <option key={item} value={item}>{DECLINE_LABELS[item] ?? item}</option>)}</select></label>
      <label className="grid gap-2 text-sm font-semibold">Message to the Buyer<textarea className={`${control} min-h-20 py-2`} value={reason} maxLength={1000} onChange={event => setReason(event.target.value)} /></label>
      {error && <p className="text-sm text-status-error" role="alert">{error}</p>}
    </div>
  </ConfirmDialog>
}

// ── Side panels ─────────────────────────────────────────────────────────────────────────────────

function DestinationPanel({ order }: { order: OrderDetail }) {
  const destination = order.destination
  const confirmed = order.delivery.confirmed
  return <section aria-labelledby="destination-heading" className="grid gap-3 rounded-surface border border-border-default bg-surface-primary p-4">
    <h2 id="destination-heading" className="flex items-center gap-2 text-base font-semibold"><MapPin size={16} aria-hidden="true" />{order.fulfillmentMethod === 'DELIVERY' ? 'Delivery' : 'Pickup'}</h2>
    {destination?.type === 'PICKUP' && <p className="text-sm">Buyer collects at your store{destination.storeAddress ? `: ${destination.storeAddress}` : ''}.</p>}
    {destination?.type === 'DELIVERY' && <dl className="grid gap-3 text-sm">
      <div><dt className="text-xs text-text-secondary">Intended destination / Project site</dt><dd className="font-semibold">{destination.intended?.label ?? '—'}</dd><dd className="text-text-secondary">{destination.intended?.formattedAddress}</dd></div>
      {destination.alternateDropOff && <div><dt className="text-xs text-text-secondary">Actual vehicle drop-off (heavy-vehicle restriction)</dt><dd className="font-semibold">{destination.alternateDropOff.label}</dd><dd className="text-text-secondary">{destination.alternateDropOff.formattedAddress}</dd></div>}
      {destination.accessInstructions && <div><dt className="text-xs text-text-secondary">Access instructions</dt><dd>{destination.accessInstructions}</dd></div>}
    </dl>}
    {order.delivery.estimate?.options?.length ? <div className="grid gap-1 border-t border-border-default pt-3 text-sm"><h3 className="font-semibold">System recommendation</h3>{order.delivery.estimate.options.map((option, index) => <p key={index}>{option.vehicleName} · {option.vehicles} vehicle(s), {option.trips} trip(s) · {formatPesoCentavos(option.feeCentavos)}</p>)}<p className="text-xs text-text-secondary">Estimated fee; the Vendor confirms and the Buyer approves before paying.</p></div> : null}
    {confirmed && <dl className="grid gap-2 border-t border-border-default pt-3 text-sm">
      <div><dt className="text-xs text-text-secondary">Confirmed vehicles</dt>{confirmed.vehicles.map((vehicle, index) => <dd key={index} className="font-semibold">{vehicle.name} · {vehicle.numberOfVehicles} vehicle{vehicle.numberOfVehicles === 1 ? '' : 's'}, {vehicle.totalVehicleTrips} trip{vehicle.totalVehicleTrips === 1 ? '' : 's'}</dd>)}</div>
      <div><dt className="text-xs text-text-secondary">Route</dt><dd>{(confirmed.distanceMeters / 1000).toFixed(1)} km to the {confirmed.endpoint === 'ALTERNATE_DROP_OFF' ? 'alternate drop-off' : 'intended destination'}</dd></div>
      <div><dt className="text-xs text-text-secondary">Final delivery fee</dt><dd className="font-semibold tabular-nums">{formatPesoCentavos(confirmed.finalFeeCentavos)}</dd></div>
      {confirmed.arrangement && <div><dt className="text-xs text-text-secondary">Arrangement</dt><dd>{confirmed.arrangement}</dd></div>}
      {confirmed.changeReason && <div><dt className="text-xs text-text-secondary">Explanation shown to the Buyer</dt><dd>{confirmed.changeReason}</dd></div>}
    </dl>}
    {order.fulfillmentMethod === 'DELIVERY' && !confirmed && order.delivery.estimate && <p className="text-sm text-text-secondary">Buyer's advisory estimate: {formatPesoCentavos(order.delivery.estimate.feeMinCentavos)}{order.delivery.estimate.feeMaxCentavos !== order.delivery.estimate.feeMinCentavos ? ` – ${formatPesoCentavos(order.delivery.estimate.feeMaxCentavos)}` : ''}. Not a confirmation.</p>}
  </section>
}

function NrpcSummary({ order }: { order: OrderDetail }) {
  const nrpc = order.nrpc
  if (!nrpc) return null
  return <section aria-labelledby="nrpc-summary-heading" className="grid gap-2 rounded-surface border border-border-default bg-surface-primary p-4 text-sm">
    <h2 id="nrpc-summary-heading" className="text-base font-semibold">NRPC</h2>
    <p><strong className="tabular-nums">{formatPesoCentavos(nrpc.amountCentavos)}</strong> · {nrpc.status === 'ACCEPTED' ? `Accepted ${formatManilaDateTime(nrpc.acceptedAt)}` : nrpc.status === 'REJECTED' ? 'Rejected by the Buyer' : 'Waiting for the Buyer'}</p>
    <p className="text-text-secondary">{nrpc.reason}</p>
    {nrpc.flag && <p className="flex items-start gap-2 font-semibold text-amber-900"><ShieldAlert size={16} className="mt-0.5 shrink-0" aria-hidden="true" />The Buyer flagged this NRPC for review. Their acceptance is recorded separately.</p>}
  </section>
}

function AutoAcceptPanelView({ order }: { order: OrderDetail }) {
  const outcome = order.autoAccept
  if (!outcome?.accepted) return null
  return <section aria-labelledby="auto-heading" className="grid gap-2 rounded-surface border border-border-default bg-surface-primary p-4 text-sm">
    <h2 id="auto-heading" className="flex items-center gap-2 text-base font-semibold"><Bot size={16} aria-hidden="true" />Auto-accepted</h2>
    <p>All lines met the auto-accept allotment and safeguards; stock was reserved automatically.</p>
  </section>
}
