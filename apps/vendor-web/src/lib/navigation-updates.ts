import { useNavigationUpdates } from '@materyalph/web-ui'

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'

export function useVendorNavigationUpdates(enabled: boolean): Record<string, number> | null {
  return useNavigationUpdates({ basePath, audience: 'vendor', enabled })
}
