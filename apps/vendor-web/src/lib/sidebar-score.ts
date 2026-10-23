import { usePortalResource, type PortalAccountScore } from '@materyalph/web-ui'
import { getStorePerformance, type StorePerformance } from './trust-api'

const UNPUBLISHED = 'New Vendor — Building Track Record'

/** The sidebar shows the published VPS only; below its sample gates it shows the workflow's New Vendor label, never the internal ranking default. */
export function sidebarScore(performance: StorePerformance): PortalAccountScore {
  const vps = performance.calculated ? performance.scores.find(score => score.key === 'VPS') : undefined
  return { name: 'Vendor Performance Score', value: vps?.published && vps.value ? vps.value : null, unpublishedLabel: UNPUBLISHED }
}

/** Read with the Store Performance grant (Owner, Store Manager) once the store is active; other roles get no score and make no request. */
export function useSidebarScore(permissions: string[] | undefined, storeActive: boolean): PortalAccountScore | null {
  const enabled = storeActive && Boolean(permissions?.includes('scores.view_store'))
  const { data } = usePortalResource('vendor-sidebar-performance', getStorePerformance, enabled)
  return enabled && data ? sidebarScore(data) : null
}
