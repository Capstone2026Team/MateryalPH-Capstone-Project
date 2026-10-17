import { useEffect, useId, useRef, useState, type ReactNode } from 'react'
import { AlertTriangle, Check, CheckCircle2, CircleDashed, Clock, CreditCard, Hourglass, PackageCheck, Scale, Undo2, XCircle } from 'lucide-react'
import type { MoneyBreakdown as MoneyBreakdownData, OrderStateRow, OrderSummary, OrderTimelineEvent } from '@materyalph/api-client-ts'
import { StatusBadge } from './portal-shell'
import { formatManilaDateTime, type DateLike } from './stock-ledger'

const peso = new Intl.NumberFormat('en-PH', { style: 'currency', currency: 'PHP', minimumFractionDigits: 2 })

/** Integer centavos to a peso string; never through binary arithmetic beyond the final display division. */
export function formatPesoCentavos(centavos: number | null | undefined): string {
  if (centavos === null || centavos === undefined) return '—'
  return peso.format(centavos / 100)
}

const familyLabels: Record<string, string> = { ORDER: 'Order', PAYMENT: 'Payment', FULFILLMENT: 'Fulfillment', REFUND: 'Refund', DISPUTE: 'Dispute' }

/** A fixed heading with an independently scrollable, keyboard-accessible order history. */
export function OrderHistory({ events }: { events: OrderTimelineEvent[] }) {
  const headingId = useId()
  return <section aria-labelledby={headingId} className="grid min-w-0 gap-3 rounded-surface border border-border-default bg-surface-primary p-4">
    <h2 id={headingId} className="text-base font-semibold">History</h2>
    <div role="region" aria-label="Order history events" tabIndex={0} className="max-h-[28rem] min-h-0 overflow-y-auto overscroll-contain rounded-control pr-3 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-focus-ring" style={{ scrollbarGutter: 'stable' }}>
      {events.length === 0 ? <p className="text-sm text-text-secondary">No order history yet.</p> : <ol className="ml-1.5 grid border-l border-border-default pl-5">
        {events.map((event, index) => <li key={index} className="relative pb-4 text-sm last:pb-0">
          <span className="absolute -left-[1.6rem] top-1 h-2.5 w-2.5 rounded-full border-2 border-surface-primary bg-action-primary" aria-hidden="true" />
          <p className="break-words font-semibold">{event.family === 'ORDER' ? '' : `${familyLabels[event.family] ?? event.family}: `}{orderStateLabel(event.toState)}</p>
          <p className="mt-1 break-words text-xs leading-5 text-text-secondary">{formatManilaDateTime(event.at)} · {event.source === 'AUTO_ACCEPT' ? 'Automated policy' : event.source === 'SYSTEM' ? 'System' : event.source === 'BUYER' ? 'Buyer' : (event.actorRole ?? 'Vendor').replaceAll('_', ' ').toLowerCase()}</p>
        </li>)}
      </ol>}
    </div>
  </section>
}

