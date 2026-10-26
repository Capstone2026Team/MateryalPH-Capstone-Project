import { PortalPagePatterns } from '@materyalph/web-ui'
import { act, cleanup, fireEvent, render, screen, waitFor } from '@testing-library/react'
import type { ReactNode } from 'react'
import { MemoryRouter, Route, Routes, useNavigate } from 'react-router-dom'
import { afterEach, beforeEach, expect, test, vi } from 'vitest'
import * as directory from '../lib/user-directory-api'
import { AdminBuyerUserDetailPage, AdminVendorUserDetailPage } from './UserDirectoryPages'

vi.mock('../lib/user-directory-api', async original => ({
  ...await original<typeof import('../lib/user-directory-api')>(),
  getDirectoryBuyer: vi.fn(), getDirectoryBuyerPhoto: vi.fn(), getDirectoryVendor: vi.fn(),
}))
vi.mock('./PhaseThreeAdminPages', async original => ({
  ...await original<typeof import('./PhaseThreeAdminPages')>(),
  AdminShell: ({ children }: { children: ReactNode }) => <PortalPagePatterns.Provider value><main>{children}</main></PortalPagePatterns.Provider>,
}))

const buyerPhotoUrl = 'https://api.example.test/api/v1/admin/buyers/b1/photo?version=2&expires=1793000000&signature=fixture'
const buyer = (over: Record<string, unknown> = {}) => ({
  id: 'b1', subjectType: 'BUYER', name: 'Maria Santos', status: 'ACTIVE',
  profile: { avatarUrl: buyerPhotoUrl, email: 'maria@example.com', emailVerified: true, mobile: '+639171234567', buyerType: 'BUSINESS', companyName: 'Santos Builders', positionTitle: 'Site Engineer', industry: 'GENERAL_CONTRACTOR', area: 'Quezon City, Metro Manila',
    onboardingStatus: 'COMPLETED', joinedAt: new Date('2026-09-01T00:00:00Z'), deletedAt: null, commerceRestrictedUntil: null },
  ratings: { received: { count: 0, inquirySeriousness: null, communicationQuality: null, paymentReliability: null }, written: { count: 0 } },
  activity: { ordersTotal: 0, ordersOpen: 0, ordersCompleted: 0, ordersCancelled: 0, quotationsTotal: 0, quotationsAccepted: 0, projectsTotal: 0, workPackagesTotal: 0, conversationsTotal: 0, favoriteStores: 0, disputesTotal: 0, disputesOpen: 0, signIns30Days: 0, lastActiveAt: null },
  recentOrders: [], sanctions: [], canViewEnforcement: true, ...over,
})
const vendor = (over: Record<string, unknown> = {}) => ({
  id: 'v1', subjectType: 'VENDOR_ORGANIZATION', storeName: 'Alpha Hardware', status: 'ACTIVE',
  store: { legalName: 'Alpha Hardware Trading', registeredName: null, businessType: 'SOLE_PROPRIETORSHIP', description: 'Quality hollow blocks since 1998.', logoUrl: 'https://media.example.test/logo.png', bannerUrl: 'https://media.example.test/banner.jpg', contactEmail: 'sales@alpha.example', contactPhone: '+639175550000',
    address: '123 Aurora Boulevard, Quezon City', location: 'Quezon City, Metro Manila', verificationStatus: 'APPROVED', setupStatus: 'COMPLETED', activationStatus: 'ACTIVE', discoverabilityStatus: 'DISCOVERABLE', accountStatus: 'ACTIVE',
    activationHoldCode: null, vacationMode: false, bulkCapability: true, joinedAt: new Date('2026-08-01T00:00:00Z') },
  owner: { name: 'Rosa Alpha', email: 'rosa@alpha.example', mobile: null },
  ratings: { store: { count: 0, serviceQuality: null, speed: null }, product: { count: 0, average: null } },
  activity: { quotesSent: 0, quotesAccepted: 0, ordersTotal: 0, ordersFulfilled: 0, ordersOpen: 0, ordersCancelled: 0, disputesTotal: 0, disputesOpen: 0, listingsTotal: 0, listingsActive: 0, teamMembers: 1, lastLoginAt: null, signIns30Days: 0 },
  sanctions: [], canViewEnforcement: true, canViewVerification: true, ...over,
})

function NextBuyer() {
  const navigate = useNavigate()
  return <button onClick={() => navigate('/buyer-users/b2')}>Next Buyer</button>
}
function renderBuyer() {
  return render(<MemoryRouter initialEntries={['/buyer-users/b1']}><Routes><Route path="/buyer-users/:buyerId" element={<AdminBuyerUserDetailPage />} /></Routes><NextBuyer /></MemoryRouter>)
}
function renderVendor() {
  return render(<MemoryRouter initialEntries={['/vendor-users/v1']}><Routes><Route path="/vendor-users/:vendorId" element={<AdminVendorUserDetailPage />} /></Routes></MemoryRouter>)
}

