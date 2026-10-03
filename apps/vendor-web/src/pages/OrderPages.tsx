import { WorkPackageAttachment } from '../components/WorkPackageAttachment'
import { useCallback, useEffect, useMemo, useRef, useState, type FormEvent, type ReactNode } from 'react'
import { Link, useParams, useSearchParams } from 'react-router-dom'
import { ArrowLeft, Bot, CheckCircle2, ClipboardList, Hand, MapPin, PackageSearch, Search, ShieldAlert, Store, Truck } from 'lucide-react'
import {
  Button, ConfirmDialog, DeadlineCountdown, Field, FilterChips, MoneyBreakdown, OrderStateRows, ResponsiveRecordList, StatusBadge, StatusMessage,
  formatManilaDateTime, formatPesoCentavos, orderStateLabel, orderStateTone, type RecordColumn,
} from '@materyalph/web-ui'
import {
  apiFailure, confirmOrder, declineOrder, getDeliveryPlan, getOrder, listOrders, pesoInputToCentavos, quantityText, readableOrderError,
  type DeliveryPlan, type DeliveryVehicleSelection, type OrderDetail, type OrderGroup, type OrderLine, type OrderListMeta, type OrderSummary, type VendorOrderConfirmRequest, type VendorOrderDeclineReason,
} from '../lib/orders-api'
import { newIdempotencyKey } from '../lib/onboarding-api'
import { storeName } from '../lib/catalog-access'
import { useOnboardingSnapshot } from '../lib/vendor-status'
import { ErrorState, LoadingState, PageHeader, VendorShell } from './PhaseThreeVendorPages'
import { OrderPaymentPanel } from './OrderPaymentPanel'
import { CancellationPanel, FulfillmentWorkspace, RefundsPanel } from './OrderFulfillmentPanels'

const GROUPS: { value: OrderGroup; label: string }[] = [
  { value: 'NEW', label: 'New requests' }, { value: 'WAITING_ON_BUYER', label: 'Waiting on Buyer' }, { value: 'AWAITING_PAYMENT', label: 'Awaiting payment' },
  { value: 'CONFIRMED', label: 'Confirmed' }, { value: 'CLOSED', label: 'Closed' }, { value: 'ALL', label: 'All' },
]
const EMPTY: Record<OrderGroup, string> = {
  NEW: 'No new requests. New Item-Based order requests appear here with a 24-hour response window.',
  WAITING_ON_BUYER: 'Nothing is waiting on a Buyer decision.', AWAITING_PAYMENT: 'No confirmed orders are waiting for payment.',
  CONFIRMED: 'No confirmed orders yet.', CLOSED: 'No completed, declined, expired or cancelled orders yet.', ALL: 'No orders yet. Orders appear once Buyers submit requests for your listings.',
}
const DECLINE_LABELS: Record<string, string> = { STOCK_UNAVAILABLE: 'Stock unavailable', OPERATIONAL_INABILITY: 'Operational inability', DELIVERY_INABILITY: 'Cannot deliver', COMPLIANCE_RESTRICTION: 'Compliance restriction', BUYER_AGREEMENT: 'Agreed with the Buyer', OTHER: 'Other' }
const control = 'min-h-12 w-full min-w-0 rounded-control border border-border-default bg-surface-primary px-3 text-base font-normal'
const manilaToday = () => new Intl.DateTimeFormat('en-CA', { timeZone: 'Asia/Manila' }).format(new Date())

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
  return <OrderAccessGate activeHref="/orders">{() => <OrdersWorkspace />}</OrderAccessGate>
}

