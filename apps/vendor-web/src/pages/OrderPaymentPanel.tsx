import { useState, type FormEvent } from 'react'
import { BadgeCheck, Banknote, Clock, FileCheck2 } from 'lucide-react'
import { Button, EvidenceFilePicker, PaymentAttemptBadge, StatusMessage, formatManilaDateTime, formatPesoCentavos } from '@materyalph/web-ui'
import { approveOnlineBalance, confirmHandoverCash, readableFinanceError, recordPhysicalPayment } from '../lib/finance-api'
import { newIdempotencyKey } from '../lib/onboarding-api'
import { pesoInputToCentavos, type OrderDetail } from '../lib/orders-api'

const RECORD_LABELS: Record<string, string> = {
  OBLIGATION_OPENED: 'Balance opened', COLLECTION: 'Cash received (your record)', ONLINE_BALANCE_CREDIT: 'Online balance payment (verified)', CORRECTION: 'Correction', CANCELLATION_RELEASE: 'Released on cancellation',
}

/**
 * Order-specific payment status for staff working this order. It never shows store-wide finance. A Vendor cash
 * record is not an online payment confirmation; online payments read Paid only after provider verification.
 */
export function OrderPaymentPanel({ order, onChanged }: { order: OrderDetail; onChanged: () => void }) {
  const payment = order.payment
  const physical = payment?.physical
  const verified = payment?.verifiedPayment
  const latest = payment?.latestAttempt
  if (!payment) return null
  return <section aria-labelledby="order-payment-heading" className="grid gap-3 rounded-surface border border-border-default bg-surface-primary p-4">
    <div className="flex items-center justify-between gap-2"><h2 id="order-payment-heading" className="text-base font-semibold">Payment</h2><span className="text-xs font-semibold text-text-secondary">TEST</span></div>
    {verified && <div className="grid gap-1 text-sm"><PaymentAttemptBadge status={verified.status} /><p className="text-text-secondary">{formatPesoCentavos(verified.totalCentavos)} via {verified.channelName ?? 'online'} · {formatManilaDateTime(verified.paidAt)}</p></div>}
    {!verified && latest && <div className="grid gap-1 text-sm"><PaymentAttemptBadge status={latest.status} /><p className="text-text-secondary">{latest.message}</p></div>}
    {!verified && !latest && order.paymentMethod === 'ONLINE' && <p className="text-sm text-text-secondary">No payment attempt yet. The Buyer pays after accepting the final amount.</p>}
    {physical?.applicable && <PhysicalPanel order={order} onChanged={onChanged} />}
  </section>
}

