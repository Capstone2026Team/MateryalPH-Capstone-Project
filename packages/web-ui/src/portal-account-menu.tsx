import { useEffect, useRef, useState, type MouseEvent } from 'react'
import { AccountsApi, AuthenticationApi, type AccountProfile } from '@materyalph/api-client-ts'
import { clearWebSessionTransport, createWebApiConfiguration } from './web-api-session'
import { ChevronDown, FileCheck2, LogOut, MonitorSmartphone, Settings, ShieldCheck, UserRound } from 'lucide-react'

export function PortalAccountMenu({ portal, basePath, onNavigate, onSignOut, avatarUrl, onProfileChange }: { portal: 'admin' | 'vendors'; basePath: string; onNavigate?: ((href: string) => void) | undefined; onSignOut?: (() => Promise<void>) | undefined; avatarUrl?: string; onProfileChange?: (profile: AccountProfile | null) => void }) {
  const [profile, setProfile] = useState<AccountProfile | null>(null)
  const [open, setOpen] = useState(false)
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState('')
  const [imageFailed, setImageFailed] = useState(false)
  const root = useRef<HTMLDivElement>(null)
  const trigger = useRef<HTMLButtonElement>(null)
  const href = portal === 'admin' ? '/workspace' : '/settings'
  useEffect(() => {
    let active = true
    onProfileChange?.(null)
    const refresh = () => { void new AccountsApi(createWebApiConfiguration(basePath, { refreshSession: true })).getAccountProfile({ accountPortal: portal }).then(result => { if (active) { setProfile(result.data); onProfileChange?.(result.data) } }).catch(() => {}) }
    refresh()
    window.addEventListener('materyalph:profile-updated', refresh)
    return () => { active = false; window.removeEventListener('materyalph:profile-updated', refresh) }
  }, [basePath, portal, onProfileChange])
  useEffect(() => {
    function outside(event: PointerEvent) { if (!root.current?.contains(event.target as Node)) setOpen(false) }
    document.addEventListener('pointerdown', outside)
    return () => document.removeEventListener('pointerdown', outside)
  }, [])
  function follow(event: MouseEvent<HTMLAnchorElement>, destination: string) {
    setOpen(false)
    if (onNavigate && destination.split('#')[0] !== window.location.pathname && event.button === 0 && !event.ctrlKey && !event.metaKey && !event.shiftKey && !event.altKey) { event.preventDefault(); onNavigate(destination) }
  }
  async function logout() {
    setBusy(true); setError('')
    try {
      if (onSignOut) await onSignOut()
      else { await new AuthenticationApi(createWebApiConfiguration(basePath, { refreshSession: true })).logout(); clearWebSessionTransport(basePath); window.location.assign('/login') }
    } catch { setError('Could not sign out. Please retry.') } finally { setBusy(false) }
  }
  useEffect(() => { setImageFailed(false) }, [avatarUrl, profile?.avatarUrl])
  const initials = profile?.fullName.trim().split(/\s+/).slice(0, 2).map(part => part[0]).join('').toUpperCase() || '…'
  return <div className="relative flex items-center gap-2" ref={root} onKeyDown={event => { if (event.key === 'Escape') { setOpen(false); trigger.current?.focus() } }}>
    <button ref={trigger} type="button" aria-expanded={open} aria-label="Account profile options" className="flex min-h-11 items-center gap-2 rounded-control px-2 text-sm font-semibold hover:bg-surface-canvas" onClick={() => setOpen(!open)}><span className="grid h-8 w-8 place-items-center overflow-hidden rounded-full bg-brand-orange-100 text-xs text-action-primary">{(avatarUrl || profile?.avatarUrl) && !imageFailed ? <img src={avatarUrl || profile?.avatarUrl || undefined} alt="" className="h-full w-full object-cover" onError={() => setImageFailed(true)} /> : initials}</span><span className="hidden max-w-40 truncate sm:inline" title={profile?.fullName}>{profile?.fullName || 'Your profile'}</span><ChevronDown aria-hidden="true" size={16} className={open ? 'rotate-180' : ''} /></button>
    {open && <div className="absolute right-0 top-full z-50 mt-2 w-64 rounded-surface border border-border-default bg-surface-primary p-2 shadow-sm"><div className="border-b border-border-default px-3 py-3"><p className="truncate text-sm font-semibold">{profile?.fullName || 'Personal account'}</p><p className="mt-1 text-xs text-text-secondary">{profile?.role.replaceAll('_', ' ') || 'Account settings'}</p></div>{([{ label: 'Profile', section: 'Profile', Icon: UserRound }, { label: 'Settings', section: 'Account', Icon: Settings }, { label: 'Security', section: 'Security', Icon: ShieldCheck }, { label: 'Sessions / Devices', section: 'Sessions', Icon: MonitorSmartphone }, { label: 'Agreements', section: 'Agreements', Icon: FileCheck2 }]).map(({ label, section, Icon }) => <a key={section} href={`${href}#${section}`} onClick={event => follow(event, `${href}#${section}`)} className="flex min-h-11 items-center gap-3 rounded-control px-3 text-sm hover:bg-surface-canvas"><Icon size={18} strokeWidth={1.75} aria-hidden="true" />{label}</a>)}<button className="flex items-center gap-3 min-h-11 w-full border-t border-border-default px-3 text-left text-sm font-semibold text-action-primary" type="button" disabled={busy} onClick={() => void logout()}><LogOut size={18} aria-hidden="true" />{busy ? 'Signing out…' : 'Sign out'}</button>{error && <p className="px-3 text-sm" role="alert">{error}</p>}</div>}
  </div>
}
