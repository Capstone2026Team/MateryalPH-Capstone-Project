import { createContext, useCallback, useContext, useEffect, useRef, useState, type ReactNode } from 'react'
import { AccountsApi, type AccountProfile } from '@materyalph/api-client-ts'
import { createWebApiConfiguration } from './web-api-session'

// Presentation state belongs to the mounted portal, not each routed page.
// Never use this display identity to authorize actions or select permissions.
export type PortalIdentity = Pick<AccountProfile, 'fullName' | 'role' | 'organizationName' | 'avatarUrl'>
const IdentityContext = createContext<{ profile: PortalIdentity | null; ensureFresh: () => void } | null>(null)

export function PortalIdentityProvider({ portal, basePath, children }: { portal: 'admin' | 'vendors'; basePath: string; children: ReactNode }) {
  const [profile, setProfile] = useState<PortalIdentity | null>(null)
  const refreshIfStale = useRef(() => {})
  const ensureFresh = useCallback(() => refreshIfStale.current(), [])
  useEffect(() => {
    let active = true
    let revision = 0
    let loadedAt = Date.now()
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
    return () => { active = false; window.removeEventListener('focus', ensureFresh); window.removeEventListener('materyalph:profile-updated', refresh) }
  }, [portal, basePath, ensureFresh])
  return <IdentityContext.Provider value={{ profile, ensureFresh }}>{children}</IdentityContext.Provider>
}

export function usePortalIdentity() { return useContext(IdentityContext) }
