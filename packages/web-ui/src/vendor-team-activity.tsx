import { useEffect, useMemo, useRef, useState } from 'react'
import { Activity, ArrowUpRight, Clock3, MessagesSquare, Package, Scale, ShieldCheck, Truck, Users } from 'lucide-react'
import { parseDate, type AccountMembership, type GetVendorTeamPerformanceRequest, type ListVendorTeamActivityRequest, type VendorTeamActivityEnvelope, type VendorTeamPerformanceEnvelope } from '@materyalph/api-client-ts'
import { Button } from './button'
import { StatusMessage } from './status-message'
import { StatusBadge } from './portal-shell'
import { TeamMemberFilters, useTeamMembers, type TeamMemberList } from './vendor-team-members'
import { TeamAvatar, TeamPagination, teamCategoryLabels, teamDate, teamRoleLabel, teamRoles } from './vendor-team-patterns'
import { TeamPerformanceStatistics } from './vendor-team-performance'
import { useAutomaticRefresh } from './use-automatic-refresh'
import { useTeamQuery } from './use-team-query'
import { DateFilter, dateFilterPreset, type DateFilterRange } from './date-filter'
import './vendor-team-activity.css'

type ActivityQuery = ListVendorTeamActivityRequest
type View = 'overview' | 'history' | 'scope'
const readable = (value: string) => value.toLowerCase().replaceAll('_', ' ').replace(/^./, letter => letter.toUpperCase())
const views: [View, string][] = [['overview', 'Statistics'], ['history', 'Activity history'], ['scope', 'Role responsibilities']]
const categoryIcons: Record<string, typeof Activity> = { SALES: MessagesSquare, INVENTORY: Package, FULFILLMENT: Truck, DISPUTES: Scale, TEAM: Users, OTHER: Activity }
const roleAreas: Record<string, string[]> = {
  OWNER: ['Sales and conversations', 'Quotations', 'Order confirmations', 'Disputes', 'Products and inventory', 'Fulfillment'],
  STORE_MANAGER: ['Sales and conversations', 'Quotations', 'Order confirmations', 'Disputes', 'Products and inventory', 'Fulfillment'],
  STORE_STAFF: ['Sales and conversations', 'Quotations', 'Order confirmations', 'Disputes', 'Products and inventory'],
  CUSTOMER_SERVICE: ['Sales and conversations', 'Quotation drafts', 'Order confirmations', 'Disputes'],
  INVENTORY: ['Products and inventory'],
  FULFILLMENT: ['Fulfillment'],
}

function dateBounds(range: DateFilterRange) {
  return { ...(range.from ? { from: parseDate(range.from) } : {}), ...(range.to ? { to: parseDate(range.to) } : {}) }
}

