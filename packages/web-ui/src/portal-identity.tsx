import { createContext, useCallback, useContext, useEffect, useRef, useState, type ReactNode } from 'react'
import { AccountsApi, type AccountProfile } from '@materyalph/api-client-ts'
import { createWebApiConfiguration } from './web-api-session'
import { StatusMessage } from './status-message'

// Presentation state belongs to the mounted portal, not each routed page.
// Never use this display identity to authorize actions or select permissions.
export type PortalIdentity = Pick<AccountProfile, 'fullName' | 'role' | 'organizationName' | 'avatarUrl'>
const IdentityContext = createContext<{ profile: PortalIdentity | null; ensureFresh: () => void } | null>(null)

export function PortalIdentityProvider({ portal, basePath, children }: { portal: 'admin' | 'vendors'; basePath: string; children: ReactNode }) {
  const [profile, setProfile] = useState<PortalIdentity | null>(null)
  const [expired, setExpired] = useState(false)
  const refreshIfStale = useRef(() => {})
  const ensureFresh = useCallback(() => refreshIfStale.current(), [])
  useEffect(() => {
    let active = true
    let revision = 0
    let loadedAt = Date.now()
    const denied = (event: Event) => {
      if (!(event instanceof CustomEvent) || !(event.detail instanceof Response) || event.detail.status !== 401) return
      revision += 1
      setProfile(null)
      setExpired(true)
    }
    window.addEventListener('materyalph:access-denied', denied)
    const refresh = () => {
      const current = ++revision
      void new AccountsApi(createWebApiConfiguration(basePath, { refreshSession: true })).getAccountProfile({ accountPortal: portal })
        .then(({ data }) => { if (active && current === revision) { loadedAt = Date.now(); setProfile({ fullName: data.fullName, role: data.role, organizationName: data.organizationName, avatarUrl: data.avatarUrl ?? null }) } })
        .catch(() => { if (active && current === revision) setProfile(null) })
    }
    refresh()
    // Renew the five-minute signed avatar on later navigation/focus, not by polling.
    refreshIfStale.current = () => { if (Date.now() - loadedAt >= 240000) { loadedAt = Date.now(); refresh() } }
    window.addEventListener('focus', ensureFresh)
    window.addEventListener('materyalph:profile-updated', refresh)
    return () => { active = false; window.removeEventListener('materyalph:access-denied', denied); window.removeEventListener('focus', ensureFresh); window.removeEventListener('materyalph:profile-updated', refresh) }
  }, [portal, basePath, ensureFresh])
  if (expired) return <main className="mx-auto max-w-xl p-6"><StatusMessage tone="error"><p>Your session has expired. Sign in again to continue.</p><a href="/login" className="mt-3 inline-flex min-h-11 items-center font-semibold underline">Sign in again</a></StatusMessage></main>
  return <IdentityContext.Provider value={{ profile, ensureFresh }}>{children}</IdentityContext.Provider>
}

export function usePortalIdentity() { return useContext(IdentityContext) }
