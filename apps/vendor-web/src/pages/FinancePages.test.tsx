import { dateFilterPreset } from '@materyalph/web-ui'
import type { VendorCommissionMonitoring } from '@materyalph/api-client-ts'
import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import { PaymentAttemptBadge, ThresholdPanel, WithholdingStatusBadge } from '@materyalph/web-ui'
import * as onboarding from '../lib/onboarding-api'
import * as finance from '../lib/finance-api'
import type { FeeStatementDetail, VendorFinanceOverview } from '../lib/finance-api'
import { VendorCommissionPage, VendorEarningsPage, VendorFinancePage, VendorStatementPage, VendorTransactionHistoryPage } from './FinancePages'

const defaultDates = () => ({ from: dateFilterPreset(30).from, to: dateFilterPreset(30).to })
const paymentPeriods = (collected = 0, refunded = 0): Pick<VendorCommissionMonitoring, 'annualPayments' | 'monthlyPayments' | 'paymentHistory'> => ({
  annualPayments: { label: '2026', startsOn: new Date('2026-01-01'), endsOn: new Date('2026-12-31'), resetsAt: new Date('2026-12-31T16:00:00Z'), collectedCentavos: collected * 2, refundedCentavos: refunded * 2, netCollectedCentavos: (collected - refunded) * 2 },
  monthlyPayments: { label: 'November 2026', startsOn: new Date('2026-11-01'), endsOn: new Date('2026-11-30'), resetsAt: new Date('2026-11-30T16:00:00Z'), collectedCentavos: collected, refundedCentavos: refunded, netCollectedCentavos: collected - refunded },
  paymentHistory: { items: [], page: 1, perPage: 10 as const, total: 0, hasMore: false },
})


vi.mock('../lib/onboarding-api', async original => ({ ...await original<typeof import('../lib/onboarding-api')>(), getVendorOnboarding: vi.fn(), getVendorPrivateFileUrl: vi.fn(), acceptVendorCommission: vi.fn() }))
vi.mock('../lib/finance-api', async original => ({ ...await original<typeof import('../lib/finance-api')>(), getFinanceOverview: vi.fn(), updatePhysicalPayments: vi.fn(), listTransactions: vi.fn(),
  getStatement: vi.fn(), payStatement: vi.fn(), refreshFeePayment: vi.fn(), getEarnings: vi.fn(), getThresholdPayments: vi.fn(), exportTransactions: vi.fn(), revealTin: vi.fn(), getCommissionMonitoring: vi.fn() }))

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

function openFigureHelp(title: string) {
  const scope = title === 'Xendit cash revenue' ? screen.getByLabelText('Xendit cash revenue estimate') : screen.getByRole('region', { name: 'At a glance' })
  fireEvent.click(within(scope).getByRole('button', { name: `How this is calculated: ${title}` }))
  return within(screen.getByRole('dialog', { name: title }))
}

beforeEach(() => {
  vi.clearAllMocks()
  vi.mocked(onboarding.getVendorOnboarding).mockResolvedValue(snapshot(['portal.orders', 'portal.wallet', 'portal.earnings', 'finance.view', 'finance.pay', 'payments.configure']))
  vi.mocked(onboarding.getVendorPrivateFileUrl).mockResolvedValue({ url: 'https://example.test/logo', expiresAt: new Date() })
  vi.mocked(finance.getEarnings).mockResolvedValue(earnings())
  vi.mocked(finance.getThresholdPayments).mockResolvedValue({ hasMore: false, total: 0, data: { taxableYear: 2026, payments: [], otherStoreTotals: null,
    totals: { assessedPayments: 0, paymentPrincipalCentavos: 0, buyerProcessingFeesCentavos: 0, collectionsCentavos: 0, withheldCentavos: 0 } } })
  vi.mocked(finance.getFinanceOverview).mockResolvedValue(overview())
  vi.mocked(finance.listTransactions).mockResolvedValue({ items: [], total: 0, hasMore: false })
  vi.mocked(finance.getCommissionMonitoring).mockResolvedValue({ hasMore: false, monitoring: {
    ...paymentPeriods(),
    currentPolicy: { id: 'policy-1', version: 1, commissionBasisPoints: 200, rateLabel: '2.00%', effectiveFrom: new Date('2026-10-19T00:00:00Z'), status: 'CURRENT' }, termsAccepted: true,
    summary: { estimatedCentavos: 0, earnedCentavos: 0, creditedCentavos: 0, netEarnedCentavos: 0, unbilledCentavos: 0, draftCentavos: 0, outstandingCentavos: 0, overdueCentavos: 0, collectedCentavos: 0, refundedCentavos: 0, netCollectedCentavos: 0 }, assessments: [],
  } })
})

test('commission monitoring distinguishes estimated fees, earned fees and issued debt and shows each saved rate', async () => {
  vi.mocked(finance.getCommissionMonitoring).mockResolvedValue({ hasMore: false, monitoring: {
    ...paymentPeriods(9000, 1000),
    currentPolicy: { id: 'policy-2', version: 2, commissionBasisPoints: 325, rateLabel: '3.25%', effectiveFrom: new Date('2026-10-19T00:00:00Z'), status: 'CURRENT' }, termsAccepted: true,
    summary: { estimatedCentavos: 3250, earnedCentavos: 20000, creditedCentavos: 4000, netEarnedCentavos: 16000, unbilledCentavos: 16000, draftCentavos: 0, outstandingCentavos: 8000, overdueCentavos: 2000, collectedCentavos: 9000, refundedCentavos: 1000, netCollectedCentavos: 8000 },
    assessments: [{ id: 'assessment-1', orderReference: 'ORD-OLD-RATE', state: 'EARNED', commissionBasisCentavos: 1000000, commissionBasisPoints: 200, estimatedCentavos: 0, earnedCentavos: 20000, creditedCentavos: 4000, netCentavos: 16000, disputeHold: false }],
  } })
  at('/finance/commissions', <VendorCommissionPage />)
  expect(await screen.findByRole('table', { name: 'Commission by order' })).toBeInTheDocument()
  expect(screen.getByText('3.25%')).toBeInTheDocument()
  expect(within(screen.getByRole('table', { name: 'Commission by order' })).getByText('2.00%')).toBeInTheDocument()
  const summary = within(screen.getByRole('region', { name: 'Current commission balances' }))
  expect(summary.getByText('Estimated commission')).toBeInTheDocument()
  expect(summary.getByText('₱32.50')).toBeInTheDocument()
  const orders = within(screen.getByRole('table', { name: 'Commission by order' }))
  expect(orders.getAllByRole('columnheader')).toHaveLength(6)
  for (const name of ['Materials value', 'Estimated commission', 'Commission charged', 'Final commission']) expect(orders.getByRole('columnheader', { name })).toBeInTheDocument()
  expect(orders.getByText('₱10,000.00')).toBeInTheDocument()
  expect(orders.getByText('₱200.00')).toBeInTheDocument()
  expect(orders.getByText('Fee reduction -₱40.00')).toBeInTheDocument()
  expect(orders.getByText('₱160.00')).toBeInTheDocument()
  const annual = within(screen.getByRole('region', { name: 'Annual total commission payment' }))
  expect(annual.getByText('₱160.00')).toBeInTheDocument()
  expect(annual.getByText('Calendar year · 2026')).toBeInTheDocument()
  expect(annual.getByText(/Resets Jan 1, 2027/)).toBeInTheDocument()
  const monthly = within(screen.getByRole('region', { name: 'Monthly commission payment' }))
  expect(monthly.getByText('₱80.00')).toBeInTheDocument()
  expect(monthly.getByText('Calendar month · November 2026')).toBeInTheDocument()
  const payments = within(screen.getByRole('table', { name: 'Monthly commission payments' }))
  expect(payments.getByRole('row', { name: 'Payments collected ₱90.00' })).toBeInTheDocument()
  expect(payments.getByRole('row', { name: 'Completed refunds -₱10.00' })).toBeInTheDocument()
  expect(screen.getByText('Unpaid statements')).toBeInTheDocument()
  expect(screen.getByRole('link', { name: 'View and pay commission statements' })).toHaveAttribute('href', '#commission-statements')
  expect(screen.queryByRole('button', { name: 'Edit rate' })).not.toBeInTheDocument()
})

test('current balances help explains carried-forward debt separately from period payments and restores focus', async () => {
  at('/finance/commissions', <VendorCommissionPage />)
  const billing = within(await screen.findByRole('region', { name: 'Current commission balances' }))
  const explanations: [string, RegExp][] = [
    ['Not yet billed', /completed orders that has not yet been added to a monthly bill/],
    ['Draft bills awaiting issue', /prepared but have not yet been issued/],
    ['Approved commission credits', /Approved reductions to commission already charged/],
    ['Unpaid statements', /balances carry forward when the payment totals reset/],
    ['Overdue', /already included in Unpaid statements/],
    ['Estimated commission', /Accepted orders awaiting completion/],
  ]
  expect(billing.getAllByRole('button', { name: /^How this is calculated:/ })).toHaveLength(1)
  const trigger = billing.getByRole('button', { name: 'How this is calculated: Current commission balances' })
  trigger.focus()
  fireEvent.click(trigger)
  expect(trigger).toHaveAttribute('aria-expanded', 'true')
  const dialog = screen.getByRole('dialog', { name: 'Current commission balances' })
  for (const [title, expected] of explanations) {
    expect(within(dialog).getByRole('heading', { name: title })).toBeInTheDocument()
    expect(dialog).toHaveTextContent(expected)
  }
  fireEvent.keyDown(document, { key: 'Escape' })
  expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
  expect(trigger).toHaveAttribute('aria-expanded', 'false')
  expect(trigger).toHaveFocus()
  fireEvent.click(trigger)
  fireEvent.click(screen.getByRole('button', { name: 'Close calculation explanation' }))
  expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
  expect(trigger).toHaveFocus()
})

test('annual payment history is distinct from paid statements, paginates independently and restores focus', async () => {
  const base = await vi.mocked(finance.getCommissionMonitoring).getMockImplementation()!()
  vi.mocked(finance.getCommissionMonitoring).mockImplementation(async (orderPage = 1, historyPage = 1) => ({ ...base, monitoring: { ...base.monitoring,
    paymentHistory: { items: [{ ...base.monitoring.annualPayments, label: historyPage === 1 ? '2025' : '2015', collectedCentavos: 50000, refundedCentavos: 10000, netCollectedCentavos: 40000 }], page: historyPage, perPage: 10, total: 11, hasMore: historyPage === 1 },
    assessments: orderPage === 1 ? [] : base.monitoring.assessments,
  } }))
  at('/finance/commissions', <VendorCommissionPage />)
  const trigger = await screen.findByRole('button', { name: 'Annual history' })
  trigger.focus()
  fireEvent.click(trigger)
  const dialog = await screen.findByRole('dialog', { name: 'Annual total commission payment history' })
  expect(await within(dialog).findByText('2025')).toBeInTheDocument()
  expect(within(dialog).getAllByText('₱400.00').length).toBeGreaterThan(0)
  fireEvent.click(within(dialog).getByRole('button', { name: 'Next' }))
  expect(await within(dialog).findByText('2015')).toBeInTheDocument()
  expect(finance.getCommissionMonitoring).toHaveBeenLastCalledWith(1, 2)
  fireEvent(dialog, new Event('cancel', { cancelable: true }))
  expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
  expect(trigger).toHaveFocus()
})

