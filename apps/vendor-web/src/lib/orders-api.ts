import {
  VendorOrdersApi,
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
export type { DeliveryPlan, DeliveryPlanVehicle, DeliveryVehicleSelection, OrderDetail, OrderLine, OrderListMeta, OrderSummary, VendorOrderConfirmRequest, VendorOrderDeclineReason }

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
