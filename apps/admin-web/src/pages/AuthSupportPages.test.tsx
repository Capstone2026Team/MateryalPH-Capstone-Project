import { act, fireEvent, render, screen } from '@testing-library/react'
import { ResponseError } from '@materyalph/api-client-ts'
import { MemoryRouter } from 'react-router-dom'
import { afterEach, beforeEach, expect, it, vi } from 'vitest'
import { AdminForgotPasswordPage, AdminMfaPage, AdminResetPasswordPage } from './AuthSupportPages'
import { completePasswordRecovery, readableApiError, requestPasswordRecovery, verifyPasswordRecovery } from '../lib/auth-api'

vi.mock('../lib/auth-api', () => ({
  getMfaStatus: vi.fn().mockResolvedValue({ data: { mfaEnrollmentRequired: true } }),
  startMfaEnrollment: vi.fn().mockResolvedValue({ data: { secret: 'TEST-ONLY', provisioningUri: 'otpauth://totp/Test?secret=TESTONLY' } }),
  confirmMfaEnrollment: vi.fn().mockResolvedValue({ data: { recoveryCodes: ['TEST-RECOVERY-CODE'] } }),
  completeMfaChallenge: vi.fn(), recoverMfaChallenge: vi.fn(), requestPasswordRecovery: vi.fn(), completePasswordRecovery: vi.fn(), verifyPasswordRecovery: vi.fn(), resendRiskChallenge: vi.fn(), readableApiError: vi.fn(),
}))

beforeEach(() => {
  vi.clearAllMocks()
  vi.mocked(readableApiError).mockImplementation(async error => error instanceof Error ? error.message : 'Request failed')
  vi.mocked(requestPasswordRecovery).mockResolvedValue({ data: { message: 'Code requested', resendAfterSeconds: 60, expiresIn: 600 }, meta: {}, errors: [] })
  vi.mocked(verifyPasswordRecovery).mockResolvedValue({ data: { verified: true, expiresIn: 600, recoveryCodes: null }, meta: {}, errors: [] })
  vi.mocked(completePasswordRecovery).mockResolvedValue({ data: { password_reset: true }, meta: {}, errors: [] })
})

afterEach(() => { delete window.grecaptcha; vi.unstubAllEnvs() })

function recoveryPage(email = 'admin@example.test') {
  render(<MemoryRouter initialEntries={[{ pathname: '/forgot-password', state: { email } }]}><AdminForgotPasswordPage /></MemoryRouter>)
}

it('uses the sign-in email and places one email action and backup recovery above the checkbox', () => {
  recoveryPage()
  expect(screen.queryByRole('textbox')).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Use an email security check instead' })).not.toBeInTheDocument()
  const backup = screen.getByRole('button', { name: 'Use recovery codes' })
  expect(screen.getByRole('button', { name: 'Send authentication code' })).toBeVisible()
  expect(backup.compareDocumentPosition(document.querySelector('.recaptcha-checkbox') as Node) & Node.DOCUMENT_POSITION_FOLLOWING).toBeTruthy()
  expect(screen.queryByLabelText(/New password/)).not.toBeInTheDocument()
})

it('asks for an email only after choosing a method when the sign-in email is missing', () => {
  recoveryPage('')
  expect(screen.queryByRole('textbox')).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Use recovery codes' }))
  fireEvent.change(screen.getByLabelText(/Account email/), { target: { value: 'admin@example.test' } })
  fireEvent.click(screen.getByRole('button', { name: 'Continue' }))
  expect(screen.getByLabelText(/Recovery code/)).toBeRequired()
  expect(requestPasswordRecovery).not.toHaveBeenCalled()
})

it('verifies the email security code once before revealing new-password fields', async () => {
  vi.mocked(requestPasswordRecovery).mockRejectedValueOnce(new ResponseError(new Response(JSON.stringify({ errors: [{ code: 'BOT_STEP_UP_REQUIRED', details: { challenge_id: 'recovery-challenge', expires_at: '2099-10-26T12:00:00Z', resend_after_seconds: 60 } }] }), { status: 403 })))
  vi.mocked(verifyPasswordRecovery).mockRejectedValueOnce(new Error('The code is invalid or expired.'))
  recoveryPage()
  fireEvent.click(screen.getByRole('button', { name: 'Send authentication code' }))
  const code = await screen.findByLabelText(/Authentication code/)
  expect(requestPasswordRecovery).toHaveBeenCalledWith('admin@example.test', { requestEmailStepUp: true })
  fireEvent.change(code, { target: { value: '000000' } })
  fireEvent.click(screen.getByRole('button', { name: 'Verify and continue' }))
  expect(await screen.findByRole('alert')).toHaveTextContent('The code is invalid or expired.')
  expect(screen.queryByLabelText(/^New password/)).not.toBeInTheDocument()
  fireEvent.change(code, { target: { value: '123456' } })
  fireEvent.click(screen.getByRole('button', { name: 'Verify and continue' }))
  await screen.findByLabelText(/^New password/)
  expect(verifyPasswordRecovery).toHaveBeenLastCalledWith({ email: 'admin@example.test', code: '123456', challengeId: 'recovery-challenge' })
  expect(requestPasswordRecovery).toHaveBeenCalledOnce()
  fireEvent.change(screen.getByLabelText(/^New password/), { target: { value: 'NewPassword12345' } })
  fireEvent.change(screen.getByLabelText(/^Confirm new password/), { target: { value: 'Different12345' } })
  fireEvent.click(screen.getByRole('button', { name: 'Update password' }))
  expect(screen.getByRole('alert')).toHaveTextContent('The passwords do not match.')
  expect(completePasswordRecovery).not.toHaveBeenCalled()
  fireEvent.change(screen.getByLabelText(/^Confirm new password/), { target: { value: 'NewPassword12345' } })
  fireEvent.click(screen.getByRole('button', { name: 'Update password' }))
  await act(async () => {})
  expect(completePasswordRecovery).toHaveBeenCalledWith('admin@example.test', 'NewPassword12345', 'NewPassword12345')
})

