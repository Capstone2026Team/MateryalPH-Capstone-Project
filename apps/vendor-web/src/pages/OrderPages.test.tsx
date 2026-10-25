import { act, fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter, Route, Routes, useLocation } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import { ResponseError } from '@materyalph/api-client-ts'
import { DeadlineCountdown, MoneyBreakdown, OrderProgress, OrderStateRows } from '@materyalph/web-ui'
import * as onboarding from '../lib/onboarding-api'
import * as orders from '../lib/orders-api'
import { chatApi } from '../lib/messaging-api'
import type { ConversationDetail } from '@materyalph/api-client-ts'
import * as disputes from '../lib/disputes-api'
import type { OrderDetail, OrderLine, OrderSummary } from '../lib/orders-api'
import { VendorOrderDetailPage, VendorOrdersPage } from './OrderPages'

vi.mock('../lib/onboarding-api', async original => ({ ...await original<typeof import('../lib/onboarding-api')>(), getVendorOnboarding: vi.fn(), getVendorPrivateFileUrl: vi.fn() }))
vi.mock('../lib/messaging-api', async original => ({ ...await original<typeof import('../lib/messaging-api')>(), chatApi: { forOrder: vi.fn(), get: vi.fn() } }))
vi.mock('./FulfillmentConversationDialog', () => ({ FulfillmentConversationDialog: ({ conversationId, onClose }: { conversationId: string; onClose: () => void }) => <div role="dialog" aria-label="Fulfillment conversations"><p>Thread {conversationId}</p><button onClick={onClose}>Close fulfillment popup</button></div> }))
vi.mock('../lib/orders-api', async original => ({ ...await original<typeof import('../lib/orders-api')>(), listOrders: vi.fn(), getOrder: vi.fn(), confirmOrder: vi.fn(), declineOrder: vi.fn(), getDeliveryPlan: vi.fn(), listAssignees: vi.fn(), listDeliveryVehicles: vi.fn(), assignFulfillment: vi.fn() }))
vi.mock('../lib/disputes-api', async original => ({ ...await original<typeof import('../lib/disputes-api')>(), getEligibility: vi.fn() }))

const states = (order: string, payment = 'NOT_REQUIRED') => [
  { family: 'ORDER' as const, state: order }, { family: 'PAYMENT' as const, state: payment }, { family: 'FULFILLMENT' as const, state: 'NOT_STARTED' },
  { family: 'REFUND' as const, state: 'NOT_REQUESTED' }, { family: 'DISPUTE' as const, state: 'NONE' },
]

function line(overrides: Partial<OrderLine> = {}): OrderLine {
  return {
    id: 'line-1', lineNumber: 1, listingId: 'listing-1', listingVariantId: 'variant-1', displayName: 'Hollow block 4"', variantLabel: 'Standard', brand: 'BrandCo', category: 'Masonry', image: null,
    unitCode: 'PC', unitName: 'piece', unitPrecision: 0, quantityStep: '1', requestedQuantity: '10.0000', confirmedQuantity: null, unitPriceCentavos: 1800, ordinaryUnitPriceCentavos: 1800,
    volumeTierApplied: false, volumeTiers: [], grossCentavos: 18000, discountCentavos: 0, lineTotalCentavos: 18000, includedVatCentavos: 0, taxCategory: 'NON_VAT', vatLabel: 'Non-VAT seller', change: null,
    priceVersionId: 'price-1', inventory: { quantityOnHand: '40.0000', hardReservedQuantity: '4.0000', availableToSell: '36.0000' }, ...overrides,
  }
}

const money = {
  currency: 'PHP' as const, calculationVersion: 'fin02.order.v1', status: 'ADVISORY_UNTIL_VENDOR_CONFIRMATION' as const, materialsGrossCentavos: 18000, vendorDiscountCentavos: 0, materialsSubtotalCentavos: 18000,
  includedVatCentavos: 0, vatExclusiveCentavos: 18000, vatTreatment: 'NO_INCLUDED_VAT' as const, delivery: { status: 'NOT_APPLICABLE' as const, amountCentavos: 0, estimate: null },
  nrpc: { amountCentavos: 0, withinOrderValue: true as const, status: null }, processingFee: { status: 'PENDING_PAYMENT_CHANNEL' as const, amountCentavos: null },
  commercialTotalCentavos: 18000, amountDueOnlineCentavos: null, onlinePrincipalCentavos: 18000, physicalBalanceCentavos: 0, paymentPurpose: 'FULL_ORDER_PAYMENT' as const, excludes: ['VENDOR_COMMISSION' as const, 'MERCHANT_WITHHOLDING' as const],
}

function detail(overrides: Partial<OrderDetail> = {}, permissions: Partial<NonNullable<OrderDetail['permissions']>> = {}): OrderDetail {
  return {
    id: 'order-1', reference: 'ORD-2026-ABCDEFGH', checkout: { id: 'checkout-1', reference: 'CHK-2026-ABCDEFGH' }, vendor: { id: 'vendor-1', name: 'Test Supply' }, procurementType: 'ITEM_BASED',
    fulfillmentMethod: 'PICKUP', paymentMethod: 'ONLINE', submittedAt: new Date('2026-10-05T01:00:00Z'), acceptedAt: null, closedAt: null, terminalReasonCode: null, confirmationSource: null,
    states: states('AWAITING_VENDOR_CONFIRMATION'), deadlines: { vendorResponseDueAt: new Date(Date.now() + 20 * 3_600_000), buyerResponseDueAt: null, paymentExpiresAt: null, serverTime: new Date(), timezone: 'Asia/Manila' },
    commercialVersion: { current: 1, accepted: null, kind: 'SUBMITTED', contentHash: 'hash', recordedAt: new Date() }, changes: [], expectedFulfillmentDate: null, lines: [line()],
    destination: { type: 'PICKUP', storeAddress: '123 Aurora Blvd' }, delivery: { status: 'NOT_APPLICABLE', estimate: null, confirmed: null }, money, nrpc: null,
    timeline: [{ family: 'ORDER', fromState: null, toState: 'AWAITING_VENDOR_CONFIRMATION', source: 'BUYER', actorRole: 'BUYER', reasonCode: 'ORDER_SUBMITTED', snapshotVersion: 1, at: new Date() }],
    lockVersion: 3, buyer: { displayName: 'Maria Buyer' }, autoAccept: { accepted: false, routedTo: 'MANUAL_REVIEW', reasons: [{ code: 'POLICY_NOT_ACTIVE', listingVariantId: 'variant-1' }], ruleVersion: 'v1', evaluatedAt: new Date() },
    reservations: [], primaryAction: 'CONFIRM', nrpcTerms: { id: 'terms-1', version: 1, title: 'NRPC Terms', available: true }, declineReasons: ['STOCK_UNAVAILABLE', 'OTHER'],
    permissions: { canConfirm: true, canRevise: true, canSetNrpc: true, canConfirmDelivery: true, canDecline: true, canViewInventory: true, ...permissions }, ...overrides,
  }
}

