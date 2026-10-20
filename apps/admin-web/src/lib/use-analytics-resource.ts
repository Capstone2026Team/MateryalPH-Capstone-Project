import { useCallback, useEffect, useRef, useState } from 'react'
import { useAutomaticRefresh, usePortalResource } from '@materyalph/web-ui'
import { readableApiError } from './auth-api'

/** Scope the resource key to every filter so late responses cannot replace another selection. */
export function useAnalyticsResource<T>(key: string, load: () => Promise<T>) {
  const loader = useRef(load)
  useEffect(() => { loader.current = load }, [load])
  const fetchResource = useCallback(() => loader.current(), [])
  const resource = usePortalResource(`admin-analytics-${key}`, fetchResource)
  const [error, setError] = useState<string | null>(null)
  useEffect(() => {
    let active = true
    setError(null)
    if (resource.error) void readableApiError(resource.error).then(message => { if (active) setError(message) })
    return () => { active = false }
  }, [resource.error])
  useAutomaticRefresh(resource.refresh, { enabled: !resource.pending, intervalMs: resource.error ? 120_000 : 30_000 })
  return { data: resource.data, error, loading: resource.pending, retry: resource.refresh, set: resource.publish }
}
