import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import type { FulfillmentStep, OrderFulfillment, OrderRefundTimeline } from '@materyalph/api-client-ts'
import { RefundTimeline } from '@materyalph/web-ui'
import * as orders from '../lib/orders-api'
import type { OrderDetail } from '../lib/orders-api'
import { CancellationPanel, FulfillmentWorkspace, RefundsPanel } from './OrderFulfillmentPanels'

vi.mock('../lib/orders-api', async original => ({ ...await original<typeof import('../lib/orders-api')>(), recordMilestone: vi.fn(), listAssignees: vi.fn(), listDeliveryVehicles: vi.fn(), assignFulfillment: vi.fn(),
  recordTrip: vi.fn(), cancelOrder: vi.fn(), getCancellationPreview: vi.fn(), finalizeCancellationRequest: vi.fn(), retryRefund: vi.fn() }))

const step = (key: string, label: string, status: FulfillmentStep['status'], proofRequired = false): FulfillmentStep => ({ key, label, status, proofRequired, proofRequirements: proofRequired ? ['DELIVERY_PHOTO', 'RECEIVER_NAME', 'SIGNATURE_OPTIONAL'] : [] })

function fulfillment(overrides: Partial<OrderFulfillment> = {}): OrderFulfillment {
  return {
    method: 'DELIVERY', state: 'PROCESSING', late: false, trackingNotice: 'There is no live GPS tracking. Status changes when the Vendor records each milestone.', trips: [], vehicleIssues: [],
    steps: [step('CONFIRMED', 'Confirmed', 'COMPLETE'), step('PROCESSING', 'Preparing', 'COMPLETE'), step('OUT_FOR_DELIVERY', 'Out for delivery', 'CURRENT'), step('DELIVERED', 'Delivered', 'UPCOMING', true), step('COMPLETED', 'Receipt confirmed', 'UPCOMING')],
    receipt: { paused: false, windowHours: 48 }, thread: { available: false, readOnly: false, notice: 'Fulfillment Messages open when the order is ready for pickup or out for delivery.' },
    acceptedArrangement: { vehicles: [{ vehicleIndex: 0, name: 'Box truck', numberOfVehicles: 1, totalVehicleTrips: 2 }], finalFeeCentavos: 60500, endpoint: 'ALTERNATE_DROP_OFF', arrangement: 'Two trips to the north gate.',
      notice: 'Accepted when the order was confirmed. Later vehicle, rate or store-hour changes never change this arrangement or its fee.' },
    nextAction: 'DISPATCH', ...overrides,
  }
}

function order(overrides: Record<string, unknown> = {}, permissions: Record<string, boolean> = {}): OrderDetail {
  return {
    id: 'order-1', reference: 'ORD-2026-FULFILL1', fulfillmentMethod: 'DELIVERY', lockVersion: 7, acceptedAt: new Date(),
    states: [{ family: 'ORDER', state: 'PROCESSING' }, { family: 'PAYMENT', state: 'PAID' }, { family: 'FULFILLMENT', state: 'PROCESSING' }, { family: 'REFUND', state: 'NOT_REQUESTED' }, { family: 'DISPUTE', state: 'NONE' }],
    fulfillment: fulfillment(), cancellation: { explanation: 'You can cancel with a reason. Every Buyer-paid amount is refunded to the original payment method.', reasonCodes: ['STOCK_FAILURE', 'OTHER'], nrpcRetainableCentavos: 0 },
    refundTimeline: { refunds: [], reimbursements: [], noLongerDueCentavos: 0 },
    permissions: { canConfirm: false, canRevise: false, canSetNrpc: false, canConfirmDelivery: false, canDecline: false, canViewInventory: false, canRecordMilestone: true, canAssignFulfillment: false,
      canCancel: false, canFinalizeCancellation: false, canReportVehicleIssue: false, canRetryRefund: false, canRespondProblem: true, ...permissions },
    ...overrides,
  } as unknown as OrderDetail
}

