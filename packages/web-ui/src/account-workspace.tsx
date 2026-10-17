import { PageHeader, FilterTabs } from './page-patterns'
import { CalendarDays, Clock, FileCheck2, ImagePlus, Info, KeyRound, Laptop, LogOut, Mail, Send, ShieldCheck, Store, type LucideIcon } from 'lucide-react'
import { useCallback, useEffect, useRef, useState, type FormEvent, type ReactNode } from 'react'
import { AccountsApi, ResponseError, type AccountProfile, type AccountSession, type AccountAgreement, type AccountRole, type AccountAdministrator } from '@materyalph/api-client-ts'
import { AccountVerificationDialog } from './account-verification-dialog'
import { AccountAvatar } from './account-avatar'
import { Button } from './button'
import { Field } from './field'
import { Select } from './filter-controls'
import { StatusBadge } from './portal-shell'
import { AuthenticatorCodeField } from './authenticator-code-field'
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
      <section aria-busy={busy} className="min-w-0 rounded-surface border border-border-default bg-surface-primary p-5 sm:p-8"><h2 className="mb-6 border-b border-border-default pb-5 text-xl font-semibold">{section}</h2>
        {section === 'Profile' && <div className="grid gap-8">
          <div className="flex flex-col gap-5 rounded-control border border-border-default bg-surface-canvas p-5 sm:flex-row sm:items-center sm:gap-6 sm:p-6">
            <AccountAvatar portal={accountPortal} basePath={basePath} avatarUrl={profile.avatarUrl} fullName={profile.fullName} alt="Your personal profile" className="grid h-24 w-24 shrink-0 place-items-center overflow-hidden rounded-full bg-brand-orange-100 text-3xl font-semibold uppercase text-action-primary ring-4 ring-surface-primary" />
            <div className="min-w-0 flex-1">
              <p className="truncate text-lg font-semibold">{profile.fullName}</p>
              <p className="mt-1 flex flex-wrap items-center gap-x-3 gap-y-2 text-sm text-text-secondary"><span className="break-all">{profile.email}</span><span className="rounded-pill border border-border-default bg-surface-primary px-2.5 py-0.5 text-xs font-semibold uppercase tracking-wide text-text-strong">{profile.role.replaceAll('_', ' ')}</span></p>
              <h3 className="mt-4 text-sm font-semibold">Profile picture</h3>
              <p className="mt-1 max-w-lg text-sm leading-6 text-text-secondary">Personal account photo, separate from your store logo. JPEG, PNG or WebP up to 2 MB. The image is security-scanned and cropped to a square.</p>
              <label className={`mt-3 inline-flex min-h-12 items-center rounded-control border border-border-default bg-surface-primary px-4 text-sm font-semibold transition-colors duration-150 focus-within:outline-2 focus-within:outline-offset-2 focus-within:outline-focus-ring motion-reduce:transition-none sm:min-h-11 ${busy ? 'cursor-not-allowed opacity-50' : 'cursor-pointer hover:border-brand-orange-300 hover:bg-surface-canvas'}`}><ImagePlus size={18} className="mr-2" aria-hidden="true" />{busy ? 'Processing…' : profile.avatarUrl ? 'Change profile picture' : 'Upload profile picture'}<input type="file" className="sr-only" accept="image/jpeg,image/png,image/webp" disabled={busy} onChange={event => { const file = event.target.files?.[0]; event.target.value = ''; if (!file) return; if (file.size > 2 * 1024 * 1024 || !['image/jpeg', 'image/png', 'image/webp'].includes(file.type)) { setMessage({ error: true, text: 'Choose a JPEG, PNG or WebP image up to 2 MB.' }); return } void act(client => client.uploadAccountPhoto({ webAccountPortal: accountPortal, photo: file, lockVersion: profile.lockVersion }), 'Profile picture saved.') }} /></label>
            </div>
          </div>
          <SecuritySetting title="Personal details" description="Your full name as it appears on your account.">
            <form className="grid gap-5" onSubmit={event => submit(event, data => act(client => client.updateAccountProfile({ accountPortal, accountProfileUpdate: { fullName: String(data.get('full_name')), lockVersion: profile.lockVersion } }), 'Profile saved.'))}>
              <Field key={profile.lockVersion} label="Full name" name="full_name" defaultValue={profile.fullName} required maxLength={160} />
              <div className="flex flex-col gap-3 sm:flex-row"><Button type="submit" disabled={busy}>Save profile</Button><Button variant="secondary" disabled={busy} onClick={() => void load()}>{busy ? 'Updating…' : 'Refresh'}</Button></div>
            </form>
          </SecuritySetting>
        </div>}
        {section === 'Account' && <dl className="grid gap-4 sm:grid-cols-2">
          <AccountDetail icon={Mail} label="Email"><span className="break-all">{profile.email}</span></AccountDetail>
          <AccountDetail icon={ShieldCheck} label="Fixed role"><span className="rounded-pill border border-border-default bg-surface-primary px-2.5 py-0.5 text-xs font-semibold uppercase tracking-wide">{profile.role.replaceAll('_', ' ')}</span></AccountDetail>
          {profile.organizationName && <AccountDetail icon={Store} label="Store membership">{profile.organizationName}</AccountDetail>}
          <AccountDetail icon={CalendarDays} label="Account created">{date(profile.createdAt)}</AccountDetail>
          <AccountDetail icon={KeyRound} label="Permissions" className="sm:col-span-2"><details className="group"><summary className="inline-flex min-h-11 cursor-pointer items-center text-sm font-semibold text-action-primary">View assigned permissions ({profile.permissions.length})</summary><ul className="mt-2 flex flex-wrap gap-2">{profile.permissions.map(permission => <li className="break-all rounded-pill border border-border-default bg-surface-primary px-3 py-1 text-xs font-normal text-text-secondary" key={permission}>{permission}</li>)}</ul></details></AccountDetail>
        </dl>}
        {section === 'Security' && <div className="grid gap-6">
          <SecuritySetting title="Change password" description="Changing your password signs out your web sessions.">
            <form className="grid gap-4" onSubmit={event => { event.preventDefault(); const form = event.currentTarget; const data = new FormData(form); promptVerification({ title: 'Change password', run: async client => { const result = await client.changeAccountPassword({ accountPortal, accountPasswordChange: { password: String(data.get('new_password')), passwordConfirmation: String(data.get('password_confirmation')) } }); form.reset(); if (result.data.signInRequired) window.location.assign(loginPath) }, success: 'Password changed.', reload: false }) }}>
              <Field label="New password" name="new_password" type="password" autoComplete="new-password" minLength={14} required />
              <Field label="Confirm new password" name="password_confirmation" type="password" autoComplete="new-password" minLength={14} required />
              <Button className="w-full sm:w-auto sm:justify-self-start" type="submit" disabled={busy}>Change password</Button>
            </form>
          </SecuritySetting>
          <SecuritySetting title="Change primary email" description="Verify your new email to complete the change. This signs out all sessions.">
            <form className="grid gap-4" onSubmit={event => { event.preventDefault(); const email = String(new FormData(event.currentTarget).get('email')); promptVerification({ title: 'Change primary email', run: async client => { setEmailChange((await client.startAccountEmailChange({ accountPortal, accountEmailChange: { email } })).data) }, success: 'Verification sent to the new email.', reload: false }) }}>
              <Field label="New email" name="email" type="email" required />
              <Button className="w-full sm:w-auto sm:justify-self-start" type="submit" disabled={busy}>Send verification</Button>
            </form>
            {emailChange && <form className="grid gap-4 border-t border-border-default pt-4" onSubmit={event => submit(event, data => act(async client => { await client.confirmAccountEmailChange({accountPortal,accountCodeConfirmation:{id:emailChange.id,code:String(data.get('email_code'))}}); window.location.assign(loginPath) }, 'Email changed.', false))}><p className="text-sm leading-6 text-text-secondary">Expires {date(emailChange.expiresAt)}. Completing this change signs out all sessions.</p><Field label="New-email verification code" name="email_code" inputMode="numeric" pattern="[0-9]{6}" required /><Button className="w-full sm:w-auto sm:justify-self-start" type="submit" disabled={busy}>Confirm email change</Button></form>}
          </SecuritySetting>
          {(totp || factor || codes.length > 0) && <SecuritySetting title="Authenticator and recovery codes" description="Your authenticator remains mandatory. Replacement keeps your existing factor active until the new code is confirmed.">
            {totp && <div className="flex flex-col gap-3 sm:flex-row sm:flex-wrap">
              <Button variant="secondary" disabled={busy} onClick={() => promptVerification({ title: 'Replace authenticator', run: async client => { setFactor((await client.startAccountFactorReplacement({ accountPortal })).data) }, success: 'Scan the new authenticator setup.', reload: false })}>Replace authenticator</Button>
              <Button variant="secondary" disabled={busy} onClick={() => { if (window.confirm('Replace all recovery codes? Previous codes will stop working.')) promptVerification({ title: 'Replace recovery codes', run: async client => { setCodes((await client.replaceAccountRecoveryCodes({ accountPortal })).data.recoveryCodes) }, success: 'Save these codes securely. They are shown once.', reload: false }) }}>Replace recovery codes</Button>
            </div>}
            {factor && <form className="grid gap-4 border-t border-border-default pt-4" onSubmit={event => submit(event, data => act(async client => { const result=await client.confirmAccountFactorReplacement({accountPortal,accountCodeConfirmation:{id:factor.id,code:String(data.get('factor_code'))}}); setFactor(null);setCodes(result.data.recoveryCodes);setSignInAfterCodes(true) }, 'Authenticator replaced. Save the new recovery codes, then sign in.', false))}>{renderQr(factor.provisioningUri)}<p className="break-all">Manual setup key: {factor.secret}</p><p>Expires {date(factor.expiresAt)}</p><AuthenticatorCodeField label="New authenticator code" name="factor_code" disabled={busy} required /><Button className="w-full sm:w-auto sm:justify-self-start" type="submit" disabled={busy}>Confirm replacement and sign out</Button></form>}
            {codes.length > 0 && <section aria-label="One-time recovery codes" className="border-t border-border-default pt-4"><h3 className="text-lg font-semibold">Save your recovery codes</h3><ul className="my-4 grid gap-2 sm:grid-cols-2">{codes.map(code => <li className="break-all font-mono" key={code}>{code}</li>)}</ul><Button className="w-full sm:w-auto" onClick={() => {setCodes([]);if(signInAfterCodes)window.location.assign(loginPath)}}>I saved my codes</Button></section>}
          </SecuritySetting>}
        </div>}
        {section === 'Sessions' && <div className="grid gap-5">
          <p className="flex items-start gap-3 rounded-control border border-border-default bg-surface-canvas p-4 text-sm leading-6 text-text-secondary"><Info size={18} className="mt-0.5 shrink-0" aria-hidden="true" /><span>Times are shown in Asia/Manila. Revocation immediately removes backend access.</span></p>
          {sessions.length === 0 && <p className="rounded-control border border-dashed border-border-default p-6 text-center text-sm text-text-secondary">No active sessions.</p>}
          <ul className="grid gap-3">{sessions.map(session => <li key={session.id} className="flex flex-col gap-4 rounded-control border border-border-default p-4 sm:flex-row sm:items-center sm:justify-between sm:p-5">
            <div className="flex min-w-0 items-start gap-4">
              <span className="grid h-11 w-11 shrink-0 place-items-center rounded-full bg-brand-orange-100 text-action-primary"><Laptop size={20} aria-hidden="true" /></span>
              <div className="min-w-0">
                <h3 className="flex flex-wrap items-center gap-x-3 gap-y-1 font-semibold">{session.description}{session.current && <span className="rounded-pill bg-brand-orange-100 px-2.5 py-0.5 text-xs font-semibold text-action-primary">Current session</span>}</h3>
                <dl className="mt-2 grid gap-1 text-sm text-text-secondary sm:grid-cols-[auto_1fr] sm:gap-x-4"><dt className="font-medium text-text-strong">Signed in</dt><dd>{date(session.createdAt)}</dd><dt className="font-medium text-text-strong">Last active</dt><dd>{date(session.lastActiveAt)}</dd></dl>
              </div>
            </div>
            <Button className="w-full sm:w-auto" variant="secondary" disabled={busy} onClick={() => {if(window.confirm('Sign out this session?')) void act(async client => {await client.revokeAccountSession({accountPortal,sessionId:session.id});if(session.current)window.location.assign(loginPath)},'Session revoked.')}}>Revoke session</Button>
          </li>)}</ul>
        </div>}
        {section === 'Agreements' && <div className="grid gap-6"><p className="text-sm leading-6 text-text-secondary">Review the published terms for your account. Acceptance is recorded separately for each version.</p>{agreements.length === 0 && <p>No agreements are available.</p>}{agreements.map(agreement => <section key={agreement.id} className="overflow-hidden rounded-control border border-border-default"><header className="flex flex-wrap items-start justify-between gap-4 border-b border-border-default bg-surface-canvas p-5"><div className="flex items-start gap-3"><FileCheck2 className="mt-1 shrink-0 text-text-secondary" size={20} aria-hidden="true" /><div><h3 className="text-lg font-semibold">{agreement.title}</h3><p className="mt-1 text-xs text-text-secondary">Version {agreement.version}</p></div></div><span className="rounded-pill border border-border-default bg-surface-primary px-3 py-1 text-xs font-semibold">{agreement.acceptedAt ? 'Accepted' : agreement.requiresAcceptance ? 'Acceptance required' : 'Not yet accepted'}</span></header><div className="p-5 sm:p-6">{agreement.acceptedAt && <p className="mb-4 text-xs text-text-secondary">Accepted {date(agreement.acceptedAt)}</p>}{agreement.contentAvailable ? <><div className="whitespace-pre-wrap break-words text-sm leading-7 text-text-strong">{agreement.content}</div>{!agreement.acceptedAt && <div className="mt-6 border-t border-border-default pt-5"><Button disabled={busy} onClick={() => void act(client=>client.acceptAccountAgreements({accountPortal,accountAgreementAcceptance:{versionIds:[agreement.id]}}),'Agreement recorded.')}>{agreement.code === 'PRIVACY_NOTICE' ? 'Acknowledge Privacy Notice' : 'Accept this version'}</Button></div>}</> : <p className="text-sm leading-6 text-text-secondary">Approved agreement text is not available yet. Contact support for the published copy.</p>}</div></section>)}</div>}

        {section === 'Admin accounts' && accountPortal === 'admin' && profile.permissions.includes('admin.manage_accounts') && <div className="grid gap-5">
          <p className="flex items-start gap-3 rounded-control border border-border-default bg-surface-canvas p-4 text-sm leading-6 text-text-secondary"><Info size={18} className="mt-0.5 shrink-0" aria-hidden="true" /><span>Verify your identity in Security before changing staff access. Changes preserve historical attribution and sign out the affected account.</span></p>
          {administrators.length === 0 && <p className="rounded-control border border-dashed border-border-default p-6 text-center text-sm text-text-secondary">No Admin accounts are available.</p>}
          <ul className="grid gap-3">{administrators.map(admin => <li key={admin.id} className="rounded-control border border-border-default p-4 sm:p-5">
            <div className="flex min-w-0 flex-wrap items-center gap-4">
              <span className="grid h-11 w-11 shrink-0 place-items-center rounded-full bg-brand-orange-100 text-sm font-semibold uppercase text-action-primary" aria-hidden="true">{admin.name.trim().split(/\s+/).slice(0, 2).map(part => part[0]).join('')}</span>
              <div className="min-w-0 flex-1">
                <h3 className="flex flex-wrap items-center gap-x-2 gap-y-1 font-semibold"><span className="break-words">{admin.name}</span>{admin.id === profile.id && <span className="rounded-pill bg-brand-orange-100 px-2.5 py-0.5 text-xs font-semibold text-action-primary">You</span>}</h3>
                <p className="mt-1 text-xs font-semibold uppercase tracking-wide text-text-secondary">{admin.role.replaceAll('_', ' ')}</p>
              </div>
              <StatusBadge label={admin.status.replaceAll('_', ' ')} tone={admin.status === 'ACTIVE' ? 'success' : admin.status === 'SUSPENDED' ? 'warning' : admin.status === 'DEACTIVATED' ? 'error' : 'neutral'} />
            </div>
            {admin.id !== profile.id && admin.role !== 'ADMIN_SUPERADMIN' && <details className="mt-4 border-t border-border-default pt-2">
              <summary className="inline-flex min-h-11 cursor-pointer items-center text-sm font-semibold text-action-primary">Manage access</summary>
              <form className="mt-3 grid gap-5" onSubmit={event => submit(event, data => {
                if (!window.confirm('Change this Admin account and sign out its sessions?')) return Promise.resolve()
                return act(client => client.changeAccountAdministrator({ accountPortal: 'admin', publicId: admin.id, accountAdminChange: { lockVersion: admin.lockVersion, reason: String(data.get('reason')), status: String(data.get('status')) as 'ACTIVE' | 'SUSPENDED' | 'DEACTIVATED', roleId: String(data.get('role_id')) } }), 'Admin access updated.')
              })}>
                <div className="grid gap-5 sm:grid-cols-2">
                  <Select label="Role" name="role_id" defaultValue={admin.roleId} required>{roles.map(role => <option value={role.id} key={role.id}>{role.name}</option>)}</Select>
                  <Select label="Access status" name="status" defaultValue={admin.status} required>{!['ACTIVE','SUSPENDED','DEACTIVATED'].includes(admin.status) && <option value="" disabled>Setup pending</option>}<option value="ACTIVE">Active</option><option value="SUSPENDED">Suspended</option><option value="DEACTIVATED">Deactivated</option></Select>
                </div>
                <Field label="Reason for access change" name="reason" required minLength={3} maxLength={500} />
                <div><Button type="submit" disabled={busy}>Update Admin access</Button></div>
              </form>
            </details>}
          </li>)}</ul>
        </div>}
        {section === 'Admin invitations' && accountPortal === 'admin' && profile.permissions.includes('admin.invite') && <div className="grid gap-8">
          <div className="rounded-control border border-border-default bg-surface-canvas p-5 sm:p-6">
            <h3 className="text-sm font-semibold">Before you invite</h3>
            <ul className="mt-3 grid gap-3 text-sm leading-6 text-text-secondary sm:grid-cols-3">
              <li className="flex items-start gap-3"><ShieldCheck size={18} className="mt-1 shrink-0 text-action-primary" aria-hidden="true" /><span>Verify your identity in Security first.</span></li>
              <li className="flex items-start gap-3"><Clock size={18} className="mt-1 shrink-0 text-action-primary" aria-hidden="true" /><span>Invitations expire after 24 hours.</span></li>
              <li className="flex items-start gap-3"><KeyRound size={18} className="mt-1 shrink-0 text-action-primary" aria-hidden="true" /><span>TOTP is required before protected access.</span></li>
            </ul>
          </div>
          <SecuritySetting title="Invite a staff member" description="Eligible recipients receive a one-time setup link at the email you enter.">
            <form className="grid gap-5" onChange={() => setInvitationKey(crypto.randomUUID())} onSubmit={event=>submit(event,data=>act(client=>client.inviteAccountAdmin({ accountPortal: 'admin',idempotencyKey:invitationKey,accountAdminInvitation:{email:String(data.get('invite_email')),roleId:String(data.get('role_id'))}}),'Invitation request received. Eligible recipients receive a one-time setup link.'))}>
              <Field label="Staff email" name="invite_email" type="email" autoComplete="off" required />
              <Select label="Fixed Admin role" name="role_id" required defaultValue=""><option value="">Choose a role</option>{roles.map(role=><option key={role.id} value={role.id}>{role.name}</option>)}</Select>
              <div className="flex flex-col gap-3 sm:flex-row"><Button type="submit" disabled={busy}><Send size={18} aria-hidden="true" />Send invitation</Button><Button variant="secondary" disabled={busy} onClick={() => void load()}>{busy ? 'Updating…' : 'Refresh'}</Button></div>
            </form>
          </SecuritySetting>
        </div>}
        {(section==='Sessions'||section==='Admin accounts')&&lastPage>1&&<div className="mt-6 flex items-center gap-4"><Button variant="secondary" disabled={busy||page<=1} onClick={()=>setPage(page-1)}>Previous</Button><span>Page {page} of {lastPage}</span><Button variant="secondary" disabled={busy||page>=lastPage} onClick={()=>setPage(page+1)}>Next</Button></div>}
        {section === 'Sessions' && <div className="mt-6 flex flex-col gap-3 border-t border-border-default pt-5 sm:flex-row sm:flex-wrap">
          <Button variant="secondary" disabled={busy} onClick={() => {if(window.confirm('Sign out all other sessions?')) void act(client => client.revokeAccountSessions({accountPortal,accountSessionRevocation:{scope:'OTHERS'}}),'Other sessions signed out.')}}>Sign out other sessions</Button>
          {embedded && <Button variant="secondary" disabled={busy || !profile} onClick={() => window.confirm('Sign out every device, including this one?') && void act(async client => { await client.revokeAccountSessions({ accountPortal, accountSessionRevocation: { scope: 'ALL' } }); clearWebSessionTransport(basePath); window.location.assign(loginPath) }, 'Signed out.', false)}>Sign out all devices</Button>}
          <Button className="sm:ml-auto" variant="quiet" disabled={busy} onClick={()=>void load()}>{busy?'Updating…':'Refresh'}</Button>
        </div>}
        {section !== 'Profile' && section !== 'Sessions' && section !== 'Admin invitations' && <div className={`mt-6${section === 'Security' ? ' flex justify-end border-t border-border-default pt-5' : ''}`}><Button variant="secondary" disabled={busy} onClick={()=>void load()}>{busy?'Updating…':'Refresh'}</Button></div>}
      </section></div></>}
    {pendingSecurityAction && <AccountVerificationDialog api={api} portal={accountPortal} title={`Confirm ${pendingSecurityAction.title.toLowerCase()}`} explainError={errorText} onClose={() => setPendingSecurityAction(null)} onVerified={async () => { const action = pendingSecurityAction; setPendingSecurityAction(null); await act(action.run, action.success, action.reload) }} />}

  </div>
}

function SecuritySetting({ title, description, children }: { title: string; description: string; children: ReactNode }) {
  return <div className="grid min-w-0 gap-4 border-t border-border-default pt-6 first:border-t-0 first:pt-0 md:grid-cols-[minmax(0,1fr)_minmax(0,1.5fr)] md:gap-8">
    <div className="min-w-0"><h3 className="text-lg font-semibold">{title}</h3><p className="mt-2 max-w-sm text-sm leading-6 text-text-secondary">{description}</p></div>
    <div className="grid min-w-0 content-start gap-4">{children}</div>
  </div>
}

function AccountDetail({ icon: Icon, label, className = '', children }: { icon: LucideIcon; label: string; className?: string; children: ReactNode }) {
  return <div className={`flex min-w-0 items-start gap-3 rounded-control border border-border-default bg-surface-canvas p-4 ${className}`}>
    <span className="grid h-10 w-10 shrink-0 place-items-center rounded-full bg-brand-orange-100 text-action-primary"><Icon size={18} aria-hidden="true" /></span>
    <div className="min-w-0 flex-1"><dt className="text-xs font-semibold uppercase tracking-wide text-text-secondary">{label}</dt><dd className="mt-1 break-words font-medium text-text-strong">{children}</dd></div>
  </div>
}
