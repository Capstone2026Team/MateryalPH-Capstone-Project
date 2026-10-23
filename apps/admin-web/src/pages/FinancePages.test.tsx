import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import { ResponseError } from '@materyalph/api-client-ts'
import { Sparkline } from '@materyalph/web-ui'
import * as finance from '../lib/finance-api'
import type { FinanceReviewItem, WithholdingAccumulatorDetail } from '../lib/finance-api'
import { AdminAccumulatorPage, AdminFinancePage } from './FinancePages'

vi.mock('../lib/finance-api', async original => ({ ...await original<typeof import('../lib/finance-api')>(), listReviewItems: vi.fn(), resolveReviewItem: vi.fn(), approveFeeCredit: vi.fn(),
  financeKpis: vi.fn(), listPayments: vi.fn(), getAccumulator: vi.fn(), resolveOverlap: vi.fn(), listAccumulators: vi.fn(), listStatements: vi.fn(), approveStatement: vi.fn(), draftStatements: vi.fn(), listChannelFees: vi.fn(), runReconciliation: vi.fn(),
  listCommissionPolicies: vi.fn(), publishCommissionPolicy: vi.fn() }))
vi.mock('./PhaseThreeAdminPages', async original => ({ ...await original<typeof import('./PhaseThreeAdminPages')>(), AdminShell: ({ children }: { children: React.ReactNode }) => <main>{children}</main> }))

const item = (overrides: Partial<FinanceReviewItem> = {}): FinanceReviewItem => ({ id: 'item-1', kind: 'PAYMENT_MISMATCH', state: 'OPEN', reasonCode: 'AMOUNT_MISMATCH', summary: 'A provider webhook did not match the stored payment attempt; nothing was marked paid.',
  vendor: { id: 'v1', name: 'Test Supply' }, sourceType: 'PAYMENT', sourceId: 'pay-1', expected: { total_centavos: 1026441 }, reported: { amount_centavos: 100 }, createdAt: new Date(), ...overrides })

const page = <T,>(items: T[]) => ({ items, hasMore: false, total: items.length })
const at = (path: string, element: React.ReactNode, pattern = path) => render(<MemoryRouter initialEntries={[path]}><Routes><Route path={pattern} element={element} /></Routes></MemoryRouter>)

beforeEach(() => {
  vi.clearAllMocks()
  vi.mocked(finance.listCommissionPolicies).mockResolvedValue({ policies: { current: { id: 'policy-1', version: 1, commissionBasisPoints: 200, rateLabel: '2.00%', effectiveFrom: new Date('2026-10-01T00:00:00Z'), status: 'CURRENT' }, latestVersion: 1, canManage: true, versions: [] }, hasMore: false })
  vi.mocked(finance.financeKpis).mockResolvedValue({ label: 'Recorded transactions', scenario: 'Earnings and cash use event dates; debt uses issue dates.', period: { from: null, to: null }, commerce: [], finance: [
    { key: 'earned_commission', label: 'Total commission earned', valueCentavos: 20000, definition: 'Earned at completion.' },
    { key: 'refunded_commissions', label: 'Refunded commissions', valueCentavos: 4000, definition: 'Confirmed refunds.' },
    { key: 'net_platform_earnings', label: 'Net platform earnings', valueCentavos: 15000, definition: 'Revenue after credits and processing costs.' },
  ], counts: { draft_statements: 1 }, trendGranularity: 'MONTH', trend: [{ period: new Date(2026, 9, 1), earnedCentavos: 20000, creditsCentavos: 4000, collectedCentavos: 20000, refundedCentavos: 4000, netEarningsCentavos: 15000, gmvCentavos: 1000000, buyerPaymentsCentavos: 1023000, buyerRefundsCentavos: 0 }] })
})

