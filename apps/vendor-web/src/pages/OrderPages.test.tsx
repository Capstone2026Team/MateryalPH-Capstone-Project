import { act, fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import { ResponseError } from '@materyalph/api-client-ts'
import { DeadlineCountdown, MoneyBreakdown, OrderStateRows } from '@materyalph/web-ui'
import * as onboarding from '../lib/onboarding-api'
import * as orders from '../lib/orders-api'
import type { OrderDetail, OrderLine, OrderSummary } from '../lib/orders-api'
import { VendorOrderDetailPage, VendorOrdersPage } from './OrderPages'

vi.mock('../lib/onboarding-api', async original => ({ ...await original<typeof import('../lib/onboarding-api')>(), getVendorOnboarding: vi.fn(), getVendorPrivateFileUrl: vi.fn() }))
vi.mock('../lib/orders-api', async original => ({ ...await original<typeof import('../lib/orders-api')>(), listOrders: vi.fn(), getOrder: vi.fn(), confirmOrder: vi.fn(), declineOrder: vi.fn(), getDeliveryPlan: vi.fn() }))

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

beforeEach(() => {
  vi.clearAllMocks()
  vi.mocked(onboarding.getVendorOnboarding).mockResolvedValue(snapshot(['portal.orders', 'orders.confirm', 'orders.revise']))
  vi.mocked(onboarding.getVendorPrivateFileUrl).mockResolvedValue({ url: 'https://example.test/logo', expiresAt: new Date() })
})

const openDetail = () => render(<MemoryRouter initialEntries={['/orders/order-1']}><Routes><Route path="/orders/:orderId" element={<VendorOrderDetailPage />} /></Routes></MemoryRouter>)

test('the status-filtered list shows counts, separate payment state and one dominant action per row', async () => {
  vi.mocked(orders.listOrders).mockResolvedValue({ items: [summary(), summary({ id: 'order-2', reference: 'ORD-2026-PAID0000', states: states('AWAITING_PAYMENT', 'PENDING'), primaryAction: 'WAITING_FOR_PAYMENT', confirmationSource: 'AUTO_ACCEPT', nrpcIndicator: true })],
    meta: { group: 'NEW', counts: { ALL: 5, NEW: 2, WAITING_ON_BUYER: 1, AWAITING_PAYMENT: 1, CONFIRMED: 0, CLOSED: 1 }, page: 1, perPage: 20, total: 2, hasMore: false, currentAsOf: new Date() } })
  render(<MemoryRouter initialEntries={['/orders']}><Routes><Route path="/orders" element={<VendorOrdersPage />} /></Routes></MemoryRouter>)
  expect(await screen.findByRole('heading', { name: 'Orders' })).toBeInTheDocument()
  const filters = screen.getByRole('group', { name: 'Filter orders by status' })
  expect(await within(filters).findByRole('button', { name: /New requests\s*2/ })).toHaveAttribute('aria-pressed', 'true')
  expect(vi.mocked(orders.listOrders)).toHaveBeenCalledWith({ group: 'NEW', q: '', page: 1 })
  const table = await screen.findByRole('table', { name: 'New requests' })
  expect(within(table).getAllByRole('link', { name: 'Review request' })).toHaveLength(1)
  expect(within(table).getAllByRole('link', { name: 'View order' })).toHaveLength(1)
  expect(within(table).getByText('Payment: Payment due')).toBeInTheDocument()
  expect(within(table).getByText('Includes NRPC')).toBeInTheDocument()
  expect(within(table).getByText('Auto-accepted')).toBeInTheDocument()
})

test('an empty group explains itself instead of showing a false table', async () => {
  vi.mocked(orders.listOrders).mockResolvedValue({ items: [], meta: { group: 'NEW', counts: { ALL: 0, NEW: 0 }, page: 1, perPage: 20, total: 0, hasMore: false, currentAsOf: new Date() } })
  render(<MemoryRouter initialEntries={['/orders']}><Routes><Route path="/orders" element={<VendorOrdersPage />} /></Routes></MemoryRouter>)
  expect(await screen.findByText(/New Item-Based order requests appear here with a 24-hour response window/)).toBeInTheDocument()
})

test('customer service confirms the request as submitted: quantities are read-only and the pickup date is sent', async () => {
  vi.mocked(orders.getOrder).mockResolvedValue(detail({}, { canRevise: false, canSetNrpc: false, canConfirmDelivery: false }))
  vi.mocked(orders.confirmOrder).mockResolvedValue(detail({ states: states('AWAITING_PAYMENT', 'PENDING'), primaryAction: 'WAITING_FOR_PAYMENT' }))
  openDetail()
  const quantity = await screen.findByLabelText('Confirmed quantity (PC)')
  expect(quantity).toBeDisabled()
  expect(screen.queryByText(/Non-Recoverable Preparation Cost \(optional\)/)).not.toBeInTheDocument()
  expect(screen.getByText(/only the Owner, Store Manager or Store Staff can publish a revision/)).toBeInTheDocument()
  expect(screen.getByText(/The order becomes payable right away with a 45-minute payment window/)).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Confirm order' }))
  const dialog = await screen.findByRole('dialog', { name: 'Reserve stock and confirm?' })
  fireEvent.click(within(dialog).getByRole('button', { name: 'Confirm order' }))
  await waitFor(() => expect(orders.confirmOrder).toHaveBeenCalledTimes(1))
  const [orderId, request] = vi.mocked(orders.confirmOrder).mock.calls[0]!
  expect(orderId).toBe('order-1')
  expect(request).toMatchObject({ lockVersion: 3, lines: [{ orderLineId: 'line-1', confirmedQuantity: '10' }], vendorDiscountCentavos: 0 })
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
  vi.mocked(orders.getOrder).mockResolvedValue(detail())
  openDetail()
  fireEvent.click(await screen.findByRole('checkbox', { name: 'Propose an NRPC' }))
  fireEvent.change(screen.getByLabelText('Hollow block 4" — NRPC (₱)'), { target: { value: '50.00' } })
  expect(screen.getByText('NRPC total:').parentElement).toHaveTextContent('₱50.00')
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
