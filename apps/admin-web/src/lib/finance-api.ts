import {
  AdminFinanceApi,
  AdminFinanceOperationsApi,
  type CommissionPolicy,
  type CommissionPolicies,
  type CommissionPolicyPublishRequest,
  type CommissionPolicyPreview,
  type StatementInvoiceUpdateRequest,
  type FinanceKpi,
  type FinanceKpis,
  type RemittanceQueueRow,
  type TaxEvidenceRow,
  type ChannelFeeVersion,
  type FinanceReviewItem,
  type ListAdminPaymentsPurposeEnum,
  type ListAdminPaymentsStateEnum,
  type ListFeeStatementsStateEnum,
  type ListWithholdingAccumulatorsStatusEnum,
  type WithholdingAccumulatorDetail,
  type WithholdingAccumulatorView,
} from '@materyalph/api-client-ts'
import { createWebApiConfiguration } from '@materyalph/web-ui'
import { dateQuery, type CalendarRange, type JsonRecord } from './admin-format'

export type { ChannelFeeVersion, FinanceKpi, FinanceKpis,FinanceReviewItem, RemittanceQueueRow, TaxEvidenceRow, WithholdingAccumulatorDetail, WithholdingAccumulatorView }
export type Page<T> = { items: T[]; hasMore: boolean; total: number; totals?: Record<string, number> }
export type { CommissionPolicy, CommissionPolicies, CommissionPolicyPublishRequest, CommissionPolicyPreview }

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'
export const commissionTermsUrl = (policy?: string) => `${import.meta.env.VITE_VENDOR_URL ?? 'http://localhost:5173'}/commission-terms${policy ? `?policy=${policy}` : ''}`
const financeApi = () => new AdminFinanceApi(createWebApiConfiguration(basePath, { refreshSession: true }))
const operationsApi = (localForbidden = false) => new AdminFinanceOperationsApi(createWebApiConfiguration(basePath, { refreshSession: true, localForbidden }))
const pageOf = <T>(data: T[], meta: unknown): Page<T> => {
  const value = (meta ?? {}) as { has_more?: boolean; total?: number }
  return { items: data, hasMore: Boolean(value.has_more), total: Number(value.total ?? data.length) }
}

export async function listCommissionPolicies(page = 1): Promise<{ policies: CommissionPolicies; hasMore: boolean }> {
  const response = await financeApi().listCommissionPolicies({ page })
  return { policies: response.data, hasMore: Boolean((response.meta as { has_more?: boolean }).has_more) }
}

export async function publishCommissionPolicy(input: CommissionPolicyPublishRequest, idempotencyKey: string): Promise<CommissionPolicy> {
  const policy = (await financeApi().publishCommissionPolicy({ commissionPolicyPublishRequest: input, idempotencyKey })).data
  window.dispatchEvent(new Event('commission-policy-changed'))
  return policy
}

export async function previewCommissionPolicy(input: CommissionPolicyPublishRequest): Promise<CommissionPolicyPreview> {
  return (await financeApi().previewCommissionPolicy({ commissionPolicyPublishRequest: input })).data
}

export async function getCommissionStatement(statementId: string, page = 1, paymentsPage = 1): Promise<JsonRecord> {
  return (await financeApi().getAdminCommissionStatement({ statementId, page, paymentsPage })).data
}

export async function resendCommissionEmail(eventId: string, idempotencyKey: string): Promise<void> {
  await financeApi().resendCommissionEmail({ eventId, idempotencyKey })
}

export async function resendFailedCommissionEmails(policyId: string, idempotencyKey: string): Promise<void> {
  await financeApi().resendFailedCommissionEmails({ policyId, idempotencyKey })
}

export async function listPayments(page: number, state?: string, range?: CalendarRange, purpose?: string): Promise<Page<JsonRecord>> {
  const response = await financeApi().listAdminPayments({ page, ...(state ? { state: state as ListAdminPaymentsStateEnum } : {}), ...(purpose ? { purpose: purpose as ListAdminPaymentsPurposeEnum } : {}), ...dateQuery(range) })
  return pageOf(response.data as JsonRecord[], response.meta)
}

export async function listCommissionTransactions(page: number, range?: CalendarRange, status?: string, search?: string, statuses?: string): Promise<Page<JsonRecord>> {
  const response = await financeApi().listCommissionTransactions({ page, ...dateQuery(range), ...(status ? { status: status as 'PAID' | 'PAID_PARTIALLY_REFUNDED' | 'PAID_REFUND_PENDING' | 'PAID_REFUNDED' | 'PAID_REFUND_FAILED' } : {}), ...(search ? { search } : {}), ...(statuses ? { statuses } : {}) })
  return pageOf(response.data as JsonRecord[], response.meta)
}

export async function updateStatementInvoice(statementId: string, input: StatementInvoiceUpdateRequest, idempotencyKey: string): Promise<void> {
  await financeApi().updateFeeStatementInvoice({ statementId, statementInvoiceUpdateRequest: input, idempotencyKey })
}

export async function listReviewItems(page: number, state: 'OPEN' | 'RESOLVED', kind?: string, range?: CalendarRange): Promise<Page<FinanceReviewItem>> {
  const response = await financeApi().listFinanceReviewItems({ page, state, ...(kind ? { kind } : {}), ...dateQuery(range) })
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

export async function listStatements(page: number, state?: string, overdue = false, range?: CalendarRange, search?: string, states?: string): Promise<Page<JsonRecord>> {
  const response = await financeApi().listFeeStatements({ page, ...(state ? { state: state as ListFeeStatementsStateEnum } : {}), ...(overdue ? { overdue: true } : {}), ...dateQuery(range), ...(search ? { search } : {}), ...(states ? { states } : {}) })
  const meta = response.meta as { totals?: Record<string, number> }
  return { ...pageOf(response.data as JsonRecord[], response.meta), ...(meta.totals ? { totals: meta.totals } : {}) }
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
export async function financeKpis(from: string, to: string, options: { localForbidden?: boolean } = {}): Promise<FinanceKpis> {
  return (await operationsApi(options.localForbidden).getFinanceKpis(dateQuery({ from, to }))).data
}

export async function remittanceQueue(page: number, reconciliationState?: string, range?: CalendarRange): Promise<Page<RemittanceQueueRow>> {
  const response = await operationsApi().listRemittanceQueue({ page, ...(reconciliationState ? { reconciliationState: reconciliationState as never } : {}), ...dateQuery(range) })
  return pageOf(response.data, response.meta)
}

export async function approveRemittanceReconciliation(assessmentId: string, sourceVersion: string, reason: string, idempotencyKey: string): Promise<void> {
  await operationsApi().approveRemittanceReconciliation({ assessmentId, idempotencyKey, remittanceReconciliationApproval: { sourceVersion, reason } })
}

export async function taxEvidenceQueue(page: number, reviewState?: string, range?: CalendarRange): Promise<Page<TaxEvidenceRow>> {
  const response = await operationsApi().listTaxEvidenceQueue({ page, ...(reviewState ? { reviewState } : {}), ...dateQuery(range) })
  return pageOf(response.data, response.meta)
}

export async function listTaxIssues(page: number): Promise<Page<FinanceReviewItem>> {
  const response = await operationsApi().listTaxIssues({ page })
  return pageOf(response.data, response.meta)
}
