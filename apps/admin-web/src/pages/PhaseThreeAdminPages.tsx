import { BackNavigation, DateFilter, dateFilterPreset, dateRangePatch, FilterPanel, FilterTabs, Pagination, QueueSectionLinks, QueueSurface, useQueueStatusCounts, ResponsiveRecordList, ChecklistPanel, verificationChecklist, PrivateEvidenceGallery, PageHeader as SharedPageHeader, PortalPagePatterns, type PrivateEvidenceItem, type RecordColumn } from '@materyalph/web-ui'
import { parseDate, type AdminVendorVerificationQueueItem } from '@materyalph/api-client-ts'
import { AsyncLoading, RequestErrorState } from '@materyalph/web-ui'
import {
  Activity,
  ChartNoAxesCombined,
  CreditCard,
  History,
  LayoutDashboard,
  Scale,
  Settings,
  ShieldCheck,
  Store,
  Users,
  BadgeCheck,
  Check,
  ClipboardCheck,
  ContactRound,
  FileText,
  Lock,
  RefreshCw,
  ShieldAlert,
} from 'lucide-react'
import { type FormEvent, type ReactNode, useCallback, useEffect, useState } from 'react'
import { Link, useNavigate, useParams, useSearchParams } from 'react-router-dom'

import { Button, Field, PortalShell, StatusBadge, StatusMessage, useNavigationUpdates, type PortalNavSection } from '@materyalph/web-ui'
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
import { useAdminQueue, useQueueParams } from '../lib/use-admin-queue'

const adminModuleIcons: Record<string, typeof FileText> = { 'vendor-verification': Store,'marketplace-analytics': ChartNoAxesCombined, 'buyer-management': Users, 'product-compliance': ShieldCheck, disputes: Scale, enforcement: ShieldAlert, moderation: ClipboardCheck, transactions: CreditCard, settings: Settings, integrations: Activity }
const adminModuleHrefs: Record<string, string> = { 'vendor-verification': '/vendor-verification','marketplace-analytics': '/analytics', 'buyer-management': '/buyer-management', 'product-compliance': '/product-compliance', disputes: '/disputes', enforcement: '/enforcement', moderation: '/reviews', transactions: '/finance', settings: '/settings', support: '/support', integrations: '/integrations' }
const adminNavigation: PortalNavSection[] = [
  { label: 'Overview', items: [{ label: 'Dashboard', href: '/dashboard', icon: <LayoutDashboard size={16} aria-hidden="true" /> }] },
  { label: 'User Management', items: [
    { label: 'Vendor Users', href: '/vendor-users', icon: <ContactRound size={18} aria-hidden="true" /> },
    { label: 'Buyer Users', href: '/buyer-users', icon: <ContactRound size={18} aria-hidden="true" /> },
  ] },
  ...[['Marketplace', [['Marketplace Analytics', 'marketplace-analytics']]], ['Compliance & quality', [['Vendor Verification', 'vendor-verification'],['Product Compliance Queue', 'product-compliance'], ['Disputes & Appeals', 'disputes'], ['Enforcement', 'enforcement'], ['Review Moderation', 'moderation'], ['Support Requests', 'support']]], ['Platform', [['Platform Finance', 'transactions'], ['Platform Settings', 'settings'], ['Platform Monitoring', 'integrations']]]].map(([label, entries]) => ({ label: label as string, items: (entries as string[][]).map(([label = '', key = '']) => ({ label, href: adminModuleHrefs[key] ?? `/preview/${key}`, icon: (() => { const Icon = adminModuleIcons[key] ?? FileText; return <Icon size={18} aria-hidden="true" /> })() })) })),
  { label: 'Tracking', items: [{ label: 'Audit Log', href: '/audit', icon: <History size={16} aria-hidden="true" /> }] },
]

function adminDate(): string {
  return new Intl.DateTimeFormat('en-PH', { dateStyle: 'full', timeZone: 'Asia/Manila' }).format(new Date())
}

export function LoadingState() {
  return <AsyncLoading label="Loading workspace…" framed />
}

export function ErrorState({ message, onRetry }: { message: string; onRetry: () => void }) {
  return <RequestErrorState message={message} onRetry={onRetry} />
}

