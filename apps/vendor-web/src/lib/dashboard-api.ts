import { VendorDashboardApi, type VendorDashboardInsights } from '@materyalph/api-client-ts'
import { createWebApiConfiguration } from '@materyalph/web-ui'
import { apiDateFilters, type DateFilters } from './date-filters'

export type { VendorDashboardInsights }
export type DashboardPeriod = 7 | 30 | 90
export const DASHBOARD_PERIODS: DashboardPeriod[] = [7, 30, 90]

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'
const api = () => new VendorDashboardApi(createWebApiConfiguration(basePath, { refreshSession: true }))

/** The role-scoped dashboard bundle; sections the member's role cannot see arrive as null. */
export async function getVendorDashboardInsights(period: DashboardPeriod | DateFilters = {}): Promise<VendorDashboardInsights> {
  return (await api().getVendorDashboardInsights(typeof period === 'number' ? { days: period } : apiDateFilters(period))).data
}
