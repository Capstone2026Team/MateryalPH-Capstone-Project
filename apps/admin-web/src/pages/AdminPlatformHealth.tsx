import { AsyncLoading } from '@materyalph/web-ui'
import { ResponseError, type IntegrationOverview } from '@materyalph/api-client-ts'
import { ArrowRight } from 'lucide-react'
import { Link } from 'react-router-dom'
import { Button, DashboardPanel, HealthBadge, ShareBar, formatManilaDateTime, useAutomaticRefresh, usePortalResource, type ShareSegment } from '@materyalph/web-ui'
import { integrationOverview } from '../lib/operations-api'

const loadHealth = () => integrationOverview({ localForbidden: true })
const statuses: Record<string, { label: string; state: string; colorVar: ShareSegment['colorVar'] }> = {
  HEALTHY: { label: 'Healthy', state: 'HEALTHY', colorVar: '--mp-viz-success' },
  DEGRADED: { label: 'Degraded', state: 'DEGRADED', colorVar: '--mp-viz-warning' },
  NOT_CONFIGURED: { label: 'Not configured', state: 'NOT_CONFIGURED', colorVar: '--mp-viz-series-2' },
  SIMULATED: { label: 'Simulated', state: 'IDLE', colorVar: '--mp-viz-series-5' },
}

/** Monitoring is separately authorized from marketplace analytics and finance. */
export function AdminPlatformHealth() {
  const { data, error, pending, refresh } = usePortalResource('admin-dashboard-platform-health', loadHealth)
  const denied = error instanceof ResponseError && error.response.status === 403
  useAutomaticRefresh(refresh, { enabled: !pending && !denied, intervalMs: error ? 120_000 : 60_000 })
  return <DashboardPanel density="compact" title="Platform health" description="Latest reported status of API services and integrations." calculation={<>
    <p>Each service uses its latest server-reported configuration and recorded operational events. The graph counts services by reported status; it is a snapshot, not uptime or a live connectivity test.</p>
    <p>Healthy does not guarantee provider availability. Simulated services use a test adapter, and unconfigured services remain visibly separate. This snapshot is independent of the marketplace date filter.</p>
  </>} footer={data && !denied ? <div className="flex flex-wrap items-center justify-between gap-2 text-xs text-text-secondary"><span>Checked {formatManilaDateTime(data.generatedAt)}</span><Link to="/integrations" className="inline-flex min-h-11 items-center gap-1 font-medium text-action-primary">Service details<ArrowRight size={14} aria-hidden="true" /></Link></div> : undefined}>
    {denied ? <p className="text-sm text-text-secondary">Platform health is outside your role scope. Integration monitoring access is required.</p>
      : !data && !error ? <AsyncLoading compact label="Loading platform health…" />
        : <div className="grid gap-4">
          {Boolean(error) && <div className="grid justify-items-start gap-2"><p role="alert" className="text-sm text-text-secondary">Platform health could not be updated.{data ? ' Showing the last successful snapshot.' : ''}</p><Button variant="secondary" onClick={() => void refresh()}>Retry platform health</Button></div>}
          {data && <PlatformHealthSnapshot data={data} />}
        </div>}
  </DashboardPanel>
}

export function PlatformHealthSnapshot({ data }: { data: IntegrationOverview }) {
  const segments = Object.entries(statuses).map(([key, status]) => ({ key, label: status.label, colorVar: status.colorVar, value: data.integrations.filter(item => item.status === key).length }))
  return <>
    <ShareBar label="API services by reported status" segments={segments} empty="No monitored services have been reported." />
    <ul aria-label="API services and integrations" className="divide-y divide-border-default">{data.integrations.map(service => {
      const status = statuses[service.status] ?? { label: 'Unknown', state: 'UNKNOWN' }
      return <li key={service.key} className="flex flex-wrap items-center justify-between gap-x-3 gap-y-1 py-2 text-xs">
        <div className="min-w-0 flex-1"><p className="font-semibold text-text-strong">{service.label}</p>{service.environment && <p className="mt-0.5 text-text-secondary">{service.environment}</p>}</div>
        <HealthBadge state={status.state} label={status.label} />
      </li>
    })}</ul>
  </>
}
