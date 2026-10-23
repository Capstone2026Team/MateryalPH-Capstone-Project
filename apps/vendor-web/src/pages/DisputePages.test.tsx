import { act, fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { afterEach, beforeEach, expect, test, vi } from 'vitest'
import * as api from '../lib/disputes-api'
import type { DisputeDetail, DisputeEligibility, VendorOrderInvoices } from '../lib/disputes-api'
import { useOnboardingSnapshot } from '../lib/vendor-status'
import { FileDisputeDialog, VendorDisputeDetailPage, VendorDisputesPage } from './DisputePages'
import { OrderInvoicePanel } from './InvoicePages'

vi.mock('../lib/disputes-api', async original => ({ ...await original<typeof import('../lib/disputes-api')>(), getDispute: vi.fn(), getEligibility: vi.fn(), fileDispute: vi.fn(), respond: vi.fn(), getOrderInvoices: vi.fn(), uploadInvoice: vi.fn(), listDisputes: vi.fn(), requestExport: vi.fn(), listExports: vi.fn(), downloadExport: vi.fn() }))
vi.mock('../lib/vendor-status', () => ({ useOnboardingSnapshot: vi.fn() }))
vi.mock('../lib/catalog-access', async original => ({ ...await original<typeof import('../lib/catalog-access')>(), storeName: () => 'Test Supply' }))
vi.mock('./PhaseThreeVendorPages', async original => ({ ...await original<typeof import('./PhaseThreeVendorPages')>(), VendorShell: ({ children }: { children: React.ReactNode }) => <main>{children}</main> }))

const now = new Date('2026-10-04T02:00:00Z')
const detail = (overrides: Partial<DisputeDetail> = {}): DisputeDetail => ({
  id: 'case-1', reference: 'CASE-261004-ABC123', orderId: 'order-1', orderReference: 'ORD-2026-AAAA', status: 'OPEN_AWAITING_RESPONSE', caseKind: 'TRANSACTION', issueType: 'DEFECTIVE',
  requestedRemedy: 'FULL_REFUND', filedByParty: 'BUYER', responsibleParty: 'VENDOR', refundState: 'NONE', remedyState: 'NONE', appealAvailable: false, vendorName: 'Test Supply', assignedToAdmin: false,
  decisions: [], description: 'Two bags arrived hardened.', affectedLines: [], originalPaymentMethod: { label: 'GCash •••• 1234', notice: 'Any refund returns to this original payment method.' },
  order: { id: 'order-1', reference: 'ORD-2026-AAAA', orderState: 'DISPUTED', disputeState: 'OPEN_AWAITING_RESPONSE', refundState: 'NONE', paymentMethod: 'EWALLET' },
  deadlines: [{ kind: 'RESPONSE', at: new Date(Date.now() + 47 * 3600_000), responsibleParty: 'VENDOR', label: 'Oct 6, 2026, 10:00 AM' }], serverTime: now, timezone: 'Asia/Manila',
  handler: { adminAssigned: false, adminIsMe: false }, lockVersion: 1,
  timeline: [{ id: 'e1', sequence: 1, type: 'CASE_FILED', at: now, actor: { party: 'BUYER', role: 'BUYER', displayName: 'Juan D.' }, body: 'Two bags arrived hardened.', details: {}, evidence: [] }],
  proposals: [], clarifications: [], remedies: [], refunds: [], availableActions: ['RESPOND', 'MESSAGE', 'ADD_EVIDENCE'], limitedView: false, permissions: { canRespond: true, canOfferRefund: false },
  ...overrides,
}) as DisputeDetail
const snapshot = (permissions: string[]) => vi.mocked(useOnboardingSnapshot).mockReturnValue({ snapshot: { permissions }, loading: false, error: null, refresh: vi.fn() } as unknown as ReturnType<typeof useOnboardingSnapshot>)
const openCase = () => render(<MemoryRouter initialEntries={['/disputes/case-1']}><Routes><Route path="/disputes/:caseId" element={<VendorDisputeDetailPage />} /></Routes></MemoryRouter>)

const invoices = (overrides: Partial<VendorOrderInvoices> = {}): VendorOrderInvoices => ({
  orderId: 'order-1', orderReference: 'ORD-2026-AAAA', status: 'NOT_YET_UPLOADED', issuanceNotice: 'Issue the invoice when it is legally due.', records: [], requests: [],
  platformDocuments: [{ kind: 'PURCHASE_ORDER', title: 'MateryalPH purchase order', notTaxInvoice: true, label: 'Not a tax invoice', availability: 'Available in order details.' }], canUpload: true, canOpenFiles: true, issuerName: 'Test Supply Corp.',
  invoiceTypes: ['VENDOR_GOODS_INVOICE', 'VENDOR_ADJUSTMENT_DOCUMENT'], sourceSystems: ['REGISTERED_CAS'], invoicingMethods: ['COMPUTERIZED'], lines: [], ...overrides,
}) as VendorOrderInvoices

const originalCreate = Object.getOwnPropertyDescriptor(URL, 'createObjectURL')
const originalRevoke = Object.getOwnPropertyDescriptor(URL, 'revokeObjectURL')
const createObjectURL = vi.fn<(blob: Blob) => string>()
const revokeObjectURL = vi.fn<(url: string) => void>()
beforeEach(() => {
  vi.clearAllMocks(); window.scrollTo = vi.fn() as unknown as typeof window.scrollTo
  createObjectURL.mockImplementation(() => `blob:local-${createObjectURL.mock.calls.length}`)
  Object.defineProperty(URL, 'createObjectURL', { configurable: true, value: createObjectURL })
  Object.defineProperty(URL, 'revokeObjectURL', { configurable: true, value: revokeObjectURL })
})
afterEach(() => {
  if (originalCreate) Object.defineProperty(URL, 'createObjectURL', originalCreate); else Reflect.deleteProperty(URL, 'createObjectURL')
  if (originalRevoke) Object.defineProperty(URL, 'revokeObjectURL', originalRevoke); else Reflect.deleteProperty(URL, 'revokeObjectURL')
})

const eligibility = (overrides: Partial<DisputeEligibility> = {}): DisputeEligibility => ({
  available: true, reason: '', caseKind: 'TRANSACTION', issueTypes: ['PHYSICAL_PAYMENT_NOT_RECEIVED'], requestedRemedies: ['PAYMENT_OF_BALANCE'],
  lines: [{ orderLineId: 'line-1', displayName: 'Steel bar', variantLabel: 'Standard', quantity: '10', lineTotalCentavos: 10000, refundableCentavos: 10000 }],
  originalPaymentMethod: { label: 'GCash', physical: false }, refundDestinationNotice: 'Refunds return to the original payment method.', filingCreatesRefund: false, ...overrides,
})
const openFiling = (onClose = vi.fn()) => render(<MemoryRouter initialEntries={['/orders/order-1']}><Routes>
  <Route path="/orders/:orderId" element={<FileDisputeDialog orderId="order-1" onClose={onClose} />} />
  <Route path="/disputes/:caseId" element={<h1>Created case</h1>} />
</Routes></MemoryRouter>)

const openQueue = () => render(<MemoryRouter initialEntries={['/disputes?group=CONCLUDED']}><Routes><Route path="/disputes" element={<VendorDisputesPage />} /></Routes></MemoryRouter>)
const queue = { items: [], meta: { counts: {}, total: 0, perPage: 20, hasMore: false } } as unknown as Awaited<ReturnType<typeof api.listDisputes>>
const exportRow = (state: string) => ({ id: 'export-1', state, requestedAt: now, rowCount: 3 }) as unknown as Awaited<ReturnType<typeof api.requestExport>>

test('one Export click requests the selected status group, waits until it is ready and downloads it', async () => {
  snapshot(['portal.disputes', 'disputes.export'])
  vi.mocked(api.listDisputes).mockResolvedValue(queue)
  vi.mocked(api.requestExport).mockResolvedValue(exportRow('QUEUED'))
  vi.mocked(api.listExports).mockResolvedValueOnce([exportRow('QUEUED')]).mockResolvedValue([exportRow('READY')])
  vi.mocked(api.downloadExport).mockResolvedValue(undefined)
  openQueue()
  expect(screen.queryByText('Case exports')).not.toBeInTheDocument()
  fireEvent.click(await screen.findByRole('button', { name: 'Export' }))
  expect(await screen.findByRole('button', { name: 'Preparing…' })).toBeDisabled()
  await waitFor(() => expect(api.downloadExport).toHaveBeenCalledWith('export-1'), { timeout: 5000 })
  expect(api.requestExport).toHaveBeenCalledExactlyOnceWith('CONCLUDED')
  expect(await screen.findByText('Export downloaded.')).toBeInTheDocument()
})

test('a revoked export says why and a role without export access has no Export button', async () => {
  snapshot(['portal.disputes', 'disputes.export'])
  vi.mocked(api.listDisputes).mockResolvedValue(queue)
  vi.mocked(api.requestExport).mockResolvedValue(exportRow('QUEUED'))
  vi.mocked(api.listExports).mockResolvedValue([exportRow('REVOKED')])
  const view = openQueue()
  fireEvent.click(await screen.findByRole('button', { name: 'Export' }))
  expect(await screen.findByText('The export was revoked because your access changed.')).toBeInTheDocument()
  expect(api.downloadExport).not.toHaveBeenCalled()
  view.unmount()
  snapshot(['portal.disputes'])
  openQueue()
  await screen.findByText('No cases in this view.')
  expect(screen.queryByRole('button', { name: 'Export' })).not.toBeInTheDocument()
})

test('the filing popup reviews local evidence, removes a file, and submits only the remaining evidence', async () => {
  vi.mocked(api.getEligibility).mockResolvedValue(eligibility())
  vi.mocked(api.fileDispute).mockResolvedValue(detail())
  openFiling()
  const dialog = screen.getByRole('dialog', { name: 'File a case' })
  const form = await within(dialog).findByRole('form', { name: 'File a case' })
  fireEvent.click(within(form).getByRole('button', { name: 'File case' }))
  expect(within(form).getByText('Describe the issue in at least 20 characters.')).toBeInTheDocument()
  expect(api.fileDispute).not.toHaveBeenCalled()
  const photo = new File(['photo'], 'handover.png', { type: 'image/png' })
  const pdf = new File(['%PDF'], 'receipt.pdf', { type: 'application/pdf' })
  fireEvent.change(within(form).getByLabelText('Evidence'), { target: { files: [photo, pdf] } })
  const preview = within(form).getByRole('img', { name: 'Selected evidence preview: handover.png' })
  const photoUrl = preview.getAttribute('src')
  expect(within(form).getByRole('link', { name: 'Preview receipt.pdf' })).toHaveAttribute('href', expect.stringContaining('blob:local-'))
  expect(within(form).getByText('Pending upload. Files are attached when you submit the form.')).toBeInTheDocument()
  expect(api.fileDispute).not.toHaveBeenCalled()
  fireEvent.click(within(form).getByRole('button', { name: 'Remove handover.png' }))
  expect(within(form).queryByText('handover.png')).not.toBeInTheDocument()
  expect(revokeObjectURL).toHaveBeenCalledWith(photoUrl)
  fireEvent.change(within(form).getByRole('textbox', { name: 'What happened' }), { target: { value: 'The Buyer has not paid the outstanding balance.' } })
  fireEvent.click(within(form).getByRole('checkbox', { name: 'Steel bar · Standard' }))
  fireEvent.click(within(form).getByRole('button', { name: 'File case' }))
  await screen.findByRole('heading', { name: 'Created case' })
  expect(api.fileDispute).toHaveBeenCalledTimes(1)
  expect(vi.mocked(api.fileDispute).mock.calls[0]).toEqual([
    { orderId: 'order-1', issueType: 'PHYSICAL_PAYMENT_NOT_RECEIVED', requestedRemedy: 'PAYMENT_OF_BALANCE', description: 'The Buyer has not paid the outstanding balance.', affectedLineIds: ['line-1'], files: [pdf] },
    expect.any(String),
  ])
  await waitFor(() => expect(revokeObjectURL).toHaveBeenCalledTimes(createObjectURL.mock.calls.length))
})

test('filing checks server eligibility inside the popup and links to an existing case', async () => {
  vi.mocked(api.getEligibility).mockResolvedValue(eligibility({ available: false, reason: 'An active case already exists.', activeCaseId: 'case-1' }))
  openFiling()
  const dialog = screen.getByRole('dialog', { name: 'File a case' })
  expect(await within(dialog).findByText('An active case already exists.')).toBeInTheDocument()
  expect(within(dialog).getByRole('link', { name: 'Open the active case' })).toHaveAttribute('href', '/disputes/case-1')
  expect(within(dialog).queryByRole('form')).not.toBeInTheDocument()
  expect(api.fileDispute).not.toHaveBeenCalled()
})

test('a failed popup submission keeps evidence for retry and prevents closing while filing', async () => {
  vi.mocked(api.getEligibility).mockResolvedValue(eligibility())
  let rejectSubmission: (reason: Error) => void = () => {}
  vi.mocked(api.fileDispute).mockImplementation(() => new Promise((_, reject) => { rejectSubmission = reject }))
  const onClose = vi.fn()
  openFiling(onClose)
  const dialog = screen.getByRole('dialog', { name: 'File a case' })
  const form = await within(dialog).findByRole('form', { name: 'File a case' })
  fireEvent.change(within(form).getByLabelText('Evidence'), { target: { files: [new File(['%PDF'], 'receipt.pdf', { type: 'application/pdf' })] } })
  fireEvent.change(within(form).getByRole('textbox', { name: 'What happened' }), { target: { value: 'The Buyer has not paid the outstanding balance.' } })
  fireEvent.click(within(form).getByRole('button', { name: 'File case' }))
  expect(within(dialog).getByRole('button', { name: 'Close file a case' })).toBeDisabled()
  fireEvent(dialog, new Event('cancel', { bubbles: true, cancelable: true }))
  expect(onClose).not.toHaveBeenCalled()
  await act(async () => { rejectSubmission(new Error('Offline')) })
  expect(within(form).getByText('receipt.pdf')).toBeInTheDocument()
  expect(within(form).getByRole('button', { name: 'File case' })).toBeEnabled()
  expect(within(dialog).getByRole('button', { name: 'Close file a case' })).toBeEnabled()
  expect(api.fileDispute).toHaveBeenCalledTimes(1)
})

test('a role without dispute access is denied and the case is never requested', async () => {
  snapshot(['portal.orders'])
  openCase()
  expect(screen.getByText(/not available to your role/)).toBeInTheDocument()
  expect(api.getDispute).not.toHaveBeenCalled()
})

test.each(['BUYER', 'VENDOR'] as const)('original complaint clearly attributes the saved description to %s', async filedByParty => {
  snapshot(['portal.disputes', 'disputes.respond'])
  const vendorFiled = filedByParty === 'VENDOR'
  const description = 'The agreed materials were not received.\nPlease review the attached details.'
  const complaintDetail = detail({ filedByParty, description,
    issueType: vendorFiled ? 'PICKUP_NO_SHOW' : 'DEFECTIVE', requestedRemedy: vendorFiled ? 'WARNING_ONLY' : 'PARTIAL_REFUND',
    requestedAmountCentavos: 150050 })
  if (vendorFiled) delete complaintDetail.requestedAmountCentavos
  vi.mocked(api.getDispute).mockResolvedValue(complaintDetail)
  openCase()
  const complaint = await screen.findByRole('region', { name: 'Original complaint' })
  expect(within(complaint).getByText(`${vendorFiled ? 'Vendor' : 'Buyer'}'s description of the problem`)).toBeInTheDocument()
  expect(within(complaint).getByText(/The agreed materials/).textContent).toBe(description)
  expect(within(complaint).getByText(vendorFiled ? 'Pickup no-show' : 'Defective or damaged')).toBeInTheDocument()
  expect(within(complaint).getByText(vendorFiled ? 'Warning only' : 'Partial refund · ₱1,500.50')).toBeInTheDocument()
})

test('an absent original description has an explicit empty state', async () => {
  snapshot(['portal.disputes'])
  vi.mocked(api.getDispute).mockResolvedValue(detail({ description: '  ' }))
  openCase()
  const complaint = await screen.findByRole('region', { name: 'Original complaint' })
  expect(within(complaint).getByText('No problem description was recorded.')).toBeInTheDocument()
})

test('staff cannot offer or accept a voluntary refund; that stays with the Owner', async () => {
  snapshot(['portal.disputes', 'disputes.respond'])
  vi.mocked(api.getDispute).mockResolvedValue(detail())
  openCase()
  const form = await screen.findByRole('region', { name: 'Respond to the Buyer' })
  const select = within(form).getByRole('combobox', { name: 'Your response' })
  expect(within(select).queryByRole('option', { name: /Offer a refund/ })).not.toBeInTheDocument()
  fireEvent.change(select, { target: { value: 'ACCEPT_REQUEST' } })
  expect(within(form).getByText(/only the Owner can agree to/)).toBeInTheDocument()
  expect(within(form).getByRole('button', { name: 'Send response' })).toBeDisabled()
  expect(screen.getByText(/original payment method/)).toBeInTheDocument()
})

test('a rejection needs evidence before it is sent', async () => {
  snapshot(['portal.disputes', 'disputes.respond'])
  vi.mocked(api.getDispute).mockResolvedValue(detail())
  openCase()
  const form = await screen.findByRole('region', { name: 'Respond to the Buyer' })
  fireEvent.change(within(form).getByRole('combobox', { name: 'Your response' }), { target: { value: 'REJECT_WITH_EVIDENCE' } })
  fireEvent.change(within(form).getByRole('textbox', { name: 'Explanation' }), { target: { value: 'Delivered sealed and dry per photo.' } })
  fireEvent.click(within(form).getByRole('button', { name: 'Send response' }))
  expect(await within(form).findByText('Attach the evidence for a rejection.')).toBeInTheDocument()
  expect(api.respond).not.toHaveBeenCalled()
})

test('fulfillment staff see a limited view without the complaint or case management', async () => {
  snapshot(['disputes.fulfillment_evidence'])
  vi.mocked(api.getDispute).mockResolvedValue(detail({ limitedView: true, availableActions: ['ADD_FULFILLMENT_EVIDENCE'], permissions: null }))
  openCase()
  expect(await screen.findByText(/add fulfillment evidence only/)).toBeInTheDocument()
  expect(screen.queryByRole('heading', { name: 'Original complaint' })).not.toBeInTheDocument()
  expect(screen.queryByRole('region', { name: 'Respond to the Buyer' })).not.toBeInTheDocument()
})

test('Customer Service sees invoice status only, with no upload or file access', async () => {
  vi.mocked(api.getOrderInvoices).mockResolvedValue(invoices({ canUpload: false, canOpenFiles: false }))
  render(<MemoryRouter><OrderInvoicePanel orderId="order-1" /></MemoryRouter>)
  expect(await screen.findByText('No copy uploaded yet')).toBeInTheDocument()
  expect(screen.queryByRole('button', { name: /Upload invoice copy/ })).not.toBeInTheDocument()
  expect(screen.getByText(/Owner, Store Manager or Store Staff upload/)).toBeInTheDocument()
})

test('an invoice upload validates fields locally and sends one keyed request', async () => {
  vi.mocked(api.getOrderInvoices).mockResolvedValue(invoices())
  vi.mocked(api.uploadInvoice).mockResolvedValue(invoices({ status: 'ISSUED' }))
  render(<MemoryRouter><OrderInvoicePanel orderId="order-1" /></MemoryRouter>)
  fireEvent.click(await screen.findByRole('button', { name: /Upload invoice copy/ }))
  const form = screen.getByRole('form', { name: 'Upload invoice copy' })
  fireEvent.click(within(form).getByRole('button', { name: 'Upload copy' }))
  expect(within(form).getByText('Enter the invoice number as printed.')).toBeInTheDocument()
  expect(within(form).getByText('Attach the PDF, JPG or PNG copy.')).toBeInTheDocument()
  expect(api.uploadInvoice).not.toHaveBeenCalled()
  fireEvent.change(within(form).getByRole('textbox', { name: 'Invoice number' }), { target: { value: 'SI-000123' } })
  fireEvent.change(within(form).getByRole('textbox', { name: /Invoice total/ }), { target: { value: '12,500.00' } })
  fireEvent.change(within(form).getByLabelText(/Copy \(PDF/), { target: { files: [new File(['%PDF'], 'si.pdf', { type: 'application/pdf' })] } })
  fireEvent.click(within(form).getByRole('button', { name: 'Upload copy' }))
  await waitFor(() => expect(api.uploadInvoice).toHaveBeenCalledTimes(1))
  expect(vi.mocked(api.uploadInvoice).mock.calls[0]![1]).toMatchObject({ invoiceNumber: 'SI-000123', amountCentavos: 1250000, issuerName: 'Test Supply Corp.' })
  expect(await screen.findByText(/uploaded and shared with the Buyer/)).toBeInTheDocument()
})
