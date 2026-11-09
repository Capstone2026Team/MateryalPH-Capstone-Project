import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import { ResponseError, parseDate } from '@materyalph/api-client-ts'
import * as api from '../lib/product-compliance-api'
import { AdminProductComplianceCasePage, AdminProductComplianceQueuePage } from './ProductCompliancePages'

vi.mock('../lib/product-compliance-api', async original => ({ ...await original<typeof import('../lib/product-compliance-api')>(), listComplianceQueue: vi.fn(), getComplianceCase: vi.fn(), decideCompliance: vi.fn(), getComplianceFileUrl: vi.fn(), listRegisters: vi.fn(), importRegister: vi.fn(), activateRegister: vi.fn() }))

function caseDetail(status = 'PENDING_ADMIN_REVIEW') {
  return {
    submission: { id: 'submission-1', version: 2, lock_version: 1, path: 'MANUAL', status, marking_type: 'PS_MARK', declared: { marking_type: 'PS_MARK', certificate_number: 'Q-1234', manufacturer_name: 'Sample Cement Corporation' }, submitted_at: '2026-09-27T01:00:00Z', decided_at: status === 'PENDING_ADMIN_REVIEW' ? null : '2026-09-27T02:00:00Z', rule_version: 1 },
    listing: { id: 'listing-1', display_name: 'Portland cement 40 kg', vendor_sku: 'CEM-40', status: 'PENDING_ADMIN_REVIEW', material_name: 'Portland cement', public_store_name: 'Test Supply', media_file_ids: [] },
    rule: { id: 'rule-1', version: 1, required_marking: 'PS_OR_ICC', product_name: 'PORTLAND CEMENT', reference_standard: 'PNS 07:2018', technical_regulation: 'DAO 17-06:2017', scope: 'Type I', marking_requirements: ['PS Mark'], source_reference: 'DTI-BPS' },
    evidence: [{ id: 'evidence-1', evidence_kind: 'MARKING_PHOTO', path: 'MANUAL', file_id: 'file-1', content_type: 'image/jpeg', byte_size: 1000, scan_state: 'CLEAN', checksum_prefix: 'abc123' }],
    extractions: [], reference_match: { result: 'UNAVAILABLE', provider: 'DTI_BPS_REGISTER', source_reference: null, checked_at: '2026-09-27T01:00:00Z', details: {} },
    previous_submissions: [], reviews: [], official_references: [{ label: 'DTI-BPS PS and ICC Marks', url: 'https://bps.dti.gov.ph/product-certification/ps-and-icc-marks' }],
  }
}

beforeEach(() => {
  vi.clearAllMocks()
  vi.mocked(api.listRegisters).mockResolvedValue({ items: [], meta: {} })
  vi.mocked(api.getComplianceFileUrl).mockResolvedValue({ url: 'https://example.test/evidence', expiresAt: new Date() })
  vi.mocked(api.getComplianceCase).mockResolvedValue(caseDetail())
})

function open(path: string) {
  return render(<MemoryRouter initialEntries={[path]}><Routes><Route path="/product-compliance" element={<AdminProductComplianceQueuePage />} /><Route path="/product-compliance/:submissionId" element={<AdminProductComplianceCasePage />} /></Routes></MemoryRouter>)
}

test('compliance tab badges use full server totals, including empty statuses', async () => {
  vi.mocked(api.listComplianceQueue).mockResolvedValue({ items: [], meta: { total: 27, last_page: 2, counts: { PENDING_ADMIN_REVIEW: 27, CHANGES_REQUIRED: 0, VERIFIED: 9, REJECTED: 0, SUPERSEDED: 2, ALL: 38 } } })
  open('/product-compliance?page=2')
  expect(await screen.findByRole('tab', { name: 'Pending Admin Review 27' })).toHaveAttribute('aria-selected', 'true')
  expect(screen.getByRole('tab', { name: 'Changes Required 0' })).toBeInTheDocument()
  expect(screen.getByRole('tab', { name: 'Verified 9' })).toBeInTheDocument()
  expect(screen.getByRole('tab', { name: 'All submissions 38' })).toBeInTheDocument()
})

