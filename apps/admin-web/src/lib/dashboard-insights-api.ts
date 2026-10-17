import { AdminDashboardApi, type AdminDashboardInsights } from '@materyalph/api-client-ts'
import { createWebApiConfiguration } from '@materyalph/web-ui'
import { dateQuery, type CalendarRange } from './admin-format'

export type { AdminDashboardInsights }
export type InsightsPeriod = 30 | 90
export type InsightsDataset = 'TEST' | 'DEMO'

const api = () => new AdminDashboardApi(createWebApiConfiguration(import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1', { refreshSession: true }))

/** Permission-scoped insights; a section outside the Admin's role arrives as null. */
export async function getAdminDashboardInsights(days: InsightsPeriod, dataset: InsightsDataset, range?: CalendarRange): Promise<AdminDashboardInsights> {
  return (await api().getAdminDashboardInsights({ ...(range?.from && range.to ? dateQuery(range) : { days }), dataset })).data
}
