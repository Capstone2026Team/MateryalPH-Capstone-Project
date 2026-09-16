import {
  AlertCircle,
  ArrowLeft,
  BadgeCheck,
  Check,
  CheckCircle2,
  ClipboardCheck,
  Clock3,
  ExternalLink,
  FileCheck2,
  FileText,
  LayoutDashboard,
  LockKeyhole,
  RefreshCw,
  ShieldAlert,
  Store,
  Users,
} from 'lucide-react'
import { type FormEvent, type ReactNode, useCallback, useEffect, useState } from 'react'
import { Link, useNavigate, useParams } from 'react-router-dom'

import { Button, Field, PortalShell, StatusBadge, StatusMessage, type PortalNavSection } from '@materyalph/web-ui'
import {
  decideVendorVerificationRequirement,
  getAdminVendorEvidenceUrl,
  getVendorVerificationCase,
  listVendorVerificationQueue,
  readableVerificationError,
  restrictVendorActivation,
  restoreVendorActivation,
  type VerificationDetail,
} from '../lib/vendor-verification-api'

type JsonRecord = Record<string, unknown>

const adminNavigation: PortalNavSection[] = [
  { label: 'Review', items: [{ label: 'Verification queue', href: '/vendor-verification', icon: <ClipboardCheck size={16} aria-hidden="true" /> }, { label: 'Dashboard', href: '/vendor-verification', icon: <LayoutDashboard size={16} aria-hidden="true" /> }] },
  { label: 'Operations', items: [{ label: 'Accounts', href: '/workspace', icon: <Users size={16} aria-hidden="true" /> }, { label: 'Store policies', href: '/vendor-verification', icon: <Store size={16} aria-hidden="true" /> }] },
]

function record(value: unknown): JsonRecord {
  return typeof value === 'object' && value !== null && !Array.isArray(value) ? value as JsonRecord : {}
}

function records(value: unknown): JsonRecord[] {
  return Array.isArray(value) ? value.map(record) : []
}

function stringValue(value: unknown, fallback = ''): string {
  return typeof value === 'string' ? value : fallback
}

function numberValue(value: unknown, fallback = 0): number {
  return typeof value === 'number' && Number.isFinite(value) ? value : fallback
}

function statusTone(status: string): 'neutral' | 'warning' | 'success' | 'error' | 'info' {
  if (['APPROVED', 'COMPLETED', 'COMPLETE', 'ACTIVE', 'CONNECTED', 'READY'].includes(status)) return 'success'
  if (['CHANGES_REQUIRED', 'IN_PROGRESS', 'PENDING_VERIFICATION', 'PENDING', 'NOT_READY', 'UNVERIFIED'].includes(status)) return 'warning'
  if (['REJECTED', 'EXPIRED', 'FAILED', 'RESTRICTED', 'SUSPENDED'].includes(status)) return 'error'
  if (status === 'SUBMITTED') return 'info'
  return 'neutral'
}

function statusLabel(status: string): string {
  return status.replaceAll('_', ' ').toLowerCase().replace(/(^|\s)\S/g, (letter) => letter.toUpperCase())
}

function adminDate(): string {
  return new Intl.DateTimeFormat('en-PH', { dateStyle: 'full' }).format(new Date())
}

function formatDate(value: unknown): string {
  if (value instanceof Date && !Number.isNaN(value.valueOf())) return new Intl.DateTimeFormat('en-PH', { dateStyle: 'medium' }).format(value)
  if (typeof value === 'string' && value) return new Intl.DateTimeFormat('en-PH', { dateStyle: 'medium' }).format(new Date(value))
  return 'Not recorded'
}

function LoadingState() {
  return <div className="grid min-h-64 place-items-center rounded-surface border border-border-default bg-surface-primary p-8 text-center"><RefreshCw className="animate-spin text-action-primary" size={24} aria-hidden="true" /><p className="mt-3 text-sm text-text-secondary">Loading verification workspace…</p></div>
}

function ErrorState({ message, onRetry }: { message: string; onRetry: () => void }) {
  return <div className="grid gap-4 rounded-surface border border-status-error/30 bg-red-50 p-6 text-sm text-red-900" role="alert"><div className="flex items-start gap-3"><AlertCircle className="mt-0.5 shrink-0" size={20} aria-hidden="true" /><p>{message}</p></div><Button className="w-fit" variant="secondary" onClick={onRetry}><RefreshCw size={16} aria-hidden="true" /> Try again</Button></div>
}

function AdminShell({ activeHref, children }: { activeHref: string; children: ReactNode }) {
  return <PortalShell homeHref="/vendor-verification" portalLabel="ADMIN PORTAL" pageTitle="Vendor Verification" dateLabel={adminDate()} sections={adminNavigation} activeHref={activeHref} accountLabel="Admin review team" accountStatus="Audited access">{children}</PortalShell>
}

