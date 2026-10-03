import {
  AdminFinanceApi,
  type ChannelFeeVersion,
  type FinanceReviewItem,
  type ListAdminPaymentsStateEnum,
  type ListFeeStatementsStateEnum,
  type ListWithholdingAccumulatorsStatusEnum,
  type WithholdingAccumulatorDetail,
  type WithholdingAccumulatorView,
} from '@materyalph/api-client-ts'
import { createWebApiConfiguration } from '@materyalph/web-ui'
import type { JsonRecord } from './admin-format'

export type { ChannelFeeVersion, FinanceReviewItem, WithholdingAccumulatorDetail, WithholdingAccumulatorView }
export type Page<T> = { items: T[]; hasMore: boolean; total: number }

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'
const financeApi = () => new AdminFinanceApi(createWebApiConfiguration(basePath, { refreshSession: true }))
const pageOf = <T>(data: T[], meta: unknown): Page<T> => {
  const value = (meta ?? {}) as { has_more?: boolean; total?: number }
  return { items: data, hasMore: Boolean(value.has_more), total: Number(value.total ?? data.length) }
}

export async function listPayments(page: number, state?: string): Promise<Page<JsonRecord>> {
  const response = await financeApi().listAdminPayments({ page, ...(state ? { state: state as ListAdminPaymentsStateEnum } : {}) })
  return pageOf(response.data as JsonRecord[], response.meta)
}

export async function listReviewItems(page: number, state: 'OPEN' | 'RESOLVED'): Promise<Page<FinanceReviewItem>> {
  const response = await financeApi().listFinanceReviewItems({ page, state })
  return pageOf(response.data, response.meta)
}

export async function resolveReviewItem(itemId: string, resolution: string): Promise<void> {
  await financeApi().resolveFinanceReviewItem({ itemId, reviewResolveRequest: { resolution } })
}

export async function listAccumulators(page: number, status?: string): Promise<Page<WithholdingAccumulatorView>> {
  const response = await financeApi().listWithholdingAccumulators({ page, ...(status ? { status: status as ListWithholdingAccumulatorsStatusEnum } : {}) })
  return pageOf(response.data, response.meta)
}

export async function getAccumulator(accumulatorId: string): Promise<WithholdingAccumulatorDetail> {
  return (await financeApi().getWithholdingAccumulator({ accumulatorId })).data
}

export async function resolveOverlap(accumulatorId: string, overlapCentavos: number, lockVersion: number, reason: string): Promise<WithholdingAccumulatorDetail> {
  return (await financeApi().resolveWithholdingOverlap({ accumulatorId, overlapResolveRequest: { overlapCentavos, lockVersion, reason } })).data
}

export async function listStatements(page: number, state?: string): Promise<Page<JsonRecord>> {
  const response = await financeApi().listFeeStatements({ page, ...(state ? { state: state as ListFeeStatementsStateEnum } : {}) })
  return pageOf(response.data as JsonRecord[], response.meta)
}

export async function draftStatements(): Promise<number> {
  return Number(((await financeApi().draftFeeStatements()).data as { drafted?: number }).drafted ?? 0)
}

export async function approveStatement(statementId: string, lockVersion: number): Promise<void> {
  await financeApi().approveFeeStatement({ statementId, statementApproveRequest: { lockVersion } })
}

export async function approveFeeCredit(proposalId: string): Promise<void> {
  await financeApi().approveFeeCredit({ proposalId })
}

export async function listChannelFees(): Promise<ChannelFeeVersion[]> {
  return (await financeApi().listChannelFees()).data
}

export async function runReconciliation(): Promise<JsonRecord> {
  return (await financeApi().runPaymentReconciliation()).data as JsonRecord
}
