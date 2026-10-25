import { openPendingWindow, shouldRotateIdempotencyKey } from '@materyalph/web-ui'
import { useEffect, useRef, useState, type FormEvent } from 'react'
import { AlertTriangle, Camera, ClipboardCheck, ImagePlus, PauseCircle, ShieldAlert, Truck, UserRoundCheck } from 'lucide-react'
import {
  Button, CancellationAvailability, ConfirmDialog, DeadlineCountdown, Field, FileSelectionField, MilestoneStepper, RefundTimeline, StatusBadge, StatusMessage,
  formatManilaDateTime, formatPesoCentavos, readOrderEvidenceFile, roleLabel,
} from '@materyalph/web-ui'
import type { FulfillmentProof, FulfillmentStep } from '@materyalph/api-client-ts'
import type { DeliveryVehicleOption } from '@materyalph/api-client-ts'
import { Link } from 'react-router-dom'
import {
  apiBasePath, apiFailure, assignFulfillment, cancelOrder, finalizeCancellationRequest, getCancellationPreview, listAssignees, pesoInputToCentavos, readableOrderError, orderFieldErrors, recordMilestone, recordReimbursement,
  recordTrip, reportVehicleIssue, respondToProblem, retryRefund, listDeliveryVehicles,
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
  const [fileUrl, setFileUrl] = useState<string | null>(null)
  useEffect(() => () => { if (fileUrl) URL.revokeObjectURL(fileUrl) }, [fileUrl])
  async function open() {
    const tab = openPendingWindow()
    setState('busy')
    try {
      const blob = await readOrderEvidenceFile(apiBasePath, path)
      const url = URL.createObjectURL(blob)
      setFileUrl(url)
      if (tab && !tab.closed) tab.location.replace(url)
      setState('idle')
    } catch { tab?.close(); setState('error') }
  }
  return <span className="inline-flex flex-wrap items-center gap-2">
    <button type="button" className="inline-flex min-h-11 items-center gap-1.5 text-sm font-semibold text-action-primary underline-offset-4 hover:underline disabled:opacity-50" disabled={state === 'busy'} onClick={() => void open()}>
      <Camera size={15} aria-hidden="true" />{state === 'busy' ? 'Opening…' : label}
    </button>
    {fileUrl && <a href={fileUrl} target="_blank" rel="noopener noreferrer" className="inline-flex min-h-11 items-center text-sm font-semibold text-action-primary underline">Open file</a>}
    {state === 'error' && <span role="alert" className="text-sm text-status-error">Could not open the file. Try again.</span>}
  </span>
}

function ProofSummary({ proof }: { proof: FulfillmentProof }) {
  return <dl className="mt-1 grid gap-1 rounded-control border border-border-default bg-surface-canvas p-3 text-sm">
    <div className="flex flex-wrap justify-between gap-x-3"><dt className="text-text-secondary">Received by</dt><dd className="font-semibold">{proof.receiverName ?? '—'}{proof.receiverKind ? ` · ${proof.receiverKind === 'BUYER' ? 'Buyer' : 'Authorized receiver'}` : ''}</dd></div>
    {proof.milestone === 'PICKED_UP' && <div className="flex flex-wrap justify-between gap-x-3"><dt className="text-text-secondary">Handover</dt><dd className="font-semibold">{proof.handoverConfirmed ? 'Confirmed' : 'Not confirmed'}</dd></div>}
    {proof.vehicle && <div className="flex flex-wrap justify-between gap-x-3"><dt className="text-text-secondary">Vehicle and trip</dt><dd className="font-semibold">{String(proof.vehicle.name ?? 'Accepted vehicle')} · trip {String(proof.vehicle.trip_number ?? '1')}</dd></div>}
    <div className="flex flex-wrap gap-x-4">{proof.photoPath && <EvidenceLink path={proof.photoPath} label="View proof photo" />}{proof.signaturePath && <EvidenceLink path={proof.signaturePath} label="View signature" />}</div>
    {proof.recordedBy && <div><dt className="text-text-secondary">Recorded by</dt><dd>{proof.recordedBy}</dd></div>}
    {proof.note && <div><dt className="text-text-secondary">Delivery notes</dt><dd className="break-words">{proof.note}</dd></div>}
    {proof.additionalPhotoPaths?.map((path, index) => <EvidenceLink key={path} path={path} label={`Additional photo ${index + 1}`} />)}
  </dl>
}

