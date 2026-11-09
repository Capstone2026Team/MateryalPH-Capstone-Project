import { dateFilterPreset } from '@materyalph/web-ui'
import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import type { ReactNode } from 'react'
import * as api from '../lib/disputes-api'
import type { InvoiceLogRow, VendorOrderInvoices } from '../lib/disputes-api'
import { useOnboardingSnapshot } from '../lib/vendor-status'
import { VendorInvoicesPage } from './InvoicePages'
import { manilaToday } from '@materyalph/web-ui'

const defaultDates = () => ({ from: dateFilterPreset(30).from, to: dateFilterPreset(30).to })


vi.mock('../lib/disputes-api', async original => ({ ...await original<typeof import('../lib/disputes-api')>(), listInvoices: vi.fn(), getOrderInvoices: vi.fn(), uploadInvoice: vi.fn(), sendInvoice: vi.fn(), getInvoicePreset: vi.fn(), saveInvoicePreset: vi.fn() }))
vi.mock('../lib/vendor-status', () => ({ useOnboardingSnapshot: vi.fn() }))
vi.mock('../lib/catalog-access', async original => ({ ...await original<typeof import('../lib/catalog-access')>(), storeName: () => 'Sample Supply' }))
vi.mock('./PhaseThreeVendorPages', async original => ({ ...await original<typeof import('./PhaseThreeVendorPages')>(), VendorShell: ({ children }: { children: ReactNode }) => <main>{children}</main> }))

const record = (id: string, number: string, amountCentavos: number): VendorOrderInvoices['records'][number] => ({
  id, invoiceType: 'VENDOR_GOODS_INVOICE', issuer: 'Sample Supply Corp.', invoiceNumber: number, issuedOn: '2026-11-03', amountCentavos,
  documentOrigin: 'DEMO_SAMPLE', originLabel: 'DEMO sample', verificationState: 'UNVERIFIED', eInvoicingCoverage: 'REVIEW_REQUIRED',
  complianceNote: 'An uploaded PDF is not proof of BIR compliance.', reconciliationState: 'MATCHED', reconciliationDifferenceCentavos: 0,
  canExplain: false, buyerTotalUnchanged: true, uploadedAt: new Date('2026-11-03T01:00:00Z'),
})
const first = record('record-1', 'SAMPLE-001', 275000)
const second = record('record-2', 'SAMPLE-002', 150000)
const preset = { invoiceType: 'VENDOR_GOODS_INVOICE', issuerName: 'Sample Supply Corp.', sourceSystem: 'REGISTERED_CAS', invoicingMethod: 'COMPUTERIZED', dateMode: 'TODAY', lockVersion: 0 } as const
const draft = { ...preset, id: 'draft-1', invoiceNumber: 'SAMPLE-003', issuedOn: new Date('2026-11-03T00:00:00'), amountCentavos: 275000, lockVersion: 1, fileName: 'saved.pdf', download: { url: '/api/v1/vendor/invoice-drafts/draft-1/files/file-1?expires=9999999999&signature=sample', expiresAt: new Date('2030-01-01') } }
const detail = (overrides: Partial<VendorOrderInvoices> = {}): VendorOrderInvoices => ({
  orderId: 'order-1', orderReference: 'ORD-2026-AAAA', status: 'ISSUED', issuanceNotice: 'Issue invoices when legally due.',
  issuerName: 'Sample Supply Corp.', records: [first, second], requests: [], platformDocuments: [], billingDetails: { billingName: 'Sample Buyer', billingAddress: 'Sample billing address', tinMasked: '••••1234' },
  canUpload: true, canOpenFiles: true, invoiceTypes: ['VENDOR_GOODS_INVOICE'], sourceSystems: ['REGISTERED_CAS'], invoicingMethods: ['COMPUTERIZED'],
  lines: [{ orderLineId: 'line-1', displayName: 'Portland cement 40 kg' }], ...overrides,
})
const rows: InvoiceLogRow[] = [first, second].map(item => ({ id: item.id, orderId: 'order-1', orderReference: 'ORD-2026-AAAA', invoiceNumber: item.invoiceNumber, amountCentavos: item.amountCentavos, issuedOn: item.issuedOn, originLabel: item.originLabel, reconciliationState: item.reconciliationState }))
const queue = (items: InvoiceLogRow[] = rows) => ({ items, meta: { counts: { REQUESTS: 0, DUE: 6, RECORDS: 2, RECONCILIATION: 0 }, total: items.length, perPage: 20, hasMore: false, issuanceNotice: 'Issue invoices when legally due.' } })
const open = (url = '/invoices?view=RECORDS') => render(<MemoryRouter initialEntries={[url]}><VendorInvoicesPage /></MemoryRouter>)

