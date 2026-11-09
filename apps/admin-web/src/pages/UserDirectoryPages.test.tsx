import { PortalPagePatterns } from '@materyalph/web-ui'
import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import type { ReactNode } from 'react'
import { MemoryRouter, Route, Routes, useLocation } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import * as trust from '../lib/trust-api'
import * as directory from '../lib/user-directory-api'
import * as operations from '../lib/operations-api'
import { AdminBuyerUserDetailPage, AdminBuyerUsersPage, AdminVendorUserDetailPage, AdminVendorUsersPage } from './UserDirectoryPages'

vi.mock('../lib/trust-api', async original => ({ ...await original<typeof import('../lib/trust-api')>(), getScore: vi.fn() }))
vi.mock('../lib/operations-api', async original => ({ ...await original<typeof import('../lib/operations-api')>(), getSubject: vi.fn() }))
vi.mock('../lib/user-directory-api', async original => ({
  ...await original<typeof import('../lib/user-directory-api')>(),
  listDirectoryBuyers: vi.fn(), getDirectoryBuyer: vi.fn(), listDirectoryBuyerReviews: vi.fn(),
  listDirectoryVendors: vi.fn(), getDirectoryVendor: vi.fn(), listDirectoryVendorReviews: vi.fn(), listDirectoryVendorListings: vi.fn(),
}))
// The real shell supplies the shared page patterns, which render workspace sections as tabs.
vi.mock('./PhaseThreeAdminPages', async original => ({ ...await original<typeof import('./PhaseThreeAdminPages')>(), AdminShell: ({ children }: { children: ReactNode }) => <PortalPagePatterns.Provider value><main>{children}</main></PortalPagePatterns.Provider> }))

const meta = (over: Record<string, unknown> = {}) => ({ page: 1, perPage: 20, total: 3, lastPage: 1, statusCounts: { ACTIVE: 2, SUSPENDED: 1 }, ...over })
const summary = { score: 4.5, count: 6, minimumCount: 5, windowDays: 90, inquirySeriousness: 4.5, communicationQuality: 4, paymentReliability: 5 }
const buyers = [
  { rating: summary, id: 'b1', name: 'Maria Santos', email: 'maria@example.com', status: 'ACTIVE', buyerType: 'BUSINESS', companyName: 'Santos Builders', joinedAt: new Date('2026-09-01T00:00:00Z'), lastActiveAt: null },
  { rating: { ...summary, score: null, count: 2 }, id: 'b2', name: 'Ana Cruz', email: 'ana@example.com', status: 'SUSPENDED', buyerType: 'INDIVIDUAL', companyName: null, joinedAt: new Date('2026-09-20T00:00:00Z'), lastActiveAt: null },
]
const vendors = [
  { vps: '4.25', id: 'v1', storeName: 'Alpha Hardware', ownerName: 'Rosa Alpha', ownerEmail: 'rosa@alpha.example', status: 'ACTIVE', verificationStatus: 'APPROVED', discoverabilityStatus: 'DISCOVERABLE', accountStatus: 'ACTIVE', location: 'Quezon City, Metro Manila', joinedAt: new Date('2026-08-01T00:00:00Z') },
  { vps: null, id: 'v2', storeName: 'Beta Lumber', ownerName: null, ownerEmail: null, status: 'SUSPENDED', verificationStatus: 'EXPIRED', discoverabilityStatus: 'NOT_DISCOVERABLE', accountStatus: 'ACTIVE', location: null, joinedAt: new Date('2026-01-01T00:00:00Z') },
]
const review = (over: Record<string, unknown> = {}) => ({ id: 'r1', type: 'BUYER', ratings: { payment_reliability: 5, communication_quality: 4 }, comment: 'Pays on time.', authorName: 'Rated Store', orderReference: 'ORD-1', storeName: 'Rated Store', productName: null,
  moderationState: 'NONE', visibility: 'PUBLIC', submittedAt: new Date('2026-10-01T02:00:00Z'), ...over })

function Where() { return <p data-testid="where">{useLocation().pathname}</p> }
function renderAt(path: string, element: ReactNode, route: string) {
  return render(<MemoryRouter initialEntries={[path]}><Routes><Route path={route} element={element} /><Route path="*" element={<Where />} /></Routes></MemoryRouter>)
}

beforeEach(() => vi.clearAllMocks())

