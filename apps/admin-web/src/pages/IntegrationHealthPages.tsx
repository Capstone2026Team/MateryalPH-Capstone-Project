import { dateFilterPreset, BarList, Button, DateFilter, DemoLabel, FactList, FilterTabs, HealthBadge, KpiCard, PageHeader, ReasonedDecisionForm, ServiceDirectory, ShareBar, SidePanel, Toolbar, useAutomaticRefresh, vpsServiceSnapshot, type VpsServiceSnapshot, type ShareSegment } from '@materyalph/web-ui'
import { Activity, AlertTriangle, CheckCircle2, Clock3, RefreshCw, RotateCcw, Server } from 'lucide-react'
import type { IntegrationOverview } from '@materyalph/api-client-ts'
import { useRef, useState } from 'react'
import { Pager, Panel } from '../components/OperationsKit'
import { label as humanize, manilaDateTime, useLoad, useProtectedAction } from '../lib/operations-hooks'
import { integrationOverview, newKey, operationFailures, operationRetries, problemText, retryOperation } from '../lib/operations-api'
import { AdminShell, ErrorState, LoadingState } from './PhaseThreeAdminPages'

type JsonRecord = Record<string, unknown>
const asRecord = (value: unknown): JsonRecord => typeof value === 'object' && value !== null && !Array.isArray(value) ? value as JsonRecord : {}
const text = (value: unknown, fallback = '—') => value === null || value === undefined || value === '' ? fallback : String(value)

/** Maps every server status word onto the shared health vocabulary while keeping the exact server label visible. */
function health(status: string): string {
  if (status === 'HEALTHY') return 'HEALTHY'
  if (status === 'FAILED') return 'FAILING'
  if (['DEGRADED', 'DELAYED', 'STALE', 'OVERDUE'].includes(status)) return 'DEGRADED'
  if (['NOT_CONFIGURED', 'NO_RUN_RECORDED'].includes(status)) return 'NOT_CONFIGURED'
  if (status === 'UNKNOWN') return 'UNKNOWN'
  return 'IDLE'
}
const Status = ({ status }: { status: string }) => <HealthBadge density="compact" state={health(status)} label={humanize(status)} />

type RetryTarget = { type: 'GEO_FACTS_RUN' | 'MATERIAL_SNAPSHOT'; reference: string; label: string }

/** Missing measurements stay unavailable, rather than becoming reassuring zeroes. */
const measurement = (value: unknown): number | null => typeof value === 'number' && Number.isFinite(value) && value >= 0 ? value : null
const countText = (value: unknown) => measurement(value)?.toLocaleString('en-PH') ?? 'Not recorded'
const taskLabel = (value: string) => humanize(value.replace(/^[^:]+:/, '').replaceAll('-', ' '))

function statusSegments(items: { status: string }[]): ShareSegment[] {
  const counts = new Map<string, number>()
  items.forEach(item => counts.set(item.status, (counts.get(item.status) ?? 0) + 1))
  return Array.from(counts, ([status, value]) => ({ key: status, label: status === 'VPS_REFERENCE' ? 'VPS reference' : status === 'CONSOLE_ONLY' ? 'Manage in console' : humanize(status), value,
    colorVar: status === 'HEALTHY' ? '--mp-viz-success' : status === 'FAILED' ? '--mp-viz-error' : ['DEGRADED', 'OVERDUE', 'STALE'].includes(status) ? '--mp-viz-warning' : status === 'SIMULATED' ? '--mp-viz-series-5' : '--mp-viz-series-2' }))
}

function HealthSummary({ data, services }: { data: IntegrationOverview; services: VpsServiceSnapshot[] }) {
  const queues = asRecord(data.queues)
  const tasksNeedingAttention = data.scheduledTasks.filter(task => ['FAILED', 'OVERDUE', 'NO_RUN_RECORDED'].includes(task.status)).length
  return <dl aria-label="Operational summary" className="grid grid-cols-2 gap-2 xl:grid-cols-4">
    <KpiCard className="mp-metric-card-compact" density="compact" label="VPS third-party services" value={services.length} hint="Providers in the VPS deployment" icon={<Server size={18} aria-hidden="true" />} />
    <KpiCard className="mp-metric-card-compact" density="compact" label="Tasks needing attention" value={tasksNeedingAttention} hint="Failed, overdue or no recorded run" icon={<Clock3 size={18} aria-hidden="true" />} />
    <KpiCard className="mp-metric-card-compact" density="compact" label="Dead-lettered deliveries" value={countText(queues.dead_letters)} hint="Eligible work recovers automatically" icon={<AlertTriangle size={18} aria-hidden="true" />} />
    <KpiCard className="mp-metric-card-compact" density="compact" label="Failed jobs" value={countText(queues.failed_jobs)} hint="Eligible work recovers automatically" icon={<Activity size={18} aria-hidden="true" />} />
  </dl>
}

