import { Button, DemoLabel, FactList, FilterTabs, HealthBadge, InfoNote, ReasonedDecisionForm, SidePanel, formatPesoCentavos, useAutomaticRefresh } from '@materyalph/web-ui'
import { RefreshCw, RotateCcw } from 'lucide-react'
import { useRef, useState } from 'react'
import { Pager, Panel } from '../components/OperationsKit'
import { label as humanize, manilaDate, manilaDateTime, useLoad, useProtectedAction } from '../lib/operations-hooks'
import { integrationOverview, listBudgetOverrides, newKey, operationFailures, operationRetries, problemText, retryOperation } from '../lib/operations-api'
import { AdminShell, ErrorState, LoadingState, PageHeader } from './PhaseThreeAdminPages'

type JsonRecord = Record<string, unknown>
const asRecord = (value: unknown): JsonRecord => typeof value === 'object' && value !== null && !Array.isArray(value) ? value as JsonRecord : {}
const text = (value: unknown, fallback = '—') => value === null || value === undefined || value === '' ? fallback : String(value)

/** Maps every server status word onto the shared health vocabulary while keeping the exact server label visible. */
function health(status: string): string {
  if (status === 'HEALTHY') return 'HEALTHY'
  if (status === 'FAILED') return 'FAILING'
  if (['DEGRADED', 'DELAYED', 'STALE', 'OVERDUE'].includes(status)) return 'DEGRADED'
  if (['NOT_CONFIGURED', 'NO_RUN_RECORDED'].includes(status)) return 'NOT_CONFIGURED'
  return 'IDLE'
}
const Status = ({ status }: { status: string }) => <HealthBadge state={health(status)} label={humanize(status)} />

type RetryTarget = { type: 'FAILED_JOB' | 'OUTBOX_EVENT' | 'GEO_FACTS_RUN' | 'MATERIAL_SNAPSHOT'; reference: string; label: string }

