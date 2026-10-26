import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import { ResponseError } from '@materyalph/api-client-ts'
import * as tax from '../lib/finance-tax-api'
import * as finance from '../lib/finance-api'
import { AdminTaxPackagePage, FinanceTaxRecords } from './FinanceTaxPages'

vi.mock('../lib/finance-tax-api', async original => ({ ...await original<typeof import('../lib/finance-tax-api')>(), listTaxAdjustments: vi.fn(), prepareTaxAdjustment: vi.fn(), reviewTaxAdjustment: vi.fn(), postTaxAdjustment: vi.fn(), listTaxPackages: vi.fn(), listTaxVendors: vi.fn(), prepareTaxPackage: vi.fn(), getTaxPackage: vi.fn(), reviewTaxPackage: vi.fn(), recordTaxSimulation: vi.fn() }))
vi.mock('../lib/finance-api', async original => ({ ...await original<typeof import('../lib/finance-api')>(), taxEvidenceQueue: vi.fn() }))
vi.mock('./PhaseThreeAdminPages', async original => ({ ...await original<typeof import('./PhaseThreeAdminPages')>(), AdminShell: ({ children }: { children: React.ReactNode }) => <main>{children}</main> }))

const adjustment = (overrides: Partial<tax.TaxAdjustment> = {}): tax.TaxAdjustment => ({ id: 'adj-1', kind: 'REFUND_AFTER_ASSESSMENT', state: 'ADJUSTMENT_REQUIRED', environment: 'TEST', openedBy: 'SYSTEM', orderReference: 'ORD-100', vendorName: 'Sample Supply', originalRecordType: 'REMITTANCE_ASSESSMENT', originalRecordId: 'source-1', periodStart: new Date('2026-10-01'), periodEnd: new Date('2026-10-31'), amountCentavos: 20000, beforeValues: { withheld_centavos: 5000 }, afterValues: {}, reason: 'A refund needs a withholding review.', allowedActions: ['PREPARE'], ...overrides })
const report = (overrides: Partial<tax.TaxPackage> = {}): tax.TaxPackage => ({ id: 'package-1', packageType: '1601-EQ', state: 'DRAFT', periodStart: '2026-10-01', periodEnd: '2026-12-31', withholdingEntity: 'DEMO_PLATFORM_WITHHOLDER', nominalDueDate: '2027-01-31', actualDueDate: null, dueDateReviewerId: null, lockVersion: 3, snapshot: { blockers: [], basis_centavos: 100000, tax_centavos: 500, rows: [] }, ...overrides })
const page = <T,>(items: T[]) => ({ items, hasMore: false, total: items.length })
const at = (path = '/finance?view=tax') => render(<MemoryRouter initialEntries={[path]}><Routes><Route path="/finance" element={<FinanceTaxRecords />} /><Route path="/finance/tax/packages/:packageId" element={<AdminTaxPackagePage />} /></Routes></MemoryRouter>)

beforeEach(() => {
  vi.resetAllMocks()
  vi.mocked(tax.listTaxAdjustments).mockResolvedValue(page([adjustment()]))
  vi.mocked(tax.listTaxPackages).mockResolvedValue(page([report()]))
  vi.mocked(tax.getTaxPackage).mockResolvedValue(report())
  vi.mocked(tax.listTaxVendors).mockResolvedValue(page([{ id: 'vendor-1', name: 'Sample Supply' }]))
  vi.mocked(finance.taxEvidenceQueue).mockResolvedValue(page([{ id: 'evidence-1', vendor: { id: 'vendor-1', name: 'Sample Supply' }, evidenceType: 'SWORN_DECLARATION', reviewState: 'APPROVED', origin: 'SAMPLE', taxProfileVersion: 1, taxableYear: 2026, decisionHref: '/vendor-verification/vendor-1', createdAt: new Date(), note: 'Sample evidence' }]))
})

test('tax records opens the preparation queue and switches between supporting tools', async () => {
  at()
  expect(await screen.findByText('ORD-100')).toBeInTheDocument()
  expect(tax.listTaxAdjustments).toHaveBeenCalledWith(1, 'ADJUSTMENT_REQUIRED', { label: 'All dates', from: '', to: '' })
  fireEvent.change(screen.getByRole('combobox', { name: 'Tax records view' }), { target: { value: 'packages' } })
  expect(await screen.findByRole('link', { name: 'Open package' })).toHaveAttribute('href', '/finance/tax/packages/package-1')
  fireEvent.change(screen.getByRole('combobox', { name: 'Tax records view' }), { target: { value: 'evidence' } })
  expect(await screen.findByRole('link', { name: 'Open verification' })).toHaveAttribute('href', '/vendor-verification/vendor-1')
  expect(screen.queryByText(/Back to notifications/)).not.toBeInTheDocument()
})

