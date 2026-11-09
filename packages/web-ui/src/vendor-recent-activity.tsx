import { AsyncLoading } from './async-state'
import { Activity } from 'lucide-react'
import type { ReactNode } from 'react'
import type { ListVendorTeamActivityRequest, VendorTeamActivityEnvelope } from '@materyalph/api-client-ts'
import { Button } from './button'
import { DashboardPanel } from './dashboard-patterns'
import { StatusMessage } from './status-message'
import { DashboardActivityList } from './dashboard-lists'
import { teamDate, teamRoleLabel } from './vendor-team-patterns'
import { useAutomaticRefresh } from './use-automatic-refresh'
import { useTeamQuery } from './use-team-query'

const latestPage: ListVendorTeamActivityRequest = { page: 1 }
const PREVIEW_LIMIT = 5
const readable = (value: string) => value.toLowerCase().replaceAll('_', ' ').replace(/^./, letter => letter.toUpperCase())

/** A bounded dashboard preview of the existing, server-authorized store history. */
export function VendorRecentActivity({ list, explainError, action }: {
  list: (query: ListVendorTeamActivityRequest) => Promise<VendorTeamActivityEnvelope>
  explainError: (error: unknown) => Promise<string>
  action?: ReactNode
}) {
  const activity = useTeamQuery(list, latestPage, explainError)
  useAutomaticRefresh(activity.refresh, { enabled: !activity.loading && !activity.blocked, intervalMs: activity.error ? 120_000 : 60_000 })
  const items = activity.result?.data.slice(0, PREVIEW_LIMIT) ?? []
  return <DashboardPanel density="compact" title="Recent activity" action={action ?? (items.length > 0 ? <span className="text-xs text-text-secondary">Latest {items.length}</span> : undefined)}>
    {activity.error && <div className="mb-3 grid gap-2">
      <StatusMessage tone="error">{activity.error}{activity.result && ' Showing the last successful update.'}</StatusMessage>
      <Button variant="secondary" className="justify-self-start" onClick={() => void activity.retry()}>Retry activity</Button>
    </div>}
    {activity.loading && !activity.result && !activity.error && <AsyncLoading compact label="Loading recent activity…" />}
    {activity.blocked && !activity.error && <p role="status" className="text-xs leading-5 text-text-secondary">Recent activity is unavailable for this session.</p>}
    {activity.result && (items.length === 0
      ? <div className="flex items-start gap-3 py-1"><Activity size={18} aria-hidden="true" className="mt-0.5 shrink-0 text-text-secondary" /><p className="text-xs leading-5 text-text-secondary">No activity recorded yet. Store updates will appear here.</p></div>
      : <DashboardActivityList label="Recent store activity" items={items.map(item => {
        const status: unknown = item.after.milestone ?? item.after.status
        return { key: item.id, title: readable(item.action), eventType: item.action, resourceType: item.resourceType, detail: <>{item.actorName?.trim() || teamRoleLabel(item.actorRole)}{item.succeeded && typeof status === 'string' && <> · <span className="mp-activity-highlight">{readable(status)}</span></>}</>, unsuccessful: !item.succeeded, at: item.createdAt, timeLabel: teamDate(item.createdAt) }
      })} />)}
  </DashboardPanel>
}
