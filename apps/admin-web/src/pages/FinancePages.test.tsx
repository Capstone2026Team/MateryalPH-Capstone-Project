import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import { ResponseError } from '@materyalph/api-client-ts'
import * as finance from '../lib/finance-api'
import type { FinanceReviewItem, WithholdingAccumulatorDetail } from '../lib/finance-api'
import { AdminAccumulatorPage, AdminFinancePage } from './FinancePages'

vi.mock('../lib/finance-api', async original => ({ ...await original<typeof import('../lib/finance-api')>(), listReviewItems: vi.fn(), resolveReviewItem: vi.fn(), approveFeeCredit: vi.fn(),
  financeKpis: vi.fn(), listPayments: vi.fn(), getAccumulator: vi.fn(), resolveOverlap: vi.fn(), listAccumulators: vi.fn(), listStatements: vi.fn(), approveStatement: vi.fn(), draftStatements: vi.fn(), listChannelFees: vi.fn(), runReconciliation: vi.fn(),
  listTaxAdjustments: vi.fn(), prepareTaxAdjustment: vi.fn(), reviewTaxAdjustment: vi.fn(), postTaxAdjustment: vi.fn() }))
vi.mock('./PhaseThreeAdminPages', async original => ({ ...await original<typeof import('./PhaseThreeAdminPages')>(), AdminShell: ({ children }: { children: React.ReactNode }) => <main>{children}</main> }))

const item = (overrides: Partial<FinanceReviewItem> = {}): FinanceReviewItem => ({ id: 'item-1', kind: 'PAYMENT_MISMATCH', state: 'OPEN', reasonCode: 'AMOUNT_MISMATCH', summary: 'A provider webhook did not match the stored payment attempt; nothing was marked paid.',
  vendor: { id: 'v1', name: 'Test Supply' }, sourceType: 'PAYMENT', sourceId: 'pay-1', expected: { total_centavos: 1026441 }, reported: { amount_centavos: 100 }, createdAt: new Date(), ...overrides })

const page = <T,>(items: T[]) => ({ items, hasMore: false, total: items.length })
const at = (path: string, element: React.ReactNode, pattern = path) => render(<MemoryRouter initialEntries={[path]}><Routes><Route path={pattern} element={element} /></Routes></MemoryRouter>)

beforeEach(() => {
  vi.clearAllMocks()
  vi.mocked(finance.financeKpis).mockResolvedValue({ label: 'Recorded transactions', scenario: 'Earnings and cash use event dates; debt uses issue dates.', period: { from: null, to: null }, commerce: [], finance: [
    { key: 'earned_commission', label: 'Total commission earned', valueCentavos: 20000, definition: 'Earned at completion.' },
    { key: 'refunded_commissions', label: 'Refunded commissions', valueCentavos: 4000, definition: 'Confirmed refunds.' },
    { key: 'net_platform_earnings', label: 'Net platform earnings', valueCentavos: 15000, definition: 'Revenue after credits and processing costs.' },
  ], counts: { draft_statements: 1 }, trendGranularity: 'MONTH', trend: [{ period: new Date(2026, 9, 1), earnedCentavos: 20000, creditsCentavos: 4000, collectedCentavos: 20000, refundedCentavos: 4000, netEarningsCentavos: 15000 }] })
})

test('the default earnings view reports commissions with cards, charts and a table and removes retired controls', async () => {
  at('/finance', <AdminFinancePage />)
  expect(await screen.findByRole('heading', { name: 'Platform earnings analytics' })).toBeInTheDocument()
  expect(await screen.findByRole('table', { name: 'Net platform earnings calculation' })).toBeInTheDocument()
  expect(screen.queryByText(/DEMO — SIMULATED FIGURES/i)).not.toBeInTheDocument()
  expect(screen.getByRole('table', { name: 'Monthly commission activity' })).toBeInTheDocument()
  expect(within(screen.getByRole('table', { name: 'Monthly commission activity' })).getByText('Oct 2026')).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'All dates' }))
  fireEvent.change(screen.getByLabelText('From'), { target: { value: '2026-10-01' } })
  fireEvent.change(screen.getByLabelText('To'), { target: { value: '2026-10-31' } })
  fireEvent.click(screen.getByRole('button', { name: 'Apply' }))
  await waitFor(() => expect(finance.financeKpis).toHaveBeenLastCalledWith('2026-10-01', '2026-10-31'))
})

