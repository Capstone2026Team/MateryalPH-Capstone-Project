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
let verificationStatus = 200
const requests: { path: string; method: string; body: string | undefined }[] = []
const envelope = (data: unknown) => new Response(JSON.stringify({ data, meta: {}, errors: [] }), { status: 200, headers: { 'Content-Type': 'application/json' } })

describe('Account workspace access and security', () => {
  beforeEach(() => {
    status = 200
    verificationStatus = 200
    requests.length = 0
    vi.stubGlobal('fetch', vi.fn(async (input: RequestInfo | URL, init?: RequestInit) => {
      const path = String(input)
      requests.push({ path, method: init?.method ?? 'GET', body: typeof init?.body === 'string' ? init.body : undefined })
      if (path.includes('/csrf')) return envelope({ csrf_token: 'test-csrf' })
      if (path.endsWith('/profile')) {
        if (status !== 200) return new Response(JSON.stringify({ data: null, meta: {}, errors: [{ code: 'UNAUTHENTICATED', message: 'Sign in again.' }] }), { status })
        return envelope(profile)
      }
      if (path.endsWith('/security')) return envelope({ totp_enrolled: true, recent_authentication_expires_at: null })
      if (path.endsWith('/reauthentication') && verificationStatus !== 200) return new Response(JSON.stringify({ data: null, meta: {}, errors: [{ code: 'REAUTHENTICATION_FAILED', message: 'The verification details are incorrect.' }] }), { status: verificationStatus, headers: { 'Content-Type': 'application/json' } })
      if (path.includes('/sessions')) return envelope([])
      return envelope({ queued: true })
    }))
  })
  afterEach(() => vi.unstubAllGlobals())

  function open() { render(<AccountWorkspace portal="admin" basePath="https://api.example.test/api/v1" loginPath="/login" renderQr={() => null} />) }

  test('uses the resolved role and hides ungranted administration', async () => {
    open()
    expect(await screen.findByRole('heading', { name: 'Settings' })).toBeVisible()
    expect(screen.getByRole('textbox', { name: 'Full name' })).toHaveValue('Support employee')
    expect(screen.queryByRole('button', { name: 'Admin invitations' })).not.toBeInTheDocument()
    expect(screen.queryByRole('button', { name: 'Admin accounts' })).not.toBeInTheDocument()
    expect(screen.queryByRole('button', { name: 'Staff access' })).not.toBeInTheDocument()
  })

  test('section navigation reuses mounted profile and fetches only section data', async () => {
    open()
    await screen.findByRole('heading', { name: 'Settings' })
    for (let visit = 0; visit < 10; visit++) {
      fireEvent.click(screen.getByRole('button', { name: 'Account' }))
      await screen.findByRole('heading', { name: 'Account' })
      fireEvent.click(screen.getByRole('button', { name: 'Profile' }))
      await screen.findByRole('textbox', { name: 'Full name' })
    }
    expect(requests.filter(request => request.path.endsWith('/profile'))).toHaveLength(1)
    fireEvent.click(screen.getByRole('button', { name: 'Sessions / Devices' }))
    await waitFor(() => expect(requests.filter(request => request.path.includes('/sessions'))).toHaveLength(1))
    expect(requests.filter(request => request.path.endsWith('/profile'))).toHaveLength(1)
    await waitFor(() => expect(screen.getByRole('button', { name: 'Refresh' })).toBeEnabled())
    fireEvent.click(screen.getByRole('button', { name: 'Refresh' }))
    await waitFor(() => expect(requests.filter(request => request.path.endsWith('/profile'))).toHaveLength(2))
  })

  test('expired sessions remove account controls and offer sign-in', async () => {
    status = 401
    open()
    expect(await screen.findByRole('heading', { name: 'Sign-in required' })).toBeVisible()
    expect(screen.queryByRole('textbox', { name: 'Full name' })).not.toBeInTheDocument()
    expect(screen.getByRole('link', { name: 'Return to sign in' })).toHaveAttribute('href', '/login')
  })

  test('email change opens an authenticator dialog and runs only after verification', async () => {
    open()
    await screen.findByRole('heading', { name: 'Settings' })
    fireEvent.click(screen.getByRole('button', { name: 'Security' }))
    const email = await screen.findByRole('textbox', { name: 'New email' })
    fireEvent.change(email, { target: { value: 'new@example.test' } })
    fireEvent.click(screen.getByRole('button', { name: 'Send verification' }))
    const dialog = screen.getByRole('dialog', { name: 'Confirm change primary email' })
    expect(screen.queryByRole('heading', { name: 'Verify your identity' })).not.toBeInTheDocument()
    expect(requests.some(request => request.path.endsWith('/account/email') && request.method === 'POST')).toBe(false)
    const code = screen.getByRole('textbox', { name: 'Authenticator code' })
    expect(code).toBeRequired()
    fireEvent.change(code, { target: { value: '123456' } })
    fireEvent.click(screen.getByRole('button', { name: 'Verify and continue' }))
    await waitFor(() => expect(dialog).not.toBeInTheDocument())
    const reauth = requests.find(request => request.path.endsWith('/reauthentication') && request.method === 'POST')
    expect(JSON.parse(reauth?.body ?? '{}')).toMatchObject({ code: '123456' })
    expect(requests.some(request => request.path.endsWith('/account/email') && request.method === 'POST')).toBe(true)
  })

  test('failed authenticator verification leaves the email change unsent', async () => {
    verificationStatus = 422
    open()
    await screen.findByRole('heading', { name: 'Settings' })
    fireEvent.click(screen.getByRole('button', { name: 'Security' }))
    fireEvent.change(await screen.findByRole('textbox', { name: 'New email' }), { target: { value: 'new@example.test' } })
    fireEvent.click(screen.getByRole('button', { name: 'Send verification' }))
    fireEvent.change(screen.getByRole('textbox', { name: 'Authenticator code' }), { target: { value: '123456' } })
    fireEvent.click(screen.getByRole('button', { name: 'Verify and continue' }))
    expect(await screen.findByText('The verification details are incorrect.')).toBeVisible()
    expect(screen.getByRole('dialog')).toBeInTheDocument()
    expect(requests.some(request => request.path.endsWith('/account/email') && request.method === 'POST')).toBe(false)
  })

  test('password and authenticator replacement each wait for the popup', async () => {
    open()
    await screen.findByRole('heading', { name: 'Settings' })
    fireEvent.click(screen.getByRole('button', { name: 'Security' }))
    fireEvent.change(await screen.findByLabelText(/^New password/), { target: { value: 'AnewPassword12345' } })
    fireEvent.change(screen.getByLabelText(/^Confirm new password/), { target: { value: 'AnewPassword12345' } })
    fireEvent.click(screen.getByRole('button', { name: 'Change password' }))
    expect(screen.getByRole('dialog', { name: 'Confirm change password' })).toBeInTheDocument()
    expect(requests.some(request => request.path.endsWith('/account/password') && request.method === 'POST')).toBe(false)
    fireEvent.click(screen.getByRole('button', { name: 'Cancel' }))
    expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
    fireEvent.click(screen.getByRole('button', { name: 'Replace authenticator' }))
    expect(screen.getByRole('dialog', { name: 'Confirm replace authenticator' })).toBeInTheDocument()
    expect(requests.some(request => request.path.endsWith('/account/factor') && request.method === 'POST')).toBe(false)
  })

  test('canceling revoke-all sends no session mutation', async () => {
    vi.spyOn(window, 'confirm').mockReturnValueOnce(false)
    open()
    await screen.findByRole('heading', { name: 'Settings' })
    const revoke = screen.getByRole('button', { name: 'Sign out all devices' })
    await waitFor(() => expect(revoke).toBeEnabled())
    fireEvent.click(revoke)
    expect(requests.some(request => request.path.endsWith('/sessions/revoke'))).toBe(false)
  })
})