test('annual payment history explains its empty state and can retry a failed request', async () => {
  const base = await vi.mocked(finance.getCommissionMonitoring).getMockImplementation()!()
  vi.mocked(finance.getCommissionMonitoring).mockResolvedValueOnce(base).mockRejectedValueOnce(new Error('offline')).mockResolvedValue(base)
  at('/finance/commissions', <VendorCommissionPage />)
  fireEvent.click(await screen.findByRole('button', { name: 'Annual history' }))
  const dialog = await screen.findByRole('dialog', { name: 'Annual total commission payment history' })
  fireEvent.click(await within(dialog).findByRole('button', { name: 'Try again' }))
  expect(await within(dialog).findByText(/No completed years with commission payments or refunds yet/)).toBeInTheDocument()
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

test('primary finance navigation opens payment and tax views and retains finance statuses and notices', async () => {
  vi.mocked(onboarding.getVendorOnboarding).mockResolvedValue(snapshot(['portal.wallet']))
  vi.mocked(finance.getFinanceOverview).mockResolvedValue(overview())
  at('/finance?section=xendit', <VendorFinancePage />, '/finance')
  expect(await screen.findByRole('heading', { name: 'Finance overview', level: 1 })).toBeInTheDocument()
  const sections = within(screen.getByRole('tablist', { name: 'Finance sections' }))
  expect(sections.getAllByRole('tab').map(tab => tab.textContent)).toEqual(['Finance overview', 'Commission monitoring', 'Transactions', 'Xendit cash revenue & remittance'])
  expect(sections.getByRole('tab', { name: 'Finance overview' })).toHaveAttribute('aria-selected', 'true')
  expect(screen.queryByRole('heading', { name: 'Xendit connection', level: 2 })).not.toBeInTheDocument()
  expect(screen.getByRole('heading', { name: 'Online payment channels', level: 2 })).toBeInTheDocument()
  expect(screen.getByText('Not offered: no approved refund route')).toBeInTheDocument()
  expect(screen.queryByRole('heading', { name: 'Refund capability' })).not.toBeInTheDocument()
  expect(screen.queryByRole('heading', { name: 'Tax profile' })).not.toBeInTheDocument()
  fireEvent.keyDown(sections.getByRole('tab', { name: 'Finance overview' }), { key: 'ArrowLeft' })
  expect(screen.getByRole('heading', { name: 'Tax profile', level: 2 })).toBeInTheDocument()
  expect(screen.getByText('Withholding rate')).toBeInTheDocument()
  expect(sections.getByRole('tab', { name: 'Xendit cash revenue & remittance' })).toHaveAttribute('aria-selected', 'true')
  expect(screen.getByRole('heading', { name: 'Xendit cash revenue & remittance', level: 1 })).toBeInTheDocument()
  expect(screen.queryByText('Production assignment unconfirmed')).not.toBeInTheDocument()
  expect(screen.queryByRole('heading', { name: 'Commission Terms' })).not.toBeInTheDocument()
  expect(screen.queryByText('Accepted · version 1')).not.toBeInTheDocument()
  expect(screen.getByRole('heading', { name: 'Xendit connection' })).toBeInTheDocument()
  expect(screen.getByText('Connected — TEST')).toBeInTheDocument()
  expect(screen.queryByRole('heading', { name: 'Online payment channels' })).not.toBeInTheDocument()
  const thresholdHeading = screen.getByRole('heading', { name: 'Gross-remittance threshold' })
  const taxProfileHeading = screen.getByRole('heading', { name: 'Tax profile', level: 2 })
  expect(taxProfileHeading.compareDocumentPosition(thresholdHeading) & Node.DOCUMENT_POSITION_FOLLOWING).toBeTruthy()
  expect(thresholdHeading.closest('.mp-threshold-workspace')).not.toContainElement(taxProfileHeading)
  expect(screen.getAllByText(/Subject to withholding — threshold crossed/).length).toBeGreaterThan(0)
  expect(screen.getByText(/Threshold crossed on .* \(Asia\/Manila\)/)).toBeInTheDocument()
  const thresholdSection = thresholdHeading.closest('section') as HTMLElement
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
  fireEvent.click(await screen.findByRole('tab', { name: 'Xendit cash revenue & remittance' }))
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
  fireEvent.click(await screen.findByRole('tab', { name: 'Xendit cash revenue & remittance' }))
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
  fireEvent.click(await screen.findByRole('tab', { name: 'Xendit cash revenue & remittance' }))
  expect(screen.getByText('The threshold panel appears once your tax profile is complete.')).toBeInTheDocument()
  expect(screen.getByRole('heading', { name: 'Xendit connection' })).toBeInTheDocument()
})

test('the compact tax profile keeps the rate readable and retains the full recorded label in help', async () => {
  const rate = '0.5% of qualifying gross remittance (RR No. 5-2025); never an extra Buyer charge'
  vi.mocked(finance.getFinanceOverview).mockResolvedValue(overview({ withholdingArrangement: { rate_label: rate } }))
  at('/finance?section=threshold', <VendorFinancePage />, '/finance')
  expect(await screen.findByText('0.5% of qualifying gross remittance')).toBeInTheDocument()
  expect(screen.queryByText(rate)).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'How this is calculated: Tax profile' }))
  expect(within(screen.getByRole('dialog', { name: 'Tax profile' })).getByText(rate)).toBeInTheDocument()
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

test('transaction history has one Payments list without a separate remittances tab or a redundant single chip', async () => {
  vi.mocked(finance.listTransactions).mockImplementation(async tab => tab === 'PAYMENTS'
    ? { items: [{ id: 'p1', reference: 'ORD-1', purpose: 'FULL_ORDER_PAYMENT', status: 'PAID', gross_centavos: 1000000, buyer_processing_fee_centavos: 26441, evidence_origin: 'SIMULATED', at: '2026-10-02T02:30:00Z' }], hasMore: false, total: 1 }
    : { items: [], hasMore: false, total: 0 })
  at('/finance/transactions', <VendorTransactionHistoryPage />)
  expect(await screen.findByRole('heading', { name: 'Transactions', level: 1 })).toBeInTheDocument()
  expect(screen.getByRole('tab', { name: 'Transactions' })).toBeInTheDocument()
  expect(screen.queryByRole('tab', { name: /Refunds and adjustments/ })).not.toBeInTheDocument()
  expect(screen.getByText('Use your authorized Xendit dashboard for available funds and money withdrawals.')).toBeInTheDocument()
  expect(screen.queryByText(/Read-only records/)).not.toBeInTheDocument()
  // Dates, status and exports share one toolbar card, as on Finance overview.
  const toolbar = screen.getByRole('button', { name: 'Last 30 days' }).closest('div') as HTMLElement
  expect(within(toolbar).getByRole('button', { name: 'Export PDF' })).toBeInTheDocument()
  expect(within(toolbar).getByRole('button', { name: 'Export CSV' })).toBeInTheDocument()
  const table = await screen.findByRole('table')
  expect(within(table).getByText('Paid — verified by provider')).toBeInTheDocument()
  expect(within(table).getByText('₱10,000.00')).toBeInTheDocument()
  expect(screen.queryByRole('tab', { name: /Physical receipts/ })).not.toBeInTheDocument()
  expect(screen.queryByRole('tab', { name: /Remittances and withholding tax/ })).not.toBeInTheDocument()
  expect(screen.queryByRole('tab', { name: /^Payments/ })).not.toBeInTheDocument()
  expect(screen.getByRole('heading', { name: /^Payments$/ })).toBeInTheDocument()
  expect(screen.getByText('Not assessed')).toBeInTheDocument()
  expect(screen.queryByText(/balance:/i)).not.toBeInTheDocument()
})

test('transaction date changes reset pagination and CSV exports keep the selected tab and open-ended dates', async () => {
  HTMLDialogElement.prototype.showModal = function () { this.open = true }
  HTMLDialogElement.prototype.close = function () { this.open = false }
  vi.mocked(finance.listTransactions).mockResolvedValue({ items: [{ id: 'refund-1', reference: 'ORD-1', amount_centavos: 100, state: 'PENDING', at: '2026-10-09T00:00:00Z' }], hasMore: false, total: 1 })
  vi.mocked(finance.exportTransactions).mockRejectedValue(new Error('Export offline'))
  at('/finance/transactions?tab=REMITTANCES&page=3', <VendorTransactionHistoryPage />, '/finance/transactions')
  await screen.findByRole('table')
  expect(finance.listTransactions).toHaveBeenLastCalledWith('PAYMENTS', 3, defaultDates())
  fireEvent.click(screen.getByRole('button', { name: 'Last 30 days' }))
  fireEvent.change(screen.getByLabelText('From'), { target: { value: '2026-10-01' } })
  fireEvent.change(screen.getByLabelText('To'), { target: { value: '' } })
  fireEvent.click(screen.getByRole('button', { name: 'Apply' }))
  await waitFor(() => expect(finance.listTransactions).toHaveBeenLastCalledWith('PAYMENTS', 1, { from: '2026-10-01' }))
  fireEvent.click(screen.getByRole('button', { name: 'Export CSV' }))
  await waitFor(() => expect(finance.exportTransactions).toHaveBeenCalledWith('PAYMENTS', { from: '2026-10-01' }))
})

test('commission statements move into monitoring and old Transactions links retain dates and page', async () => {
  vi.mocked(finance.listTransactions).mockResolvedValue({ items: [{ id: 's1', reference: 'SAMPLE-STMT-202610', period_start: '2026-10-01', due_on: '2026-11-15', state: 'ISSUED', outstanding_centavos: 20000 }], total: 50, hasMore: true })
  render(<MemoryRouter initialEntries={['/finance/transactions?tab=STATEMENTS&page=3&from=2026-10-01']}><Routes>
    <Route path="/finance/transactions" element={<VendorTransactionHistoryPage />} />
    <Route path="/finance/commissions" element={<VendorCommissionPage />} />
  </Routes></MemoryRouter>)
  const statements = within(await screen.findByRole('region', { name: 'Commission statements' }))
  expect(await statements.findByRole('link', { name: /SAMPLE-STMT-202610/ })).toHaveAttribute('href', '/finance/statements/s1?from=2026-10-01&statement_page=3')
  expect(finance.listTransactions).toHaveBeenCalledWith('STATEMENTS', 3, { statementState: 'NOT_PAID' })
  expect(statements.getByRole('button', { name: 'Export PDF' })).toBeInTheDocument()
  expect(statements.getByRole('button', { name: 'Export CSV' })).toBeInTheDocument()
  expect(screen.queryByRole('tab', { name: 'Commission statements' })).not.toBeInTheDocument()
  fireEvent.click(statements.getByRole('button', { name: 'Next' }))
  await waitFor(() => expect(finance.listTransactions).toHaveBeenCalledWith('STATEMENTS', 4, { statementState: 'NOT_PAID' }))
})

test('paid statement history opens on demand, filters and pages on the server, and keeps return context', async () => {
  HTMLDialogElement.prototype.showModal = function () { this.open = true }
  HTMLDialogElement.prototype.close = function () { this.open = false }
  vi.mocked(finance.listTransactions).mockImplementation(async (_tab, _page, filters) => filters?.statementState === 'PAID'
    ? { items: [{ id: 'paid-1', reference: 'SAMPLE-PAID-1', state: 'PAID', period_start: '2026-10-01', issued_on: '2026-11-02', paid_centavos: 5120 }], total: 30, hasMore: true }
    : { items: [{ id: 'due-1', reference: 'SAMPLE-DUE-1', state: 'ISSUED', period_start: '2026-10-01', due_on: '2026-11-15', outstanding_centavos: 5120 }], total: 1, hasMore: false })
  at('/finance/commissions', <VendorCommissionPage />)
  const panel = within(await screen.findByRole('region', { name: 'Commission statements' }))
  expect(await panel.findByRole('link', { name: /SAMPLE-DUE-1/ })).toBeVisible()
  expect(panel.queryByRole('button', { name: 'All dates' })).not.toBeInTheDocument()
  expect(finance.listTransactions).not.toHaveBeenCalledWith('STATEMENTS', expect.anything(), expect.objectContaining({ statementState: 'PAID' }))
  fireEvent.click(panel.getByRole('button', { name: 'History' }))
  const history = within(await screen.findByRole('dialog', { name: 'Commission statement history' }))
  expect(await history.findByRole('link', { name: 'SAMPLE-PAID-1' })).toHaveAttribute('href', '/finance/statements/paid-1?statement_history=1')
  expect(history.getByText('₱51.20')).toBeVisible()
  expect(history.queryByText('SAMPLE-DUE-1')).not.toBeInTheDocument()
  fireEvent.click(history.getByRole('button', { name: 'Next' }))
  await waitFor(() => expect(finance.listTransactions).toHaveBeenLastCalledWith('STATEMENTS', 2, { statementState: 'PAID' }))
  fireEvent.click(history.getByRole('button', { name: 'All dates' }))
  fireEvent.change(screen.getByLabelText('From'), { target: { value: '2026-11-01' } })
  fireEvent.change(screen.getByLabelText('To'), { target: { value: '2026-11-30' } })
  fireEvent.click(screen.getByRole('button', { name: 'Apply' }))
  await waitFor(() => expect(finance.listTransactions).toHaveBeenLastCalledWith('STATEMENTS', 1, { statementState: 'PAID', from: '2026-11-01', to: '2026-11-30' }))
  expect(history.getByRole('link', { name: 'SAMPLE-PAID-1' })).toHaveAttribute('href', '/finance/statements/paid-1?statement_history=1&from=2026-11-01&to=2026-11-30&date_label=Custom+range')
  expect(history.getByRole('button', { name: 'Export PDF' })).toBeVisible()
  expect(history.getByRole('button', { name: 'Export CSV' })).toBeVisible()
  fireEvent.click(history.getByRole('button', { name: 'Close commission statement history' }))
  expect(screen.queryByRole('dialog', { name: 'Commission statement history' })).not.toBeInTheDocument()
  expect(panel.getByRole('link', { name: /SAMPLE-DUE-1/ })).toBeVisible()
})

test('paid history retries a failed load and explains an empty filtered range', async () => {
  vi.mocked(finance.listTransactions).mockImplementation(async (_tab, _page, filters) => {
    if (filters?.statementState === 'PAID') throw new Error('History offline')
    return { items: [], hasMore: false, total: 0 }
  })
  at('/finance/commissions?statement_history=1&from=2026-11-01', <VendorCommissionPage />, '/finance/commissions')
  const history = within(await screen.findByRole('dialog', { name: 'Commission statement history' }))
  expect(await history.findByText('History offline')).toBeVisible()
  vi.mocked(finance.listTransactions).mockResolvedValue({ items: [], hasMore: false, total: 0 })
  fireEvent.click(history.getByRole('button', { name: 'Try again' }))
  expect(await history.findByText('No paid commission statements in these dates.')).toBeVisible()
})

test('the Tax documents tab appears only once a certificate exists', async () => {
  vi.mocked(finance.listTransactions).mockImplementation(async tab => tab === 'TAX_DOCUMENTS' ? { items: [], hasMore: false, total: 0 } : { items: [{ id: 'p1', reference: 'ORD-1', status: 'PAID', at: '2026-10-02T02:30:00Z' }], hasMore: false, total: 1 })
  at('/finance/transactions?tab=TAX_DOCUMENTS', <VendorTransactionHistoryPage />, '/finance/transactions')
  await screen.findByRole('table')
  expect(screen.queryByRole('tab', { name: /Tax documents/ })).not.toBeInTheDocument()
  expect(screen.getByRole('heading', { name: /^Payments$/ })).toBeInTheDocument()
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
  await waitFor(() => expect(finance.listTransactions).toHaveBeenLastCalledWith('PAYMENTS', 1, { ...defaultDates(),  status: 'FAILED' }))
  expect(screen.getByRole('button', { name: /Failed — not charged/ })).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Export CSV' }))
  await waitFor(() => expect(finance.exportTransactions).toHaveBeenCalledWith('PAYMENTS', { ...defaultDates(),  status: 'FAILED' }))
  fireEvent.click(screen.getByRole('tab', { name: 'Tax documents' }))
  await waitFor(() => expect(finance.listTransactions).toHaveBeenLastCalledWith('TAX_DOCUMENTS', 1, defaultDates()))
  expect(screen.queryByRole('combobox', { name: 'Status' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('tab', { name: /^Payments/ }))
  await waitFor(() => expect(finance.listTransactions).toHaveBeenLastCalledWith('PAYMENTS', 1, defaultDates()))
  expect(screen.getByRole('combobox', { name: 'Status' })).toHaveValue('')
})

test('historical unlinked assessments remain in Payments without claiming a verified payment or current cash', async () => {
  vi.mocked(finance.listTransactions).mockImplementation(async tab => ({ items: tab === 'PAYMENTS' ? [
    { id: 'legacy', kind: 'REMITTANCE', assessment_id: 'legacy', reference: 'ORD-HISTORY', status: 'ASSESSED', gross_centavos: 100000,
      net_collected_centavos: null, refunded_centavos: null, gross_basis_centavos: 100000, withheld_centavos: 500, expected_cash_centavos: 99500, calculation_state: 'POSTED' },
  ] : [], hasMore: false, total: 1 }))
  at('/finance/transactions', <VendorTransactionHistoryPage />)
  const table = await screen.findByRole('table', { name: 'Payments' })
  expect(table).toHaveTextContent('Assessment recorded')
  expect(table).toHaveTextContent('Historical assessment without a linked payment')
  expect(table).toHaveTextContent('Historical assessment')
  expect(table).not.toHaveTextContent('₱995.00')
  expect(table).not.toHaveTextContent('Paid — verified by provider')
  expect(table).not.toHaveTextContent('Online payment')
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
  expect(cells[1]).toHaveTextContent('₱100.00')
  expect(cells[2]).toHaveTextContent(refunded > 0 ? `-₱${(refunded / 100).toFixed(2)}` : '₱0.00')
  expect(cells[2]).not.toHaveTextContent('-₱0.00')
  expect(cells[3]).toHaveTextContent(net)
})

test('Payments lists Cash on Delivery and In-Store orders beside online payments, with what is still owed', async () => {
  vi.mocked(finance.listTransactions).mockResolvedValue({ items: [
    { id: 'o1', kind: 'PHYSICAL', order_id: 'order-cod', reference: 'ORD-COD', purpose: 'CASH_ON_DELIVERY', status: 'PHYSICAL_TO_RECORD', refund_state: 'NOT_REQUESTED', gross_centavos: 2905250, buyer_processing_fee_centavos: 0,
      refunded_centavos: 0, net_collected_centavos: 0, collected_centavos: 0, remaining_centavos: 2905250, channel: 'CASH_ON_DELIVERY', evidence_origin: 'VENDOR_RECORD', at: '2026-10-20T02:30:00Z' },
    { id: 'o2', kind: 'PHYSICAL', reference: 'ORD-STORE', purpose: 'IN_STORE_PAYMENT', status: 'PHYSICAL_COLLECTED', refund_state: 'NOT_REQUESTED', gross_centavos: 100000, buyer_processing_fee_centavos: 0,
      refunded_centavos: 0, net_collected_centavos: 100000, collected_centavos: 100000, remaining_centavos: 0, channel: 'IN_STORE', evidence_origin: 'VENDOR_RECORD', at: '2026-10-19T02:30:00Z' },
    { id: 'p1', kind: 'ONLINE', order_id: 'order-online', reference: 'ORD-ONLINE', purpose: 'FULL_ORDER_PAYMENT', status: 'PAID', refund_state: 'NOT_REQUESTED', gross_centavos: 28550, buyer_processing_fee_centavos: 755,
      refunded_centavos: 0, net_collected_centavos: 28550, evidence_origin: 'XENDIT_TEST', at: '2026-10-18T02:30:00Z' },
    { id: 'released', kind: 'PHYSICAL', reference: 'ORD-CANCELLED', purpose: 'CASH_ON_DELIVERY', status: 'PHYSICAL_RELEASED', gross_centavos: 117360,
      net_collected_centavos: 0, remaining_centavos: 117360, channel: 'CASH_ON_DELIVERY', evidence_origin: 'VENDOR_RECORD' },
  ], hasMore: false, total: 4 })
  at('/finance/transactions', <VendorTransactionHistoryPage />)
  const rows = within(await screen.findByRole('table')).getAllByRole('row')
  expect(screen.getByRole('link', { name: 'ORD-COD' })).toHaveAttribute('href', '/orders/order-cod')
  expect(screen.getByRole('link', { name: 'ORD-ONLINE' })).toHaveAttribute('href', '/orders/order-online')
  expect(rows[1]).toHaveTextContent('Cash on Delivery'); expect(rows[1]).toHaveTextContent('Handed over — cash not recorded'); expect(rows[1]).toHaveTextContent('₱29,052.50 still owed'); expect(rows[1]).toHaveTextContent('COD · Vendor record')
  expect(rows[2]).toHaveTextContent('Collected — Vendor record'); expect(rows[2]).toHaveTextContent('In-Store · Vendor record'); expect(rows[2]).not.toHaveTextContent('still owed')
  expect(rows[3]).toHaveTextContent('Paid — verified by provider')
  expect(rows[3]).not.toHaveTextContent('E-wallet transaction fee')
  expect(rows[3]).toHaveTextContent('₱285.50')
  expect(rows[3]).not.toHaveTextContent('₱293.05')
  expect(rows[3]).not.toHaveTextContent('-₱7.55')
  expect(rows[1]).toHaveClass('mp-finance-payment-physical')
  expect(within(rows[1]!).getByText('Physical payment')).toBeInTheDocument()
  expect(rows[3]).toHaveClass('mp-finance-payment-online')
  expect(within(rows[3]!).getByText('Online payment')).toBeInTheDocument()
  expect(rows[4]).toHaveTextContent('No longer due')
  expect(rows[4]).not.toHaveTextContent('still owed')
  expect(rows[4]).toHaveTextContent('₱1,173.60')
  fireEvent.change(screen.getByRole('combobox', { name: 'Status' }), { target: { value: 'PHYSICAL_TO_RECORD' } })
  await waitFor(() => expect(finance.listTransactions).toHaveBeenLastCalledWith('PAYMENTS', 1, { ...defaultDates(),  status: 'PHYSICAL_TO_RECORD' }))
})

test('Payments keeps remittance and tax beside each payment and preserves voided and unavailable assessment history', async () => {
  vi.mocked(finance.listTransactions).mockImplementation(async tab => tab === 'PAYMENTS' ? { items: [
    { id: 'p1', kind: 'ONLINE', status: 'PAID', assessment_id: 'r1', order_id: 'order-1', reference: 'ORD-REMIT', gross_centavos: 28550, net_collected_centavos: 27550, refunded_centavos: 1000, assessment_collected_centavos: 29305, assessment_refunds_centavos: 0, provider_charge_centavos: 755, withheld_centavos: 127,
      assessment_delivery_centavos: 1000, assessment_vat_centavos: 2059, assessment_rate_basis_points: 50,
      gross_basis_centavos: 25491, expected_cash_centavos: 28423, order_after_refunds_centavos: 27550, net_remittance_centavos: 27423, threshold_status_after: 'SUBJECT_STANDARD', calculation_state: 'POSTED', deduction_evidence_state: 'SIMULATED_WITHHELD' },
    { id: 'p2', kind: 'ONLINE', status: 'PAID', refund_state: 'REFUNDED', assessment_id: 'r2', reference: 'ORD-VOID', gross_centavos: 236000, refunded_centavos: 236000, net_collected_centavos: 0, assessment_collected_centavos: 242241, assessment_refunds_centavos: 0, provider_charge_centavos: 6241, withheld_centavos: 765,
      gross_basis_centavos: 152946, expected_cash_centavos: 235235, order_after_refunds_centavos: 0, net_remittance_centavos: null, calculation_state: 'VOIDED', deduction_evidence_state: 'SIMULATED_WITHHELD' },
    { id: 'p3', kind: 'ONLINE', status: 'PAID', assessment_id: 'r3', reference: 'ORD-REVIEW', gross_centavos: 10000, assessment_collected_centavos: 10000, provider_charge_centavos: 0, withheld_centavos: 0,
      gross_basis_centavos: 0, expected_cash_centavos: null, order_after_refunds_centavos: 10000, net_remittance_centavos: null, calculation_state: 'BASE_REVIEW_REQUIRED', deduction_evidence_state: 'UNCONFIRMED' },
  ], hasMore: false, total: 3 } : { items: [], hasMore: false, total: 0 })
  at('/finance/transactions?tab=REMITTANCES', <VendorTransactionHistoryPage />, '/finance/transactions')
  const table = await screen.findByRole('table', { name: 'Payments' })
  const rows = within(table).getAllByRole('row')
  expect(screen.getByRole('link', { name: 'ORD-REMIT' })).toHaveAttribute('href', '/orders/order-1')
  expect(rows[1]).toHaveTextContent('Withholding tax-₱1.27')
  expect(rows[1]).toHaveTextContent('Order after refunds₱275.50')
  expect(rows[1]).toHaveTextContent('Net remittance₱274.23')
  expect(rows[1]).not.toHaveTextContent('₱284.23')
  expect(rows[1]).toHaveTextContent('₱274.23')
  expect(rows[1]).not.toHaveTextContent('Tax basis')
  expect(rows[1]).not.toHaveTextContent('₱254.91')
  expect(within(rows[1]!).getAllByRole('button')).toHaveLength(1)
  expect(within(table).queryByRole('button', { name: /How this is calculated/ })).not.toBeInTheDocument()
  expect(rows[2]).not.toHaveTextContent('₱2,352.35')
  expect(rows[2]).toHaveTextContent('Voided — fully refunded')
  expect(rows[3]).toHaveTextContent('Calculation needs review')
  expect(within(rows[3]!).getAllByRole('cell').at(-1)).toHaveTextContent('—')
  expect(rows[3]).not.toHaveTextContent('-₱0.00')
  const taxHelp = within(rows[1]!).getByRole('button', { name: 'View breakdown: Tax basis · ORD-REMIT' })
  fireEvent.click(taxHelp)
  const taxExplanation = screen.getByRole('dialog', { name: 'Tax basis · ORD-REMIT' })
  expect(taxExplanation).toHaveTextContent('recorded portion of this payment used to calculate withholding tax')
  const basis = within(taxExplanation).getByRole('table', { name: 'Tax basis calculation' })
  expect(basis).toHaveTextContent('Payment received₱293.05')
  expect(taxExplanation).not.toHaveTextContent(/Buyer-paid processing fee|Buyer fee/)
  expect(basis).toHaveTextContent('Refunds before assessment₱0.00')
  expect(basis).toHaveTextContent('Separately billed delivery-₱10.00')
  expect(basis).toHaveTextContent('Included material VAT-₱20.59')
  expect(basis).toHaveTextContent('Payment provider charge-₱7.55')
  expect(basis).toHaveTextContent('Tax basis₱254.91')
  expect(basis).not.toHaveTextContent('-₱0.00')
  expect(basis).not.toHaveTextContent('₱275.50')
  expect(taxExplanation).toHaveTextContent('× Applied rate0.5%')
  expect(taxExplanation).toHaveTextContent('Withholding tax₱1.27')
  expect(taxExplanation).toHaveTextContent('0.5%')
  expect(taxExplanation).toHaveTextContent('Later refunds do not recalculate the posted basis')
  expect(taxExplanation).toHaveTextContent('Commission is billed separately')
  fireEvent.keyDown(document, { key: 'Escape' })
  expect(taxHelp).toHaveFocus()
  fireEvent.click(within(rows[2]!).getByRole('button', { name: 'View breakdown: Remittance details · ORD-VOID' }))
  expect(screen.getByRole('dialog')).toHaveTextContent('Original assessment · voided')
  expect(screen.getByRole('dialog')).toHaveTextContent('₱2,352.35')
})

test.each([
  { state: 'POSTED', rate: 0, delivery: 0, vat: 0, withheld: 0, status: 'RELIEF_ACTIVE', expected: '× Applied rate0%', missing: false },
  { state: 'POSTED', rate: null, delivery: null, vat: null, withheld: 50, status: 'SUBJECT_STANDARD', expected: 'The original effective rate is unavailable', missing: true },
  { state: 'BASE_REVIEW_REQUIRED', rate: 0, delivery: 0, vat: 0, withheld: 0, status: 'UNDER_REVIEW', expected: 'These original amounts are not a finalized withholding calculation', missing: false },
])('Tax basis preserves recorded relief, missing values and review state: $status', async ({ state, rate, delivery, vat, withheld, status, expected, missing }) => {
  vi.mocked(finance.listTransactions).mockResolvedValue({ items: [
    { id: 'tax-case', kind: 'ONLINE', reference: 'ORD-TAX-CASE', status: 'PAID', assessment_id: 'assessment', calculation_state: state,
      assessment_collected_centavos: 10000, assessment_refunds_centavos: 0, assessment_delivery_centavos: delivery, assessment_vat_centavos: vat,
      assessment_rate_basis_points: rate, provider_charge_centavos: 0, gross_basis_centavos: 10000, withheld_centavos: withheld, threshold_status_after: status,
      order_after_refunds_centavos: 10000, net_remittance_centavos: state === 'POSTED' ? 10000 - withheld : null },
  ], hasMore: false, total: 1 })
  at('/finance/transactions', <VendorTransactionHistoryPage />)
  fireEvent.click(await screen.findByRole('button', { name: 'View breakdown: Tax basis · ORD-TAX-CASE' }))
  const dialog = screen.getByRole('dialog', { name: 'Tax basis · ORD-TAX-CASE' })
  expect(dialog).toHaveTextContent(expected)
  expect(dialog).not.toHaveTextContent('-₱0.00')
  if (missing) {
    expect(dialog).toHaveTextContent('missing amounts are not treated as zero')
    expect(within(dialog).getByRole('row', { name: 'Separately billed delivery —' })).toBeInTheDocument()
  }
  if (state !== 'POSTED') expect(dialog).not.toHaveTextContent('× Applied rate')
})

test('a fully refunded payment retains posted tax history without showing an active withholding deduction or net remittance', async () => {
  vi.mocked(finance.listTransactions).mockImplementation(async tab => ({ items: tab === 'PAYMENTS' ? [
    { id: 'refunded', kind: 'ONLINE', status: 'PAID', refund_state: 'REFUNDED', assessment_id: 'posted', reference: 'ORD-REFUNDED',
      order_after_refunds_centavos: 0, net_remittance_centavos: 0, withheld_centavos: 127, gross_basis_centavos: 25491,
      expected_cash_centavos: 28423, calculation_state: 'POSTED' },
  ] : [], hasMore: false, total: 1 }))
  at('/finance/transactions', <VendorTransactionHistoryPage />)
  const table = await screen.findByRole('table', { name: 'Payments' })
  expect(table).toHaveTextContent('Fully refunded · Tax record retained')
  expect(table).not.toHaveTextContent('-₱1.27')
  expect(table).not.toHaveTextContent('Net remittance')
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

test('settled statement details use a compact signed breakdown and return to commission monitoring', async () => {
  vi.mocked(finance.getStatement).mockResolvedValue({ ...statement, state: 'PAID', outstandingCentavos: 0, paidCentavos: 19000, creditsCentavos: 1000, lines: [...statement.lines, { type: 'CREDIT_TRANSFER', amount_centavos: 1000, description: 'Approved commission credit' }] })
  at('/finance/statements/s1?statement_page=2', <VendorStatementPage />, '/finance/statements/:statementId')
  expect(await screen.findByText('Statement settled. No payment is due.')).toBeInTheDocument()
  expect(screen.getByRole('link', { name: 'Commission statements' })).toHaveAttribute('href', '/finance/commissions?statement_page=2#commission-statements')
  expect(screen.queryByRole('complementary', { name: 'Pay statement' })).not.toBeInTheDocument()
  expect(within(screen.getByRole('table', { name: 'Statement breakdown' })).getByText('-₱10.00')).toBeInTheDocument()
  expect(screen.getByText('Amount due')).toBeInTheDocument()
})

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
    breakdown: { sales: { orders: 2, materialsBeforeDiscountCentavos: 950000, vendorDiscountsCentavos: 50000, materialsAfterDiscountCentavos: 900000, deliveryCentavos: 100000, refundsCentavos: 0 },
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

test('the Earnings URL reuses the combined overview with visible calculations and charts', async () => {
  vi.mocked(finance.getEarnings).mockResolvedValue(earnings())
  at('/finance/earnings', <VendorEarningsPage />)
  expect(await screen.findByRole('heading', { name: 'Earnings', level: 1 })).toBeInTheDocument()
  expect(screen.queryByText('TEST dataset — DEMO figures')).not.toBeInTheDocument()
  expect(screen.queryByText(/Demo aggregates are TEST-only/)).not.toBeInTheDocument()
  expect((await screen.findAllByText('₱10,000.00')).length).toBeGreaterThan(0)
  expect(screen.getByRole('link', { name: 'View statements' })).toHaveAttribute('href', '/finance/commissions#commission-statements')
  expect(screen.queryByText('View financial calculations')).not.toBeInTheDocument()
  expect(screen.queryByLabelText(/Chart details for/)).not.toBeInTheDocument()
  for (const name of ['Sales and collections', 'Financial calculations', 'Deductions and commission', 'Deductions and fees']) expect(screen.getByRole('region', { name })).toBeInTheDocument()
  expect(screen.queryByRole('region', { name: 'Xendit cash revenue' })).not.toBeInTheDocument()
  expect(screen.getByRole('img', { name: /Earnings and collections: Earnings and Online collections and Physical collections over 3 periods/ })).toBeInTheDocument()
  expect(screen.getByText(/Charted by day · Oct 8 – Oct 10/)).toBeInTheDocument()
  const summaryHeader = screen.getByRole('heading', { name: 'Sales overview' }).parentElement!
  expect(within(summaryHeader).getByText('Oct 8 – Oct 10', { exact: true })).toBeVisible()
  expect(within(summaryHeader).queryByText('Selected dates · Asia/Manila')).not.toBeInTheDocument()
  expect(screen.getAllByText(/vs previous/).length).toBeGreaterThan(0)
  const sales = within(screen.getByRole('region', { name: 'Sales and collections' }))
  expect(sales.getByRole('table', { name: 'Sales and collections per day' })).toHaveTextContent('Oct 9₱10,000.00₱10,000.00₱0.00')
  expect(within(screen.getByRole('region', { name: 'Deductions and commission' })).getByRole('img')).toBeInTheDocument()
  expect(screen.getByText('Collections by method').nextElementSibling).toHaveTextContent('Online collections₱10,000.00 · 100.0%')
})

test('partial refunds reconcile product values to earnings and financial labels use plain full names', async () => {
  const data = earnings()
  data.commercialSalesCentavos = 975000
  data.breakdown.sales.refundsCentavos = 25000
  vi.mocked(finance.getEarnings).mockResolvedValue(data)
  at('/finance', <VendorFinancePage />)
  const sales = within(await screen.findByRole('table', { name: 'Earnings calculation' }))
  expect(sales.getByRole('row', { name: /^Completed refunds/ })).toHaveTextContent('-₱250.00')
  expect(sales.getByRole('row', { name: /^Earnings/ })).toHaveTextContent('₱9,750.00')
  const products = within(screen.getByLabelText('Product sales value reconciliation'))
  expect(products.getByText('Less completed refunds').parentElement).toHaveTextContent('-₱250.00')
  expect(products.getByText('Equals earnings').parentElement).toHaveTextContent('₱9,750.00')
  const fees = within(screen.getByRole('region', { name: 'Deductions and fees' }))
  expect(fees.getByText('Platform commission charges')).toBeVisible()
  expect(fees.getByText('Creditable withholding tax')).toBeVisible()
  expect(screen.queryByText(/Earned commission|Simulated CWT/)).not.toBeInTheDocument()
})

test('a pending connection and unconfigured channels stay explicit in the combined overview', async () => {
  vi.mocked(finance.getFinanceOverview).mockResolvedValue(overview({
    xenditConnection: { status: 'PENDING', label: 'Connection pending reconciliation', environment: 'TEST' },
    onlineChannels: { provider_ready: false, channels: [] },
  }))
  at('/finance?section=xendit&from=2026-10-08&to=2026-10-10', <VendorFinancePage />, '/finance')
  expect(await screen.findByText('No online payment channels are configured.')).toBeInTheDocument()
  fireEvent.click(screen.getByRole('tab', { name: 'Xendit cash revenue & remittance' }))
  expect(screen.getByText('Connection pending reconciliation')).toBeInTheDocument()
  expect(await screen.findByRole('table', { name: 'Estimated remittance calculation' })).toBeVisible()
  expect(finance.getEarnings).toHaveBeenLastCalledWith({ from: '2026-10-08', to: '2026-10-10' })
})

test('the combined overview retries failed finance loading', async () => {
  vi.mocked(finance.getFinanceOverview).mockRejectedValueOnce(new Error('offline')).mockResolvedValue(overview())
  at('/finance', <VendorFinancePage />)
  expect(await screen.findByRole('alert')).toBeInTheDocument()
  expect(finance.getEarnings).not.toHaveBeenCalled()
  fireEvent.click(screen.getByRole('button', { name: 'Try again' }))
  expect(await screen.findByRole('heading', { name: 'Online payment channels' })).toBeInTheDocument()
  expect(await screen.findByRole('region', { name: 'Sales and collections' })).toBeInTheDocument()
})

test('every Earnings card shows the lines that add up to its number', async () => {
  vi.mocked(finance.getEarnings).mockResolvedValue({ ...earnings(), includedVatCentavos: 96429,
    breakdown: { sales: { orders: 2, materialsBeforeDiscountCentavos: 950000, vendorDiscountsCentavos: 50000, materialsAfterDiscountCentavos: 900000, deliveryCentavos: 100000, refundsCentavos: 0 },
      online: { payments: 3, principalPaidCentavos: 1300000, refundedPrincipalCentavos: 300000 }, physical: { records: 2, cashOnDeliveryCentavos: 40000, inStoreCentavos: 25000, unrecordedCentavos: 2905250, unrecordedOrders: 1 } },
    physicalCollectionsCentavos: 65000 })
  at('/finance/earnings', <VendorEarningsPage />)
  const sales = within(await screen.findByRole('table', { name: 'Earnings calculation' }))
  expect(sales.getByRole('row', { name: /^Materials before discounts/ })).toHaveTextContent('₱9,500.00')
  expect(sales.getByRole('row', { name: /^Vendor discounts/ })).toHaveTextContent('-₱500.00')
  expect(sales.getByRole('row', { name: /^Delivery/ })).toHaveTextContent('₱1,000.00')
  expect(sales.getByRole('row', { name: /^Earnings/ })).toHaveTextContent('₱10,000.00')
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

test('earnings reconciles product values with earnings without a duplicate ranking', async () => {
  vi.mocked(finance.getEarnings).mockResolvedValue(earnings())
  at('/finance/earnings', <VendorEarningsPage />)
  const strip = within(await screen.findByLabelText('Product sales value reconciliation'))
  expect(strip.getByText('Product sales value').closest('dt')?.nextElementSibling).toHaveTextContent('₱9,000.00')
  expect(strip.getByText('Plus delivery').closest('dt')?.nextElementSibling).toHaveTextContent('₱1,000.00')
  expect(strip.getByText('Equals earnings').closest('dt')?.nextElementSibling).toHaveTextContent('₱10,000.00')
  const table = within(screen.getByRole('table', { name: 'Product sales value' }))
  expect(table.getByRole('row', { name: /Portland Cement 40kg/ })).toHaveTextContent('Cement · SKU CEM-40')
  expect(table.getByRole('row', { name: /Portland Cement 40kg/ })).toHaveTextContent('66.7%')
  expect(table.getByRole('row', { name: /Portland Cement 40kg/ })).toHaveTextContent('₱6,000.00')
  expect(table.getByRole('row', { name: /Deformed Steel Bar 10mm/ })).toHaveTextContent('₱3,000.00')
  expect(table.getByRole('link', { name: 'Portland Cement 40kg' })).toHaveAttribute('href', '/analytics/products/l1')
  expect(screen.queryByRole('list', { name: 'Top selling products' })).not.toBeInTheDocument()
})

test('the product list says so when nothing sold and notes when it shows only the top products', async () => {
  vi.mocked(finance.getEarnings).mockResolvedValue({ ...earnings(), products: { items: [], total: 0, truncated: false } })
  const first = at('/finance/earnings', <VendorEarningsPage />)
  expect((await screen.findAllByText('No product was sold in these dates.')).length).toBe(1)
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

test('payout shows retained order payments and withholding without Buyer-fee deductions', async () => {
  vi.mocked(finance.getEarnings).mockResolvedValue({ ...earnings(), onlineCollectionsCentavos: 128475, buyerProcessingFeesCentavos: 3397,
    remittanceCollectionsCentavos: 131872, remittanceRefundsCentavos: 0, providerChargesCentavos: 3397, simulatedCwtCentavos: 381, estimatedRemittanceCashCentavos: 128094 })
  at('/finance?section=threshold', <VendorFinancePage />, '/finance')
  const breakdown = within(await screen.findByRole('table', { name: 'Estimated remittance calculation' }))
  expect(breakdown.getByRole('row', { name: /Order payments after refunds/ })).toHaveTextContent('₱1,284.75')
  expect(breakdown.queryByRole('row', { name: /^Provider charges/ })).not.toBeInTheDocument()
  expect(breakdown.queryByRole('row', { name: /E-wallet transaction/ })).not.toBeInTheDocument()
  expect(breakdown.getByRole('row', { name: /^Creditable withholding tax/ })).toHaveTextContent('-₱3.81')
  expect(breakdown.getByRole('row', { name: /^Xendit cash revenue/ })).toHaveTextContent('₱1,280.94')
  expect(breakdown.queryByRole('row', { name: /^Confirmed refunds/ })).not.toBeInTheDocument()
  expect(screen.getByRole('heading', { name: 'Xendit connection' })).toBeInTheDocument()
})

test('the Xendit card contains the summary date filter and preserves it when the period reloads', async () => {
  at('/finance?section=threshold&from=2026-10-08&to=2026-10-10', <VendorFinancePage />, '/finance')
  await screen.findByRole('table', { name: 'Estimated remittance calculation' })
  const connection = screen.getByRole('region', { name: 'Xendit connection' })
  const summary = within(connection).getByLabelText('Xendit cash revenue estimate')
  const dateButton = within(summary).getByRole('button', { name: 'Oct 8, 2026 – Oct 10, 2026' })
  expect(within(connection).getByRole('region', { name: 'Payment breakdown' })).toBeInTheDocument()
  expect(screen.getAllByRole('button', { name: 'Oct 8, 2026 – Oct 10, 2026' })).toHaveLength(1)
  expect(within(summary).getByRole('region', { name: 'At a glance' })).toHaveAttribute('data-embedded', 'true')
  fireEvent.click(dateButton)
  const dialog = within(screen.getByRole('dialog', { name: 'Earnings dates' }))
  fireEvent.click(dialog.getByRole('button', { name: 'Last 7 days' }))
  fireEvent.click(dialog.getByRole('button', { name: 'Apply' }))
  await waitFor(() => expect(finance.getEarnings).toHaveBeenLastCalledWith({ from: dateFilterPreset(7).from, to: dateFilterPreset(7).to }))
  expect(within(summary).getByRole('button', { name: 'Last 7 days' })).toBe(dateButton)
  expect(screen.getByRole('tab', { name: 'Xendit cash revenue & remittance' })).toHaveAttribute('aria-selected', 'true')
  expect(finance.getFinanceOverview).toHaveBeenCalledTimes(1)
})

test('payout omits fully refunded money and does not deduct the refunds a second time', async () => {
  vi.mocked(finance.getEarnings).mockResolvedValue({ ...earnings(), onlineCollectionsCentavos: 128475, onlineRefundsCentavos: 73272,
    remittanceCollectionsCentavos: 205144, remittanceRefundsCentavos: 73272, providerChargesCentavos: 3397, simulatedCwtCentavos: 381, estimatedRemittanceCashCentavos: 128094 })
  at('/finance?section=threshold', <VendorFinancePage />, '/finance')
  const breakdown = within(await screen.findByRole('table', { name: 'Estimated remittance calculation' }))
  expect(breakdown.getByRole('row', { name: /Order payments after refunds/ })).toHaveTextContent('₱1,284.75')
  expect(breakdown.queryByRole('row', { name: /^Confirmed refunds/ })).not.toBeInTheDocument()
  expect(screen.queryByText('₱2,051.44')).not.toBeInTheDocument()
  expect(breakdown.getByRole('row', { name: /^Xendit cash revenue/ })).toHaveTextContent('₱1,280.94')
  expect(openFigureHelp('Xendit cash revenue').getByText(/Fully refunded payments are excluded/)).toBeInTheDocument()
})

test('the breakdown uses the assessment-date components and shows confirmed partial refunds once', async () => {
  vi.mocked(finance.getEarnings).mockResolvedValue({ ...earnings(), onlineCollectionsCentavos: 600000, onlineRefundsCentavos: 400000,
    remittanceCollectionsCentavos: 100000, remittanceRefundsCentavos: 20000, providerChargesCentavos: 1000, simulatedCwtCentavos: 500, estimatedRemittanceCashCentavos: 78500 })
  at('/finance?section=threshold&from=2026-10-08&to=2026-10-10', <VendorFinancePage />, '/finance')
  const breakdown = within(await screen.findByRole('table', { name: 'Estimated remittance calculation' }))
  expect(breakdown.getByRole('row', { name: /Order payments after refunds/ })).toHaveTextContent('₱790.00')
  expect(breakdown.getByRole('row', { name: /^Xendit cash revenue/ })).toHaveTextContent('₱785.00')
  expect(openFigureHelp('Xendit cash revenue').getByText(/Uses online payment assessments in the selected dates/)).toBeInTheDocument()
})

test('earnings displays the server net collections without a refunds banner', async () => {
  vi.mocked(finance.getEarnings).mockResolvedValue({ ...earnings(), onlineCollectionsCentavos: 600000, onlineRefundsCentavos: 400000 })
  at('/finance', <VendorFinancePage />, '/finance')
  expect(await screen.findByText('Verified principal after confirmed refunds')).toBeInTheDocument()
  expect(screen.queryByText(/Refunded amounts are excluded from online collections/)).not.toBeInTheDocument()
  expect(screen.queryByRole('link', { name: 'View refunds' })).not.toBeInTheDocument()
  const online = openFigureHelp('Online collections')
  expect(online.getByText(/Refunded money is not counted as paid/)).toHaveTextContent('₱4,000.00')
  expect(online.getByText(/Refunded money is not counted as paid/)).toHaveTextContent(/Pending or failed refunds remain counted/)
  fireEvent.click(online.getByRole('button', { name: 'Close calculation explanation' }))
  fireEvent.click(screen.getByRole('tab', { name: 'Xendit cash revenue & remittance' }))
  await screen.findByRole('table', { name: 'Estimated remittance calculation' })
  const remittance = openFigureHelp('Xendit cash revenue')
  expect(remittance.getByText(/Platform commission charges are billed separately/)).toHaveTextContent(/TEST records/)
  expect(remittance.getByText(/Platform commission charges are billed separately/)).toHaveTextContent(/does not show available provider funds/)
  expect(remittance.getByText(/Uses online payment assessments/)).toHaveTextContent(/Fully refunded payments are excluded/)
})

test('each financial figure has its own explanation instead of a full-page calculation notes panel', async () => {
  at('/finance', <VendorFinancePage />)
  const summary = await screen.findByRole('region', { name: 'At a glance' })
  expect(screen.queryByRole('region', { name: 'How these figures are calculated' })).not.toBeInTheDocument()
  expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
  const figures: [HTMLElement, string, RegExp][] = [
    [summary, 'Earnings', /Earnings = materials − discounts \+ delivery − completed refunds/],
    [summary, 'Online collections', /original payment date/],
    [summary, 'Physical collections', /date received/],
    [screen.getByRole('region', { name: 'Product sales value' }), 'Product sales value', /Product sales value \+ delivery − completed refunds = earnings/],
    [screen.getByRole('region', { name: 'Deductions and fees' }), 'E-wallet transaction fees', /never store revenue/],
    [screen.getByRole('region', { name: 'Deductions and fees' }), 'Creditable withholding tax', /recorded as a tax credit for the Vendor/],
    [screen.getByRole('region', { name: 'Deductions and fees' }), 'Platform commission charges', /saved order rate applies to materials/],
  ]
  for (const [scope, title, expected] of figures) {
    const trigger = within(scope).getByRole('button', { name: `How this is calculated: ${title}` })
    trigger.focus()
    fireEvent.click(trigger)
    expect(screen.getByRole('dialog', { name: title })).toHaveTextContent(expected)
    fireEvent.keyDown(document, { key: 'Escape' })
    expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
    expect(trigger).toHaveFocus()
  }
})

test('earnings compares with the previous equal period once a start date is chosen and charts long periods by month', async () => {
  vi.mocked(finance.getEarnings).mockResolvedValue(earnings())
  const first = at('/finance/earnings?from=2026-10-08&to=2026-10-10', <VendorEarningsPage />, '/finance/earnings')
  const summary = within(await screen.findByRole('region', { name: 'At a glance' }))
  expect(summary.getByText('+25.0%')).toBeInTheDocument()
  expect(summary.getByText('vs previous 3 days')).toBeInTheDocument()
  expect(summary.getAllByText('No comparison')).toHaveLength(2)
  expect(summary.getAllByText('No previous 3 days to compare')).toHaveLength(2)
  expect(screen.getByRole('table', { name: 'Earnings calculation' })).toBeVisible()
  expect(screen.getByText(/compared with Oct 5 – Oct 7/)).toBeInTheDocument()
  first.unmount()

  vi.mocked(finance.getEarnings).mockResolvedValue(earnings({ granularity: 'MONTH', days: 120, from: new Date(2026, 5, 13), to: new Date(2026, 9, 10),
    points: [{ date: new Date(2026, 5, 1), ...figures }, { date: new Date(2026, 9, 1), ...figures, earnedCommissionCentavos: 20000 }] }))
  at('/finance/earnings', <VendorEarningsPage />)
  const deductions = within(await screen.findByRole('region', { name: 'Deductions and commission' }))
  expect(deductions.getByRole('table', { name: 'Deductions and commission per month' })).toHaveTextContent('Oct 2026')
  expect(screen.getByRole('region', { name: 'Sales and collections' })).toHaveTextContent('No sales or collections in this period.')
})

test('sales comparisons stay in the overview and the payout comparison moves with its summary', async () => {
  const data = earnings()
  data.trend.previous!.changePercent = { ...data.trend.previous!.changePercent, commercialSalesCentavos: 25, onlineCollectionsCentavos: -3.2, physicalCollectionsCentavos: 0, estimatedRemittanceCashCentavos: 12.4 }
  vi.mocked(finance.getEarnings).mockResolvedValue(data)
  at('/finance?from=2026-10-08&to=2026-10-10', <VendorFinancePage />, '/finance')
  const summary = await screen.findByRole('region', { name: 'At a glance' })
  for (const group of [summary]) {
    for (const value of ['+25.0%', '-3.2%', '0.0%']) expect(within(group).getByText(value)).toBeInTheDocument()
    expect(within(group).queryByText('+12.4%')).not.toBeInTheDocument()
    expect(within(group).getAllByText('vs previous 3 days')).toHaveLength(3)
    expect(within(group).getByText('-3.2%').closest('dd')).toHaveAttribute('data-direction', 'down')
    expect(within(group).getByText('0.0%').closest('dd')).toHaveAttribute('data-direction', 'flat')
  }
  expect(within(screen.getByLabelText('Earnings summary')).queryByText('vs previous 3 days')).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('tab', { name: 'Xendit cash revenue & remittance' }))
  expect(await screen.findByText('+12.4%')).toBeInTheDocument()
})

test('threshold panel floors the remaining allowance and states status in text, not color', () => {
  render(<ThresholdPanel data={{ ...threshold, remainingAllowanceCentavos: -500, crossedAt: null, status: 'RELIEF_ACTIVE', advisory: true, percentOfThreshold: 85, cumulativeGrossCentavos: 42500000 }} />)
  expect(screen.getByText('Remaining allowance').closest('dt')?.nextElementSibling).toHaveTextContent('₱0.00')
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
  expect(gross.getByRole('row', { name: /Assessed online payments/ })).toHaveTextContent('₱1,318.72')
  expect(gross.getByRole('row', { name: /Separately billed delivery/ })).toHaveTextContent('-₱428.25')
  expect(gross.getByRole('row', { name: /Included material VAT/ })).toHaveTextContent('-₱91.77')
  expect(gross.getByRole('row', { name: /Provider charges/ })).toHaveTextContent('-₱33.97')
  expect(gross.getByRole('row', { name: /On-platform gross toward threshold/ })).toHaveTextContent('₱764.73')
  expect(cash.getByRole('row', { name: /Creditable withholding tax/ })).toHaveTextContent('-₱3.81')
  expect(cash.getByRole('row', { name: /Estimated cash at assessment/ })).toHaveTextContent('₱1,280.94')
  expect(screen.getByText(/regardless of the Earnings date filter/)).toBeInTheDocument()
  expect(screen.getByText(/Earnings reflects later confirmed refunds/)).toBeInTheDocument()
})

test('missing declaration shows withholding and the full-width on-platform calculation without the removed annual panel', () => {
  render(<ThresholdPanel layout="overview" showDemoLabel={false} data={{ ...threshold, cumulativeGrossCentavos: 101964, localGrossCentavos: 101964,
    remainingAllowanceCentavos: 49898036, percentOfThreshold: 0, crossedAt: null, advisory: false, status: 'SUBJECT_STANDARD', reasonCode: 'NO_DECLARATION',
    calculationBreakdown: { assessedPayments: 4, paymentPrincipalCentavos: 157025, buyerProcessingFeesCentavos: 4152, collectionsCentavos: 161177, refundsCentavos: 0, deliveryCentavos: 42825, materialVatCentavos: 12236,
      providerChargesCentavos: 4152, grossBasisCentavos: 101964, withheldCentavos: 508, assessedCashCentavos: 156517,
      withholdingBreakdown: { payments: ['A', 'B', 'C', 'D'].map(id => ({ id, orderReference: `ORD-${id}`, grossBasisCentavos: 25491, rateBasisPoints: 50, withheldCentavos: 127 })), remainingPayments: 0, remainingBasisCentavos: 0, remainingWithheldCentavos: 0 } } }} paymentBreakdown={<div data-testid="payment-records">Payment source records</div>} />)
  expect(screen.getByText('Annual · 2026')).toBeInTheDocument()
  expect(screen.getByText('Full taxable year. Not affected by the date filter.')).toBeInTheDocument()
  expect(screen.getByRole('heading', { name: 'Withholding tax' })).toBeInTheDocument()
  expect(screen.getByLabelText('Total withholding tax')).toHaveTextContent('₱5.08')
  expect(screen.getByLabelText('Total withholding tax')).not.toHaveTextContent('₱5.10')
  expect(screen.queryByText('Counted toward threshold')).not.toBeInTheDocument()
  expect(screen.queryByText('Remaining to threshold')).not.toBeInTheDocument()
  expect(screen.queryByText('0.2% of annual threshold')).not.toBeInTheDocument()
  expect(screen.queryByText('₱500,000.00', { exact: true })).not.toBeInTheDocument()
  expect(screen.queryByText('Threshold not crossed.')).not.toBeInTheDocument()
  expect(screen.getByRole('note', { name: 'Tax is withheld' })).toBeInTheDocument()
  expect(document.querySelector('.mp-threshold-meter')).not.toBeInTheDocument()
  expect(screen.getByRole('note', { name: 'Why tax is withheld' })).toHaveTextContent('Tax is withheld because no approved Sworn Declaration is on record.')
  expect(screen.getByText(/A Sworn Declaration must be reviewed and approved before relief can apply/)).toBeInTheDocument()
  expect(screen.getByText(/Tax applies to the tax basis shown below, regardless of the annual total/)).toBeInTheDocument()
  expect(screen.getByRole('heading', { name: 'On-platform threshold calculation' })).toBeInTheDocument()
  expect(screen.getByText('Tax basis is the amount from online payments used to calculate withholding tax. Buyer-paid fees are excluded.')).toBeInTheDocument()
  const purpose = within(screen.getByRole('region', { name: 'On-platform threshold calculation' }))
  expect(purpose.queryByRole('heading', { name: 'Find the tax basis' })).not.toBeInTheDocument()
  expect(purpose.queryByRole('heading', { name: /^How .* is used$/ })).not.toBeInTheDocument()
  expect(purpose.queryByRole('group', { name: 'Standard withholding example' })).not.toBeInTheDocument()
  expect(purpose.queryByText(/^Withholding tax recorded/)).not.toBeInTheDocument()
  expect(screen.queryByRole('region', { name: 'Annual tax basis across platforms' })).not.toBeInTheDocument()
  expect(screen.queryByText('Why does this differ from Xendit cash revenue?')).not.toBeInTheDocument()
  const calculation = within(screen.getByRole('table', { name: 'On-platform threshold calculation' }))
  expect(calculation.getByRole('row', { name: /^Total gross threshold/ })).toHaveTextContent('₱1,019.64')
  expect(screen.queryByText(/Qualifying MateryalPH remittances/)).not.toBeInTheDocument()
  expect(screen.getByRole('table', { name: 'On-platform threshold calculation' })).not.toContainElement(screen.getByTestId('payment-records'))
  expect(screen.getByRole('region', { name: 'On-platform threshold calculation' })).not.toContainElement(screen.getByTestId('payment-records'))
  expect(calculation.getByRole('row', { name: /^Online payments/ })).toHaveTextContent('₱1,570.25')
  expect(calculation.queryByRole('row', { name: /Provider charges/ })).not.toBeInTheDocument()
  expect(calculation.getByRole('row', { name: /^Delivery/ })).toHaveTextContent('-₱428.25')
  expect(calculation.getByRole('row', { name: /^Material VAT/ })).toHaveTextContent('-₱122.36')
  expect(calculation.queryByRole('row', { name: /Refunds/ })).not.toBeInTheDocument()
  expect(screen.queryByRole('table', { name: 'Remittance cash for these assessments' })).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'How this is calculated: Earnings and annual remittances' })).not.toBeInTheDocument()
  const help = screen.getByRole('button', { name: 'How this is calculated: On-platform threshold calculation' })
  fireEvent.click(help)
  const dialog = within(screen.getByRole('dialog', { name: 'On-platform threshold calculation' }))
  expect(dialog.getByText(/Online payments - delivery - material VAT = tax basis/)).toBeInTheDocument()
  expect(dialog.getByText(/Later refunds do not rewrite posted tax assessments/)).toBeInTheDocument()
  fireEvent.keyDown(document, { key: 'Escape' })
  expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
  expect(help).toHaveFocus()
  const taxHelp = screen.getByRole('button', { name: 'How this is calculated: Total withholding tax' })
  fireEvent.click(taxHelp)
  const taxDialog = within(screen.getByRole('dialog', { name: 'Total withholding tax' }))
  expect(taxDialog.getAllByText('₱254.91 tax basis × 0.5% · Rounded per payment')).toHaveLength(4)
  expect(taxDialog.getAllByText('₱1.27')).toHaveLength(4)
  expect(taxDialog.getByRole('row', { name: /^Total withholding tax/ })).toHaveTextContent('₱5.08')
  expect(taxDialog.queryByText('₱5.10')).not.toBeInTheDocument()
  fireEvent.keyDown(document, { key: 'Escape' })
  expect(taxHelp).toHaveFocus()
})

test.each(['RELIEF_ACTIVE', 'SUBJECT_STANDARD'])('on-platform calculation keeps its recorded basis separate from outside-platform totals for %s', (status) => {
  render(<ThresholdPanel layout="overview" hasApprovedDeclaration={status === 'RELIEF_ACTIVE'} data={{ ...threshold, status,
    cumulativeGrossCentavos: 93973, localGrossCentavos: 76473, externalDeclaredCentavos: 20000, externalOverlapCentavos: 2500,
    crossedAt: null, reasonCode: status === 'RELIEF_ACTIVE' ? 'RELIEF_VALID' : 'NO_DECLARATION',
    calculationBreakdown: { collectionsCentavos: 205144, refundsCentavos: 73272, deliveryCentavos: 42825, materialVatCentavos: 9177,
      providerChargesCentavos: 3397, grossBasisCentavos: 76473, withheldCentavos: 381, assessedCashCentavos: 128094 } }} />)
  const calculation = within(screen.getByRole('table', { name: 'On-platform threshold calculation' }))
  expect(calculation.getByRole('row', { name: /^Online payments/ })).toHaveTextContent('₱1,284.75')
  expect(calculation.getByRole('row', { name: /^Delivery/ })).toHaveTextContent('-₱428.25')
  expect(calculation.getByRole('row', { name: /^Material VAT/ })).toHaveTextContent('-₱91.77')
  expect(calculation.getByRole('row', { name: /^Total gross threshold/ })).toHaveTextContent('₱764.73')
  expect(screen.queryByRole('region', { name: 'Annual tax basis across platforms' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'How this is calculated: On-platform threshold calculation' }))
  expect(screen.getByRole('dialog', { name: 'On-platform threshold calculation' })).toHaveTextContent('Online payments - delivery - material VAT = tax basis.')
  expect(screen.getByRole('dialog', { name: 'On-platform threshold calculation' })).toHaveTextContent('Later refunds do not rewrite posted tax assessments')
})

test('approved relief retains the threshold total without the removed withholding details', () => {
  render(<ThresholdPanel layout="overview" hasApprovedDeclaration data={{ ...threshold, status: 'RELIEF_ACTIVE', reasonCode: 'RELIEF_VALID',
    crossedAt: null, cumulativeGrossCentavos: 100000, localGrossCentavos: 100000, remainingAllowanceCentavos: 49900000,
    calculationBreakdown: { collectionsCentavos: 112000, refundsCentavos: 0, deliveryCentavos: 0, materialVatCentavos: 12000,
      providerChargesCentavos: 0, grossBasisCentavos: 100000, withheldCentavos: 0, assessedCashCentavos: 112000,
      withholdingBreakdown: { payments: [{ id: 'relief', orderReference: 'ORD-RELIEF', grossBasisCentavos: 100000, rateBasisPoints: 0, withheldCentavos: 0 }], remainingPayments: 0, remainingBasisCentavos: 0, remainingWithheldCentavos: 0 } } }} />)
  expect(screen.getByText('Relief active — no withholding')).toBeInTheDocument()
  const calculation = within(screen.getByRole('table', { name: 'On-platform threshold calculation' }))
  expect(calculation.getByRole('row', { name: /^Total gross threshold/ })).toHaveTextContent('₱1,000.00')
  expect(screen.getByLabelText('Total withholding tax')).toHaveTextContent('₱0.00')
  expect(screen.queryByRole('group', { name: 'Standard withholding example' })).not.toBeInTheDocument()
  expect(screen.queryByText(/^Withholding tax recorded/)).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'How this is calculated: Total withholding tax' }))
  const taxDialog = within(screen.getByRole('dialog', { name: 'Total withholding tax' }))
  expect(taxDialog.getByText('₱1,000.00 tax basis × 0% · Rounded per payment')).toBeInTheDocument()
  expect(taxDialog.getByRole('row', { name: /^Total withholding tax/ })).toHaveTextContent('₱0.00')
})

test.each([0, 42500000])('missing declaration keeps the allowance and advisory hidden at %i centavos without a calculation', (cumulativeGrossCentavos) => {
  render(<ThresholdPanel layout="overview" data={{ ...threshold, status: 'SUBJECT_STANDARD', reasonCode: 'NO_DECLARATION', crossedAt: null,
    cumulativeGrossCentavos, localGrossCentavos: cumulativeGrossCentavos, advisory: cumulativeGrossCentavos >= 40000000, calculationBreakdown: null }} />)
  expect(screen.getByRole('note', { name: 'Tax is withheld' })).toBeInTheDocument()
  expect(screen.getByRole('note', { name: 'Why tax is withheld' })).toBeInTheDocument()
  expect(screen.queryByText('Remaining to threshold')).not.toBeInTheDocument()
  expect(screen.queryByText(/of annual threshold|80% of the threshold reached|Threshold not crossed/)).not.toBeInTheDocument()
  expect(screen.queryByRole('table')).not.toBeInTheDocument()
  expect(screen.queryByRole('region', { name: 'On-platform threshold calculation' })).not.toBeInTheDocument()
  expect(screen.getByLabelText('Total withholding tax')).toHaveTextContent('—')
  expect(screen.getByLabelText('Total withholding tax')).toHaveTextContent('Recorded total unavailable')
  expect(screen.getByLabelText('Total withholding tax')).not.toHaveTextContent('₱0.00')
  expect(screen.queryByRole('button', { name: 'How this is calculated: Annual remittance total' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'How this is calculated: Total withholding tax' }))
  expect(screen.getByRole('dialog', { name: 'Total withholding tax' })).toHaveTextContent('Payment calculation details are unavailable.')
  expect(screen.queryByRole('table')).not.toBeInTheDocument()
})

test.each([null, undefined])('withholding help keeps the recorded total when payment calculation details are %s', (withholdingBreakdown) => {
  render(<ThresholdPanel layout="overview" data={{ ...threshold, calculationBreakdown: {
    collectionsCentavos: 101964, refundsCentavos: 0, deliveryCentavos: 0, materialVatCentavos: 0, providerChargesCentavos: 0,
    grossBasisCentavos: 101964, withheldCentavos: 508, assessedCashCentavos: 101456, withholdingBreakdown,
  } }} />)
  expect(screen.getByLabelText('Total withholding tax')).toHaveTextContent('₱5.08')
  fireEvent.click(screen.getByRole('button', { name: 'How this is calculated: Total withholding tax' }))
  const dialog = within(screen.getByRole('dialog', { name: 'Total withholding tax' }))
  expect(dialog.getByText(/Payment calculation details are unavailable. The total shown is the recorded yearly withholding tax./)).toBeInTheDocument()
  expect(dialog.queryByRole('table')).not.toBeInTheDocument()
})

test('withholding help adds remaining recorded assessments without applying one rate to the yearly basis', () => {
  render(<ThresholdPanel layout="overview" data={{ ...threshold, calculationBreakdown: {
    collectionsCentavos: 300000, refundsCentavos: 0, deliveryCentavos: 0, materialVatCentavos: 0, providerChargesCentavos: 0,
    grossBasisCentavos: 300000, withheldCentavos: 1000, assessedCashCentavos: 299000,
    withholdingBreakdown: { payments: [{ id: 'own', orderReference: 'ORD-OWN', grossBasisCentavos: 100000, rateBasisPoints: 0, withheldCentavos: 0 }],
      remainingPayments: 2, remainingBasisCentavos: 200000, remainingWithheldCentavos: 1000 },
  } }} />)
  fireEvent.click(screen.getByRole('button', { name: 'How this is calculated: Total withholding tax' }))
  const dialog = within(screen.getByRole('dialog', { name: 'Total withholding tax' }))
  expect(dialog.getByRole('row', { name: /^Other assessments \(2\)/ })).toHaveTextContent('₱2,000.00 combined tax basis')
  expect(dialog.getByRole('row', { name: /^Other assessments \(2\)/ })).toHaveTextContent('₱10.00')
  expect(dialog.getByRole('row', { name: /^Total withholding tax/ })).toHaveTextContent('₱10.00')
})

test.each([
  [0, '0%'], [1, 'Less than 0.1%'], [101964, '0.2%'], [49999999, '99.9%'], [50000000, '100%'],
])('compact threshold shows precise progress for %i centavos without implying a crossing', (cumulativeGrossCentavos, label) => {
  render(<ThresholdPanel layout="overview" hasApprovedDeclaration data={{ ...threshold, cumulativeGrossCentavos, percentOfThreshold: 0, crossedAt: null, status: 'RELIEF_ACTIVE' }} />)
  expect(screen.getByText(`${label} of annual threshold`)).toBeInTheDocument()
  expect(screen.queryByRole('note', { name: 'Tax is withheld' })).not.toBeInTheDocument()
  expect(document.querySelector('.mp-threshold-meter > span')).toHaveStyle({ width: `${cumulativeGrossCentavos / threshold.thresholdCentavos * 100}%` })
  expect(screen.getByText('Threshold not crossed.')).toBeInTheDocument()
  expect(screen.queryByText(/Tax is withheld because no approved Sworn Declaration/)).not.toBeInTheDocument()
})

test.each(['SUBJECT_THRESHOLD_BREACHED', 'SUBJECT_PRIOR_YEAR', 'UNDER_REVIEW'])('no approved declaration hides the allowance for %s while keeping its recorded reason', (status) => {
  render(<ThresholdPanel layout="overview" hasApprovedDeclaration={false} data={{ ...threshold, status,
    crossedAt: status === 'SUBJECT_THRESHOLD_BREACHED' ? threshold.crossedAt : null }} />)
  expect(screen.getByRole('heading', { name: 'Withholding tax' })).toBeInTheDocument()
  expect(screen.getByRole('note', { name: 'Tax is withheld' })).toBeInTheDocument()
  expect(screen.queryByText('Remaining to threshold')).not.toBeInTheDocument()
  expect(screen.queryByText('₱500,000.00', { exact: true })).not.toBeInTheDocument()
  expect(screen.queryByText(/of annual threshold/)).not.toBeInTheDocument()
  expect(screen.queryByText(/Tax is withheld because no approved Sworn Declaration/)).not.toBeInTheDocument()
  if (status === 'SUBJECT_THRESHOLD_BREACHED') expect(screen.getByText(/Threshold crossed on/)).toBeInTheDocument()
})

test('compact threshold uses the recorded reason and does not blame a missing declaration for other standard treatment', () => {
  render(<ThresholdPanel layout="overview" data={{ ...threshold, status: 'SUBJECT_STANDARD', reasonCode: 'RELIEF_NOT_IN_PERIOD', crossedAt: null }} />)
  expect(screen.getByText(/Being below the threshold does not automatically grant relief/)).toBeInTheDocument()
  expect(screen.getByRole('note', { name: 'Tax is withheld' })).toBeInTheDocument()
  expect(screen.queryByText(/Tax is withheld because no approved Sworn Declaration/)).not.toBeInTheDocument()
})

test.each([
  ['RELIEF_ACTIVE', 'Approved relief applies'], ['SUBJECT_PRIOR_YEAR', 'The prior year exceeded'],
  ['UNDER_REVIEW', 'Standard withholding applies while the review is pending'], ['NOT_STARTED', 'No remittance assessment is recorded'],
])('compact threshold retains the %s explanation without a calculation breakdown', (status, explanation) => {
  render(<ThresholdPanel layout="overview" data={{ ...threshold, status, crossedAt: null, calculationBreakdown: null }} />)
  expect(screen.getByText(new RegExp(explanation))).toBeInTheDocument()
  expect(screen.queryByRole('note', { name: 'Tax is withheld' }) !== null).toBe(['SUBJECT_PRIOR_YEAR', 'UNDER_REVIEW'].includes(status))
  expect(screen.queryByText(/Tax is withheld because no approved Sworn Declaration/)).not.toBeInTheDocument()
  expect(screen.queryByRole('table')).not.toBeInTheDocument()
  expect(screen.queryByRole('region', { name: 'Annual tax basis across platforms' })).not.toBeInTheDocument()
})

test('compact threshold keeps its recorded crossing treatment after the outside-platform panel is removed', () => {
  render(<ThresholdPanel layout="overview" data={{ ...threshold, cumulativeGrossCentavos: 50100000, localGrossCentavos: 50000000,
    externalDeclaredCentavos: 200000, externalOverlapCentavos: 100000, externalOverlapState: 'UNRESOLVED', priorYearTotalCentavos: 61000000 }} />)
  expect(screen.queryByText('Already counted')).not.toBeInTheDocument()
  expect(screen.queryByRole('region', { name: 'Annual tax basis across platforms' })).not.toBeInTheDocument()
  expect(screen.getByText(/Refunds or later declarations do not restore relief/)).toBeInTheDocument()
  expect(screen.getByRole('note', { name: 'Tax is withheld' })).toBeInTheDocument()
  expect(screen.queryByText(/Tax is withheld because no approved Sworn Declaration/)).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'How this is calculated: Annual remittance total' })).not.toBeInTheDocument()
})