/**
 * Fulfillment workspace: a milestone stepper whose completion comes from the server, with the proof form attached to
 * the step that requires it. The accepted vehicles, trips, fee and address are read-only; nothing here can change a
 * commercial term. There is no live tracking.
 */
export function FulfillmentWorkspace({ order, onChanged, onReload, staffWorkspace = false }: { order: OrderDetail; onChanged: Notify; onReload: () => void; staffWorkspace?: boolean }) {
  const fulfillment = order.fulfillment
  if (!fulfillment) return null
  const permissions = order.permissions
  const canAct = Boolean(permissions?.canRecordMilestone) && ACTIONABLE.includes(fulfillment.nextAction)
  const delivery = fulfillment.method === 'DELIVERY'
  const awaitingDeliveryProof = delivery && (fulfillment.state === 'OUT_FOR_DELIVERY' || fulfillment.nextAction === 'RECORD_DELIVERY')
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
    <MilestoneStepper steps={fulfillment.steps} showProofRequirements={!delivery || staffWorkspace} renderProof={(step: FulfillmentStep) => step.proof ? <ProofSummary proof={step.proof} /> : null}
      renderStepContent={step => delivery && step.key === 'OUT_FOR_DELIVERY' && (fulfillment.assignment || fulfillment.nextAction === 'DISPATCH' || (awaitingDeliveryProof && permissions?.canAssignFulfillment))
        ? <DeliveryAssignmentStep key={`${order.id}-${fulfillment.nextAction === 'DISPATCH'}`} order={order} onChanged={onChanged} onReload={onReload} /> : null}
      currentAction={fulfillment.nextAction === 'DISPATCH' ? !permissions?.canAssignFulfillment && <p className="text-sm text-text-secondary">The Owner or Store Manager confirms the staff and vehicle assignment to dispatch this delivery.</p>
        : awaitingDeliveryProof && !staffWorkspace ? <p className="text-sm text-text-secondary">{fulfillment.assignment?.displayName ?? 'The assigned Fulfillment Staff member'} records Delivered with the receiver’s name and delivery photo from their Fulfillment portal. This page updates when they submit the proof.</p>
        : canAct ? <MilestoneAction key={fulfillment.nextAction} order={order} onChanged={onChanged} onReload={onReload} /> : !permissions?.canRecordMilestone && ACTIONABLE.includes(fulfillment.nextAction)
        ? <p className="text-sm text-text-secondary">Only the Owner, Store Manager or the assigned Fulfillment Staff record this milestone.</p> : undefined} />
    {fulfillment.nextAction === 'AWAIT_RECEIPT' && <ReceiptStatus order={order} onReload={onReload} />}
    {fulfillment.acceptedArrangement && <AcceptedArrangement order={order} onChanged={onChanged} />}
    {fulfillment.issue && <ProblemPanel order={order} onChanged={onChanged} />}
    {!delivery && permissions?.canAssignFulfillment && <AssignmentPanel order={order} onChanged={onChanged} onReload={onReload} />}
    {!delivery && !permissions?.canAssignFulfillment && fulfillment.assignment && <AssignmentSummary order={order} />}
    {permissions?.canReportVehicleIssue && order.fulfillmentMethod === 'DELIVERY' && <VehicleIssueForm order={order} onChanged={onChanged} />}
    {(fulfillment.vehicleIssues?.length ?? 0) > 0 && <section className="grid gap-3 border-t border-border-default pt-4" aria-label="Reported delivery issues"><h3 className="font-semibold">Delivery issues</h3>{fulfillment.vehicleIssues.map((issue, index) => <div key={index} className="text-sm"><p className="font-semibold">{VEHICLE_ISSUE_LABELS[issue.category] ?? issue.category}{issue.reportedAt ? ` · ${formatManilaDateTime(issue.reportedAt)}` : ''}</p><p className="break-words">{issue.description}</p></div>)}</section>}
    {(fulfillment.assignmentHistory?.length ?? 0) > 0 && <section className="grid gap-3 border-t border-border-default pt-4" aria-label="Staff assignment history"><h3 className="font-semibold">Assignment history</h3><ol className="grid gap-3 text-sm">{fulfillment.assignmentHistory?.map((entry, index) => <li key={index}><p className="font-semibold">{entry.event === 'ASSIGNMENT_ACKNOWLEDGED' ? 'Assignment acknowledged' : entry.displayName ?? 'Staff assigned'}{entry.vehicleName ? ` · ${entry.vehicleName}` : ''}</p><p className="text-text-secondary">{entry.at ? formatManilaDateTime(entry.at) : ''} · {roleLabel(entry.actorRole ?? 'VENDOR')}</p>{entry.reason && <p className="break-words">{entry.reason}</p>}</li>)}</ol></section>}
  </section>
}

