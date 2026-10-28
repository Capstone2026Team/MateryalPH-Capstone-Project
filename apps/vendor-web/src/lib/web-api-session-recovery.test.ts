import { afterEach, expect, test, vi } from 'vitest'
import { clearWebSessionTransport, createWebApiConfiguration } from '@materyalph/web-ui'

const base = 'https://portal.example.test/api/v1'
const json = (status: number, data = {}) => new Response(JSON.stringify({ data, meta: {}, errors: [] }), {
  status, headers: { 'Content-Type': 'application/json' },
})
afterEach(() => { clearWebSessionTransport(); vi.useRealTimers(); vi.unstubAllGlobals(); vi.restoreAllMocks() })

test.each(['/vendors/onboarding', '/admin/account/profile', '/auth/session'])('a temporary failure on %s recovers without a manual retry', async path => {
  vi.useFakeTimers()
  const fetcher = vi.fn().mockResolvedValueOnce(json(500)).mockResolvedValueOnce(json(200, { recovered: true }))
  vi.stubGlobal('fetch', fetcher)
  const request = createWebApiConfiguration(base, { refreshSession: true }).fetchApi!(`${base}${path}`)
  await vi.advanceTimersByTimeAsync(300)
  expect(await (await request).json()).toMatchObject({ data: { recovered: true } })
  expect(fetcher).toHaveBeenCalledTimes(2)
})

test.each([502, 503, 504, 'network'])('a brief %s failure shares one retry across simultaneous readers', async failure => {
  vi.useFakeTimers()
  const fetcher = vi.fn()
  if (typeof failure === 'number') fetcher.mockResolvedValueOnce(json(failure))
  else fetcher.mockRejectedValueOnce(new TypeError('Failed to fetch'))
  fetcher.mockResolvedValue(json(200))
  vi.stubGlobal('fetch', fetcher)
  const transport = createWebApiConfiguration(base).fetchApi!
  const requests = [transport(`${base}/auth/session`), transport(`${base}/auth/session`)]
  await vi.advanceTimersByTimeAsync(300)
  expect((await Promise.all(requests)).map(response => response.status)).toEqual([200, 200])
  expect(fetcher).toHaveBeenCalledTimes(2)
})

test('a persistent server error stops after one retry and never expires the session', async () => {
  vi.useFakeTimers()
  const denied = vi.fn()
  window.addEventListener('materyalph:access-denied', denied)
  try {
    const fetcher = vi.fn(async () => json(500))
    vi.stubGlobal('fetch', fetcher)
    const request = createWebApiConfiguration(base, { refreshSession: true }).fetchApi!(`${base}/auth/session`)
    await vi.advanceTimersByTimeAsync(300)
    expect((await request).status).toBe(500)
    expect(fetcher).toHaveBeenCalledTimes(2)
    expect(denied).not.toHaveBeenCalled()
  } finally { window.removeEventListener('materyalph:access-denied', denied) }
})

test.each([401, 403, 404, 409, 419, 422, 429])('HTTP %s is not retried as a temporary server error', async status => {
  const fetcher = vi.fn(async () => json(status))
  vi.stubGlobal('fetch', fetcher)
  expect((await createWebApiConfiguration(base).fetchApi!(`${base}/example`)).status).toBe(status)
  expect(fetcher).toHaveBeenCalledOnce()
})

test('Retry-After and failed commands are never automatically replayed', async () => {
  const fetcher = vi.fn(async () => new Response('{}', { status: 503, headers: { 'Retry-After': '30' } }))
  vi.stubGlobal('fetch', fetcher)
  const transport = createWebApiConfiguration(base).fetchApi!
  expect((await transport(`${base}/example`)).status).toBe(503)
  fetcher.mockImplementation(async () => json(500))
  expect((await transport(`${base}/vendor/orders/confirm`, { method: 'POST' })).status).toBe(500)
  expect(fetcher).toHaveBeenCalledTimes(2)
})

test('private media keeps its existing explicit retry instead of replaying downloads', async () => {
  const fetcher = vi.fn(async () => json(503))
  vi.stubGlobal('fetch', fetcher)
  const response = await createWebApiConfiguration(base).fetchApi!(`${base}/vendors/account/photo`, { headers: { Accept: 'image/png' } })
  expect(response.status).toBe(503)
  expect(fetcher).toHaveBeenCalledOnce()
})

test.each(['logout', 'cancel'])('a pending read retry is not sent after %s', async action => {
  vi.useFakeTimers()
  const fetcher = vi.fn(async () => json(502))
  vi.stubGlobal('fetch', fetcher)
  const controller = new AbortController()
  const request = createWebApiConfiguration(base).fetchApi!(`${base}/example`, { signal: controller.signal })
  await vi.advanceTimersByTimeAsync(0)
  if (action === 'logout') {
    clearWebSessionTransport()
    await vi.advanceTimersByTimeAsync(300)
    expect((await request).status).toBe(502)
  } else {
    controller.abort(new Error('Canceled by caller'))
    const canceled = expect(request).rejects.toThrow('Canceled by caller')
    await vi.advanceTimersByTimeAsync(300)
    await canceled
  }
  expect(fetcher).toHaveBeenCalledOnce()
})

