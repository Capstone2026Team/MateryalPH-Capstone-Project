import { useCallback, useEffect, useState, type FormEvent, type ReactNode } from 'react'
import { AccountsApi, AuthenticationApi, ResponseError, type AccountProfile, type AccountSession, type AccountAgreement, type AccountMembership, type AccountRole, type AccountAdministrator } from '@materyalph/api-client-ts'
import { Button } from './button'
import { Field } from './field'
import { StatusMessage } from './status-message'
import { clearWebSessionTransport, createWebApiConfiguration } from './web-api-session'

type Section = 'Profile' | 'Security' | 'Sessions' | 'Agreements' | 'Staff access' | 'Admin invitations' | 'Admin accounts'
type Props = { portal: 'vendors' | 'admin'; basePath: string; loginPath: string; renderQr: (uri: string) => ReactNode }

export function AccountWorkspace({ portal: accountPortal, basePath, loginPath, renderQr }: Props) {
  const [profile, setProfile] = useState<AccountProfile | null>(null)
  const [section, setSection] = useState<Section>('Profile')
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<{ error: boolean; text: string } | null>(null)
  const [denied, setDenied] = useState(false)
  const [sessions, setSessions] = useState<AccountSession[]>([])
  const [agreements, setAgreements] = useState<AccountAgreement[]>([])
  const [memberships, setMemberships] = useState<AccountMembership[]>([])
  const [administrators, setAdministrators] = useState<AccountAdministrator[]>([])
  const [roles, setRoles] = useState<AccountRole[]>([])
  const [page, setPage] = useState(1)
  const [lastPage, setLastPage] = useState(1)
  const [emailChange, setEmailChange] = useState<{ id: string; expiresAt: string } | null>(null)
  const [factor, setFactor] = useState<{ id: string; secret: string; provisioningUri: string; expiresAt: string } | null>(null)
  const [codes, setCodes] = useState<string[]>([])
  const [signInAfterCodes, setSignInAfterCodes] = useState(false)
  const [invitationKey, setInvitationKey] = useState(() => crypto.randomUUID())
  const [totp, setTotp] = useState(false)

  const api = useCallback(() => new AccountsApi(createWebApiConfiguration(basePath, { refreshSession: true })), [basePath])

  const failure = useCallback(async (error: unknown) => {
    let text = 'The request could not finish. Check your connection and retry.'
    if (error instanceof ResponseError) {
      if (error.response.status === 401) { setProfile(null); setDenied(true); text = 'Your session has expired. Sign in again.' }
      if (error.response.status === 429) text = 'Too many requests were sent. Please wait a moment and try again.'
      const body: unknown = await error.response.clone().json().catch(() => null)
      if (typeof body === 'object' && body !== null && 'errors' in body && Array.isArray(body.errors)) {
        const first: unknown = body.errors[0]
        if (typeof first === 'object' && first !== null && 'message' in first && typeof first.message === 'string') text = first.message
      }
    }
    setMessage({ error: true, text })
  }, [])

  const load = useCallback(async () => {
    setBusy(true)
    try {
      const client = api()
      const response = await client.getAccountProfile({ accountPortal })
      if (response.data.accountType !== (accountPortal === 'vendors' ? 'VENDOR' : 'ADMIN')) { setDenied(true); setProfile(null); return }
      setProfile(response.data)
      setDenied(false)
      const security = await client.getAccountSecurity({ accountPortal }); setTotp(security.data.totpEnrolled)
      if (section === 'Sessions') {
        const result = await client.listAccountSessions({ accountPortal, page }); setSessions(result.data); setLastPage(Number(result.meta.last_page ?? 1))
      }
      if (section === 'Agreements') setAgreements((await client.listAccountAgreements({ accountPortal })).data)
      if (section === 'Staff access' && accountPortal === 'vendors' && response.data.permissions.includes('staff.manage')) {
        const result = await client.listAccountMemberships({ accountPortal: 'vendors', page }); setMemberships(result.data); setLastPage(Number(result.meta.last_page ?? 1))
      }
      if (section === 'Admin accounts' && accountPortal === 'admin' && response.data.permissions.includes('admin.manage_accounts')) {
        const result = await client.listAccountAdministrators({ accountPortal: 'admin', page }); setAdministrators(result.data); setLastPage(Number(result.meta.last_page ?? 1))
        setRoles((await client.listAccountAdminRoles({ accountPortal: 'admin' })).data)
      }
      if (section === 'Admin invitations' && accountPortal === 'admin' && response.data.permissions.includes('admin.invite')) setRoles((await client.listAccountAdminRoles({ accountPortal: 'admin' })).data)
    } catch (error) { await failure(error) }
    finally { setBusy(false) }
  }, [accountPortal, api, failure, page, section])

  useEffect(() => { void load() }, [load])
  async function act(operation: (client: AccountsApi) => Promise<unknown>, text: string, reload = true) {
    setBusy(true); setMessage(null)
    try { await operation(api()); setMessage({ error: false, text }); if (reload) await load() }
    catch (error) { await failure(error) }
    finally { setBusy(false) }
  }
  function submit(event: FormEvent<HTMLFormElement>, action: (data: FormData) => Promise<void>) {
    event.preventDefault(); const form = event.currentTarget; const data = new FormData(form); if (form.querySelector('input[type="password"],input[autocomplete="one-time-code"]')) form.reset(); void action(data)
  }
  const date = (value: string | null) => value ? new Date(value).toLocaleString('en-PH', { timeZone: 'Asia/Manila' }) + ' (Asia/Manila)' : 'Not available'
  const nav: Section[] = ['Profile', 'Security', 'Sessions', 'Agreements']
  if (profile?.permissions.includes('staff.manage')) nav.push('Staff access')
  if (profile?.permissions.includes('admin.manage_accounts')) nav.push('Admin accounts')
  if (profile?.permissions.includes('admin.invite')) nav.push('Admin invitations')

  return <main className="mx-auto min-h-screen max-w-6xl bg-surface-canvas p-4 text-text-strong sm:p-8">
    <header className="mb-8 flex flex-wrap items-center justify-between gap-4 border-b border-border-default pb-6"><a href={accountPortal === 'vendors' ? '/' : '/workspace'} aria-label="MateryalPH home"><img className="w-40" src="/brand/materyalph-logo.png" alt="MateryalPH" /></a><span>{accountPortal === 'vendors' ? 'Vendor account' : 'Admin account'}</span><Button variant="secondary" disabled={busy || !profile} onClick={() => window.confirm('Sign out every device, including this one?') && void act(async client => { await client.revokeAccountSessions({ accountPortal, accountSessionRevocation: { scope: 'ALL' } }); window.location.assign(loginPath) }, 'Signed out.', false)}>Sign out all devices</Button></header>
    {message && <StatusMessage tone={message.error ? 'error' : 'success'}>{message.text}</StatusMessage>}
    {denied ? <section><h1 className="text-2xl font-bold">Sign-in required</h1><a className="inline-flex min-h-12 items-center text-action-primary underline" href={loginPath}>Return to sign in</a></section> : !profile ? <section aria-busy={busy}><h1 className="text-2xl font-bold">{busy ? 'Checking your account…' : 'Account unavailable'}</h1><Button variant="secondary" disabled={busy} onClick={() => void load()}>Retry</Button></section> : <>
      <h1 className="mb-2 text-3xl font-bold">Your account</h1><p className="mb-8 text-text-secondary">{profile.fullName} · {profile.role.replaceAll('_', ' ')}</p>
      <div className="grid gap-8 md:grid-cols-[13rem_1fr]"><nav aria-label="Account settings" className="flex flex-wrap content-start gap-2 md:flex-col">{accountPortal === 'vendors' && <a className="min-h-12 px-4 py-3 underline" href="/dashboard">Vendor Dashboard</a>}{accountPortal === 'vendors' && (profile.role === 'OWNER' || profile.permissions.includes('finance.draft_corrections') || profile.permissions.includes('staff.manage')) && <a className="min-h-12 px-4 py-3 underline" href="/onboarding">Vendor onboarding and team</a>}{accountPortal === 'admin' && profile.permissions.includes('vendors.verify') && <a className="min-h-12 px-4 py-3 underline" href="/vendor-verification">Vendor verification</a>}{nav.map(item => <Button key={item} variant={section === item ? 'primary' : 'secondary'} aria-current={section === item ? 'page' : undefined} onClick={() => { setSection(item); setPage(1); setFactor(null); setCodes([]); setMessage(null) }}>{item}</Button>)}<Button variant="secondary" disabled={busy} onClick={() => void act(async () => { await new AuthenticationApi(createWebApiConfiguration(basePath, { refreshSession: true })).logout(); clearWebSessionTransport(basePath); window.location.assign(loginPath) }, 'Signed out.', false)}>Sign out</Button></nav>
      <section aria-busy={busy} className="min-w-0 rounded-xl bg-surface-primary p-5 sm:p-8"><h2 className="mb-6 text-2xl font-bold">{section}</h2>
        {section === 'Profile' && <><form className="grid max-w-xl gap-5" onSubmit={event => submit(event, data => act(client => client.updateAccountProfile({ accountPortal, accountProfileUpdate: { fullName: String(data.get('full_name')), lockVersion: profile.lockVersion } }), 'Profile saved.'))}><Field key={profile.lockVersion} label="Full name" name="full_name" defaultValue={profile.fullName} required maxLength={160} /><Button type="submit" disabled={busy}>Save profile</Button></form><dl className="mt-8 grid gap-4 border-t border-border-default pt-6"><div><dt>Email</dt><dd className="break-all">{profile.email}</dd></div><div><dt>Fixed role</dt><dd>{profile.role.replaceAll('_',' ')}</dd></div>{profile.organizationName && <div><dt>Store membership</dt><dd>{profile.organizationName}</dd></div>}<div><dt>Account created</dt><dd>{date(profile.createdAt)}</dd></div><div><dt>Permissions</dt><dd className="break-words">{profile.permissions.length ? profile.permissions.join(', ') : 'Personal account settings'}</dd></div></dl></>}
        {section === 'Security' && <div className="grid max-w-xl gap-8">
          <form className="grid gap-4" onSubmit={event => submit(event, data => act(client => client.reauthenticateAccount({ accountPortal, accountReauthentication: { password: String(data.get('password')), code: String(data.get('code') || '') || null } }), 'Identity verified for 15 minutes.'))}><h3 className="text-lg font-semibold">Verify your identity</h3><p>Verify before changing your password, email, authenticator or access settings.</p><Field label="Current password" name="password" type="password" autoComplete="current-password" required />{totp && <Field label="Authenticator code" name="code" inputMode="numeric" pattern="[0-9]{6}" maxLength={6} autoComplete="one-time-code" required />}<Button type="submit" disabled={busy}>Verify identity</Button></form>
          <form className="grid gap-4" onSubmit={event => submit(event, data => act(client => client.reauthenticateAccount({ accountPortal, accountReauthentication: { emailCode: String(data.get('reauth_email_code')), code: String(data.get('reauth_totp') || '') || null } }), 'Identity verified for 15 minutes.'))}>
            <Button type="button" variant="secondary" disabled={busy} onClick={() => void act(client => client.sendAccountReauthenticationEmail({ accountPortal }), 'A verification code was sent to your current email.', false)}>Send email verification instead</Button>
            <Field label="Current-email verification code" name="reauth_email_code" inputMode="numeric" pattern="[0-9]{6}" autoComplete="one-time-code" required />
            {totp && <Field label="Authenticator code for email verification" name="reauth_totp" inputMode="numeric" pattern="[0-9]{6}" required />}
            <Button type="submit" disabled={busy}>Verify email code</Button>
          </form>
          <form className="grid gap-4 border-t border-border-default pt-6" onSubmit={event => submit(event, data => act(async client => { const result = await client.changeAccountPassword({ accountPortal, accountPasswordChange: { password: String(data.get('new_password')), passwordConfirmation: String(data.get('password_confirmation')) } }); if(result.data.signInRequired) window.location.assign(loginPath) }, 'Password changed.'))}><h3 className="text-lg font-semibold">Change password</h3><Field label="New password" name="new_password" type="password" autoComplete="new-password" minLength={14} required /><Field label="Confirm new password" name="password_confirmation" type="password" autoComplete="new-password" minLength={14} required /><p>Changing your password signs out your web sessions.</p><Button type="submit" disabled={busy}>Change password</Button></form>
          <form className="grid gap-4 border-t border-border-default pt-6" onSubmit={event => submit(event, data => act(async client => { setEmailChange((await client.startAccountEmailChange({accountPortal,accountEmailChange:{email:String(data.get('email'))}})).data) }, 'Verification sent to the new email.', false))}><h3 className="text-lg font-semibold">Change primary email</h3><Field label="New email" name="email" type="email" required /><Button type="submit" disabled={busy}>Send verification</Button></form>
          {emailChange && <form className="grid gap-4" onSubmit={event => submit(event, data => act(async client => { await client.confirmAccountEmailChange({accountPortal,accountCodeConfirmation:{id:emailChange.id,code:String(data.get('email_code'))}}); window.location.assign(loginPath) }, 'Email changed.', false))}><p>Expires {date(emailChange.expiresAt)}. Completing this change signs out all sessions.</p><Field label="New-email verification code" name="email_code" inputMode="numeric" pattern="[0-9]{6}" required /><Button type="submit" disabled={busy}>Confirm email change</Button></form>}
          {totp && <div className="grid gap-4 border-t border-border-default pt-6"><h3 className="text-lg font-semibold">Authenticator and recovery codes</h3><p>Your authenticator remains mandatory. Replacement keeps your existing factor active until the new code is confirmed.</p><Button variant="secondary" disabled={busy} onClick={() => void act(async client => setFactor((await client.startAccountFactorReplacement({accountPortal})).data), 'Scan the new authenticator setup.', false)}>Replace authenticator</Button><Button variant="secondary" disabled={busy} onClick={() => { if(window.confirm('Replace all recovery codes? Previous codes will stop working.')) void act(async client => setCodes((await client.replaceAccountRecoveryCodes({accountPortal})).data.recoveryCodes), 'Save these codes securely. They are shown once.', false) }}>Replace recovery codes</Button></div>}
          {factor && <form className="grid gap-4" onSubmit={event => submit(event, data => act(async client => { const result=await client.confirmAccountFactorReplacement({accountPortal,accountCodeConfirmation:{id:factor.id,code:String(data.get('factor_code'))}}); setFactor(null);setCodes(result.data.recoveryCodes);setSignInAfterCodes(true) }, 'Authenticator replaced. Save the new recovery codes, then sign in.', false))}>{renderQr(factor.provisioningUri)}<p className="break-all">Manual setup key: {factor.secret}</p><p>Expires {date(factor.expiresAt)}</p><Field label="New authenticator code" name="factor_code" inputMode="numeric" pattern="[0-9]{6}" required /><Button type="submit" disabled={busy}>Confirm replacement and sign out</Button></form>}
          {codes.length > 0 && <section aria-label="One-time recovery codes"><h3 className="text-lg font-semibold">Save your recovery codes</h3><ul className="my-4 grid gap-2">{codes.map(code => <li key={code}>{code}</li>)}</ul><Button onClick={() => {setCodes([]);if(signInAfterCodes)window.location.assign(loginPath)}}>I saved my codes</Button></section>}
        </div>}
        {section === 'Sessions' && <><p className="mb-4">Times are shown in Asia/Manila. Revocation immediately removes backend access.</p>{sessions.length === 0 && <p>No active sessions.</p>}<ul className="divide-y divide-border-default">{sessions.map(session => <li key={session.id} className="flex flex-wrap items-center justify-between gap-4 py-5"><div><h3 className="font-semibold">{session.description}{session.current ? ' · Current session' : ''}</h3><p>Signed in {date(session.createdAt)}</p><p>Last active {date(session.lastActiveAt)}</p></div><Button variant="secondary" disabled={busy} onClick={() => {if(window.confirm('Sign out this session?')) void act(async client => {await client.revokeAccountSession({accountPortal,sessionId:session.id});if(session.current)window.location.assign(loginPath)},'Session revoked.')}}>Revoke session</Button></li>)}</ul><Button variant="secondary" disabled={busy} onClick={() => {if(window.confirm('Sign out all other sessions?')) void act(client => client.revokeAccountSessions({accountPortal,accountSessionRevocation:{scope:'OTHERS'}}),'Other sessions signed out.')}}>Sign out other sessions</Button></>}
        {section === 'Agreements' && <div className="grid gap-6">{agreements.length === 0 && <p>No agreements are available.</p>}{agreements.map(agreement => <section key={agreement.id} className="border-b border-border-default pb-6"><h3 className="text-lg font-semibold">{agreement.title} · Version {agreement.version}</h3><p>{agreement.acceptedAt ? 'Accepted '+date(agreement.acceptedAt) : agreement.requiresAcceptance ? 'Acceptance required' : 'Not yet accepted'}</p>{agreement.contentAvailable ? <><pre className="my-4 whitespace-pre-wrap font-sans">{agreement.content}</pre>{!agreement.acceptedAt && <Button disabled={busy} onClick={() => void act(client=>client.acceptAccountAgreements({accountPortal,accountAgreementAcceptance:{versionIds:[agreement.id]}}),'Agreement recorded.')}>{agreement.code === 'PRIVACY_NOTICE' ? 'Acknowledge Privacy Notice' : 'Accept this version'}</Button>}</> : <p className="mt-3 text-text-secondary">Approved agreement text is not available yet. Contact support for the published copy.</p>}</section>)}</div>}
        {section === 'Staff access' && accountPortal === 'vendors' && profile.permissions.includes('staff.manage') && <><p className="mb-6">Verify your identity in Security before changing access. Every change is audited and notifies the Owner.</p>{memberships.length === 0 && <p>No eligible staff memberships.</p>}<ul className="divide-y divide-border-default">{memberships.map(member=><li key={member.id} className="grid gap-3 py-5"><h3 className="font-semibold">{member.name} · {member.role.replaceAll('_',' ')}</h3><p>{member.status}</p>{member.role==='STORE_MANAGER' && profile.permissions.includes('staff.delegate') && <Button variant="secondary" disabled={busy} onClick={()=>void act(client=>client.changeAccountDelegation({ accountPortal: 'vendors',membershipId:member.id,accountDelegation:{canManageStaff:!member.canManageStaff}}),'Delegation updated.')}>{member.canManageStaff?'Remove staff-management delegation':'Allow staff-management delegation'}</Button>}<Button variant="secondary" disabled={busy} onClick={()=>{if(window.confirm('Change this employee’s access and revoke their sessions?'))void act(client=>client.changeAccountMembershipStatus({ accountPortal: 'vendors',membershipId:member.id,accountMembershipStatus:{status:member.status==='ACTIVE'?'DEACTIVATED':'ACTIVE'}}),'Membership updated.')}}>{member.status==='ACTIVE'?'Deactivate access':'Reactivate access'}</Button></li>)}</ul></>}
        {section === 'Admin accounts' && accountPortal === 'admin' && profile.permissions.includes('admin.manage_accounts') && <>
          <p className="mb-6">Verify your identity in Security before changing staff access. Changes preserve historical attribution and sign out the affected account.</p>
          {administrators.length === 0 && <p>No Admin accounts are available.</p>}
          <ul className="divide-y divide-border-default">{administrators.map(admin => <li key={admin.id} className="py-6">
            <h3 className="font-semibold">{admin.name}</h3><p>{admin.role.replaceAll('_', ' ')} · {admin.status}</p>
            {admin.id !== profile.id && admin.role !== 'ADMIN_SUPERADMIN' && <form className="mt-4 grid max-w-xl gap-4" onSubmit={event => submit(event, data => {
              if (!window.confirm('Change this Admin account and sign out its sessions?')) return Promise.resolve()
              return act(client => client.changeAccountAdministrator({ accountPortal: 'admin', publicId: admin.id, accountAdminChange: { lockVersion: admin.lockVersion, reason: String(data.get('reason')), status: String(data.get('status')) as 'ACTIVE' | 'SUSPENDED' | 'DEACTIVATED', roleId: String(data.get('role_id')) } }), 'Admin access updated.')
            })}>
              <label className="grid gap-2">Role<select className="min-h-12 border border-border-default bg-surface-primary px-3" name="role_id" defaultValue={admin.roleId} required>{roles.map(role => <option value={role.id} key={role.id}>{role.name}</option>)}</select></label>
              <label className="grid gap-2">Access status<select className="min-h-12 border border-border-default bg-surface-primary px-3" name="status" defaultValue={admin.status} required>{!['ACTIVE','SUSPENDED','DEACTIVATED'].includes(admin.status) && <option value="" disabled>Setup pending</option>}<option value="ACTIVE">Active</option><option value="SUSPENDED">Suspended</option><option value="DEACTIVATED">Deactivated</option></select></label>
              <Field label="Reason for access change" name="reason" required minLength={3} maxLength={500} />
              <Button type="submit" disabled={busy}>Update Admin access</Button>
            </form>}
          </li>)}</ul>
        </>}
        {section === 'Admin invitations' && accountPortal === 'admin' && profile.permissions.includes('admin.invite') && <form className="grid max-w-xl gap-5" onChange={() => setInvitationKey(crypto.randomUUID())} onSubmit={event=>submit(event,data=>act(client=>client.inviteAccountAdmin({ accountPortal: 'admin',idempotencyKey:invitationKey,accountAdminInvitation:{email:String(data.get('invite_email')),roleId:String(data.get('role_id'))}}),'Invitation request received. Eligible recipients receive a one-time setup link.'))}><p>Verify your identity in Security first. Invitations expire after 24 hours; TOTP is required before protected access.</p><Field label="Staff email" name="invite_email" type="email" required /><label className="grid gap-2">Fixed Admin role<select className="min-h-12 rounded-control border border-border-default bg-surface-primary px-3" name="role_id" required><option value="">Choose a role</option>{roles.map(role=><option key={role.id} value={role.id}>{role.name}</option>)}</select></label><Button type="submit" disabled={busy}>Send invitation</Button></form>}
        {(section==='Sessions'||section==='Staff access'||section==='Admin accounts')&&lastPage>1&&<div className="mt-6 flex items-center gap-4"><Button variant="secondary" disabled={busy||page<=1} onClick={()=>setPage(page-1)}>Previous</Button><span>Page {page} of {lastPage}</span><Button variant="secondary" disabled={busy||page>=lastPage} onClick={()=>setPage(page+1)}>Next</Button></div>}
        <Button className="mt-6" variant="secondary" disabled={busy} onClick={()=>void load()}>{busy?'Updating…':'Refresh'}</Button>
      </section></div></>}
  </main>
}
