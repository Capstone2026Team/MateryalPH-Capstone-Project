import { AdminOrderOperationsApi, type OrderDetail, type OrderSummary, type ListAdminAuditOrdersRequest } from '@materyalph/api-client-ts'
import { createWebApiConfiguration } from '@materyalph/web-ui'

export type { OrderDetail, OrderSummary }
export const orderAuditBasePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'
const api = () => new AdminOrderOperationsApi(createWebApiConfiguration(orderAuditBasePath, { refreshSession: true }))

export async function listAuditOrders(filters: ListAdminAuditOrdersRequest) {
  const result = await api().listAdminAuditOrders(filters)
  return { items: result.data, meta: result.meta }
}

export async function getAuditOrder(orderId: string, caseId?: string): Promise<OrderDetail> {
  return (await api().getAdminAuditOrder({ orderId, ...(caseId ? { caseId } : {}) })).data
}