test('the Buyer list shows name, email, status and join date, counts every status, and opens a Buyer from its row', async () => {
  vi.mocked(directory.listDirectoryBuyers).mockResolvedValue({ items: buyers, meta: meta() } as never)
  renderAt('/buyer-users', <AdminBuyerUsersPage />, '/buyer-users')

  const table = await screen.findByRole('region', { name: 'Buyer users' })
  expect(within(table).getAllByRole('columnheader').map(header => header.textContent)).toEqual(['Name', 'Email', 'Buyer rating (CCS)', 'Status', 'Date joined'])
  expect(within(table).getByText('maria@example.com')).toBeInTheDocument()
  expect(within(table).getByText('Santos Builders')).toBeInTheDocument()
  expect(within(table).getByText('Suspended')).toBeInTheDocument()
  expect(within(table).getByText(/Sept? 1, 2026/)).toBeInTheDocument()
  expect(screen.getAllByRole('tab').map(tab => tab.textContent)).toEqual(['Active2', 'Pending Verification0', 'Suspended1', 'Deactivated0', 'Deleted0'])
  expect(screen.getByRole('tab', { name: /Active/ })).toHaveAttribute('aria-selected', 'true')
  expect(vi.mocked(directory.listDirectoryBuyers).mock.calls[0]?.[0]).toMatchObject({ status: 'ACTIVE', sort: 'joined_desc', page: 1 })

  fireEvent.click(within(table).getByText('Ana Cruz').closest('tr') as HTMLElement)
  expect(await screen.findByTestId('where')).toHaveTextContent('/buyer-users/b2')
})

test('the Buyer list searches on submit with the API minimum, filters by status and type, sorts, resets and paginates', async () => {
  vi.mocked(directory.listDirectoryBuyers).mockResolvedValue({ items: buyers, meta: meta({ lastPage: 2, total: 24 }) } as never)
  renderAt('/buyer-users', <AdminBuyerUsersPage />, '/buyer-users')
  await screen.findByRole('region', { name: 'Buyer users' })
  const calls = vi.mocked(directory.listDirectoryBuyers).mock.calls
  const lastCall = () => calls.at(-1)?.[0]

  const search = screen.getByRole('searchbox', { name: 'Search Buyers' })
  fireEvent.change(search, { target: { value: 'm' } })
  fireEvent.submit(search.closest('form') as HTMLFormElement)
  expect(screen.getByRole('alert')).toHaveTextContent('at least 2 characters')
  expect(calls.every(call => call[0].q === undefined)).toBe(true)

  fireEvent.change(search, { target: { value: ' santos ' } })
  fireEvent.submit(search.closest('form') as HTMLFormElement)
  await waitFor(() => expect(lastCall()).toMatchObject({ q: 'santos', page: 1 }))
  expect(screen.queryByRole('alert')).not.toBeInTheDocument()

  fireEvent.click(screen.getByRole('tab', { name: /Suspended/ }))
  await waitFor(() => expect(lastCall()).toMatchObject({ q: 'santos', status: 'SUSPENDED' }))
  fireEvent.change(screen.getByLabelText('Buyer type'), { target: { value: 'BUSINESS' } })
  await waitFor(() => expect(lastCall()).toMatchObject({ buyerType: 'BUSINESS' }))
  fireEvent.change(screen.getByLabelText('Sort by'), { target: { value: 'name_asc' } })
  await waitFor(() => expect(lastCall()).toMatchObject({ sort: 'name_asc' }))

  fireEvent.click(await screen.findByRole('button', { name: 'Next' }))
  await waitFor(() => expect(lastCall()).toMatchObject({ page: 2, sort: 'name_asc' }))
  fireEvent.click(screen.getByRole('button', { name: 'Reset filters' }))
  await waitFor(() => expect(lastCall()).toMatchObject({ sort: 'joined_desc', page: 1 }))
  expect(lastCall()).not.toHaveProperty('q')
  expect(lastCall()).toMatchObject({ status: 'ACTIVE' })
  expect(lastCall()).not.toHaveProperty('buyerType')
})

