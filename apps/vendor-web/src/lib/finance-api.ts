import {
  VendorFinanceApi,
  VendorFinanceReviewsApi,
  type VendorFinanceReviews,
  type FeeStatementDetail,
  type ListVendorTransactionsStatusEnum,
  type ListVendorTransactionsTabEnum,
  type PaymentAttempt,
  type PaymentChannelOption,
  type PhysicalPaymentSettings,
  type PhysicalPaymentSummary,
  type VendorEarnings,
  type VendorEarningsTrendPoint,
  type VendorFinanceOverview,
} from '@materyalph/api-client-ts'
import { createWebApiConfiguration, type PaymentChannelRow, type ThresholdPanelData } from '@materyalph/web-ui'
import { newIdempotencyKey } from './onboarding-api'
import { apiDateFilters, type DateFilters } from './date-filters'

export { readableOnboardingError as readableFinanceError } from './onboarding-api'
export type { VendorFinanceReviews, FeeStatementDetail, PaymentAttempt, PaymentChannelOption, PhysicalPaymentSettings, PhysicalPaymentSummary, VendorEarnings, VendorEarningsTrendPoint, VendorFinanceOverview }

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'
const financeApi = () => new VendorFinanceApi(createWebApiConfiguration(basePath, { refreshSession: true }))

export type FinanceTab = 'PAYMENTS' | 'PHYSICAL' | 'REMITTANCES' | 'STATEMENTS' | 'REFUNDS' | 'TAX_DOCUMENTS'
export type FinanceRow = Record<string, unknown>

export async function getFinanceOverview(): Promise<VendorFinanceOverview> {
  return (await financeApi().getVendorFinanceOverview()).data
}

/** Owner-only, audited reveal of the full TIN; call it only on an explicit unmask action and never keep the result. */
export async function revealTin(): Promise<string> {
  return (await financeApi().revealVendorTin()).data.tin
}

export async function updatePhysicalPayments(lockVersion: number, codEnabled: boolean, inStoreEnabled: boolean): Promise<PhysicalPaymentSettings> {
  return (await financeApi().updateVendorPhysicalPayments({ physicalPaymentSettingsUpdate: { lockVersion, codEnabled, inStoreEnabled } })).data
}

/** Payments-tab status filter; each value matches the badge a Payments row shows. */
export type PaymentStatusFilter = ListVendorTransactionsStatusEnum
export type TransactionFilters = DateFilters & { status?: PaymentStatusFilter }

export async function listTransactions(tab: FinanceTab, page = 1, filters: TransactionFilters = {}): Promise<{ items: FinanceRow[]; hasMore: boolean; total: number }> {
  const response = await financeApi().listVendorTransactions({ tab: tab as ListVendorTransactionsTabEnum, page, ...(filters.status ? { status: filters.status } : {}), ...apiDateFilters(filters) })
  const meta = response.meta as { has_more?: boolean; total?: number }
  return { items: response.data as FinanceRow[], hasMore: Boolean(meta.has_more), total: Number(meta.total ?? response.data.length) }
}

/** Owner-only CSV export; the download is audited by the server. */
export async function exportTransactions(tab: FinanceTab, filters: TransactionFilters = {}): Promise<Blob> {
  const raw = await financeApi().exportVendorTransactionsRaw({ tab, ...(filters.status ? { status: filters.status } : {}), ...apiDateFilters(filters) })
  return raw.raw.blob()
}

export async function getEarnings(filters: DateFilters = {}): Promise<VendorEarnings> {
  return (await financeApi().getVendorEarnings(apiDateFilters(filters))).data
}

export async function getStatement(statementId: string): Promise<FeeStatementDetail> {
  return (await financeApi().getVendorFeeStatement({ statementId })).data
}

/** One idempotency key per submitted payment; a retry of the same click reuses it. */
export async function payStatement(statementId: string, channelCode: string, amountCentavos: number | null, idempotencyKey = newIdempotencyKey()): Promise<PaymentAttempt> {
  return (await financeApi().payVendorFeeStatement({ statementId, idempotencyKey, statementPaymentRequest: { channelCode, ...(amountCentavos === null ? {} : { amountCentavos }) } })).data
}

export async function refreshFeePayment(paymentId: string): Promise<PaymentAttempt> {
  return (await financeApi().refreshVendorFeePayment({ paymentId })).data
}

export async function recordPhysicalPayment(orderId: string, amountCentavos: number, file: File, note: string, idempotencyKey = newIdempotencyKey()): Promise<PhysicalPaymentSummary> {
  return (await financeApi().recordVendorPhysicalPayment({ orderId, idempotencyKey, amountCentavos, file, ...(note.trim() ? { note: note.trim() } : {}) })).data
}

export async function approveOnlineBalance(orderId: string): Promise<void> {
  await financeApi().approveVendorOnlineBalance({ orderId, idempotencyKey: newIdempotencyKey() })
}

/** Snake-case JSON section of the overview, read safely. */
export function section(value: unknown): Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value) ? value as Record<string, unknown> : {}
}

export function thresholdData(value: VendorFinanceOverview['threshold']): ThresholdPanelData | null {
  if (!value) return null
  return { taxableYear: value.taxableYear, thresholdCentavos: value.thresholdCentavos, cumulativeGrossCentavos: value.cumulativeGrossCentavos, remainingAllowanceCentavos: value.remainingAllowanceCentavos,
    localGrossCentavos: value.localGrossCentavos, externalDeclaredCentavos: value.externalDeclaredCentavos, externalOverlapCentavos: value.externalOverlapCentavos,
    externalOverlapState: value.externalOverlapState, percentOfThreshold: value.percentOfThreshold, advisory: value.advisory, status: value.status, reasonCode: value.reasonCode,
    crossedAt: value.crossedAt, priorYearTotalCentavos: value.priorYearTotalCentavos, finalForYearNotice: value.finalForYearNotice,
    calculationBreakdown: value.calculationBreakdown }
}

export function channelRows(channels: unknown): PaymentChannelRow[] {
  return (Array.isArray(channels) ? channels : []).map(item => {
    const row = section(item)
    return { code: String(row.code ?? row['code']), displayName: String(row.display_name ?? row.displayName ?? row.code), available: Boolean(row.available),
      unavailableReason: (row.unavailable_reason ?? row.unavailableReason ?? null) as string | null, refundSupported: Boolean(row.refund_supported ?? row.refundSupported),
      rateLabel: String(row.rate_label ?? row.rateLabel ?? ''), feeCentavos: (row.fee_centavos ?? row.feeCentavos ?? null) as number | null, totalCentavos: (row.total_centavos ?? row.totalCentavos ?? null) as number | null }
  })
}


/** Owner-only review status: statement approval and payment, tax adjustments, evidence and open finance reviews. */
export async function getFinanceReviews(): Promise<VendorFinanceReviews> {
  return (await new VendorFinanceReviewsApi(createWebApiConfiguration(basePath, { refreshSession: true })).getVendorFinanceReviews()).data
}
