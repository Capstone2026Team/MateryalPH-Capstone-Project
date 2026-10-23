import { fireEvent, render, screen, waitFor } from '@testing-library/react'
import { MemoryRouter } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import * as finance from '../lib/finance-api'
import * as orders from '../lib/orders-api'
import type { OrderDetail } from '../lib/orders-api'
import { FulfillmentWorkspace } from './OrderFulfillmentPanels'
import { OrderPaymentPanel } from './OrderPaymentPanel'

vi.mock('../lib/finance-api', async original => ({ ...await original<typeof import('../lib/finance-api')>(), confirmHandoverCash: vi.fn() }))
vi.mock('../lib/orders-api', async original => ({ ...await original<typeof import('../lib/orders-api')>(), recordMilestone: vi.fn() }))

type Physical = NonNullable<NonNullable<OrderDetail['payment']>['physical']>

function order(physical: Partial<Physical>, permissions: Partial<NonNullable<OrderDetail['permissions']>>): OrderDetail {
  return {
    id: 'order-1', reference: 'ORD-2026-CASH', paymentMethod: 'IN_STORE', fulfillmentMethod: 'PICKUP', lockVersion: 7,
    states: [{ family: 'ORDER', state: 'READY_FOR_PICKUP' }],
    payment: { available: false, environment: 'TEST', attempts: [], physical: { applicable: true, method: 'IN_STORE', state: 'UNPAID', remainingCentavos: 100000, onlineBalanceApproved: false, records: [], notice: 'Paid directly.', ...physical } },
    fulfillment: { method: 'PICKUP', state: 'READY_FOR_PICKUP', late: false, trackingNotice: 'Recorded milestones only.', trips: [], vehicleIssues: [], receipt: { paused: false, windowHours: 48 }, thread: { available: true, readOnly: false },
      nextAction: 'RECORD_PICKUP', steps: [{ key: 'PICKED_UP', label: 'Picked up', status: 'CURRENT', proofRequired: true, proofRequirements: ['HANDOVER_CONFIRMATION', 'RECEIVER_NAME'] }] },
    permissions: { canRecordMilestone: true, canAssignFulfillment: false, canRecordPhysicalPayment: true, ...permissions },
  } as unknown as OrderDetail
}

beforeEach(() => vi.clearAllMocks())

test('an In-Store handover asks for the cash received, prefilled with the balance, and needs a photo for cash', async () => {
  vi.mocked(orders.recordMilestone).mockResolvedValue(order({}, {}))
  render(<MemoryRouter><FulfillmentWorkspace order={order({}, {})} onChanged={vi.fn()} onReload={vi.fn()} /></MemoryRouter>)
  const cash = screen.getByRole('textbox', { name: /Cash received from the Buyer \(In-Store Payment\)/ })
  expect(cash).toHaveValue('1000.00')
  expect(screen.getByText(/Outstanding ₱1,000.00\. Enter 0 if the Buyer paid nothing\. It is recorded as cash received, with the handover photo as evidence\./)).toBeInTheDocument()
  fireEvent.change(screen.getByRole('textbox', { name: /Collected by/ }), { target: { value: 'Ana Buyer' } })
  fireEvent.click(screen.getByRole('checkbox', { name: /I handed over every line/ }))
  fireEvent.click(screen.getByRole('button', { name: 'Record handover' }))
  expect(await screen.findByText('Add a handover photo as evidence of the cash received.')).toBeInTheDocument()
  fireEvent.change(cash, { target: { value: '1000.01' } })
  fireEvent.click(screen.getByRole('button', { name: 'Record handover' }))
  expect(await screen.findByText('Enter an amount from ₱0.00 to ₱1,000.00.')).toBeInTheDocument()
  expect(orders.recordMilestone).not.toHaveBeenCalled()
  fireEvent.change(cash, { target: { value: '0' } })
  fireEvent.click(screen.getByRole('button', { name: 'Record handover' }))
  await waitFor(() => expect(orders.recordMilestone).toHaveBeenCalledWith('order-1', expect.objectContaining({ milestone: 'PICKED_UP', lockVersion: 7, cashReceivedCentavos: 0 }), expect.any(String)))
})

test('Fulfillment Staff are told the cash they enter waits for confirmation', () => {
  render(<MemoryRouter><FulfillmentWorkspace order={order({}, { canRecordPhysicalPayment: false })} onChanged={vi.fn()} onReload={vi.fn()} /></MemoryRouter>)
  expect(screen.getByText(/The Owner, Store Manager or Store Staff confirms it before it counts as collected\./)).toBeInTheDocument()
})

test('an online order hands over without any cash field', () => {
  const online = { ...order({}, {}), paymentMethod: 'ONLINE' } as OrderDetail
  render(<MemoryRouter><FulfillmentWorkspace order={online} onChanged={vi.fn()} onReload={vi.fn()} /></MemoryRouter>)
  expect(screen.queryByRole('textbox', { name: /Cash received/ })).not.toBeInTheDocument()
})

test('reported handover cash is confirmed with the handover photo by a member who may record cash', async () => {
  vi.mocked(finance.confirmHandoverCash).mockResolvedValue({} as Awaited<ReturnType<typeof finance.confirmHandoverCash>>)
  const onChanged = vi.fn()
  const handoverCash = { reportedCentavos: 2905250, confirmableCentavos: 2905250, milestone: 'DELIVERED' as const, reportedAt: new Date('2026-10-20T06:00:00Z'), hasPhoto: true }
  render(<OrderPaymentPanel order={order({ method: 'CASH_ON_DELIVERY', remainingCentavos: 2905250, handoverCash }, {})} onChanged={onChanged} />)
  expect(screen.getByText(/cash was reported at delivery/)).toHaveTextContent('₱29,052.50')
  fireEvent.click(screen.getByRole('button', { name: 'Confirm ₱29,052.50 received' }))
  await waitFor(() => expect(finance.confirmHandoverCash).toHaveBeenCalledWith('order-1', null, expect.any(String)))
  expect(await screen.findByText('₱29,052.50 recorded as cash received. The Buyer is asked to acknowledge it.')).toBeInTheDocument()
  expect(onChanged).toHaveBeenCalled()
})

test('a handover without a photo needs a receipt, and staff without the cash permission cannot confirm', async () => {
  const handoverCash = { reportedCentavos: 50000, confirmableCentavos: 50000, milestone: 'PICKED_UP' as const, reportedAt: new Date('2026-10-20T06:00:00Z'), hasPhoto: false }
  const view = render(<OrderPaymentPanel order={order({ handoverCash }, {})} onChanged={vi.fn()} />)
  fireEvent.click(screen.getByRole('button', { name: 'Confirm ₱500.00 received' }))
  expect(await screen.findByText(/This handover has no photo\. Attach a receipt/)).toBeInTheDocument()
  expect(finance.confirmHandoverCash).not.toHaveBeenCalled()
  view.unmount()
  render(<OrderPaymentPanel order={order({ handoverCash }, { canRecordPhysicalPayment: false })} onChanged={vi.fn()} />)
  expect(screen.getByText(/The Owner, Store Manager or Store Staff confirms it\./)).toBeInTheDocument()
  expect(screen.queryByRole('button', { name: /Confirm/ })).not.toBeInTheDocument()
})
