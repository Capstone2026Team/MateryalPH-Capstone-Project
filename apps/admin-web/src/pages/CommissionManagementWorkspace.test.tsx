import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import * as finance from '../lib/finance-api'
import { CommissionManagementWorkspace } from './CommissionManagementWorkspace'
import { marketplacePaymentsFixture } from '../test/marketplace-payments-fixture'

vi.mock('../lib/finance-api', async original => ({ ...await original<typeof import('../lib/finance-api')>(), listCommissionPolicies: vi.fn(), financeKpis: vi.fn(), listStatements: vi.fn(), listCommissionTransactions: vi.fn(), getCommissionStatement: vi.fn(), previewCommissionPolicy: vi.fn(), publishCommissionPolicy: vi.fn(), resendCommissionEmail: vi.fn(), resendFailedCommissionEmails: vi.fn() }))

const current: finance.CommissionPolicy = { id: 'policy-1', version: 1, commissionBasisPoints: 200, rateLabel: '2.00%', effectiveFrom: new Date('2026-01-01T00:00:00+08:00'), termsVersion: 2, termsContent: 'Current terms', status: 'CURRENT' }
const bill = { id: 'bill-1', vendor_name: 'Test Supply', reference: 'STMT-OCT-1', state: 'ISSUED', period_start: '2026-10-01', period_end: '2026-10-31', due_on: '2026-11-19', charges_centavos: 60000, credits_centavos: 10000, paid_centavos: 20000, outstanding_centavos: 30000, overdue: false, email: { total: 1, sent: 1, failed: 0, blocked: 0, queued: 0 } }
const preview: finance.CommissionPolicyPreview = { vendorCount: 2, noticeHours: 0, noticeRequired: false, exampleCommissionCentavos: 15000, monthlyBasisCentavos: 1_000_000, estimatedMonthlyChangeCentavos: -5000, volumePeriod: '2026-08-01 to 2026-10-31', currentTerms: 'Current terms', newTerms: 'Proposed terms at 1.50%', emailSubject: 'Commission rate update: 2.00% -> 1.50%', emailHtml: '<p>Rendered email from the policy service</p>' }
const empty = { items: [], hasMore: false, total: 0 }
const overdue = vi.fn()

beforeEach(() => {
  vi.clearAllMocks()
  vi.mocked(finance.listCommissionPolicies).mockResolvedValue({ policies: { current, latestVersion: 1, minNoticeDays: 30, canManage: true, canExport: true, eligibleVendorCount: 2, versions: [current] }, hasMore: false })
  vi.mocked(finance.financeKpis).mockResolvedValue(marketplacePaymentsFixture())
  vi.mocked(finance.listStatements).mockResolvedValue({ items: [bill], hasMore: false, total: 1, totals: { charges_centavos: 60000, credits_centavos: 10000, after_credits_centavos: 50000, outstanding_centavos: 30000 } })
  vi.mocked(finance.listCommissionTransactions).mockResolvedValue(empty)
  vi.mocked(finance.previewCommissionPolicy).mockResolvedValue(preview)
  vi.mocked(finance.publishCommissionPolicy).mockResolvedValue({ ...current, id: 'policy-2', version: 2, rateLabel: '1.50%', commissionBasisPoints: 150, delivery: { total: 2, sent: 0, queued: 2, failed: 0, blocked: 0 } })
  vi.mocked(finance.getCommissionStatement).mockResolvedValue({ ...bill, can_resend: true, can_export: true, lock_version: 2, issuance_origin: 'SYSTEM', issued_at: '2026-11-07T00:00:00Z', lines: { items: [], meta: {} }, payments: { items: [], meta: {} }, rate_breakdown: [{ rate_label: '2.00%', basis_centavos: 3000000, commission_centavos: 60000 }], emails: [{ id: 'email-1', type: 'STATEMENT_ISSUED', state: 'SENT', attempts: 1, created_at: '2026-11-07T00:00:00Z', sent_at: '2026-11-07T00:01:00Z' }] })
  vi.mocked(finance.resendCommissionEmail).mockResolvedValue()
  vi.mocked(finance.resendFailedCommissionEmails).mockResolvedValue()
})

function mount() { return render(<MemoryRouter><CommissionManagementWorkspace navigation={<span>Finance view</span>} overdue={false} onOverdueChange={overdue} /></MemoryRouter>) }