export function VendorTeamActivity({ list, performance, listMembers, canManageManagers, explainError, watchUpdates }: {
  list: (query: ActivityQuery) => Promise<VendorTeamActivityEnvelope>
  performance: (query: GetVendorTeamPerformanceRequest) => Promise<VendorTeamPerformanceEnvelope>
  listMembers: TeamMemberList
  canManageManagers: boolean
  explainError: (error: unknown) => Promise<string>
  watchUpdates: (refresh: () => void, onLive: (live: boolean) => void) => Promise<() => void>
}) {
  const members = useTeamMembers(listMembers, explainError)
  const [selection, setSelected] = useState<AccountMembership | null>(null)
  const [range, setRange] = useState<DateFilterRange>(() => dateFilterPreset(30))
  const [page, setPage] = useState(1)
  const [view, setView] = useState<View>('overview')
  const memberId = selection?.id
  const historyQuery = useMemo<ActivityQuery>(() => ({ page, ...(memberId ? { memberId } : {}), ...dateBounds(range) }), [page, memberId, range])
  const statisticsQuery = useMemo<GetVendorTeamPerformanceRequest>(() => ({ memberId: memberId ?? '', ...dateBounds(range) }), [memberId, range])
  const history = useTeamQuery(list, historyQuery, explainError, 0, Boolean(memberId) && view === 'history' && !members.blocked)
  const statistics = useTeamQuery(performance, statisticsQuery, explainError, 0, Boolean(memberId) && view === 'overview' && !members.blocked)
  const blocked = history.blocked || statistics.blocked
  const active = view === 'history' ? history : statistics
  const visibleMembers = blocked || members.blocked ? null : members.result
  const memberListRef = useRef<HTMLDivElement>(null)
  const [memberCapacity, setMemberCapacity] = useState(20)
  const [memberChunk, setMemberChunk] = useState(0)
  const memberChunks = Math.max(1, Math.ceil((visibleMembers?.data.length ?? 0) / memberCapacity))
  const currentMemberChunk = memberChunk < 0 ? memberChunks - 1 : Math.min(memberChunk, memberChunks - 1)
  const shownMembers = visibleMembers?.data.slice(currentMemberChunk * memberCapacity, (currentMemberChunk + 1) * memberCapacity) ?? []
  const memberPage = members.query.page ?? 1
  const lastMemberPage = Number(visibleMembers?.meta.last_page ?? 1)
  const selected = blocked || members.blocked ? null : visibleMembers?.data.find(member => member.id === selection?.id) ?? selection
  const [live, setLive] = useState(false)
  const updatesEnabled = !blocked && !members.blocked
  const refreshMembers = members.refresh
  const refreshHistory = history.refresh
  const refreshStatistics = statistics.refresh
  useEffect(() => {
    const container = memberListRef.current
    if (!container) return
    const desktop = window.matchMedia('(min-width: 1024px) and (min-height: 720px)')
    const fitMembers = () => {
      if (!desktop.matches) { setMemberCapacity(20); return }
      const rows = [...container.querySelectorAll('li')]
      const rowHeight = Math.max(96, ...rows.map(row => row.getBoundingClientRect().height))
      const list = container.querySelector('ul')
      const listTop = list ? list.getBoundingClientRect().top - container.getBoundingClientRect().top : 12
      setMemberCapacity(Math.max(1, Math.min(20, Math.floor((container.clientHeight - listTop + 8) / (rowHeight + 8)))))
    }
    const observer = new ResizeObserver(fitMembers)
    observer.observe(container)
    desktop.addEventListener('change', fitMembers)
    fitMembers()
    return () => { observer.disconnect(); desktop.removeEventListener('change', fitMembers) }
  }, [visibleMembers, members.loading, members.error])
  const synchronize = async () => {
    if (document.visibilityState === 'visible' && navigator.onLine) await Promise.all([refreshHistory(), refreshStatistics(), refreshMembers()])
  }
  useAutomaticRefresh(synchronize, { enabled: updatesEnabled && !active.loading && !members.loading, intervalMs: active.error || members.error ? 120_000 : live ? 45_000 : 4_000 })
  useEffect(() => {
    if (!updatesEnabled) return
    let current = true
    let stop: (() => void) | undefined
    let timer: number | undefined
    setLive(false)
    const invalidate = () => {
      if (timer !== undefined) return
      timer = window.setTimeout(() => {
        timer = undefined
        if (current && document.visibilityState === 'visible' && navigator.onLine) void Promise.all([refreshHistory(), refreshStatistics(), refreshMembers()])
      }, 150)
    }
    void watchUpdates(invalidate, value => { if (current) setLive(value) }).then(cleanup => { if (current) stop = cleanup; else cleanup() }).catch(() => { if (current) setLive(false) })
    window.addEventListener('focus', invalidate)
    return () => { current = false; stop?.(); window.clearTimeout(timer); window.removeEventListener('focus', invalidate) }
  }, [updatesEnabled, watchUpdates, refreshHistory, refreshStatistics, refreshMembers])
  function selectMember(member: AccountMembership) {
    setSelected(member); setPage(1); setView('overview')
  }
  const profile = teamRoles.find(role => role.value === selected?.role)
  const title = selected?.name ?? 'Team member activity'
  const roleLabel = selected ? teamRoleLabel(selected.role) : ''
  return <div className="team-tracking-workspace min-w-0 w-full">
    <h1 className="sr-only">Team Tracking</h1>
    <div className="team-tracking-layout grid min-w-0 grid-cols-1 bg-surface-primary lg:grid-cols-[256px_minmax(0,1fr)]">
      <aside aria-label="Select a team member" className="team-tracking-sidebar min-w-0 border-b border-border-default bg-surface-primary p-4 lg:border-b-0 lg:border-r">
        <div className="mb-4 flex items-center gap-2"><Users size={18} aria-hidden="true" /><h2 className="font-semibold">Your team</h2></div>
        <TeamMemberFilters compact query={members.query} canManageManagers={canManageManagers} onChange={value => { setMemberChunk(0); members.setQuery(value) }} />
        <div ref={memberListRef} className="team-tracking-members">
        {members.error && <div className="mt-4 space-y-3"><StatusMessage tone="error">{members.error}</StatusMessage><Button variant="secondary" onClick={() => void members.retry()}>Retry team list</Button></div>}{members.loading ? <p className="py-5 text-sm" role="status">Loading team…</p> : <ul className="mt-3 space-y-2">{shownMembers.map(member => <li key={member.id}><button type="button" aria-pressed={selected?.id === member.id} onClick={() => selectMember(member)} className={`flex min-h-24 w-full items-start gap-3 rounded-control border p-3 text-left ${selected?.id === member.id ? 'border-action-primary bg-surface-primary' : 'border-border-default hover:bg-surface-primary'}`}><TeamAvatar name={member.name} /><span className="min-w-0"><span className="block break-words text-sm font-semibold">{member.name}</span><span className="mt-1 block text-xs leading-5 text-text-secondary">{teamRoleLabel(member.role)}</span><span className="mt-1 block text-xs text-text-secondary">{readable(member.status)}</span></span></button></li>)}</ul>}
        {!members.loading && !members.error && !visibleMembers?.data.length && <p className="py-5 text-sm leading-6 text-text-secondary">No team members match this view. Accepted invitations appear here.</p>}
        </div>
        {visibleMembers && (memberChunks > 1 || lastMemberPage > 1) && <div className="team-tracking-member-pages mt-5 flex items-center justify-between gap-1 text-xs"><Button variant="quiet" disabled={members.loading || (memberPage === 1 && currentMemberChunk === 0)} onClick={() => { if (currentMemberChunk > 0) setMemberChunk(currentMemberChunk - 1); else { setMemberChunk(-1); members.setQuery({ ...members.query, page: memberPage - 1 }) } }}>Previous</Button><span className="tabular-nums">{(memberPage - 1) * 20 + currentMemberChunk * memberCapacity + 1}–{(memberPage - 1) * 20 + currentMemberChunk * memberCapacity + shownMembers.length}</span><Button variant="quiet" disabled={members.loading || (memberPage === lastMemberPage && currentMemberChunk === memberChunks - 1)} onClick={() => { if (currentMemberChunk < memberChunks - 1) setMemberChunk(currentMemberChunk + 1); else { setMemberChunk(0); members.setQuery({ ...members.query, page: memberPage + 1 }) } }}>Next</Button></div>}
        <a href="/team" className="mt-4 inline-flex min-h-11 w-full items-center justify-center gap-2 rounded-full bg-action-primary px-4 text-sm font-semibold text-white">Manage accounts<ArrowUpRight size={16} aria-hidden="true" /></a>
        <p className="mt-6 border-t border-border-default pt-4 text-xs leading-5 text-text-secondary">{canManageManagers ? 'Select a team member to view their statistics and recorded activity.' : 'Delegated access covers non-manager staff only.'} Inactive members retain their recorded history.</p>
      </aside>
      <section className="team-tracking-panel min-w-0 bg-surface-canvas" aria-label="Selected team member">
        <header className="flex flex-wrap items-center justify-between gap-3 border-b border-border-default bg-surface-primary px-4 py-4 sm:px-6">
          <div className="flex min-w-0 items-center gap-3">{selected && <TeamAvatar name={title} />}<div className="min-w-0"><h2 className="break-words text-xl font-semibold">{title}</h2><p className="mt-0.5 text-sm text-text-secondary">{selected ? roleLabel : 'Statistics, activity history and role responsibilities for individual team accounts'}</p></div></div>
          {selected && <StatusBadge label={readable(selected.status)} tone={selected.status === 'ACTIVE' ? 'success' : 'neutral'} />}
        </header>
        {selected && <nav aria-label="Tracking views" className="flex min-w-0 flex-wrap gap-x-6 border-b border-border-default bg-surface-primary px-4 sm:px-6">{views.map(([key, label]) => <button key={key} type="button" aria-pressed={view === key} onClick={() => { setView(key); setPage(1) }} className={`min-h-12 shrink-0 border-b-2 text-sm font-semibold ${view === key ? 'border-action-primary text-action-primary' : 'border-transparent text-text-secondary hover:text-text-strong'}`}>{label}</button>)}</nav>}
        <div className="team-tracking-body min-w-0 space-y-5 p-4 sm:p-6" tabIndex={0} role="region" aria-label="Team member details">
          {!selected && <div className="py-16 text-center"><Users size={28} className="mx-auto mb-3 text-text-secondary" aria-hidden="true" /><h3 className="font-semibold">Select a team member</h3><p className="mt-2 text-sm text-text-secondary">Choose a member from Your team to view their statistics, activity history and role responsibilities.</p></div>}
          {selected && view !== 'scope' && <div className="flex flex-wrap items-end justify-between gap-3">
            <div className="min-w-0"><h3 className="text-base font-semibold text-text-strong">{view === 'overview' ? `${roleLabel} statistics` : 'Activity history'}</h3>
              <p className="mt-1 flex flex-wrap items-center gap-1.5 text-xs text-text-secondary"><Clock3 size={14} aria-hidden="true" />{active.updatedAt ? `Updated ${teamDate(active.updatedAt)}` : 'Loading'} · Asia/Manila time</p></div>
            <DateFilter title="Tracking period" value={range} disabled={active.loading} onChange={next => { setRange(next); setPage(1) }} />
          </div>}
          {selected && view !== 'scope' && active.error && <div className="space-y-3"><StatusMessage tone="error">{active.error}</StatusMessage><Button variant="secondary" onClick={() => void active.retry()}>Try again</Button></div>}
          {selected && view === 'overview' && (statistics.loading && !statistics.result ? <p role="status" className="py-16 text-center text-sm text-text-secondary">Loading statistics…</p>
            : updatesEnabled && statistics.result && <TeamPerformanceStatistics data={statistics.result.data} />)}
          {selected && view === 'history' && (history.loading && !history.result ? <p role="status" className="py-16 text-center text-sm text-text-secondary">Loading recorded activity…</p>
            : updatesEnabled && history.result && <section aria-label="Activity history" className="rounded-surface border border-border-default bg-surface-primary">
              <header className="flex flex-wrap items-center justify-between gap-2 border-b border-border-default px-5 py-3.5"><p className="text-sm font-semibold text-text-strong">{history.result.meta.total.toLocaleString('en-PH')} {history.result.meta.total === 1 ? 'record' : 'records'}</p><p className="text-xs text-text-secondary">Newest first</p></header>
              {history.result.data.length === 0 ? <div className="px-5 py-12 text-center"><Activity size={24} className="mx-auto mb-3 text-text-secondary" aria-hidden="true" /><p className="font-medium">No recorded activity in this period</p><p className="mt-2 text-sm text-text-secondary">Choose a longer period. An empty history does not indicate inactivity outside the recorded system.</p></div>
                : <ol className="divide-y divide-border-default">{history.result.data.map(item => {
                  const Icon = categoryIcons[item.category] ?? Activity
                  const otherRole = item.actorRole && item.actorRole !== selected.role
                  return <li key={item.id} className="flex items-start gap-3 px-5 py-4">
                    <span aria-hidden="true" className="mt-0.5 grid h-9 w-9 shrink-0 place-items-center rounded-full bg-brand-orange-50 text-action-primary"><Icon size={16} /></span>
                    <div className="min-w-0 flex-1">
                      <div className="flex flex-wrap items-start justify-between gap-2"><p className="break-words text-sm font-semibold text-text-strong">{readable(item.action)}</p>{!item.succeeded && <StatusBadge label="Unsuccessful" tone="warning" />}</div>
                      <p className="mt-1 text-xs leading-5 text-text-secondary">{teamDate(item.createdAt)} · {teamCategoryLabels[item.category] ?? 'Other activity'}{otherRole ? ` · as ${teamRoleLabel(item.actorRole)}` : ''}</p>
                      <details className="mt-2 text-xs"><summary className="inline-flex min-h-6 cursor-pointer items-center py-1 font-medium text-action-primary">Record details</summary><dl className="mt-2 grid gap-2 rounded-control bg-surface-canvas p-3 sm:grid-cols-2">
                        <div><dt className="text-text-secondary">Result</dt><dd className="mt-1">{item.succeeded ? 'Succeeded' : 'Unsuccessful'}</dd></div>
                        <div><dt className="text-text-secondary">Role at the time</dt><dd className="mt-1">{teamRoleLabel(item.actorRole)}</dd></div>
                        <div><dt className="text-text-secondary">Affected resource</dt><dd className="mt-1 break-all">{readable(item.resourceType)} · {item.resourceId || '—'}</dd></div>
                        <div><dt className="text-text-secondary">Correlation reference</dt><dd className="mt-1 break-all">{item.correlationId || 'Not recorded'}</dd></div>
                        {Object.entries(item.after).map(([key, value]) => <div key={key}><dt className="text-text-secondary">{readable(key)}</dt><dd className="mt-1 break-words">{String(item.before[key] ?? '—')} → {String(value)}</dd></div>)}
                      </dl></details>
                    </div>
                  </li>
                })}</ol>}
              <div className="px-5 pb-4"><TeamPagination page={page} lastPage={history.result.meta.lastPage} busy={history.loading} onPage={setPage} /></div>
            </section>)}
          {selected && view === 'scope' && <section aria-label="Role responsibilities" className="rounded-surface border border-border-default bg-surface-primary p-5 sm:p-6">
            <div className="flex items-start gap-4"><span aria-hidden="true" className="grid h-11 w-11 shrink-0 place-items-center rounded-full bg-brand-orange-50 text-action-primary"><ShieldCheck size={20} /></span>
              <div className="min-w-0"><h3 className="text-base font-semibold text-text-strong">{roleLabel}</h3><p className="mt-2 max-w-3xl text-sm leading-6 text-text-secondary">{profile?.detail ?? 'Holds full store authority, including team management and Owner-only finances.'}</p></div></div>
            <div className="mt-6 border-t border-border-default pt-5"><h4 className="text-xs font-semibold uppercase tracking-[0.08em] text-text-secondary">Measured in Statistics</h4>
              <ul className="mt-3 flex flex-wrap gap-2">{(roleAreas[selected.role] ?? []).map(area => <li key={area} className="inline-flex min-h-8 items-center rounded-pill border border-border-default bg-surface-canvas px-3 text-xs font-medium text-text-strong">{area}</li>)}</ul></div>
            <p className="mt-6 text-sm leading-6 text-text-secondary">Statistics follow this member&apos;s current role. Activity history keeps the role held when each action occurred. Current access also depends on active membership, store state, Owner settings and assignment.</p>
          </section>}
        </div>
      </section>
    </div>
  </div>
}
