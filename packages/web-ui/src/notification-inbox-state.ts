import type { NotificationItem, NotificationsApi } from '@materyalph/api-client-ts'

export type NotificationFilters = { type: string; from?: string; to?: string; dateLabel?: string }

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
  return { type: params.get('type') ?? '', ...(params.get('from') ? { from: params.get('from')! } : {}), ...(params.get('to') ? { to: params.get('to')! } : {}), ...(params.get('date_label') ? { dateLabel: params.get('date_label')! } : {}) }
}

export function notificationFilterSearch(search: string, filters: NotificationFilters): string {
  const params = new URLSearchParams(search)
  params.delete('status') // Saved links from the removed Status filter are dropped.
  if (filters.type) params.set('type', filters.type); else params.delete('type')
  for (const [key, value] of [['from', filters.from], ['to', filters.to], ['date_label', filters.dateLabel]]) {
    if (value) params.set(key!, value); else params.delete(key!)
  }
  return params.toString()
}

export function notificationView(items: readonly NotificationItem[], filters: NotificationFilters) {
  // Existing URLs used display titles. Resolve them to their category without filling the dropdown with order references.
  const type = items.find(item => item.title === filters.type)?.category ?? filters.type
  const start = filters.from ? Date.parse(`${filters.from}T00:00:00+08:00`) : -Infinity
  const end = filters.to ? Date.parse(`${filters.to}T00:00:00+08:00`) + 86400000 : Infinity
  // The inbox lists unread notices only; a notice leaves it once read. Read notices stay stored server-side.
  const pending = items.filter(item => !item.readAt)
  const unread = pending.filter(item => (!type || item.category === type) && Date.parse(item.createdAt) >= start && Date.parse(item.createdAt) < end)
  return {
    type,
    types: [...new Set(items.map(item => item.category))].map(value => ({ value, label: notificationTypeLabel(value) })).sort((a, b) => a.label.localeCompare(b.label)),
    visible: unread,
    unread,
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