beforeEach(() => {
  vi.resetAllMocks()
  vi.mocked(useOnboardingSnapshot).mockReturnValue({ snapshot: { permissions: ['invoices.view'] }, loading: false, error: null, refresh: vi.fn() } as unknown as ReturnType<typeof useOnboardingSnapshot>)
  vi.mocked(api.listInvoices).mockResolvedValue(queue())
  vi.mocked(api.getOrderInvoices).mockResolvedValue(detail())
})

test('selects the exact invoice record when two copies belong to the same order', async () => {
  open()
  expect(await screen.findByRole('heading', { name: 'SAMPLE-001' })).toBeVisible()
  const sheet = screen.getByRole('region', { name: 'Invoice details' })
  expect(within(sheet).getByRole('group', { name: 'Recorded invoice amounts' })).toHaveTextContent('₱2,750.00')
  expect(within(sheet).getAllByText('DEMO sample')[0]).toBeVisible()
  expect(within(sheet).getByText('TIN: ••••1234')).toBeVisible()
  fireEvent.click(screen.getByRole('button', { name: 'View SAMPLE-002 · ORD-2026-AAAA' }))
  expect(within(sheet).getByRole('heading', { name: 'SAMPLE-002' })).toBeVisible()
  expect(within(sheet).getByRole('group', { name: 'Recorded invoice amounts' })).toHaveTextContent('₱1,500.00')
  expect(api.getOrderInvoices).toHaveBeenCalledExactlyOnceWith('order-1')
  expect(within(sheet).getByRole('link', { name: 'View order' })).toHaveAttribute('href', '/orders/order-1#invoices')
})

test('summary cards change the server view and retain the inclusive date range', async () => {
  open('/invoices?view=RECORDS&from=2026-11-01&to=2026-11-04&page=2')
  await screen.findByRole('button', { name: 'View SAMPLE-001 · ORD-2026-AAAA' })
  fireEvent.click(screen.getByRole('button', { name: 'Filter: No copy yet' }))
  await waitFor(() => expect(api.listInvoices).toHaveBeenLastCalledWith({ view: 'DUE', page: 1, from: '2026-11-01', to: '2026-11-04' }))
  expect(screen.getByText('Dates filter this list. Overview shows all dates.')).toBeVisible()
})

test('unrequested sales identify their Buyer without inventing invoice billing details', async () => {
  vi.mocked(api.listInvoices).mockResolvedValue(queue([{ orderId: 'order-1', orderReference: 'ORD-2026-AAAA', buyerName: 'Ana Buyer', orderState: 'COMPLETED', openRequest: false }]))
  vi.mocked(api.getOrderInvoices).mockResolvedValue(detail({ records: [], status: 'NOT_YET_UPLOADED', billingDetails: null, buyerName: 'Ana Buyer' }))
  open('/invoices?view=DUE')
  expect(await screen.findByRole('button', { name: 'View ORD-2026-AAAA · Buyer: Ana Buyer' })).toBeVisible()
  const sheet = screen.getByRole('region', { name: 'Invoice details' })
  expect(await within(sheet).findByText('Ana Buyer')).toBeVisible()
  expect(within(sheet).getByRole('heading', { name: 'Buyer' })).toBeVisible()
  expect(within(sheet).getByText('No billing details provided.')).toBeVisible()
  expect(screen.queryByText('Buyer requested copy')).not.toBeInTheDocument()
})

test('supplied billing details take priority over the order Buyer name', async () => {
  vi.mocked(api.getOrderInvoices).mockResolvedValue(detail({ records: [], status: 'NOT_YET_UPLOADED', buyerName: 'Ana Buyer' }))
  open('/invoices?view=DUE')
  expect(await screen.findByText('Sample Buyer')).toBeVisible()
  const sheet = screen.getByRole('region', { name: 'Invoice details' })
  expect(within(sheet).getByRole('heading', { name: 'Bill to' })).toBeVisible()
  expect(within(sheet).queryByText('Ana Buyer')).not.toBeInTheDocument()
})

