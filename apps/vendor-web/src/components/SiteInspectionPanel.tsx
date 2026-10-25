import { useState } from 'react'
import type { SiteInspection, SiteInspectionDecision } from '@materyalph/api-client-ts'
import { Button, Field, FormDialog, StatusMessage, formatManilaDateTime } from '@materyalph/web-ui'
import { CalendarClock, MapPin, Ruler } from 'lucide-react'
import { manilaInstant } from '../lib/ready-mixed-concrete'

type Action = 'schedule' | 'decline' | 'complete'

const STATUS_LABELS: Record<string, string> = { REQUESTED: 'Requested', SCHEDULED: 'Scheduled', COMPLETED: 'Completed', DECLINED: 'Declined', CANCELLED: 'Cancelled by Buyer' }
const VOLUME = /^\d{1,6}(\.\d{1,3})?$/

/** Generated calendar dates use local midnight; keep their calendar day when displaying them. */
const preferredDateText = (date: Date) => date.toLocaleDateString('en-PH', { dateStyle: 'medium' })

/**
 * Free Site Inspection / Estimate requests in a sales conversation (owner decision 2026-10-16). The store
 * schedules, declines, or records the measured volume; a quotation for that volume is then prepared through
 * the normal quotation editor. The server decides which actions the viewer may take.
 */
export function SiteInspectionPanel({ inspections, busy, onDecide, onPrepareQuotation }: {
  inspections: SiteInspection[]; busy: boolean
  onDecide: (inspection: SiteInspection, action: Action, decision: SiteInspectionDecision) => Promise<void>
  onPrepareQuotation?: (() => void) | undefined
}) {
  const [dialog, setDialog] = useState<{ inspection: SiteInspection; action: Action } | null>(null)
  if (inspections.length === 0) return null
  const [latest, ...older] = inspections
  return <section aria-labelledby="site-inspections-heading" className="mx-5 my-4 grid gap-3 rounded-surface border border-border-default bg-surface-primary p-4">
    <div className="flex flex-wrap items-center justify-between gap-2">
      <h3 id="site-inspections-heading" className="font-semibold">Free site inspection</h3>
      <span className="text-xs text-text-secondary">No charge to the Buyer · creates no order</span>
    </div>
    {latest && <InspectionSummary inspection={latest} busy={busy} onAction={action => setDialog({ inspection: latest, action })} onPrepareQuotation={onPrepareQuotation} />}
    {older.length > 0 && <details className="text-sm"><summary className="min-h-11 cursor-pointer py-2 font-semibold text-action-primary">Earlier requests ({older.length})</summary>
      <ul className="grid gap-2">{older.map(item => <li key={item.id} className="text-text-secondary">{item.listing.displayName} · {STATUS_LABELS[item.status] ?? item.status} · requested {formatManilaDateTime(item.requestedAt)}{item.measuredVolumeM3 ? ` · ${Number(item.measuredVolumeM3)} m³` : ''}</li>)}</ul>
    </details>}
    {dialog && <DecisionDialog key={`${dialog.inspection.id}-${dialog.action}`} inspection={dialog.inspection} action={dialog.action} onClose={() => setDialog(null)} onSubmit={async decision => { await onDecide(dialog.inspection, dialog.action, decision); setDialog(null) }} />}
  </section>
}

