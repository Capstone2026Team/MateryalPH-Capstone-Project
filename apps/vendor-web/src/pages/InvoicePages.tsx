import { AsyncLoading } from '@materyalph/web-ui'
import { manilaToday, shouldRotateIdempotencyKey } from '@materyalph/web-ui'
import { cloneElement, useCallback, useEffect, useId, useRef, useState, type ReactElement } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import { ArrowUpRight, Check, FileCheck2, FileClock, FileText, MessageSquare, ReceiptText, RefreshCw, Save, Send, Upload } from 'lucide-react'
import { serializeDate } from '@materyalph/api-client-ts'
import {
  Button, DateFilter, ConfirmDialog, DeadlineCountdown, FileSelectionField, FilterTabs, FormDialog, InvoicePresetFields, type InvoicePresetValues, EmptyState, InvoiceRecordList, Pagination, PlatformDocumentNotice, StatCard, StatusBadge, StatusMessage, formatManilaDateTime, formatPesoCentavos, InvoiceWorkspace, InvoiceListItem, InvoiceDetailSummary, InvoiceSelectionPlaceholder,
} from '@materyalph/web-ui'
import {
  disputeApiBasePath, explainDifference, getOrderInvoices, listInvoices, uploadInvoice, saveInvoicePreset, sendInvoice, getInvoicePreset,
  type InvoiceListMeta, type InvoiceLogRow, type InvoiceView, type VendorOrderInvoices,
} from '../lib/disputes-api'
import { pesoInputToCentavos, readableOrderError, orderFieldErrors } from '../lib/orders-api'
import { newIdempotencyKey } from '../lib/onboarding-api'
import { storeName } from '../lib/catalog-access'
import { useOnboardingSnapshot } from '../lib/vendor-status'
import { ErrorState, LoadingState, PageHeader, VendorShell } from './PhaseThreeVendorPages'
import { dateRangeFromParams, dateRangePatch } from '../lib/date-filters'

const control = 'min-h-12 w-full min-w-0 rounded-control border border-border-default bg-surface-primary px-3 text-base font-normal'
const VIEWS: { value: InvoiceView; label: string }[] = [
  { value: 'REQUESTS', label: 'Buyer requests' }, { value: 'DUE', label: 'No copy yet' }, { value: 'RECORDS', label: 'Uploaded copies' }, { value: 'RECONCILIATION', label: 'Amount mismatches' },
]
const REQUEST_STATES: Record<string, string> = { REQUESTED: 'Requested', UPLOADED: 'Uploaded', DOWNLOADED: 'Downloaded by the Buyer', RETURNED_FOR_CORRECTION: 'Returned for correction', CLOSED: 'Closed' }

export function VendorInvoicesPage() {
  const { snapshot, loading, error, refresh } = useOnboardingSnapshot()
  if (loading) return <VendorShell activeHref="/invoices" accountLabel="Vendor" navigationData={null}><LoadingState label="Loading invoices…" /></VendorShell>
  if (error || !snapshot) return <VendorShell activeHref="/invoices" accountLabel="Vendor" navigationData={null}><ErrorState message={error ?? 'Invoices are unavailable.'} onRetry={() => void refresh()} /></VendorShell>
  return <VendorShell activeHref="/invoices" accountLabel={storeName(snapshot)} navigationData={snapshot}>
    {snapshot.permissions.includes('invoices.view') ? <InvoicesWorkspace canManagePresets={snapshot.permissions.includes('invoices.upload')} /> : <StatusMessage tone="error">E-Invoices are not available to your role.</StatusMessage>}
  </VendorShell>
}

