import { useCallback, useEffect, useMemo, useRef, useState } from 'react'
import { NotificationsApi, ReportingApi, type NotificationItem, type NotificationPreference, type DocumentExport, type DocumentExportInput } from '@materyalph/api-client-ts'
import { Bell, Download, FileText, Settings2 } from 'lucide-react'
import { createWebApiConfiguration } from './web-api-session'
import { Button } from './button'
import { useAutomaticRefresh } from './use-automatic-refresh'

export type NotificationAudience = 'vendor' | 'admin'

function accessRevoked(error: unknown): boolean {
  return Boolean(error && typeof error === 'object' && 'response' in error && error.response instanceof Response && [401, 403].includes(error.response.status))
}

export async function notificationError(error: unknown): Promise<string> {
  if (error && typeof error === 'object' && 'response' in error && error.response instanceof Response) {
    try {
      const body: unknown = await error.response.clone().json()
      if (body && typeof body === 'object' && 'errors' in body && Array.isArray(body.errors)) {
        const first: unknown = body.errors[0]
        if (first && typeof first === 'object' && 'message' in first && typeof first.message === 'string') return first.message
      }
    } catch { /* Use the safe network message below. */ }
  }
  return 'This request could not be completed. Check your connection and try again.'
}

export function NotificationsWorkspace({ basePath, audience, navigate, enablePush }: { basePath: string; audience: NotificationAudience; navigate: (path: string) => void; enablePush?: () => Promise<void> }) {
  const api = useMemo(() => new NotificationsApi(createWebApiConfiguration(basePath, { refreshSession: true })), [basePath])
  const [tab, setTab] = useState<'inbox' | 'preferences' | 'reports'>(() => new URLSearchParams(window.location.search).get('tab') === 'reports' ? 'reports' : 'inbox')
  const [items, setItems] = useState<NotificationItem[]>([])
  const [preferences, setPreferences] = useState<NotificationPreference[]>([])
  const [cursor, setCursor] = useState<string | undefined>()
  const [busy, setBusy] = useState(false)
  const [loaded, setLoaded] = useState(false)
  const [error, setError] = useState('')
  const [status, setStatus] = useState('')
  const load = useCallback(async (next?: string) => {
    setBusy(true); setError('')
    try {
      const result = await api.listNotifications({ audience, ...(next ? { cursor: next } : {}) })
      setItems(old => next ? [...old, ...result.data] : result.data)
      setCursor(typeof result.meta.next_cursor === 'string' ? result.meta.next_cursor : undefined)
      setLoaded(true)
    } catch (cause) { if (accessRevoked(cause)) { setItems([]); setCursor(undefined); setLoaded(true) }; setError(await notificationError(cause)) } finally { setBusy(false) }
  }, [api, audience])
  useEffect(() => { void load() }, [load])
  useAutomaticRefresh(load, { enabled: tab === 'inbox' && !busy })
  const open = useCallback(async (id: string) => {
    setBusy(true); setError('')
    try {
      const result = await api.resolveNotification({ audience, noticeId: id })
      await api.readNotification({ audience, noticeId: id })
      if (!result.data.path.startsWith('/') || result.data.path.startsWith('//')) throw new Error('Invalid target')
      navigate(result.data.path)
    } catch (cause) { setError(await notificationError(cause)) } finally { setBusy(false) }
  }, [api, audience, navigate])
  useEffect(() => {
    const notice = new URLSearchParams(window.location.search).get('notice')
    if (notice && /^[0-9a-f-]{36}$/i.test(notice)) void open(notice)
  }, [open])
  async function showPreferences() {
    setTab('preferences'); setBusy(true); setError('')
    try { setPreferences((await api.getNotificationPreferences({ audience })).data) }
    catch (cause) { setError(await notificationError(cause)) } finally { setBusy(false) }
  }
  async function change(preference: NotificationPreference, channel: 'inApp' | 'email' | 'push', enabled: boolean) {
    setBusy(true); setError(''); setStatus('')
    try {
      const result = await api.updateNotificationPreference({ audience, notificationPreferenceInput: { category: preference.category, inApp: preference.inApp, email: preference.email, push: preference.push, [channel]: enabled } })
      setPreferences(result.data); setStatus('Notification preferences saved.')
    } catch (cause) { setError(await notificationError(cause)) } finally { setBusy(false) }
  }
  return <section className="grid gap-6" aria-busy={busy}>
    <header><h1 className="text-2xl font-semibold text-text-strong">Notifications</h1><p className="mt-2 text-sm text-text-secondary">Updates that need your attention, with secure links to your work.</p></header>
    <nav aria-label="Notification sections" className="flex flex-wrap gap-2 border-b border-border-default pb-3">
      <Button variant={tab === 'inbox' ? 'primary' : 'secondary'} onClick={() => setTab('inbox')}><Bell size={16} aria-hidden="true" />Inbox</Button>
      <Button variant={tab === 'preferences' ? 'primary' : 'secondary'} onClick={() => void showPreferences()}><Settings2 size={16} aria-hidden="true" />Preferences</Button>
      <Button variant={tab === 'reports' ? 'primary' : 'secondary'} onClick={() => setTab('reports')}><FileText size={16} aria-hidden="true" />Documents & exports</Button>
    </nav>
    {error && <div role="alert" className="grid gap-2 rounded-surface border border-border-default bg-surface-primary p-4"><p>{error}</p><Button variant="secondary" onClick={() => void (tab === 'preferences' ? showPreferences() : load())}>Retry</Button></div>}
    {status && <p role="status">{status}</p>}
    {tab === 'inbox' && <div className="rounded-surface border border-border-default bg-surface-primary">
      <div className="flex items-center justify-between gap-3 border-b border-border-default p-4"><h2 className="font-semibold">Your inbox</h2><Button variant="secondary" disabled={busy} onClick={() => void load()}>Refresh</Button></div>
      {!loaded && busy ? <p role="status" className="p-6">Loading notifications…</p> : loaded && !items.length ? <div className="p-6"><h3 className="font-semibold">You’re up to date</h3><p className="mt-2 text-sm text-text-secondary">New account and transaction updates will appear here. You can review your preferences above.</p></div> : <ul className="divide-y divide-border-default">{items.map(item => <li key={item.id} className="p-4 sm:p-5"><div className="flex flex-wrap items-center gap-2"><h3 className="font-semibold">{item.title}</h3>{!item.readAt && <span className="text-xs font-semibold text-action-primary">Unread</span>}{item.mandatory && <span className="text-xs text-text-secondary">Required notice</span>}</div><p className="mt-2 text-sm text-text-secondary">{item.body}</p><div className="mt-3 flex flex-wrap items-center justify-between gap-3"><time className="text-xs text-text-secondary" dateTime={item.createdAt}>{new Date(item.createdAt).toLocaleString('en-PH', { timeZone: 'Asia/Manila' })} · Manila</time><Button variant="secondary" disabled={busy} onClick={() => void open(item.id)}>View details<span className="sr-only">: {item.title}</span></Button></div></li>)}</ul>}
      {cursor && <div className="p-4"><Button variant="secondary" disabled={busy} onClick={() => void load(cursor)}>Load more</Button></div>}
    </div>}
    {tab === 'preferences' && <div className="rounded-surface border border-border-default bg-surface-primary p-5">
      <h2 className="text-lg font-semibold">Delivery preferences</h2><p className="mt-2 text-sm text-text-secondary">Push also depends on this browser’s permission. You can always read required updates in your inbox.</p>
      {enablePush && <Button className="mt-4" variant="secondary" disabled={busy} onClick={() => { setBusy(true); void enablePush().then(() => setStatus('Push notifications enabled on this browser.')).catch(async cause => setError(await notificationError(cause))).finally(() => setBusy(false)) }}>Enable browser notifications</Button>}
      <div className="mt-5 divide-y divide-border-default">{preferences.map(p => <section key={p.category} className="py-4"><h3 className="font-semibold">{p.category.toLowerCase().replaceAll('_', ' ')}</h3><p className="mt-1 text-sm text-text-secondary">{p.explanation}</p>{p.mandatory ? <p className="mt-2 text-sm font-medium">Always enabled · In-app, email and registered push devices</p> : <div className="mt-3 flex flex-wrap gap-4">{(['inApp', 'email', 'push'] as const).map(channel => <label key={channel} className="inline-flex min-h-11 items-center gap-2"><input type="checkbox" checked={p[channel]} disabled={busy} onChange={event => void change(p, channel, event.target.checked)} />{channel === 'inApp' ? 'In-app' : channel === 'email' ? 'Email' : 'Push'}</label>)}</div>}</section>)}</div>
    </div>}
    {tab === 'reports' && <DocumentExportWorkspace basePath={basePath} audience={audience} />}
  </section>
}

