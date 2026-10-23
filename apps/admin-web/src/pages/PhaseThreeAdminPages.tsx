import { DateFilter, FilterTabs, InfoNote, Pagination, Toolbar, ChecklistPanel, verificationChecklist, PrivateEvidenceGallery, PageHeader as SharedPageHeader, PortalPagePatterns, type PrivateEvidenceItem } from '@materyalph/web-ui'
import { parseDate } from '@materyalph/api-client-ts'
import {
  Activity,
  ChartNoAxesCombined,
  CreditCard,
  History,
  LayoutDashboard,
  ReceiptText,
  Scale,
  Settings,
  ShieldCheck,
  Store,
  Users,
  AlertCircle,
  ArrowLeft,
  BadgeCheck,
  Check,
  CheckCircle2,
  ClipboardCheck,
  ContactRound,
  FileText,
  RefreshCw,
  ShieldAlert,
} from 'lucide-react'
import { type FormEvent, type ReactNode, useCallback, useEffect, useState } from 'react'
import { Link, useNavigate, useParams, useSearchParams } from 'react-router-dom'

import { Button, Field, PortalShell, StatusBadge, StatusMessage, useNavigationUpdates, useNavigationRefresh, usePortalResource, type PortalNavSection } from '@materyalph/web-ui'
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

import { formatDate, numberValue, record, records, statusLabel, statusTone, stringValue, type JsonRecord } from '../lib/admin-format'

const adminModuleIcons: Record<string, typeof FileText> = { 'vendor-verification': Store,'marketplace-analytics': ChartNoAxesCombined, 'buyer-management': Users, 'product-compliance': ShieldCheck, disputes: Scale, enforcement: ShieldAlert, scores: BadgeCheck, moderation: ClipboardCheck, transactions: CreditCard, 'order-operations': ReceiptText, invoices: ReceiptText, settings: Settings, integrations: Activity }
const adminModuleHrefs: Record<string, string> = { 'vendor-verification': '/vendor-verification','marketplace-analytics': '/analytics', 'buyer-management': '/buyer-management', 'product-compliance': '/product-compliance', disputes: '/disputes', enforcement: '/enforcement', scores: '/scores', moderation: '/reviews', transactions: '/finance', 'order-operations': '/order-operations', invoices: '/invoices', settings: '/settings', support: '/support', integrations: '/integrations' }
const adminNavigation: PortalNavSection[] = [
  { label: 'Overview', items: [{ label: 'Dashboard', href: '/dashboard', icon: <LayoutDashboard size={16} aria-hidden="true" /> }] },
  { label: 'User Management', items: [
    { label: 'Vendor Users', href: '/vendor-users', icon: <ContactRound size={16} aria-hidden="true" />, child: true },
    { label: 'Buyer Users', href: '/buyer-users', icon: <ContactRound size={16} aria-hidden="true" />, child: true },
  ] },
  ...[['Marketplace', [['Marketplace Analytics', 'marketplace-analytics']]], ['Compliance & quality', [['Vendor Verification', 'vendor-verification'],['Product Compliance Queue', 'product-compliance'], ['Disputes & Appeals', 'disputes'], ['Enforcement', 'enforcement'], ['Score & Badge Monitoring', 'scores'], ['Review Moderation', 'moderation']]], ['Finance', [['Transaction', 'transactions'], ['Orders & Refunds', 'order-operations'], ['Invoice Request Log', 'invoices']]], ['Platform', [['Platform Settings', 'settings'], ['Support Requests', 'support'], ['Integration & Job Health', 'integrations']]]].map(([label, entries]) => ({ label: label as string, items: (entries as string[][]).map(([label = '', key = '']) => ({ label, href: adminModuleHrefs[key] ?? `/preview/${key}`, icon: (() => { const Icon = adminModuleIcons[key] ?? FileText; return <Icon size={18} aria-hidden="true" /> })() })) })),
  { label: 'Tracking', items: [{ label: 'Audit Log', href: '/audit', icon: <History size={16} aria-hidden="true" /> }] },
]

function adminDate(): string {
  return new Intl.DateTimeFormat('en-PH', { dateStyle: 'full', timeZone: 'Asia/Manila' }).format(new Date())
}

export function LoadingState() {
  return <div role="status" className="grid min-h-48 place-items-center rounded-surface border border-border-default bg-surface-primary p-8 text-center"><RefreshCw className="animate-spin motion-reduce:animate-none text-action-primary" size={24} aria-hidden="true" /><p className="mt-3 text-sm text-text-secondary">Loading workspace…</p></div>
}

export function ErrorState({ message, onRetry }: { message: string; onRetry: () => void }) {
  return <div className="grid gap-4 rounded-surface border border-status-error/30 bg-red-50 p-6 text-sm text-red-900" role="alert"><div className="flex items-start gap-3"><AlertCircle className="mt-0.5 shrink-0" size={20} aria-hidden="true" /><p>{message}</p></div><Button className="w-fit" variant="secondary" onClick={onRetry}><RefreshCw size={16} aria-hidden="true" /> Try again</Button></div>
}

export function AdminShell({ activeHref, children }: { activeHref: string; children: ReactNode }) {
  const navigate = useNavigate()
  const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'
  const counts = useNavigationUpdates({ basePath, audience: 'admin' })
  const sections = adminNavigation.map(section => ({ ...section, items: section.items.map(item => ({ ...item, updateCount: counts?.[item.href] ?? 0, updateCountLabel: 'pending item' })) }))
  return <PortalShell apiBasePath={basePath} onNavigate={navigate} notificationUnreadCount={counts?.['/notifications'] ?? 0} headerActions={<Link className="inline-flex min-h-11 items-center text-sm font-semibold" to="/workspace">Account settings</Link>} homeHref="/dashboard" portalLabel="ADMIN PORTAL" pageTitle={activeHref === '/dashboard' ? 'Dashboard' : activeHref === '/notifications' ? 'Notifications' : activeHref === '/workspace' ? 'Settings' : activeHref === '/audit' ? 'Audit tracking' : adminNavigation.flatMap(section => section.items).find(item => item.href === activeHref)?.label ?? 'Vendor Verification'} dateLabel={adminDate()} sections={sections} activeHref={activeHref} accountLabel="Admin review team" accountStatus="Audited access"><PortalPagePatterns.Provider value><div className="admin-page text-sm">{children}</div></PortalPagePatterns.Provider></PortalShell>
}

export function PageHeader({ eyebrow, title, description, actions }: { eyebrow: string; title: string; description: string; actions?: ReactNode; compact?: boolean }) {
  return <SharedPageHeader eyebrow={eyebrow} title={title} description={description} actions={actions} />
}