test('status sections switch immediately while draft filters apply explicitly and preserve submission dates', async () => {
  vi.mocked(api.listComplianceQueue).mockResolvedValue({ items: [], meta: { total: 0, last_page: 1 } })
  open('/product-compliance?path=MANUAL&reference=UNMATCHED&from=2026-10-01&to=2026-10-31&page=2')
  await screen.findByText('No submissions on this page.')
  expect(screen.queryByRole('combobox', { name: 'Status' })).not.toBeInTheDocument()
  const calls = vi.mocked(api.listComplianceQueue).mock.calls.length
  fireEvent.change(screen.getByRole('combobox', { name: 'Input path' }), { target: { value: 'QR' } })
  expect(api.listComplianceQueue).toHaveBeenCalledTimes(calls)
  fireEvent.click(screen.getByRole('tab', { name: 'Verified' }))
  await waitFor(() => expect(api.listComplianceQueue).toHaveBeenLastCalledWith(expect.objectContaining({ status: 'VERIFIED', path: 'MANUAL', referenceResult: 'UNMATCHED', page: 1, from: parseDate('2026-10-01'), to: parseDate('2026-10-31') })))
  expect(screen.getByRole('combobox', { name: 'Input path' })).toHaveValue('QR')
  await waitFor(() => expect(screen.getByRole('button', { name: 'Apply filters' })).toBeEnabled())
  fireEvent.click(screen.getByRole('button', { name: 'Apply filters' }))
  await waitFor(() => expect(api.listComplianceQueue).toHaveBeenLastCalledWith(expect.objectContaining({ status: 'VERIFIED', path: 'QR', page: 1 })))
})

test('queue loads oldest pending submissions with register result text', async () => {
  vi.mocked(api.listComplianceQueue).mockResolvedValue({ items: [{ id: 'submission-1', version: 2, path: 'MANUAL', status: 'PENDING_ADMIN_REVIEW', reviewMode: 'MANUAL_REVIEW', listingId: 'listing-1', displayName: 'Portland cement 40 kg', vendorSku: 'CEM-40', publicStoreName: 'Test Supply', productName: 'PORTLAND CEMENT', referenceStandard: 'PNS 07:2018', referenceResult: 'UNCERTAIN', submittedAt: '2026-09-27T01:00:00Z' }], meta: { total: 1, last_page: 1 } })
  vi.mocked(api.listRegisters).mockResolvedValue({ items: [{ id: 'register-1', registerKind: 'PS_LICENSE', sourceReference: 'DTI-BPS', snapshotDate: new Date('2026-07-31'), status: 'ACTIVE', sourceChannel: 'UPLOAD', stale: true, rowCount: 7890, rejectedRowCount: 0 }], meta: {} })
  open('/product-compliance')
  const table = await screen.findByRole('table', { name: 'Product compliance submissions' })
  expect(within(table).getByText('Uncertain')).toBeVisible()
  expect(within(table).getByText('Vendor requested review')).toBeVisible()
  expect(api.listComplianceQueue).toHaveBeenCalledWith(expect.objectContaining({ status: 'PENDING_ADMIN_REVIEW', sort: 'oldest' }))
  fireEvent.click(screen.getByRole('button', { name: 'DTI-BPS register snapshots' }))
  expect(screen.getByRole('heading', { name: 'DTI-BPS register snapshots' })).toBeVisible()
  // The government sheets disable downloads, so the snapshot DTI-BPS provides is imported as .xlsx or .csv.
  expect(screen.getByLabelText(/Register file/)).toHaveAttribute('accept', expect.stringContaining('.xlsx'))
  const snapshots = await screen.findByRole('table', { name: 'Register snapshots' })
  expect(within(snapshots).getByText(/Older than a month/)).toBeVisible()
  expect(within(snapshots).getByText('Admin upload')).toBeVisible()
})