function OrdersWorkspace() {
  const [searchParams, setSearchParams] = useSearchParams()
  const group = (searchParams.get('group') ?? 'NEW') as OrderGroup
  const q = searchParams.get('q') ?? ''
  const page = Math.max(1, Number(searchParams.get('page') ?? '1') || 1)
  const [query, setQuery] = useState(q)
  const [rows, setRows] = useState<OrderSummary[]>([])
  const [meta, setMeta] = useState<OrderListMeta | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  const request = useRef(0)
  const setParams = (patch: Record<string, string>) => setSearchParams(current => {
    const next = new URLSearchParams(current)
    for (const [key, value] of Object.entries(patch)) { if (value) next.set(key, value); else next.delete(key) }
    if (!('page' in patch)) next.delete('page')
    return next
  }, { replace: true })

  useEffect(() => {
    const id = ++request.current
    setLoading(true); setError(null)
    listOrders({ group, q, page }).then(result => { if (id === request.current) { setRows(result.items); setMeta(result.meta) } })
      .catch(async cause => { const text = await readableOrderError(cause); if (id === request.current) setError(text) })
      .finally(() => { if (id === request.current) setLoading(false) })
  }, [group, q, page, attempt])

  const columns: RecordColumn<OrderSummary>[] = [
    { key: 'order', header: 'Order', cell: row => <OrderIdentity row={row} /> },
    { key: 'buyer', header: 'Buyer', cell: row => row.buyer?.displayName ?? '—' },
    { key: 'source', header: 'Type · source', cell: row => <span className="inline-flex flex-wrap items-center gap-1.5">{row.procurementType === 'PROJECT_BASED' ? 'Project-Based' : 'Item-Based'} · {row.confirmationSource === 'AUTO_ACCEPT' ? <span className="inline-flex items-center gap-1 font-semibold"><Bot size={14} aria-hidden="true" />Auto-accepted</span> : row.confirmationSource === 'MANUAL' ? 'Manual' : 'Awaiting review'}</span> },
    { key: 'status', header: 'Status', cell: row => <StatusStack row={row} /> },
    { key: 'deadline', header: 'Deadline', cell: row => row.deadline ? <span className="grid gap-0.5"><span className="font-semibold">{row.deadline.kind === 'VENDOR_RESPONSE' ? 'Your response' : row.deadline.kind === 'BUYER_RESPONSE' ? 'Buyer response' : 'Payment'}</span><span className="text-xs text-text-secondary">{formatManilaDateTime(row.deadline.at)}</span></span> : <span className="text-text-secondary">—</span> },
    { key: 'total', header: 'Total', cell: row => <span className="grid gap-0.5"><span className="font-semibold tabular-nums">{formatPesoCentavos(row.commercialTotalCentavos)}</span>{row.deliveryPending && <span className="text-xs text-text-secondary">+ delivery to confirm</span>}{row.nrpcIndicator && <span className="text-xs font-semibold text-amber-900">Includes NRPC</span>}</span> },
    { key: 'action', header: 'Action', cell: row => <ActionLink row={row} /> },
  ]
  const chips = GROUPS.map(item => ({ value: item.value, label: item.label, count: meta?.counts[item.value] }))

  return <div className="grid min-w-0 gap-6">
    <PageHeader eyebrow="Store Operations" title="Orders" description="Review Item-Based order requests, confirm or revise them within 24 hours, and follow each order's separate order, payment, fulfillment, refund and dispute status." />
    <div className="flex min-w-0 flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
      <FilterChips label="Filter orders by status" chips={chips} value={group} disabled={loading} onChange={value => setParams({ group: value })} />
      <form role="search" className="flex min-w-0 gap-2 lg:w-96" onSubmit={(event: FormEvent) => { event.preventDefault(); setParams({ q: query.trim() }) }}>
        <label htmlFor="order-search" className="sr-only">Search by Order ID or Buyer</label>
        <input id="order-search" className={control} value={query} onChange={event => setQuery(event.target.value)} placeholder="Order ID or Buyer name" maxLength={120} />
        <Button type="submit" variant="secondary" aria-label="Search orders"><Search size={16} aria-hidden="true" /></Button>
      </form>
    </div>
    {error ? <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} />
      : loading && rows.length === 0 ? <div className="grid gap-3" aria-busy="true" aria-label="Loading orders">{[0, 1, 2].map(index => <div key={index} className="h-20 animate-pulse rounded-surface bg-surface-canvas motion-reduce:animate-none" />)}</div>
        : rows.length === 0 ? <EmptyOrders text={q ? `No orders match “${q}”.` : EMPTY[group]} />
          : <div aria-busy={loading}>
            <ResponsiveRecordList caption={`${GROUPS.find(item => item.value === group)?.label ?? 'Orders'}`} rows={rows} columns={columns} rowKey={row => row.id} cardTitle={row => <OrderIdentity row={row} />} cardAction={row => <ActionLink row={row} />} />
            {meta && meta.total > meta.perPage && <nav aria-label="Order pages" className="mt-4 flex flex-wrap items-center justify-between gap-3 text-sm">
              <span className="text-text-secondary">Page {meta.page} of {Math.ceil(meta.total / meta.perPage)} · {meta.total} orders</span>
              <span className="flex gap-2"><Button variant="secondary" disabled={page <= 1} onClick={() => setParams({ page: String(page - 1) })}>Previous</Button><Button variant="secondary" disabled={!meta.hasMore} onClick={() => setParams({ page: String(page + 1) })}>Next</Button></span>
            </nav>}
          </div>}
  </div>
}

function OrderIdentity({ row }: { row: OrderSummary }) {
  return <span className="grid min-w-0 gap-0.5">
    <Link to={`/orders/${row.id}`} className="font-semibold text-action-primary underline-offset-4 hover:underline">{row.reference}</Link>
    <span className="text-xs text-text-secondary">{row.firstLine.displayName}{row.lineCount > 1 ? ` + ${row.lineCount - 1} more` : ''}</span>
    <span className="text-xs text-text-secondary">Requested {formatManilaDateTime(row.submittedAt)}</span>
  </span>
}

function StatusStack({ row }: { row: OrderSummary }) {
  const order = stateOf(row.states, 'ORDER')
  const payment = stateOf(row.states, 'PAYMENT')
  const refund = stateOf(row.states, 'REFUND')
  return <span className="grid justify-items-start gap-1">
    <StatusBadge label={orderStateLabel(order)} tone={orderStateTone(order)} />
    <span className="text-xs text-text-secondary">Payment: {orderStateLabel(payment)}{refund !== 'NOT_REQUESTED' ? ` · Refund: ${orderStateLabel(refund)}` : ''}</span>
  </span>
}

