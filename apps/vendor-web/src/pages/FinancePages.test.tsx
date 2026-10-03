import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import { ThresholdPanel, WithholdingStatusBadge } from '@materyalph/web-ui'
import * as onboarding from '../lib/onboarding-api'
import * as finance from '../lib/finance-api'
import type { FeeStatementDetail, VendorFinanceOverview } from '../lib/finance-api'
import { VendorEarningsPage, VendorFinancePage, VendorStatementPage, VendorTransactionHistoryPage } from './FinancePages'

vi.mock('../lib/onboarding-api', async original => ({ ...await original<typeof import('../lib/onboarding-api')>(), getVendorOnboarding: vi.fn(), getVendorPrivateFileUrl: vi.fn() }))
vi.mock('../lib/finance-api', async original => ({ ...await original<typeof import('../lib/finance-api')>(), getFinanceOverview: vi.fn(), updatePhysicalPayments: vi.fn(), listTransactions: vi.fn(),
  getStatement: vi.fn(), payStatement: vi.fn(), refreshFeePayment: vi.fn(), getEarnings: vi.fn(), exportTransactions: vi.fn() }))

function snapshot(permissions: string[]): Awaited<ReturnType<typeof onboarding.getVendorOnboarding>> {
  return ({ stepCompletion: [], lockVersion: 1, requirements: [], drafts: [], organization: { store_name: 'Test Supply' }, welcomeRequired: false, permissions, verification: {}, setup: { status: 'COMPLETED' }, activation: { status: 'ACTIVE', readiness: { ready: true, blockers: [], status: 'READY', ruleVersion: 'test' } }, sections: {} }) as unknown as Awaited<ReturnType<typeof onboarding.getVendorOnboarding>>
}

const threshold = {
  demo: true, taxableYear: 2026, yearStartAt: new Date('2025-12-31T16:00:00Z'), yearEndAt: new Date('2026-12-31T16:00:00Z'), thresholdCentavos: 50000000, cumulativeGrossCentavos: 50100000,
  remainingAllowanceCentavos: 0, localGrossCentavos: 50100000, externalDeclaredCentavos: 0, externalOverlapCentavos: 0, externalOverlapState: 'NONE' as const, percentOfThreshold: 100, advisory: false,
  status: 'SUBJECT_THRESHOLD_BREACHED' as const, statusLabel: 'Subject to withholding — threshold crossed', statusIcon: 'alert-octagon', reasonCode: 'THRESHOLD_CROSSED',
  crossedAt: new Date('2026-10-02T02:30:00Z'), crossedAtManila: 'October 2, 2026 10:30 AM (Asia/Manila)', priorYearTotalCentavos: null,
  finalForYearNotice: 'Crossing ₱500,000.00 is final for the taxable year.', events: [],
}

function overview(overrides: Partial<VendorFinanceOverview> = {}): VendorFinanceOverview {
  return {
    demoLabel: 'DEMO — simulated tax and settlement figures.',
    xenditConnection: { status: 'CONNECTED_TEST', label: 'Connected — TEST', environment: 'TEST', account_contract: 'XENDIT_ACCOUNTS_V2', payment_api: 'XENDIT_PAYMENT_SESSIONS', production_capability: false, note: 'Reused TEST sub-account.' },
    taxProfile: { available: true, tin_masked: '•••-•••-123 (masked)', vat_category: 'NON_VAT', fiscal_year_start_month: 1, relief_claimed: true, declaration: { status: 'APPROVED', taxable_year: 2026 } },
    withholdingArrangement: { scenario: 'DEMO_PLATFORM_WITHHOLDER', label: 'DEMO platform-withholder scenario (simulated)', production_assignment: 'UNCONFIRMED', production_assignment_label: 'Production assignment unconfirmed', rate_label: '0.5% of qualifying gross remittance' },
    threshold, commissionTerms: { accepted: true, version: 1, accepted_at: '2026-09-20T00:00:00Z', rate_label: '2% of completed materials', note: 'Accepted once in Store Verification.' },
    onlineChannels: { provider_ready: true, channels: [
      { code: 'GCASH', display_name: 'GCash', kind: 'EWALLET', available: true, unavailable_reason: null, refund_supported: true, rate_label: '2.3% + 12% VAT on the fee', fee_version: 1 },
      { code: 'QRPH', display_name: 'QR Ph', kind: 'QR', available: false, unavailable_reason: 'REFUND_ROUTE_UNAVAILABLE', refund_supported: false, rate_label: '0%', fee_version: 1 },
    ] },
    physicalPayments: { cod_enabled: false, in_store_enabled: false, lock_version: 0, cod_note: 'Site Delivery only.', in_store_note: 'Self-Pickup only.' },
    refundCapability: { status: 'AVAILABLE_TEST', refund_channels: ['GCash'], note: 'Refunds go to the original payment method.' },
    statements: { outstanding_centavos: 0, next_due_on: null },
    notices: [{ id: 'n1', mandatory: true, title: 'Withholding status changed: SUBJECT THRESHOLD BREACHED', body: 'Crossing is final for the year.', createdAt: new Date(), read: false }],
    ...overrides,
  } as VendorFinanceOverview
}