test('each platform earnings card prints the lines that add up to it and short ranges chart by day', async () => {
  vi.mocked(finance.financeKpis).mockResolvedValue({ label: 'Recorded transactions', scenario: 'Earnings and cash use event dates.', period: { from: null, to: null }, commerce: [], finance: [
    { key: 'earned_commission', label: 'Total commission earned', valueCentavos: 20000, definition: 'Earned at completion.' }, { key: 'fee_credits', label: 'Approved commission credits', valueCentavos: 3000, definition: 'Credits.' },
    { key: 'net_commission', label: 'Net commission earned', valueCentavos: 17000, definition: 'Earnings less credits.' }, { key: 'platform_revenue', label: 'Commission revenue, excluding VAT', valueCentavos: 15000, definition: 'Posted revenue.' },
    { key: 'processing_expense', label: 'Platform processing costs', valueCentavos: 700, definition: 'Costs.' }, { key: 'net_platform_earnings', label: 'Net platform earnings', valueCentavos: 14300, definition: 'Revenue less costs.' },
    { key: 'collected', label: 'Collected commissions', valueCentavos: 9000, definition: 'Collected.' }, { key: 'refunded_commissions', label: 'Refunded commissions', valueCentavos: 1000, definition: 'Refunded.' },
    { key: 'net_collected', label: 'Net collected commissions', valueCentavos: 8000, definition: 'Collected less refunds.' }, { key: 'receivables', label: 'Outstanding receivables', valueCentavos: 6000, definition: 'Owed.' },
    { key: 'overdue', label: 'Overdue receivables', valueCentavos: 2500, definition: 'Past due.' }, { key: 'pending_commissions', label: 'Pending commissions', valueCentavos: 7000, definition: 'Pending.' },
  ], counts: {}, trendGranularity: 'DAY', trend: [
    { period: new Date(2026, 9, 1), earnedCentavos: 20000, creditsCentavos: 3000, collectedCentavos: 0, refundedCentavos: 0, netEarningsCentavos: 14300 },
    { period: new Date(2026, 9, 2), earnedCentavos: 0, creditsCentavos: 0, collectedCentavos: 9000, refundedCentavos: 1000, netEarningsCentavos: 0 }] })
  at('/finance', <AdminFinancePage />)
  const earned = within(await screen.findByRole('table', { name: 'Net commission earned calculation' }))
  expect(earned.getByRole('row', { name: /^Total commission earned/ })).toHaveTextContent('₱200.00')
  expect(earned.getByRole('row', { name: /^Approved commission credits/ })).toHaveTextContent('-₱30.00')
  expect(earned.getByRole('row', { name: /^Net commission earned/ })).toHaveTextContent('₱170.00')
  const net = within(screen.getByRole('table', { name: 'Net platform earnings calculation' }))
  expect(net.getByRole('row', { name: /^Platform processing costs/ })).toHaveTextContent('-₱7.00')
  expect(net.getByRole('row', { name: /^Net platform earnings/ })).toHaveTextContent('₱143.00')
  const collected = within(screen.getByRole('table', { name: 'Net collected commissions calculation' }))
  expect(collected.getByRole('row', { name: /^Refunded commissions/ })).toHaveTextContent('-₱10.00')
  expect(collected.getByRole('row', { name: /^Net collected commissions/ })).toHaveTextContent('₱80.00')
  const owed = within(screen.getByRole('table', { name: 'Outstanding receivables calculation' }))
  expect(owed.getByRole('row', { name: /^Issued, not yet due/ })).toHaveTextContent('₱35.00')
  expect(owed.getByRole('row', { name: /^Overdue/ })).toHaveTextContent('₱25.00')
  expect(owed.getByRole('row', { name: /^Outstanding receivables/ })).toHaveTextContent('₱60.00')
  expect(screen.getByText(/Charted by day · Oct 1 – Oct 2/)).toBeInTheDocument()
  expect(screen.getByRole('table', { name: 'Daily commission activity' })).toBeInTheDocument()
  expect(screen.getByRole('img', { name: /Commission earned, collected, credited and refunded per day/ })).toBeInTheDocument()
})