function summary(overrides: Partial<OrderSummary> = {}): OrderSummary {
  return {
    id: 'order-1', reference: 'ORD-2026-ABCDEFGH', vendor: { id: 'vendor-1', name: 'Test Supply' }, submittedAt: new Date('2026-10-05T01:00:00Z'), procurementType: 'ITEM_BASED', confirmationSource: null,
    states: states('AWAITING_VENDOR_CONFIRMATION'), fulfillmentMethod: 'PICKUP', paymentMethod: 'ONLINE', lineCount: 2, firstLine: { displayName: 'Hollow block 4"', image: null },
    materialsCentavos: 18000, deliveryCentavos: 0, commercialTotalCentavos: 18000, deliveryPending: false, deadline: { kind: 'VENDOR_RESPONSE', at: new Date('2026-10-06T01:00:00Z') },
    expectedFulfillmentDate: null, buyer: { displayName: 'Maria Buyer' }, primaryAction: 'CONFIRM', nrpcIndicator: false, ...overrides,
  }
}

function snapshot(permissions: string[]): Awaited<ReturnType<typeof onboarding.getVendorOnboarding>> {
  return ({ stepCompletion: [], lockVersion: 1, requirements: [], drafts: [], organization: { store_name: 'Test Supply' }, welcomeRequired: false, permissions, verification: {}, setup: { status: 'COMPLETED' }, activation: { status: 'ACTIVE', marketplaceDiscoverabilityStatus: 'DISCOVERABLE', readiness: { ready: true, blockers: [], status: 'READY', ruleVersion: 'test' } }, sections: {} }) as Awaited<ReturnType<typeof onboarding.getVendorOnboarding>>
}

function failure(status: number, code: string, details: Record<string, unknown> = {}): ResponseError {
  return new ResponseError(new Response(JSON.stringify({ data: null, meta: {}, errors: [{ code, message: 'Conflict', details }] }), { status, headers: { 'Content-Type': 'application/json' } }), 'failed')
}

function fulfillmentUnread(count: number): ConversationDetail {
  return {
    conversation: { id: 'fulfillment-1', purpose: 'FULFILLMENT', contextType: 'ITEM_BASED', lockVersion: 1,
      store: { id: 'store-1', name: 'Supply', verified: true }, unreadCount: count, channel: 'private-thread',
      lockedReference: {}, updatedAt: '2026-10-12T08:00:00Z', canTransfer: false, fulfillmentEntryEnabled: true, readOnly: false },
    messages: { items: [], hasMore: false }, quotations: { versions: [], hasMore: false },
  }
}

beforeEach(() => {
  vi.clearAllMocks()
  vi.mocked(chatApi.get).mockResolvedValue(fulfillmentUnread(0))
  vi.mocked(onboarding.getVendorOnboarding).mockResolvedValue(snapshot(['portal.messages', 'portal.orders', 'orders.confirm', 'orders.revise']))
  vi.mocked(onboarding.getVendorPrivateFileUrl).mockResolvedValue({ url: 'https://example.test/logo', expiresAt: new Date() })
})

const openDetail = () => render(<MemoryRouter initialEntries={['/orders/order-1']}><Routes><Route path="/orders/:orderId" element={<VendorOrderDetailPage />} /></Routes></MemoryRouter>)

test('a Fulfillment Staff order link opens their assigned workspace for delivery proof', async () => {
  vi.mocked(onboarding.getVendorOnboarding).mockResolvedValue(snapshot(['portal.orders', 'portal.fulfillment', 'portal.messages']))
  render(<MemoryRouter initialEntries={['/orders/order-1']}><Routes><Route path="/orders/:orderId" element={<VendorOrderDetailPage />} /><Route path="/fulfillment/:orderId" element={<MessageDestination />} /></Routes></MemoryRouter>)
  expect(await screen.findByText('/fulfillment/order-1')).toBeVisible()
  expect(orders.getOrder).not.toHaveBeenCalled()
})