test('an empty date filter uses the picker without a separate clear control or a false completion message', async () => {
  vi.mocked(api.listInvoices).mockResolvedValue(queue([]))
  open('/invoices?view=DUE&from=2026-11-01')
  expect(await screen.findByText('No invoices match these dates.')).toBeVisible()
  expect(screen.queryByText('Every confirmed sale has an uploaded invoice copy.')).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Clear dates' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'From Nov 1, 2026' }))
  fireEvent.click(screen.getByRole('button', { name: 'Last 30 days' }))
  fireEvent.click(screen.getByRole('button', { name: 'Apply' }))
  await waitFor(() => expect(api.listInvoices).toHaveBeenLastCalledWith({ ...defaultDates(), view: 'DUE', page: 1 }))
})

test('an empty request queue links directly to sales that still need copies', async () => {
  vi.mocked(api.listInvoices).mockResolvedValue(queue([]))
  open('/invoices')
  fireEvent.click(await screen.findByRole('button', { name: 'View sales without copies' }))
  await waitFor(() => expect(api.listInvoices).toHaveBeenLastCalledWith({ ...defaultDates(), view: 'DUE', page: 1 }))
})

test('a failed detail read can be retried successfully', async () => {
  vi.mocked(api.getOrderInvoices).mockRejectedValueOnce(new Error('Temporarily offline')).mockResolvedValueOnce(detail())
  open()
  fireEvent.click(await screen.findByRole('button', { name: 'Try again' }))
  const sheet = screen.getByRole('region', { name: 'Invoice details' })
  expect(await within(sheet).findByRole('heading', { name: 'SAMPLE-001' })).toBeVisible()
  expect(api.getOrderInvoices).toHaveBeenCalledTimes(2)
})

test('switching orders removes the previous billing details while the next read is pending', async () => {
  vi.mocked(api.listInvoices).mockResolvedValue(queue([rows[0]!, { ...rows[1]!, orderId: 'order-2' }]))
  vi.mocked(api.getOrderInvoices).mockResolvedValueOnce(detail()).mockImplementationOnce(() => new Promise(() => {}))
  open()
  expect(await screen.findByRole('heading', { name: 'SAMPLE-001' })).toBeVisible()
  fireEvent.click(screen.getByRole('button', { name: 'View SAMPLE-002 · ORD-2026-AAAA' }))
  expect(screen.queryByText('Sample billing address')).not.toBeInTheDocument()
  expect(screen.getByText('Loading invoices…')).toBeVisible()
})

test('a status-only role has no file or upload action even if a file URL is present', async () => {
  vi.mocked(api.getOrderInvoices).mockResolvedValue(detail({ canUpload: false, canOpenFiles: false, records: [{ ...first, download: { url: '/private/invoice', expiresAt: new Date() } }] }))
  open()
  expect(await screen.findByRole('heading', { name: 'SAMPLE-001' })).toBeVisible()
  expect(screen.queryByRole('button', { name: 'Open invoice copy' })).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Upload invoice copy' })).not.toBeInTheDocument()
})

test('a role without invoice permission never requests invoice data', async () => {
  vi.mocked(useOnboardingSnapshot).mockReturnValue({ snapshot: { permissions: [] }, loading: false, error: null, refresh: vi.fn() } as unknown as ReturnType<typeof useOnboardingSnapshot>)
  open()
  expect(screen.getByText('E-Invoices are not available to your role.')).toBeVisible()
  expect(api.listInvoices).not.toHaveBeenCalled()
  expect(api.getOrderInvoices).not.toHaveBeenCalled()
})

