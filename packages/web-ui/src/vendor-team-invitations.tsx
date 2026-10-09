import { useCallback, useEffect, useState, type FormEvent, type ReactNode, useId, useRef } from 'react'
import type { VendorInvitationRequest, VendorTeamInvitationListEnvelope, VendorTeamInvitationRecord } from '@materyalph/api-client-ts'
import { Button } from './button'
import { Field } from './field'
import { StatusMessage } from './status-message'
import { StatusBadge } from './portal-shell'
import type { RequestAccountVerification } from './account-verification-dialog'
import { FormDialog } from './form-dialog'
import { Plus, Mail, Trash2 } from 'lucide-react'
import { teamRoles as roles, TeamAvatar } from './vendor-team-patterns'

function invitationDate(value: Date | string | null | undefined) {
  return value ? new Intl.DateTimeFormat('en-PH', { dateStyle: 'medium', timeStyle: 'short', timeZone: 'Asia/Manila' }).format(new Date(value)) : 'Not yet accepted'
}

export function VendorTeamInvitations({ organizationName, canInviteManager, invite, list, explainError, children, verifyChange, deleteInvitation }: {
  deleteInvitation?: ((id: string, lockVersion: number) => Promise<unknown>) | undefined
  verifyChange: RequestAccountVerification
  children?: ReactNode
  organizationName: string
  canInviteManager: boolean
  invite: (input: VendorInvitationRequest) => Promise<unknown>
  list: (page: number) => Promise<VendorTeamInvitationListEnvelope>
  explainError: (error: unknown) => Promise<string>
}) {
  const [tab, setTab] = useState<'members' | 'invitations'>(children ? 'members' : 'invitations')
  const [deleting, setDeleting] = useState<VendorTeamInvitationRecord | null>(null)
  const deleteFormId = useId()
  const [open, setOpen] = useState(false)
  const formId = useId()
  const descriptionId = useId()
  const [role, setRole] = useState<VendorInvitationRequest['role']>('STORE_STAFF')
  const [busy, setBusy] = useState(false)
  const [loading, setLoading] = useState(true)
  const [message, setMessage] = useState<{ tone: 'success' | 'error'; text: string } | null>(null)
  const [loadError, setLoadError] = useState<string | null>(null)
  const [rows, setRows] = useState<VendorTeamInvitationRecord[]>([])
  const [page, setPage] = useState(1)
  const [lastPage, setLastPage] = useState(1)
  const loadVersion = useRef(0)
  const load = useCallback(async () => {
    const version = ++loadVersion.current
    setLoading(true); setLoadError(null)
    try { const response = await list(page); if (version === loadVersion.current) { setRows(response.data); setLastPage(response.meta.lastPage) } }
    catch (error) { const text = await explainError(error); if (version === loadVersion.current) { setRows([]); setLoadError(text) } }
    finally { if (version === loadVersion.current) setLoading(false) }
  }, [list, page, explainError])
  useEffect(() => { void load(); return () => { loadVersion.current++ } }, [load, tab])

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    if (busy) return
    const form = event.currentTarget
    const data = new FormData(form)
    setBusy(true); setMessage(null)
    try {
      if (!await verifyChange(`Authenticate invitation for ${String(data.get('invitee_name')).trim()}`)) return
      await invite({ inviteeName: String(data.get('invitee_name')).trim(), email: String(data.get('email')).trim().toLowerCase(), inviteeMobile: String(data.get('invitee_mobile') || '').trim() || null, role, canManageStaff: role === 'STORE_MANAGER' && data.get('can_manage_staff') === 'on' })
      form.reset(); setRole('STORE_STAFF'); setOpen(false); setTab('invitations')
      setMessage({ tone: 'success', text: 'Invitation queued for email delivery. Your employee will use their own login and join this store.' })
      if (page !== 1) setPage(1); else await load()
    } catch (error) { setMessage({ tone: 'error', text: await explainError(error) }) }
    finally { setBusy(false) }
  }

  async function confirmDelete(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    if (!deleting || !deleteInvitation || busy) return
    setBusy(true); setMessage(null)
    try {
      if (!await verifyChange(`Authenticate invitation deletion for ${deleting.inviteeName || deleting.email}`)) return
      await deleteInvitation(deleting.id, deleting.lockVersion)
      setDeleting(null); setMessage({ tone: 'success', text: 'Invitation deleted. Its audit history is preserved.' })
      if (rows.length === 1 && page > 1) setPage(page - 1); else await load()
    } catch (error) { setMessage({ tone: 'error', text: await explainError(error) }) }
    finally { setBusy(false) }
  }

  return <div className="min-w-0 space-y-8">
    <div className="flex flex-wrap items-center justify-between gap-4"><Button className="rounded-full" onClick={() => { setMessage(null); setOpen(true) }}><Plus size={18} aria-hidden="true" />Add new account</Button>{children && <nav aria-label="Team account views" className="flex gap-1 rounded-control bg-surface-canvas p-1">{([['members', 'Team members'], ['invitations', 'Invitations']] as const).map(([key, label]) => <button key={key} type="button" aria-pressed={tab === key} className={`min-h-11 rounded-control px-4 text-sm font-medium ${tab === key ? 'bg-surface-primary text-action-primary shadow-sm' : 'text-text-secondary'}`} onClick={() => setTab(key)}>{label}</button>)}</nav>}</div>
    {!open && !deleting && message && <StatusMessage tone={message.tone}>{message.text}</StatusMessage>}
    {tab === 'members' && children}
    <FormDialog open={open} title="Add new account" description={`Invite an employee to ${organizationName} with their own login and one fixed role.`} busy={busy} onClose={() => setOpen(false)} footer={<div className="flex flex-wrap items-center justify-between gap-3"><p className="text-xs text-text-secondary">Invitation links expire after 24 hours.</p><div className="flex gap-3"><Button variant="secondary" disabled={busy} onClick={() => setOpen(false)}>Cancel</Button><Button type="submit" form={formId} disabled={busy}>{busy ? 'Sending invitation…' : 'Send invitation'}</Button></div></div>}>
      <form id={formId} className="min-w-0 space-y-5" onSubmit={event => void submit(event)}>
        <div><h3 className="text-lg font-semibold">Invite a team member</h3><p className="mt-1 break-words text-sm text-text-secondary">Vendor organization: <span className="font-semibold text-text-strong">{organizationName}</span></p></div>
        {message && <StatusMessage tone={message.tone}>{message.text}</StatusMessage>}
        <fieldset disabled={busy} className="grid min-w-0 gap-5 sm:grid-cols-2">
          <Field label="Employee full name" name="invitee_name" autoComplete="name" maxLength={160} required />
          <Field label="Email address" name="email" type="email" autoComplete="email" maxLength={254} required />
          <Field label="Contact number (optional)" name="invitee_mobile" type="tel" autoComplete="tel" maxLength={24} />
          <label className="grid min-w-0 gap-2 text-sm font-medium">Fixed role<select name="role" value={role} onChange={event => setRole(event.target.value as VendorInvitationRequest['role'])} className="min-h-11 w-full min-w-0 rounded-control border border-border-default bg-surface-primary px-3 text-text-strong" aria-describedby={descriptionId}>{roles.filter(item => canInviteManager || item.value !== 'STORE_MANAGER').map(item => <option key={item.value} value={item.value}>{item.label}</option>)}</select></label>
          <p id={descriptionId} className="text-sm leading-6 text-text-secondary sm:col-span-2">{roles.find(item => item.value === role)?.detail}</p>
          {role === 'STORE_MANAGER' && canInviteManager && <div className="sm:col-span-2"><label className="flex min-h-11 items-start gap-3 text-sm leading-6"><input className="mt-1 h-5 w-5 shrink-0 accent-action-primary" type="checkbox" name="can_manage_staff" />Allow this Store Manager to manage staff accounts</label><p className="mt-1 text-xs leading-5 text-text-secondary">Off by default. Allows management of non-manager staff only. You will authenticate before sending this invitation.</p></div>}
        </fieldset>
        <p className="rounded-control bg-surface-canvas p-4 text-sm leading-6 text-text-secondary">Employees do not repeat Vendor Onboarding and cannot bypass Store Activation. Invitations and access changes are recorded in the store’s audit history.</p>
      </form>
    </FormDialog>
    <FormDialog open={!!deleting} title="Delete invitation" description={deleting?.inviteeName || deleting?.email || ''} busy={busy} onClose={() => setDeleting(null)} footer={<div className="flex justify-end gap-3"><Button variant="secondary" disabled={busy} onClick={() => setDeleting(null)}>Cancel</Button><Button variant="danger" type="submit" form={deleteFormId} disabled={busy}>{busy ? 'Deleting…' : 'Delete invitation'}</Button></div>}>
      <form id={deleteFormId} onSubmit={event => void confirmDelete(event)} className="space-y-4">{message?.tone === 'error' && <StatusMessage tone="error">{message.text}</StatusMessage>}<p className="text-sm leading-7">Delete this invitation from the list? Its link will remain invalid, and its audit history will be preserved.</p></form>
    </FormDialog>
    {tab === 'invitations' && <section aria-labelledby="team-invitation-history" className="min-w-0"><div className="flex flex-wrap items-center justify-between gap-3"><h3 id="team-invitation-history" className="flex items-center gap-2 text-lg font-semibold"><Mail size={18} aria-hidden="true" />Invitation history</h3><Button type="button" variant="secondary" disabled={loading} onClick={() => void load()}>Refresh invitations</Button></div>
      {loadError ? <div className="mt-4"><StatusMessage tone="error">{loadError}</StatusMessage></div> : loading ? <p className="py-6 text-sm text-text-secondary" role="status">Loading invitations…</p> : rows.length === 0 ? <p className="mt-4 rounded-control border border-dashed border-border-default px-5 py-6 text-sm leading-6 text-text-secondary">No invitations yet. Continue without a team, or select Add new account to invite your first employee.</p> : <ul className="mt-4 space-y-3">{rows.map(row => <li key={row.id} className="min-w-0 rounded-surface border border-border-default bg-surface-primary p-5"><div className="flex flex-wrap items-start justify-between gap-3"><div className="flex min-w-0 items-center gap-3"><TeamAvatar name={row.inviteeName || 'Employee'} /><div className="min-w-0"><p className="break-words font-semibold">{row.inviteeName || 'Employee'}</p><p className="break-all text-sm text-text-secondary">{row.email}</p></div></div><StatusBadge label={row.status.toLowerCase()} /></div><details className="mt-3"><summary className="flex min-h-11 cursor-pointer items-center text-sm text-action-primary">Invitation details</summary><dl className="mt-3 grid gap-x-6 gap-y-3 text-sm sm:grid-cols-2 lg:grid-cols-3">{[['Role', roles.find(roleOption => roleOption.value === row.role)?.label ?? row.role], ['Contact number', row.inviteeMobile || 'Not provided'], ['Invited by', row.invitedByName], ['Created (Manila)', invitationDate(row.createdAt)], ['Expires (Manila)', invitationDate(row.expiresAt)], ['Accepted (Manila)', invitationDate(row.acceptedAt)]].map(([label, value]) => <div className="min-w-0" key={label}><dt className="text-xs text-text-secondary">{label}</dt><dd className="mt-1 break-words">{value}</dd></div>)}</dl></details>{deleteInvitation && canInviteManager && row.canDelete && <Button className="mt-4" variant="danger" disabled={busy} onClick={() => { setMessage(null); setDeleting(row) }} aria-label={`Delete invitation for ${row.inviteeName || row.email}`}><Trash2 size={15} aria-hidden="true" />Delete invitation</Button>}{row.status !== 'ACCEPTED' && row.status !== 'REVOKED' && <Button className="mt-4" variant="secondary" disabled={busy} onClick={async () => { if (busy) return; setBusy(true); setMessage(null); try { if (!await verifyChange(`Authenticate replacement invitation for ${row.inviteeName || row.email}`)) return; await invite({ email: row.email, inviteeName: row.inviteeName || '', inviteeMobile: row.inviteeMobile ?? null, role: row.role as VendorInvitationRequest['role'], canManageStaff: row.canManageStaff }); setMessage({ tone: 'success', text: 'A replacement invitation was queued. The previous link is no longer valid.' }); await load() } catch (error) { setMessage({ tone: 'error', text: await explainError(error) }) } finally { setBusy(false) } }}>Resend invitation to {row.inviteeName || row.email}</Button>}</li>)}</ul>}
      {lastPage > 1 && <div className="mt-4 flex flex-wrap items-center gap-3"><Button variant="secondary" disabled={loading || page <= 1} onClick={() => setPage(page - 1)}>Previous</Button><span className="text-sm">Page {page} of {lastPage}</span><Button variant="secondary" disabled={loading || page >= lastPage} onClick={() => setPage(page + 1)}>Next page</Button></div>}
    </section>}
  </div>
}