test('Finance overview shows financial content directly and preserves dates across the single navigation row', async () => {
  vi.mocked(finance.getFinanceOverview).mockResolvedValue(overview())
  vi.mocked(finance.getEarnings).mockResolvedValue(earnings())
  at('/finance?from=2026-10-08&to=2026-10-10', <VendorFinancePage />, '/finance')
  const overviewTab = await screen.findByRole('tab', { name: 'Finance overview' })
  expect(overviewTab).toHaveAttribute('aria-selected', 'true')
  expect(screen.queryByRole('tablist', { name: 'Workspace sections' })).not.toBeInTheDocument()
  expect(screen.queryByRole('tab', { name: 'Earnings' })).not.toBeInTheDocument()
  expect(screen.queryByRole('tab', { name: 'Finance reviews' })).not.toBeInTheDocument()
  expect(screen.queryByRole('link', { name: /^Earnings$/ })).not.toBeInTheDocument()
  expect(screen.queryByText('MateryalPH holds no wallet or balance for your store.')).not.toBeInTheDocument()
  expect(await screen.findByRole('region', { name: 'Sales and collections' })).toBeInTheDocument()
  expect(screen.queryByRole('heading', { name: 'Earnings', level: 2 })).not.toBeInTheDocument()
  await waitFor(() => expect(finance.getEarnings).toHaveBeenCalledTimes(1))
  expect(finance.getEarnings).toHaveBeenLastCalledWith({ from: '2026-10-08', to: '2026-10-10' })
  expect(screen.getByRole('button', { name: 'Export PDF' })).toBeEnabled()
  expect(screen.getByRole('button', { name: 'Oct 8, 2026 – Oct 10, 2026' })).toBeInTheDocument()
  expect(screen.queryByRole('heading', { name: 'Xendit connection', level: 2 })).not.toBeInTheDocument()
  expect(screen.getByRole('heading', { name: 'Online payment channels' })).toBeInTheDocument()
  expect(screen.queryByRole('tab', { name: 'Xendit & payment channels' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('tab', { name: 'Xendit cash revenue & remittance' }))
  expect(screen.queryByRole('button', { name: 'Export PDF' })).not.toBeInTheDocument()
  expect(await screen.findByRole('table', { name: 'Estimated remittance calculation' })).toBeInTheDocument()
  expect(screen.getByRole('heading', { name: 'Xendit connection' })).toBeInTheDocument()
  fireEvent.click(screen.getByRole('tab', { name: 'Finance overview' }))
  expect(await screen.findByRole('region', { name: 'Sales and collections' })).toBeInTheDocument()
  expect(finance.getEarnings).toHaveBeenLastCalledWith({ from: '2026-10-08', to: '2026-10-10' })
})
test('Finance overview does not request Earnings without its permission', async () => {
  vi.mocked(onboarding.getVendorOnboarding).mockResolvedValue(snapshot(['portal.wallet']))
  vi.mocked(finance.getFinanceOverview).mockResolvedValue(overview())
  at('/finance', <VendorFinancePage />)
  await screen.findByRole('heading', { name: 'Finance overview', level: 1 })
  expect(screen.queryByRole('tab', { name: 'Earnings' })).not.toBeInTheDocument()
  expect(screen.getByRole('tab', { name: 'Finance overview' })).toHaveAttribute('aria-selected', 'true')
  expect(screen.queryByRole('heading', { name: 'Xendit connection' })).not.toBeInTheDocument()
  expect(finance.getEarnings).not.toHaveBeenCalled()
})