function AssignmentSummary({ order }: { order: OrderDetail }) {
  const assignment = order.fulfillment!.assignment
  if (!assignment) return null
  return <div className="grid gap-2 text-sm"><p className="flex flex-wrap items-center gap-2"><UserRoundCheck size={16} aria-hidden="true" />Assigned to <strong>{assignment.displayName}</strong> (Fulfillment Staff)</p>{assignment.vehicle && <p>Vehicle: <strong>{assignment.vehicle.name}</strong></p>}{assignment.assignedAt && <p className="text-text-secondary">Assigned {formatManilaDateTime(assignment.assignedAt)}</p>}{assignment.acknowledgedAt && <p className="text-text-secondary">Acknowledged {formatManilaDateTime(assignment.acknowledgedAt)}</p>}</div>
}

function DeliveryAssignmentStep({ order, onChanged, onReload }: { order: OrderDetail; onChanged: Notify; onReload: () => void }) {
  const [open, setOpen] = useState(false)
  const dispatch = order.fulfillment!.nextAction === 'DISPATCH'
  const canAssign = Boolean(order.permissions?.canAssignFulfillment)
  const showForm = canAssign && (dispatch || open)
  return <div className="mt-2 grid min-w-0 gap-3">
    {!showForm && <AssignmentSummary order={order} />}
    {canAssign && !showForm && <Button variant="secondary" className="w-fit" onClick={() => setOpen(true)}>{order.fulfillment!.assignment ? 'Reassign Fulfillment Staff' : 'Assign Fulfillment Staff'}</Button>}
    {showForm && <AssignmentPanel dispatch={dispatch} order={order} onChanged={(updated, message) => { setOpen(false); onChanged(updated, message) }} onReload={onReload} />}
  </div>
}

function ReceiptStatus({ order, onReload }: { order: OrderDetail; onReload: () => void }) {
  const receipt = order.fulfillment!.receipt
  if (receipt.paused) return <p className="flex items-start gap-2 rounded-control border border-amber-300 bg-amber-50 px-3 py-2 text-sm text-amber-950"><PauseCircle size={16} className="mt-0.5 shrink-0" aria-hidden="true" />
    Automatic receipt confirmation is paused while the Buyer's problem report is open. It resumes with the remaining time when the Buyer resolves it.</p>
  return receipt.dueAt ? <DeadlineCountdown at={receipt.dueAt} label="Receipt confirms automatically in" endedLabel="Confirming receipt" onExpire={onReload} /> : null
}

