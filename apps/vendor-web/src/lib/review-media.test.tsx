import { act, fireEvent, render, screen, waitFor } from '@testing-library/react'
import type { ReviewMediaLink } from '@materyalph/api-client-ts'
import { afterEach, beforeEach, expect, test, vi } from 'vitest'
import { ProductReviewSummary, ReviewDetailContent, ReviewListCard, type ReviewPresentationRow } from '../../../../packages/web-ui/src/review-details'
import { clearWebSessionTransport, createWebApiConfiguration, readReviewMediaFile } from '../../../../packages/web-ui/src/web-api-session'

const base = 'https://api.example.test/api/v1'
const reviewId = '0199aa10-0000-7000-8000-000000000001'
const mediaId = '0199aa10-0000-7000-8000-000000000002'
const signedUrl = (portal = 'vendor', version = 1) => `${base}/${portal}/reviews/${reviewId}/media/${mediaId}/content?expires=123&signature=synthetic&version=${version}`
const createObjectURL = vi.fn(() => 'blob:private-review')
const revokeObjectURL = vi.fn()

function media(contentType: ReviewMediaLink['contentType'] = 'image/png'): ReviewMediaLink {
  return { id: mediaId, url: signedUrl(), expiresAt: new Date('2026-10-15T00:05:00Z'), contentType, byteSize: 1024 }
}

function review(attachments: ReviewMediaLink[] = []): ReviewPresentationRow {
  return { id: reviewId, type: 'PRODUCT', product: { listingId: 'listing', name: 'Steel bar', variantLabel: '12mm' }, displayName: 'France S.', submittedAt: new Date('2026-10-14T10:29:00Z'), verifiedPurchase: true, edited: true, ratings: { productQuality: 4 }, comment: 'Materials arrived in good condition.', media: attachments, orderReference: 'ORD-SYNTHETIC' }
}

beforeEach(() => {
  clearWebSessionTransport()
  createObjectURL.mockClear()
  revokeObjectURL.mockClear()
  const NativeURL = URL
  vi.stubGlobal('URL', class extends NativeURL {
    static override createObjectURL = createObjectURL
    static override revokeObjectURL = revokeObjectURL
  })
})
afterEach(() => { vi.unstubAllGlobals(); vi.unstubAllEnvs() })

test.each(['vendor', 'admin'])('%s review media uses session credentials and permits only approved content', async portal => {
  const fetcher = vi.fn(async () => new Response('synthetic photo', { headers: { 'Content-Type': 'image/png' } }))
  vi.stubGlobal('fetch', fetcher)
  const blob = await readReviewMediaFile(base, signedUrl(portal))
  expect(blob.type).toBe('image/png')
  expect(fetcher).toHaveBeenCalledWith(new URL(signedUrl(portal)), expect.objectContaining({ credentials: 'include', cache: 'no-store', referrerPolicy: 'origin', headers: { Accept: 'image/jpeg,image/png,video/mp4,video/quicktime' } }))
})

test.each(['5173', '5174'])('signed review media validates API identity before using the local %s proxy', async port => {
  vi.stubEnv('DEV', true)
  vi.stubGlobal('window', { location: new URL(`http://localhost:${port}/reviews/${reviewId}`), dispatchEvent: vi.fn() })
  const fetcher = vi.fn(async () => new Response('synthetic photo', { headers: { 'Content-Type': 'image/png' } }))
  vi.stubGlobal('fetch', fetcher)
  const localBase = 'http://localhost:8080/api/v1'
  await readReviewMediaFile(localBase, signedUrl().replace(base, localBase))
  expect(fetcher).toHaveBeenCalledWith(signedUrl().replace(base, `http://localhost:${port}/api/v1`), expect.objectContaining({ credentials: 'include' }))
  expect(createWebApiConfiguration(localBase).basePath).toBe(localBase)
})

