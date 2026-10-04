import { useEffect, useRef, useState, type ReactNode } from 'react'
import {
  AlertTriangle, BadgeCheck, Ban, CircleDot, ClipboardList, FileText, Gavel, Handshake, Info, MessageSquare, Paperclip, RefreshCw, Scale, Send, ShieldAlert, Undo2, UserRoundCheck,
} from 'lucide-react'
import type { DisputeDeadline, DisputeTimelineEntry, InvoiceRecordView, PlatformDocumentRef } from '@materyalph/api-client-ts'
import { Button } from './button'
import { DeadlineCountdown, formatPesoCentavos } from './order-patterns'
import { StatusBadge } from './portal-shell'
import { formatManilaDateTime } from './stock-ledger'
import { readSignedCaseFile } from './web-api-session'

type Tone = 'success' | 'warning' | 'error' | 'info' | 'neutral'

const CASE_STATES: Record<string, [string, Tone]> = {
  OPEN_AWAITING_RESPONSE: ['Awaiting response', 'warning'], MUTUAL_RESOLUTION: ['Mutual resolution', 'info'], ESCALATED_ADMIN_REVIEW: ['Admin review', 'info'],
  AWAITING_CLARIFICATION: ['Awaiting clarification', 'warning'], DECIDED: ['Decided — remedy in progress', 'info'], APPEAL_OPEN: ['Appeal under review', 'warning'],
  RESOLVED: ['Resolved', 'success'], CLOSED_INCONCLUSIVE: ['Closed — inconclusive', 'neutral'],
}
const ISSUES: Record<string, string> = {
  WRONG_ITEM: 'Wrong item', DEFECTIVE: 'Defective item', INCOMPLETE_DELIVERY: 'Incomplete delivery', LATE_OR_MISSING: 'Late or missing fulfillment', MISLEADING_LISTING: 'Misleading listing',
  PAYMENT: 'Payment issue', INVOICE: 'Invoice issue', OTHER_TRANSACTION: 'Other transaction issue', PHYSICAL_PAYMENT_NOT_RECEIVED: 'Cash payment not received', PICKUP_NO_SHOW: 'Pickup no-show',
  ABUSIVE_COMMUNICATION: 'Abusive communication', FALSE_EVIDENCE: 'False evidence', INACCESSIBLE_DELIVERY_SITE: 'Inaccessible delivery site',
}
const REMEDIES: Record<string, string> = {
  REPLACEMENT: 'Replacement', FULL_REFUND: 'Full refund', PARTIAL_REFUND: 'Partial refund', RETURN_AND_REFUND: 'Return and refund', INVOICE_CORRECTION: 'Invoice correction',
  PAYMENT_OF_BALANCE: 'Payment of the balance', WARNING_ONLY: 'Warning only', OTHER: 'Other remedy', NO_FURTHER_ACTION: 'No further action', DISMISSED: 'Dismissed', INCONCLUSIVE: 'Inconclusive, with monitoring',
}
const EVENTS: Record<string, string> = {
  CASE_FILED: 'Case filed', RESPONSE_SUBMITTED: 'Response submitted', EVIDENCE_ADDED: 'Evidence added', MESSAGE: 'Message', PROPOSAL_MADE: 'Resolution proposed', PROPOSAL_ACCEPTED: 'Proposal accepted',
  PROPOSAL_REJECTED: 'Proposal rejected', AGREEMENT_RECORDED: 'Agreement recorded', ESCALATED: 'Escalated to Admin review', CLARIFICATION_REQUESTED: 'Clarification requested',
  CLARIFICATION_ANSWERED: 'Clarification answered', CLARIFICATION_EXPIRED: 'Clarification not answered in time', DECISION_ISSUED: 'Decision issued', DECISION_ENFORCEABLE: 'Decision final — remedy started',
  APPEAL_FILED: 'Appeal filed', APPEAL_DECIDED: 'Appeal decided', REMEDY_CREATED: 'Remedy created', REMEDY_UPDATED: 'Remedy updated', REMEDY_COMPLETED: 'Remedy completed',
  REFUND_UPDATED: 'Refund status', SANCTION_RECORDED: 'Sanction recorded', HANDLER_ASSIGNED: 'Handler assigned', HANDLER_REASSIGNED: 'Handler reassigned', CASE_RESOLVED: 'Case resolved',
  CASE_CLOSED_INCONCLUSIVE: 'Case closed — inconclusive', ORDER_HOLD_CHANGED: 'Order updated',
}
const EVENT_ICONS: Record<string, typeof Scale> = {
  CASE_FILED: ClipboardList, RESPONSE_SUBMITTED: Send, EVIDENCE_ADDED: Paperclip, MESSAGE: MessageSquare, PROPOSAL_MADE: Handshake, PROPOSAL_ACCEPTED: BadgeCheck, PROPOSAL_REJECTED: Ban,
  AGREEMENT_RECORDED: Handshake, ESCALATED: ShieldAlert, CLARIFICATION_REQUESTED: Info, CLARIFICATION_ANSWERED: Send, CLARIFICATION_EXPIRED: AlertTriangle, DECISION_ISSUED: Gavel,
  DECISION_ENFORCEABLE: Gavel, APPEAL_FILED: Scale, APPEAL_DECIDED: Gavel, REMEDY_CREATED: Undo2, REMEDY_UPDATED: RefreshCw, REMEDY_COMPLETED: BadgeCheck, REFUND_UPDATED: Undo2,
  SANCTION_RECORDED: ShieldAlert, HANDLER_ASSIGNED: UserRoundCheck, HANDLER_REASSIGNED: UserRoundCheck, CASE_RESOLVED: BadgeCheck, CASE_CLOSED_INCONCLUSIVE: CircleDot, ORDER_HOLD_CHANGED: Info,
}
const ROLES: Record<string, string> = {
  OWNER: 'Owner', STORE_MANAGER: 'Store Manager', STORE_STAFF: 'Store Staff', CUSTOMER_SERVICE: 'Customer Service', FULFILLMENT: 'Fulfillment Staff', INVENTORY: 'Inventory Staff', BUYER: 'Buyer',
  SYSTEM: 'MateryalPH', ADMIN_ORDER_DISPUTE: 'Order and Dispute Staff', ADMIN_SUPERADMIN: 'Super Admin',
}
const PARTIES: Record<string, string> = { BUYER: 'Buyer', VENDOR: 'Store', ADMIN: 'MateryalPH', SYSTEM: 'MateryalPH' }

