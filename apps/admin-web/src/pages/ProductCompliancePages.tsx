import { useCallback, useEffect, useState, type FormEvent } from 'react'
import { Link, useNavigate, useParams } from 'react-router-dom'
import { AlertCircle, ArrowLeft, BadgeCheck, CheckCircle2, Clock, ExternalLink, FileSearch, ShieldCheck, XCircle } from 'lucide-react'
import { Button, Field, PrivateEvidenceGallery, ResponsiveRecordList, ReviewWorkspace, StatusMessage, type PrivateEvidenceItem, type RecordColumn } from '@materyalph/web-ui'
import type { ComplianceReferenceResult, CompliancePath, ListProductComplianceQueueStatusEnum } from '@materyalph/api-client-ts'
import { activateRegister, complianceErrorCode, decideCompliance, getComplianceCase, getComplianceFileUrl, importRegister, listComplianceQueue, listRegisters, type ComplianceRegister, type ProductComplianceCase, type ProductComplianceQueueItem } from '../lib/product-compliance-api'
import { readableVerificationError } from '../lib/vendor-verification-api'
import { formatDate, record, records, statusLabel, stringValue, numberValue } from '../lib/admin-format'
import { AdminShell, ErrorState, LoadingState, PageHeader } from './PhaseThreeAdminPages'

const apiBasePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'
const icons: Record<string, typeof Clock> = { PENDING_ADMIN_REVIEW: Clock, VERIFIED: ShieldCheck, CHANGES_REQUIRED: AlertCircle, REJECTED: XCircle, SUPERSEDED: FileSearch, MATCHED: CheckCircle2, UNCERTAIN: AlertCircle, UNMATCHED: XCircle, UNAVAILABLE: FileSearch }

function StateText({ status }: { status: string }) {
  const Icon = icons[status] ?? FileSearch
  return <span className="inline-flex items-center gap-1.5 font-semibold"><Icon size={16} aria-hidden="true" />{statusLabel(status)}</span>
}

const referenceExplanation: Record<string, string> = {
  MATCHED: 'Exact match with the active DTI-BPS register snapshot.',
  UNCERTAIN: 'The number exists in the register but another detail differs. Check the company, standard and expiry.',
  UNMATCHED: 'The number was not found in the active register snapshot. This is not a counterfeit finding.',
  UNAVAILABLE: 'No active register snapshot was available when this was submitted.',
}

