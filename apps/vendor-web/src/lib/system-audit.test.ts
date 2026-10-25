import { describe, expect, it } from 'vitest'
import { parseDate } from '@materyalph/api-client-ts'
import { manilaToday, shouldRotateIdempotencyKey } from '@materyalph/web-ui'

describe('calendar dates and mutation retries', () => {
  it('uses Manila today around UTC midnight and preserves date-only local midnight', () => {
    expect(manilaToday(new Date('2026-10-23T16:01:00Z'))).toBe('2026-10-24')
    const selected = new Date('2026-10-24T00:00:00')
    expect(selected.getDate()).toBe(24)
    expect(selected.getHours()).toBe(0)
    expect(parseDate('2026-10-24').toLocaleDateString('en-PH', { dateStyle: 'medium' })).toBe(selected.toLocaleDateString('en-PH', { dateStyle: 'medium' }))
  })

  it('keeps the key for unknown, timeout and server outcomes, and rotates for definitive client rejection', () => {
    expect(shouldRotateIdempotencyKey(new TypeError('Failed to fetch'))).toBe(false)
    for (const status of [408, 500, 502, 503, 504]) expect(shouldRotateIdempotencyKey({ response: { status } })).toBe(false)
    for (const status of [400, 401, 403, 409, 422, 429]) expect(shouldRotateIdempotencyKey({ response: { status } })).toBe(true)
  })
})