test('a private upload remains in the missing-copy queue until Send', async () => {
  vi.mocked(api.listInvoices).mockResolvedValue(queue([{ orderId: 'order-1', orderReference: 'ORD-2026-AAAA', orderState: 'CONFIRMED' }]))
  const prepared = detail({ records: [], status: 'NOT_YET_UPLOADED', draft, canSend: true })
  vi.mocked(api.getOrderInvoices).mockResolvedValueOnce(detail({ records: [], status: 'NOT_YET_UPLOADED' })).mockResolvedValue(prepared)
  vi.mocked(api.uploadInvoice).mockResolvedValue(prepared)
  open('/invoices?view=DUE')
  fireEvent.click(await screen.findByRole('button', { name: 'Upload invoice copy' }))
  const form = screen.getByRole('form', { name: 'Upload invoice copy' })
  fireEvent.change(within(form).getByRole('textbox', { name: 'Invoice number' }), { target: { value: 'SAMPLE-001' } })
  fireEvent.change(within(form).getByRole('textbox', { name: /Invoice total/ }), { target: { value: '2750.00' } })
  fireEvent.change(within(form).getByLabelText(/Copy \(PDF/), { target: { files: [new File(['sample PDF'], 'sample-invoice.pdf', { type: 'application/pdf' })] } })
  fireEvent.click(within(screen.getByRole('dialog', { name: 'Upload invoice copy' })).getByRole('button', { name: 'Upload copy' }))
  expect(await screen.findByRole('button', { name: 'Review uploaded copy' })).toBeVisible()
  expect(screen.getByRole('button', { name: 'Send' })).toBeEnabled()
  expect(screen.getByText('Invoice copy uploaded. Review the details, then select Send to share it with the Buyer.')).toBeVisible()
  expect(api.uploadInvoice).toHaveBeenCalledTimes(1)
  expect(api.listInvoices).toHaveBeenCalledTimes(2)
})

test('Send is disabled without a saved file and locks the sent version', async () => {
  const prepared = detail({ records: [], status: 'NOT_YET_UPLOADED', draft, canSend: true })
  vi.mocked(api.getOrderInvoices).mockResolvedValueOnce(detail({ records: [], status: 'NOT_YET_UPLOADED', canSend: false })).mockResolvedValue(prepared)
  open()
  expect(await screen.findByRole('button', { name: 'Send' })).toBeDisabled()
  fireEvent.click(screen.getByRole('button', { name: 'Refresh' }))
  expect(await screen.findByRole('button', { name: 'Review uploaded copy' })).toBeVisible()
  const sent = detail({ canSend: false, canUpload: false, records: [first], draft: { ...draft, sentRecordId: first.id, lockVersion: 2 } })
  vi.mocked(api.sendInvoice).mockResolvedValue(sent)
  vi.mocked(api.getOrderInvoices).mockResolvedValue(sent)
  fireEvent.click(screen.getByRole('button', { name: 'Send' }))
  expect(await screen.findByRole('button', { name: 'Sent' })).toBeDisabled()
  expect(api.sendInvoice).toHaveBeenCalledWith('order-1', 1, expect.any(String))
  expect(screen.queryByRole('button', { name: 'Review uploaded copy' })).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Edit' })).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Hold' })).not.toBeInTheDocument()
})

test('new copies use today and reusable business defaults without reusing invoice amounts', async () => {
  vi.mocked(api.getOrderInvoices).mockResolvedValue(detail({ records: [], status: 'NOT_YET_UPLOADED', preset }))
  vi.mocked(api.saveInvoicePreset).mockResolvedValue({ ...preset, lockVersion: 1 })
  open()
  fireEvent.click(await screen.findByRole('button', { name: 'Upload invoice copy' }))
  const form = screen.getByRole('form', { name: 'Upload invoice copy' })
  expect(within(form).getByLabelText('Invoice date')).toHaveValue(manilaToday())
  expect(within(form).getByLabelText('Invoice number')).toHaveValue('')
  expect(within(form).getByLabelText('Invoice total (₱)')).toHaveValue('')
  fireEvent.click(within(form).getByRole('button', { name: 'Save preset' }))
  expect(await screen.findByText(/Preset saved for this store/)).toBeVisible()
  expect(api.saveInvoicePreset).toHaveBeenCalledWith({ invoiceType: preset.invoiceType, issuerName: preset.issuerName, sourceSystem: preset.sourceSystem, invoicingMethod: preset.invoicingMethod, lockVersion: 0 }, expect.any(String))
})