export function AdminIntegrationHealthPage() {
  const overview = useLoad(integrationOverview, [])
  const [kind, setKind] = useState<'OUTBOX' | 'JOBS'>('OUTBOX')
  const [page, setPage] = useState(1)
  const failures = useLoad(() => operationFailures(kind, page), [kind, page])
  const retries = useLoad(operationRetries, [])
  const [target, setTarget] = useState<RetryTarget | null>(null)
  const [done, setDone] = useState<string | null>(null)
  useAutomaticRefresh(async () => { overview.retry() }, { enabled: !overview.loading, intervalMs: 60_000 })
  const data = overview.data
  const analytics = asRecord(data?.analytics)
  const geo = asRecord(analytics.geo_aggregation), snapshot = asRecord(analytics.materials_snapshot), psgc = asRecord(analytics.psgc)
  const queues = asRecord(data?.queues), environment = asRecord(data?.environment)
  const canRetry = Boolean(data?.canRetry)
  return <AdminShell activeHref="/integrations"><div className="space-y-6">
    <PageHeader eyebrow="Platform" title="Integration & Job Health" description="Provider configuration presence, queues, scheduled tasks and daily analytics runs. Credentials, payloads, recipients and exception messages are never shown."
      actions={<Button variant="secondary" disabled={overview.loading} onClick={() => { overview.retry(); failures.retry(); retries.retry() }}><RefreshCw size={16} aria-hidden="true" />Refresh</Button>} />
    {done && <p role="status" className="rounded-control border border-status-success/30 bg-green-50 px-4 py-3 text-sm text-green-900">{done}</p>}
    {overview.error ? <ErrorState message={overview.error} onRetry={overview.retry} /> : !data ? <LoadingState /> : <>
      <div className="flex flex-wrap items-center gap-2 text-sm text-text-secondary"><span className="font-semibold text-text-strong">{text(environment.app)}</span><span aria-hidden="true">·</span><span>{text(environment.commerce)}</span><span aria-hidden="true">·</span><span>Checked {manilaDateTime(data.generatedAt)}</span></div>
      <Panel title="Integrations" description="Configured means a value is present; values are never displayed.">
        <ul className="grid gap-3 md:grid-cols-2 2xl:grid-cols-3">{data.integrations.map(item => <li key={item.key} className="grid min-w-0 content-start gap-2 rounded-control border border-border-default p-4">
          <div className="flex flex-wrap items-start justify-between gap-2"><h3 className="min-w-0 break-words font-semibold">{item.label}</h3><Status status={item.status} /></div>
          <p className="text-sm text-text-secondary">{item.detail}</p>
          {(item.environment || item.lastEventAt) && <p className="text-[13px] text-text-secondary">{[item.environment, item.lastEventAt ? `Last event ${manilaDateTime(item.lastEventAt)}` : null].filter(Boolean).join(' · ')}</p>}
        </li>)}</ul>
      </Panel>
      <div className="grid items-start gap-5 xl:grid-cols-2">
        <Panel title="Queues and outbox" actions={<Status status={text(queues.status, 'UNKNOWN')} />}>
          <FactList facts={[{ label: 'Queue connection', value: text(queues.connection) }, { label: 'Outbox backlog (over 5 min)', value: text(queues.outbox_backlog, '0') }, { label: 'Dead-lettered deliveries', value: text(queues.dead_letters, '0') }, { label: 'Failed jobs', value: text(queues.failed_jobs, '0') }]} />
        </Panel>
        <Panel title="Daily analytics" description="TEST facts are rebuilt nightly; DEMO data is labelled and never mixed with TEST.">
          <div className="grid gap-4">
            <div className="grid gap-2"><div className="flex flex-wrap items-center justify-between gap-2"><h3 className="font-semibold">Geographic aggregation</h3><Status status={text(geo.status, 'UNKNOWN')} /></div>
              <FactList facts={[{ label: 'Through date', value: text(geo.through_date) }, { label: 'Published', value: geo.last_published_at ? manilaDateTime(String(geo.last_published_at)) : '—' }, { label: 'Revision', value: text(geo.revision) }, ...(geo.error_code ? [{ label: 'Last error code', value: String(geo.error_code) }] : [])]} />
              {asRecord(geo.demo_dataset).label ? <p className="flex flex-wrap items-center gap-2 text-[13px] text-text-secondary"><DemoLabel>{String(asRecord(geo.demo_dataset).label)}</DemoLabel>Published {manilaDateTime(String(asRecord(geo.demo_dataset).published_at))}</p> : null}
              {canRetry && <Button variant="secondary" className="w-fit" onClick={() => setTarget({ type: 'GEO_FACTS_RUN', reference: 'latest', label: 'Geographic analytics aggregation' })}><RotateCcw size={16} aria-hidden="true" />Re-run aggregation</Button>}</div>
            <div className="grid gap-2 border-t border-border-default pt-4"><div className="flex flex-wrap items-center justify-between gap-2"><h3 className="font-semibold">Materials Analytics snapshot</h3><Status status={text(snapshot.status, 'UNKNOWN')} /></div>
              <FactList facts={[{ label: 'Dataset', value: text(snapshot.dataset) }, { label: 'Snapshot date', value: text(snapshot.snapshot_date) }, { label: 'Selected observations', value: text(snapshot.observations) }, { label: 'Vendors', value: text(snapshot.vendors) }, { label: 'Failed captures (7 days)', value: text(snapshot.failed_captures_7_days, '0') }]} />
              {canRetry && <Button variant="secondary" className="w-fit" onClick={() => setTarget({ type: 'MATERIAL_SNAPSHOT', reference: 'latest', label: 'Materials Analytics daily snapshot' })}><RotateCcw size={16} aria-hidden="true" />Re-run snapshot</Button>}</div>
            <div className="grid gap-2 border-t border-border-default pt-4"><div className="flex flex-wrap items-center justify-between gap-2"><h3 className="font-semibold">PSGC reference</h3><Status status={text(psgc.status, 'UNKNOWN')} /></div>
              <FactList facts={[{ label: 'Active version', value: text(psgc.version) }, { label: 'Effective on', value: text(psgc.effective_on) }, { label: 'Boundaries by level', value: Object.entries(asRecord(psgc.boundaries)).map(([level, total]) => `${humanize(level)}: ${String(total)}`).join(', ') || 'None imported (tile view in use)' }, { label: 'Last boundary import', value: psgc.last_boundary_import ? manilaDateTime(String(psgc.last_boundary_import)) : 'Never' }]} /></div>
          </div>
        </Panel>
      </div>
      <Panel title="Scheduled tasks" description="The latest recorded run of each scheduled task.">
        <div className="overflow-x-auto"><table className="w-full min-w-[720px] text-left text-sm"><caption className="sr-only">Scheduled task health</caption>
          <thead className="text-[13px] text-text-secondary"><tr>{['Task', 'Status', 'Last started', 'Duration', 'Expected within'].map(head => <th key={head} scope="col" className="px-3 py-2 font-semibold">{head}</th>)}</tr></thead>
          <tbody className="divide-y divide-border-default">{data.scheduledTasks.map(task => <tr key={task.task}><th scope="row" className="px-3 py-2 text-left font-mono text-[13px] font-normal break-all">{task.task}</th><td className="px-3 py-2"><Status status={task.status} /></td><td className="px-3 py-2">{task.lastStartedAt ? manilaDateTime(task.lastStartedAt) : 'No run recorded'}</td><td className="px-3 py-2 tabular-nums">{task.durationMs === null || task.durationMs === undefined ? '—' : `${(task.durationMs / 1000).toFixed(1)} s`}</td><td className="px-3 py-2 tabular-nums">{task.expectedWithinMinutes >= 1440 ? `${Math.round(task.expectedWithinMinutes / 60)} h` : `${task.expectedWithinMinutes} min`}</td></tr>)}</tbody></table></div>
      </Panel>
    </>}
    <Panel title="Failures" description="Class names and failure categories only. Payment, refund, credential and invitation work is retried by its own reconciliation, never from here.">
      <FilterTabs appearance="tabs" label="Failure kind" value={kind} onChange={value => { setKind(value as 'OUTBOX' | 'JOBS'); setPage(1) }} chips={[{ value: 'OUTBOX', label: 'Dead-lettered deliveries' }, { value: 'JOBS', label: 'Failed jobs' }]} />
      {failures.error ? <ErrorState message={failures.error} onRetry={failures.retry} /> : !failures.data ? <LoadingState /> : failures.data.items.length === 0 ? <p className="text-sm text-text-secondary">Nothing has failed in this category.</p>
        : <div className="overflow-x-auto"><table className="w-full min-w-[760px] text-left text-sm"><caption className="sr-only">Failures</caption>
          <thead className="text-[13px] text-text-secondary"><tr>{['Work', 'Queue', 'Failure', 'Attempts', 'Failed', ''].map(head => <th key={head} scope="col" className="px-3 py-2 font-semibold">{head || <span className="sr-only">Action</span>}</th>)}</tr></thead>
          <tbody className="divide-y divide-border-default">{failures.data.items.map(item => <tr key={item.reference}><th scope="row" className="px-3 py-2 text-left font-normal"><span className="font-semibold">{item.label}</span></th><td className="px-3 py-2">{item.queue}</td><td className="px-3 py-2">{item.failure}</td><td className="px-3 py-2 tabular-nums">{item.attempts ?? '—'}</td><td className="px-3 py-2">{manilaDateTime(item.failedAt)}</td>
            <td className="px-3 py-2 text-right">{item.retryable && canRetry ? <Button variant="secondary" onClick={() => setTarget({ type: item.kind, reference: item.reference, label: item.label })}>Retry</Button> : <span className="text-[13px] text-text-secondary">{item.retryNote ?? 'Not retryable here'}</span>}</td></tr>)}</tbody></table></div>}
      {failures.data && <Pager page={page} lastPage={failures.data.lastPage} total={failures.data.total} busy={failures.loading} onChange={setPage} />}
    </Panel>
    <Panel title="Recent retries" description="Every retry records its reason, actor and correlation ID.">
      {retries.error ? <ErrorState message={retries.error} onRetry={retries.retry} /> : !retries.data ? <LoadingState /> : retries.data.length === 0 ? <p className="text-sm text-text-secondary">No retries have been requested.</p>
        : <ul className="divide-y divide-border-default">{retries.data.map(item => <li key={item.correlationId} className="grid gap-1 py-3 text-sm"><p><span className="font-semibold">{item.label}</span> · {humanize(item.outcome)} · {manilaDateTime(item.createdAt)}</p><p className="text-text-secondary">{item.actor} ({item.actorRole}): {item.reason}</p><p className="break-all text-[13px] text-text-secondary">Correlation ID {item.correlationId}</p></li>)}</ul>}
    </Panel>
    {target && <RetryPanel target={target} onClose={() => setTarget(null)} onDone={message => { setTarget(null); setDone(message); failures.retry(); retries.retry(); overview.retry() }} />}
  </div></AdminShell>
}