function PageHeader({ eyebrow, title, description, actions }: { eyebrow: string; title: string; description: string; actions?: ReactNode }) {
  return <div className="flex flex-col gap-5 border-b border-border-default pb-7 lg:flex-row lg:items-end lg:justify-between"><div className="max-w-3xl"><p className="text-xs font-semibold uppercase tracking-[0.14em] text-action-primary">{eyebrow}</p><h1 className="mt-3 text-3xl font-semibold tracking-tight text-text-strong sm:text-4xl">{title}</h1><p className="mt-3 max-w-2xl text-base leading-7 text-text-secondary">{description}</p></div>{actions && <div className="flex shrink-0 flex-wrap gap-3">{actions}</div>}</div>
}

export function AdminVendorVerificationQueuePage() {
  const [items, setItems] = useState<import('@materyalph/api-client-ts').AdminVendorVerificationQueueItem[]>([])
  const [meta, setMeta] = useState<JsonRecord>({})
  const [status, setStatus] = useState('PENDING_VERIFICATION')
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  const load = useCallback(async (nextStatus = status) => {
    setLoading(true); setError(null)
    try { const result = await listVendorVerificationQueue(nextStatus ? { status: nextStatus } : {}); setItems(result.items); setMeta(result.meta) } catch (cause) { setError(await readableVerificationError(cause)) } finally { setLoading(false) }
  }, [status])

  useEffect(() => { void load() }, [load])
  const total = numberValue(meta.total, items.length)

  return <AdminShell activeHref="/vendor-verification"><div className="phase3-page space-y-8"><PageHeader eyebrow="Admin review" title="Vendor Verification queue" description="Review submitted Vendor cases in one consistent workspace. Private evidence is available only through an authorized, short-lived URL and every decision becomes immutable review history." actions={<Button variant="secondary" disabled={loading} onClick={() => void load()}><RefreshCw size={16} aria-hidden="true" /> Refresh queue</Button>} /><section className="flex flex-col gap-4 border-b border-border-default pb-6 sm:flex-row sm:items-end sm:justify-between"><div><p className="text-xs font-semibold uppercase tracking-[0.14em] text-action-primary">Manual review</p><h2 className="mt-2 text-xl font-semibold">{total} case{total === 1 ? '' : 's'} in this view</h2><p className="mt-1 text-sm text-text-secondary">Filter by review status, then open a case for requirement-level decisions.</p></div><label className="grid gap-2 text-sm font-semibold sm:min-w-64" htmlFor="queue-status">Status filter<select className="min-h-12 rounded-control border border-border-default bg-surface-primary px-3 text-base font-normal" id="queue-status" value={status} onChange={(event) => setStatus(event.target.value)}><option value="">All review cases</option><option value="PENDING_VERIFICATION">Pending verification</option><option value="CHANGES_REQUIRED">Changes required</option><option value="REJECTED">Rejected</option><option value="APPROVED">Approved</option></select></label><Button variant="secondary" onClick={() => void load(status)}>Apply</Button></section>{loading ? <LoadingState /> : error ? <ErrorState message={error} onRetry={() => void load()} /> : items.length === 0 ? <EmptyQueue status={status} /> : <section className="overflow-hidden rounded-surface border border-border-default bg-surface-primary" aria-labelledby="queue-table-title"><h2 className="sr-only" id="queue-table-title">Vendor verification cases</h2><div className="overflow-x-auto"><table className="w-full min-w-[760px] border-collapse text-left text-sm"><thead className="bg-surface-canvas text-xs uppercase tracking-[0.12em] text-text-secondary"><tr><th className="px-5 py-4 font-semibold" scope="col">Store</th><th className="px-5 py-4 font-semibold" scope="col">Verification</th><th className="px-5 py-4 font-semibold" scope="col">Setup</th><th className="px-5 py-4 font-semibold" scope="col">Progress</th><th className="px-5 py-4 font-semibold" scope="col">Submitted</th><th className="px-5 py-4" scope="col"><span className="sr-only">Open</span></th></tr></thead><tbody className="divide-y divide-border-default">{items.map((item) => <tr className="hover:bg-brand-orange-50" key={item.id}><td className="px-5 py-5"><Link className="font-semibold text-text-strong underline-offset-4 hover:text-action-primary hover:underline" to={`/vendor-verification/${item.id}`}>{item.storeName}</Link><p className="mt-1 text-xs text-text-secondary">{item.registeredName ?? 'Registered name pending'} · {item.businessType ? statusLabel(item.businessType) : 'Business type pending'}</p></td><td className="px-5 py-5"><StatusBadge label={statusLabel(item.verificationStatus)} tone={statusTone(item.verificationStatus)} /></td><td className="px-5 py-5"><StatusBadge label={statusLabel(item.setupStatus ?? 'NOT_STARTED')} tone={statusTone(item.setupStatus ?? 'NOT_STARTED')} /></td><td className="px-5 py-5"><ProgressText progress={item.progress} /></td><td className="px-5 py-5 text-text-secondary">{formatDate(item.submittedAt)}</td><td className="px-5 py-5 text-right"><Link className="inline-flex min-h-11 items-center gap-2 font-semibold text-action-primary" to={`/vendor-verification/${item.id}`}>Review <ArrowLeft className="rotate-180" size={16} aria-hidden="true" /></Link></td></tr>)}</tbody></table></div></section>}</div></AdminShell>
}

