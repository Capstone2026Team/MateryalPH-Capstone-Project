import {
  AdminFinanceApi,
  AdminFinanceOperationsApi,
  type FinanceKpis,
  type RemittanceQueueRow,
  type TaxAdjustment,
  type TaxAdjustmentPrepareRequest,
  type TaxEvidenceRow,
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

export type { ChannelFeeVersion, FinanceKpis, FinanceReviewItem, RemittanceQueueRow, TaxAdjustment, TaxEvidenceRow, WithholdingAccumulatorDetail, WithholdingAccumulatorView }
export type Page<T> = { items: T[]; hasMore: boolean; total: number }

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'
const financeApi = () => new AdminFinanceApi(createWebApiConfiguration(basePath, { refreshSession: true }))
const operationsApi = () => new AdminFinanceOperationsApi(createWebApiConfiguration(basePath, { refreshSession: true }))
const pageOf = <T>(data: T[], meta: unknown): Page<T> => {
  const value = (meta ?? {}) as { has_more?: boolean; total?: number }
  return { items: data, hasMore: Boolean(value.has_more), total: Number(value.total ?? data.length) }
}

export async function listPayments(page: number, state?: string): Promise<Page<JsonRecord>> {
  const response = await financeApi().listAdminPayments({ page, ...(state ? { state: state as ListAdminPaymentsStateEnum } : {}) })
  return pageOf(response.data as JsonRecord[], response.meta)
}

export async function listReviewItems(page: number, state: 'OPEN' | 'RESOLVED', kind?: string): Promise<Page<FinanceReviewItem>> {
  const response = await financeApi().listFinanceReviewItems({ page, state, ...(kind ? { kind } : {}) })
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

export async function listStatements(page: number, state?: string, overdue = false): Promise<Page<JsonRecord>> {
  const response = await financeApi().listFeeStatements({ page, ...(state ? { state: state as ListFeeStatementsStateEnum } : {}), ...(overdue ? { overdue: true } : {}) })
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

// FIN-10 queues. Preparer and reviewer are distinct named users; the server returns 409 PREPARER_CANNOT_REVIEW otherwise.
const day = (value: string) => new Date(`${value}T00:00:00Z`)

export async function financeKpis(from: string, to: string): Promise<FinanceKpis> {
  return (await operationsApi().getFinanceKpis({ from: day(from), to: day(to) })).data
}

export async function remittanceQueue(page: number, reconciliationState?: string): Promise<Page<RemittanceQueueRow>> {
  const response = await operationsApi().listRemittanceQueue({ page, ...(reconciliationState ? { reconciliationState: reconciliationState as never } : {}) })
  return pageOf(response.data, response.meta)
}

export async function taxEvidenceQueue(page: number, reviewState?: string): Promise<Page<TaxEvidenceRow>> {
  const response = await operationsApi().listTaxEvidenceQueue({ page, ...(reviewState ? { reviewState } : {}) })
  return pageOf(response.data, response.meta)
}

export async function listTaxAdjustments(page: number, state?: string): Promise<Page<TaxAdjustment>> {
  const response = await operationsApi().listTaxAdjustments({ page, ...(state ? { state: state as never } : {}) })
  return pageOf(response.data, response.meta)
}

export async function prepareTaxAdjustment(adjustmentId: string, input: TaxAdjustmentPrepareRequest): Promise<TaxAdjustment> {
  return (await operationsApi().prepareTaxAdjustment({ adjustmentId, taxAdjustmentPrepareRequest: input })).data
}

export async function reviewTaxAdjustment(adjustmentId: string, decision: 'APPROVED' | 'REJECTED', reason: string): Promise<TaxAdjustment> {
  return (await operationsApi().reviewTaxAdjustment({ adjustmentId, taxAdjustmentReviewRequest: { decision, reason } })).data
}

export async function postTaxAdjustment(adjustmentId: string): Promise<TaxAdjustment> {
  return (await operationsApi().postTaxAdjustment({ adjustmentId })).data
}