function RetryPanel({ target, onClose, onDone }: { target: RetryTarget; onClose: () => void; onDone: (message: string) => void }) {
  const [error, setError] = useState<string | null>(null)
  const key = useRef({ scope: '', value: newKey() })
  const { run, busy, dialog } = useProtectedAction()
  async function submit(reason: string) {
    setError(null)
    const input = { targetType: target.type, reference: target.reference, reason }
    const scope = JSON.stringify(input)
    if (key.current.scope !== scope) key.current = { scope, value: newKey() }
    const result = await run('Verify to retry this work', () => retryOperation(input, key.current.value))
    if (result.ok) onDone(`${result.value.label} was queued again (correlation ID ${result.value.correlationId}).`)
    else setError(problemText(result.problem))
  }
  return <SidePanel open title="Retry work" description="Only allowlisted, idempotent work can be retried." onClose={onClose}>
    <ReasonedDecisionForm title="Queue a retry" target={target.label} before={humanize(target.type)} after="Queued for another attempt" submitLabel="Queue retry" busy={busy} error={error} minReason={10} maxReason={500} onSubmit={reason => void submit(reason)} />
    {dialog}
  </SidePanel>
}

export function AdminBudgetOverridesPage() {
  const [page, setPage] = useState(1)
  const list = useLoad(() => listBudgetOverrides(page), [page])
  return <AdminShell activeHref="/budget-overrides"><div className="space-y-6">
    <PageHeader eyebrow="Finance" title="Budget Override Audit Log" description="Buyer-confirmed orders that exceeded a Project or Work Package budget, with the recorded reason. Read-only; Admins cannot change a Buyer budget." />
    <InfoNote>Buyers are identified by a short pseudonymous suffix only.</InfoNote>
    {list.error ? <ErrorState message={list.error} onRetry={list.retry} /> : !list.data ? <LoadingState /> : list.data.items.length === 0
      ? <p className="rounded-surface border border-dashed border-border-default bg-surface-primary px-6 py-10 text-center text-sm text-text-secondary">No budget overrides have been recorded.</p>
      : <div className="overflow-x-auto rounded-surface border border-border-default bg-surface-primary"><table className="w-full min-w-[900px] text-left text-sm"><caption className="sr-only">Budget overrides</caption>
        <thead className="bg-surface-canvas text-[13px] text-text-secondary"><tr>{['Recorded', 'Project / Work Package', 'Order', 'Budget before', 'Order amount', 'Overage', 'Reason', 'Buyer'].map(head => <th key={head} scope="col" className="px-3 py-3 font-semibold">{head}</th>)}</tr></thead>
        <tbody className="divide-y divide-border-default">{list.data.items.map(item => <tr key={item.id} className="align-top"><td className="px-3 py-3">{manilaDate(item.recordedAt)}</td><th scope="row" className="px-3 py-3 text-left font-normal"><span className="font-semibold">{item.project}</span><p className="text-[13px] text-text-secondary">{item.workPackage}</p></th><td className="px-3 py-3">{item.orderReference ?? '—'}</td>
          <td className="px-3 py-3 text-right tabular-nums">{formatPesoCentavos(item.priorBudgetCentavos)}</td><td className="px-3 py-3 text-right tabular-nums">{formatPesoCentavos(item.orderAmountCentavos)}</td><td className="px-3 py-3 text-right font-semibold tabular-nums">{formatPesoCentavos(item.overageCentavos)}</td><td className="max-w-72 px-3 py-3">{item.reason}</td><td className="px-3 py-3">{item.actor}</td></tr>)}</tbody></table></div>}
    {list.data && <Pager page={page} lastPage={list.data.lastPage} total={list.data.total} busy={list.loading} onChange={setPage} />}
  </div></AdminShell>
}