const at = (path: string, element: React.ReactNode, pattern = path) => render(<MemoryRouter initialEntries={[path]}><Routes><Route path={pattern} element={element} /><Route path="/orders" element={<p>Orders page</p>} /></Routes></MemoryRouter>)

beforeEach(() => {
  vi.clearAllMocks()
  vi.mocked(onboarding.getVendorOnboarding).mockResolvedValue(snapshot(['portal.orders', 'portal.wallet', 'portal.earnings', 'finance.view', 'finance.pay', 'payments.configure']))
  vi.mocked(onboarding.getVendorPrivateFileUrl).mockResolvedValue({ url: 'https://example.test/logo', expiresAt: new Date() })
})

test('overview shows separate sections, the unconfirmed production assignment and a crossed threshold with Manila time', async () => {
  vi.mocked(finance.getFinanceOverview).mockResolvedValue(overview())
  at('/finance', <VendorFinancePage />)
  expect(await screen.findByRole('heading', { name: 'Finance overview', level: 1 })).toBeInTheDocument()
  for (const name of ['Xendit connection', 'Vendor Tax Profile summary', 'Withholding arrangement', 'Commission Terms', 'Online payment channels', 'Physical payments', 'Refund capability']) {
    expect(screen.getByRole('heading', { name, level: 2 })).toBeInTheDocument()
  }
  expect(screen.getByText('Connected — TEST')).toBeInTheDocument()
  expect(screen.getByText('Production assignment unconfirmed')).toBeInTheDocument()
  expect(screen.getAllByText(/Subject to withholding — threshold crossed/).length).toBeGreaterThan(0)
  expect(screen.getByText(/Threshold crossed on .* \(Asia\/Manila\)/)).toBeInTheDocument()
  expect(screen.getAllByText(/DEMO/).length).toBeGreaterThan(1)
  expect(screen.getByText('Not offered: no approved refund route')).toBeInTheDocument()
  expect(screen.getByText(/Cannot be turned off/)).toBeInTheDocument()
})

test('owner saves physical payment options with optimistic locking', async () => {
  vi.mocked(finance.getFinanceOverview).mockResolvedValue(overview())
  vi.mocked(finance.updatePhysicalPayments).mockResolvedValue({ codEnabled: false, inStoreEnabled: true, lockVersion: 1 })
  at('/finance', <VendorFinancePage />)
  const save = await screen.findByRole('button', { name: 'Save physical payment options' })
  expect(save).toBeDisabled()
  fireEvent.click(screen.getByLabelText(/Accept In-Store Payment/))
  fireEvent.click(save)
  await waitFor(() => expect(finance.updatePhysicalPayments).toHaveBeenCalledWith(0, false, true))
  expect(await screen.findByText(/applies to new orders only/)).toBeInTheDocument()
})

test('a manager without the finance module sees an owner-only explanation, not finance data', async () => {
  vi.mocked(onboarding.getVendorOnboarding).mockResolvedValue(snapshot(['portal.orders', 'orders.confirm']))
  at('/finance', <VendorFinancePage />)
  expect(await screen.findByRole('heading', { name: 'Store-wide finance is Owner-only' })).toBeInTheDocument()
  expect(finance.getFinanceOverview).not.toHaveBeenCalled()
})

test('transaction history switches tabs, shows a specific empty state and never a balance', async () => {
  vi.mocked(finance.listTransactions).mockImplementation(async tab => tab === 'PAYMENTS'
    ? { items: [{ id: 'p1', reference: 'ORD-1', purpose: 'FULL_ORDER_PAYMENT', status: 'PAID', gross_centavos: 1026441, buyer_processing_fee_centavos: 26441, evidence_origin: 'SIMULATED', at: '2026-10-02T02:30:00Z' }], hasMore: false, total: 1 }
    : { items: [], hasMore: false, total: 0 })
  at('/finance/transactions', <VendorTransactionHistoryPage />)
  const table = await screen.findByRole('table')
  expect(within(table).getByText('Paid — verified by provider')).toBeInTheDocument()
  expect(within(table).getByText('₱10,264.41')).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: /Physical receipts/ }))
  expect(await screen.findByText(/No Cash on Delivery or In-Store records yet/)).toBeInTheDocument()
  expect(screen.queryByText(/balance:/i)).not.toBeInTheDocument()
})

