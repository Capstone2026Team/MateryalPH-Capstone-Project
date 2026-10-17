import { parseDate } from '@materyalph/api-client-ts'
import { ALL_DATES, type DateFilterRange } from '@materyalph/web-ui'

/** Calendar dates stay as strings in page state; generated query serializers preserve local calendar fields. */
export type DateFilters = { from?: string; to?: string }

export function apiDateFilters(filters: DateFilters = {}): { from?: Date; to?: Date } {
  return {
    ...(filters.from ? { from: parseDate(filters.from) } : {}),
    ...(filters.to ? { to: parseDate(filters.to) } : {}),
  }
}

export function dateRangeFromParams(params: URLSearchParams): DateFilterRange {
  const from = params.get('from') ?? ''
  const to = params.get('to') ?? ''
  return from || to ? { label: params.get('date_label') ?? 'Custom range', from, to } : ALL_DATES
}

export function dateRangePatch(range: DateFilterRange): Record<string, string> {
  return { from: range.from, to: range.to, date_label: range.from || range.to ? range.label : '' }
}