const verificationTabs = ['PENDING_VERIFICATION', 'CHANGES_REQUIRED', 'REJECTED', 'APPROVED', 'EXPIRED']
const blankVerificationFilters = { regionCode: '', submittedFrom: '', submittedTo: '', sort: 'submitted_desc', setupStatus: '', activation: '', discoverability: '', blocker: '', ageDays: '', expiryDays: '' }

/** A day-count filter that applies on blur or Enter, so typing a number does not reload the queue on every keystroke. */
function DaysFilter({ label, value, onCommit }: { label: string; value: string; onCommit: (value: string) => void }) {
  const [draft, setDraft] = useState(value)
  useEffect(() => { setDraft(value) }, [value])
  const commit = () => { const next = draft.trim(); if (next !== value) onCommit(next) }
  return <input type="number" min={1} max={365} inputMode="numeric" aria-label={label} placeholder={label} className="min-h-11 w-52 max-w-full rounded-control border border-border-default bg-surface-primary px-3 text-sm text-text-strong" value={draft} onChange={event => setDraft(event.target.value)} onBlur={commit} onKeyDown={event => { if (event.key === 'Enter') commit() }} />
}

export function AdminVendorVerificationQueuePage() {
  const [searchParams] = useSearchParams()
  const requestedStatus = searchParams.get('status') ?? ''
  const [filters, setFilters] = useState({ status: verificationTabs.includes(requestedStatus) ? requestedStatus : 'PENDING_VERIFICATION', ...blankVerificationFilters, activation: searchParams.get('activation') ?? '', expiryDays: searchParams.get('expiry') ?? '' })
  const [page, setPage] = useState(1)
  const [error, setError] = useState<string | null>(null)
  const [counts, setCounts] = useState<Record<string, number>>({})
  const loadQueue = useCallback(() => listVendorVerificationQueue({
      status: filters.status, ...(filters.regionCode ? { regionCode: filters.regionCode } : {}),
      ...(filters.submittedFrom ? { submittedFrom: parseDate(filters.submittedFrom) } : {}),
      ...(filters.submittedTo ? { submittedTo: parseDate(filters.submittedTo) } : {}),
      ...(filters.setupStatus ? { setupStatus: filters.setupStatus as never } : {}), ...(filters.activation ? { activation: filters.activation as never } : {}),
      ...(filters.discoverability ? { discoverability: filters.discoverability as never } : {}), ...(filters.blocker ? { blocker: filters.blocker as never } : {}),
      ...(filters.ageDays ? { ageDays: Number(filters.ageDays) } : {}), ...(filters.expiryDays ? { expiryDays: Number(filters.expiryDays) } : {}),
      sort: filters.sort as never, page,
    }), [filters, page])
  const { data, error: failure, refresh } = usePortalResource(`admin-verification:${JSON.stringify(filters)}:${page}`, loadQueue)
  useNavigationRefresh(() => { void refresh() })
  const items = data?.items ?? []
  const meta = data?.meta ?? {}
  const loading = !data && !failure
  useEffect(() => {
    const received = data?.meta.status_counts
    if (received && typeof received === 'object') setCounts(received as Record<string, number>)
  }, [data])
  const change = (patch: Partial<typeof filters>) => { setFilters(current => ({ ...current, ...patch })); setPage(1) }
  const filtersChanged = (Object.keys(blankVerificationFilters) as (keyof typeof blankVerificationFilters)[]).some(key => filters[key] !== blankVerificationFilters[key])
  useEffect(() => {
    let active = true
    setError(null)
    if (failure) void readableVerificationError(failure).then(message => { if (active) setError(message) })
    return () => { active = false }
  }, [failure])
  const [dateLabel, setDateLabel] = useState('All dates')
  const filterSelect = 'min-h-11 w-auto max-w-full rounded-control border border-border-default bg-surface-primary px-3 text-sm font-normal text-text-strong'
  return <AdminShell activeHref="/vendor-verification"><div className="space-y-6">
    <PageHeader eyebrow="Compliance & quality" title="Vendor Verification" description="Review submitted business requirements. Choose a review status and submission period, then open a case to review its evidence." actions={<Button variant="secondary" disabled={loading} onClick={() => void refresh()}><RefreshCw size={16} aria-hidden="true" />Refresh queue</Button>} />
    <InfoNote>Verification, setup, TEST provider readiness, activation and discovery are separate states. The number on each tab counts the cases under the filters below.</InfoNote>
    <FilterTabs label="Review status" value={filters.status} onChange={status => change({ status })} chips={verificationTabs.map(value => ({ value, label: statusLabel(value), ...(counts[value] !== undefined ? { count: counts[value] } : {}) }))} />
    <Toolbar filters={<>
      <DateFilter title="Submission dates" value={{ label: dateLabel, from: filters.submittedFrom, to: filters.submittedTo }} onChange={range => { setDateLabel(range.label); change({ submittedFrom: range.from, submittedTo: range.to }) }} />
      <label className="sr-only" htmlFor="verification-setup">Setup</label>
      <select id="verification-setup" className={filterSelect} value={filters.setupStatus} onChange={event => change({ setupStatus: event.target.value })}><option value="">Any setup state</option>{['NOT_STARTED', 'IN_PROGRESS', 'CHANGES_REQUIRED', 'COMPLETED'].map(value => <option key={value} value={value}>{statusLabel(value)}</option>)}</select>
      <label className="sr-only" htmlFor="verification-activation">Activation</label>
      <select id="verification-activation" className={filterSelect} value={filters.activation} onChange={event => change({ activation: event.target.value })}><option value="">Any activation state</option>{['NOT_ACTIVE', 'NOT_READY', 'READY', 'ACTIVE', 'RESTRICTED', 'SUSPENDED'].map(value => <option key={value} value={value}>{statusLabel(value)}</option>)}</select>
      <label className="sr-only" htmlFor="verification-discovery">Discovery</label>
      <select id="verification-discovery" className={filterSelect} value={filters.discoverability} onChange={event => change({ discoverability: event.target.value })}><option value="">Any discovery state</option><option value="DISCOVERABLE">Discoverable</option><option value="NOT_DISCOVERABLE">Not discoverable</option></select>
      <label className="sr-only" htmlFor="verification-blocker">Activation blocker</label>
      <select id="verification-blocker" className={filterSelect} value={filters.blocker} onChange={event => change({ blocker: event.target.value })}><option value="">Any blocker</option>{[['MEDIA', 'Store media'], ['HOURS', 'Store hours'], ['DELIVERY', 'Delivery setup'], ['AUTHORITY', 'Authority to act'], ['TERMS', 'Agreements'], ['PROVIDER', 'Provider readiness (TEST)']].map(([value = '', text]) => <option key={value} value={value}>{text}</option>)}</select>
      <DaysFilter label="Waiting at least (days)" value={filters.ageDays} onCommit={ageDays => change({ ageDays })} />
      <DaysFilter label="Document expires within (days)" value={filters.expiryDays} onCommit={expiryDays => change({ expiryDays })} />
      <label className="sr-only" htmlFor="verification-sort">Sort by</label>
      <select id="verification-sort" className={filterSelect} value={filters.sort} onChange={event => change({ sort: event.target.value })}><option value="submitted_desc">Newest submission first</option><option value="submitted_asc">Oldest submission first</option><option value="oldest_pending">Oldest pending requirement first</option></select>
      {filtersChanged && <Button variant="quiet" onClick={() => { setDateLabel('All dates'); setFilters({ status: filters.status, ...blankVerificationFilters }); setPage(1) }}>Reset filters</Button>}
    </>} />
    {loading ? <LoadingState /> : error ? <ErrorState message={error} onRetry={() => void refresh()} /> : <>{items.length === 0 ? <EmptyQueue status={filters.status} /> : <div className="overflow-x-auto"><table className="w-full min-w-[1100px] text-left text-sm"><thead><tr>{['Store', 'Location', 'Verification', 'Setup', 'Provider (TEST)', 'Activation', 'Discovery', 'Pending', 'Action'].map(label => <th className="whitespace-nowrap px-4 py-3" scope="col" key={label}>{label}</th>)}</tr></thead><tbody>{items.map(item => <tr className="border-t border-border-default align-top" key={item.id}><td className="min-w-56 px-4 py-4"><Link className="font-semibold text-action-primary underline" to={`/vendor-verification/${item.id}`}>{item.storeName}</Link><p className="mt-1 text-text-secondary">{item.registeredName ?? 'Registered name pending'}</p></td><td className="min-w-56 px-4 py-4"><p>{item.regionName ?? 'Unassigned region'}</p><p className="mt-1 text-text-secondary">{[item.province, item.cityMunicipality].filter(Boolean).join(' · ') || 'Address not recorded'}</p></td><td className="whitespace-nowrap px-4 py-4"><StatusBadge label={statusLabel(item.verificationStatus)} tone={statusTone(item.verificationStatus)} /><div className="mt-2"><ProgressText progress={item.progress} /></div></td><td className="whitespace-nowrap px-4 py-4">{statusLabel(item.setupStatus ?? 'NOT_STARTED')}</td><td className="whitespace-nowrap px-4 py-4">{statusLabel(item.providerStatus ?? 'NOT_CONNECTED')}</td><td className="whitespace-nowrap px-4 py-4"><StatusBadge label={statusLabel(item.activationStatus ?? 'NOT_READY')} tone={statusTone(item.activationStatus ?? 'NOT_READY')} />{item.holdCode && <p className="mt-1 text-[13px] text-text-secondary">Hold: {statusLabel(item.holdCode)}</p>}</td><td className="whitespace-nowrap px-4 py-4">{statusLabel(item.discoverabilityStatus ?? 'NOT_DISCOVERABLE')}</td><td className="whitespace-nowrap px-4 py-4"><p className="font-semibold tabular-nums">{item.pendingRequirements ?? 0} requirement(s)</p><p className="mt-1 text-[13px] text-text-secondary">{item.oldestPendingAt ? `Oldest ${formatDate(item.oldestPendingAt)}` : `Submitted ${formatDate(item.submittedAt)}`}</p></td><td className="whitespace-nowrap px-4 py-4"><Link className="inline-flex min-h-11 items-center font-semibold text-action-primary" to={`/vendor-verification/${item.id}`}>Review</Link></td></tr>)}</tbody></table></div>}<Pagination page={page} lastPage={numberValue(meta.last_page, 1)} total={numberValue(meta.total)} busy={loading} onChange={setPage} /></>}
  </div></AdminShell>
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
  const [authorityEvidence, setAuthorityEvidence] = useState('')
  const [authorityScopes, setAuthorityScopes] = useState<string[]>([])
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
  const steps = detail ? records(record(detail.sections).STORE_VERIFICATION).filter(step => step.status !== 'NOT_APPLICABLE' && step.level !== 'OPTIONAL' && step.key !== 'commission_terms') : []
  const documents = detail ? records(detail.documents) : []
  const reviews = detail ? records(detail.reviews) : []
  const authorityReviews = detail ? records(detail.authority_reviews ?? detail.authorityReviews) : []
  const checklist = verificationChecklist(steps.map(step => ({ key: stringValue(step.key), label: stringValue(step.label, stringValue(step.key)), level: stringValue(step.level), status: stringValue(step.status), reason: stringValue(step.reason) })), { separateAuthority: true })
  const selectedItem = checklist.find(item => item.key === selectedKey) ?? checklist[0]
  const selectedSteps = selectedItem?.requirements.map(requirement => steps.find(step => stringValue(step.key) === requirement.key)).filter((step): step is JsonRecord => Boolean(step)) ?? []
  const selectedStep = selectedSteps[0]
  const selectedDocuments = documents.filter(document => selectedSteps.some(step => stringValue(step.key) === stringValue(document.requirementKey, stringValue(document.requirement_key))))
    .sort((left, right) => selectedSteps.findIndex(step => stringValue(step.key) === stringValue(left.requirementKey, stringValue(left.requirement_key))) - selectedSteps.findIndex(step => stringValue(step.key) === stringValue(right.requirementKey, stringValue(right.requirement_key))))
  const organization = record(detail?.organization)
  const readiness = record(detail?.readiness)

  useEffect(() => {
    if (selectedItem && selectedItem.key !== selectedKey) setSelectedKey(selectedItem.key)
  }, [selectedKey, selectedItem])

  async function submitDecision(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    if (!selectedItem || !selectedStep) { setMessage({ tone: 'error', text: 'Select a verification requirement first.' }); return }
    if (decision !== 'APPROVED' && reason.trim().length < 3) { setMessage({ tone: 'error', text: 'A reason is required for Changes Required or Reject.' }); return }
    setBusy(true); setMessage(null)
    try {
      const grouped = selectedItem.key !== stringValue(selectedStep.key)
      const requirementVersions = Object.fromEntries(selectedSteps.map(step => [stringValue(step.key), numberValue(step.lockVersion, numberValue(step.lock_version, 1))]))
      const updated = await decideVendorVerificationRequirement(organizationId, selectedItem.key, { decision: decision as import('@materyalph/api-client-ts').AdminVendorVerificationDecision['decision'], ...(grouped ? { requirementVersions } : { lockVersion: numberValue(selectedStep.lockVersion, numberValue(selectedStep.lock_version, 1)) }), reason: reason.trim() || null, verifiedDocumentNumber: documentNumber.trim() || null, verifiedIssueDate: issueDate ? parseDate(issueDate) : null, expirationKind: expirationKind as NonNullable<import('@materyalph/api-client-ts').AdminVendorVerificationDecision['expirationKind']>, verifiedExpirationDate: expirationDate ? parseDate(expirationDate) : null, evidenceSource: evidenceSource.trim() || null, verifiedVatCategory: selectedItem.key === 'bir_cor' && verifiedVatCategory ? verifiedVatCategory as NonNullable<import('@materyalph/api-client-ts').AdminVendorVerificationDecision['verifiedVatCategory']> : null, remarks: remarks.trim() || null, ...(selectedItem.key === 'authority_to_act' ? { authorityEvidenceVersionId: authorityEvidence || null, authorityScopes: authorityScopes as NonNullable<import('@materyalph/api-client-ts').AdminVendorVerificationDecision['authorityScopes']> } : {}) }); setDetail(updated); setMessage({ tone: 'success', text: `${statusLabel(decision)} recorded for ${selectedItem.label}.` }); setReason('') } catch (cause) { setMessage({ tone: 'error', text: await readableVerificationError(cause) }) } finally { setBusy(false) }
  }

  async function changeRestriction(action: 'restrict' | 'restore') {
    if (restrictionReason.trim().length < 3) { setMessage({ tone: 'error', text: 'Enter a reason before changing activation restriction.' }); return }
    setBusy(true); setMessage(null)
    try { if (action === 'restrict') await restrictVendorActivation(organizationId, restrictionReason.trim()); else await restoreVendorActivation(organizationId, restrictionReason.trim()); await load(); setMessage({ tone: 'success', text: action === 'restrict' ? 'Activation restriction recorded.' : 'Activation restoration recorded.' }) } catch (cause) { setMessage({ tone: 'error', text: await readableVerificationError(cause) }) } finally { setBusy(false) }
  }

  if (loading) return <AdminShell activeHref="/vendor-verification"><LoadingState /></AdminShell>
  if (error) return <AdminShell activeHref="/vendor-verification"><ErrorState message={error} onRetry={() => void load()} /></AdminShell>
  if (!detail) return null

  return <AdminShell activeHref="/vendor-verification"><div className="phase3-page space-y-5"><PageHeader compact eyebrow="Admin review case" title={stringValue(organization.storeName, stringValue(organization.store_name, 'Vendor verification'))} description="Review current evidence, record a requirement-level decision, and keep activation restriction separate from the verification decision." actions={<Button variant="secondary" onClick={() => navigate('/vendor-verification')}><ArrowLeft size={16} aria-hidden="true" /> Back to queue</Button>} /><section className="grid gap-5 border-b border-border-default pb-4 lg:grid-cols-[1.2fr_.8fr]"><div><div className="flex flex-wrap items-center gap-3"><StatusBadge label={statusLabel(stringValue(organization.verificationStatus, stringValue(organization.store_verification_status, 'PENDING_VERIFICATION')))} tone={statusTone(stringValue(organization.verificationStatus, stringValue(organization.store_verification_status, 'PENDING_VERIFICATION')))} /><StatusBadge label={`Activation: ${statusLabel(stringValue(organization.activationStatus, stringValue(organization.store_activation_status, 'NOT_READY')))}`} tone={statusTone(stringValue(organization.activationStatus, stringValue(organization.store_activation_status, 'NOT_READY')))} /></div><dl className="mt-3 grid gap-3 text-sm sm:grid-cols-2 2xl:grid-cols-4"><DetailDatum label="Registered name" value={stringValue(organization.registeredName, stringValue(organization.registered_name, stringValue(organization.legalName, stringValue(organization.legal_name, 'Not recorded'))))} /><DetailDatum label="Business type" value={statusLabel(stringValue(organization.businessType, stringValue(organization.business_type, 'Not recorded')))} /><DetailDatum label="Store email" value={stringValue(organization.storeEmail, stringValue(organization.store_email, 'Not recorded'))} /><DetailDatum label="Store phone" value={stringValue(organization.storePhone, stringValue(organization.store_phone, 'Not recorded'))} /></dl></div><div className="border-t border-border-default pt-5 lg:border-l lg:border-t-0 lg:pl-6"><p className="text-xs font-semibold uppercase tracking-[0.14em] text-action-primary">Activation readiness</p><h2 className="mt-2 text-xl font-semibold">{booleanValue(readiness.ready) ? 'Ready, pending Vendor activation.' : 'Blocked by current requirements.'}</h2><div className="mt-4 grid gap-2">{records(readiness.blockers).slice(0, 4).map((blocker) => <p className="text-sm leading-6 text-text-secondary" key={`${stringValue(blocker.key)}-${stringValue(blocker.reason)}`}><span className="font-semibold text-text-strong">{stringValue(blocker.key)}:</span> {stringValue(blocker.reason)}</p>)}</div></div></section><WorkstreamPanel detail={detail} />{message && <StatusMessage tone={message.tone}>{message.text}</StatusMessage>}<ChecklistPanel title="Verification requirements" items={checklist} compact selectedKey={selectedItem?.key}
      renderAction={item => <Button variant="quiet" disabled={busy} aria-current={selectedItem?.key === item.key ? 'true' : undefined} aria-label={`Review ${item.label}`} onClick={() => { setSelectedKey(item.key); setMessage(null); setDecision('APPROVED'); setReason(''); setDocumentNumber(''); setIssueDate(''); setExpirationKind('UNVERIFIED'); setExpirationDate(''); setEvidenceSource(''); setRemarks('') }}>Review</Button>}
      /><div className="grid items-start gap-5 xl:grid-cols-[minmax(0,1.4fr)_minmax(0,1fr)]"><ReviewInformation selectedItem={selectedItem} selectedDocuments={selectedDocuments} detail={detail} /><div className="grid min-w-0 gap-5"><DecisionPanel authorityFields={stringValue(selectedStep?.key) === 'authority_to_act' ? <fieldset className="grid gap-4"><legend className="font-semibold">Authority to Act evidence and scope</legend><label className="grid gap-2 text-sm font-semibold">Evidence version<select className="min-h-12 rounded-control border border-border-default bg-surface-primary px-3 font-normal" value={authorityEvidence} onChange={event => setAuthorityEvidence(event.target.value)}><option value="">Select reviewed evidence</option>{documents.filter(doc => ['business_registration', 'authority_to_act'].includes(stringValue(doc.requirement_key, stringValue(doc.requirementKey)))).map(doc => <option key={stringValue(doc.version_id, stringValue(doc.versionId))} value={stringValue(doc.version_id, stringValue(doc.versionId))}>{statusLabel(stringValue(doc.requirement_key, stringValue(doc.requirementKey)))} — version {numberValue(doc.version)}</option>)}</select></label><p className="text-sm">Confirm the named representative, organization, capacity, signatures, and dates. Approve only the scopes supported by this evidence.</p>{([['TAX_DECLARATIONS', 'Tax declarations'], ['COMMISSION_AGREEMENT', 'Commission Agreement'], ['PAYMENT_CONFIGURATION', 'Payment configuration']] as const).map(([scope, label]) => <label key={scope} className="flex min-h-11 items-center gap-3 text-sm"><input type="checkbox" className="h-5 w-5 accent-action-primary" checked={authorityScopes.includes(scope)} onChange={event => setAuthorityScopes(event.target.checked ? [...authorityScopes, scope] : authorityScopes.filter(item => item !== scope))} />{label}</label>)}</fieldset> : undefined} selectedItem={selectedItem} selectedStep={selectedStep} selectedDocuments={selectedDocuments} detail={detail} decision={decision} setDecision={setDecision} reason={reason} setReason={setReason} documentNumber={documentNumber} setDocumentNumber={setDocumentNumber} issueDate={issueDate} setIssueDate={setIssueDate} expirationKind={expirationKind} setExpirationKind={setExpirationKind} expirationDate={expirationDate} setExpirationDate={setExpirationDate} evidenceSource={evidenceSource} setEvidenceSource={setEvidenceSource} verifiedVatCategory={verifiedVatCategory} setVerifiedVatCategory={setVerifiedVatCategory} remarks={remarks} setRemarks={setRemarks} busy={busy} onSubmit={submitDecision} /><RestrictionPanel activationStatus={stringValue(organization.activationStatus, stringValue(organization.store_activation_status, 'NOT_READY'))} reason={restrictionReason} setReason={setRestrictionReason} busy={busy} onRestrict={() => void changeRestriction('restrict')} onRestore={() => void changeRestriction('restore')} /></div></div><ReviewHistory reviews={reviews} />{authorityReviews.length > 0 && <section className="border-t border-border-default pt-6"><h2 className="text-xl font-semibold">Authority decision history</h2><div className="mt-4 grid gap-3">{authorityReviews.map(review => <p className="text-sm" key={stringValue(review.id)}>Representative version {numberValue(review.version)} · {statusLabel(stringValue(review.decision))} · Scopes: {stringValue(review.scope, 'None')} · {stringValue(review.reason)} · {formatDate(review.reviewed_at ?? review.reviewedAt)}</p>)}</div></section>}</div></AdminShell>
}