const statement: FeeStatementDetail = {
  id: 's1', reference: 'SAMPLE-STMT-202610-ABCD', state: 'ISSUED', overdue: false, periodStart: '2026-10-01', periodEnd: '2026-10-31', issuedOn: '2026-11-02', dueOn: '2026-11-15',
  chargesCentavos: 20000, creditsCentavos: 0, paidCentavos: 0, outstandingCentavos: 20000, disputedHeldCentavos: 0, lockVersion: 2, sampleNotice: 'SAMPLE statement — not an official invoice.',
  lines: [{ type: 'EARNED_COMMISSION', amount_centavos: 20000, description: 'Earned 2% commission on completed order', order_reference: 'ORD-1', basis_centavos: 1000000 }], payments: [],
  channels: [{ code: 'GCASH', displayName: 'GCash', kind: 'EWALLET', available: true, refundSupported: true, feeVersion: 1, rateLabel: '2.3%', feeCentavos: 0, totalCentavos: 20000, feeBearer: 'PLATFORM', rateSource: 'DEMO_PUBLISHED_RATE' }],
} as FeeStatementDetail

test('the owner pays an issued statement in part; the amount is validated before any request', async () => {
  vi.mocked(finance.getStatement).mockResolvedValue(statement)
  vi.mocked(finance.payStatement).mockResolvedValue({ id: 'pay-1', purpose: 'PLATFORM_FEE_PAYMENT', status: 'PENDING', attemptNumber: 1, principalCentavos: 5000, processingFeeCentavos: 0, totalCentavos: 5000, feeBearer: 'PLATFORM', environment: 'TEST', evidenceOrigin: 'SIMULATED', canCheckStatus: true, message: 'Pending' } as Awaited<ReturnType<typeof finance.payStatement>>)
  const open = vi.spyOn(window, 'open').mockReturnValue(null)
  at('/finance/statements/s1', <VendorStatementPage />, '/finance/statements/:statementId')
  expect(await screen.findByRole('heading', { name: 'SAMPLE-STMT-202610-ABCD', level: 1 })).toBeInTheDocument()
  fireEvent.click(screen.getByLabelText('Pay part of the balance now'))
  fireEvent.change(screen.getByLabelText(/Amount \(₱\)/), { target: { value: '500' } })
  fireEvent.click(screen.getByRole('button', { name: /Pay amount/ }))
  expect(await screen.findByText(/Enter an amount from ₱0.01 to ₱200.00/)).toBeInTheDocument()
  expect(finance.payStatement).not.toHaveBeenCalled()
  fireEvent.change(screen.getByLabelText(/Amount \(₱\)/), { target: { value: '50' } })
  fireEvent.click(screen.getByRole('button', { name: /Pay amount/ }))
  await waitFor(() => expect(finance.payStatement).toHaveBeenCalledWith('s1', 'GCASH', 5000, expect.any(String)))
  open.mockRestore()
})

test('earnings is a separate owner module with labelled DEMO figures', async () => {
  vi.mocked(finance.getEarnings).mockResolvedValue({ demo: true, environment: 'TEST', notice: 'Internal Operational Report — Not a Tax Invoice.', commercialSalesCentavos: 1000000, includedVatCentavos: 0,
    onlineCollectionsCentavos: 1000000, buyerProcessingFeesCentavos: 26441, physicalCollectionsCentavos: 0, providerChargesCentavos: 26441, simulatedCwtCentavos: 5000,
    estimatedRemittanceCashCentavos: 995000, earnedCommissionCentavos: 0, estimatedCommissionCentavos: 20000, unpaidStatementsCentavos: 0 })
  at('/finance/earnings', <VendorEarningsPage />)
  expect(await screen.findByRole('heading', { name: 'Earnings', level: 1 })).toBeInTheDocument()
  expect(screen.getByText('TEST dataset — DEMO figures')).toBeInTheDocument()
  expect(screen.getByText('₱9,950.00')).toBeInTheDocument()
})

test('threshold panel floors the remaining allowance and states status in text, not color', () => {
  render(<ThresholdPanel data={{ ...threshold, remainingAllowanceCentavos: -500, crossedAt: null, status: 'RELIEF_ACTIVE', advisory: true, percentOfThreshold: 85, cumulativeGrossCentavos: 42500000 }} />)
  expect(screen.getByText('Remaining allowance').nextElementSibling).toHaveTextContent('₱0.00')
  expect(screen.getByText('Relief active — no withholding')).toBeInTheDocument()
  expect(screen.getByText(/Advisory: 80% of the threshold reached/)).toBeInTheDocument()
  render(<WithholdingStatusBadge status="SUBJECT_PRIOR_YEAR" />)
  expect(screen.getByText('Subject to withholding — prior year above threshold')).toBeInTheDocument()
})
