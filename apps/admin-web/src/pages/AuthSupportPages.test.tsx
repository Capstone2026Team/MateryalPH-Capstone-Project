import { fireEvent, render, screen } from '@testing-library/react'
import { MemoryRouter } from 'react-router-dom'
import { expect, it, vi } from 'vitest'
import { AdminMfaPage } from './AuthSupportPages'

vi.mock('../lib/auth-api', () => ({
  getMfaStatus: vi.fn().mockResolvedValue({ data: { mfaEnrollmentRequired: true } }),
  startMfaEnrollment: vi.fn().mockResolvedValue({ data: { secret: 'TEST-ONLY', provisioningUri: 'otpauth://totp/Test?secret=TESTONLY' } }),
  confirmMfaEnrollment: vi.fn().mockResolvedValue({ data: { recoveryCodes: ['TEST-RECOVERY-CODE'] } }),
  completeMfaChallenge: vi.fn(), recoverMfaChallenge: vi.fn(), requestPasswordRecovery: vi.fn(), resetPassword: vi.fn(), readableApiError: vi.fn(),
}))

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
