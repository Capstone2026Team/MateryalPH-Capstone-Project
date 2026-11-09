import { afterEach, expect, test, vi } from 'vitest'
import { clearWebSessionTransport, createWebApiConfiguration } from '@materyalph/web-ui'
import { ResponseError } from '@materyalph/api-client-ts'
import { financeKpis } from './finance-api'

afterEach(() => { clearWebSessionTransport(); vi.unstubAllGlobals() })

test('the optional earnings panel keeps finance 403 local while ordinary finance reads still invalidate access', async () => {
  const denied = vi.fn()
  window.addEventListener('materyalph:access-denied', denied)
  vi.stubGlobal('fetch', vi.fn(async (input: RequestInfo | URL) => String(input).endsWith('/csrf')
    ? new Response(JSON.stringify({ data: { csrf_token: 'test-finance-csrf' }, meta: {}, errors: [] }))
    : new Response(JSON.stringify({ data: null, meta: {}, errors: [{ code: 'PERMISSION_DENIED' }] }), { status: 403 })))
  try {
    await expect(financeKpis('2026-11-01', '2026-11-06', { localForbidden: true })).rejects.toBeInstanceOf(ResponseError)
    expect(denied).not.toHaveBeenCalled()
    await expect(financeKpis('2026-11-01', '2026-11-06')).rejects.toBeInstanceOf(ResponseError)
    expect(denied).toHaveBeenCalledTimes(1)
  } finally { window.removeEventListener('materyalph:access-denied', denied) }
})

test('local permission handling never suppresses session expiry', async () => {
  const denied = vi.fn()
  window.addEventListener('materyalph:access-denied', denied)
  vi.stubGlobal('fetch', vi.fn(async () => new Response('{}', { status: 401 })))
  try {
    const response = await createWebApiConfiguration('http://localhost:8080/api/v1', { localForbidden: true }).fetchApi!('http://localhost:8080/api/v1/admin/finance/kpis')
    expect(response.status).toBe(401)
    expect(denied).toHaveBeenCalledTimes(1)
  } finally { window.removeEventListener('materyalph:access-denied', denied) }
})
