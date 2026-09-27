import {
  AdminProductComplianceApi,
  ResponseError,
  type ComplianceReferenceResult,
  type ComplianceRegister,
  type CompliancePath,
  type ProductComplianceDecision,
  type ProductComplianceQueueItem,
  type ListProductComplianceQueueStatusEnum,
} from '@materyalph/api-client-ts'
import { createWebApiConfiguration } from '@materyalph/web-ui'

export type { ComplianceRegister, ProductComplianceQueueItem }
export type ProductComplianceCase = Record<string, unknown>

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'

function complianceApi(): AdminProductComplianceApi {
  return new AdminProductComplianceApi(createWebApiConfiguration(basePath, { refreshSession: true }))
}

export async function listComplianceQueue(filters: { status?: ListProductComplianceQueueStatusEnum; path?: CompliancePath; referenceResult?: ComplianceReferenceResult; sort?: 'oldest' | 'newest'; page?: number }) {
  const response = await complianceApi().listProductComplianceQueue(filters)
  return { items: response.data, meta: response.meta as { current_page?: number; last_page?: number; total?: number } }
}

export async function getComplianceCase(submissionId: string): Promise<ProductComplianceCase> {
  return (await complianceApi().getProductComplianceCase({ submissionId })).data as unknown as ProductComplianceCase
}

export async function decideCompliance(submissionId: string, decision: ProductComplianceDecision): Promise<ProductComplianceCase> {
  return (await complianceApi().decideProductCompliance({ submissionId, idempotencyKey: crypto.randomUUID(), productComplianceDecision: decision })).data as unknown as ProductComplianceCase
}

export async function getComplianceFileUrl(fileId: string) {
  return (await complianceApi().getProductComplianceFileUrl({ fileId })).data
}

export async function listRegisters(page = 1) {
  const response = await complianceApi().listComplianceRegisters({ page })
  return { items: response.data, meta: response.meta as { last_page?: number } }
}

export async function importRegister(registerKind: 'PS_LICENSE' | 'ICC_CERTIFICATE', sourceReference: string, snapshotDate: string, file: Blob): Promise<ComplianceRegister> {
  return (await complianceApi().importComplianceRegister({ registerKind, sourceReference, snapshotDate: new Date(`${snapshotDate}T00:00:00Z`), file })).data
}

export async function activateRegister(registerId: string): Promise<ComplianceRegister> {
  return (await complianceApi().activateComplianceRegister({ registerId })).data
}

/** Returns the stable error code so the page can show the stale-review conflict banner. */
export async function complianceErrorCode(error: unknown): Promise<string | null> {
  if (!(error instanceof ResponseError)) return null
  const payload: unknown = await error.response.clone().json().catch(() => null)
  const first = typeof payload === 'object' && payload !== null && 'errors' in payload && Array.isArray(payload.errors) ? payload.errors[0] as { code?: unknown } : null
  return typeof first?.code === 'string' ? first.code : null
}
