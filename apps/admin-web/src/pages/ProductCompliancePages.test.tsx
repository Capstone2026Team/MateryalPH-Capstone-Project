import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import { ResponseError } from '@materyalph/api-client-ts'
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

test('queue loads oldest pending submissions with register result text', async () => {
  vi.mocked(api.listComplianceQueue).mockResolvedValue({ items: [{ id: 'submission-1', version: 2, path: 'MANUAL', status: 'PENDING_ADMIN_REVIEW', listingId: 'listing-1', displayName: 'Portland cement 40 kg', vendorSku: 'CEM-40', publicStoreName: 'Test Supply', productName: 'PORTLAND CEMENT', referenceStandard: 'PNS 07:2018', referenceResult: 'UNCERTAIN', submittedAt: '2026-09-27T01:00:00Z' }], meta: { total: 1, last_page: 1 } })
  open('/product-compliance')
  const table = await screen.findByRole('table', { name: 'Product compliance submissions' })
  expect(within(table).getByText('Uncertain')).toBeVisible()
  expect(api.listComplianceQueue).toHaveBeenCalledWith(expect.objectContaining({ status: 'PENDING_ADMIN_REVIEW', sort: 'oldest' }))
  expect(screen.getByRole('heading', { name: 'DTI-BPS register snapshots' })).toBeVisible()
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

test('a decided submission is read-only and extraction is labelled as assistance', async () => {
  vi.mocked(api.getComplianceCase).mockResolvedValue(caseDetail('VERIFIED'))
  open('/product-compliance/submission-1')
  expect(await screen.findByText(/Decisions are immutable/)).toBeVisible()
  expect(screen.queryByRole('button', { name: 'Record decision' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Register and extraction' }))
  expect(screen.getByText(/No active register snapshot was available/)).toBeVisible()
  expect(screen.getByText(/never evidence of authenticity/)).toBeVisible()
})