function InvoicesWorkspace({ canManagePresets }: { canManagePresets: boolean }) {
  const [params, setParams] = useSearchParams()
  const view = (VIEWS.some(item => item.value === params.get('view')) ? params.get('view') : 'REQUESTS') as InvoiceView
  const range = dateRangeFromParams(params)
  const page = Math.max(1, Number(params.get('page') ?? '1') || 1)
  const update = (patch: Record<string, string>) => setParams(current => {
    const next = new URLSearchParams(current)
    for (const [key, value] of Object.entries(patch)) { if (value) next.set(key, value); else next.delete(key) }
    if (!('page' in patch)) next.delete('page')
    return next
  }, { replace: true })
  const [rows, setRows] = useState<InvoiceLogRow[] | null>(null)
  const [meta, setMeta] = useState<InvoiceListMeta | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  const [selectedId, setSelectedId] = useState<string | null>(null)
  const [notice, setNotice] = useState<string | null>(null)
  const refreshList = useCallback(() => setAttempt(value => value + 1), [])
  const invoiceChanged = useCallback((text: string) => { setNotice(text); refreshList() }, [refreshList])
  useEffect(() => {
    let active = true
    setRows(null); setError(null); setSelectedId(null)
    listInvoices({ view, page, ...(range.from ? { from: range.from } : {}), ...(range.to ? { to: range.to } : {}) }).then(result => { if (active) { setRows(result.items); setMeta(result.meta) } }).catch(async cause => { const text = await readableOrderError(cause); if (active) setError(text) })
    return () => { active = false }
  }, [view, page, range.from, range.to, attempt])
  const rowKey = (row: InvoiceLogRow) => row.id ?? row.orderId ?? ''
  const selected = !error && rows ? rows.find(row => rowKey(row) === selectedId) ?? rows[0] : undefined
  const hasDates = Boolean(range.from || range.to)
  return <div className="grid min-w-0 gap-6">
    <PageHeader eyebrow="Store Operations" title="E-Invoices" description="Keep invoice copies, Buyer requests and corrections in one place." compact actions={canManagePresets ? <InvoicePresetSettings onSaved={refreshList} /> : undefined} />
    {notice && <StatusMessage tone="success">{notice}</StatusMessage>}
    <InvoiceWorkspace summary={<>
      <StatCard label="Buyer requests" value={meta?.counts?.REQUESTS ?? '—'} icon={<MessageSquare size={17} />} active={view === 'REQUESTS'} onClick={() => update({ view: 'REQUESTS' })} />
      <StatCard label="No copy yet" value={meta?.counts?.DUE ?? '—'} icon={<FileClock size={17} />} active={view === 'DUE'} onClick={() => update({ view: 'DUE' })} />
      <StatCard label="Uploaded copies" value={meta?.counts?.RECORDS ?? '—'} icon={<FileCheck2 size={17} />} active={view === 'RECORDS'} onClick={() => update({ view: 'RECORDS' })} />
    </>} list={<section aria-labelledby="invoice-list-heading" className="mp-card mp-invoice-list">
      <div className="mp-invoice-list-header"><div><h2 id="invoice-list-heading" className="text-base font-semibold">Invoice list</h2><p className="mt-1 text-xs text-text-secondary">{error ? 'Records unavailable' : rows === null ? 'Loading records…' : `${meta?.total ?? rows.length} ${meta?.total === 1 ? 'record' : 'records'} in this view`}</p></div><Button variant="quiet" onClick={refreshList} disabled={rows === null && !error}><RefreshCw size={15} aria-hidden="true" />Refresh</Button></div>
      <FilterTabs label="Invoice view" appearance="tabs" value={view} onChange={value => update({ view: value })} chips={VIEWS.map(item => ({ value: item.value, label: item.value === 'REQUESTS' ? 'Requests' : item.value === 'RECORDS' ? 'Uploaded' : item.label, count: meta?.counts?.[item.value] }))} />
      {view === 'RECONCILIATION' && <p className="text-xs leading-5 text-text-secondary">Invoice totals or VAT that do not match the accepted order.</p>}
      <div className="flex flex-wrap items-center justify-between gap-3"><DateFilter title={view === 'REQUESTS' ? 'Request dates' : view === 'DUE' ? 'Sale confirmation dates' : 'Invoice dates'} value={range} onChange={next => update(dateRangePatch(next))} /><span className="text-xs text-text-secondary">Dates filter this list. Overview shows all dates.</span></div>
      {error ? <ErrorState message={error} onRetry={refreshList} /> : rows === null ? <LoadingState label="Loading invoices…" />
        : rows.length === 0 ? <EmptyState icon={<ReceiptText size={24} aria-hidden="true" />} message={hasDates ? 'No invoices match these dates.' : view === 'REQUESTS' ? 'No Buyer copy or correction requests.' : view === 'DUE' ? 'Every confirmed sale has an uploaded invoice copy.' : view === 'RECONCILIATION' ? 'No unresolved amount mismatches.' : 'No invoice copies in this view.'} action={view === 'REQUESTS' && Boolean(meta?.counts?.DUE) ? <Button variant="secondary" onClick={() => update({ view: 'DUE' })}>View sales without copies</Button> : <Button variant="secondary" onClick={refreshList}>Refresh list</Button>} />
          : <ul className="mp-invoice-list-items" aria-label={VIEWS.find(item => item.value === view)?.label ?? 'Invoices'}>{rows.map(row => <InvoiceQueueItem key={rowKey(row)} row={row} view={view} selected={rowKey(row) === (selected ? rowKey(selected) : null)} onSelect={() => {
            setSelectedId(rowKey(row))
            if (window.matchMedia?.('(max-width: 1279px)').matches) document.getElementById('invoice-details')?.scrollIntoView({ block: 'start', behavior: 'instant' })
          }} />)}</ul>}
      {meta && (page > 1 || meta.hasMore) && <Pagination page={page} hasMore={Boolean(meta.hasMore)} total={meta.total ?? 0} busy={rows === null} onChange={next => update({ page: String(next) })} />}
    </section>} detail={selected?.orderId ? <OrderInvoicePanel key={selected.orderId} orderId={selected.orderId} workspace {...(view === 'RECORDS' || view === 'RECONCILIATION' ? { recordId: selected.id } : {})} onChanged={invoiceChanged} /> : <InvoiceSelectionPlaceholder />} />
  </div>
}

