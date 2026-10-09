import { useEffect } from 'react'
import { NotificationsApi } from '@materyalph/api-client-ts'
import { createWebApiConfiguration, useAutomaticRefresh, useNotificationUnreadCount, usePortalResource } from '@materyalph/web-ui'

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'
const load = async () => (await new NotificationsApi(createWebApiConfiguration(basePath, { refreshSession: true })).getVendorNavigationUpdates()).data.sections

export function useVendorNavigationUpdates(enabled: boolean): Record<string, number> | null {
  const unreadCount = useNotificationUnreadCount({ basePath, audience: 'vendor', enabled })
  const { data, error, pending, refresh, publish } = usePortalResource('vendor-navigation-updates', load, enabled)
  useAutomaticRefresh(refresh, { enabled: enabled && !pending, intervalMs: error ? 120_000 : 30_000 })
  useEffect(() => {
    if (!enabled) return
    const update = (event: Event) => {
      const count: unknown = event instanceof CustomEvent ? event.detail?.unreadCount : undefined
      if (typeof count === 'number' && Number.isSafeInteger(count) && count >= 0) publish(previous => ({ ...previous, '/notifications': count }))
      else void refresh()
    }
    window.addEventListener('materyalph:navigation-updates', update)
    return () => window.removeEventListener('materyalph:navigation-updates', update)
  }, [enabled, refresh, publish])
  return enabled && data ? { ...data, '/notifications': unreadCount ?? data['/notifications'] ?? 0 } : null
}
