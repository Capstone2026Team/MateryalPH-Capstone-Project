import { manilaToday, shouldRotateIdempotencyKey } from '@materyalph/web-ui'
import { cloneElement, useCallback, useEffect, useId, useRef, useState, type ReactElement } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import { FileText, ReceiptText, Upload } from 'lucide-react'
import {
  ActiveFilters, ALL_DATES, Button, DateFilter, ConfirmDialog, DeadlineCountdown, FileSelectionField, FilterTabs, InfoNote, EmptyState, InvoiceRecordList, Pagination, PlatformDocumentNotice, ResponsiveRecordList, StatusBadge, StatusMessage, Toolbar, dateFilterLabel, formatManilaDateTime, formatPesoCentavos, type RecordColumn,
} from '@materyalph/web-ui'
import {
  disputeApiBasePath, explainDifference, getOrderInvoices, listInvoices, uploadInvoice,
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
  { value: 'REQUESTS', label: 'Buyer requests' }, { value: 'DUE', label: 'No copy yet' }, { value: 'RECORDS', label: 'Uploaded copies' }, { value: 'RECONCILIATION', label: 'Differences' },
]
const REQUEST_STATES: Record<string, string> = { REQUESTED: 'Requested', UPLOADED: 'Uploaded', DOWNLOADED: 'Downloaded by the Buyer', RETURNED_FOR_CORRECTION: 'Returned for correction', CLOSED: 'Closed' }
const SOURCE_LABELS: Record<string, string> = { REGISTERED_CAS: 'Registered CAS / accounting system', BIR_EIS: 'BIR EIS', LOOSE_LEAF_OR_PRINTED: 'Loose-leaf or printed (ATP)', OTHER_REGISTERED: 'Other registered process' }
const METHOD_LABELS: Record<string, string> = { ELECTRONIC: 'Electronic', COMPUTERIZED: 'Computerized', MANUAL: 'Manual' }

export function VendorInvoicesPage() {
  const { snapshot, loading, error, refresh } = useOnboardingSnapshot()
  if (loading) return <VendorShell activeHref="/invoices" accountLabel="Vendor" navigationData={null}><LoadingState label="Loading invoices…" /></VendorShell>
  if (error || !snapshot) return <VendorShell activeHref="/invoices" accountLabel="Vendor" navigationData={null}><ErrorState message={error ?? 'Invoices are unavailable.'} onRetry={() => void refresh()} /></VendorShell>
  return <VendorShell activeHref="/invoices" accountLabel={storeName(snapshot)} navigationData={snapshot}>
    {snapshot.permissions.includes('invoices.view') ? <InvoicesWorkspace /> : <StatusMessage tone="error">E-Invoices are not available to your role.</StatusMessage>}
  </VendorShell>
}

