import type { ReactNode } from 'react'
import type { OrderDetail, OrderLine, PaymentAttempt } from '@materyalph/api-client-ts'
import { FactList } from './operations-patterns'
import { InfoNote } from './page-patterns'
import { MoneyBreakdown, OrderHistory, OrderStateRows, formatPesoCentavos, orderStateLabel } from './order-patterns'
import { MilestoneStepper, RefundTimeline } from './fulfillment-patterns'
import { PrivateEvidenceGallery } from './private-evidence-gallery'
import { readOrderEvidenceFile } from './web-api-session'
import { ResponsiveRecordList, type RecordColumn } from './catalog-patterns'
import { formatManilaDateTime } from './stock-ledger'
import { WorkPackageAttachment } from './work-package-attachment'
import './order-audit-details.css'

const words = (value: string | null | undefined) => value ? value.replaceAll('_', ' ').toLowerCase() : 'Not recorded'
const date = (value: Date | null | undefined) => value ? formatManilaDateTime(value) : 'Not recorded'

function AuditSection({ title, label = title, meta, children }: { title: string; label?: string; meta?: ReactNode; children: ReactNode }) {
  return <section className="order-audit__section mp-card" aria-label={label}>
    <header className="order-audit__section-heading"><h2>{title}</h2>{meta && <span>{meta}</span>}</header>
    <div className="order-audit__section-body">{children}</div>
  </section>
}

