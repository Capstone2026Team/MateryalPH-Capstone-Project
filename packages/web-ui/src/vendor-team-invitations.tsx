import { useCallback, useEffect, useState, type FormEvent } from 'react'
import type { VendorInvitationRequest, VendorTeamInvitationListEnvelope, VendorTeamInvitationRecord } from '@materyalph/api-client-ts'
import { Button } from './button'
import { Field } from './field'
import { StatusMessage } from './status-message'
import { StatusBadge } from './portal-shell'

const roles = [
  { value: 'STORE_MANAGER', label: 'Store Manager', detail: 'Oversees daily operations, products, fulfillment and operational performance. Financial accounts and protected Owner functions stay with the Vendor Owner.' },
  { value: 'STORE_STAFF', label: 'Store Staff', detail: 'Handles sales, customer conversations, products and inventory. Does not manage fulfillment, financial accounts or team access.' },
  { value: 'CUSTOMER_SERVICE', label: 'Customer Service Staff', detail: 'Handles customer inquiries, permitted orders and quotations. May view relevant stock, but cannot administer inventory.' },
  { value: 'INVENTORY', label: 'Inventory Staff', detail: 'Manages products, variants, pricing, stock and product compliance. Does not accept orders or handle customer conversations.' },
  { value: 'FULFILLMENT', label: 'Fulfillment Staff', detail: 'Prepares and fulfills assigned orders and uses their dedicated fulfillment conversations. Cannot change inventory, pricing or vehicle configurations.' },
] as const

function invitationDate(value: Date | string | null | undefined) {
  return value ? new Intl.DateTimeFormat('en-PH', { dateStyle: 'medium', timeStyle: 'short', timeZone: 'Asia/Manila' }).format(new Date(value)) : 'Not yet accepted'
}

