import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import { PaymentAttemptBadge, ThresholdPanel, WithholdingStatusBadge } from '@materyalph/web-ui'
import * as onboarding from '../lib/onboarding-api'
import * as finance from '../lib/finance-api'
import type { FeeStatementDetail, VendorFinanceOverview } from '../lib/finance-api'
import { VendorCommissionPage, VendorEarningsPage, VendorFinancePage, VendorStatementPage, VendorTransactionHistoryPage } from './FinancePages'

vi.mock('../lib/onboarding-api', async original => ({ ...await original<typeof import('../lib/onboarding-api')>(), getVendorOnboarding: vi.fn(), getVendorPrivateFileUrl: vi.fn(), acceptVendorCommission: vi.fn() }))
vi.mock('../lib/finance-api', async original => ({ ...await original<typeof import('../lib/finance-api')>(), getFinanceOverview: vi.fn(), updatePhysicalPayments: vi.fn(), listTransactions: vi.fn(),
  getStatement: vi.fn(), payStatement: vi.fn(), refreshFeePayment: vi.fn(), getEarnings: vi.fn(), exportTransactions: vi.fn(), revealTin: vi.fn(), getCommissionMonitoring: vi.fn() }))

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
  vi.mocked(finance.getEarnings).mockResolvedValue(earnings())
  vi.mocked(finance.getCommissionMonitoring).mockResolvedValue({ hasMore: false, monitoring: {
    currentPolicy: { id: 'policy-1', version: 1, commissionBasisPoints: 200, rateLabel: '2.00%', effectiveFrom: new Date('2026-10-19T00:00:00Z'), status: 'CURRENT' }, termsAccepted: true,
    summary: { estimatedCentavos: 0, earnedCentavos: 0, creditedCentavos: 0, netEarnedCentavos: 0, unbilledCentavos: 0, draftCentavos: 0, outstandingCentavos: 0, overdueCentavos: 0, collectedCentavos: 0, refundedCentavos: 0, netCollectedCentavos: 0 }, assessments: [],
  } })
})

test('commission monitoring distinguishes estimated fees, earned fees and issued debt and shows each saved rate', async () => {
  vi.mocked(finance.getCommissionMonitoring).mockResolvedValue({ hasMore: false, monitoring: {
    currentPolicy: { id: 'policy-2', version: 2, commissionBasisPoints: 325, rateLabel: '3.25%', effectiveFrom: new Date('2026-10-19T00:00:00Z'), status: 'CURRENT' }, termsAccepted: true,
    summary: { estimatedCentavos: 3250, earnedCentavos: 20000, creditedCentavos: 4000, netEarnedCentavos: 16000, unbilledCentavos: 16000, draftCentavos: 0, outstandingCentavos: 8000, overdueCentavos: 2000, collectedCentavos: 9000, refundedCentavos: 1000, netCollectedCentavos: 8000 },
    assessments: [{ id: 'assessment-1', orderReference: 'ORD-OLD-RATE', state: 'EARNED', commissionBasisCentavos: 1000000, commissionBasisPoints: 200, estimatedCentavos: 0, earnedCentavos: 20000, creditedCentavos: 4000, netCentavos: 16000, disputeHold: false }],
  } })
  at('/finance/commissions', <VendorCommissionPage />)
  expect(await screen.findByRole('table', { name: 'Commission by order' })).toBeInTheDocument()
  expect(screen.getByText('3.25%')).toBeInTheDocument()
  expect(within(screen.getByRole('table', { name: 'Commission by order' })).getByText('2.00%')).toBeInTheDocument()
  expect(screen.getByText('Estimated fees')).toBeInTheDocument()
  expect(screen.getByText('Unpaid statements')).toBeInTheDocument()
  expect(screen.getByRole('link', { name: 'View and pay commission statements' })).toHaveAttribute('href', '/finance/transactions?tab=STATEMENTS')
  expect(screen.queryByRole('button', { name: 'Edit rate' })).not.toBeInTheDocument()
})

test('commission monitoring remains Owner-only', async () => {
  vi.mocked(onboarding.getVendorOnboarding).mockResolvedValue(snapshot(['portal.orders']))
  at('/finance/commissions', <VendorCommissionPage />)
  expect(await screen.findByText('Store-wide finance is Owner-only')).toBeInTheDocument()
  expect(finance.getCommissionMonitoring).not.toHaveBeenCalled()
})

test('reviewing commission terms opens a popup with fresh terms and keeps the Vendor in Finance', async () => {
  const current = snapshot(['portal.wallet'])
  const fresh = { ...current, verification: { commission_terms: { accepted: true, can_accept: true, agreement: { id: 'agreement-3', version: 3, content: 'Current published commission agreement' } } } }
  vi.mocked(onboarding.getVendorOnboarding).mockResolvedValueOnce(current).mockResolvedValue(fresh)
  at('/finance/commissions', <VendorCommissionPage />)
  const review = await screen.findByRole('button', { name: 'Review Commission Terms' })
  review.focus()
  fireEvent.click(review)
  const dialog = within(screen.getByRole('dialog', { name: 'Review Commission Terms' }))
  expect(await dialog.findByText('Current commission terms accepted for this organization.')).toBeInTheDocument()
  fireEvent.click(dialog.getByText('Read the full commission terms'))
  expect(await dialog.findByRole('region', { name: 'Current commission agreement' })).toHaveTextContent('Current published commission agreement')
  expect(onboarding.getVendorOnboarding).toHaveBeenCalledTimes(2)
  expect(dialog.queryByRole('checkbox')).not.toBeInTheDocument()
  fireEvent.click(dialog.getByRole('button', { name: 'Done' }))
  expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
  expect(screen.getByRole('heading', { name: 'Commission monitoring' })).toBeInTheDocument()
  expect(screen.getByRole('button', { name: 'Review Commission Terms' })).toHaveFocus()
  expect(onboarding.acceptVendorCommission).not.toHaveBeenCalled()
})

