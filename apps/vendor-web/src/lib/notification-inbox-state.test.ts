import { describe, expect, it, vi } from 'vitest'
import { type NotificationItem } from '@materyalph/api-client-ts'
import { loadNotificationInbox, notificationFilters, notificationFilterSearch, notificationView, sameNotifications, withNotificationReads } from '../../../../packages/web-ui/src/notification-inbox-state'

const item = (id: string, title = 'Account security update', readAt: string | null = null, category = 'SECURITY'): NotificationItem => ({ id, title, readAt, category, body: 'Synthetic retained notice.', mandatory: true, createdAt: '2026-10-09T00:00:00Z' })

describe('notification inbox state', () => {
  it('persists filters without dropping unrelated deep-link or tab parameters', () => {
    const search = notificationFilterSearch('?tab=inbox&notice=fixture', { status: 'archived', type: 'TEAM' })
    expect(notificationFilters(search)).toEqual({ status: 'archived', type: 'TEAM' })
    expect(new URLSearchParams(search).get('notice')).toBe('fixture')
    expect(notificationFilterSearch(search, { status: 'unread', type: '' })).toBe('tab=inbox&notice=fixture')
    for (const query of ['', '?status=unknown', '?status=all']) expect(notificationFilters(query)).toEqual({ status: 'unread', type: '' })
  })
  it('builds types dynamically and keeps all status counts scoped to the selected type', () => {
    const items = [item('4'), item('3', 'Team access changed', null, 'TEAM'), item('2', 'Team access changed', '2026-10-09T01:00:00Z', 'TEAM'), item('1', 'New notice type', null, 'NEW_NOTICE_TYPE')]
    const view = notificationView(items, { status: 'unread', type: 'TEAM' })
    expect(view.types).toEqual([{ value: 'SECURITY', label: 'Account security update' }, { value: 'NEW_NOTICE_TYPE', label: 'New notice type' }, { value: 'TEAM', label: 'Team access changed' }])
    expect(view.counts).toEqual({ unread: 1, archived: 1 })
    expect(view.visible.map(value => value.id)).toEqual(['3'])
    expect(notificationView(items, { status: 'unread', type: 'Missing type' }).visible).toEqual([])
  })
  it('groups different order titles into one category and supports existing title-based URLs', () => {
    const items = [item('3', 'New order request ORD-SYNTHETIC-A', null, 'ORDERS'), item('2', 'Order ORD-SYNTHETIC-B completed', null, 'ORDERS'), item('1')]
    const view = notificationView(items, { status: 'unread', type: 'ORDERS' })
    expect(view.types).toEqual([{ value: 'SECURITY', label: 'Account security update' }, { value: 'ORDERS', label: 'Order updates' }])
    expect(view.visible.map(value => value.id)).toEqual(['3', '2'])
    expect(notificationView(items, { status: 'unread', type: items[0]!.title })).toEqual(view)
    const read = withNotificationReads(items, new Set(view.unread.map(value => value.id)), '2026-10-09T01:00:00Z')
    expect(notificationView(read, { status: 'unread', type: '' }).visible.map(value => value.id)).toEqual(['1'])
    expect(notificationView(read, { status: 'archived', type: 'ORDERS' }).visible.map(value => value.id)).toEqual(['3', '2'])
  })
  it('moves only matching unread notices to Archived and restores them without losing new arrivals', () => {
    const filters = { status: 'unread' as const, type: 'TEAM' }
    const original = [item('3', 'Team access changed', null, 'TEAM'), item('2')]
    const ids = new Set(notificationView(original, filters).unread.map(value => value.id))
    const optimistic = withNotificationReads(original, ids, '2026-10-09T01:00:00Z')
    expect(notificationView(optimistic, filters).visible).toEqual([])
    expect(notificationView(optimistic, { ...filters, status: 'archived' }).visible.map(value => value.id)).toEqual(['3'])
    expect(notificationView(optimistic, { ...filters, status: 'archived' }).unread).toEqual([])
    const updated = [item('4', 'New notice type', null, 'NEW_NOTICE_TYPE'), ...optimistic]
    expect(notificationView(updated, filters).counts).toEqual({ unread: 0, archived: 1 })
    const restored = withNotificationReads(updated, ids, null)
    expect(restored.map(value => value.id)).toEqual(['4', '3', '2'])
    expect(notificationView(restored, filters).visible.map(value => value.id)).toEqual(['3'])
    expect(original[0]?.readAt).toBeNull()
  })
  it('removes an individually read notice from the default inbox and retains it in Archived after reload', () => {
    const items = [item('2'), item('1', 'Account security update', '2026-10-08T01:00:00Z')]
    const filters = notificationFilters('')
    expect(notificationView(items, filters).visible.map(value => value.id)).toEqual(['2'])
    const read = withNotificationReads(items, new Set(['2']), '2026-10-09T01:00:00Z')
    expect(notificationView(read, filters).visible).toEqual([])
    expect(notificationView(read, notificationFilters('?status=archived')).visible.map(value => value.id)).toEqual(['2', '1'])
    expect(notificationView(read, filters).counts).toEqual({ unread: 0, archived: 2 })
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