test('the Buyer list shows an empty state, and a failure with a retry that recovers', async () => {
  vi.mocked(directory.listDirectoryBuyers).mockResolvedValueOnce({ items: [], meta: meta({ total: 0, statusCounts: {} }) } as never)
  const view = renderAt('/buyer-users', <AdminBuyerUsersPage />, '/buyer-users')
  expect(await screen.findByText(/No users match these filters/)).toBeInTheDocument()
  expect(screen.queryByRole('region', { name: 'Buyer users' })).not.toBeInTheDocument()
  view.unmount()

  vi.mocked(directory.listDirectoryBuyers).mockRejectedValueOnce(new Error('offline')).mockResolvedValueOnce({ items: buyers, meta: meta() } as never)
  renderAt('/buyer-users', <AdminBuyerUsersPage />, '/buyer-users')
  expect(await screen.findByRole('alert')).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: /Try again/ }))
  expect(await screen.findByRole('region', { name: 'Buyer users' })).toBeInTheDocument()
})

test('older Buyers appear by default despite saved analytics dates, and a date-only filter can be reset', async () => {
  const saved = { label: 'Last 30 days', from: '2026-10-09', to: '2026-11-07' }
  localStorage.setItem('materyalph:date-filter:v1', JSON.stringify(saved))
  vi.mocked(directory.listDirectoryBuyers).mockImplementation(async filters => ({ items: filters.from || filters.to ? [] : buyers, meta: meta({ total: filters.from || filters.to ? 0 : 2 }) } as never))
  renderAt('/buyer-users', <AdminBuyerUsersPage />, '/buyer-users')
  expect(await screen.findByRole('link', { name: 'Maria Santos' })).toBeInTheDocument()
  expect(screen.getByRole('button', { name: 'All dates' })).toBeInTheDocument()
  expect(directory.listDirectoryBuyers).toHaveBeenLastCalledWith(expect.not.objectContaining({ from: expect.anything() }))
  fireEvent.click(screen.getByRole('button', { name: 'All dates' }))
  fireEvent.click(within(screen.getByRole('dialog', { name: 'Joined dates' })).getByRole('button', { name: 'Last 30 days' }))
  fireEvent.click(screen.getByRole('button', { name: 'Apply' }))
  expect(await screen.findByText(/No users match these filters/)).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Reset filters' }))
  expect(await screen.findByRole('link', { name: 'Maria Santos' })).toBeInTheDocument()
  const filters = vi.mocked(directory.listDirectoryBuyers).mock.calls.at(-1)?.[0]
  expect(filters).not.toHaveProperty('from')
  expect(filters).not.toHaveProperty('to')
  expect(JSON.parse(localStorage.getItem('materyalph:date-filter:v1')!)).toEqual(saved)
})

test('Vendor join dates also default to all dates independently of analytics', async () => {
  localStorage.setItem('materyalph:date-filter:v1', JSON.stringify({ label: 'Last 30 days', from: '2026-10-09', to: '2026-11-07' }))
  vi.mocked(directory.listDirectoryVendors).mockResolvedValue({ items: vendors, meta: meta() } as never)
  renderAt('/vendor-users', <AdminVendorUsersPage />, '/vendor-users')
  expect(await screen.findByRole('link', { name: 'Alpha Hardware' })).toBeInTheDocument()
  expect(screen.getByRole('button', { name: 'All dates' })).toBeInTheDocument()
  for (const [filters] of vi.mocked(directory.listDirectoryVendors).mock.calls) {
    expect(filters).not.toHaveProperty('from')
    expect(filters).not.toHaveProperty('to')
  }
})

test('the Vendor list shows store, owner, status and join date, filters, and opens a store from its row', async () => {
  vi.mocked(directory.listDirectoryVendors).mockResolvedValue({ items: vendors, meta: meta({ total: 2, statusCounts: { ACTIVE: 1, SUSPENDED: 1 } }) } as never)
  renderAt('/vendor-users', <AdminVendorUsersPage />, '/vendor-users')

  const table = await screen.findByRole('region', { name: 'Vendor users' })
  expect(within(table).getAllByRole('columnheader').map(header => header.textContent)).toEqual(['Store name', 'Owner', 'VPS rating', 'Status', 'Date joined'])
  expect(within(table).getByText('Rosa Alpha')).toBeInTheDocument()
  expect(within(table).getByText('No active Owner')).toBeInTheDocument()
  expect(within(table).getByText('Verification: Expired')).toBeInTheDocument()
  expect(screen.getAllByRole('tab').map(tab => tab.textContent)).toEqual(['Active1', 'Ready0', 'Not Ready0', 'Restricted0', 'Suspended1'])

  fireEvent.change(screen.getByLabelText('Verification'), { target: { value: 'EXPIRED' } })
  await waitFor(() => expect(vi.mocked(directory.listDirectoryVendors).mock.calls.at(-1)?.[0]).toMatchObject({ verification: 'EXPIRED', page: 1 }))
  fireEvent.change(screen.getByLabelText('Discovery'), { target: { value: 'NOT_DISCOVERABLE' } })
  await waitFor(() => expect(vi.mocked(directory.listDirectoryVendors).mock.calls.at(-1)?.[0]).toMatchObject({ verification: 'EXPIRED', discoverability: 'NOT_DISCOVERABLE' }))

  fireEvent.click(within(await screen.findByRole('region', { name: 'Vendor users' })).getByText('Alpha Hardware').closest('tr') as HTMLElement)
  expect(await screen.findByTestId('where')).toHaveTextContent('/vendor-users/v1')
})