function InspectionSummary({ inspection, busy, onAction, onPrepareQuotation }: { inspection: SiteInspection; busy: boolean; onAction: (action: Action) => void; onPrepareQuotation?: (() => void) | undefined }) {
  const site = [inspection.site.label, inspection.site.formattedAddress].filter(Boolean).join(' — ')
  return <div className="grid gap-3 text-sm">
    <p><span className="font-semibold">{inspection.listing.displayName}{inspection.variant?.label ? ` · ${inspection.variant.label}` : ''}</span> <span className="ml-1 rounded-pill bg-surface-canvas px-2 py-0.5 text-xs font-semibold">{STATUS_LABELS[inspection.status] ?? inspection.status}</span></p>
    <dl className="grid gap-2 sm:grid-cols-2">
      <div className="flex gap-2"><MapPin size={16} className="mt-0.5 shrink-0 text-text-secondary" aria-hidden="true" /><div><dt className="text-text-secondary">Site</dt><dd className="break-words">{site || 'Saved location'}</dd></div></div>
      <div className="flex gap-2"><CalendarClock size={16} className="mt-0.5 shrink-0 text-text-secondary" aria-hidden="true" /><div><dt className="text-text-secondary">{inspection.scheduledFor ? 'Scheduled' : 'Preferred date'}</dt><dd>{inspection.scheduledFor ? `${formatManilaDateTime(inspection.scheduledFor)} (Philippine time)` : preferredDateText(inspection.preferredDate)}</dd></div></div>
      {inspection.measuredVolumeM3 && <div className="flex gap-2"><Ruler size={16} className="mt-0.5 shrink-0 text-text-secondary" aria-hidden="true" /><div><dt className="text-text-secondary">Measured volume</dt><dd className="font-semibold tabular-nums">{Number(inspection.measuredVolumeM3)} m³</dd></div></div>}
    </dl>
    {inspection.buyerNotes && <p className="rounded-control bg-surface-canvas px-3 py-2"><span className="font-semibold">Buyer notes: </span>{inspection.buyerNotes}</p>}
    {inspection.vendorNote && <p className="text-text-secondary"><span className="font-semibold text-text-strong">Store note: </span>{inspection.vendorNote}</p>}
    <div className="flex flex-wrap gap-2">
      {inspection.actions.schedule && <Button variant="secondary" disabled={busy} onClick={() => onAction('schedule')}>{inspection.status === 'SCHEDULED' ? 'Reschedule' : 'Schedule visit'}</Button>}
      {inspection.actions.complete && <Button disabled={busy} onClick={() => onAction('complete')}>Record measured volume</Button>}
      {inspection.actions.decline && <Button variant="quiet" disabled={busy} onClick={() => onAction('decline')}>Decline</Button>}
      {inspection.status === 'COMPLETED' && onPrepareQuotation && <Button variant="secondary" disabled={busy} onClick={onPrepareQuotation}>Prepare quotation for {Number(inspection.measuredVolumeM3)} m³</Button>}
    </div>
  </div>
}

function DecisionDialog({ inspection, action, onClose, onSubmit }: { inspection: SiteInspection; action: Action; onClose: () => void; onSubmit: (decision: SiteInspectionDecision) => Promise<void> }) {
  const [when, setWhen] = useState('')
  const [text, setText] = useState('')
  const [volume, setVolume] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  const titles: Record<Action, string> = { schedule: 'Schedule the site visit', decline: 'Decline the inspection', complete: 'Record the measured volume' }
  async function submit() {
    const decision: SiteInspectionDecision = { lockVersion: inspection.lockVersion }
    if (action === 'schedule') {
      const instant = manilaInstant(when)
      if (!instant || new Date(instant) <= new Date()) { setError('Choose a future date and time.'); return }
      decision.scheduledFor = new Date(instant)
      if (text.trim()) decision.note = text.trim()
    } else if (action === 'decline') {
      if (text.trim().length < 10) { setError('Explain the reason in at least 10 characters.'); return }
      decision.reason = text.trim()
    } else {
      if (!VOLUME.test(volume.trim()) || Number(volume) <= 0) { setError('Enter the volume in cubic meters, above zero, with up to 3 decimals.'); return }
      decision.measuredVolumeM3 = volume.trim()
      if (text.trim()) decision.note = text.trim()
    }
    setBusy(true); setError(null)
    try { await onSubmit(decision) } catch (cause) { setError(cause instanceof Error ? cause.message : 'The inspection could not be updated.') } finally { setBusy(false) }
  }
  return <FormDialog open size="compact" busy={busy} title={titles[action]} onClose={onClose}
    description={action === 'complete' ? 'The Buyer sees this volume. Then prepare a quotation for it; nothing is ordered until the Buyer accepts.' : action === 'decline' ? 'The Buyer sees your reason in the conversation.' : 'Times are in Philippine time. The Buyer is notified.'}
    footer={<><Button variant="secondary" disabled={busy} onClick={onClose}>Cancel</Button><Button disabled={busy} onClick={() => void submit()}>{busy ? 'Saving…' : action === 'schedule' ? 'Save schedule' : action === 'decline' ? 'Decline request' : 'Save volume'}</Button></>}>
    <div className="grid gap-4">
      {error && <StatusMessage tone="error">{error}</StatusMessage>}
      {action === 'schedule' && <Field label="Visit date and time" name="scheduled_for" type="datetime-local" value={when} onChange={event => setWhen(event.target.value)} hint={`Buyer prefers ${preferredDateText(inspection.preferredDate)}.`} />}
      {action === 'complete' && <Field label="Measured volume (m³)" name="measured_volume_m3" inputMode="decimal" value={volume} onChange={event => setVolume(event.target.value)} hint="Include an allowance for waste, as you would quote it." />}
      <label className="grid gap-2 text-sm font-semibold">{action === 'decline' ? 'Reason' : 'Note for the Buyer (optional)'}
        <textarea className="min-h-24 rounded-control border border-border-default bg-surface-primary px-3 py-3 text-base font-normal" maxLength={1000} value={text} onChange={event => setText(event.target.value)} />
      </label>
    </div>
  </FormDialog>
}