export function AdminShell({ activeHref, children, headerNotice }: { activeHref: string; children: ReactNode; headerNotice?: ReactNode }) {
  const navigate = useNavigate()
  const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'
  const counts = useNavigationUpdates({ basePath, audience: 'admin' })
  const sections = adminNavigation.map(section => ({ ...section, items: section.items.map(item => ({ ...item, updateCount: counts?.[item.href] ?? 0, updateCountLabel: 'pending item' })) }))
  return <PortalShell headerNotice={headerNotice} apiBasePath={basePath} onNavigate={navigate} notificationUnreadCount={counts?.['/notifications'] ?? 0} headerActions={<Link className="inline-flex min-h-11 items-center text-sm font-semibold" to="/workspace">Account settings</Link>} homeHref="/dashboard" portalLabel="ADMIN PORTAL" pageTitle={activeHref === '/dashboard' ? 'Dashboard' : activeHref === '/notifications' ? 'Notifications' : activeHref === '/workspace' ? 'Settings' : activeHref === '/audit' ? 'Audit tracking' : adminNavigation.flatMap(section => section.items).find(item => item.href === activeHref)?.label ?? 'Vendor Verification'} dateLabel={adminDate()} sections={sections} activeHref={activeHref} accountLabel="Admin review team" accountStatus="Audited access"><PortalPagePatterns.Provider value><div className="admin-page text-sm">{children}</div></PortalPagePatterns.Provider></PortalShell>
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
  return <input type="number" min={1} max={365} inputMode="numeric" aria-label={label} placeholder="Any" className="min-h-11 w-full rounded-control border border-border-default bg-surface-primary px-3 text-sm text-text-strong" value={draft} onChange={event => setDraft(event.target.value)} onBlur={commit} onKeyDown={event => { if (event.key === 'Enter') commit() }} />
}

