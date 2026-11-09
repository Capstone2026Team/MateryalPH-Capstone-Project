import { AsyncLoading } from '@materyalph/web-ui'
import { AnalyticsDashboardLayout, AnalyticsPanelColumns, DashboardActivityList, DashboardHeader, DashboardPanel, DashboardQueueList, DateFilter, InfoNote, Pagination, SectionWorkspace, StatusBadge, dateFilterPreset, useAutomaticRefresh, usePortalResource } from '@materyalph/web-ui'
import { ArrowRight } from 'lucide-react'
import { Link } from 'react-router-dom'
import { useCallback, useEffect, useState, type ReactNode } from 'react'
import { AdminVendorVerificationApi, type OperationsQueue } from '@materyalph/api-client-ts'
import { Button, StatusMessage, createWebApiConfiguration } from '@materyalph/web-ui'
import { AdminShell } from './PhaseThreeAdminPages'
import { readableVerificationError } from '../lib/vendor-verification-api'
import { getAdminDashboardInsightsComparison, type AdminDashboardInsights, type InsightsPeriod } from '../lib/dashboard-insights-api'
import { ActiveUsersPanel, CategoryDemandCard, MarketplacePerformancePanel, OrderVolumePanel, UserPopulationPanel, CaseRatesPanel, GmvTrendPanel, MarketplaceUnavailable, QueueLoadChart, AdminOverviewKpis } from './AdminDashboardInsights'
import { AdminPlatformEarnings } from './AdminPlatformEarnings'
import { useAdminPlatformEarnings } from '../lib/use-admin-platform-earnings'
import { AdminPlatformHealth } from './AdminPlatformHealth'

