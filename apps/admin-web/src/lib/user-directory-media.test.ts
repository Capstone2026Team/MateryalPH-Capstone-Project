import { clearWebSessionTransport, readDirectoryBuyerPhoto } from '@materyalph/web-ui'
import { afterEach, beforeEach, expect, test, vi } from 'vitest'

const base = 'https://api.example.test/api/v1'
const buyerId = '0199f96c-a1b2-7c3d-8e4f-0123456789ab'
const photoPath = `/api/v1/admin/buyers/${buyerId}/photo`
const signedUrl = `https://api.example.test${photoPath}?version=2&expires=1793000000&signature=fixture%2Bsignature%2Fvalue`
const fetchMock = vi.fn<typeof fetch>()

beforeEach(() => {
  clearWebSessionTransport()
  fetchMock.mockReset()
  vi.stubGlobal('fetch', fetchMock)
})
afterEach(() => { clearWebSessionTransport(); vi.unstubAllGlobals() })

test('Buyer directory photo transport preserves the exact signed URL and sends credentials with no-store caching', async () => {
  fetchMock.mockResolvedValue(new Response('sanitized-png', { headers: { 'Content-Type': 'image/png' } }))

  const photo = await readDirectoryBuyerPhoto(base, buyerId, signedUrl)

  expect(photo.type).toBe('image/png')
  expect(fetchMock).toHaveBeenCalledTimes(1)
  const [input, init] = fetchMock.mock.calls[0]!
  expect(String(input)).toBe(signedUrl)
  expect(init).toMatchObject({ credentials: 'include', cache: 'no-store', referrerPolicy: 'origin' })
  expect(new Headers(init?.headers).get('Accept')).toBe('image/png')
})

test.each([
  `https://other.example.test${photoPath}?signature=fixture`,
  `https://api.example.test/api/v1/admin/buyers/another-buyer/photo?signature=fixture`,
  `https://api.example.test/api/v1/admin/account/photo?signature=fixture`,
  `https://api.example.test${photoPath}/content?signature=fixture`,
  `https://api.example.test/other-api/admin/buyers/${buyerId}/photo?signature=fixture`,
  `https://user:password@api.example.test${photoPath}?signature=fixture`,
])('Buyer directory photo transport refuses an untrusted or differently scoped URL: %s', async url => {
  await expect(readDirectoryBuyerPhoto(base, buyerId, url)).rejects.toThrow('Buyer profile picture URL is invalid')
  expect(fetchMock).not.toHaveBeenCalled()
})

test('Buyer directory photos reject content that is not sanitized PNG', async () => {
  fetchMock.mockResolvedValue(new Response('<svg></svg>', { headers: { 'Content-Type': 'image/svg+xml' } }))

  await expect(readDirectoryBuyerPhoto(base, buyerId, signedUrl)).rejects.toThrow('Buyer profile picture cannot be previewed')
})

test('an expired photo link fails locally without announcing lost access to the directory', async () => {
  const accessDenied = vi.fn()
  window.addEventListener('materyalph:access-denied', accessDenied)
  fetchMock.mockResolvedValue(new Response('', { status: 403 }))
  try {
    await expect(readDirectoryBuyerPhoto(base, buyerId, signedUrl)).rejects.toMatchObject({ response: { status: 403 } })
    expect(accessDenied).not.toHaveBeenCalled()
    expect(fetchMock).toHaveBeenCalledTimes(1)
  } finally {
    window.removeEventListener('materyalph:access-denied', accessDenied)
  }
})
