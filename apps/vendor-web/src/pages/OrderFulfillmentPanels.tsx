import { useEffect, useRef, useState, type FormEvent } from 'react'
import { Link } from 'react-router-dom'
import { AlertTriangle, Camera, ClipboardCheck, MessageSquare, PauseCircle, ShieldAlert, Truck, UserRoundCheck } from 'lucide-react'
import {
  Button, CancellationAvailability, ConfirmDialog, DeadlineCountdown, Field, MilestoneStepper, RefundTimeline, StatusBadge, StatusMessage,
  formatManilaDateTime, formatPesoCentavos, readOrderEvidenceFile, roleLabel,
} from '@materyalph/web-ui'
import type { FulfillmentProof, FulfillmentStep } from '@materyalph/api-client-ts'
import {
  apiBasePath, apiFailure, assignFulfillment, cancelOrder, finalizeCancellationRequest, getCancellationPreview, listAssignees, readableOrderError, recordMilestone, recordReimbursement,
  recordTrip, reportVehicleIssue, respondToProblem, retryRefund,
  type FulfillmentAssignee, type MilestoneInput, type OrderDetail, type VehicleIssueRequestCategoryEnum, type VendorCancellationPreview, type VendorCancelRequestReasonCodeEnum,
} from '../lib/orders-api'
import { newIdempotencyKey } from '../lib/onboarding-api'

const control = 'min-h-12 w-full min-w-0 rounded-control border border-border-default bg-surface-primary px-3 text-base font-normal'
const VENDOR_REASON_LABELS: Record<string, string> = {
  STOCK_FAILURE: 'Stock failure', OPERATIONAL_INABILITY: 'Operational inability', DELIVERY_INABILITY: 'Cannot deliver', COMPLIANCE_RESTRICTION: 'Compliance restriction',
  ACCOUNT_RESTRICTION: 'Account restriction', BUYER_AGREEMENT: 'Agreed with the Buyer', OTHER: 'Other',
}
const ISSUE_LABELS: Record<string, string> = { NOT_RECEIVED: 'Not received', INCOMPLETE: 'Incomplete', DAMAGED: 'Damaged', WRONG_ITEM: 'Wrong item', LATE: 'Late', ACCESS_PROBLEM: 'Access problem', OTHER: 'Other' }
const VEHICLE_ISSUE_LABELS: Record<string, string> = { BREAKDOWN: 'Breakdown', CAPACITY_SHORTFALL: 'Capacity shortfall', ACCESS_BLOCKED: 'Access blocked', DELAY: 'Delay', OTHER: 'Other' }
const ACTIONABLE = ['START_PREPARATION', 'MARK_READY', 'DISPATCH', 'RECORD_PICKUP', 'RECORD_DELIVERY']

type Notify = (order: OrderDetail, message: string) => void

/** Opens an order evidence file (proof, problem photo, reimbursement or NRPC evidence) through the authorized API path. */
export function EvidenceLink({ path, label }: { path: string; label: string }) {
  const [state, setState] = useState<'idle' | 'busy' | 'error'>('idle')
  async function open() {
    setState('busy')
    try {
      const blob = await readOrderEvidenceFile(apiBasePath, path)
      window.open(URL.createObjectURL(blob), '_blank', 'noopener')
      setState('idle')
    } catch { setState('error') }
  }
  return <span className="inline-flex flex-wrap items-center gap-2">
    <button type="button" className="inline-flex min-h-11 items-center gap-1.5 text-sm font-semibold text-action-primary underline-offset-4 hover:underline disabled:opacity-50" disabled={state === 'busy'} onClick={() => void open()}>
      <Camera size={15} aria-hidden="true" />{state === 'busy' ? 'Opening…' : label}
    </button>
    {state === 'error' && <span role="alert" className="text-sm text-status-error">Could not open the file. Try again.</span>}
  </span>
}

function ProofSummary({ proof }: { proof: FulfillmentProof }) {
  return <dl className="mt-1 grid gap-1 rounded-control border border-border-default bg-surface-canvas p-3 text-sm">
    <div className="flex flex-wrap justify-between gap-x-3"><dt className="text-text-secondary">Received by</dt><dd className="font-semibold">{proof.receiverName ?? '—'}{proof.receiverKind ? ` · ${proof.receiverKind === 'BUYER' ? 'Buyer' : 'Authorized receiver'}` : ''}</dd></div>
    {proof.milestone === 'PICKED_UP' && <div className="flex flex-wrap justify-between gap-x-3"><dt className="text-text-secondary">Handover</dt><dd className="font-semibold">{proof.handoverConfirmed ? 'Confirmed' : 'Not confirmed'}</dd></div>}
    {proof.vehicle && <div className="flex flex-wrap justify-between gap-x-3"><dt className="text-text-secondary">Vehicle and trip</dt><dd className="font-semibold">{String(proof.vehicle.name ?? 'Accepted vehicle')} · trip {String(proof.vehicle.trip_number ?? '1')}</dd></div>}
    <div className="flex flex-wrap gap-x-4">{proof.photoPath && <EvidenceLink path={proof.photoPath} label="View proof photo" />}{proof.signaturePath && <EvidenceLink path={proof.signaturePath} label="View signature" />}</div>
  </dl>
}