const wrap = (node: React.ReactNode) => render(<MemoryRouter>{node}</MemoryRouter>)

beforeEach(() => {
  vi.clearAllMocks()
  vi.mocked(orders.listAssignees).mockResolvedValue([])
  vi.mocked(orders.listDeliveryVehicles).mockResolvedValue([])
})

test('Owner sees the required staff selector directly in Out for Delivery and confirms dispatch atomically', async () => {
  vi.mocked(orders.listAssignees).mockResolvedValue([{ userId: 12, displayName: 'Delivery Staff', assigned: false }])
  vi.mocked(orders.listDeliveryVehicles).mockResolvedValue([{ vehicleIndex: 0, vehicleId: 'vehicle-1', name: 'Box truck', vehicleType: 'TRUCK', numberOfVehicles: 1, totalVehicleTrips: 2, available: true, unavailableReason: '' }])
  vi.mocked(orders.assignFulfillment).mockResolvedValue(order())
  const changed = vi.fn()
  wrap(<FulfillmentWorkspace order={order({}, { canAssignFulfillment: true })} onChanged={changed} onReload={vi.fn()} />)
  expect(screen.getByRole('heading', { name: 'Confirm delivery assignment' })).toBeVisible()
  expect(screen.getByText(/Assign a Fulfillment Staff member.*before proceeding to Out for Delivery/)).toBeVisible()
  const staff = await screen.findByRole('combobox', { name: 'Fulfillment Staff' })
  await waitFor(() => expect(staff).toHaveValue('12'))
  expect(screen.getByRole('combobox', { name: 'Delivery vehicle' })).toHaveValue('0')
  const dispatchStep = within(screen.getByRole('list', { name: 'Fulfillment milestones' })).getAllByRole('listitem')[2]!
  expect(within(dispatchStep).getByRole('combobox', { name: 'Fulfillment Staff' })).toBe(staff)
  fireEvent.click(screen.getByRole('button', { name: 'Done' }))
  await waitFor(() => expect(orders.assignFulfillment).toHaveBeenCalledWith('order-1', 12, 'Confirmed delivery dispatch', { lockVersion: 7, vehicleIndex: 0, dispatch: true }, expect.any(String)))
  expect(orders.recordMilestone).not.toHaveBeenCalled()
  expect(changed).toHaveBeenCalled()
})

test('unavailable accepted vehicles block dispatch and link to fleet management', async () => {
  vi.mocked(orders.listAssignees).mockResolvedValue([{ userId: 12, displayName: 'Delivery Staff', assigned: false }])
  vi.mocked(orders.listDeliveryVehicles).mockResolvedValue([{ vehicleIndex: 0, vehicleId: 'vehicle-1', name: 'Box truck', vehicleType: 'TRUCK', numberOfVehicles: 1, totalVehicleTrips: 2, available: false, unavailableReason: 'Already allocated to another delivery.' }])
  wrap(<FulfillmentWorkspace order={order({}, { canAssignFulfillment: true })} onChanged={vi.fn()} onReload={vi.fn()} />)
  expect(await screen.findByText(/No accepted vehicles are available/)).toBeVisible()
  expect(screen.getByRole('link', { name: 'Vehicles' })).toHaveAttribute('href', '/vehicles')
  expect(screen.getByRole('button', { name: 'Done' })).toBeDisabled()
  expect(orders.assignFulfillment).not.toHaveBeenCalled()
})

