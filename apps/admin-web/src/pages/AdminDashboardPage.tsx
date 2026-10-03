import { DashboardHeader, DashboardPanel, DashboardPreviewSection, MetricCard, SectionWorkspace, StatusBadge, useAutomaticRefresh } from '@materyalph/web-ui'
import { ArrowRight, ClipboardCheck, Store, Users } from 'lucide-react'
import { Link } from 'react-router-dom'
import { useCallback, useEffect, useState } from 'react'
import { AdminVendorVerificationApi, ResponseError, type AdminDashboardSummary } from '@materyalph/api-client-ts'
import { Button, StatusMessage, createWebApiConfiguration } from '@materyalph/web-ui'
import { AdminShell } from './PhaseThreeAdminPages'
import { readableVerificationError } from '../lib/vendor-verification-api'

const api = new AdminVendorVerificationApi(createWebApiConfiguration(import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1', { refreshSession: true }))

export function AdminDashboardPage() {
  const [summary, setSummary] = useState<AdminDashboardSummary | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [busy, setBusy] = useState(true)
  const load = useCallback(async () => {
    setBusy(true); setError(null)
    try { setSummary((await api.getAdminDashboard()).data) }
    catch (cause) {
      if (cause instanceof ResponseError && [401, 403].includes(cause.response.status)) setSummary(null)
      setError(await readableVerificationError(cause))
    }
    finally { setBusy(false) }
  }, [])
  useEffect(() => { void load() }, [load])
  useAutomaticRefresh(load, { enabled: !busy, intervalMs: error ? 120_000 : 30_000 })
  return <AdminShell activeHref="/dashboard"><div className="space-y-5">
    <DashboardHeader eyebrow="Platform overview" description="A clear view of marketplace activity and the reviews that need your attention." status={<StatusBadge label="Admin workspace" />} />
    {error && <StatusMessage tone="error">{error}{summary && ' Showing the last successful update.'}</StatusMessage>}
    {busy && !summary && <p role="status">Loading platform metrics…</p>}
    {summary && <>
      <SectionWorkspace dashboard sections={[{ label: 'Overview', content: <>
        <p className="text-xs text-text-secondary">Current platform counts within your Admin permissions.</p>
        <dl className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">{[
          { label: 'Active Tier 2 Vendors', value: summary.activeVendors, description: 'Active account and activated store.', icon: Store },
          { label: 'Non-active Vendor stores', value: summary.inactiveVendors, description: 'Includes stores completing onboarding.', icon: Store },
          { label: 'Active Buyers', value: summary.activeBuyers, description: 'Buyer accounts with ACTIVE status.', icon: Users },
          { label: 'Pending business-document reviews', value: summary.pendingDocumentReviews, description: 'Submitted documents awaiting review.', icon: ClipboardCheck },
        ].map(({ label, value, description, icon: Icon }, index) => <MetricCard key={label} label={label} value={value === null ? '—' : value.toLocaleString('en-PH')} description={value === null ? 'Outside your role scope.' : description} icon={<Icon size={16} aria-hidden="true" />} accent={index === 3} />)}</dl>
        <div className="grid items-start gap-5 xl:grid-cols-3"><div className="xl:col-span-2"><DashboardPanel title="Review priorities" description="Focus on submitted business documents.">
          <div className="flex flex-col gap-5 sm:flex-row sm:items-center"><span className="grid h-12 w-12 shrink-0 place-items-center rounded-surface bg-brand-orange-50 text-action-primary"><ClipboardCheck size={24} aria-hidden="true" /></span><div className="min-w-0 flex-1"><h3 className="text-base font-semibold">{summary.pendingDocumentReviews === null ? 'Reviews outside your role scope' : summary.pendingDocumentReviews === 0 ? 'No business documents awaiting review' : `${summary.pendingDocumentReviews.toLocaleString('en-PH')} business documents awaiting review`}</h3><p className="mt-2 text-sm leading-6 text-text-secondary">{summary.pendingDocumentReviews === null ? 'This summary is available to authorized Vendor reviewers.' : 'Open Vendor Management to review submissions and their verification requirements.'}</p></div></div>
          {summary.pendingDocumentReviews !== null && <Link to="/vendor-verification" className="mt-5 inline-flex min-h-11 items-center gap-2 rounded-control bg-action-primary px-4 text-sm font-semibold text-white hover:bg-action-primary-pressed">Open Vendor Management<ArrowRight size={16} aria-hidden="true" /></Link>}
        </DashboardPanel></div><DashboardPanel title="Platform snapshot" description="Current account and tracking coverage."><dl className="divide-y divide-border-default">{[
          ['Vendor stores', summary.activeVendors !== null && summary.inactiveVendors !== null ? summary.activeVendors + summary.inactiveVendors : null],
          ['Active Buyers', summary.activeBuyers],
          ...(summary.canViewAudit ? [['Recorded audit events', summary.auditEvents]] : []),
        ].map(([label, value]) => <div key={String(label)} className="flex items-center justify-between gap-4 py-3 first:pt-0"><dt className="text-xs text-text-secondary">{label}</dt><dd className="text-sm font-semibold tabular-nums">{value === null ? 'Outside your role scope' : Number(value).toLocaleString('en-PH')}</dd></div>)}</dl>{summary.canViewAudit && <Link to="/audit" className="mt-2 inline-flex min-h-11 items-center gap-2 text-sm font-semibold text-action-primary">View audit log<ArrowRight size={16} aria-hidden="true" /></Link>}</DashboardPanel></div>
      </> }, { label: 'Vendor Activity', content: <><dl className="grid gap-4 sm:grid-cols-2 xl:grid-cols-3"><MetricCard label="Active Tier 2 Vendors" value={summary.activeVendors ?? '—'} description={summary.activeVendors === null ? 'Outside your role scope.' : 'Active account and activated store.'} /><MetricCard label="Non-active Vendor stores" value={summary.inactiveVendors ?? '—'} description={summary.inactiveVendors === null ? 'Outside your role scope.' : 'Includes stores completing onboarding.'} /><MetricCard label="Pending business-document reviews" value={summary.pendingDocumentReviews ?? '—'} description={summary.pendingDocumentReviews === null ? 'Outside your role scope.' : 'Submitted documents awaiting review.'} accent /></dl><DashboardPanel title="Vendor verification" description="Review submitted evidence and store requirements.">{summary.pendingDocumentReviews !== null ? <Link to="/vendor-verification" className="inline-flex min-h-11 items-center gap-2 text-sm font-semibold text-action-primary">Open Vendor Management<ArrowRight size={16} aria-hidden="true" /></Link> : <p className="text-sm text-text-secondary">Outside your role scope.</p>}</DashboardPanel></> },
      { label: 'Compliance & Moderation', content: <DashboardPreviewSection title="Compliance overview" description="Product compliance and marketplace moderation." labels={['Product compliance', 'Review moderation', 'Flags and restrictions', 'Scores and badges']} /> },
      { label: 'Disputes & Appeals', content: <DashboardPreviewSection title="Case overview" description="Disputes, appeals and decisions requiring review." labels={['Open disputes', 'Appeals', 'Pending decisions']} /> },
      { label: 'Transactions & Finance', content: <DashboardPreviewSection title="Finance overview" description="Transaction and invoice reporting." labels={['Transaction log', 'Invoice requests', 'Budget override audit']} /> },
      { label: 'Platform Health', content: <><DashboardPreviewSection title="Integration monitoring" description="Provider, background job and privacy-request reporting." labels={['Integration health', 'Background jobs', 'Privacy requests']} />{summary.canViewAudit && <DashboardPanel title="Recent platform activity"><AdminAuditPage embedded /></DashboardPanel>}</> }]} />
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
  const content = <div className="space-y-6"><h2 className="text-xl font-semibold">Audit Logs &amp; Tracking</h2><p className="text-text-secondary">Read-only event tracking. Private payloads and personal contact details are excluded.</p>{error ? <><StatusMessage tone="error">{error}</StatusMessage><Button onClick={() => setAttempt(value => value + 1)}>Retry</Button></> : busy ? <p role="status">Loading audit events…</p> : items.length === 0 ? <p>No audit events recorded.</p> : <div className="overflow-x-auto"><table className="w-full text-left text-sm"><thead><tr>{['Recorded (Manila)', 'Role', 'Action', 'Resource', 'Result', 'Correlation ID'].map(label => <th className="p-3" scope="col" key={label}>{label}</th>)}</tr></thead><tbody>{items.map(item => <tr className="border-t border-border-default" key={String(item.id)}><td className="p-3">{new Date(String(item.created_at)).toLocaleString('en-PH', { timeZone: 'Asia/Manila' })}</td>{['actor_role', 'action', 'resource_type'].map(key => <td className="p-3" key={key}>{String(item[key] ?? 'System')}</td>)}<td className="p-3">{item.succeeded ? 'Succeeded' : 'Failed'}</td><td className="p-3 break-all">{String(item.correlation_id)}</td></tr>)}</tbody></table></div>}<div className="flex items-center gap-4"><Button variant="secondary" disabled={busy || page <= 1} onClick={() => setPage(value => value - 1)}>Previous</Button><span>Page {page} of {lastPage}</span><Button variant="secondary" disabled={busy || page >= lastPage} onClick={() => setPage(value => value + 1)}>Next</Button></div></div>
  return embedded ? content : <AdminShell activeHref="/audit">{content}</AdminShell>
}