const pick = (value: JsonRecord, camel: string, snake: string): unknown => value[camel] ?? value[snake]

/**
 * Phase 16: the separate Vendor workstreams and the StoreActivationGate result explained by source revision.
 * Teams and products never block activation, and there is no provider-ready override control.
 */
function WorkstreamPanel({ detail }: { detail: VerificationDetail }) {
  const streams = record(detail.workstreams)
  const restrictions = record(pick(detail, 'activationRestrictions', 'activation_restrictions'))
  if (Object.keys(streams).length === 0 && Object.keys(restrictions).length === 0) return null
  const provider = record(pick(streams, 'providerReadiness', 'provider_readiness'))
  const activation = record(streams.activation)
  const discoverability = record(streams.discoverability)
  const items = [
    { label: 'Verification', status: stringValue(record(streams.verification).status, 'PENDING_VERIFICATION'), note: 'Business Information is decided per requirement group; documents keep their own decisions.' },
    { label: 'Setup', status: stringValue(record(streams.setup).status, 'NOT_STARTED'), note: 'Store profile, hours, media and delivery.' },
    { label: 'TEST provider readiness', status: stringValue(provider.status, 'NOT_CONNECTED'), note: `${stringValue(provider.environment, 'TEST')} · ${stringValue(provider.note, 'Readiness comes only from the provider.')}${stringValue(pick(provider, 'lastErrorCode', 'last_error_code')) ? ` Last error ${stringValue(pick(provider, 'lastErrorCode', 'last_error_code'))}.` : ''}` },
    { label: 'Activation', status: stringValue(activation.status, 'NOT_READY'), note: stringValue(pick(activation, 'holdCode', 'hold_code')) ? `Hold: ${statusLabel(stringValue(pick(activation, 'holdCode', 'hold_code')))}` : 'Activated by the Vendor Owner once every gate passes.' },
    { label: 'Discovery', status: stringValue(discoverability.status, 'NOT_DISCOVERABLE'), note: stringValue(discoverability.reason, 'Shown to Buyers only while active and eligible.') },
  ]
  const blockers = records(restrictions.blockers)
  const notBlocking = Array.isArray(pick(restrictions, 'notBlocking', 'not_blocking')) ? (pick(restrictions, 'notBlocking', 'not_blocking') as unknown[]).map(item => String(item)) : []
  return <section aria-labelledby="workstreams" className="grid gap-4 rounded-surface border border-border-default bg-surface-primary p-4">
    <div><h2 id="workstreams" className="text-lg font-semibold">Workstreams and activation restrictions</h2><p className="mt-1 text-sm text-text-secondary">Each state is tracked separately. Activation is evaluated by the store activation gate{stringValue(pick(restrictions, 'ruleVersion', 'rule_version')) ? ` (rule ${stringValue(pick(restrictions, 'ruleVersion', 'rule_version'))})` : ''}; there is no override that marks a provider ready.</p></div>
    <dl className="grid gap-3 sm:grid-cols-2 xl:grid-cols-5">{items.map(item => <div key={item.label} className="min-w-0 rounded-control border border-border-default p-3"><dt className="text-[13px] font-medium text-text-secondary">{item.label}</dt><dd className="mt-1"><StatusBadge label={statusLabel(item.status)} tone={statusTone(item.status)} /></dd><dd className="mt-2 break-words text-[13px] text-text-secondary">{item.note}</dd></div>)}</dl>
    {blockers.length === 0 ? <p className="text-sm text-text-secondary">No activation blockers recorded.</p> : <div className="overflow-x-auto"><table className="w-full min-w-[720px] text-left text-sm"><caption className="sr-only">Activation blockers with their source revisions</caption>
      <thead className="text-[13px] text-text-secondary"><tr>{['Category', 'Blocker', 'Source', 'Revision', 'Source status'].map(head => <th key={head} scope="col" className="px-3 py-2 font-semibold">{head}</th>)}</tr></thead>
      <tbody className="divide-y divide-border-default">{blockers.map(blocker => { const source = record(blocker.source); return <tr key={`${stringValue(blocker.key)}-${numberValue(blocker.condition)}`} className="align-top">
        <td className="px-3 py-2">{statusLabel(stringValue(blocker.category))}</td><th scope="row" className="px-3 py-2 text-left font-normal">{stringValue(blocker.reason)}</th>
        <td className="px-3 py-2">{stringValue(source.label, statusLabel(stringValue(source.type, 'Unknown')))}</td><td className="px-3 py-2 tabular-nums">{source.revision === null || source.revision === undefined ? '—' : `v${numberValue(source.revision)}`}</td>
        <td className="px-3 py-2">{source.status ? statusLabel(stringValue(source.status)) : '—'}{pick(source, 'updatedAt', 'updated_at') ? <p className="text-[13px] text-text-secondary">{formatDate(pick(source, 'updatedAt', 'updated_at'))}</p> : null}</td></tr> })}</tbody></table></div>}
    {notBlocking.length > 0 && <ul className="grid gap-1 text-[13px] text-text-secondary">{notBlocking.map(note => <li key={note}>Not blocking: {note}</li>)}</ul>}
  </section>
}
function booleanValue(value: unknown): boolean {
  return value === true
}

