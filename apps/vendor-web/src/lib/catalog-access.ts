import { useOnboardingSnapshot } from './vendor-status'

/** Role-derived visibility for My Products pages. The server still authorizes every request. */
export function useCatalogAccess() {
  const { snapshot, loading, error, refresh } = useOnboardingSnapshot()
  const permissions = snapshot?.permissions ?? []
  const activation = String((snapshot?.activation as { status?: unknown } | undefined)?.status ?? 'NOT_READY')
  return { snapshot, loading, error, refresh, canView: permissions.includes('portal.products'), canManage: permissions.includes('catalog.manage'), canSubmitCompliance: permissions.includes('compliance.submit'), canViewInventory: permissions.includes('inventory.view'), active: activation === 'ACTIVE', activation }
}

export function storeName(snapshot: ReturnType<typeof useOnboardingSnapshot>['snapshot']): string {
  const organization = snapshot?.organization as { store_name?: string; storeName?: string } | undefined
  return organization?.storeName ?? organization?.store_name ?? 'Vendor'
}
