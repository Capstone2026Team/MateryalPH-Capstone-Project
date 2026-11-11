import { afterEach, expect, test, vi } from 'vitest'
import { clearWebSessionTransport, createWebApiConfiguration, getWebCsrfToken } from '@materyalph/web-ui'

const base = 'https://portal.example.test/api/v1'
const json = (data: unknown, status = 200) => new Response(JSON.stringify({ data, meta: {}, errors: [] }), {
  status, headers: { 'Content-Type': 'application/json' },
})

afterEach(() => { clearWebSessionTransport(); vi.unstubAllGlobals() })

test('a CSRF response from a cleared session cannot authorize a waiting action or replace the new token', async () => {
  let finishOld!: (response: Response) => void
  const fetcher = vi.fn()
    .mockImplementationOnce(() => new Promise<Response>(resolve => { finishOld = resolve }))
    .mockResolvedValue(json({ csrf_token: 'new-session-csrf' }))
  vi.stubGlobal('fetch', fetcher)
  const previous = getWebCsrfToken(base)
  const rejected = expect(previous).rejects.toThrow('session changed')
  clearWebSessionTransport()
  expect(await getWebCsrfToken(base)).toBe('new-session-csrf')
  finishOld(json({ csrf_token: 'old-session-csrf' }))
  await rejected
  expect(await getWebCsrfToken(base)).toBe('new-session-csrf')
  expect(fetcher).toHaveBeenCalledTimes(2)
})

test('finishing an old CSRF request does not remove the new session bootstrap from coordination', async () => {
  let finishOld!: (response: Response) => void
  let finishNew!: (response: Response) => void
  const fetcher = vi.fn()
    .mockImplementationOnce(() => new Promise<Response>(resolve => { finishOld = resolve }))
    .mockImplementationOnce(() => new Promise<Response>(resolve => { finishNew = resolve }))
  vi.stubGlobal('fetch', fetcher)
  const previous = getWebCsrfToken(base)
  const rejected = expect(previous).rejects.toThrow('session changed')
  clearWebSessionTransport()
  const current = getWebCsrfToken(base)
  finishOld(json({ csrf_token: 'old-session-csrf' }))
  await rejected
  expect(getWebCsrfToken(base)).toBe(current)
  finishNew(json({ csrf_token: 'new-session-csrf' }))
  expect(await current).toBe('new-session-csrf')
  expect(fetcher).toHaveBeenCalledTimes(2)
})

test.each(['/vendors/onboarding', '/admin/account/profile'])('%s does not refresh a cleared session after acquiring the browser lock', async path => {
  const fetcher = vi.fn(async (input: RequestInfo | URL) => String(input).endsWith('/csrf')
    ? json({ csrf_token: 'cached-session-csrf' }) : json({}, 401))
  vi.stubGlobal('fetch', fetcher)
  await getWebCsrfToken(base)
  vi.stubGlobal('navigator', { locks: { request: vi.fn((_name, _options, callback) => {
    const result = callback({ name: 'fixture-refresh-lock' })
    clearWebSessionTransport()
    return result
  }) } })
  const response = await createWebApiConfiguration(base, { refreshSession: true }).fetchApi!(`${base}${path}`)
  expect(response.status).toBe(401)
  expect(fetcher.mock.calls.map(([url]) => String(url))).toEqual([`${base}/auth/csrf`, `${base}${path}`])
})

test.each(['/vendor/orders/fixture/confirm', '/admin/disputes/fixture/decision'])('a delayed 419 on %s never renews CSRF or replays the action after logout', async path => {
  let finish!: (response: Response) => void
  const fetcher = vi.fn(() => new Promise<Response>(resolve => { finish = resolve }))
  vi.stubGlobal('fetch', fetcher)
  const request = createWebApiConfiguration(base, { refreshSession: true }).fetchApi!(`${base}${path}`, { method: 'POST' })
  clearWebSessionTransport()
  finish(json({}, 419))
  expect((await request).status).toBe(419)
  expect(fetcher).toHaveBeenCalledOnce()
})

test('an old refresh response cannot prevent the replacement session from recovering its own expired cookie', async () => {
  let finishOldRefresh!: (response: Response) => void
  let finishCurrentRead!: (response: Response) => void
  let currentAuthenticated = false
  let refreshes = 0
  let currentReads = 0
  const fetcher = vi.fn(async (input: RequestInfo | URL): Promise<Response> => {
    const url = String(input)
    if (url.endsWith('/csrf')) return json({ csrf_token: 'fixture-session-csrf' })
    if (url.endsWith('/refresh')) {
      if (++refreshes === 1) return new Promise<Response>(resolve => { finishOldRefresh = resolve })
      currentAuthenticated = true
      return json({})
    }
    if (url.endsWith('/current') && ++currentReads === 1) return new Promise<Response>(resolve => { finishCurrentRead = resolve })
    return json({}, currentAuthenticated ? 200 : 401)
  })
  vi.stubGlobal('fetch', fetcher)
  const transport = createWebApiConfiguration(base, { refreshSession: true }).fetchApi!
  const previous = transport(`${base}/previous`)
  await vi.waitFor(() => expect(refreshes).toBe(1))
  clearWebSessionTransport()
  const current = transport(`${base}/current`)
  finishOldRefresh(json({}))
  expect((await previous).status).toBe(401)
  finishCurrentRead(json({}, 401))
  expect((await current).status).toBe(200)
  expect(refreshes).toBe(2)
})