/**
 * Fulfillment workspace: a milestone stepper whose completion comes from the server, with the proof form attached to
 * the step that requires it. The accepted vehicles, trips, fee and address are read-only; nothing here can change a
 * commercial term. There is no live tracking.
 */
export function FulfillmentWorkspace({ order, onChanged, onReload }: { order: OrderDetail; onChanged: Notify; onReload: () => void }) {
  const fulfillment = order.fulfillment
  if (!fulfillment) return null
  const permissions = order.permissions
  const canAct = Boolean(permissions?.canRecordMilestone) && ACTIONABLE.includes(fulfillment.nextAction)
  const orderState = order.states.find(row => row.family === 'ORDER')?.state ?? ''
  return <section aria-labelledby="fulfillment-heading" className="grid min-w-0 gap-5 rounded-surface border border-border-default bg-surface-primary p-4 sm:p-5">
    <div className="flex flex-wrap items-start justify-between gap-3">
      <div className="min-w-0">
        <h2 id="fulfillment-heading" className="flex items-center gap-2 text-lg font-semibold"><ClipboardCheck size={18} aria-hidden="true" />Fulfillment</h2>
        <p className="mt-1 text-sm text-text-secondary">{fulfillment.method === 'DELIVERY' ? 'Site Delivery' : 'Self-Pickup'}{fulfillment.expectedDate ? ` · expected ${fulfillment.expectedDate}` : ''}. {fulfillment.trackingNotice}</p>
      </div>
      {fulfillment.late && <StatusBadge label="Past the expected date" tone="warning" icon={<AlertTriangle size={14} aria-hidden="true" />} />}
    </div>
    {orderState === 'CANCELLATION_REQUESTED' && <StatusMessage tone="error">The Buyer asked to cancel. Milestones are paused until you finalize the request below or the Buyer withdraws it.</StatusMessage>}
    <MilestoneStepper steps={fulfillment.steps} renderProof={(step: FulfillmentStep) => step.proof ? <ProofSummary proof={step.proof} /> : null}
      currentAction={canAct ? <MilestoneAction order={order} onChanged={onChanged} onReload={onReload} /> : !permissions?.canRecordMilestone && ACTIONABLE.includes(fulfillment.nextAction)
        ? <p className="text-sm text-text-secondary">Only the Owner, Store Manager or the assigned Fulfillment Staff record this milestone.</p> : undefined} />
    {fulfillment.nextAction === 'AWAIT_RECEIPT' && <ReceiptStatus order={order} onReload={onReload} />}
    {fulfillment.acceptedArrangement && <AcceptedArrangement order={order} onChanged={onChanged} />}
    {fulfillment.issue && <ProblemPanel order={order} onChanged={onChanged} />}
    <ThreadEntry order={order} />
    {permissions?.canAssignFulfillment && <AssignmentPanel order={order} onChanged={onChanged} />}
    {!permissions?.canAssignFulfillment && fulfillment.assignment && <p className="flex items-center gap-2 text-sm"><UserRoundCheck size={16} aria-hidden="true" />Assigned to <strong>{fulfillment.assignment.displayName}</strong> (Fulfillment Staff)</p>}
    {permissions?.canReportVehicleIssue && order.fulfillmentMethod === 'DELIVERY' && <VehicleIssueForm order={order} onChanged={onChanged} />}
  </section>
}

function ReceiptStatus({ order, onReload }: { order: OrderDetail; onReload: () => void }) {
  const receipt = order.fulfillment!.receipt
  if (receipt.paused) return <p className="flex items-start gap-2 rounded-control border border-amber-300 bg-amber-50 px-3 py-2 text-sm text-amber-950"><PauseCircle size={16} className="mt-0.5 shrink-0" aria-hidden="true" />
    Automatic receipt confirmation is paused while the Buyer's problem report is open. It resumes with the remaining time when the Buyer resolves it.</p>
  return receipt.dueAt ? <DeadlineCountdown at={receipt.dueAt} label="Receipt confirms automatically in" endedLabel="Confirming receipt" onExpire={onReload} /> : null
}

