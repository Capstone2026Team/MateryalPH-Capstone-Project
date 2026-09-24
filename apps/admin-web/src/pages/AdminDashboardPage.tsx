import { DashboardHeader, MetricCard, SectionWorkspace, PreviewMetrics } from '@materyalph/web-ui'
import { useCallback, useEffect, useState } from 'react'
import { AdminVendorVerificationApi, type AdminDashboardSummary } from '@materyalph/api-client-ts'
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
    catch (cause) { setError(await readableVerificationError(cause)) }
    finally { setBusy(false) }
  }, [])
  useEffect(() => { void load() }, [load])
  return <AdminShell activeHref="/dashboard"><div className="space-y-6">
    <DashboardHeader eyebrow="Platform overview" description="Current account, activation and review counts within your Admin permissions." actions={<Button variant="secondary" disabled={busy} onClick={() => void load()}>Refresh dashboard</Button>} />
    {error ? <StatusMessage tone="error">{error}</StatusMessage> : busy ? <p role="status">Loading platform metrics…</p> : summary && <>
      <SectionWorkspace dateFilter sections={[{ label: 'Overview', content: <><dl className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">{[
        ['Active Tier 2 Vendors', summary.activeVendors, 'Active account and activated store.'],
        ['Non-active Vendor stores', summary.inactiveVendors, 'Registered stores not currently active, including onboarding.'],
        ['Active Buyers', summary.activeBuyers, 'Buyer accounts with ACTIVE status.'],
        ['Pending business-document reviews', summary.pendingDocumentReviews, 'Submitted documents awaiting review.'],
      ].map(([label, value, description]) => <MetricCard key={String(label)} label={String(label)} value={value === null ? '—' : value} description={value === null ? 'Outside your role scope.' : String(description)} />)}</dl>
      </> }, { label: 'Vendor Activity', content: <><p className="mb-4">Pending business-document reviews: {summary.pendingDocumentReviews ?? 'Outside your role scope'}</p><PreviewMetrics labels={['Approved Vendors', 'Changes required', 'Restricted or suspended Vendors']} /></> }, { label: 'Compliance & Moderation', content: <PreviewMetrics labels={['Product compliance', 'Review moderation', 'Flags and restrictions', 'Scores and badges']} /> }, { label: 'Disputes & Appeals', content: <PreviewMetrics labels={['Open disputes', 'Appeals', 'Pending decisions']} /> }, { label: 'Transactions & Finance', content: <PreviewMetrics labels={['Transaction log', 'Invoice requests', 'Budget override audit']} /> }, { label: 'Platform Health', content: <><PreviewMetrics labels={['Integration health', 'Background jobs', 'Privacy requests']} />{summary.canViewAudit && <section className="rounded-surface border border-border-default bg-surface-primary p-5 sm:p-6"><AdminAuditPage embedded /></section>}</> }]} />
      <p className="text-sm text-text-secondary">Updated {new Intl.DateTimeFormat('en-PH', { dateStyle: 'medium', timeStyle: 'short', timeZone: 'Asia/Manila' }).format(summary.generatedAt)} (Asia/Manila)</p>
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
  const content = <div className="space-y-6"><h2 className="text-xl font-semibold">Audit Logs &amp; Tracking</h2><p className="text-text-secondary">Read-only event tracking. Private payloads and personal contact details are excluded.</p>{error ? <><StatusMessage tone="error">{error}</StatusMessage><Button onClick={() => setAttempt(value => value + 1)}>Retry</Button></> : busy ? <p role="status">Loading audit events…</p> : items.length === 0 ? <p>No audit events recorded.</p> : <div className="overflow-x-auto"><table className="w-full text-left text-sm"><thead><tr>{['Recorded (Manila)', 'Role', 'Action', 'Resource', 'Result', 'Correlation ID'].map(label => <th className="p-3" scope="col" key={label}>{label}</th>)}</tr></thead><tbody>{items.map(item => <tr className="border-t border-border-default" key={String(item.id)}><td className="p-3">{new Date(String(item.created_at)).toLocaleString('en-PH', { timeZone: 'Asia/Manila' })}</td>{['actor_role', 'action', 'resource_type'].map(key => <td className="p-3" key={key}>{String(item[key] ?? 'System')}</td>)}<td className="p-3">{item.succeeded ? 'Succeeded' : 'Failed'}</td><td className="p-3 break-all">{String(item.correlation_id)}</td></tr>)}</tbody></table></div>}<div className="flex items-center gap-4"><Button variant="secondary" disabled={busy || page <= 1} onClick={() => setPage(value => value - 1)}>Previous</Button><span>Page {page} of {lastPage}</span><Button variant="secondary" disabled={busy || page >= lastPage} onClick={() => setPage(value => value + 1)}>Next</Button></div></div>
  return embedded ? content : <AdminShell activeHref="/audit">{content}</AdminShell>
}