function waitForOtherTab() {
  const request = vi.fn()
    .mockImplementationOnce(async (_name, _options, callback) => callback(null))
    .mockImplementationOnce(async (_name, _options, callback) => callback({ name: 'fixture-refresh-lock' }))
  vi.stubGlobal('navigator', { locks: { request } })
  return request
}

test.each(['/vendors/onboarding', '/admin/account/profile'])('%s reuses cookies refreshed by another tab without rotating its token again', async path => {
  const locks = waitForOtherTab()
  const fetcher = vi.fn()
    .mockResolvedValueOnce(json(401))
    .mockResolvedValueOnce(json(200))
    .mockResolvedValueOnce(json(200, { recovered: true }))
  vi.stubGlobal('fetch', fetcher)
  const denied = vi.fn()
  window.addEventListener('materyalph:access-denied', denied)
  try {
    const response = await createWebApiConfiguration(base, { refreshSession: true }).fetchApi!(`${base}${path}`)
    expect(response.status).toBe(200)
    expect(fetcher.mock.calls.map(([url]) => url)).toEqual([`${base}${path}`, `${base}/auth/session`, `${base}${path}`])
    expect(locks).toHaveBeenNthCalledWith(1, `materyalph:refresh:${base}`, { ifAvailable: true }, expect.any(Function))
    expect(locks).toHaveBeenNthCalledWith(2, `materyalph:refresh:${base}`, { signal: expect.any(AbortSignal) }, expect.any(Function))
    expect(denied).not.toHaveBeenCalled()
  } finally { window.removeEventListener('materyalph:access-denied', denied) }
})

test('a waiting tab still refreshes when the other tab did not restore the session', async () => {
  waitForOtherTab()
  const fetcher = vi.fn(async (input: RequestInfo | URL) => {
    if (String(input).endsWith('/csrf')) return json(200, { csrf_token: 'fixture-csrf-token' })
    if (String(input).endsWith('/refresh')) return json(200)
    return json(401)
  })
  vi.stubGlobal('fetch', fetcher)
  expect((await createWebApiConfiguration(base, { refreshSession: true }).fetchApi!(`${base}/example`)).status).toBe(401)
  expect(fetcher.mock.calls.filter(([url]) => String(url).endsWith('/auth/refresh'))).toHaveLength(1)
})

test('a temporary session-probe failure never rotates or invalidates the shared session', async () => {
  vi.useFakeTimers()
  waitForOtherTab()
  const fetcher = vi.fn().mockResolvedValueOnce(json(401)).mockImplementation(async () => json(503))
  vi.stubGlobal('fetch', fetcher)
  const request = createWebApiConfiguration(base, { refreshSession: true }).fetchApi!(`${base}/example`)
  await vi.advanceTimersByTimeAsync(300)
  expect((await request).status).toBe(503)
  expect(fetcher.mock.calls.map(([url]) => url)).toEqual([`${base}/example`, `${base}/auth/session`, `${base}/auth/session`])
})

test('two independent tabs hold the same browser lock through refresh and rotate only once', async () => {
  let held: Promise<void> | null = null
  const locks = vi.fn(async (_name: string, options: { ifAvailable?: boolean }, callback: (lock: object | null) => Promise<unknown>) => {
    if (held && options.ifAvailable) return callback(null)
    if (held) await held
    let release!: () => void
    held = new Promise<void>(resolve => { release = resolve })
    try { return await callback({ name: 'fixture-refresh-lock' }) }
    finally { held = null; release() }
  })
  vi.stubGlobal('navigator', { locks: { request: locks } })
  let refreshed = false
  let finishRefresh!: () => void
  const refreshGate = new Promise<void>(resolve => { finishRefresh = resolve })
  const fetcher = vi.fn(async (input: RequestInfo | URL) => {
    if (String(input).endsWith('/csrf')) return json(200, { csrf_token: 'fixture-shared-csrf' })
    if (String(input).endsWith('/refresh')) {
      await refreshGate
      refreshed = true
      return json(200)
    }
    return json(refreshed ? 200 : 401)
  })
  vi.stubGlobal('fetch', fetcher)
  vi.resetModules()
  const otherTab = await import('../../../../packages/web-ui/src/web-api-session')
  try {
    const first = createWebApiConfiguration(base, { refreshSession: true }).fetchApi!(`${base}/vendors/onboarding`)
    await vi.waitFor(() => expect(fetcher.mock.calls.some(([url]) => String(url).endsWith('/refresh'))).toBe(true))
    const second = otherTab.createWebApiConfiguration(base, { refreshSession: true }).fetchApi!(`${base}/admin/account/profile`)
    await vi.waitFor(() => expect(locks).toHaveBeenCalledTimes(3))
    finishRefresh()
    expect((await Promise.all([first, second])).map(response => response.status)).toEqual([200, 200])
    expect(fetcher.mock.calls.filter(([url]) => String(url).endsWith('/refresh'))).toHaveLength(1)
  } finally { finishRefresh(); otherTab.clearWebSessionTransport() }
})