test('Finance consent uses the freshly loaded version and organization lock and refreshes fees after acceptance', async () => {
  const current = snapshot(['portal.wallet'])
  const terms = { accepted: false, can_accept: true, agreement: { id: 'agreement-4', version: 4, content: 'Version four commission terms' } }
  const fresh = { ...current, lockVersion: 8, organization: { ...current.organization, lock_version: 7 }, verification: { commission_terms: terms } }
  const accepted = { ...fresh, lockVersion: 9, verification: { commission_terms: { ...terms, accepted: true } } }
  vi.mocked(onboarding.getVendorOnboarding).mockResolvedValueOnce(current).mockResolvedValue(fresh)
  let complete!: (value: typeof accepted) => void
  vi.mocked(onboarding.acceptVendorCommission).mockImplementation(() => new Promise(resolve => { complete = resolve }))
  at('/finance/commissions', <VendorCommissionPage />)
  fireEvent.click(await screen.findByRole('button', { name: 'Review Commission Terms' }))
  const dialog = within(screen.getByRole('dialog', { name: 'Review Commission Terms' }))
  const checkbox = await dialog.findByRole('checkbox')
  expect(checkbox).not.toBeChecked()
  expect(checkbox).toBeDisabled()
  fireEvent.click(dialog.getByText('Read the full commission terms'))
  fireEvent.scroll(await dialog.findByRole('region', { name: 'Current commission agreement' }))
  fireEvent.click(checkbox)
  fireEvent.click(dialog.getByRole('button', { name: 'Accept commission terms' }))
  expect(onboarding.acceptVendorCommission).toHaveBeenCalledWith({ organizationLockVersion: 7, agreementVersionId: 'agreement-4', accepted: true })
  expect(dialog.getByRole('button', { name: 'Done' })).toBeDisabled()
  expect(dialog.getByRole('button', { name: 'Close review commission terms' })).toBeDisabled()
  complete(accepted)
  expect(await dialog.findByText('Current commission terms accepted for this organization.')).toBeInTheDocument()
  expect(finance.getCommissionMonitoring).toHaveBeenCalledTimes(2)
  expect(screen.getByRole('heading', { name: 'Commission monitoring' })).toBeInTheDocument()
})

test('failed popup loading offers a retry while keeping commission monitoring open', async () => {
  const current = snapshot(['portal.wallet'])
  vi.mocked(onboarding.getVendorOnboarding).mockResolvedValueOnce(current).mockRejectedValueOnce(new Error('offline')).mockResolvedValue({ ...current, verification: { commissionTerms: { accepted: true, agreement: { id: 'agreement-1', version: 1, content: 'Published terms' } } } })
  at('/finance/commissions', <VendorCommissionPage />)
  fireEvent.click(await screen.findByRole('button', { name: 'Review Commission Terms' }))
  const dialog = within(screen.getByRole('dialog', { name: 'Review Commission Terms' }))
  expect(await dialog.findByRole('alert')).toBeInTheDocument()
  fireEvent.click(dialog.getByRole('button', { name: 'Try again' }))
  expect(await dialog.findByText('Current commission terms accepted for this organization.')).toBeInTheDocument()
  expect(screen.getByRole('heading', { name: 'Commission monitoring' })).toBeInTheDocument()
})

test('overview groups payment and tax sections and retains finance statuses and notices', async () => {
  vi.mocked(onboarding.getVendorOnboarding).mockResolvedValue(snapshot(['portal.wallet']))
  vi.mocked(finance.getFinanceOverview).mockResolvedValue(overview())
  at('/finance', <VendorFinancePage />)
  expect(await screen.findByRole('heading', { name: 'Finance overview', level: 1 })).toBeInTheDocument()
  const sections = within(screen.getByRole('tablist', { name: 'Workspace sections' }))
  expect(sections.getAllByRole('tab').map(tab => tab.textContent)).toEqual(['Xendit & payment channels', 'Gross-remittance threshold'])
  expect(screen.getByRole('heading', { name: 'Xendit connection', level: 2 })).toBeInTheDocument()
  expect(screen.getByRole('heading', { name: 'Online payment channels', level: 2 })).toBeInTheDocument()
  expect(screen.getByText('Connected — TEST')).toBeInTheDocument()
  expect(screen.getByText('Not offered: no approved refund route')).toBeInTheDocument()
  expect(screen.queryByRole('heading', { name: 'Refund capability' })).not.toBeInTheDocument()
  expect(screen.queryByRole('heading', { name: 'Vendor Tax Profile summary' })).not.toBeInTheDocument()
  fireEvent.keyDown(sections.getByRole('tab', { name: 'Xendit & payment channels' }), { key: 'ArrowRight' })
  for (const name of ['Vendor Tax Profile summary', 'Withholding arrangement']) {
    expect(screen.getByRole('heading', { name, level: 2 })).toBeInTheDocument()
  }
  expect(sections.getByRole('tab', { name: 'Gross-remittance threshold' })).toHaveAttribute('aria-selected', 'true')
  expect(screen.queryByText('Production assignment unconfirmed')).not.toBeInTheDocument()
  expect(screen.queryByRole('heading', { name: 'Commission Terms' })).not.toBeInTheDocument()
  expect(screen.queryByText('Accepted · version 1')).not.toBeInTheDocument()
  expect(screen.queryByRole('heading', { name: 'Xendit connection' })).not.toBeInTheDocument()
  expect(screen.queryByRole('heading', { name: 'Online payment channels' })).not.toBeInTheDocument()
  const thresholdHeading = screen.getByRole('heading', { name: 'Gross-remittance threshold — taxable year 2026' })
  expect(thresholdHeading.compareDocumentPosition(screen.getByRole('heading', { name: 'Vendor Tax Profile summary', level: 2 })) & Node.DOCUMENT_POSITION_FOLLOWING).toBeTruthy()
  expect(screen.getAllByText(/Subject to withholding — threshold crossed/).length).toBeGreaterThan(0)
  expect(screen.getByText(/Threshold crossed on .* \(Asia\/Manila\)/)).toBeInTheDocument()
  const thresholdSection = screen.getByRole('heading', { name: 'Gross-remittance threshold — taxable year 2026' }).closest('section') as HTMLElement
  expect(within(thresholdSection).queryByText('DEMO — simulated figures')).not.toBeInTheDocument()
  expect(screen.queryByText('DEMO — simulated figures')).not.toBeInTheDocument()
  expect(screen.queryByText('DEMO — simulated tax and settlement figures.')).not.toBeInTheDocument()
  expect(screen.getByText(/Cannot be turned off/)).toBeInTheDocument()
  expect(finance.getFinanceOverview).toHaveBeenCalledTimes(1)
  expect(finance.getEarnings).not.toHaveBeenCalled()
})

