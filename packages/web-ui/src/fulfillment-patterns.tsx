import type { ReactNode } from 'react'
import { AlertTriangle, BadgeCheck, Banknote, CheckCircle2, Circle, CircleDot, Clock, Info, Send, Undo2, XCircle } from 'lucide-react'
import type { CancellationRemedy, FulfillmentStep, OrderRefundTimeline, RefundTimelineItem, ReimbursementTimelineItem } from '@materyalph/api-client-ts'
import { formatPesoCentavos } from './order-patterns'
import { StatusBadge } from './portal-shell'
import { formatManilaDateTime } from './stock-ledger'

const stepStatusText = { COMPLETE: 'Completed', CURRENT: 'Current step', UPCOMING: 'Upcoming' } as const

/**
 * Fulfillment milestones as an ordered stepper. Completion comes only from the server's recorded milestones; the
 * current step can host the proof capture that milestone requires. Status is text plus icon, never color alone,
 * and nothing here animates or implies a live vehicle position.
 */
export function MilestoneStepper({ steps, label = 'Fulfillment milestones', renderProof, currentAction }: {
  steps: FulfillmentStep[]
  label?: string
  renderProof?: (step: FulfillmentStep) => ReactNode
  currentAction?: ReactNode
}) {
  return <ol className="grid min-w-0" aria-label={label}>
    {steps.map((step, index) => {
      const last = index === steps.length - 1
      const Icon = step.status === 'COMPLETE' ? CheckCircle2 : step.status === 'CURRENT' ? CircleDot : Circle
      const tone = step.status === 'COMPLETE' ? 'text-green-800' : step.status === 'CURRENT' ? 'text-action-primary' : 'text-text-secondary'
      return <li key={step.key} className="relative grid min-w-0 grid-cols-[2rem_minmax(0,1fr)] gap-x-3" aria-current={step.status === 'CURRENT' ? 'step' : undefined}>
        <span className="relative flex justify-center" aria-hidden="true">
          <Icon size={22} className={`relative z-10 mt-0.5 bg-surface-primary ${tone}`} />
          {!last && <span className={`absolute bottom-0 top-7 w-px ${step.status === 'COMPLETE' ? 'bg-green-700' : 'bg-border-default'}`} />}
        </span>
        <div className={`grid min-w-0 gap-1 ${last ? '' : 'pb-6'}`}>
          <div className="flex min-w-0 flex-wrap items-baseline justify-between gap-x-3 gap-y-0.5">
            <p className={`font-semibold ${step.status === 'UPCOMING' ? 'text-text-secondary' : 'text-text-strong'}`}>{step.label}</p>
            <span className={`text-xs font-semibold ${tone}`}>{stepStatusText[step.status]}</span>
          </div>
          {step.at && <p className="text-sm text-text-secondary"><time dateTime={step.at.toISOString()}>{formatManilaDateTime(step.at)}</time>{step.actorRole ? ` · ${roleLabel(step.actorRole)}` : ''}</p>}
          {step.proofRequired && step.status !== 'COMPLETE' && <p className="text-xs text-text-secondary">Proof required: {step.proofRequirements.map(proofText).join(', ')}.</p>}
          {step.proof && renderProof?.(step)}
          {step.status === 'CURRENT' && currentAction}
        </div>
      </li>
    })}
  </ol>
}

function proofText(code: string): string {
  return ({ DELIVERY_PHOTO: 'delivery photo', RECEIVER_NAME: 'receiver name', SIGNATURE_OPTIONAL: 'signature (optional)', HANDOVER_CONFIRMATION: 'handover confirmation',
    RECEIVER_TYPE: 'Buyer or authorized receiver' } as Record<string, string>)[code] ?? code.toLowerCase().replaceAll('_', ' ')
}

export function roleLabel(role: string): string {
  return ({ OWNER: 'Owner', STORE_MANAGER: 'Store Manager', STORE_STAFF: 'Store Staff', CUSTOMER_SERVICE: 'Customer Service', FULFILLMENT: 'Fulfillment Staff', INVENTORY: 'Inventory Staff',
    BUYER: 'Buyer', SYSTEM: 'MateryalPH', AUTOMATED_POLICY: 'Automated policy' } as Record<string, string>)[role] ?? role.toLowerCase().replaceAll('_', ' ')
}

const refundDisplay = {
  QUEUED: { label: 'Refund queued', tone: 'warning', icon: Clock },
  INITIATED: { label: 'Refund initiated — awaiting provider confirmation', tone: 'warning', icon: Send },
  PROCESSED: { label: 'Refund processed by the payment provider', tone: 'success', icon: BadgeCheck },
  FAILED: { label: 'Refund failed — action required', tone: 'error', icon: XCircle },
} as const

/** Initiation and success are visibly different: a pending refund never shows a success check. */
export function RefundStatusBadge({ displayState }: { displayState: RefundTimelineItem['displayState'] }) {
  const meta = refundDisplay[displayState] ?? refundDisplay.QUEUED
  const Icon = meta.icon
  return <StatusBadge label={meta.label} tone={meta.tone} icon={<Icon size={14} aria-hidden="true" />} />
}