function InvoiceQueueItem({ row, view, selected, onSelect }: { row: InvoiceLogRow; view: InvoiceView; selected: boolean; onSelect: () => void }) {
  const metadata = view === 'REQUESTS'
    ? [{ label: 'Request', value: row.kind === 'CORRECTION' ? 'Correction' : 'Invoice copy' }, { label: 'Service target', value: row.serviceTargetLabel ?? 'Not recorded' }]
    : view === 'DUE'
      ? [{ label: 'Sale confirmed', value: row.acceptedAt ? formatManilaDateTime(row.acceptedAt) : 'Not recorded' }, { label: 'Order status', value: (row.orderState ?? '').replaceAll('_', ' ').toLowerCase() }]
      : [{ label: 'Invoice date', value: row.issuedOn ?? 'Not recorded' }, { label: 'Origin', value: row.originLabel ?? 'Not recorded' }]
  const status = view === 'REQUESTS'
    ? <StatusBadge label={row.overdue ? 'Past service target' : REQUEST_STATES[row.state ?? ''] ?? row.state ?? 'Requested'} tone={row.overdue ? 'error' : 'warning'} />
    : view === 'DUE'
      ? <StatusBadge label={row.openRequest ? 'Buyer requested copy' : 'No copy yet'} tone={row.openRequest ? 'warning' : 'neutral'} />
      : <StatusBadge label={row.reconciliationState === 'INVOICE_RECONCILIATION_REQUIRED' ? 'Review amount mismatch' : row.reconciliationState === 'EXPLAINED' ? 'Explained' : row.reconciliationState === 'CORRECTED' ? 'Corrected' : 'Copy uploaded'} tone={row.reconciliationState === 'INVOICE_RECONCILIATION_REQUIRED' ? 'warning' : 'success'} />
  return <InvoiceListItem title={row.invoiceNumber ?? row.orderReference ?? 'Order'} {...(view === 'DUE' && row.buyerName ? { reference: `Buyer: ${row.buyerName}` } : row.invoiceNumber && row.orderReference ? { reference: row.orderReference } : {})} selected={selected} onSelect={onSelect} metadata={metadata} status={status} {...(row.amountCentavos !== undefined ? { amount: formatPesoCentavos(row.amountCentavos) } : {})} />
}

