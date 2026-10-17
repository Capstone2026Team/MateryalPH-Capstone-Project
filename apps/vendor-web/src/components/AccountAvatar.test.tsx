import { StrictMode } from 'react'
import { act, fireEvent, render, screen, waitFor } from '@testing-library/react'
import { afterEach, beforeEach, expect, test, vi } from 'vitest'
import { AccountAvatar } from '../../../../packages/web-ui/src/account-avatar'
import { clearWebSessionTransport, readAccountPhoto } from '../../../../packages/web-ui/src/web-api-session'

const base = 'https://api.example.test/api/v1'
const signedUrl = (portal: 'vendors' | 'admin', version = 1) => `${base}/${portal}/account/photo?expires=123&signature=fixture&owner=fixture&version=${version}`
const png = () => new Response('synthetic photo', { headers: { 'Content-Type': 'image/png' } })
const renewed = (url: string | null) => new Response(JSON.stringify({ data: { avatar_url: url } }), { headers: { 'Content-Type': 'application/json' } })
const createObjectURL = vi.fn(() => 'blob:personal-photo')
const revokeObjectURL = vi.fn()

beforeEach(() => {
  clearWebSessionTransport()
  createObjectURL.mockClear()
  revokeObjectURL.mockClear()
  const NativeURL = URL
  vi.stubGlobal('URL', class extends NativeURL {
    static override createObjectURL = createObjectURL
    static override revokeObjectURL = revokeObjectURL
  })
})
afterEach(() => vi.unstubAllGlobals())

function avatar(portal: 'vendors' | 'admin' = 'vendors', url: string | null = signedUrl(portal)) {
  return <AccountAvatar portal={portal} basePath={base} avatarUrl={url} fullName="France Jefferson Sulibio" alt="Your personal profile" className="profile-avatar" />
}

test.each(['vendors', 'admin'] as const)('%s photo uses authenticated transport and revokes its private preview on unmount', async portal => {
  const fetcher = vi.fn().mockImplementation(async () => png())
  vi.stubGlobal('fetch', fetcher)
  const view = render(avatar(portal))
  expect(await screen.findByRole('img', { name: 'Your personal profile' })).toHaveAttribute('src', 'blob:personal-photo')
  expect(fetcher).toHaveBeenCalledWith(new URL(signedUrl(portal)), expect.objectContaining({ credentials: 'include', cache: 'no-store', referrerPolicy: 'origin' }))
  view.unmount()
  expect(revokeObjectURL).toHaveBeenCalledWith('blob:personal-photo')
})

test.each([403, 404])('renews an expired or outdated photo link once after %s', async status => {
  const fetcher = vi.fn()
    .mockResolvedValueOnce(new Response('{}', { status }))
    .mockResolvedValueOnce(renewed(signedUrl('vendors', 2)))
    .mockResolvedValueOnce(png())
  vi.stubGlobal('fetch', fetcher)
  render(avatar())
  expect(await screen.findByRole('img', { name: 'Your personal profile' })).toHaveAttribute('src', 'blob:personal-photo')
  expect(fetcher).toHaveBeenCalledTimes(3)
  expect(fetcher.mock.calls[1]?.[0]).toBe(`${base}/vendors/account/profile`)
  expect(fetcher.mock.calls[2]?.[0]).toEqual(new URL(signedUrl('vendors', 2)))
})

test('a missing photo after renewal keeps initials and stops retrying', async () => {
  const fetcher = vi.fn()
    .mockResolvedValueOnce(new Response('{}', { status: 403 }))
    .mockResolvedValueOnce(renewed(signedUrl('vendors', 2)))
    .mockResolvedValueOnce(new Response('{}', { status: 404 }))
  vi.stubGlobal('fetch', fetcher)
  render(avatar())
  await waitFor(() => expect(fetcher).toHaveBeenCalledTimes(3))
  expect(screen.getByText('FJ')).toBeVisible()
  expect(screen.queryByRole('img')).not.toBeInTheDocument()
  expect(createObjectURL).not.toHaveBeenCalled()
})

test('decode failures fall back to initials without refetching', async () => {
  const fetcher = vi.fn().mockResolvedValueOnce(png())
  vi.stubGlobal('fetch', fetcher)
  render(avatar())
  fireEvent.error(await screen.findByRole('img', { name: 'Your personal profile' }))
  expect(screen.getByText('FJ')).toBeVisible()
  expect(screen.queryByRole('img')).not.toBeInTheDocument()
  expect(fetcher).toHaveBeenCalledTimes(1)
})

test('StrictMode and late responses cannot restore an obsolete photo', async () => {
  let finish!: (response: Response) => void
  const fetcher = vi.fn(() => new Promise<Response>(resolve => { finish = resolve }))
  vi.stubGlobal('fetch', fetcher)
  const view = render(<StrictMode>{avatar()}</StrictMode>)
  view.rerender(<StrictMode>{avatar('vendors', null)}</StrictMode>)
  await act(async () => { finish(png()) })
  expect(screen.getByText('FJ')).toBeVisible()
  expect(createObjectURL).not.toHaveBeenCalled()
  expect(screen.queryByRole('img')).not.toBeInTheDocument()
})

test('foreign origins, unrelated API paths and the other portal never receive photo credentials', async () => {
  const fetcher = vi.fn()
  vi.stubGlobal('fetch', fetcher)
  for (const url of ['https://untrusted.example/photo', `${base}/auth/session`, signedUrl('admin')]) {
    await expect(readAccountPhoto(base, 'vendors', url)).rejects.toThrow('invalid')
  }
  expect(fetcher).not.toHaveBeenCalled()
})

test('offline and unexpected response content are rejected', async () => {
  const fetcher = vi.fn()
    .mockRejectedValueOnce(new TypeError('Offline'))
    .mockResolvedValueOnce(new Response('<html>Sign in</html>', { headers: { 'Content-Type': 'text/html' } }))
  vi.stubGlobal('fetch', fetcher)
  await expect(readAccountPhoto(base, 'vendors', signedUrl('vendors'))).rejects.toThrow('Offline')
  await expect(readAccountPhoto(base, 'vendors', signedUrl('vendors'))).rejects.toThrow('cannot be previewed')
  expect(fetcher).toHaveBeenCalledTimes(2)
})