test('the vendor stepper preserves status and arrangement without staff proof fields or separate assignment controls', () => {
  wrap(<FulfillmentWorkspace order={order({ fulfillment: fulfillment({ assignment: { displayName: 'Assigned staff', role: 'FULFILLMENT', assignedAt: new Date(), userId: 12 } }) })} onChanged={vi.fn()} onReload={vi.fn()} />)
  const stepper = screen.getByRole('list', { name: 'Fulfillment milestones' })
  const items = within(stepper).getAllByRole('listitem')
  expect(items[1]).toHaveTextContent('Completed')
  expect(items[2]).toHaveAttribute('aria-current', 'step')
  expect(items[3]).not.toHaveTextContent('Proof required')
  expect(items[2]).toHaveTextContent('Assigned staff')
  expect(screen.getByText(/no live GPS tracking/)).toBeInTheDocument()
  expect(screen.getByText(/never change this arrangement or its fee/)).toBeInTheDocument()
  expect(screen.queryByRole('spinbutton')).not.toBeInTheDocument()
  expect(screen.queryByRole('heading', { name: 'Fulfillment assignment' })).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: /Dispatch —/ })).not.toBeInTheDocument()
  expect(screen.queryByRole('combobox', { name: 'Fulfillment Staff' })).not.toBeInTheDocument()
  expect(orders.listAssignees).not.toHaveBeenCalled()
  expect(orders.listDeliveryVehicles).not.toHaveBeenCalled()
})

test('dispatch without active Fulfillment Staff cannot be completed', async () => {
  wrap(<FulfillmentWorkspace order={order({}, { canAssignFulfillment: true })} onChanged={vi.fn()} onReload={vi.fn()} />)
  expect(await screen.findByText(/No active Fulfillment Staff are available/)).toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Done' })).not.toBeInTheDocument()
  expect(orders.assignFulfillment).not.toHaveBeenCalled()
  expect(orders.recordMilestone).not.toHaveBeenCalled()
})

test('multiple Fulfillment Staff require selecting the delivery assignee before Done', async () => {
  vi.mocked(orders.listAssignees).mockResolvedValue([{ userId: 12, displayName: 'First Staff', assigned: false }, { userId: 13, displayName: 'Second Staff', assigned: false }])
  vi.mocked(orders.listDeliveryVehicles).mockResolvedValue([{ vehicleIndex: 0, vehicleId: 'vehicle-1', name: 'Box truck', vehicleType: 'TRUCK', numberOfVehicles: 1, totalVehicleTrips: 2, available: true, unavailableReason: '' }])
  vi.mocked(orders.assignFulfillment).mockResolvedValue(order())
  wrap(<FulfillmentWorkspace order={order({}, { canAssignFulfillment: true })} onChanged={vi.fn()} onReload={vi.fn()} />)
  const staff = await screen.findByRole('combobox', { name: 'Fulfillment Staff' })
  expect(staff).toHaveValue('')
  expect(within(staff).getByRole('option', { name: 'First Staff' })).toBeVisible()
  expect(within(staff).getByRole('option', { name: 'Second Staff' })).toBeVisible()
  expect(screen.getByRole('button', { name: 'Done' })).toBeDisabled()
  fireEvent.click(screen.getByRole('button', { name: 'Done' }))
  expect(orders.assignFulfillment).not.toHaveBeenCalled()
  fireEvent.change(staff, { target: { value: '13' } })
  fireEvent.click(screen.getByRole('button', { name: 'Done' }))
  await waitFor(() => expect(orders.assignFulfillment).toHaveBeenCalledWith('order-1', 13, 'Confirmed delivery dispatch', { lockVersion: 7, vehicleIndex: 0, dispatch: true }, expect.any(String)))
})

test('delivery proof is required before the Delivered milestone is sent', async () => {
  const current = order({ fulfillment: fulfillment({ nextAction: 'RECORD_DELIVERY', steps: [step('CONFIRMED', 'Confirmed', 'COMPLETE'), step('DELIVERED', 'Delivered', 'CURRENT', true)] }) })
  wrap(<FulfillmentWorkspace staffWorkspace order={current} onChanged={vi.fn()} onReload={vi.fn()} />)
  fireEvent.click(screen.getByRole('button', { name: 'Record delivery' }))
  expect(await screen.findByText('Add a delivery photo.')).toBeInTheDocument()
  expect(screen.getByText('Enter the receiver\'s name.')).toBeInTheDocument()
  expect(orders.recordMilestone).not.toHaveBeenCalled()
})

