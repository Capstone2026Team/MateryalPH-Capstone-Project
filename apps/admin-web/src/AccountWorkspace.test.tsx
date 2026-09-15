import { fireEvent, render, screen, waitFor } from '@testing-library/react'
import { afterEach, beforeEach, describe, expect, test, vi } from 'vitest'
import { AccountWorkspace } from '@materyalph/web-ui'

const profile = {
  id: 'account-fixture', full_name: 'Support employee', email: 'support@example.test',
  account_type: 'ADMIN', account_status: 'ACTIVE', lock_version: 1,
  created_at: '2026-09-01T00:00:00Z', buyer_type: null, company_name: null,
  organization_name: null, organization_id: null, membership_id: 'membership-fixture',
  role: 'ADMIN_SUPPORT', can_manage_staff: false, permissions: [],
}
let status = 200
const requests: { path: string; method: string }[] = []
const envelope = (data: unknown) => new Response(JSON.stringify({ data, meta: {}, errors: [] }), { status: 200, headers: { 'Content-Type': 'application/json' } })

describe('Account workspace access and security', () => {
  beforeEach(() => {
    status = 200
    requests.length = 0
    vi.stubGlobal('fetch', vi.fn(async (input: RequestInfo | URL, init?: RequestInit) => {
      const path = String(input)
      requests.push({ path, method: init?.method ?? 'GET' })
      if (path.includes('/csrf')) return envelope({ csrf_token: 'test-csrf' })
      if (path.endsWith('/profile')) {
        if (status !== 200) return new Response(JSON.stringify({ data: null, meta: {}, errors: [{ code: 'UNAUTHENTICATED', message: 'Sign in again.' }] }), { status })
        return envelope(profile)
      }
      if (path.endsWith('/security')) return envelope({ totp_enrolled: true, recent_authentication_expires_at: null })
      if (path.includes('/sessions')) return envelope([])
      return envelope({ queued: true })
    }))
  })
  afterEach(() => vi.unstubAllGlobals())

  function open() { render(<AccountWorkspace portal="admin" basePath="https://api.example.test/api/v1" loginPath="/login" renderQr={() => null} />) }

  test('uses the resolved role and hides ungranted administration', async () => {
    open()
    expect(await screen.findByRole('heading', { name: 'Your account' })).toBeVisible()
    expect(screen.getByRole('textbox', { name: 'Full name' })).toHaveValue('Support employee')
    expect(screen.queryByRole('button', { name: 'Admin invitations' })).not.toBeInTheDocument()
    expect(screen.queryByRole('button', { name: 'Admin accounts' })).not.toBeInTheDocument()
    expect(screen.queryByRole('button', { name: 'Staff access' })).not.toBeInTheDocument()
  })

  test('expired sessions remove account controls and offer sign-in', async () => {
    status = 401
    open()
    expect(await screen.findByRole('heading', { name: 'Sign-in required' })).toBeVisible()
    expect(screen.queryByRole('textbox', { name: 'Full name' })).not.toBeInTheDocument()
    expect(screen.getByRole('link', { name: 'Return to sign in' })).toHaveAttribute('href', '/login')
  })

  test('email verification retains the required authenticator input', async () => {
    open()
    await screen.findByRole('heading', { name: 'Your account' })
    fireEvent.click(screen.getByRole('button', { name: 'Security' }))
    const send = await screen.findByRole('button', { name: 'Send email verification instead' })
    await waitFor(() => expect(send).toBeEnabled())
    fireEvent.click(send)
    expect(await screen.findByText('A verification code was sent to your current email.')).toBeVisible()
    expect(screen.getByRole('textbox', { name: 'Authenticator code for email verification' })).toBeRequired()
    expect(requests.some(request => request.path.endsWith('/reauthentication/email') && request.method === 'POST')).toBe(true)
  })

  test('canceling revoke-all sends no session mutation', async () => {
    vi.spyOn(window, 'confirm').mockReturnValueOnce(false)
    open()
    await screen.findByRole('heading', { name: 'Your account' })
    const revoke = screen.getByRole('button', { name: 'Sign out all devices' })
    await waitFor(() => expect(revoke).toBeEnabled())
    fireEvent.click(revoke)
    expect(requests.some(request => request.path.endsWith('/sessions/revoke'))).toBe(false)
  })
})
