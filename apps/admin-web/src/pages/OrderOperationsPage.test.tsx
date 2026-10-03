import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import { ResponseError } from '@materyalph/api-client-ts'
import * as operations from '../lib/order-operations-api'
import type { AdminRefundRow } from '../lib/order-operations-api'
import { AdminOrderOperationsPage } from './OrderOperationsPage'

vi.mock('../lib/order-operations-api', async original => ({ ...await original<typeof import('../lib/order-operations-api')>(), getSummary: vi.fn(), listRefunds: vi.fn(), retryRefund: vi.fn(),
  listReimbursements: vi.fn(), confirmReimbursement: vi.fn(), listCancellationRequests: vi.fn() }))
vi.mock('./PhaseThreeAdminPages', async original => ({ ...await original<typeof import('./PhaseThreeAdminPages')>(), AdminShell: ({ children }: { children: React.ReactNode }) => <main>{children}</main> }))

const refund = (overrides: Partial<AdminRefundRow> = {}): AdminRefundRow => ({ id: 'refund-1', targetType: 'ORDER', trigger: 'CANCELLATION', state: 'REFUND_FAILED', displayState: 'FAILED', amountCentavos: 1026441,
  attemptNumber: 1, failureCode: 'INSUFFICIENT_BALANCE', evidenceOrigin: 'SIMULATED', orderReference: 'ORD-2026-AAAA', vendorName: 'Test Supply', requestedAt: new Date('2026-10-02T02:00:00Z'), canRetry: true, ...overrides })
const at = (path: string) => render(<MemoryRouter initialEntries={[path]}><Routes><Route path="/order-operations" element={<AdminOrderOperationsPage />} /></Routes></MemoryRouter>)

beforeEach(() => {
  vi.clearAllMocks()
  vi.mocked(operations.getSummary).mockResolvedValue({ refundsFailed: 1, refundsPending: 2, reimbursementsPending: 1, cancellationRequestsOpen: 0, nfrEvents30Days: 3 })
})

test('failed refunds come first with a retry to the original payment that stays pending', async () => {
  vi.mocked(operations.listRefunds).mockResolvedValue({ items: [refund()], hasMore: false })
  vi.mocked(operations.retryRefund).mockResolvedValue()
  at('/order-operations')
  expect(await screen.findByText('Refund failed — action required')).toBeInTheDocument()
  expect(screen.getByText(/INSUFFICIENT_BALANCE/)).toBeInTheDocument()
  expect(operations.listRefunds).toHaveBeenCalledWith(1, 'REFUND_FAILED')
  fireEvent.click(screen.getByRole('button', { name: 'Retry after funding is resolved' }))
  await waitFor(() => expect(operations.retryRefund).toHaveBeenCalledWith('refund-1'))
  expect(await screen.findByText(/stays pending until the provider confirms it/)).toBeInTheDocument()
})

test('a reimbursement decision needs a recorded reason, and a 403 is explained', async () => {
  vi.mocked(operations.listReimbursements).mockResolvedValue([{ id: 'r1', orderReference: 'ORD-2026-BBBB', vendorName: 'Test Supply', state: 'VENDOR_REIMBURSEMENT_PENDING', amountCentavos: 400000,
    method: 'IN_STORE', hasEvidence: true, confirmedByReview: false, canDecide: true }])
  vi.mocked(operations.confirmReimbursement).mockRejectedValue(new ResponseError(new Response(JSON.stringify({ data: null, meta: {}, errors: [{ code: 'PERMISSION_DENIED', message: 'This Admin action is not available to your role.', details: {} }] }),
    { status: 403, headers: { 'Content-Type': 'application/json' } }), 'denied'))
  at('/order-operations?view=reimbursements')
  fireEvent.click(await screen.findByRole('button', { name: 'Confirm with reason' }))
  const dialog = screen.getByRole('dialog')
  fireEvent.click(within(dialog).getByRole('button', { name: 'Confirm reimbursement' }))
  expect(await within(dialog).findByText(/at least 10 characters/)).toBeInTheDocument()
  fireEvent.change(within(dialog).getByRole('textbox', { name: 'Reason' }), { target: { value: 'Reviewed the bank deposit slip from the Vendor.' } })
  fireEvent.click(within(dialog).getByRole('button', { name: 'Confirm reimbursement' }))
  expect(await within(dialog).findByText(/not available to your role/)).toBeInTheDocument()
})
