import { useCallback, useEffect } from 'react'
import { NotificationsApi } from '@materyalph/api-client-ts'
import { createWebApiConfiguration } from './web-api-session'
import { useAutomaticRefresh } from './use-automatic-refresh'
import { usePortalResource } from './portal-resources'
import { watchNotificationUpdates } from './notification-realtime'
import type { NotificationAudience } from './notifications-workspace'

/** The current account's authorized unread notices, shared by its mounted portal. */
export function useNotificationUnreadCount({ basePath, audience, enabled = true }: { basePath: string; audience: NotificationAudience; enabled?: boolean }) {
  const load = useCallback(async () => {
    const result = await new NotificationsApi(createWebApiConfiguration(basePath, { refreshSession: true })).getNotificationUnreadCount({ audience })
    return result.data.unreadCount
  }, [basePath, audience])
  const { data, refresh, publish } = usePortalResource(`${audience}-notification-unread-count`, load, enabled)
  useAutomaticRefresh(refresh, { enabled, intervalMs: 15_000 })

  useEffect(() => {
    if (!enabled) return
    let active = true
    let stop: (() => void) | undefined
    let timer: ReturnType<typeof setTimeout> | undefined
    const invalidate = () => {
      if (!active) return
      clearTimeout(timer)
      timer = setTimeout(() => {
        if (!active) return
        void refresh()
        window.dispatchEvent(new Event('materyalph:notifications-refresh'))
      }, 150)
    }
    const count = (event: Event) => {
      if (!active || !(event instanceof CustomEvent) || event.detail?.audience !== audience) return
      const unread: unknown = event.detail?.unreadCount
      if (typeof unread === 'number' && Number.isSafeInteger(unread) && unread >= 0) publish(unread)
      else void refresh()
    }
    const updated = () => { if (active) void refresh() }
    const revoke = () => { active = false; clearTimeout(timer); stop?.() }
    // A denied action can be outside notifications; only an expired session ends the subscription.
    const denied = (event: Event) => { if (event instanceof CustomEvent && event.detail instanceof Response && event.detail.status === 401) revoke() }
    void watchNotificationUpdates(basePath, audience, invalidate).then(close => { if (active) stop = close; else close() }).catch(() => { /* REST polling remains available while Reverb reconnects. */ })
    window.addEventListener('materyalph:notification-count', count)
    window.addEventListener('materyalph:notifications-refresh', updated)
    window.addEventListener('materyalph:session-cleared', revoke)
    window.addEventListener('materyalph:access-denied', denied)
    return () => {
      revoke()
      window.removeEventListener('materyalph:notification-count', count)
      window.removeEventListener('materyalph:notifications-refresh', updated)
      window.removeEventListener('materyalph:session-cleared', revoke)
      window.removeEventListener('materyalph:access-denied', denied)
    }
  }, [basePath, audience, enabled, publish, refresh])
  return enabled && typeof data === 'number' && Number.isSafeInteger(data) && data >= 0 ? data : null
}
