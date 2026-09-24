import { describe, expect, test } from 'vitest'
import { ResponseError } from '@materyalph/api-client-ts'
import { readableApiError } from './auth-api'

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