const buyerProfile = (over: Record<string, unknown> = {}) => ({ rating: summary,
  id: 'b1', subjectType: 'BUYER', name: 'Maria Santos', status: 'ACTIVE',
  profile: { email: 'maria@example.com', emailVerified: true, mobile: '+639171234567', buyerType: 'BUSINESS', companyName: 'Santos Builders', positionTitle: 'Site Engineer', industry: 'GENERAL_CONTRACTOR', area: 'Quezon City, Metro Manila',
    onboardingStatus: 'COMPLETED', joinedAt: new Date('2026-09-01T00:00:00Z'), deletedAt: null, commerceRestrictedUntil: null },
  ratings: { received: { count: 2, inquirySeriousness: '4.50', communicationQuality: '4.00', paymentReliability: null }, written: { count: 1 } },
  activity: { ordersTotal: 5, ordersOpen: 1, ordersCompleted: 3, ordersCancelled: 1, quotationsTotal: 4, quotationsAccepted: 2, projectsTotal: 1, workPackagesTotal: 2, conversationsTotal: 6, favoriteStores: 3, disputesTotal: 2, disputesOpen: 1, signIns30Days: 8, lastActiveAt: new Date('2026-10-01T02:00:00Z') },
  recentOrders: [{ id: 'o1', reference: 'ORD-AAA', orderState: 'COMPLETED', paymentState: 'PAID', procurementType: 'ITEM_BASED', storeName: 'Alpha Hardware', createdAt: new Date('2026-09-15T00:00:00Z') }],
  sanctions: [], canViewEnforcement: false, ...over,
})