test('foreign origins, unrelated private routes and malformed review paths never receive credentials', async () => {
  const fetcher = vi.fn()
  vi.stubGlobal('fetch', fetcher)
  for (const url of ['https://untrusted.example/review.png', `${base}/auth/session`, `${base}/catalog-files/${mediaId}/content`, signedUrl('buyers'), signedUrl().replace(reviewId, '-'.repeat(36)), signedUrl().replace('/content', '/content/extra'), signedUrl().replace('/api/v1/', '/api/v10/'), signedUrl().replace('https://', 'https://user:password@')]) {
    await expect(readReviewMediaFile(base, url)).rejects.toThrow('invalid')
  }
  expect(fetcher).not.toHaveBeenCalled()
})

test('HTML responses and denied private content cannot become media previews', async () => {
  const fetcher = vi.fn().mockResolvedValueOnce(new Response('<html>Sign in</html>', { headers: { 'Content-Type': 'text/html' } })).mockResolvedValueOnce(new Response('{}', { status: 403 }))
  vi.stubGlobal('fetch', fetcher)
  await expect(readReviewMediaFile(base, signedUrl())).rejects.toThrow('cannot be previewed')
  await expect(readReviewMediaFile(base, signedUrl())).rejects.toMatchObject({ response: { status: 403 } })
  expect(createObjectURL).not.toHaveBeenCalled()
  expect(fetcher).toHaveBeenCalledTimes(2)
})

test('an expired signed link remains local and normal API permission denial still invalidates the portal', async () => {
  vi.stubGlobal('fetch', vi.fn(async () => new Response('{}', { status: 403 })))
  const denied = vi.fn()
  window.addEventListener('materyalph:access-denied', denied)
  try {
    await expect(readReviewMediaFile(base, signedUrl())).rejects.toMatchObject({ response: { status: 403 } })
    expect(denied).not.toHaveBeenCalled()
    const transport = createWebApiConfiguration(base).fetchApi!
    await transport(`${base}/vendor/reviews`)
    expect(denied).toHaveBeenCalledOnce()
    expect(denied.mock.calls[0]?.[0]).toMatchObject({ detail: { status: 403 } })
  } finally { window.removeEventListener('materyalph:access-denied', denied) }
})

test('an invalid review media session still attempts refresh and publishes the final authentication denial', async () => {
  const fetcher = vi.fn(async (input: RequestInfo | URL) => String(input).endsWith('/auth/csrf')
    ? new Response(JSON.stringify({ data: { csrf_token: 'synthetic-csrf-token' } }), { headers: { 'Content-Type': 'application/json' } })
    : new Response('{}', { status: 401, headers: { 'Content-Type': 'application/json' } }))
  vi.stubGlobal('fetch', fetcher)
  const denied = vi.fn()
  window.addEventListener('materyalph:access-denied', denied)
  try {
    await expect(readReviewMediaFile(base, signedUrl())).rejects.toMatchObject({ response: { status: 401 } })
    expect(fetcher.mock.calls.some(([input]) => String(input).endsWith('/auth/refresh'))).toBe(true)
    expect(denied).toHaveBeenCalled()
    expect(denied.mock.calls.at(-1)?.[0]).toMatchObject({ detail: { status: 401 } })
  } finally { window.removeEventListener('materyalph:access-denied', denied) }
})

test('cards open details independently from reporting and never fetch attachments', () => {
  const fetcher = vi.fn()
  vi.stubGlobal('fetch', fetcher)
  const open = vi.fn()
  const report = vi.fn()
  render(<ReviewListCard review={review([media()])} onOpen={open} onReport={report} />)
  fireEvent.click(screen.getByRole('button', { name: 'View Steel bar details by France S.' }))
  expect(open).toHaveBeenCalledOnce()
  fireEvent.click(screen.getByRole('button', { name: 'Report' }))
  expect(report).toHaveBeenCalledOnce()
  expect(open).toHaveBeenCalledOnce()
  expect(screen.getByText('1 photo')).toBeVisible()
  expect(fetcher).not.toHaveBeenCalled()
})