function InvoicesWorkspace() {
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
  useEffect(() => {
    let active = true
    setRows(null); setError(null)
    listInvoices({ view, page, ...(range.from ? { from: range.from } : {}), ...(range.to ? { to: range.to } : {}) }).then(result => { if (active) { setRows(result.items); setMeta(result.meta) } }).catch(async cause => { const text = await readableOrderError(cause); if (active) setError(text) })
    return () => { active = false }
  }, [view, page, range.from, range.to, attempt])
  const orderLink = (row: InvoiceLogRow) => <Link to={`/orders/${row.orderId ?? ''}#invoices`} className="font-semibold text-action-primary underline-offset-4 hover:underline">{row.orderReference ?? 'Order'}</Link>
  const columns: RecordColumn<InvoiceLogRow>[] = view === 'REQUESTS' ? [
    { key: 'order', header: 'Order', cell: orderLink },
    { key: 'kind', header: 'Request', cell: row => <span className="grid gap-0.5"><span className="font-semibold">{row.kind === 'CORRECTION' ? 'Correction' : 'Copy'}</span><span className="text-xs text-text-secondary">{row.details}</span></span> },
    { key: 'state', header: 'Status', cell: row => <span className="grid justify-items-start gap-1"><StatusBadge label={REQUEST_STATES[row.state ?? ''] ?? row.state ?? ''} tone={row.overdue ? 'error' : row.state === 'REQUESTED' || row.state === 'RETURNED_FOR_CORRECTION' ? 'warning' : 'success'} />{row.overdue && <span className="text-xs font-semibold text-status-error">Past the service target</span>}</span> },
    { key: 'target', header: 'Service target', cell: row => <span className="text-sm">{row.serviceTargetLabel ?? '—'}</span> },
  ] : view === 'DUE' ? [
    { key: 'order', header: 'Order', cell: orderLink },
    { key: 'state', header: 'Order status', cell: row => (row.orderState ?? '').replaceAll('_', ' ').toLowerCase() },
    { key: 'accepted', header: 'Sale confirmed', cell: row => row.acceptedAt ? formatManilaDateTime(row.acceptedAt) : '—' },
    { key: 'request', header: 'Buyer request', cell: row => row.openRequest ? <StatusBadge label="Open request" tone="warning" /> : <span className="text-text-secondary">None</span> },
  ] : [
    { key: 'order', header: 'Order', cell: orderLink },
    { key: 'invoice', header: 'Invoice', cell: row => <span className="grid gap-0.5"><span className="font-semibold">{row.invoiceNumber}</span><span className="text-xs text-text-secondary">{row.issuedOn} · {row.originLabel}</span></span> },
    { key: 'amount', header: 'Amount', cell: row => <span className="tabular-nums">{formatPesoCentavos(row.amountCentavos ?? 0)}</span> },
    { key: 'recon', header: 'Reconciliation', cell: row => row.reconciliationState === 'INVOICE_RECONCILIATION_REQUIRED' ? <StatusBadge label={`Differs by ${formatPesoCentavos(row.reconciliationDifferenceCentavos ?? 0)}`} tone="warning" /> : <span className="text-sm">{(row.reconciliationState ?? '').replaceAll('_', ' ').toLowerCase()}</span> },
  ]
  return <div className="grid min-w-0 gap-6">
    <PageHeader eyebrow="Store Operations" title="E-Invoices" description="Manage invoice copies and Buyer copy or correction requests." />
    <InfoNote>MateryalPH never assigns an official invoice number; an uploaded PDF is not proof of BIR compliance. {meta?.issuanceNotice}</InfoNote>
    <FilterTabs label="Invoice view" value={view} onChange={value => update({ view: value })} chips={VIEWS.map(item => ({ value: item.value, label: item.label, count: meta?.counts?.[item.value] }))} />
    <Toolbar filters={<DateFilter title={view === 'REQUESTS' ? 'Request dates' : view === 'DUE' ? 'Sale confirmation dates' : 'Invoice dates'} value={range} onChange={next => update(dateRangePatch(next))} />} />
    <ActiveFilters filters={range.from || range.to ? [{ key: 'dates', label: dateFilterLabel(range), onRemove: () => update(dateRangePatch(ALL_DATES)) }] : []} onClear={() => update(dateRangePatch(ALL_DATES))} />
    {error ? <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} /> : rows === null ? <LoadingState label="Loading invoices…" />
      : rows.length === 0 ? <EmptyState icon={<ReceiptText size={24} aria-hidden="true" />} message={view === 'REQUESTS' ? 'No Buyer copy or correction requests.' : view === 'DUE' ? 'Every confirmed sale has an uploaded invoice copy.' : 'No invoice copies in this view.'} action={<Button variant="secondary" onClick={() => setAttempt(value => value + 1)}>Retry</Button>} />
        : <ResponsiveRecordList caption={VIEWS.find(item => item.value === view)?.label ?? 'Invoices'} rows={rows} columns={columns} rowKey={row => row.id ?? row.orderId ?? ''} cardTitle={orderLink} />}
    {meta && (page > 1 || meta.hasMore) && <Pagination page={page} hasMore={Boolean(meta.hasMore)} total={meta.total ?? 0} busy={rows === null} onChange={next => update({ page: String(next) })} />}
  </div>
}

