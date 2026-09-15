import { ResponseError } from '@materyalph/api-client-ts'
import { clearWebSessionTransport } from '@materyalph/web-ui'
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

    await Promise.all([
      withWebAuthApi((api) => api.logout()),
      withWebAuthApi((api) => api.logout()),
    ])

    expect(fetchMock.mock.calls.filter(([input]) => String(input).endsWith('/auth/csrf'))).toHaveLength(1)
    expect(fetchMock.mock.calls.filter(([input]) => String(input).endsWith('/auth/logout'))).toHaveLength(2)
  })

  test('refreshes concurrent protected requests once and retries each request once', async () => {
    let sessionCalls = 0
    const fetchMock = vi.fn(async (input: RequestInfo | URL) => {
      const url = String(input)
      if (url.endsWith('/auth/csrf')) return jsonResponse({ data: { csrf_token: 'refresh-test-csrf-token' }, meta: {}, errors: [] })
      if (url.endsWith('/auth/refresh')) return jsonResponse({ data: { session_id: 'test-session' }, meta: {}, errors: [] })
      sessionCalls += 1
      if (sessionCalls <= 2) return jsonResponse({ data: null, meta: {}, errors: [{ code: 'UNAUTHENTICATED', message: 'Expired.' }] }, 401)
      return jsonResponse({ data: { authenticated: true }, meta: {}, errors: [] })
    })
    vi.stubGlobal('fetch', fetchMock)

    await Promise.all([getSession(), getSession()])

    expect(fetchMock.mock.calls.filter(([input]) => String(input).endsWith('/auth/csrf'))).toHaveLength(1)
    expect(fetchMock.mock.calls.filter(([input]) => String(input).endsWith('/auth/refresh'))).toHaveLength(1)
    expect(fetchMock.mock.calls.filter(([input]) => String(input).endsWith('/auth/session'))).toHaveLength(4)
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
})

function jsonResponse(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json' },
  })
}