test('the overview separates platform money from marketplace money with cards, charts and tables', async () => {
  at('/finance', <AdminFinancePage />)
  expect(await screen.findByRole('heading', { name: 'Platform Finance' })).toBeInTheDocument()
  expect(screen.queryByRole('heading', { name: 'Financial overview' })).not.toBeInTheDocument()
  expect(screen.getByRole('heading', { name: 'Platform earnings and funds', level: 2 })).toBeInTheDocument()
  expect(screen.getByRole('tab', { name: 'Overview', selected: true })).toBeInTheDocument()
  expect(await screen.findByRole('heading', { name: 'Marketplace payments' })).toBeInTheDocument()
  expect(screen.queryByText('View breakdown')).not.toBeInTheDocument()
  expect(await screen.findByRole('table', { name: 'Net platform earnings calculation' })).toBeInTheDocument()
  expect(screen.getByRole('table', { name: 'Platform-held funds calculation' })).toBeInTheDocument()
  expect(screen.queryByText(/DEMO — SIMULATED FIGURES/i)).not.toBeInTheDocument()
  expect(screen.queryByText('Platform earnings analytics')).not.toBeInTheDocument()
  expect(screen.getByRole('table', { name: 'Monthly commission activity' })).toBeInTheDocument()
  expect(within(screen.getByRole('table', { name: 'Monthly commission activity' })).getByText('Oct 2026')).toBeInTheDocument()
  expect(within(screen.getByRole('table', { name: 'Monthly marketplace volume' })).getByRole('row', { name: /^Oct 2026/ })).toHaveTextContent('₱10,000.00₱10,230.00₱0.00')
  expect(screen.getByRole('link', { name: /1\s*Draft commission statements/ })).toHaveAttribute('href', '/finance?view=statements')
  expect(screen.queryByText(/Nothing is waiting/)).not.toBeInTheDocument()
  expect(screen.getByText('No Buyer payments in this period.')).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'All dates' }))
  fireEvent.change(screen.getByLabelText('From'), { target: { value: '2026-10-01' } })
  fireEvent.change(screen.getByLabelText('To'), { target: { value: '2026-10-31' } })
  fireEvent.click(screen.getByRole('button', { name: 'Apply' }))
  await waitFor(() => expect(finance.financeKpis).toHaveBeenLastCalledWith('2026-10-01', '2026-10-31'))
})

test('refund-period sparklines keep negative amounts visible inside the chart', () => {
  const { container } = render(<Sparkline values={[-12000, null, 0, 6000]} />)
  const path = container.querySelector('path')?.getAttribute('d') ?? ''
  const heights = [...path.matchAll(/[ML][\d.]+,([\d.-]+)/g)].map(match => Number(match[1]))
  expect(heights).toHaveLength(3)
  expect(heights.every(value => value >= 0 && value <= 32)).toBe(true)
  expect(heights[0]).toBeGreaterThan(heights[1]!)
  expect(heights[1]).toBeGreaterThan(heights[2]!)
})