export function AdminVendorVerificationQueuePage() {
  const { params, page, range, change: patchParams, setPage, context } = useQueueParams()
  const filters = { ...blankVerificationFilters, status: verificationTabs.includes(params.get('status') ?? '') ? params.get('status')! : 'PENDING_VERIFICATION',
    submittedFrom: range.from, submittedTo: range.to, regionCode: params.get('region') ?? '', sort: params.get('sort') ?? 'submitted_desc', setupStatus: params.get('setup') ?? '', activation: params.get('activation') ?? '', discoverability: params.get('discovery') ?? '', blocker: params.get('blocker') ?? '', ageDays: params.get('age') ?? '', expiryDays: params.get('expiry') ?? '' }
  const change = (patch: Partial<typeof filters>) => {
    const names: Record<string, string> = { submittedFrom: 'from', submittedTo: 'to', regionCode: 'region', setupStatus: 'setup', discoverability: 'discovery', ageDays: 'age', expiryDays: 'expiry' }
    patchParams(Object.fromEntries(Object.entries(patch).map(([key, value]) => [names[key] ?? key, value])))
  }
  const queue = useAdminQueue(`verification:${JSON.stringify(filters)}:${page}`, () => listVendorVerificationQueue({
    status: filters.status, ...(filters.regionCode ? { regionCode: filters.regionCode } : {}), ...(range.from ? { submittedFrom: parseDate(range.from) } : {}), ...(range.to ? { submittedTo: parseDate(range.to) } : {}),
    ...(filters.setupStatus ? { setupStatus: filters.setupStatus as never } : {}), ...(filters.activation ? { activation: filters.activation as never } : {}), ...(filters.discoverability ? { discoverability: filters.discoverability as never } : {}),
    ...(filters.blocker ? { blocker: filters.blocker as never } : {}), ...(filters.ageDays ? { ageDays: Number(filters.ageDays) } : {}), ...(filters.expiryDays ? { expiryDays: Number(filters.expiryDays) } : {}), sort: filters.sort as never, page,
  }))
  const items = queue.data?.items ?? []
  const meta = queue.data?.meta ?? {}
  const counts = useQueueStatusCounts(meta.status_counts, Boolean(queue.error))
  const total = typeof meta.total === 'number' ? meta.total : null
  const reset = () => patchParams({ region: '', sort: '', setup: '', activation: '', discovery: '', blocker: '', age: '', expiry: '', ...dateRangePatch(dateFilterPreset(30)) })
  const href = (id: string) => `/vendor-verification/${id}${context}`
  const identity = (item: AdminVendorVerificationQueueItem) => <div className="grid gap-1"><Link className="inline-flex min-h-11 items-center font-semibold text-action-primary hover:underline" to={href(item.id)}>{item.storeName}</Link><p className="text-xs text-text-secondary">{item.registeredName ?? 'Registered name pending'}</p><p className="text-xs text-text-secondary">{[item.regionName, item.province, item.cityMunicipality].filter(Boolean).join(' · ') || 'Address not recorded'}</p></div>
  const columns: RecordColumn<AdminVendorVerificationQueueItem>[] = [
    { key: 'store', header: 'Store · location', cell: identity },
    { key: 'verification', header: 'Verification', cell: item => <div className="grid justify-items-start gap-2"><StatusBadge label={statusLabel(item.verificationStatus)} tone={statusTone(item.verificationStatus)} /><ProgressText progress={item.progress} /></div> },
    { key: 'setup', header: 'Setup', cell: item => statusLabel(item.setupStatus ?? 'NOT_STARTED') },
    { key: 'provider', header: 'Provider (TEST)', cell: item => statusLabel(item.providerStatus ?? 'NOT_CONNECTED') },
    { key: 'activation', header: 'Activation', cell: item => <><StatusBadge label={statusLabel(item.activationStatus ?? 'NOT_READY')} tone={statusTone(item.activationStatus ?? 'NOT_READY')} />{item.holdCode && <p className="mt-1 text-xs text-text-secondary">Hold: {statusLabel(item.holdCode)}</p>}</> },
    { key: 'discovery', header: 'Discovery', cell: item => statusLabel(item.discoverabilityStatus ?? 'NOT_DISCOVERABLE') },
    { key: 'pending', header: 'Pending requirements', cell: item => <><p className="font-semibold tabular-nums">{item.pendingRequirements ?? 0} requirement(s)</p><p className="mt-1 text-xs text-text-secondary">{item.oldestPendingAt ? `Oldest ${formatDate(item.oldestPendingAt)}` : `Submitted ${formatDate(item.submittedAt)}`}</p></> },
    { key: 'action', header: 'Action', cell: item => <Link className="inline-flex min-h-11 items-center font-semibold text-action-primary" to={href(item.id)}>Review</Link> },
  ]
  const filterSelect = 'min-h-11 rounded-control border border-border-default bg-surface-primary px-3 font-normal'
  return <AdminShell activeHref="/vendor-verification"><div className="mp-queue-workspace">
    <PageHeader eyebrow="Compliance & quality" title="Vendor Verification" description="Review business requirements and evidence. Verification, setup and activation retain their separate checks." actions={<Button variant="secondary" disabled={queue.loading} onClick={() => void queue.retry()}><RefreshCw size={16} aria-hidden="true" />{queue.loading && queue.data ? 'Refreshing…' : 'Refresh queue'}</Button>} />

    <FilterTabs appearance="chips" label="Review status" value={filters.status} onChange={status => change({ status })} chips={verificationTabs.map(value => ({ value, label: statusLabel(value), ...(typeof counts[value] === 'number' ? { count: counts[value] as number } : {}) }))} />
    <FilterPanel compact label="Verification filters" footer={<div className="mp-filter-date"><span>Submission dates</span><DateFilter title="Submission dates" value={range} onChange={value => patchParams(dateRangePatch(value))} /></div>} actions={<Button variant="quiet" onClick={reset}>Reset filters</Button>}>
      <label>Setup<select className={filterSelect} value={filters.setupStatus} onChange={event => change({ setupStatus: event.target.value })}><option value="">Any setup state</option>{['NOT_STARTED', 'IN_PROGRESS', 'CHANGES_REQUIRED', 'COMPLETED'].map(value => <option key={value} value={value}>{statusLabel(value)}</option>)}</select></label>
      <label>Activation<select className={filterSelect} value={filters.activation} onChange={event => change({ activation: event.target.value })}><option value="">Any activation state</option>{['NOT_ACTIVE', 'NOT_READY', 'READY', 'ACTIVE', 'RESTRICTED', 'SUSPENDED'].map(value => <option key={value} value={value}>{statusLabel(value)}</option>)}</select></label>
      <label>Discovery<select className={filterSelect} value={filters.discoverability} onChange={event => change({ discoverability: event.target.value })}><option value="">Any discovery state</option><option value="DISCOVERABLE">Discoverable</option><option value="NOT_DISCOVERABLE">Not discoverable</option></select></label>
      <label>Activation blocker<select className={filterSelect} value={filters.blocker} onChange={event => change({ blocker: event.target.value })}><option value="">Any blocker</option>{[['MEDIA', 'Store media'], ['HOURS', 'Store hours'], ['DELIVERY', 'Delivery setup'], ['AUTHORITY', 'Authority to act'], ['TERMS', 'Agreements'], ['PROVIDER', 'Provider readiness (TEST)']].map(([value = '', text]) => <option key={value} value={value}>{text}</option>)}</select></label>
      <label>Waiting at least (days)<DaysFilter label="Waiting at least (days)" value={filters.ageDays} onCommit={ageDays => change({ ageDays })} /></label>
      <label>Document expires within (days)<DaysFilter label="Document expires within (days)" value={filters.expiryDays} onCommit={expiryDays => change({ expiryDays })} /></label>
      <label>Sort by<select className={filterSelect} value={filters.sort} onChange={event => change({ sort: event.target.value })}><option value="submitted_desc">Newest submission first</option><option value="submitted_asc">Oldest submission first</option><option value="oldest_pending">Oldest pending requirement first</option></select></label>
    </FilterPanel>
    <QueueSurface title={statusLabel(filters.status)} description="Verification, setup, TEST provider readiness, activation and discovery are separate states." count={total} shown={items.length} loaded={Boolean(queue.data)} busy={queue.loading} error={queue.error && <ErrorState message={queue.error} onRetry={queue.retry} />} emptyTitle={page > 1 ? 'No cases on this page.' : 'No cases match this view.'} emptyDescription="No Vendor cases match the selected status and filters. Choose another status or adjust the submission dates." emptyAction={page > 1 ? <Button variant="secondary" onClick={() => setPage(1)}>Return to first page</Button> : undefined}
      footer={queue.data && (page > 1 || numberValue(meta.last_page, 1) > 1) && <Pagination page={page} lastPage={numberValue(meta.last_page, 1)} total={total ?? 0} busy={queue.loading} onChange={setPage} />}>
      <ResponsiveRecordList compact tableClassName="mp-queue-record-table" caption="Vendor verification cases" rows={items} columns={columns} rowKey={item => item.id} cardTitle={identity} />
    </QueueSurface>
  </div></AdminShell>
}