test('bills separate before credits, credits, after credits and amount due with filter totals', async () => {
  mount()
  const table = within(await screen.findByRole('table', { name: 'Commission statements' }))
  const row = within(table.getByRole('row', { name: /Test Supply/ }))
  expect(row.getByText('₱600.00')).toBeVisible()
  expect(row.getByText('₱100.00')).toBeVisible()
  expect(row.getByText('₱500.00')).toBeVisible()
  expect(row.getByText('₱300.00')).toBeVisible()
  expect(table.getByRole('row', { name: /Totals/ })).toHaveTextContent('₱500.00')
  expect(screen.getAllByRole('button', { name: 'Last 30 days' })).toHaveLength(1)
  expect(screen.getAllByText('TEST/DEMO billing')).toHaveLength(1)
})

test('one reporting period drives KPIs, bills and payments and keeps the search filter', async () => {
  mount()
  await screen.findByRole('table', { name: 'Commission statements' })
  fireEvent.change(screen.getByRole('searchbox'), { target: { value: 'Test Supply' } })
  fireEvent.click(screen.getByRole('button', { name: 'Last 30 days' }))
  fireEvent.change(screen.getByLabelText('From'), { target: { value: '2026-10-01' } })
  fireEvent.change(screen.getByLabelText('To'), { target: { value: '2026-10-31' } })
  fireEvent.click(screen.getByRole('button', { name: 'Apply' }))
  await waitFor(() => expect(finance.financeKpis).toHaveBeenCalledWith('2026-10-01', '2026-10-31'))
  expect(finance.listStatements).toHaveBeenLastCalledWith(1, undefined, false, expect.objectContaining({ from: '2026-10-01', to: '2026-10-31' }), 'Test Supply', undefined)
  expect(finance.listCommissionTransactions).toHaveBeenLastCalledWith(1, expect.objectContaining({ from: '2026-10-01', to: '2026-10-31' }), undefined, 'Test Supply', undefined)
  expect(screen.getByRole('searchbox')).toHaveValue('Test Supply')
})

test('the rate stepper previews authoritative impact and publishes one reviewed request', async () => {
  mount()
  fireEvent.click(await screen.findByRole('button', { name: 'Edit rate' }))
  const drawer = within(screen.getByRole('dialog'))
  fireEvent.change(drawer.getByLabelText('New commission rate (%)'), { target: { value: '1.50' } })
  fireEvent.click(drawer.getByRole('button', { name: 'Continue' }))
  fireEvent.change(drawer.getByLabelText('Internal reason'), { target: { value: 'Approved commercial rate review' } })
  fireEvent.change(drawer.getByLabelText('Vendor-facing message (optional)'), { target: { value: 'A lower rate for future transactions.' } })
  fireEvent.click(drawer.getByRole('button', { name: 'Continue' }))
  expect(await drawer.findByText('2 Vendors will be notified')).toBeVisible()
  expect(drawer.getByText(/₱150.00 commission/)).toBeVisible()
  expect(drawer.getByTitle('Commission rate email preview')).toHaveAttribute('sandbox', '')
  expect(finance.publishCommissionPolicy).not.toHaveBeenCalled()
  fireEvent.click(drawer.getByRole('button', { name: 'Continue' }))
  expect(drawer.getByRole('button', { name: 'Publish new rate' })).toBeDisabled()
  fireEvent.click(drawer.getByRole('checkbox', { name: /I reviewed the rate/ }))
  fireEvent.click(drawer.getByRole('button', { name: 'Publish new rate' }))
  await waitFor(() => expect(finance.publishCommissionPolicy).toHaveBeenCalledWith(expect.objectContaining({ commissionBasisPoints: 150, expectedVersion: 1, effectiveFrom: null, reason: 'Approved commercial rate review', vendorMessage: 'A lower rate for future transactions.', noticeOverride: false }), expect.stringMatching(/^[0-9a-f-]{36}$/)))
  expect(await drawer.findByText(/Notified 0 of 2/)).toBeVisible()
})