test('the Buyer profile separates profile, ratings and reviews, and usage and activity, and loads reviews by direction', async () => {
  vi.mocked(directory.getDirectoryBuyer).mockResolvedValue(buyerProfile({ sanctions: [{ id: 's1', action: 'WARNING', actionLabel: 'Warning', state: 'EFFECTIVE', reason: 'Repeated pickup no-shows.', createdAt: new Date('2026-09-25T00:00:00Z'), expiresAt: null }], canViewEnforcement: true }) as never)
  vi.mocked(directory.listDirectoryBuyerReviews).mockImplementation((async ({ direction }: { direction?: string }) => direction === 'WRITTEN'
    ? { items: [review({ id: 'r2', type: 'VENDOR', ratings: { service_quality: 4, speed_rating: 5 }, comment: null, visibility: 'HIDDEN_BY_MODERATION', moderationState: 'HIDDEN_PENDING_REVIEW' })], meta: meta({ lastPage: 1, total: 1 }) }
    : { items: [review()], meta: meta({ lastPage: 1, total: 1, canModerate: true }) }) as never)
  renderAt('/buyer-users/b1', <AdminBuyerUserDetailPage />, '/buyer-users/:buyerId')

  expect(await screen.findByRole('heading', { level: 1, name: 'Maria Santos' })).toBeInTheDocument()
  expect(screen.getAllByRole('tab').map(tab => tab.textContent)).toEqual(['Profile', 'Performance Monitoring', 'Ratings and reviews', 'Usage and activity'])
  expect(screen.getByText('maria@example.com')).toBeInTheDocument()
  expect(screen.getByText('+639171234567')).toBeInTheDocument()
  expect(screen.getByText('Santos Builders')).toBeInTheDocument()
  expect(screen.getByText('Quezon City, Metro Manila')).toBeInTheDocument()
  const identity = screen.getByRole('complementary', { name: 'User identity and contact' })
  expect(within(identity).getByRole('heading', { name: 'Maria Santos' })).toBeInTheDocument()
  expect(within(identity).getByText('maria@example.com')).toBeInTheDocument()
  expect(screen.getByRole('button', { name: 'Open Enforcement' })).toBeInTheDocument()
  expect(screen.getByRole('link', { name: /Open Warning recorded/ })).toHaveAttribute('href', '/enforcement/s1')
  expect(directory.getDirectoryBuyer).toHaveBeenCalledWith('b1')

  fireEvent.click(screen.getByRole('tab', { name: 'Ratings and reviews' }))
  expect(await screen.findByText('Pays on time.')).toBeInTheDocument()
  expect(screen.getByText('No ratings yet')).toBeInTheDocument()
  expect(screen.getByRole('link', { name: 'Open in Review Moderation' })).toHaveAttribute('href', '/reviews/r1')
  expect(directory.listDirectoryBuyerReviews).toHaveBeenCalledWith({ buyerId: 'b1', direction: 'RECEIVED', page: 1 })

  fireEvent.click(screen.getByRole('tab', { name: /Written by this Buyer/ }))
  expect(await screen.findByText(/withheld while this review is hidden or removed/)).toBeInTheDocument()
  expect(screen.getByText('Hidden By Moderation')).toBeInTheDocument()
  expect(directory.listDirectoryBuyerReviews).toHaveBeenLastCalledWith({ buyerId: 'b1', direction: 'WRITTEN', page: 1 })

  fireEvent.click(screen.getByRole('tab', { name: 'Usage and activity' }))
  expect(within(identity).getByText('maria@example.com')).toBeInTheDocument()
  expect(screen.queryByRole('heading', { name: 'Buyer information' })).not.toBeInTheDocument()
  expect(await screen.findByText('Orders')).toBeInTheDocument()
  expect(screen.getByText('Orders').closest('div')).toHaveTextContent('5')
  expect(screen.getByText('Sign-ins in 30 days').closest('div')).toHaveTextContent('8')
  expect(screen.getByText('Disputes (open / total)').closest('div')).toHaveTextContent('1 / 2')
  expect(within(screen.getByRole('table', { name: 'Recent orders' })).getByText('ORD-AAA')).toBeInTheDocument()
})

test('a deleted Buyer shows the masked address and no mobile, and a missing Buyer reports a failure with retry', async () => {
  vi.mocked(directory.getDirectoryBuyer).mockResolvedValueOnce(buyerProfile({ status: 'DELETED', profile: { ...buyerProfile().profile, email: 'm•••@example.com', mobile: null, deletedAt: new Date('2026-10-02T00:00:00Z') } }) as never)
  const view = renderAt('/buyer-users/b1', <AdminBuyerUserDetailPage />, '/buyer-users/:buyerId')
  expect(await screen.findByText('m•••@example.com')).toBeInTheDocument()
  expect(screen.getByText(/deleted their account, so the email is masked/)).toBeInTheDocument()
  expect(screen.getByText('Not provided', { selector: 'dd' })).toBeInTheDocument()
  expect(screen.queryByText('Verified')).not.toBeInTheDocument()
  view.unmount()

  vi.mocked(directory.getDirectoryBuyer).mockRejectedValueOnce(new Error('offline'))
  renderAt('/buyer-users/b9', <AdminBuyerUserDetailPage />, '/buyer-users/:buyerId')
  expect(await screen.findByRole('alert')).toBeInTheDocument()
  expect(screen.getByRole('button', { name: /Try again/ })).toBeInTheDocument()
})

