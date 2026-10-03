import {
  AdminOrderOperationsApi,
  type AdminCancellationRequestRow,
  type AdminOrderOperationsSummary,
  type AdminRefundRow,
  type AdminReimbursementRow,
  type ListAdminRefundsStateEnum,
} from '@materyalph/api-client-ts'
import { createWebApiConfiguration } from '@materyalph/web-ui'

export type { AdminCancellationRequestRow, AdminOrderOperationsSummary, AdminRefundRow, AdminReimbursementRow }

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'
const operationsApi = () => new AdminOrderOperationsApi(createWebApiConfiguration(basePath, { refreshSession: true }))
const newKey = () => crypto.randomUUID()

export async function getSummary(): Promise<AdminOrderOperationsSummary> {
  return (await operationsApi().getAdminOrderOperationsSummary()).data
}

export async function listRefunds(page: number, state?: ListAdminRefundsStateEnum): Promise<{ items: AdminRefundRow[]; hasMore: boolean }> {
  const response = await operationsApi().listAdminRefunds({ page, ...(state ? { state } : {}) })
  return { items: response.data, hasMore: Boolean((response.meta as { has_more?: boolean } | undefined)?.has_more) }
}

/** Re-sends a failed instruction to the original payment only; Admins never hold or disburse funds. */
export async function retryRefund(refundId: string): Promise<void> {
  await operationsApi().retryAdminRefund({ refundId, idempotencyKey: newKey() })
}

export async function listReimbursements(): Promise<AdminReimbursementRow[]> {
  return (await operationsApi().listAdminReimbursements()).data
}

export async function confirmReimbursement(reimbursementId: string, reason: string): Promise<void> {
  await operationsApi().confirmAdminReimbursement({ reimbursementId, adminReimbursementDecision: { reason } })
}

export async function listCancellationRequests(): Promise<AdminCancellationRequestRow[]> {
  return (await operationsApi().listAdminCancellationRequests()).data
}