const createObjectUrl = vi.fn<(blob: Blob) => string>()
const revokeObjectUrl = vi.fn<(url: string) => void>()
beforeEach(() => {
  vi.resetAllMocks()
  createObjectUrl.mockReturnValue('blob:buyer-photo')
  vi.stubGlobal('URL', class extends URL {
    static override createObjectURL = createObjectUrl
    static override revokeObjectURL = revokeObjectUrl
  })
})
afterEach(() => { cleanup(); vi.unstubAllGlobals() })

test('the Buyer profile reads private media once, displays a Blob URL and revokes it on unmount', async () => {
  const photo = new Blob(['sanitized-photo'], { type: 'image/png' })
  vi.mocked(directory.getDirectoryBuyer).mockResolvedValue(buyer() as never)
  vi.mocked(directory.getDirectoryBuyerPhoto).mockResolvedValue(photo)
  const view = renderBuyer()

  expect(await screen.findByRole('img', { name: 'Maria Santos profile photo' })).toHaveAttribute('src', 'blob:buyer-photo')
  expect(directory.getDirectoryBuyerPhoto).toHaveBeenCalledExactlyOnceWith('b1', buyerPhotoUrl)
  expect(createObjectUrl).toHaveBeenCalledExactlyOnceWith(photo)
  expect(screen.getByRole('link', { name: 'Open Enforcement' })).toHaveAttribute('href', '/enforcement')
  fireEvent.click(screen.getByRole('tab', { name: 'Usage and activity' }))
  expect(screen.getByText('Orders')).toBeInTheDocument()
  expect(directory.getDirectoryBuyerPhoto).toHaveBeenCalledTimes(1)

  view.unmount()
  expect(revokeObjectUrl).toHaveBeenCalledExactlyOnceWith('blob:buyer-photo')
})

test('a failed private Buyer photo keeps initials, profile details and queue actions available', async () => {
  vi.mocked(directory.getDirectoryBuyer).mockResolvedValue(buyer() as never)
  vi.mocked(directory.getDirectoryBuyerPhoto).mockRejectedValue(new Error('Expired photo signature'))
  renderBuyer()

  expect(await screen.findByRole('img', { name: 'Maria Santos profile photo unavailable' })).toHaveTextContent('MS')
  expect(screen.getByRole('heading', { level: 1, name: 'Maria Santos' })).toBeInTheDocument()
  expect(screen.getByText('maria@example.com')).toBeInTheDocument()
  expect(screen.getByRole('link', { name: 'Open Enforcement' })).toBeInTheDocument()
  expect(screen.queryByRole('alert')).not.toBeInTheDocument()
  expect(createObjectUrl).not.toHaveBeenCalled()
})

test('a deleted Buyer never requests a photo even if its response includes an avatar URL', async () => {
  vi.mocked(directory.getDirectoryBuyer).mockResolvedValue(buyer({
    status: 'DELETED', profile: { ...buyer().profile, email: 'm•••@example.com', mobile: null, deletedAt: new Date('2026-10-02T00:00:00Z') },
  }) as never)
  renderBuyer()

  expect(await screen.findByRole('heading', { level: 1, name: 'Maria Santos' })).toBeInTheDocument()
  expect(screen.getByText('m•••@example.com')).toBeInTheDocument()
  expect(screen.getByRole('img', { name: 'Maria Santos profile photo unavailable' })).toHaveTextContent('MS')
  expect(directory.getDirectoryBuyerPhoto).not.toHaveBeenCalled()
  expect(createObjectUrl).not.toHaveBeenCalled()
})

test('moving to another Buyer revokes the previous photo before displaying the new photo', async () => {
  const secondPhotoUrl = buyerPhotoUrl.replace('/b1/', '/b2/')
  vi.mocked(directory.getDirectoryBuyer).mockResolvedValueOnce(buyer() as never).mockResolvedValueOnce(buyer({
    id: 'b2', name: 'Ana Cruz', profile: { ...buyer().profile, avatarUrl: secondPhotoUrl, email: 'ana@example.com' },
  }) as never)
  vi.mocked(directory.getDirectoryBuyerPhoto).mockResolvedValue(new Blob(['photo'], { type: 'image/png' }))
  createObjectUrl.mockReturnValueOnce('blob:maria-photo').mockReturnValueOnce('blob:ana-photo')
  renderBuyer()
  await screen.findByRole('img', { name: 'Maria Santos profile photo' })

  fireEvent.click(screen.getByRole('button', { name: 'Next Buyer' }))

  expect(await screen.findByRole('img', { name: 'Ana Cruz profile photo' })).toHaveAttribute('src', 'blob:ana-photo')
  expect(revokeObjectUrl).toHaveBeenCalledWith('blob:maria-photo')
  expect(screen.queryByRole('img', { name: 'Maria Santos profile photo' })).not.toBeInTheDocument()
  expect(directory.getDirectoryBuyerPhoto).toHaveBeenLastCalledWith('b2', secondPhotoUrl)
})