test('case names the exact target version and requires a reason to return or reject', async () => {
  open('/product-compliance/submission-1')
  expect(await screen.findByText(/Target: submission version 2 · lock 1 · 1 evidence file/)).toBeVisible()
  expect(screen.getByRole('navigation', { name: 'Review sections' })).toBeVisible()
  fireEvent.click(screen.getByRole('radio', { name: 'Return for correction' }))
  expect(screen.getByRole('textbox', { name: /Reason/ })).toBeRequired()
  fireEvent.click(screen.getByRole('button', { name: 'Record decision' }))
  expect(api.decideCompliance).not.toHaveBeenCalled()
  vi.mocked(api.decideCompliance).mockResolvedValue(caseDetail('CHANGES_REQUIRED'))
  fireEvent.change(screen.getByRole('textbox', { name: /Reason/ }), { target: { value: 'The licence number is not legible.' } })
  fireEvent.click(screen.getByRole('button', { name: 'Record decision' }))
  await waitFor(() => expect(api.decideCompliance).toHaveBeenCalledWith('submission-1', expect.objectContaining({ decision: 'CHANGES_REQUIRED', lockVersion: 1, reason: 'The licence number is not legible.' })))
  expect(await screen.findByText(/Store Activation is unaffected/)).toBeVisible()
  expect(screen.queryByRole('button', { name: 'Record decision' })).not.toBeInTheDocument()
})

test('a stale decision shows a conflict banner with a refresh action', async () => {
  const response = new Response(JSON.stringify({ data: null, meta: {}, errors: [{ code: 'STALE_REVIEW', message: 'This submission changed or was already decided. Refresh to review the current version.', details: {} }] }), { status: 409, headers: { 'Content-Type': 'application/json' } })
  vi.mocked(api.decideCompliance).mockRejectedValue(new ResponseError(response))
  open('/product-compliance/submission-1')
  fireEvent.click(await screen.findByRole('button', { name: 'Record decision' }))
  expect(await screen.findByRole('button', { name: 'Refresh case' })).toBeVisible()
  fireEvent.click(screen.getByRole('button', { name: 'Refresh case' }))
  await waitFor(() => expect(api.getComplianceCase).toHaveBeenCalledTimes(2))
})

test('private marking evidence and public product photos both preview', async () => {
  const apiBase = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'
  const evidenceUrl = `${new URL(apiBase, window.location.origin).href.replace(/\/$/, '')}/catalog-files/file-1/content?expires=1&signature=test`
  const photoUrl = 'https://res.cloudinary.com/demo/image/upload/listing.jpg'
  vi.mocked(api.getComplianceCase).mockResolvedValue({ ...caseDetail(), listing: { ...caseDetail().listing, media_file_ids: ['media-1'] } })
  vi.mocked(api.getComplianceFileUrl).mockImplementation(async fileId => ({ url: fileId === 'media-1' ? photoUrl : evidenceUrl, expiresAt: new Date() }))
  const fetcher = vi.fn(async (..._args: unknown[]) => new Response('synthetic image', { headers: { 'Content-Type': 'image/jpeg' } }))
  vi.stubGlobal('fetch', fetcher)
  vi.stubGlobal('URL', Object.assign(URL, { createObjectURL: vi.fn(() => 'blob:evidence'), revokeObjectURL: vi.fn() }))
  open('/product-compliance/submission-1')
  expect(await screen.findByRole('img', { name: 'Marking photo · Manual' })).toHaveAttribute('src', 'blob:evidence')
  fireEvent.click(screen.getByRole('button', { name: 'Listing and material' }))
  expect(await screen.findByRole('img', { name: 'Public product photo 1' })).toHaveAttribute('src', photoUrl)
  expect(screen.queryByText(/Preview could not be loaded/)).not.toBeInTheDocument()
  // Without a local API base the shell's own session reads share this stub; count only the preview requests.
  const requested = fetcher.mock.calls.map(([input]) => String(input))
  expect(requested.filter(url => url === new URL(evidenceUrl).href)).toHaveLength(1)
  expect(requested).not.toContain(photoUrl)
  expect(fetcher).toHaveBeenCalledWith(new URL(evidenceUrl), expect.objectContaining({ credentials: 'include' }))
  vi.unstubAllGlobals()
})

test('a decided submission is read-only and extraction is labelled as assistance', async () => {
  vi.mocked(api.getComplianceCase).mockResolvedValue(caseDetail('VERIFIED'))
  open('/product-compliance/submission-1')
  expect(await screen.findByText(/Decisions are immutable/)).toBeVisible()
  expect(screen.queryByRole('button', { name: 'Record decision' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Register and extraction' }))
  expect(screen.getByText(/No active register snapshot was available/)).toBeVisible()
  expect(screen.getByText(/never evidence of authenticity/)).toBeVisible()
})
