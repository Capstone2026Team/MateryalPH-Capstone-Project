import { afterEach, expect, test, vi } from 'vitest'
import { clearWebSessionTransport, createWebApiConfiguration, getWebCsrfToken } from '@materyalph/web-ui'
import { getVendorOnboarding, readableOnboardingError } from './onboarding-api'
import { PortalResourceStore } from '../../../../packages/web-ui/src/portal-resource-store'

const base = 'http://localhost:8080/api/v1'
const json = (data: unknown, status = 200) => new Response(JSON.stringify({ data, meta: {}, errors: [] }), { status, headers: { 'Content-Type': 'application/json' } })

afterEach(() => { clearWebSessionTransport(); vi.useRealTimers(); vi.unstubAllGlobals(); vi.unstubAllEnvs() })

test.each(['5173', '5174'])('local portal %s proxies API requests without changing the configured API identity', async port => {
  vi.stubEnv('DEV', true)
  vi.stubGlobal('window', { location: new URL(`http://localhost:${port}/dashboard`), dispatchEvent: vi.fn() })
  const fetchMock = vi.fn(async (_input: RequestInfo | URL, _init?: RequestInit) => json({ status: 'ok' }))
  vi.stubGlobal('fetch', fetchMock)
  const transport = createWebApiConfiguration(base).fetchApi!
  const signature = '?expires=123&signature=abc%2Bdef'
  await transport(`${base}/vendors/onboarding${signature}`, { credentials: 'include', headers: { Accept: 'application/json' } })
  expect(fetchMock).toHaveBeenLastCalledWith(`http://localhost:${port}/api/v1/vendors/onboarding${signature}`, expect.objectContaining({ credentials: 'include' }))
  expect(createWebApiConfiguration(base).basePath).toBe(base)
  await transport('https://api.example.test/api/v1/accounts/profile')
  expect(fetchMock.mock.calls.at(-1)?.[0]).toBe('https://api.example.test/api/v1/accounts/profile')
  vi.stubEnv('DEV', false)
  await transport(`${base}/health`)
  expect(fetchMock.mock.calls.at(-1)?.[0]).toBe(`${base}/health`)
})

test('a stalled onboarding request leaves loading, remains signed in and can be retried', async () => {
  vi.useFakeTimers()
  const signals: AbortSignal[] = []
  const fetchMock = vi.fn((input: RequestInfo | URL, init?: RequestInit) => {
    if (String(input).endsWith('/csrf')) return Promise.resolve(json({ csrf_token: 'fixture-csrf-token' }))
    signals.push(init!.signal!)
    return new Promise<Response>(() => {})
  })
  vi.stubGlobal('fetch', fetchMock)
  const denied = vi.fn()
  window.addEventListener('materyalph:access-denied', denied)
  try {
    const store = new PortalResourceStore()
    const loading = store.load('vendor-onboarding', getVendorOnboarding)
    await vi.advanceTimersByTimeAsync(30_000)
    await loading
    expect(store.read('vendor-onboarding')).toMatchObject({ data: null, pending: false })
    expect(await readableOnboardingError(store.read('vendor-onboarding').error)).toMatch(/taking too long.*try again/)
    expect(signals[0]?.aborted).toBe(true)
    expect(denied).not.toHaveBeenCalled()
    fetchMock.mockImplementation(async () => json({ step_completion: [], lock_version: 1, requirements: [], drafts: [], organization: {}, permissions: [], sections: {}, verification: {}, setup: {}, activation: {}, welcome_required: false }))
    await store.load('vendor-onboarding', getVendorOnboarding)
    expect(store.read('vendor-onboarding')).toMatchObject({ data: { lockVersion: 1 }, error: null, pending: false })
    expect(signals).toHaveLength(1)
  } finally { window.removeEventListener('materyalph:access-denied', denied) }
})

test('a stalled shared CSRF bootstrap is released so an explicit retry can obtain a new token', async () => {
  vi.useFakeTimers()
  const fetchMock = vi.fn(() => new Promise<Response>(() => {}))
  vi.stubGlobal('fetch', fetchMock)
  const first = getWebCsrfToken(base)
  expect(getWebCsrfToken(base)).toBe(first)
  const failed = expect(first).rejects.toThrow('taking too long')
  await vi.advanceTimersByTimeAsync(30_000)
  await failed
  fetchMock.mockImplementation(async () => json({ csrf_token: 'fixture-recovered-csrf' }))
  expect(await getWebCsrfToken(base)).toBe('fixture-recovered-csrf')
  expect(fetchMock).toHaveBeenCalledTimes(2)
})

test('a JSON body that stalls after its headers also times out', async () => {
  vi.useFakeTimers()
  const response = new Response('{}', { headers: { 'Content-Type': 'application/json' } })
  vi.spyOn(response, 'arrayBuffer').mockImplementation(() => new Promise<ArrayBuffer>(() => {}))
  vi.stubGlobal('fetch', vi.fn(async () => response))
  const request = createWebApiConfiguration(base).fetchApi!(`${base}/vendors/onboarding`)
  const failed = expect(request).rejects.toThrow('taking too long')
  await vi.advanceTimersByTimeAsync(30_000)
  await failed
})

test('caller cancellation remains effective', async () => {
  vi.useFakeTimers()
  const controller = new AbortController()
  let requestSignal: AbortSignal | null = null
  const fetchMock = vi.fn((_input: RequestInfo | URL, init?: RequestInit) => {
    requestSignal = init?.signal ?? null
    return new Promise<Response>((_resolve, reject) => { init?.signal?.addEventListener('abort', () => reject(init.signal!.reason), { once: true }) })
  })
  vi.stubGlobal('fetch', fetchMock)
  const transport = createWebApiConfiguration(base).fetchApi!
  const request = transport(`${base}/vendors/onboarding`, { signal: controller.signal })
  const canceled = expect(request).rejects.toThrow('Canceled by caller')
  controller.abort(new Error('Canceled by caller'))
  await canceled
  expect((requestSignal as AbortSignal | null)?.aborted).toBe(true)
  expect(fetchMock).toHaveBeenCalledTimes(1)
})

test('the read timeout never cancels or automatically replays an in-flight mutation', async () => {
  vi.useFakeTimers()
  let finish!: (response: Response) => void
  const fetchMock = vi.fn(() => new Promise<Response>(resolve => { finish = resolve }))
  vi.stubGlobal('fetch', fetchMock)
  const transport = createWebApiConfiguration(base).fetchApi!
  const request = transport(`${base}/vendor/orders/fixture/confirm`, { method: 'POST' })
  await vi.advanceTimersByTimeAsync(60_000)
  expect(fetchMock).toHaveBeenCalledTimes(1)
  await expect(transport(`${base}/vendor/orders/fixture/confirm`, { method: 'POST' })).rejects.toThrow('already processing')
  finish(json({ confirmed: true }))
  expect((await request).status).toBe(200)
})