/** The order journey alone: payment, refund and dispute remain independent state families. */
export function OrderProgress({ state, fulfillmentMethod }: { state: string; fulfillmentMethod: 'DELIVERY' | 'PICKUP' }) {
  const pickup = fulfillmentMethod === 'PICKUP'
  const steps = ['Request received', 'Awaiting acceptance', 'Preparing order', pickup ? 'Ready for pickup' : 'Out for delivery', pickup ? 'Picked up & confirmed' : 'Delivered & confirmed']
  const stage = ({ AWAITING_VENDOR_CONFIRMATION: 1, AWAITING_BUYER_APPROVAL: 1, AWAITING_NRPC_ACCEPTANCE: 1, AWAITING_PAYMENT: 1, CONFIRMED: 2, PROCESSING: 2, READY_FOR_PICKUP: 3, OUT_FOR_DELIVERY: 3, DELIVERED: 4, PICKED_UP: 4, COMPLETED: 5 } as Record<string, number>)[state]
  const labels = [...steps]
  if (state === 'AWAITING_BUYER_APPROVAL') labels[1] = 'Buyer approval'
  if (state === 'AWAITING_NRPC_ACCEPTANCE') labels[1] = 'NRPC acceptance'
  if (state === 'AWAITING_PAYMENT') labels[1] = 'Awaiting payment'
  if (state === 'CONFIRMED') labels[2] = 'Confirmed · awaiting preparation'
  if (state === 'DELIVERED' || state === 'PICKED_UP') labels[4] = pickup ? 'Picked up · awaiting confirmation' : 'Delivered · awaiting confirmation'
  return <div className="grid gap-3">
    <div className="overflow-x-auto pb-1" tabIndex={0} role="group" aria-label="Order progress steps, scroll horizontally on small screens">
    <ol aria-label="Order progress" className="flex min-w-[26rem] items-start">
      {labels.map((label, index) => {
        const complete = index === 0 || (stage !== undefined && index < stage)
        const current = index === stage
        return <li key={index} aria-current={current ? 'step' : undefined} className="relative grid min-w-0 flex-1 justify-items-center gap-2 text-center">
          {index < 4 && <span aria-hidden="true" className="absolute left-1/2 top-4 h-0.5 w-full bg-border-default" />}
          <span className={`relative z-10 grid h-8 w-8 place-items-center rounded-full border-2 ${complete ? 'border-action-primary bg-action-primary text-white' : current ? 'border-brand-orange-500 bg-brand-orange-500 text-text-strong' : 'border-border-default bg-surface-primary text-text-secondary'}`}>
            {complete ? <Check size={16} aria-hidden="true" /> : current ? <Hourglass size={15} aria-hidden="true" /> : index + 1}
          </span>
          <span className="px-1 text-xs font-semibold leading-4">{label}<span className="sr-only">{complete ? ' — complete' : current ? ' — current' : ' — not complete'}</span></span>
        </li>
      })}
    </ol>
    </div>
    <p className="text-xs text-text-secondary">Current status: <strong>{orderStateLabel(state)}</strong>{stage === undefined ? ' · Normal progress is interrupted.' : ''}</p>
  </div>
}

const stateLabels: Record<string, string> = {
  AWAITING_VENDOR_CONFIRMATION: 'Awaiting Vendor confirmation', AWAITING_BUYER_APPROVAL: 'Awaiting Buyer approval', AWAITING_NRPC_ACCEPTANCE: 'Awaiting NRPC acceptance',
  AWAITING_PAYMENT: 'Awaiting payment', CONFIRMED: 'Confirmed', PROCESSING: 'Preparing', READY_FOR_PICKUP: 'Ready for pickup', OUT_FOR_DELIVERY: 'Out for delivery',
  DELIVERED: 'Delivered', PICKED_UP: 'Picked up', COMPLETED: 'Completed', CANCELLATION_REQUESTED: 'Cancellation requested', DECLINED: 'Declined', EXPIRED: 'Expired',
  CANCELLED: 'Cancelled', DISPUTED: 'Disputed', NOT_REQUIRED: 'No payment due', PENDING: 'Payment due', PAID: 'Paid (verified)', FAILED: 'Failed',
  NOT_STARTED: 'Not started', NOT_REQUESTED: 'None', REFUND_PENDING: 'Refund pending', PARTIALLY_REFUNDED: 'Partially refunded', REFUNDED: 'Refunded',
  REFUND_FAILED: 'Refund failed', NONE: 'None', OPEN_AWAITING_RESPONSE: 'Open', MUTUAL_RESOLUTION: 'Mutual resolution', ESCALATED_ADMIN_REVIEW: 'Admin review',
  AWAITING_CLARIFICATION: 'Awaiting clarification', DECIDED: 'Decided', APPEAL_OPEN: 'Appeal open', RESOLVED: 'Resolved', CLOSED_INCONCLUSIVE: 'Closed',
}

export function orderStateLabel(state: string): string {
  return stateLabels[state] ?? state.toLowerCase().replaceAll('_', ' ').replace(/^\w/, letter => letter.toUpperCase())
}

type Tone = 'success' | 'warning' | 'error' | 'info' | 'neutral'

export function orderStateTone(state: string): Tone {
  if (['COMPLETED', 'PAID', 'CONFIRMED', 'DELIVERED', 'PICKED_UP', 'REFUNDED', 'RESOLVED'].includes(state)) return 'success'
  if (['DECLINED', 'EXPIRED', 'CANCELLED', 'FAILED', 'REFUND_FAILED', 'DISPUTED'].includes(state)) return 'error'
  if (state.startsWith('AWAITING') || ['PENDING', 'REFUND_PENDING', 'CANCELLATION_REQUESTED', 'OPEN_AWAITING_RESPONSE'].includes(state)) return 'warning'
  if (['NONE', 'NOT_STARTED', 'NOT_REQUESTED', 'NOT_REQUIRED'].includes(state)) return 'neutral'
  return 'info'
}