/** Invoice copies, Buyer requests and the upload form on the order page; actions follow the caller's role. */
export function OrderInvoicePanel({ orderId, workspace = false, recordId, onChanged }: { orderId: string; workspace?: boolean; recordId?: string | undefined; onChanged?: (text: string) => void }) {
  const [data, setData] = useState<VendorOrderInvoices | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [notice, setNotice] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  const reload = useCallback(() => setAttempt(value => value + 1), [])
  const [sending, setSending] = useState(false)
  const [sendError, setSendError] = useState<string | null>(null)
  const [reviewedSelection, setReviewedSelection] = useState<string | null>(null)
  const sendKey = useRef({ value: newIdempotencyKey(), version: 0 })
  useEffect(() => {
    let active = true
    setError(null)
    getOrderInvoices(orderId).then(value => { if (active) setData(value) }).catch(async cause => { const text = await readableOrderError(cause); if (active) setError(text) })
    return () => { active = false }
  }, [orderId, attempt])
  const changed = (next: VendorOrderInvoices, text: string) => { setData(next); if (onChanged) onChanged(text); else setNotice(text) }
  const record = data?.records.find(item => item.id === recordId) ?? data?.records.at(-1)
  const showDraft = !recordId || !record || reviewedSelection === recordId
  async function send() {
    if (!data?.canSend || !data.draft || sending) return
    setSending(true); setSendError(null)
    if (sendKey.current.version !== data.draft.lockVersion) sendKey.current = { value: newIdempotencyKey(), version: data.draft.lockVersion }
    try {
      const next = await sendInvoice(orderId, data.draft.lockVersion, sendKey.current.value)
      sendKey.current = { value: newIdempotencyKey(), version: 0 }
      changed(next, 'Invoice copy sent to the Buyer. This version is now locked.')
    } catch (cause) {
      if (shouldRotateIdempotencyKey(cause)) sendKey.current = { value: newIdempotencyKey(), version: 0 }
      setSendError(await readableOrderError(cause))
    } finally { setSending(false) }
  }
  const sendButton = data?.canOpenFiles && <Button disabled={!data.canSend || sending || !showDraft} onClick={() => void send()}>{data.records.length > 0 && !data.canUpload ? <Check size={15} aria-hidden="true" /> : <Send size={15} aria-hidden="true" />}{sending ? 'Sending…' : data.records.length > 0 && !data.canUpload ? 'Sent' : 'Send'}</Button>
  return <section id="invoices" aria-label={workspace ? 'Invoice details' : undefined} aria-labelledby={workspace ? undefined : 'invoice-heading'} className={workspace ? 'mp-invoice-sheet' : 'grid min-w-0 gap-4 mp-card mp-card-padded'}>
    {!workspace && <div className="flex min-w-0 flex-wrap items-start justify-between gap-3">
      <h2 id="invoice-heading" className="flex min-w-0 items-center gap-2 text-lg font-semibold"><FileText size={18} className="shrink-0" aria-hidden="true" />Invoices</h2>
      {data && <StatusBadge label={data.status === 'ISSUED' ? 'Copy uploaded' : data.status === 'NOT_YET_UPLOADED' ? 'No copy uploaded yet' : 'Not due yet'} tone={data.status === 'NOT_YET_UPLOADED' ? 'warning' : 'neutral'} />}
    </div>}
    {error ? <ErrorState message={error} onRetry={reload} /> : !data ? <AsyncLoading compact label="Loading invoices…" /> : <>
      {workspace && <InvoiceDetailSummary data={data} showDraft={showDraft} {...(record ? { record } : {})} apiBasePath={disputeApiBasePath} recordAction={record?.canExplain ? <ExplainAction orderId={orderId} recordId={record.id} onChanged={changed} /> : null} actions={<div className="flex flex-wrap items-center gap-2">{sendButton}<Link to={`/orders/${orderId}#invoices`} className="inline-flex min-h-11 items-center gap-1.5 text-xs font-semibold text-action-primary underline-offset-4 hover:underline focus-visible:outline-2 focus-visible:outline-focus-ring">View order<ArrowUpRight size={14} aria-hidden="true" /></Link></div>} />}
      {!workspace && sendButton}
      {sendError && <StatusMessage tone="error">{sendError}</StatusMessage>}
      {!workspace && <p className="max-w-3xl text-sm leading-6 text-text-secondary">{data.issuanceNotice}</p>}
      {notice && <StatusMessage tone="success">{notice}</StatusMessage>}
      {data.requests.filter(request => request.state !== 'CLOSED').map(request => <div key={request.id} className="grid gap-2 rounded-control border border-amber-300 bg-amber-50 p-3 text-sm text-amber-950">
        <p className="font-semibold">The Buyer requested an invoice {request.kind === 'CORRECTION' ? 'correction' : 'copy'} · {REQUEST_STATES[request.state] ?? request.state}</p>
        {request.details && <p className="whitespace-pre-line">{request.details}</p>}
        {(request.state === 'REQUESTED' || request.state === 'RETURNED_FOR_CORRECTION') && <DeadlineCountdown at={request.serviceTargetAt} label="Service target in" endedLabel="Past the service target" />}
        <p className="text-xs">The three-business-day target is a document-service goal. It never extends your legal deadline to issue the invoice.</p>
      </div>)}
      {!workspace && data.billingDetails && <dl className="grid gap-1 rounded-control bg-surface-canvas p-3 text-sm">
        <div className="flex flex-wrap justify-between gap-x-3"><dt className="text-text-secondary">Bill to</dt><dd className="font-semibold">{data.billingDetails.billingName}</dd></div>
        <div className="flex flex-wrap justify-between gap-x-3"><dt className="text-text-secondary">Address</dt><dd className="font-semibold">{data.billingDetails.billingAddress}</dd></div>
        {(data.billingDetails.tin || data.billingDetails.tinMasked) && <div className="flex flex-wrap justify-between gap-x-3"><dt className="text-text-secondary">Buyer TIN</dt><dd className="font-semibold tabular-nums">{data.billingDetails.tin ?? data.billingDetails.tinMasked}</dd></div>}
      </dl>}
      {(!workspace || data.records.length > 1 || !data.canOpenFiles || !data.canUpload) && <div className="grid min-w-0 gap-2">
        {workspace ? data.records.length > 1 && <details><summary className="min-h-11 cursor-pointer py-3 text-sm font-semibold focus-visible:outline-2 focus-visible:outline-focus-ring">All invoice copies ({data.records.length})</summary><InvoiceRecordList records={data.records} apiBasePath={disputeApiBasePath} renderAction={item => item.canExplain ? <ExplainAction orderId={orderId} recordId={item.id} onChanged={changed} /> : null} /></details> : <InvoiceRecordList records={data.records} apiBasePath={disputeApiBasePath} renderAction={item => item.canExplain ? <ExplainAction orderId={orderId} recordId={item.id} onChanged={changed} /> : null} />}
        {!data.canOpenFiles && data.records.length > 0 && <p className="text-xs leading-5 text-text-secondary">Your role can see invoice status but not open the official file.</p>}
        {!data.canUpload && !data.canOpenFiles && <p className="text-sm leading-6 text-text-secondary">The Owner, Store Manager or Store Staff upload the official invoice copy.</p>}
      </div>}
      {data.canUpload && <UploadForm key={data.draft?.lockVersion ?? 0} data={data} onReview={() => setReviewedSelection(recordId ?? null)} onChanged={changed} />}
      {!data.canUpload && data.canOpenFiles && data.records.length > 0 && <p className="text-xs leading-5 text-text-secondary">This sent version is locked. A Buyer return or correction request allows you to prepare a new version; earlier copies stay in the history.</p>}
      <div className="grid min-w-0 gap-3 border-t border-border-default pt-4"><h3 className="text-sm font-semibold">MateryalPH documents</h3><PlatformDocumentNotice documents={data.platformDocuments} orderId={orderId} apiBasePath={disputeApiBasePath} onRefresh={reload} />{workspace && <p className="text-xs leading-5 text-text-secondary">{data.issuanceNotice}</p>}</div>
    </>}
  </section>
}