function ActionLink({ row }: { row: OrderSummary }) {
  const confirm = row.primaryAction === 'CONFIRM'
  return <Link to={`/orders/${row.id}`} className={`inline-flex min-h-11 items-center justify-center gap-2 rounded-control px-4 text-sm font-semibold ${confirm ? 'bg-action-primary text-white hover:bg-action-primary-pressed' : 'border border-border-default bg-surface-primary text-text-strong hover:bg-surface-canvas'}`}>
    {confirm ? 'Review request' : 'View order'}
  </Link>
}

function EmptyOrders({ text }: { text: string }) {
  return <div className="grid justify-items-center gap-3 rounded-surface border border-dashed border-border-default bg-surface-primary px-6 py-12 text-center">
    <ClipboardList size={28} className="text-action-primary" aria-hidden="true" />
    <p className="max-w-md text-sm text-text-secondary">{text}</p>
  </div>
}

// ── Detail ──────────────────────────────────────────────────────────────────────────────────────

export function VendorOrderDetailPage() {
  const { orderId = '' } = useParams()
  return <OrderAccessGate activeHref="/orders">{() => <OrderDetailWorkspace orderId={orderId} />}</OrderAccessGate>
}

function OrderDetailWorkspace({ orderId }: { orderId: string }) {
  const [order, setOrder] = useState<OrderDetail | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [notice, setNotice] = useState<{ tone: 'success' | 'error' | 'info'; text: string } | null>(null)
  const [attempt, setAttempt] = useState(0)
  const load = useCallback(() => setAttempt(value => value + 1), [])
  useEffect(() => {
    let active = true
    setError(null)
    getOrder(orderId).then(loaded => { if (active) setOrder(loaded) }).catch(async cause => { const text = await readableOrderError(cause); if (active) setError(text) })
    return () => { active = false }
  }, [orderId, attempt])

  if (error) return <div className="grid gap-4"><BackLink /><ErrorState message={error} onRetry={load} /></div>
  if (!order) return <div className="grid gap-4"><BackLink /><LoadingState label="Loading order…" /></div>
  const orderState = stateOf(order.states, 'ORDER')
  const inFulfillment = Boolean(order.acceptedAt) && !['AWAITING_VENDOR_CONFIRMATION', 'AWAITING_BUYER_APPROVAL', 'AWAITING_NRPC_ACCEPTANCE', 'AWAITING_PAYMENT', 'DECLINED', 'EXPIRED'].includes(orderState)
  const changed = (next: OrderDetail, text: string) => { setOrder(next); setNotice({ tone: 'success', text }) }
  const deadline = orderState === 'AWAITING_VENDOR_CONFIRMATION' ? { at: order.deadlines.vendorResponseDueAt, label: 'Respond within' }
    : orderState === 'AWAITING_BUYER_APPROVAL' || orderState === 'AWAITING_NRPC_ACCEPTANCE' ? { at: order.deadlines.buyerResponseDueAt, label: 'Buyer decides within' }
      : orderState === 'AWAITING_PAYMENT' ? { at: order.deadlines.paymentExpiresAt, label: 'Payment window' } : null

  return <div className="grid min-w-0 gap-6">
    <BackLink />
    <PageHeader eyebrow="Job order" title={order.reference} status={orderState} description={primaryDescription(order)} />
    <dl className="flex min-w-0 flex-wrap gap-x-8 gap-y-2 border-b border-border-default pb-5 text-sm">
      <Meta label="Buyer" value={order.buyer?.displayName ?? '—'} />
      <Meta label="Requested" value={formatManilaDateTime(order.submittedAt)} />
      <Meta label="Fulfillment" value={order.fulfillmentMethod === 'DELIVERY' ? 'Site Delivery' : 'Self-Pickup'} />
      <Meta label="Payment method" value={order.paymentMethod === 'ONLINE' ? 'Online payment' : order.paymentMethod === 'CASH_ON_DELIVERY' ? 'Cash on Delivery' : 'In-Store Payment'} />
      <Meta label="Source" value={order.confirmationSource === 'AUTO_ACCEPT' ? 'Auto-accepted' : order.confirmationSource === 'MANUAL' ? 'Manual confirmation' : 'Manual review'} />
      {order.expectedFulfillmentDate && <Meta label={order.fulfillmentMethod === 'DELIVERY' ? 'Delivery date' : 'Ready for pickup'} value={String(order.expectedFulfillmentDate).slice(0, 10)} />}
    </dl>
    {deadline?.at && <DeadlineCountdown at={deadline.at} label={deadline.label} onExpire={load} />}
    {notice && <StatusMessage tone={notice.tone}>{notice.text}</StatusMessage>}
    {order.projectContext && <><WorkPackageAttachment reference={order.projectContext} />{order.projectContext.note != null && <StatusMessage tone="info">Informational Note: {String(order.projectContext.note)} · No response required</StatusMessage>}</>}
    <div className="grid min-w-0 gap-6 xl:grid-cols-[minmax(0,1fr)_22rem]">
      <div className="grid min-w-0 content-start gap-6">
        {order.primaryAction === 'CONFIRM' && order.permissions?.canConfirm
          ? <ConfirmationWorkspace order={order} onDone={(next, text) => { setOrder(next); setNotice({ tone: 'success', text }) }} onReload={load} />
          : <LinesPanel order={order} />}
        {order.primaryAction === 'CONFIRM' && !order.permissions?.canConfirm && <StatusMessage tone="error">Your role can view this request but cannot confirm or decline it.</StatusMessage>}
        {inFulfillment && <FulfillmentWorkspace order={order} onChanged={changed} onReload={load} />}
        {order.autoAccept && <AutoAcceptPanelView order={order} />}
        <TimelinePanel order={order} />
      </div>
      <aside className="grid min-w-0 content-start gap-6" aria-label="Order summary">
        <section aria-labelledby="status-heading" className="grid gap-2"><h2 id="status-heading" className="text-base font-semibold">Status</h2><OrderStateRows states={order.states} /></section>
        <div className="rounded-surface border border-border-default bg-surface-primary p-4"><MoneyBreakdown money={order.money} title="Buyer payment breakdown" /><p className="mt-3 border-t border-border-default pt-3 text-xs text-text-secondary">The Buyer total never includes your 2% monthly commission or merchant withholding; those are settled separately.</p></div>
        <OrderPaymentPanel order={order} onChanged={load} />
        <CancellationPanel order={order} onChanged={changed} />
        <RefundsPanel order={order} onChanged={changed} />
        <DestinationPanel order={order} />
        {order.nrpc && <NrpcSummary order={order} />}
      </aside>
    </div>
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

function BackLink() {
  return <Link to="/orders" className="inline-flex min-h-11 w-fit items-center gap-2 text-sm font-semibold text-text-secondary hover:text-text-strong"><ArrowLeft size={16} aria-hidden="true" />All orders</Link>
}

function Meta({ label, value }: { label: string; value: string }) {
  return <div className="min-w-0"><dt className="text-xs text-text-secondary">{label}</dt><dd className="font-semibold text-text-strong">{value}</dd></div>
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

type DeliveryChoice = { key: string; vehicleId: string; numberOfVehicles: number; trips: number; perTrip: number }

function ConfirmationWorkspace({ order, onDone, onReload }: { order: OrderDetail; onDone: (order: OrderDetail, message: string) => void; onReload: () => void }) {
  const permissions = order.permissions ?? { canConfirm: false, canRevise: false, canSetNrpc: false, canConfirmDelivery: false, canDecline: false, canViewInventory: false }
  const [quantities, setQuantities] = useState<Record<string, string>>(() => Object.fromEntries(order.lines.map(line => [line.id, quantityText(line.requestedQuantity)])))
  const [discount, setDiscount] = useState('')
  const [nrpcOn, setNrpcOn] = useState(false)
  const [nrpcReason, setNrpcReason] = useState('')
  const [nrpcLines, setNrpcLines] = useState<Record<string, string>>({})
  const [readyDate, setReadyDate] = useState(() => manilaToday())
  const [plan, setPlan] = useState<DeliveryPlan | null>(null)
  const [planBusy, setPlanBusy] = useState(false)
  const [choices, setChoices] = useState<DeliveryChoice[]>([])
  const [deliveryDate, setDeliveryDate] = useState(() => manilaToday())
  const [arrangement, setArrangement] = useState('')
  const [accessConfirmed, setAccessConfirmed] = useState(false)
  const [heavyAccess, setHeavyAccess] = useState(false)
  const [manualNote, setManualNote] = useState('')
  const [errors, setErrors] = useState<Record<string, string>>({})
  const [message, setMessage] = useState<string | null>(null)
  const [shortLines, setShortLines] = useState<Record<string, string>>({})
  const [confirmOpen, setConfirmOpen] = useState(false)
  const [declineOpen, setDeclineOpen] = useState(false)
  const [busy, setBusy] = useState(false)
  const idempotencyKey = useRef(newIdempotencyKey())
  const delivery = order.fulfillmentMethod === 'DELIVERY'

  const changed = order.lines.some(line => quantityText(line.requestedQuantity) !== (quantities[line.id] ?? '').trim()) || (pesoInputToCentavos(discount || '0') ?? 0) > 0
  const nrpcTotal = Object.values(nrpcLines).reduce((sum, value) => sum + (pesoInputToCentavos(value || '0') ?? 0), 0)
  const deliveryFee = choices.reduce((sum, choice) => sum + choice.perTrip * choice.trips, 0)
  const nextStep = changed || delivery ? 'The Buyer reviews and approves this version within 24 hours before paying.' : nrpcOn ? 'The Buyer reviews and accepts the NRPC within 24 hours before paying.' : 'The order becomes payable right away with a 24-hour payment window.'

  async function loadPlan() {
    setPlanBusy(true); setMessage(null)
    try {
      const next = await getDeliveryPlan(order.id, order.lines.map(line => ({ orderLineId: line.id, confirmedQuantity: (quantities[line.id] ?? '0').trim() || '0' })))
      setPlan(next)
      setChoices(next.groups.flatMap(group => { const first = group.candidates[0]; return first ? [{ key: group.key, vehicleId: first.vehicleId, numberOfVehicles: first.numberOfVehicles ?? 1, trips: first.totalVehicleTrips ?? 1, perTrip: first.perTripCentavos }] : [] }))
    } catch (cause) { setMessage(await readableOrderError(cause)) } finally { setPlanBusy(false) }
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
    const discountCentavos = discount.trim() === '' ? 0 : pesoInputToCentavos(discount)
    if (discountCentavos === null) local.vendor_discount_centavos = 'Enter a discount in pesos, e.g. 100.00.'
    const request: VendorOrderConfirmRequest = { lockVersion: order.lockVersion, lines, vendorDiscountCentavos: discountCentavos ?? 0 }
    if (nrpcOn) {
      if (nrpcReason.trim().length < 10) local['nrpc.reason'] = 'Describe the irreversible preparation in at least 10 characters.'
      const allocations = Object.entries(nrpcLines).map(([orderLineId, value]) => ({ orderLineId, principalCentavos: pesoInputToCentavos(value || '0') ?? -1 })).filter(item => item.principalCentavos !== 0)
      if (allocations.length === 0 || allocations.some(item => item.principalCentavos < 0)) local['nrpc.lines'] = 'Enter the NRPC amount for each prepared line.'
      request.nrpc = { amountCentavos: nrpcTotal, reason: nrpcReason.trim(), lines: allocations }
    }
    if (delivery) {
      if (!plan || choices.length === 0) local.delivery = 'Load the vehicle options and choose the vehicles and trips.'
      if (!accessConfirmed) local['delivery.access_confirmed'] = 'Confirm the drop-off is accessible for the chosen vehicles.'
      if (arrangement.trim().length < 5) local['delivery.arrangement'] = 'Describe the delivery arrangement for the Buyer.'
      if (plan?.status === 'MANUAL_REVIEW_REQUIRED' && manualNote.trim().length < 10) local['delivery.manual_review_note'] = 'Record your manual load review (at least 10 characters).'
      request.delivery = {
        vehicles: choices.map((choice): DeliveryVehicleSelection => ({ vehicleId: choice.vehicleId, numberOfVehicles: choice.numberOfVehicles, totalVehicleTrips: choice.trips, groupKey: choice.key })),
        finalFeeCentavos: deliveryFee, fulfillmentDate: new Date(`${deliveryDate}T00:00:00Z`), arrangement: arrangement.trim(), accessConfirmed, heavyVehicleAccessConfirmed: heavyAccess,
        manualReviewNote: plan?.status === 'MANUAL_REVIEW_REQUIRED' ? manualNote.trim() : null,
      }
    } else {
      if (!readyDate || readyDate < manilaToday()) local['pickup.ready_date'] = 'Choose a ready-for-pickup date from today onward.'
      request.pickup = { readyDate: new Date(`${readyDate}T00:00:00Z`) }
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
      idempotencyKey.current = newIdempotencyKey()
      const failure = await apiFailure(cause)
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
      {permissions.canRevise && <div className="max-w-xs"><Field label="Order discount (₱, optional)" name="vendor_discount_centavos" inputMode="decimal" value={discount} disabled={busy} error={errors.vendor_discount_centavos} onChange={event => setDiscount(event.target.value)} hint="Spread across lines by value before VAT." /></div>}
    </section>

    <section className="grid gap-4 rounded-surface border border-border-default bg-surface-primary p-4 sm:p-5" aria-labelledby="fulfillment-heading">
      <h2 id="fulfillment-heading" className="flex items-center gap-2 text-lg font-semibold">{delivery ? <Truck size={18} aria-hidden="true" /> : <Store size={18} aria-hidden="true" />}{delivery ? 'Delivery arrangement' : 'Ready-for-pickup date'}</h2>
      {!delivery && <div className="max-w-xs"><Field label="Ready for pickup on" name="pickup.ready_date" type="date" min={manilaToday()} value={readyDate} disabled={busy} error={errors['pickup.ready_date']} onChange={event => setReadyDate(event.target.value)} hint="Philippine date. Store hours stay informational." /></div>}
      {delivery && !permissions.canConfirmDelivery && <StatusMessage tone="error">Only the Owner or Store Manager can confirm the delivery vehicles, trips and fee for this order.</StatusMessage>}
      {delivery && permissions.canConfirmDelivery && <DeliveryPlanner plan={plan} busy={planBusy || busy} onLoad={() => void loadPlan()} choices={choices} setChoices={setChoices} fee={deliveryFee} errors={errors}
        date={deliveryDate} setDate={setDeliveryDate} arrangement={arrangement} setArrangement={setArrangement} access={accessConfirmed} setAccess={setAccessConfirmed} heavy={heavyAccess} setHeavy={setHeavyAccess} note={manualNote} setNote={setManualNote} />}
    </section>

    {permissions.canSetNrpc && <section className="grid gap-4 rounded-surface border border-border-default bg-surface-primary p-4 sm:p-5" aria-labelledby="nrpc-heading">
      <div className="flex flex-wrap items-start justify-between gap-3">
        <div><h2 id="nrpc-heading" className="text-lg font-semibold">Non-Recoverable Preparation Cost (optional)</h2>
          <p className="mt-1 max-w-2xl text-sm text-text-secondary">Only for actual irreversible preparation such as cutting or mixing. It is part of the order value, never added on top, and the Buyer must accept it{order.nrpcTerms ? ` under NRPC Terms v${order.nrpcTerms.version}` : ''} before paying. Orders with NRPC are never auto-accepted.</p></div>
        <label className="inline-flex min-h-11 items-center gap-2 text-sm font-semibold"><input type="checkbox" className="h-5 w-5 accent-action-primary" checked={nrpcOn} disabled={busy || order.nrpcTerms?.available === false} onChange={event => setNrpcOn(event.target.checked)} />Propose an NRPC</label>
      </div>
      {nrpcOn && <div className="grid gap-4">
        <label className="grid gap-2 text-sm font-semibold">Reason for the NRPC<textarea className={`${control} min-h-24 py-2`} value={nrpcReason} maxLength={1000} disabled={busy} aria-invalid={Boolean(errors['nrpc.reason'])} aria-describedby={errors['nrpc.reason'] ? 'nrpc-reason-error' : undefined} onChange={event => setNrpcReason(event.target.value)} /></label>
        {errors['nrpc.reason'] && <p id="nrpc-reason-error" className="-mt-2 text-sm text-status-error">{errors['nrpc.reason']}</p>}
        <div className="grid gap-3 md:grid-cols-2">{order.lines.map(line => <Field key={line.id} label={`${line.displayName} — NRPC (₱)`} name={`nrpc.${line.id}`} inputMode="decimal" value={nrpcLines[line.id] ?? ''} disabled={busy} onChange={event => setNrpcLines(current => ({ ...current, [line.id]: event.target.value }))} hint={`Up to that line's payable value, ${formatPesoCentavos(line.lineTotalCentavos)}.`} />)}</div>
        {errors['nrpc.lines'] && <p className="text-sm text-status-error" role="alert">{errors['nrpc.lines']}</p>}
        <p className="text-sm font-semibold">NRPC total: <span className="tabular-nums">{formatPesoCentavos(nrpcTotal)}</span></p>
      </div>}
    </section>}

    <div className="flex flex-col gap-3 border-t border-border-default pt-5 sm:flex-row sm:items-center sm:justify-between">
      <p className="flex items-start gap-2 text-sm text-text-secondary"><CheckCircle2 size={16} className="mt-0.5 shrink-0 text-status-success" aria-hidden="true" />{nextStep}</p>
      <div className="flex flex-col-reverse gap-3 sm:flex-row">
        {permissions.canDecline && <Button variant="secondary" disabled={busy} onClick={() => setDeclineOpen(true)}>Decline request</Button>}
        <Button type="submit" disabled={busy || (delivery && !permissions.canConfirmDelivery)}>{busy ? 'Confirming…' : changed || delivery ? 'Send to Buyer for approval' : nrpcOn ? 'Confirm and send NRPC' : 'Confirm order'}</Button>
      </div>
    </div>
    <ConfirmDialog open={confirmOpen} tone="primary" title="Reserve stock and confirm?" confirmLabel={changed || delivery ? 'Send to Buyer' : 'Confirm order'} busy={busy} onCancel={() => setConfirmOpen(false)} onConfirm={() => void submit()}>
      <p>The confirmed quantities are reserved for this order now. {nextStep}</p>
      {delivery && <p className="mt-2">Delivery fee: <strong>{formatPesoCentavos(deliveryFee)}</strong>, from the disclosed rate formula.</p>}
    </ConfirmDialog>
    <DeclineDialog open={declineOpen} order={order} onClose={() => setDeclineOpen(false)} onDone={onDone} />
  </form>
}

function DeliveryPlanner({ plan, busy, onLoad, choices, setChoices, fee, errors, date, setDate, arrangement, setArrangement, access, setAccess, heavy, setHeavy, note, setNote }: {
  plan: DeliveryPlan | null; busy: boolean; onLoad: () => void; choices: DeliveryChoice[]; setChoices: (next: DeliveryChoice[]) => void; fee: number; errors: Record<string, string>
  date: string; setDate: (value: string) => void; arrangement: string; setArrangement: (value: string) => void; access: boolean; setAccess: (value: boolean) => void
  heavy: boolean; setHeavy: (value: boolean) => void; note: string; setNote: (value: string) => void
}) {
  const vehicles = useMemo(() => new Map((plan?.eligibleVehicles ?? []).map(vehicle => [vehicle.vehicleId, vehicle])), [plan])
  if (!plan) return <div className="grid justify-items-start gap-3">
    <p className="text-sm text-text-secondary">Load advisory vehicle options for the confirmed quantities. The route runs from your store to the Buyer's actual vehicle drop-off.</p>
    <Button variant="secondary" disabled={busy} onClick={onLoad}><Truck size={16} aria-hidden="true" />{busy ? 'Loading options…' : 'Load vehicle options'}</Button>
    {errors.delivery && <p className="text-sm text-status-error" role="alert">{errors.delivery}</p>}
  </div>
  const update = (key: string, patch: Partial<DeliveryChoice>) => setChoices(choices.map(choice => choice.key === key ? { ...choice, ...patch } : choice))
  const anyHeavy = choices.some(choice => vehicles.get(choice.vehicleId)?.heavyClassification === 'HEAVY')
  return <div className="grid gap-5">
    <p className="text-sm text-text-secondary">Route {(plan.route.distanceMeters / 1000).toFixed(1)} km to the {plan.endpoint.kind === 'ALTERNATE_DROP_OFF' ? 'alternate drop-off' : 'intended destination'}. {plan.notice}</p>
    {plan.status === 'MANUAL_REVIEW_REQUIRED' && <StatusMessage tone="error">Some load measurements are missing. Review the load manually, choose vehicles and trips, and record your review.</StatusMessage>}
    {plan.groups.map(group => {
      const choice = choices.find(item => item.key === group.key)
      const options = group.candidates.length ? group.candidates : plan.eligibleVehicles.filter(vehicle => vehicle.withinRange)
      return <fieldset key={group.key} className="grid min-w-0 gap-3 border-t border-border-default pt-4">
        <legend className="text-sm font-semibold">{group.label}</legend>
        <div className="grid gap-2">{options.map(option => <label key={option.vehicleId} className={`flex min-h-11 min-w-0 cursor-pointer flex-wrap items-center gap-3 rounded-control border px-3 py-2 text-sm ${choice?.vehicleId === option.vehicleId ? 'border-action-primary bg-brand-orange-50' : 'border-border-default'}`}>
          <input type="radio" name={`vehicle-${group.key}`} className="h-4 w-4 accent-action-primary" checked={choice?.vehicleId === option.vehicleId} onChange={() => {
            const next = { key: group.key, vehicleId: option.vehicleId, numberOfVehicles: option.numberOfVehicles ?? 1, trips: option.totalVehicleTrips ?? 1, perTrip: option.perTripCentavos }
            setChoices(choice ? choices.map(item => item.key === group.key ? next : item) : [...choices, next])
          }} />
          <span className="min-w-0 flex-1"><span className="font-semibold">{option.name}</span> <span className="text-text-secondary">{[option.brand, option.heavyClassification === 'HEAVY' ? 'Heavy vehicle' : null].filter(Boolean).join(' · ')}</span></span>
          <span className="tabular-nums text-text-secondary">{formatPesoCentavos(option.perTripCentavos)} per trip</span>
        </label>)}{options.length === 0 && <p className="text-sm text-status-error">No eligible vehicle can reach this drop-off. Decline or contact the Buyer.</p>}</div>
        {choice && <div className="grid gap-3 sm:grid-cols-2">
          <Field label="Vehicles used" name={`vehicles-${group.key}`} type="number" min={1} max={vehicles.get(choice.vehicleId)?.numberAvailable ?? 1} value={choice.numberOfVehicles} onChange={event => update(group.key, { numberOfVehicles: Math.max(1, Number(event.target.value) || 1) })} />
          <Field label="Total trips" name={`trips-${group.key}`} type="number" min={1} value={choice.trips} onChange={event => update(group.key, { trips: Math.max(1, Number(event.target.value) || 1) })} />
        </div>}
      </fieldset>
    })}
    <p className="text-sm">Final delivery fee: <strong className="tabular-nums">{formatPesoCentavos(fee)}</strong> <span className="text-text-secondary">(per-trip rate × trips; the Buyer sees this before paying)</span></p>
    <div className="grid gap-4 sm:grid-cols-2">
      <Field label="Delivery date" name="delivery.fulfillment_date" type="date" min={manilaToday()} value={date} onChange={event => setDate(event.target.value)} />
    </div>
    <label className="grid gap-2 text-sm font-semibold">Arrangement shown to the Buyer<textarea className={`${control} min-h-20 py-2`} value={arrangement} maxLength={2000} placeholder="e.g. One box-truck trip to the north gate before noon." onChange={event => setArrangement(event.target.value)} /></label>
    {errors['delivery.arrangement'] && <p className="-mt-3 text-sm text-status-error">{errors['delivery.arrangement']}</p>}
    {plan.status === 'MANUAL_REVIEW_REQUIRED' && <label className="grid gap-2 text-sm font-semibold">Manual load review<textarea className={`${control} min-h-20 py-2`} value={note} maxLength={2000} onChange={event => setNote(event.target.value)} /></label>}
    {errors['delivery.manual_review_note'] && <p className="-mt-3 text-sm text-status-error">{errors['delivery.manual_review_note']}</p>}
    <label className="flex min-h-11 items-start gap-3 text-sm"><input type="checkbox" className="mt-0.5 h-5 w-5 accent-action-primary" checked={access} onChange={event => setAccess(event.target.checked)} /><span>I confirm the drop-off is accessible for the chosen vehicles.</span></label>
    {errors['delivery.access_confirmed'] && <p className="-mt-3 text-sm text-status-error">{errors['delivery.access_confirmed']}</p>}
    {anyHeavy && <label className="flex min-h-11 items-start gap-3 text-sm"><input type="checkbox" className="mt-0.5 h-5 w-5 accent-action-primary" checked={heavy} onChange={event => setHeavy(event.target.checked)} /><span>I confirm heavy-vehicle access at the drop-off.</span></label>}
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
    {confirmed && <dl className="grid gap-2 border-t border-border-default pt-3 text-sm">
      <div><dt className="text-xs text-text-secondary">Confirmed vehicles</dt>{confirmed.vehicles.map((vehicle, index) => <dd key={index} className="font-semibold">{vehicle.name} · {vehicle.numberOfVehicles} vehicle{vehicle.numberOfVehicles === 1 ? '' : 's'}, {vehicle.totalVehicleTrips} trip{vehicle.totalVehicleTrips === 1 ? '' : 's'}</dd>)}</div>
      <div><dt className="text-xs text-text-secondary">Route</dt><dd>{(confirmed.distanceMeters / 1000).toFixed(1)} km to the {confirmed.endpoint === 'ALTERNATE_DROP_OFF' ? 'alternate drop-off' : 'intended destination'}</dd></div>
      <div><dt className="text-xs text-text-secondary">Final delivery fee</dt><dd className="font-semibold tabular-nums">{formatPesoCentavos(confirmed.finalFeeCentavos)}</dd></div>
      {confirmed.arrangement && <div><dt className="text-xs text-text-secondary">Arrangement</dt><dd>{confirmed.arrangement}</dd></div>}
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
  if (!outcome) return null
  return <section aria-labelledby="auto-heading" className="grid gap-2 rounded-surface border border-border-default bg-surface-primary p-4 text-sm">
    <h2 id="auto-heading" className="flex items-center gap-2 text-base font-semibold">{outcome.accepted ? <Bot size={16} aria-hidden="true" /> : <Hand size={16} aria-hidden="true" />}{outcome.accepted ? 'Auto-accepted' : 'Routed to manual review'}</h2>
    {outcome.accepted ? <p>All lines met the auto-accept allotment and safeguards; stock was reserved automatically.</p>
      : <ul className="grid gap-1 text-text-secondary">{[...new Set(outcome.reasons.map(reason => reason.code))].map(code => <li key={code}>• {autoAcceptReason(code)}</li>)}</ul>}
  </section>
}

function autoAcceptReason(code: string): string {
  return ({
    POLICY_NOT_ACTIVE: 'Auto-accept is off or paused for a line.', ALLOTMENT_INSUFFICIENT: 'A line exceeds its remaining auto-accept allotment.', UNIT_CAP_EXCEEDED: 'A line exceeds its maximum unit count.',
    AMOUNT_CAP_EXCEEDED: 'The order exceeds a maximum order amount.', STOCK_INSUFFICIENT: 'Available stock was lower than requested.', DELIVERY_REQUIRES_VENDOR_CONFIRMATION: 'Site Delivery needs your confirmed vehicles, trips and fee.',
    FULFILLMENT_DATE_NOT_CONFIGURED: 'No auto-accept ready-for-pickup lead time is set in Inventory settings.', PAYMENT_CAPABILITY_UNAVAILABLE: 'Online payment is not connected.',
    WHOLE_UNITS_REQUIRED: 'Auto-accept needs whole-unit quantities.', TAX_CLASSIFICATION_MISSING: 'A line has no validated tax classification.',
  } as Record<string, string>)[code] ?? code.toLowerCase().replaceAll('_', ' ')
}

function TimelinePanel({ order }: { order: OrderDetail }) {
  return <section aria-labelledby="timeline-heading" className="grid gap-3">
    <h2 id="timeline-heading" className="text-lg font-semibold">History</h2>
    <ol className="grid gap-0 border-l border-border-default pl-5">{order.timeline.map((event, index) => <li key={index} className="relative pb-4 text-sm">
      <span className="absolute -left-[1.6rem] top-1 h-2.5 w-2.5 rounded-full border-2 border-surface-primary bg-action-primary" aria-hidden="true" />
      <p className="font-semibold">{event.family === 'ORDER' ? '' : `${event.family.charAt(0)}${event.family.slice(1).toLowerCase()}: `}{orderStateLabel(event.toState)}</p>
      <p className="text-text-secondary">{formatManilaDateTime(event.at)} · {event.source === 'AUTO_ACCEPT' ? 'Automated policy' : event.source === 'SYSTEM' ? 'System' : event.source === 'BUYER' ? 'Buyer' : (event.actorRole ?? 'Vendor').replaceAll('_', ' ').toLowerCase()}</p>
    </li>)}</ol>
  </section>
}
