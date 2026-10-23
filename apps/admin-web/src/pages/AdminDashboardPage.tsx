import { DashboardHeader, DashboardPanel, DateFilter, MetricCard, Pagination, SectionWorkspace, StatusBadge, dateFilterPreset, useAutomaticRefresh, usePortalResource } from '@materyalph/web-ui'
import { ArrowRight, ClipboardCheck, Store, Users } from 'lucide-react'
import { Link } from 'react-router-dom'
import { useCallback, useEffect, useState, type ReactNode } from 'react'
import { AdminVendorVerificationApi, type OperationsQueue } from '@materyalph/api-client-ts'
import { Button, StatusMessage, createWebApiConfiguration } from '@materyalph/web-ui'
import { AdminShell } from './PhaseThreeAdminPages'
import { readableVerificationError } from '../lib/vendor-verification-api'
import { getAdminDashboardInsights, type AdminDashboardInsights, type InsightsPeriod } from '../lib/dashboard-insights-api'
import { ActivityPanel, AreaSegmentsPanel, CaseRatesPanel, CategoryInsights, GmvTrendPanel, MarketplaceKpis, MarketplaceUnavailable, OrderVolumePanel, QueueLoadChart, VendorHealthPanel } from './AdminDashboardInsights'

const api = new AdminVendorVerificationApi(createWebApiConfiguration(import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1', { refreshSession: true }))
const loadDashboard = async () => (await api.getAdminDashboard()).data

export function AdminDashboardPage() {
  const { data: summary, error: failure, pending: busy, refresh: load } = usePortalResource('admin-dashboard', loadDashboard)
  const [days, setDays] = useState<InsightsPeriod>(30)
  const [range, setRange] = useState(() => dateFilterPreset(30))
  const loadInsights = useCallback(() => getAdminDashboardInsights(days, 'TEST', range), [days, range])
  const { data: insights, error: insightsFailure, pending: insightsBusy, refresh: reloadInsights } = usePortalResource(`admin-dashboard-insights-${range.from}-${range.to}`, loadInsights)
  const [error, setError] = useState<string | null>(null)
  const [insightsError, setInsightsError] = useState<string | null>(null)
  useEffect(() => {
    let active = true
    setError(null)
    if (failure) void readableVerificationError(failure).then(message => { if (active) setError(message) })
    return () => { active = false }
  }, [failure])
  useEffect(() => {
    let active = true
    setInsightsError(null)
    if (insightsFailure) void readableVerificationError(insightsFailure).then(message => { if (active) setInsightsError(message) })
    return () => { active = false }
  }, [insightsFailure])
  useAutomaticRefresh(load, { enabled: !busy, intervalMs: error ? 120_000 : 30_000 })
  useAutomaticRefresh(reloadInsights, { enabled: !insightsBusy, intervalMs: insightsError ? 120_000 : 30_000 })
  const periodLabel = range.label === 'Custom range' ? `${range.from} – ${range.to}` : range.label.toLowerCase()
  /** Marketplace content when permitted and available; otherwise the reason, never an empty chart. */
  const market = (render: (marketplace: NonNullable<AdminDashboardInsights['marketplace']>) => ReactNode) => !insights ? null
    : insights.marketplace ? render(insights.marketplace) : <MarketplaceUnavailable allowed={insights.access.marketplace} reason={insights.marketplaceUnavailableReason} />
  return <AdminShell activeHref="/dashboard"><div className="space-y-5">
    <DashboardHeader eyebrow="Platform overview" description="A clear view of marketplace activity and the reviews that need your attention." status={<StatusBadge label="Admin workspace" />} />
    {error && <StatusMessage tone="error">{error}{summary && ' Showing the last successful update.'}</StatusMessage>}
    {busy && !summary && <p role="status">Loading platform metrics…</p>}
    {summary && <>
      <div className="flex flex-wrap items-center justify-between gap-3 rounded-surface border border-border-default bg-surface-primary px-4 py-2">
        <div className="flex flex-wrap items-center gap-4"><DateFilter title="Marketplace activity dates" value={range} allowAllDates={false} allowOpenEnded={false} maxRangeDays={366} onChange={value => { setRange(value); setDays(value.label === 'Last 90 days' ? 90 : 30) }} /></div>
        <p className="text-xs text-text-secondary">{insightsBusy && !insights ? 'Loading charts…' : insights?.marketplace?.dataset.lastAggregatedAt ? `Charts aggregated ${new Intl.DateTimeFormat('en-PH', { dateStyle: 'medium', timeStyle: 'short', timeZone: 'Asia/Manila' }).format(insights.marketplace.dataset.lastAggregatedAt)} (Asia/Manila) · Updates automatically` : 'Charts update automatically after aggregation.'}</p>
      </div>
      {insightsError && <div className="flex flex-wrap items-center gap-3"><StatusMessage tone="error">{insightsError}{insights ? ' Showing the last successful charts.' : ''}</StatusMessage><Button variant="secondary" onClick={() => void reloadInsights()}>Retry charts</Button></div>}
      <SectionWorkspace dashboard sections={[{ label: 'Overview', content: <>
        <p className="text-xs text-text-secondary">Current platform counts within your Admin permissions.</p>
        <dl className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">{[
          { label: 'Active Tier 2 Vendors', value: summary.activeVendors, description: 'Active account and activated store.', icon: Store },
          { label: 'Non-active Vendor stores', value: summary.inactiveVendors, description: 'Includes stores completing onboarding.', icon: Store },
          { label: 'Active Buyers', value: summary.activeBuyers, description: 'Buyer accounts with ACTIVE status.', icon: Users },
          { label: 'Pending business-document reviews', value: summary.pendingDocumentReviews, description: 'Submitted documents awaiting review.', icon: ClipboardCheck },
        ].map(({ label, value, description, icon: Icon }, index) => <MetricCard key={label} label={label} value={value === null ? '—' : value.toLocaleString('en-PH')} description={value === null ? 'Outside your role scope.' : description} icon={<Icon size={16} aria-hidden="true" />} accent={index === 3} />)}</dl>
        {market(marketplace => <><MarketplaceKpis marketplace={marketplace} periodLabel={periodLabel} /><GmvTrendPanel marketplace={marketplace} /></>)}
        <QueueLoadChart queues={summary.queues} />
        <QueueList queues={summary.queues} title="Your work queues" empty="No work queues are assigned to your role." />
        <div className="grid items-start gap-5 xl:grid-cols-3"><div className="xl:col-span-2"><DashboardPanel title="Review priorities" description="Focus on submitted business documents.">
          <div className="flex flex-col gap-5 sm:flex-row sm:items-center"><span className="grid h-12 w-12 shrink-0 place-items-center rounded-surface bg-brand-orange-50 text-action-primary"><ClipboardCheck size={24} aria-hidden="true" /></span><div className="min-w-0 flex-1"><h3 className="text-base font-semibold">{summary.pendingDocumentReviews === null ? 'Reviews outside your role scope' : summary.pendingDocumentReviews === 0 ? 'No business documents awaiting review' : `${summary.pendingDocumentReviews.toLocaleString('en-PH')} business documents awaiting review`}</h3><p className="mt-2 text-sm leading-6 text-text-secondary">{summary.pendingDocumentReviews === null ? 'This summary is available to authorized Vendor reviewers.' : 'Open Vendor Management to review submissions and their verification requirements.'}</p></div></div>
          {summary.pendingDocumentReviews !== null && <Link to="/vendor-verification" className="mt-5 inline-flex min-h-11 items-center gap-2 rounded-control bg-action-primary px-4 text-sm font-semibold text-white hover:bg-action-primary-pressed">Open Vendor Management<ArrowRight size={16} aria-hidden="true" /></Link>}
        </DashboardPanel></div><DashboardPanel title="Platform snapshot" description="Current account and tracking coverage."><dl className="divide-y divide-border-default">{[
          ['Vendor stores', summary.activeVendors !== null && summary.inactiveVendors !== null ? summary.activeVendors + summary.inactiveVendors : null],
          ['Active Buyers', summary.activeBuyers],
          ...(summary.canViewAudit ? [['Recorded audit events', summary.auditEvents]] : []),
        ].map(([label, value]) => <div key={String(label)} className="flex items-center justify-between gap-4 py-3 first:pt-0"><dt className="text-xs text-text-secondary">{label}</dt><dd className="text-sm font-semibold tabular-nums">{value === null ? 'Outside your role scope' : Number(value).toLocaleString('en-PH')}</dd></div>)}</dl>{summary.canViewAudit && <Link to="/audit" className="mt-2 inline-flex min-h-11 items-center gap-2 text-sm font-semibold text-action-primary">View audit log<ArrowRight size={16} aria-hidden="true" /></Link>}</DashboardPanel></div>
      </> }, { label: 'Vendor Activity', content: <><QueueList queues={summary.queues} groups={['Vendor Management']} title="Vendor queues" empty="Vendor verification queues are outside your role scope." /><dl className="grid gap-4 sm:grid-cols-2 xl:grid-cols-3"><MetricCard label="Active Tier 2 Vendors" value={summary.activeVendors ?? '—'} description={summary.activeVendors === null ? 'Outside your role scope.' : 'Active account and activated store.'} /><MetricCard label="Non-active Vendor stores" value={summary.inactiveVendors ?? '—'} description={summary.inactiveVendors === null ? 'Outside your role scope.' : 'Includes stores completing onboarding.'} /><MetricCard label="Pending business-document reviews" value={summary.pendingDocumentReviews ?? '—'} description={summary.pendingDocumentReviews === null ? 'Outside your role scope.' : 'Submitted documents awaiting review.'} accent /></dl><DashboardPanel title="Vendor verification" description="Review submitted evidence and store requirements.">{summary.pendingDocumentReviews !== null ? <Link to="/vendor-verification" className="inline-flex min-h-11 items-center gap-2 text-sm font-semibold text-action-primary">Open Vendor Management<ArrowRight size={16} aria-hidden="true" /></Link> : <p className="text-sm text-text-secondary">Outside your role scope.</p>}</DashboardPanel>{insights?.vendorHealth && <VendorHealthPanel health={insights.vendorHealth} />}{market(marketplace => <><AreaSegmentsPanel marketplace={marketplace} /><ActivityPanel marketplace={marketplace} audience="vendor" /></>)}</> },
      { label: 'Compliance & Moderation', content: <><QueueLoadChart queues={summary.queues} groups={['Compliance and quality', 'Account enforcement']} /><QueueList queues={summary.queues} groups={['Compliance and quality', 'Account enforcement']} empty="No compliance, moderation or enforcement queues are in your role scope." /></> },
      { label: 'Disputes & Appeals', content: <>{market(marketplace => <CaseRatesPanel marketplace={marketplace} />)}<QueueList queues={summary.queues} groups={['Disputes and appeals']} empty="Dispute and appeal queues are outside your role scope." /></> },
      { label: 'Transactions & Finance', content: <>{market(marketplace => <><MarketplaceKpis marketplace={marketplace} periodLabel={periodLabel} /><OrderVolumePanel marketplace={marketplace} /><CategoryInsights marketplace={marketplace} /></>)}<QueueList queues={summary.queues} groups={['Finance', 'Payments and refunds']} empty="Finance, payment and refund queues are outside your role scope." /></> },
      { label: 'Platform Health', content: <>{market(marketplace => <ActivityPanel marketplace={marketplace} audience="both" />)}<QueueList queues={summary.queues} groups={['Platform']} empty="Job-health queues are outside your role scope." />{summary.canViewAudit && <DashboardPanel title="Recent platform activity"><AdminAuditPage embedded /></DashboardPanel>}</> }]} />
      <p className="border-t border-border-default pt-4 text-xs text-text-secondary">Updated {new Intl.DateTimeFormat('en-PH', { dateStyle: 'medium', timeStyle: 'short', timeZone: 'Asia/Manila' }).format(summary.generatedAt)} (Asia/Manila) · Updates automatically</p>
    </>}

  </div></AdminShell>
}