test('Done dispatches the assigned delivery and a delayed automatic read cannot undo its assignment', async () => {
  const preparing = detail({
    acceptedAt: new Date(), fulfillmentMethod: 'DELIVERY', primaryAction: 'NONE', states: states('PROCESSING'),
    fulfillment: { method: 'DELIVERY', state: 'PROCESSING', late: false, trackingNotice: 'Recorded milestones only.', trips: [], vehicleIssues: [], receipt: { paused: false, windowHours: 48 }, thread: { available: false, readOnly: false }, nextAction: 'DISPATCH',
      steps: [{ key: 'OUT_FOR_DELIVERY', label: 'Out for delivery', status: 'CURRENT', proofRequired: false, proofRequirements: [] }, { key: 'DELIVERED', label: 'Delivered', status: 'UPCOMING', proofRequired: true, proofRequirements: ['DELIVERY_PHOTO', 'RECEIVER_NAME'] }] },
  }, { canAssignFulfillment: true, canRecordMilestone: true })
  const dispatched = detail({ ...preparing, lockVersion: 4, states: states('OUT_FOR_DELIVERY'), fulfillment: { ...preparing.fulfillment!, state: 'OUT_FOR_DELIVERY', nextAction: 'RECORD_DELIVERY',
    assignment: { userId: 12, displayName: 'Delivery Staff', role: 'FULFILLMENT', assignedAt: new Date(), vehicle: { vehicleIndex: 0, name: 'Accepted truck', numberOfVehicles: 1, totalVehicleTrips: 1 } },
    steps: [{ ...preparing.fulfillment!.steps[0]!, status: 'COMPLETE' }, { ...preparing.fulfillment!.steps[1]!, status: 'CURRENT' }] } }, { canAssignFulfillment: true, canRecordMilestone: false })
  let completeRead!: (value: OrderDetail) => void
  const oldRead = new Promise<OrderDetail>(resolve => { completeRead = resolve })
  vi.mocked(orders.getOrder).mockReturnValue(oldRead).mockResolvedValueOnce(preparing)
  vi.mocked(orders.listAssignees).mockResolvedValue([{ userId: 12, displayName: 'Delivery Staff', assigned: false }])
  vi.mocked(orders.listDeliveryVehicles).mockResolvedValue([{ vehicleIndex: 0, vehicleId: 'accepted-truck', name: 'Accepted truck', vehicleType: 'TRUCK', numberOfVehicles: 1, totalVehicleTrips: 1, available: true, unavailableReason: '' }])
  vi.mocked(orders.assignFulfillment).mockResolvedValue(dispatched)
  openDetail()
  await screen.findByRole('heading', { name: 'Confirm delivery assignment' })
  await waitFor(() => expect(screen.getByRole('combobox', { name: 'Fulfillment Staff' })).toHaveValue('12'))
  act(() => window.dispatchEvent(new Event('materyalph:domain-refresh')))
  await waitFor(() => expect(orders.getOrder).toHaveBeenCalledTimes(2))
  fireEvent.click(screen.getByRole('button', { name: 'Done' }))
  await waitFor(() => expect(orders.assignFulfillment).toHaveBeenCalledWith('order-1', 12, 'Confirmed delivery dispatch', { lockVersion: 3, vehicleIndex: 0, dispatch: true }, expect.any(String)))
  expect(await screen.findByText('Delivery Staff')).toBeVisible()
  // A new refresh can share the transport's still-pending read from before dispatch.
  act(() => window.dispatchEvent(new Event('materyalph:domain-refresh')))
  await waitFor(() => expect(orders.getOrder).toHaveBeenCalledTimes(3))
  await act(async () => { completeRead(preparing); await oldRead })
  expect(screen.getByText('Delivery Staff')).toBeVisible()
  expect(screen.getByRole('button', { name: 'Reassign Fulfillment Staff' })).toBeVisible()
  expect(screen.queryByRole('button', { name: 'Out for Delivery' })).not.toBeInTheDocument()
  expect(screen.queryByRole('textbox', { name: /Receiver name/ })).not.toBeInTheDocument()
})

test('staff delivery proof reaches Vendor Order Details after a private invalidation', async () => {
  const current = detail({
    acceptedAt: new Date(), fulfillmentMethod: 'DELIVERY', primaryAction: 'NONE', states: states('OUT_FOR_DELIVERY'),
    fulfillment: { method: 'DELIVERY', state: 'OUT_FOR_DELIVERY', late: false, trackingNotice: 'Recorded milestones only.', trips: [], vehicleIssues: [], receipt: { paused: false, windowHours: 48 }, thread: { available: false, readOnly: false }, nextAction: 'RECORD_DELIVERY',
      assignment: { displayName: 'Delivery Staff', role: 'FULFILLMENT' }, steps: [{ key: 'DELIVERED', label: 'Delivered', status: 'CURRENT', proofRequired: true, proofRequirements: ['DELIVERY_PHOTO', 'RECEIVER_NAME'] }] },
  }, { canAssignFulfillment: false, canRecordMilestone: false })
  vi.mocked(orders.getOrder).mockResolvedValue(current)
  openDetail()
  expect(await screen.findByText(/records Delivered with the receiver/)).toBeVisible()
  expect(screen.queryByRole('textbox', { name: /Receiver name/ })).not.toBeInTheDocument()
  const proof = { milestone: 'DELIVERED' as const, receiverName: 'Site Foreman', handoverConfirmed: true, recordedBy: 'Delivery Staff', photoPath: '/vendor/orders/order-1/files/proof-photo', additionalPhotoPaths: [] }
  vi.mocked(orders.getOrder).mockResolvedValue(detail({ ...current, lockVersion: 4, states: states('DELIVERED'), fulfillment: { ...current.fulfillment!, state: 'DELIVERED', nextAction: 'AWAIT_RECEIPT', proof,
    steps: [{ ...current.fulfillment!.steps[0]!, status: 'COMPLETE', actorRole: 'FULFILLMENT', proof }] } }))
  act(() => window.dispatchEvent(new Event('materyalph:domain-refresh')))
  expect(await screen.findByText('Site Foreman')).toBeVisible()
  expect(screen.getByRole('button', { name: 'View proof photo' })).toBeVisible()
  expect(screen.queryByRole('button', { name: 'Record delivery' })).not.toBeInTheDocument()
})

test('File a case opens a popup over the order and closing restores the trigger focus', async () => {
  vi.mocked(orders.getOrder).mockResolvedValue(detail({ primaryAction: 'NONE' }, { canFileDispute: true }))
  vi.mocked(disputes.getEligibility).mockResolvedValue({ available: false, reason: 'This order is outside the filing window.', caseKind: 'TRANSACTION', issueTypes: [], requestedRemedies: [], lines: [], originalPaymentMethod: { label: 'GCash', physical: false }, refundDestinationNotice: 'Original payment method only.', filingCreatesRefund: false })
  render(<MemoryRouter initialEntries={['/orders/order-1']}><MessageDestination /><Routes><Route path="/orders/:orderId" element={<VendorOrderDetailPage />} /></Routes></MemoryRouter>)
  const trigger = await screen.findByRole('button', { name: 'File a case' })
  expect(disputes.getEligibility).not.toHaveBeenCalled()
  trigger.focus()
  fireEvent.click(trigger)
  const dialog = screen.getByRole('dialog', { name: 'File a case' })
  expect(await within(dialog).findByText('This order is outside the filing window.')).toBeInTheDocument()
  expect(screen.getByRole('region', { name: 'Order information' })).toBeInTheDocument()
  expect(screen.getByText('/orders/order-1')).toBeInTheDocument()
  expect(disputes.getEligibility).toHaveBeenCalledWith('order-1')
  fireEvent.click(within(dialog).getByRole('button', { name: 'Close file a case' }))
  expect(screen.queryByRole('dialog', { name: 'File a case' })).not.toBeInTheDocument()
  expect(trigger).toHaveFocus()
})

