import { useEffect, useRef } from 'react'

/** Refresh mounted, visible workspaces without overlapping requests or focus bursts. */
export function useAutomaticRefresh(refresh: () => Promise<unknown>, { enabled = true, intervalMs = 30_000 }: { enabled?: boolean; intervalMs?: number } = {}) {
  const callback = useRef(refresh)
  const pending = useRef(false)
  useEffect(() => { callback.current = refresh }, [refresh])

  useEffect(() => {
    if (!enabled) return
    let active = true
    let dueAt = Date.now() + intervalMs
    let timer: ReturnType<typeof setTimeout> | undefined
    const schedule = () => { timer = setTimeout(() => { void update() }, intervalMs) }
    async function update() {
      if (!active || pending.current || document.visibilityState !== 'visible' || !navigator.onLine || Date.now() < dueAt) return
      clearTimeout(timer)
      pending.current = true
      try { await callback.current() }
      catch { /* The workspace owns its error presentation and retry state. */ }
      finally {
        pending.current = false
        dueAt = Date.now() + intervalMs
        if (active) schedule()
      }
    }
    const resume = () => { void update() }
    schedule()
    document.addEventListener('visibilitychange', resume)
    window.addEventListener('focus', resume)
    window.addEventListener('online', resume)
    return () => {
      active = false
      clearTimeout(timer)
      document.removeEventListener('visibilitychange', resume)
      window.removeEventListener('focus', resume)
      window.removeEventListener('online', resume)
    }
  }, [enabled, intervalMs])
}
