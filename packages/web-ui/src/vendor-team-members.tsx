import { useId, useState, type FormEvent } from 'react'
import { Pencil, Search, ShieldCheck, Users, RefreshCw, UserRoundX, Pause, Play, Lightbulb, Trash2 } from 'lucide-react'
import type { AccountMembership, AccountMembershipListEnvelope, ListAccountMembershipsRequest, VendorStaffUpdate } from '@materyalph/api-client-ts'
import { Button } from './button'
import { Field } from './field'
import type { RequestAccountVerification } from './account-verification-dialog'
import { FormDialog } from './form-dialog'
import { StatusBadge } from './portal-shell'
import { StatusMessage } from './status-message'
import { TeamAvatar, TeamPagination, teamRoles, teamRoleLabel } from './vendor-team-patterns'
import { useTeamQuery } from './use-team-query'

export type TeamMemberQuery = Pick<ListAccountMembershipsRequest, 'page' | 'search' | 'role'>
export type TeamMemberList = (query: TeamMemberQuery) => Promise<AccountMembershipListEnvelope>

export function useTeamMembers(list: TeamMemberList, explainError: (error: unknown) => Promise<string>) {
  const [query, setQuery] = useState<TeamMemberQuery>({ page: 1 })
  const state = useTeamQuery(list, query, explainError, query.search ? 250 : 0)
  return { query, setQuery, ...state }
}

export function TeamMemberFilters({ query, onChange, canManageManagers, compact = false }: { compact?: boolean; query: TeamMemberQuery; onChange: (query: TeamMemberQuery) => void; canManageManagers: boolean }) {
  return <div className={`grid min-w-0 w-full grid-cols-1 gap-3 ${compact ? '' : 'sm:grid-cols-2'}`}><label className="grid min-w-0 grid-cols-1 gap-2 text-xs font-medium text-text-secondary">Find a team member<span className="flex min-h-11 min-w-0 w-full items-center gap-2 rounded-control border border-border-default bg-surface-primary px-3"><Search size={16} className="shrink-0" aria-hidden="true" /><input type="search" maxLength={160} placeholder="Search by name" className="min-w-0 w-full flex-1 bg-transparent py-2 text-sm text-text-strong" value={query.search ?? ''} onChange={event => { const next = { ...query, page: 1 }; if (event.target.value) next.search = event.target.value; else delete next.search; onChange(next) }} /></span></label><label className="grid min-w-0 grid-cols-1 gap-2 text-xs font-medium text-text-secondary">Current role<select className="min-h-11 min-w-0 w-full max-w-full rounded-control border border-border-default bg-surface-primary px-3 text-sm text-text-strong" value={query.role ?? ''} onChange={event => { const next = { ...query, page: 1 }; if (event.target.value) next.role = event.target.value as NonNullable<TeamMemberQuery['role']>; else delete next.role; onChange(next) }}><option value="">All staff roles</option>{teamRoles.filter(role => canManageManagers || role.value !== 'STORE_MANAGER').map(role => <option key={role.value} value={role.value}>{role.label}</option>)}</select></label></div>
}

type MemberAction = { member: AccountMembership; kind: 'edit' | 'status' | 'delegation' | 'delete'; status?: 'ACTIVE' | 'SUSPENDED' | 'DEACTIVATED' }

