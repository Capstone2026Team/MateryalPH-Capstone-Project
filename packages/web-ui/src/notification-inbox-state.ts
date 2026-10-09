import type { NotificationItem, NotificationsApi } from '@materyalph/api-client-ts'

export type NotificationFilters = { status: 'unread' | 'archived'; type: string }

const typeLabels: Record<string, string> = {
  SECURITY: 'Account security update',
  TEAM: 'Team access changed',
  ORDERS: 'Order updates',
  INVOICES: 'Invoice updates',
  PAYMENT: 'Payment updates',
  REFUND: 'Refund updates',
  FINANCE_MANDATORY: 'Finance notices',
}

export function notificationTypeLabel(category: string): string {
  const label = category.toLowerCase().replaceAll('_', ' ')
  return typeLabels[category] ?? `${label.charAt(0).toUpperCase()}${label.slice(1)}`
}

export function notificationFilters(search: string): NotificationFilters {
  const params = new URLSearchParams(search)
  const status = params.get('status')
  return { status: status === 'archived' ? 'archived' : 'unread', type: params.get('type') ?? '' }
}

export function notificationFilterSearch(search: string, filters: NotificationFilters): string {
  const params = new URLSearchParams(search)
  if (filters.status === 'unread') params.delete('status'); else params.set('status', filters.status)
  if (filters.type) params.set('type', filters.type); else params.delete('type')
  return params.toString()
}

export function notificationView(items: readonly NotificationItem[], filters: NotificationFilters) {
  // Existing URLs used display titles. Resolve them to their category without filling the dropdown with order references.
  const type = items.find(item => item.title === filters.type)?.category ?? filters.type
  const matchingType = items.filter(item => !type || item.category === type)
  const unread = matchingType.filter(item => !item.readAt)
  const archived = matchingType.filter(item => Boolean(item.readAt))
  return {
    type,
    types: [...new Set(items.map(item => item.category))].map(value => ({ value, label: notificationTypeLabel(value) })).sort((a, b) => a.label.localeCompare(b.label)),
    counts: { unread: unread.length, archived: archived.length },
    visible: filters.status === 'archived' ? archived : unread,
    unread: filters.status === 'archived' ? [] : unread,
  }
}

export function withNotificationReads(items: readonly NotificationItem[], ids: ReadonlySet<string>, readAt: string | null): NotificationItem[] {
  return items.map(item => ids.has(item.id) ? { ...item, readAt } : item)
}

export function sameNotifications(left: readonly NotificationItem[], right: readonly NotificationItem[]): boolean {
  return left.length === right.length && left.every((item, index) => {
    const other = right[index]
    return other && item.id === other.id && item.readAt === other.readAt && item.title === other.title && item.body === other.body
      && item.category === other.category && item.mandatory === other.mandatory && item.createdAt === other.createdAt
  })
}

/** Assemble authorized cursor pages before swapping the snapshot, including empty pages of revoked rows. */
export async function loadNotificationInbox(api: Pick<NotificationsApi, 'listNotifications'>, audience: 'vendor' | 'admin', signal?: AbortSignal): Promise<NotificationItem[]> {
  const items = new Map<string, NotificationItem>()
  const cursors = new Set<string>()
  let cursor: string | undefined
  do {
    const result = await api.listNotifications({ audience, ...(cursor ? { cursor } : {}) }, signal ? { signal } : undefined)
    for (const item of result.data) items.set(item.id, item)
    cursor = typeof result.meta.next_cursor === 'string' ? result.meta.next_cursor : undefined
    if (cursor && cursors.has(cursor)) throw new Error('The notification cursor did not advance.')
    if (cursor) cursors.add(cursor)
  } while (cursor)
  return [...items.values()].sort((a, b) => b.id.localeCompare(a.id))
}