function MilestoneAction({ order, onChanged, onReload }: { order: OrderDetail; onChanged: Notify; onReload: () => void }) {
  const next = order.fulfillment!.nextAction
  const vehicles = order.fulfillment!.acceptedArrangement?.vehicles ?? []
  const [note, setNote] = useState('')
  const [vehicleIndex, setVehicleIndex] = useState(0)
  const [trip, setTrip] = useState(1)
  const [receiver, setReceiver] = useState('')
  const [receiverKind, setReceiverKind] = useState<'BUYER' | 'AUTHORIZED_RECEIVER'>('BUYER')
  const [handover, setHandover] = useState(false)
  const [photo, setPhoto] = useState<File | null>(null)
  const [signature, setSignature] = useState<File | null>(null)
  const [errors, setErrors] = useState<Record<string, string>>({})
  const [message, setMessage] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  const key = useRef(newIdempotencyKey())
  const milestones: Record<string, MilestoneInput['milestone']> = { START_PREPARATION: 'PROCESSING', MARK_READY: 'READY_FOR_PICKUP', DISPATCH: 'OUT_FOR_DELIVERY', RECORD_PICKUP: 'PICKED_UP', RECORD_DELIVERY: 'DELIVERED' }
  const milestone: MilestoneInput['milestone'] = milestones[next] ?? 'PROCESSING'
  const label = ({ START_PREPARATION: 'Start preparing', MARK_READY: 'Mark ready for pickup', DISPATCH: 'Dispatch — out for delivery', RECORD_PICKUP: 'Record handover', RECORD_DELIVERY: 'Record delivery' } as Record<string, string>)[next]
  const selected = vehicles[vehicleIndex]

  async function submit(event: FormEvent) {
    event.preventDefault()
    const local: Record<string, string> = {}
    if (milestone === 'DELIVERED' && !photo) local.file = 'Add a delivery photo.'
    if ((milestone === 'DELIVERED' || milestone === 'PICKED_UP') && receiver.trim().length < 2) local.receiver_name = 'Enter the receiver\'s name.'
    if (milestone === 'PICKED_UP' && !handover) local.handover_confirmed = 'Confirm the handover.'
    if (milestone === 'OUT_FOR_DELIVERY' && vehicles.length === 0) local.vehicle_index = 'This order has no accepted delivery vehicle.'
    setErrors(local)
    if (Object.keys(local).length) { setMessage('Add the required proof.'); return }
    const input: MilestoneInput = { milestone, lockVersion: order.lockVersion, ...(note.trim() ? { note: note.trim() } : {}) }
    if (milestone === 'OUT_FOR_DELIVERY') Object.assign(input, { vehicleIndex, tripNumber: trip })
    if (milestone === 'DELIVERED') Object.assign(input, { receiverName: receiver.trim(), ...(photo ? { file: photo } : {}), ...(signature ? { signature } : {}) })
    if (milestone === 'PICKED_UP') Object.assign(input, { receiverName: receiver.trim(), receiverKind, handoverConfirmed: true, ...(photo ? { file: photo } : {}) })
    setBusy(true); setMessage(null)
    try {
      const updated = await recordMilestone(order.id, input, key.current)
      key.current = newIdempotencyKey()
      onChanged(updated, `${label} recorded.`)
    } catch (cause) {
      key.current = newIdempotencyKey()
      const failure = await apiFailure(cause)
      if (failure?.code === 'MILESTONE_ALREADY_RECORDED' || failure?.code === 'ORDER_STATE_CONFLICT' || failure?.code === 'STALE_VERSION') { setMessage('This order changed. Reloading its current fulfillment status…'); onReload() }
      else setMessage(await readableOrderError(cause))
    } finally { setBusy(false) }
  }

  return <form className="mt-2 grid gap-4 rounded-control border border-action-primary/40 bg-brand-orange-50/40 p-4" onSubmit={event => void submit(event)} noValidate aria-label={label}>
    {message && <StatusMessage tone="error">{message}</StatusMessage>}
    {milestone === 'OUT_FOR_DELIVERY' && <fieldset className="grid gap-3"><legend className="text-sm font-semibold">Accepted vehicle and trip</legend>
      <div className="grid gap-2">{vehicles.map(vehicle => <label key={vehicle.vehicleIndex} className={`flex min-h-11 cursor-pointer items-center gap-3 rounded-control border px-3 py-2 text-sm ${vehicleIndex === vehicle.vehicleIndex ? 'border-action-primary bg-surface-primary' : 'border-border-default'}`}>
        <input type="radio" name="vehicle" className="h-4 w-4 accent-action-primary" checked={vehicleIndex === vehicle.vehicleIndex} onChange={() => { setVehicleIndex(vehicle.vehicleIndex); setTrip(1) }} />
        <span className="min-w-0 flex-1"><span className="font-semibold">{vehicle.name ?? 'Accepted vehicle'}</span> <span className="text-text-secondary">· {vehicle.numberOfVehicles} vehicle{vehicle.numberOfVehicles === 1 ? '' : 's'}, {vehicle.totalVehicleTrips} trip{vehicle.totalVehicleTrips === 1 ? '' : 's'}</span></span>
      </label>)}</div>
      {errors.vehicle_index && <p className="text-sm text-status-error" role="alert">{errors.vehicle_index}</p>}
      {selected && selected.totalVehicleTrips > 1 && <label className="grid max-w-xs gap-2 text-sm font-semibold">Trip<select className={control} value={trip} onChange={event => setTrip(Number(event.target.value))}>
        {Array.from({ length: selected.totalVehicleTrips }, (_, index) => <option key={index} value={index + 1}>Trip {index + 1} of {selected.totalVehicleTrips}</option>)}</select></label>}
      <p className="text-xs text-text-secondary">Only the accepted vehicles and trips can be dispatched. A different vehicle or extra trip needs a revision the Buyer approves.</p>
    </fieldset>}
    {(milestone === 'DELIVERED' || milestone === 'PICKED_UP') && <div className="grid gap-4 sm:grid-cols-2">
      <Field label={milestone === 'DELIVERED' ? 'Receiver name' : 'Collected by'} name="receiver_name" required value={receiver} maxLength={120} error={errors.receiver_name} onChange={event => setReceiver(event.target.value)} />
      {milestone === 'PICKED_UP' && <label className="grid gap-2 text-sm font-semibold">Receiver<select className={control} value={receiverKind} onChange={event => setReceiverKind(event.target.value as 'BUYER' | 'AUTHORIZED_RECEIVER')}>
        <option value="BUYER">The Buyer</option><option value="AUTHORIZED_RECEIVER">An authorized receiver</option></select></label>}
      <label className="grid gap-2 text-sm font-semibold">{milestone === 'DELIVERED' ? 'Delivery photo' : 'Handover photo (optional)'}{milestone === 'DELIVERED' && <span className="sr-only"> (required)</span>}
        <input type="file" accept="image/png,image/jpeg" className="min-h-12 w-full min-w-0 text-sm" aria-invalid={Boolean(errors.file)} onChange={event => setPhoto(event.target.files?.[0] ?? null)} /></label>
      {milestone === 'DELIVERED' && <label className="grid gap-2 text-sm font-semibold">Receiver signature (optional)<input type="file" accept="image/png,image/jpeg" className="min-h-12 w-full min-w-0 text-sm" onChange={event => setSignature(event.target.files?.[0] ?? null)} /></label>}
      {errors.file && <p className="text-sm text-status-error sm:col-span-2" role="alert">{errors.file}</p>}
      {milestone === 'PICKED_UP' && <label className="flex min-h-11 items-start gap-3 text-sm sm:col-span-2"><input type="checkbox" className="mt-0.5 h-5 w-5 accent-action-primary" checked={handover} onChange={event => setHandover(event.target.checked)} />
        <span>I handed over every line of this order to the person named above.</span></label>}
      {errors.handover_confirmed && <p className="text-sm text-status-error sm:col-span-2" role="alert">{errors.handover_confirmed}</p>}
    </div>}
    <label className="grid gap-2 text-sm font-semibold">Note (optional)<textarea className={`${control} min-h-16 py-2`} maxLength={500} value={note} onChange={event => setNote(event.target.value)} /></label>
    <div className="flex flex-wrap items-center gap-3">
      <Button type="submit" disabled={busy}>{busy ? 'Recording…' : label}</Button>
      {(milestone === 'READY_FOR_PICKUP' || milestone === 'OUT_FOR_DELIVERY') && <span className="text-xs text-text-secondary">This also opens Fulfillment Messages with the Buyer.</span>}
    </div>
  </form>
}