test('preparing an adjustment sends exact centavos and preserves the independent review step', async () => {
  vi.mocked(tax.prepareTaxAdjustment).mockResolvedValue(adjustment({ state: 'UNDER_REVIEW', allowedActions: [], separationNote: 'You prepared this adjustment; a different finance user must review it.', afterValues: { proposed_withheld_centavos: 4205 } }))
  at()
  fireEvent.click(await screen.findByRole('button', { name: 'Review adjustment for ORD-100' }))
  fireEvent.change(screen.getByLabelText('Corrected withholding'), { target: { value: '42.05' } })
  fireEvent.change(screen.getByLabelText('Certificate impact'), { target: { value: 'REISSUE_REQUIRED' } })
  fireEvent.change(screen.getByLabelText('Evidence reference (optional)'), { target: { value: 'Refund evidence' } })
  fireEvent.change(screen.getByLabelText('Reason for correction'), { target: { value: 'Reviewed the refund evidence.' } })
  fireEvent.click(screen.getByRole('button', { name: 'Send for review' }))
  await waitFor(() => expect(tax.prepareTaxAdjustment).toHaveBeenCalledWith('adj-1', { correctedWithheldCentavos: 4205, certificateImpact: 'REISSUE_REQUIRED', evidenceReference: 'Refund evidence', reason: 'Reviewed the refund evidence.' }))
  expect(await screen.findByText(/You prepared this adjustment/)).toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Approve adjustment' })).not.toBeInTheDocument()
  expect(tax.postTaxAdjustment).not.toHaveBeenCalled()
})

test('a reviewer approves with a reason and explicitly posts the approved correction', async () => {
  const prepared = adjustment({ state: 'UNDER_REVIEW', preparer: 'Another finance user', allowedActions: ['APPROVE', 'REJECT'], afterValues: { proposed_withheld_centavos: 4205, certificate_impact: 'REISSUE_REQUIRED', evidence_reference: 'Refund evidence' } })
  vi.mocked(tax.listTaxAdjustments).mockResolvedValue(page([prepared]))
  vi.mocked(tax.reviewTaxAdjustment).mockResolvedValue({ ...prepared, state: 'APPROVED', allowedActions: ['POST'] })
  vi.mocked(tax.postTaxAdjustment).mockResolvedValue({ ...prepared, state: 'POSTED', allowedActions: [] })
  at()
  fireEvent.click(await screen.findByRole('button', { name: 'Review adjustment for ORD-100' }))
  fireEvent.change(screen.getByLabelText('Review reason'), { target: { value: 'Confirmed the refund and proposed withholding.' } })
  fireEvent.click(screen.getByRole('button', { name: 'Approve adjustment' }))
  await waitFor(() => expect(tax.reviewTaxAdjustment).toHaveBeenCalledWith('adj-1', { decision: 'APPROVED', reason: 'Confirmed the refund and proposed withholding.' }))
  expect(tax.postTaxAdjustment).not.toHaveBeenCalled()
  fireEvent.click(await screen.findByRole('button', { name: 'Post adjustment' }))
  await waitFor(() => expect(tax.postTaxAdjustment).toHaveBeenCalledWith('adj-1'))
  expect(await screen.findByText('Adjustment posted. The original assessment is preserved.')).toBeInTheDocument()
})

test('returning a correction requires a review reason and retains an API rejection for retry', async () => {
  vi.mocked(tax.listTaxAdjustments).mockResolvedValue(page([adjustment({ state: 'UNDER_REVIEW', allowedActions: ['APPROVE', 'REJECT'] })]))
  vi.mocked(tax.reviewTaxAdjustment).mockRejectedValue(new ResponseError(new Response(JSON.stringify({ errors: [{ code: 'PREPARER_CANNOT_REVIEW', message: 'A different finance user must review this adjustment.' }] }), { status: 409, headers: { 'Content-Type': 'application/json' } })))
  at()
  fireEvent.click(await screen.findByRole('button', { name: 'Review adjustment for ORD-100' }))
  fireEvent.click(screen.getByRole('button', { name: 'Return for correction' }))
  expect(await screen.findByText('Enter a reason of at least 10 characters.')).toBeInTheDocument()
  expect(tax.reviewTaxAdjustment).not.toHaveBeenCalled()
  fireEvent.change(screen.getByLabelText('Review reason'), { target: { value: 'The supporting evidence needs correction.' } })
  fireEvent.click(screen.getByRole('button', { name: 'Return for correction' }))
  expect(await screen.findByText('A different finance user must review this adjustment.')).toBeInTheDocument()
  expect(screen.getByLabelText('Review reason')).toHaveValue('The supporting evidence needs correction.')
  expect(tax.reviewTaxAdjustment).toHaveBeenCalledWith('adj-1', { decision: 'REJECTED', reason: 'The supporting evidence needs correction.' })
})

