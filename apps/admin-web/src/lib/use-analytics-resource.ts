import { useCallback, useEffect, useRef, useState } from 'react'
import { useAutomaticRefresh, usePortalResource } from '@materyalph/web-ui'
import { readableApiError } from './auth-api'

/** Scope the resource key to every filter so late responses cannot replace another selection. */
export function useAnalyticsResource<T>(key: string, load: () => Promise<T>, { automaticRefresh = true, explainError = readableApiError }: { automaticRefresh?: boolean; explainError?: (cause: unknown) => Promise<string> } = {}) {
  const loader = useRef(load)
  useEffect(() => { loader.current = load }, [load])
  const fetchResource = useCallback(() => loader.current(), [])
  const resource = usePortalResource(`admin-analytics-${key}`, fetchResource)
  const [failure, setFailure] = useState<{ cause: unknown; message: string } | null>(null)
  useEffect(() => {
    let active = true
    if (resource.error) void explainError(resource.error).then(message => { if (active) setFailure({ cause: resource.error, message }) })
    return () => { active = false }
  }, [resource.error, explainError])
  useAutomaticRefresh(resource.refresh, { enabled: automaticRefresh && !resource.pending, intervalMs: resource.error ? 120_000 : 30_000 })
  return { data: resource.data, error: resource.error && failure?.cause === resource.error ? failure.message : null, loading: resource.pending, retry: resource.refresh, set: resource.publish }
}
