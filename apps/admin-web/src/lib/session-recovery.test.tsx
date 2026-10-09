import { act, render, screen } from '@testing-library/react'
import { afterEach, expect, test, vi } from 'vitest'
import { PortalIdentityProvider, clearWebSessionTransport } from '@materyalph/web-ui'
import { signOutWebSession } from '../../../../packages/web-ui/src/web-api-session'

const base = 'https://api.example.test/api/v1'
const json = (status: number, data = {}) => new Response(JSON.stringify({ data, meta: {}, errors: [] }), { status, headers: { 'Content-Type': 'application/json' } })
afterEach(() => { clearWebSessionTransport(); vi.unstubAllGlobals() })

test('logout refreshes expired access before revoking the session', async () => {
  let attempts = 0
  const fetchMock = vi.fn(async (input: RequestInfo | URL) => {
    const url = String(input)
    if (url.endsWith('/csrf')) return json(200, { csrf_token: 'fixture-csrf-token' })
    if (url.endsWith('/refresh')) return json(200)
    return json(++attempts === 1 ? 401 : 200)
  })
  vi.stubGlobal('fetch', fetchMock)
  await signOutWebSession(base)
  expect(fetchMock.mock.calls.map(([url]) => String(url).replace(base, ''))).toEqual(['/auth/csrf', '/auth/logout', '/auth/refresh', '/auth/logout'])
})

test('an already expired refresh session allows sign-out recovery', async () => {
  vi.stubGlobal('fetch', vi.fn(async (input: RequestInfo | URL) => String(input).endsWith('/csrf') ? json(200, { csrf_token: 'fixture-csrf-token' }) : json(401)))
  await expect(signOutWebSession(base)).resolves.toBeUndefined()
})

test.each([403, 419, 429, 500])('logout does not hide HTTP %s failures', async status => {
  vi.stubGlobal('fetch', vi.fn(async (input: RequestInfo | URL) => String(input).endsWith('/csrf') ? json(200, { csrf_token: 'fixture-csrf-token' }) : json(status)))
  await expect(signOutWebSession(base)).rejects.toMatchObject({ response: { status } })
})

test('CSRF bootstrap failure is not treated as completed logout', async () => {
  vi.stubGlobal('fetch', vi.fn(async () => json(401)))
  await expect(signOutWebSession(base)).rejects.toMatchObject({ response: { status: 401 } })
})

test('logout keeps network failures retryable', async () => {
  vi.stubGlobal('fetch', vi.fn(async (input: RequestInfo | URL) => {
    if (String(input).endsWith('/csrf')) return json(200, { csrf_token: 'fixture-csrf-token' })
    throw new TypeError('Network unavailable')
  }))
  await expect(signOutWebSession(base)).rejects.toBeDefined()
})

test('protected portal offers sign-in recovery only for an expired session', async () => {
  vi.stubGlobal('fetch', vi.fn(async () => json(503)))
  render(<PortalIdentityProvider portal="admin" basePath={base}><p>Protected page</p></PortalIdentityProvider>)
  await act(async () => {})
  act(() => window.dispatchEvent(new CustomEvent('materyalph:access-denied', { detail: json(403) })))
  expect(screen.getByText('Protected page')).toBeInTheDocument()
  act(() => window.dispatchEvent(new CustomEvent('materyalph:access-denied', { detail: json(401) })))
  expect(screen.queryByText('Protected page')).not.toBeInTheDocument()
  expect(screen.getByRole('link', { name: 'Sign in again' })).toHaveAttribute('href', '/login')
})
