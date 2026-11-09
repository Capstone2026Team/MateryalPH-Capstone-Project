import { useSearchParams } from 'react-router-dom'
import { dateRangeFromParams, useNavigationRefresh } from '@materyalph/web-ui'
import { readableVerificationError } from './vendor-verification-api'
import { useAnalyticsResource } from './use-analytics-resource'

/** Preserve the matching snapshot during refresh; another filter set has its own resource. */
export function useAdminQueue<T>(key: string, load: () => Promise<T>, explainError = readableVerificationError) {
  const resource = useAnalyticsResource(`queue-${key}`, load, { automaticRefresh: false, explainError })
  useNavigationRefresh(() => { void resource.retry() })
  return resource
}

export function useQueueParams() {
  const [params, setParams] = useSearchParams()
  const requestedPage = Number(params.get('page'))
  const page = Number.isSafeInteger(requestedPage) && requestedPage > 0 ? requestedPage : 1
  const range = dateRangeFromParams(params)
  const change = (patch: Record<string, string>, resetPage = true) => setParams(current => {
    const next = new URLSearchParams(current)
    if (resetPage) next.delete('page')
    for (const [key, value] of Object.entries(patch)) { if (value) next.set(key, value); else next.delete(key) }
    return next
  })
  return { params, page, range, change, setPage: (value: number) => change({ page: String(value) }, false), context: params.size ? `?${params.toString()}` : '' }
}
