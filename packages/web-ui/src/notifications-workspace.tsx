import { PageHeader, FilterTabs } from './page-patterns'
import { useCallback, useEffect, useMemo, useRef, useState, type ReactNode } from 'react'
import { NotificationsApi, ReportingApi, type DocumentExport, type DocumentExportInput } from '@materyalph/api-client-ts'
import { Download } from 'lucide-react'
import { createWebApiConfiguration } from './web-api-session'
import { Button } from './button'
import { useAutomaticRefresh } from './use-automatic-refresh'
import { NotificationInbox, type NotificationInboxWatcher } from './notification-inbox'
import { notificationError } from './notification-error'
import { NotificationPreferencesDialog } from './notification-preferences-dialog'

export { notificationError } from './notification-error'

export type NotificationAudience = 'vendor' | 'admin'

function accessRevoked(error: unknown): boolean {
  return Boolean(error && typeof error === 'object' && 'response' in error && error.response instanceof Response && [401, 403].includes(error.response.status))
}

export function NotificationsWorkspace({ basePath, audience, navigate, enablePush, watchUpdates, headerActions }: { basePath: string; audience: NotificationAudience; navigate: (path: string) => void; enablePush?: () => Promise<void>; watchUpdates?: NotificationInboxWatcher; headerActions?: ReactNode }) {
  const api = useMemo(() => new NotificationsApi(createWebApiConfiguration(basePath, { refreshSession: true })), [basePath])
  const [tab, setTab] = useState<'inbox' | 'reports'>(() => new URLSearchParams(window.location.search).get('tab') === 'reports' ? 'reports' : 'inbox')
  const [preferencesOpen, setPreferencesOpen] = useState(false)
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState('')
  const open = useCallback(async (id: string) => {
    setBusy(true); setError('')
    try {
      const result = await api.resolveNotification({ audience, noticeId: id })
      await api.readNotification({ audience, noticeId: id })
      window.dispatchEvent(new CustomEvent('materyalph:notification-read', { detail: { id, audience } }))
      window.dispatchEvent(new Event('materyalph:navigation-updates'))
      if (!result.data.path.startsWith('/') || result.data.path.startsWith('//')) throw new Error('Invalid target')
      navigate(result.data.path)
    } catch (cause) { setError(await notificationError(cause)) } finally { setBusy(false) }
  }, [api, audience, navigate])
  useEffect(() => {
    const notice = new URLSearchParams(window.location.search).get('notice')
    if (notice && /^[0-9a-f-]{36}$/i.test(notice)) void open(notice)
  }, [open])
  return <section className="grid gap-6" aria-busy={busy}>
    <PageHeader eyebrow={audience === 'vendor' ? 'Vendor Portal' : 'Admin Portal'} title="Notifications" description="Updates that need your attention, with secure links to your work." actions={headerActions} />
    <FilterTabs appearance="tabs" label="Notification sections" value={tab} chips={[{ value: 'inbox', label: 'Inbox' }, { value: 'reports', label: 'Documents & exports' }]} onChange={value => setTab(value === 'reports' ? 'reports' : 'inbox')} />
    {error && <div role="alert" className="grid gap-2 rounded-surface border border-border-default bg-surface-primary p-4"><p>{error}</p><Button variant="secondary" onClick={() => { setError(''); window.dispatchEvent(new Event('materyalph:notifications-refresh')) }}>Retry</Button></div>}
    {tab === 'inbox' && <NotificationInbox api={api} audience={audience} disabled={busy} onOpen={open} onPreferences={() => setPreferencesOpen(true)} {...(watchUpdates ? { watchUpdates } : {})} />}
    {preferencesOpen && <NotificationPreferencesDialog api={api} audience={audience} onClose={() => setPreferencesOpen(false)} {...(enablePush ? { enablePush } : {})} />}
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

