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
  vi.mocked(operations.getSummary).mockResolvedValue({ refundsTotal: 5, refundsFailed: 1, refundsPending: 2, reimbursementsTotal: 2, reimbursementsPending: 1, cancellationRequestsOpen: 0, nfrEvents30Days: 3 })
})

test('tab badges include processed refunds and confirmed reimbursements while cards retain exception counts', async () => {
  vi.mocked(operations.getSummary).mockResolvedValue({ refundsTotal: 1, refundsFailed: 0, refundsPending: 0, reimbursementsTotal: 1, reimbursementsPending: 0, cancellationRequestsOpen: 0, nfrEvents30Days: 1 })
  vi.mocked(operations.listRefunds).mockResolvedValue({ items: [refund({ state: 'REFUNDED', displayState: 'PROCESSED', canRetry: false })], hasMore: false })
  at('/order-operations')
  expect(screen.getByRole('heading', { level: 1, name: 'Orders & Refunds Logs' })).toBeInTheDocument()
  expect(screen.getByRole('link', { name: 'Invoice Request Log' })).toHaveAttribute('href', '/invoices')
  expect(await screen.findByRole('tab', { name: 'Refunds 1' })).toBeInTheDocument()
  expect(screen.getByRole('tab', { name: 'Cash reimbursements 1' })).toBeInTheDocument()
  expect(screen.getByText('Failed refunds').closest('div')).toHaveTextContent('Failed refunds0')
  expect(screen.getByText('Refunds awaiting provider').closest('div')).toHaveTextContent('Refunds awaiting provider0')
  expect(screen.getByText('Reimbursements pending').closest('div')).toHaveTextContent('Reimbursements pending0')
  const statuses = within(screen.getByRole('group', { name: 'Refund status' }))
  expect(statuses.getAllByRole('button')).toHaveLength(3)
  expect(statuses.queryByRole('button', { name: 'All' })).not.toBeInTheDocument()
  expect(screen.queryByRole('combobox', { name: 'Status' })).not.toBeInTheDocument()
  fireEvent.click(statuses.getByRole('button', { name: 'Processed' }))
  await waitFor(() => expect(operations.listRefunds).toHaveBeenLastCalledWith(1, 'REFUNDED', { label: 'All dates', from: '', to: '' }))
  expect(statuses.getByRole('button', { name: 'Processed', pressed: true })).toBeInTheDocument()
  fireEvent.click(statuses.getByRole('button', { name: 'Awaiting provider' }))
  await waitFor(() => expect(operations.listRefunds).toHaveBeenLastCalledWith(1, 'REFUND_PENDING', { label: 'All dates', from: '', to: '' }))
  fireEvent.click(screen.getByRole('button', { name: 'Reset filters' }))
  await waitFor(() => expect(operations.listRefunds).toHaveBeenLastCalledWith(1, 'REFUND_FAILED', { label: 'All dates', from: '', to: '' }))
  expect(statuses.getByRole('button', { name: 'Failed', pressed: true })).toBeInTheDocument()
  expect(screen.getByRole('tab', { name: 'Refunds 1' })).toBeInTheDocument()
})

test('refund records keep their amounts, references and states readable without granting unavailable actions', async () => {
  const item = refund({ canRetry: false, statementReference: 'FEE-2026-AAAA', trigger: 'FEE_CREDIT', amountCentavos: 15375 })
  delete item.orderReference
  vi.mocked(operations.listRefunds).mockResolvedValue({ items: [item], hasMore: false })
  at('/order-operations')
  const table = within(await screen.findByRole('table', { name: 'Refund records' }))
  expect(table.getByText('FEE-2026-AAAA')).toBeInTheDocument()
  expect(table.getByText('₱153.75')).toBeInTheDocument()
  expect(table.getByText('Platform fee credit')).toBeInTheDocument()
  expect(table.getByRole('columnheader', { name: 'Requested' })).toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Retry after funding is resolved' })).not.toBeInTheDocument()
})

test('reimbursement log retains recorded methods and distinguishes evidence from confirmation', async () => {
  vi.mocked(operations.listReimbursements).mockResolvedValue([{ id: 'r1', orderReference: 'ORD-2026-CASH', vendorName: 'Test Supply', state: 'VENDOR_REIMBURSEMENT_PENDING', amountCentavos: 400000, method: 'IN_STORE', hasEvidence: true, confirmedByReview: false, canDecide: false }])
  at('/order-operations?view=reimbursements')
  const records = within(await screen.findByRole('table', { name: 'Cash reimbursement records' }))
  expect(records.getByText('In-Store Payment')).toBeInTheDocument()
  expect(records.getByText('₱4,000.00')).toBeInTheDocument()
  expect(records.getByText('Vendor evidence recorded — awaiting confirmation')).toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Confirm with reason' })).not.toBeInTheDocument()
})