function OverviewCharts({ data, services, onFailures }: { data: IntegrationOverview; services: VpsServiceSnapshot[]; onFailures: () => void }) {
  const queues = asRecord(data.queues)
  const recovery = data.automaticRecovery
  const items = [{ key: 'outbox_backlog', label: 'Outbox backlog (over 5 min)' }, { key: 'dead_letters', label: 'Dead-lettered deliveries' }, { key: 'failed_jobs', label: 'Failed jobs' }]
  const measured = items.flatMap(item => { const value = measurement(queues[item.key]); return value === null ? [] : [{ ...item, value, display: value.toLocaleString('en-PH') }] })
  return <div className="mp-monitoring-health grid h-full min-w-0 gap-3 sm:grid-cols-3 xl:auto-rows-fr xl:grid-cols-1 [&_dl]:gap-x-3 [&_dl]:gap-y-2">
    <Panel compact title="Integration status" description="Distribution of the latest reported statuses. Configuration presence does not confirm live provider availability.">
      <ShareBar variant="donut" totalLabel="Providers" legendColumns={1} label="Integration status distribution" segments={statusSegments(services)} empty="No integrations have been reported." />
    </Panel>
    <Panel compact title="Queues and outbox" actions={<Status status={text(queues.status, 'UNKNOWN')} />}>
      <p className="text-xs leading-5 text-text-secondary">Current counts by category; the same work may appear in more than one category.</p>
      <BarList label="Queue exception counts" items={measured} empty="Queue counts have not been recorded." />
      {measured.length < items.length && <p className="text-xs text-text-secondary">Not recorded: {items.filter(item => measurement(queues[item.key]) === null).map(item => item.label).join(', ')}.</p>}
      <div className="flex flex-wrap items-center justify-between gap-2 border-t border-border-default pt-1"><p className="text-xs text-text-secondary">Connection <strong className="font-medium text-text-strong">{text(queues.connection)}</strong></p><Button variant="quiet" onClick={onFailures}>Review failures</Button></div>
    </Panel>
    <Panel compact title="Automatic recovery" actions={<Status status={recovery?.status ?? 'NO_RUN_RECORDED'} />}>
      <p className="text-xs leading-5 text-text-secondary">Eligible deliveries and jobs are retried by the server. No manual queue action is needed.</p>
      <FactList layout="rows" facts={[{ label: 'Recovery limit', value: recovery ? `${recovery.maxCycles} cycles per event` : 'Not recorded' },
        { label: 'Cooldowns', value: recovery?.delaysMinutes.map(value => value >= 60 ? `${value / 60} h` : `${value} min`).join(' · ') ?? 'Not recorded' },
        { label: 'Last check', value: recovery?.lastStartedAt ? manilaDateTime(recovery.lastStartedAt) : 'No run recorded' }]} />
      <p className="text-xs text-text-secondary">Persistent failures stay visible after the limit. Payments, refunds, credentials and invitations use their own recovery process.</p>
    </Panel>
  </div>
}

function TaskCharts({ tasks }: { tasks: IntegrationOverview['scheduledTasks'] }) {
  const durations = tasks.flatMap(task => { const value = measurement(task.durationMs); return value === null ? [] : [{ key: task.task, label: taskLabel(task.task), value, display: `${(value / 1000).toLocaleString('en-PH', { maximumFractionDigits: 3 })} s`, detail: humanize(task.status) }] }).sort((a, b) => b.value - a.value)
  return <div className="grid min-w-0 content-start gap-3">
    <Panel compact title="Scheduled task status" description="Latest status for each monitored task, including tasks without a recorded run."><ShareBar label="Scheduled task status distribution" segments={statusSegments(tasks)} empty="No scheduled tasks have been reported." /></Panel>
    <Panel compact title="Latest task durations" description="Last recorded duration per task, from longest to shortest. Different tasks have different workloads."><BarList label="Latest scheduled task durations" items={durations} empty="No task durations have been recorded yet." /><p className="text-xs text-text-secondary">{tasks.length - durations.length} of {tasks.length} tasks have no recorded duration.</p></Panel>
  </div>
}

