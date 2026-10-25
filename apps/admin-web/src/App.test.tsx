import { act, fireEvent, render, screen, waitFor } from '@testing-library/react'
import { ResponseError } from '@materyalph/api-client-ts'
import { afterEach, beforeEach, describe, expect, test, vi } from 'vitest'

import App from './App'

const { getSessionMock, signInMock, acceptInviteMock, verifyRiskMock } = vi.hoisted(() => ({ getSessionMock: vi.fn(), signInMock: vi.fn(), acceptInviteMock: vi.fn(), verifyRiskMock: vi.fn() }))
vi.mock('./lib/auth-api', async (importOriginal) => ({
  ...await importOriginal<typeof import('./lib/auth-api')>(),
  getSession: getSessionMock,
  signInAdmin: signInMock,
  acceptAdminInvitation: acceptInviteMock,
  verifyRiskChallenge: verifyRiskMock,
}))
vi.mock('./pages/AuthSupportPages', async importOriginal => ({
  ...await importOriginal<typeof import('./pages/AuthSupportPages')>(),
  AdminMfaPage: () => <h1>Verify Admin MFA</h1>,
}))

vi.mock('./pages/AdminDashboardPage', () => ({
  AdminDashboardPage: () => <h1>Dashboard</h1>,
  AdminAuditPage: () => <h1>Audit</h1>,
}))

beforeEach(() => {
  window.history.replaceState({}, '', '/login')
  getSessionMock.mockReset()
  signInMock.mockReset()
  acceptInviteMock.mockReset()
  verifyRiskMock.mockReset()
  getSessionMock.mockRejectedValue(new ResponseError(new Response(null, { status: 401 })))
})

describe('Admin authentication portal', () => {


  test('keeps Admin access invitation-only', async () => {
    render(<App />)

    await screen.findByRole('button', { name: /sign in securely/i })
    expect(screen.getByRole('heading', { name: 'Welcome back' })).toBeVisible()
    expect(screen.getByText(/invitation-only/i)).toBeVisible()
    expect(screen.queryByRole('link', { name: /register/i })).not.toBeInTheDocument()
    expect(screen.getByRole('button', { name: /sign in securely/i })).toBeEnabled()
  })

  test('password visibility is accessible without submitting the form', async () => {
    render(<App />)
    await screen.findByRole('button', { name: /sign in securely/i })
    const field = screen.getByLabelText(/^Password/i, { selector: 'input' })
    fireEvent.change(field, { target: { value: 'ExamplePassword123' } })
    fireEvent.click(screen.getByRole('button', { name: 'Show password' }))
    expect(field).toHaveAttribute('type', 'text')
    expect(field).toHaveValue('ExamplePassword123')
    expect(screen.getByRole('button', { name: 'Hide password' })).toHaveAttribute('aria-pressed', 'true')
  })

  test('connects password recovery to a real route', async () => {
    render(<App />)
    await screen.findByRole('button', { name: /sign in securely/i })
    fireEvent.change(screen.getByRole('textbox', { name: /email address/i }), { target: { value: 'admin@example.test' } })
    fireEvent.click(screen.getByRole('link', { name: 'Forgot password?' }))

    expect(screen.getByRole('heading', { name: /recover admin access/i })).toBeVisible()
    expect(screen.queryByRole('textbox')).not.toBeInTheDocument()
    expect(screen.getByRole('button', { name: 'Send authentication code' })).toBeVisible()
    expect(screen.getByRole('button', { name: 'Use recovery codes' })).toBeVisible()
    expect(screen.getByText('a••••@example.test')).toBeVisible()
  })

  test.each(['/', '/login'])('returns an active Admin session from %s to the dashboard', async path => {
    window.history.replaceState({}, '', path)
    getSessionMock.mockResolvedValue({ data: { user: { accountType: 'ADMIN' } } })
    render(<App />)

    expect(screen.queryByRole('button', { name: /sign in securely/i })).not.toBeInTheDocument()
    await screen.findByRole('heading', { name: 'Dashboard' })
    expect(window.location.pathname).toBe('/dashboard')
  })

  test('keeps the sign-in form hidden until an unauthenticated response arrives', async () => {
    let rejectSession!: (error: unknown) => void
    getSessionMock.mockReturnValue(new Promise((_, reject) => { rejectSession = reject }))
    render(<App />)

    expect(screen.getByText('Checking your Admin session…')).toBeVisible()
    expect(screen.queryByRole('button', { name: /sign in securely/i })).not.toBeInTheDocument()
    rejectSession(new ResponseError(new Response(null, { status: 401 })))
    await screen.findByRole('button', { name: /sign in securely/i })
  })

  test('does not route another account type into the Admin dashboard', async () => {
    getSessionMock.mockResolvedValue({ data: { user: { accountType: 'VENDOR' } } })
    render(<App />)

    expect(await screen.findByRole('button', { name: 'Retry session check' })).toBeVisible()
    expect(window.location.pathname).toBe('/login')
  })

  test('offers a retry when the session service is unavailable', async () => {
    getSessionMock.mockRejectedValueOnce(new Error('Network unavailable'))
    render(<App />)

    fireEvent.click(await screen.findByRole('button', { name: 'Retry session check' }))
    await waitFor(() => expect(getSessionMock).toHaveBeenCalledTimes(2))
    await screen.findByRole('button', { name: /sign in securely/i })
  })
})


afterEach(() => {
  delete window.grecaptcha
  vi.unstubAllEnvs()
})