const vendorProfile = (over: Record<string, unknown> = {}) => ({
  id: 'v1', subjectType: 'VENDOR_ORGANIZATION', storeName: 'Alpha Hardware', status: 'ACTIVE',
  store: { legalName: 'Alpha Hardware Trading', registeredName: null, businessType: 'SOLE_PROPRIETORSHIP', description: 'Quality hollow blocks since 1998.', logoUrl: null, bannerUrl: 'https://img.example/store-banner.jpg', contactEmail: 'sales@alpha.example', contactPhone: '+639175550000',
    address: '123 Aurora Boulevard, Quezon City', location: 'Quezon City, Metro Manila', verificationStatus: 'APPROVED', setupStatus: 'COMPLETED', activationStatus: 'ACTIVE', discoverabilityStatus: 'DISCOVERABLE', accountStatus: 'ACTIVE',
    activationHoldCode: null, vacationMode: false, bulkCapability: true, joinedAt: new Date('2026-08-01T00:00:00Z') },
  owner: { name: 'Rosa Alpha', email: 'rosa@alpha.example', mobile: null },
  ratings: { store: { count: 3, serviceQuality: '4.33', speed: '4.67' }, product: { count: 2, average: '4.50' } },
  activity: { quotesSent: 12, quotesAccepted: 5, ordersTotal: 9, ordersFulfilled: 6, ordersOpen: 2, ordersCancelled: 1, disputesTotal: 1, disputesOpen: 0, listingsTotal: 10, listingsActive: 8, teamMembers: 4, lastLoginAt: new Date('2026-10-05T01:00:00Z'), signIns30Days: 21 },
  sanctions: [], canViewEnforcement: true, canViewVerification: true, ...over,
})
const listing = (over: Record<string, unknown> = {}) => ({ id: 'l1', name: 'Hollow block 4 inch', sku: 'HB-4', status: 'ACTIVE', updatedAt: new Date('2026-10-02T00:00:00Z'), variantCount: 2, minPriceCentavos: 1800, maxPriceCentavos: 2600, unitCode: 'PC',
  stock: 'LIMITED_STOCK', imageUrl: 'https://img.example/hb.png', imageAlt: 'Block photo', ...over })