test.each([
  ['PICKUP', 'Self-Pickup', 'Ready for pickup'],
  ['DELIVERY', 'Site Delivery', 'Delivery date'],
] as const)('order information preserves document navigation and the full %s calendar date', async (fulfillmentMethod, fulfillmentLabel, dateLabel) => {
  vi.mocked(orders.getOrder).mockResolvedValue(detail({ fulfillmentMethod, expectedFulfillmentDate: new Date(2026, 9, 6), confirmationSource: 'MANUAL', primaryAction: 'NONE' }))
  openDetail()
  const information = await screen.findByRole('region', { name: 'Order information' })
  expect(within(information).getByRole('heading', { name: 'Order information' })).toBeInTheDocument()
  expect(within(information).getByRole('button', { name: 'Export PDF' })).toBeEnabled()
  expect(within(information).getByText('Maria Buyer')).toBeInTheDocument()
  expect(within(information).getByText('Oct 5, 2026, 9:00 AM (Asia/Manila)')).toBeInTheDocument()
  expect(within(information).getByText(fulfillmentLabel)).toBeInTheDocument()
  expect(within(information).getByText('Online payment')).toBeInTheDocument()
  expect(within(information).getByText('Manual confirmation')).toBeInTheDocument()
  expect(within(information).getByText(dateLabel).nextElementSibling).toHaveTextContent('Oct 6, 2026')
})

test('the status-filtered list shows counts, separate payment state and one dominant action per row', async () => {
  vi.mocked(orders.listOrders).mockResolvedValue({ items: [summary(), summary({ id: 'order-2', reference: 'ORD-2026-PAID0000', states: states('AWAITING_PAYMENT', 'PENDING'), primaryAction: 'WAITING_FOR_PAYMENT', confirmationSource: 'AUTO_ACCEPT', nrpcIndicator: true })],
    meta: { group: 'NEW', counts: { ALL: 5, NEW: 2, WAITING_ON_BUYER: 1, AWAITING_PAYMENT: 1, CONFIRMED: 0, CLOSED: 1 }, page: 1, perPage: 20, total: 2, hasMore: false, currentAsOf: new Date() } })
  render(<MemoryRouter initialEntries={['/orders?group=NEW']}><Routes><Route path="/orders" element={<VendorOrdersPage />} /></Routes></MemoryRouter>)
  expect(await screen.findByRole('heading', { name: 'Orders' })).toBeInTheDocument()
  const filters = screen.getByRole('tablist', { name: 'Filter orders by status' })
  expect(await within(filters).findByRole('tab', { name: /New requests\s*2/ })).toHaveAttribute('aria-selected', 'true')
  expect(vi.mocked(orders.listOrders)).toHaveBeenCalledWith({ group: 'NEW', q: '', page: 1 })
  const table = await screen.findByRole('list', { name: 'New requests' })
  expect(within(table).getAllByRole('link', { name: 'Review request' })).toHaveLength(1)
  expect(within(table).getAllByRole('link', { name: 'View order' })).toHaveLength(1)
  expect(within(table).getByText('Payment: Payment due')).toBeInTheDocument()
  expect(within(table).getByText('Includes NRPC')).toBeInTheDocument()
  expect(within(table).getByText('Auto-accepted')).toBeInTheDocument()
})

