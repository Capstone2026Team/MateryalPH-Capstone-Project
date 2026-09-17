import { useEffect, useRef, useState, type MouseEvent } from 'react'
import { AccountsApi, AuthenticationApi, type AccountProfile } from '@materyalph/api-client-ts'
import { clearWebSessionTransport, createWebApiConfiguration } from './web-api-session'

export function PortalAccountMenu({ portal, basePath, onNavigate, onSignOut, avatarUrl }: { portal: 'admin' | 'vendors'; basePath: string; onNavigate?: ((href: string) => void) | undefined; onSignOut?: (() => Promise<void>) | undefined; avatarUrl?: string }) {
  const [profile, setProfile] = useState<AccountProfile | null>(null)
  const [open, setOpen] = useState(false)
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState('')
  const [imageFailed, setImageFailed] = useState(false)
  const root = useRef<HTMLDivElement>(null)
  const trigger = useRef<HTMLButtonElement>(null)
  const href = portal === 'admin' ? '/workspace' : '/account'
  useEffect(() => {
    let active = true
    void new AccountsApi(createWebApiConfiguration(basePath, { refreshSession: true })).getAccountProfile({ accountPortal: portal }).then(result => { if (active) setProfile(result.data) }).catch(() => {})
    return () => { active = false }
  }, [basePath, portal])
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
  const initials = profile?.fullName.trim().split(/\s+/).slice(0, 2).map(part => part[0]).join('').toUpperCase() || '…'
  return <div className="relative flex items-center gap-2" ref={root} onKeyDown={event => { if (event.key === 'Escape') { setOpen(false); trigger.current?.focus() } }}>
    <a className="inline-flex min-h-11 items-center rounded-control px-3 text-sm text-text-secondary hover:bg-surface-canvas" href={href} onClick={event => follow(event, href)}>Settings</a>
    <button ref={trigger} type="button" aria-expanded={open} aria-label="Account profile options" className="flex min-h-11 items-center gap-2 rounded-control px-2 text-sm font-semibold hover:bg-surface-canvas" onClick={() => setOpen(!open)}><span className="grid h-8 w-8 place-items-center overflow-hidden rounded-full bg-brand-orange-100 text-xs text-action-primary">{avatarUrl && !imageFailed ? <img src={avatarUrl} alt="" className="h-full w-full object-cover" onError={() => setImageFailed(true)} /> : initials}</span><span className="hidden sm:inline">Account</span><span aria-hidden="true">⌄</span></button>
    {open && <div className="absolute right-0 top-full z-50 mt-2 w-64 rounded-surface border border-border-default bg-surface-primary p-2 shadow-sm"><div className="border-b border-border-default px-3 py-3"><p className="truncate text-sm font-semibold">{profile?.fullName || 'Personal account'}</p><p className="mt-1 text-xs text-text-secondary">{profile?.role.replaceAll('_', ' ') || 'Account settings'}</p></div>{[['Personal profile', 'Profile'], ['Security', 'Security'], ['Sessions / Devices', 'Sessions'], ['Agreements', 'Agreements']].map(([label, section]) => <a key={section} href={`${href}#${section}`} onClick={event => follow(event, `${href}#${section}`)} className="flex min-h-11 items-center rounded-control px-3 text-sm hover:bg-surface-canvas">{label}</a>)}<button className="min-h-11 w-full border-t border-border-default px-3 text-left text-sm font-semibold text-action-primary" type="button" disabled={busy} onClick={() => void logout()}>{busy ? 'Signing out…' : 'Sign out'}</button>{error && <p className="px-3 text-sm" role="alert">{error}</p>}</div>}
  </div>
}