test('the Vendor profile shows the store, ratings, activity and a basic product listing table with stock labels only', async () => {
  vi.mocked(directory.getDirectoryVendor).mockResolvedValue(vendorProfile() as never)
  vi.mocked(directory.listDirectoryVendorReviews).mockResolvedValue({ items: [review({ id: 'r3', type: 'VENDOR', ratings: { service_quality: 4, speed_rating: 5 }, comment: 'Fast and helpful.', authorName: 'Maria S.' })], meta: meta({ total: 1 }) } as never)
  vi.mocked(directory.listDirectoryVendorListings).mockResolvedValue({ items: [listing(), listing({ id: 'l2', name: 'Draft rebar', sku: null, status: 'DRAFT', variantCount: 1, minPriceCentavos: null, maxPriceCentavos: null, unitCode: null, stock: 'OUT_OF_STOCK', imageUrl: null, imageAlt: null })],
    meta: meta({ total: 2, statusCounts: { ACTIVE: 1, DRAFT: 1 } }) } as never)
  renderAt('/vendor-users/v1', <AdminVendorUserDetailPage />, '/vendor-users/:vendorId')

  expect(await screen.findByRole('heading', { level: 1, name: 'Alpha Hardware' })).toBeInTheDocument()
  expect(screen.getAllByRole('tab').map(tab => tab.textContent)).toEqual(['Store profile', 'Ratings and reviews', 'Usage and activity', 'Product listings'])
  expect(screen.getByText('Quality hollow blocks since 1998.')).toBeInTheDocument()
  expect(screen.getByText('sales@alpha.example')).toBeInTheDocument()
  expect(screen.getByText('rosa@alpha.example')).toBeInTheDocument()
  const identity = screen.getByRole('complementary', { name: 'User identity and contact' })
  expect(within(identity).getByText('sales@alpha.example')).toBeInTheDocument()
  const storeCard = screen.getByRole('region', { name: 'About the store' })
  const banner = within(storeCard).getByRole('img', { name: 'Alpha Hardware store banner' })
  expect(banner).toHaveAttribute('src', 'https://img.example/store-banner.jpg')
  fireEvent.error(banner)
  expect(within(storeCard).getByText('Banner unavailable')).toBeInTheDocument()
  expect(screen.getByRole('link', { name: 'Open verification case' })).toHaveAttribute('href', '/vendor-verification/v1')

  fireEvent.click(screen.getByRole('tab', { name: 'Ratings and reviews' }))
  expect(await screen.findByText('Fast and helpful.')).toBeInTheDocument()
  expect(directory.listDirectoryVendorReviews).toHaveBeenCalledWith({ vendorId: 'v1', type: 'VENDOR', page: 1 })
  fireEvent.click(screen.getByRole('tab', { name: /Product reviews/ }))
  await waitFor(() => expect(directory.listDirectoryVendorReviews).toHaveBeenLastCalledWith({ vendorId: 'v1', type: 'PRODUCT', page: 1 }))

  fireEvent.click(screen.getByRole('tab', { name: 'Usage and activity' }))
  expect(screen.getByText('Quotes sent').closest('div')).toHaveTextContent('12')
  expect(screen.getByText('Orders fulfilled').closest('div')).toHaveTextContent('6')
  expect(screen.getByText('Active listings').closest('div')).toHaveTextContent('8 of 10')
  expect(screen.getByText('Last login').closest('div')).toHaveTextContent('Oct 5, 2026')
  expect(within(identity).getByText('sales@alpha.example')).toBeInTheDocument()
  const calculation = screen.getByRole('button', { name: 'About Quotes sent' })
  const calculationScope = within(calculation.parentElement!)
  fireEvent.focus(calculation)
  expect(calculationScope.getByRole('tooltip')).toHaveTextContent('Published quotation versions.')
  fireEvent.keyDown(calculation, { key: 'Escape' })
  expect(calculationScope.queryByRole('tooltip')).not.toBeInTheDocument()

  fireEvent.click(screen.getByRole('tab', { name: 'Product listings' }))
  const table = await screen.findByRole('region', { name: 'Product listings' })
  expect(within(table).getAllByRole('columnheader').map(header => header.textContent)).toEqual(['Product', 'Price', 'Stock', 'Status'])
  expect(within(table).getByRole('img', { name: 'Block photo' })).toHaveAttribute('src', 'https://img.example/hb.png')
  expect(within(table).getByText('Hollow block 4 inch')).toBeInTheDocument()
  expect(within(table).getByText(/₱18\.00\s–\s₱26\.00/)).toBeInTheDocument()
  expect(within(table).getByText('Limited stock')).toBeInTheDocument()
  expect(within(table).getByText('Out of stock')).toBeInTheDocument()
  expect(within(table).getByRole('img', { name: 'No photo' })).toBeInTheDocument()
  expect(within(table).queryByText(/quantity/i)).not.toBeInTheDocument()
  expect(screen.getAllByRole('tab').slice(4).map(tab => tab.textContent)).toEqual(['All2', 'Active1', 'Draft1'])

  fireEvent.click(screen.getByRole('tab', { name: /Draft/ }))
  await waitFor(() => expect(directory.listDirectoryVendorListings).toHaveBeenLastCalledWith({ vendorId: 'v1', status: 'DRAFT', page: 1 }))
  const search = screen.getByRole('searchbox', { name: 'Search listings' })
  fireEvent.change(search, { target: { value: 'block' } })
  fireEvent.submit(search.closest('form') as HTMLFormElement)
  await waitFor(() => expect(directory.listDirectoryVendorListings).toHaveBeenLastCalledWith({ vendorId: 'v1', q: 'block', status: 'DRAFT', page: 1 }))
})

test('the Vendor profile hides the cross-queue links the role cannot open', async () => {
  vi.mocked(directory.getDirectoryVendor).mockResolvedValue(vendorProfile({ canViewEnforcement: false, canViewVerification: false, owner: null }) as never)
  renderAt('/vendor-users/v1', <AdminVendorUserDetailPage />, '/vendor-users/:vendorId')
  await screen.findByRole('heading', { level: 1, name: 'Alpha Hardware' })
  expect(screen.queryByRole('link', { name: 'Open verification case' })).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Open Enforcement' })).not.toBeInTheDocument()
  expect(screen.getByText('This store has no active Owner.')).toBeInTheDocument()
})


test('directory lists show published VPS and CCS and neutral sample states', async () => {
  vi.mocked(directory.listDirectoryVendors).mockResolvedValue({ items: vendors, meta: meta() } as never)
  const view = renderAt('/vendor-users', <AdminVendorUsersPage />, '/vendor-users')
  expect(await screen.findByLabelText('Vendor performance (VPS): 4.25 out of 5')).toBeInTheDocument()
  expect(screen.getByLabelText('Vendor performance (VPS): New Vendor')).toBeInTheDocument()
  view.unmount()
  vi.mocked(directory.listDirectoryBuyers).mockResolvedValue({ items: buyers, meta: meta() } as never)
  renderAt('/buyer-users', <AdminBuyerUsersPage />, '/buyer-users')
  expect(await screen.findByLabelText('Buyer rating (CCS): 4.50 out of 5')).toBeInTheDocument()
  expect(screen.getByLabelText('Buyer rating (CCS): Building your rating')).toBeInTheDocument()
})