export function VendorTeamInvitations({ organizationName, canInviteManager, invite, list, explainError }: {
  organizationName: string
  canInviteManager: boolean
  invite: (input: VendorInvitationRequest) => Promise<unknown>
  list: (page: number) => Promise<VendorTeamInvitationListEnvelope>
  explainError: (error: unknown) => Promise<string>
}) {
  const [role, setRole] = useState<VendorInvitationRequest['role']>('STORE_STAFF')
  const [busy, setBusy] = useState(false)
  const [loading, setLoading] = useState(true)
  const [message, setMessage] = useState<{ tone: 'success' | 'error'; text: string } | null>(null)
  const [loadError, setLoadError] = useState<string | null>(null)
  const [rows, setRows] = useState<VendorTeamInvitationRecord[]>([])
  const [page, setPage] = useState(1)
  const [lastPage, setLastPage] = useState(1)
  const load = useCallback(async () => {
    setLoading(true); setLoadError(null)
    try { const response = await list(page); setRows(response.data); setLastPage(response.meta.lastPage) }
    catch (error) { setLoadError(await explainError(error)) }
    finally { setLoading(false) }
  }, [list, page, explainError])
  useEffect(() => { void load() }, [load])

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    const form = event.currentTarget
    const data = new FormData(form)
    setBusy(true); setMessage(null)
    try {
      await invite({ inviteeName: String(data.get('invitee_name')).trim(), email: String(data.get('email')).trim().toLowerCase(), inviteeMobile: String(data.get('invitee_mobile') || '').trim() || null, role, canManageStaff: role === 'STORE_MANAGER' && data.get('can_manage_staff') === 'on' })
      form.reset(); setRole('STORE_STAFF')
      setMessage({ tone: 'success', text: 'Invitation queued for email delivery. Your employee will use their own login and join this store.' })
      if (page !== 1) setPage(1); else await load()
    } catch (error) { setMessage({ tone: 'error', text: await explainError(error) }) }
    finally { setBusy(false) }
  }

  return <div className="min-w-0 space-y-8">
    <div className="flex flex-col gap-3 sm:flex-row sm:items-start sm:gap-4"><StatusBadge label="Optional" /><p className="max-w-3xl text-sm leading-6 text-text-secondary">Invite employees now or after Store Activation. Each person joins your existing store with an individual login and one fixed role. You can skip this step; the Vendor Owner keeps access to all store functions.</p></div>
    <div className="grid min-w-0 gap-8 border-y border-border-default py-7 lg:grid-cols-[minmax(0,1fr)_minmax(220px,0.55fr)]">
      <form className="min-w-0 space-y-5" onSubmit={event => void submit(event)}>
        <div><h3 className="text-lg font-semibold">Invite a team member</h3><p className="mt-1 break-words text-sm text-text-secondary">Vendor organization: <span className="font-semibold text-text-strong">{organizationName}</span></p></div>
        {message && <StatusMessage tone={message.tone}>{message.text}</StatusMessage>}
        <fieldset disabled={busy} className="grid min-w-0 gap-5 sm:grid-cols-2">
          <Field label="Employee full name" name="invitee_name" autoComplete="name" maxLength={160} required />
          <Field label="Email address" name="email" type="email" autoComplete="email" maxLength={254} required />
          <Field label="Contact number (optional)" name="invitee_mobile" type="tel" autoComplete="tel" maxLength={24} />
          <label className="grid min-w-0 gap-2 text-sm font-medium">Fixed role<select name="role" value={role} onChange={event => setRole(event.target.value as VendorInvitationRequest['role'])} className="min-h-11 w-full min-w-0 rounded-control border border-border-default bg-surface-primary px-3 text-text-strong" aria-describedby="team-role-description">{roles.filter(item => canInviteManager || item.value !== 'STORE_MANAGER').map(item => <option key={item.value} value={item.value}>{item.label}</option>)}</select></label>
          <p id="team-role-description" className="text-sm leading-6 text-text-secondary sm:col-span-2">{roles.find(item => item.value === role)?.detail}</p>
          {role === 'STORE_MANAGER' && canInviteManager && <div className="sm:col-span-2"><label className="flex min-h-11 items-start gap-3 text-sm leading-6"><input className="mt-1 h-5 w-5 shrink-0 accent-action-primary" type="checkbox" name="can_manage_staff" />Allow this Store Manager to manage staff accounts</label><p className="mt-1 text-xs leading-5 text-text-secondary">Off by default. Allows management of non-manager staff only. Verify your identity in Account Settings → Security before enabling.</p></div>}
        </fieldset>
        <div className="flex flex-wrap items-center gap-4"><Button type="submit" disabled={busy}>{busy ? 'Sending invitation…' : 'Send invitation'}</Button><p className="text-xs leading-5 text-text-secondary">The email link expires after 24 hours.</p></div>
      </form>
      <aside className="min-w-0 border-t border-border-default pt-6 lg:border-l lg:border-t-0 lg:pl-7 lg:pt-0"><h3 className="text-sm font-semibold">Individual accounts. One store.</h3><ul className="mt-3 space-y-3 text-sm leading-6 text-text-secondary"><li>Employees use their own credentials. Never share the Vendor Owner login.</li><li>Invited employees do not repeat Vendor Onboarding.</li><li>Until this store is active, employees have limited access according to their role.</li><li>Invitations and team changes are recorded in the store’s audit history.</li></ul></aside>
    </div>
    <section aria-labelledby="team-invitation-history" className="min-w-0"><div className="flex flex-wrap items-center justify-between gap-3"><h3 id="team-invitation-history" className="text-lg font-semibold">Invitations</h3><Button type="button" variant="secondary" disabled={loading} onClick={() => void load()}>Refresh invitations</Button></div>
      {loadError ? <div className="mt-4"><StatusMessage tone="error">{loadError}</StatusMessage></div> : loading ? <p className="py-6 text-sm text-text-secondary" role="status">Loading invitations…</p> : rows.length === 0 ? <p className="mt-4 rounded-control border border-dashed border-border-default px-5 py-6 text-sm leading-6 text-text-secondary">No invitations yet. Continue without a team, or invite your first employee above.</p> : <ul className="mt-4 divide-y divide-border-default">{rows.map(row => <li key={row.id} className="min-w-0 py-5"><div className="flex flex-wrap items-start justify-between gap-3"><div className="min-w-0"><p className="break-words font-semibold">{row.inviteeName || 'Employee'}</p><p className="break-all text-sm text-text-secondary">{row.email}</p></div><StatusBadge label={row.status.toLowerCase()} /></div><dl className="mt-3 grid gap-x-6 gap-y-3 text-sm sm:grid-cols-2 lg:grid-cols-3">{[['Role', roles.find(roleOption => roleOption.value === row.role)?.label ?? row.role], ['Contact number', row.inviteeMobile || 'Not provided'], ['Invited by', row.invitedByName], ['Created (Manila)', invitationDate(row.createdAt)], ['Expires (Manila)', invitationDate(row.expiresAt)], ['Accepted (Manila)', invitationDate(row.acceptedAt)]].map(([label, value]) => <div className="min-w-0" key={label}><dt className="text-xs text-text-secondary">{label}</dt><dd className="mt-1 break-words">{value}</dd></div>)}</dl>{row.status !== 'ACCEPTED' && row.status !== 'REVOKED' && <Button className="mt-4" variant="secondary" disabled={busy} onClick={async () => { setBusy(true); setMessage(null); try { await invite({ email: row.email, inviteeName: row.inviteeName || '', inviteeMobile: row.inviteeMobile ?? null, role: row.role as VendorInvitationRequest['role'], canManageStaff: row.canManageStaff }); setMessage({ tone: 'success', text: 'A replacement invitation was queued. The previous link is no longer valid.' }); await load() } catch (error) { setMessage({ tone: 'error', text: await explainError(error) }) } finally { setBusy(false) } }}>Resend invitation to {row.inviteeName || row.email}</Button>}</li>)}</ul>}
      {lastPage > 1 && <div className="mt-4 flex flex-wrap items-center gap-3"><Button variant="secondary" disabled={loading || page <= 1} onClick={() => setPage(page - 1)}>Previous</Button><span className="text-sm">Page {page} of {lastPage}</span><Button variant="secondary" disabled={loading || page >= lastPage} onClick={() => setPage(page + 1)}>Next page</Button></div>}
    </section>
  </div>
}
