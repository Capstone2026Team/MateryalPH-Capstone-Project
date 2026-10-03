import { fireEvent, render, screen, within } from '@testing-library/react'
import { expect, it, vi } from 'vitest'
import { PortalShell } from '../../../packages/web-ui/src/portal-shell'
import { Home, Users } from 'lucide-react'

vi.mock('@materyalph/api-client-ts', () => ({
  AccountsApi: class { getAccountProfile() { return Promise.resolve({ data: { fullName: 'Authenticated Admin', role: 'ADMIN_SUPPORT', organizationName: 'Registered Supply' } }) } },
  AuthenticationApi: class {}, Configuration: class {},
}))

it('keeps direct routes, disabled items and active names accessible when collapsed', async () => {
  vi.stubGlobal('matchMedia', vi.fn(() => ({ matches: true, addEventListener: vi.fn(), removeEventListener: vi.fn() })))
  const navigate = vi.fn()
  render(<PortalShell portalLabel="ADMIN PORTAL" pageTitle="Dashboard" accountLabel="Loading account" apiBasePath="http://localhost/api/v1" activeHref="/dashboard" onNavigate={navigate} sections={[
    { label: 'Overview', items: [{ label: 'Dashboard', href: '/dashboard', icon: <Home /> }, { label: 'Restricted team', href: '/restricted', disabled: true, icon: <Users /> }] },
    { label: 'Other', items: [{ label: 'Audit Log', href: '/audit', icon: <Users /> }] },
  ]}><h1>Dashboard content</h1></PortalShell>)
  const sidebar = screen.getByLabelText('ADMIN PORTAL navigation')
  expect(await within(sidebar).findByText('Authenticated Admin')).toBeVisible()
  expect(within(sidebar).getByText('ADMIN SUPPORT')).toBeVisible()
  expect(sidebar.querySelectorAll('details, summary')).toHaveLength(0)
  fireEvent.click(screen.getByRole('button', { name: 'Collapse sidebar' }))
  expect(screen.getByRole('button', { name: 'Expand sidebar' })).toHaveAttribute('aria-expanded', 'false')
  expect(sidebar.closest('.portal-layout')).toHaveClass('is-collapsed')
  expect(within(sidebar).getByRole('link', { name: 'Dashboard' })).toHaveAttribute('aria-current', 'page')
  const audit = within(sidebar).getByRole('link', { name: 'Audit Log' })
  fireEvent.focus(audit)
  expect(screen.queryByRole('tooltip')).not.toBeInTheDocument()
  fireEvent.mouseEnter(audit)
  expect(screen.getByRole('tooltip')).toHaveTextContent('Audit Log')
  fireEvent.keyDown(audit, { key: 'Escape' })
  expect(screen.queryByRole('tooltip')).not.toBeInTheDocument()
  fireEvent.click(audit)
  expect(navigate).toHaveBeenCalledWith('/audit')
  const disabled = within(sidebar).getByRole('link', { name: 'Restricted team, unavailable' })
  expect(disabled).toHaveAttribute('aria-disabled', 'true')
  expect(disabled).not.toHaveAttribute('href')
  fireEvent.click(disabled)
  expect(navigate).toHaveBeenCalledTimes(1)
  fireEvent.click(screen.getByRole('button', { name: 'Expand sidebar' }))
  expect(sidebar.closest('.portal-layout')).not.toHaveClass('is-collapsed')
})