test('vendor Delivered is managed by assigned staff even if stale permissions still allow milestones', () => {
  const current = order({ fulfillment: fulfillment({ state: 'OUT_FOR_DELIVERY', nextAction: 'RECORD_DELIVERY', assignment: { displayName: 'Assigned staff', role: 'FULFILLMENT', userId: 12 }, steps: [step('OUT_FOR_DELIVERY', 'Out for delivery', 'COMPLETE'), step('DELIVERED', 'Delivered', 'CURRENT', true)] }) })
  wrap(<FulfillmentWorkspace order={current} onChanged={vi.fn()} onReload={vi.fn()} />)
  expect(screen.getByText(/Assigned staff records Delivered/)).toBeVisible()
  expect(screen.queryByRole('textbox', { name: 'Receiver name' })).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Choose photo' })).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Choose signature' })).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Record delivery' })).not.toBeInTheDocument()
  expect(screen.queryByText(/Proof required:/)).not.toBeInTheDocument()
})

test('delivery reassign stays inside Out for Delivery while the staff completion step is current', () => {
  const current = order({ fulfillment: fulfillment({ state: 'OUT_FOR_DELIVERY', nextAction: 'NONE', assignment: { displayName: 'Assigned staff', role: 'FULFILLMENT', userId: 12 }, steps: [step('OUT_FOR_DELIVERY', 'Out for delivery', 'COMPLETE'), step('DELIVERED', 'Delivered', 'CURRENT', true)] }) }, { canRecordMilestone: false, canAssignFulfillment: true })
  wrap(<FulfillmentWorkspace order={current} onChanged={vi.fn()} onReload={vi.fn()} />)
  const dispatchStep = within(screen.getByRole('list', { name: 'Fulfillment milestones' })).getAllByRole('listitem')[0]!
  expect(within(dispatchStep).getByRole('button', { name: 'Reassign Fulfillment Staff' })).toBeVisible()
  expect(screen.getByText(/Assigned staff records Delivered/)).toBeVisible()
})

test('vendor oversight can still record an accepted trip while staff owns delivery proof', async () => {
  vi.mocked(orders.recordTrip).mockResolvedValue(order())
  const current = order({ fulfillment: fulfillment({ state: 'OUT_FOR_DELIVERY', nextAction: 'NONE', trips: [{ vehicleIndex: 0, tripNumber: 1, totalVehicleTrips: 2, name: 'Box truck' }] }) }, { canRecordMilestone: false, canReportVehicleIssue: true })
  wrap(<FulfillmentWorkspace order={current} onChanged={vi.fn()} onReload={vi.fn()} />)
  fireEvent.click(screen.getByRole('button', { name: 'Record next accepted trip (Box truck, trip 2)' }))
  await waitFor(() => expect(orders.recordTrip).toHaveBeenCalledWith('order-1', 0, 2))
  expect(screen.queryByRole('button', { name: 'Record delivery' })).not.toBeInTheDocument()
})