test('New requests is the default and the order interface has no All section', async () => {
  vi.mocked(orders.listOrders).mockResolvedValue({ items: [summary()], meta: { group: 'NEW', counts: { ALL: 25, NEW: 25, CLOSED: 0 }, page: 1, perPage: 20, total: 25, hasMore: true, currentAsOf: new Date() } })
  render(<MemoryRouter initialEntries={['/orders']}><Routes><Route path="/orders" element={<VendorOrdersPage />} /></Routes></MemoryRouter>)
  await screen.findByRole('list', { name: 'New requests' })
  expect(orders.listOrders).toHaveBeenLastCalledWith({ group: 'NEW', q: '', page: 1 })
  const tabs = screen.getByRole('tablist', { name: 'Filter orders by status' })
  expect(within(tabs).getAllByRole('tab')).toHaveLength(5)
  expect(within(tabs).getAllByRole('tab')[0]).toHaveTextContent('New requests')
  expect(within(tabs).getAllByRole('tab')[0]).toHaveAttribute('aria-selected', 'true')
  expect(within(tabs).queryByRole('tab', { name: /^All/ })).not.toBeInTheDocument()
  expect(screen.queryByRole('combobox', { name: 'Order status' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Next' }))
  await waitFor(() => expect(orders.listOrders).toHaveBeenLastCalledWith({ group: 'NEW', q: '', page: 2 }))
  await waitFor(() => expect(within(tabs).getByRole('tab', { name: /^Closed/ })).not.toBeDisabled())
  fireEvent.click(within(tabs).getByRole('tab', { name: /^Closed/ }))
  await waitFor(() => expect(orders.listOrders).toHaveBeenLastCalledWith({ group: 'CLOSED', q: '', page: 1 }))
  expect(screen.getByRole('combobox', { name: 'Closed status' })).toBeInTheDocument()
})

test('an old All URL falls back to New requests without exposing the removed section', async () => {
  vi.mocked(orders.listOrders).mockResolvedValue({ items: [], meta: { group: 'NEW', counts: { ALL: 1, NEW: 0 }, page: 1, perPage: 20, total: 0, hasMore: false, currentAsOf: new Date() } })
  render(<MemoryRouter initialEntries={['/orders?group=ALL&status_group=CLOSED&closed_state=EXPIRED']}><Routes><Route path="/orders" element={<VendorOrdersPage />} /></Routes></MemoryRouter>)
  expect(await screen.findByText('No new requests yet.')).toBeInTheDocument()
  expect(orders.listOrders).toHaveBeenLastCalledWith({ group: 'NEW', q: '', page: 1 })
  expect(screen.queryByRole('button', { name: 'View all orders' })).not.toBeInTheDocument()
  expect(screen.queryByRole('combobox', { name: 'Order status' })).not.toBeInTheDocument()
  expect(screen.queryByRole('combobox', { name: 'Closed status' })).not.toBeInTheDocument()
})

test('clearing filters from an empty Closed result retains the Closed section', async () => {
  vi.mocked(orders.listOrders).mockResolvedValue({ items: [], meta: { group: 'CLOSED', counts: { ALL: 1, CLOSED: 1 }, page: 1, perPage: 20, total: 0, hasMore: false, currentAsOf: new Date() } })
  render(<MemoryRouter initialEntries={['/orders?group=CLOSED&closed_state=EXPIRED&page=2']}><Routes><Route path="/orders" element={<VendorOrdersPage />} /></Routes></MemoryRouter>)
  expect(await screen.findByText('No expired orders yet.')).toBeInTheDocument()
  expect(orders.listOrders).toHaveBeenLastCalledWith({ group: 'CLOSED', closedState: 'EXPIRED', q: '', page: 2 })
  fireEvent.click(screen.getByRole('button', { name: 'Clear filters' }))
  await waitFor(() => expect(orders.listOrders).toHaveBeenLastCalledWith({ group: 'CLOSED', q: '', page: 1 }))
  expect(screen.getByRole('combobox', { name: 'Closed status' })).toHaveValue('')
  expect(screen.queryByRole('button', { name: 'View all orders' })).not.toBeInTheDocument()
})

test('order dates are inclusive, preserve status and search, and reset pagination only after Apply', async () => {
  HTMLDialogElement.prototype.showModal = function () { this.open = true }
  HTMLDialogElement.prototype.close = function () { this.open = false }
  vi.mocked(orders.listOrders).mockResolvedValue({ items: [], meta: { group: 'CLOSED', counts: { CLOSED: 1 }, page: 2, perPage: 20, total: 0, hasMore: false, currentAsOf: new Date() } })
  render(<MemoryRouter initialEntries={['/orders?group=CLOSED&closed_state=EXPIRED&q=cement&page=2']}><Routes><Route path="/orders" element={<VendorOrdersPage />} /></Routes></MemoryRouter>)
  await waitFor(() => expect(orders.listOrders).toHaveBeenCalled())
  fireEvent.click(screen.getByRole('button', { name: 'All dates' }))
  fireEvent.change(screen.getByLabelText('From'), { target: { value: '2026-10-09' } })
  fireEvent.change(screen.getByLabelText('To'), { target: { value: '2026-10-09' } })
  expect(orders.listOrders).toHaveBeenCalledTimes(1)
  fireEvent.click(screen.getByRole('button', { name: 'Apply' }))
  await waitFor(() => expect(orders.listOrders).toHaveBeenLastCalledWith({ group: 'CLOSED', closedState: 'EXPIRED', q: 'cement', page: 1, from: '2026-10-09', to: '2026-10-09' }))
  fireEvent.click(screen.getByRole('button', { name: /Remove .*2026 filter/ }))
  await waitFor(() => expect(orders.listOrders).toHaveBeenLastCalledWith({ group: 'CLOSED', closedState: 'EXPIRED', q: 'cement', page: 1 }))
})

test('an empty group explains itself instead of showing a false table', async () => {
  vi.mocked(orders.listOrders).mockResolvedValue({ items: [], meta: { group: 'NEW', counts: { ALL: 0, NEW: 0 }, page: 1, perPage: 20, total: 0, hasMore: false, currentAsOf: new Date() } })
  render(<MemoryRouter initialEntries={['/orders?group=NEW']}><Routes><Route path="/orders" element={<VendorOrdersPage />} /></Routes></MemoryRouter>)
  expect(await screen.findByText('No new requests yet.')).toBeInTheDocument()
})

test('order links open a panel, retain the list, and use the existing confirmation workflow', async () => {
  vi.mocked(orders.listOrders).mockResolvedValue({ items: [summary()], meta: { group: 'NEW', counts: { NEW: 1 }, page: 1, perPage: 20, total: 1, hasMore: false, currentAsOf: new Date() } })
  vi.mocked(orders.getOrder).mockResolvedValue(detail())
  vi.mocked(orders.confirmOrder).mockResolvedValue(detail({ states: states('AWAITING_PAYMENT', 'PENDING'), primaryAction: 'WAITING_FOR_PAYMENT' }))
  render(<MemoryRouter initialEntries={['/orders']}><Routes><Route path="/orders" element={<VendorOrdersPage />} /></Routes></MemoryRouter>)
  fireEvent.click(await screen.findByRole('link', { name: 'Review request' }))
  const panel = await screen.findByRole('dialog', { name: 'ORD-2026-ABCDEFGH' })
  expect(await within(panel).findByRole('table', { name: 'Ordered materials and prices' })).toBeInTheDocument()
  expect(screen.getByRole('list', { name: 'New requests' })).toBeInTheDocument()
  expect(within(panel).queryByText('History')).not.toBeInTheDocument()
  expect(within(panel).queryByText('Order documents')).not.toBeInTheDocument()
  expect(within(panel).queryByText('Materials subtotal')).not.toBeInTheDocument()
  expect(within(panel).getByRole('link', { name: 'Open full order' })).toHaveAttribute('href', '/orders/order-1')
  expect(orders.confirmOrder).not.toHaveBeenCalled()
  fireEvent.click(within(panel).getByRole('button', { name: 'Review & confirm order' }))
  const editor = await screen.findByRole('dialog', { name: 'Review and confirm' })
  fireEvent.click(within(editor).getByRole('button', { name: 'Confirm order' }))
  fireEvent.click(within(await screen.findByRole('dialog', { name: 'Reserve stock and confirm?' })).getByRole('button', { name: 'Confirm order' }))
  expect(await within(panel).findByText(/Order confirmed and stock reserved/)).toBeInTheDocument()
  fireEvent.click(within(panel).getByRole('button', { name: 'Close order details' }))
  await waitFor(() => expect(screen.queryByRole('dialog')).not.toBeInTheDocument())
  expect(orders.listOrders).toHaveBeenCalledTimes(3)
})

test('a read-only order panel does not offer confirmation or decline', async () => {
  vi.mocked(orders.listOrders).mockResolvedValue({ items: [summary({ primaryAction: 'NONE' })], meta: { group: 'NEW', counts: { NEW: 1 }, page: 1, perPage: 20, total: 1, hasMore: false, currentAsOf: new Date() } })
  vi.mocked(orders.getOrder).mockResolvedValue(detail({}, { canConfirm: false, canDecline: false }))
  render(<MemoryRouter initialEntries={['/orders']}><Routes><Route path="/orders" element={<VendorOrdersPage />} /></Routes></MemoryRouter>)
  fireEvent.click(await screen.findByRole('link', { name: 'View order' }))
  const panel = await screen.findByRole('dialog')
  expect(await within(panel).findByText('Your role can view this request but cannot confirm it.')).toBeInTheDocument()
  expect(within(panel).queryByRole('button', { name: 'Review & confirm order' })).not.toBeInTheDocument()
  expect(within(panel).queryByRole('button', { name: 'Decline request' })).not.toBeInTheDocument()
})

test('a failed panel request can retry without leaving the order list', async () => {
  vi.mocked(orders.listOrders).mockResolvedValue({ items: [summary()], meta: { group: 'NEW', counts: { NEW: 1 }, page: 1, perPage: 20, total: 1, hasMore: false, currentAsOf: new Date() } })
  vi.mocked(orders.getOrder).mockRejectedValueOnce(new Error('Offline')).mockResolvedValue(detail())
  render(<MemoryRouter initialEntries={['/orders?order=order-1']}><Routes><Route path="/orders" element={<VendorOrdersPage />} /></Routes></MemoryRouter>)
  const panel = await screen.findByRole('dialog')
  fireEvent.click(await within(panel).findByRole('button', { name: /retry|try again/i }))
  expect(await within(panel).findByRole('table', { name: 'Ordered materials and prices' })).toBeInTheDocument()
  expect(orders.getOrder).toHaveBeenCalledTimes(2)
})

test('customer service confirms the request as submitted: quantities are read-only and the pickup date is sent', async () => {
  vi.mocked(orders.getOrder).mockResolvedValue(detail({}, { canRevise: false, canSetNrpc: false, canConfirmDelivery: false }))
  vi.mocked(orders.confirmOrder).mockResolvedValue(detail({ states: states('AWAITING_PAYMENT', 'PENDING'), primaryAction: 'WAITING_FOR_PAYMENT' }))
  openDetail()
  const quantity = await screen.findByLabelText('Confirmed quantity (PC)')
  expect(quantity).toBeDisabled()
  expect(screen.queryByText(/Non-Recoverable Preparation Cost \(optional\)/)).not.toBeInTheDocument()
  expect(screen.getByText(/only the Owner, Store Manager or Store Staff can publish a revision/)).toBeInTheDocument()
  expect(screen.getByText(/The order becomes payable right away with a 24-hour payment window/)).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Confirm order' }))
  const dialog = await screen.findByRole('dialog', { name: 'Reserve stock and confirm?' })
  fireEvent.click(within(dialog).getByRole('button', { name: 'Confirm order' }))
  await waitFor(() => expect(orders.confirmOrder).toHaveBeenCalledTimes(1))
  const [orderId, request] = vi.mocked(orders.confirmOrder).mock.calls[0]!
  expect(orderId).toBe('order-1')
  expect(request).toMatchObject({ lockVersion: 3, lines: [{ orderLineId: 'line-1', confirmedQuantity: '10' }] })
  expect(request).not.toHaveProperty('discount')
  expect(request).not.toHaveProperty('vendorDiscountCentavos')
  expect(request.pickup?.readyDate).toBeInstanceOf(Date)
  expect(request.delivery).toBeUndefined()
  expect(await screen.findByText(/Order confirmed and stock reserved/)).toBeInTheDocument()
})

test('a lower quantity becomes a revision for Buyer approval and a stock conflict names the available quantity without reserving', async () => {
  vi.mocked(orders.getOrder).mockResolvedValue(detail())
  vi.mocked(orders.confirmOrder).mockRejectedValue(failure(409, 'STOCK_INSUFFICIENT', { lines: [{ order_line_id: 'line-1', available_to_sell: '6.0000' }] }))
  openDetail()
  fireEvent.change(await screen.findByLabelText('Confirmed quantity (PC)'), { target: { value: '8' } })
  expect(screen.getByRole('button', { name: 'Send to Buyer for approval' })).toBeInTheDocument()
  expect(screen.getByText(/The Buyer reviews and approves this version within 24 hours/)).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Send to Buyer for approval' }))
  fireEvent.click(within(await screen.findByRole('dialog')).getByRole('button', { name: 'Send to Buyer' }))
  expect(await screen.findByText('Only 6 piece can be reserved now.')).toBeInTheDocument()
  expect(screen.getByText(/Nothing was reserved/)).toBeInTheDocument()
})

test('an NRPC above zero needs a reason before it is sent', async () => {
  vi.mocked(orders.getOrder).mockResolvedValue(detail({ paymentMethod: 'IN_STORE' }))
  openDetail()
  fireEvent.click(await screen.findByRole('checkbox', { name: 'Include NRPC' }))
  fireEvent.change(screen.getByLabelText('Add prepared material'), { target: { value: 'line-1' } })
  fireEvent.change(screen.getByLabelText(/Preparation cost for Hollow block 4"/), { target: { value: '50.00' } })
  expect(screen.getByText('NRPC total')).toHaveTextContent('₱50.00')
  fireEvent.click(screen.getByRole('button', { name: 'Confirm and send NRPC' }))
  expect(await screen.findByText('Describe the irreversible preparation in at least 10 characters.')).toBeInTheDocument()
  expect(orders.confirmOrder).not.toHaveBeenCalled()
})

test('only the Owner or Store Manager can confirm a Site Delivery arrangement', async () => {
  vi.mocked(orders.getOrder).mockResolvedValue(detail({ fulfillmentMethod: 'DELIVERY', destination: { type: 'DELIVERY', intended: { locationId: 'l1', label: 'Project site', kind: 'PROJECT_SITE', formattedAddress: 'Site, QC' }, heavyVehicleRestriction: 'YES', alternateDropOff: { locationId: 'l2', label: 'North gate', kind: 'DELIVERY', formattedAddress: 'Gate, QC' }, vehicleEndpoint: 'ALTERNATE_DROP_OFF', accessInstructions: 'Forklift at the gate' } }, { canConfirmDelivery: false }))
  openDetail()
  expect(await screen.findByText(/Only the Owner or Store Manager can confirm the delivery vehicles, trips and fee/)).toBeInTheDocument()
  expect(screen.getByRole('button', { name: 'Send to Buyer for approval' })).toBeDisabled()
  expect(screen.getByText('Intended destination / Project site')).toBeInTheDocument()
  expect(screen.getByText('Actual vehicle drop-off (heavy-vehicle restriction)')).toBeInTheDocument()
  expect(screen.getByText('North gate')).toBeInTheDocument()
})

test('the countdown shows the exact Manila time and resolves once on expiry', () => {
  vi.useFakeTimers()
  try {
    const onExpire = vi.fn()
    const at = new Date(Date.now() + 2000)
    render(<DeadlineCountdown at={at} label="Payment window" onExpire={onExpire} />)
    expect(screen.getByRole('timer')).toHaveTextContent('00:02')
    expect(screen.getByText(/\(Asia\/Manila\)/)).toBeInTheDocument()
    for (let tick = 0; tick < 3; tick++) act(() => { vi.advanceTimersByTime(1000) })
    expect(screen.getByRole('timer')).toHaveTextContent('Window ended')
    expect(onExpire).toHaveBeenCalledTimes(1)
  } finally { vi.useRealTimers() }
})

test('the money breakdown keeps NRPC inside the subtotal, leaves the fee pending and never shows commission', () => {
  render(<MoneyBreakdown money={{ ...money, nrpc: { amountCentavos: 5000, withinOrderValue: true, status: 'PROPOSED' }, includedVatCentavos: 1929, vatTreatment: 'PRICES_INCLUDE_VAT' }} />)
  expect(screen.getByText('Non-Recoverable Preparation Cost')).toBeInTheDocument()
  expect(screen.getByText('Part of the materials subtotal, not an extra charge')).toBeInTheDocument()
  expect(screen.getByText('Shown at payment')).toBeInTheDocument()
  expect(screen.getByText('Included VAT (already in the subtotal)')).toBeInTheDocument()
  expect(screen.queryByText(/commission|withholding/i)).not.toBeInTheDocument()
})

test('five separate state rows name each area in text', () => {
  render(<OrderStateRows states={states('AWAITING_PAYMENT', 'PENDING')} />)
  const rows = screen.getAllByRole('term')
  expect(rows.map(row => row.textContent)).toEqual(['Order', 'Payment', 'Fulfillment', 'Refund', 'Dispute'])
  expect(screen.getByText('Awaiting payment')).toBeInTheDocument()
  expect(screen.getByText('Payment due')).toBeInTheDocument()
})


test.each(['/orders/order-1', '/orders?order=order-1'])('fulfillment Message badge updates and clears without reloading the order at %s', async entry => {
  vi.mocked(orders.listOrders).mockResolvedValue({ items: [summary()], meta: { group: 'NEW', counts: { NEW: 1 }, page: 1, perPage: 20, total: 1, hasMore: false, currentAsOf: new Date() } })
  vi.mocked(orders.getOrder).mockResolvedValue(detail({
    fulfillment: { method: 'PICKUP', state: 'READY_FOR_PICKUP', late: false, steps: [], trackingNotice: 'Recorded milestones only.', trips: [],
      receipt: { paused: false, windowHours: 48 }, vehicleIssues: [], nextAction: 'NONE',
      thread: { available: true, conversationId: 'fulfillment-1', readOnly: false } },
  }))
  vi.mocked(chatApi.get).mockResolvedValue(fulfillmentUnread(120))
  render(<MemoryRouter initialEntries={[entry]}><Routes><Route path="/orders" element={<VendorOrdersPage />} /><Route path="/orders/:orderId" element={<VendorOrderDetailPage />} /></Routes></MemoryRouter>)
  const button = await screen.findByRole('button', { name: 'Message' })
  await within(button).findByText('99+')
  expect(button).toHaveAccessibleDescription('120 unread fulfillment messages')
  const orderReads = vi.mocked(orders.getOrder).mock.calls.length
  vi.mocked(chatApi.get).mockResolvedValue(fulfillmentUnread(2))
  act(() => window.dispatchEvent(new Event('materyalph:domain-refresh')))
  await within(button).findByText('2')
  vi.mocked(chatApi.get).mockResolvedValue(fulfillmentUnread(0))
  act(() => window.dispatchEvent(new Event('materyalph:navigation-updates')))
  await waitFor(() => expect(button.querySelector('.portal-count-badge')).toBeNull())
  expect(button).toHaveAccessibleDescription('No unread fulfillment messages')
  await waitFor(() => expect(vi.mocked(orders.getOrder).mock.calls.length).toBeGreaterThan(orderReads))
  expect(chatApi.get).toHaveBeenLastCalledWith('fulfillment-1')
  expect(chatApi.forOrder).not.toHaveBeenCalled()
})

function MessageDestination() {
  const location = useLocation()
  return <p>{location.pathname}{location.search}</p>
}

test.each([
  ['/orders/order-1', false], ['/orders/order-1', true],
  ['/orders?order=order-1', false], ['/orders?order=order-1', true],
] as const)('Message opens fulfillment from %s with read-only history %s', async (entry, readOnly) => {
  vi.mocked(orders.listOrders).mockResolvedValue({ items: [summary()], meta: { group: 'NEW', counts: { NEW: 1 }, page: 1, perPage: 20, total: 1, hasMore: false, currentAsOf: new Date() } })
  vi.mocked(orders.getOrder).mockResolvedValue(detail({
    acceptedAt: new Date(), primaryAction: 'NONE', states: states(readOnly ? 'COMPLETED' : 'READY_FOR_PICKUP'),
    fulfillment: {
      method: 'PICKUP', state: 'READY_FOR_PICKUP', late: false, steps: [], trackingNotice: 'Recorded milestones only.', trips: [],
      receipt: { paused: false, windowHours: 48 }, vehicleIssues: [], nextAction: 'NONE',
      thread: { available: true, conversationId: 'fulfillment-1', readOnly },
    },
  }))
  render(<MemoryRouter initialEntries={[entry]}><MessageDestination /><Routes><Route path="/orders" element={<VendorOrdersPage />} /><Route path="/orders/:orderId" element={<VendorOrderDetailPage />} /></Routes></MemoryRouter>)
  await screen.findByRole('button', { name: 'Message' })
  if (entry === '/orders/order-1') {
    const information = screen.getByRole('region', { name: 'Order information' })
    expect(within(information).getByRole('button', { name: 'Message' })).toBeInTheDocument()
    expect(within(information).getByRole('button', { name: 'Export PDF' })).toBeEnabled()
    expect(screen.getAllByRole('button', { name: 'Message' })).toHaveLength(1)
  }
  expect(screen.queryByText('Open Fulfillment Messages')).not.toBeInTheDocument()
  expect(screen.queryByText('· read-only history')).not.toBeInTheDocument()
  fireEvent.click(await screen.findByRole('button', { name: 'Message' }))
  expect(await screen.findByRole('dialog', { name: 'Fulfillment conversations' })).toBeInTheDocument()
  expect(screen.getByText('Thread fulfillment-1')).toBeInTheDocument()
  expect(screen.getByText(entry)).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Close fulfillment popup' }))
  expect(screen.queryByRole('dialog', { name: 'Fulfillment conversations' })).not.toBeInTheDocument()
  expect(screen.getByRole('button', { name: 'Message' })).toBeInTheDocument()
  expect(chatApi.forOrder).not.toHaveBeenCalled()
})

test.each([
  ['AWAITING_VENDOR_CONFIRMATION', 'DELIVERY', 'Awaiting acceptance'],
  ['AWAITING_PAYMENT', 'DELIVERY', 'Awaiting payment'],
  ['PROCESSING', 'DELIVERY', 'Preparing order'],
  ['READY_FOR_PICKUP', 'PICKUP', 'Ready for pickup'],
  ['DELIVERED', 'DELIVERY', 'Delivered · awaiting confirmation'],
] as const)('order progress maps %s honestly', (state, fulfillmentMethod, label) => {
  render(<OrderProgress state={state} fulfillmentMethod={fulfillmentMethod} />)
  const tracker = screen.getByRole('list', { name: 'Order progress' })
  expect(within(tracker).getByText(label).closest('li')).toHaveAttribute('aria-current', 'step')
})

test.each(['CANCELLED', 'DECLINED', 'EXPIRED', 'DISPUTED'])('interrupted %s never implies successful completion', state => {
  render(<OrderProgress state={state} fulfillmentMethod="DELIVERY" />)
  expect(screen.getByText(/Normal progress is interrupted/)).toBeInTheDocument()
  expect(screen.getByRole('list', { name: 'Order progress' }).querySelector('[aria-current]')).toBeNull()
})


test('a completed order marks every progress step complete', () => {
  render(<OrderProgress state="COMPLETED" fulfillmentMethod="DELIVERY" />)
  expect(within(screen.getByRole('list', { name: 'Order progress' })).getAllByText('— complete')).toHaveLength(5)
})

test('Message is unavailable before the fulfillment thread opens', async () => {
  vi.mocked(orders.getOrder).mockResolvedValue(detail())
  openDetail()
  const button = await screen.findByRole('button', { name: 'Message' })
  expect(button).toBeDisabled()
  expect(button).toHaveAccessibleDescription('Fulfillment Messages open when the order is ready for pickup or out for delivery.')
  fireEvent.click(button)
  expect(chatApi.forOrder).not.toHaveBeenCalled()
})


test.each(['AWAITING_PAYMENT', 'COMPLETED', 'CANCELLED'])('compact %s review excludes operational panels', async state => {
  vi.mocked(orders.listOrders).mockResolvedValue({ items: [summary({ primaryAction: 'NONE' })], meta: { group: 'NEW', counts: { NEW: 1 }, page: 1, perPage: 20, total: 1, hasMore: false, currentAsOf: new Date() } })
  vi.mocked(orders.getOrder).mockResolvedValue(detail({ states: states(state, 'PENDING'), primaryAction: 'NONE', expectedFulfillmentDate: new Date(2026, 9, 24), fulfillmentMethod: 'DELIVERY', destination: { type: 'DELIVERY', intended: { locationId: 'site-1', label: 'Project site', kind: 'PROJECT_SITE', formattedAddress: 'Sample delivery address' }, accessInstructions: 'Use the north gate.' } }))
  render(<MemoryRouter initialEntries={['/orders?order=order-1']}><Routes><Route path="/orders" element={<VendorOrdersPage />} /></Routes></MemoryRouter>)
  const panel = await screen.findByRole('dialog')
  expect(await within(panel).findByText('Sample delivery address')).toBeInTheDocument()
  expect(within(panel).getByText('Use the north gate.')).toBeInTheDocument()
  expect(within(panel).getByText('Expected fulfillment').nextElementSibling).toHaveTextContent('Oct 24, 2026')
  expect(within(panel).getByText('Payment due')).toBeInTheDocument()
  expect(within(panel).queryByText('History')).not.toBeInTheDocument()
  expect(within(panel).queryByText('Order documents')).not.toBeInTheDocument()
  expect(within(panel).queryByRole('button', { name: 'Review & confirm order' })).not.toBeInTheDocument()
})


test.each(['ONLINE', 'IN_STORE', 'CASH_ON_DELIVERY'] as const)('NRPC setup follows the order payment method %s', async paymentMethod => {
  vi.mocked(orders.getOrder).mockResolvedValue(detail({ paymentMethod }))
  openDetail()
  await screen.findByRole('region', { name: 'Order information' })
  if (paymentMethod === 'ONLINE') expect(screen.queryByRole('checkbox', { name: 'Include NRPC' })).not.toBeInTheDocument()
  else expect(screen.getByRole('checkbox', { name: 'Include NRPC' })).toBeEnabled()
})