it('uses checkbox evidence for the email code and keeps resend on the server cooldown', async () => {
  vi.stubEnv('VITE_RECAPTCHA_SITE_KEY', 'test-admin-site')
  const renderWidget = vi.fn((_host: HTMLElement, parameters: Record<string, unknown>) => { (parameters.callback as (token: string) => void)('test-checkbox'); return 1 })
  window.grecaptcha = { enterprise: { ready: callback => callback(), render: renderWidget, reset: vi.fn() } }
  recoveryPage()
  await act(async () => {})
  fireEvent.click(screen.getByRole('button', { name: 'Send authentication code' }))
  await screen.findByLabelText(/Authentication code/)
  expect(requestPasswordRecovery).toHaveBeenCalledWith('admin@example.test', { recaptchaToken: 'test-checkbox' })
  expect(screen.getByRole('button', { name: /Request another code in \d+s/ })).toBeDisabled()
})

it('verifies saved backup codes and offers the replacement set after password reset', async () => {
  vi.mocked(verifyPasswordRecovery).mockResolvedValueOnce({ data: { verified: true, expiresIn: 600, recoveryCodes: ['TEST-ONLY-CODE'] }, meta: {}, errors: [] })
  recoveryPage()
  fireEvent.click(screen.getByRole('button', { name: 'Use recovery codes' }))
  fireEvent.change(screen.getByLabelText(/Recovery code/), { target: { value: 'BACK-UPCO-DES2' } })
  fireEvent.click(screen.getByRole('button', { name: 'Verify and continue' }))
  await screen.findByLabelText(/^New password/)
  expect(verifyPasswordRecovery).toHaveBeenCalledWith({ email: 'admin@example.test', recoveryCode: 'BACK-UPCO-DES2' })
  expect(requestPasswordRecovery).not.toHaveBeenCalled()
  fireEvent.change(screen.getByLabelText(/^New password/), { target: { value: 'NewPassword12345' } })
  fireEvent.change(screen.getByLabelText(/^Confirm new password/), { target: { value: 'NewPassword12345' } })
  fireEvent.click(screen.getByRole('button', { name: 'Update password' }))
  expect(await screen.findByRole('button', { name: 'Download recovery codes (.txt)' })).toBeVisible()
  expect(screen.getByText('TEST-ONLY-CODE')).toBeVisible()
})

it('keeps the legacy reset link behind code verification', () => {
  render(<MemoryRouter initialEntries={['/reset-password?email=admin@example.test']}><AdminResetPasswordPage /></MemoryRouter>)
  expect(screen.getByLabelText(/Authentication code/)).toBeRequired()
  expect(screen.queryByLabelText(/^New password/)).not.toBeInTheDocument()
})

it('renders a local enrollment QR and downloads the issued recovery set', async () => {
  const create = vi.fn().mockReturnValue('blob:test-only')
  const revoke = vi.fn()
  Object.defineProperty(URL, 'createObjectURL', { configurable: true, value: create })
  Object.defineProperty(URL, 'revokeObjectURL', { configurable: true, value: revoke })
  const click = vi.spyOn(HTMLAnchorElement.prototype, 'click').mockImplementation(() => {})
  render(<MemoryRouter><AdminMfaPage /></MemoryRouter>)
  expect(await screen.findByRole('img', { name: 'Authenticator setup QR code' })).toBeTruthy()
  fireEvent.change(screen.getByLabelText(/Six-digit authenticator code/), { target: { value: '123456' } })
  fireEvent.click(screen.getByRole('button', { name: 'Enroll and continue' }))
  fireEvent.click(await screen.findByRole('button', { name: 'Download recovery codes (.txt)' }))
  expect(create).toHaveBeenCalledOnce()
  expect(click).toHaveBeenCalledOnce()
  expect(revoke).toHaveBeenCalledWith('blob:test-only')
  click.mockRestore()
})