test('a previous Buyer photo resolving after navigation cannot replace the current Buyer photo', async () => {
  let finishFirstPhoto!: (photo: Blob) => void
  const firstPhoto = new Promise<Blob>(resolve => { finishFirstPhoto = resolve })
  const secondPhotoUrl = buyerPhotoUrl.replace('/b1/', '/b2/')
  vi.mocked(directory.getDirectoryBuyer).mockResolvedValueOnce(buyer() as never).mockResolvedValueOnce(buyer({
    id: 'b2', name: 'Ana Cruz', profile: { ...buyer().profile, avatarUrl: secondPhotoUrl },
  }) as never)
  vi.mocked(directory.getDirectoryBuyerPhoto).mockReturnValueOnce(firstPhoto).mockResolvedValueOnce(new Blob(['ana'], { type: 'image/png' }))
  createObjectUrl.mockReturnValue('blob:ana-photo')
  renderBuyer()
  await waitFor(() => expect(directory.getDirectoryBuyerPhoto).toHaveBeenCalledTimes(1))
  expect(screen.getByRole('img', { name: 'Loading Maria Santos profile photo' })).toHaveTextContent('MS')

  fireEvent.click(screen.getByRole('button', { name: 'Next Buyer' }))
  await screen.findByRole('img', { name: 'Ana Cruz profile photo' })
  await act(async () => { finishFirstPhoto(new Blob(['maria'], { type: 'image/png' })); await firstPhoto })

  expect(screen.getByRole('img', { name: 'Ana Cruz profile photo' })).toHaveAttribute('src', 'blob:ana-photo')
  expect(screen.queryByRole('img', { name: 'Maria Santos profile photo' })).not.toBeInTheDocument()
  expect(createObjectUrl).toHaveBeenCalledTimes(1)
})

test('the Vendor profile displays the store banner and logo with accessible names', async () => {
  vi.mocked(directory.getDirectoryVendor).mockResolvedValue(vendor() as never)
  renderVendor()

  expect(await screen.findByRole('img', { name: 'Alpha Hardware store banner' })).toHaveAttribute('src', 'https://media.example.test/banner.jpg')
  expect(screen.getByRole('img', { name: 'Alpha Hardware logo' })).toHaveAttribute('src', 'https://media.example.test/logo.png')
  expect(screen.getByRole('heading', { level: 1, name: 'Alpha Hardware' })).toBeInTheDocument()
  expect(screen.getByRole('link', { name: 'Open verification case' })).toHaveAttribute('href', '/vendor-verification/v1')
  expect(screen.getAllByRole('tab').map(tab => tab.textContent)).toEqual(['Store profile', 'Ratings and reviews', 'Usage and activity', 'Product listings'])
})

test('failed Vendor branding falls back while store details, actions and activity remain usable', async () => {
  vi.mocked(directory.getDirectoryVendor).mockResolvedValue(vendor() as never)
  renderVendor()
  fireEvent.error(await screen.findByRole('img', { name: 'Alpha Hardware store banner' }))
  fireEvent.error(screen.getByRole('img', { name: 'Alpha Hardware logo' }))

  expect(screen.getByText('Banner unavailable')).toBeInTheDocument()
  expect(screen.getByRole('img', { name: 'Alpha Hardware logo unavailable' })).toHaveTextContent('AH')
  expect(screen.getByText('Quality hollow blocks since 1998.')).toBeInTheDocument()
  expect(screen.getByText('sales@alpha.example')).toBeInTheDocument()
  expect(screen.getByRole('link', { name: 'Open Enforcement' })).toBeInTheDocument()
  expect(screen.getByRole('link', { name: 'Open verification case' })).toBeInTheDocument()
  fireEvent.click(screen.getByRole('tab', { name: 'Usage and activity' }))
  expect(screen.getByText('Orders fulfilled')).toBeInTheDocument()
  expect(screen.queryByRole('alert')).not.toBeInTheDocument()
})
