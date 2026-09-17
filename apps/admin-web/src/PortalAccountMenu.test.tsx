import { fireEvent, render, screen } from '@testing-library/react'
import { expect, it, vi } from 'vitest'
import { PortalAccountMenu } from '../../../packages/web-ui/src/portal-account-menu'

vi.mock('@materyalph/api-client-ts', () => ({
  AccountsApi: class { getAccountProfile() { return Promise.resolve({ data: { fullName: 'Test Owner', role: 'OWNER' } }) } },
  AuthenticationApi: class {}, Configuration: class {},
}))

it.each(['admin', 'vendors'] as const)('shows personal initials and safe quick links for %s', async portal => {
  const logout = vi.fn().mockResolvedValue(undefined)
  render(<PortalAccountMenu portal={portal} basePath="http://localhost/api/v1" onSignOut={logout} />)
  expect(await screen.findByText('TO')).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Account profile options' }))
  expect(screen.getByRole('link', { name: 'Personal profile' })).toHaveAttribute('href', `${portal === 'admin' ? '/workspace' : '/account'}#Profile`)
  expect(logout).not.toHaveBeenCalled()
  fireEvent.keyDown(screen.getByRole('button', { name: 'Account profile options' }), { key: 'Escape' })
  expect(screen.queryByRole('link', { name: 'Personal profile' })).not.toBeInTheDocument()
})
