import { afterEach, beforeEach, expect, test, vi } from 'vitest'
import { clearWebSessionTransport, readWebPrivateFile } from '@materyalph/web-ui'
const base = 'http://localhost:8080/api/v1'
const url = `${base}/vendor-onboarding-files/example/content?expires=123&signature=test`
beforeEach(() => clearWebSessionTransport())
afterEach(() => vi.unstubAllGlobals())

test('private content is fetched with portal credentials and no caching', async () => {
  const fetcher = vi.fn().mockResolvedValue(new Response('synthetic PDF', { headers: { 'Content-Type': 'application/pdf' } }))
  vi.stubGlobal('fetch', fetcher)
  expect((await readWebPrivateFile(base, url)).type).toBe('application/pdf')
  expect(fetcher).toHaveBeenCalledWith(new URL(url), expect.objectContaining({ credentials: 'include', cache: 'no-store' }))
})
test('foreign origins and non-evidence paths never receive credentials', async () => {
  const fetcher = vi.fn()
  vi.stubGlobal('fetch', fetcher)
  await expect(readWebPrivateFile(base, 'https://example.test/private')).rejects.toThrow('invalid')
  await expect(readWebPrivateFile(base, `${base}/auth/session`)).rejects.toThrow('invalid')
  expect(fetcher).not.toHaveBeenCalled()
})
test('access denied and executable content are not previewed', async () => {
  const fetcher = vi.fn().mockResolvedValueOnce(new Response('{}', { status: 403 })).mockResolvedValueOnce(new Response('<script/>', { headers: { 'Content-Type': 'text/html' } }))
  vi.stubGlobal('fetch', fetcher)
  await expect(readWebPrivateFile(base, url)).rejects.toThrow()
  await expect(readWebPrivateFile(base, url)).rejects.toThrow('cannot be previewed')
  expect(fetcher).toHaveBeenCalledTimes(2)
})
test('expired portal session refreshes before retrying private content', async () => {
  const json = (data: unknown) => new Response(JSON.stringify({ data }), { headers: { 'Content-Type': 'application/json' } })
  const fetcher = vi.fn().mockResolvedValueOnce(new Response('{}', { status: 401 })).mockResolvedValueOnce(json({ csrf_token: 'synthetic-csrf-for-test' })).mockResolvedValueOnce(json({})).mockResolvedValueOnce(new Response('image', { headers: { 'Content-Type': 'image/png' } }))
  vi.stubGlobal('fetch', fetcher)
  expect((await readWebPrivateFile(base, url)).type).toBe('image/png')
  expect(fetcher).toHaveBeenCalledTimes(4)
  expect(fetcher.mock.calls[2]?.[0]).toBe(`${base}/auth/refresh`)
})