test('each card prints the lines that add up to it, payment methods are broken down and short ranges chart by day', async () => {
  vi.mocked(finance.financeKpis).mockResolvedValue({ label: 'Recorded transactions', scenario: 'Earnings and cash use event dates.', period: { from: null, to: null }, commerce: [
    { key: 'gross_gmv', label: 'Gross merchandise value', valueCentavos: 3000000, definition: 'Confirmed order value.' }, { key: 'cancelled_gmv', label: 'Cancelled order value', valueCentavos: 500000, definition: 'Cancelled.' },
    { key: 'refunded_gmv', label: 'Refunded order value', valueCentavos: 100000, definition: 'Refunded.' }, { key: 'net_gmv', label: 'Net merchandise value', valueCentavos: 2400000, definition: 'Net.' },
    { key: 'online_payments', label: 'Verified online payments', valueCentavos: 2050000, definition: 'Online.' }, { key: 'buyer_processing_fees', label: 'Buyer processing fees', valueCentavos: 50000, definition: 'Fees.' },
    { key: 'cash_on_delivery', label: 'Cash on Delivery collected', valueCentavos: 600000, definition: 'COD.' }, { key: 'in_store', label: 'In-Store payments collected', valueCentavos: 350000, definition: 'Store.' },
    { key: 'buyer_payments', label: 'Buyer payments received', valueCentavos: 3000000, definition: 'All received.' }, { key: 'cancellation_refunds', label: 'Cancellation refunds', valueCentavos: 200000, definition: 'Cancel.' },
    { key: 'dispute_refunds', label: 'Dispute-conclusion refunds', valueCentavos: 100000, definition: 'Dispute.' }, { key: 'other_refunds', label: 'Other online refunds', valueCentavos: 0, definition: 'Other.' },
    { key: 'cash_reimbursements', label: 'Cash reimbursements', valueCentavos: 50000, definition: 'Cash back.' }, { key: 'buyer_refunds', label: 'Refunds to Buyers', valueCentavos: 350000, definition: 'All refunds.' },
    { key: 'pending_buyer_refunds', label: 'Refunds in progress', valueCentavos: 25000, definition: 'Pending.' }, { key: 'net_buyer_payments', label: 'Net Vendor collections', valueCentavos: 2650000, definition: 'Kept.' },
  ], finance: [
    { key: 'earned_commission', label: 'Total commission earned', valueCentavos: 20000, definition: 'Earned at completion.' }, { key: 'fee_credits', label: 'Approved commission credits', valueCentavos: 3000, definition: 'Credits.' },
    { key: 'net_commission', label: 'Net commission earned', valueCentavos: 17000, definition: 'Earnings less credits.' }, { key: 'platform_revenue', label: 'Commission revenue, excluding VAT', valueCentavos: 15179, definition: 'Posted revenue.' },
    { key: 'fee_vat', label: 'Output VAT on fees', valueCentavos: 1821, definition: 'VAT.' },
    { key: 'processing_expense', label: 'Platform processing costs', valueCentavos: 700, definition: 'Costs.' }, { key: 'net_platform_earnings', label: 'Net platform earnings', valueCentavos: 14479, definition: 'Revenue less costs.' },
    { key: 'collected', label: 'Collected commissions', valueCentavos: 9000, definition: 'Collected.' }, { key: 'refunded_commissions', label: 'Refunded commissions', valueCentavos: 1000, definition: 'Refunded.' },
    { key: 'net_collected', label: 'Net collected commissions', valueCentavos: 8000, definition: 'Collected less refunds.' }, { key: 'receivables', label: 'Outstanding receivables', valueCentavos: 6000, definition: 'Owed.' },
    { key: 'overdue', label: 'Overdue receivables', valueCentavos: 2500, definition: 'Past due.' }, { key: 'pending_commissions', label: 'Pending commissions', valueCentavos: 7000, definition: 'Pending.' },
  ], counts: { confirmed_orders: 3, pending_buyer_refunds: 1 }, paymentMethods: [
    { method: 'GCASH', label: 'GCash', kind: 'ONLINE', payments: 2, amountCentavos: 2050000 },
    { method: 'CASH_ON_DELIVERY', label: 'Cash on Delivery', kind: 'PHYSICAL', payments: 1, amountCentavos: 600000 },
    { method: 'IN_STORE', label: 'In-Store Payment', kind: 'PHYSICAL', payments: 1, amountCentavos: 350000 },
  ], trendGranularity: 'DAY', trend: [
    { period: new Date(2026, 9, 1), earnedCentavos: 20000, creditsCentavos: 3000, collectedCentavos: 0, refundedCentavos: 0, netEarningsCentavos: 14479, gmvCentavos: 3000000, buyerPaymentsCentavos: 2000000, buyerRefundsCentavos: 0 },
    { period: new Date(2026, 9, 2), earnedCentavos: 0, creditsCentavos: 0, collectedCentavos: 9000, refundedCentavos: 1000, netEarningsCentavos: 0, gmvCentavos: 0, buyerPaymentsCentavos: 1000000, buyerRefundsCentavos: 350000 }] })
  at('/finance', <AdminFinancePage />)
  const earned = within(await screen.findByRole('table', { name: 'Net commission earned calculation' }))
  expect(earned.getByRole('row', { name: /^Commission earned at completion/ })).toHaveTextContent('₱200.00')
  expect(earned.getByRole('row', { name: /^Approved commission credits/ })).toHaveTextContent('-₱30.00')
  expect(earned.getByRole('row', { name: /^Net commission earned/ })).toHaveTextContent('₱170.00')
  const net = within(screen.getByRole('table', { name: 'Net platform earnings calculation' }))
  expect(net.getByRole('row', { name: /^Net commission earned/ })).toHaveTextContent('₱170.00')
  expect(net.getByRole('row', { name: /^Output VAT on fees/ })).toHaveTextContent('-₱18.21')
  expect(net.getByRole('row', { name: /^Commission revenue, excluding VAT/ })).toHaveTextContent('₱151.79')
  expect(net.getByRole('row', { name: /^Platform processing costs/ })).toHaveTextContent('-₱7.00')
  expect(net.getByRole('row', { name: /^Net platform earnings/ })).toHaveTextContent('₱144.79')
  const held = within(screen.getByRole('table', { name: 'Platform-held funds calculation' }))
  expect(held.getByRole('row', { name: /^Commission refunds to Vendors/ })).toHaveTextContent('-₱10.00')
  expect(held.getByRole('row', { name: /^Platform-held funds/ })).toHaveTextContent('₱80.00')
  const gmv = within(screen.getByRole('table', { name: 'Gross merchandise value calculation' }))
  expect(gmv.getByRole('row', { name: /^Cancelled order value/ })).toHaveTextContent('-₱5,000.00')
  expect(gmv.getByRole('row', { name: /^Net merchandise value/ })).toHaveTextContent('₱24,000.00')
  const received = within(screen.getByRole('table', { name: 'Buyer payments received calculation' }))
  expect(received.getByRole('row', { name: /^Cash on Delivery collected/ })).toHaveTextContent('₱6,000.00')
  expect(received.getByRole('row', { name: /^Buyer payments received/ })).toHaveTextContent('₱30,000.00')
  const refunds = within(screen.getByRole('table', { name: 'Refunds to Buyers calculation' }))
  expect(refunds.queryByRole('row', { name: /^Other online refunds/ })).not.toBeInTheDocument()
  expect(refunds.getByRole('row', { name: /^Refunds to Buyers/ })).toHaveTextContent('₱3,500.00')
  expect(within(screen.getByRole('table', { name: 'Net Vendor collections calculation' })).getByRole('row', { name: /^Net Vendor collections/ })).toHaveTextContent('₱26,500.00')
  expect(screen.getByText(/₱250.00 more in 1 refund still in progress/)).toBeInTheDocument()
  expect(screen.getByText(/3 confirmed orders, by confirmation date/)).toBeInTheDocument()
  const methods = within(screen.getByRole('list', { name: 'Buyer payments per method' }))
  expect(methods.getAllByRole('listitem').map(row => row.textContent)).toEqual([
    'GCash₱20,500.002 payments · 68.3%', 'Cash on Delivery₱6,000.001 cash record · 20.0%', 'In-Store Payment₱3,500.001 cash record · 11.7%'])
  expect(screen.getByRole('table', { name: 'Daily marketplace volume' })).toBeInTheDocument()
  expect(screen.getByRole('img', { name: /Gross merchandise value, Buyer payments and refunds per day/ })).toBeInTheDocument()
  const owed = within(screen.getByRole('table', { name: 'Outstanding receivables calculation' }))
  expect(owed.getByRole('row', { name: /^Issued, not yet due/ })).toHaveTextContent('₱35.00')
  expect(owed.getByRole('row', { name: /^Overdue/ })).toHaveTextContent('₱25.00')
  expect(owed.getByRole('row', { name: /^Outstanding receivables/ })).toHaveTextContent('₱60.00')
  fireEvent.click(screen.getByText('What every figure means'))
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

test('publishing a commission percentage sends basis points, the reviewed version and one request key', async () => {
  vi.mocked(finance.listStatements).mockResolvedValue(page([]))
  vi.mocked(finance.listReviewItems).mockResolvedValue(page([]))
  vi.mocked(finance.publishCommissionPolicy).mockResolvedValue({ id: 'policy-2', version: 2, commissionBasisPoints: 325, rateLabel: '3.25%', effectiveFrom: new Date(), status: 'CURRENT' })
  at('/finance?view=statements', <AdminFinancePage />, '/finance')
  fireEvent.click(await screen.findByRole('button', { name: 'Edit rate' }))
  fireEvent.change(screen.getByLabelText('Commission percentage (%)'), { target: { value: '3.25' } })
  expect(screen.getByText('₱325.00')).toBeInTheDocument()
  fireEvent.change(screen.getByLabelText(/^Reason/), { target: { value: 'Approved commercial rate review' } })
  fireEvent.click(screen.getByRole('button', { name: 'Publish new rate' }))
  await waitFor(() => expect(finance.publishCommissionPolicy).toHaveBeenCalledWith({ commissionBasisPoints: 325, expectedVersion: 1, effectiveFrom: null, reason: 'Approved commercial rate review' }, expect.stringMatching(/^[0-9a-f-]{36}$/)))
  expect(await screen.findByText(/Commission policy published/)).toBeInTheDocument()
})

test('read-only commission access shows the rate without publishing controls', async () => {
  const policies = await finance.listCommissionPolicies()
  vi.mocked(finance.listCommissionPolicies).mockResolvedValue({ ...policies, policies: { ...policies.policies, canManage: false } })
  vi.mocked(finance.listStatements).mockResolvedValue(page([]))
  vi.mocked(finance.listReviewItems).mockResolvedValue(page([]))
  at('/finance?view=statements', <AdminFinancePage />, '/finance')
  expect(await screen.findByText('2.00%')).toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Edit rate' })).not.toBeInTheDocument()
  expect(screen.getByRole('button', { name: 'View history' })).toBeInTheDocument()
})

test('overdue debt offers only collectible states and switching to management resets its query', async () => {
  vi.mocked(finance.listStatements).mockResolvedValue(page([]))
  vi.mocked(finance.listReviewItems).mockResolvedValue(page([]))
  at('/finance?view=overdue', <AdminFinancePage />, '/finance')
  await waitFor(() => expect(finance.listStatements).toHaveBeenLastCalledWith(1, undefined, true, { label: 'All dates', from: '', to: '' }))
  expect(await screen.findByText('No overdue commission balances match these filters.')).toBeInTheDocument()
  expect(screen.queryByText('Billing schedule and due dates')).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Draft' })).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Settled' })).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Draft last month' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Partially paid' }))
  await waitFor(() => expect(finance.listStatements).toHaveBeenLastCalledWith(1, 'PARTIALLY_PAID', true, { label: 'All dates', from: '', to: '' }))
  fireEvent.click(screen.getByRole('tab', { name: 'Commission management' }))
  await waitFor(() => expect(finance.listStatements).toHaveBeenLastCalledWith(1, undefined, false, { label: 'All dates', from: '', to: '' }))
  expect(screen.getByRole('button', { name: 'Settled' })).toBeInTheDocument()
  expect(screen.getByText('Billing schedule and due dates')).toBeInTheDocument()
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