function AcceptedArrangement({ order, onChanged }: { order: OrderDetail; onChanged: Notify }) {
  const arrangement = order.fulfillment!.acceptedArrangement!
  const trips = order.fulfillment!.trips
  const outForDelivery = order.fulfillment!.nextAction === 'RECORD_DELIVERY'
  const remaining = arrangement.vehicles.flatMap(vehicle => Array.from({ length: vehicle.totalVehicleTrips }, (_, index) => ({ vehicle, trip: index + 1 })))
    .filter(item => !trips.some(recorded => recorded.vehicleIndex === item.vehicle.vehicleIndex && recorded.tripNumber === item.trip))
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState<string | null>(null)
  return <section aria-labelledby="arrangement-heading" className="grid gap-3 border-t border-border-default pt-4">
    <h3 id="arrangement-heading" className="flex items-center gap-2 font-semibold"><Truck size={16} aria-hidden="true" />Accepted delivery arrangement</h3>
    <dl className="grid gap-2 text-sm sm:grid-cols-2">
      {arrangement.vehicles.map(vehicle => <div key={vehicle.vehicleIndex}><dt className="text-text-secondary">Vehicle</dt><dd className="font-semibold">{vehicle.name ?? 'Accepted vehicle'} · {vehicle.numberOfVehicles} vehicle{vehicle.numberOfVehicles === 1 ? '' : 's'}, {vehicle.totalVehicleTrips} trip{vehicle.totalVehicleTrips === 1 ? '' : 's'}</dd></div>)}
      <div><dt className="text-text-secondary">Final delivery fee</dt><dd className="font-semibold tabular-nums">{formatPesoCentavos(arrangement.finalFeeCentavos)}</dd></div>
      <div><dt className="text-text-secondary">Drop-off</dt><dd className="font-semibold">{arrangement.endpoint === 'ALTERNATE_DROP_OFF' ? 'Alternate drop-off (heavy-vehicle restriction)' : 'Intended destination'}</dd></div>
      {arrangement.arrangement && <div className="sm:col-span-2"><dt className="text-text-secondary">Arrangement</dt><dd>{arrangement.arrangement}</dd></div>}
    </dl>
    <p className="text-xs text-text-secondary">{arrangement.notice}</p>
    {trips.length > 0 && <ul className="grid gap-1 text-sm" aria-label="Dispatched trips">{trips.map(trip => <li key={`${trip.vehicleIndex}-${trip.tripNumber}`}>Trip {trip.tripNumber} of {trip.totalVehicleTrips} · {trip.name ?? 'Accepted vehicle'}{trip.dispatchedAt ? ` · ${formatManilaDateTime(trip.dispatchedAt)}` : ''}</li>)}</ul>}
    {outForDelivery && order.permissions?.canRecordMilestone && remaining.length > 0 && <div className="flex flex-wrap items-center gap-3">
      <Button variant="secondary" disabled={busy} onClick={() => void (async () => {
        setBusy(true); setError(null)
        try { onChanged(await recordTrip(order.id, remaining[0]!.vehicle.vehicleIndex, remaining[0]!.trip), `Trip ${remaining[0]!.trip} recorded.`) } catch (cause) { setError(await readableOrderError(cause)) } finally { setBusy(false) }
      })()}>Record next accepted trip ({remaining[0]!.vehicle.name ?? 'vehicle'}, trip {remaining[0]!.trip})</Button>
      {error && <p role="alert" className="text-sm text-status-error">{error}</p>}
    </div>}
  </section>
}

