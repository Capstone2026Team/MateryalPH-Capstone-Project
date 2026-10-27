import { ALL_DATES, BarList, Button, DateFilter, DemoLabel, FactList, FilterTabs, HealthBadge, KpiCard, ReasonedDecisionForm, ShareBar, SidePanel, Toolbar, useAutomaticRefresh, type ShareSegment } from '@materyalph/web-ui'
import { Activity, AlertTriangle, CheckCircle2, Clock3, RefreshCw, RotateCcw, Server } from 'lucide-react'
import type { IntegrationOverview } from '@materyalph/api-client-ts'
import { useRef, useState } from 'react'
import { Pager, Panel } from '../components/OperationsKit'
import { label as humanize, manilaDateTime, useLoad, useProtectedAction } from '../lib/operations-hooks'
import { integrationOverview, newKey, operationFailures, operationRetries, problemText, retryOperation } from '../lib/operations-api'
import { AdminShell, ErrorState, LoadingState, PageHeader } from './PhaseThreeAdminPages'
import { BulkOperationRetryPanel } from './BulkOperationRetryPanel'

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
const Status = ({ status }: { status: string }) => <HealthBadge state={health(status)} label={humanize(status)} />

type RetryTarget = { type: 'FAILED_JOB' | 'OUTBOX_EVENT' | 'GEO_FACTS_RUN' | 'MATERIAL_SNAPSHOT'; reference: string; label: string }

/** Missing measurements stay unavailable, rather than becoming reassuring zeroes. */
const measurement = (value: unknown): number | null => typeof value === 'number' && Number.isFinite(value) && value >= 0 ? value : null
const countText = (value: unknown) => measurement(value)?.toLocaleString('en-PH') ?? 'Not recorded'
const taskLabel = (value: string) => humanize(value.replace(/^[^:]+:/, '').replaceAll('-', ' '))

function statusSegments(items: { status: string }[]): ShareSegment[] {
  const counts = new Map<string, number>()
  items.forEach(item => counts.set(item.status, (counts.get(item.status) ?? 0) + 1))
  return Array.from(counts, ([status, value]) => ({ key: status, label: humanize(status), value,
    colorVar: status === 'HEALTHY' ? '--mp-viz-series-3' : status === 'FAILED' ? '--mp-viz-series-2' : ['DEGRADED', 'OVERDUE', 'STALE'].includes(status) ? '--mp-viz-series-4' : status === 'SIMULATED' ? '--mp-viz-series-5' : '--mp-viz-series-1' }))
}

function HealthSummary({ data, onRetry }: { data: IntegrationOverview; onRetry: (kind: 'OUTBOX' | 'JOBS') => void }) {
  const queues = asRecord(data.queues)
  const tasksNeedingAttention = data.scheduledTasks.filter(task => ['FAILED', 'OVERDUE', 'NO_RUN_RECORDED'].includes(task.status)).length
  return <dl aria-label="Operational summary" className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
    <KpiCard label="Integrations reporting healthy" value={`${data.integrations.filter(item => item.status === 'HEALTHY').length} / ${data.integrations.length}`} hint="Configuration and recorded events" icon={<Server size={18} aria-hidden="true" />} />
    <KpiCard label="Tasks needing attention" value={tasksNeedingAttention} hint="Failed, overdue or no recorded run" icon={<Clock3 size={18} aria-hidden="true" />} />
    <KpiCard label="Dead-lettered deliveries" value={countText(queues.dead_letters)} hint="Deliveries that exhausted their attempts" icon={<AlertTriangle size={18} aria-hidden="true" />} actions={data.canRetry && <Button variant="outline" className="w-full" disabled={!measurement(queues.dead_letters)} onClick={() => onRetry('OUTBOX')}><RotateCcw size={16} aria-hidden="true" />Retry eligible deliveries</Button>} />
    <KpiCard label="Failed jobs" value={countText(queues.failed_jobs)} hint="Jobs currently in the failure queue" icon={<Activity size={18} aria-hidden="true" />} actions={data.canRetry && <Button variant="outline" className="w-full" disabled={!measurement(queues.failed_jobs)} onClick={() => onRetry('JOBS')}><RotateCcw size={16} aria-hidden="true" />Retry eligible jobs</Button>} />
  </dl>
}