test('an immediate increase requires the explicit notice override and a reason', async () => {
  mount()
  fireEvent.click(await screen.findByRole('button', { name: 'Edit rate' }))
  const drawer = within(screen.getByRole('dialog'))
  fireEvent.change(drawer.getByLabelText('New commission rate (%)'), { target: { value: '3.00' } })
  fireEvent.click(drawer.getByRole('button', { name: 'Continue' }))
  expect(await drawer.findByText(/Increases require 30 days/)).toBeVisible()
  fireEvent.click(drawer.getByLabelText('Explicitly override the minimum notice period'))
  fireEvent.click(drawer.getByRole('button', { name: 'Continue' }))
  expect(await drawer.findByText(/Give a notice override reason/)).toBeVisible()
  fireEvent.change(drawer.getByLabelText('Notice override reason'), { target: { value: 'Explicitly approved short notice exception' } })
  fireEvent.click(drawer.getByRole('button', { name: 'Continue' }))
  expect(drawer.getByLabelText('Internal reason')).toBeVisible()
  expect(finance.publishCommissionPolicy).not.toHaveBeenCalled()
})

test('a configured zero-day notice period allows an immediate increase without an override', async () => {
  vi.mocked(finance.listCommissionPolicies).mockResolvedValue({ policies: { current, latestVersion: 1, minNoticeDays: 0, canManage: true, versions: [current] }, hasMore: false })
  mount()
  fireEvent.click(await screen.findByRole('button', { name: 'Edit rate' }))
  const drawer = within(screen.getByRole('dialog'))
  fireEvent.change(drawer.getByLabelText('New commission rate (%)'), { target: { value: '3.00' } })
  fireEvent.click(drawer.getByRole('button', { name: 'Continue' }))
  expect(drawer.getByLabelText('Internal reason')).toBeVisible()
  expect(drawer.queryByLabelText('Explicitly override the minimum notice period')).not.toBeInTheDocument()
})

test('statement drawer shows saved rate detail and permission-gated email resend', async () => {
  mount()
  fireEvent.click(await screen.findByRole('button', { name: 'Test Supply' }))
  const drawer = within(screen.getByRole('dialog'))
  await drawer.findByText('Email activity')
  fireEvent.click(drawer.getByRole('tab', { name: 'Charges and credits' }))
  expect(await drawer.findByRole('table', { name: 'Statement rates' })).toHaveTextContent('2.00%')
  fireEvent.click(drawer.getByRole('tab', { name: 'Activity and emails' }))
  fireEvent.click(drawer.getByRole('button', { name: 'Resend email' }))
  await waitFor(() => expect(finance.resendCommissionEmail).toHaveBeenCalledWith('email-1', expect.stringMatching(/^[0-9a-f-]{36}$/)))
  expect(await drawer.findByText(/Statement email queued/)).toBeVisible()
})

test('read-only roles have no rate or email mutation controls', async () => {
  vi.mocked(finance.listCommissionPolicies).mockResolvedValue({ policies: { current, latestVersion: 1, canManage: false, versions: [current] }, hasMore: false })
  vi.mocked(finance.getCommissionStatement).mockResolvedValue({ ...bill, can_resend: false, emails: [{ id: 'email-1', state: 'SENT', type: 'STATEMENT_ISSUED', attempts: 1, created_at: '2026-11-07T00:00:00Z' }] })
  mount()
  await screen.findByText('2.00%')
  expect(screen.queryByRole('button', { name: 'Edit rate' })).not.toBeInTheDocument()
  fireEvent.click(await screen.findByRole('button', { name: 'Test Supply' }))
  const drawer = within(screen.getByRole('dialog'))
  fireEvent.click(drawer.getByRole('tab', { name: 'Activity and emails' }))
  await drawer.findByText(/delivery attempts/)
  expect(drawer.queryByRole('button', { name: 'Resend email' })).not.toBeInTheDocument()
})

test('failed rate delivery exposes resend failed without changing the policy', async () => {
  const policy = { ...current, delivery: { total: 2, sent: 1, failed: 1, queued: 0, blocked: 0 } }
  vi.mocked(finance.listCommissionPolicies).mockResolvedValue({ policies: { current: policy, latestVersion: 1, canManage: true, versions: [policy] }, hasMore: false })
  mount()
  fireEvent.click(await screen.findByRole('button', { name: 'View history' }))
  expect(await screen.findByText('Notified 1 of 2, 1 failed')).toBeVisible()
  fireEvent.click(screen.getByRole('button', { name: 'Resend failed' }))
  await waitFor(() => expect(finance.resendFailedCommissionEmails).toHaveBeenCalledWith('policy-1', expect.any(String)))
  expect(finance.publishCommissionPolicy).not.toHaveBeenCalled()
})