function ProblemPanel({ order, onChanged }: { order: OrderDetail; onChanged: Notify }) {
  const issue = order.fulfillment!.issue!
  const [response, setResponse] = useState('')
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState<string | null>(null)
  return <section aria-labelledby="problem-heading" className={`grid gap-3 border-t border-border-default pt-4 ${issue.state === 'OPEN' ? '' : 'opacity-90'}`}>
    <div className="flex flex-wrap items-center justify-between gap-2">
      <h3 id="problem-heading" className="flex items-center gap-2 font-semibold"><ShieldAlert size={16} aria-hidden="true" />Buyer problem report · {ISSUE_LABELS[issue.category] ?? issue.category}</h3>
      <StatusBadge label={issue.state === 'OPEN' ? 'Open — auto-confirmation paused' : 'Resolved'} tone={issue.state === 'OPEN' ? 'warning' : 'success'} />
    </div>
    <p className="text-sm">{issue.description}</p>
    {issue.reportedAt && <p className="text-xs text-text-secondary">Reported {formatManilaDateTime(issue.reportedAt)}</p>}
    {issue.photoPaths.length > 0 && <div className="flex flex-wrap gap-x-4">{issue.photoPaths.map((path, index) => <EvidenceLink key={path} path={path} label={`View photo ${index + 1}`} />)}</div>}
    {issue.vendorResponse ? <p className="rounded-control bg-surface-canvas p-3 text-sm"><strong>Your response:</strong> {issue.vendorResponse}</p>
      : issue.state === 'OPEN' && order.permissions?.canRespondProblem && <form className="grid gap-2" onSubmit={event => { event.preventDefault(); void (async () => {
        if (response.trim().length < 5) { setError('Write at least 5 characters.'); return }
        setBusy(true); setError(null)
        try { onChanged(await respondToProblem(order.id, issue.id, response.trim()), 'Response sent to the Buyer.') } catch (cause) { setError(await readableOrderError(cause)) } finally { setBusy(false) }
      })() }}>
        <label className="grid gap-2 text-sm font-semibold">Respond to the Buyer<textarea className={`${control} min-h-20 py-2`} maxLength={2000} value={response} onChange={event => setResponse(event.target.value)} /></label>
        {error && <p role="alert" className="text-sm text-status-error">{error}</p>}
        <Button type="submit" variant="secondary" disabled={busy} className="w-fit">{busy ? 'Sending…' : 'Send response'}</Button>
        <p className="text-xs text-text-secondary">A response is communication only. A replacement, refund or other remedy follows its own authorized process.</p>
      </form>}
  </section>
}

function ThreadEntry({ order }: { order: OrderDetail }) {
  const thread = order.fulfillment!.thread
  return <p className="flex flex-wrap items-center gap-2 border-t border-border-default pt-4 text-sm">
    <MessageSquare size={16} aria-hidden="true" />
    {thread.available && thread.conversationId
      ? <><Link to={`/messages?conversation=${thread.conversationId}`} className="font-semibold text-action-primary underline-offset-4 hover:underline">Open Fulfillment Messages</Link>{thread.readOnly && <span className="text-text-secondary">· read-only history</span>}</>
      : <span className="text-text-secondary">{thread.notice ?? 'Fulfillment Messages are not open yet.'}</span>}
  </p>
}

