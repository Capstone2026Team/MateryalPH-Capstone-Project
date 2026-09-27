import { ResponseError } from '@materyalph/api-client-ts'
import { clearWebSessionTransport, createWebApiConfiguration, rateLimitMessage } from '@materyalph/web-ui'
import { afterEach, beforeEach, describe, expect, test, vi } from 'vitest'

import { asValidationFailure, getSession, signOut, withWebAuthApi } from './auth-api'

afterEach(() => vi.unstubAllGlobals())
beforeEach(() => clearWebSessionTransport())

describe('Vendor auth API errors', () => {
  test('retains only safe Laravel validation field messages', async () => {
    const error = new ResponseError(new Response(JSON.stringify({
      data: null,
      meta: {},
      errors: [{
        code: 'VALIDATION_FAILED',
        message: 'Review the highlighted fields and try again.',
        details: {
          full_name: ['Enter the Vendor Owner name.'],
          'bot_protection.recaptcha_token': ['Complete the security checkbox again.'],
          'unsafe field name!': ['Must not be retained.'],
          email: { internal: 'Must not be retained.' },
        },
      }],
    }), { status: 422, headers: { 'Content-Type': 'application/json' } }))

    await expect(asValidationFailure(error)).resolves.toEqual({
      message: 'Review the highlighted fields and try again.',
      fieldErrors: {
        full_name: ['Enter the Vendor Owner name.'],
        'bot_protection.recaptcha_token': ['Complete the security checkbox again.'],
      },
    })
  })

  test('does not treat unrelated API errors as validation details', async () => {
    const error = new ResponseError(new Response(JSON.stringify({
      data: null,
      meta: {},
      errors: [{ code: 'INTERNAL_ERROR', message: 'The request could not be completed.', details: { trace: ['hidden'] } }],
    }), { status: 500, headers: { 'Content-Type': 'application/json' } }))

    await expect(asValidationFailure(error)).resolves.toBeNull()
  })
})