function ExplainAction({ orderId, recordId, onChanged }: { orderId: string; recordId: string; onChanged: (data: VendorOrderInvoices, text: string) => void }) {
  const [open, setOpen] = useState(false)
  const [note, setNote] = useState('')
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState<string | null>(null)
  return <>
    <Button variant="quiet" onClick={() => setOpen(true)}>Explain amount mismatch</Button>
    <ConfirmDialog open={open} tone="primary" busy={busy} title="Explain the invoice amount mismatch" confirmLabel="Save explanation" onCancel={() => setOpen(false)} onConfirm={() => void (async () => {
      if (note.trim().length < 10) { setError('Explain in at least 10 characters.'); return }
      setBusy(true); setError(null)
      try { onChanged(await explainDifference(orderId, recordId, note.trim()), 'Explanation saved. The Buyer\'s agreed amount is unchanged.'); setOpen(false) } catch (cause) { setError(await readableOrderError(cause)) } finally { setBusy(false) }
    })()}>
      <p className="text-text-secondary">Explain why the invoice total or VAT does not match the accepted order. The Buyer's agreed amount stays unchanged.</p>
      <label className="grid gap-2 text-sm font-semibold text-text-strong">Explanation<textarea className={`${control} min-h-20 py-2`} maxLength={2000} value={note} onChange={event => setNote(event.target.value)} /></label>
      {error && <p role="alert" className="text-sm text-status-error">{error}</p>}
    </ConfirmDialog>
  </>
}