test('Tax adjustments is no longer a finance view; an old link opens the Platform Finance overview', async () => {
  vi.mocked(finance.financeKpis).mockResolvedValue({ label: 'Recorded transactions', scenario: 'Event dates.', period: { from: null, to: null }, commerce: [], finance: [], counts: {}, trendGranularity: 'DAY', trend: [] })
  at('/finance?view=adjustments', <AdminFinancePage />, '/finance')
  expect(await screen.findByRole('heading', { name: 'Platform Finance' })).toBeInTheDocument()
  expect(await screen.findByText('No financial activity is recorded for these dates.')).toBeInTheDocument()
  expect(screen.queryByRole('heading', { name: 'Finance actions' })).not.toBeInTheDocument()
  expect(screen.queryByRole('heading', { name: 'Tax adjustments' })).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: /Tax adjustments/ })).not.toBeInTheDocument()
})

test('a role without finance.view sees the server explanation instead of data', async () => {
  vi.mocked(finance.listReviewItems).mockRejectedValue(new ResponseError(new Response(JSON.stringify({ data: null, meta: {}, errors: [{ code: 'PERMISSION_DENIED', message: 'This finance action is not available to your Admin role.', details: {} }] }), { status: 403, headers: { 'Content-Type': 'application/json' } }), 'denied'))
  at('/finance?view=queue', <AdminFinancePage />, '/finance')
  expect(await screen.findByText('This finance action is not available to your Admin role.')).toBeInTheDocument()
})