export function AdminAuditPage({ embedded = false }: { embedded?: boolean }) {
  const [items, setItems] = useState<Record<string, unknown>[]>([])
  const [page, setPage] = useState(1)
  const [lastPage, setLastPage] = useState(1)
  const [error, setError] = useState<string | null>(null)
  const [busy, setBusy] = useState(true)
  const [attempt, setAttempt] = useState(0)
  useEffect(() => {
    let active = true
    setBusy(true); setError(null)
    void api.listAdminDashboardAudit({ page }).then(result => { if (active) { setItems(result.data); setLastPage(Number(result.meta.last_page ?? 1)) } }).catch(async cause => { const message = await readableVerificationError(cause); if (active) setError(message) }).finally(() => { if (active) setBusy(false) })
    return () => { active = false }
  }, [page, attempt])
  useAutomaticRefresh(async () => { setAttempt(value => value + 1) }, { enabled: embedded && !busy, intervalMs: error ? 120_000 : 30_000 })
  const content = <div className="space-y-6"><h2 className="text-xl font-semibold">Audit Logs &amp; Tracking</h2><p className="text-text-secondary">Read-only event tracking. Private payloads and personal contact details are excluded.</p>{error ? <><StatusMessage tone="error">{error}</StatusMessage><Button onClick={() => setAttempt(value => value + 1)}>Retry</Button></> : busy ? <p role="status">Loading audit events…</p> : items.length === 0 ? <p>No audit events recorded.</p> : <div className="overflow-x-auto"><table className="w-full text-left text-sm"><thead><tr>{['Recorded (Manila)', 'Role', 'Action', 'Resource', 'Result', 'Correlation ID'].map(label => <th className="p-3" scope="col" key={label}>{label}</th>)}</tr></thead><tbody>{items.map(item => <tr className="border-t border-border-default" key={String(item.id)}><td className="p-3">{new Date(String(item.created_at)).toLocaleString('en-PH', { timeZone: 'Asia/Manila' })}</td>{['actor_role', 'action', 'resource_type'].map(key => <td className="p-3" key={key}>{String(item[key] ?? 'System')}</td>)}<td className="p-3">{item.succeeded ? 'Succeeded' : 'Failed'}</td><td className="p-3 break-all">{String(item.correlation_id)}</td></tr>)}</tbody></table></div>}<Pagination page={page} lastPage={lastPage} busy={busy} onChange={setPage} /></div>
  return embedded ? content : <AdminShell activeHref="/audit">{content}</AdminShell>
}