function AssignmentPanel({ order, onChanged }: { order: OrderDetail; onChanged: Notify }) {
  const current = order.fulfillment!.assignment
  const [options, setOptions] = useState<FulfillmentAssignee[] | null>(null)
  const [target, setTarget] = useState('')
  const [reason, setReason] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  useEffect(() => { let active = true; listAssignees(order.id).then(rows => { if (active) setOptions(rows) }).catch(async cause => { const text = await readableOrderError(cause); if (active) setError(text) }); return () => { active = false } }, [order.id])
  return <section aria-labelledby="assignment-heading" className="grid gap-3 border-t border-border-default pt-4">
    <h3 id="assignment-heading" className="flex items-center gap-2 font-semibold"><UserRoundCheck size={16} aria-hidden="true" />Fulfillment Staff</h3>
    <p className="text-sm">{current ? <>Assigned to <strong>{current.displayName}</strong>{current.assignedAt ? ` since ${formatManilaDateTime(current.assignedAt)}` : ''}.</> : 'No Fulfillment Staff assigned. The Owner or Store Manager can record milestones directly.'}</p>
    {options === null && !error && <p className="text-sm text-text-secondary">Loading Fulfillment Staff…</p>}
    {options && options.length === 0 && <p className="text-sm text-text-secondary">No active Fulfillment Staff. Teams are optional; invite staff from Team if you need them.</p>}
    {options && options.length > 0 && <form className="grid gap-3 sm:grid-cols-[minmax(0,1fr)_minmax(0,1fr)_auto] sm:items-end" onSubmit={event => { event.preventDefault(); void (async () => {
      if (!target || reason.trim().length < 5) { setError('Choose staff and give a reason of at least 5 characters.'); return }
      setBusy(true); setError(null)
      try { const updated = await assignFulfillment(order.id, Number(target), reason.trim()); setReason(''); onChanged(updated, 'Fulfillment Staff assigned. Any former assignee lost access to this order and its messages.') } catch (cause) { setError(await readableOrderError(cause)) } finally { setBusy(false) }
    })() }}>
      <label className="grid gap-2 text-sm font-semibold">{current ? 'Reassign to' : 'Assign'}<select className={control} value={target} onChange={event => setTarget(event.target.value)}>
        <option value="">Choose Fulfillment Staff</option>{options.filter(option => !option.assigned).map(option => <option key={option.userId} value={option.userId}>{option.displayName}</option>)}</select></label>
      <Field label="Reason" name="assignment_reason" value={reason} maxLength={500} onChange={event => setReason(event.target.value)} />
      <Button type="submit" variant="secondary" disabled={busy}>{busy ? 'Saving…' : current ? 'Reassign' : 'Assign'}</Button>
    </form>}
    {error && <p role="alert" className="text-sm text-status-error">{error}</p>}
  </section>
}

function VehicleIssueForm({ order, onChanged }: { order: OrderDetail; onChanged: Notify }) {
  const [open, setOpen] = useState(false)
  const [category, setCategory] = useState<VehicleIssueRequestCategoryEnum>('BREAKDOWN')
  const [description, setDescription] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  const issues = order.fulfillment!.vehicleIssues
  return <section aria-labelledby="vehicle-issue-heading" className="grid gap-3 border-t border-border-default pt-4">
    <div className="flex flex-wrap items-center justify-between gap-2"><h3 id="vehicle-issue-heading" className="font-semibold">Vehicle issues</h3>
      <Button variant="quiet" aria-expanded={open} onClick={() => setOpen(value => !value)}>{open ? 'Close' : 'Report a vehicle issue'}</Button></div>
    {issues.length > 0 && <ul className="grid gap-1 text-sm">{issues.map((issue, index) => <li key={index}>{VEHICLE_ISSUE_LABELS[issue.category] ?? issue.category} · {issue.description}{issue.reportedAt ? ` · ${formatManilaDateTime(issue.reportedAt)}` : ''}{issue.actorRole ? ` · ${roleLabel(issue.actorRole)}` : ''}</li>)}</ul>}
    {open && <form className="grid gap-3" onSubmit={event => { event.preventDefault(); void (async () => {
      if (description.trim().length < 10) { setError('Describe the issue in at least 10 characters.'); return }
      setBusy(true); setError(null)
      try { const updated = await reportVehicleIssue(order.id, category, description.trim()); setDescription(''); setOpen(false); onChanged(updated, 'Vehicle issue reported to the Owner and Store Manager.') } catch (cause) { setError(await readableOrderError(cause)) } finally { setBusy(false) }
    })() }}>
      <label className="grid max-w-xs gap-2 text-sm font-semibold">Issue<select className={control} value={category} onChange={event => setCategory(event.target.value as VehicleIssueRequestCategoryEnum)}>{Object.entries(VEHICLE_ISSUE_LABELS).map(([value, text]) => <option key={value} value={value}>{text}</option>)}</select></label>
      <label className="grid gap-2 text-sm font-semibold">What happened<textarea className={`${control} min-h-20 py-2`} maxLength={1000} value={description} onChange={event => setDescription(event.target.value)} /></label>
      {error && <p role="alert" className="text-sm text-status-error">{error}</p>}
      <p className="text-xs text-text-secondary">This does not change the accepted vehicles, trips or fee. The Owner or Store Manager decides any revision, which the Buyer must approve.</p>
      <Button type="submit" variant="secondary" disabled={busy} className="w-fit">{busy ? 'Reporting…' : 'Report issue'}</Button>
    </form>}
  </section>
}

