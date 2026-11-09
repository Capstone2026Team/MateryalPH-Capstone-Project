import { beforeEach, expect, test, vi } from 'vitest'
import { readOrderEvidenceFile } from '@materyalph/web-ui'

beforeEach(() => vi.restoreAllMocks())
const order = '019c6e27-e55b-73d1-87d8-4e01f1f75043'
const file = '019c7714-3b77-74d1-9866-e1f484aae2ab'
const caseId = '019c7714-3b77-74d1-9866-e1f484aae2ac'

test('Admin evidence stays on the configured API origin and sends its case context', async () => {
  const fetch = vi.spyOn(globalThis, 'fetch').mockResolvedValue(new Response(new Blob(['proof'], { type: 'image/png' }), { status: 200, headers: { 'Content-Type': 'image/png' } }))
  await readOrderEvidenceFile('https://api.example.test/api/v1', `/admin/order-operations/orders/${order}/files/${file}?case_id=${caseId}`)
  expect(String(fetch.mock.calls[0]?.[0])).toBe(`https://api.example.test/api/v1/admin/order-operations/orders/${order}/files/${file}?case_id=${caseId}`)
  expect(fetch.mock.calls[0]?.[1]).toMatchObject({ credentials: 'include', cache: 'no-store', referrerPolicy: 'origin' })
})

test.each([`https://other.test/${file}`, `/admin/order-operations/orders/${order}/files/${file}?case_id=${caseId}&url=other`, `/admin/order-operations/orders/${order}/files/${file}/../secret`])('rejects an untrusted evidence path %s before sending credentials', async path => {
  const fetch = vi.spyOn(globalThis, 'fetch')
  await expect(readOrderEvidenceFile('https://api.example.test/api/v1', path)).rejects.toThrow('evidence path is invalid')
  expect(fetch).not.toHaveBeenCalled()
})