function ProgressText({ progress }: { progress: { [key: string]: unknown } }) {
  const complete = numberValue(progress.complete)
  const total = numberValue(progress.total)
  return <div><p className="font-semibold">{complete}/{total} required</p><div className="mt-2 h-2 w-32 overflow-hidden rounded-pill bg-brand-orange-100"><div className="h-full bg-brand-orange-600" style={{ width: `${total > 0 ? (complete / total) * 100 : 0}%` }} /></div></div>
}

function EmptyQueue({ status }: { status: string }) {
  return <section className="grid min-h-64 place-items-center border-y border-border-default py-12 text-center"><div><div className="mx-auto grid h-14 w-14 place-items-center rounded-full bg-brand-orange-50 text-action-primary"><CheckCircle2 size={26} aria-hidden="true" /></div><h2 className="mt-5 text-xl font-semibold">No cases match this view.</h2><p className="mt-2 max-w-md text-sm leading-6 text-text-secondary">{status ? `There are no ${statusLabel(status).toLowerCase()} cases right now.` : 'Submitted Vendor cases will appear here when ready for manual review.'}</p></div></section>
}

export function AdminVendorVerificationDetailPage() {
  const { organizationId = '' } = useParams()
  const navigate = useNavigate()
  const [detail, setDetail] = useState<VerificationDetail | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [selectedKey, setSelectedKey] = useState('')
  const [decision, setDecision] = useState('APPROVED')
  const [reason, setReason] = useState('')
  const [documentNumber, setDocumentNumber] = useState('')
  const [issueDate, setIssueDate] = useState('')
  const [expirationKind, setExpirationKind] = useState('UNVERIFIED')
  const [expirationDate, setExpirationDate] = useState('')
  const [evidenceSource, setEvidenceSource] = useState('')
  const [verifiedVatCategory, setVerifiedVatCategory] = useState('')
  const [remarks, setRemarks] = useState('')
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<{ tone: 'success' | 'error'; text: string } | null>(null)
  const [restrictionReason, setRestrictionReason] = useState('')

  const load = useCallback(async () => {
    if (!organizationId) return
    setLoading(true); setError(null)
    try { const result = await getVendorVerificationCase(organizationId); setDetail(result) } catch (cause) { setError(await readableVerificationError(cause)) } finally { setLoading(false) }
  }, [organizationId])

  useEffect(() => { void load() }, [load])
  const steps = detail ? records(record(detail.sections).STORE_VERIFICATION) : []
  const documents = detail ? records(detail.documents) : []
  const reviews = detail ? records(detail.reviews) : []
  const selectedStep = steps.find((step) => stringValue(step.key) === selectedKey) ?? steps[0]
  const selectedDocument = documents.find((document) => stringValue(document.requirementKey, stringValue(document.requirement_key)) === stringValue(selectedStep?.key))
  const organization = record(detail?.organization)
  const readiness = record(detail?.readiness)

  useEffect(() => {
    if (selectedStep && !selectedKey) setSelectedKey(stringValue(selectedStep.key))
  }, [selectedKey, selectedStep])

  async function submitDecision(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    if (!selectedStep) { setMessage({ tone: 'error', text: 'Select a verification requirement first.' }); return }
    if (decision !== 'APPROVED' && reason.trim().length < 3) { setMessage({ tone: 'error', text: 'A reason is required for Changes Required or Reject.' }); return }
    setBusy(true); setMessage(null)
    try {
      const updated = await decideVendorVerificationRequirement(organizationId, stringValue(selectedStep.key), { decision: decision as import('@materyalph/api-client-ts').AdminVendorVerificationDecision['decision'], lockVersion: numberValue(selectedStep.lockVersion, numberValue(selectedStep.lock_version, 1)), reason: reason.trim() || null, verifiedDocumentNumber: documentNumber.trim() || null, verifiedIssueDate: issueDate ? new Date(`${issueDate}T00:00:00Z`) : null, expirationKind: expirationKind as NonNullable<import('@materyalph/api-client-ts').AdminVendorVerificationDecision['expirationKind']>, verifiedExpirationDate: expirationDate ? new Date(`${expirationDate}T00:00:00Z`) : null, evidenceSource: evidenceSource.trim() || null, verifiedVatCategory: stringValue(selectedStep.key) === 'bir_cor' && verifiedVatCategory ? verifiedVatCategory as NonNullable<import('@materyalph/api-client-ts').AdminVendorVerificationDecision['verifiedVatCategory']> : null, remarks: remarks.trim() || null }); setDetail(updated); setMessage({ tone: 'success', text: `${statusLabel(decision)} recorded for ${stringValue(selectedStep.label, stringValue(selectedStep.key))}.` }); setReason('') } catch (cause) { setMessage({ tone: 'error', text: await readableVerificationError(cause) }) } finally { setBusy(false) }
  }

  async function openEvidence(fileId: string) {
    setBusy(true); setMessage(null)
    try { const result = await getAdminVendorEvidenceUrl(fileId); if (result.url) window.open(result.url, '_blank', 'noopener,noreferrer') } catch (cause) { setMessage({ tone: 'error', text: await readableVerificationError(cause) }) } finally { setBusy(false) }
  }

  async function changeRestriction(action: 'restrict' | 'restore') {
    if (restrictionReason.trim().length < 3) { setMessage({ tone: 'error', text: 'Enter a reason before changing activation restriction.' }); return }
    setBusy(true); setMessage(null)
    try { if (action === 'restrict') await restrictVendorActivation(organizationId, restrictionReason.trim()); else await restoreVendorActivation(organizationId, restrictionReason.trim()); await load(); setMessage({ tone: 'success', text: action === 'restrict' ? 'Activation restriction recorded.' : 'Activation restoration recorded.' }) } catch (cause) { setMessage({ tone: 'error', text: await readableVerificationError(cause) }) } finally { setBusy(false) }
  }

  if (loading) return <AdminShell activeHref="/vendor-verification"><LoadingState /></AdminShell>
  if (error) return <AdminShell activeHref="/vendor-verification"><ErrorState message={error} onRetry={() => void load()} /></AdminShell>
  if (!detail) return null

  return <AdminShell activeHref="/vendor-verification"><div className="phase3-page space-y-8"><PageHeader eyebrow="Admin review case" title={stringValue(organization.storeName, stringValue(organization.store_name, 'Vendor verification'))} description="Review current evidence, record a requirement-level decision, and keep activation restriction separate from the verification decision." actions={<Button variant="secondary" onClick={() => navigate('/vendor-verification')}><ArrowLeft size={16} aria-hidden="true" /> Back to queue</Button>} /><section className="grid gap-5 border-b border-border-default pb-7 lg:grid-cols-[1.2fr_.8fr]"><div><div className="flex flex-wrap items-center gap-3"><StatusBadge label={statusLabel(stringValue(organization.verificationStatus, stringValue(organization.store_verification_status, 'PENDING_VERIFICATION')))} tone={statusTone(stringValue(organization.verificationStatus, stringValue(organization.store_verification_status, 'PENDING_VERIFICATION')))} /><StatusBadge label={`Activation: ${statusLabel(stringValue(organization.activationStatus, stringValue(organization.store_activation_status, 'NOT_READY')))}`} tone={statusTone(stringValue(organization.activationStatus, stringValue(organization.store_activation_status, 'NOT_READY')))} /></div><dl className="mt-5 grid gap-4 text-sm sm:grid-cols-2"><DetailDatum label="Registered name" value={stringValue(organization.registeredName, stringValue(organization.registered_name, stringValue(organization.legalName, stringValue(organization.legal_name, 'Not recorded'))))} /><DetailDatum label="Business type" value={statusLabel(stringValue(organization.businessType, stringValue(organization.business_type, 'Not recorded')))} /><DetailDatum label="Store email" value={stringValue(organization.storeEmail, stringValue(organization.store_email, 'Not recorded'))} /><DetailDatum label="Store phone" value={stringValue(organization.storePhone, stringValue(organization.store_phone, 'Not recorded'))} /></dl></div><div className="border-t border-border-default pt-5 lg:border-l lg:border-t-0 lg:pl-6"><p className="text-xs font-semibold uppercase tracking-[0.14em] text-action-primary">Activation readiness</p><h2 className="mt-2 text-xl font-semibold">{booleanValue(readiness.ready) ? 'Ready, pending Vendor activation.' : 'Blocked by current requirements.'}</h2><div className="mt-4 grid gap-2">{records(readiness.blockers).slice(0, 4).map((blocker) => <p className="text-sm leading-6 text-text-secondary" key={`${stringValue(blocker.key)}-${stringValue(blocker.reason)}`}><span className="font-semibold text-text-strong">{stringValue(blocker.key)}:</span> {stringValue(blocker.reason)}</p>)}</div></div></section>{message && <StatusMessage tone={message.tone}>{message.text}</StatusMessage>}<div className="grid gap-8 xl:grid-cols-[minmax(0,.8fr)_minmax(0,1.2fr)]"><section className="rounded-surface border border-border-default bg-surface-primary p-5 sm:p-7" aria-labelledby="requirements-title"><div className="flex items-start gap-3"><ClipboardCheck className="mt-1 shrink-0 text-action-primary" size={22} aria-hidden="true" /><div><h2 id="requirements-title" className="text-2xl font-semibold">Verification requirements</h2><p className="mt-2 text-sm leading-6 text-text-secondary">Choose one requirement at a time. Corrections and rejection reasons remain visible in the review history.</p></div></div><div className="mt-6 grid gap-2">{steps.map((step) => <button className={`flex min-h-14 w-full items-center justify-between gap-3 border px-4 py-3 text-left ${stringValue(step.key) === stringValue(selectedStep?.key) ? 'border-action-primary bg-brand-orange-50' : 'border-border-default bg-surface-primary hover:bg-brand-orange-50'}`} type="button" key={stringValue(step.key)} onClick={() => setSelectedKey(stringValue(step.key))}><span className="flex min-w-0 items-center gap-3"><RequirementIcon status={stringValue(step.status)} /><span className="min-w-0"><span className="block font-semibold">{stringValue(step.label, stringValue(step.key))}</span><span className="mt-1 block text-xs text-text-secondary">{stringValue(step.level)}</span></span></span><StatusBadge label={statusLabel(stringValue(step.status, 'NOT_STARTED'))} tone={statusTone(stringValue(step.status, 'NOT_STARTED'))} /></button>)}</div></section><DecisionPanel selectedStep={selectedStep} selectedDocument={selectedDocument} decision={decision} setDecision={setDecision} reason={reason} setReason={setReason} documentNumber={documentNumber} setDocumentNumber={setDocumentNumber} issueDate={issueDate} setIssueDate={setIssueDate} expirationKind={expirationKind} setExpirationKind={setExpirationKind} expirationDate={expirationDate} setExpirationDate={setExpirationDate} evidenceSource={evidenceSource} setEvidenceSource={setEvidenceSource} verifiedVatCategory={verifiedVatCategory} setVerifiedVatCategory={setVerifiedVatCategory} remarks={remarks} setRemarks={setRemarks} busy={busy} onSubmit={submitDecision} onOpenEvidence={openEvidence} /></div><div className="grid gap-8 lg:grid-cols-2"><CaseInformation detail={detail} /><RestrictionPanel activationStatus={stringValue(organization.activationStatus, stringValue(organization.store_activation_status, 'NOT_READY'))} reason={restrictionReason} setReason={setRestrictionReason} busy={busy} onRestrict={() => void changeRestriction('restrict')} onRestore={() => void changeRestriction('restore')} /></div><ReviewHistory reviews={reviews} /></div></AdminShell>
}