export const disputeIssueLabel = (code: string): string => ISSUES[code] ?? code.toLowerCase().replaceAll('_', ' ')
export const disputeRemedyLabel = (code: string): string => REMEDIES[code] ?? code.toLowerCase().replaceAll('_', ' ')
export const disputeStateLabel = (code: string): string => CASE_STATES[code]?.[0] ?? code.toLowerCase().replaceAll('_', ' ')
export const disputeEventLabel = (code: string): string => EVENTS[code] ?? code.toLowerCase().replaceAll('_', ' ')
export const disputeRoleLabel = (role: string | null | undefined): string => (role ? ROLES[role] ?? role.toLowerCase().replaceAll('_', ' ') : '')

/** Case state as text plus icon; color only reinforces it. */
export function DisputeStatusBadge({ status }: { status: string }) {
  const [label, tone] = CASE_STATES[status] ?? [disputeStateLabel(status), 'neutral' as Tone]
  return <StatusBadge label={label} tone={tone} icon={<Scale size={14} aria-hidden="true" />} />
}

const DEADLINE_LABELS: Record<string, string> = { RESPONSE: 'Response due in', MUTUAL_RESOLUTION: 'Agreement window closes in', CLARIFICATION: 'Clarification due in', APPEAL: 'Appeal window closes in' }

/** Every active deadline as a live countdown plus the exact Asia/Manila date and time. */
export function DisputeDeadlines({ deadlines, onExpire, partyNote }: { deadlines: DisputeDeadline[]; onExpire?: () => void; partyNote?: (deadline: DisputeDeadline) => string }) {
  if (deadlines.length === 0) return null
  return <div className="grid gap-2" aria-label="Case deadlines">
    {deadlines.map(deadline => <div key={deadline.kind} className="grid gap-1">
      <DeadlineCountdown at={deadline.at} label={DEADLINE_LABELS[deadline.kind] ?? 'Due in'} endedLabel="Deadline passed — updating the case" {...(onExpire ? { onExpire } : {})} />
      {partyNote && <p className="text-xs text-text-secondary">{partyNote(deadline)}</p>}
    </div>)}
  </div>
}