test('private photo preview is revoked on unmount and cleared immediately on session change', async () => {
  vi.stubGlobal('fetch', vi.fn(async () => new Response('synthetic photo', { headers: { 'Content-Type': 'image/png' } })))
  const view = render(<ReviewDetailContent review={review([media()])} apiBasePath={base} />)
  expect(await screen.findByRole('img', { name: 'Buyer review photo 1' })).toHaveAttribute('src', 'blob:private-review')
  expect(screen.getByText('Oct 14, 2026, 6:29 PM (Asia/Manila)')).toBeVisible()
  act(() => clearWebSessionTransport())
  expect(screen.queryByRole('img', { name: 'Buyer review photo 1' })).not.toBeInTheDocument()
  expect(revokeObjectURL).toHaveBeenCalledWith('blob:private-review')
  view.unmount()
  expect(revokeObjectURL).toHaveBeenCalledTimes(1)
})

test('a removed detail cannot expose a late private attachment response', async () => {
  let finish!: (response: Response) => void
  vi.stubGlobal('fetch', vi.fn(() => new Promise<Response>(resolve => { finish = resolve })))
  const view = render(<ReviewDetailContent review={review([media()])} apiBasePath={base} />)
  view.unmount()
  await act(async () => { finish(new Response('synthetic photo', { headers: { 'Content-Type': 'image/png' } })) })
  expect(createObjectURL).not.toHaveBeenCalled()
})

test('videos load only on request and provide controls without autoplay', async () => {
  const fetcher = vi.fn(async () => new Response('synthetic video', { headers: { 'Content-Type': 'video/mp4' } }))
  vi.stubGlobal('fetch', fetcher)
  const view = render(<ReviewDetailContent review={review([media('video/mp4')])} apiBasePath={base} />)
  expect(fetcher).not.toHaveBeenCalled()
  fireEvent.click(screen.getByRole('button', { name: 'Load video' }))
  const video = await screen.findByLabelText('Buyer review video 1')
  expect(video).toHaveAttribute('controls')
  expect(video).not.toHaveAttribute('autoplay')
  expect(video).toHaveAttribute('preload', 'metadata')
  expect(screen.getByRole('link', { name: 'Download video 1' })).toHaveAttribute('href', 'blob:private-review')
  view.unmount()
  expect(revokeObjectURL).toHaveBeenCalledWith('blob:private-review')
})

test('failed media has a bounded explicit retry and can refresh the signed links', async () => {
  const fetcher = vi.fn().mockRejectedValueOnce(new TypeError('Offline')).mockResolvedValueOnce(new Response('synthetic photo', { headers: { 'Content-Type': 'image/png' } }))
  const refresh = vi.fn()
  vi.stubGlobal('fetch', fetcher)
  render(<ReviewDetailContent review={review([media()])} apiBasePath={base} onRefreshMedia={refresh} />)
  fireEvent.click(await screen.findByRole('button', { name: 'Retry photo 1' }))
  expect(await screen.findByRole('img', { name: 'Buyer review photo 1' })).toBeVisible()
  fireEvent.click(screen.getByRole('button', { name: 'Refresh attachments' }))
  expect(refresh).toHaveBeenCalledOnce()
  await waitFor(() => expect(fetcher).toHaveBeenCalledTimes(2))
})

test('summary shows authoritative all-time counts, including zero-count rating buckets', () => {
  render(<ProductReviewSummary summary={{ count: 4, average: 4.5, distribution: [{ stars: 5, count: 2 }, { stars: 4, count: 2 }] }} />)
  expect(screen.getByText('4.5')).toBeVisible()
  expect(screen.getByText('4 reviews · All time')).toBeVisible()
  expect(screen.getByRole('meter', { name: '5 stars' })).toHaveAttribute('aria-valuenow', '2')
  expect(screen.getByRole('meter', { name: '1 star' })).toHaveAttribute('aria-valuenow', '0')
  expect(screen.getAllByRole('meter')).toHaveLength(5)
})
