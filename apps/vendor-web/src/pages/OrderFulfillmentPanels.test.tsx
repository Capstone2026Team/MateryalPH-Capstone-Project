import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import type { FulfillmentStep, OrderFulfillment, OrderRefundTimeline } from '@materyalph/api-client-ts'
import { RefundTimeline } from '@materyalph/web-ui'
import * as orders from '../lib/orders-api'
import type { OrderDetail } from '../lib/orders-api'
import { CancellationPanel, FulfillmentWorkspace, RefundsPanel } from './OrderFulfillmentPanels'

vi.mock('../lib/orders-api', async original => ({ ...await original<typeof import('../lib/orders-api')>(), recordMilestone: vi.fn(), listAssignees: vi.fn(), assignFulfillment: vi.fn(),
  cancelOrder: vi.fn(), getCancellationPreview: vi.fn(), finalizeCancellationRequest: vi.fn(), retryRefund: vi.fn() }))

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
})

test('the stepper shows server-derived status as text and attaches dispatch to the current step using only accepted vehicles', async () => {
  const changed = vi.fn()
  vi.mocked(orders.recordMilestone).mockResolvedValue(order())
  wrap(<FulfillmentWorkspace order={order()} onChanged={changed} onReload={vi.fn()} />)
  const stepper = screen.getByRole('list', { name: 'Fulfillment milestones' })
  const items = within(stepper).getAllByRole('listitem')
  expect(items[1]).toHaveTextContent('Completed')
  expect(items[2]).toHaveAttribute('aria-current', 'step')
  expect(items[3]).toHaveTextContent('Proof required: delivery photo, receiver name, signature (optional).')
  expect(screen.getByText(/no live GPS tracking/)).toBeInTheDocument()
  expect(screen.getByText(/never change this arrangement or its fee/)).toBeInTheDocument()
  expect(screen.queryByRole('spinbutton')).not.toBeInTheDocument()
  fireEvent.change(screen.getByRole('combobox', { name: 'Trip' }), { target: { value: '2' } })
  fireEvent.click(screen.getByRole('button', { name: 'Dispatch — out for delivery' }))
  await waitFor(() => expect(orders.recordMilestone).toHaveBeenCalledWith('order-1', { milestone: 'OUT_FOR_DELIVERY', lockVersion: 7, vehicleIndex: 0, tripNumber: 2 }, expect.any(String)))
  expect(changed).toHaveBeenCalled()
})

test('delivery proof is required before the Delivered milestone is sent', async () => {
  const current = order({ fulfillment: fulfillment({ nextAction: 'RECORD_DELIVERY', steps: [step('CONFIRMED', 'Confirmed', 'COMPLETE'), step('DELIVERED', 'Delivered', 'CURRENT', true)] }) })
  wrap(<FulfillmentWorkspace order={current} onChanged={vi.fn()} onReload={vi.fn()} />)
  fireEvent.click(screen.getByRole('button', { name: 'Record delivery' }))
  expect(await screen.findByText('Add a delivery photo.')).toBeInTheDocument()
  expect(screen.getByText('Enter the receiver\'s name.')).toBeInTheDocument()
  expect(orders.recordMilestone).not.toHaveBeenCalled()
})

test('a role without milestone authority sees why instead of a disabled control', () => {
  wrap(<FulfillmentWorkspace order={order({}, { canRecordMilestone: false })} onChanged={vi.fn()} onReload={vi.fn()} />)
  expect(screen.getByText(/Only the Owner, Store Manager or the assigned Fulfillment Staff record this milestone/)).toBeInTheDocument()
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
