import { fireEvent, render, waitFor } from '@testing-library/react'
import { afterEach, beforeEach, expect, test, vi } from 'vitest'
import { ReviewAuthorAvatar } from '../../../../packages/web-ui/src/review-author-avatar'
import { clearWebSessionTransport, readReviewBuyerPhoto } from '../../../../packages/web-ui/src/web-api-session'

const base = 'https://api.example.test/api/v1'
const reviewId = '0199aa10-0000-7000-8000-000000000001'
const signed = `${base}/vendor/reviews/${reviewId}/buyer-photo?expires=9999999999&signature=sample`
const create = vi.fn(() => 'blob:sample-buyer-photo')
const revoke = vi.fn()

beforeEach(() => {
  clearWebSessionTransport()
  create.mockClear(); revoke.mockClear()
  const NativeURL = URL
  vi.stubGlobal('URL', class extends NativeURL {
    static override createObjectURL = create
    static override revokeObjectURL = revoke
  })
})
afterEach(() => vi.unstubAllGlobals())

test('Buyer profile photos load through authenticated review transport and release their private blob', async () => {
  const fetcher = vi.fn(async () => new Response('sample-png', { headers: { 'Content-Type': 'image/png' } }))
  vi.stubGlobal('fetch', fetcher)
  const view = render(<ReviewAuthorAvatar apiBasePath={base} review={{ id: reviewId, type: 'PRODUCT', displayName: 'Sample B.', buyerAvatarUrl: signed }} />)
  await waitFor(() => expect(view.container.querySelector('img')).toHaveAttribute('src', 'blob:sample-buyer-photo'))
  expect(fetcher).toHaveBeenCalledWith(new URL(signed), expect.objectContaining({ credentials: 'include', cache: 'no-store', referrerPolicy: 'origin' }))
  fireEvent.error(view.container.querySelector('img')!)
  expect(view.container.querySelector('img')).toBeNull()
  view.unmount()
  expect(revoke).toHaveBeenCalledWith('blob:sample-buyer-photo')
})

test('unavailable reviewer identities and store-authored Buyer ratings never request a profile photo', () => {
  const fetcher = vi.fn()
  vi.stubGlobal('fetch', fetcher)
  const view = render(<ReviewAuthorAvatar apiBasePath={base} review={{ id: reviewId, type: 'VENDOR', displayName: 'Reviewer unavailable', buyerAvatarUrl: signed }} />)
  view.rerender(<ReviewAuthorAvatar apiBasePath={base} review={{ id: reviewId, type: 'BUYER', displayName: 'Sample Supply', buyerAvatarUrl: signed }} />)
  expect(fetcher).not.toHaveBeenCalled()
  expect(view.container.querySelector('img')).toBeNull()
})

test.each([signed.replace('api.example.test', 'untrusted.example.test'), signed.replace(reviewId, '0199aa10-0000-7000-8000-000000000002'), signed.replace('/buyer-photo', '/media/anything/content')])('rejects an untrusted or different-review avatar link', async source => {
  const fetcher = vi.fn()
  vi.stubGlobal('fetch', fetcher)
  await expect(readReviewBuyerPhoto(base, reviewId, source)).rejects.toThrow('URL is invalid')
  expect(fetcher).not.toHaveBeenCalled()
})

test('an expired photo falls back locally without invalidating the portal session', async () => {
  vi.stubGlobal('fetch', vi.fn(async () => new Response('{}', { status: 403, headers: { 'Content-Type': 'application/json' } })))
  const denied = vi.fn()
  window.addEventListener('materyalph:access-denied', denied)
  const view = render(<ReviewAuthorAvatar apiBasePath={base} review={{ id: reviewId, type: 'PRODUCT', displayName: 'Sample B.', buyerAvatarUrl: signed }} />)
  await waitFor(() => expect(fetch).toHaveBeenCalled())
  expect(view.container.querySelector('img')).toBeNull()
  expect(denied).not.toHaveBeenCalled()
  window.removeEventListener('materyalph:access-denied', denied)
})

test('rejects a non-PNG response even from an authorized profile route', async () => {
  vi.stubGlobal('fetch', vi.fn(async () => new Response('<html>invalid</html>', { headers: { 'Content-Type': 'text/html' } })))
  await expect(readReviewBuyerPhoto(base, reviewId, signed)).rejects.toThrow('cannot be previewed')
})