const api = new AdminVendorVerificationApi(createWebApiConfiguration(import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1', { refreshSession: true }))
const loadDashboard = async () => (await api.getAdminDashboard()).data

export function AdminDashboardPage() {
  const { data: summary, error: failure, pending: busy, refresh: load } = usePortalResource('admin-dashboard', loadDashboard)
  const [days, setDays] = useState<InsightsPeriod>(30)
  const [range, setRange] = useState(() => dateFilterPreset(30))
  const platformEarnings = useAdminPlatformEarnings(range)
  const loadInsights = useCallback(() => getAdminDashboardInsightsComparison(days, 'TEST', range), [days, range])
  const { data: insightComparison, error: insightsFailure, pending: insightsBusy, refresh: reloadInsights } = usePortalResource(`admin-dashboard-insights-comparison-${range.from}-${range.to}`, loadInsights)
  const insights = insightComparison?.current ?? null
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
  /** Marketplace content when permitted and available; otherwise the reason, never an empty chart. */
  const market = (render: (marketplace: NonNullable<AdminDashboardInsights['marketplace']>) => ReactNode) => !insights ? null
    : insights.marketplace ? render(insights.marketplace) : <MarketplaceUnavailable allowed={insights.access.marketplace} reason={insights.marketplaceUnavailableReason} />
  const chartsNote = insightsBusy && !insights ? 'Loading charts…' : insights?.marketplace?.dataset.lastAggregatedAt ? `Charts aggregated ${new Intl.DateTimeFormat('en-PH', { dateStyle: 'medium', timeStyle: 'short', timeZone: 'Asia/Manila' }).format(insights.marketplace.dataset.lastAggregatedAt)} (Asia/Manila) · Updates automatically` : 'Charts update automatically after aggregation.'
  return <AdminShell activeHref="/dashboard"><div className="mp-analytics space-y-3">
    <DashboardHeader eyebrow="Platform overview" description="A clear view of marketplace activity and the reviews that need your attention." status={<StatusBadge label="Admin workspace" />} actions={summary ? <p className="text-xs text-text-secondary">{chartsNote}</p> : undefined} />
    {error && <StatusMessage tone="error">{error}{summary && ' Showing the last successful update.'}</StatusMessage>}
    {busy && !summary && <AsyncLoading compact label="Loading platform metrics…" />}
    {summary && <>
      {insightsError && <div className="flex flex-wrap items-center gap-3"><StatusMessage tone="error">{insightsError}{insights ? ' Showing the last successful charts.' : ''}</StatusMessage><Button variant="secondary" onClick={() => void reloadInsights()}>Retry charts</Button></div>}
      <SectionWorkspace dashboard actions={<DateFilter title="Marketplace activity dates" value={range} allowAllDates={false} allowOpenEnded={false} maxRangeDays={366} onChange={value => { setRange(value); setDays(value.label === 'Last 90 days' ? 90 : 30) }} />} sections={[{ label: 'Overview', content: <>
        <AnalyticsDashboardLayout stretchAside={summary.canViewAudit} aside={<>
          <QueueList compact queues={summary.queues} title="Priority actions" empty="No work queues are assigned to your role." />
          {summary.canViewAudit && <AdminActivityPreview />}
        </>}>
          <AdminOverviewKpis activeBuyers={summary.activeBuyers} activeVendors={summary.activeVendors} inactiveVendors={summary.inactiveVendors} marketplace={insights?.marketplace ?? null} range={range}
            platformEarningsCentavos={platformEarnings.netCollectedCentavos} platformEarningsUnavailableReason={platformEarnings.unavailableReason}
            platformEarningsChangePercent={platformEarnings.changePercent} platformEarningsComparisonUnavailable={platformEarnings.comparisonUnavailable} previousMarketplace={insightComparison?.previous?.marketplace ?? null}
            marketplaceUnavailableReason={insights ? insights.access.marketplace ? insights.marketplaceUnavailableReason ?? 'Marketplace value is unavailable.' : 'Needs aggregate analytics access.' : insightsFailure ? 'Marketplace value could not be loaded.' : 'Loading marketplace value…'} />
          <div className="mp-card-group mp-analytics-cards mp-analytics-overview">
            <AdminPlatformEarnings resource={platformEarnings} />
            <AnalyticsPanelColumns main={market(marketplace => <><GmvTrendPanel marketplace={marketplace} /><MarketplacePerformancePanel marketplace={marketplace} /></>)} aside={<AdminPlatformHealth />} />
            <UserPopulationPanel buyers={summary.activeBuyers} vendors={summary.activeVendors} />
            {market(marketplace => <CategoryDemandCard marketplace={marketplace} />)}
            {market(marketplace => <ActiveUsersPanel marketplace={marketplace} />)}
            {market(marketplace => <OrderVolumePanel wide marketplace={marketplace} />)}
          </div>
        </AnalyticsDashboardLayout>
      </> },
      { label: 'Disputes & Appeals', content: <div className="grid gap-4">
        <div className="flex flex-wrap items-center justify-between gap-3"><div><h2 className="text-base font-semibold text-text-strong">Case review overview</h2><p className="mt-1 text-xs text-text-secondary">Review escalations, decide appeals and track remedies through completion.</p></div>{summary.queues?.some(queue => queue.group === 'Disputes and appeals') && <Link to="/disputes" className="inline-flex min-h-11 items-center gap-2 rounded-control border border-border-default bg-surface-primary px-4 text-sm font-semibold">Open case queue<ArrowRight size={16} aria-hidden="true" /></Link>}</div>
        {market(marketplace => <CaseRatesPanel marketplace={marketplace} />)}
        <div className="grid gap-4 lg:grid-cols-2"><QueueLoadChart queues={summary.queues} groups={['Disputes and appeals']} /><QueueList queues={summary.queues} groups={['Disputes and appeals']} title="Review queues" empty="Dispute and appeal queues are outside your role scope." /></div>
        <InfoNote>Decisions require evidence, a reason and a conflict check. Appeals retain the original decision; refunds follow the original payment method.</InfoNote>
      </div> },
      { label: 'Audit Logs & Tracking', content: <>{summary.canViewAudit ? <DashboardPanel density="compact" title="Recent platform activity"><AdminAuditPage embedded /></DashboardPanel> : <InfoNote>Audit logs are outside your role scope.</InfoNote>}</> }]} />
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
  const content = <div className="space-y-6"><h2 className="text-xl font-semibold">Audit Logs &amp; Tracking</h2><p className="text-text-secondary">Read-only event tracking. Private payloads and personal contact details are excluded.</p>{error ? <><StatusMessage tone="error">{error}</StatusMessage><Button onClick={() => setAttempt(value => value + 1)}>Retry</Button></> : busy ? <AsyncLoading compact label="Loading audit events…" /> : items.length === 0 ? <p>No audit events recorded.</p> : <div className="overflow-x-auto"><table className="w-full text-left text-sm"><thead><tr>{['Recorded (Manila)', 'Role', 'Action', 'Resource', 'Result', 'Correlation ID'].map(label => <th className="p-3" scope="col" key={label}>{label}</th>)}</tr></thead><tbody>{items.map(item => <tr className="border-t border-border-default" key={String(item.id)}><td className="p-3">{new Date(String(item.created_at)).toLocaleString('en-PH', { timeZone: 'Asia/Manila' })}</td>{['actor_role', 'action', 'resource_type'].map(key => <td className="p-3" key={key}>{String(item[key] ?? 'System')}</td>)}<td className="p-3">{item.succeeded ? 'Succeeded' : 'Failed'}</td><td className="p-3 break-all">{String(item.correlation_id)}</td></tr>)}</tbody></table></div>}<Pagination page={page} lastPage={lastPage} busy={busy} onChange={setPage} /></div>
  return embedded ? content : <AdminShell activeHref="/audit">{content}</AdminShell>
}

/** Role-scoped work queues from the server; a queue appears only when the Admin holds its permission. */
function QueueList({ queues = [], groups, title = 'Work queues', empty, compact = false }: { queues?: OperationsQueue[] | undefined; groups?: string[]; title?: string; empty: string; compact?: boolean }) {
  const visible = groups ? queues.filter(queue => groups.includes(queue.group)) : queues
  const age = (value: Date | null | undefined) => {
    if (!value) return null
    const hours = Math.max(0, Math.floor((Date.now() - value.getTime()) / 3_600_000))
    return hours < 48 ? `oldest ${hours} h` : `oldest ${Math.floor(hours / 24)} days`
  }
  return <DashboardPanel divided={compact} density="compact" title={title} description={compact ? 'Reviews and cases waiting for your role.' : "Counts within your Admin permissions, with the age of the oldest pending item."}>
    {compact ? <DashboardQueueList empty={empty} items={visible.map(queue => ({ ...queue, detail: `${queue.group}${queue.count > 0 && age(queue.oldestAt) ? ` · ${age(queue.oldestAt)}` : ''}`, attention: queue.count > 0 }))} renderLink={(queue, content) => <Link to={queue.href}>{content}</Link>} /> : visible.length === 0 ? <p className="text-sm text-text-secondary">{empty}</p> : <ul className="grid gap-x-5 sm:grid-cols-2 xl:grid-cols-3">{visible.map(queue => <li key={queue.key} className="border-b border-border-default">
      <Link to={queue.href} className="group flex min-h-full items-start justify-between gap-3 rounded-control py-3 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-focus-ring">
        <span className="grid min-w-0 gap-1"><span className="text-sm font-semibold text-text-strong group-hover:text-action-primary">{queue.label}</span>
          <span className="text-xs text-text-secondary">{queue.group}{queue.count > 0 && age(queue.oldestAt) ? ` · ${age(queue.oldestAt)}` : ''}</span>
          {!compact && <span className="text-xs leading-5 text-text-secondary">{queue.description}</span>}</span>
        <span className={`shrink-0 rounded-control px-2 py-1 text-sm font-semibold tabular-nums ${queue.count > 0 ? 'bg-brand-orange-50 text-action-primary' : 'bg-surface-canvas text-text-secondary'}`}>{queue.count.toLocaleString('en-PH')}</span>
      </Link>
    </li>)}</ul>}
  </DashboardPanel>
}

const loadAuditPreview = async () => (await api.listAdminDashboardAudit({ page: 1 })).data

function AdminActivityPreview() {
  const { data, error, pending, refresh } = usePortalResource('admin-dashboard-audit-preview', loadAuditPreview)
  useAutomaticRefresh(refresh, { enabled: !pending, intervalMs: error ? 120_000 : 30_000 })
  return <DashboardPanel density="compact" title="Recent activity" action={<Link to="/audit" className="inline-flex min-h-11 items-center text-xs font-medium text-action-primary">View all<ArrowRight size={13} aria-hidden="true" /></Link>}>
    {error ? <p className="text-xs text-text-secondary">Activity could not be loaded. <button type="button" onClick={() => void refresh()} className="min-h-11 font-medium text-action-primary">Retry</button></p> : !data ? <AsyncLoading compact label="Loading activity…" /> : data.length === 0 ? <p className="text-xs text-text-secondary">No recent platform activity.</p> : <DashboardActivityList label="Recent platform activity" items={data.slice(0, 5).map(item => ({
      key: String(item.id), title: String(item.action ?? 'Platform event').replaceAll('_', ' ').replaceAll('.', ' ').toLowerCase().replace(/^./, letter => letter.toUpperCase()),
      eventType: String(item.action ?? ''), resourceType: String(item.resource_type ?? ''),
      detail: <><span className="mp-activity-highlight">{String(item.resource_type ?? 'System').replaceAll('_', ' ').toLowerCase()}</span> · <span className={item.succeeded ? undefined : 'text-status-error'}>{item.succeeded ? 'Succeeded' : 'Failed'}</span></>,
      at: new Date(String(item.created_at)),
    }))} />}
  </DashboardPanel>
}
