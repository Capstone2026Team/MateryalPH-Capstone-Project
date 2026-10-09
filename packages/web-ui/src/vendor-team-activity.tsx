import { useEffect, useRef, useState } from 'react'
import { Activity, CheckCircle2, Clock3, ShieldCheck, TriangleAlert, Users, ArrowUpRight, BarChart3 } from 'lucide-react'
import type { AccountMembership, ListVendorTeamActivityRequest, VendorTeamActivityEnvelope } from '@materyalph/api-client-ts'
import { Button } from './button'
import { StatusMessage } from './status-message'
import { StatusBadge } from './portal-shell'
import { TeamMemberFilters, useTeamMembers, type TeamMemberList } from './vendor-team-members'
import { TeamAvatar, TeamMetric, TeamActivityDistribution, TeamPagination, teamCategoryLabels, teamDate, teamRoleLabel, teamRoles } from './vendor-team-patterns'
import { useAutomaticRefresh } from './use-automatic-refresh'
import { useTeamQuery } from './use-team-query'
import './vendor-team-activity.css'

type ActivityQuery = ListVendorTeamActivityRequest
const readable = (value: string) => value.toLowerCase().replaceAll('_', ' ').replace(/^./, letter => letter.toUpperCase())

export function VendorTeamActivity({ list, listMembers, canManageManagers, explainError, watchUpdates }: {
  list: (query: ActivityQuery) => Promise<VendorTeamActivityEnvelope>
  listMembers: TeamMemberList
  canManageManagers: boolean
  explainError: (error: unknown) => Promise<string>
  watchUpdates: (refresh: () => void, onLive: (live: boolean) => void) => Promise<() => void>
}) {
  const members = useTeamMembers(listMembers, explainError)
  const [selection, setSelected] = useState<AccountMembership | null>(null)
  const [query, setQuery] = useState<ActivityQuery>({ page: 1, days: 30 })
  const [view, setView] = useState<'overview' | 'history' | 'scope'>('overview')
  const { result, error, loading, updatedAt, blocked, refresh, retry } = useTeamQuery(list, query, explainError, 0, Boolean(query.memberId) && !members.blocked)
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
    if (document.visibilityState === 'visible' && navigator.onLine) await Promise.all([refresh(), refreshMembers()])
  }
  useAutomaticRefresh(synchronize, { enabled: updatesEnabled && !loading && !members.loading, intervalMs: error || members.error ? 120_000 : live ? 45_000 : 4_000 })
  useEffect(() => {
    if (!updatesEnabled) return
    let active = true
    let stop: (() => void) | undefined
    let timer: number | undefined
    setLive(false)
    const invalidate = () => {
      if (timer !== undefined) return
      timer = window.setTimeout(() => {
        timer = undefined
        if (active && document.visibilityState === 'visible' && navigator.onLine) void Promise.all([refresh(), refreshMembers()])
      }, 150)
    }
    void watchUpdates(invalidate, value => { if (active) setLive(value) }).then(cleanup => { if (active) stop = cleanup; else cleanup() }).catch(() => { if (active) setLive(false) })
    window.addEventListener('focus', invalidate)
    return () => { active = false; stop?.(); window.clearTimeout(timer); window.removeEventListener('focus', invalidate) }
  }, [updatesEnabled, watchUpdates, refresh, refreshMembers])
  function selectMember(member: AccountMembership) {
    setSelected(member); setQuery(current => ({ days: current.days ?? 30, page: 1, memberId: member.id })); setView('overview')
  }
  const profile = teamRoles.find(role => role.value === selected?.role)
  const title = selected?.name ?? 'Team member activity'
  const categoryCounts = result?.meta.categories ?? []
  const relevantCategories = selected && profile ? categoryCounts.filter(item => (profile.categories as readonly string[]).includes(item.category) || item.count > 0) : categoryCounts
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
        <p className="mt-6 border-t border-border-default pt-4 text-xs leading-5 text-text-secondary">{canManageManagers ? 'Select a team member to view their recorded activity.' : 'Delegated access covers non-manager staff only.'} Inactive members retain their recorded history.</p>
      </aside>
      <section className="team-tracking-panel min-w-0 bg-surface-canvas" aria-label="Selected team activity">
        <header className="flex flex-wrap items-center justify-between gap-3 bg-surface-primary p-4 sm:px-5"><div className="flex min-w-0 items-center gap-3">{selected && <TeamAvatar name={title} />}<div className="min-w-0"><h2 className="break-words text-xl font-semibold">{title}</h2><p className="mt-1 text-sm text-text-secondary">{selected ? teamRoleLabel(selected.role) : 'Recorded activity for individual team accounts'}</p></div></div>{selected && <StatusBadge label={readable(selected.status)} tone={selected.status === 'ACTIVE' ? 'success' : 'neutral'} />}</header>
        {selected && <><div className="mx-4 mb-3 flex items-start gap-2 rounded-control border border-border-default bg-surface-canvas p-3 text-xs leading-5 text-text-secondary sm:mx-5"><Clock3 size={16} className="mt-0.5 shrink-0" aria-hidden="true" /><p>Recorded actions, not hours worked or sales totals. {updatedAt && `Updated ${teamDate(updatedAt)}. `}All times use Asia/Manila.</p></div>
        <nav aria-label="Tracking views" className="flex min-w-0 flex-wrap gap-x-5 border-b border-border-default bg-surface-primary px-4 sm:px-5">{([['overview', 'Statistics'], ['history', 'Activity history'], ['scope', 'Role responsibilities']] as const).map(([key, label]) => <button key={key} type="button" aria-pressed={view === key} onClick={() => { setView(key); if (key === 'overview') setQuery(current => { const next = { ...current, page: 1 }; delete next.category; return next }) }} className={`min-h-12 shrink-0 border-b-2 px-1 text-sm font-medium ${view === key ? 'border-action-primary text-action-primary' : 'border-transparent text-text-secondary'}`}>{label}</button>)}</nav></>}
        <div className="team-tracking-body min-w-0 space-y-4 p-4 sm:p-5" tabIndex={0} role="region" aria-label="Activity content">
          {selected && <div className="grid min-w-0 grid-cols-1 gap-3 sm:flex sm:flex-wrap"><label className="grid min-w-0 gap-2 text-xs font-medium text-text-secondary">Activity period<select className="min-h-11 min-w-0 w-full rounded-control border border-border-default bg-surface-primary px-3 text-sm text-text-strong" value={query.days} onChange={event => setQuery({ ...query, page: 1, days: Number(event.target.value) as NonNullable<ActivityQuery['days']> })}><option value={7}>Last 7 days</option><option value={30}>Last 30 days</option><option value={90}>Last 90 days</option></select></label><label className="grid min-w-0 gap-2 text-xs font-medium text-text-secondary">Role at time of action<select className="min-h-11 min-w-0 w-full max-w-full rounded-control border border-border-default bg-surface-primary px-3 text-sm text-text-strong" value={query.role ?? ''} onChange={event => { const next = { ...query, page: 1 }; if (event.target.value) next.role = event.target.value as NonNullable<ActivityQuery['role']>; else delete next.role; setQuery(next) }}><option value="">All authorized roles</option>{canManageManagers && <option value="OWNER">Vendor Owner</option>}{teamRoles.filter(role => canManageManagers || role.value !== 'STORE_MANAGER').map(role => <option key={role.value} value={role.value}>{role.label}</option>)}</select></label>{view === 'history' && <label className="grid min-w-0 gap-2 text-xs font-medium text-text-secondary">Work area<select className="min-h-11 min-w-0 w-full rounded-control border border-border-default bg-surface-primary px-3 text-sm text-text-strong" value={query.category ?? ''} onChange={event => { const next = { ...query, page: 1 }; if (event.target.value) next.category = event.target.value as NonNullable<ActivityQuery['category']>; else delete next.category; setQuery(next) }}><option value="">All work areas</option>{Object.entries(teamCategoryLabels).map(([key, label]) => <option key={key} value={key}>{label}</option>)}</select></label>}</div>}
          {!selected && !error && <div className="py-12 text-center"><Users size={28} className="mx-auto mb-3 text-text-secondary" aria-hidden="true" /><h3 className="font-semibold">Select a team member</h3><p className="mt-2 text-sm text-text-secondary">Choose a member from Your team to view their statistics, activity history and role responsibilities.</p></div>}
          {error && <div className="space-y-3"><StatusMessage tone="error">{error}</StatusMessage><Button variant="secondary" onClick={() => void retry()}>Retry activity</Button></div>}
          {selected && (loading ? <p role="status" className="py-12 text-center text-sm text-text-secondary">Loading recorded activity…</p> : updatesEnabled && result && <>
            {view === 'overview' && <>
              <div className="grid gap-3 md:grid-cols-3"><TeamMetric label="Recorded actions" value={result.meta.totalEvents} icon={<Activity size={18} aria-hidden="true" />} /><TeamMetric label="Succeeded" value={result.meta.succeededEvents} icon={<CheckCircle2 size={18} aria-hidden="true" />} /><TeamMetric label="Unsuccessful" value={result.meta.failedEvents} icon={<TriangleAlert size={18} aria-hidden="true" />} /></div>
              <div className="grid gap-3 sm:grid-cols-2">{relevantCategories.slice(0, 2).map(item => <TeamMetric key={item.category} label={teamCategoryLabels[item.category] ?? item.category} value={item.count} icon={<BarChart3 size={18} aria-hidden="true" />} />)}</div>
              <TeamActivityDistribution categories={categoryCounts} onSelect={category => { setQuery({ ...query, category: category as NonNullable<ActivityQuery['category']>, page: 1 }); setView('history') }} />
              <p className="text-xs leading-6 text-text-secondary">{profile?.detail ?? 'Select a team member to monitor their role and recorded work.'} Counts cover all matching pages in the selected period.</p>
            </>}
            {view === 'scope' ? <div className="space-y-5"><div className="flex items-center gap-2"><ShieldCheck size={20} aria-hidden="true" /><h3 className="font-semibold">{selected ? 'Current role responsibilities' : 'Fixed staff roles'}</h3></div>{(profile ? [profile] : teamRoles.filter(role => canManageManagers || role.value !== 'STORE_MANAGER')).map(role => <div key={role.value} className="border-l-2 border-border-default pl-4"><h4 className="font-semibold">{role.label}</h4><p className="mt-2 text-sm leading-6 text-text-secondary">{role.detail}</p></div>)}<p className="text-sm leading-6 text-text-secondary">Activity keeps the role held when each action occurred. Current access also depends on active membership, store state, Owner settings and assignment.</p></div> : view === 'history' ? <section><div className="mb-4 flex flex-wrap items-center justify-between gap-3"><h3 className="font-semibold">{`Activity history · ${result.meta.total.toLocaleString('en-PH')} events`}</h3></div>{result.data.length === 0 ? <div className="rounded-control border border-dashed border-border-default px-5 py-10 text-center"><Activity size={24} className="mx-auto mb-3 text-text-secondary" aria-hidden="true" /><p className="font-medium">No recorded activity in this view</p><p className="mt-2 text-sm text-text-secondary">Choose another period, role or work area. An empty history does not indicate inactivity outside the recorded system.</p></div> : <ol className="divide-y divide-border-default">{result.data.map(item => <li key={item.id} className="py-5 first:pt-0"><div className="flex flex-wrap items-start justify-between gap-3"><div className="min-w-0"><p className="break-words text-sm font-semibold">{readable(item.action)}</p><p className="mt-1 text-xs leading-5 text-text-secondary">{item.actorName || 'System'} · {teamRoleLabel(item.actorRole)}</p></div><StatusBadge label={item.succeeded ? 'Succeeded' : 'Unsuccessful'} tone={item.succeeded ? 'success' : 'neutral'} /></div><p className="mt-2 text-xs text-text-secondary">{teamDate(item.createdAt)} · {teamCategoryLabels[item.category]}</p><details className="mt-3 text-xs"><summary className="min-h-6 cursor-pointer py-1 text-action-primary">Record details</summary><dl className="mt-2 grid gap-2 rounded-control bg-surface-canvas p-3"><div><dt className="text-text-secondary">Affected resource</dt><dd className="mt-1 break-all">{readable(item.resourceType)} · {item.resourceId || '—'}</dd></div><div><dt className="text-text-secondary">Correlation reference</dt><dd className="mt-1 break-all">{item.correlationId || 'Not recorded'}</dd></div>{Object.entries(item.after).map(([key, value]) => <div key={key}><dt className="text-text-secondary">{readable(key)}</dt><dd className="mt-1 break-words">{String(item.before[key] ?? '—')} → {String(value)}</dd></div>)}</dl></details></li>)}</ol>}{view === 'history' && <TeamPagination page={query.page ?? 1} lastPage={result.meta.lastPage} busy={loading} onPage={page => setQuery({ ...query, page })} />}</section> : null}
          </>)}
        </div>
      </section>
    </div>
  </div>
}