function OverviewCharts({ data, onFailures }: { data: IntegrationOverview; onFailures: () => void }) {
  const queues = asRecord(data.queues)
  const items = [{ key: 'outbox_backlog', label: 'Outbox backlog (over 5 min)' }, { key: 'dead_letters', label: 'Dead-lettered deliveries' }, { key: 'failed_jobs', label: 'Failed jobs' }]
  const measured = items.flatMap(item => { const value = measurement(queues[item.key]); return value === null ? [] : [{ ...item, value, display: value.toLocaleString('en-PH') }] })
  return <div className="grid min-w-0 content-start gap-5">
    <Panel title="Integration status" description="Distribution of the latest reported statuses. Configuration presence does not confirm live provider availability.">
      <ShareBar label="Integration status distribution" segments={statusSegments(data.integrations)} empty="No integrations have been reported." />
    </Panel>
    <Panel title="Queues and outbox" description="Current counts by category; the same work may appear in more than one category." actions={<Status status={text(queues.status, 'UNKNOWN')} />}>
      <BarList label="Queue exception counts" items={measured} empty="Queue counts have not been recorded." />
      {measured.length < items.length && <p className="text-xs text-text-secondary">Not recorded: {items.filter(item => measurement(queues[item.key]) === null).map(item => item.label).join(', ')}.</p>}
      <div className="flex flex-wrap items-center justify-between gap-3 border-t border-border-default pt-3"><p className="text-sm text-text-secondary">Connection <strong className="font-medium text-text-strong">{text(queues.connection)}</strong></p><Button variant="quiet" onClick={onFailures}>Review failures</Button></div>
    </Panel>
  </div>
}

function TaskCharts({ tasks }: { tasks: IntegrationOverview['scheduledTasks'] }) {
  const durations = tasks.flatMap(task => { const value = measurement(task.durationMs); return value === null ? [] : [{ key: task.task, label: taskLabel(task.task), value, display: `${(value / 1000).toLocaleString('en-PH', { maximumFractionDigits: 3 })} s`, detail: humanize(task.status) }] }).sort((a, b) => b.value - a.value)
  return <div className="grid min-w-0 content-start gap-5">
    <Panel title="Scheduled task status" description="Latest status for each monitored task, including tasks without a recorded run."><ShareBar label="Scheduled task status distribution" segments={statusSegments(tasks)} empty="No scheduled tasks have been reported." /></Panel>
    <Panel title="Latest task durations" description="Last recorded duration per task, from longest to shortest. Different tasks have different workloads."><BarList label="Latest scheduled task durations" items={durations} empty="No task durations have been recorded yet." /><p className="text-xs text-text-secondary">{tasks.length - durations.length} of {tasks.length} tasks have no recorded duration.</p></Panel>
  </div>
}