function DetailDatum({ label, value }: { label: string; value: string }) {
  return <div className="min-w-0"><dt className="text-xs leading-5 text-text-secondary">{label}</dt><dd className="mt-0.5 break-words text-sm font-medium leading-5 text-text-strong">{value}</dd></div>
}



type ReviewItem = ReturnType<typeof verificationChecklist>[number]

type DecisionPanelProps = {
  authorityFields?: ReactNode
  selectedItem: ReviewItem | undefined
  selectedStep: JsonRecord | undefined
  selectedDocuments: JsonRecord[]
  detail: VerificationDetail
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
}

function ReviewInformation({ selectedItem, selectedDocuments, detail }: Pick<DecisionPanelProps, 'selectedItem' | 'selectedDocuments' | 'detail'>) {
  const isBusiness = selectedItem?.key === 'business_information_group'
  const evidenceItems: PrivateEvidenceItem[] = selectedDocuments.flatMap(document => {
    const fileId = stringValue(document.fileId, stringValue(document.file_id))
    if (!fileId) return []
    const key = stringValue(document.requirementKey, stringValue(document.requirement_key))
    const label = key.includes('back') ? 'Government ID — Back' : ['identity_evidence', 'representative_identity'].includes(key) ? 'Government ID — Front / identity page' : selectedItem?.label ?? statusLabel(key)
    return [{ id: fileId, label, loadUrl: () => getAdminVendorEvidenceUrl(fileId) }]
  })

  return <section className="min-w-0 rounded-surface border border-border-default bg-surface-primary p-4 sm:p-5" aria-labelledby="review-information-title">
    <div className="flex flex-wrap items-center justify-between gap-3"><h2 id="review-information-title" className="text-lg font-semibold">{selectedItem?.label ?? 'Submitted information'}</h2>{selectedItem && <StatusBadge label={statusLabel(selectedItem.status)} tone={statusTone(selectedItem.status)} />}</div>
    {selectedItem && <div className="mt-4 border-t border-border-default pt-4"><h3 className="text-lg font-semibold">Submitted information</h3><div className="mt-4"><CaseInformation detail={detail} selectedKey={selectedItem.key} /></div></div>}
    {selectedItem && !isBusiness && <div className="mt-4 border-t border-border-default pt-4"><h3 className="text-lg font-semibold">Supporting evidence</h3>{selectedDocuments.length > 0 && <p className="mt-1 text-sm text-text-secondary">Current submitted versions. Images and PDFs load here through your authorized session.</p>}{selectedDocuments.map(document => <p className="mt-2 text-xs text-text-secondary" key={stringValue(document.id)}>Version {numberValue(document.version) || 'unavailable'} · Scan: {statusLabel(stringValue(document.scanState, stringValue(document.scan_state, 'UNAVAILABLE')))}</p>)}<div className="mt-4">{evidenceItems.length ? <PrivateEvidenceGallery key={selectedItem.key} items={evidenceItems} apiBasePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} /> : <p className="text-sm text-text-secondary">No current submitted evidence is available for this requirement.</p>}</div></div>}
    {isBusiness && <p className="mt-4 border-t border-border-default pt-4 text-sm text-text-secondary">Government ID, BIR registration, business registration, and permits have their own review decisions in the list.</p>}
  </section>
}

