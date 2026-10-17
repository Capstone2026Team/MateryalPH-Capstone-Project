import {
  VendorDisputesApi,
  VendorInvoicesApi,
  type AppealVendorDisputeGroundsEnum,
  type DisputeDetail,
  type DisputeEligibility,
  type DisputeExport,
  type DisputeListMeta,
  type DisputeProposalRequestRemedyEnum,
  type DisputeSummary,
  type FileVendorDisputeIssueTypeEnum,
  type FileVendorDisputeRequestedRemedyEnum,
  type InvoiceListMeta,
  type InvoiceLogRow,
  type ListVendorDisputesGroupEnum,
  type ListVendorInvoicesViewEnum,
  type RespondVendorDisputePositionEnum,
  type UploadVendorInvoiceInvoiceTypeEnum,
  type UploadVendorInvoiceInvoicingMethodEnum,
  type UploadVendorInvoiceSourceSystemEnum,
  type VendorOrderInvoices,
} from '@materyalph/api-client-ts'
import { createWebApiConfiguration } from '@materyalph/web-ui'
import { newIdempotencyKey } from './onboarding-api'
import { apiDateFilters, type DateFilters } from './date-filters'

export type { DisputeDetail, DisputeEligibility, DisputeExport, DisputeListMeta, DisputeSummary, InvoiceListMeta, InvoiceLogRow, VendorOrderInvoices }
export type DisputeGroup = ListVendorDisputesGroupEnum
export type InvoiceView = ListVendorInvoicesViewEnum

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'
const disputes = () => new VendorDisputesApi(createWebApiConfiguration(basePath, { refreshSession: true }))
const invoices = () => new VendorInvoicesApi(createWebApiConfiguration(basePath, { refreshSession: true }))
export const disputeApiBasePath = basePath

export async function listDisputes(filters: { group: DisputeGroup; q?: string; page?: number } & DateFilters): Promise<{ items: DisputeSummary[]; meta: DisputeListMeta }> {
  const response = await disputes().listVendorDisputes({ group: filters.group, ...(filters.q ? { q: filters.q } : {}), ...(filters.page ? { page: filters.page } : {}), ...apiDateFilters(filters) })
  return { items: response.data, meta: response.meta }
}

export async function getDispute(caseId: string): Promise<DisputeDetail> {
  return (await disputes().getVendorDispute({ caseId })).data
}

export async function getEligibility(orderId: string): Promise<DisputeEligibility> {
  return (await disputes().getVendorDisputeEligibility({ orderId })).data
}

export async function fileDispute(input: { orderId: string; issueType: string; requestedRemedy: string; description: string; affectedLineIds: string[]; files: File[] }, idempotencyKey = newIdempotencyKey()): Promise<DisputeDetail> {
  return (await disputes().fileVendorDispute({ idempotencyKey, orderId: input.orderId, issueType: input.issueType as FileVendorDisputeIssueTypeEnum,
    requestedRemedy: input.requestedRemedy as FileVendorDisputeRequestedRemedyEnum, description: input.description,
    ...(input.affectedLineIds.length ? { affectedLineIds: input.affectedLineIds } : {}), ...(input.files.length ? { files: input.files } : {}) })).data
}

export async function respond(caseId: string, input: { position: string; body: string; amountCentavos?: number; files: File[] }, idempotencyKey = newIdempotencyKey()): Promise<DisputeDetail> {
  return (await disputes().respondVendorDispute({ caseId, idempotencyKey, position: input.position as RespondVendorDisputePositionEnum, body: input.body,
    ...(input.amountCentavos ? { amountCentavos: input.amountCentavos } : {}), ...(input.files.length ? { files: input.files } : {}) })).data
}

export async function propose(caseId: string, input: { remedy: string; amountCentavos?: number; terms: string }, idempotencyKey = newIdempotencyKey()): Promise<DisputeDetail> {
  return (await disputes().proposeVendorDisputeResolution({ caseId, idempotencyKey, disputeProposalRequest: { remedy: input.remedy as DisputeProposalRequestRemedyEnum, terms: input.terms,
    ...(input.amountCentavos ? { amountCentavos: input.amountCentavos } : {}) } })).data
}

export async function answerProposal(caseId: string, proposalId: string, accept: boolean, idempotencyKey = newIdempotencyKey()): Promise<DisputeDetail> {
  return (await disputes().answerVendorDisputeProposal({ caseId, proposalId, idempotencyKey, disputeProposalAnswer: { decision: accept ? 'ACCEPT' : 'REJECT' } })).data
}

