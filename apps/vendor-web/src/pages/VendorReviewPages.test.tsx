import { fireEvent, render, screen, waitFor } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import * as api from '../lib/trust-api'
import { useOnboardingSnapshot } from '../lib/vendor-status'
import { VendorReviewDetailPage, VendorReviewsPage } from './TrustPages'
import { ProductReviewsSection } from './VendorReviewPages'

vi.mock('../lib/trust-api', async original => ({ ...await original<typeof import('../lib/trust-api')>(), listReviews: vi.fn(), getReview: vi.fn(), reportReview: vi.fn() }))
vi.mock('../lib/vendor-status', () => ({ useOnboardingSnapshot: vi.fn() }))
vi.mock('../lib/catalog-access', async original => ({ ...await original<typeof import('../lib/catalog-access')>(), storeName: () => 'Test Supply' }))
vi.mock('./PhaseThreeVendorPages', async original => ({ ...await original<typeof import('./PhaseThreeVendorPages')>(), VendorShell: ({ children }: { children: React.ReactNode }) => <main>{children}</main> }))

const review: api.VendorReviewRow = {
  id: 'r1', type: 'PRODUCT', displayName: 'France S.', ratings: { productQuality: 4 }, comment: 'Solid quality and packed carefully.',
  product: { listingId: 'l1', name: 'Rerolled steel bar', variantLabel: '15 × 12' }, submittedAt: new Date('2026-10-14T10:29:00Z'),
  verifiedPurchase: true, edited: true, media: [], orderId: 'o1', orderReference: 'ORD-2026-TEST', canReport: true,
}
const list = (items: api.VendorReviewRow[] = [review], total = items.length): Awaited<ReturnType<typeof api.listReviews>> => ({ items, meta: { page: 1, perPage: 20, total, type: 'PRODUCT', summary: { count: total, average: total ? 4 : null, distribution: [5, 4, 3, 2, 1].map(stars => ({ stars, count: stars === 4 ? total : 0 })) } } })
const snapshot = (permissions = ['reviews.view', 'reviews.report']) => vi.mocked(useOnboardingSnapshot).mockReturnValue({ snapshot: { permissions }, loading: false, error: null, refresh: vi.fn() } as unknown as ReturnType<typeof useOnboardingSnapshot>)

beforeEach(() => { vi.clearAllMocks(); snapshot(); vi.mocked(api.listReviews).mockResolvedValue(list()); vi.mocked(api.getReview).mockResolvedValue(review) })

test('a product review opens authorized details and returns to its selected tab and page', async () => {
  render(<MemoryRouter initialEntries={['/reviews?tab=PRODUCT&page=2']}><Routes><Route path="/reviews" element={<VendorReviewsPage />} /><Route path="/reviews/:reviewId" element={<VendorReviewDetailPage />} /></Routes></MemoryRouter>)
  const product = await screen.findByText('Rerolled steel bar')
  const opener = product.closest('button')
  expect(opener).not.toBeNull()
  fireEvent.click(opener!)
  expect(await screen.findByRole('heading', { name: 'Review details' })).toBeInTheDocument()
  await waitFor(() => expect(api.getReview).toHaveBeenCalledWith('r1'))
  expect(await screen.findByText('Solid quality and packed carefully.')).toBeInTheDocument()
  expect(screen.getByRole('link', { name: /View order/ })).toHaveAttribute('href', '/orders/o1')
  expect(screen.getByRole('link', { name: 'Ratings & Reviews' })).toHaveAttribute('href', '/reviews?tab=PRODUCT&page=2')
})

test('product analytics requests all dates for exactly its listing and paginates using the server total', async () => {
  vi.mocked(api.listReviews).mockResolvedValue(list([review], 42))
  render(<MemoryRouter><ProductReviewsSection listingId="l1" canView /></MemoryRouter>)
  expect(await screen.findByText('Rerolled steel bar')).toBeInTheDocument()
  expect(api.listReviews).toHaveBeenCalledWith('PRODUCT', 1, { listingId: 'l1' })
  fireEvent.click(screen.getByRole('button', { name: /Next/ }))
  await waitFor(() => expect(api.listReviews).toHaveBeenLastCalledWith('PRODUCT', 2, { listingId: 'l1' }))
})

test('reviews and their details are denied before fetching when the member lacks reviews.view', () => {
  snapshot(['catalog.manage'])
  const view = render(<MemoryRouter initialEntries={['/reviews/r1']}><Routes><Route path="/reviews/:reviewId" element={<VendorReviewDetailPage />} /></Routes></MemoryRouter>)
  expect(screen.getByText('Ratings and reviews are not available to your role.')).toBeInTheDocument()
  expect(api.getReview).not.toHaveBeenCalled()
  view.unmount()
  render(<MemoryRouter><ProductReviewsSection listingId="l1" canView={false} /></MemoryRouter>)
  expect(api.listReviews).not.toHaveBeenCalled()
})

test('an unavailable detail offers retry without displaying the previous review', async () => {
  vi.mocked(api.getReview).mockRejectedValueOnce(new Error('This review is unavailable.')).mockResolvedValue(review)
  render(<MemoryRouter initialEntries={['/reviews/r1']}><Routes><Route path="/reviews/:reviewId" element={<VendorReviewDetailPage />} /></Routes></MemoryRouter>)
  expect(await screen.findByRole('button', { name: /Try again/ })).toBeInTheDocument()
  expect(screen.queryByText('Solid quality and packed carefully.')).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: /Try again/ }))
  expect(await screen.findByText('Solid quality and packed carefully.')).toBeInTheDocument()
})

test('retrying the same review report reuses its idempotency key', async () => {
  HTMLDialogElement.prototype.showModal = function () { this.open = true }
  HTMLDialogElement.prototype.close = function () { this.open = false }
  vi.mocked(api.reportReview).mockRejectedValueOnce(new Error('Connection interrupted.')).mockResolvedValueOnce(undefined)
  render(<MemoryRouter initialEntries={['/reviews?tab=PRODUCT']}><Routes><Route path="/reviews" element={<VendorReviewsPage />} /></Routes></MemoryRouter>)
  fireEvent.click(await screen.findByRole('button', { name: 'Report' }))
  fireEvent.click(screen.getByRole('button', { name: 'Send report' }))
  await screen.findByText('Connection interrupted.')
  fireEvent.click(screen.getByRole('button', { name: 'Send report' }))
  await waitFor(() => expect(api.reportReview).toHaveBeenCalledTimes(2))
  const calls = vi.mocked(api.reportReview).mock.calls
  expect(calls[0]?.[3]).toBeTruthy()
  expect(calls[1]?.[3]).toBe(calls[0]?.[3])
})
