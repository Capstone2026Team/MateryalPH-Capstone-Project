import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import * as api from '../lib/disputes-api'
import type { DisputeDetail, VendorOrderInvoices } from '../lib/disputes-api'
import { useOnboardingSnapshot } from '../lib/vendor-status'
import { VendorDisputeDetailPage } from './DisputePages'
import { OrderInvoicePanel } from './InvoicePages'

vi.mock('../lib/disputes-api', async original => ({ ...await original<typeof import('../lib/disputes-api')>(), getDispute: vi.fn(), respond: vi.fn(), getOrderInvoices: vi.fn(), uploadInvoice: vi.fn() }))
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

beforeEach(() => { vi.clearAllMocks(); window.scrollTo = vi.fn() as unknown as typeof window.scrollTo })

test('a role without dispute access is denied and the case is never requested', async () => {
  snapshot(['portal.orders'])
  openCase()
  expect(screen.getByText(/not available to your role/)).toBeInTheDocument()
  expect(api.getDispute).not.toHaveBeenCalled()
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
