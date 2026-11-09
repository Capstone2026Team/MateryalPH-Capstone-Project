import { parseDate } from '@materyalph/api-client-ts'
export { dateRangeFromParams, dateRangePatch } from '@materyalph/web-ui'

/** Calendar dates stay as strings in page state; generated query serializers preserve local calendar fields. */
export type DateFilters = { from?: string; to?: string }

export function apiDateFilters(filters: DateFilters = {}): { from?: Date; to?: Date } {
  return {
    ...(filters.from ? { from: parseDate(filters.from) } : {}),
    ...(filters.to ? { to: parseDate(filters.to) } : {}),
  }
}