describe('Vendor auth API transport', () => {
  test('page permission denial neither refreshes nor logs out an authenticated session', async () => {
    const fetchMock = vi.fn(async () => jsonResponse({ data: null, meta: {}, errors: [{ code: 'PERMISSION_DENIED', message: 'This page is unavailable.' }] }, 403))
    vi.stubGlobal('fetch', fetchMock)
    await expect(getSession()).rejects.toMatchObject({ response: { status: 403 } })
    expect(fetchMock).toHaveBeenCalledOnce()
  })
  test('logs out through the CSRF-protected credentialed browser endpoint', async () => {
    const fetchMock = vi.fn()
      .mockResolvedValueOnce(jsonResponse({
        data: { csrf_token: 'test-csrf-token' },
        meta: {},
        errors: [],
      }))
      .mockResolvedValueOnce(jsonResponse({
        data: { logged_out: true },
        meta: {},
        errors: [],
      }))
    vi.stubGlobal('fetch', fetchMock)

    await signOut()

    expect(fetchMock).toHaveBeenCalledTimes(2)
    expect(fetchMock.mock.calls[0]).toEqual([
      'http://localhost:8080/api/v1/auth/csrf',
      expect.objectContaining({ method: 'GET', credentials: 'include' }),
    ])
    expect(fetchMock.mock.calls[1]).toEqual([
      'http://localhost:8080/api/v1/auth/logout',
      expect.objectContaining({
        method: 'POST',
        credentials: 'include',
        headers: expect.objectContaining({ 'X-CSRF-Token': 'test-csrf-token' }),
      }),
    ])
  })

  test('deduplicates concurrent CSRF acquisition for protected mutations', async () => {
    const fetchMock = vi.fn(async (input: RequestInfo | URL) => {
      const url = String(input)
      if (url.endsWith('/auth/csrf')) return jsonResponse({ data: { csrf_token: 'shared-test-csrf-token' }, meta: {}, errors: [] })
      return jsonResponse({ data: { logged_out: true }, meta: {}, errors: [] })
    })
    vi.stubGlobal('fetch', fetchMock)

    const results = await Promise.allSettled([
      withWebAuthApi((api) => api.logout()),
      withWebAuthApi((api) => api.logout()),
    ])

    expect(fetchMock.mock.calls.filter(([input]) => String(input).endsWith('/auth/csrf'))).toHaveLength(1)
    expect(fetchMock.mock.calls.filter(([input]) => String(input).endsWith('/auth/logout'))).toHaveLength(1)
    expect(results.filter(result => result.status === 'rejected')).toHaveLength(1)
  })

  test('refreshes concurrent protected requests once and retries each request once', async () => {
    let sessionCalls = 0
    const fetchMock = vi.fn(async (input: RequestInfo | URL) => {
      const url = String(input)
      if (url.endsWith('/auth/csrf')) return jsonResponse({ data: { csrf_token: 'refresh-test-csrf-token' }, meta: {}, errors: [] })
      if (url.endsWith('/auth/refresh')) return jsonResponse({ data: { session_id: 'test-session' }, meta: {}, errors: [] })
      sessionCalls += 1
      if (sessionCalls === 1) return jsonResponse({ data: null, meta: {}, errors: [{ code: 'UNAUTHENTICATED', message: 'Expired.' }] }, 401)
      return jsonResponse({ data: { authenticated: true }, meta: {}, errors: [] })
    })
    vi.stubGlobal('fetch', fetchMock)

    await Promise.all([getSession(), getSession()])

    expect(fetchMock.mock.calls.filter(([input]) => String(input).endsWith('/auth/csrf'))).toHaveLength(1)
    expect(fetchMock.mock.calls.filter(([input]) => String(input).endsWith('/auth/refresh'))).toHaveLength(1)
    expect(fetchMock.mock.calls.filter(([input]) => String(input).endsWith('/auth/session'))).toHaveLength(2)
  })

  test('honors Retry-After without blocking other endpoints and permits manual retry after expiry', async () => {
    const clock = vi.spyOn(Date, 'now').mockReturnValue(100000)
    const fetchMock = vi.fn(async () => new Response('{}', { status: 429, headers: { 'Retry-After': '30' } }))
    vi.stubGlobal('fetch', fetchMock)
    const transport = createWebApiConfiguration('http://localhost:8080/api/v1').fetchApi
    if (!transport) throw new Error('Expected configured transport')
    try {
      const first = await transport('http://localhost:8080/api/v1/example')
      expect(rateLimitMessage(first)).toContain('30 seconds')
      await transport('http://localhost:8080/api/v1/example')
      expect(fetchMock).toHaveBeenCalledTimes(1)
      await transport('http://localhost:8080/api/v1/other')
      expect(fetchMock).toHaveBeenCalledTimes(2)
      clock.mockReturnValue(131000)
      await transport('http://localhost:8080/api/v1/example')
      expect(fetchMock).toHaveBeenCalledTimes(3)
    } finally { clock.mockRestore() }
  })

  test('simultaneous reads have independently readable bodies without caching completed data', async () => {
    const fetchMock = vi.fn(async () => jsonResponse({ value: 'current' }))
    vi.stubGlobal('fetch', fetchMock)
    const transport = createWebApiConfiguration('http://localhost:8080/api/v1').fetchApi
    if (!transport) throw new Error('Expected configured transport')
    const responses = await Promise.all([transport('/example'), transport('/example')])
    expect(await responses[0].json()).toEqual({ value: 'current' })
    expect(await responses[1].json()).toEqual({ value: 'current' })
    expect(fetchMock).toHaveBeenCalledTimes(1)
    await transport('/example')
    expect(fetchMock).toHaveBeenCalledTimes(2)
  })

  test('allows overlapping declared lookup POSTs while guarding real mutations', async () => {
    const pending: ((response: Response) => void)[] = []
    vi.stubGlobal('fetch', vi.fn(() => new Promise<Response>(resolve => { pending.push(resolve) })))
    const base = 'http://localhost:8080/api/v1'
    const transport = createWebApiConfiguration(base, { readOnlyPostPaths: ['/vendors/onboarding/address/pin'] }).fetchApi!
    const older = transport(`${base}/vendors/onboarding/address/pin`, { method: 'POST', body: 'old' })
    const newer = transport(`${base}/vendors/onboarding/address/pin`, { method: 'POST', body: 'new' })
    expect(pending).toHaveLength(2)
    pending[1]!(jsonResponse({ point: 'new' }))
    expect(await (await newer).json()).toEqual({ point: 'new' })
    pending[0]!(jsonResponse({ point: 'old' }))
    await older
    const submit = transport(`${base}/vendors/onboarding/verification/submit`, { method: 'POST' })
    await expect(transport(`${base}/vendors/onboarding/verification/submit`, { method: 'POST' })).rejects.toThrow('already processing')
    pending[2]!(jsonResponse({ submitted: true }))
    await submit
  })

  test('returns HTTP 429 without refreshing or clearing the browser session', async () => {
    const fetchMock = vi.fn(async () => jsonResponse({
      data: null,
      meta: {},
      errors: [{ code: 'RATE_LIMITED', message: 'Too many attempts.' }],
    }, 429))
    vi.stubGlobal('fetch', fetchMock)

    await expect(getSession()).rejects.toMatchObject({ response: { status: 429 } })
    expect(fetchMock).toHaveBeenCalledOnce()
  })

  test('later protected requests honor a throttled refresh without resending it', async () => {
    const clock = vi.spyOn(Date, 'now').mockReturnValue(100000)
    const base = 'http://localhost:8080/api/v1'
    const fetchMock = vi.fn(async (input: RequestInfo | URL) => {
      if (String(input).endsWith('/auth/csrf')) return jsonResponse({ data: { csrf_token: 'refresh-cooldown-test' } })
      if (String(input).endsWith('/auth/refresh')) return new Response('{}', { status: 429, headers: { 'Retry-After': '30' } })
      return new Response('{}', { status: 401 })
    })
    vi.stubGlobal('fetch', fetchMock)
    const transport = createWebApiConfiguration(base, { refreshSession: true }).fetchApi!
    try {
      for (const path of ['/auth/session', '/vendors/account/profile', '/admin/account/profile']) {
        expect((await transport(`${base}${path}`)).status).toBe(429)
      }
      expect(fetchMock.mock.calls.filter(([input]) => String(input).endsWith('/auth/refresh'))).toHaveLength(1)
      clock.mockReturnValue(131000)
      await transport(`${base}/auth/session`)
      expect(fetchMock.mock.calls.filter(([input]) => String(input).endsWith('/auth/refresh'))).toHaveLength(2)
    } finally { clock.mockRestore() }
  })

  test('a rejected CSRF bootstrap is not repeatedly requested by subsequent clicks', async () => {
    const fetchMock = vi.fn(async () => new Response('{}', { status: 429, headers: { 'Retry-After': '30' } }))
    vi.stubGlobal('fetch', fetchMock)
    await expect(signOut()).rejects.toMatchObject({ response: { status: 429 } })
    await expect(signOut()).rejects.toMatchObject({ response: { status: 429 } })
    expect(fetchMock).toHaveBeenCalledOnce()
  })

  test('a refresh with persistent CSRF failure stops after one token renewal', async () => {
    const fetchMock = vi.fn(async (input: RequestInfo | URL) => String(input).endsWith('/auth/csrf')
      ? jsonResponse({ data: { csrf_token: 'renewed-csrf-test' } })
      : new Response('{}', { status: String(input).endsWith('/auth/refresh') ? 419 : 401 }))
    vi.stubGlobal('fetch', fetchMock)
    await expect(getSession()).rejects.toMatchObject({ response: { status: 419 } })
    expect(fetchMock.mock.calls.filter(([input]) => String(input).endsWith('/auth/refresh'))).toHaveLength(2)
    expect(fetchMock.mock.calls.filter(([input]) => String(input).endsWith('/auth/csrf'))).toHaveLength(2)
  })

  test('a late old-session 401 reuses the completed refresh and retries only once', async () => {
    const base = 'http://localhost:8080/api/v1'
    let releaseLate: (response: Response) => void = () => { throw new Error('Missing late request') }
    let fastCalls = 0
    let slowCalls = 0
    const fetchMock = vi.fn(async (input: RequestInfo | URL) => {
      const url = String(input)
      if (url.endsWith('/auth/csrf')) return jsonResponse({ data: { csrf_token: 'late-session-csrf' } })
      if (url.endsWith('/auth/refresh')) return jsonResponse({ data: {} })
      if (url.endsWith('/slow') && ++slowCalls === 1) return new Promise<Response>(resolve => { releaseLate = resolve })
      if (url.endsWith('/fast') && ++fastCalls === 1) return new Response('{}', { status: 401 })
      return new Response('{}', { status: 401 })
    })
    vi.stubGlobal('fetch', fetchMock)
    const transport = createWebApiConfiguration(base, { refreshSession: true }).fetchApi!
    const slow = transport(`${base}/slow`)
    expect((await transport(`${base}/fast`)).status).toBe(401)
    releaseLate(new Response('{}', { status: 401 }))
    expect((await slow).status).toBe(401)
    expect(fetchMock.mock.calls.filter(([input]) => String(input).endsWith('/auth/refresh'))).toHaveLength(1)
    expect(fastCalls).toBe(2)
    expect(slowCalls).toBe(2)
  })
})

function jsonResponse(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json' },
  })
}