test('the TIN stays masked until the Owner shows it, is fetched on each show and is discarded when hidden', async () => {
  vi.mocked(finance.getFinanceOverview).mockResolvedValue(overview())
  vi.mocked(finance.revealTin).mockResolvedValue('123-456-789-000')
  at('/finance', <VendorFinancePage />)
  fireEvent.click(await screen.findByRole('tab', { name: 'Gross-remittance threshold' }))
  expect(screen.getByText('•••-•••-123 (masked)')).toBeInTheDocument()
  expect(finance.revealTin).not.toHaveBeenCalled()
  fireEvent.click(screen.getByRole('button', { name: 'Show TIN' }))
  expect(await screen.findByText('123-456-789-000')).toBeInTheDocument()
  expect(screen.queryByText('•••-•••-123 (masked)')).not.toBeInTheDocument()
  const hide = screen.getByRole('button', { name: 'Hide TIN' })
  expect(hide).toHaveAttribute('aria-pressed', 'true')
  fireEvent.click(hide)
  expect(screen.getByText('•••-•••-123 (masked)')).toBeInTheDocument()
  expect(screen.queryByText('123-456-789-000')).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Show TIN' }))
  await screen.findByText('123-456-789-000')
  expect(finance.revealTin).toHaveBeenCalledTimes(2)
})

test('a TIN that cannot be revealed stays masked and says why', async () => {
  vi.mocked(finance.getFinanceOverview).mockResolvedValue(overview())
  vi.mocked(finance.revealTin).mockRejectedValue(new Error('denied'))
  at('/finance', <VendorFinancePage />)
  fireEvent.click(await screen.findByRole('tab', { name: 'Gross-remittance threshold' }))
  fireEvent.click(screen.getByRole('button', { name: 'Show TIN' }))
  expect(await screen.findByRole('alert')).toBeInTheDocument()
  expect(screen.getByText('•••-•••-123 (masked)')).toBeInTheDocument()
  expect(screen.getByRole('button', { name: 'Show TIN' })).toHaveAttribute('aria-pressed', 'false')
})

test('the threshold section remains available when the tax profile is incomplete', async () => {
  const incompleteProfile = overview({ taxProfile: { available: false } })
  delete incompleteProfile.threshold
  vi.mocked(finance.getFinanceOverview).mockResolvedValue(incompleteProfile)
  at('/finance', <VendorFinancePage />)
  fireEvent.click(await screen.findByRole('tab', { name: 'Gross-remittance threshold' }))
  expect(screen.getByText('The threshold panel appears once your tax profile is complete.')).toBeInTheDocument()
  expect(screen.queryByRole('heading', { name: 'Xendit connection' })).not.toBeInTheDocument()
})

test('physical payment controls are managed in Store Profile instead of Finance overview', async () => {
  vi.mocked(finance.getFinanceOverview).mockResolvedValue(overview())
  at('/finance', <VendorFinancePage />)
  await screen.findByRole('heading', { name: 'Finance overview', level: 1 })
  expect(screen.queryByRole('heading', { name: 'Physical payments' })).not.toBeInTheDocument()
  expect(screen.queryByRole('checkbox', { name: /Accept Cash on Delivery/ })).not.toBeInTheDocument()
  expect(finance.updatePhysicalPayments).not.toHaveBeenCalled()
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
  expect(await screen.findByRole('heading', { name: 'Transactions', level: 1 })).toBeInTheDocument()
  expect(screen.getByRole('tab', { name: 'Transactions' })).toBeInTheDocument()
  expect(screen.queryByRole('tab', { name: /Refunds and adjustments/ })).not.toBeInTheDocument()
  expect(screen.getByText('Use your authorized Xendit dashboard for balances and money withdrawals.')).toBeInTheDocument()
  expect(screen.queryByText(/Read-only records/)).not.toBeInTheDocument()
  // Dates, status and exports share one toolbar card, as on Finance overview.
  const toolbar = screen.getByRole('button', { name: 'All dates' }).closest('div') as HTMLElement
  expect(within(toolbar).getByRole('button', { name: 'Export PDF' })).toBeInTheDocument()
  expect(within(toolbar).getByRole('button', { name: 'Export CSV' })).toBeInTheDocument()
  const table = await screen.findByRole('table')
  expect(within(table).getByText('Paid — verified by provider')).toBeInTheDocument()
  expect(within(table).getByText('₱10,264.41')).toBeInTheDocument()
  expect(screen.queryByRole('tab', { name: /Physical receipts/ })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('tab', { name: /Remittances and CWT/ }))
  expect(await screen.findByText(/No simulated remittance assessments yet/)).toBeInTheDocument()
  expect(screen.queryByText(/balance:/i)).not.toBeInTheDocument()
})

test('transaction date changes reset pagination and CSV exports keep the selected tab and open-ended dates', async () => {
  HTMLDialogElement.prototype.showModal = function () { this.open = true }
  HTMLDialogElement.prototype.close = function () { this.open = false }
  vi.mocked(finance.listTransactions).mockResolvedValue({ items: [{ id: 'refund-1', reference: 'ORD-1', amount_centavos: 100, state: 'PENDING', at: '2026-10-09T00:00:00Z' }], hasMore: false, total: 1 })
  vi.mocked(finance.exportTransactions).mockRejectedValue(new Error('Export offline'))
  at('/finance/transactions?tab=STATEMENTS&page=3', <VendorTransactionHistoryPage />, '/finance/transactions')
  await screen.findByRole('table')
  expect(finance.listTransactions).toHaveBeenLastCalledWith('STATEMENTS', 3, {})
  fireEvent.click(screen.getByRole('button', { name: 'All dates' }))
  fireEvent.change(screen.getByLabelText('From'), { target: { value: '2026-10-01' } })
  fireEvent.click(screen.getByRole('button', { name: 'Apply' }))
  await waitFor(() => expect(finance.listTransactions).toHaveBeenLastCalledWith('STATEMENTS', 1, { from: '2026-10-01' }))
  fireEvent.click(screen.getByRole('button', { name: 'Export CSV' }))
  await waitFor(() => expect(finance.exportTransactions).toHaveBeenCalledWith('STATEMENTS', { from: '2026-10-01' }))
})