test('saved copies reopen with their metadata and can keep the existing file', async () => {
  const prepared = detail({ records: [], status: 'NOT_YET_UPLOADED', draft, canSend: true })
  vi.mocked(api.getOrderInvoices).mockResolvedValue(prepared)
  vi.mocked(api.uploadInvoice).mockResolvedValue({ ...prepared, draft: { ...draft, lockVersion: 2 } })
  open()
  fireEvent.click(await screen.findByRole('button', { name: 'Review uploaded copy' }))
  const form = screen.getByRole('form', { name: 'Upload invoice copy' })
  expect(within(form).getByLabelText('Invoice number')).toHaveValue('SAMPLE-003')
  fireEvent.change(within(form).getByLabelText('Invoice total (₱)'), { target: { value: '2800.00' } })
  fireEvent.click(screen.getByRole('button', { name: 'Save changes' }))
  await waitFor(() => expect(api.uploadInvoice).toHaveBeenCalledOnce())
  expect(vi.mocked(api.uploadInvoice).mock.calls[0]?.[1]).toMatchObject({ lockVersion: 1, amountCentavos: 280000 })
  expect(vi.mocked(api.uploadInvoice).mock.calls[0]?.[1].file).toBeUndefined()
})

test('sent history remains selectable while a correction draft is being prepared', async () => {
  vi.mocked(api.getOrderInvoices).mockResolvedValue(detail({ draft, canSend: true }))
  open()
  expect(await screen.findByRole('heading', { name: 'SAMPLE-001' })).toBeVisible()
  expect(screen.getByRole('button', { name: 'Send' })).toBeDisabled()
  fireEvent.click(screen.getByRole('button', { name: 'Review corrected invoice' }))
  fireEvent.click(screen.getByRole('button', { name: 'Cancel' }))
  expect(screen.getByRole('heading', { name: 'SAMPLE-003' })).toBeVisible()
  expect(screen.getByRole('button', { name: 'Send' })).toBeEnabled()
  fireEvent.click(screen.getByRole('button', { name: 'View SAMPLE-002 · ORD-2026-AAAA' }))
  expect(screen.getByRole('heading', { name: 'SAMPLE-002' })).toBeVisible()
})

