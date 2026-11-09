import { AsyncLoading } from './async-state'
import { useCallback, useEffect, useMemo, useRef, useState } from 'react'
import { Download } from 'lucide-react'
import { AccountsApi, ReportingApi, type DocumentExport, type DocumentExportInput, type PlatformDocumentRef } from '@materyalph/api-client-ts'
import { Button } from './button'
import { StatusMessage } from './status-message'
import { createWebApiConfiguration } from './web-api-session'
import { notificationError } from './notification-error'
import { useAccountVerification } from './account-verification-dialog'
import { requestExportWithVerification } from './document-export-verification'

type ExportType = DocumentExportInput['type']
export type DocumentExportContext = {
  basePath: string
  audience: 'vendor' | 'admin'
  types: readonly ExportType[]
  resourceId?: string
  filters?: Record<string, unknown>
  title?: string
  disabled?: boolean
  format?: 'PDF' | 'CSV'
}

const label = (value: string) => value === 'GEO_ANALYTICS' ? 'Geographic analytics' : value === 'MATERIALS_ANALYTICS' ? 'Materials Analytics' : value.toLowerCase().replaceAll('_', ' ').replace(/^./, first => first.toUpperCase())

/** Keep the URL available while the browser starts saving the attachment. */
export function saveDocumentBlob(blob: Blob, filename: string): void {
  const url = URL.createObjectURL(blob)
  const anchor = document.createElement('a')
  anchor.href = url
  anchor.download = filename
  document.body.appendChild(anchor)
  anchor.click()
  anchor.remove()
  window.setTimeout(() => URL.revokeObjectURL(url), 60_000)
}

export function DocumentExportButton(props: DocumentExportContext) {
  const format = props.format ?? 'PDF'
  return <div className="flex min-w-0 flex-wrap items-start gap-2">{props.types.map(type => <DocumentExportWorkspace
    {...props} key={type} types={[type]} compact
    buttonLabel={props.types.length === 1 && type !== 'PURCHASE_ORDER' ? `Export ${format}` : `${label(type)} ${format}`}
  />)}</div>
}

class ExportDownloadError extends Error {
  constructor(message: string, readonly resume = false) { super(message) }
}

type OrderDocumentKind = 'PURCHASE_ORDER'

async function pauseForDocument(signal: AbortSignal): Promise<void> {
  if (signal.aborted) return
  await new Promise<void>(resolve => {
    const done = () => { window.clearTimeout(timer); signal.removeEventListener('abort', done); resolve() }
    const timer = window.setTimeout(done, 5000)
    signal.addEventListener('abort', done, { once: true })
  })
}

async function waitForOrderDocument(api: ReportingApi, audience: 'admin' | 'vendor', orderId: string, kind: OrderDocumentKind, isCurrent: () => boolean, signal: AbortSignal): Promise<PlatformDocumentRef | null> {
  for (let attempt = 0; attempt < 60 && isCurrent(); attempt++) {
    const result = await api.listOrderDocuments({ audience, orderId })
    if (!isCurrent()) return null
    const document = result.data.find(item => item.kind === kind)
    if (document?.availability === 'READY' && document.downloadUrl) return document
    if (document?.availability !== 'QUEUED') throw new ExportDownloadError(document?.availability === 'AFTER_ACCEPTANCE' ? 'The Purchase Order will be available after the final order is accepted.'
      : 'This document is currently unavailable. Refresh its status or contact support.')
    await pauseForDocument(signal)
  }
  if (!isCurrent()) return null
  throw new ExportDownloadError('The document is still being prepared. Try downloading it again shortly.', true)
}

