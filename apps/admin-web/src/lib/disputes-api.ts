import {
  AdminDisputesApi,
  AdminInvoicesApi,
  type AdminDisputeAppealDecisionRequestMetricEventEnum,
  type AdminDisputeAppealDecisionRequestOutcomeEnum,
  type AdminDisputeAppealDecisionRequestResultEnum,
  type AdminDisputeDecisionRequestMetricEventEnum,
  type AdminDisputeDecisionRequestOutcomeEnum,
  type DisputeDetail,
  type DisputeListMeta,
  type DisputeSanctionInput,
  type DisputeSummary,
  type InvoiceListMeta,
  type InvoiceLogRow,
  type ListAdminDisputesStatusEnum,
  type ListAdminInvoiceLogViewEnum,
} from '@materyalph/api-client-ts'
import { createWebApiConfiguration } from '@materyalph/web-ui'
import { dateQuery, type CalendarRange } from './admin-format'

export type { DisputeDetail, DisputeListMeta, DisputeSanctionInput, DisputeSummary, InvoiceListMeta, InvoiceLogRow }
export type QueueStatus = ListAdminDisputesStatusEnum
export type InvoiceLogView = ListAdminInvoiceLogViewEnum

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'
export const adminApiBasePath = basePath
const disputes = () => new AdminDisputesApi(createWebApiConfiguration(basePath, { refreshSession: true }))
const invoices = () => new AdminInvoicesApi(createWebApiConfiguration(basePath, { refreshSession: true }))
export const newKey = (): string => crypto.randomUUID()

export async function listQueue(status: QueueStatus, page = 1, range?: CalendarRange): Promise<{ items: DisputeSummary[]; meta: DisputeListMeta }> {
  const response = await disputes().listAdminDisputes({ status, page, ...dateQuery(range) })
  return { items: response.data, meta: response.meta }
}

export async function getCase(caseId: string): Promise<DisputeDetail> {
  return (await disputes().getAdminDispute({ caseId })).data
}

export async function assignToMe(caseId: string): Promise<DisputeDetail> {
  return (await disputes().assignAdminDispute({ caseId, idempotencyKey: newKey() })).data
}

export async function escalateCase(caseId: string, reason: string): Promise<DisputeDetail> {
  return (await disputes().escalateAdminDispute({ caseId, idempotencyKey: newKey(), disputeEscalateRequest: { reason } })).data
}

export async function requestClarification(caseId: string, parties: ('BUYER' | 'VENDOR')[], question: string): Promise<DisputeDetail> {
  return (await disputes().requestAdminDisputeClarification({ caseId, idempotencyKey: newKey(), adminDisputeClarificationRequest: { parties, question } })).data
}

export type DecisionInput = {
  outcome: string; reason: string; amountCentavos?: number; affectedLineIds: string[]; enforceable: boolean; conflictCheckConfirmed: boolean; evidenceLimitation?: string
  sanctions: DisputeSanctionInput[]; metricEvent?: string; lockVersion: number
}

/** One key per submitted decision so a retried click cannot record a second version. */
export async function decide(caseId: string, input: DecisionInput, idempotencyKey: string): Promise<DisputeDetail> {
  return (await disputes().decideAdminDispute({ caseId, idempotencyKey, adminDisputeDecisionRequest: {
    outcome: input.outcome as AdminDisputeDecisionRequestOutcomeEnum, reason: input.reason, enforceable: input.enforceable, conflictCheckConfirmed: input.conflictCheckConfirmed, lockVersion: input.lockVersion,
    affectedLineIds: input.affectedLineIds, sanctions: input.sanctions, ...(input.amountCentavos ? { amountCentavos: input.amountCentavos } : {}),
    ...(input.evidenceLimitation ? { evidenceLimitation: input.evidenceLimitation } : {}), ...(input.metricEvent ? { metricEvent: input.metricEvent as AdminDisputeDecisionRequestMetricEventEnum } : {}),
  } })).data
}

export async function decideAppeal(caseId: string, input: DecisionInput & { result: string }, idempotencyKey: string): Promise<DisputeDetail> {
  return (await disputes().decideAdminDisputeAppeal({ caseId, idempotencyKey, adminDisputeAppealDecisionRequest: {
    result: input.result as AdminDisputeAppealDecisionRequestResultEnum, reason: input.reason, conflictCheckConfirmed: input.conflictCheckConfirmed, lockVersion: input.lockVersion,
    affectedLineIds: input.affectedLineIds, sanctions: input.sanctions, ...(input.result !== 'AFFIRMED' ? { outcome: input.outcome as AdminDisputeAppealDecisionRequestOutcomeEnum } : {}),
    ...(input.amountCentavos ? { amountCentavos: input.amountCentavos } : {}), ...(input.metricEvent ? { metricEvent: input.metricEvent as AdminDisputeAppealDecisionRequestMetricEventEnum } : {}),
  } })).data
}

export async function confirmRemedy(caseId: string, remedyId: string, reason: string): Promise<DisputeDetail> {
  return (await disputes().confirmAdminDisputeRemedy({ caseId, remedyId, idempotencyKey: newKey(), disputeRemedyConfirmRequest: { reason } })).data
}

export async function listInvoiceLog(view: InvoiceLogView, page = 1, range?: CalendarRange): Promise<{ items: InvoiceLogRow[]; meta: InvoiceListMeta }> {
  const response = await invoices().listAdminInvoiceLog({ view, page, ...dateQuery(range) })
  return { items: response.data, meta: response.meta }
}