function MilestoneAction({ order, onChanged, onReload }: { order: OrderDetail; onChanged: Notify; onReload: () => void }) {
  const next = order.fulfillment!.nextAction
  const [note, setNote] = useState('')
  const [receiver, setReceiver] = useState('')
  const [receiverKind, setReceiverKind] = useState<'BUYER' | 'AUTHORIZED_RECEIVER'>('BUYER')
  const [handover, setHandover] = useState(false)
  const [photo, setPhoto] = useState<File | null>(null)
  const [signature, setSignature] = useState<File | null>(null)
  const [additional, setAdditional] = useState<(File | null)[]>([])
  const [errors, setErrors] = useState<Record<string, string>>({})
  const [message, setMessage] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  const milestones: Record<string, MilestoneInput['milestone']> = { START_PREPARATION: 'PROCESSING', MARK_READY: 'READY_FOR_PICKUP', RECORD_PICKUP: 'PICKED_UP', RECORD_DELIVERY: 'DELIVERED' }
  const milestone: MilestoneInput['milestone'] = milestones[next] ?? 'PROCESSING'
  // Cash on Delivery and In-Store handovers state the cash received, prefilled with the outstanding balance.
  const outstanding = order.paymentMethod !== 'ONLINE' && (milestone === 'DELIVERED' || milestone === 'PICKED_UP') ? order.payment?.physical?.remainingCentavos ?? 0 : 0
  const [cash, setCash] = useState(() => outstanding > 0 ? (outstanding / 100).toFixed(2) : '')
  const key = useRef(newIdempotencyKey())
  useEffect(() => { key.current = newIdempotencyKey() }, [note, receiver, receiverKind, handover, photo, signature, additional, cash])
  const label = ({ START_PREPARATION: 'Start preparing', MARK_READY: 'Mark ready for pickup', RECORD_PICKUP: 'Record handover', RECORD_DELIVERY: 'Record delivery' } as Record<string, string>)[next]
  function clearFieldError(name: string) {
    setErrors(current => { const updated = { ...current }; delete updated[name]; return updated })
    setMessage(null)
  }

  async function submit(event: FormEvent) {
    event.preventDefault()
    const local: Record<string, string> = {}
    if (milestone === 'DELIVERED' && !photo) local.file = 'Add a delivery photo.'
    if ((milestone === 'DELIVERED' || milestone === 'PICKED_UP') && receiver.trim().length < 2) local.receiver_name = 'Enter the receiver\'s name.'
    if (milestone === 'PICKED_UP' && !handover) local.handover_confirmed = 'Confirm the handover.'
    const cashCentavos = outstanding > 0 ? pesoInputToCentavos(cash) : null
    if (outstanding > 0 && (cashCentavos === null || cashCentavos > outstanding)) local.cash_received_centavos = `Enter an amount from ₱0.00 to ${formatPesoCentavos(outstanding)}.`
    if (milestone === 'PICKED_UP' && (cashCentavos ?? 0) > 0 && !photo) local.file = 'Add a handover photo as evidence of the cash received.'
    for (const [name, file] of [['file', photo], ['signature', signature], ...additional.map((file, index) => [`additional_${index}`, file])] as [string, File | null][]) {
      if (file && !['image/png', 'image/jpeg'].includes(file.type)) local[name] = 'Choose a JPG or PNG image.'
      if (file && order.fulfillment?.proofUploadLimitKb && file.size > order.fulfillment.proofUploadLimitKb * 1024) local[name] = `Choose an image up to ${Math.round(order.fulfillment.proofUploadLimitKb / 1024)} MB.`
    }
    setErrors(local)
    if (Object.keys(local).length) { setMessage('Add the required proof.'); return }
    const input: MilestoneInput = { milestone, lockVersion: order.lockVersion, ...(note.trim() ? { note: note.trim() } : {}) }
    if (milestone === 'DELIVERED') Object.assign(input, { receiverName: receiver.trim(), ...(photo ? { file: photo } : {}), ...(signature ? { signature } : {}), ...(additional.some(Boolean) ? { additionalPhotos: additional.filter((file): file is File => file !== null) } : {}) })
    if (milestone === 'PICKED_UP') Object.assign(input, { receiverName: receiver.trim(), receiverKind, handoverConfirmed: true, ...(photo ? { file: photo } : {}) })
    if (cashCentavos !== null) input.cashReceivedCentavos = cashCentavos
    setBusy(true); setMessage(null)
    try {
      const updated = await recordMilestone(order.id, input, key.current)
      key.current = newIdempotencyKey()
      onChanged(updated, `${label} recorded.`)
    } catch (cause) {
      if (shouldRotateIdempotencyKey(cause)) key.current = newIdempotencyKey()
      setErrors(await orderFieldErrors(cause))
      const failure = await apiFailure(cause)
      if (failure?.code === 'MILESTONE_ALREADY_RECORDED' || failure?.code === 'ORDER_STATE_CONFLICT' || failure?.code === 'STALE_VERSION') { setMessage('This order changed. Reloading its current fulfillment status…'); onReload() }
      else setMessage(await readableOrderError(cause))
    } finally { setBusy(false) }
  }

  const deliveryProof = milestone === 'DELIVERED'
  const noteField = <label className="grid min-w-0 content-start gap-2 text-sm font-semibold">Note (optional)<textarea className={`${control} ${deliveryProof ? 'min-h-24' : 'min-h-16'} py-2`} maxLength={500} value={note} onChange={event => setNote(event.target.value)} /></label>

  return <form className={deliveryProof ? 'mt-3 grid w-full min-w-0 max-w-5xl gap-5 rounded-control border border-border-default bg-surface-canvas p-4 sm:p-5' : 'mt-2 grid gap-4 rounded-control border border-action-primary/40 bg-brand-orange-50/40 p-4'} onSubmit={event => void submit(event)} noValidate aria-label={label}>
    {deliveryProof && <header className="flex items-start gap-3">
      <Camera size={20} className="mt-0.5 shrink-0 text-action-primary" aria-hidden="true" />
      <div className="min-w-0"><h3 className="text-lg font-semibold">Delivery proof</h3><p className="mt-1 text-sm leading-6 text-text-secondary">Enter who received the order and add a clear delivery photo.</p></div>
    </header>}
    {message && <StatusMessage tone="error">{message}</StatusMessage>}
    {(milestone === 'DELIVERED' || milestone === 'PICKED_UP') && <div className={deliveryProof ? 'grid min-w-0 items-start gap-5 md:grid-cols-2' : 'grid gap-4 sm:grid-cols-2'}>
      <Field label={milestone === 'DELIVERED' ? 'Receiver name' : 'Collected by'} name="receiver_name" required value={receiver} maxLength={120} error={errors.receiver_name} onChange={event => { setReceiver(event.target.value); clearFieldError('receiver_name') }} />
      {milestone === 'PICKED_UP' && <label className="grid gap-2 text-sm font-semibold">Receiver<select className={control} value={receiverKind} onChange={event => setReceiverKind(event.target.value as 'BUYER' | 'AUTHORIZED_RECEIVER')}>
        <option value="BUYER">The Buyer</option><option value="AUTHORIZED_RECEIVER">An authorized receiver</option></select></label>}
      <div className={milestone === 'PICKED_UP' ? 'min-w-0 sm:col-span-2' : 'min-w-0'}>
        <FileSelectionField camera label={milestone === 'DELIVERED' ? 'Delivery photo' : outstanding > 0 ? 'Handover photo (required when cash is received)' : 'Handover photo (optional)'} chooseLabel="Choose photo" accept="image/png,image/jpeg" hint={`JPG or PNG${order.fulfillment?.proofUploadLimitKb ? ` · up to ${Math.round(order.fulfillment.proofUploadLimitKb / 1024)} MB` : ''}`} required={milestone === 'DELIVERED'} file={photo} disabled={busy} error={errors.file} onChange={file => { setPhoto(file); clearFieldError('file') }} />
      </div>
      {milestone === 'PICKED_UP' && <label className="flex min-h-11 items-start gap-3 text-sm sm:col-span-2"><input type="checkbox" className="mt-0.5 h-5 w-5 accent-action-primary" checked={handover} onChange={event => setHandover(event.target.checked)} />
        <span>I handed over every line of this order to the person named above.</span></label>}
      {errors.handover_confirmed && <p className="text-sm text-status-error sm:col-span-2" role="alert">{errors.handover_confirmed}</p>}
      {outstanding > 0 && <div className={deliveryProof ? 'min-w-0 md:col-span-2' : 'min-w-0 sm:col-span-2'}>
        <Field label={`Cash received from the Buyer (${order.paymentMethod === 'IN_STORE' ? 'In-Store Payment' : 'Cash on Delivery'})`} name="cash_received_centavos" inputMode="decimal" required startAdornment="₱"
          value={cash} error={errors.cash_received_centavos} onChange={event => { setCash(event.target.value); clearFieldError('cash_received_centavos') }}
          hint={`Outstanding ${formatPesoCentavos(outstanding)}. Enter 0 if the Buyer paid nothing. ${order.permissions?.canRecordPhysicalPayment
            ? `It is recorded as cash received, with the ${deliveryProof ? 'delivery' : 'handover'} photo as evidence.`
            : 'The Owner, Store Manager or Store Staff confirms it before it counts as collected.'}`} />
      </div>}
    </div>}
    {deliveryProof ? <section aria-label="Optional delivery evidence" className="grid min-w-0 gap-4 border-t border-border-default pt-5">
      <h4 className="text-sm font-semibold">Optional details</h4>
      <div className="grid min-w-0 items-start gap-5 md:grid-cols-2">
        <FileSelectionField label="Receiver signature (optional)" chooseLabel="Choose signature" accept="image/png,image/jpeg" hint="JPG or PNG" file={signature} disabled={busy} error={errors.signature} onChange={setSignature} />
        {noteField}
      </div>
      <div className="grid min-w-0 gap-4">
        <div className="flex min-w-0 flex-col gap-3 sm:flex-row sm:flex-wrap sm:items-center sm:justify-between">
          <p className="text-sm text-text-secondary">Up to 3 additional delivery photos</p>
          {additional.length < 3 && <Button variant="secondary" className="w-full sm:w-auto" disabled={busy} onClick={() => setAdditional(current => [...current, null])}><ImagePlus size={16} aria-hidden="true" />Add another delivery photo</Button>}
        </div>
        {additional.length > 0 && <div className="grid min-w-0 items-start gap-4 md:grid-cols-2">{additional.map((file, index) => <FileSelectionField key={index} camera label={`Additional delivery photo ${index + 1} (optional)`} chooseLabel="Choose photo" accept="image/png,image/jpeg" hint="JPG or PNG" file={file} disabled={busy} error={errors[`additional_${index}`]} onChange={next => setAdditional(current => current.map((item, i) => i === index ? next : item))} />)}</div>}
      </div>
    </section> : noteField}
    <div className={deliveryProof ? 'flex min-w-0 flex-col gap-3 border-t border-border-default pt-4 sm:flex-row sm:items-center sm:justify-between' : 'flex flex-wrap items-center gap-3'}>
      {deliveryProof && <p className="max-w-lg text-sm text-text-secondary">The Buyer can review this proof in Order Details.</p>}
      <Button type="submit" disabled={busy} className={deliveryProof ? 'w-full sm:w-auto' : undefined}>{busy ? 'Recording…' : label}</Button>
      {milestone === 'READY_FOR_PICKUP' && <span className="text-xs text-text-secondary">This also opens Fulfillment Messages with the Buyer.</span>}
    </div>
  </form>
}