function ProgressText({ progress }: { progress: { [key: string]: unknown } }) {
  const complete = numberValue(progress.complete)
  const total = numberValue(progress.total)
  return <div><p className="font-semibold">{complete}/{total} required</p><div className="mt-2 h-2 w-32 overflow-hidden rounded-pill bg-brand-orange-100"><div className="h-full bg-brand-orange-600" style={{ width: `${total > 0 ? (complete / total) * 100 : 0}%` }} /></div></div>
}

export function AdminVendorVerificationDetailPage() {
  const { organizationId = '' } = useParams()
  return <VendorVerificationCase key={organizationId} organizationId={organizationId} />
}

function VendorVerificationCase({ organizationId }: { organizationId: string }) {
  const [params] = useSearchParams()
  const back = `/vendor-verification${params.size ? `?${params.toString()}` : ''}`
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
  const pendingPrerequisites = checklist.filter(item => item.key !== 'business_information_group' && item.status !== 'COMPLETED')
  // Open on the first requirement that can be decided now; Business information comes last.
  const selectedItem = checklist.find(item => item.key === selectedKey) ?? pendingPrerequisites[0] ?? checklist[0]
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
    if (busy || loading) return
    if (!selectedItem || !selectedStep) { setMessage({ tone: 'error', text: 'Select a verification requirement first.' }); return }
    if (decision !== 'APPROVED' && reason.trim().length < 3) { setMessage({ tone: 'error', text: 'A reason is required for Changes Required or Reject.' }); return }
    setBusy(true); setMessage(null)
    try {
      const grouped = selectedItem.key !== stringValue(selectedStep.key)
      const requirementVersions = Object.fromEntries(selectedSteps.map(step => [stringValue(step.key), numberValue(step.lockVersion, numberValue(step.lock_version, 1))]))
      const updated = await decideVendorVerificationRequirement(organizationId, selectedItem.key, { decision: decision as import('@materyalph/api-client-ts').AdminVendorVerificationDecision['decision'], ...(grouped ? { requirementVersions } : { lockVersion: numberValue(selectedStep.lockVersion, numberValue(selectedStep.lock_version, 1)) }), reason: reason.trim() || null, verifiedDocumentNumber: documentNumber.trim() || null, verifiedIssueDate: issueDate ? parseDate(issueDate) : null, expirationKind: expirationKind as NonNullable<import('@materyalph/api-client-ts').AdminVendorVerificationDecision['expirationKind']>, verifiedExpirationDate: expirationDate ? parseDate(expirationDate) : null, evidenceSource: evidenceSource.trim() || null, verifiedVatCategory: selectedItem.key === 'bir_cor' && verifiedVatCategory ? verifiedVatCategory as NonNullable<import('@materyalph/api-client-ts').AdminVendorVerificationDecision['verifiedVatCategory']> : null, remarks: remarks.trim() || null, ...(selectedItem.key === 'authority_to_act' ? { authorityEvidenceVersionId: authorityEvidence || null, authorityScopes: authorityScopes as NonNullable<import('@materyalph/api-client-ts').AdminVendorVerificationDecision['authorityScopes']> } : {}) }); setDetail(updated); setMessage({ tone: 'success', text: `${statusLabel(decision)} recorded for ${selectedItem.label}.` }); setReason('') } catch (cause) { setMessage({ tone: 'error', text: await readableVerificationError(cause) }) } finally { setBusy(false) }
  }

  async function changeRestriction(action: 'restrict' | 'restore') {
    if (busy || loading) return
    if (restrictionReason.trim().length < 3) { setMessage({ tone: 'error', text: 'Enter a reason before changing activation restriction.' }); return }
    setBusy(true); setMessage(null)
    try { if (action === 'restrict') await restrictVendorActivation(organizationId, restrictionReason.trim()); else await restoreVendorActivation(organizationId, restrictionReason.trim()); await load(); setMessage({ tone: 'success', text: action === 'restrict' ? 'Activation restriction recorded.' : 'Activation restoration recorded.' }) } catch (cause) { setMessage({ tone: 'error', text: await readableVerificationError(cause) }) } finally { setBusy(false) }
  }

  if (loading && !detail) return <AdminShell activeHref="/vendor-verification"><LoadingState /></AdminShell>
  if (error) return <AdminShell activeHref="/vendor-verification"><ErrorState message={error} onRetry={() => void load()} /></AdminShell>
  if (!detail) return null

  return <AdminShell activeHref="/vendor-verification"><div className="phase3-page mp-queue-workspace" aria-busy={loading}><PageHeader compact eyebrow="Admin review case" title={stringValue(organization.storeName, stringValue(organization.store_name, 'Vendor verification'))} description="Review current evidence, record a requirement-level decision, and keep activation restriction separate from the verification decision." actions={<BackNavigation><button type="button" onClick={() => navigate(back)}>Back to queue</button></BackNavigation>} /><QueueSectionLinks links={[{ href: '#review-information-title', label: 'Submitted information' }, { href: '#decision-title', label: 'Requirement decision' }, { href: '#restriction-title', label: 'Activation restriction' }, { href: '#review-history-title', label: 'Decision history' }]} /><section className="grid gap-5 border-b border-border-default pb-4 lg:grid-cols-[1.2fr_.8fr]"><div><div className="flex flex-wrap items-center gap-3"><StatusBadge label={statusLabel(stringValue(organization.verificationStatus, stringValue(organization.store_verification_status, 'PENDING_VERIFICATION')))} tone={statusTone(stringValue(organization.verificationStatus, stringValue(organization.store_verification_status, 'PENDING_VERIFICATION')))} /><StatusBadge label={`Activation: ${statusLabel(stringValue(organization.activationStatus, stringValue(organization.store_activation_status, 'NOT_READY')))}`} tone={statusTone(stringValue(organization.activationStatus, stringValue(organization.store_activation_status, 'NOT_READY')))} /></div><dl className="mt-3 grid gap-3 text-sm sm:grid-cols-2 2xl:grid-cols-4"><DetailDatum label="Registered name" value={stringValue(organization.registeredName, stringValue(organization.registered_name, stringValue(organization.legalName, stringValue(organization.legal_name, 'Not recorded'))))} /><DetailDatum label="Business type" value={statusLabel(stringValue(organization.businessType, stringValue(organization.business_type, 'Not recorded')))} /><DetailDatum label="Store email" value={stringValue(organization.storeEmail, stringValue(organization.store_email, 'Not recorded'))} /><DetailDatum label="Store phone" value={stringValue(organization.storePhone, stringValue(organization.store_phone, 'Not recorded'))} /></dl></div><div className="border-t border-border-default pt-5 lg:border-l lg:border-t-0 lg:pl-6"><p className="text-xs font-semibold uppercase tracking-[0.14em] text-action-primary">Activation readiness</p><h2 className="mt-2 text-xl font-semibold">{booleanValue(readiness.ready) ? 'Ready, pending Vendor activation.' : 'Blocked by current requirements.'}</h2><div className="mt-4 grid gap-2">{records(readiness.blockers).slice(0, 4).map((blocker) => <p className="text-sm leading-6 text-text-secondary" key={`${stringValue(blocker.key)}-${stringValue(blocker.reason)}`}><span className="font-semibold text-text-strong">{stringValue(blocker.key)}:</span> {stringValue(blocker.reason)}</p>)}</div></div></section>{message && <StatusMessage tone={message.tone}>{message.text}</StatusMessage>}<ChecklistPanel title="Verification requirements" items={checklist} compact selectedKey={selectedItem?.key}
      renderAction={item => <Button variant="quiet" disabled={busy} aria-current={selectedItem?.key === item.key ? 'true' : undefined} aria-label={`Review ${item.label}`} onClick={() => { setSelectedKey(item.key); setMessage(null); setDecision('APPROVED'); setReason(''); setDocumentNumber(''); setIssueDate(''); setExpirationKind('UNVERIFIED'); setExpirationDate(''); setEvidenceSource(''); setRemarks('') }}>Review</Button>}
      /><div className="mp-queue-detail-columns"><ReviewInformation selectedItem={selectedItem} selectedDocuments={selectedDocuments} detail={detail} /><div className="mp-queue-detail-stack"><DecisionPanel authorityFields={stringValue(selectedStep?.key) === 'authority_to_act' ? <fieldset className="grid gap-4"><legend className="font-semibold">Authority to Act evidence and scope</legend><label className="grid gap-2 text-sm font-semibold">Evidence version<select className="min-h-12 rounded-control border border-border-default bg-surface-primary px-3 font-normal" value={authorityEvidence} onChange={event => setAuthorityEvidence(event.target.value)}><option value="">Select reviewed evidence</option>{documents.filter(doc => ['business_registration', 'authority_to_act'].includes(stringValue(doc.requirement_key, stringValue(doc.requirementKey)))).map(doc => <option key={stringValue(doc.version_id, stringValue(doc.versionId))} value={stringValue(doc.version_id, stringValue(doc.versionId))}>{statusLabel(stringValue(doc.requirement_key, stringValue(doc.requirementKey)))} — version {numberValue(doc.version)}</option>)}</select></label><p className="text-sm">Confirm the named representative, organization, capacity, signatures, and dates. Approve only the scopes supported by this evidence.</p>{([['TAX_DECLARATIONS', 'Tax declarations'], ['COMMISSION_AGREEMENT', 'Commission Agreement'], ['PAYMENT_CONFIGURATION', 'Payment configuration']] as const).map(([scope, label]) => <label key={scope} className="flex min-h-11 items-center gap-3 text-sm"><input type="checkbox" className="h-5 w-5 accent-action-primary" checked={authorityScopes.includes(scope)} onChange={event => setAuthorityScopes(event.target.checked ? [...authorityScopes, scope] : authorityScopes.filter(item => item !== scope))} />{label}</label>)}</fieldset> : undefined} selectedItem={selectedItem} pendingPrerequisites={pendingPrerequisites} selectedStep={selectedStep} selectedDocuments={selectedDocuments} detail={detail} decision={decision} setDecision={setDecision} reason={reason} setReason={setReason} documentNumber={documentNumber} setDocumentNumber={setDocumentNumber} issueDate={issueDate} setIssueDate={setIssueDate} expirationKind={expirationKind} setExpirationKind={setExpirationKind} expirationDate={expirationDate} setExpirationDate={setExpirationDate} evidenceSource={evidenceSource} setEvidenceSource={setEvidenceSource} verifiedVatCategory={verifiedVatCategory} setVerifiedVatCategory={setVerifiedVatCategory} remarks={remarks} setRemarks={setRemarks} busy={busy || loading} onSubmit={submitDecision} /><RestrictionPanel activationStatus={stringValue(organization.activationStatus, stringValue(organization.store_activation_status, 'NOT_READY'))} reason={restrictionReason} setReason={setRestrictionReason} busy={busy || loading} onRestrict={() => void changeRestriction('restrict')} onRestore={() => void changeRestriction('restore')} /></div></div><ReviewHistory reviews={reviews} />{authorityReviews.length > 0 && <section className="border-t border-border-default pt-6"><h2 className="text-xl font-semibold">Authority decision history</h2><div className="mt-4 grid gap-3">{authorityReviews.map(review => <p className="text-sm" key={stringValue(review.id)}>Representative version {numberValue(review.version)} · {statusLabel(stringValue(review.decision))} · Scopes: {stringValue(review.scope, 'None')} · {stringValue(review.reason)} · {formatDate(review.reviewed_at ?? review.reviewedAt)}</p>)}</div></section>}</div></AdminShell>
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
  /** Other requirements still awaiting approval; Business information is the final acceptance after them. */
  pendingPrerequisites: ReviewItem[]
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

  return <section className="min-w-0 mp-card mp-card-padded" aria-labelledby="review-information-title">
    <div className="flex flex-wrap items-center justify-between gap-3"><h2 id="review-information-title" className="text-lg font-semibold">{selectedItem?.label ?? 'Submitted information'}</h2>{selectedItem && <StatusBadge label={statusLabel(selectedItem.status)} tone={statusTone(selectedItem.status)} />}</div>
    {selectedItem && <div className="mt-4 border-t border-border-default pt-4"><h3 className="text-lg font-semibold">Submitted information</h3><div className="mt-4"><CaseInformation detail={detail} selectedKey={selectedItem.key} /></div></div>}
    {selectedItem && !isBusiness && <div className="mt-4 border-t border-border-default pt-4"><h3 className="text-lg font-semibold">Supporting evidence</h3>{selectedDocuments.length > 0 && <p className="mt-1 text-sm text-text-secondary">Current submitted versions. Images and PDFs load here through your authorized session.</p>}{selectedDocuments.map(document => <p className="mt-2 text-xs text-text-secondary" key={stringValue(document.id)}>Version {numberValue(document.version) || 'unavailable'} · Scan: {statusLabel(stringValue(document.scanState, stringValue(document.scan_state, 'UNAVAILABLE')))}</p>)}<div className="mt-4">{evidenceItems.length ? <PrivateEvidenceGallery key={selectedItem.key} items={evidenceItems} apiBasePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} /> : <p className="text-sm text-text-secondary">No current submitted evidence is available for this requirement.</p>}</div></div>}
    {isBusiness && <p className="mt-4 border-t border-border-default pt-4 text-sm text-text-secondary">Government ID, BIR registration, business registration, and permits have their own review decisions in the list.</p>}
  </section>
}