test('channel fees offer a safe link to the Xendit dashboard in a new tab', async () => {
  vi.mocked(finance.listChannelFees).mockResolvedValue([{ code: 'GCASH', displayName: 'GCash', version: 1, ratePpm: 23000, fixedCentavos: 0, rateIncludesVat: false, feeVatBasisPoints: 1200, refundSupported: true, enabled: true, sourceReference: 'Xendit published rates.' }] as Awaited<ReturnType<typeof finance.listChannelFees>>)
  at('/finance?view=channels', <AdminFinancePage />, '/finance')
  const link = await screen.findByRole('link', { name: /Open Xendit dashboard/ })
  expect(link).toHaveAttribute('href', 'https://dashboard.xendit.co/')
  expect(link).toHaveAttribute('target', '_blank')
  expect(link.getAttribute('rel')).toContain('noopener')
  expect(link.getAttribute('rel')).toContain('noreferrer')
  expect(screen.getByText(/never stores or shows its Xendit credentials/)).toBeInTheDocument()
})

test('overdue debt offers only collectible states and switching to management resets its query', async () => {
  vi.mocked(finance.listStatements).mockResolvedValue(page([]))
  vi.mocked(finance.listReviewItems).mockResolvedValue(page([]))
  at('/finance?view=overdue', <AdminFinancePage />, '/finance')
  await waitFor(() => expect(finance.listStatements).toHaveBeenLastCalledWith(1, undefined, true, { label: 'All dates', from: '', to: '' }))
  expect(screen.queryByRole('button', { name: 'Draft' })).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Settled' })).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Draft last month' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Partially paid' }))
  await waitFor(() => expect(finance.listStatements).toHaveBeenLastCalledWith(1, 'PARTIALLY_PAID', true, { label: 'All dates', from: '', to: '' }))
  fireEvent.click(screen.getByRole('button', { name: 'Commission management' }))
  await waitFor(() => expect(finance.listStatements).toHaveBeenLastCalledWith(1, undefined, false, { label: 'All dates', from: '', to: '' }))
  expect(screen.getByRole('button', { name: 'Settled' })).toBeInTheDocument()
  expect(await screen.findByRole('heading', { name: 'Commission credit approvals' })).toBeInTheDocument()
})

test('the work queue shows the mismatch and requires a reasoned resolution', async () => {
  vi.mocked(finance.listReviewItems).mockResolvedValue(page([item()]))
  vi.mocked(finance.resolveReviewItem).mockResolvedValue()
  at('/finance?view=queue', <AdminFinancePage />, '/finance')
  expect(await screen.findByText('Payment mismatch')).toBeInTheDocument()
  expect(screen.getByText(/nothing was marked paid/)).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Resolve' }))
  expect(await screen.findByText(/at least 10 characters/)).toBeInTheDocument()
  fireEvent.change(screen.getByLabelText('Resolution'), { target: { value: 'Provider confirmed the forged amount; no capture exists.' } })
  fireEvent.click(screen.getByRole('button', { name: 'Resolve' }))
  await waitFor(() => expect(finance.resolveReviewItem).toHaveBeenCalledWith('item-1', 'Provider confirmed the forged amount; no capture exists.'))
})

const adjustment = (overrides: Partial<finance.TaxAdjustment> = {}): finance.TaxAdjustment => ({ id: 'adj-1', kind: 'REFUND_AFTER_ASSESSMENT', state: 'ADJUSTMENT_REQUIRED', environment: 'TEST', openedBy: 'SYSTEM', orderReference: 'ORD-2026-T8PYSAI4',
  vendorName: 'Test Supply', originalRecordType: 'REMITTANCE_ASSESSMENT', originalRecordId: 'rem-1', periodStart: new Date(2026, 9, 1), periodEnd: new Date(2026, 9, 31), amountCentavos: 73272,
  beforeValues: { withheld_centavos: 127 }, afterValues: {}, reason: 'Order was cancelled after this collection was assessed.', allowedActions: ['PREPARE'], ...overrides })