async function waitForExport(api: ReportingApi, audience: 'admin' | 'vendor', requested: DocumentExport, type: ExportType, format: 'PDF' | 'CSV', isCurrent: () => boolean, signal: AbortSignal): Promise<DocumentExport | null> {
  let item = requested
  for (let attempt = 0; attempt <= 60 && isCurrent(); attempt++) {
    if (item.state === 'READY') {
      if (item.expiresAt && new Date(item.expiresAt).getTime() <= Date.now()) throw new ExportDownloadError('This export has expired. Try exporting a new copy.')
      return item
    }
    if (item.state !== 'QUEUED') throw new ExportDownloadError(item.state === 'REVOKED' ? 'Access to this export has been revoked.' : 'This export could not be generated. Try exporting a new copy.')
    if (attempt === 60) break
    if (attempt > 0) await pauseForDocument(signal)
    if (!isCurrent()) return null
    let page = 1
    let found = false
    do {
      const result = await api.listDocumentExports({ audience, page, type, format, ...(requested.resourceId ? { resourceId: requested.resourceId } : {}) })
      if (!isCurrent()) return null
      const current = result.data.find(candidate => candidate.id === requested.id)
      if (current) { item = current; found = true; break }
      if (result.meta.has_more !== true) break
      page++
    } while (isCurrent())
    if (!found) throw new ExportDownloadError('This export is no longer available to your account.')
  }
  if (!isCurrent()) return null
  throw new ExportDownloadError('The export is still generating. Click Export again to continue the download.', true)
}