/** Labels one control; the hint and error stay outside the accessible name and are linked through aria-describedby. */
function FieldShell({ label, error, children, hint }: { label: string; error?: string | undefined; children: ReactElement<Record<string, unknown>>; hint?: string }) {
  const id = useId()
  const described = [hint ? `${id}-hint` : '', error ? `${id}-error` : ''].filter(Boolean).join(' ')
  return <div className="grid min-w-0 gap-2 text-sm font-semibold">
    <label htmlFor={id}>{label}</label>
    {cloneElement(children, { id, ...(described ? { 'aria-describedby': described } : {}), ...(error ? { 'aria-invalid': true } : {}) })}
    {hint && <span id={`${id}-hint`} className="text-xs font-normal text-text-secondary">{hint}</span>}
    {error && <span id={`${id}-error`} role="alert" className="text-sm font-normal text-status-error">{error}</span>}
  </div>
}

function UploadForm({ data, onChanged, onReview }: { data: VendorOrderInvoices; onReview: () => void; onChanged: (data: VendorOrderInvoices, text: string) => void }) {
  const today = manilaToday()
  const draft = data.draft
  const unsent = draft && !draft.sentRecordId
  const formId = useId()
  const [open, setOpen] = useState(false)
  const [type, setType] = useState<string>(draft?.invoiceType ?? data.preset?.invoiceType ?? 'VENDOR_GOODS_INVOICE')
  const [issuer, setIssuer] = useState(draft?.issuerName ?? data.preset?.issuerName ?? data.issuerName)
  const [number, setNumber] = useState(unsent ? draft.invoiceNumber : '')
  const [issuedOn, setIssuedOn] = useState(unsent ? serializeDate(draft.issuedOn)! : today)
  const [amount, setAmount] = useState(unsent ? (draft.amountCentavos / 100).toFixed(2) : '')
  const [vat, setVat] = useState(unsent && draft.vatCentavos != null ? (draft.vatCentavos / 100).toFixed(2) : '')
  const [lines, setLines] = useState<string[]>(draft?.relatedLineIds ?? [])
  const [source, setSource] = useState<string>(draft?.sourceSystem ?? data.preset?.sourceSystem ?? 'REGISTERED_CAS')
  const [method, setMethod] = useState<string>(draft?.invoicingMethod ?? data.preset?.invoicingMethod ?? 'COMPUTERIZED')
  const [amends, setAmends] = useState(draft?.amendsInvoiceRecordId ?? data.records.at(-1)?.id ?? '')
  const [file, setFile] = useState<File | null>(null)
  const [errors, setErrors] = useState<Record<string, string>>({})
  const [message, setMessage] = useState<string | null>(null)
  const [presetNotice, setPresetNotice] = useState<string | null>(null)
  const [presetVersion, setPresetVersion] = useState(data.preset?.lockVersion ?? 0)
  const [busy, setBusy] = useState(false)
  const key = useRef({ value: newIdempotencyKey(), body: '' })
  const presetKey = useRef({ value: newIdempotencyKey(), body: '' })
  async function savePreset() {
    setBusy(true); setMessage(null); setPresetNotice(null)
    const input = { invoiceType: type, issuerName: issuer.trim(), sourceSystem: source, invoicingMethod: method, lockVersion: presetVersion }
    const body = JSON.stringify(input)
    if (presetKey.current.body !== body) presetKey.current = { value: newIdempotencyKey(), body }
    try {
      const saved = await saveInvoicePreset(input, presetKey.current.value)
      setPresetVersion(saved.lockVersion); setPresetNotice('Preset saved for this store. New invoice dates default to today.')
      presetKey.current = { value: newIdempotencyKey(), body: '' }
    } catch (cause) {
      if (shouldRotateIdempotencyKey(cause)) presetKey.current = { value: newIdempotencyKey(), body: '' }
      setMessage(await readableOrderError(cause))
    } finally { setBusy(false) }
  }
  async function submit() {
    const local: Record<string, string> = {}
    const centavos = pesoInputToCentavos(amount)
    const vatCentavos = vat.trim() ? pesoInputToCentavos(vat) : undefined
    if (!issuer.trim()) local.issuer = 'Enter the issuer exactly as printed.'
    if (!/^[A-Za-z0-9][A-Za-z0-9 \-/#.]*$/.test(number.trim())) local.number = 'Enter the invoice number as printed.'
    if (!issuedOn || issuedOn > today) local.issued_on = 'Choose an invoice date no later than today.'
    if (centavos === null) local.amount = 'Enter the invoice total.'
    if (vatCentavos === null) local.vat = 'Enter a valid VAT amount or leave it blank.'
    if (type === 'VENDOR_ADJUSTMENT_DOCUMENT' && !amends) local.amends = 'Choose the invoice this document adjusts.'
    if (!file && !draft) local.file = 'Attach the PDF, JPG or PNG copy.'
    setErrors(local)
    if (Object.keys(local).length) { setMessage('Check the highlighted fields.'); return }
    setBusy(true); setMessage(null)
    const input = { invoiceType: type, issuerName: issuer.trim(), invoiceNumber: number.trim(), issuedOn: new Date(`${issuedOn}T00:00:00`), amountCentavos: centavos!,
      ...(vatCentavos !== undefined && vatCentavos !== null ? { vatCentavos } : {}), relatedLineIds: lines, sourceSystem: source, invoicingMethod: method,
      ...(amends ? { amendsInvoiceRecordId: amends } : {}), ...(file ? { file } : {}), lockVersion: draft?.lockVersion ?? 0 }
    const body = JSON.stringify({ ...input, file: file ? [file.name, file.size, file.lastModified] : null })
    if (key.current.body !== body) key.current = { value: newIdempotencyKey(), body }
    try {
      const next = await uploadInvoice(data.orderId, input, key.current.value)
      key.current = { value: newIdempotencyKey(), body: '' }; setOpen(false)
      onChanged(next, 'Invoice copy uploaded. Review the details, then select Send to share it with the Buyer.')
    } catch (cause) {
      if (shouldRotateIdempotencyKey(cause)) key.current = { value: newIdempotencyKey(), body: '' }
      setErrors(await orderFieldErrors(cause)); setMessage(await readableOrderError(cause))
    } finally { setBusy(false) }
  }
  return <>
    <Button variant="secondary" className="w-fit" onClick={() => { onReview(); setOpen(true) }}>{unsent ? <Check size={17} className="text-status-success" aria-hidden="true" /> : <Upload size={16} aria-hidden="true" />}{unsent ? 'Review uploaded copy' : 'Upload invoice copy'}</Button>
    <FormDialog open={open} title="Upload invoice copy" description="Prepare and review your copy here. The Buyer receives it only after you select Send." size="compact" busy={busy} onClose={() => setOpen(false)} footer={<div className="flex flex-wrap justify-end gap-3"><Button variant="secondary" disabled={busy} onClick={() => setOpen(false)}>Cancel</Button><Button type="submit" form={formId} disabled={busy}>{busy ? 'Saving…' : unsent ? 'Save changes' : 'Upload copy'}</Button></div>}>
      <form id={formId} className="grid min-w-0 gap-5" noValidate aria-label="Upload invoice copy" onSubmit={event => { event.preventDefault(); void submit() }}>
        {message && <StatusMessage tone="error">{message}</StatusMessage>}
        {presetNotice && <StatusMessage tone="success">{presetNotice}</StatusMessage>}
        <section className="grid gap-4" aria-label="Invoice preset">
          <div className="flex flex-wrap items-center justify-between gap-3"><div><h3 className="text-sm font-semibold">Invoice preset</h3><p className="mt-1 text-xs leading-5 text-text-secondary">Reuse these business details. You can change them any time.</p></div><Button variant="secondary" disabled={busy} onClick={() => void savePreset()}><Save size={15} aria-hidden="true" />Save preset</Button></div>
          <InvoicePresetFields value={{ invoiceType: type, issuerName: issuer, sourceSystem: source, invoicingMethod: method }} onChange={next => { setType(next.invoiceType); setIssuer(next.issuerName); setSource(next.sourceSystem); setMethod(next.invoicingMethod) }} registeredName={data.issuerName} disabled={busy} issuerError={errors.issuer_name ?? errors.issuer} invoiceTypes={data.invoiceTypes} sourceSystems={data.sourceSystems} invoicingMethods={data.invoicingMethods} />
          <p className="text-xs leading-5 text-text-secondary">New invoice dates start with today. Invoice numbers and amounts are entered for each copy.</p>
        </section>
        <fieldset className="grid gap-4 border-t border-border-default pt-5" aria-label="This invoice" disabled={busy}>
          <h3 className="text-sm font-semibold">This invoice</h3>
          <div className="grid gap-4 sm:grid-cols-2">
            <FieldShell label="Invoice number" error={errors.invoice_number ?? errors.number}><input className={control} value={number} maxLength={64} onChange={event => setNumber(event.target.value)} /></FieldShell>
            <FieldShell label="Invoice date" error={errors.issued_on}><input type="date" className={control} max={today} value={issuedOn} onChange={event => setIssuedOn(event.target.value)} /></FieldShell>
            <FieldShell label="Invoice total (₱)" error={errors.amount_centavos ?? errors.amount}><input className={control} inputMode="decimal" placeholder="0.00" value={amount} onChange={event => setAmount(event.target.value)} /></FieldShell>
            <FieldShell label="VAT shown (₱, optional)" error={errors.vat_centavos ?? errors.vat}><input className={control} inputMode="decimal" placeholder="0.00" value={vat} onChange={event => setVat(event.target.value)} /></FieldShell>
            {data.records.length > 0 && <FieldShell label="Corrects invoice" error={errors.amends_invoice_record_id ?? errors.amends}><select className={control} value={amends} onChange={event => setAmends(event.target.value)}>{data.records.map(record => <option key={record.id} value={record.id}>{record.invoiceNumber}</option>)}</select></FieldShell>}
          </div>
          {data.lines.length > 1 && <fieldset className="grid gap-2"><legend className="text-sm font-semibold">Lines covered (leave unchecked for the whole order)</legend>{data.lines.map(line => <label key={line.orderLineId} className="flex min-h-11 items-center gap-3 text-sm"><input type="checkbox" className="h-5 w-5 accent-action-primary" checked={lines.includes(line.orderLineId)} onChange={event => setLines(current => event.target.checked ? [...current, line.orderLineId] : current.filter(id => id !== line.orderLineId))} />{line.displayName}</label>)}</fieldset>}
        </fieldset>
        {draft && <p className="flex items-center gap-2 text-sm"><Check size={16} className="text-status-success" aria-hidden="true" />Current copy: {draft.fileName ?? 'Invoice document'}. Choose another file to replace it.</p>}
        <FileSelectionField label="Copy (PDF, JPG or PNG)" accept="application/pdf,image/png,image/jpeg" hint="Upload the issued invoice copy. It stays private until sent." file={file} disabled={busy} required={!draft} error={errors.file} onChange={setFile} />
        <p className="text-xs leading-5 text-text-secondary">TEST documents remain DEMO samples. Sending locks this version and never changes the Buyer’s accepted order amount.</p>
      </form>
    </FormDialog>
  </>
}

function InvoicePresetSettings({ onSaved }: { onSaved: () => void }) {
  const [open, setOpen] = useState(false)
  const [value, setValue] = useState<InvoicePresetValues | null>(null)
  const [registeredName, setRegisteredName] = useState('')
  const [version, setVersion] = useState(0)
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<string | null>(null)
  const key = useRef({ value: newIdempotencyKey(), body: '' })
  async function load() {
    setOpen(true); setBusy(true); setMessage(null); setValue(null)
    try {
      const saved = await getInvoicePreset()
      setValue(saved); setRegisteredName(saved.issuerName); setVersion(saved.lockVersion)
    } catch (cause) { setMessage(await readableOrderError(cause)) } finally { setBusy(false) }
  }
  async function save() {
    if (!value || busy) return
    setBusy(true); setMessage(null)
    const input = { ...value, lockVersion: version }
    const body = JSON.stringify(input)
    if (key.current.body !== body) key.current = { value: newIdempotencyKey(), body }
    try {
      const saved = await saveInvoicePreset(input, key.current.value)
      setValue(saved); setVersion(saved.lockVersion); setOpen(false)
      onSaved()
      window.dispatchEvent(new Event('materyalph:domain-refresh'))
    } catch (cause) {
      if (shouldRotateIdempotencyKey(cause)) key.current = { value: newIdempotencyKey(), body: '' }
      setMessage(await readableOrderError(cause))
    } finally { setBusy(false) }
  }
  return <><Button variant="secondary" onClick={() => void load()}><Save size={16} aria-hidden="true" />Invoice preset</Button><FormDialog open={open} title="Invoice preset" description="Save business defaults for your store. New invoice dates start with today. Sent invoices stay unchanged." size="compact" busy={busy} onClose={() => setOpen(false)} footer={<div className="flex flex-wrap justify-end gap-3"><Button variant="secondary" disabled={busy} onClick={() => setOpen(false)}>Cancel</Button><Button disabled={busy || !value} onClick={() => void save()}>Save preset</Button></div>}>{message && <StatusMessage tone="error">{message}</StatusMessage>}{value ? <InvoicePresetFields value={value} onChange={setValue} registeredName={registeredName} disabled={busy} /> : <p className="text-sm text-text-secondary">{busy ? 'Loading preset…' : 'The preset could not load.'}</p>}{!busy && !value && <Button variant="secondary" onClick={() => void load()}>Try again</Button>}</FormDialog></>
}