const toneClasses: Record<Tone, string> = {
  success: 'text-green-800', warning: 'text-amber-900', error: 'text-red-800', info: 'text-blue-900', neutral: 'text-text-secondary',
}
const familyIcons = { ORDER: PackageCheck, PAYMENT: CreditCard, FULFILLMENT: CircleDashed, REFUND: Undo2, DISPUTE: Scale }
const toneIcons = { success: CheckCircle2, warning: Clock, error: XCircle, info: CircleDashed, neutral: CircleDashed }

/**
 * Order, payment, fulfillment, refund and dispute as five separate labelled rows, so no single status bar
 * implies the others. Each state is text plus icon; color is only reinforcement.
 */
export function OrderStateRows({ states, className = '' }: { states: OrderStateRow[]; className?: string }) {
  return <dl className={`grid min-w-0 divide-y divide-border-default rounded-surface border border-border-default bg-surface-primary ${className}`} aria-label="Order status by area">
    {states.map(row => {
      const tone = orderStateTone(row.state)
      const FamilyIcon = familyIcons[row.family as keyof typeof familyIcons] ?? PackageCheck
      const StateIcon = toneIcons[tone]
      return <div key={row.family} className="flex min-h-11 min-w-0 flex-wrap items-center justify-between gap-x-4 gap-y-1 px-4 py-2">
        <dt className="flex items-center gap-2 text-sm text-text-secondary"><FamilyIcon size={16} aria-hidden="true" />{familyLabels[row.family] ?? row.family}</dt>
        <dd className={`flex min-w-0 items-center gap-1.5 text-sm font-semibold ${toneClasses[tone]}`}><StateIcon size={16} aria-hidden="true" />{orderStateLabel(row.state)}</dd>
      </div>
    })}
  </dl>
}

const toDate = (value: DateLike): Date | null => { if (!value) return null; const date = value instanceof Date ? value : new Date(value); return Number.isNaN(date.getTime()) ? null : date }

function remainingText(milliseconds: number): string {
  const totalSeconds = Math.ceil(milliseconds / 1000)
  const hours = Math.floor(totalSeconds / 3600)
  const minutes = Math.floor((totalSeconds % 3600) / 60)
  const seconds = totalSeconds % 60
  if (hours >= 24) return `${Math.floor(hours / 24)} d ${hours % 24} h`
  if (hours > 0) return `${hours} h ${String(minutes).padStart(2, '0')} min`
  return `${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`
}

/**
 * A deadline as a live countdown plus the exact Asia/Manila date and time. It ticks every second in the last
 * hour, announces only the change of state, and on reaching zero shows a resolved "window ended" state and asks
 * the caller to refresh once, instead of spinning. Motion is limited to text changes.
 */
export function DeadlineCountdown({ at, label, endedLabel = 'Window ended', onExpire, now: fixedNow }: {
  at: DateLike; label: string; endedLabel?: string; onExpire?: () => void; now?: number
}) {
  const target = toDate(at)
  const [now, setNow] = useState(() => fixedNow ?? Date.now())
  const expiredFired = useRef(false)
  const remaining = target ? target.getTime() - (fixedNow ?? now) : 0
  useEffect(() => {
    if (fixedNow !== undefined || !target || remaining <= 0) return
    const timer = window.setTimeout(() => setNow(Date.now()), remaining <= 3_600_000 ? 1000 : 30_000)
    return () => window.clearTimeout(timer)
  }, [fixedNow, target, remaining, now])
  useEffect(() => {
    if (target && remaining <= 0 && !expiredFired.current) {
      expiredFired.current = true
      onExpire?.()
    }
  }, [target, remaining, onExpire])
  if (!target) return null
  const ended = remaining <= 0
  const urgent = !ended && remaining <= 15 * 60_000
  return <div className={`flex min-w-0 flex-wrap items-center gap-x-3 gap-y-1 rounded-control border px-3 py-2 text-sm ${ended ? 'border-border-default bg-surface-canvas text-text-secondary' : urgent ? 'border-amber-300 bg-amber-50 text-amber-950' : 'border-border-default bg-surface-primary text-text-strong'}`}>
    {ended ? <AlertTriangle size={16} aria-hidden="true" /> : <Clock size={16} aria-hidden="true" />}
    <span className="font-semibold">{label}</span>
    <span role="timer" aria-live="off" className="font-semibold tabular-nums">{ended ? endedLabel : remainingText(remaining)}</span>
    <span className="text-text-secondary">{ended ? 'Ended' : 'Until'} <time dateTime={target.toISOString()}>{formatManilaDateTime(target)}</time></span>
    <span className="sr-only" aria-live="polite">{ended ? `${label}: ${endedLabel}` : urgent ? `${label}: less than 15 minutes left` : ''}</span>
  </div>
}