/** One passive presenter for Audit Log and case-linked order investigations. No commercial mutation callbacks. */
export function OrderAuditDetails({ order, apiBasePath, relatedCase }: { order: OrderDetail; apiBasePath: string; relatedCase?: ReactNode }) {
  const proof = order.fulfillment?.proof
  const files = (paths: (string | undefined | null)[], label: string) => paths.filter((path): path is string => Boolean(path)).map((path, index) => ({ id: path, label: `${label} ${index + 1}`, loadFile: () => readOrderEvidenceFile(apiBasePath, path) }))
  const evidence = (paths: (string | undefined | null)[], label: string) => <PrivateEvidenceGallery apiBasePath={apiBasePath} items={files(paths, label)} layout="thumbnails" />
  const itemIdentity = (line: OrderLine) => <span className="grid gap-1"><strong>{line.displayName}</strong><span className="text-xs font-normal text-text-secondary">{[line.variantLabel, line.brand, line.category].filter(Boolean).join(' · ')}</span></span>
  const paymentIdentity = (payment: PaymentAttempt) => <span className="grid gap-1"><strong>{words(payment.purpose)}</strong><span className="font-normal">{payment.channelName ?? payment.channelCode ?? 'Online'} · attempt {payment.attemptNumber}</span><span className="text-xs font-normal text-text-secondary">{payment.environment} · {payment.evidenceOrigin}</span></span>
  const lines: RecordColumn<OrderLine>[] = [
    { key: 'item', header: 'Item', cell: itemIdentity },
    { key: 'quantity', header: 'Requested / confirmed', cell: line => `${line.requestedQuantity} ${line.unitName} / ${line.confirmedQuantity ?? (order.commercialVersion.accepted !== null ? line.requestedQuantity : 'Not yet confirmed')}${line.confirmedQuantity !== null || order.commercialVersion.accepted !== null ? ` ${line.unitName}` : ''}` },
    { key: 'unit', header: 'Unit price', cell: line => formatPesoCentavos(line.unitPriceCentavos) },
    { key: 'discount', header: 'Discount', cell: line => formatPesoCentavos(line.discountCentavos) },
    { key: 'total', header: 'Line total', cell: line => <span className="grid gap-1"><strong>{formatPesoCentavos(line.lineTotalCentavos)}</strong><span className="text-xs text-text-secondary">{line.vatLabel} · included VAT {formatPesoCentavos(line.includedVatCentavos)}</span></span> },
  ]
  const payments: RecordColumn<PaymentAttempt>[] = [
    { key: 'attempt', header: 'Payment', cell: paymentIdentity },
    { key: 'status', header: 'Status', cell: payment => orderStateLabel(payment.status) },
    { key: 'amount', header: 'Amount', cell: payment => <span className="order-audit__payment-amount"><strong>{formatPesoCentavos(payment.totalCentavos)}</strong><span>Principal {formatPesoCentavos(payment.principalCentavos)}</span><span>Processing fee {formatPesoCentavos(payment.processingFeeCentavos)}</span></span> },
    { key: 'date', header: 'Created / paid (Manila)', cell: payment => <span className="grid gap-1"><span>{date(payment.createdAt)}</span><span>{payment.paidAt ? date(payment.paidAt) : 'No verified payment'}</span></span> },
  ]
  const decision = order.refundTimeline?.decision
  const delivery = order.delivery.confirmed
  return <div className="order-audit">
    <InfoNote>Read-only audit view. Opening this order and its private evidence is recorded. Payment and refund states reflect recorded evidence.</InfoNote>
    <section className="order-audit__overview mp-card" aria-label="Order overview">
      <OrderStateRows states={order.states} className="order-audit__states" />
      <div className="order-audit__overview-body">
      <div className="order-audit__information">
      <h2 className="order-audit__heading">Order overview</h2>
      <div className="order-audit__facts">
      <FactList facts={[
        { label: 'Buyer', value: order.buyer?.displayName ?? 'Buyer' }, { label: 'Vendor', value: order.vendor.name },
        { label: 'Procurement', value: words(order.procurementType) }, { label: 'Payment method', value: words(order.paymentMethod) },
        { label: 'Fulfillment', value: words(order.fulfillmentMethod) }, { label: 'Expected fulfillment', value: order.expectedFulfillmentDate?.toLocaleDateString('en-PH', { timeZone: 'Asia/Manila' }) ?? 'Not recorded' },
        { label: 'Submitted', value: date(order.submittedAt) }, { label: 'Accepted', value: date(order.acceptedAt) }, { label: 'Closed', value: date(order.closedAt) },
        { label: 'Commercial version', value: `Current v${order.commercialVersion.current} · accepted ${order.commercialVersion.accepted === null ? 'not yet' : `v${order.commercialVersion.accepted}`}` },
        { label: 'Version recorded', value: date(order.commercialVersion.recordedAt) }, { label: 'Closure reason', value: words(order.terminalReasonCode) },
      ]} />
      </div>
      {relatedCase}
      {order.changes.length > 0 && <ul className="grid gap-2 text-sm">{order.changes.map((change, index) => <li key={index}>{change.label}: {change.from} → {change.to}</li>)}</ul>}
      </div>
      <div className="order-audit__money"><MoneyBreakdown money={order.money} title="Recorded payment breakdown" /></div>
      </div>
    </section>
    <div className="order-audit__columns">
    <div className="order-audit__main">
    <AuditSection title="Order items" meta={`${order.lines.length} ${order.lines.length === 1 ? 'item' : 'items'}`}><ResponsiveRecordList compact tableClassName="order-audit__items-table" caption="Recorded order items" rows={order.lines} columns={lines} rowKey={line => line.id} cardTitle={itemIdentity} /></AuditSection>
    <AuditSection title="Payment transactions" meta={order.payment?.attempts?.length ? `${order.payment.attempts.length} ${order.payment.attempts.length === 1 ? 'attempt' : 'attempts'}` : undefined}>
      {order.payment?.attempts?.length ? <ResponsiveRecordList compact tableClassName="order-audit__payments-table" caption="Online payment attempts" rows={order.payment.attempts} columns={payments} rowKey={payment => payment.id} cardTitle={paymentIdentity} /> : <p className="text-sm text-text-secondary">No online payment attempts recorded.</p>}
      {order.payment?.physical?.applicable && <><h3 className="font-semibold">Cash payment records</h3><p className="text-sm">{words(order.payment.physical.state)} · remaining {formatPesoCentavos(order.payment.physical.remainingCentavos)}</p>{order.payment.physical.records.map(record => <p key={record.id} className="text-sm">{date(record.recordedAt)} · {words(record.kind)} · {formatPesoCentavos(record.amountCentavos)} · {words(record.state)} · {words(record.source)}</p>)}</>}
    </AuditSection>
    {order.fulfillment && <AuditSection title="Fulfillment & evidence" label="Fulfillment evidence">
      <div className="order-audit__fulfillment">
      <MilestoneStepper steps={order.fulfillment.steps} showProofRequirements={false} />
      <div className="order-audit__fulfillment-records">
      <div className="order-audit__facts"><FactList facts={[
        { label: 'Assigned fulfillment staff', value: order.fulfillment.assignment?.displayName ?? 'None recorded' },
        { label: 'Assignment recorded', value: date(order.fulfillment.assignment?.assignedAt) },
        { label: 'Receipt confirmed', value: date(order.fulfillment.receipt.confirmedAt) },
        { label: 'Receipt confirmation source', value: words(order.fulfillment.receipt.confirmationSource) },
        { label: 'Receipt confirmation due', value: date(order.fulfillment.receipt.dueAt) },
        { label: 'Receipt timer', value: order.fulfillment.receipt.paused ? 'Paused' : 'Not paused' },
      ]} /></div>
      {proof && <div className="order-audit__proof"><h3>Handover evidence</h3><p className="text-sm">Received by {proof.receiverName ?? 'not recorded'} · {date(proof.recordedAt)} · {proof.recordedBy ?? 'Vendor'}</p>{proof.note && <p className="whitespace-pre-wrap text-sm">{proof.note}</p>}{evidence([proof.photoPath, ...(proof.additionalPhotoPaths ?? []), proof.signaturePath], 'Handover evidence')}</div>}
      {order.fulfillment.issue && <div className="order-audit__proof"><h3 className="font-semibold">Reported fulfillment issue</h3><p className="whitespace-pre-wrap text-sm">{words(order.fulfillment.issue.category)} · {words(order.fulfillment.issue.state)} · {order.fulfillment.issue.description}</p><p className="whitespace-pre-wrap text-sm">Vendor response: {order.fulfillment.issue.vendorResponse ?? 'None recorded'}</p><p className="text-sm">Resolution: {order.fulfillment.issue.resolution ?? 'None recorded'}</p>{evidence(order.fulfillment.issue.photoPaths, 'Issue evidence')}</div>}
      </div>
      </div>
      <p className="text-xs text-text-secondary">{order.fulfillment.trackingNotice}</p>
    </AuditSection>}
    {order.projectContext && <AuditSection title="Attached Work Package"><p className="text-sm">{String(order.projectContext.project_name ?? 'Project')} · version {String(order.projectContext.version ?? 'Not recorded')}</p><WorkPackageAttachment reference={{ ...order.projectContext, material_scope: 'VENDOR_ORDER', order: { reference: order.reference, accepted: order.acceptedAt !== null } }} />{order.projectContext.note != null && <p className="whitespace-pre-wrap text-sm">{String(order.projectContext.note)}</p>}</AuditSection>}
    {order.refundTimeline && <AuditSection title="Cancellation & refunds" label="Cancellation and refunds">
      {order.cancellation?.openRequest && <FactList facts={[{ label: 'Open cancellation request', value: words(order.cancellation.openRequest.reasonCode) }, { label: 'Buyer reason', value: order.cancellation.openRequest.reason ?? 'None recorded' }, { label: 'Requested', value: date(order.cancellation.openRequest.requestedAt) }, { label: 'Response due', value: date(order.cancellation.openRequest.responseDueAt) }]} />}
      {decision && <><FactList facts={[{ label: 'Decision', value: words(decision.decisionCode) }, { label: 'Reason', value: decision.reason ?? words(decision.reasonCode) }, { label: 'Decided', value: date(decision.decidedAt) }, { label: 'NRPC retained', value: formatPesoCentavos(decision.nrpcRetainedCentavos) }]} />{decision.nrpcEvidencePath && evidence([decision.nrpcEvidencePath], 'NRPC evidence')}</>}
      <RefundTimeline timeline={order.refundTimeline} audience="ADMIN" renderEvidence={(path, label) => evidence([path], label)} />
    </AuditSection>}
    </div>
    <div className="order-audit__supporting">
    <AuditSection title="Delivery & pickup" label="Delivery and pickup">
      <div className="order-audit__facts order-audit__delivery-facts"><FactList facts={[
        { label: 'Destination', value: order.destination?.storeAddress ?? order.destination?.intended?.formattedAddress ?? 'Not recorded' },
        { label: 'Alternate drop-off', value: order.destination?.alternateDropOff?.formattedAddress ?? 'None' },
        { label: 'Access instructions', value: order.destination?.accessInstructions ?? 'None recorded' },
        { label: 'Delivery confirmation', value: words(order.delivery.status) }, { label: 'Arrangement', value: delivery?.arrangement ?? 'Not recorded' },
        { label: 'Confirmed delivery fee', value: formatPesoCentavos(delivery?.finalFeeCentavos) },
        { label: 'Vendor response due', value: date(order.deadlines.vendorResponseDueAt) }, { label: 'Buyer response due', value: date(order.deadlines.buyerResponseDueAt) }, { label: 'Payment expiry', value: date(order.deadlines.paymentExpiresAt) },
      ]} /></div>
      {delivery?.vehicles.map((vehicle, index) => <p key={index} className="text-sm">{vehicle.name} · {vehicle.vehicleType} · {vehicle.totalVehicleTrips} trips · {formatPesoCentavos(vehicle.tripTotalCentavos)}</p>)}
    </AuditSection>
    {order.nrpc && <AuditSection title="NRPC"><p>{formatPesoCentavos(order.nrpc.amountCentavos)} · {words(order.nrpc.status)} · accepted {date(order.nrpc.acceptedAt)}</p><p className="whitespace-pre-wrap text-sm">{order.nrpc.reason}</p><p className="text-sm">{order.nrpc.cancellationEffect}</p>{order.nrpc.terms && <details><summary className="min-h-11 cursor-pointer py-3 text-sm font-semibold">{order.nrpc.terms.title} · v{order.nrpc.terms.version}</summary><p className="whitespace-pre-wrap text-sm">{order.nrpc.terms.content}</p></details>}</AuditSection>}
    <OrderHistory events={order.timeline} />
    </div>
    </div>
  </div>
}