/**
 * Opens case evidence or an invoice copy through its five-minute signed link. An expired link asks for a refresh
 * instead of failing silently; the file is shown in a modal preview and never cached.
 */
export function SignedFileButton({ url, label, apiBasePath, onExpired }: { url: string; label: string; apiBasePath: string; onExpired?: () => void }) {
  const dialog = useRef<HTMLDialogElement>(null)
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [preview, setPreview] = useState<{ url: string; type: string } | null>(null)
  useEffect(() => {
    if (!preview) return
    dialog.current?.showModal()
    return () => URL.revokeObjectURL(preview.url)
  }, [preview])
  async function open() {
    setBusy(true); setError(null)
    try {
      const blob = await readSignedCaseFile(apiBasePath, url)
      setPreview({ url: URL.createObjectURL(blob), type: blob.type })
    } catch (cause) {
      const status = (cause as { response?: { status?: number } })?.response?.status
      setError(status === 403 ? 'This link expired. Refresh to get a new one.' : 'The file could not be opened. Try again.')
      if (status === 403) onExpired?.()
    } finally { setBusy(false) }
  }
  return <span className="inline-flex min-w-0 flex-wrap items-center gap-2">
    <button type="button" disabled={busy} onClick={() => void open()}
      className="inline-flex min-h-11 min-w-0 items-center gap-1.5 rounded-control px-1 text-sm font-semibold text-action-primary underline-offset-4 hover:underline disabled:opacity-50">
      <Paperclip size={15} aria-hidden="true" /><span className="truncate">{busy ? 'Opening…' : label}</span>
    </button>
    {error && <span role="alert" className="text-sm text-status-error">{error}</span>}
    {preview && <dialog ref={dialog} aria-label={label} onClose={() => setPreview(null)} className="fixed inset-0 m-auto max-h-[90dvh] w-[min(96vw,1100px)] max-w-none rounded-surface border border-border-default bg-surface-primary p-4 text-text-strong backdrop:bg-black/50">
      <div className="mb-4 flex items-center justify-between gap-4"><h2 className="min-w-0 truncate text-lg font-semibold">{label}</h2><Button variant="secondary" onClick={() => dialog.current?.close()}>Close preview</Button></div>
      {preview.type.startsWith('image/') ? <img src={preview.url} alt={label} className="max-h-[70dvh] w-full object-contain" /> : <iframe src={preview.url} title={label} className="h-[70dvh] w-full border-0" />}
    </dialog>}
  </span>
}

const AMOUNT_KEYS = ['amount_centavos', 'awarded_centavos', 'requested_amount_centavos']

function detailText(entry: DisputeTimelineEntry): string | null {
  const details = entry.details as Record<string, unknown>
  const parts: string[] = []
  if (typeof details.position === 'string') parts.push(details.position.toLowerCase().replaceAll('_', ' '))
  if (typeof details.remedy === 'string') parts.push(disputeRemedyLabel(details.remedy))
  if (typeof details.outcome === 'string') parts.push(disputeRemedyLabel(details.outcome))
  if (typeof details.result === 'string') parts.push(`appeal ${details.result.toLowerCase()}`)
  if (typeof details.version === 'number') parts.push(`version ${details.version}`)
  if (typeof details.grounds === 'string') parts.push(details.grounds === 'NEW_EVIDENCE' ? 'new evidence' : 'material process error')
  for (const key of AMOUNT_KEYS) if (typeof details[key] === 'number' && (details[key] as number) > 0) parts.push(formatPesoCentavos(details[key] as number))
  if (typeof details.due_at === 'string') parts.push(`due ${formatManilaDateTime(details.due_at)}`)
  if (typeof details.appeal_due_at === 'string') parts.push(`appeal by ${formatManilaDateTime(details.appeal_due_at)}`)
  if (details.enforceable === true) parts.push('immediately enforceable')
  return parts.length ? parts.join(' · ') : null
}

/**
 * The single chronological case surface. Each entry shows what happened, who did it (name, role and party), the exact
 * Asia/Manila time and its evidence, which opens through a short-lived signed link. Entries are append-only.
 */
