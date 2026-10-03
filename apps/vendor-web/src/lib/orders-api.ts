import {
  VendorFulfillmentApi,
  VendorOrdersApi,
  type FulfillmentAssignee,
  type RecordVendorFulfillmentMilestoneMilestoneEnum,
  type RecordVendorFulfillmentMilestoneReceiverKindEnum,
  type VehicleIssueRequestCategoryEnum,
  type VendorCancellationPreview,
  type VendorCancelRequestReasonCodeEnum,
  type DeliveryPlan,
  type DeliveryPlanVehicle,
  type DeliveryVehicleSelection,
  type ListVendorOrdersGroupEnum,
  type OrderDetail,
  type OrderLine,
  type OrderListMeta,
  type OrderSummary,
  type VendorOrderConfirmRequest,
  type VendorOrderDeclineReason,
} from '@materyalph/api-client-ts'
import { createWebApiConfiguration } from '@materyalph/web-ui'
import { newIdempotencyKey } from './onboarding-api'

export { apiFailure, type ApiFailure } from './inventory-api'
export { readableOnboardingError as readableOrderError, onboardingFieldErrors as orderFieldErrors } from './onboarding-api'
export type { DeliveryPlan, DeliveryPlanVehicle, DeliveryVehicleSelection, OrderDetail, OrderLine, OrderListMeta, OrderSummary, VendorOrderConfirmRequest, VendorOrderDeclineReason,
  FulfillmentAssignee, VendorCancellationPreview, VendorCancelRequestReasonCodeEnum, VehicleIssueRequestCategoryEnum }

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'
const ordersApi = () => new VendorOrdersApi(createWebApiConfiguration(basePath, { refreshSession: true }))

export type OrderGroup = 'ALL' | 'NEW' | 'WAITING_ON_BUYER' | 'AWAITING_PAYMENT' | 'CONFIRMED' | 'CLOSED'

export async function listOrders(filters: { group: OrderGroup; q?: string; page?: number }): Promise<{ items: OrderSummary[]; meta: OrderListMeta }> {
  const response = await ordersApi().listVendorOrders({ group: filters.group as ListVendorOrdersGroupEnum, ...(filters.q ? { q: filters.q } : {}), ...(filters.page ? { page: filters.page } : {}) })
  return { items: response.data, meta: response.meta }
}

export async function getOrder(orderId: string): Promise<OrderDetail> {
  return (await ordersApi().getVendorOrder({ orderId })).data
}

export async function getDeliveryPlan(orderId: string, lines: { orderLineId: string; confirmedQuantity: string }[]): Promise<DeliveryPlan> {
  return (await ordersApi().getVendorOrderDeliveryPlan({ orderId, deliveryPlanRequest: { lines } })).data
}

/** One idempotency key per submitted decision; a retry of the same click reuses it. */
export async function confirmOrder(orderId: string, request: VendorOrderConfirmRequest, idempotencyKey = newIdempotencyKey()): Promise<OrderDetail> {
  return (await ordersApi().confirmVendorOrder({ orderId, idempotencyKey, vendorOrderConfirmRequest: request })).data
}

export async function declineOrder(orderId: string, lockVersion: number, reasonCode: VendorOrderDeclineReason, reason: string): Promise<OrderDetail> {
  return (await ordersApi().declineVendorOrder({ orderId, idempotencyKey: newIdempotencyKey(), vendorOrderDeclineRequest: { lockVersion, reasonCode, reason } })).data
}

const fulfillmentApi = () => new VendorFulfillmentApi(createWebApiConfiguration(basePath, { refreshSession: true }))

export type MilestoneInput = {
  milestone: RecordVendorFulfillmentMilestoneMilestoneEnum
  lockVersion: number
  vehicleIndex?: number
  tripNumber?: number
  receiverName?: string
  receiverKind?: RecordVendorFulfillmentMilestoneReceiverKindEnum
  handoverConfirmed?: boolean
  note?: string
  file?: Blob
  signature?: Blob
}

