import { afterEach, expect, test, vi } from 'vitest'
import { ALL_DATES } from '@materyalph/web-ui'
import { dateRangeFromParams, dateRangePatch } from './date-filters'

afterEach(() => vi.useRealTimers())

test('portal dates default to 30 inclusive Manila days even when another filter is present', () => {
  vi.useFakeTimers()
  vi.setSystemTime(new Date('2026-11-04T17:00:00Z'))
  for (const search of ['', 'group=CLOSED&page=2', 'from=&to=']) {
    expect(dateRangeFromParams(new URLSearchParams(search))).toEqual({ label: 'Last 30 days', from: '2026-10-07', to: '2026-11-05' })
  }
})

test('explicit custom, open-ended and All dates selections survive URL round trips', () => {
  for (const range of [ALL_DATES, { label: 'Custom range', from: '2026-09-01', to: '2026-09-17' }, { label: 'Custom range', from: '', to: '2026-09-17' }]) {
    expect(dateRangeFromParams(new URLSearchParams(dateRangePatch(range)))).toEqual(range)
  }
})
