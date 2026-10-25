import { ResponseError } from '@materyalph/api-client-ts'
import { act, fireEvent, render, screen, waitFor } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { afterEach, beforeEach, expect, test, vi } from 'vitest'
import * as auth from '../lib/auth-api'
import { VendorForgotPasswordPage, VendorResetPasswordPage } from './AuthSupportPages'
import { resetEnterpriseLoaderForTests } from '../lib/recaptcha-enterprise'

vi.mock('../lib/auth-api', async original => ({
  ...await original<typeof import('../lib/auth-api')>(),
  requestPasswordRecovery: vi.fn(), verifyPasswordRecovery: vi.fn(), completePasswordRecovery: vi.fn(),
  resendRiskChallenge: vi.fn(), readableApiError: vi.fn(),
}))

beforeEach(() => {
  vi.clearAllMocks()
  vi.mocked(auth.requestPasswordRecovery).mockResolvedValue({ data: { message: 'Code requested', resendAfterSeconds: 60, expiresIn: 600 }, meta: {}, errors: [] })
  vi.mocked(auth.verifyPasswordRecovery).mockResolvedValue({ data: { verified: true, expiresIn: 600, recoveryCodes: null }, meta: {}, errors: [] })
  vi.mocked(auth.completePasswordRecovery).mockResolvedValue({ data: { password_reset: true }, meta: {}, errors: [] })
  vi.mocked(auth.readableApiError).mockImplementation(async error => error instanceof Error ? error.message : 'Request failed')
})

afterEach(() => { delete window.grecaptcha; resetEnterpriseLoaderForTests(); vi.unstubAllEnvs() })

function page(email = 'owner@example.test') {
  render(<MemoryRouter initialEntries={[{ pathname: '/forgot-password', state: { email } }]}><Routes><Route path="/forgot-password" element={<VendorForgotPasswordPage />} /><Route path="/login" element={<h1>Sign in reached</h1>} /></Routes></MemoryRouter>)
}

test('Vendor recovery shares both method choices and places reCAPTCHA below without an email field', () => {
  page()
  expect(screen.getByText('o••••@example.test')).toBeVisible()
  expect(screen.queryByRole('textbox')).not.toBeInTheDocument()
  expect(screen.getByRole('button', { name: 'Send authentication code' })).toBeVisible()
  const backup = screen.getByRole('button', { name: 'Use recovery codes' })
  expect(backup.compareDocumentPosition(document.querySelector('.recaptcha-checkbox') as Node) & Node.DOCUMENT_POSITION_FOLLOWING).toBeTruthy()
  expect(screen.queryByRole('button', { name: 'Use an email security check instead' })).not.toBeInTheDocument()
})

test('Vendor recovery asks for the account email only if it was not entered on sign-in', () => {
  page('')
  expect(screen.queryByRole('textbox')).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Use recovery codes' }))
  fireEvent.change(screen.getByLabelText(/Account email/), { target: { value: 'owner@example.test' } })
  fireEvent.click(screen.getByRole('button', { name: 'Continue' }))
  expect(screen.getByLabelText(/Recovery code/)).toBeRequired()
})

test('Vendor recovery sends the checkbox token with the Vendor recovery action', async () => {
  vi.stubEnv('VITE_RECAPTCHA_SITE_KEY', 'test-vendor-site')
  const renderWidget = vi.fn((_host: HTMLElement, _parameters: Record<string, unknown>) => 1)
  window.grecaptcha = { enterprise: { ready: callback => callback(), render: renderWidget, reset: vi.fn() } }
  page()
  await waitFor(() => expect(renderWidget).toHaveBeenCalledOnce())
  const parameters = renderWidget.mock.calls[0]?.[1] as Record<string, unknown>
  expect(parameters.action).toBe('vendor_password_recovery')
  act(() => (parameters.callback as (token: string) => void)('test-vendor-checkbox'))
  fireEvent.click(screen.getByRole('button', { name: 'Send authentication code' }))
  await screen.findByLabelText(/Authentication code/)
  expect(auth.requestPasswordRecovery).toHaveBeenCalledWith('owner@example.test', { recaptchaToken: 'test-vendor-checkbox' })
})