function booleanValue(value: unknown): boolean {
  return value === true
}

function DetailDatum({ label, value }: { label: string; value: string }) {
  return <div><dt className="text-text-secondary">{label}</dt><dd className="mt-1 font-semibold text-text-strong">{value}</dd></div>
}

function RequirementIcon({ status }: { status: string }) {
  if (['APPROVED', 'COMPLETED', 'NOT_APPLICABLE'].includes(status)) return <CheckCircle2 className="shrink-0 text-status-success" size={19} aria-hidden="true" />
  if (['CHANGES_REQUIRED', 'REJECTED', 'EXPIRED'].includes(status)) return <AlertCircle className="shrink-0 text-status-error" size={19} aria-hidden="true" />
  if (['PENDING_VERIFICATION', 'SUBMITTED'].includes(status)) return <Clock3 className="shrink-0 text-status-warning" size={19} aria-hidden="true" />
  return <div className="h-4 w-4 shrink-0 rounded-full border-2 border-border-default" aria-hidden="true" />
}

type DecisionPanelProps = {
  selectedStep: JsonRecord | undefined
  selectedDocument: JsonRecord | undefined
  decision: string
  setDecision: (value: string) => void
  reason: string
  setReason: (value: string) => void
  documentNumber: string
  setDocumentNumber: (value: string) => void
  issueDate: string
  setIssueDate: (value: string) => void
  expirationKind: string
  setExpirationKind: (value: string) => void
  expirationDate: string
  setExpirationDate: (value: string) => void
  evidenceSource: string
  setEvidenceSource: (value: string) => void
  verifiedVatCategory: string
  setVerifiedVatCategory: (value: string) => void
  remarks: string
  setRemarks: (value: string) => void
  busy: boolean
  onSubmit: (event: FormEvent<HTMLFormElement>) => void
  onOpenEvidence: (fileId: string) => Promise<void>
}

