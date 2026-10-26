import { useCallback, useEffect, useRef, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { NotificationsApi, type DeliveryFailure } from '@materyalph/api-client-ts'
import { ALL_DATES, Button, DateFilter, EmptyState, StatusMessage, Toolbar, enableWebPush, NotificationsWorkspace, createWebApiConfiguration, notificationError } from '@materyalph/web-ui'
import { AdminShell, LoadingState, PageHeader } from './PhaseThreeAdminPages'
import { dateQuery } from '../lib/admin-format'

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'
export function AdminNotificationsPage() {
  const navigate = useNavigate()
  return <AdminShell activeHref="/notifications"><NotificationsWorkspace basePath={basePath} audience="admin" navigate={navigate} {...(import.meta.env.VITE_FIREBASE_PUSH_ENABLED === 'true' ? { enablePush: () => enableWebPush(basePath, 'admin', { apiKey: import.meta.env.VITE_FIREBASE_API_KEY, appId: import.meta.env.VITE_FIREBASE_APP_ID, projectId: import.meta.env.VITE_FIREBASE_PROJECT_ID, messagingSenderId: import.meta.env.VITE_FIREBASE_MESSAGING_SENDER_ID }, import.meta.env.VITE_FIREBASE_VAPID_KEY) } : {})} /></AdminShell>
}

export function AdminDeliveryFailuresPage() {
  const [items, setItems] = useState<DeliveryFailure[]>([])
  const [error, setError] = useState('')
  const [page, setPage] = useState(1)
  const [hasMore, setHasMore] = useState(false)
  const [range, setRange] = useState(ALL_DATES)
  const [loading, setLoading] = useState(true)
  const request = useRef(0)
  const cancelPending = useCallback(() => { request.current++ }, [])
  const load = useCallback(async (number = 1) => {
    const run = ++request.current
    setLoading(true); setError('')
    if (number === 1) setItems([])
    try { const result = await new NotificationsApi(createWebApiConfiguration(basePath, { refreshSession: true })).listNotificationFailures({ page: number, ...dateQuery(range) }); if (run !== request.current) return; setItems(old => number === 1 ? result.data : [...old, ...result.data]); setHasMore(result.meta.has_more === true); setPage(number) }
    catch (cause) { const message = await notificationError(cause); if (run === request.current) setError(message) }
    finally { if (run === request.current) setLoading(false) }
  }, [range])
  useEffect(() => { void load(); return cancelPending }, [load, cancelPending])
  return <AdminShell activeHref="/notifications"><div className="grid gap-6"><PageHeader eyebrow="Notifications" title="Delivery exceptions" description="External deliveries that exhausted their five attempts. Original business transactions remain recorded." actions={<Button variant="secondary" disabled={loading} onClick={() => void load()}>Refresh</Button>} /><Toolbar filters={<><DateFilter title="Delivery failure dates" value={range} onChange={setRange} />{(range.from || range.to) && <Button variant="quiet" onClick={() => setRange(ALL_DATES)}>Reset dates</Button>}</>} />{error && <StatusMessage tone="error">{error}</StatusMessage>}{loading && !items.length ? <LoadingState /> : items.length ? <ul className="divide-y divide-border-default rounded-surface border border-border-default bg-surface-primary px-4">{items.map(item => <li key={item.id} className="py-4"><strong>{item.channel} · {item.state}</strong><p className="text-sm">{item.attemptCount} attempts · {item.failureCode}</p><p className="break-all text-xs text-text-secondary">Delivery reference: {item.id}</p></li>)}</ul> : !error && <EmptyState message="No failed deliveries match these dates." />}{hasMore && <Button variant="secondary" disabled={loading} onClick={() => void load(page + 1)}>{loading ? 'Loading…' : 'Load more'}</Button>}</div></AdminShell>
}