test('applying payment dates resets pagination while retaining status and cancellation leaves the current query intact', async () => {
  vi.mocked(finance.listPayments).mockResolvedValue({ items: [{ id: 'p1', reference: 'PAY-TEST', vendor_name: 'Test Supply', purpose: 'FULL_ORDER_PAYMENT', account_scope: 'VENDOR_SUB_ACCOUNT', channel_name: 'GCash', status: 'PAID', total_centavos: 25000, evidence_origin: 'SIMULATED', reconciliation_state: 'RECONCILED', created_at: '2026-10-02T01:00:00Z' },
    { id: 'p2', reference: 'FS-2026-10', vendor_name: 'Test Supply', purpose: 'PLATFORM_FEE_PAYMENT', account_scope: 'PLATFORM_ACCOUNT', channel_name: 'Maya', status: 'PAID', total_centavos: 2000, evidence_origin: 'XENDIT_TEST', reconciliation_state: 'NOT_REQUIRED', created_at: '2026-10-03T01:00:00Z' }], hasMore: true, total: 70 })
  at('/finance?view=payments', <AdminFinancePage />, '/finance')
  await screen.findByText('PAY-TEST')
  const rows = screen.getAllByRole('row')
  expect(rows[1]).toHaveTextContent(/Order payment\s*To Vendor account/)
  expect(rows[1]).toHaveTextContent('GCash')
  expect(rows[1]).toHaveTextContent('Simulated')
  expect(rows[2]).toHaveTextContent(/Commission payment\s*To platform account/)
  expect(rows[2]).toHaveTextContent('Xendit TEST')
  fireEvent.change(screen.getByRole('combobox', { name: 'Payment purpose' }), { target: { value: 'PLATFORM_FEE_PAYMENT' } })
  await waitFor(() => expect(finance.listPayments).toHaveBeenLastCalledWith(1, undefined, { label: 'All dates', from: '', to: '' }, 'PLATFORM_FEE_PAYMENT'))
  fireEvent.change(screen.getByRole('combobox', { name: 'Payment purpose' }), { target: { value: '' } })
  fireEvent.change(screen.getByRole('combobox', { name: 'Payment status' }), { target: { value: 'PAID' } })
  await waitFor(() => expect(finance.listPayments).toHaveBeenLastCalledWith(1, 'PAID', { label: 'All dates', from: '', to: '' }, undefined))
  fireEvent.click(screen.getByRole('button', { name: 'Next' }))
  await waitFor(() => expect(finance.listPayments).toHaveBeenLastCalledWith(2, 'PAID', { label: 'All dates', from: '', to: '' }, undefined))
  const calls = vi.mocked(finance.listPayments).mock.calls.length
  fireEvent.click(screen.getByRole('button', { name: 'All dates' }))
  fireEvent.click(screen.getByRole('button', { name: 'Last 7 days' }))
  fireEvent.click(screen.getByRole('button', { name: 'Cancel' }))
  expect(finance.listPayments).toHaveBeenCalledTimes(calls)
  fireEvent.click(screen.getByRole('button', { name: 'All dates' }))
  fireEvent.change(screen.getByLabelText('From'), { target: { value: '2026-10-01' } })
  fireEvent.change(screen.getByLabelText('To'), { target: { value: '2026-10-09' } })
  fireEvent.click(screen.getByRole('button', { name: 'Apply' }))
  await waitFor(() => expect(finance.listPayments).toHaveBeenLastCalledWith(1, 'PAID', { label: 'Custom range', from: '2026-10-01', to: '2026-10-09' }, undefined))
  expect(screen.getByText('Page 1 · 70 records')).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Reset filters' }))
  await waitFor(() => expect(finance.listPayments).toHaveBeenLastCalledWith(1, undefined, { label: 'All dates', from: '', to: '' }, undefined))
  expect(screen.getByRole('combobox', { name: 'Payment status' })).toHaveValue('')
  expect(screen.getByRole('combobox', { name: 'Payment purpose' })).toHaveValue('')
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
