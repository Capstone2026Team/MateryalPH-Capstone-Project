import { useEffect, useRef, useState } from 'react'
import { AlertTriangle, CheckCircle2, CircleDashed, Clock, CreditCard, PackageCheck, Scale, Undo2, XCircle } from 'lucide-react'
import type { MoneyBreakdown as MoneyBreakdownData, OrderStateRow } from '@materyalph/api-client-ts'
import { formatManilaDateTime, type DateLike } from './stock-ledger'

const peso = new Intl.NumberFormat('en-PH', { style: 'currency', currency: 'PHP', minimumFractionDigits: 2 })

/** Integer centavos to a peso string; never through binary arithmetic beyond the final display division. */
export function formatPesoCentavos(centavos: number | null | undefined): string {
  if (centavos === null || centavos === undefined) return '—'
  return peso.format(centavos / 100)
}

const familyLabels: Record<string, string> = { ORDER: 'Order', PAYMENT: 'Payment', FULFILLMENT: 'Fulfillment', REFUND: 'Refund', DISPUTE: 'Dispute' }

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
export function MoneyBreakdown({ money, title = 'Payment breakdown' }: { money: MoneyBreakdownData; title?: string }) {
  const delivery = money.delivery.status === 'NOT_APPLICABLE' ? 'Not applicable (Self-Pickup)'
    : money.delivery.amountCentavos !== null ? formatPesoCentavos(money.delivery.amountCentavos)
      : money.delivery.estimate ? `Estimate ${formatPesoCentavos(money.delivery.estimate.minCentavos)}${money.delivery.estimate.maxCentavos !== money.delivery.estimate.minCentavos ? ` – ${formatPesoCentavos(money.delivery.estimate.maxCentavos)}` : ''}` : 'Set by the Vendor'
  const fee = money.processingFee.status === 'NOT_APPLICABLE' ? 'None' : money.processingFee.amountCentavos === null ? 'Shown at payment' : formatPesoCentavos(money.processingFee.amountCentavos)
  const physical = money.paymentPurpose !== 'FULL_ORDER_PAYMENT' && (money.physicalBalanceCentavos ?? 0) > 0
  return <section aria-labelledby="money-breakdown-heading" className="min-w-0">
    <h3 id="money-breakdown-heading" className="text-base font-semibold text-text-strong">{title}</h3>
    <dl className="mt-2 divide-y divide-border-default/70">
      <MoneyRow label="Materials" value={formatPesoCentavos(money.materialsGrossCentavos)} />
      {money.vendorDiscountCentavos > 0 && <MoneyRow label="Vendor discount" value={`− ${formatPesoCentavos(money.vendorDiscountCentavos)}`} />}
      <MoneyRow label="Materials subtotal" value={formatPesoCentavos(money.materialsSubtotalCentavos)} note={money.vatTreatment === 'PRICES_INCLUDE_VAT' ? 'Prices include VAT' : 'No VAT included'} />
      {money.includedVatCentavos > 0 && <MoneyRow muted label="Included VAT (already in the subtotal)" value={formatPesoCentavos(money.includedVatCentavos)} />}
      <MoneyRow label="Delivery fee" value={delivery} note={money.delivery.status === 'PENDING_VENDOR_CONFIRMATION' ? 'Confirmed by the Vendor before you pay' : undefined} />
      {money.nrpc.amountCentavos > 0 && <MoneyRow muted label="Non-Recoverable Preparation Cost" value={formatPesoCentavos(money.nrpc.amountCentavos)} note="Part of the materials subtotal, not an extra charge" />}
      <MoneyRow label="Payment processing fee" value={fee} note={money.processingFee.status === 'PENDING_PAYMENT_CHANNEL' ? 'Disclosed when a payment channel is chosen' : undefined} />
      <MoneyRow strong label={money.commercialTotalCentavos === null ? 'Total before delivery' : 'Order total'} value={formatPesoCentavos(money.commercialTotalCentavos ?? money.materialsSubtotalCentavos)} note={money.processingFee.status === 'PENDING_PAYMENT_CHANNEL' ? 'Before the processing fee' : undefined} />
      {physical && <MoneyRow label="Pay the Vendor directly" value={formatPesoCentavos(money.physicalBalanceCentavos)} />}
    </dl>
  </section>
}
