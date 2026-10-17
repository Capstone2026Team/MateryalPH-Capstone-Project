import { useNavigationUpdates } from './use-navigation-updates'
import type { NotificationAudience } from './notifications-workspace'

/** Compatibility shortcut; the same navigation snapshot owns every portal count. */
export function useNotificationUnreadCount(options: { basePath: string; audience: NotificationAudience; enabled?: boolean }) {
  const data = useNavigationUpdates(options)
  const count = data?.['/notifications']
  return typeof count === 'number' && Number.isSafeInteger(count) && count >= 0 ? count : null
}