test('cancellation logs show server deadlines and automatic finalization without adding cancellation controls', async () => {
  vi.mocked(operations.listCancellationRequests).mockResolvedValue([
    { id: 'request-1', orderReference: 'ORD-2026-CANCEL', vendorName: 'Test Supply', reasonCode: 'CHANGE_OF_PLAN', responseDueAt: new Date('2026-10-27T02:00:00Z'), overdue: true },
    { id: 'request-2', orderReference: 'ORD-2026-WAIT', reasonCode: 'CHANGE_OF_PLAN', overdue: false },
  ])
  at('/order-operations?view=requests')
  const records = within(await screen.findByRole('table', { name: 'Cancellation request records' }))
  expect(records.getByText('Past due — finalizing automatically')).toBeInTheDocument()
  expect(records.getByText('Awaiting Vendor response')).toBeInTheDocument()
  expect(records.getByText(/Oct 27, 2026/)).toHaveTextContent('10:00')
  expect(records.getByText('Not recorded')).toBeInTheDocument()
  expect(records.queryByRole('button')).not.toBeInTheDocument()
})

test('Refresh updates the summary and current list without resetting its filters', async () => {
  vi.mocked(operations.listRefunds).mockResolvedValue({ items: [], hasMore: false })
  at('/order-operations')
  await screen.findByText('No refunds in this status.')
  fireEvent.click(screen.getByRole('button', { name: 'Processed' }))
  await waitFor(() => expect(operations.listRefunds).toHaveBeenLastCalledWith(1, 'REFUNDED', { label: 'All dates', from: '', to: '' }))
  vi.mocked(operations.getSummary).mockResolvedValue({ refundsTotal: 6, refundsFailed: 0, refundsPending: 2, reimbursementsTotal: 2, reimbursementsPending: 1, cancellationRequestsOpen: 0, nfrEvents30Days: 3 })
  vi.mocked(operations.listRefunds).mockResolvedValue({ items: [refund({ state: 'REFUNDED', displayState: 'PROCESSED', canRetry: false })], hasMore: false })
  const callsBefore = vi.mocked(operations.listRefunds).mock.calls.length
  fireEvent.click(screen.getByRole('button', { name: 'Refresh' }))
  expect(await screen.findByRole('tab', { name: 'Refunds 6' })).toBeInTheDocument()
  expect(await within(screen.getByRole('list', { name: 'Refund records' })).findByText('Refund processed by the payment provider')).toBeInTheDocument()
  expect(screen.getByRole('button', { name: 'Processed', pressed: true })).toBeInTheDocument()
  expect(operations.listRefunds).toHaveBeenCalledTimes(callsBefore + 1)
})

test('failed refunds come first with a retry to the original payment that stays pending', async () => {
  vi.mocked(operations.listRefunds).mockResolvedValue({ items: [refund()], hasMore: false })
  vi.mocked(operations.retryRefund).mockResolvedValue()
  at('/order-operations')
  const records = within(await screen.findByRole('list', { name: 'Refund records' }))
  expect(records.getByText('Refund failed — action required')).toBeInTheDocument()
  expect(screen.getByRole('tab', { name: 'Refunds 5' })).toBeInTheDocument()
  expect(records.getByText(/INSUFFICIENT_BALANCE/)).toBeInTheDocument()
  expect(operations.listRefunds).toHaveBeenCalledWith(1, 'REFUND_FAILED', { label: 'All dates', from: '', to: '' })
  fireEvent.click(records.getByRole('button', { name: 'Retry after funding is resolved' }))
  await waitFor(() => expect(operations.retryRefund).toHaveBeenCalledWith('refund-1'))
  expect(await screen.findByText(/stays pending until the provider confirms it/)).toBeInTheDocument()
})

test('a reimbursement decision needs a recorded reason, and a 403 is explained', async () => {
  vi.mocked(operations.listReimbursements).mockResolvedValue([{ id: 'r1', orderReference: 'ORD-2026-BBBB', vendorName: 'Test Supply', state: 'VENDOR_REIMBURSEMENT_PENDING', amountCentavos: 400000,
    method: 'IN_STORE', hasEvidence: true, confirmedByReview: false, canDecide: true }])
  vi.mocked(operations.confirmReimbursement).mockRejectedValue(new ResponseError(new Response(JSON.stringify({ data: null, meta: {}, errors: [{ code: 'PERMISSION_DENIED', message: 'This Admin action is not available to your role.', details: {} }] }),
    { status: 403, headers: { 'Content-Type': 'application/json' } }), 'denied'))
  at('/order-operations?view=reimbursements')
  const records = within(await screen.findByRole('list', { name: 'Cash reimbursement records' }))
  fireEvent.click(records.getByRole('button', { name: 'Confirm with reason' }))
  const dialog = screen.getByRole('dialog')
  fireEvent.click(within(dialog).getByRole('button', { name: 'Confirm reimbursement' }))
  expect(await within(dialog).findByText(/at least 10 characters/)).toBeInTheDocument()
  fireEvent.change(within(dialog).getByRole('textbox', { name: 'Reason' }), { target: { value: 'Reviewed the bank deposit slip from the Vendor.' } })
  fireEvent.click(within(dialog).getByRole('button', { name: 'Confirm reimbursement' }))
  expect(await within(dialog).findByText(/not available to your role/)).toBeInTheDocument()
})