export function DisputeTimeline({ entries, apiBasePath, onLinkExpired, emptyText = 'No case activity yet.' }: { entries: DisputeTimelineEntry[]; apiBasePath: string; onLinkExpired?: () => void; emptyText?: string }) {
  if (entries.length === 0) return <p className="text-sm text-text-secondary">{emptyText}</p>
  return <ol className="grid min-w-0" aria-label="Case timeline">
    {entries.map((entry, index) => {
      const Icon = EVENT_ICONS[entry.type] ?? CircleDot
      const last = index === entries.length - 1
      const details = detailText(entry)
      return <li key={entry.id} className="relative grid min-w-0 grid-cols-[2rem_minmax(0,1fr)] gap-x-3">
        <span className="relative flex justify-center" aria-hidden="true">
          <span className={`relative z-10 mt-0.5 flex h-7 w-7 items-center justify-center rounded-full border ${entry.actor.party === 'ADMIN' || entry.actor.party === 'SYSTEM' ? 'border-blue-300 bg-blue-50 text-blue-900' : entry.actor.party === 'BUYER' ? 'border-border-default bg-surface-canvas text-text-strong' : 'border-brand-orange-200 bg-brand-orange-50 text-action-primary'}`}>
            <Icon size={14} />
          </span>
          {!last && <span className="absolute bottom-0 top-8 w-px bg-border-default" />}
        </span>
        <article className={`grid min-w-0 gap-1 ${last ? '' : 'pb-5'}`} aria-label={`${disputeEventLabel(entry.type)} by ${entry.actor.displayName}`}>
          <div className="flex min-w-0 flex-wrap items-baseline justify-between gap-x-3 gap-y-0.5">
            <p className="font-semibold text-text-strong">{disputeEventLabel(entry.type)}</p>
            {entry.at && <time className="text-xs text-text-secondary tabular-nums" dateTime={entry.at.toISOString()}>{formatManilaDateTime(entry.at)}</time>}
          </div>
          <p className="text-sm text-text-secondary">{entry.actor.displayName}{entry.actor.role && entry.actor.party !== 'SYSTEM' ? ` · ${disputeRoleLabel(entry.actor.role)}` : ''} · {PARTIES[entry.actor.party] ?? entry.actor.party}</p>
          {details && <p className="text-sm font-semibold text-text-strong">{details}</p>}
          {entry.body && <p className="whitespace-pre-line break-words text-sm text-text-strong">{entry.body}</p>}
          {entry.evidence.length > 0 && <ul className="flex min-w-0 flex-wrap gap-x-4" aria-label="Evidence">{entry.evidence.map(file => <li key={file.fileId} className="min-w-0">
            <SignedFileButton url={file.url} label={file.name || 'Evidence'} apiBasePath={apiBasePath} {...(onLinkExpired ? { onExpired: onLinkExpired } : {})} />
          </li>)}</ul>}
        </article>
      </li>
    })}
  </ol>
}

/** The masked original payment method, read-only. There is never a field for another refund destination. */
export function OriginalPaymentMethodNotice({ label, notice }: { label: string; notice?: string }) {
  return <div className="flex items-start gap-2 rounded-control border border-border-default bg-surface-canvas px-3 py-2 text-sm" role="note">
    <Info size={16} className="mt-0.5 shrink-0 text-blue-900" aria-hidden="true" />
    <span><strong>{label}</strong><span className="block text-text-secondary">{notice ?? 'Any refund returns to this original payment method. MateryalPH never asks for another card, e-wallet or bank account.'}</span></span>
  </div>
}

const RECONCILIATION: Record<string, [string, Tone]> = {
  MATCHED: ['Matches the accepted order', 'success'], INVOICE_RECONCILIATION_REQUIRED: ['Differs from the accepted order', 'warning'], EXPLAINED: ['Difference explained', 'info'],
  CORRECTED: ['Corrected by a later document', 'success'], NOT_APPLICABLE: ['Adjustment document', 'neutral'],
}
const INVOICE_TYPES: Record<string, string> = { VENDOR_GOODS_INVOICE: 'Vendor sales invoice', VENDOR_ADJUSTMENT_DOCUMENT: 'Vendor adjustment document', PLATFORM_SERVICE_INVOICE: 'Platform service invoice', PROCESSOR_INVOICE: 'Processor invoice' }

/**
 * Invoice copies with their provenance. A DEMO sample is labelled; no upload is presented as BIR or structured
 * e-invoicing compliance; a reconciliation difference never changes the accepted Buyer total.
 */