/** Records the next milestone with the proof that milestone requires; one key per submitted click. */
export async function recordMilestone(orderId: string, input: MilestoneInput, idempotencyKey = newIdempotencyKey()): Promise<OrderDetail> {
  return (await fulfillmentApi().recordVendorFulfillmentMilestone({ orderId, idempotencyKey, ...input })).data
}

export async function listAssignees(orderId: string): Promise<FulfillmentAssignee[]> {
  return (await fulfillmentApi().listVendorFulfillmentAssignees({ orderId })).data
}

export async function assignFulfillment(orderId: string, userId: number, reason: string): Promise<OrderDetail> {
  return (await fulfillmentApi().assignVendorFulfillmentStaff({ orderId, idempotencyKey: newIdempotencyKey(), fulfillmentAssignmentRequest: { userId, reason } })).data
}

export async function recordTrip(orderId: string, vehicleIndex: number, tripNumber: number): Promise<OrderDetail> {
  return (await fulfillmentApi().recordVendorFulfillmentTrip({ orderId, idempotencyKey: newIdempotencyKey(), fulfillmentTripRequest: { vehicleIndex, tripNumber } })).data
}

export async function reportVehicleIssue(orderId: string, category: VehicleIssueRequestCategoryEnum, description: string): Promise<OrderDetail> {
  return (await fulfillmentApi().reportVendorVehicleIssue({ orderId, idempotencyKey: newIdempotencyKey(), vehicleIssueRequest: { category, description } })).data
}

export async function respondToProblem(orderId: string, issueId: string, response: string): Promise<OrderDetail> {
  return (await fulfillmentApi().respondVendorProblem({ orderId, issueId, idempotencyKey: newIdempotencyKey(), problemResponseRequest: { response } })).data
}

export async function getCancellationPreview(orderId: string): Promise<VendorCancellationPreview> {
  return (await fulfillmentApi().getVendorCancellationPreview({ orderId })).data
}

export async function cancelOrder(orderId: string, lockVersion: number, reasonCode: VendorCancelRequestReasonCodeEnum, reason: string, idempotencyKey = newIdempotencyKey()): Promise<OrderDetail> {
  return (await fulfillmentApi().cancelVendorOrder({ orderId, idempotencyKey, vendorCancelRequest: { lockVersion, reasonCode, reason } })).data
}

export async function finalizeCancellationRequest(orderId: string, retainNrpc: boolean, note: string, file?: Blob, idempotencyKey = newIdempotencyKey()): Promise<OrderDetail> {
  return (await fulfillmentApi().finalizeVendorCancellationRequest({ orderId, idempotencyKey, retainNrpc, ...(note ? { note } : {}), ...(file ? { file } : {}) })).data
}

export async function retryRefund(orderId: string, refundId: string): Promise<OrderDetail> {
  return (await fulfillmentApi().retryVendorRefund({ orderId, refundId, idempotencyKey: newIdempotencyKey() })).data
}

export async function recordReimbursement(orderId: string, reimbursementId: string, file: Blob, note?: string): Promise<OrderDetail> {
  return (await fulfillmentApi().recordVendorReimbursement({ orderId, reimbursementId, idempotencyKey: newIdempotencyKey(), file, ...(note ? { note } : {}) })).data
}

export const apiBasePath = basePath

/** Peso text (e.g. "1,250.50") to integer centavos, or null when invalid. */
export function pesoInputToCentavos(value: string): number | null {
  const text = value.trim().replaceAll(',', '')
  if (!/^\d{1,11}(\.\d{1,2})?$/.test(text)) return null
  const [whole, fraction = ''] = text.split('.')
  return Number(whole) * 100 + Number(fraction.padEnd(2, '0'))
}

/** Four-decimal quantity for display without trailing zeros. */
export function quantityText(value: string | null | undefined): string {
  if (value === null || value === undefined || value === '') return '—'
  return value.includes('.') ? value.replace(/\.?0+$/, '') : value
}