test('Buyer performance uses the published summary and retains the eligibility explanation', async () => {
  vi.mocked(directory.getDirectoryBuyer).mockResolvedValue(buyerProfile({ rating: { ...summary, score: null, count: 4, inquirySeriousness: null, communicationQuality: null, paymentReliability: null } }) as never)
  renderAt('/buyer-users/b1', <AdminBuyerUserDetailPage />, '/buyer-users/:buyerId')
  fireEvent.click(await screen.findByRole('tab', { name: 'Performance Monitoring' }))
  expect(screen.getByText('Buyer rating (CCS)')).toBeInTheDocument()
  expect(screen.getByText(/Building your rating/)).toBeInTheDocument()
  expect(screen.getByText('Activity context')).toBeInTheDocument()
  expect(screen.queryByText('4.50')).not.toBeInTheDocument()
})

test('Vendor performance loads only when its authorized section opens', async () => {
  vi.mocked(directory.getDirectoryVendor).mockResolvedValue(vendorProfile({ canViewScores: true }) as never)
  vi.mocked(trust.getScore).mockResolvedValue({ vendorId: 'v1', storeName: 'Alpha Hardware', scores: [], badges: [], badgeMetrics: [], history: [], canInvestigate: false } as never)
  renderAt('/vendor-users/v1', <AdminVendorUserDetailPage />, '/vendor-users/:vendorId')
  await screen.findByRole('heading', { name: 'Alpha Hardware' })
  expect(trust.getScore).not.toHaveBeenCalled()
  fireEvent.click(screen.getByRole('tab', { name: 'Performance Monitoring' }))
  expect(await screen.findByText('Read-only access')).toBeInTheDocument()
  expect(trust.getScore).toHaveBeenCalledWith('v1', 1)
  fireEvent.click(screen.getByRole('tab', { name: 'Investigations' }))
  expect(screen.getByText(/You have read-only access/)).toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Record exclusion' })).not.toBeInTheDocument()
})

test('directory access alone never loads protected Vendor performance', async () => {
  vi.mocked(directory.getDirectoryVendor).mockResolvedValue(vendorProfile({ canViewScores: false }) as never)
  renderAt('/vendor-users/v1', <AdminVendorUserDetailPage />, '/vendor-users/:vendorId')
  await screen.findByRole('heading', { name: 'Alpha Hardware' })
  expect(screen.queryByRole('tab', { name: 'Performance Monitoring' })).not.toBeInTheDocument()
  expect(trust.getScore).not.toHaveBeenCalled()
})

test.each(['BUYER', 'VENDOR_ORGANIZATION'] as const)('Open Enforcement selects the exact %s profile in a popup', async type => {
  vi.mocked(operations.getSubject).mockResolvedValue({ displayName: 'Selected account', accountStatus: 'ACTIVE', openOrders: 0, disputesOpen: 0, disputesTotal: 0, sanctions: [], recordableActions: ['WARNING'] } as never)
  if (type === 'BUYER') {
    vi.mocked(directory.getDirectoryBuyer).mockResolvedValue(buyerProfile({ canViewEnforcement: true }) as never)
    renderAt('/buyer-users/b1', <AdminBuyerUserDetailPage />, '/buyer-users/:buyerId')
  } else {
    vi.mocked(directory.getDirectoryVendor).mockResolvedValue(vendorProfile() as never)
    renderAt('/vendor-users/v1', <AdminVendorUserDetailPage />, '/vendor-users/:vendorId')
  }
  fireEvent.click(await screen.findByRole('button', { name: 'Open Enforcement' }))
  const dialog = await screen.findByRole('dialog', { name: 'Record enforcement action' })
  await within(dialog).findByRole('button', { name: 'Record warning & notify' })
  expect(operations.getSubject).toHaveBeenCalledWith(type, type === 'BUYER' ? 'b1' : 'v1')
  expect(within(dialog).queryByRole('search')).not.toBeInTheDocument()
  fireEvent.click(within(dialog).getByRole('button', { name: 'Cancel' }))
  expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
})