test('the Tax documents tab appears only once a certificate exists', async () => {
  vi.mocked(finance.listTransactions).mockImplementation(async tab => tab === 'TAX_DOCUMENTS' ? { items: [], hasMore: false, total: 0 } : { items: [{ id: 'p1', reference: 'ORD-1', status: 'PAID', at: '2026-10-02T02:30:00Z' }], hasMore: false, total: 1 })
  at('/finance/transactions?tab=TAX_DOCUMENTS', <VendorTransactionHistoryPage />, '/finance/transactions')
  await screen.findByRole('table')
  expect(screen.queryByRole('tab', { name: /Tax documents/ })).not.toBeInTheDocument()
  expect(screen.getByRole('tab', { name: /Payments/ })).toBeInTheDocument()
})

test('the Payments status dropdown filters on the server, resets pagination, rides along with exports and clears with the tab', async () => {
  vi.mocked(finance.listTransactions).mockResolvedValue({ items: [{ id: 'p1', reference: 'ORD-1', purpose: 'FULL_ORDER_PAYMENT', status: 'FAILED', gross_centavos: 29305, evidence_origin: 'SIMULATED', at: '2026-10-07T03:47:00Z' }], hasMore: false, total: 1 })
  vi.mocked(finance.exportTransactions).mockResolvedValue(new Blob(['csv']))
  URL.createObjectURL = vi.fn(() => 'blob:test'); URL.revokeObjectURL = vi.fn()
  at('/finance/transactions?page=2', <VendorTransactionHistoryPage />, '/finance/transactions')
  await screen.findByRole('table')
  const dropdown = screen.getByRole('combobox', { name: 'Status' })
  expect(within(dropdown).getAllByRole('option').map(option => option.textContent)).toEqual(expect.arrayContaining(['All statuses', 'Failed — not charged', 'Paid — refunded', 'Paid — verified by provider']))
  fireEvent.change(dropdown, { target: { value: 'FAILED' } })
  await waitFor(() => expect(finance.listTransactions).toHaveBeenLastCalledWith('PAYMENTS', 1, { status: 'FAILED' }))
  expect(screen.getByRole('button', { name: /Failed — not charged/ })).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Export CSV' }))
  await waitFor(() => expect(finance.exportTransactions).toHaveBeenCalledWith('PAYMENTS', { status: 'FAILED' }))
  fireEvent.click(screen.getByRole('tab', { name: /Remittances and CWT/ }))
  await waitFor(() => expect(finance.listTransactions).toHaveBeenLastCalledWith('REMITTANCES', 1, {}))
  expect(screen.queryByRole('combobox', { name: 'Status' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('tab', { name: /^Payments/ }))
  await waitFor(() => expect(finance.listTransactions).toHaveBeenLastCalledWith('PAYMENTS', 1, {}))
  expect(screen.getByRole('combobox', { name: 'Status' })).toHaveValue('')
})

test.each([
  ['REFUNDED', 'Paid — refunded', 10000, '₱0.00'],
  ['PARTIALLY_REFUNDED', 'Paid — partially refunded', 4000, '₱60.00'],
  ['REFUND_PENDING', 'Paid — refund pending', 0, '₱100.00'],
  ['REFUND_FAILED', 'Paid — refund failed', 0, '₱100.00'],
])('payment history shows %s independently of the verified capture and displays the net amount', async (refundState, label, refunded, net) => {
  vi.mocked(finance.listTransactions).mockResolvedValue({ items: [{ id: 'p1', reference: 'ORD-REFUND', purpose: 'FULL_ORDER_PAYMENT', status: 'PAID', refund_state: refundState,
    gross_centavos: 10000, buyer_processing_fee_centavos: 0, refunded_centavos: refunded, net_collected_centavos: 10000 - refunded, evidence_origin: 'SIMULATED', at: '2026-10-02T02:30:00Z' }], hasMore: false, total: 1 })
  at('/finance/transactions', <VendorTransactionHistoryPage />)
  const table = await screen.findByRole('table')
  expect(within(table).getByText(label)).toBeInTheDocument()
  expect(within(table).getByRole('columnheader', { name: 'Refunded' })).toBeInTheDocument()
  expect(within(table).getByRole('columnheader', { name: 'Net collected' })).toBeInTheDocument()
  const cells = within(within(table).getAllByRole('row')[1]!).getAllByRole('cell')
  expect(cells[3]).toHaveTextContent('₱100.00')
  expect(cells[6]).toHaveTextContent(net)
})

test('Payments lists Cash on Delivery and In-Store orders beside online payments, with what is still owed', async () => {
  vi.mocked(finance.listTransactions).mockResolvedValue({ items: [
    { id: 'o1', kind: 'PHYSICAL', order_id: 'order-cod', reference: 'ORD-COD', purpose: 'CASH_ON_DELIVERY', status: 'PHYSICAL_TO_RECORD', refund_state: 'NOT_REQUESTED', gross_centavos: 2905250, buyer_processing_fee_centavos: 0,
      refunded_centavos: 0, net_collected_centavos: 0, collected_centavos: 0, remaining_centavos: 2905250, channel: 'CASH_ON_DELIVERY', evidence_origin: 'VENDOR_RECORD', at: '2026-10-20T02:30:00Z' },
    { id: 'o2', kind: 'PHYSICAL', reference: 'ORD-STORE', purpose: 'IN_STORE_PAYMENT', status: 'PHYSICAL_COLLECTED', refund_state: 'NOT_REQUESTED', gross_centavos: 100000, buyer_processing_fee_centavos: 0,
      refunded_centavos: 0, net_collected_centavos: 100000, collected_centavos: 100000, remaining_centavos: 0, channel: 'IN_STORE', evidence_origin: 'VENDOR_RECORD', at: '2026-10-19T02:30:00Z' },
    { id: 'p1', kind: 'ONLINE', order_id: 'order-online', reference: 'ORD-ONLINE', purpose: 'FULL_ORDER_PAYMENT', status: 'PAID', refund_state: 'NOT_REQUESTED', gross_centavos: 29305, buyer_processing_fee_centavos: 755,
      refunded_centavos: 0, net_collected_centavos: 29305, evidence_origin: 'XENDIT_TEST', at: '2026-10-18T02:30:00Z' },
  ], hasMore: false, total: 3 })
  at('/finance/transactions', <VendorTransactionHistoryPage />)
  const rows = within(await screen.findByRole('table')).getAllByRole('row')
  expect(screen.getByRole('link', { name: 'ORD-COD' })).toHaveAttribute('href', '/orders/order-cod')
  expect(screen.getByRole('link', { name: 'ORD-ONLINE' })).toHaveAttribute('href', '/orders/order-online')
  expect(rows[1]).toHaveTextContent('CASH ON DELIVERY'); expect(rows[1]).toHaveTextContent('Handed over — cash not recorded'); expect(rows[1]).toHaveTextContent('₱29,052.50 still owed'); expect(rows[1]).toHaveTextContent('COD · VENDOR RECORD')
  expect(rows[2]).toHaveTextContent('Collected — Vendor record'); expect(rows[2]).toHaveTextContent('IN-STORE · VENDOR RECORD'); expect(rows[2]).not.toHaveTextContent('still owed')
  expect(rows[3]).toHaveTextContent('Paid — verified by provider')
  fireEvent.change(screen.getByRole('combobox', { name: 'Status' }), { target: { value: 'PHYSICAL_TO_RECORD' } })
  await waitFor(() => expect(finance.listTransactions).toHaveBeenLastCalledWith('PAYMENTS', 1, { status: 'PHYSICAL_TO_RECORD' }))
})

test.each([
  ['REFUND_PENDING', 'Late capture — refund queued'],
  ['REFUNDED', 'Late capture — refunded'],
  ['REFUND_FAILED', 'Late capture — refund failed'],
])('late capture retains its technical context for %s', (refundState, label) => {
  render(<PaymentAttemptBadge status="CAPTURED_LATE_REFUND_PENDING" refundStatus={refundState} />)
  expect(screen.getByText(label)).toBeInTheDocument()
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

type EarningsData = Awaited<ReturnType<typeof finance.getEarnings>>
const figures = { commercialSalesCentavos: 0, onlineCollectionsCentavos: 0, onlineRefundsCentavos: 0, buyerProcessingFeesCentavos: 0, physicalCollectionsCentavos: 0, providerChargesCentavos: 0, simulatedCwtCentavos: 0,
  estimatedRemittanceCashCentavos: 0, earnedCommissionCentavos: 0 }

function earnings(trend: Partial<EarningsData['trend']> = {}): EarningsData {
  return { demo: true, environment: 'TEST', notice: 'Internal Operational Report — Not a Tax Invoice.', commercialSalesCentavos: 1000000, includedVatCentavos: 0,
    onlineCollectionsCentavos: 1000000, onlineRefundsCentavos: 0, buyerProcessingFeesCentavos: 26441, physicalCollectionsCentavos: 0, providerChargesCentavos: 26441, simulatedCwtCentavos: 5000,
    estimatedRemittanceCashCentavos: 995000, remittanceCollectionsCentavos: 1026441, remittanceRefundsCentavos: 0, earnedCommissionCentavos: 0, estimatedCommissionCentavos: 20000, unpaidStatementsCentavos: 0,
    breakdown: { sales: { orders: 2, materialsBeforeDiscountCentavos: 950000, vendorDiscountsCentavos: 50000, materialsAfterDiscountCentavos: 900000, deliveryCentavos: 100000 },
      online: { payments: 1, principalPaidCentavos: 1000000, refundedPrincipalCentavos: 0 }, physical: { records: 0, cashOnDeliveryCentavos: 0, inStoreCentavos: 0, unrecordedCentavos: 0, unrecordedOrders: 0 } },
    products: { total: 2, truncated: false, items: [
      { listingId: 'l1', name: 'Portland Cement 40kg', category: 'Cement', sku: 'CEM-40', orders: 2, valueCentavos: 600000, vatCentavos: 64286 },
      { listingId: 'l2', name: 'Deformed Steel Bar 10mm', category: 'Steel', sku: null, orders: 1, valueCentavos: 300000, vatCentavos: 32143 }] },
    trend: { granularity: 'DAY', timezone: 'Asia/Manila', from: new Date(2026, 9, 8), to: new Date(2026, 9, 10), days: 3,
      points: [{ date: new Date(2026, 9, 8), ...figures }, { date: new Date(2026, 9, 9), ...figures, commercialSalesCentavos: 1000000, onlineCollectionsCentavos: 1000000, providerChargesCentavos: 26441, simulatedCwtCentavos: 5000, estimatedRemittanceCashCentavos: 995000 },
        { date: new Date(2026, 9, 10), ...figures }],
      previous: { from: new Date(2026, 9, 5), to: new Date(2026, 9, 7), totals: { ...figures, commercialSalesCentavos: 800000 },
        changePercent: { ...Object.fromEntries(Object.keys(figures).map(key => [key, null])), commercialSalesCentavos: 25 } as NonNullable<EarningsData['trend']['previous']>['changePercent'] },
      ...trend },
  }
}

test('earnings is a separate owner module without a notice banner and charts each figure over time', async () => {
  vi.mocked(finance.getEarnings).mockResolvedValue(earnings())
  at('/finance/earnings', <VendorEarningsPage />)
  expect(await screen.findByRole('heading', { name: 'Earnings', level: 1 })).toBeInTheDocument()
  expect(screen.queryByText('TEST dataset — DEMO figures')).not.toBeInTheDocument()
  expect(screen.queryByText(/Demo aggregates are TEST-only/)).not.toBeInTheDocument()
  expect(screen.getAllByText('₱9,950.00').length).toBeGreaterThan(0)
  for (const name of ['Sales and collections', 'Estimated remittance cash', 'Deductions and commission', 'Deductions and fees']) expect(screen.getByRole('region', { name })).toBeInTheDocument()
  expect(screen.getByRole('img', { name: /Commercial sales and collections: Commercial sales and Online collections and Physical collections over 3 periods/ })).toBeInTheDocument()
  expect(screen.getByText(/Charted by day · Oct 8 – Oct 10/)).toBeInTheDocument()
  expect(screen.queryByText(/vs previous/), 'All dates has no earlier period to compare').not.toBeInTheDocument()
  const sales = within(screen.getByRole('region', { name: 'Sales and collections' }))
  expect(sales.getByRole('table', { name: 'Sales and collections per day' })).toHaveTextContent('Oct 9₱10,000.00₱10,000.00₱0.00')
  expect(within(screen.getByRole('region', { name: 'Deductions and commission' })).getByRole('img')).toBeInTheDocument()
  expect(screen.getByText('Collections by method').nextElementSibling).toHaveTextContent('Online collections₱10,000.00 · 100.0%')
})

test('every Earnings card shows the lines that add up to its number', async () => {
  vi.mocked(finance.getEarnings).mockResolvedValue({ ...earnings(), includedVatCentavos: 96429,
    breakdown: { sales: { orders: 2, materialsBeforeDiscountCentavos: 950000, vendorDiscountsCentavos: 50000, materialsAfterDiscountCentavos: 900000, deliveryCentavos: 100000 },
      online: { payments: 3, principalPaidCentavos: 1300000, refundedPrincipalCentavos: 300000 }, physical: { records: 2, cashOnDeliveryCentavos: 40000, inStoreCentavos: 25000, unrecordedCentavos: 2905250, unrecordedOrders: 1 } },
    physicalCollectionsCentavos: 65000 })
  at('/finance/earnings', <VendorEarningsPage />)
  const sales = within(await screen.findByRole('table', { name: 'Commercial sales calculation' }))
  expect(sales.getByRole('row', { name: /^Materials before discounts/ })).toHaveTextContent('₱9,500.00')
  expect(sales.getByRole('row', { name: /^Vendor discounts/ })).toHaveTextContent('-₱500.00')
  expect(sales.getByRole('row', { name: /^Delivery/ })).toHaveTextContent('₱1,000.00')
  expect(sales.getByRole('row', { name: /^Commercial sales/ })).toHaveTextContent('₱10,000.00')
  expect(screen.getByText(/2 orders · includes ₱964.29 VAT\. Cancelled and fully refunded orders are left out\./)).toBeInTheDocument()
  const online = within(screen.getByRole('table', { name: 'Online collections calculation' }))
  expect(online.getByRole('row', { name: /^Verified online payments \(3\)/ })).toHaveTextContent('₱13,000.00')
  expect(online.getByRole('row', { name: /^Confirmed refunds of that principal/ })).toHaveTextContent('-₱3,000.00')
  expect(online.getByRole('row', { name: /^Online collections/ })).toHaveTextContent('₱10,000.00')
  const physical = within(screen.getByRole('table', { name: 'Physical collections calculation' }))
  expect(physical.getByRole('row', { name: /^Cash on Delivery/ })).toHaveTextContent('₱400.00')
  expect(physical.getByRole('row', { name: /^In-Store Payment/ })).toHaveTextContent('₱250.00')
  expect(physical.getByRole('row', { name: /^Physical collections \(2 receipts\)/ })).toHaveTextContent('₱650.00')
  // Cash still owed on handed-over orders is shown beside the recorded total, never added to it.
  expect(screen.getByText(/on 1 delivered or picked-up order is not recorded yet and not counted/)).toHaveTextContent('₱29,052.50')
  expect(screen.getByRole('link', { name: 'Review cash to record' })).toHaveAttribute('href', '/finance/transactions?tab=PAYMENTS&status=PHYSICAL_TO_RECORD')
})

test('earnings lists the sales value of each product and ranks the top sellers like Product analytics', async () => {
  vi.mocked(finance.getEarnings).mockResolvedValue(earnings())
  at('/finance/earnings', <VendorEarningsPage />)
  const strip = within(await screen.findByLabelText('Product sales value reconciliation'))
  expect(strip.getByText('Product sales value').nextElementSibling).toHaveTextContent('₱9,000.00')
  expect(strip.getByText('Plus delivery').nextElementSibling).toHaveTextContent('₱1,000.00')
  expect(strip.getByText('Equals commercial sales').nextElementSibling).toHaveTextContent('₱10,000.00')
  const table = within(screen.getByRole('table', { name: 'Product sales value' }))
  expect(table.getByRole('row', { name: /Portland Cement 40kg/ })).toHaveTextContent('Cement · SKU CEM-40')
  expect(table.getByRole('row', { name: /Portland Cement 40kg/ })).toHaveTextContent('66.7%')
  expect(table.getByRole('row', { name: /Portland Cement 40kg/ })).toHaveTextContent('₱6,000.00')
  expect(table.getByRole('row', { name: /Deformed Steel Bar 10mm/ })).toHaveTextContent('₱3,000.00')
  expect(table.getByRole('link', { name: 'Portland Cement 40kg' })).toHaveAttribute('href', '/performance/products/l1')
  const top = within(screen.getByRole('list', { name: 'Top selling products' }))
  expect(top.getAllByRole('listitem').map(item => item.textContent)).toEqual([expect.stringContaining('Portland Cement 40kg'), expect.stringContaining('Deformed Steel Bar 10mm')])
  expect(top.getAllByRole('listitem')[0]).toHaveTextContent('2 orders · 66.7%')
})

test('the product list says so when nothing sold and notes when it shows only the top products', async () => {
  vi.mocked(finance.getEarnings).mockResolvedValue({ ...earnings(), products: { items: [], total: 0, truncated: false } })
  const first = at('/finance/earnings', <VendorEarningsPage />)
  expect((await screen.findAllByText('No product was sold in these dates.')).length).toBe(2)
  first.unmount()
  const items = Array.from({ length: 12 }, (_, index) => ({ listingId: `l${index}`, name: `Product ${index + 1}`, category: 'Cement', sku: null, orders: 1, valueCentavos: 100000 - index, vatCentavos: 0 }))
  vi.mocked(finance.getEarnings).mockResolvedValue({ ...earnings(), products: { items, total: 80, truncated: true } })
  at('/finance/earnings', <VendorEarningsPage />)
  expect(await screen.findByText('Showing the top 12 of 80 products by sales value.')).toBeInTheDocument()
  const table = within(screen.getByRole('table', { name: 'Product sales value' }))
  expect(table.queryByRole('row', { name: /Product 11/ })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: /next/i }))
  expect(within(screen.getByRole('table', { name: 'Product sales value' })).getByRole('row', { name: /Product 11/ })).toBeInTheDocument()
})

test('earnings shows the remittance calculation with signed deductions and the authoritative total', async () => {
  vi.mocked(finance.getEarnings).mockResolvedValue({ ...earnings(), onlineCollectionsCentavos: 128475, buyerProcessingFeesCentavos: 3397,
    remittanceCollectionsCentavos: 131872, remittanceRefundsCentavos: 0, providerChargesCentavos: 3397, simulatedCwtCentavos: 381, estimatedRemittanceCashCentavos: 128094 })
  at('/finance/earnings', <VendorEarningsPage />)
  const breakdown = within(await screen.findByRole('table', { name: 'Estimated remittance calculation' }))
  expect(breakdown.getByRole('row', { name: /Collected online payments/ })).toHaveTextContent('₱1,318.72')
  expect(breakdown.getByRole('row', { name: /^Provider charges/ })).toHaveTextContent('-₱33.97')
  expect(breakdown.getByRole('row', { name: /^Simulated CWT/ })).toHaveTextContent('-₱3.81')
  expect(breakdown.getByRole('row', { name: /^Estimated remittance cash/ })).toHaveTextContent('₱1,280.94')
  expect(breakdown.getByRole('row', { name: /^Confirmed refunds/ })).toHaveTextContent('₱0.00')
  expect(breakdown.getByRole('row', { name: /^Confirmed refunds/ })).not.toHaveTextContent('-₱0.00')
})

test('the breakdown displays full refunds alongside their original collections without reducing the total twice', async () => {
  vi.mocked(finance.getEarnings).mockResolvedValue({ ...earnings(), onlineCollectionsCentavos: 128475, onlineRefundsCentavos: 73272,
    remittanceCollectionsCentavos: 205144, remittanceRefundsCentavos: 73272, providerChargesCentavos: 3397, simulatedCwtCentavos: 381, estimatedRemittanceCashCentavos: 128094 })
  at('/finance/earnings', <VendorEarningsPage />)
  const breakdown = within(await screen.findByRole('table', { name: 'Estimated remittance calculation' }))
  expect(breakdown.getByRole('row', { name: /Collected online payments/ })).toHaveTextContent('₱2,051.44')
  expect(breakdown.getByRole('row', { name: /^Confirmed refunds/ })).toHaveTextContent('-₱732.72')
  expect(breakdown.getByRole('row', { name: /^Estimated remittance cash/ })).toHaveTextContent('₱1,280.94')
  expect(screen.getByText(/Fully refunded payments appear in both collections and refunds/)).toBeInTheDocument()
  expect(screen.getByText('Verified principal after confirmed refunds').parentElement).toHaveTextContent('₱1,284.75')
})

test('the breakdown uses the assessment-date components and shows confirmed partial refunds once', async () => {
  vi.mocked(finance.getEarnings).mockResolvedValue({ ...earnings(), onlineCollectionsCentavos: 600000, onlineRefundsCentavos: 400000,
    remittanceCollectionsCentavos: 100000, remittanceRefundsCentavos: 20000, providerChargesCentavos: 1000, simulatedCwtCentavos: 500, estimatedRemittanceCashCentavos: 78500 })
  at('/finance/earnings?from=2026-10-08&to=2026-10-10', <VendorEarningsPage />, '/finance/earnings')
  const breakdown = within(await screen.findByRole('table', { name: 'Estimated remittance calculation' }))
  expect(breakdown.getByRole('row', { name: /Collected online payments/ })).toHaveTextContent('₱1,000.00')
  expect(breakdown.getByRole('row', { name: /^Confirmed refunds/ })).toHaveTextContent('-₱200.00')
  expect(breakdown.getByRole('row', { name: /^Estimated remittance cash/ })).toHaveTextContent('₱785.00')
  expect(screen.getByText(/These amounts use remittances assessed in the selected dates/)).toBeInTheDocument()
})

test('earnings displays the server net collections without a refunds banner', async () => {
  vi.mocked(finance.getEarnings).mockResolvedValue({ ...earnings(), onlineCollectionsCentavos: 600000, onlineRefundsCentavos: 400000 })
  at('/finance/earnings', <VendorEarningsPage />)
  expect(await screen.findByText('Verified principal after confirmed refunds')).toBeInTheDocument()
  expect(screen.queryByText(/Refunded amounts are excluded from online collections/)).not.toBeInTheDocument()
  expect(screen.queryByRole('link', { name: 'View refunds' })).not.toBeInTheDocument()
  expect(screen.getByText(/Why this can differ from your Xendit balance/)).toHaveTextContent(/still pending there.*creditable withholding/)
  expect(screen.getByText(/Why this can differ from your Xendit balance/)).not.toHaveTextContent(/simulated/i)
  expect(screen.getByText(/Refunded money is not counted as paid/)).toHaveTextContent('₱4,000.00')
  expect(screen.getByText(/Refunded money is not counted as paid/)).toHaveTextContent(/fully refunded adds no provider charge, CWT or cash/)
  expect(screen.getByText('Verified principal after confirmed refunds').parentElement).toHaveTextContent('₱6,000.00')
})

test('earnings compares with the previous equal period once a start date is chosen and charts long periods by month', async () => {
  vi.mocked(finance.getEarnings).mockResolvedValue(earnings())
  const first = at('/finance/earnings?from=2026-10-08&to=2026-10-10', <VendorEarningsPage />, '/finance/earnings')
  expect(await screen.findByText('+25.0% vs previous 3 days')).toBeInTheDocument()
  expect(screen.getAllByText('No previous 3 days to compare')).toHaveLength(3)
  expect(screen.getByText(/compared with Oct 5 – Oct 7/)).toBeInTheDocument()
  first.unmount()

  vi.mocked(finance.getEarnings).mockResolvedValue(earnings({ granularity: 'MONTH', days: 120, from: new Date(2026, 5, 13), to: new Date(2026, 9, 10),
    points: [{ date: new Date(2026, 5, 1), ...figures }, { date: new Date(2026, 9, 1), ...figures, earnedCommissionCentavos: 20000 }] }))
  at('/finance/earnings', <VendorEarningsPage />)
  const deductions = within(await screen.findByRole('region', { name: 'Deductions and commission' }))
  expect(deductions.getByRole('table', { name: 'Deductions and commission per month' })).toHaveTextContent('Oct 2026')
  expect(screen.getByRole('region', { name: 'Sales and collections' })).toHaveTextContent('No sales or collections in this period.')
})

test('threshold panel floors the remaining allowance and states status in text, not color', () => {
  render(<ThresholdPanel data={{ ...threshold, remainingAllowanceCentavos: -500, crossedAt: null, status: 'RELIEF_ACTIVE', advisory: true, percentOfThreshold: 85, cumulativeGrossCentavos: 42500000 }} />)
  expect(screen.getByText('Remaining allowance').nextElementSibling).toHaveTextContent('₱0.00')
  expect(screen.getByText('Relief active — no withholding')).toBeInTheDocument()
  expect(screen.getByText('DEMO — simulated figures')).toBeInTheDocument()
  expect(screen.getByText(/Advisory: 80% of the threshold reached/)).toBeInTheDocument()
  expect(screen.getByText(/a fully refunded collection is voided and removed from this threshold total/)).toBeInTheDocument()
  render(<WithholdingStatusBadge status="SUBJECT_PRIOR_YEAR" />)
  expect(screen.getByText('Subject to withholding — prior year above threshold')).toBeInTheDocument()
})

test('threshold explains the recorded gross basis and the cash difference with delivery, VAT and withholding', () => {
  render(<ThresholdPanel data={{ ...threshold, cumulativeGrossCentavos: 76473, localGrossCentavos: 76473, remainingAllowanceCentavos: 49923527,
    crossedAt: null, status: 'SUBJECT_STANDARD', calculationBreakdown: {
      collectionsCentavos: 131872, refundsCentavos: 0, deliveryCentavos: 42825, materialVatCentavos: 9177,
      providerChargesCentavos: 3397, grossBasisCentavos: 76473, withheldCentavos: 381, assessedCashCentavos: 128094,
    } }} />)
  const gross = within(screen.getByRole('table', { name: 'On-platform threshold calculation' }))
  const cash = within(screen.getByRole('table', { name: 'Remittance cash for these assessments' }))
  expect(gross.getByRole('row', { name: /Assessed collections/ })).toHaveTextContent('₱1,318.72')
  expect(gross.getByRole('row', { name: /Separately billed delivery/ })).toHaveTextContent('-₱428.25')
  expect(gross.getByRole('row', { name: /Included material VAT/ })).toHaveTextContent('-₱91.77')
  expect(gross.getByRole('row', { name: /Provider charges/ })).toHaveTextContent('-₱33.97')
  expect(gross.getByRole('row', { name: /On-platform gross toward threshold/ })).toHaveTextContent('₱764.73')
  expect(cash.getByRole('row', { name: /Assessed withholding/ })).toHaveTextContent('-₱3.81')
  expect(cash.getByRole('row', { name: /Estimated cash at assessment/ })).toHaveTextContent('₱1,280.94')
  expect(screen.getByText(/regardless of the Earnings date filter/)).toBeInTheDocument()
  expect(screen.getByText(/Earnings reflects later confirmed refunds/)).toBeInTheDocument()
})

test('Finance overview opens on Earnings, lists no Finance reviews section and has no separate sidebar link', async () => {
  vi.mocked(finance.getFinanceOverview).mockResolvedValue(overview())
  vi.mocked(finance.getEarnings).mockResolvedValue(earnings())
  at('/finance', <VendorFinancePage />)
  const earningsTab = await screen.findByRole('tab', { name: 'Earnings' })
  expect(within(screen.getByRole('tablist', { name: 'Workspace sections' })).getAllByRole('tab').map(tab => tab.textContent)).toEqual(['Earnings', 'Xendit & payment channels', 'Gross-remittance threshold'])
  expect(earningsTab).toHaveAttribute('aria-selected', 'true')
  expect(screen.queryByRole('tab', { name: 'Finance reviews' })).not.toBeInTheDocument()
  expect(screen.queryByRole('link', { name: /^Earnings$/ })).not.toBeInTheDocument()
  expect(screen.queryByText('MateryalPH holds no wallet or balance for your store.')).not.toBeInTheDocument()
  expect(await screen.findByRole('heading', { name: 'Earnings', level: 2 })).toBeInTheDocument()
  await waitFor(() => expect(finance.getEarnings).toHaveBeenCalledTimes(1))
  expect(screen.getByRole('button', { name: 'Export PDF' })).toBeEnabled()
  expect(screen.getByRole('button', { name: /^Earnings dates|All dates/ })).toBeInTheDocument()
  expect(screen.queryByRole('heading', { name: 'Xendit connection' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('tab', { name: 'Xendit & payment channels' }))
  expect(await screen.findByRole('heading', { name: 'Xendit connection', level: 2 })).toBeInTheDocument()
})
test('Finance overview does not request Earnings without its permission', async () => {
  vi.mocked(onboarding.getVendorOnboarding).mockResolvedValue(snapshot(['portal.wallet']))
  vi.mocked(finance.getFinanceOverview).mockResolvedValue(overview())
  at('/finance', <VendorFinancePage />)
  await screen.findByRole('heading', { name: 'Finance overview', level: 1 })
  expect(screen.queryByRole('tab', { name: 'Earnings' })).not.toBeInTheDocument()
  expect(finance.getEarnings).not.toHaveBeenCalled()
})