export function AdminProductComplianceQueuePage() {
  const [filters, setFilters] = useState<{ status: ListProductComplianceQueueStatusEnum; path: string; referenceResult: string; sort: 'oldest' | 'newest' }>({ status: 'PENDING_ADMIN_REVIEW', path: '', referenceResult: '', sort: 'oldest' })
  const [applied, setApplied] = useState(filters)
  const [page, setPage] = useState(1)
  const [items, setItems] = useState<ProductComplianceQueueItem[]>([])
  const [meta, setMeta] = useState<{ last_page?: number; total?: number }>({})
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  useEffect(() => {
    let active = true
    setLoading(true); setError(null)
    void listComplianceQueue({ status: applied.status, sort: applied.sort, page, ...(applied.path ? { path: applied.path as CompliancePath } : {}), ...(applied.referenceResult ? { referenceResult: applied.referenceResult as ComplianceReferenceResult } : {}) })
      .then(result => { if (active) { setItems(result.items); setMeta(result.meta) } })
      .catch(async cause => { const message = await readableVerificationError(cause); if (active) setError(message) })
      .finally(() => { if (active) setLoading(false) })
    return () => { active = false }
  }, [applied, page, attempt])
  const columns: RecordColumn<ProductComplianceQueueItem>[] = [
    { key: 'listing', header: 'Listing', cell: row => <Link className="font-semibold text-action-primary underline" to={`/product-compliance/${row.id}`}>{row.displayName}</Link> },
    { key: 'store', header: 'Store', cell: row => row.publicStoreName ?? '—' },
    { key: 'product', header: 'Regulated product', cell: row => <>{row.productName ?? row.materialName ?? '—'}<span className="block text-xs text-text-secondary">{row.referenceStandard ?? ''}</span></> },
    { key: 'path', header: 'Path', cell: row => statusLabel(row.path) },
    { key: 'reference', header: 'Register', cell: row => row.referenceResult ? <StateText status={row.referenceResult} /> : '—' },
    { key: 'status', header: 'Status', cell: row => <StateText status={row.status} /> },
    { key: 'submitted', header: 'Submitted', cell: row => `${formatDate(row.submittedAt)} · v${row.version}` },
  ]
  const control = 'min-h-11 rounded-control border border-border-default bg-surface-primary px-3 font-normal'
  return <AdminShell activeHref="/product-compliance"><div className="space-y-6">
    <PageHeader eyebrow="Compliance & quality" title="Product Compliance Queue" description="PS Mark and ICC sticker submissions for DTI-BPS regulated products. Oldest pending first. MateryalPH review is a marketplace control, not a government certification." actions={<Button variant="secondary" disabled={loading} onClick={() => setAttempt(value => value + 1)}>Refresh queue</Button>} />
    <form className="flex flex-wrap items-end gap-3 rounded-surface border border-border-default bg-surface-primary p-4" aria-label="Filter compliance queue" onSubmit={event => { event.preventDefault(); setPage(1); setApplied(filters) }}>
      <label className="grid gap-2 text-sm font-semibold">Status<select className={control} value={filters.status} onChange={event => setFilters({ ...filters, status: event.target.value as ListProductComplianceQueueStatusEnum })}>{['PENDING_ADMIN_REVIEW', 'CHANGES_REQUIRED', 'VERIFIED', 'REJECTED', 'SUPERSEDED', 'ALL'].map(status => <option key={status} value={status}>{statusLabel(status)}</option>)}</select></label>
      <label className="grid gap-2 text-sm font-semibold">Input path<select className={control} value={filters.path} onChange={event => setFilters({ ...filters, path: event.target.value })}><option value="">All paths</option>{['PHOTO_OCR', 'QR', 'MANUAL'].map(path => <option key={path} value={path}>{statusLabel(path)}</option>)}</select></label>
      <label className="grid gap-2 text-sm font-semibold">Register result<select className={control} value={filters.referenceResult} onChange={event => setFilters({ ...filters, referenceResult: event.target.value })}><option value="">All results</option>{['MATCHED', 'UNCERTAIN', 'UNMATCHED', 'UNAVAILABLE'].map(result => <option key={result} value={result}>{statusLabel(result)}</option>)}</select></label>
      <label className="grid gap-2 text-sm font-semibold">Sort<select className={control} value={filters.sort} onChange={event => setFilters({ ...filters, sort: event.target.value as 'oldest' | 'newest' })}><option value="oldest">Oldest first</option><option value="newest">Newest first</option></select></label>
      <Button type="submit" disabled={loading}>Apply filters</Button>
    </form>
    {loading ? <LoadingState /> : error ? <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} />
      : items.length === 0 ? <section className="grid min-h-48 place-items-center border-y border-border-default py-10 text-center"><div><CheckCircle2 className="mx-auto text-action-primary" size={28} aria-hidden="true" /><h2 className="mt-3 text-xl font-semibold">No submissions match this view.</h2><p className="mt-2 text-sm text-text-secondary">{applied.status === 'PENDING_ADMIN_REVIEW' ? 'Nothing is waiting for review. New PS/ICC submissions appear here automatically.' : 'Change the filters to see other submissions.'}</p></div></section>
        : <><p className="text-sm text-text-secondary" aria-live="polite">{meta.total ?? items.length} submissions</p><ResponsiveRecordList caption="Product compliance submissions" rows={items} columns={columns} rowKey={row => row.id} cardTitle={row => <Link className="text-action-primary underline" to={`/product-compliance/${row.id}`}>{row.displayName}</Link>} /><div className="flex items-center gap-3"><Button variant="secondary" disabled={page <= 1} onClick={() => setPage(value => value - 1)}>Previous</Button><span>Page {page} of {meta.last_page ?? 1}</span><Button variant="secondary" disabled={page >= (meta.last_page ?? 1)} onClick={() => setPage(value => value + 1)}>Next</Button></div></>}
    <RegisterPanel />
  </div></AdminShell>
}