export function DocumentExportWorkspace({ basePath, audience, types, resourceId, filters = {}, title, format = 'PDF', disabled, compact = false, buttonLabel }: DocumentExportContext & { compact?: boolean; buttonLabel?: string }) {
  const api = useMemo(() => new ReportingApi(createWebApiConfiguration(basePath, { refreshSession: true })), [basePath])
  const accountsApi = useCallback(() => new AccountsApi(createWebApiConfiguration(basePath, { refreshSession: true })), [basePath])
  const [type, setType] = useState<ExportType>(types[0] ?? 'PURCHASE_ORDER')
  const [items, setItems] = useState<DocumentExport[]>([])
  const [busy, setBusy] = useState(false)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const [message, setMessage] = useState('')
  const [page, setPage] = useState(1)
  const [hasMore, setHasMore] = useState(false)
  const [sessionActive, setSessionActive] = useState(true)
  const sessionOpen = useRef(true)
  const { verify, dialog } = useAccountVerification({ api: accountsApi, portal: 'admin', explainError: notificationError, enabled: audience === 'admin' && sessionActive })
  const generation = useRef(0)
  const actionLock = useRef(false)
  const controller = useRef<AbortController | null>(null)
  const contextKey = JSON.stringify({ basePath, audience, type, resourceId, filters, format })
  const context = useRef(contextKey)
  context.current = contextKey
  const requestKey = useRef<{ scope: string; key: string; item?: DocumentExport }>({ scope: '', key: crypto.randomUUID() })
  const load = useCallback(async (number = 1) => {
    if (!sessionOpen.current) return
    const epoch = generation.current
    setLoading(true)
    try {
      const result = await api.listDocumentExports({ audience, page: number, type, format, ...(resourceId ? { resourceId } : {}) })
      if (epoch !== generation.current) return
      setItems(old => number === 1 ? result.data : [...new Map([...old, ...result.data].map(item => [item.id, item])).values()])
      setPage(number); setHasMore(result.meta.has_more === true)
    } catch (cause) {
      const message = await notificationError(cause)
      if (epoch !== generation.current) return
      if (cause && typeof cause === 'object' && 'response' in cause && cause.response instanceof Response && [401, 403].includes(cause.response.status)) setItems([])
      setError(message)
    } finally { if (epoch === generation.current) setLoading(false) }
  }, [api, audience, type, resourceId, format])
  useEffect(() => {
    generation.current++; actionLock.current = false; setBusy(false); setItems([]); setPage(1); setHasMore(false); setError(''); setMessage('')
    requestKey.current = { scope: '', key: crypto.randomUUID() }
    if (!compact) void load()
    const clear = () => { generation.current++; controller.current?.abort(); sessionOpen.current = false; setSessionActive(false); setBusy(false); setLoading(false); setItems([]); setHasMore(false); setMessage(''); setError('Sign in again to continue.') }
    window.addEventListener('materyalph:session-cleared', clear)
    return () => { generation.current++; controller.current?.abort(); window.removeEventListener('materyalph:session-cleared', clear) }
  }, [load, contextKey, compact])
  const pending = items.some(item => item.state === 'QUEUED')
  useEffect(() => {
    const resume = () => { if (!document.hidden && pending && !busy) void load() }
    document.addEventListener('visibilitychange', resume)
    return () => document.removeEventListener('visibilitychange', resume)
  }, [pending, busy, load])
  useEffect(() => {
    if (!pending || busy || loading || error) return
    const timer = window.setTimeout(() => { if (!document.hidden) void load() }, 5000)
    return () => window.clearTimeout(timer)
  }, [pending, busy, loading, error, load])

  async function request() {
    if (actionLock.current || !sessionActive || disabled) return
    actionLock.current = true
    const abort = new AbortController()
    controller.current = abort
    const epoch = generation.current
    const isCurrent = () => !abort.signal.aborted && sessionOpen.current && epoch === generation.current && context.current === contextKey
    setBusy(true); setError(''); setMessage('')
    try {
      if (resourceId && format === 'PDF' && type === 'PURCHASE_ORDER') {
        const document = await waitForOrderDocument(api, audience, resourceId, type, isCurrent, abort.signal)
        if (!document || !isCurrent()) return
        const blob = await api.downloadOrderDocument({ audience, orderId: resourceId, kind: type })
        await saveBlob(blob, 'PDF', `materyalph-${type.toLowerCase()}-${resourceId}.pdf`, isCurrent)
        if (isCurrent()) setMessage('PDF download started.')
        return
      }
      const input: DocumentExportInput = { type, format, resourceId: resourceId ?? null, purpose: `${label(type)} ${format} export from ${audience} ${resourceId ? 'record' : 'report'}.`, filters }
      const scope = JSON.stringify(input)
      if (requestKey.current.scope !== scope) requestKey.current = { scope, key: crypto.randomUUID() }
      const idempotencyKey = requestKey.current.key
      const submit = () => api.requestDocumentExport({ audience, idempotencyKey, documentExportInput: input })
      const result = requestKey.current.item ? { data: requestKey.current.item } : audience === 'admin'
        ? await requestExportWithVerification(submit, () => verify(`Confirm ${label(type).toLowerCase()} export`), isCurrent)
        : await submit()
      if (!isCurrent()) return
      if (!result) { setError(`Verification was cancelled. Your ${format} was not requested.`); return }
      requestKey.current.item = result.data
      setItems(old => [result.data, ...old.filter(item => item.id !== result.data.id)])
      const ready = await waitForExport(api, audience, result.data, type, format, isCurrent, abort.signal)
      if (!ready || !isCurrent()) return
      requestKey.current.item = ready
      setItems(old => [ready, ...old.filter(item => item.id !== ready.id)])
      await save(ready, isCurrent)
      if (!isCurrent()) return
      requestKey.current = { scope: '', key: crypto.randomUUID() }
      setMessage(`${format} download started.`)
      if (!compact) await load()
    } catch (cause) {
      const message = cause instanceof ExportDownloadError ? cause.message : await notificationError(cause)
      if (isCurrent()) {
        const unavailable = cause && typeof cause === 'object' && 'response' in cause && cause.response instanceof Response && [403, 410].includes(cause.response.status)
        if (unavailable || (cause instanceof ExportDownloadError && !cause.resume)) requestKey.current = { scope: '', key: crypto.randomUUID() }
        setError(message)
      }
    }
    finally { if (epoch === generation.current) { actionLock.current = false; setBusy(false) } }
  }
  async function save(item: DocumentExport, isCurrent: () => boolean) {
    const blob = await api.downloadDocumentExport({ audience, exportId: item.id })
    await saveBlob(blob, item.format, `materyalph-${item.type.toLowerCase()}-${item.id}.${item.format.toLowerCase()}`, isCurrent)
  }
  async function saveBlob(blob: Blob, fileFormat: string, filename: string, isCurrent: () => boolean) {
    if (!isCurrent()) return
    if (fileFormat === 'PDF' && await blob.slice(0, 5).text() !== '%PDF-') throw new ExportDownloadError('The PDF could not be verified. Try downloading it again.')
    if (!isCurrent()) return
    saveDocumentBlob(new Blob([blob], { type: fileFormat === 'PDF' ? 'application/pdf' : 'text/csv;charset=utf-8' }), filename)
  }
  async function download(item: DocumentExport) {
    if (actionLock.current || !sessionActive) return
    actionLock.current = true
    const epoch = generation.current
    setBusy(true); setError('')
    try {
      await save(item, () => sessionOpen.current && epoch === generation.current && context.current === contextKey)
      if (epoch !== generation.current) return
      await load()
    } catch (cause) { const message = await notificationError(cause); if (epoch === generation.current) { setError(message); await load() } }
    finally { if (epoch === generation.current) { actionLock.current = false; setBusy(false) } }
  }
  if (compact) return <div className="grid min-w-0 gap-2" aria-busy={busy}>
    <Button variant="secondary" disabled={disabled || busy || !sessionActive} onClick={() => void request()}><Download size={16} aria-hidden="true" />{busy ? 'Preparing download…' : buttonLabel}</Button>
    {busy && <p role="status" className="text-sm text-text-secondary">Your {format} will download when it is ready.</p>}
    {error && <StatusMessage tone="error">{error}</StatusMessage>}
    {message && <p role="status" className="text-sm text-text-secondary">{message}</p>}
    {dialog}
  </div>
  const control = 'mt-1 min-h-12 w-full rounded-control border border-border-default bg-surface-primary px-3 text-text-strong'
  return <><section className="grid min-w-0 gap-5" aria-busy={busy}>
    <p className="text-sm text-text-secondary">{title ? `${title}. ` : ''}Private {format} snapshots expire after 24 hours. Downloads are recorded. MateryalPH documents are not tax invoices.</p>
    {error && <StatusMessage tone="error">{error}</StatusMessage>}
    <form className="grid gap-4" onSubmit={event => { event.preventDefault(); void request() }}>
      <label className="text-sm font-semibold">Document<select className={control} value={type} disabled={busy} onChange={event => { setError(''); setType(event.target.value as ExportType) }}>{types.map(value => <option key={value} value={value}>{label(value)}</option>)}</select></label>
      {audience === 'admin' && <p className="text-sm text-text-secondary">If identity verification is required, you’ll be prompted here before your {format} is generated.</p>}
      <div><Button type="submit" disabled={disabled || busy || !sessionActive}>{busy ? 'Preparing download…' : `Export ${format}`}</Button></div>
    </form>
    {message && <p role="status">{message}</p>}
    <div className="flex flex-wrap items-center justify-between gap-3 border-t border-border-default pt-5"><h3 className="font-semibold">Recent exports</h3><Button variant="secondary" disabled={busy || loading || !sessionActive} onClick={() => { setError(''); void load() }}>Refresh status</Button></div>
    {loading && <AsyncLoading compact label="Loading exports…" />}
    {pending && <StatusMessage tone="info">Your {format} is generating. Its status updates automatically while this section is open.</StatusMessage>}
    {!loading && !items.length && <p className="text-sm text-text-secondary">No exports for this document yet.</p>}
    <ul className="divide-y divide-border-default">{items.map(item => {
      const expired = item.state === 'EXPIRED' || (item.expiresAt != null && new Date(item.expiresAt).getTime() <= Date.now())
      return <li key={item.id} className="grid min-w-0 gap-2 py-4"><div className="flex flex-wrap justify-between gap-3"><h4 className="font-semibold">{label(item.type)} · {item.format}</h4><span className="text-sm">{expired ? 'EXPIRED' : item.state}</span></div>
        <p className="break-words text-sm">{item.purpose}</p>
        <p className="text-xs text-text-secondary">Requested: {new Date(item.createdAt).toLocaleString('en-PH', { timeZone: 'Asia/Manila' })} Manila</p>
        <p className="text-xs text-text-secondary">Expires: {item.expiresAt ? `${new Date(item.expiresAt).toLocaleString('en-PH', { timeZone: 'Asia/Manila' })} Manila` : '24 hours after generation'}</p>
        {item.state === 'FAILED' && <p role="alert" className="text-sm">Generation failed. Generate a new {format} to try again.</p>}
        {expired && <p className="text-sm text-text-secondary">This download has expired. Generate a new {format} above.</p>}
        {item.state === 'REVOKED' && <p className="text-sm text-text-secondary">Access to this document has been revoked.</p>}
        {item.state === 'READY' && !expired && <div><Button disabled={busy || !sessionActive} onClick={() => void download(item)}><Download size={16} aria-hidden="true" />Download {item.format}</Button></div>}
      </li>
    })}</ul>
    {hasMore && <Button variant="secondary" disabled={loading || busy || !sessionActive} onClick={() => void load(page + 1)}>Load more exports</Button>}
  </section>{dialog}</>
}