test('an existing Out for Delivery order without staff can be assigned inside its dispatch phase', async () => {
  vi.mocked(orders.listAssignees).mockResolvedValue([{ userId: 12, displayName: 'Delivery Staff', assigned: false }])
  vi.mocked(orders.listDeliveryVehicles).mockResolvedValue([{ vehicleIndex: 0, vehicleId: 'vehicle-1', name: 'Box truck', vehicleType: 'TRUCK', numberOfVehicles: 1, totalVehicleTrips: 2, available: true, unavailableReason: '' }])
  vi.mocked(orders.assignFulfillment).mockResolvedValue(order())
  const current = order({ fulfillment: fulfillment({ state: 'OUT_FOR_DELIVERY', nextAction: 'NONE', steps: [step('OUT_FOR_DELIVERY', 'Out for delivery', 'COMPLETE'), step('DELIVERED', 'Delivered', 'CURRENT', true)] }) }, { canRecordMilestone: false, canAssignFulfillment: true })
  wrap(<FulfillmentWorkspace order={current} onChanged={vi.fn()} onReload={vi.fn()} />)
  const dispatchStep = within(screen.getByRole('list', { name: 'Fulfillment milestones' })).getAllByRole('listitem')[0]!
  fireEvent.click(within(dispatchStep).getByRole('button', { name: 'Assign Fulfillment Staff' }))
  await screen.findByRole('combobox', { name: 'Fulfillment Staff' })
  fireEvent.change(screen.getByRole('textbox', { name: 'Reason' }), { target: { value: 'Assign staff to complete this existing delivery.' } })
  fireEvent.click(screen.getByRole('button', { name: 'Assign' }))
  await waitFor(() => expect(orders.assignFulfillment).toHaveBeenCalledWith('order-1', 12, 'Assign staff to complete this existing delivery.', { lockVersion: 7, vehicleIndex: 0, dispatch: false }, expect.any(String)))
  expect(orders.recordMilestone).not.toHaveBeenCalled()
})

test('Self-Pickup retains vendor handover proof and its optional staff assignment', async () => {
  const current = order({ fulfillmentMethod: 'PICKUP', fulfillment: fulfillment({ method: 'PICKUP', state: 'READY_FOR_PICKUP', nextAction: 'RECORD_PICKUP', acceptedArrangement: null, steps: [step('PICKED_UP', 'Picked up', 'CURRENT', true)] }) }, { canAssignFulfillment: true })
  wrap(<FulfillmentWorkspace order={current} onChanged={vi.fn()} onReload={vi.fn()} />)
  expect(screen.getByRole('textbox', { name: 'Collected by' })).toBeInTheDocument()
  expect(screen.getByRole('button', { name: 'Record handover' })).toBeInTheDocument()
  expect(screen.getByRole('heading', { name: 'Fulfillment assignment' })).toBeInTheDocument()
  expect(await screen.findByText(/No active Fulfillment Staff are available/)).toBeVisible()
})

test('a role without milestone authority sees why instead of a disabled control', () => {
  wrap(<FulfillmentWorkspace order={order({}, { canRecordMilestone: false })} onChanged={vi.fn()} onReload={vi.fn()} />)
  expect(screen.getByText(/The Owner or Store Manager confirms the staff and vehicle assignment/)).toBeInTheDocument()
  expect(screen.queryByRole('button', { name: /Dispatch/ })).not.toBeInTheDocument()
})

test('a paused receipt window is explained and a problem report shows the respond form', () => {
  const current = order({ states: [{ family: 'ORDER', state: 'DELIVERED' }], fulfillment: fulfillment({ nextAction: 'AWAIT_RECEIPT', receipt: { paused: true, remainingSeconds: 3600, windowHours: 48 },
    issue: { id: 'issue-1', category: 'DAMAGED', description: 'Two blocks arrived cracked.', state: 'OPEN', photoPaths: [] } }) })
  wrap(<FulfillmentWorkspace order={current} onChanged={vi.fn()} onReload={vi.fn()} />)
  expect(screen.getByText(/Automatic receipt confirmation is paused/)).toBeInTheDocument()
  expect(screen.getByText('Open — auto-confirmation paused')).toBeInTheDocument()
  expect(screen.getByRole('textbox', { name: 'Respond to the Buyer' })).toBeInTheDocument()
})

