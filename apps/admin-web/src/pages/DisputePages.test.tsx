import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import { ResponseError } from '@materyalph/api-client-ts'
import * as api from '../lib/disputes-api'
import type { DisputeDetail } from '../lib/disputes-api'
import { AdminDisputeCasePage, AdminDisputeQueuePage } from './DisputePages'
import { AdminInvoiceLogPage } from './InvoiceLogPage'

vi.mock('../lib/disputes-api', async original => ({ ...await original<typeof import('../lib/disputes-api')>(), listQueue: vi.fn(), getCase: vi.fn(), assignToMe: vi.fn(), decide: vi.fn(),
  decideAppeal: vi.fn(), requestClarification: vi.fn(), escalateCase: vi.fn(), confirmRemedy: vi.fn(), listInvoiceLog: vi.fn() }))
vi.mock('./PhaseThreeAdminPages', async original => ({ ...await original<typeof import('./PhaseThreeAdminPages')>(), AdminShell: ({ children }: { children: React.ReactNode }) => <main>{children}</main> }))

const now = new Date('2026-10-04T02:00:00Z')
const detail = (overrides: Partial<DisputeDetail> = {}): DisputeDetail => ({
  id: 'case-1', reference: 'CASE-261004-ABC123', orderId: 'order-1', orderReference: 'ORD-2026-AAAA', status: 'ESCALATED_ADMIN_REVIEW', caseKind: 'TRANSACTION', issueType: 'DEFECTIVE',
  requestedRemedy: 'PARTIAL_REFUND', requestedAmountCentavos: 150000, filedByParty: 'BUYER', responsibleParty: 'ADMIN', refundState: 'NONE', remedyState: 'NONE', appealAvailable: false,
  vendorName: 'Test Supply', buyerName: 'Juan D.', assignedToAdmin: true, decisions: [], description: 'Two bags arrived hardened.',
  affectedLines: [{ orderLineId: 'line-1', displayName: 'Portland cement 40 kg', quantity: '10', lineTotalCentavos: 300000, refundableCentavos: 300000 }],
  originalPaymentMethod: { label: 'GCash •••• 1234', notice: 'Any refund returns to this original payment method.' },
  order: { id: 'order-1', reference: 'ORD-2026-AAAA', orderState: 'DISPUTED', disputeState: 'ESCALATED_ADMIN_REVIEW', refundState: 'NONE', paymentMethod: 'EWALLET' },
  deadlines: [], serverTime: now, timezone: 'Asia/Manila', handler: { adminAssigned: true, adminIsMe: true }, lockVersion: 3,
  timeline: [{ id: 'e1', sequence: 1, type: 'CASE_FILED', at: now, actor: { party: 'BUYER', role: 'BUYER', displayName: 'Juan D.' }, body: 'Two bags arrived hardened.', details: {}, evidence: [] }],
  proposals: [], clarifications: [], remedies: [], refunds: [], availableActions: ['DECIDE', 'REQUEST_CLARIFICATION'], limitedView: false,
  admin: { outcomes: ['DISMISSED', 'REPLACEMENT', 'FULL_REFUND', 'PARTIAL_REFUND', 'INCONCLUSIVE'], sanctions: ['WARNING', 'TEMPORARY_RESTRICTION', 'SUSPENSION', 'PERMANENT_BAN'],
    metricEvents: ['VALIDATED_DEFECT_RETURN'], refundable: { onlineCentavos: 300000, cashCentavos: 0 }, alreadyAwardedCentavos: 0, appealReviewerConflict: false, unansweredClarification: false,
    buyer: { displayName: 'Juan D.', priorCases: 0 }, vendor: { displayName: 'Test Supply', priorCases: 2 }, orderTimeline: [], enforcement: [] },
  ...overrides,
}) as DisputeDetail
const at = (path: string) => render(<MemoryRouter initialEntries={[path]}><Routes>
  <Route path="/disputes" element={<AdminDisputeQueuePage />} /><Route path="/disputes/:caseId" element={<AdminDisputeCasePage />} /><Route path="/invoices" element={<AdminInvoiceLogPage />} />
</Routes></MemoryRouter>)

beforeEach(() => { vi.clearAllMocks(); window.scrollTo = vi.fn() as unknown as typeof window.scrollTo })

test('the queue opens on cases needing an Admin and links each case', async () => {
  vi.mocked(api.listQueue).mockResolvedValue({ items: [{ ...detail(), decisions: 0 }], meta: { counts: { NEEDS_ADMIN: 1 } } })
  at('/disputes')
  expect(await screen.findByRole('link', { name: 'CASE-261004-ABC123' })).toHaveAttribute('href', '/disputes/case-1')
  expect(api.listQueue).toHaveBeenCalledWith('NEEDS_ADMIN', 1, { label: 'All dates', from: '', to: '' })
})

test.each(['BUYER', 'VENDOR'] as const)('original complaint clearly attributes the saved description to %s', async filedByParty => {
  const vendorFiled = filedByParty === 'VENDOR'
  const description = 'The agreed materials were not received.\nPlease review the attached details.'
  const complaintDetail = detail({ filedByParty, description,
    issueType: vendorFiled ? 'PICKUP_NO_SHOW' : 'DEFECTIVE', requestedRemedy: vendorFiled ? 'WARNING_ONLY' : 'PARTIAL_REFUND',
    requestedAmountCentavos: 150050 })
  if (vendorFiled) delete complaintDetail.requestedAmountCentavos
  vi.mocked(api.getCase).mockResolvedValue(complaintDetail)
  at('/disputes/case-1')
  const complaint = await screen.findByRole('region', { name: 'Original complaint' })
  expect(within(complaint).getByText(`${vendorFiled ? 'Vendor' : 'Buyer'}'s description of the problem`)).toBeInTheDocument()
  expect(within(complaint).getByText(/The agreed materials/).textContent).toBe(description)
  expect(within(complaint).getByText(vendorFiled ? 'Pickup no-show' : 'Defective or damaged')).toBeInTheDocument()
  expect(within(complaint).getByText(vendorFiled ? 'Warning only' : 'Partial refund · ₱1,500.50')).toBeInTheDocument()
})