function DecisionPanel(props: DecisionPanelProps) {
  const { selectedItem, decision, setDecision, reason, setReason, documentNumber, setDocumentNumber, issueDate, setIssueDate, expirationKind, setExpirationKind, expirationDate, setExpirationDate, evidenceSource, setEvidenceSource, verifiedVatCategory, setVerifiedVatCategory, remarks, setRemarks, busy, onSubmit } = props
  const isBusiness = selectedItem?.key === 'business_information_group'
  const pendingPrerequisites = isBusiness ? props.pendingPrerequisites : []
  const locked = pendingPrerequisites.length > 0

  return <section className="min-w-0 mp-card mp-card-padded" aria-labelledby="decision-title">
    <div className="flex items-start gap-3"><BadgeCheck className="mt-1 shrink-0 text-action-primary" size={22} aria-hidden="true" /><div><h2 id="decision-title" className="text-lg font-semibold">Record decision</h2><p className="mt-2 text-sm leading-6 text-text-secondary">Review the submitted information and current evidence before recording a decision.</p></div></div>
    <div className="mt-4 border-t border-border-default pt-4"><h3 className="text-xs font-semibold uppercase tracking-[0.14em] text-action-primary">Selected requirement</h3><div className="mt-2 flex flex-wrap items-center gap-3"><p className="text-lg font-semibold">{selectedItem?.label ?? 'Select a requirement'}</p>{selectedItem && <StatusBadge label={statusLabel(selectedItem.status)} tone={statusTone(selectedItem.status)} />}</div>{selectedItem?.reason && <p className="mt-2 text-sm text-text-secondary">{selectedItem.reason}</p>}</div>
    {locked && <div id="decision-locked" className="mt-4 rounded-control border border-border-default bg-surface-canvas p-3 text-sm"><p className="flex items-center gap-2 font-semibold"><Lock size={16} aria-hidden="true" />Final acceptance</p><p className="mt-1 leading-6 text-text-secondary">Business information is decided after every other requirement is approved. Still pending:</p><ul className="mt-1 list-disc pl-5 leading-6 text-text-secondary">{pendingPrerequisites.map(item => <li key={item.key}>{item.label} — {statusLabel(item.status)}</li>)}</ul></div>}
    <form className="mt-4 border-t border-border-default pt-4" onSubmit={onSubmit}><fieldset className="min-w-0" disabled={locked} aria-describedby={locked ? 'decision-locked' : undefined}>
      {!isBusiness && selectedItem && <div className="mb-6"><h3 className="text-lg font-semibold">Verification details</h3><div className="mt-4 grid gap-4 sm:grid-cols-2"><Field label="Verified document number" name="verified_document_number" value={documentNumber} onChange={event => setDocumentNumber(event.target.value)} /><Field label="Evidence source" name="evidence_source" value={evidenceSource} onChange={event => setEvidenceSource(event.target.value)} /><Field label="Issue date" name="verified_issue_date" type="date" value={issueDate} onChange={event => setIssueDate(event.target.value)} /><label className="grid gap-2 text-sm font-semibold" htmlFor="expiration_kind">Expiration<select className="min-h-12 rounded-control border border-border-default bg-surface-primary px-3 text-base font-normal" id="expiration_kind" value={expirationKind} onChange={event => setExpirationKind(event.target.value)}><option value="UNVERIFIED">Not verified</option><option value="DATE">Has expiration date</option><option value="NO_EXPIRATION">No expiration</option></select></label>{expirationKind === 'DATE' && <Field label="Expiration date" name="verified_expiration_date" type="date" value={expirationDate} onChange={event => setExpirationDate(event.target.value)} />}{selectedItem.key === 'bir_cor' && <label className="grid gap-2 text-sm font-semibold" htmlFor="verified_vat_category">VAT category verified by Admin<select className="min-h-12 rounded-control border border-border-default bg-surface-primary px-3 py-3 text-base font-normal" id="verified_vat_category" value={verifiedVatCategory} onChange={event => setVerifiedVatCategory(event.target.value)}><option value="">Not verified</option><option value="VAT">VAT</option><option value="NON_VAT">Non-VAT</option><option value="VAT_ZERO">VAT zero-rated</option><option value="VAT_EXEMPT">VAT exempt</option></select></label>}</div></div>}
      {props.authorityFields && <div className="mb-6">{props.authorityFields}</div>}
      <h3 className="text-lg font-semibold">Admin decision</h3><div className="mt-3 grid gap-3"><label className="grid gap-2 text-sm font-semibold" htmlFor="decision">Decision<select className="min-h-12 rounded-control border border-border-default bg-surface-primary px-3 text-base font-normal" id="decision" value={decision} onChange={event => setDecision(event.target.value)}><option value="APPROVED">Approve</option><option value="CHANGES_REQUIRED">Request correction</option><option value="REJECTED">Reject</option></select></label><label className="grid gap-2 text-sm font-semibold" htmlFor="decision_reason">Reason {decision !== 'APPROVED' && <span className="text-status-error" aria-hidden="true">*</span>}<textarea className="min-h-20 rounded-control border border-border-default bg-surface-primary px-3 py-3 text-base font-normal" id="decision_reason" value={reason} onChange={event => setReason(event.target.value)} placeholder={decision === 'APPROVED' ? 'Optional approval note' : 'Explain the correction or rejection clearly.'} required={decision !== 'APPROVED'} /></label><label className="grid gap-2 text-sm font-semibold" htmlFor="review_remarks">Reviewer remarks<textarea className="min-h-20 rounded-control border border-border-default bg-surface-primary px-3 py-3 text-base font-normal" id="review_remarks" value={remarks} onChange={event => setRemarks(event.target.value)} /></label><Button type="submit" className="w-fit" disabled={busy || !selectedItem}>{busy ? 'Recording…' : 'Record requirement decision'} <Check size={16} aria-hidden="true" /></Button></div>
    </fieldset></form>
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
  return <section className="mp-card mp-card-padded" aria-labelledby="restriction-title"><div className="flex items-start gap-3"><ShieldAlert className="mt-1 shrink-0 text-action-primary" size={22} aria-hidden="true" /><div><h2 id="restriction-title" className="text-lg font-semibold">Activation restriction</h2><p className="mt-2 text-sm leading-6 text-text-secondary">Restriction is a separate Admin action. It does not rewrite the verification review history.</p></div></div><div className="mt-4"><StatusBadge label={`Current: ${statusLabel(activationStatus)}`} tone={statusTone(activationStatus)} /></div><label className="mt-4 grid gap-2 text-sm font-semibold" htmlFor="restriction_reason">Reason<textarea className="min-h-20 rounded-control border border-border-default bg-surface-primary px-3 py-3 text-base font-normal" id="restriction_reason" value={reason} onChange={(event) => setReason(event.target.value)} placeholder="Explain why activation should be restricted or restored." /></label><div className="mt-4 flex flex-wrap gap-3"><Button disabled={busy} variant="secondary" onClick={onRestrict}>Restrict activation</Button><Button disabled={busy} onClick={onRestore}>Restore activation</Button></div></section>
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