/** Role-scoped work queues from the server; a queue appears only when the Admin holds its permission. */
function QueueList({ queues = [], groups, title = 'Work queues', empty }: { queues?: OperationsQueue[] | undefined; groups?: string[]; title?: string; empty: string }) {
  const visible = groups ? queues.filter(queue => groups.includes(queue.group)) : queues
  const age = (value: Date | null | undefined) => {
    if (!value) return null
    const hours = Math.max(0, Math.floor((Date.now() - value.getTime()) / 3_600_000))
    return hours < 48 ? `oldest ${hours} h` : `oldest ${Math.floor(hours / 24)} days`
  }
  return <DashboardPanel title={title} description="Counts within your Admin permissions, with the age of the oldest pending item.">
    {visible.length === 0 ? <p className="text-sm text-text-secondary">{empty}</p> : <ul className="grid gap-3 sm:grid-cols-2 xl:grid-cols-3">{visible.map(queue => <li key={queue.key}>
      <Link to={queue.href} className="grid min-h-full gap-1 rounded-surface border border-border-default bg-surface-primary p-4 hover:border-action-primary focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-focus-ring">
        <span className="flex items-start justify-between gap-3"><span className="text-sm font-semibold text-text-strong">{queue.label}</span><span className={`rounded-pill px-2 text-sm font-semibold tabular-nums ${queue.count > 0 ? 'bg-brand-orange-50 text-action-primary' : 'bg-surface-canvas text-text-secondary'}`}>{queue.count.toLocaleString('en-PH')}</span></span>
        <span className="text-[13px] text-text-secondary">{queue.group}{queue.count > 0 && age(queue.oldestAt) ? ` · ${age(queue.oldestAt)}` : ''}</span>
        <span className="text-[13px] text-text-secondary">{queue.description}</span>
      </Link>
    </li>)}</ul>}
  </DashboardPanel>
}