export function DocumentExportWorkspace({ basePath, audience }: { basePath: string; audience: NotificationAudience }) {
  const api = useMemo(() => new ReportingApi(createWebApiConfiguration(basePath, { refreshSession: true })), [basePath])
  const [items, setItems] = useState<DocumentExport[]>([])
  const [type, setType] = useState<DocumentExportInput['type']>('PURCHASE_ORDER')
  const [format, setFormat] = useState<DocumentExportInput['format']>('PDF')
  const [resourceId, setResourceId] = useState(() => new URLSearchParams(window.location.search).get('resource') ?? '')
  const [purpose, setPurpose] = useState('')
  const requestKey = useRef({ scope: '', key: crypto.randomUUID() })
  const [days, setDays] = useState(30)
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState('')
  const [page, setPage] = useState(1)
  const [hasMore, setHasMore] = useState(false)
  const load = useCallback(async (number = 1) => {
    try { const result = await api.listDocumentExports({ audience, page: number }); setItems(old => number === 1 ? result.data : [...old, ...result.data]); setPage(number); setHasMore(result.meta.has_more === true) }
    catch (cause) { if (accessRevoked(cause)) setItems([]); setError(await notificationError(cause)) }
  }, [api, audience])
  useEffect(() => { void load() }, [load])
  useAutomaticRefresh(load, { enabled: !busy })
  async function request() {
    setBusy(true); setError('')
    try { const scope = JSON.stringify([type, format, resourceId, purpose, days]); if (requestKey.current.scope !== scope) requestKey.current = { scope, key: crypto.randomUUID() }; await api.requestDocumentExport({ audience, idempotencyKey: requestKey.current.key, documentExportInput: { type, format, resourceId: type === 'MATERIALS_ANALYTICS' ? null : resourceId || null, purpose, filters: type === 'MATERIALS_ANALYTICS' ? { preset_days: days } : {} } }); await load() }
    catch (cause) { setError(await notificationError(cause)) } finally { setBusy(false) }
  }
  async function download(item: DocumentExport) {
    setBusy(true); setError('')
    try { const result = await api.downloadDocumentExportRaw({ audience, exportId: item.id }); const blob = await result.raw.blob(); const url = URL.createObjectURL(blob); const anchor = document.createElement('a'); anchor.href = url; anchor.download = `materyalph-${item.type.toLowerCase()}.${item.format.toLowerCase()}`; anchor.click(); URL.revokeObjectURL(url); await load() }
    catch (cause) { setError(await notificationError(cause)) } finally { setBusy(false) }
  }
  const control = 'mt-1 min-h-12 w-full rounded-control border border-border-default bg-surface-primary px-3 text-text-strong'
  return <section className="grid gap-5"><div><h2 className="text-xl font-semibold">Documents & exports</h2><p className="mt-2 text-sm text-text-secondary">Private snapshots for an authorized purpose. Downloads expire after 24 hours and are recorded. MateryalPH documents are not tax invoices.</p></div>
    {error && <p role="alert">{error}</p>}
    <form className="grid gap-4 rounded-surface border border-border-default bg-surface-primary p-5" onSubmit={event => { event.preventDefault(); void request() }}>
      <div className="grid gap-4 sm:grid-cols-2"><label>Document<select className={control} value={type} onChange={e => setType(e.target.value as DocumentExportInput['type'])}>{['PURCHASE_ORDER', 'PAYMENT_CONFIRMATION', 'OPERATIONAL_ORDER', 'FEE_STATEMENT', 'MATERIALS_ANALYTICS', 'TAX_PACKAGE'].map(value => <option key={value} value={value}>{value.toLowerCase().replaceAll('_', ' ')}</option>)}</select></label><label>Format<select className={control} value={format} onChange={e => setFormat(e.target.value as DocumentExportInput['format'])}><option>PDF</option><option>CSV</option></select></label></div>
      {type !== 'MATERIALS_ANALYTICS' && <label>Order, statement or reviewed tax package ID<input className={control} value={resourceId} onChange={e => setResourceId(e.target.value)} required /></label>}
      {type === 'MATERIALS_ANALYTICS' && <label>Reporting window<select className={control} value={days} onChange={e => setDays(Number(e.target.value))}>{[7, 30, 90].map(value => <option key={value} value={value}>{value} days</option>)}</select></label>}
      <label>Purpose<textarea className={`${control} py-3`} minLength={10} maxLength={500} required value={purpose} onChange={e => setPurpose(e.target.value)} placeholder="Describe why you need this document" /></label>
      <p className="text-sm text-text-secondary">Materials Analytics uses your authorized default scope and selected window. Finance documents are Owner-only. Admin exports require recent identity verification in Account settings.</p>
      <div><Button type="submit" disabled={busy}>Generate document</Button></div>
    </form>
    <div className="flex items-center justify-between gap-3"><h3 className="font-semibold">Recent exports</h3><Button variant="secondary" disabled={busy} onClick={() => void load()}>Refresh status</Button></div>
    {!items.length ? <p className="text-sm text-text-secondary">No authorized exports to show. Generate a document to start.</p> : <ul className="divide-y divide-border-default rounded-surface border border-border-default bg-surface-primary">{items.map(item => <li key={item.id} className="grid gap-2 p-5"><div className="flex flex-wrap items-center justify-between gap-3"><h4 className="font-semibold">{item.type.toLowerCase().replaceAll('_', ' ')} · {item.format}</h4><span className="text-sm">{item.state}</span></div><p className="text-sm">{item.purpose}</p><p className="break-all text-xs text-text-secondary">Source: {item.sourceHash}</p><p className="text-xs text-text-secondary">Expires: {item.expiresAt ? new Date(item.expiresAt).toLocaleString('en-PH', { timeZone: 'Asia/Manila' }) + ' Manila' : 'After generation'}</p><details className="text-xs"><summary className="min-h-11 cursor-pointer py-3">Source versions, filters and access record</summary><pre className="overflow-auto whitespace-pre-wrap break-all">{JSON.stringify({ versions: item.sourceVersions, filters: item.filters, checksum: item.checksum, access: item.accessRecord }, null, 2)}</pre></details>{item.state === 'READY' && <div><Button variant="secondary" disabled={busy} onClick={() => void download(item)}><Download size={16} aria-hidden="true" />Download</Button></div>}</li>)}</ul>}
    {hasMore && <Button variant="secondary" onClick={() => void load(page + 1)}>Load more exports</Button>}
  </section>
}

