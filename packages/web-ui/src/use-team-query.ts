import { useCallback, useEffect, useRef, useState } from 'react'
import { ResponseError } from '@materyalph/api-client-ts'

/** Keep team snapshots visible during updates; discard stale requests and revoked access. */
export function useTeamQuery<Query, Result>(list: (query: Query) => Promise<Result>, query: Query, explainError: (error: unknown) => Promise<string>, delayMs = 0, enabled = true) {
  const [result, setResult] = useState<Result | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(enabled)
  const [blocked, setBlocked] = useState(false)
  const [updatedAt, setUpdatedAt] = useState<Date | null>(null)
  const update = useRef<() => Promise<void>>(async () => {})
  const retryUpdate = useRef<() => Promise<void>>(async () => {})
  const refresh = useCallback(() => update.current(), [])
  const retry = useCallback(() => retryUpdate.current(), [])

  useEffect(() => {
    let current = true
    let denied = false
    let queued = false
    let pending: Promise<void> | undefined
    setLoading(enabled); setError(null); setResult(null); setUpdatedAt(null); setBlocked(false)
    if (!enabled) {
      update.current = async () => {}
      retryUpdate.current = async () => {}
      return
    }
    const load = (): Promise<void> => {
      if (!current || denied) return Promise.resolve()
      queued = true
      if (pending) return pending
      pending = (async () => {
        do {
          queued = false
          try {
            const value = await list(query)
            if (!current) return
            setResult(value); setError(null); setUpdatedAt(new Date())
          } catch (cause) {
            if (!current) return
            if (cause instanceof ResponseError && [401, 403, 404].includes(cause.response.status)) {
              denied = true; setBlocked(true); setResult(null); setUpdatedAt(null)
            }
            const message = await explainError(cause)
            if (current) setError(message)
            queued = false
          }
        } while (queued && current && !denied)
      })().finally(() => { pending = undefined; if (current) setLoading(false) })
      return pending
    }
    update.current = load
    retryUpdate.current = () => { denied = false; setBlocked(false); return load() }
    const timer = window.setTimeout(() => { void load() }, delayMs)
    const clear = () => {
      current = false; setResult(null); setUpdatedAt(null); setLoading(false); setBlocked(true)
    }
    window.addEventListener('materyalph:session-cleared', clear)
    return () => { current = false; window.clearTimeout(timer); window.removeEventListener('materyalph:session-cleared', clear) }
  }, [list, query, explainError, delayMs, enabled])

  return { result: enabled ? result : null, error: enabled ? error : null, loading: enabled && loading, blocked: enabled && blocked, updatedAt: enabled ? updatedAt : null, refresh, retry }
}