export function InvoiceRecordList({ records, apiBasePath, renderAction }: { records: InvoiceRecordView[]; apiBasePath: string; renderAction?: (record: InvoiceRecordView) => ReactNode }) {
  if (records.length === 0) return <p className="text-sm text-text-secondary">No invoice copy uploaded yet.</p>
  return <ul className="grid divide-y divide-border-default rounded-surface border border-border-default bg-surface-primary" aria-label="Invoice records">
    {records.map(record => {
      const [reconciliation, tone] = RECONCILIATION[record.reconciliationState] ?? [record.reconciliationState, 'neutral' as Tone]
      return <li key={record.id} className="grid min-w-0 gap-2 px-4 py-3">
        <div className="flex min-w-0 flex-wrap items-center justify-between gap-2">
          <p className="flex min-w-0 items-center gap-2 font-semibold"><FileText size={16} aria-hidden="true" /><span className="min-w-0 break-words">{INVOICE_TYPES[record.invoiceType] ?? record.invoiceType} · {record.invoiceNumber}</span></p>
          <span className="text-lg font-semibold tabular-nums">{formatPesoCentavos(record.amountCentavos)}</span>
        </div>
        <div className="flex flex-wrap gap-2">
          <StatusBadge label={record.originLabel} tone={record.documentOrigin === 'DEMO_SAMPLE' ? 'warning' : 'neutral'} />
          <StatusBadge label={reconciliation} tone={tone} />
          <StatusBadge label={record.verificationState === 'VERIFIED' ? 'Verified' : 'Not verified as compliant'} tone="neutral" />
        </div>
        <dl className="grid gap-x-6 gap-y-1 text-sm sm:grid-cols-2">
          <div className="flex flex-wrap justify-between gap-x-3"><dt className="text-text-secondary">Issuer</dt><dd className="font-semibold">{record.issuer}</dd></div>
          <div className="flex flex-wrap justify-between gap-x-3"><dt className="text-text-secondary">Invoice date</dt><dd className="font-semibold">{record.issuedOn}</dd></div>
          {record.vatCentavos !== null && record.vatCentavos !== undefined && <div className="flex flex-wrap justify-between gap-x-3"><dt className="text-text-secondary">VAT shown</dt><dd className="font-semibold tabular-nums">{formatPesoCentavos(record.vatCentavos)}</dd></div>}
          {record.uploadedAt && <div className="flex flex-wrap justify-between gap-x-3"><dt className="text-text-secondary">Uploaded</dt><dd className="font-semibold">{formatManilaDateTime(record.uploadedAt)}</dd></div>}
          {record.reconciliationState === 'INVOICE_RECONCILIATION_REQUIRED' && record.expectedTotalCentavos !== null && record.expectedTotalCentavos !== undefined && <div className="flex flex-wrap justify-between gap-x-3 sm:col-span-2">
            <dt className="text-text-secondary">Accepted order amount</dt><dd className="font-semibold tabular-nums">{formatPesoCentavos(record.expectedTotalCentavos)} (difference {formatPesoCentavos(record.reconciliationDifferenceCentavos)})</dd></div>}
        </dl>
        {record.reconciliationNote && <p className="text-sm text-text-secondary">Explanation: {record.reconciliationNote}</p>}
        <p className="text-xs text-text-secondary">{record.complianceNote}</p>
        <div className="flex flex-wrap items-center gap-3">
          {record.download && <SignedFileButton url={record.download.url} label="Open invoice copy" apiBasePath={apiBasePath} />}
          {renderAction?.(record)}
        </div>
      </li>
    })}
  </ul>
}

/** MateryalPH's own Purchase Order and payment confirmation, each visibly labelled "Not a tax invoice". */
export function PlatformDocumentNotice({ documents }: { documents: PlatformDocumentRef[] }) {
  return <ul className="grid gap-2" aria-label="MateryalPH documents">
    {documents.map(document => <li key={document.kind} className="flex min-w-0 flex-wrap items-center justify-between gap-2 rounded-control border border-border-default bg-surface-canvas px-3 py-2 text-sm">
      <span className="flex min-w-0 items-center gap-2"><FileText size={15} aria-hidden="true" />{document.title}</span>
      <StatusBadge label={document.label} tone="neutral" icon={<Ban size={14} aria-hidden="true" />} />
    </li>)}
  </ul>
}