/** Vendor cancellation and finalization of a Buyer request, with the server's FIN-07 amounts shown before confirming. */
export function CancellationPanel({ order, onChanged }: { order: OrderDetail; onChanged: Notify }) {
  const cancellation = order.cancellation
  const permissions = order.permissions
  const [preview, setPreview] = useState<VendorCancellationPreview | null>(null)
  const [dialog, setDialog] = useState<'cancel' | 'finalize' | null>(null)
  const [reasonCode, setReasonCode] = useState<VendorCancelRequestReasonCodeEnum>('STOCK_FAILURE')
  const [reason, setReason] = useState('')
  const [retain, setRetain] = useState(false)
  const [evidence, setEvidence] = useState<File | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  const key = useRef(newIdempotencyKey())
  if (!cancellation) return null
  const open = cancellation.openRequest
  const showPanel = permissions?.canCancel || permissions?.canFinalizeCancellation || open
  if (!showPanel) return null
  async function load(kind: 'cancel' | 'finalize') {
    setError(null); setDialog(kind)
    try { setPreview(await getCancellationPreview(order.id)) } catch (cause) { setError(await readableOrderError(cause)) }
  }
  async function confirm() {
    if (dialog === 'cancel' && reason.trim().length < 10) { setError('Explain the cancellation to the Buyer in at least 10 characters.'); return }
    if (dialog === 'finalize' && retain && (!evidence || reason.trim().length < 10)) { setError('Retaining the NRPC needs preparation evidence and a description of at least 10 characters.'); return }
    setBusy(true); setError(null)
    try {
      const updated = dialog === 'cancel' ? await cancelOrder(order.id, order.lockVersion, reasonCode, reason.trim(), key.current) : await finalizeCancellationRequest(order.id, retain, reason.trim(), evidence ?? undefined, key.current)
      key.current = newIdempotencyKey(); setDialog(null); setReason(''); setEvidence(null)
      onChanged(updated, dialog === 'cancel' ? 'Order cancelled. Every Buyer-paid amount is being refunded to the original payment method and the stock was released.' : 'Cancellation finalized. The refund was initiated with the payment provider.')
    } catch (cause) { key.current = newIdempotencyKey(); setError(await readableOrderError(cause)) } finally { setBusy(false) }
  }
  const plan = dialog === 'cancel' ? preview?.vendorCancellation : retain ? preview?.withNrpcRetained ?? preview?.fullRefund : preview?.fullRefund
  return <section aria-labelledby="cancellation-heading" className="grid gap-3 rounded-surface border border-border-default bg-surface-primary p-4">
    <h2 id="cancellation-heading" className="text-base font-semibold">Cancellation</h2>
    {open && <div className="grid gap-2 rounded-control border border-amber-300 bg-amber-50 p-3 text-sm text-amber-950">
      <p className="font-semibold">The Buyer asked to cancel ({open.reasonCode.toLowerCase().replaceAll('_', ' ')}).</p>
      {open.reason && <p>“{open.reason}”</p>}
      {open.responseDueAt && <DeadlineCountdown at={open.responseDueAt} label="Finalize within" endedLabel="Finalizing automatically" />}
      <p>Without your response it is finalized automatically with a full refund. You cannot refuse a permitted request.</p>
      {permissions?.canFinalizeCancellation && <Button className="w-fit" onClick={() => void load('finalize')}>Finalize cancellation</Button>}
    </div>}
    {!open && <CancellationAvailability explanation={cancellation.explanation} />}
    {permissions?.canCancel && !open && <Button variant="danger" className="w-fit" onClick={() => void load('cancel')}>Cancel this order</Button>}
    {permissions?.canCancel && open && <button type="button" className="w-fit text-sm font-semibold text-status-error underline-offset-4 hover:underline" onClick={() => void load('cancel')}>Cancel as a Vendor instead (Vendor-caused)</button>}
    <ConfirmDialog open={dialog !== null} tone={dialog === 'finalize' ? 'primary' : 'danger'} title={dialog === 'cancel' ? 'Cancel this order?' : 'Finalize the Buyer\'s cancellation?'}
      confirmLabel={dialog === 'cancel' ? 'Cancel order and refund' : retain ? 'Finalize and retain NRPC' : 'Finalize with full refund'} busy={busy} onCancel={() => { setDialog(null); setError(null) }} onConfirm={() => void confirm()}>
      <div className="grid gap-3 text-text-strong">
        {dialog === 'cancel' && <p className="text-text-secondary">A Vendor cancellation forfeits any NRPC, refunds every Buyer-paid amount to the original payment method, releases the reserved stock and counts toward your Non-Fulfillment Rate.</p>}
        {dialog === 'cancel' && <label className="grid gap-2 text-sm font-semibold">Reason<select className={control} value={reasonCode} onChange={event => setReasonCode(event.target.value as VendorCancelRequestReasonCodeEnum)}>
          {(cancellation.reasonCodes ?? Object.keys(VENDOR_REASON_LABELS)).map(code => <option key={code} value={code}>{VENDOR_REASON_LABELS[code] ?? code}</option>)}</select></label>}
        {dialog === 'finalize' && (cancellation.nrpcRetainableCentavos ?? 0) > 0 && <label className="flex min-h-11 items-start gap-3 text-sm"><input type="checkbox" className="mt-0.5 h-5 w-5 accent-action-primary" checked={retain} onChange={event => setRetain(event.target.checked)} />
          <span>Retain the accepted NRPC of <strong>{formatPesoCentavos(cancellation.nrpcRetainableCentavos ?? 0)}</strong> — I can show evidence of the actual irreversible preparation.</span></label>}
        {(dialog === 'cancel' || retain) && <label className="grid gap-2 text-sm font-semibold">{dialog === 'cancel' ? 'Message to the Buyer' : 'Describe the preparation'}<textarea className={`${control} min-h-20 py-2`} maxLength={dialog === 'cancel' ? 1000 : 2000} value={reason} onChange={event => setReason(event.target.value)} /></label>}
        {dialog === 'finalize' && retain && <label className="grid gap-2 text-sm font-semibold">Preparation evidence<input type="file" accept="image/png,image/jpeg,application/pdf" className="min-h-12 w-full min-w-0 text-sm" onChange={event => setEvidence(event.target.files?.[0] ?? null)} /></label>}
        {plan ? <PlanSummary plan={plan} /> : dialog && !error && <p className="text-sm text-text-secondary">Calculating refund amounts…</p>}
        {error && <p role="alert" className="text-sm text-status-error">{error}</p>}
      </div>
    </ConfirmDialog>
  </section>
}