export function AdminIntegrationHealthPage() {
  const overview = useLoad(integrationOverview, [])
  const [kind, setKind] = useState<'OUTBOX' | 'JOBS'>('OUTBOX')
  const [page, setPage] = useState(1)
  const [range, setRange] = useState(ALL_DATES)
  const [view, setView] = useState('overview')
  const failures = useLoad(() => operationFailures(kind, page, range), [kind, page, range.from, range.to])
  const retries = useLoad(operationRetries, [])
  const [target, setTarget] = useState<RetryTarget | null>(null)
  const [bulkKind, setBulkKind] = useState<'OUTBOX' | 'JOBS' | null>(null)
  const [done, setDone] = useState<string | null>(null)
  useAutomaticRefresh(async () => { overview.retry() }, { enabled: !overview.loading, intervalMs: 60_000 })
  const data = overview.data
  const analytics = asRecord(data?.analytics)
  const geo = asRecord(analytics.geo_aggregation), snapshot = asRecord(analytics.materials_snapshot), psgc = asRecord(analytics.psgc)
  const environment = asRecord(data?.environment)
  const canRetry = Boolean(data?.canRetry)
  return <AdminShell activeHref="/integrations"><div className="space-y-6">
    <PageHeader eyebrow="Platform operations" title="Integration & Job Health" description="Review integration status, monitor scheduled work and resolve delivery failures."
      actions={<Button variant="secondary" disabled={overview.loading} onClick={() => { overview.retry(); failures.retry(); retries.retry() }}><RefreshCw size={16} aria-hidden="true" />Refresh</Button>} />
    {done && <p role="status" className="rounded-control border border-status-success/30 bg-green-50 px-4 py-3 text-sm text-green-900">{done}</p>}
    {overview.error ? <ErrorState message={overview.error} onRetry={overview.retry} /> : !data ? <LoadingState /> : <>
      <div className="flex flex-wrap items-center justify-between gap-x-4 gap-y-2 rounded-control border border-border-default bg-surface-primary px-4 py-3 text-xs text-text-secondary"><span className="flex flex-wrap items-center gap-2"><span className="font-semibold text-text-strong">{text(environment.app)}</span><span aria-hidden="true">·</span><span>{text(environment.commerce)}</span></span><span>Checked {manilaDateTime(data.generatedAt)} (Asia/Manila) · Refreshes every minute</span></div>
      <HealthSummary data={data} onRetry={setBulkKind} />
    </>}
    <FilterTabs appearance="tabs" label="Health section" value={view} onChange={setView} chips={[{ value: 'overview', label: 'Overview' }, { value: 'tasks', label: 'Scheduled tasks' }, { value: 'failures', label: 'Failures & retries' }]} />
    {data && !overview.error && view === 'overview' && <>
      <div className="grid items-start gap-5 xl:grid-cols-[minmax(0,2fr)_minmax(0,1fr)]">
        <Panel title="Integrations" description="Configuration and recorded events only. Credentials and sensitive payloads are never displayed.">
          {data.integrations.length === 0 ? <p className="text-sm text-text-secondary">No integrations have been reported.</p> : <ul className="grid gap-x-6 md:grid-cols-2">{data.integrations.map(item => <li key={item.key} className="grid min-w-0 content-start gap-2 border-t border-border-default py-4">
            <div className="flex flex-wrap items-start justify-between gap-2"><h3 className="min-w-0 break-words font-semibold">{item.label}</h3><Status status={item.status} /></div>
            <p className="text-sm text-text-secondary">{item.detail}</p>
            {(item.environment || item.lastEventAt) && <p className="text-[13px] text-text-secondary">{[item.environment, item.lastEventAt ? `Last event ${manilaDateTime(item.lastEventAt)}` : null].filter(Boolean).join(' · ')}</p>}
          </li>)}</ul>}
        </Panel>
        <OverviewCharts data={data} onFailures={() => setView('failures')} />
      </div>
        <Panel title="Analytics and reference data" description="Publication times and capture dates from the latest recorded runs.">
          <div className="grid items-start gap-5 2xl:grid-cols-3">
            <div className="grid gap-2"><div className="flex flex-wrap items-center justify-between gap-2"><h3 className="font-semibold">Geographic aggregation</h3><Status status={text(geo.status, 'UNKNOWN')} /></div>
              <FactList facts={[{ label: 'Through date', value: text(geo.through_date) }, { label: 'Published', value: geo.last_published_at ? manilaDateTime(String(geo.last_published_at)) : '—' }, { label: 'Revision', value: text(geo.revision) }, ...(geo.error_code ? [{ label: 'Last error code', value: String(geo.error_code) }] : [])]} />
              {asRecord(geo.demo_dataset).label ? <p className="flex flex-wrap items-center gap-2 text-[13px] text-text-secondary"><DemoLabel>{String(asRecord(geo.demo_dataset).label)}</DemoLabel>Published {manilaDateTime(String(asRecord(geo.demo_dataset).published_at))}</p> : null}
              {canRetry && <Button variant="secondary" className="w-fit" onClick={() => setTarget({ type: 'GEO_FACTS_RUN', reference: 'latest', label: 'Geographic analytics aggregation' })}><RotateCcw size={16} aria-hidden="true" />Re-run aggregation</Button>}</div>
            <div className="grid gap-2 border-t border-border-default pt-5 2xl:border-l 2xl:border-t-0 2xl:pl-5 2xl:pt-0"><div className="flex flex-wrap items-center justify-between gap-2"><h3 className="font-semibold">Materials Analytics snapshot</h3><Status status={text(snapshot.status, 'UNKNOWN')} /></div>
              <FactList facts={[{ label: 'Dataset', value: text(snapshot.dataset) }, { label: 'Snapshot date', value: text(snapshot.snapshot_date) }, { label: 'Selected observations', value: text(snapshot.observations) }, { label: 'Vendors', value: text(snapshot.vendors) }, { label: 'Failed captures (7 days)', value: countText(snapshot.failed_captures_7_days) }]} />
              {canRetry && <Button variant="secondary" className="w-fit" onClick={() => setTarget({ type: 'MATERIAL_SNAPSHOT', reference: 'latest', label: 'Materials Analytics daily snapshot' })}><RotateCcw size={16} aria-hidden="true" />Re-run snapshot</Button>}</div>
            <div className="grid gap-2 border-t border-border-default pt-5 2xl:border-l 2xl:border-t-0 2xl:pl-5 2xl:pt-0"><div className="flex flex-wrap items-center justify-between gap-2"><h3 className="font-semibold">PSGC reference</h3><Status status={text(psgc.status, 'UNKNOWN')} /></div>
              <FactList facts={[{ label: 'Active version', value: text(psgc.version) }, { label: 'Effective on', value: text(psgc.effective_on) }, { label: 'Boundaries by level', value: Object.entries(asRecord(psgc.boundaries)).map(([level, total]) => `${humanize(level)}: ${String(total)}`).join(', ') || 'None imported (tile view in use)' }, { label: 'Last boundary import', value: psgc.last_boundary_import ? manilaDateTime(String(psgc.last_boundary_import)) : 'Never' }]} /></div>
          </div>
        </Panel>
    </>}
    {data && !overview.error && view === 'tasks' && <div className="grid items-start gap-5 xl:grid-cols-[minmax(0,2fr)_minmax(0,1fr)]">
      <Panel title="Scheduled tasks" description="The latest recorded run of each scheduled task.">
        {data.scheduledTasks.length === 0 ? <p className="text-sm text-text-secondary">No scheduled tasks have been reported.</p> : <div className="overflow-x-auto"><table className="w-full min-w-[720px] text-left text-sm"><caption className="sr-only">Scheduled task health</caption>
          <thead className="text-[13px] text-text-secondary"><tr>{['Task', 'Status', 'Last started', 'Duration', 'Expected within'].map(head => <th key={head} scope="col" className="px-3 py-2 font-semibold">{head}</th>)}</tr></thead>
          <tbody className="divide-y divide-border-default">{data.scheduledTasks.map(task => <tr key={task.task}><th scope="row" className="px-3 py-3 text-left"><span className="block font-medium">{taskLabel(task.task)}</span><span className="mt-1 block break-all font-mono text-xs font-normal text-text-secondary">{task.task}</span></th><td className="px-3 py-3"><Status status={task.status} /></td><td className="px-3 py-3">{task.lastStartedAt ? manilaDateTime(task.lastStartedAt) : 'No run recorded'}</td><td className="px-3 py-3 tabular-nums">{measurement(task.durationMs) === null ? '—' : `${((task.durationMs ?? 0) / 1000).toLocaleString('en-PH', { maximumFractionDigits: 3 })} s`}</td><td className="px-3 py-3 tabular-nums">{task.expectedWithinMinutes >= 1440 ? `${task.expectedWithinMinutes / 60} h` : `${task.expectedWithinMinutes} min`}</td></tr>)}</tbody></table></div>}
      </Panel>
      <TaskCharts tasks={data.scheduledTasks} />
    </div>}
    {view === 'failures' && <>
    <Panel title="Failures" description="Class names and failure categories only. Payment, refund, credential and invitation work is retried by its own reconciliation, never from here.">
      <FilterTabs appearance="tabs" label="Failure kind" value={kind} onChange={value => { setKind(value as 'OUTBOX' | 'JOBS'); setPage(1) }} chips={[{ value: 'OUTBOX', label: 'Dead-lettered deliveries' }, { value: 'JOBS', label: 'Failed jobs' }]} />
      <Toolbar filters={<><DateFilter title="Failure dates" value={range} onChange={value => { setRange(value); setPage(1) }} />{(range.from || range.to) && <Button variant="quiet" onClick={() => { setRange(ALL_DATES); setPage(1) }}>Reset dates</Button>}</>} />
      {failures.error ? <ErrorState message={failures.error} onRetry={failures.retry} /> : !failures.data ? <LoadingState /> : failures.data.items.length === 0 ? <p className="flex items-start gap-2 rounded-control bg-surface-canvas p-4 text-sm text-text-secondary"><CheckCircle2 size={18} className="shrink-0 text-status-success" aria-hidden="true" />Nothing has failed in this category{range.from || range.to ? ' for the selected dates' : ''}.</p>
        : <div className="overflow-x-auto"><table className="w-full min-w-[760px] text-left text-sm"><caption className="sr-only">Failures</caption>
          <thead className="text-[13px] text-text-secondary"><tr>{['Work', 'Queue', 'Failure', 'Attempts', 'Failed', ''].map(head => <th key={head} scope="col" className="px-3 py-2 font-semibold">{head || <span className="sr-only">Action</span>}</th>)}</tr></thead>
          <tbody className="divide-y divide-border-default">{failures.data.items.map(item => <tr key={item.reference}><th scope="row" className="px-3 py-2 text-left font-normal"><span className="font-semibold">{item.label}</span></th><td className="px-3 py-2">{item.queue}</td><td className="px-3 py-2">{item.failure}</td><td className="px-3 py-2 tabular-nums">{item.attempts ?? '—'}</td><td className="px-3 py-2">{manilaDateTime(item.failedAt)}</td>
            <td className="px-3 py-2 text-right">{item.retryable && canRetry ? <Button variant="secondary" className="whitespace-nowrap" onClick={() => setTarget({ type: item.kind, reference: item.reference, label: item.label })}>Retry</Button> : <span className="text-[13px] text-text-secondary">{item.retryNote ?? 'Not retryable here'}</span>}</td></tr>)}</tbody></table></div>}
      {failures.data && <Pager page={page} lastPage={failures.data.lastPage} total={failures.data.total} busy={failures.loading} onChange={setPage} />}
    </Panel>
    <Panel title="Recent retries" description="Every retry records its reason, actor and correlation ID.">
      {retries.error ? <ErrorState message={retries.error} onRetry={retries.retry} /> : !retries.data ? <LoadingState /> : retries.data.length === 0 ? <p className="text-sm text-text-secondary">No retries have been requested.</p>
        : <ul className="divide-y divide-border-default">{retries.data.map(item => <li key={item.correlationId} className="grid gap-1 py-3 text-sm"><p><span className="font-semibold">{item.label}</span> · {humanize(item.outcome)} · {manilaDateTime(item.createdAt)}</p><p className="text-text-secondary">{item.actor} ({item.actorRole}): {item.reason}</p><p className="break-all text-[13px] text-text-secondary">Correlation ID {item.correlationId}</p></li>)}</ul>}
    </Panel>
    </>}
    {target && <RetryPanel target={target} onClose={() => setTarget(null)} onDone={message => { setTarget(null); setDone(message); failures.retry(); retries.retry(); overview.retry() }} />}
    {bulkKind && <BulkOperationRetryPanel kind={bulkKind} onClose={() => setBulkKind(null)} onChanged={() => { failures.retry(); retries.retry(); overview.retry() }} onReview={() => { setKind(bulkKind); setPage(1); setRange(ALL_DATES); setView('failures'); setBulkKind(null) }} />}
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