test('a returned invoice can replace its copy, update its details and send a linked correction', async () => {
  const returned = { ...first, fileName: 'original.pdf' }
  const feedback: VendorOrderInvoices['requests'][number] = { id: 'request-1', kind: 'COPY', state: 'RETURNED_FOR_CORRECTION',
    details: 'Returned: Please correct the invoice total.', invoiceRecordId: first.id, fulfilledInvoiceRecordId: first.id,
    requestedAt: new Date(), serviceTargetAt: new Date('2030-01-01'), serviceTargetLabel: 'Jan 1, 2030', overdue: false, canReturn: false, canClose: false }
  const initial = detail({ records: [returned], requests: [feedback], draft: { ...draft, sentRecordId: first.id, lockVersion: 2 }, canSend: false })
  const prepared = { ...initial, draft: { ...draft, invoiceNumber: 'CORRECTED-001', fileName: 'replacement.pdf', amountCentavos: 280000, lockVersion: 3, amendsInvoiceRecordId: first.id }, canSend: true }
  vi.mocked(api.listInvoices).mockResolvedValue(queue([{ ...rows[0]!, state: 'RETURNED_FOR_CORRECTION', kind: 'CORRECTION' }]))
  vi.mocked(api.getOrderInvoices).mockResolvedValue(initial)
  vi.mocked(api.uploadInvoice).mockImplementation(async () => { vi.mocked(api.getOrderInvoices).mockResolvedValue(prepared); return prepared })
  const sent = { ...prepared, canUpload: false, canSend: false, requests: [{ ...feedback, state: 'UPLOADED' as const }], records: [returned, { ...first, id: 'corrected', invoiceNumber: 'CORRECTED-001', amendsInvoiceRecordId: first.id }], draft: { ...prepared.draft, sentRecordId: 'corrected', lockVersion: 4 } }
  vi.mocked(api.sendInvoice).mockImplementation(async () => { vi.mocked(api.getOrderInvoices).mockResolvedValue(sent); vi.mocked(api.listInvoices).mockResolvedValue(queue([])); return sent })
  open('/invoices?view=RECONCILIATION')
  expect(await screen.findByText('Returned by Buyer')).toBeVisible()
  fireEvent.click(await screen.findByRole('button', { name: 'Prepare corrected invoice' }))
  const form = screen.getByRole('form', { name: 'Upload invoice copy' })
  expect(within(form).getByLabelText('Invoice total (₱)')).toHaveValue('2750.00')
  fireEvent.change(within(form).getByLabelText('Invoice number'), { target: { value: 'CORRECTED-001' } })
  fireEvent.change(within(form).getByLabelText('Invoice total (₱)'), { target: { value: '2800.00' } })
  const replacement = new File(['new PDF'], 'replacement.pdf', { type: 'application/pdf' })
  fireEvent.change(within(form).getByLabelText(/Copy \(PDF/), { target: { files: [replacement] } })
  fireEvent.click(screen.getByRole('button', { name: 'Upload copy' }))
  expect(await screen.findByRole('heading', { name: 'CORRECTED-001' })).toBeVisible()
  expect(screen.getByRole('button', { name: 'Send' })).toBeEnabled()
  expect(api.uploadInvoice).toHaveBeenCalledWith('order-1', expect.objectContaining({ invoiceNumber: 'CORRECTED-001', amountCentavos: 280000, amendsInvoiceRecordId: first.id, file: replacement, lockVersion: 2 }), expect.any(String))
  expect(screen.queryByRole('button', { name: 'Explain amount mismatch' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Send' }))
  await waitFor(() => expect(api.sendInvoice).toHaveBeenCalledWith('order-1', 3, expect.any(String)))
  expect(await screen.findByText('No invoices match these dates.')).toBeVisible()
})

test('a correction can retain an existing attachment and keeps form values after a failed save', async () => {
  vi.mocked(api.getOrderInvoices).mockResolvedValue(detail({ records: [{ ...first, fileName: 'original.pdf' }], canSend: false }))
  vi.mocked(api.uploadInvoice).mockRejectedValueOnce(new Error('Temporarily unavailable')).mockResolvedValueOnce(detail({ records: [first], draft, canSend: true }))
  open('/invoices?view=RECONCILIATION')
  fireEvent.click(await screen.findByRole('button', { name: 'Prepare corrected invoice' }))
  const form = screen.getByRole('form', { name: 'Upload invoice copy' })
  fireEvent.change(within(form).getByLabelText('Invoice number'), { target: { value: 'CORRECTED-002' } })
  fireEvent.click(screen.getByRole('button', { name: 'Upload copy' }))
  await waitFor(() => expect(api.uploadInvoice).toHaveBeenCalledOnce())
  expect(within(form).getByLabelText('Invoice number')).toHaveValue('CORRECTED-002')
  expect(within(form).getByLabelText('Copy (PDF, JPG or PNG)')).not.toBeRequired()
  await waitFor(() => expect(screen.getByRole('button', { name: 'Upload copy' })).toBeEnabled())
  fireEvent.click(screen.getByRole('button', { name: 'Upload copy' }))
  await waitFor(() => expect(api.uploadInvoice).toHaveBeenCalledTimes(2))
  expect(vi.mocked(api.uploadInvoice).mock.calls[1]?.[1]).toMatchObject({ invoiceNumber: 'CORRECTED-002', amountCentavos: first.amountCentavos, amendsInvoiceRecordId: first.id, lockVersion: 0 })
  expect(vi.mocked(api.uploadInvoice).mock.calls[1]?.[1].file).toBeUndefined()
})

test('business presets remain editable after an invoice has been sent', async () => {
  vi.mocked(useOnboardingSnapshot).mockReturnValue({ snapshot: { permissions: ['invoices.view', 'invoices.upload'] }, loading: false, error: null, refresh: vi.fn() } as unknown as ReturnType<typeof useOnboardingSnapshot>)
  vi.mocked(api.getOrderInvoices).mockResolvedValue(detail({ canUpload: false, canSend: false }))
  vi.mocked(api.getInvoicePreset).mockResolvedValue(preset)
  vi.mocked(api.saveInvoicePreset).mockResolvedValue({ ...preset, invoicingMethod: 'MANUAL', lockVersion: 1 })
  open()
  await screen.findByRole('heading', { name: 'SAMPLE-001' })
  fireEvent.click(screen.getByRole('button', { name: 'Invoice preset' }))
  const dialog = screen.getByRole('dialog', { name: 'Invoice preset' })
  fireEvent.change(await within(dialog).findByRole('combobox', { name: 'Invoicing method' }), { target: { value: 'MANUAL' } })
  fireEvent.click(within(dialog).getByRole('button', { name: 'Save preset' }))
  await waitFor(() => expect(api.saveInvoicePreset).toHaveBeenCalledOnce())
  expect(vi.mocked(api.saveInvoicePreset).mock.calls[0]?.[0]).toMatchObject({ invoicingMethod: 'MANUAL', lockVersion: 0 })
  expect(api.uploadInvoice).not.toHaveBeenCalled()
})