export function VendorTeamMembers({ list, explainError, canManageManagers, update, changeStatus, changeDelegation, verifyChange, deleteAccount }: {
  deleteAccount?: ((id: string, lockVersion: number) => Promise<unknown>) | undefined
  verifyChange: RequestAccountVerification
  list: TeamMemberList; explainError: (error: unknown) => Promise<string>; canManageManagers: boolean
  update: (id: string, input: VendorStaffUpdate) => Promise<unknown>
  changeStatus: (id: string, status: 'ACTIVE' | 'SUSPENDED' | 'DEACTIVATED') => Promise<unknown>
  changeDelegation: (id: string, enabled: boolean) => Promise<unknown>
}) {
  const members = useTeamMembers(list, explainError)
  const [action, setAction] = useState<MemberAction | null>(null)
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<{ tone: 'error' | 'success'; text: string } | null>(null)
  const formId = useId()
  function selectAction(value: MemberAction) { setMessage(null); setAction(value) }
  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    if (!action || busy) return
    const data = new FormData(event.currentTarget)
    setBusy(true); setMessage(null)
    try {
      const change = action.kind === 'delete' ? 'account deletion' : action.kind === 'edit' ? 'account details change' : action.kind === 'delegation' ? 'staff delegation change' : `${action.status?.toLowerCase()} membership change`
      if (!await verifyChange(`Authenticate ${change} for ${action.member.name}`)) return
      if (action.kind === 'edit') await update(action.member.id, { fullName: String(data.get('name')).trim(), role: String(data.get('role')) as VendorStaffUpdate['role'], lockVersion: action.member.lockVersion ?? 1 })
      if (action.kind === 'status' && action.status) await changeStatus(action.member.id, action.status)
      if (action.kind === 'delegation') await changeDelegation(action.member.id, !action.member.canManageStaff)
      if (action.kind === 'delete' && deleteAccount) await deleteAccount(action.member.id, action.member.lockVersion ?? 1)
      setAction(null); setMessage({ tone: 'success', text: action.kind === 'delete' ? 'Team account deleted. Historical work and attribution are preserved.' : 'Team account updated. The change is recorded in the audit history.' })
      if (action.kind === 'delete' && members.result?.data.length === 1 && (members.query.page ?? 1) > 1) members.setQuery({ ...members.query, page: (members.query.page ?? 1) - 1 }); else members.refresh()
    } catch (cause) { setMessage({ tone: 'error', text: await explainError(cause) }) }
    finally { setBusy(false) }
  }
  return <section className="space-y-5" aria-label="Team members">
    <div className="flex flex-col gap-3 sm:flex-row sm:items-end"><div className="min-w-0 flex-1"><TeamMemberFilters query={members.query} onChange={members.setQuery} canManageManagers={canManageManagers} /></div><Button variant="secondary" disabled={members.loading} onClick={() => void members.retry()}><RefreshCw size={16} aria-hidden="true" />Refresh accounts</Button></div>
    {!action && message && <StatusMessage tone={message.tone}>{message.text}</StatusMessage>}
    {members.error ? <div className="space-y-3"><StatusMessage tone="error">{members.error}</StatusMessage><Button variant="secondary" onClick={() => void members.retry()}>Retry accounts</Button></div> : members.loading ? <p className="py-8 text-sm text-text-secondary" role="status">Loading team accounts…</p> : !members.result?.data.length ? <div className="rounded-surface border border-dashed border-border-default p-8 text-center"><Users className="mx-auto mb-3 text-text-secondary" size={26} aria-hidden="true" /><h3 className="font-semibold">{members.query.search || members.query.role ? 'No matching team members' : 'Your team starts here'}</h3><p className="mt-2 text-sm text-text-secondary">{members.query.search || members.query.role ? 'Try a different name or role.' : 'Add a new account to invite your first employee. Accepted invitations appear here.'}</p></div> : <ul className="space-y-3">{members.result.data.map(member => <li key={member.id} className="flex min-h-28 flex-col gap-5 rounded-surface border border-border-default bg-surface-primary px-5 py-6 lg:flex-row lg:items-center">
      <div className="flex min-w-0 flex-1 items-center gap-4"><TeamAvatar name={member.name} /><div className="min-w-0"><h3 className="break-words font-semibold">{member.name}</h3><p className="mt-1 text-sm text-text-secondary">{teamRoleLabel(member.role)}</p>{member.role === 'STORE_MANAGER' && <p className="mt-2 flex items-center gap-1 text-xs text-text-secondary"><ShieldCheck size={14} aria-hidden="true" />Staff management {member.canManageStaff ? 'enabled' : 'off'}</p>}</div></div>
      <div className="flex flex-wrap gap-2"><Button variant="quiet" onClick={() => selectAction({ member, kind: 'edit' })} aria-label={`Edit ${member.name}`}><Pencil size={15} aria-hidden="true" />Edit account</Button><Button variant="secondary" onClick={() => selectAction({ member, kind: 'status', status: member.status === 'ACTIVE' ? 'SUSPENDED' : 'ACTIVE' })}>{member.status === 'ACTIVE' ? <Pause size={14} aria-hidden="true" /> : <Play size={14} aria-hidden="true" />}{member.status === 'ACTIVE' ? 'Suspend account' : 'Reactivate'}</Button>{member.status !== 'DEACTIVATED' && <Button variant="danger" className="rounded-full" onClick={() => selectAction({ member, kind: 'status', status: 'DEACTIVATED' })}><UserRoundX size={15} aria-hidden="true" />Deactivate</Button>}{deleteAccount && canManageManagers && member.status === 'DEACTIVATED' && <Button variant="danger" onClick={() => selectAction({ member, kind: 'delete' })} aria-label={`Delete account for ${member.name}`}><Trash2 size={15} aria-hidden="true" />Delete account</Button>}{canManageManagers && member.role === 'STORE_MANAGER' && <Button variant="quiet" onClick={() => selectAction({ member, kind: 'delegation' })}>{member.canManageStaff ? 'Revoke delegation' : 'Delegate staff access'}</Button>}</div><div className="flex min-w-24 flex-col items-start gap-2 lg:items-end"><StatusBadge label={member.status.toLowerCase()} tone={member.status === 'ACTIVE' ? 'success' : 'neutral'} /><span className="text-xs text-text-secondary">Store member</span></div>
    </li>)}</ul>}
    {members.result && <TeamPagination page={members.query.page ?? 1} lastPage={Number(members.result.meta.last_page ?? 1)} busy={members.loading} onPage={page => members.setQuery({ ...members.query, page })} />}
    <div className="flex items-start gap-3 rounded-control border border-border-default bg-brand-orange-50 p-4"><Lightbulb size={18} className="mt-0.5 shrink-0 text-action-primary" aria-hidden="true" /><div><p className="text-sm font-semibold">One account for every team member</p><p className="mt-1 text-xs leading-5 text-text-secondary">Use Team Tracking to monitor recorded work. Suspending or deactivating access preserves the employee’s history.</p></div></div>

    <FormDialog open={!!action} title={action?.kind === 'delete' ? 'Delete team account' : action?.kind === 'edit' ? 'Edit team account' : 'Change team access'} description={action ? `${action.member.name} · ${teamRoleLabel(action.member.role)}` : ''} busy={busy} onClose={() => setAction(null)} footer={<div className="flex justify-end gap-3"><Button variant="secondary" disabled={busy} onClick={() => setAction(null)}>Cancel</Button><Button type="submit" form={formId} variant={action?.kind === 'delete' ? 'danger' : 'primary'} disabled={busy}>{busy ? 'Saving…' : action?.kind === 'delete' ? 'Delete account' : 'Confirm change'}</Button></div>}>
      {action && <form key={`${action.member.id}-${action.kind}`} id={formId} onSubmit={event => void submit(event)} className="space-y-5">
        {message?.tone === 'error' && <StatusMessage tone="error">{message.text}</StatusMessage>}
        {action.kind === 'edit' ? <><Field label="Employee full name" name="name" defaultValue={action.member.name} required maxLength={160} /><label className="grid gap-2 text-sm font-medium">Fixed role<select name="role" defaultValue={action.member.role} className="min-h-11 rounded-control border border-border-default bg-surface-primary px-3">{teamRoles.filter(role => canManageManagers || role.value !== 'STORE_MANAGER').map(role => <option key={role.value} value={role.value}>{role.label}</option>)}</select></label><p className="text-sm text-text-secondary">Changing a role signs out the employee. Previous actions retain their original role attribution.</p></> : <p className="text-sm leading-7">{action.kind === 'delete' ? 'Delete this deactivated account from your team? It cannot be reactivated. A new invitation is required to rejoin. Historical work and attribution will be preserved.' : action.kind === 'delegation' ? action.member.canManageStaff ? 'Revoke this Manager’s permission to manage non-manager staff accounts?' : 'Allow this Manager to manage non-manager staff accounts? They cannot manage other Managers or change protected Owner settings.' : action.status === 'ACTIVE' ? 'Restore this employee’s membership access? They will need to sign in again.' : `${action.status === 'SUSPENDED' ? 'Suspend' : 'Deactivate'} this employee’s membership and revoke active sessions? Historical work and attribution will be preserved.`}</p>}
      </form>}
    </FormDialog>
  </section>
}
