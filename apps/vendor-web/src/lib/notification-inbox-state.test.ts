import { describe, expect, it, vi } from 'vitest'
import { type NotificationItem } from '@materyalph/api-client-ts'
import { loadNotificationInbox, notificationFilters, notificationFilterSearch, notificationView, sameNotifications, withNotificationReads } from '../../../../packages/web-ui/src/notification-inbox-state'

const item = (id: string, title = 'Account security update', readAt: string | null = null, category = 'SECURITY'): NotificationItem => ({ id, title, readAt, category, body: 'Synthetic retained notice.', mandatory: true, createdAt: '2026-10-09T00:00:00Z' })

describe('notification inbox state', () => {
  it('filters the complete snapshot inclusively by Manila date without changing unrelated category options', () => {
    const rows = [
      { ...item('4'), createdAt: '2026-10-09T16:00:00Z' },
      { ...item('3'), createdAt: '2026-10-09T15:59:59Z' },
      { ...item('2'), createdAt: '2026-10-08T16:00:00Z' },
      { ...item('1', 'Team access changed', null, 'TEAM'), createdAt: '2026-10-08T15:59:59Z' },
    ]
    const filters = { type: '', from: '2026-10-09', to: '2026-10-09', dateLabel: 'Custom range' }
    expect(notificationView(rows, filters).visible.map(row => row.id)).toEqual(['3', '2'])
    expect(notificationView(rows, { ...filters, from: '' }).visible.map(row => row.id)).toEqual(['3', '2', '1'])
    expect(notificationView(rows, { ...filters, to: '' }).visible.map(row => row.id)).toEqual(['4', '3', '2'])
    expect(notificationFilters(notificationFilterSearch('?tab=inbox&notice=fixture', filters))).toEqual(filters)
    expect(notificationFilterSearch('?from=2026-10-09&to=2026-10-09&date_label=Today&tab=inbox', { type: '' })).toBe('tab=inbox')
  })
  it('persists filters without dropping unrelated deep-link or tab parameters', () => {
    const search = notificationFilterSearch('?tab=inbox&notice=fixture', { type: 'TEAM' })
    expect(notificationFilters(search)).toEqual({ type: 'TEAM' })
    expect(new URLSearchParams(search).get('notice')).toBe('fixture')
    expect(notificationFilterSearch(search, { type: '' })).toBe('tab=inbox&notice=fixture')
    // Saved links from the removed Status filter are ignored and dropped.
    for (const query of ['', '?status=unknown', '?status=all', '?status=unread', '?status=archived']) expect(notificationFilters(query)).toEqual({ type: '' })
    expect(notificationFilterSearch('?tab=inbox&status=archived', { type: '' })).toBe('tab=inbox')
  })
  it('builds types dynamically from every notice and lists only unread notices', () => {
    const items = [item('4'), item('3', 'Team access changed', null, 'TEAM'), item('2', 'Team access changed', '2026-10-09T01:00:00Z', 'TEAM'), item('1', 'Finance notice', '2026-10-09T01:00:00Z', 'FINANCE_MANDATORY'), item('0', 'New notice type', null, 'NEW_NOTICE_TYPE')]
    const view = notificationView(items, { type: 'TEAM' })
    expect(view.types).toEqual([{ value: 'SECURITY', label: 'Account security update' }, { value: 'FINANCE_MANDATORY', label: 'Finance notices' }, { value: 'NEW_NOTICE_TYPE', label: 'New notice type' }, { value: 'TEAM', label: 'Team access changed' }])
    expect(notificationView(items.map(row => ({ ...row, readAt: '2026-10-09T01:00:00Z' })), { type: '' }).types).toHaveLength(4)
    expect(view.visible.map(value => value.id)).toEqual(['3'])
    expect(notificationView(items, { type: '' }).visible.map(value => value.id)).toEqual(['4', '3', '0'])
    expect(notificationView(items, { type: 'Missing type' }).visible).toEqual([])
  })
  it('groups different order titles into one category and supports existing title-based URLs', () => {
    const items = [item('3', 'New order request ORD-SYNTHETIC-A', null, 'ORDERS'), item('2', 'Order ORD-SYNTHETIC-B completed', null, 'ORDERS'), item('1')]
    const view = notificationView(items, { type: 'ORDERS' })
    expect(view.types).toEqual([{ value: 'SECURITY', label: 'Account security update' }, { value: 'ORDERS', label: 'Order updates' }])
    expect(view.visible.map(value => value.id)).toEqual(['3', '2'])
    expect(notificationView(items, { type: items[0]!.title })).toEqual(view)
    const read = withNotificationReads(items, new Set(view.unread.map(value => value.id)), '2026-10-09T01:00:00Z')
    expect(notificationView(read, { type: '' }).visible.map(value => value.id)).toEqual(['1'])
    expect(notificationView(read, { type: 'ORDERS' }).visible).toEqual([])
  })
  it('removes only matching unread notices once read and restores them without losing new arrivals', () => {
    const filters = { type: 'TEAM' }
    const original = [item('3', 'Team access changed', null, 'TEAM'), item('2')]
    const ids = new Set(notificationView(original, filters).unread.map(value => value.id))
    const optimistic = withNotificationReads(original, ids, '2026-10-09T01:00:00Z')
    expect(notificationView(optimistic, filters).visible).toEqual([])
    expect(notificationView(optimistic, { type: '' }).visible.map(value => value.id)).toEqual(['2'])
    const updated = [item('4', 'New notice type', null, 'NEW_NOTICE_TYPE'), ...optimistic]
    expect(notificationView(updated, { type: '' }).visible.map(value => value.id)).toEqual(['4', '2'])
    const restored = withNotificationReads(updated, ids, null)
    expect(restored.map(value => value.id)).toEqual(['4', '3', '2'])
    expect(notificationView(restored, filters).visible.map(value => value.id)).toEqual(['3'])
    expect(original[0]?.readAt).toBeNull()
  })
  it('never lists already-read notices, so nothing unreadable-to-mark is shown', () => {
    const items = [item('2'), item('1', 'Account security update', '2026-10-08T01:00:00Z')]
    expect(notificationView(items, notificationFilters('')).visible.map(value => value.id)).toEqual(['2'])
    const read = withNotificationReads(items, new Set(['2']), '2026-10-09T01:00:00Z')
    expect(notificationView(read, notificationFilters('')).visible).toEqual([])
    expect(notificationView(read, notificationFilters('')).unread).toEqual([])
  })
  it('loads all cursor pages including empty revoked pages before replacing the inbox', async () => {
    const listNotifications = vi.fn().mockResolvedValueOnce({ data: [item('4')], meta: { next_cursor: '3' }, errors: [] })
      .mockResolvedValueOnce({ data: [], meta: { next_cursor: '2' }, errors: [] })
      .mockResolvedValueOnce({ data: [item('1')], meta: { next_cursor: null }, errors: [] })
    expect((await loadNotificationInbox({ listNotifications }, 'vendor')).map(value => value.id)).toEqual(['4', '1'])
    expect(listNotifications).toHaveBeenNthCalledWith(2, { audience: 'vendor', cursor: '3' }, undefined)
    expect(listNotifications).toHaveBeenCalledTimes(3)
  })
  it('rejects partial and nonadvancing feeds while leaving the prior snapshot intact', async () => {
    const original = [item('1')]
    const failure = vi.fn().mockResolvedValueOnce({ data: [item('3')], meta: { next_cursor: '2' }, errors: [] }).mockRejectedValueOnce(new Error('offline'))
    await expect(loadNotificationInbox({ listNotifications: failure }, 'vendor')).rejects.toThrow('offline')
    const cycle = vi.fn().mockResolvedValue({ data: [], meta: { next_cursor: '2' }, errors: [] })
    await expect(loadNotificationInbox({ listNotifications: cycle }, 'vendor')).rejects.toThrow('cursor did not advance')
    expect(original).toEqual([item('1')])
  })
  it('retains the current snapshot for identical refreshes and detects changed read state', () => {
    const current = [item('1')]
    expect(sameNotifications(current, [item('1')])).toBe(true)
    expect(sameNotifications(current, [item('2'), item('1')])).toBe(false)
    expect(sameNotifications(current, [item('1', 'Account security update', '2026-10-09T01:00:00Z')])).toBe(false)
  })
})