test('an absent original description has an explicit empty state', async () => {
  const complaintDetail = detail()
  delete complaintDetail.description
  vi.mocked(api.getCase).mockResolvedValue(complaintDetail)
  at('/disputes/case-1')
  const complaint = await screen.findByRole('region', { name: 'Original complaint' })
  expect(within(complaint).getByText('No problem description was recorded.')).toBeInTheDocument()
})

test('a decision requires the reason, partial amount and conflict check before it is sent once', async () => {
  vi.mocked(api.getCase).mockResolvedValue(detail())
  vi.mocked(api.decide).mockResolvedValue(detail({ status: 'DECIDED', availableActions: [] }))
  at('/disputes/case-1')
  expect(await screen.findByRole('heading', { name: 'Original complaint' })).toBeInTheDocument()
  expect(screen.getByText(/original payment method/)).toBeInTheDocument()
  const form = screen.getByRole('region', { name: 'Decision' })
  fireEvent.click(within(form).getByRole('button', { name: 'Review decision' }))
  expect(within(form).getByText('Enter the awarded amount.')).toBeInTheDocument()
  expect(within(form).getByText(/at least 20 characters/)).toBeInTheDocument()
  expect(within(form).getByText('Confirm the conflict-of-interest check.')).toBeInTheDocument()
  expect(api.decide).not.toHaveBeenCalled()

  fireEvent.change(within(form).getByRole('textbox', { name: /Awarded amount/ }), { target: { value: '1,500.50' } })
  fireEvent.change(within(form).getByRole('textbox', { name: /Reason \(required\)/ }), { target: { value: 'Photos show two hardened bags on delivery.' } })
  fireEvent.click(within(form).getByRole('checkbox', { name: /Conflict check/ }))
  fireEvent.click(within(form).getByRole('button', { name: 'Review decision' }))
  fireEvent.click(within(screen.getByRole('dialog')).getByRole('button', { name: 'Record decision' }))
  await waitFor(() => expect(api.decide).toHaveBeenCalledTimes(1))
  const [caseId, input] = vi.mocked(api.decide).mock.calls[0]!
  expect(caseId).toBe('case-1')
  expect(input).toMatchObject({ outcome: 'PARTIAL_REFUND', amountCentavos: 150050, affectedLineIds: ['line-1'], enforceable: false, conflictCheckConfirmed: true, lockVersion: 3, sanctions: [] })
  expect(await screen.findByText(/appeal window lapses unappealed/)).toBeInTheDocument()
})

test('an unanswered clarification requires an evidence limitation', async () => {
  vi.mocked(api.getCase).mockResolvedValue(detail({ admin: { ...detail().admin!, unansweredClarification: true } }))
  at('/disputes/case-1')
  const form = await screen.findByRole('region', { name: 'Decision' })
  fireEvent.change(within(form).getByRole('combobox', { name: /Remedy/ }), { target: { value: 'DISMISSED' } })
  fireEvent.click(within(form).getByRole('button', { name: 'Review decision' }))
  expect(within(form).getByText(/limits the evidence/)).toBeInTheDocument()
})

test('the original decider is blocked from deciding the appeal', async () => {
  vi.mocked(api.getCase).mockResolvedValue(detail({ status: 'APPEAL_OPEN', availableActions: ['DECIDE_APPEAL'], admin: { ...detail().admin!, appealReviewerConflict: true } }))
  at('/disputes/case-1')
  const form = await screen.findByRole('region', { name: 'Decide the appeal' })
  expect(within(form).getByText(/Another Order and Dispute Staff member/)).toBeInTheDocument()
  expect(within(form).getByRole('button', { name: 'Review appeal decision' })).toBeDisabled()
})

test('a stale or unauthorized case shows the server message with retry', async () => {
  vi.mocked(api.getCase).mockRejectedValue(new ResponseError(new Response(JSON.stringify({ data: null, meta: {}, errors: [{ code: 'PERMISSION_DENIED', message: 'This Admin action is not available to your role.', details: {} }] }),
    { status: 403, headers: { 'Content-Type': 'application/json' } }), 'denied'))
  at('/disputes/case-1')
  expect(await screen.findByText(/not available to your role/)).toBeInTheDocument()
})

test('the invoice log marks Vendor copies and overdue requests without any create action', async () => {
  vi.mocked(api.listInvoiceLog).mockResolvedValue({ items: [{ id: 'r1', orderReference: 'ORD-2026-AAAA', vendorName: 'Test Supply', kind: 'COPY', state: 'REQUESTED', overdue: true, serviceTargetLabel: 'Oct 7, 2026, 5:00 PM' }],
    meta: { counts: { REQUESTS_OPEN: 1, REQUESTS_OVERDUE: 1 }, notice: 'MateryalPH stores Vendor-uploaded copies only.' } } as Awaited<ReturnType<typeof api.listInvoiceLog>>)
  at('/invoices')
  expect(await screen.findByText('Past the service target')).toBeInTheDocument()
  expect(screen.getByText(/1 request\(s\) are past the three-business-day target/)).toBeInTheDocument()
  expect(screen.queryByRole('button', { name: /(create|upload|issue) (a |tax )?invoice/i })).not.toBeInTheDocument()
})