test('vendor cancellation shows the consequences and server amounts before confirming', async () => {
  vi.mocked(orders.getCancellationPreview).mockResolvedValue({ vendorCancellation: { cause: 'VENDOR', nrpcRetainedCentavos: 0, nrpcAcceptedCentavos: 100000, online: [], onlineRefundTotalCentavos: 102345,
    cashReimbursementCentavos: 40000, releasedUnpaidCentavos: 50000, paidTotalCentavos: 142345, excludes: ['VENDOR_COMMISSION'] } })
  vi.mocked(orders.cancelOrder).mockResolvedValue(order())
  const changed = vi.fn()
  wrap(<CancellationPanel order={order({}, { canCancel: true })} onChanged={changed} />)
  fireEvent.click(screen.getByRole('button', { name: 'Cancel this order' }))
  const dialog = await screen.findByRole('dialog')
  expect(within(dialog).getByText(/forfeits any NRPC/)).toBeInTheDocument()
  expect(await within(dialog).findByText('₱1,023.45')).toBeInTheDocument()
  expect(within(dialog).getByText('Cash you must reimburse')).toBeInTheDocument()
  fireEvent.click(within(dialog).getByRole('button', { name: 'Cancel order and refund' }))
  expect(await within(dialog).findByText(/at least 10 characters/)).toBeInTheDocument()
  fireEvent.change(within(dialog).getByRole('textbox', { name: 'Message to the Buyer' }), { target: { value: 'The cement supplier failed to deliver.' } })
  fireEvent.click(within(dialog).getByRole('button', { name: 'Cancel order and refund' }))
  await waitFor(() => expect(orders.cancelOrder).toHaveBeenCalledWith('order-1', 7, 'STOCK_FAILURE', 'The cement supplier failed to deliver.', expect.any(String)))
  expect(changed).toHaveBeenCalled()
})

test('refund initiation and refund success are visibly different, and only an Owner retry is offered', async () => {
  const timeline: OrderRefundTimeline = { noLongerDueCentavos: 50000, reimbursements: [], refunds: [
    { id: 'r1', trigger: 'CANCELLATION', state: 'REFUND_PENDING', displayState: 'INITIATED', amountCentavos: 1000, processingFeeCentavos: 0, paymentPurpose: 'FULL_ORDER_PAYMENT', originalMethod: 'GCash', attemptNumber: 1, canRetry: false, message: 'Refund initiated with the payment provider.' },
    { id: 'r2', trigger: 'CANCELLATION', state: 'REFUNDED', displayState: 'PROCESSED', amountCentavos: 2000, processingFeeCentavos: 0, paymentPurpose: 'NRPC_ASSURANCE_PAYMENT', originalMethod: 'Maya', attemptNumber: 1, canRetry: false, message: 'Refund processed.' },
    { id: 'r3', trigger: 'CANCELLATION', state: 'REFUND_FAILED', displayState: 'FAILED', amountCentavos: 3000, processingFeeCentavos: 0, paymentPurpose: 'ORDER_BALANCE_PAYMENT', originalMethod: 'Card', attemptNumber: 1, canRetry: true, failureCode: 'INSUFFICIENT_BALANCE', message: 'The refund failed.' },
  ] }
  render(<RefundTimeline timeline={timeline} audience="BUYER" />)
  expect(screen.getByText('Refund initiated — awaiting provider confirmation')).toBeInTheDocument()
  expect(screen.getByText('Refund processed by the payment provider')).toBeInTheDocument()
  expect(screen.queryByText('INSUFFICIENT_BALANCE')).not.toBeInTheDocument()
  expect(screen.getByText(/No longer due/)).toBeInTheDocument()

  vi.mocked(orders.retryRefund).mockResolvedValue(order())
  const changed = vi.fn()
  wrap(<RefundsPanel order={order({ refundTimeline: timeline }, { canRetryRefund: true })} onChanged={changed} />)
  fireEvent.click(screen.getByRole('button', { name: 'Retry refund after funding is resolved' }))
  await waitFor(() => expect(orders.retryRefund).toHaveBeenCalledWith('order-1', 'r3'))
})
