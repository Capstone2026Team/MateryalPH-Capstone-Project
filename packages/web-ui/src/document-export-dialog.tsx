import { useCallback, useEffect, useMemo, useRef, useState } from 'react'
import { Download } from 'lucide-react'
import { AccountsApi, ReportingApi, type DocumentExport, type DocumentExportInput } from '@materyalph/api-client-ts'
import { Button } from './button'
import { FormDialog } from './form-dialog'
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
  const [open, setOpen] = useState(false)
  return <>
    <Button variant="secondary" disabled={props.disabled} onClick={() => setOpen(true)}><Download size={16} aria-hidden="true" />Export PDF</Button>
    {open && <FormDialog open size="compact" title="Documents & exports" description={props.title ?? 'Generate a PDF for this section.'} onClose={() => setOpen(false)} footer={null}>
      <DocumentExportWorkspace {...props} />
    </FormDialog>}
  </>
}

export function DocumentExportWorkspace({ basePath, audience, types, resourceId, filters = {}, title }: DocumentExportContext) {
  const api = useMemo(() => new ReportingApi(createWebApiConfiguration(basePath, { refreshSession: true })), [basePath])
  const accountsApi = useCallback(() => new AccountsApi(createWebApiConfiguration(basePath, { refreshSession: true })), [basePath])
  const [type, setType] = useState<ExportType>(types[0] ?? 'PURCHASE_ORDER')
  const [purpose, setPurpose] = useState('')
  const [items, setItems] = useState<DocumentExport[]>([])
  const [busy, setBusy] = useState(false)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const [page, setPage] = useState(1)
  const [hasMore, setHasMore] = useState(false)
  const [sessionActive, setSessionActive] = useState(true)
  const sessionOpen = useRef(true)
  const { verify, dialog } = useAccountVerification({ api: accountsApi, portal: 'admin', explainError: notificationError, enabled: audience === 'admin' && sessionActive })
  const generation = useRef(0)
  const actionLock = useRef(false)
  const contextKey = JSON.stringify({ basePath, audience, type, resourceId, filters })
  const context = useRef(contextKey)
  context.current = contextKey
  const requestKey = useRef({ scope: '', key: crypto.randomUUID() })
  const load = useCallback(async (number = 1) => {
    if (!sessionOpen.current) return
    const epoch = generation.current
    setLoading(true)
    try {
      const result = await api.listDocumentExports({ audience, page: number, type, format: 'PDF', ...(resourceId ? { resourceId } : {}) })
      if (epoch !== generation.current) return
      setItems(old => number === 1 ? result.data : [...new Map([...old, ...result.data].map(item => [item.id, item])).values()])
      setPage(number); setHasMore(result.meta.has_more === true)
    } catch (cause) {
      const message = await notificationError(cause)
      if (epoch !== generation.current) return
      if (cause && typeof cause === 'object' && 'response' in cause && cause.response instanceof Response && [401, 403].includes(cause.response.status)) setItems([])
      setError(message)
    } finally { if (epoch === generation.current) setLoading(false) }
  }, [api, audience, type, resourceId])
  useEffect(() => {
    generation.current++; setBusy(false); setItems([]); setPage(1); setHasMore(false); void load()
    const clear = () => { generation.current++; sessionOpen.current = false; setSessionActive(false); setBusy(false); setLoading(false); setItems([]); setHasMore(false); setError('Sign in again to continue.') }
    window.addEventListener('materyalph:session-cleared', clear)
    return () => { generation.current++; window.removeEventListener('materyalph:session-cleared', clear) }
  }, [load])
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
    if (actionLock.current || !sessionActive) return
    actionLock.current = true
    const epoch = generation.current
    const isCurrent = () => sessionOpen.current && epoch === generation.current && context.current === contextKey
    setBusy(true); setError('')
    try {
      const input: DocumentExportInput = { type, format: 'PDF', resourceId: resourceId ?? null, purpose: purpose.trim(), filters }
      const scope = JSON.stringify(input)
      if (requestKey.current.scope !== scope) requestKey.current = { scope, key: crypto.randomUUID() }
      const idempotencyKey = requestKey.current.key
      const submit = () => api.requestDocumentExport({ audience, idempotencyKey, documentExportInput: input })
      const result = audience === 'admin'
        ? await requestExportWithVerification(submit, () => verify(`Confirm ${label(type).toLowerCase()} export`), isCurrent)
        : await submit()
      if (!isCurrent()) return
      if (!result) { setError('Verification was cancelled. Your PDF was not requested.'); return }
      requestKey.current = { scope: '', key: crypto.randomUUID() }
      setItems(old => [result.data, ...old.filter(item => item.id !== result.data.id)])
      await load()
    } catch (cause) { const message = await notificationError(cause); if (isCurrent()) setError(message) }
    finally { actionLock.current = false; if (epoch === generation.current) setBusy(false) }
  }
  async function download(item: DocumentExport) {
    if (actionLock.current || !sessionActive) return
    actionLock.current = true
    const epoch = generation.current
    setBusy(true); setError('')
    try {
      const blob = await api.downloadDocumentExport({ audience, exportId: item.id })
      if (epoch !== generation.current) return
      if (await blob.slice(0, 5).text() !== '%PDF-') throw new Error('Invalid PDF response')
      if (epoch !== generation.current) return
      saveDocumentBlob(new Blob([blob], { type: 'application/pdf' }), `materyalph-${item.type.toLowerCase()}-${item.id}.pdf`)
      await load()
    } catch (cause) { const message = await notificationError(cause); if (epoch === generation.current) { setError(message); await load() } }
    finally { actionLock.current = false; if (epoch === generation.current) setBusy(false) }
  }
  const control = 'mt-1 min-h-12 w-full rounded-control border border-border-default bg-surface-primary px-3 text-text-strong'
  return <><section className="grid min-w-0 gap-5" aria-busy={busy}>
    <p className="text-sm text-text-secondary">{title ? `${title}. ` : ''}Private PDF snapshots expire after 24 hours. Downloads are recorded. MateryalPH documents are not tax invoices.</p>
    {error && <StatusMessage tone="error">{error}</StatusMessage>}
    <form className="grid gap-4" onSubmit={event => { event.preventDefault(); void request() }}>
      <label className="text-sm font-semibold">Document<select className={control} value={type} disabled={busy} onChange={event => { setError(''); setType(event.target.value as ExportType) }}>{types.map(value => <option key={value} value={value}>{label(value)}</option>)}</select></label>
      <label className="text-sm font-semibold">Purpose<textarea className={`${control} py-3 font-normal`} minLength={10} maxLength={500} required disabled={busy} value={purpose} onChange={event => setPurpose(event.target.value)} placeholder="Describe why you need this document" /></label>
      {audience === 'admin' && <p className="text-sm text-text-secondary">If identity verification is required, you’ll be prompted here before your PDF is generated.</p>}
      <div><Button type="submit" disabled={busy || !sessionActive}>{busy ? 'Preparing…' : 'Generate PDF'}</Button></div>
    </form>
    <div className="flex flex-wrap items-center justify-between gap-3 border-t border-border-default pt-5"><h3 className="font-semibold">Recent exports</h3><Button variant="secondary" disabled={busy || loading || !sessionActive} onClick={() => { setError(''); void load() }}>Refresh status</Button></div>
    {loading && <p role="status">Loading exports…</p>}
    {pending && <StatusMessage tone="info">Your PDF is generating. Its status updates automatically while this popup is open.</StatusMessage>}
    {!loading && !items.length && <p className="text-sm text-text-secondary">No exports for this document yet.</p>}
    <ul className="divide-y divide-border-default">{items.map(item => {
      const expired = item.state === 'EXPIRED' || (item.expiresAt != null && new Date(item.expiresAt).getTime() <= Date.now())
      return <li key={item.id} className="grid min-w-0 gap-2 py-4"><div className="flex flex-wrap justify-between gap-3"><h4 className="font-semibold">{label(item.type)} · PDF</h4><span className="text-sm">{expired ? 'EXPIRED' : item.state}</span></div>
        <p className="break-words text-sm">{item.purpose}</p>
        <p className="text-xs text-text-secondary">Requested: {new Date(item.createdAt).toLocaleString('en-PH', { timeZone: 'Asia/Manila' })} Manila</p>
        <p className="text-xs text-text-secondary">Expires: {item.expiresAt ? `${new Date(item.expiresAt).toLocaleString('en-PH', { timeZone: 'Asia/Manila' })} Manila` : '24 hours after generation'}</p>
        {item.state === 'FAILED' && <p role="alert" className="text-sm">Generation failed. Generate a new PDF to try again.</p>}
        {expired && <p className="text-sm text-text-secondary">This download has expired. Generate a new PDF above.</p>}
        {item.state === 'REVOKED' && <p className="text-sm text-text-secondary">Access to this document has been revoked.</p>}
        {item.state === 'READY' && !expired && <div><Button disabled={busy || !sessionActive} onClick={() => void download(item)}><Download size={16} aria-hidden="true" />Download PDF</Button></div>}
      </li>
    })}</ul>
    {hasMore && <Button variant="secondary" disabled={loading || busy || !sessionActive} onClick={() => void load(page + 1)}>Load more exports</Button>}
  </section>{dialog}</>
}
