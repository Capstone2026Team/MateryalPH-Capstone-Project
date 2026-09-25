import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { beforeEach, describe, expect, test, vi } from 'vitest'
import { AdminVendorVerificationDetailPage } from './PhaseThreeAdminPages'

const api = vi.hoisted(() => ({
  getVendorVerificationCase: vi.fn(),
  decideVendorVerificationRequirement: vi.fn(),
  getAdminVendorEvidenceUrl: vi.fn(),
}))

vi.mock('../lib/vendor-verification-api', () => ({
  ...api,
  readableVerificationError: async () => 'Review failed',
  listVendorVerificationQueue: vi.fn(),
  restrictVendorActivation: vi.fn(),
  restoreVendorActivation: vi.fn(),
}))

vi.mock('@materyalph/web-ui', async importOriginal => {
  const actual = await importOriginal<typeof import('@materyalph/web-ui')>()
  return {
    ...actual,
    PortalShell: ({ children }: { children: React.ReactNode }) => <main>{children}</main>,
    PrivateEvidenceGallery: ({ items }: { items: { label: string }[] }) => <div>{items.map(item => <p key={item.label}>Inline preview: {item.label}</p>)}</div>,
  }
})

const caseDetail = {
  organization: { id: 'case-1', store_name: 'Test Supply', registered_name: 'Test Supply Inc.', business_type: 'CORPORATION', store_email: 'store@example.test' },
  sections: { STORE_VERIFICATION: [
    { key: 'business_type', label: 'business_type', level: 'REQUIRED', status: 'PENDING_VERIFICATION', lock_version: 2 },
    { key: 'business_information', label: 'business_information', level: 'REQUIRED', status: 'PENDING_VERIFICATION', lock_version: 3 },
    { key: 'identity_evidence', label: 'Government ID front', level: 'REQUIRED', status: 'PENDING_VERIFICATION', lock_version: 4 },
    { key: 'identity_back_evidence', label: 'Government ID back', level: 'REQUIRED', status: 'PENDING_VERIFICATION', lock_version: 5 },
    { key: 'bir_cor', label: 'BIR COR', level: 'REQUIRED', status: 'PENDING_VERIFICATION', lock_version: 6 },
  ] },
  legal_identity: { first_name: 'Juan', surname: 'Dela Cruz', id_type: 'DRIVERS_LICENSE', id_number_last4: '1234' },
  documents: [
    { id: 'front', requirement_key: 'identity_evidence', file_id: 'front-file', version: 1, scan_state: 'CLEAN' },
    { id: 'back', requirement_key: 'identity_back_evidence', file_id: 'back-file', version: 1, scan_state: 'CLEAN' },
  ],
  readiness: { ready: false, blockers: [] },
  reviews: [],
}

function renderCase() {
  return render(<MemoryRouter initialEntries={['/vendor-verification/case-1']}><Routes><Route path="/vendor-verification/:organizationId" element={<AdminVendorVerificationDetailPage />} /></Routes></MemoryRouter>)
}

describe('Admin verification case review', () => {
  beforeEach(() => {
    api.getVendorVerificationCase.mockResolvedValue(caseDetail)
    api.decideVendorVerificationRequirement.mockResolvedValue(caseDetail)
  })

  test('reviews business information as one action and loads both ID files with identity values', async () => {
    renderCase()
    const list = await screen.findByRole('region', { name: 'Verification requirements' })
    expect(within(list).getAllByRole('button', { name: 'Review Business information' })).toHaveLength(1)
    expect(within(list).queryByRole('button', { name: /review business_type/i })).not.toBeInTheDocument()
    expect(screen.getAllByText('Test Supply Inc.')).toHaveLength(2)
    fireEvent.click(within(list).getByRole('button', { name: 'Review Government ID — Registered legal identity' }))
    expect(screen.getByText('Juan Dela Cruz')).toBeVisible()
    expect(screen.getByText('Inline preview: Government ID — Front / identity page')).toBeVisible()
    expect(screen.getByText('Inline preview: Government ID — Back')).toBeVisible()
    expect(screen.getByLabelText('Verified document number')).toBeVisible()
  })

  test('sends one version guarded business decision', async () => {
    renderCase()
    await screen.findByRole('region', { name: 'Verification requirements' })
    fireEvent.click(screen.getByRole('button', { name: 'Record requirement decision' }))
    await waitFor(() => expect(api.decideVendorVerificationRequirement).toHaveBeenCalledWith('case-1', 'business_information_group', expect.objectContaining({
      decision: 'APPROVED', requirementVersions: { business_type: 2, business_information: 3 },
    })))
  })
})