/** Invoice copies, Buyer requests and the upload form on the order page; actions follow the caller's role. */
export function OrderInvoicePanel({ orderId }: { orderId: string }) {
  const [data, setData] = useState<VendorOrderInvoices | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [notice, setNotice] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  const reload = useCallback(() => setAttempt(value => value + 1), [])
  useEffect(() => {
    let active = true
    getOrderInvoices(orderId).then(value => { if (active) setData(value) }).catch(async cause => { const text = await readableOrderError(cause); if (active) setError(text) })
    return () => { active = false }
  }, [orderId, attempt])
  const changed = (next: VendorOrderInvoices, text: string) => { setData(next); setNotice(text) }
  return <section id="invoices" aria-labelledby="invoice-heading" className="grid min-w-0 gap-4 rounded-surface border border-border-default bg-surface-primary p-4 sm:p-5">
    <div className="flex min-w-0 flex-wrap items-start justify-between gap-3">
      <h2 id="invoice-heading" className="flex min-w-0 items-center gap-2 text-lg font-semibold"><FileText size={18} className="shrink-0" aria-hidden="true" />Invoices</h2>
      {data && <StatusBadge label={data.status === 'ISSUED' ? 'Copy uploaded' : data.status === 'NOT_YET_UPLOADED' ? 'No copy uploaded yet' : 'Not due yet'} tone={data.status === 'NOT_YET_UPLOADED' ? 'warning' : 'neutral'} />}
    </div>
    {error ? <ErrorState message={error} onRetry={reload} /> : !data ? <p className="text-sm text-text-secondary">Loading invoices…</p> : <>
      <p className="max-w-3xl text-sm leading-6 text-text-secondary">{data.issuanceNotice}</p>
      {notice && <StatusMessage tone="success">{notice}</StatusMessage>}
      {data.requests.filter(request => request.state !== 'CLOSED').map(request => <div key={request.id} className="grid gap-2 rounded-control border border-amber-300 bg-amber-50 p-3 text-sm text-amber-950">
        <p className="font-semibold">The Buyer requested an invoice {request.kind === 'CORRECTION' ? 'correction' : 'copy'} · {REQUEST_STATES[request.state] ?? request.state}</p>
        {request.details && <p className="whitespace-pre-line">{request.details}</p>}
        {(request.state === 'REQUESTED' || request.state === 'RETURNED_FOR_CORRECTION') && <DeadlineCountdown at={request.serviceTargetAt} label="Service target in" endedLabel="Past the service target" />}
        <p className="text-xs">The three-business-day target is a document-service goal. It never extends your legal deadline to issue the invoice.</p>
      </div>)}
      {data.billingDetails && <dl className="grid gap-1 rounded-control bg-surface-canvas p-3 text-sm">
        <div className="flex flex-wrap justify-between gap-x-3"><dt className="text-text-secondary">Bill to</dt><dd className="font-semibold">{data.billingDetails.billingName}</dd></div>
        <div className="flex flex-wrap justify-between gap-x-3"><dt className="text-text-secondary">Address</dt><dd className="font-semibold">{data.billingDetails.billingAddress}</dd></div>
        {(data.billingDetails.tin || data.billingDetails.tinMasked) && <div className="flex flex-wrap justify-between gap-x-3"><dt className="text-text-secondary">Buyer TIN</dt><dd className="font-semibold tabular-nums">{data.billingDetails.tin ?? data.billingDetails.tinMasked}</dd></div>}
      </dl>}
      <div className="grid min-w-0 gap-2">
        <InvoiceRecordList records={data.records} apiBasePath={disputeApiBasePath} renderAction={record => record.canExplain ? <ExplainAction orderId={orderId} recordId={record.id} onChanged={changed} /> : null} />
        {!data.canOpenFiles && data.records.length > 0 && <p className="text-xs leading-5 text-text-secondary">Your role can see invoice status but not open the official file.</p>}
        {!data.canUpload && <p className="text-sm leading-6 text-text-secondary">The Owner, Store Manager or Store Staff upload the official invoice copy.</p>}
      </div>
      {data.canUpload && <UploadForm data={data} onChanged={changed} />}
      <div className="grid min-w-0 gap-3 border-t border-border-default pt-4"><h3 className="text-sm font-semibold">MateryalPH documents</h3><PlatformDocumentNotice documents={data.platformDocuments} /></div>
    </>}
  </section>
}