function RegisterPanel() {
  const [registers, setRegisters] = useState<ComplianceRegister[]>([])
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<{ tone: 'success' | 'error'; text: string } | null>(null)
  const [imported, setImported] = useState<ComplianceRegister | null>(null)
  const load = useCallback(async () => { try { setRegisters((await listRegisters()).items) } catch (cause) { setMessage({ tone: 'error', text: await readableVerificationError(cause) }) } }, [])
  useEffect(() => { void load() }, [load])
  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault(); setBusy(true); setMessage(null); setImported(null)
    const form = event.currentTarget
    const data = new FormData(form)
    const file = data.get('file')
    try {
      if (!(file instanceof File) || file.size === 0) throw new Error('Choose the CSV export of the register.')
      const result = await importRegister(String(data.get('register_kind')) as 'PS_LICENSE' | 'ICC_CERTIFICATE', String(data.get('source_reference')), String(data.get('snapshot_date')), file)
      setImported(result); form.reset(); await load()
      setMessage({ tone: result.rejectedRowCount > 0 ? 'error' : 'success', text: `Imported ${result.rowCount} records as a draft snapshot${result.rejectedRowCount > 0 ? `; ${result.rejectedRowCount} rows were rejected and not imported` : ''}. Activate it to use it for matching.` })
    } catch (cause) { setMessage({ tone: 'error', text: await readableVerificationError(cause) }) } finally { setBusy(false) }
  }
  async function activate(register: ComplianceRegister) {
    setBusy(true); setMessage(null)
    try { await activateRegister(register.id); await load(); setMessage({ tone: 'success', text: `${statusLabel(register.registerKind)} snapshot of ${register.snapshotDate.toString().slice(0, 10)} is now active; the previous active snapshot is superseded.` }) }
    catch (cause) { setMessage({ tone: 'error', text: await readableVerificationError(cause) }) } finally { setBusy(false) }
  }
  return <section aria-labelledby="register-heading" className="grid gap-4 border-t border-border-default pt-6">
    <div><h2 id="register-heading" className="text-xl font-semibold">DTI-BPS register snapshots</h2><p className="mt-1 max-w-3xl text-sm text-text-secondary">The PS licensee and ICC certificate lists are maintained by DTI-BPS and change regularly. Upload a CSV export as a dated snapshot. An exact match with the active snapshot verifies a submission automatically; anything less comes to this queue.</p></div>
    {message && <StatusMessage tone={message.tone}>{message.text}</StatusMessage>}
    <form className="grid grid-cols-1 gap-4 rounded-surface border border-border-default bg-surface-primary p-4 sm:grid-cols-2" onSubmit={submit} aria-busy={busy}>
      <label className="grid gap-2 text-sm font-semibold">Register<select name="register_kind" className="min-h-12 rounded-control border border-border-default bg-surface-primary px-3 text-base font-normal" required><option value="PS_LICENSE">PS licensees</option><option value="ICC_CERTIFICATE">ICC certificates</option></select></label>
      <Field label="Snapshot date" name="snapshot_date" type="date" required max={new Date().toISOString().slice(0, 10)} />
      <Field label="Source" name="source_reference" required minLength={3} maxLength={500} hint="Where the list came from, for example the DTI-BPS sheet link." />
      <label className="grid min-w-0 gap-2 text-sm font-semibold">CSV export<span className="font-normal text-text-secondary">Needs a licence/certificate number column and a company column.</span><input name="file" type="file" accept=".csv,text/csv" required className="min-h-11 w-full min-w-0 text-sm" /></label>
      <Button type="submit" className="w-fit" disabled={busy}>{busy ? 'Importing…' : 'Import snapshot'}</Button>
    </form>
    {imported && imported.rejectedRows && imported.rejectedRows.length > 0 && <details className="text-sm"><summary className="min-h-11 cursor-pointer py-2 font-semibold">Rejected rows ({imported.rejectedRowCount})</summary><ul className="mt-2 grid gap-1">{records(imported.rejectedRows).map(row => <li key={numberValue(row.row_number)}>Row {numberValue(row.row_number)}: {stringValue(row.reason)}</li>)}</ul></details>}
    {registers.length > 0 && <div className="overflow-x-auto rounded-surface border border-border-default"><table className="w-full min-w-[640px] text-left text-sm"><caption className="sr-only">Register snapshots</caption><thead className="bg-surface-canvas"><tr>{['Register', 'Snapshot', 'Records', 'Status', 'Action'].map(label => <th key={label} scope="col" className="px-4 py-3">{label}</th>)}</tr></thead><tbody>{registers.map(register => <tr key={register.id} className="border-t border-border-default"><td className="px-4 py-3">{register.registerKind === 'PS_LICENSE' ? 'PS licensees' : 'ICC certificates'}</td><td className="px-4 py-3">{formatDate(register.snapshotDate)}</td><td className="px-4 py-3">{register.rowCount}{register.rejectedRowCount ? ` (${register.rejectedRowCount} rejected)` : ''}</td><td className="px-4 py-3">{statusLabel(register.status)}</td><td className="px-4 py-3">{register.status === 'DRAFT' ? <Button variant="secondary" disabled={busy} onClick={() => void activate(register)}>Activate</Button> : '—'}</td></tr>)}</tbody></table></div>}
  </section>
}