const triggerText: Record<string, string> = { CANCELLATION: 'Cancellation Refund', DISPUTE_CONCLUSION: 'Dispute-Conclusion Refund', TECHNICAL_COMPENSATION: 'Technical compensation refund', FEE_CREDIT: 'Platform fee credit refund' }
const purposeText: Record<string, string> = { FULL_ORDER_PAYMENT: 'Full order payment', NRPC_ASSURANCE_PAYMENT: 'NRPC assurance payment', ORDER_BALANCE_PAYMENT: 'Online balance payment' }

/**
 * One timeline per original online payment, then any Vendor cash reimbursement and any balance that is No longer
 * due. Money that was never collected is never called Refunded; a failed refund never asks the Buyer to pay again.
 */
export function RefundTimeline({ timeline, audience, onRetry, retryingId, onAcknowledge, acknowledgingId, renderEvidence }: {
  timeline: OrderRefundTimeline
  audience: 'BUYER' | 'VENDOR' | 'ADMIN'
  onRetry?: (refund: RefundTimelineItem) => void
  retryingId?: string | null
  onAcknowledge?: (reimbursement: ReimbursementTimelineItem) => void
  acknowledgingId?: string | null
  renderEvidence?: (path: string, label: string) => ReactNode
}) {
  const empty = timeline.refunds.length === 0 && timeline.reimbursements.length === 0 && timeline.noLongerDueCentavos === 0
  if (empty) return <p className="text-sm text-text-secondary">No refunds or reimbursements on this order.</p>
  return <div className="grid gap-4">
    {timeline.decision && <CancellationDecisionSummary decision={timeline.decision} audience={audience} />}
    {timeline.refunds.length > 0 && <ul className="grid gap-3" aria-label="Refunds to the original payment method">
      {timeline.refunds.map(refund => <li key={refund.id} className={`grid gap-2 border-l-4 pl-3 ${refund.displayState === 'PROCESSED' ? 'border-green-700' : refund.displayState === 'FAILED' ? 'border-red-700' : 'border-amber-500'}`}>
        <div className="flex min-w-0 flex-wrap items-center justify-between gap-2">
          <p className="font-semibold text-text-strong"><Undo2 size={15} className="mr-1.5 inline align-[-2px]" aria-hidden="true" />{triggerText[refund.trigger] ?? 'Refund'}</p>
          <span className="text-lg font-semibold tabular-nums text-text-strong">{formatPesoCentavos(refund.amountCentavos)}</span>
        </div>
        <RefundStatusBadge displayState={refund.displayState} />
        <p className="text-sm text-text-secondary">{refund.message}</p>
        <dl className="grid gap-x-6 gap-y-1 text-sm sm:grid-cols-2">
          <Row label="Original payment" value={`${purposeText[refund.paymentPurpose] ?? refund.paymentPurpose} · ${refund.originalMethod}`} />
          {refund.processingFeeCentavos > 0 && <Row label="Includes processing fee" value={formatPesoCentavos(refund.processingFeeCentavos)} />}
          {refund.requestedAt && <Row label="Initiated" value={formatManilaDateTime(refund.requestedAt)} />}
          {refund.completedAt && <Row label="Processed" value={formatManilaDateTime(refund.completedAt)} />}
          {refund.attemptNumber > 1 && <Row label="Attempt" value={String(refund.attemptNumber)} />}
          {audience !== 'BUYER' && refund.failureCode && <Row label="Failure code" value={refund.failureCode} />}
          {refund.evidenceOrigin === 'SIMULATED' && <Row label="Evidence" value="SIMULATED — no provider call" />}
        </dl>
        {refund.arrivalNote && <p className="flex items-start gap-2 text-sm text-text-secondary"><Info size={15} className="mt-0.5 shrink-0" aria-hidden="true" />{refund.arrivalNote}</p>}
        {refund.canRetry && onRetry && <button type="button" className="inline-flex min-h-11 w-fit items-center gap-2 rounded-control border border-border-default bg-surface-primary px-4 text-sm font-semibold text-text-strong hover:bg-surface-canvas disabled:opacity-50"
          disabled={retryingId === refund.id} onClick={() => onRetry(refund)}>{retryingId === refund.id ? 'Retrying…' : 'Retry refund after funding is resolved'}</button>}
      </li>)}
    </ul>}
    {timeline.reimbursements.map(row => <div key={row.id} className={`grid gap-2 border-l-4 pl-3 ${row.state === 'REIMBURSEMENT_CONFIRMED' ? 'border-green-700' : 'border-amber-500'}`}>
      <div className="flex min-w-0 flex-wrap items-center justify-between gap-2">
        <p className="font-semibold text-text-strong"><Banknote size={15} className="mr-1.5 inline align-[-2px]" aria-hidden="true" />Cash reimbursement by the Vendor</p>
        <span className="text-lg font-semibold tabular-nums">{formatPesoCentavos(row.amountCentavos)}</span>
      </div>
      <StatusBadge label={row.state === 'REIMBURSEMENT_CONFIRMED' ? 'Reimbursement confirmed' : row.hasEvidence ? 'Recorded by the Vendor — awaiting confirmation' : 'Reimbursement pending'}
        tone={row.state === 'REIMBURSEMENT_CONFIRMED' ? 'success' : 'warning'} icon={row.state === 'REIMBURSEMENT_CONFIRMED' ? <BadgeCheck size={14} aria-hidden="true" /> : <Clock size={14} aria-hidden="true" />} />
      <p className="text-sm text-text-secondary">{row.message}</p>
      {row.evidencePath && renderEvidence?.(row.evidencePath, 'Reimbursement evidence')}
      {onAcknowledge && row.state === 'VENDOR_REIMBURSEMENT_PENDING' && row.hasEvidence && <button type="button" disabled={acknowledgingId === row.id} onClick={() => onAcknowledge(row)}
        className="inline-flex min-h-11 w-fit items-center rounded-control bg-action-primary px-4 text-sm font-semibold text-white hover:bg-action-primary-pressed disabled:opacity-50">{acknowledgingId === row.id ? 'Confirming…' : 'I received this cash'}</button>}
    </div>)}
    {timeline.noLongerDueCentavos > 0 && <p className="flex items-start gap-2 border-l-4 border-border-default pl-3 text-sm"><CheckCircle2 size={16} className="mt-0.5 shrink-0 text-text-secondary" aria-hidden="true" />
      <span><strong className="tabular-nums">{formatPesoCentavos(timeline.noLongerDueCentavos)}</strong> not yet paid is <strong>No longer due</strong>. Nothing is refunded for money that was never collected.</span></p>}
  </div>
}