test('Vendor email fallback verifies once before showing the existing 12-character password form', async () => {
  vi.mocked(auth.requestPasswordRecovery).mockRejectedValueOnce(new ResponseError(new Response(JSON.stringify({ errors: [{ code: 'BOT_STEP_UP_REQUIRED', details: { challenge_id: 'vendor-recovery', expires_at: '2099-10-26T12:00:00Z', resend_after_seconds: 60 } }] }), { status: 403 })))
  vi.mocked(auth.verifyPasswordRecovery).mockRejectedValueOnce(new Error('Invalid code'))
  page()
  fireEvent.click(screen.getByRole('button', { name: 'Send authentication code' }))
  const code = await screen.findByLabelText(/Authentication code/)
  fireEvent.change(code, { target: { value: '000000' } })
  fireEvent.click(screen.getByRole('button', { name: 'Verify and continue' }))
  expect(await screen.findByRole('alert')).toHaveTextContent('Invalid code')
  expect(screen.queryByLabelText(/^New password/)).not.toBeInTheDocument()
  fireEvent.paste(code, { clipboardData: { getData: () => '123 456' } })
  fireEvent.click(screen.getByRole('button', { name: 'Verify and continue' }))
  const password = await screen.findByLabelText(/^New password/)
  expect(password).toHaveAttribute('minlength', '12')
  expect(auth.verifyPasswordRecovery).toHaveBeenLastCalledWith({ email: 'owner@example.test', code: '123456', challengeId: 'vendor-recovery' })
  expect(auth.requestPasswordRecovery).toHaveBeenCalledOnce()
  fireEvent.change(password, { target: { value: 'VendorPass12' } })
  fireEvent.change(screen.getByLabelText(/^Confirm new password/), { target: { value: 'VendorPass12' } })
  fireEvent.click(screen.getByRole('button', { name: 'Update password' }))
  expect(await screen.findByRole('heading', { name: 'Sign in reached' })).toBeVisible()
  expect(auth.completePasswordRecovery).toHaveBeenCalledWith('owner@example.test', 'VendorPass12', 'VendorPass12')
})

test('Vendor saved recovery codes reveal passwords only after verification and show replacements after reset', async () => {
  vi.mocked(auth.verifyPasswordRecovery).mockResolvedValueOnce({ data: { verified: true, expiresIn: 600, recoveryCodes: ['TEST-ONLY-CODE'] }, meta: {}, errors: [] })
  page()
  fireEvent.click(screen.getByRole('button', { name: 'Use recovery codes' }))
  expect(screen.queryByLabelText(/^New password/)).not.toBeInTheDocument()
  fireEvent.change(screen.getByLabelText(/Recovery code/), { target: { value: 'BACK-UPCO-DES2' } })
  fireEvent.click(screen.getByRole('button', { name: 'Verify and continue' }))
  fireEvent.change(await screen.findByLabelText(/^New password/), { target: { value: 'VendorPass12' } })
  fireEvent.change(screen.getByLabelText(/^Confirm new password/), { target: { value: 'VendorPass12' } })
  fireEvent.click(screen.getByRole('button', { name: 'Update password' }))
  expect(await screen.findByText('TEST-ONLY-CODE')).toBeVisible()
  expect(screen.getByRole('button', { name: 'Download recovery codes (.txt)' })).toBeVisible()
  expect(auth.requestPasswordRecovery).not.toHaveBeenCalled()
})

test('Vendor legacy reset links begin with code verification', () => {
  render(<MemoryRouter initialEntries={['/reset-password?email=owner@example.test']}><VendorResetPasswordPage /></MemoryRouter>)
  expect(screen.getByLabelText(/Authentication code/)).toBeRequired()
  expect(screen.queryByLabelText(/^New password/)).not.toBeInTheDocument()
})
