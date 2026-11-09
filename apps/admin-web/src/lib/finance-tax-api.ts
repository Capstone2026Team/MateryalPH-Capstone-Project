import { AdminFinanceOperationsApi, ReportingApi, type TaxPackage, type TaxPackageInput, type TaxPackageReview } from '@materyalph/api-client-ts'
import { createWebApiConfiguration } from '@materyalph/web-ui'
import { dateQuery, type CalendarRange } from './admin-format'
import type { Page } from './finance-api'
import { listDirectoryVendors } from './user-directory-api'

export type { TaxPackage, TaxPackageInput, TaxPackageReview }

export const taxBasePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'
const config = () => createWebApiConfiguration(taxBasePath, { refreshSession: true })
const finance = () => new AdminFinanceOperationsApi(config())
const reports = () => new ReportingApi(config())

export async function listTaxVendors(page: number): Promise<Page<{ id: string; name: string }>> {
  const response = await listDirectoryVendors({ page })
  return { items: response.items.map(item => ({ id: item.id, name: item.storeName })), hasMore: response.meta.page < response.meta.lastPage, total: response.meta.total }
}

export async function listTaxPackages(page: number, range: CalendarRange): Promise<Page<TaxPackage>> {
  const response = await reports().listTaxPackages({ page, ...dateQuery(range) })
  return { items: response.data, hasMore: Boolean((response.meta as { has_more?: boolean }).has_more), total: response.data.length }
}

export async function prepareTaxPackage(input: TaxPackageInput, idempotencyKey: string): Promise<TaxPackage> {
  return (await reports().prepareTaxPackage({ taxPackageInput: input, idempotencyKey })).data
}

export async function getTaxPackage(packageId: string): Promise<TaxPackage> {
  return (await reports().getTaxPackage({ packageId })).data
}

export async function reviewTaxPackage(packageId: string, input: TaxPackageReview): Promise<TaxPackage> {
  return (await reports().reviewTaxPackage({ packageId, taxPackageReview: input })).data
}

export async function recordTaxSimulation(packageId: string): Promise<void> {
  await reports().recordTaxSimulation({ packageId })
}

export async function getWithholdingRegister(month: string | undefined, page: number) {
  return finance().getWithholdingRegister({ ...(month ? { month } : {}), page })
}

export async function getWithholdingVendor(vendorId: string, month: string, withholdingEntity: string, page: number) {
  return finance().getWithholdingVendor({ vendorId, month, withholdingEntity: withholdingEntity as 'DEMO_PLATFORM_WITHHOLDER' | 'DEMO_PROVIDER_WITHHOLDER', page })
}
