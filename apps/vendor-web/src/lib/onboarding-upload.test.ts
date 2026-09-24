import { afterEach, expect, test, vi } from 'vitest'
import { clearWebSessionTransport } from '@materyalph/web-ui'
import { uploadVendorDocument } from './onboarding-api'

afterEach(() => { vi.unstubAllGlobals(); clearWebSessionTransport() })

test('generated multipart request preserves the selected File and lets the browser set its boundary', async () => {
  const selected = new File(['%PDF-1.4 fixture'], 'registration.pdf', { type: 'application/pdf' })
  let body: FormData | undefined
  const fetchMock = vi.fn(async (input: RequestInfo | URL, init?: RequestInit) => {
    if (String(input).endsWith('/auth/csrf')) return new Response(JSON.stringify({ data: { csrf_token: 'test-only-csrf-token' } }))
    expect(String(input)).toContain('/vendors/onboarding/documents')
    expect(init?.method).toBe('POST')
    expect(new Headers(init?.headers).has('Content-Type')).toBe(false)
    expect(init?.body).toBeInstanceOf(FormData)
    body = init?.body as FormData
    return new Response(JSON.stringify({ data: { id: 'pending-file', requirement_key: 'identity_evidence', version: 0, scan_state: 'CLEAN', status: 'PENDING_SUBMISSION' }, meta: {}, errors: [] }), { status: 201 })
  })
  vi.stubGlobal('fetch', fetchMock)
  await uploadVendorDocument('identity_evidence', selected)
  expect(body?.get('requirement_key')).toBe('identity_evidence')
  const sent = body?.get('file') as File
  expect(sent.name).toBe(selected.name)
  expect(sent.size).toBe(selected.size)
  expect(sent.type).toBe(selected.type)
  expect(body?.get('metadata')).toBeInstanceOf(Blob)
})