function AcceptedArrangement({ order, onChanged }: { order: OrderDetail; onChanged: Notify }) {
  const arrangement = order.fulfillment!.acceptedArrangement!
  const trips = order.fulfillment!.trips
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
    {order.fulfillment!.state === 'OUT_FOR_DELIVERY' && order.permissions?.canReportVehicleIssue && remaining.length > 0 && <div className="flex flex-wrap items-center gap-3">
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

function AssignmentPanel({ order, onChanged, onReload, dispatch = false }: { order: OrderDetail; onChanged: Notify; onReload: () => void; dispatch?: boolean }) {
  const current = order.fulfillment!.assignment
  const [options, setOptions] = useState<FulfillmentAssignee[] | null>(null)
  const [vehicles, setVehicles] = useState<DeliveryVehicleOption[] | null>(null)
  const [target, setTarget] = useState('')
  const [vehicle, setVehicle] = useState('')
  const [reason, setReason] = useState(dispatch ? 'Confirmed delivery dispatch' : '')
  const [error, setError] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  const [attempt, setAttempt] = useState(0)
  const key = useRef(newIdempotencyKey())
  const delivery = order.fulfillmentMethod === 'DELIVERY'
  useEffect(() => { key.current = newIdempotencyKey() }, [target, vehicle, reason, order.lockVersion])
  useEffect(() => {
    let active = true
    void Promise.all([listAssignees(order.id), delivery ? listDeliveryVehicles(order.id) : Promise.resolve([])]).then(([staff, fleet]) => {
      if (!active) return
      setError(null); setOptions(staff); setVehicles(fleet)
      setTarget(value => staff.some(row => String(row.userId) === value) ? value : staff.some(row => row.userId === current?.userId) ? String(current!.userId) : staff.length === 1 ? String(staff[0]!.userId) : '')
      setVehicle(value => value || String(current?.vehicle?.vehicleIndex ?? (fleet.filter(row => row.available).length === 1 ? fleet.find(row => row.available)!.vehicleIndex : '')))
    }).catch(async cause => { const text = await readableOrderError(cause); if (active) setError(text) })
    return () => { active = false }
  }, [order, current?.userId, current?.vehicle?.vehicleIndex, delivery, attempt])
  const selected = vehicles?.find(row => String(row.vehicleIndex) === vehicle)
  const selectedStaff = options?.find(row => String(row.userId) === target)
  return <section aria-labelledby="assignment-heading" className="grid gap-3 border-t border-border-default pt-4">
    <h3 id="assignment-heading" className="flex items-center gap-2 font-semibold"><UserRoundCheck size={16} aria-hidden="true" />{dispatch ? 'Confirm delivery assignment' : 'Fulfillment assignment'}</h3>
    <p className="text-sm">{current ? <>Assigned to <strong>{current.displayName}</strong>{current.vehicle?.name ? ` · ${current.vehicle.name}` : ''}{current.assignedAt ? ` since ${formatManilaDateTime(current.assignedAt)}` : ''}.</> : delivery ? 'Assign a Fulfillment Staff member and choose an available accepted vehicle before proceeding to Out for Delivery.' : 'No Fulfillment Staff assigned. The Owner or Store Manager can record pickup milestones directly.'}</p>
    {options === null && !error && <p className="text-sm text-text-secondary">Loading Fulfillment Staff…</p>}
    {options && options.length === 0 && <StatusMessage>No active Fulfillment Staff are available. <Link to="/team" className="inline-flex min-h-11 items-center underline">Open Team Accounts</Link></StatusMessage>}
    {delivery && vehicles && !vehicles.some(row => row.available) && <StatusMessage>No accepted vehicles are available. Restore availability in <Link to="/vehicles" className="inline-flex min-h-11 items-center underline">Vehicles</Link>; a different arrangement requires Buyer approval.</StatusMessage>}
    {options && options.length > 0 && <form className="grid min-w-0 gap-4" onSubmit={event => { event.preventDefault(); void (async () => {
      if (!selectedStaff || reason.trim().length < 5 || (delivery && !selected?.available)) { setError('Choose active staff, an available accepted vehicle and a reason of at least 5 characters.'); return }
      setBusy(true); setError(null)
      try { const updated = await assignFulfillment(order.id, Number(target), reason.trim(), { lockVersion: order.lockVersion, ...(delivery ? { vehicleIndex: Number(vehicle) } : {}), dispatch }, key.current); key.current = newIdempotencyKey(); onChanged(updated, dispatch ? 'Delivery assignment confirmed. The order is out for delivery.' : 'Fulfillment assignment saved. Affected staff have been notified.') } catch (cause) {
        const failure = await apiFailure(cause)
        if (['STALE_VERSION', 'ORDER_STATE_CONFLICT', 'MILESTONE_ALREADY_RECORDED'].includes(failure?.code ?? '')) { setError('This order changed. Reloading its current fulfillment status…'); onReload() }
        else { setError(await readableOrderError(cause)); setAttempt(value => value + 1) }
      } finally { setBusy(false) }
    })() }}>
      <div className="grid min-w-0 gap-4 sm:grid-cols-2"><label className="grid gap-2 text-sm font-semibold">Fulfillment Staff<select className={control} disabled={busy} value={target} onChange={event => setTarget(event.target.value)}>
        <option value="">Choose Fulfillment Staff</option>{options.map(option => <option key={option.userId} value={option.userId}>{option.displayName}</option>)}</select></label>
      {delivery && <label className="grid gap-2 text-sm font-semibold">Delivery vehicle<select className={control} disabled={busy} value={vehicle} onChange={event => setVehicle(event.target.value)}><option value="">Choose accepted vehicle</option>{vehicles?.map(row => <option key={row.vehicleIndex} value={row.vehicleIndex} disabled={!row.available}>{row.name}{row.available ? '' : ' · Unavailable'}</option>)}</select></label>}</div>
      {selected && <p className="text-sm">{selected.name} · {selected.numberOfVehicles} vehicle(s), {selected.totalVehicleTrips} accepted trip(s). {selected.unavailableReason}</p>}
      {delivery && <div className="grid gap-2 rounded-control bg-surface-canvas p-3 text-sm"><p className="font-semibold">{order.reference} · {order.buyer?.displayName ?? 'Buyer'}</p><p className="break-words">{String((order.destination?.heavyVehicleRestriction === 'YES' ? order.destination?.alternateDropOff : order.destination?.intended)?.formattedAddress ?? 'Confirmed delivery destination')}</p>{order.destination?.accessInstructions && <p className="break-words">{String(order.destination.accessInstructions)}</p>}<p>Final delivery fee: {formatPesoCentavos(order.fulfillment!.acceptedArrangement?.finalFeeCentavos ?? 0)}</p><p className="text-text-secondary">Assignment changes preserve the accepted arrangement and fee.</p></div>}
      <Field label="Reason" name="assignment_reason" value={reason} maxLength={500} onChange={event => setReason(event.target.value)} />
      {dispatch && <p className="text-xs text-text-secondary">Done confirms the assignment and marks this order Out for Delivery. It appears in the selected staff member’s Fulfillment portal.</p>}
      <Button className="w-full sm:w-fit" type="submit" variant={dispatch ? 'primary' : 'secondary'} disabled={busy || !selectedStaff || (delivery && !selected?.available)}>{busy ? 'Saving…' : dispatch ? 'Done' : current ? 'Reassign' : 'Assign'}</Button>
    </form>}
    {error && <StatusMessage tone="error">{error}<Button variant="quiet" onClick={() => setAttempt(value => value + 1)}>Retry options</Button></StatusMessage>}
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
    } catch (cause) { if (shouldRotateIdempotencyKey(cause)) key.current = newIdempotencyKey(); setError(await readableOrderError(cause)) } finally { setBusy(false) }
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
