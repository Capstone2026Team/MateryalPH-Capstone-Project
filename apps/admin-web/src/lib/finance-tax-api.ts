import { AdminFinanceOperationsApi, ReportingApi, type TaxAdjustment, type TaxAdjustmentPrepareRequest, type TaxAdjustmentReviewRequest, type TaxPackage, type TaxPackageInput, type TaxPackageReview } from '@materyalph/api-client-ts'
import { createWebApiConfiguration } from '@materyalph/web-ui'
import { dateQuery, type CalendarRange } from './admin-format'
import type { Page } from './finance-api'
import { listDirectoryVendors } from './user-directory-api'

export type { TaxAdjustment, TaxAdjustmentPrepareRequest, TaxPackage, TaxPackageInput, TaxPackageReview }

export const taxBasePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'
const config = () => createWebApiConfiguration(taxBasePath, { refreshSession: true })
const adjustments = () => new AdminFinanceOperationsApi(config())
const reports = () => new ReportingApi(config())

export async function listTaxVendors(page: number): Promise<Page<{ id: string; name: string }>> {
  const response = await listDirectoryVendors({ page })
  return { items: response.items.map(item => ({ id: item.id, name: item.storeName })), hasMore: response.meta.page < response.meta.lastPage, total: response.meta.total }
}

export async function listTaxAdjustments(page: number, state: TaxAdjustment['state'] | '', range: CalendarRange): Promise<Page<TaxAdjustment>> {
  const response = await adjustments().listTaxAdjustments({ page, ...(state ? { state } : {}), ...dateQuery(range) })
  const meta = response.meta as { has_more?: boolean; total?: number }
  return { items: response.data, hasMore: Boolean(meta.has_more), total: Number(meta.total ?? response.data.length) }
}

export async function prepareTaxAdjustment(adjustmentId: string, input: TaxAdjustmentPrepareRequest): Promise<TaxAdjustment> {
  return (await adjustments().prepareTaxAdjustment({ adjustmentId, taxAdjustmentPrepareRequest: input })).data
}

export async function reviewTaxAdjustment(adjustmentId: string, input: TaxAdjustmentReviewRequest): Promise<TaxAdjustment> {
  return (await adjustments().reviewTaxAdjustment({ adjustmentId, taxAdjustmentReviewRequest: input })).data
}

export async function postTaxAdjustment(adjustmentId: string): Promise<TaxAdjustment> {
  return (await adjustments().postTaxAdjustment({ adjustmentId })).data
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