function DecisionPanel(props: DecisionPanelProps) {
  const { selectedItem, decision, setDecision, reason, setReason, documentNumber, setDocumentNumber, issueDate, setIssueDate, expirationKind, setExpirationKind, expirationDate, setExpirationDate, evidenceSource, setEvidenceSource, verifiedVatCategory, setVerifiedVatCategory, remarks, setRemarks, busy, onSubmit } = props
  const isBusiness = selectedItem?.key === 'business_information_group'

  return <section className="min-w-0 rounded-surface border border-border-default bg-surface-primary p-4 sm:p-5" aria-labelledby="decision-title">
    <div className="flex items-start gap-3"><BadgeCheck className="mt-1 shrink-0 text-action-primary" size={22} aria-hidden="true" /><div><h2 id="decision-title" className="text-lg font-semibold">Record decision</h2><p className="mt-2 text-sm leading-6 text-text-secondary">Review the submitted information and current evidence before recording a decision.</p></div></div>
    <div className="mt-4 border-t border-border-default pt-4"><h3 className="text-xs font-semibold uppercase tracking-[0.14em] text-action-primary">Selected requirement</h3><div className="mt-2 flex flex-wrap items-center gap-3"><p className="text-lg font-semibold">{selectedItem?.label ?? 'Select a requirement'}</p>{selectedItem && <StatusBadge label={statusLabel(selectedItem.status)} tone={statusTone(selectedItem.status)} />}</div>{selectedItem?.reason && <p className="mt-2 text-sm text-text-secondary">{selectedItem.reason}</p>}</div>
    <form className="mt-4 border-t border-border-default pt-4" onSubmit={onSubmit}>
      {!isBusiness && selectedItem && <div className="mb-6"><h3 className="text-lg font-semibold">Verification details</h3><div className="mt-4 grid gap-4 sm:grid-cols-2"><Field label="Verified document number" name="verified_document_number" value={documentNumber} onChange={event => setDocumentNumber(event.target.value)} /><Field label="Evidence source" name="evidence_source" value={evidenceSource} onChange={event => setEvidenceSource(event.target.value)} /><Field label="Issue date" name="verified_issue_date" type="date" value={issueDate} onChange={event => setIssueDate(event.target.value)} /><label className="grid gap-2 text-sm font-semibold" htmlFor="expiration_kind">Expiration<select className="min-h-12 rounded-control border border-border-default bg-surface-primary px-3 text-base font-normal" id="expiration_kind" value={expirationKind} onChange={event => setExpirationKind(event.target.value)}><option value="UNVERIFIED">Not verified</option><option value="DATE">Has expiration date</option><option value="NO_EXPIRATION">No expiration</option></select></label>{expirationKind === 'DATE' && <Field label="Expiration date" name="verified_expiration_date" type="date" value={expirationDate} onChange={event => setExpirationDate(event.target.value)} />}{selectedItem.key === 'bir_cor' && <label className="grid gap-2 text-sm font-semibold" htmlFor="verified_vat_category">VAT category verified by Admin<select className="min-h-12 rounded-control border border-border-default bg-surface-primary px-3 py-3 text-base font-normal" id="verified_vat_category" value={verifiedVatCategory} onChange={event => setVerifiedVatCategory(event.target.value)}><option value="">Not verified</option><option value="VAT">VAT</option><option value="NON_VAT">Non-VAT</option><option value="VAT_ZERO">VAT zero-rated</option><option value="VAT_EXEMPT">VAT exempt</option></select></label>}</div></div>}
      {props.authorityFields && <div className="mb-6">{props.authorityFields}</div>}
      <h3 className="text-lg font-semibold">Admin decision</h3><div className="mt-3 grid gap-3"><label className="grid gap-2 text-sm font-semibold" htmlFor="decision">Decision<select className="min-h-12 rounded-control border border-border-default bg-surface-primary px-3 text-base font-normal" id="decision" value={decision} onChange={event => setDecision(event.target.value)}><option value="APPROVED">Approve</option><option value="CHANGES_REQUIRED">Request correction</option><option value="REJECTED">Reject</option></select></label><label className="grid gap-2 text-sm font-semibold" htmlFor="decision_reason">Reason {decision !== 'APPROVED' && <span className="text-status-error" aria-hidden="true">*</span>}<textarea className="min-h-20 rounded-control border border-border-default bg-surface-primary px-3 py-3 text-base font-normal" id="decision_reason" value={reason} onChange={event => setReason(event.target.value)} placeholder={decision === 'APPROVED' ? 'Optional approval note' : 'Explain the correction or rejection clearly.'} required={decision !== 'APPROVED'} /></label><label className="grid gap-2 text-sm font-semibold" htmlFor="review_remarks">Reviewer remarks<textarea className="min-h-20 rounded-control border border-border-default bg-surface-primary px-3 py-3 text-base font-normal" id="review_remarks" value={remarks} onChange={event => setRemarks(event.target.value)} /></label><Button type="submit" className="w-fit" disabled={busy || !selectedItem}>{busy ? 'Recording…' : 'Record requirement decision'} <Check size={16} aria-hidden="true" /></Button></div>
    </form>
  </section>
}