export async function escalate(caseId: string, reason: string, idempotencyKey = newIdempotencyKey()): Promise<DisputeDetail> {
  return (await disputes().escalateVendorDispute({ caseId, idempotencyKey, disputeEscalateRequest: { reason } })).data
}

export async function addEvidence(caseId: string, files: File[], description?: string, idempotencyKey = newIdempotencyKey()): Promise<DisputeDetail> {
  return (await disputes().addVendorDisputeEvidence({ caseId, idempotencyKey, files, ...(description ? { description } : {}) })).data
}

export async function sendMessage(caseId: string, body: string, idempotencyKey = newIdempotencyKey()): Promise<DisputeDetail> {
  return (await disputes().sendVendorDisputeMessage({ caseId, idempotencyKey, disputeMessageRequest: { body } })).data
}

export async function answerClarification(caseId: string, clarificationId: string, response: string, files: File[], idempotencyKey = newIdempotencyKey()): Promise<DisputeDetail> {
  return (await disputes().answerVendorDisputeClarification({ caseId, clarificationId, idempotencyKey, response, ...(files.length ? { files } : {}) })).data
}

export async function appeal(caseId: string, grounds: string, statement: string, files: File[], idempotencyKey = newIdempotencyKey()): Promise<DisputeDetail> {
  return (await disputes().appealVendorDispute({ caseId, idempotencyKey, grounds: grounds as AppealVendorDisputeGroundsEnum, statement, ...(files.length ? { files } : {}) })).data
}

export async function recordReplacement(caseId: string, remedyId: string, note: string, file: File | null, idempotencyKey = newIdempotencyKey()): Promise<DisputeDetail> {
  return (await disputes().recordVendorDisputeReplacement({ caseId, remedyId, idempotencyKey, note, ...(file ? { files: [file] } : {}) })).data
}

export async function listExports(): Promise<DisputeExport[]> {
  return (await disputes().listVendorDisputeExports()).data
}

export async function requestExport(group: DisputeGroup): Promise<DisputeExport> {
  return (await disputes().requestVendorDisputeExport({ disputeExportRequest: { group } })).data
}

/** Downloads a ready export through the authorized, audited endpoint; the browser saves it as a CSV file. */
export async function downloadExport(exportId: string): Promise<void> {
  const blob = await disputes().downloadVendorDisputeExport({ exportId })
  const url = URL.createObjectURL(blob)
  const link = document.createElement('a')
  link.href = url
  link.download = 'dispute-cases.csv'
  link.click()
  URL.revokeObjectURL(url)
}

export async function listInvoices(filters: { view: InvoiceView; page?: number } & DateFilters): Promise<{ items: InvoiceLogRow[]; meta: InvoiceListMeta }> {
  const response = await invoices().listVendorInvoices({ view: filters.view, ...(filters.page ? { page: filters.page } : {}), ...apiDateFilters(filters) })
  return { items: response.data, meta: response.meta }
}

export async function getOrderInvoices(orderId: string): Promise<VendorOrderInvoices> {
  return (await invoices().getVendorOrderInvoices({ orderId })).data
}

export type InvoiceUploadInput = {
  invoiceType: string; issuerName: string; invoiceNumber: string; issuedOn: Date; amountCentavos: number; vatCentavos?: number; relatedLineIds: string[]
  sourceSystem: string; invoicingMethod: string; amendsInvoiceRecordId?: string; file: File
}

export async function uploadInvoice(orderId: string, input: InvoiceUploadInput, idempotencyKey = newIdempotencyKey()): Promise<VendorOrderInvoices> {
  return (await invoices().uploadVendorInvoice({ orderId, idempotencyKey, invoiceType: input.invoiceType as UploadVendorInvoiceInvoiceTypeEnum, issuerName: input.issuerName,
    invoiceNumber: input.invoiceNumber, issuedOn: input.issuedOn, amountCentavos: input.amountCentavos, sourceSystem: input.sourceSystem as UploadVendorInvoiceSourceSystemEnum,
    invoicingMethod: input.invoicingMethod as UploadVendorInvoiceInvoicingMethodEnum, file: input.file, ...(input.vatCentavos !== undefined ? { vatCentavos: input.vatCentavos } : {}),
    ...(input.relatedLineIds.length ? { relatedLineIds: input.relatedLineIds } : {}), ...(input.amendsInvoiceRecordId ? { amendsInvoiceRecordId: input.amendsInvoiceRecordId } : {}) })).data
}

export async function explainDifference(orderId: string, recordId: string, note: string, idempotencyKey = newIdempotencyKey()): Promise<VendorOrderInvoices> {
  return (await invoices().explainVendorInvoiceDifference({ orderId, recordId, idempotencyKey, invoiceExplanationRequest: { note } })).data
}
