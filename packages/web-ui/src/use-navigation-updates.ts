import { useCallback, useEffect, useRef } from 'react'
import { NotificationsApi } from '@materyalph/api-client-ts'
import { createWebApiConfiguration } from './web-api-session'
import { useAutomaticRefresh } from './use-automatic-refresh'
import { usePortalResource } from './portal-resources'
import { watchNotificationUpdates } from './notification-realtime'
import type { NotificationAudience } from './notifications-workspace'

/** One authoritative snapshot drives the bell, sidebar and status counters. */
export function useNavigationUpdates({ basePath, audience, enabled = true }: { basePath: string; audience: NotificationAudience; enabled?: boolean }) {
  const load = useCallback(async () => (await new NotificationsApi(createWebApiConfiguration(basePath, { refreshSession: true })).getNavigationUpdates({ audience })).data.sections, [basePath, audience])
  const { data, refresh, publish, synchronize: reload } = usePortalResource(`${audience}-navigation-updates`, load, enabled)
  const sessionActive = useRef(enabled)
  const poll = useCallback(() => sessionActive.current ? refresh() : Promise.resolve(), [refresh])
  useAutomaticRefresh(poll, { enabled, intervalMs: 15_000 })
  useEffect(() => {
    if (!enabled) return
    sessionActive.current = true
    let active = true
    let running = false
    let again = false
    let stop: (() => void) | undefined
    let timer: ReturnType<typeof setTimeout> | undefined
    async function synchronize() {
      if (!active) return
      if (running) { again = true; return }
      running = true
      try {
        do { again = false; await reload() } while (active && again)
      } finally { running = false }
    }
    const invalidate = () => {
      if (!active) return
      if (running) again = true
      if (timer) return
      timer = setTimeout(() => { timer = undefined; void synchronize() }, 100)
    }
    const changed = (event: Event) => {
      if (event instanceof CustomEvent && event.detail?.audience && event.detail.audience !== audience) return
      if (event instanceof CustomEvent && event.detail?.basePath && event.detail.basePath !== basePath) return
      invalidate()
    }
    const count = (event: Event) => {
      if (!(event instanceof CustomEvent) || event.detail?.audience !== audience) return
      const value: unknown = event.detail?.unreadCount
      if (active && typeof value === 'number' && Number.isSafeInteger(value) && value >= 0) publish(previous => ({ ...previous, '/notifications': value }))
      invalidate()
    }
    const revoke = () => { active = false; sessionActive.current = false; clearTimeout(timer); stop?.() }
    const denied = (event: Event) => { if (event instanceof CustomEvent && event.detail instanceof Response && event.detail.status === 401) revoke() }
    const received = () => { invalidate(); window.dispatchEvent(new Event('materyalph:notifications-refresh')); window.dispatchEvent(new Event('materyalph:domain-refresh')) }
    void watchNotificationUpdates(basePath, audience, received).then(close => { if (active) stop = close; else close() }).catch(() => { /* REST recovery remains active. */ })
    window.addEventListener('materyalph:navigation-updates', changed)
    window.addEventListener('materyalph:notification-count', count)
    window.addEventListener('materyalph:notifications-refresh', changed)
    window.addEventListener('materyalph:session-cleared', revoke)
    window.addEventListener('materyalph:access-denied', denied)
    return () => {
      revoke()
      window.removeEventListener('materyalph:navigation-updates', changed)
      window.removeEventListener('materyalph:notification-count', count)
      window.removeEventListener('materyalph:notifications-refresh', changed)
      window.removeEventListener('materyalph:session-cleared', revoke)
      window.removeEventListener('materyalph:access-denied', denied)
    }
  }, [basePath, audience, enabled, reload, publish])
  return enabled ? data : null
}