function PhysicalPanel({ order, onChanged }: { order: OrderDetail; onChanged: () => void }) {
  const physical = order.payment!.physical!
  const remaining = physical.remainingCentavos ?? null
  const canRecord = Boolean(order.permissions?.canRecordPhysicalPayment) && remaining !== null && remaining > 0
  const canApprove = Boolean(order.permissions?.canApproveOnlineBalance) && remaining !== null && remaining > 0
  const [amount, setAmount] = useState('')
  const [note, setNote] = useState('')
  const [file, setFile] = useState<File | null>(null)
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<{ tone: 'success' | 'error'; text: string } | null>(null)
  const [key, setKey] = useState(newIdempotencyKey)

  async function record(event: FormEvent) {
    event.preventDefault()
    setMessage(null)
    const centavos = pesoInputToCentavos(amount)
    if (centavos === null || centavos < 1 || (remaining !== null && centavos > remaining)) { setMessage({ tone: 'error', text: `Enter an amount from ₱0.01 to ${formatPesoCentavos(remaining)}.` }); return }
    if (!file) { setMessage({ tone: 'error', text: 'Attach a photo or PDF of the receipt as evidence.' }); return }
    setBusy(true)
    try {
      await recordPhysicalPayment(order.id, centavos, file, note, key)
      setMessage({ tone: 'success', text: 'Payment recorded. The Buyer is asked to acknowledge it.' })
      setAmount(''); setNote(''); setFile(null); setKey(newIdempotencyKey())
      onChanged()
    } catch (cause) { setMessage({ tone: 'error', text: await readableFinanceError(cause) }) }
    finally { setBusy(false) }
  }
  async function approve() {
    setBusy(true); setMessage(null)
    try { await approveOnlineBalance(order.id); setMessage({ tone: 'success', text: 'The Buyer can now pay the remaining balance online.' }); onChanged() }
    catch (cause) { setMessage({ tone: 'error', text: await readableFinanceError(cause) }) }
    finally { setBusy(false) }
  }

  return <div className="grid gap-3 border-t border-border-default pt-3">
    <div className="flex items-center gap-2 text-sm font-semibold"><Banknote size={16} aria-hidden="true" />{physical.method === 'CASH_ON_DELIVERY' ? 'Cash on Delivery' : 'In-Store Payment'}</div>
    <p className="text-sm">Outstanding: <strong className="tabular-nums">{formatPesoCentavos(remaining)}</strong>{physical.onlineBalanceApproved && remaining ? ' · online balance payment allowed' : ''}</p>
    {physical.records.length > 0 && <ul className="grid gap-2 text-sm">{physical.records.filter(row => row.kind !== 'OBLIGATION_OPENED').map(row => <li key={row.id} className="flex flex-wrap justify-between gap-2">
      <span className="flex items-center gap-1.5">{row.kind === 'ONLINE_BALANCE_CREDIT' ? <BadgeCheck size={14} aria-hidden="true" /> : <FileCheck2 size={14} aria-hidden="true" />}{RECORD_LABELS[row.kind] ?? row.kind}{row.buyerAcknowledgedAt ? ' · Buyer acknowledged' : ''}</span>
      <span className="tabular-nums font-semibold">{formatPesoCentavos(row.amountCentavos)}</span></li>)}</ul>}
    {message && <StatusMessage tone={message.tone}>{message.text}</StatusMessage>}
    {physical.handoverCash && <HandoverCash order={order} onChanged={onChanged} onMessage={setMessage} />}
    {canRecord && <form className="grid gap-3" onSubmit={event => void record(event)} aria-label="Record payment received">
      <label className="grid gap-1.5 text-sm font-semibold">Amount received (₱)<input className="min-h-12 rounded-control border border-border-default px-3 text-base font-normal" inputMode="decimal" value={amount} disabled={busy} onChange={event => setAmount(event.target.value)} /></label>
      <EvidenceFilePicker label="Receipt evidence" file={file} onChange={setFile} disabled={busy} />
      <label className="grid gap-1.5 text-sm font-semibold">Note (optional)<input className="min-h-12 rounded-control border border-border-default px-3 text-base font-normal" maxLength={500} value={note} disabled={busy} onChange={event => setNote(event.target.value)} /></label>
      <Button type="submit" variant="secondary" disabled={busy}>{busy ? 'Recording…' : 'Record payment received'}</Button>
    </form>}
    {canApprove && !physical.onlineBalanceApproved && <Button variant="secondary" disabled={busy} onClick={() => void approve()}>Allow Buyer to pay balance online</Button>}
  </div>
}

/**
 * Cash Fulfillment Staff reported at Delivered / Picked up. It counts as collected only after a member who may record
 * cash confirms it; the handover photo is the evidence unless the handover had none, which then needs a receipt.
 */
function HandoverCash({ order, onChanged, onMessage }: { order: OrderDetail; onChanged: () => void; onMessage: (message: { tone: 'success' | 'error'; text: string }) => void }) {
  const handover = order.payment!.physical!.handoverCash!
  const canConfirm = Boolean(order.permissions?.canRecordPhysicalPayment)
  const [file, setFile] = useState<File | null>(null)
  const [busy, setBusy] = useState(false)
  const [key, setKey] = useState(newIdempotencyKey)
  const place = handover.milestone === 'PICKED_UP' ? 'pickup' : 'delivery'

  async function confirm() {
    if (!handover.hasPhoto && !file) { onMessage({ tone: 'error', text: 'This handover has no photo. Attach a receipt photo or PDF to confirm the cash.' }); return }
    setBusy(true)
    try {
      await confirmHandoverCash(order.id, file, key)
      setKey(newIdempotencyKey())
      onMessage({ tone: 'success', text: `${formatPesoCentavos(handover.confirmableCentavos)} recorded as cash received. The Buyer is asked to acknowledge it.` })
      onChanged()
    } catch (cause) { onMessage({ tone: 'error', text: await readableFinanceError(cause) }) }
    finally { setBusy(false) }
  }

  return <div className="grid gap-3 rounded-control border border-amber-300 bg-amber-50 p-3 text-sm text-amber-950">
    <p className="flex items-start gap-2"><Clock size={16} className="mt-0.5 shrink-0" aria-hidden="true" />
      <span><strong className="tabular-nums">{formatPesoCentavos(handover.reportedCentavos)}</strong> cash was reported at {place} on {formatManilaDateTime(handover.reportedAt)}. {canConfirm ? 'Confirm it once the cash is with the store.' : 'The Owner, Store Manager or Store Staff confirms it.'}</span></p>
    {canConfirm && <>
      {!handover.hasPhoto && <EvidenceFilePicker label="Receipt evidence" file={file} onChange={setFile} disabled={busy} />}
      <Button variant="secondary" className="w-fit" disabled={busy} onClick={() => void confirm()}>{busy ? 'Confirming…' : `Confirm ${formatPesoCentavos(handover.confirmableCentavos)} received`}</Button>
    </>}
  </div>
}