function DecisionPanel(props: DecisionPanelProps) {
  const { selectedStep, selectedDocument, decision, setDecision, reason, setReason, documentNumber, setDocumentNumber, issueDate, setIssueDate, expirationKind, setExpirationKind, expirationDate, setExpirationDate, evidenceSource, setEvidenceSource, verifiedVatCategory, setVerifiedVatCategory, remarks, setRemarks, busy, onSubmit, onOpenEvidence } = props
  const fileId = stringValue(selectedDocument?.fileId, stringValue(selectedDocument?.file_id))
  return <section className="rounded-surface border border-action-primary/30 bg-brand-orange-50 p-5 sm:p-7" aria-labelledby="decision-title"><div className="flex items-start gap-3"><BadgeCheck className="mt-1 shrink-0 text-action-primary" size={22} aria-hidden="true" /><div><h2 id="decision-title" className="text-2xl font-semibold">Record decision</h2><p className="mt-2 text-sm leading-6 text-text-secondary">{selectedStep ? `Reviewing ${stringValue(selectedStep.label, stringValue(selectedStep.key))}.` : 'Select a requirement to begin.'} Approve only validated clean evidence.</p></div></div>{selectedDocument && <div className="mt-5 flex flex-wrap items-center gap-3 border-y border-action-primary/20 py-4"><FileCheck2 size={18} className="text-action-primary" aria-hidden="true" /><div><p className="font-semibold">Current evidence version {stringValue(selectedDocument.version, 'not available')}</p><p className="text-sm text-text-secondary">Scan state: {statusLabel(stringValue(selectedDocument.scanState, stringValue(selectedDocument.scan_state, 'not available')))}</p></div>{fileId && <Button type="button" variant="secondary" disabled={busy} onClick={() => void onOpenEvidence(fileId)}><LockKeyhole size={16} aria-hidden="true" /> Open private evidence <ExternalLink size={15} aria-hidden="true" /></Button>}</div>}<form className="mt-6 grid gap-5" onSubmit={onSubmit}><div className="grid gap-5 sm:grid-cols-3"><label className="grid gap-2 text-sm font-semibold" htmlFor="decision">Decision<select className="min-h-12 rounded-control border border-border-default bg-surface-primary px-3 text-base font-normal" id="decision" value={decision} onChange={(event) => setDecision(event.target.value)}><option value="APPROVED">Approve</option><option value="CHANGES_REQUIRED">Changes Required</option><option value="REJECTED">Reject</option></select></label><Field label="Verified document number" name="verified_document_number" value={documentNumber} onChange={(event) => setDocumentNumber(event.target.value)} /><Field label="Evidence source" name="evidence_source" value={evidenceSource} onChange={(event) => setEvidenceSource(event.target.value)} /></div><div className="grid gap-5 sm:grid-cols-3"><Field label="Issue date" name="verified_issue_date" type="date" value={issueDate} onChange={(event) => setIssueDate(event.target.value)} /><label className="grid gap-2 text-sm font-semibold" htmlFor="expiration_kind">Expiration<select className="min-h-12 rounded-control border border-border-default bg-surface-primary px-3 text-base font-normal" id="expiration_kind" value={expirationKind} onChange={(event) => setExpirationKind(event.target.value)}><option value="UNVERIFIED">Not verified</option><option value="DATE">Has expiration date</option><option value="NO_EXPIRATION">No expiration</option></select></label>{expirationKind === 'DATE' ? <Field label="Expiration date" name="verified_expiration_date" type="date" value={expirationDate} onChange={(event) => setExpirationDate(event.target.value)} /> : <div />}</div>{stringValue(selectedStep?.key) === 'bir_cor' && <label className="grid gap-2 text-sm font-semibold" htmlFor="verified_vat_category">VAT category verified by Admin<select className="min-h-12 rounded-control border border-border-default bg-surface-primary px-3 py-3 text-base font-normal" id="verified_vat_category" value={verifiedVatCategory} onChange={(event) => setVerifiedVatCategory(event.target.value)}><option value="">Not verified</option><option value="VAT">VAT</option><option value="NON_VAT">Non-VAT</option><option value="VAT_ZERO">VAT zero-rated</option><option value="VAT_EXEMPT">VAT exempt</option></select></label>}<div className="grid gap-2 text-sm font-semibold"><label htmlFor="decision_reason">Reason {decision !== 'APPROVED' && <span className="text-status-error" aria-hidden="true">*</span>}</label><textarea className="min-h-28 rounded-control border border-border-default bg-surface-primary px-3 py-3 text-base font-normal" id="decision_reason" value={reason} onChange={(event) => setReason(event.target.value)} placeholder={decision === 'APPROVED' ? 'Optional approval note' : 'Explain the correction or rejection clearly.'} /></div><div className="grid gap-2 text-sm font-semibold"><label htmlFor="review_remarks">Reviewer remarks</label><textarea className="min-h-24 rounded-control border border-border-default bg-surface-primary px-3 py-3 text-base font-normal" id="review_remarks" value={remarks} onChange={(event) => setRemarks(event.target.value)} /></div><Button className="w-fit" disabled={busy || !selectedStep}>{busy ? 'Recording…' : 'Record requirement decision'} <Check size={16} aria-hidden="true" /></Button></form></section>
}