test('tax adjustments are prepared with a reason and then sent for a different reviewer', async () => {
  vi.mocked(finance.listTaxAdjustments).mockResolvedValue(page([adjustment()]))
  vi.mocked(finance.prepareTaxAdjustment).mockResolvedValue(adjustment({ state: 'UNDER_REVIEW', allowedActions: [] }))
  at('/finance?view=adjustments', <AdminFinancePage />, '/finance')
  expect(await screen.findByText('Refund after assessment')).toBeInTheDocument()
  expect(within(screen.getByRole('listitem')).getByText('Needs preparation')).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Prepare correction' }))
  fireEvent.change(screen.getByLabelText('Corrected withholding (₱)'), { target: { value: '0.00' } })
  fireEvent.click(screen.getByRole('button', { name: 'Send for review' }))
  expect(await screen.findByText(/at least 10 characters/)).toBeInTheDocument()
  expect(finance.prepareTaxAdjustment).not.toHaveBeenCalled()
  fireEvent.change(screen.getByLabelText('Reason'), { target: { value: 'Refund confirmed; no withholding applies.' } })
  fireEvent.click(screen.getByRole('button', { name: 'Send for review' }))
  await waitFor(() => expect(finance.prepareTaxAdjustment).toHaveBeenCalledWith('adj-1', 0, 'Refund confirmed; no withholding applies.', 'NONE', ''))
})

test('only a different finance user can review and an approved adjustment is posted', async () => {
  vi.mocked(finance.listTaxAdjustments).mockResolvedValue(page([
    adjustment({ id: 'mine', state: 'UNDER_REVIEW', allowedActions: [], separationNote: 'You prepared this adjustment; a different finance user must review it.' }),
    adjustment({ id: 'theirs', state: 'UNDER_REVIEW', allowedActions: ['APPROVE', 'REJECT'] }),
    adjustment({ id: 'ready', state: 'APPROVED', allowedActions: ['POST'] }),
    adjustment({ id: 'closed', state: 'NOT_REQUIRED', allowedActions: [], afterValues: { note: 'No withholding remains to review.' } }),
  ]))
  vi.mocked(finance.reviewTaxAdjustment).mockResolvedValue(adjustment())
  vi.mocked(finance.postTaxAdjustment).mockResolvedValue(adjustment())
  at('/finance?view=adjustments', <AdminFinancePage />, '/finance')
  expect(await screen.findByText(/You prepared this adjustment/)).toBeInTheDocument()
  expect(screen.getAllByRole('button', { name: 'Review (different user)' })).toHaveLength(1)
  expect(screen.getByText('No withholding remains to review.')).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Post linked entry' }))
  await waitFor(() => expect(finance.postTaxAdjustment).toHaveBeenCalledWith('ready'))
  await waitFor(() => expect(finance.listTaxAdjustments).toHaveBeenCalledTimes(2))
  fireEvent.click(await screen.findByRole('button', { name: 'Review (different user)' }))
  fireEvent.change(await screen.findByLabelText('Decision reason'), { target: { value: 'Evidence is sufficient.' } })
  fireEvent.click(screen.getByRole('button', { name: 'Approve' }))
  await waitFor(() => expect(finance.reviewTaxAdjustment).toHaveBeenCalledWith('theirs', 'APPROVED', 'Evidence is sufficient.'))
})

test('a role without finance.view sees the server explanation instead of data', async () => {
  vi.mocked(finance.listReviewItems).mockRejectedValue(new ResponseError(new Response(JSON.stringify({ data: null, meta: {}, errors: [{ code: 'PERMISSION_DENIED', message: 'This finance action is not available to your Admin role.', details: {} }] }), { status: 403, headers: { 'Content-Type': 'application/json' } }), 'denied'))
  at('/finance?view=queue', <AdminFinancePage />, '/finance')
  expect(await screen.findByText('This finance action is not available to your Admin role.')).toBeInTheDocument()
})