function CancellationDecisionSummary({ decision, audience }: { decision: NonNullable<OrderRefundTimeline['decision']>; audience: 'BUYER' | 'VENDOR' | 'ADMIN' }) {
  const by = decision.decidedBy === 'SYSTEM' ? 'automatically after the Vendor did not respond within 24 hours' : decision.decidedBy === 'VENDOR' ? 'by the Vendor' : 'by the Buyer'
  return <div className="grid gap-1 text-sm">
    <p className="font-semibold text-text-strong">{decision.cause === 'VENDOR' ? 'Cancelled by the Vendor' : 'Cancelled at the Buyer\'s request'} · finalized {by}</p>
    {decision.decidedAt && <p className="text-text-secondary">{formatManilaDateTime(decision.decidedAt)}{decision.reasonCode ? ` · ${decision.reasonCode.toLowerCase().replaceAll('_', ' ')}` : ''}</p>}
    {decision.reason && <p className="text-text-secondary">“{decision.reason}”</p>}
    {decision.nrpcRetainedCentavos > 0 && <p>The Vendor retains the accepted NRPC of <strong className="tabular-nums">{formatPesoCentavos(decision.nrpcRetainedCentavos)}</strong>{audience === 'BUYER' ? ' after substantiating the preparation' : ' with preparation evidence on file'}.</p>}
    {decision.cause === 'VENDOR' && <p>{audience === 'VENDOR' ? 'Any NRPC was forfeited, every Buyer-paid amount is refunded, and this cancellation counts toward your Non-Fulfillment Rate.' : 'Any NRPC was forfeited and every amount you paid is refunded.'}</p>}
  </div>
}

function Row({ label, value }: { label: string; value: string }) {
  return <div className="flex min-w-0 flex-wrap justify-between gap-x-3"><dt className="text-text-secondary">{label}</dt><dd className="font-semibold text-text-strong">{value}</dd></div>
}

const remedyLabels: Record<string, string> = { REPORT_PROBLEM: 'Report a Problem', DISPUTE: 'Dispute', RETURN: 'Return', WARRANTY: 'Warranty', STATUTORY_REMEDIES: 'Statutory remedies' }

/**
 * Why cancellation is or is not available, in text. When it is unavailable at the handover stage, the remaining
 * remedies are listed instead of a disabled button with no explanation.
 */
export function CancellationAvailability({ explanation, remedies = [], action }: { explanation: string; remedies?: CancellationRemedy[]; action?: ReactNode }) {
  return <div className="grid gap-3">
    <p className="flex items-start gap-2 text-sm text-text-strong"><Info size={16} className="mt-0.5 shrink-0 text-blue-900" aria-hidden="true" />{explanation}</p>
    {remedies.length > 0 && <ul className="grid gap-2" aria-label="Remedies that remain available">
      {remedies.map(remedy => <li key={remedy.code} className="flex items-start gap-2 text-sm">
        {remedy.available ? <CheckCircle2 size={16} className="mt-0.5 shrink-0 text-green-800" aria-hidden="true" /> : <AlertTriangle size={16} className="mt-0.5 shrink-0 text-amber-900" aria-hidden="true" />}
        <span><strong>{remedyLabels[remedy.code] ?? remedy.code}.</strong> {remedy.note}</span>
      </li>)}
    </ul>}
    {action}
  </div>
}
