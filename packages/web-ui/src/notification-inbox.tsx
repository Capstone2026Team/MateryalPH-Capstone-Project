import { useCallback, useEffect, useMemo, useRef, useState } from 'react'
import { parseDate, type NotificationItem, type NotificationsApi } from '@materyalph/api-client-ts'
import { Bell, Settings2 } from 'lucide-react'
import { Button } from './button'
import { DateFilter } from './date-filter'
import { EmptyState } from './page-patterns'
import { useAutomaticRefresh } from './use-automatic-refresh'
import { notificationError } from './notification-error'
import type { NotificationAudience } from './notifications-workspace'
import { loadNotificationInbox, notificationFilters, notificationFilterSearch, notificationView, sameNotifications, withNotificationReads, type NotificationFilters } from './notification-inbox-state'

export type NotificationInboxWatcher = (refresh: () => void) => Promise<() => void>

export function NotificationInbox({ api, audience, disabled, onOpen, onPreferences, watchUpdates }: { api: NotificationsApi; audience: NotificationAudience; disabled: boolean; onOpen: (id: string) => Promise<void>; onPreferences: () => void; watchUpdates?: NotificationInboxWatcher }) {
  const [items, setItems] = useState<NotificationItem[]>([])
  const [filters, setFilters] = useState(() => notificationFilters(window.location.search))
  const [loaded, setLoaded] = useState(false)
  const [marking, setMarking] = useState(false)
  const [error, setError] = useState('')
  const snapshot = useRef(items)
  useEffect(() => { snapshot.current = items }, [items])
  const generation = useRef(0)
  const readVersion = useRef(0)
  const inFlight = useRef(false)
  const refreshAgain = useRef(false)
  const controller = useRef<AbortController | null>(null)
  const optimistic = useRef<{ ids: Set<string>; at: string } | null>(null)
  const view = useMemo(() => notificationView(items, filters), [items, filters])
  const filtersActive = filters.type !== '' || Boolean(filters.from || filters.to)
  const notifyCount = useCallback((snapshot: readonly NotificationItem[]) => {
    const unreadCount = snapshot.filter(item => !item.readAt).length
    window.dispatchEvent(new CustomEvent('materyalph:notification-count', { detail: { audience, unreadCount } }))
    if (audience === 'vendor') window.dispatchEvent(new CustomEvent('materyalph:navigation-updates', { detail: { unreadCount } }))
  }, [audience])
  useEffect(() => { if (loaded) notifyCount(items) }, [items, loaded, notifyCount])

  const refresh = useCallback(async () => {
    if (inFlight.current) { refreshAgain.current = true; return }
    inFlight.current = true
    const epoch = generation.current
    const version = readVersion.current
    const request = new AbortController()
    controller.current = request
    try {
      const result = await loadNotificationInbox(api, audience, request.signal)
      if (epoch !== generation.current) return
      if (version !== readVersion.current) { refreshAgain.current = true; return }
      const next = optimistic.current ? withNotificationReads(result, optimistic.current.ids, optimistic.current.at) : result
      setItems(previous => sameNotifications(previous, next) ? previous : next)
      setLoaded(true)
      // A background success must not erase a bulk-action failure before the user sees it.
      if (!optimistic.current) setError(previous => previous.startsWith('Could not mark') ? previous : '')
    } catch (cause) {
      if (epoch !== generation.current) return
      if (cause && typeof cause === 'object' && 'response' in cause && cause.response instanceof Response && [401, 403].includes(cause.response.status)) {
        setItems([]); setLoaded(false); optimistic.current = null
      }
      setError(await notificationError(cause))
    } finally {
      if (epoch === generation.current) {
        inFlight.current = false
        if (refreshAgain.current) { refreshAgain.current = false; void refresh() }
      }
    }
  }, [api, audience, notifyCount])

  useEffect(() => {
    generation.current++
    void refresh()
    const update = () => { void refresh() }
    const syncFilters = () => setFilters(notificationFilters(window.location.search))
    const readNotice = (event: Event) => {
      const id: unknown = event instanceof CustomEvent ? event.detail?.id : undefined
      if (typeof id !== 'string' || !(event instanceof CustomEvent) || event.detail?.audience !== audience) return
      readVersion.current++
      snapshot.current = withNotificationReads(snapshot.current, new Set([id]), new Date().toISOString())
      notifyCount(snapshot.current)
      setItems(current => withNotificationReads(current, new Set([id]), new Date().toISOString()))
    }
    window.addEventListener('materyalph:notifications-refresh', update)
    window.addEventListener('materyalph:notification-read', readNotice)
    window.addEventListener('popstate', syncFilters)
    return () => {
      generation.current++; controller.current?.abort(); inFlight.current = false; refreshAgain.current = false
      window.removeEventListener('materyalph:notifications-refresh', update)
      window.removeEventListener('materyalph:notification-read', readNotice)
      window.removeEventListener('popstate', syncFilters)
    }
  }, [refresh, audience, notifyCount])
  useAutomaticRefresh(refresh, { enabled: !marking, intervalMs: 15_000 })
  useEffect(() => {
    if (!watchUpdates) return
    let active = true
    let stop: (() => void) | undefined
    let timer: ReturnType<typeof setTimeout> | undefined
    const update = () => { clearTimeout(timer); timer = setTimeout(() => { if (active) void refresh() }, 250) }
    void watchUpdates(update).then(close => { if (active) stop = close; else close() }).catch(() => { /* Polling keeps the inbox current while Reverb reconnects. */ })
    return () => { active = false; clearTimeout(timer); stop?.() }
  }, [refresh, watchUpdates])

  function changeFilters(next: NotificationFilters) {
    setFilters(next)
    const url = new URL(window.location.href)
    url.search = notificationFilterSearch(url.search, next)
    url.searchParams.set('tab', 'inbox')
    window.history.replaceState(window.history.state, '', url)
  }
  const clearFilters = () => changeFilters({ type: '' })

  async function markAllRead() {
    if (marking || optimistic.current || !view.unread.length || !items[0]) return
    const epoch = generation.current
    const ids = new Set(view.unread.map(item => item.id))
    const at = new Date().toISOString()
    optimistic.current = { ids, at }
    readVersion.current++
    setMarking(true); setError('')
    const next = withNotificationReads(items, ids, at)
    setItems(next)
    try {
      const result = await api.markNotificationsRead({ audience, notificationReadFilter: { throughId: items[0].id, ...(view.type ? { category: view.type } : {}), ...(filters.from ? { from: parseDate(filters.from) } : {}), ...(filters.to ? { to: parseDate(filters.to) } : {}) } })
      if (epoch !== generation.current) return
      optimistic.current = null; readVersion.current++
      setItems(current => withNotificationReads(current, ids, result.data.readAt))
      window.dispatchEvent(new Event('materyalph:navigation-updates'))
      await refresh()
    } catch (cause) {
      if (epoch !== generation.current) return
      optimistic.current = null; readVersion.current++
      const denied = cause && typeof cause === 'object' && 'response' in cause && cause.response instanceof Response && [401, 403].includes(cause.response.status)
      if (denied) { setItems([]); setLoaded(false) }
      else setItems(current => withNotificationReads(current, ids, null))
      setError(`Could not mark notifications as read. ${await notificationError(cause)}`)
      window.dispatchEvent(new Event('materyalph:navigation-updates'))
    } finally { if (epoch === generation.current) setMarking(false) }
  }

  const selectClass = 'min-h-11 w-full min-w-0 rounded-control border border-border-default bg-surface-primary px-3 text-sm font-normal text-text-strong focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-focus-ring'
  return <div className="min-w-0 rounded-surface border border-border-default bg-surface-primary">
    <div className="grid gap-4 border-b border-border-default p-4">
      <div className="flex flex-wrap items-center justify-between gap-3"><h2 className="font-semibold">Your inbox</h2><div className="flex flex-wrap items-center gap-2"><Button variant="secondary" disabled={disabled || marking || !loaded || !view.unread.length} onClick={() => void markAllRead()}>{marking ? 'Marking as read…' : 'Mark all as read'}</Button><Button variant="secondary" className="w-11 shrink-0 px-0!" aria-label="Notification preferences" title="Notification preferences" aria-haspopup="dialog" disabled={disabled || marking} onClick={onPreferences}><Settings2 size={18} aria-hidden="true" /></Button></div></div>
      <div className="flex flex-wrap items-end gap-3">
        <DateFilter title="Notification dates" value={{ label: filters.dateLabel || 'Custom range', from: filters.from || '', to: filters.to || '' }} disabled={disabled || marking} onChange={range => changeFilters({ ...filters, from: range.from, to: range.to, dateLabel: range.label })} />
        <label className="grid min-w-0 flex-1 gap-2 text-sm font-semibold sm:max-w-72">Type<select className={selectClass} value={view.type} onChange={event => changeFilters({ ...filters, type: event.target.value })}><option value="">All types</option>{view.type && !view.types.some(type => type.value === view.type) && <option value={view.type}>Unavailable type</option>}{view.types.map(type => <option key={type.value} value={type.value}>{type.label}</option>)}</select></label>
        {filtersActive && <Button variant="quiet" className="text-action-primary underline" onClick={clearFilters}>Clear filters</Button>}
      </div>
    </div>
    {error && <div role="alert" className="grid gap-2 border-b border-border-default p-4"><p>{error}</p><Button variant="secondary" className="justify-self-start" disabled={marking} onClick={() => { setError(''); void refresh() }}>Retry</Button></div>}
    {!loaded ? !error && <p role="status" className="p-6">Loading notifications…</p> : !view.visible.length ? <EmptyState icon={<Bell size={24} aria-hidden="true" />} message={filtersActive ? 'No notifications match your filters.' : "You're all caught up."} {...(filtersActive ? { action: <Button variant="secondary" onClick={clearFilters}>Clear filters</Button> } : {})} /> : <ul className="divide-y divide-border-default">{view.visible.map(item => <li key={item.id} className="p-4 sm:p-5"><div className="flex flex-wrap items-center gap-2"><h3 className="font-semibold">{item.title}</h3>{!item.readAt && <span className="text-xs font-semibold text-action-primary">Unread</span>}{item.mandatory && <span className="text-xs text-text-secondary">Required notice</span>}</div><p className="mt-2 text-sm text-text-secondary">{item.body}</p><div className="mt-3 flex flex-wrap items-center justify-between gap-3"><time className="text-xs text-text-secondary" dateTime={item.createdAt}>{new Date(item.createdAt).toLocaleString('en-PH', { timeZone: 'Asia/Manila' })} · Manila</time><Button variant="secondary" disabled={disabled || marking} onClick={() => void onOpen(item.id)}>View details<span className="sr-only">: {item.title}</span></Button></div></li>)}</ul>}
  </div>
}