function CaseInformation({ detail }: { detail: VerificationDetail }) {
  const contacts = records(detail.contacts)
  const address = record(detail.address)
  const identity = record(detail.legal_identity ?? detail.legalIdentity)
  const classification = record(detail.classification)
  const tax = record(detail.tax_profile ?? detail.taxProfile)
  const individualRequired = identity.individual_required === true || identity.individualRequired === true
  const companyRequired = identity.company_required === true || identity.companyRequired === true
  const individualName = [stringValue(identity.first_name, stringValue(identity.firstName)), stringValue(identity.middle_name, stringValue(identity.middleName)), stringValue(identity.surname)].filter(Boolean).join(' ') || 'Not recorded'
  const companyName = stringValue(identity.company_registered_name, stringValue(identity.companyRegisteredName, 'Not recorded'))
  const idType = stringValue(identity.id_type, stringValue(identity.idType, 'Not supplied'))
  const idLast4 = stringValue(identity.id_number_last4, stringValue(identity.idNumberLast4, 'not supplied'))
  const vatDeclared = stringValue(tax.vat_category, stringValue(tax.vatCategory, 'Not recorded'))
  const vatVerified = stringValue(tax.vat_verified_category, stringValue(tax.vatVerifiedCategory, 'Not verified'))
  const branchCode = stringValue(tax.tin_branch_code, stringValue(tax.tinBranchCode, 'Not supplied'))
  const birReference = stringValue(tax.bir_cor_reference, stringValue(tax.birCorReference, 'Not supplied'))

  return <section className="rounded-surface border border-border-default bg-surface-primary p-5 sm:p-7" aria-labelledby="case-information-title">
    <h2 id="case-information-title" className="text-2xl font-semibold">Submitted information</h2>
    <div className="mt-6 grid gap-6">
      <InfoGroup title="Primary contacts"><div className="grid gap-3">{contacts.length === 0 ? <p className="text-sm text-text-secondary">No contact submitted.</p> : contacts.map((contact) => <div className="border-t border-border-default pt-3" key={`${stringValue(contact.fullName, stringValue(contact.full_name))}-${stringValue(contact.email)}`}><p className="font-semibold">{stringValue(contact.fullName, stringValue(contact.full_name, 'Unnamed contact'))}</p><p className="mt-1 text-sm text-text-secondary">{stringValue(contact.title)} · {stringValue(contact.email, stringValue(contact.email, 'No email'))}</p></div>)}</div></InfoGroup>
      <InfoGroup title="Legal identity">{companyRequired && <p className="text-sm text-text-secondary">Company registered name: {companyName}</p>}{individualRequired && <><p className="text-sm text-text-secondary">Individual legal name: {individualName}</p><p className="mt-2 text-sm text-text-secondary">Government ID: {idType} · ending {idLast4}</p></>}</InfoGroup>
      <InfoGroup title="Registered address"><p className="text-sm leading-6 text-text-secondary">{stringValue(address.formattedAddress, stringValue(address.formatted_address, [stringValue(address.street), stringValue(address.barangay), stringValue(address.cityMunicipality, stringValue(address.city_municipality)), stringValue(address.province), stringValue(address.postalCode, stringValue(address.postal_code))].filter(Boolean).join(', ') || 'No address submitted.'))}</p><p className="mt-2 text-xs text-text-secondary">Review state: {statusLabel(stringValue(address.reviewState, stringValue(address.review_state, 'UNREVIEWED')))}</p></InfoGroup>
      <InfoGroup title="Classification and tax"><p className="text-sm text-text-secondary">{statusLabel(stringValue(classification.supplierType, stringValue(classification.supplier_type, 'Not classified')))}</p><p className="mt-2 text-sm text-text-secondary">{statusLabel(stringValue(tax.entityClass, stringValue(tax.entity_class, 'Entity class pending')))} · Declared VAT: {statusLabel(vatDeclared)} · Admin verified: {statusLabel(vatVerified)}</p><p className="mt-2 text-sm text-text-secondary">TIN branch code: {branchCode} · BIR COR reference: {birReference}</p><p className="mt-2 text-sm text-text-secondary">Taxpayer key ending {stringValue(tax.taxpayerKeyLast4, stringValue(tax.taxpayer_key_last4, 'not supplied'))} · TIN ending {stringValue(tax.tinLast4, stringValue(tax.tin_last4, 'not supplied'))} · Owner attested: {tax.ownerAttested === true || tax.owner_attested === true ? 'Yes' : 'No'}</p></InfoGroup>
    </div>
  </section>
}
function InfoGroup({ title, children }: { title: string; children: ReactNode }) {
  return <div className="border-t border-border-default pt-4"><h3 className="font-semibold">{title}</h3><div className="mt-3">{children}</div></div>
}

