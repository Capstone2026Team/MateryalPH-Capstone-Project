import { afterEach, beforeEach, describe, expect, test, vi } from 'vitest'
import { ResponseError } from '@materyalph/api-client-ts'
import { clearWebSessionTransport } from '@materyalph/web-ui'
import { acceptAdminInvitation, readableApiError, resendRiskChallenge, signInAdmin, verifyRiskChallenge } from './auth-api'

afterEach(() => vi.unstubAllGlobals())
beforeEach(() => clearWebSessionTransport())

function failure(code: string, message: string, status = 401) {
  return new ResponseError(new Response(JSON.stringify({ data: null, meta: {}, errors: [{ code, message }] }), {
    status, headers: { 'Content-Type': 'application/json' },
  }))
}

describe('Admin authentication errors', () => {
  test('invalid login credentials are not presented as an expired session', async () => {
    expect(await readableApiError(failure('INVALID_CREDENTIALS', 'The email or password is incorrect.')))
      .toBe('The email or password is incorrect.')
  })

  test('unknown authentication failures retain the safe session-expiry fallback', async () => {
    expect(await readableApiError(failure('SESSION_REVOKED', 'Internal diagnostic')))
      .toBe('Your session has expired. Sign in again to continue.')
  })

  test('invalid MFA codes retain their actionable message', async () => {
    expect(await readableApiError(failure('MFA_CODE_INVALID', 'Enter a valid authenticator code.')))
      .toBe('Enter a valid authenticator code.')
  })
})

describe('Admin bot-protection transport', () => {
  test.each(['login', 'invitation', 'verify', 'resend'])('%s carries bot evidence or the Admin portal through generated CSRF cookie transport', async operation => {
    const fetchMock = vi.fn()
      .mockResolvedValueOnce(new Response(JSON.stringify({ data: { csrf_token: 'test-csrf' }, meta: {}, errors: [] }), { status: 200, headers: { 'Content-Type': 'application/json' } }))
      .mockResolvedValueOnce(new Response(JSON.stringify({ data: { mfa_required: true, next: 'SIGN_IN_AND_ENROLL_MFA', verified: true, expires_in: 300 }, meta: {}, errors: [] }), { status: 200, headers: { 'Content-Type': 'application/json' } }))
    vi.stubGlobal('fetch', fetchMock)
    if (operation === 'login') await signInAdmin('admin@example.test', 'TestPassword123', { recaptchaToken: 'test-checkbox' })
    if (operation === 'invitation') await acceptAdminInvitation({ token: 'test-invite', email: 'admin@example.test', fullName: 'Test Admin', password: 'TestPassword123', passwordConfirmation: 'TestPassword123' }, { requestEmailStepUp: true })
    if (operation === 'verify') await verifyRiskChallenge('test-challenge', 'admin@example.test', '123456')
    if (operation === 'resend') await resendRiskChallenge('test-challenge', 'admin@example.test')
    const request = fetchMock.mock.calls[1]?.[1] as RequestInit
    const body = JSON.parse(String(request.body)) as Record<string, unknown>
    if (operation === 'login') expect(body.bot_protection).toEqual({ recaptcha_token: 'test-checkbox' })
    if (operation === 'invitation') expect(body.bot_protection).toEqual({ request_email_step_up: true })
    if (operation === 'verify' || operation === 'resend') expect(body.portal).toBe('ADMIN')
    expect(request.credentials).toBe('include')
    expect(new Headers(request.headers).get('X-CSRF-Token')).toBe('test-csrf')
  })
})