function prepareCheckbox() {
  vi.stubEnv('VITE_RECAPTCHA_SITE_KEY', 'test-admin-site')
  const renderWidget = vi.fn((_host: HTMLElement, _parameters: Record<string, unknown>) => 9)
  const reset = vi.fn()
  window.grecaptcha = { enterprise: { ready: callback => callback(), render: renderWidget, reset } }
  return { renderWidget, reset }
}

function fillLogin() {
  fireEvent.change(screen.getByRole('textbox', { name: /email address/i }), { target: { value: 'admin@example.test' } })
  fireEvent.change(screen.getByLabelText(/^Password/i, { selector: 'input' }), { target: { value: 'TestPassword123' } })
}

test('Admin login requires checkbox evidence, submits its action token, and continues to MFA', async () => {
  const { renderWidget, reset } = prepareCheckbox()
  signInMock.mockResolvedValue({ data: { mfaRequired: true } })
  render(<App />)
  await screen.findByRole('button', { name: /sign in securely/i })
  fillLogin()
  fireEvent.click(screen.getByRole('button', { name: /sign in securely/i }))
  expect(await screen.findByText('Complete the security checkbox before continuing.')).toBeVisible()
  expect(signInMock).not.toHaveBeenCalled()
  await waitFor(() => expect(renderWidget).toHaveBeenCalledOnce())
  const parameters = renderWidget.mock.calls[0]?.[1] as Record<string, unknown>
  expect(parameters).toMatchObject({ sitekey: 'test-admin-site', action: 'admin_login' })
  act(() => (parameters.callback as (token: string) => void)('test-checkbox'))
  fireEvent.click(screen.getByRole('button', { name: /sign in securely/i }))
  await screen.findByRole('heading', { name: 'Verify Admin MFA' })
  expect(signInMock).toHaveBeenCalledWith('admin@example.test', 'TestPassword123', { recaptchaToken: 'test-checkbox' })
  expect(reset).toHaveBeenCalledWith(9)
})

test('Admin email security check retries with cookie proof and retains the MFA requirement', async () => {
  prepareCheckbox()
  signInMock.mockRejectedValueOnce(new ResponseError(new Response(JSON.stringify({ errors: [{ code: 'BOT_STEP_UP_REQUIRED', details: { challenge_id: 'test-challenge', expires_at: '2026-10-14T10:00:00Z', resend_after_seconds: 60 } }] }), { status: 403, headers: { 'Content-Type': 'application/json' } })))
    .mockResolvedValueOnce({ data: { mfaRequired: true } })
  verifyRiskMock.mockResolvedValue({ data: { verified: true } })
  render(<App />)
  await screen.findByRole('button', { name: /sign in securely/i })
  fillLogin()
  fireEvent.click(screen.getByRole('button', { name: 'Use an email security check instead' }))
  const code = await screen.findByLabelText(/Risk-verification code/)
  fireEvent.change(code, { target: { value: '123456' } })
  fireEvent.click(screen.getByRole('button', { name: 'Verify and continue' }))
  await screen.findByRole('heading', { name: 'Verify Admin MFA' })
  expect(verifyRiskMock).toHaveBeenCalledWith('test-challenge', 'admin@example.test', '123456')
  expect(signInMock.mock.calls).toEqual([
    ['admin@example.test', 'TestPassword123', { requestEmailStepUp: true }],
    ['admin@example.test', 'TestPassword123', {}],
  ])
})

test('Admin invitation shows the 14-character password requirements and updates them as the invitee types', () => {
  window.history.replaceState({}, '', '/accept-invite?token=test-invite')
  prepareCheckbox()
  render(<App />)
  const requirements = screen.getByRole('list', { name: 'Requirements for this password' })
  const items = () => Array.from(requirements.querySelectorAll('li')).map(item => item.textContent)
  expect(items()[0]).toBe('Must be a minimum of 14 characters in length (not met)')
  fireEvent.change(screen.getByLabelText(/^Password/i, { selector: 'input' }), { target: { value: 'Abcdefghijklm1' } })
  expect(items().every(item => item?.endsWith('(met)'))).toBe(true)
})

test('Admin invitation registration sends the invited email and action-bound checkbox evidence', async () => {
  window.history.replaceState({}, '', '/accept-invite?token=test-invite')
  const { renderWidget } = prepareCheckbox()
  acceptInviteMock.mockResolvedValue({ data: { next: 'SIGN_IN_AND_ENROLL_MFA' } })
  render(<App />)
  fireEvent.change(screen.getByLabelText(/Invited email address/), { target: { value: 'admin@example.test' } })
  fireEvent.change(screen.getByLabelText(/Full name/), { target: { value: 'Test Admin' } })
  fireEvent.change(screen.getByLabelText(/^Password/i, { selector: 'input' }), { target: { value: 'TestPassword123' } })
  fireEvent.change(screen.getByLabelText(/Confirm password/i, { selector: 'input' }), { target: { value: 'TestPassword123' } })
  screen.getAllByRole('checkbox').forEach(checkbox => fireEvent.click(checkbox))
  await waitFor(() => expect(renderWidget).toHaveBeenCalledOnce())
  const parameters = renderWidget.mock.calls[0]?.[1] as Record<string, unknown>
  expect(parameters.action).toBe('admin_invitation_accept')
  act(() => (parameters.callback as (token: string) => void)('test-checkbox'))
  fireEvent.click(screen.getByRole('button', { name: 'Create Admin account' }))
  await screen.findByRole('link', { name: 'Continue to sign in' })
  expect(acceptInviteMock).toHaveBeenCalledWith({ token: 'test-invite', email: 'admin@example.test', fullName: 'Test Admin', password: 'TestPassword123', passwordConfirmation: 'TestPassword123' }, { recaptchaToken: 'test-checkbox' })
  expect(window.location.search).toBe('')
})