function RestrictionPanel({ activationStatus, reason, setReason, busy, onRestrict, onRestore }: { activationStatus: string; reason: string; setReason: (value: string) => void; busy: boolean; onRestrict: () => void; onRestore: () => void }) {
  return <section className="rounded-surface border border-border-default bg-surface-primary p-5 sm:p-7" aria-labelledby="restriction-title"><div className="flex items-start gap-3"><ShieldAlert className="mt-1 shrink-0 text-action-primary" size={22} aria-hidden="true" /><div><h2 id="restriction-title" className="text-2xl font-semibold">Activation restriction</h2><p className="mt-2 text-sm leading-6 text-text-secondary">Restriction is a separate Admin action. It does not rewrite the verification review history.</p></div></div><div className="mt-5"><StatusBadge label={`Current: ${statusLabel(activationStatus)}`} tone={statusTone(activationStatus)} /></div><label className="mt-5 grid gap-2 text-sm font-semibold" htmlFor="restriction_reason">Reason<textarea className="min-h-28 rounded-control border border-border-default bg-surface-primary px-3 py-3 text-base font-normal" id="restriction_reason" value={reason} onChange={(event) => setReason(event.target.value)} placeholder="Explain why activation should be restricted or restored." /></label><div className="mt-5 flex flex-wrap gap-3"><Button disabled={busy} variant="secondary" onClick={onRestrict}>Restrict activation</Button><Button disabled={busy} onClick={onRestore}>Restore activation</Button></div></section>
}