const sections = [
  { key: 'listing', label: 'Listing and material' },
  { key: 'declaration', label: 'Declared marking and evidence' },
  { key: 'assistance', label: 'Register and extraction' },
  { key: 'history', label: 'Previous submissions and reviews' },
] as const

export function AdminProductComplianceCasePage() {
  const { submissionId = '' } = useParams()
  const navigate = useNavigate()
  const [detail, setDetail] = useState<ProductComplianceCase | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [section, setSection] = useState<(typeof sections)[number]['key']>('declaration')
  const [decision, setDecision] = useState<'APPROVED' | 'CHANGES_REQUIRED' | 'REJECTED'>('APPROVED')
  const [reason, setReason] = useState('')
  const [remarks, setRemarks] = useState('')
  const [source, setSource] = useState('')
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<{ tone: 'success' | 'error'; text: string } | null>(null)
  const [stale, setStale] = useState(false)
  const load = useCallback(async () => {
    setLoading(true); setError(null); setStale(false)
    try { setDetail(await getComplianceCase(submissionId)) } catch (cause) { setError(await readableVerificationError(cause)) } finally { setLoading(false) }
  }, [submissionId])
  useEffect(() => { void load() }, [load])
  if (loading) return <AdminShell activeHref="/product-compliance"><LoadingState /></AdminShell>
  if (error || !detail) return <AdminShell activeHref="/product-compliance"><ErrorState message={error ?? 'The submission is unavailable.'} onRetry={() => void load()} /></AdminShell>

  const submission = record(detail.submission)
  const listing = record(detail.listing)
  const rule = record(detail.rule)
  const declared = record(submission.declared)
  const evidence = records(detail.evidence)
  const match = detail.reference_match ? record(detail.reference_match) : null
  const pending = stringValue(submission.status) === 'PENDING_ADMIN_REVIEW'
  const evidenceItems: PrivateEvidenceItem[] = evidence.map(item => ({ id: stringValue(item.file_id), label: `${stringValue(item.evidence_kind) === 'QR_IMAGE' ? 'QR image' : 'Marking photo'} · ${statusLabel(stringValue(item.path))}`, loadUrl: () => getComplianceFileUrl(stringValue(item.file_id)) }))
  const mediaItems: PrivateEvidenceItem[] = (Array.isArray(listing.media_file_ids) ? listing.media_file_ids.filter((id): id is string => typeof id === 'string') : []).slice(0, 2).map((id, index) => ({ id, label: `Public product photo ${index + 1}`, loadUrl: () => getComplianceFileUrl(id) }))

  async function submitDecision(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    if (decision !== 'APPROVED' && reason.trim().length < 3) { setMessage({ tone: 'error', text: 'A reason is required to return for correction or reject.' }); return }
    setBusy(true); setMessage(null)
    try {
      setDetail(await decideCompliance(submissionId, { decision, lockVersion: numberValue(submission.lock_version, 1), reason: reason.trim() || null, remarks: remarks.trim() || null, sourceReference: source.trim() || null }))
      setMessage({ tone: 'success', text: `${decision === 'APPROVED' ? 'Approved' : decision === 'CHANGES_REQUIRED' ? 'Returned for correction' : 'Rejected'}. The Vendor is notified; Store Activation is unaffected.` }); setReason(''); setRemarks('')
    } catch (cause) {
      if (await complianceErrorCode(cause) === 'STALE_REVIEW') setStale(true)
      setMessage({ tone: 'error', text: await readableVerificationError(cause) })
    } finally { setBusy(false) }
  }

  const datum = (label: string, value: unknown) => <div key={label} className="min-w-0"><dt className="text-xs text-text-secondary">{label}</dt><dd className="mt-0.5 break-words text-sm font-medium">{stringValue(value) || 'Not provided'}</dd></div>
  const information = <section aria-labelledby="case-section-heading" className="min-w-0 rounded-surface border border-border-default bg-surface-primary p-4 sm:p-5">
    <h2 id="case-section-heading" className="text-lg font-semibold">{sections.find(item => item.key === section)?.label}</h2>
    {section === 'listing' && <div className="mt-4 grid gap-5"><dl className="grid gap-3 sm:grid-cols-2">{datum('Display name', listing.display_name)}{datum('Vendor SKU', listing.vendor_sku)}{datum('Canonical material', listing.material_name)}{datum('Category', listing.category_name)}{datum('Brand', listing.brand)}{datum('Model', listing.model)}{datum('Manufacturer', listing.manufacturer)}{datum('Country of manufacture', listing.country_of_manufacture)}</dl>
      <div className="border-t border-border-default pt-4"><h3 className="font-semibold">{stringValue(rule.product_name, 'Regulated product')}</h3><dl className="mt-3 grid gap-3 sm:grid-cols-2">{datum('Reference standard', rule.reference_standard)}{datum('Technical regulation', rule.technical_regulation)}</dl><p className="mt-3 text-sm">{stringValue(rule.scope)}</p><h4 className="mt-4 text-sm font-semibold">Marking requirements</h4><ul className="mt-2 list-disc space-y-1 pl-5 text-sm">{(Array.isArray(rule.marking_requirements) ? rule.marking_requirements : []).map(item => <li key={String(item)}>{String(item)}</li>)}</ul></div>
      {mediaItems.length > 0 && <div className="border-t border-border-default pt-4"><h3 className="font-semibold">Public product photos</h3><div className="mt-3"><PrivateEvidenceGallery items={mediaItems} apiBasePath={apiBasePath} /></div></div>}</div>}
    {section === 'declaration' && <div className="mt-4 grid gap-5 xl:grid-cols-2"><dl className="grid content-start gap-3">{datum('Marking type', statusLabel(stringValue(declared.marking_type)))}{datum(stringValue(declared.marking_type) === 'ICC_STICKER' ? 'ICC Certificate No.' : 'PS License No.', declared.certificate_number)}{datum('Manufacturer', declared.manufacturer_name)}{datum('Manufacturer address', declared.manufacturer_address)}{datum('Importer', declared.importer_name)}{datum('Importer address', declared.importer_address)}{datum('Country of manufacture', declared.country_of_manufacture)}{datum('Brand', declared.brand)}{datum('Batch or lot', declared.batch_number)}</dl>
      <div className="min-w-0"><h3 className="font-semibold">Private evidence</h3>{evidence.map(item => <p key={stringValue(item.id)} className="mt-1 text-xs text-text-secondary">{stringValue(item.evidence_kind) === 'QR_IMAGE' ? 'QR image' : 'Marking photo'} · scan {stringValue(item.scan_state) === 'CLEAN' ? 'passed' : stringValue(item.scan_state).toLowerCase()} · {stringValue(item.content_type)} · sha256 {stringValue(item.checksum_prefix)}…</p>)}<div className="mt-3">{evidenceItems.length ? <PrivateEvidenceGallery items={evidenceItems} apiBasePath={apiBasePath} /> : <p className="text-sm text-text-secondary">No evidence file is attached.</p>}</div></div></div>}
    {section === 'assistance' && <div className="mt-4 grid gap-5">
      <div><h3 className="font-semibold">Register comparison</h3>{match ? <><p className="mt-2"><StateText status={stringValue(match.result)} /></p><p className="mt-1 text-sm">{referenceExplanation[stringValue(match.result)] ?? ''}</p><p className="mt-1 text-xs text-text-secondary">{stringValue(match.source_reference, 'No register snapshot')} · checked {formatDate(match.checked_at)}</p>{records(record(match.details).candidates).map(candidate => <p key={stringValue(candidate.record_id)} className="mt-1 text-sm">Register record differs on: {(Array.isArray(candidate.failed_checks) ? candidate.failed_checks : []).map(check => statusLabel(String(check))).join(', ')}</p>)}</> : <p className="mt-2 text-sm text-text-secondary">No comparison recorded.</p>}</div>
      <div className="border-t border-border-default pt-4"><h3 className="font-semibold">Extraction assistance</h3><p className="mt-1 text-sm text-text-secondary">OCR and QR values are suggestions the Vendor confirmed or corrected; they are never evidence of authenticity.</p>{records(detail.extractions).length === 0 ? <p className="mt-2 text-sm">Manual entry — no extraction.</p> : records(detail.extractions).map((item, index) => <div key={index} className="mt-2 text-sm"><p className="font-semibold">{statusLabel(stringValue(item.source))} · {statusLabel(stringValue(item.status))}{typeof item.confidence === 'number' ? ` · confidence ${Math.round(item.confidence * 100)}%` : ''}</p><ul className="mt-1 grid gap-0.5">{Object.entries(record(item.suggestions)).map(([key, value]) => <li key={key}>{statusLabel(key)}: {String(value)}</li>)}</ul></div>)}</div>
    </div>}
    {section === 'history' && <div className="mt-4 grid gap-5"><div><h3 className="font-semibold">Previous submissions</h3>{records(detail.previous_submissions).length === 0 ? <p className="mt-2 text-sm text-text-secondary">This is the first submission for the listing.</p> : <ul className="mt-2 divide-y divide-border-default text-sm">{records(detail.previous_submissions).map(item => <li key={stringValue(item.id)} className="py-2">Version {numberValue(item.version)} · {statusLabel(stringValue(item.path))} · <StateText status={stringValue(item.status)} /> · {formatDate(item.submitted_at)}</li>)}</ul>}</div>
      <div className="border-t border-border-default pt-4"><h3 className="font-semibold">Review decisions</h3>{records(detail.reviews).length === 0 ? <p className="mt-2 text-sm text-text-secondary">No decision recorded yet.</p> : <ul className="mt-2 divide-y divide-border-default text-sm">{records(detail.reviews).map(item => <li key={stringValue(item.id)} className="py-2">Version {numberValue(item.submission_version)} · {statusLabel(stringValue(item.decision))} · {stringValue(item.source) === 'SYSTEM_REGISTER_MATCH' ? 'System register match' : stringValue(item.reviewer_name, 'Admin')} · {formatDate(item.reviewed_at)}{stringValue(item.reason) ? ` · ${stringValue(item.reason)}` : ''}</li>)}</ul>}</div></div>}
  </section>

  const decisionPanel = <section aria-labelledby="decision-heading" className="min-w-0 rounded-surface border border-border-default bg-surface-primary p-4 sm:p-5">
    <div className="flex items-start gap-3"><BadgeCheck className="mt-1 shrink-0 text-action-primary" size={22} aria-hidden="true" /><div><h2 id="decision-heading" className="text-lg font-semibold">Record decision</h2><p className="mt-1 text-sm text-text-secondary">Target: submission version {numberValue(submission.version)} · lock {numberValue(submission.lock_version)} · {evidence.length} evidence file{evidence.length === 1 ? '' : 's'} · rule v{numberValue(submission.rule_version)}</p></div></div>
    {stale && <div className="mt-4 flex flex-wrap items-center gap-3 rounded-control border border-status-warning/40 bg-amber-50 p-3 text-sm" role="alert"><AlertCircle size={18} aria-hidden="true" /><span className="flex-1">This submission changed or was already decided. Refresh to review the current version.</span><Button variant="secondary" onClick={() => void load()}>Refresh case</Button></div>}
    {message && <div className="mt-4"><StatusMessage tone={message.tone}>{message.text}</StatusMessage></div>}
    {!pending ? <p className="mt-4 text-sm"><StateText status={stringValue(submission.status)} /> — decided {formatDate(submission.decided_at)}. Decisions are immutable; a correction creates a new submission.</p>
      : <form className="mt-4 grid gap-3 border-t border-border-default pt-4" onSubmit={submitDecision}>
        <fieldset className="grid gap-2"><legend className="text-sm font-semibold">Decision</legend>{([['APPROVED', 'Approve'], ['CHANGES_REQUIRED', 'Return for correction'], ['REJECTED', 'Reject']] as const).map(([value, label]) => <label key={value} className="flex min-h-11 items-center gap-3 rounded-control border border-border-default px-3"><input type="radio" name="decision" className="h-5 w-5 accent-action-primary" checked={decision === value} onChange={() => setDecision(value)} />{label}</label>)}</fieldset>
        <label className="grid gap-2 text-sm font-semibold" htmlFor="compliance-reason"><span>Reason {decision !== 'APPROVED' && <span className="text-status-error" aria-hidden="true">*</span>}</span><textarea id="compliance-reason" className="min-h-20 rounded-control border border-border-default bg-surface-primary px-3 py-3 text-base font-normal" value={reason} required={decision !== 'APPROVED'} onChange={event => setReason(event.target.value)} placeholder={decision === 'APPROVED' ? 'Optional approval note' : 'Tell the Vendor exactly what to correct.'} /></label>
        <Field label="Source checked" name="source_reference" value={source} hint="For example the DTI-BPS list and date you checked." onChange={event => setSource(event.target.value)} />
        <label className="grid gap-2 text-sm font-semibold" htmlFor="compliance-remarks">Internal remarks<textarea id="compliance-remarks" className="min-h-16 rounded-control border border-border-default bg-surface-primary px-3 py-3 text-base font-normal" value={remarks} onChange={event => setRemarks(event.target.value)} /></label>
        <Button type="submit" className="w-fit" disabled={busy}>{busy ? 'Recording…' : 'Record decision'}</Button>
      </form>}
    <div className="mt-5 border-t border-border-default pt-4"><h3 className="text-sm font-semibold">Official references</h3><ul className="mt-2 grid gap-1 text-sm">{records(detail.official_references).map(reference => <li key={stringValue(reference.url)}><a className="inline-flex min-h-11 items-center gap-1 text-action-primary underline" href={stringValue(reference.url)} target="_blank" rel="noopener noreferrer">{stringValue(reference.label)} <ExternalLink size={14} aria-hidden="true" /><span className="sr-only">(opens in a new tab)</span></a></li>)}</ul></div>
  </section>

  const navigator = <div className="grid gap-2 rounded-surface border border-border-default bg-surface-primary p-2">{sections.map(item => <Button key={item.key} variant={section === item.key ? 'primary' : 'quiet'} className="justify-start text-left" aria-current={section === item.key ? 'true' : undefined} onClick={() => setSection(item.key)}>{item.label}</Button>)}</div>

  return <AdminShell activeHref="/product-compliance"><div className="space-y-5">
    <PageHeader compact eyebrow="Product compliance case" title={stringValue(listing.display_name, 'Compliance submission')} description={`${stringValue(listing.public_store_name, 'Vendor store')} · ${stringValue(rule.product_name, '')} · submitted ${formatDate(submission.submitted_at)}`} actions={<Button variant="secondary" onClick={() => navigate('/product-compliance')}><ArrowLeft size={16} aria-hidden="true" /> Back to queue</Button>} />
    <p className="flex flex-wrap gap-4 text-sm"><StateText status={stringValue(submission.status)} />{match && <span>Register: <StateText status={stringValue(match.result)} /></span>}<span>Listing: {statusLabel(stringValue(listing.status))}</span></p>
    <ReviewWorkspace navigator={navigator} information={information} decision={decisionPanel} />
  </div></AdminShell>
}

