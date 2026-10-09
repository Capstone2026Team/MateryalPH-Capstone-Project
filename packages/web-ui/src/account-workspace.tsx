import { PageHeader, FilterTabs } from './page-patterns'
import { FileCheck2, ImagePlus, LogOut } from 'lucide-react'
import { useCallback, useEffect, useRef, useState, type FormEvent, type ReactNode } from 'react'
import { AccountsApi, ResponseError, type AccountProfile, type AccountSession, type AccountAgreement, type AccountRole, type AccountAdministrator } from '@materyalph/api-client-ts'
import { AccountVerificationDialog } from './account-verification-dialog'
import { Button } from './button'
import { Field } from './field'
import { StatusMessage } from './status-message'
import { rateLimitMessage, clearWebSessionTransport, signOutWebSession, createWebApiConfiguration } from './web-api-session'

type Section = 'Profile' | 'Account' | 'Security' | 'Sessions' | 'Agreements' | 'Admin invitations' | 'Admin accounts'
type Props = { portal: 'vendors' | 'admin'; basePath: string; loginPath: string; renderQr: (uri: string) => ReactNode; embedded?: boolean }
type PendingSecurityAction = { title: string; run: (client: AccountsApi) => Promise<void>; success: string; reload: boolean }

export function AccountWorkspace({ portal: accountPortal, basePath, loginPath, renderQr, embedded = false }: Props) {
  const [profile, setProfile] = useState<AccountProfile | null>(null)
  const loadedProfile = useRef<AccountProfile | null>(null)
  const [section, setSection] = useState<Section>(() => ['Profile', 'Account', 'Security', 'Sessions', 'Agreements'].includes(window.location.hash.slice(1)) ? window.location.hash.slice(1) as Section : 'Profile')
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<{ error: boolean; text: string } | null>(null)
  const [denied, setDenied] = useState(false)
  const [sessions, setSessions] = useState<AccountSession[]>([])
  const [agreements, setAgreements] = useState<AccountAgreement[]>([])
  const [administrators, setAdministrators] = useState<AccountAdministrator[]>([])
  const [roles, setRoles] = useState<AccountRole[]>([])
  const [page, setPage] = useState(1)
  const [lastPage, setLastPage] = useState(1)
  const [emailChange, setEmailChange] = useState<{ id: string; expiresAt: string } | null>(null)
  const [factor, setFactor] = useState<{ id: string; secret: string; provisioningUri: string; expiresAt: string } | null>(null)
  const [codes, setCodes] = useState<string[]>([])
  const [signInAfterCodes, setSignInAfterCodes] = useState(false)
  const [invitationKey, setInvitationKey] = useState(() => crypto.randomUUID())
  const actionLock = useRef(false)
  const [totp, setTotp] = useState(false)
  const [pendingSecurityAction, setPendingSecurityAction] = useState<PendingSecurityAction | null>(null)


  const api = useCallback(() => new AccountsApi(createWebApiConfiguration(basePath, { refreshSession: true })), [basePath])

  const errorText = useCallback(async (error: unknown) => {
    let text = 'The request could not finish. Check your connection and retry.'
    if (error instanceof ResponseError) {
      if (error.response.status === 401) { loadedProfile.current = null; setProfile(null); setDenied(true); text = 'Your session has expired. Sign in again.' }
      if (error.response.status === 429 && error.response.headers.has('Retry-After')) return rateLimitMessage(error.response)
      const body: unknown = await error.response.clone().json().catch(() => null)
      if (typeof body === 'object' && body !== null && 'errors' in body && Array.isArray(body.errors)) {
        const first: unknown = body.errors[0]
        if (typeof first === 'object' && first !== null && 'message' in first && typeof first.message === 'string') text = first.message
      }
    }
    return text
  }, [])
  const failure = useCallback(async (error: unknown) => {
    setMessage({ error: true, text: await errorText(error) })
  }, [errorText])

  const load = useCallback(async (refreshProfile = true) => {
    setBusy(true)
    try {
      const client = api()
      const response = { data: !refreshProfile && loadedProfile.current ? loadedProfile.current : (await client.getAccountProfile({ accountPortal })).data }
      if (response.data.accountType !== (accountPortal === 'vendors' ? 'VENDOR' : 'ADMIN')) { setDenied(true); setProfile(null); return }
      setProfile(response.data)
      loadedProfile.current = response.data
      setDenied(false)
      if (section === 'Security') { const security = await client.getAccountSecurity({ accountPortal }); setTotp(security.data.totpEnrolled) }
      if (section === 'Sessions') {
        const result = await client.listAccountSessions({ accountPortal, page }); setSessions(result.data); setLastPage(Number(result.meta.last_page ?? 1))
      }
      if (section === 'Agreements') setAgreements((await client.listAccountAgreements({ accountPortal })).data)
      if (section === 'Admin accounts' && accountPortal === 'admin' && response.data.permissions.includes('admin.manage_accounts')) {
        const result = await client.listAccountAdministrators({ accountPortal: 'admin', page }); setAdministrators(result.data); setLastPage(Number(result.meta.last_page ?? 1))
        setRoles((await client.listAccountAdminRoles({ accountPortal: 'admin' })).data)
      }
      if (section === 'Admin invitations' && accountPortal === 'admin' && response.data.permissions.includes('admin.invite')) setRoles((await client.listAccountAdminRoles({ accountPortal: 'admin' })).data)
    } catch (error) { await failure(error) }
    finally { setBusy(false) }
  }, [accountPortal, api, failure, page, section])

  useEffect(() => { loadedProfile.current = null }, [accountPortal, basePath])
  useEffect(() => { void load(false) }, [load])
  useEffect(() => {
    function selectHash() { const next = window.location.hash.slice(1); if (['Profile', 'Account', 'Security', 'Sessions', 'Agreements'].includes(next)) { setSection(next as Section); setPage(1); setFactor(null); setCodes([]) } }
    window.addEventListener('hashchange', selectHash)
    // Client-side routers emit popstate for same-page hash navigation.
    window.addEventListener('popstate', selectHash)
    return () => { window.removeEventListener('hashchange', selectHash); window.removeEventListener('popstate', selectHash) }
  }, [])
  async function act(operation: (client: AccountsApi) => Promise<unknown>, text: string, reload = true) {
    if (actionLock.current) return
    actionLock.current = true
    setBusy(true); setMessage(null)
    try { await operation(api()); setMessage({ error: false, text }); if (reload) { await load(); window.dispatchEvent(new Event('materyalph:profile-updated')) } }
    catch (error) { await failure(error) }
    finally { actionLock.current = false; setBusy(false) }
  }
  function submit(event: FormEvent<HTMLFormElement>, action: (data: FormData) => Promise<void>) {
    event.preventDefault(); const form = event.currentTarget; const data = new FormData(form); if (form.querySelector('input[type="password"],input[autocomplete="one-time-code"]')) form.reset(); void action(data)
  }
  function promptVerification(action: PendingSecurityAction) {
    if (!busy && !actionLock.current) setPendingSecurityAction(action)
  }
  const date = (value: string | null) => value ? new Date(value).toLocaleString('en-PH', { timeZone: 'Asia/Manila' }) + ' (Asia/Manila)' : 'Not available'
  const nav: Section[] = ['Profile', 'Account', 'Security', 'Sessions', 'Agreements']
  if (profile?.permissions.includes('admin.manage_accounts')) nav.push('Admin accounts')
  if (profile?.permissions.includes('admin.invite')) nav.push('Admin invitations')

  return <div className={embedded ? "mx-auto w-full max-w-6xl text-text-strong" : "mx-auto min-h-screen max-w-6xl bg-surface-canvas p-4 text-text-strong sm:p-8"}>
    {!embedded && <header className="mb-8 flex flex-wrap items-center justify-between gap-4 border-b border-border-default pb-6"><a href={accountPortal === 'vendors' ? '/dashboard' : '/vendor-verification'} aria-label="MateryalPH home"><img className="w-40" src="/brand/materyalph-logo.png" alt="MateryalPH" /></a><span>{accountPortal === 'vendors' ? 'Vendor account' : 'Admin account'}</span><Button variant="secondary" disabled={busy || !profile} onClick={() => window.confirm('Sign out every device, including this one?') && void act(async client => { await client.revokeAccountSessions({ accountPortal, accountSessionRevocation: { scope: 'ALL' } }); window.location.assign(loginPath) }, 'Signed out.', false)}>Sign out all devices</Button></header>}
    {message && <StatusMessage tone={message.error ? 'error' : 'success'}>{message.text}</StatusMessage>}
    {denied ? <section><h1 className="text-2xl font-bold">Sign-in required</h1><a className="inline-flex min-h-12 items-center text-action-primary underline" href={loginPath}>Return to sign in</a></section> : !profile ? <section aria-busy={busy}><h1 className="text-2xl font-bold">{busy ? 'Checking your account…' : 'Account unavailable'}</h1><Button variant="secondary" disabled={busy} onClick={() => void load()}>Retry</Button></section> : <>
      <div className="mb-6"><PageHeader eyebrow="Account" title="Settings" description="Manage your profile, security, sessions and agreements." /><p className="mt-4 text-[13px] text-text-secondary">{profile.fullName} · {profile.role.replaceAll('_', ' ')}</p></div>

      <div className="grid items-start gap-6"><nav aria-label="Account settings" className="flex flex-wrap items-center justify-between gap-4"><FilterTabs appearance="tabs" label="Account sections" value={section} chips={nav.map(item => ({ value: item, label: item === 'Sessions' ? 'Sessions / Devices' : item }))} onChange={value => { setSection(value as Section); setPage(1); setFactor(null); setCodes([]); setMessage(null) }} /><Button variant="secondary" disabled={busy} onClick={() => void act(async () => { await signOutWebSession(basePath); window.location.assign(loginPath) }, 'Signed out.', false)}><LogOut size={18} aria-hidden="true" /> Sign out</Button></nav>
      <section aria-busy={busy} className="min-w-0 rounded-surface border border-border-default bg-surface-primary p-5 sm:p-8"><h2 className={`mb-6 border-b border-border-default pb-5 text-xl font-semibold${section === 'Security' ? ' mx-auto w-full max-w-xl' : ''}`}>{section}</h2>
        {section === 'Profile' && <><div className="mb-6 flex flex-wrap items-center gap-5 border-b border-border-default pb-6"><div className="grid h-20 w-20 shrink-0 place-items-center overflow-hidden rounded-full bg-brand-orange-100 text-2xl font-semibold text-action-primary">{profile.avatarUrl ? <img src={profile.avatarUrl} alt="Your personal profile" className="h-full w-full object-cover" /> : profile.fullName.trim().split(/\s+/).slice(0, 2).map(part => part[0]).join('')}</div><div><h3 className="font-semibold">Profile picture</h3><p className="mt-1 max-w-lg text-sm leading-6 text-text-secondary">Personal account photo, separate from your store logo. JPEG, PNG or WebP up to 2 MB. The image is security-scanned and cropped to a square.</p><label className="mt-3 inline-flex min-h-11 cursor-pointer items-center rounded-control border border-border-default px-4 text-sm font-semibold"><ImagePlus size={18} className="mr-2" aria-hidden="true" />{busy ? 'Processing…' : 'Upload profile picture'}<input type="file" className="sr-only" accept="image/jpeg,image/png,image/webp" disabled={busy} onChange={event => { const file = event.target.files?.[0]; event.target.value = ''; if (!file) return; if (file.size > 2 * 1024 * 1024 || !['image/jpeg', 'image/png', 'image/webp'].includes(file.type)) { setMessage({ error: true, text: 'Choose a JPEG, PNG or WebP image up to 2 MB.' }); return } void act(client => client.uploadAccountPhoto({ webAccountPortal: accountPortal, photo: file, lockVersion: profile.lockVersion }), 'Profile picture saved.') }} /></label></div></div><form className="grid max-w-xl gap-5" onSubmit={event => submit(event, data => act(client => client.updateAccountProfile({ accountPortal, accountProfileUpdate: { fullName: String(data.get('full_name')), lockVersion: profile.lockVersion } }), 'Profile saved.'))}><Field key={profile.lockVersion} label="Full name" name="full_name" defaultValue={profile.fullName} required maxLength={160} /><Button type="submit" disabled={busy}>Save profile</Button></form></>}
        {section === 'Account' && <dl className="grid gap-6 sm:grid-cols-2"><div><dt>Email</dt><dd className="break-all">{profile.email}</dd></div><div><dt>Fixed role</dt><dd>{profile.role.replaceAll('_',' ')}</dd></div>{profile.organizationName && <div><dt>Store membership</dt><dd>{profile.organizationName}</dd></div>}<div><dt>Account created</dt><dd>{date(profile.createdAt)}</dd></div><div><dt>Permissions</dt><dd className="mt-2 text-sm text-text-secondary"><details><summary className="cursor-pointer">View assigned permissions</summary><ul className="mt-3 grid gap-2">{profile.permissions.map(permission => <li className="break-words" key={permission}>{permission}</li>)}</ul></details></dd></div></dl>}
        {section === 'Security' && <div className="mx-auto grid w-full max-w-xl gap-6">
          <form className="grid gap-4" onSubmit={event => { event.preventDefault(); const form = event.currentTarget; const data = new FormData(form); promptVerification({ title: 'Change password', run: async client => { const result = await client.changeAccountPassword({ accountPortal, accountPasswordChange: { password: String(data.get('new_password')), passwordConfirmation: String(data.get('password_confirmation')) } }); form.reset(); if (result.data.signInRequired) window.location.assign(loginPath) }, success: 'Password changed.', reload: false }) }}><h3 className="text-lg font-semibold">Change password</h3><Field label="New password" name="new_password" type="password" autoComplete="new-password" minLength={14} required /><Field label="Confirm new password" name="password_confirmation" type="password" autoComplete="new-password" minLength={14} required /><p>Changing your password signs out your web sessions.</p><Button type="submit" disabled={busy}>Change password</Button></form>
          <form className="grid gap-4 border-t border-border-default pt-6" onSubmit={event => { event.preventDefault(); const email = String(new FormData(event.currentTarget).get('email')); promptVerification({ title: 'Change primary email', run: async client => { setEmailChange((await client.startAccountEmailChange({ accountPortal, accountEmailChange: { email } })).data) }, success: 'Verification sent to the new email.', reload: false }) }}><h3 className="text-lg font-semibold">Change primary email</h3><Field label="New email" name="email" type="email" required /><Button type="submit" disabled={busy}>Send verification</Button></form>
          {emailChange && <form className="grid gap-4" onSubmit={event => submit(event, data => act(async client => { await client.confirmAccountEmailChange({accountPortal,accountCodeConfirmation:{id:emailChange.id,code:String(data.get('email_code'))}}); window.location.assign(loginPath) }, 'Email changed.', false))}><p>Expires {date(emailChange.expiresAt)}. Completing this change signs out all sessions.</p><Field label="New-email verification code" name="email_code" inputMode="numeric" pattern="[0-9]{6}" required /><Button type="submit" disabled={busy}>Confirm email change</Button></form>}
          {totp && <div className="grid gap-4 border-t border-border-default pt-6"><h3 className="text-lg font-semibold">Authenticator and recovery codes</h3><p>Your authenticator remains mandatory. Replacement keeps your existing factor active until the new code is confirmed.</p><Button variant="secondary" disabled={busy} onClick={() => promptVerification({ title: 'Replace authenticator', run: async client => { setFactor((await client.startAccountFactorReplacement({ accountPortal })).data) }, success: 'Scan the new authenticator setup.', reload: false })}>Replace authenticator</Button><Button variant="secondary" disabled={busy} onClick={() => { if (window.confirm('Replace all recovery codes? Previous codes will stop working.')) promptVerification({ title: 'Replace recovery codes', run: async client => { setCodes((await client.replaceAccountRecoveryCodes({ accountPortal })).data.recoveryCodes) }, success: 'Save these codes securely. They are shown once.', reload: false }) }}>Replace recovery codes</Button></div>}
          {factor && <form className="grid gap-4" onSubmit={event => submit(event, data => act(async client => { const result=await client.confirmAccountFactorReplacement({accountPortal,accountCodeConfirmation:{id:factor.id,code:String(data.get('factor_code'))}}); setFactor(null);setCodes(result.data.recoveryCodes);setSignInAfterCodes(true) }, 'Authenticator replaced. Save the new recovery codes, then sign in.', false))}>{renderQr(factor.provisioningUri)}<p className="break-all">Manual setup key: {factor.secret}</p><p>Expires {date(factor.expiresAt)}</p><Field label="New authenticator code" name="factor_code" inputMode="numeric" pattern="[0-9]{6}" required /><Button type="submit" disabled={busy}>Confirm replacement and sign out</Button></form>}
          {codes.length > 0 && <section aria-label="One-time recovery codes"><h3 className="text-lg font-semibold">Save your recovery codes</h3><ul className="my-4 grid gap-2">{codes.map(code => <li key={code}>{code}</li>)}</ul><Button onClick={() => {setCodes([]);if(signInAfterCodes)window.location.assign(loginPath)}}>I saved my codes</Button></section>}
          <div className="grid gap-3 border-t border-border-default pt-6"><h3 className="text-base font-semibold">Other protected settings</h3><p className="text-sm text-text-secondary">Protected store settings require a recent security check.</p><Button className="justify-self-start" variant="secondary" disabled={busy} onClick={() => promptVerification({ title: 'other protected settings', run: async () => {}, success: 'Security verification is valid for 15 minutes.', reload: false })}>Verify for other settings</Button></div>
        </div>}
        {section === 'Sessions' && <><p className="mb-4">Times are shown in Asia/Manila. Revocation immediately removes backend access.</p>{sessions.length === 0 && <p>No active sessions.</p>}<ul className="divide-y divide-border-default">{sessions.map(session => <li key={session.id} className="flex flex-wrap items-center justify-between gap-4 py-5"><div><h3 className="font-semibold">{session.description}{session.current ? ' · Current session' : ''}</h3><p>Signed in {date(session.createdAt)}</p><p>Last active {date(session.lastActiveAt)}</p></div><Button variant="secondary" disabled={busy} onClick={() => {if(window.confirm('Sign out this session?')) void act(async client => {await client.revokeAccountSession({accountPortal,sessionId:session.id});if(session.current)window.location.assign(loginPath)},'Session revoked.')}}>Revoke session</Button></li>)}</ul><Button variant="secondary" disabled={busy} onClick={() => {if(window.confirm('Sign out all other sessions?')) void act(client => client.revokeAccountSessions({accountPortal,accountSessionRevocation:{scope:'OTHERS'}}),'Other sessions signed out.')}}>Sign out other sessions</Button></>}
        {section === 'Agreements' && <div className="grid gap-6"><p className="text-sm leading-6 text-text-secondary">Review the published terms for your account. Acceptance is recorded separately for each version.</p>{agreements.length === 0 && <p>No agreements are available.</p>}{agreements.map(agreement => <section key={agreement.id} className="overflow-hidden rounded-control border border-border-default"><header className="flex flex-wrap items-start justify-between gap-4 border-b border-border-default bg-surface-canvas p-5"><div className="flex items-start gap-3"><FileCheck2 className="mt-1 shrink-0 text-text-secondary" size={20} aria-hidden="true" /><div><h3 className="text-lg font-semibold">{agreement.title}</h3><p className="mt-1 text-xs text-text-secondary">Version {agreement.version}</p></div></div><span className="rounded-pill border border-border-default bg-surface-primary px-3 py-1 text-xs font-semibold">{agreement.acceptedAt ? 'Accepted' : agreement.requiresAcceptance ? 'Acceptance required' : 'Not yet accepted'}</span></header><div className="p-5 sm:p-6">{agreement.acceptedAt && <p className="mb-4 text-xs text-text-secondary">Accepted {date(agreement.acceptedAt)}</p>}{agreement.contentAvailable ? <><div className="whitespace-pre-wrap break-words text-sm leading-7 text-text-strong">{agreement.content}</div>{!agreement.acceptedAt && <div className="mt-6 border-t border-border-default pt-5"><Button disabled={busy} onClick={() => void act(client=>client.acceptAccountAgreements({accountPortal,accountAgreementAcceptance:{versionIds:[agreement.id]}}),'Agreement recorded.')}>{agreement.code === 'PRIVACY_NOTICE' ? 'Acknowledge Privacy Notice' : 'Accept this version'}</Button></div>}</> : <p className="text-sm leading-6 text-text-secondary">Approved agreement text is not available yet. Contact support for the published copy.</p>}</div></section>)}</div>}

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
        {(section==='Sessions'||section==='Admin accounts')&&lastPage>1&&<div className="mt-6 flex items-center gap-4"><Button variant="secondary" disabled={busy||page<=1} onClick={()=>setPage(page-1)}>Previous</Button><span>Page {page} of {lastPage}</span><Button variant="secondary" disabled={busy||page>=lastPage} onClick={()=>setPage(page+1)}>Next</Button></div>}
        {embedded && section === 'Sessions' && <Button className="mt-6" variant="secondary" disabled={busy || !profile} onClick={() => window.confirm('Sign out every device, including this one?') && void act(async client => { await client.revokeAccountSessions({ accountPortal, accountSessionRevocation: { scope: 'ALL' } }); clearWebSessionTransport(basePath); window.location.assign(loginPath) }, 'Signed out.', false)}>Sign out all devices</Button>}
        <div className={`mt-6${section === 'Security' ? ' mx-auto w-full max-w-xl' : ''}`}><Button variant="secondary" disabled={busy} onClick={()=>void load()}>{busy?'Updating…':'Refresh'}</Button></div>
      </section></div></>}
    {pendingSecurityAction && <AccountVerificationDialog api={api} portal={accountPortal} title={`Confirm ${pendingSecurityAction.title.toLowerCase()}`} explainError={errorText} onClose={() => setPendingSecurityAction(null)} onVerified={async () => { const action = pendingSecurityAction; setPendingSecurityAction(null); await act(action.run, action.success, action.reload) }} />}

  </div>
}
