// @vitest-environment node
import { expect, test, vi } from 'vitest'
import { requestExportWithVerification } from '../../../../packages/web-ui/src/document-export-verification'

const problem = (code: string, status = 403) => ({ response: new Response(JSON.stringify({ errors: [{ code, message: 'Request denied.' }] }), { status }) })

test('a currently authorized export runs without prompting for verification', async () => {
  const request = vi.fn().mockResolvedValue({ id: 'export-1' })
  const verify = vi.fn()
  await expect(requestExportWithVerification(request, verify, () => true)).resolves.toEqual({ id: 'export-1' })
  expect(request).toHaveBeenCalledOnce()
  expect(verify).not.toHaveBeenCalled()
})

test.each(['RECENT_AUTHENTICATION_REQUIRED', 'REAUTHENTICATION_REQUIRED'])('retries %s once using the original input and idempotency key', async code => {
  const input = { type: 'GEO_ANALYTICS', purpose: 'Reporting review', filters: { area: '1300000000' } }
  const transport = vi.fn().mockRejectedValueOnce(problem(code)).mockResolvedValue({ id: 'export-1' })
  const request = () => transport(input, 'original-export-request')
  const verify = vi.fn().mockResolvedValue(true)
  await expect(requestExportWithVerification(request, verify, () => true)).resolves.toEqual({ id: 'export-1' })
  expect(verify).toHaveBeenCalledOnce()
  expect(transport).toHaveBeenCalledTimes(2)
  for (const call of transport.mock.calls) {
    expect(call[0]).toBe(input)
    expect(call[1]).toBe('original-export-request')
  }
})

test('cancelling verification does not retry the export', async () => {
  const request = vi.fn().mockRejectedValue(problem('RECENT_AUTHENTICATION_REQUIRED'))
  const verify = vi.fn().mockResolvedValue(false)
  await expect(requestExportWithVerification(request, verify, () => true)).resolves.toBeNull()
  expect(request).toHaveBeenCalledOnce()
  expect(verify).toHaveBeenCalledOnce()
})

test.each([
  ['EXPORT_ACCESS_DENIED', 403], ['UNAUTHENTICATED', 401], ['VALIDATION_FAILED', 422], ['RECENT_AUTHENTICATION_REQUIRED', 500],
])('does not challenge or retry %s with HTTP %s', async (code, status) => {
  const cause = problem(code, status)
  const request = vi.fn().mockRejectedValue(cause)
  const verify = vi.fn()
  await expect(requestExportWithVerification(request, verify, () => true)).rejects.toBe(cause)
  expect(request).toHaveBeenCalledOnce()
  expect(verify).not.toHaveBeenCalled()
})

test('an unreadable failure retains the original error and never prompts', async () => {
  const cause = { response: new Response('Unavailable', { status: 403 }) }
  const request = vi.fn().mockRejectedValue(cause)
  const verify = vi.fn()
  await expect(requestExportWithVerification(request, verify, () => true)).rejects.toBe(cause)
  expect(request).toHaveBeenCalledOnce()
  expect(verify).not.toHaveBeenCalled()
})

test('a failed verification cannot authorize a retry', async () => {
  const cause = new Error('Verification unavailable')
  const request = vi.fn().mockRejectedValue(problem('RECENT_AUTHENTICATION_REQUIRED'))
  const verify = vi.fn().mockRejectedValue(cause)
  await expect(requestExportWithVerification(request, verify, () => true)).rejects.toBe(cause)
  expect(request).toHaveBeenCalledOnce()
})

test('a retry that still needs verification stops without a second prompt', async () => {
  const cause = problem('RECENT_AUTHENTICATION_REQUIRED')
  const request = vi.fn().mockRejectedValue(cause)
  const verify = vi.fn().mockResolvedValue(true)
  await expect(requestExportWithVerification(request, verify, () => true)).rejects.toBe(cause)
  expect(request).toHaveBeenCalledTimes(2)
  expect(verify).toHaveBeenCalledOnce()
})

test('a stale export context prevents the first request', async () => {
  const request = vi.fn()
  const verify = vi.fn()
  await expect(requestExportWithVerification(request, verify, () => false)).resolves.toBeNull()
  expect(request).not.toHaveBeenCalled()
  expect(verify).not.toHaveBeenCalled()
})

test('closing the workspace or clearing the session while verifying prevents a retry', async () => {
  let current = true
  const request = vi.fn().mockRejectedValue(problem('RECENT_AUTHENTICATION_REQUIRED'))
  const verify = vi.fn(async () => { current = false; return true })
  await expect(requestExportWithVerification(request, verify, () => current)).resolves.toBeNull()
  expect(request).toHaveBeenCalledOnce()
})

test('an export response arriving after its context becomes stale is discarded', async () => {
  let current = true
  const request = vi.fn(async () => { current = false; return { id: 'private-export' } })
  const verify = vi.fn()
  await expect(requestExportWithVerification(request, verify, () => current)).resolves.toBeNull()
  expect(verify).not.toHaveBeenCalled()
})