function ReviewHistory({ reviews }: { reviews: JsonRecord[] }) {
  return <section className="border-t border-border-default pt-6" aria-labelledby="review-history-title">
    <div className="flex items-center gap-3"><FileText className="text-action-primary" size={20} aria-hidden="true" /><div><h2 id="review-history-title" className="text-xl font-semibold">Immutable review history</h2><p className="mt-1 text-sm text-text-secondary">Each evidence version keeps its decision, reviewer notes, and expiration metadata.</p></div></div>
    {reviews.length === 0 ? <p className="mt-5 border-y border-border-default py-5 text-sm text-text-secondary">No requirement decisions have been recorded yet.</p> : <div className="mt-5 overflow-x-auto border-y border-border-default">
      <table className="w-full min-w-[1100px] border-collapse text-left text-sm">
        <caption className="sr-only">Immutable Vendor verification decisions by requirement and evidence version</caption>
        <thead className="text-xs uppercase tracking-[0.12em] text-text-secondary"><tr><th className="px-3 py-4 font-semibold" scope="col">Requirement</th><th className="px-3 py-4 font-semibold" scope="col">Evidence version</th><th className="px-3 py-4 font-semibold" scope="col">Decision</th><th className="px-3 py-4 font-semibold" scope="col">Reason</th><th className="px-3 py-4 font-semibold" scope="col">Evidence source</th><th className="px-3 py-4 font-semibold" scope="col">Reviewer</th><th className="px-3 py-4 font-semibold" scope="col">Expiry</th><th className="px-3 py-4 font-semibold" scope="col">Reviewed</th></tr></thead>
        <tbody className="divide-y divide-border-default">{reviews.map((review) => {
          const version = numberValue(review.version, 0)
          const expiration = stringValue(review.expirationKind, stringValue(review.expiration_kind, 'UNVERIFIED'))
          return <tr key={stringValue(review.id, `${stringValue(review.businessDocumentVersionId, stringValue(review.business_document_version_id))}-${stringValue(review.reviewedAt, stringValue(review.reviewed_at))}`)}><td className="px-3 py-4 font-semibold">{statusLabel(stringValue(review.requirementKey, stringValue(review.requirement_key, 'Requirement')))}</td><td className="px-3 py-4 text-text-secondary">{version > 0 ? `Version ${version}` : 'Not recorded'}</td><td className="px-3 py-4"><StatusBadge label={statusLabel(stringValue(review.decision))} tone={statusTone(stringValue(review.decision))} /></td><td className="max-w-md px-3 py-4 text-text-secondary">{stringValue(review.reason, 'No reason recorded')}</td><td className="px-3 py-4 text-text-secondary">{stringValue(review.evidenceSource, stringValue(review.evidence_source, 'Not recorded'))}</td><td className="px-3 py-4 text-text-secondary">{stringValue(review.reviewerName, stringValue(review.reviewer_name, 'Authorized Admin'))}</td><td className="px-3 py-4 text-text-secondary">{expiration === 'DATE' ? formatDate(review.verifiedExpirationDate ?? review.verified_expiration_date) : statusLabel(expiration)}</td><td className="px-3 py-4 text-text-secondary">{formatDate(review.reviewedAt ?? review.reviewed_at)}</td></tr>
        })}</tbody>
      </table>
    </div>}
  </section>
}
