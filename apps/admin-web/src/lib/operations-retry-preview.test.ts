import { afterEach, expect, test, vi } from 'vitest'
import { AdminIntegrationHealthApi, type OperationFailure } from '@materyalph/api-client-ts'
import { operationRetryPreview } from './operations-api'

const row = (reference: string): OperationFailure => ({ reference, kind: 'OUTBOX_EVENT', label: 'Notification delivery', queue: 'notifications', failure: 'Delivery exhausted', failedAt: new Date(), retryable: true })
afterEach(() => vi.restoreAllMocks())

test('retry preview uses per_page metadata to read every page and deduplicates overlapping records', async () => {
  const list = vi.spyOn(AdminIntegrationHealthApi.prototype, 'listOperationFailures')
    .mockResolvedValueOnce({ data: [row('one'), row('two')], meta: { total: 4, per_page: 2, page: 1 }, errors: [] })
    .mockResolvedValueOnce({ data: [row('two'), row('three')], meta: { total: 4, per_page: 2, page: 2 }, errors: [] })
  const preview = await operationRetryPreview('OUTBOX')
  expect(preview.map(item => item.reference)).toEqual(['one', 'two', 'three'])
  expect(list).toHaveBeenNthCalledWith(1, { kind: 'OUTBOX', page: 1 })
  expect(list).toHaveBeenNthCalledWith(2, { kind: 'OUTBOX', page: 2 })
})

test('a later-page error rejects the preview instead of returning a partial batch', async () => {
  vi.spyOn(AdminIntegrationHealthApi.prototype, 'listOperationFailures')
    .mockResolvedValueOnce({ data: [row('one')], meta: { total: 2, per_page: 1 }, errors: [] })
    .mockRejectedValueOnce(new TypeError('Network unavailable'))
  await expect(operationRetryPreview('JOBS')).rejects.toThrow('Network unavailable')
})
