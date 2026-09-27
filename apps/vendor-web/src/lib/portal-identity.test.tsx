import { StrictMode, useState } from 'react'
import { fireEvent, render, screen, waitFor } from '@testing-library/react'
import { afterEach, expect, test, vi } from 'vitest'
import { PortalIdentityProvider, PortalAccountMenu, clearWebSessionTransport } from '@materyalph/web-ui'

afterEach(() => { clearWebSessionTransport(); vi.unstubAllGlobals() })

test('routed menu remounts reuse display identity, updates refresh it, and a new portal mount reloads it', async () => {
  let fullName = 'First Owner'
  const fetchMock = vi.fn(async () => new Response(JSON.stringify({ data: {
    id: 'fixture', full_name: fullName, role: 'OWNER', organization_name: 'Fixture Store',
    account_type: 'VENDOR', account_status: 'ACTIVE', email: 'owner@example.test', lock_version: 1,
    created_at: '2026-09-01T00:00:00Z', permissions: [],
  }, meta: {}, errors: [] }), { headers: { 'Content-Type': 'application/json' } }))
  vi.stubGlobal('fetch', fetchMock)
  function RoutesProbe() {
    const [page, setPage] = useState(0)
    return <><button onClick={() => setPage(value => value + 1)}>Navigate</button><PortalAccountMenu key={page} portal="vendors" basePath="https://api.example.test/api/v1" /></>
  }
  const tree = <StrictMode><PortalIdentityProvider portal="vendors" basePath="https://api.example.test/api/v1"><RoutesProbe /></PortalIdentityProvider></StrictMode>
  const view = render(tree)
  await screen.findByText('First Owner')
  for (let visit = 0; visit < 20; visit++) fireEvent.click(screen.getByRole('button', { name: 'Navigate' }))
  expect(fetchMock).toHaveBeenCalledTimes(1)
  fullName = 'Updated Owner'
  window.dispatchEvent(new Event('materyalph:profile-updated'))
  await screen.findByText('Updated Owner')
  expect(fetchMock).toHaveBeenCalledTimes(2)
  view.unmount()
  render(tree)
  await waitFor(() => expect(fetchMock).toHaveBeenCalledTimes(3))
  await screen.findByText('Updated Owner')
})