test('package preparation chooses a Vendor by name and reuses its request key on retry', async () => {
  vi.mocked(tax.prepareTaxPackage).mockRejectedValueOnce(new Error('offline')).mockResolvedValueOnce(report({ packageType: '2307' }))
  at('/finance?view=tax&taxView=packages')
  fireEvent.click(await screen.findByRole('button', { name: 'Prepare package' }))
  const dialog = screen.getByRole('dialog', { name: 'Prepare tax package' })
  fireEvent.change(within(dialog).getByLabelText('Report form'), { target: { value: '2307' } })
  fireEvent.change(within(dialog).getByLabelText(/Reporting period start/), { target: { value: '2026-10-01' } })
  await within(dialog).findByRole('option', { name: 'Sample Supply' })
  fireEvent.change(within(dialog).getByLabelText('Vendor (required)'), { target: { value: 'vendor-1' } })
  fireEvent.click(within(dialog).getByRole('button', { name: 'Prepare draft' }))
  expect(await within(dialog).findByText(/Check your connection/)).toBeInTheDocument()
  fireEvent.click(within(dialog).getByRole('button', { name: 'Prepare draft' }))
  await waitFor(() => expect(tax.prepareTaxPackage).toHaveBeenCalledTimes(2))
  const calls = vi.mocked(tax.prepareTaxPackage).mock.calls
  expect(calls[0]?.[0]).toEqual({ form: '2307', periodStart: '2026-10-01', withholdingEntity: 'DEMO_PLATFORM_WITHHOLDER', vendorOrganizationId: 'vendor-1' })
  expect(calls[0]?.[1]).toBe(calls[1]?.[1])
  expect(calls[0]?.[1]).toMatch(/^[0-9a-f-]{36}$/)
  expect(await screen.findByRole('heading', { name: 'Tax support package' })).toBeInTheDocument()
  expect(screen.getByRole('link', { name: 'Tax records' })).toHaveAttribute('href', '/finance?view=tax&taxView=packages')
})

test('package blockers are readable and prevent review/export controls', async () => {
  vi.mocked(tax.getTaxPackage).mockResolvedValue(report({ snapshot: { blockers: ['TAX_ADJUSTMENT_REVIEW_REQUIRED'], basis_centavos: 100000, tax_centavos: 500 } }))
  at('/finance/tax/packages/package-1')
  expect(await screen.findByText('An adjustment still needs review or posting.')).toBeInTheDocument()
  expect(screen.getByText('₱1,000.00')).toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Review package' })).not.toBeInTheDocument()
  expect(screen.queryByText('TAX_ADJUSTMENT_REVIEW_REQUIRED')).not.toBeInTheDocument()
  expect(screen.getByRole('link', { name: 'Open tax records' })).toHaveAttribute('href', '/finance?view=tax')
})

test('package review submits the loaded version and explicit reconciliation confirmation', async () => {
  vi.mocked(tax.reviewTaxPackage).mockResolvedValue(report({ state: 'REVIEWED', lockVersion: 4, actualDueDate: '2027-01-31' }))
  at('/finance/tax/packages/package-1')
  fireEvent.click(await screen.findByRole('button', { name: 'Review package' }))
  const dialog = screen.getByRole('dialog', { name: 'Review tax package' })
  fireEvent.change(within(dialog).getByLabelText(/Reviewed due date/), { target: { value: '2027-01-31' } })
  fireEvent.change(within(dialog).getByLabelText(/Deadline source and version/), { target: { value: 'Reviewed demo calendar version 1' } })
  fireEvent.change(within(dialog).getByLabelText(/Review reason/), { target: { value: 'Sources and calendar reconciled.' } })
  fireEvent.click(within(dialog).getByRole('checkbox'))
  fireEvent.click(within(dialog).getByRole('button', { name: 'Approve package' }))
  await waitFor(() => expect(tax.reviewTaxPackage).toHaveBeenCalledWith('package-1', { lockVersion: 3, actualDueDate: '2027-01-31', dueDateSource: 'Reviewed demo calendar version 1', reason: 'Sources and calendar reconciled.', reconciled: true }))
  expect(await screen.findByText('Package reviewed. You can now export the sample report.')).toBeInTheDocument()
  expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
})

test('denied finance reads show the server explanation and offer retry without stale records', async () => {
  vi.mocked(tax.listTaxAdjustments).mockRejectedValueOnce(new ResponseError(new Response(JSON.stringify({ errors: [{ code: 'PERMISSION_DENIED', message: 'This finance action is not available to your Admin role.' }] }), { status: 403, headers: { 'Content-Type': 'application/json' } }))).mockResolvedValueOnce(page([]))
  at()
  expect(await screen.findByText('This finance action is not available to your Admin role.')).toBeInTheDocument()
  expect(screen.queryByText('ORD-100')).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Try again' }))
  expect(await screen.findByText('No tax adjustments match these filters.')).toBeInTheDocument()
})