function MoneyRow({ label, value, note, strong = false, muted = false }: { label: string; value: string; note?: string | undefined; strong?: boolean; muted?: boolean }) {
  return <div className={`flex min-w-0 flex-wrap items-baseline justify-between gap-x-4 gap-y-0.5 py-2 ${strong ? 'border-t border-border-default pt-3' : ''}`}>
    <dt className={`min-w-0 text-sm ${strong ? 'font-semibold text-text-strong' : muted ? 'text-text-secondary' : 'text-text-strong'}`}>{label}{note && <span className="block text-xs font-normal text-text-secondary">{note}</span>}</dt>
    <dd className={`tabular-nums ${strong ? 'text-lg font-semibold text-text-strong' : muted ? 'text-sm text-text-secondary' : 'text-sm font-semibold text-text-strong'}`}>{value}</dd>
  </div>
}

/**
 * FIN-02 Buyer amounts: materials, discount, included VAT (never added again), delivery, NRPC as part of the
 * materials value, processing fee and the total. Vendor commission and withholding never appear here.
 */
export function MoneyBreakdown({ money, title = 'Payment breakdown', compact = false }: { money: MoneyBreakdownData; title?: string; compact?: boolean }) {
  const discount = money.discount
  const deliveryDiscount = discount?.scope === 'DELIVERY' ? discount : null
  const materialsDiscountLabel = discount?.scope === 'MATERIALS' ? `Vendor discount ${discount.percent}% (materials)` : 'Vendor discount'
  const deliveryDiscountLabel = deliveryDiscount ? `Vendor discount ${deliveryDiscount.percent}% (delivery fee)` : ''
  const delivery = money.delivery.status === 'NOT_APPLICABLE' ? 'Not applicable (Self-Pickup)'
    : money.delivery.amountCentavos !== null ? formatPesoCentavos(deliveryDiscount?.basisCentavos ?? money.delivery.amountCentavos)
      : money.delivery.estimate ? `Estimate ${formatPesoCentavos(money.delivery.estimate.minCentavos)}${money.delivery.estimate.maxCentavos !== money.delivery.estimate.minCentavos ? ` – ${formatPesoCentavos(money.delivery.estimate.maxCentavos)}` : ''}` : 'Estimate unavailable — delivery review required'
  const estimate = money.commercialTotalCentavos === null ? money.delivery.estimate : null
  const totalLabel = estimate ? 'Estimated total' : money.commercialTotalCentavos === null ? 'Total before delivery' : 'Order total'
  const total = estimate
    ? `${formatPesoCentavos(money.materialsSubtotalCentavos + estimate.minCentavos)}${estimate.maxCentavos !== estimate.minCentavos ? ` – ${formatPesoCentavos(money.materialsSubtotalCentavos + estimate.maxCentavos)}` : ''}`
    : formatPesoCentavos(money.commercialTotalCentavos ?? money.materialsSubtotalCentavos)
  const fee = money.processingFee.status === 'NOT_APPLICABLE' ? 'None' : money.processingFee.amountCentavos === null ? 'Shown at payment' : formatPesoCentavos(money.processingFee.amountCentavos)
  const physical = money.paymentPurpose !== 'FULL_ORDER_PAYMENT' && (money.physicalBalanceCentavos ?? 0) > 0
  if (compact) return <section aria-label={title} className="min-w-0 border-t border-border-default pt-4">
    <h3 className="mb-3 text-xs font-semibold uppercase tracking-wide text-text-secondary">Payment summary</h3>
    <dl className="grid gap-2 border-y-2 border-text-strong py-3">
      <ReviewMoneyRow label="Materials" value={formatPesoCentavos(money.materialsGrossCentavos)} />
      {money.vendorDiscountCentavos > 0 && <ReviewMoneyRow label={materialsDiscountLabel} value={`− ${formatPesoCentavos(money.vendorDiscountCentavos)}`} />}
      {money.includedVatCentavos > 0 && <ReviewMoneyRow label="Included VAT (in materials)" value={formatPesoCentavos(money.includedVatCentavos)} muted />}
      <ReviewMoneyRow label={deliveryDiscount ? "Delivery before discount" : "Delivery fee"} value={delivery} />
      {deliveryDiscount && <ReviewMoneyRow label={deliveryDiscountLabel} value={`− ${formatPesoCentavos(deliveryDiscount.deductionCentavos)}`} />}
      {money.nrpc.amountCentavos > 0 && <ReviewMoneyRow label="NRPC (in materials)" value={formatPesoCentavos(money.nrpc.amountCentavos)} muted />}
      <ReviewMoneyRow label="Payment processing fee" value={fee} />
      <div className="mt-1 grid grid-cols-[minmax(0,1fr)_auto] items-baseline gap-x-4 border-t-2 border-text-strong pt-3 text-xs font-bold text-text-strong">
        <dt className="uppercase tracking-wide">{totalLabel}</dt>
        <dd className="text-right tabular-nums">{total}</dd>
      </div>
      {physical && <ReviewMoneyRow label="Pay the Vendor directly" value={formatPesoCentavos(money.physicalBalanceCentavos)} />}
    </dl>
    {money.delivery.status === 'PENDING_VENDOR_CONFIRMATION' && <p className="mt-2 text-xs leading-5 text-text-secondary">Delivery fee is awaiting Vendor confirmation.</p>}
    {money.processingFee.status === 'PENDING_PAYMENT_CHANNEL' && <p className="mt-2 text-xs leading-5 text-text-secondary">Order total excludes the processing fee, disclosed when a payment channel is selected.</p>}
  </section>
  return <section aria-labelledby="money-breakdown-heading" className="min-w-0">
    <h3 id="money-breakdown-heading" className="text-base font-semibold text-text-strong">{title}</h3>
    <dl className="mt-2 divide-y divide-border-default/70">
      <MoneyRow label="Materials" value={formatPesoCentavos(money.materialsGrossCentavos)} />
      {money.vendorDiscountCentavos > 0 && <MoneyRow label={materialsDiscountLabel} value={`− ${formatPesoCentavos(money.vendorDiscountCentavos)}`} />}
      <MoneyRow label="Materials subtotal" value={formatPesoCentavos(money.materialsSubtotalCentavos)} note={money.vatTreatment === 'PRICES_INCLUDE_VAT' ? 'Prices include VAT' : 'No VAT included'} />
      {money.includedVatCentavos > 0 && <MoneyRow muted label="Included VAT (already in the subtotal)" value={formatPesoCentavos(money.includedVatCentavos)} />}
      <MoneyRow label={deliveryDiscount ? "Delivery before discount" : "Delivery fee"} value={delivery} note={money.delivery.status === 'PENDING_VENDOR_CONFIRMATION' ? 'Confirmed by the Vendor before you pay' : undefined} />
      {deliveryDiscount && <MoneyRow label={deliveryDiscountLabel} value={`− ${formatPesoCentavos(deliveryDiscount.deductionCentavos)}`} />}
      {money.nrpc.amountCentavos > 0 && <MoneyRow muted label="Non-Recoverable Preparation Cost" value={formatPesoCentavos(money.nrpc.amountCentavos)} note="Part of the materials subtotal, not an extra charge" />}
      <MoneyRow label="Payment processing fee" value={fee} note={money.processingFee.status === 'PENDING_PAYMENT_CHANNEL' ? 'Disclosed when a payment channel is chosen' : undefined} />
      <MoneyRow strong label={totalLabel} value={total} note={money.processingFee.status === 'PENDING_PAYMENT_CHANNEL' ? 'Before the processing fee' : undefined} />
      {physical && <MoneyRow label="Pay the Vendor directly" value={formatPesoCentavos(money.physicalBalanceCentavos)} />}
    </dl>
  </section>
}