function CaseInformation({ detail, selectedKey }: { detail: VerificationDetail; selectedKey: string }) {
  const organization = record(detail.organization)
  const identity = record(detail.legal_identity ?? detail.legalIdentity)
  const representative = record(detail.representative)
  const address = record(detail.address)
  const classification = record(detail.classification)
  const tax = record(detail.tax_profile ?? detail.taxProfile)
  const taxDetails = record(tax.details)
  const privacyStep = records(record(detail.sections).STORE_VERIFICATION).find(step => step.key === 'privacy_acknowledgement')
  const fullName = [stringValue(identity.first_name, stringValue(identity.firstName)), stringValue(identity.middle_name, stringValue(identity.middleName)), stringValue(identity.surname), stringValue(identity.suffix)].filter(Boolean).join(' ')
  const fields: [string, string][] = selectedKey === 'business_information_group' ? [
    ['Business type', statusLabel(stringValue(organization.business_type, stringValue(organization.businessType)))],
    ['Registered business / legal name', stringValue(organization.registered_name, stringValue(organization.registeredName, stringValue(organization.legal_name, stringValue(organization.legalName))))],
    ['Store or trade name', stringValue(organization.store_name, stringValue(organization.storeName))],
    ['Date established', formatDate(organization.date_established ?? organization.dateEstablished)],
    ['Registered legal identity', fullName || stringValue(identity.company_registered_name, stringValue(identity.companyRegisteredName))],
    ['Registered business address', stringValue(address.formatted_address, stringValue(address.formattedAddress, [stringValue(address.street), stringValue(address.barangay), stringValue(address.city_municipality, stringValue(address.cityMunicipality)), stringValue(address.province), stringValue(address.postal_code, stringValue(address.postalCode))].filter(Boolean).join(', ')))],
    ['Supplier classification', statusLabel(stringValue(classification.supplier_type, stringValue(classification.supplierType)))],
    ['Supplier niches', Array.isArray(classification.niches) ? classification.niches.filter(value => typeof value === 'string').join(', ') : ''],
    ['Other supplier category', Array.isArray(classification.custom_labels) ? classification.custom_labels.filter(value => typeof value === 'string').join(', ') : stringValue(classification.custom_label)],
    ['Store email', stringValue(organization.store_email, stringValue(organization.storeEmail))],
    ['Store phone', stringValue(organization.store_phone, stringValue(organization.storePhone))],
    ['Authorized representative', stringValue(representative.full_name, stringValue(representative.fullName))],
    ['Representative capacity', stringValue(representative.position)],
    ['Tax entity class', statusLabel(stringValue(tax.entity_class, stringValue(tax.entityClass)))],
    ['Tax registration category', statusLabel(stringValue(tax.registration_category, stringValue(tax.registrationCategory)))],
    ['Declared VAT category', statusLabel(stringValue(tax.vat_category, stringValue(tax.vatCategory)))],
    ['Verified VAT category', statusLabel(stringValue(tax.vat_verified_category, stringValue(tax.vatVerifiedCategory)))],
    ['TIN ending', stringValue(tax.tin_last4, stringValue(tax.tinLast4))],
    ['Taxpayer key ending', stringValue(tax.taxpayer_key_last4, stringValue(tax.taxpayerKeyLast4))],
    ['BIR COR reference', stringValue(tax.bir_cor_reference, stringValue(tax.birCorReference))],
    ['Tax relief claimed', typeof taxDetails.tax_relief_claimed === 'boolean' ? taxDetails.tax_relief_claimed ? 'Yes' : 'No' : ''],
    ['Sworn Declaration year', taxDetails.declaration_year == null ? '' : String(taxDetails.declaration_year)],
    ['Owner tax attestation', Object.keys(tax).length ? tax.owner_attested === true || tax.ownerAttested === true ? 'Yes' : 'No' : ''],
    ['Privacy acknowledgement', privacyStep ? statusLabel(stringValue(privacyStep.status)) : ''],
  ] : selectedKey === 'legal_identity_id' ? [
    ['Full legal name', fullName],
    ['Company registered name', stringValue(identity.company_registered_name, stringValue(identity.companyRegisteredName))],
    ['ID type', statusLabel(stringValue(identity.id_type, stringValue(identity.idType)))],
    ['ID number ending', stringValue(identity.id_number_last4, stringValue(identity.idNumberLast4))],
  ] : ['representative_id', 'authority_to_act'].includes(selectedKey) ? [
    ['Full legal name', stringValue(representative.full_name, stringValue(representative.fullName))],
    ['Position / title', stringValue(representative.position)],
    ['Relationship', statusLabel(stringValue(representative.relationship))],
    ['ID number ending', stringValue(representative.id_number_last4, stringValue(representative.idNumberLast4))],
    ['Representative version', String(numberValue(representative.version) || '')],
  ] : selectedKey === 'bir_cor' || selectedKey === 'tax_relief_evidence' ? [
    ['Registered business name', stringValue(organization.registered_name, stringValue(organization.registeredName))],
    ['TIN ending', stringValue(tax.tin_last4, stringValue(tax.tinLast4))],
    ['Declared VAT category', statusLabel(stringValue(tax.vat_category, stringValue(tax.vatCategory)))],
    ['BIR COR reference', stringValue(tax.bir_cor_reference, stringValue(tax.birCorReference))],
  ] : selectedKey === 'lgu_permit' ? [
    ['Registered business address', stringValue(address.formatted_address, stringValue(address.formattedAddress))],
    ['Registered business name', stringValue(organization.registered_name, stringValue(organization.registeredName))],
  ] : [
    ['Registered business name', stringValue(organization.registered_name, stringValue(organization.registeredName))],
    ['Business type', statusLabel(stringValue(organization.business_type, stringValue(organization.businessType)))],
  ]
  const showFields = (rows: [string, string][]) => <dl className="grid gap-x-6 gap-y-3 sm:grid-cols-2">{rows.filter(([, value]) => value && value !== 'Not recorded').map(([label, value]) => <DetailDatum key={label} label={label} value={value} />)}</dl>
  if (selectedKey === 'business_information_group') {
    return <div className="space-y-4">
      <div><h4 className="mb-2 text-xs font-semibold uppercase tracking-wide text-text-secondary">Business and legal details</h4>{showFields(fields.slice(0, 6))}</div>
      <div className="border-t border-border-default pt-4"><h4 className="mb-2 text-xs font-semibold uppercase tracking-wide text-text-secondary">Supplier classification</h4>{showFields(fields.slice(6, 9))}</div>
      <div className="border-t border-border-default pt-4"><h4 className="mb-2 text-xs font-semibold uppercase tracking-wide text-text-secondary">Contact and representative</h4>{showFields(fields.slice(9, 13))}</div>
      <div className="border-t border-border-default pt-4"><h4 className="mb-2 text-xs font-semibold uppercase tracking-wide text-text-secondary">Tax information</h4>{showFields(fields.slice(13, -1))}</div>
      <div className="border-t border-border-default pt-4"><h4 className="mb-2 text-xs font-semibold uppercase tracking-wide text-text-secondary">Privacy notice</h4>{showFields(fields.slice(-1))}</div>
    </div>
  }
  return fields.some(([, value]) => value && value !== 'Not recorded') ? showFields(fields) : <p className="text-sm text-text-secondary">No submitted values are available for this requirement.</p>
}