function ExplainAction({ orderId, recordId, onChanged }: { orderId: string; recordId: string; onChanged: (data: VendorOrderInvoices, text: string) => void }) {
  const [open, setOpen] = useState(false)
  const [note, setNote] = useState('')
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState<string | null>(null)
  return <>
    <Button variant="quiet" onClick={() => setOpen(true)}>Explain the difference</Button>
    <ConfirmDialog open={open} tone="primary" busy={busy} title="Explain the invoice difference" confirmLabel="Save explanation" onCancel={() => setOpen(false)} onConfirm={() => void (async () => {
      if (note.trim().length < 10) { setError('Explain in at least 10 characters.'); return }
      setBusy(true); setError(null)
      try { onChanged(await explainDifference(orderId, recordId, note.trim()), 'Explanation saved. The Buyer\'s agreed amount is unchanged.'); setOpen(false) } catch (cause) { setError(await readableOrderError(cause)) } finally { setBusy(false) }
    })()}>
      <p className="text-text-secondary">The Buyer's accepted total never changes. Explain the difference, or upload a corrected document that references this one.</p>
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

function UploadForm({ data, onChanged }: { data: VendorOrderInvoices; onChanged: (data: VendorOrderInvoices, text: string) => void }) {
  const today = manilaToday()
  const [open, setOpen] = useState(false)
  const [type, setType] = useState('VENDOR_GOODS_INVOICE')
  const [issuer, setIssuer] = useState(data.issuerName)
  const [number, setNumber] = useState('')
  const [issuedOn, setIssuedOn] = useState(today)
  const [amount, setAmount] = useState('')
  const [vat, setVat] = useState('')
  const [lines, setLines] = useState<string[]>([])
  const [source, setSource] = useState('REGISTERED_CAS')
  const [method, setMethod] = useState('COMPUTERIZED')
  const [amends, setAmends] = useState('')
  const [file, setFile] = useState<File | null>(null)
  const [errors, setErrors] = useState<Record<string, string>>({})
  const [message, setMessage] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  const key = useRef(newIdempotencyKey())
  if (!open) return <Button variant="secondary" className="w-fit" onClick={() => setOpen(true)}><Upload size={16} aria-hidden="true" />Upload invoice copy</Button>
  async function submit() {
    const local: Record<string, string> = {}
    const centavos = pesoInputToCentavos(amount)
    const vatCentavos = vat.trim() ? pesoInputToCentavos(vat) : undefined
    if (!issuer.trim()) local.issuer = 'Enter the issuer exactly as printed.'
    if (!/^[A-Za-z0-9][A-Za-z0-9 \-/#.]*$/.test(number.trim())) local.number = 'Enter the invoice number as printed.'
    if (centavos === null) local.amount = 'Enter the invoice total.'
    if (vatCentavos === null) local.vat = 'Enter a valid VAT amount or leave it blank.'
    if (type === 'VENDOR_ADJUSTMENT_DOCUMENT' && !amends) local.amends = 'Choose the invoice this document adjusts.'
    if (!file) local.file = 'Attach the PDF, JPG or PNG copy.'
    setErrors(local)
    if (Object.keys(local).length) { setMessage('Check the highlighted fields.'); return }
    setBusy(true); setMessage(null)
    try {
      const next = await uploadInvoice(data.orderId, { invoiceType: type, issuerName: issuer.trim(), invoiceNumber: number.trim(), issuedOn: new Date(`${issuedOn}T00:00:00`), amountCentavos: centavos!,
        ...(vatCentavos !== undefined && vatCentavos !== null ? { vatCentavos } : {}), relatedLineIds: lines, sourceSystem: source, invoicingMethod: method, ...(amends ? { amendsInvoiceRecordId: amends } : {}), file: file! }, key.current)
      key.current = newIdempotencyKey(); setOpen(false)
      const record = next.records.at(-1)
      onChanged(next, record?.reconciliationState === 'INVOICE_RECONCILIATION_REQUIRED' ? 'Copy uploaded. Its totals differ from the accepted order — explain the difference or upload a correction. The Buyer\'s amount is unchanged.' : 'Invoice copy uploaded and shared with the Buyer.')
    } catch (cause) { if (shouldRotateIdempotencyKey(cause)) key.current = newIdempotencyKey(); setErrors(await orderFieldErrors(cause)); setMessage(await readableOrderError(cause)) } finally { setBusy(false) }
  }
  return <form className="grid gap-4 border-t border-border-default pt-4" noValidate aria-label="Upload invoice copy" onSubmit={event => { event.preventDefault(); void submit() }}>
    <h3 className="text-base font-semibold">Upload invoice copy</h3>
    {message && <StatusMessage tone="error">{message}</StatusMessage>}
    <div className="grid gap-4 sm:grid-cols-2">
      <FieldShell label="Document type"><select className={control} value={type} onChange={event => setType(event.target.value)}>{data.invoiceTypes.map(code => <option key={code} value={code}>{code === 'VENDOR_GOODS_INVOICE' ? 'Sales invoice' : 'Adjustment document'}</option>)}</select></FieldShell>
      <FieldShell label="Issuer (registered business name)" error={errors.issuer_name ?? errors.issuer} hint={`Must match: ${data.issuerName}`}><input className={control} value={issuer} maxLength={240} onChange={event => setIssuer(event.target.value)} /></FieldShell>
      <FieldShell label="Invoice number" error={errors.invoice_number ?? errors.number}><input className={control} value={number} maxLength={64} onChange={event => setNumber(event.target.value)} /></FieldShell>
      <FieldShell label="Invoice date" error={errors.issued_on}><input type="date" className={control} max={today} value={issuedOn} onChange={event => setIssuedOn(event.target.value)} /></FieldShell>
      <FieldShell label="Invoice total (₱)" error={errors.amount_centavos ?? errors.amount}><input className={control} inputMode="decimal" placeholder="0.00" value={amount} onChange={event => setAmount(event.target.value)} /></FieldShell>
      <FieldShell label="VAT shown (₱, optional)" error={errors.vat_centavos ?? errors.vat}><input className={control} inputMode="decimal" placeholder="0.00" value={vat} onChange={event => setVat(event.target.value)} /></FieldShell>
      <FieldShell label="Issued through"><select className={control} value={source} onChange={event => setSource(event.target.value)}>{data.sourceSystems.map(code => <option key={code} value={code}>{SOURCE_LABELS[code] ?? code}</option>)}</select></FieldShell>
      <FieldShell label="Invoicing method"><select className={control} value={method} onChange={event => setMethod(event.target.value)}>{data.invoicingMethods.map(code => <option key={code} value={code}>{METHOD_LABELS[code] ?? code}</option>)}</select></FieldShell>
      {data.records.length > 0 && <FieldShell label={type === 'VENDOR_ADJUSTMENT_DOCUMENT' ? 'Adjusts invoice' : 'Corrects invoice (optional)'} error={errors.amends_invoice_record_id ?? errors.amends}><select className={control} value={amends} onChange={event => setAmends(event.target.value)}>
        <option value="">None</option>{data.records.map(record => <option key={record.id} value={record.id}>{record.invoiceNumber} · {formatPesoCentavos(record.amountCentavos)}</option>)}</select></FieldShell>}
    </div>
    {data.lines.length > 1 && <fieldset className="grid gap-2"><legend className="text-sm font-semibold">Lines covered (leave all unchecked for the whole order)</legend>{data.lines.map(line => <label key={line.orderLineId} className="flex min-h-11 items-center gap-3 text-sm">
      <input type="checkbox" className="h-5 w-5 accent-action-primary" checked={lines.includes(line.orderLineId)} onChange={event => setLines(current => event.target.checked ? [...current, line.orderLineId] : current.filter(id => id !== line.orderLineId))} />{line.displayName}</label>)}</fieldset>}
    <FileSelectionField label="Copy (PDF, JPG or PNG)" accept="application/pdf,image/png,image/jpeg" hint="Select the issued invoice copy before uploading." file={file} disabled={busy} required error={errors.file} onChange={setFile} />
    <p className="text-xs text-text-secondary">TEST uploads are labelled DEMO samples. The totals are compared with the accepted order; a difference is flagged for you to explain and never changes what the Buyer pays.</p>
    <div className="flex flex-wrap gap-3"><Button type="submit" disabled={busy}>{busy ? 'Uploading…' : 'Upload copy'}</Button><Button variant="secondary" onClick={() => setOpen(false)}>Cancel</Button></div>
  </form>
}