function ReviewMoneyRow({ label, value, muted = false }: { label: string; value: string; muted?: boolean }) {
  return <div className="grid min-w-0 grid-cols-[minmax(0,1fr)_minmax(0,1fr)] items-baseline gap-x-4 text-xs leading-5">
    <dt className={muted ? 'text-text-secondary' : 'text-text-strong'}>{label}</dt>
    <dd className={`break-words text-right tabular-nums ${muted ? 'text-text-secondary' : 'font-medium text-text-strong'}`}>{value}</dd>
  </div>
}

/** Shared stacked order summary; navigation stays with the consuming client. */
export function OrderSummaryCard({ order, identity, action }: { order: OrderSummary; identity: ReactNode; action: ReactNode }) {
  const orderState = order.states.find(row => row.family === 'ORDER')?.state ?? ''
  const facts = [
    { label: 'Items', value: `${order.lineCount} ${order.lineCount === 1 ? 'item' : 'items'}` },
    { label: 'Fulfillment', value: order.fulfillmentMethod === 'DELIVERY' ? 'Site Delivery' : 'Self-Pickup' },
    { label: 'Payment method', value: order.paymentMethod === 'ONLINE' ? 'Online payment' : order.paymentMethod === 'CASH_ON_DELIVERY' ? 'Cash on Delivery' : 'In-Store Payment' },
    { label: 'Confirmation', value: order.confirmationSource === 'AUTO_ACCEPT' ? 'Auto-accepted' : order.confirmationSource === 'MANUAL' ? 'Manual' : 'Awaiting review' },
  ]
  return <article aria-label={order.reference} className="min-w-0 overflow-hidden rounded-surface border border-border-default bg-surface-primary">
    <header className="flex min-w-0 flex-col justify-between gap-4 p-4 sm:flex-row sm:p-5">
      <div className="flex min-w-0 items-start gap-3">
        <span className="grid h-11 w-11 shrink-0 place-items-center rounded-control border border-border-default bg-surface-canvas text-action-primary"><PackageCheck size={22} aria-hidden="true" /></span>
        {identity}
      </div>
      <div className="grid shrink-0 justify-items-start gap-1 sm:justify-items-end">
        <p className="text-lg font-semibold tabular-nums text-text-strong">{formatPesoCentavos(order.commercialTotalCentavos)}</p>
        {order.deliveryPending && <p className="text-xs text-text-secondary">+ delivery to confirm</p>}
        {order.nrpcIndicator && <p className="text-xs font-semibold text-text-secondary">Includes NRPC</p>}
        <p className="text-xs text-text-secondary">Requested {formatManilaDateTime(order.submittedAt)}</p>
        <StatusBadge label={orderStateLabel(orderState)} tone={orderStateTone(orderState)} />
      </div>
    </header>
    <dl className="grid grid-cols-2 gap-x-4 gap-y-4 border-t border-border-default px-4 py-3 sm:px-5 lg:grid-cols-4">
      {facts.map(fact => <div key={fact.label} className="min-w-0 border-l border-border-default pl-3 first:border-l-0 first:pl-0"><dt className="text-xs text-text-secondary">{fact.label}</dt><dd className="mt-1 break-words text-sm font-semibold">{fact.value}</dd></div>)}
    </dl>
    <div className="flex flex-wrap gap-x-4 gap-y-1 px-4 pb-3 text-xs text-text-secondary sm:px-5">
      {order.states.filter(row => row.family !== 'ORDER').map(row => <span key={row.family}>{familyLabels[row.family] ?? row.family}: {orderStateLabel(row.state)}</span>)}
    </div>
    <div className="flex flex-col gap-3 border-t border-border-default bg-surface-canvas px-4 py-3 sm:flex-row sm:items-center sm:justify-between sm:px-5">
      <div className="min-w-0">{order.deadline ? <DeadlineCountdown at={order.deadline.at} label={order.deadline.kind === 'VENDOR_RESPONSE' ? 'Respond within' : order.deadline.kind === 'BUYER_RESPONSE' ? 'Buyer response' : 'Payment window'} /> : <span className="text-xs text-text-secondary">No pending response deadline</span>}</div>
      <div className="shrink-0">{action}</div>
    </div>
  </article>
}