function RestrictionPanel({ activationStatus, reason, setReason, busy, onRestrict, onRestore }: { activationStatus: string; reason: string; setReason: (value: string) => void; busy: boolean; onRestrict: () => void; onRestore: () => void }) {
  return <section className="rounded-surface border border-border-default bg-surface-primary p-4 sm:p-5" aria-labelledby="restriction-title"><div className="flex items-start gap-3"><ShieldAlert className="mt-1 shrink-0 text-action-primary" size={22} aria-hidden="true" /><div><h2 id="restriction-title" className="text-lg font-semibold">Activation restriction</h2><p className="mt-2 text-sm leading-6 text-text-secondary">Restriction is a separate Admin action. It does not rewrite the verification review history.</p></div></div><div className="mt-4"><StatusBadge label={`Current: ${statusLabel(activationStatus)}`} tone={statusTone(activationStatus)} /></div><label className="mt-4 grid gap-2 text-sm font-semibold" htmlFor="restriction_reason">Reason<textarea className="min-h-20 rounded-control border border-border-default bg-surface-primary px-3 py-3 text-base font-normal" id="restriction_reason" value={reason} onChange={(event) => setReason(event.target.value)} placeholder="Explain why activation should be restricted or restored." /></label><div className="mt-4 flex flex-wrap gap-3"><Button disabled={busy} variant="secondary" onClick={onRestrict}>Restrict activation</Button><Button disabled={busy} onClick={onRestore}>Restore activation</Button></div></section>
}

function ReviewHistory({ reviews }: { reviews: JsonRecord[] }) {
  return <section className="border-t border-border-default pt-6" aria-labelledby="review-history-title">
    <div className="flex items-center gap-3"><FileText className="text-action-primary" size={20} aria-hidden="true" /><div><h2 id="review-history-title" className="text-xl font-semibold">Immutable review history</h2><p className="mt-1 text-sm text-text-secondary">Each evidence version keeps its decision, reviewer notes, and expiration metadata.</p></div></div>
    {reviews.length === 0 ? <p className="mt-5 border-y border-border-default py-5 text-sm text-text-secondary">No requirement decisions have been recorded yet.</p> : <div className="relative mt-5 overflow-x-auto border-y border-border-default">
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

