import { clearWebSessionTransport, createWebApiConfiguration } from '@materyalph/web-ui'
import { afterEach, expect, test, vi } from 'vitest'

const base = 'https://api.example.test/api/v1'
afterEach(() => { clearWebSessionTransport(); vi.unstubAllGlobals() })

test.each([
  [403, 'RECENT_AUTHENTICATION_REQUIRED', false],
  [403, 'REAUTHENTICATION_REQUIRED', false],
  [403, 'EXPORT_ACCESS_DENIED', true],
  [403, 'FORBIDDEN', true],
  [401, 'RECENT_AUTHENTICATION_REQUIRED', true],
] as const)('HTTP %s %s signals page-wide access denial: %s', async (status, code, denied) => {
  const payload = { data: null, meta: {}, errors: [{ code, message: 'Protected action.' }] }
  const fetcher = vi.fn(async () => new Response(JSON.stringify(payload), { status, headers: { 'Content-Type': 'application/json' } }))
  vi.stubGlobal('fetch', fetcher)
  const onDenied = vi.fn()
  window.addEventListener('materyalph:access-denied', onDenied)
  try {
    const response = await createWebApiConfiguration(base).fetchApi!(`${base}/admin/reports`, { method: 'POST' })
    expect(response.status).toBe(status)
    expect(await response.json()).toEqual(payload)
    expect(onDenied).toHaveBeenCalledTimes(denied ? 1 : 0)
    expect(fetcher).toHaveBeenCalledOnce()
  } finally { window.removeEventListener('materyalph:access-denied', onDenied) }
})

test.each(['unreadable', '{}', '{"errors":[]}', '{"errors":[{"code":"FORBIDDEN"},{"code":"RECENT_AUTHENTICATION_REQUIRED"}]}'])('malformed or unrelated denial remains protected: %s', async body => {
  vi.stubGlobal('fetch', vi.fn(async () => new Response(body, { status: 403 })))
  const onDenied = vi.fn()
  window.addEventListener('materyalph:access-denied', onDenied)
  try {
    const response = await createWebApiConfiguration(base).fetchApi!(`${base}/admin/reports`, { method: 'POST' })
    expect(await response.text()).toBe(body)
    expect(onDenied).toHaveBeenCalledOnce()
  } finally { window.removeEventListener('materyalph:access-denied', onDenied) }
})