function PlanSummary({ plan }: { plan: NonNullable<VendorCancellationPreview['fullRefund']> }) {
  return <dl className="grid gap-1 rounded-control bg-surface-canvas p-3 text-sm">
    <div className="flex justify-between gap-3"><dt>Refund to the original payment method</dt><dd className="font-semibold tabular-nums">{formatPesoCentavos(plan.onlineRefundTotalCentavos)}</dd></div>
    {plan.nrpcRetainedCentavos > 0 && <div className="flex justify-between gap-3"><dt>NRPC retained</dt><dd className="font-semibold tabular-nums">{formatPesoCentavos(plan.nrpcRetainedCentavos)}</dd></div>}
    {plan.cashReimbursementCentavos > 0 && <div className="flex justify-between gap-3"><dt>Cash you must reimburse</dt><dd className="font-semibold tabular-nums">{formatPesoCentavos(plan.cashReimbursementCentavos)}</dd></div>}
    {plan.releasedUnpaidCentavos > 0 && <div className="flex justify-between gap-3"><dt>Unpaid balance, no longer due</dt><dd className="font-semibold tabular-nums">{formatPesoCentavos(plan.releasedUnpaidCentavos)}</dd></div>}
    <dd className="pt-1 text-xs text-text-secondary">Your withholding tax, commission and provider charges never reduce the Buyer's refund.</dd>
  </dl>
}

/** Refund and reimbursement timeline with the Owner's retry and the evidenced cash reimbursement action. */
export function RefundsPanel({ order, onChanged }: { order: OrderDetail; onChanged: Notify }) {
  const timeline = order.refundTimeline
  const [retrying, setRetrying] = useState<string | null>(null)
  const [error, setError] = useState<string | null>(null)
  if (!timeline || (timeline.refunds.length === 0 && timeline.reimbursements.length === 0 && timeline.noLongerDueCentavos === 0 && !timeline.decision)) return null
  const pending = timeline.reimbursements.find(row => row.state === 'VENDOR_REIMBURSEMENT_PENDING' && !row.hasEvidence)
  return <section aria-labelledby="refunds-heading" className="grid gap-3 rounded-surface border border-border-default bg-surface-primary p-4">
    <h2 id="refunds-heading" className="text-base font-semibold">Refunds and reimbursements</h2>
    {error && <StatusMessage tone="error">{error}</StatusMessage>}
    <RefundTimeline timeline={timeline} audience="VENDOR" retryingId={retrying} renderEvidence={(path, label) => <EvidenceLink path={path} label={label} />}
      onRetry={refund => void (async () => { setRetrying(refund.id); setError(null); try { onChanged(await retryRefund(order.id, refund.id), 'Refund retried with the payment provider.') } catch (cause) { setError(await readableOrderError(cause)) } finally { setRetrying(null) } })()} />
    {pending && order.permissions?.canRecordPhysicalPayment && <ReimbursementForm orderId={order.id} reimbursementId={pending.id} amount={pending.amountCentavos} onChanged={onChanged} />}
  </section>
}

function ReimbursementForm({ orderId, reimbursementId, amount, onChanged }: { orderId: string; reimbursementId: string; amount: number; onChanged: Notify }) {
  const [file, setFile] = useState<File | null>(null)
  const [note, setNote] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  return <form className="grid gap-3 border-t border-border-default pt-3" onSubmit={event => { event.preventDefault(); void (async () => {
    if (!file) { setError('Upload evidence of the cash you returned.'); return }
    setBusy(true); setError(null)
    try { onChanged(await recordReimbursement(orderId, reimbursementId, file, note.trim() || undefined), 'Reimbursement recorded. The Buyer confirms it on their order.') } catch (cause) { setError(await readableOrderError(cause)) } finally { setBusy(false) }
  })() }}>
    <p className="text-sm">Return <strong className="tabular-nums">{formatPesoCentavos(amount)}</strong> collected in cash, then record the evidence. This is separate from any online refund.</p>
    <label className="grid gap-2 text-sm font-semibold">Reimbursement evidence<input type="file" accept="image/png,image/jpeg,application/pdf" className="min-h-12 w-full min-w-0 text-sm" onChange={event => setFile(event.target.files?.[0] ?? null)} /></label>
    <label className="grid gap-2 text-sm font-semibold">Note (optional)<input className={control} maxLength={500} value={note} onChange={event => setNote(event.target.value)} /></label>
    {error && <p role="alert" className="text-sm text-status-error">{error}</p>}
    <Button type="submit" variant="secondary" disabled={busy} className="w-fit">{busy ? 'Recording…' : 'Record reimbursement'}</Button>
  </form>
}