export function AdminIntegrationHealthPage() {
  const overview = useLoad(integrationOverview, [])
  const [kind, setKind] = useState<'OUTBOX' | 'JOBS'>('OUTBOX')
  const [page, setPage] = useState(1)
  const [range, setRange] = useState(() => dateFilterPreset(30))
  const [view, setView] = useState('overview')
  const failures = useLoad(() => operationFailures(kind, page, range), [kind, page, range.from, range.to])
  const retries = useLoad(operationRetries, [])
  const [target, setTarget] = useState<RetryTarget | null>(null)
  const [done, setDone] = useState<string | null>(null)
  useAutomaticRefresh(async () => { overview.retry(); if (view === 'failures') { failures.retry(); retries.retry() } }, { enabled: !overview.loading, intervalMs: 60_000 })
  const data = overview.data
  const analytics = asRecord(data?.analytics)
  const geo = asRecord(analytics.geo_aggregation), snapshot = asRecord(analytics.materials_snapshot), psgc = asRecord(analytics.psgc)
  const environment = asRecord(data?.environment)
  const deployed = environment.deployment === 'HOSTINGER_VPS'
  const services = vpsServiceSnapshot(data?.integrations ?? [], deployed)
  const commerceLabel = text(environment.commerce)
  const canRetry = Boolean(data?.canRetry)
  return <AdminShell activeHref="/integrations"><div className="space-y-3">
    <PageHeader compact eyebrow="Platform control center" title="Platform Monitoring" description="API services, backend jobs and server access in one place."
      actions={<Button variant="secondary" disabled={overview.loading} onClick={() => { overview.retry(); failures.retry(); retries.retry() }}><RefreshCw size={16} aria-hidden="true" />Refresh</Button>} />
    {done && <p role="status" className="rounded-control border border-status-success/30 bg-green-50 px-4 py-3 text-sm text-green-900">{done}</p>}
    {overview.error ? <ErrorState message={overview.error} onRetry={overview.retry} /> : !data ? <LoadingState /> : <>
      <div className="flex flex-wrap items-center justify-between gap-x-4 gap-y-1 rounded-control border border-border-default bg-surface-primary px-3 py-2 text-xs text-text-secondary"><span className="flex flex-wrap items-center gap-2"><span className="font-semibold text-text-strong">{text(environment.app)}</span><span>{commerceLabel}</span></span><span>Checked {manilaDateTime(data.generatedAt)} (Asia/Manila) · Refreshes every minute</span></div>
      <HealthSummary data={data} services={services} />
    </>}
    <FilterTabs appearance="tabs" label="Health section" value={view} onChange={setView} chips={[{ value: 'overview', label: 'Overview' }, { value: 'tasks', label: 'Scheduled tasks' }, { value: 'failures', label: 'Recovery activity' }]} />
    {data && !overview.error && view === 'overview' && <div role="group" aria-label="Platform monitoring overview" className="grid min-w-0 items-stretch gap-3 xl:grid-cols-[18rem_minmax(0,1fr)]">
        <section aria-label="Services & integrations" className="grid min-w-0 content-start gap-3 xl:col-start-2 xl:row-start-1">
          <div><h2 className="mp-card-heading">Services & integrations</h2><p className="mt-1 text-xs leading-5 text-text-secondary">Grouped by platform role. Status reflects configuration and recorded events.</p></div>
          <ServiceDirectory integrations={data.integrations} deployed={deployed} formatDateTime={manilaDateTime} />
        </section>
        <aside aria-label="Platform health" className="min-w-0 xl:col-start-1 xl:row-start-1">
          <OverviewCharts data={data} services={services} onFailures={() => setView('failures')} />
        </aside>
        <div className="min-w-0 xl:col-span-2 [&_dl]:gap-x-3 [&_dl]:gap-y-2">
          <Panel compact title="Analytics and reference data" description="Latest snapshots and reference imports">
          <div className="grid min-w-0 items-start gap-3 lg:grid-cols-3">
            <div className="grid gap-2"><div className="flex flex-wrap items-center justify-between gap-2"><h3 className="font-semibold">Geographic aggregation</h3><Status status={text(geo.status, 'UNKNOWN')} /></div>
              <FactList facts={[{ label: 'Through date', value: text(geo.through_date) }, { label: 'Published', value: geo.last_published_at ? manilaDateTime(String(geo.last_published_at)) : '—' }, { label: 'Revision', value: text(geo.revision) }, ...(geo.error_code ? [{ label: 'Last error code', value: String(geo.error_code) }] : [])]} />
              {asRecord(geo.demo_dataset).label ? <p className="flex flex-wrap items-center gap-2 text-[13px] text-text-secondary"><DemoLabel>{String(asRecord(geo.demo_dataset).label)}</DemoLabel>Published {manilaDateTime(String(asRecord(geo.demo_dataset).published_at))}</p> : null}
              {canRetry && <Button variant="secondary" className="w-fit" onClick={() => setTarget({ type: 'GEO_FACTS_RUN', reference: 'latest', label: 'Geographic analytics aggregation' })}><RotateCcw size={16} aria-hidden="true" />Re-run aggregation</Button>}</div>
            <div className="grid min-w-0 gap-2 border-t border-border-default pt-3 lg:border-t-0 lg:border-l lg:pt-0 lg:pl-3"><div className="flex flex-wrap items-center justify-between gap-2"><h3 className="font-semibold">Materials Analytics snapshot</h3><Status status={text(snapshot.status, 'UNKNOWN')} /></div>
              <FactList facts={[{ label: 'Dataset', value: text(snapshot.dataset) }, { label: 'Snapshot date', value: text(snapshot.snapshot_date) }, { label: 'Selected observations', value: text(snapshot.observations) }, { label: 'Vendors', value: text(snapshot.vendors) }, { label: 'Failed captures (7 days)', value: countText(snapshot.failed_captures_7_days) }]} />
              {canRetry && <Button variant="secondary" className="w-fit" onClick={() => setTarget({ type: 'MATERIAL_SNAPSHOT', reference: 'latest', label: 'Materials Analytics daily snapshot' })}><RotateCcw size={16} aria-hidden="true" />Re-run snapshot</Button>}</div>
            <div className="grid min-w-0 gap-2 border-t border-border-default pt-3 lg:border-t-0 lg:border-l lg:pt-0 lg:pl-3"><div className="flex flex-wrap items-center justify-between gap-2"><h3 className="font-semibold">PSGC reference</h3><Status status={text(psgc.status, 'UNKNOWN')} /></div>
              <FactList facts={[{ label: 'Active version', value: text(psgc.version) }, { label: 'Effective on', value: text(psgc.effective_on) }, { label: 'Boundaries by level', value: Object.entries(asRecord(psgc.boundaries)).map(([level, total]) => `${humanize(level)}: ${String(total)}`).join(', ') || 'None imported (tile view in use)' }, { label: 'Last boundary import', value: psgc.last_boundary_import ? manilaDateTime(String(psgc.last_boundary_import)) : 'Never' }]} /></div>
          </div>
          </Panel>
        </div>
    </div>}
    {data && !overview.error && view === 'tasks' && <div className="grid items-start gap-3 xl:grid-cols-[minmax(0,2fr)_minmax(0,1fr)]">
      <Panel compact title="Scheduled tasks" description="The latest recorded run of each scheduled task.">
        {data.scheduledTasks.length === 0 ? <p className="text-sm text-text-secondary">No scheduled tasks have been reported.</p> : <div className="overflow-x-auto"><table className="w-full min-w-[720px] text-left text-sm"><caption className="sr-only">Scheduled task health</caption>
          <thead className="text-[13px] text-text-secondary"><tr>{['Task', 'Status', 'Last started', 'Duration', 'Expected within'].map(head => <th key={head} scope="col" className="px-3 py-2 font-semibold">{head}</th>)}</tr></thead>
          <tbody className="divide-y divide-border-default">{data.scheduledTasks.map(task => <tr key={task.task}><th scope="row" className="px-3 py-3 text-left"><span className="block font-medium">{taskLabel(task.task)}</span><span className="mt-1 block break-all font-mono text-xs font-normal text-text-secondary">{task.task}</span></th><td className="px-3 py-3"><Status status={task.status} /></td><td className="px-3 py-3">{task.lastStartedAt ? manilaDateTime(task.lastStartedAt) : 'No run recorded'}</td><td className="px-3 py-3 tabular-nums">{measurement(task.durationMs) === null ? '—' : `${((task.durationMs ?? 0) / 1000).toLocaleString('en-PH', { maximumFractionDigits: 3 })} s`}</td><td className="px-3 py-3 tabular-nums">{task.expectedWithinMinutes >= 1440 ? `${task.expectedWithinMinutes / 60} h` : `${task.expectedWithinMinutes} min`}</td></tr>)}</tbody></table></div>}
      </Panel>
      <TaskCharts tasks={data.scheduledTasks} />
    </div>}
    {view === 'failures' && <>
    <Panel title="Failures" description="Eligible work recovers automatically after cooldown. A retry limit or an owning-process notice explains what still needs attention.">
      <FilterTabs appearance="tabs" label="Failure kind" value={kind} onChange={value => { setKind(value as 'OUTBOX' | 'JOBS'); setPage(1) }} chips={[{ value: 'OUTBOX', label: 'Dead-lettered deliveries' }, { value: 'JOBS', label: 'Failed jobs' }]} />
      <Toolbar filters={<><DateFilter title="Failure dates" value={range} onChange={value => { setRange(value); setPage(1) }} /></>} />
      {failures.error ? <ErrorState message={failures.error} onRetry={failures.retry} /> : !failures.data ? <LoadingState /> : failures.data.items.length === 0 ? <p className="flex items-start gap-2 rounded-control bg-surface-canvas p-4 text-sm text-text-secondary"><CheckCircle2 size={18} className="shrink-0 text-status-success" aria-hidden="true" />Nothing has failed in this category{range.from || range.to ? ' for the selected dates' : ''}.</p>
        : <div className="overflow-x-auto"><table className="w-full min-w-[760px] text-left text-sm"><caption className="sr-only">Failures</caption>
          <thead className="text-[13px] text-text-secondary"><tr>{['Work', 'Queue', 'Failure', 'Attempts', 'Failed', 'Recovery'].map(head => <th key={head} scope="col" className="px-3 py-2 font-semibold">{head}</th>)}</tr></thead>
          <tbody className="divide-y divide-border-default">{failures.data.items.map(item => <tr key={item.reference}><th scope="row" className="px-3 py-2 text-left font-normal"><span className="font-semibold">{item.label}</span></th><td className="px-3 py-2">{item.queue}</td><td className="px-3 py-2">{item.failure}</td><td className="px-3 py-2 tabular-nums">{item.attempts ?? '—'}</td><td className="px-3 py-2">{manilaDateTime(item.failedAt)}</td>
            <td className="px-3 py-2 text-[13px] text-text-secondary">{item.recoveryStatus === 'SCHEDULED' ? <><span className="block font-medium text-text-strong">Automatic retry scheduled</span>{item.nextRetryAt && <span className="block">From {manilaDateTime(item.nextRetryAt)} (Asia/Manila)</span>}<span>Recovery {item.recoveryAttempts ?? 0} of 3 used</span></> : item.recoveryStatus === 'LIMIT_REACHED' ? 'Retry limit reached · needs investigation' : item.recoveryStatus === 'RESOLVED' ? 'Completed · clearing stale failure' : item.retryNote ?? 'Recovery status unavailable'}</td></tr>)}</tbody></table></div>}
      {failures.data && <Pager page={page} lastPage={failures.data.lastPage} total={failures.data.total} busy={failures.loading} onChange={setPage} />}
    </Panel>
    <Panel title="Recent recovery activity" description="Automatic recovery and authorized analytics runs, with reasons and correlation IDs.">
      {retries.error ? <ErrorState message={retries.error} onRetry={retries.retry} /> : !retries.data ? <LoadingState /> : retries.data.length === 0 ? <p className="text-sm text-text-secondary">No retries have been requested.</p>
        : <ul className="divide-y divide-border-default">{retries.data.map(item => <li key={item.correlationId} className="grid gap-1 py-3 text-sm"><p><span className="font-semibold">{item.label}</span> · {humanize(item.outcome)} · {manilaDateTime(item.createdAt)}</p><p className="text-text-secondary">{item.actor} ({item.actorRole}): {item.reason}</p><p className="break-all text-[13px] text-text-secondary">Correlation ID {item.correlationId}</p></li>)}</ul>}
    </Panel>
    </>}
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
