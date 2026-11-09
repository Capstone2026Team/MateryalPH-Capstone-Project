import { act, render, screen } from '@testing-library/react'
import { afterEach, expect, test, vi } from 'vitest'
import { ResponseError } from '@materyalph/api-client-ts'
import { PortalResourceProvider, usePortalResource } from '../../../../packages/web-ui/src/portal-resources'
import { clearWebSessionTransport, createWebApiConfiguration, readAccountPhoto, readSignedCaseFile, readWebPrivateFile } from '../../../../packages/web-ui/src/web-api-session'

const base = 'https://api.example.test/api/v1'
const id = '0199aa10-0000-7000-8000-000000000001'
const signed = (path: string) => `${base}${path}?expires=123&signature=fixture%2Bvalue%2Fsignature`
const json = (status: number) => new Response(JSON.stringify({ data: null, meta: {}, errors: [{ code: 'HTTP_ERROR', message: 'Invalid signature.' }] }), {
  status, headers: { 'Content-Type': 'application/json' },
})
const files = [
  { name: 'Vendor account photo', read: () => readAccountPhoto(base, 'vendors', signed('/vendors/account/photo')) },
  { name: 'Admin account photo', read: () => readAccountPhoto(base, 'admin', signed('/admin/account/photo')) },
  { name: 'case evidence', read: () => readSignedCaseFile(base, signed(`/vendor/disputes/${id}/files/${id}/content`)) },
  { name: 'invoice copy', read: () => readSignedCaseFile(base, signed(`/admin/invoice-records/${id}/content`)) },
  { name: 'onboarding evidence', read: () => readWebPrivateFile(base, signed(`/vendor-onboarding-files/${id}/content`)) },
  { name: 'catalog evidence', read: () => readWebPrivateFile(base, signed(`/catalog-files/${id}/content`)) },
]

afterEach(() => { clearWebSessionTransport(); vi.unstubAllGlobals() })

test.each(files)('an expired $name link fails locally without rejecting portal access', async ({ read }) => {
  const fetcher = vi.fn(async () => json(403))
  vi.stubGlobal('fetch', fetcher)
  const denied = vi.fn()
  window.addEventListener('materyalph:access-denied', denied)
  try {
    await expect(read()).rejects.toMatchObject({ response: { status: 403 } })
    expect(fetcher).toHaveBeenCalledOnce()
    expect(fetcher).toHaveBeenCalledWith(expect.any(URL), expect.objectContaining({ credentials: 'include', cache: 'no-store' }))
    expect(denied).not.toHaveBeenCalled()
  } finally { window.removeEventListener('materyalph:access-denied', denied) }
})

function Snapshot({ load }: { load: () => Promise<string> }) {
  const resource = usePortalResource('dashboard', load)
  return <p>{resource.error instanceof ResponseError ? 'Dashboard rejected' : resource.data ?? 'Loading dashboard'}</p>
}

test.each(['vendors', 'admin'] as const)('%s photo expiry preserves loaded and pending dashboard data', async portal => {
  vi.stubGlobal('fetch', vi.fn(async () => json(403)))
  let finish!: (value: string) => void
  const load = vi.fn(() => new Promise<string>(resolve => { finish = resolve }))
  render(<PortalResourceProvider><Snapshot load={load} /></PortalResourceProvider>)
  expect(screen.getByText('Loading dashboard')).toBeVisible()

  await act(async () => {
    await expect(readAccountPhoto(base, portal, signed(`/${portal}/account/photo`))).rejects.toMatchObject({ response: { status: 403 } })
    finish('Dashboard ready')
  })
  expect(screen.getByText('Dashboard ready')).toBeVisible()

  await act(async () => {
    await expect(readAccountPhoto(base, portal, signed(`/${portal}/account/photo`))).rejects.toMatchObject({ response: { status: 403 } })
  })
  expect(screen.getByText('Dashboard ready')).toBeVisible()
  expect(load).toHaveBeenCalledOnce()
})

test.each(files)('$name still announces an expired session after refresh fails', async ({ read }) => {
  const fetcher = vi.fn(async (input: RequestInfo | URL) => String(input).endsWith('/auth/csrf')
    ? new Response(JSON.stringify({ data: { csrf_token: 'fixture-csrf' } }), { headers: { 'Content-Type': 'application/json' } })
    : json(401))
  vi.stubGlobal('fetch', fetcher)
  const denied = vi.fn()
  window.addEventListener('materyalph:access-denied', denied)
  try {
    await expect(read()).rejects.toMatchObject({ response: { status: 401 } })
    expect(fetcher.mock.calls.some(([input]) => String(input).endsWith('/auth/refresh'))).toBe(true)
    expect(denied).toHaveBeenCalledWith(expect.objectContaining({ detail: expect.objectContaining({ status: 401 }) }))
  } finally { window.removeEventListener('materyalph:access-denied', denied) }
})

test('a protected page permission denial still rejects portal snapshots', async () => {
  vi.stubGlobal('fetch', vi.fn(async () => json(403)))
  const load = vi.fn(async () => 'Dashboard ready')
  render(<PortalResourceProvider><Snapshot load={load} /></PortalResourceProvider>)
  expect(await screen.findByText('Dashboard ready')).toBeVisible()
  await act(async () => {
    const response = await createWebApiConfiguration(base, { refreshSession: true }).fetchApi!(`${base}/vendor/onboarding`)
    expect(response.status).toBe(403)
  })
  expect(screen.getByText('Dashboard rejected')).toBeVisible()
})