test('applying payment dates resets pagination while retaining status and cancellation leaves the current query intact', async () => {
  vi.mocked(finance.listPayments).mockResolvedValue({ items: [{ id: 'p1', reference: 'PAY-TEST', purpose: 'ORDER', status: 'PAID', total_centavos: 25000, evidence_origin: 'SIMULATED', reconciliation_state: 'RECONCILED', created_at: '2026-10-02T01:00:00Z' }], hasMore: true, total: 70 })
  at('/finance?view=payments', <AdminFinancePage />, '/finance')
  await screen.findByText('PAY-TEST')
  fireEvent.click(screen.getByRole('button', { name: 'Paid' }))
  await waitFor(() => expect(finance.listPayments).toHaveBeenLastCalledWith(1, 'PAID', { label: 'All dates', from: '', to: '' }))
  fireEvent.click(screen.getByRole('button', { name: 'Next' }))
  await waitFor(() => expect(finance.listPayments).toHaveBeenLastCalledWith(2, 'PAID', { label: 'All dates', from: '', to: '' }))
  const calls = vi.mocked(finance.listPayments).mock.calls.length
  fireEvent.click(screen.getByRole('button', { name: 'All dates' }))
  fireEvent.click(screen.getByRole('button', { name: 'Last 7 days' }))
  fireEvent.click(screen.getByRole('button', { name: 'Cancel' }))
  expect(finance.listPayments).toHaveBeenCalledTimes(calls)
  fireEvent.click(screen.getByRole('button', { name: 'All dates' }))
  fireEvent.change(screen.getByLabelText('From'), { target: { value: '2026-10-01' } })
  fireEvent.change(screen.getByLabelText('To'), { target: { value: '2026-10-09' } })
  fireEvent.click(screen.getByRole('button', { name: 'Apply' }))
  await waitFor(() => expect(finance.listPayments).toHaveBeenLastCalledWith(1, 'PAID', { label: 'Custom range', from: '2026-10-01', to: '2026-10-09' }))
  expect(screen.getByText('Page 1 · 70 records')).toBeInTheDocument()
})

const accumulator: WithholdingAccumulatorDetail = {
  id: 'acc-1', vendor: { id: 'v1', name: 'Test Supply' }, environment: 'TEST', taxpayerKeySuffix: 'abc123', taxableYear: 2026, thresholdCentavos: 50000000, gAccumulatedCentavos: 100000,
  gExternalDeclaredCentavos: 30000000, gExternalOverlapCentavos: 0, gEffectiveCentavos: 30100000, remainingAllowanceCentavos: 19900000, externalOverlapState: 'UNRESOLVED', status: 'UNDER_REVIEW',
  statusLabel: 'Under review', reasonCode: 'OVERLAP_UNRESOLVED', breached: false, lockVersion: 2, demo: true,
  taxProfile: { tin_masked: '•••-•••-123', declaration_year: 2026 }, events: [{ from_status: null, to_status: 'UNDER_REVIEW', reason_code: 'OVERLAP_UNRESOLVED', g_before_centavos: 0, g_after_centavos: 30000000, actor_type: 'SYSTEM', occurred_at: '2026-10-02T00:00:00Z' }],
  assessments: [],
} as WithholdingAccumulatorDetail

test('the overlap form validates against the declared total and sends the lock version', async () => {
  vi.mocked(finance.getAccumulator).mockResolvedValue(accumulator)
  vi.mocked(finance.resolveOverlap).mockResolvedValue({ ...accumulator, status: 'RELIEF_ACTIVE', externalOverlapState: 'RESOLVED' })
  at('/finance/accumulators/acc-1', <AdminAccumulatorPage />, '/finance/accumulators/:accumulatorId')
  expect(await screen.findByRole('heading', { name: /Test Supply — taxable year 2026/ })).toBeInTheDocument()
  expect(screen.getAllByText('Under review — standard rate applies').length).toBeGreaterThan(0)
  fireEvent.change(screen.getByLabelText(/Overlap already counted/), { target: { value: '400000' } })
  fireEvent.change(screen.getByLabelText('Evidence basis'), { target: { value: 'Declared total includes MateryalPH remittances.' } })
  fireEvent.click(screen.getByRole('button', { name: 'Record overlap' }))
  expect(await screen.findByText(/cannot exceed the declared/)).toBeInTheDocument()
  fireEvent.change(screen.getByLabelText(/Overlap already counted/), { target: { value: '1,000.00' } })
  fireEvent.click(screen.getByRole('button', { name: 'Record overlap' }))
  await waitFor(() => expect(finance.resolveOverlap).toHaveBeenCalledWith('acc-1', 100000, 2, 'Declared total includes MateryalPH remittances.'))
})
