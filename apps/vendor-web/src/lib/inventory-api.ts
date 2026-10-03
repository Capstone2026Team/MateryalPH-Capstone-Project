import {
  InventoryRowFromJSON,
  ResponseError,
  VendorAutoAcceptApi,
  VendorFleetApi,
  VendorInventoryApi,
  type AutoAcceptPolicyConfigure,
  type AutoAcceptPolicyDetail,
  type FleetVehicle,
  type FleetVehicleInput,
  type FleetVehicleListMeta,
  type InventoryLedgerMeta,
  type InventoryMovement,
  type InventoryRow,
  type InventoryRowUpdate,
  type InventorySettings,
  type PageMeta,
  type PriceHistoryEntry,
  type StockLabel,
} from '@materyalph/api-client-ts'
import { createWebApiConfiguration } from '@materyalph/web-ui'
import { newIdempotencyKey } from './onboarding-api'

export { readableOnboardingError as readableInventoryError, onboardingFieldErrors as inventoryFieldErrors } from './onboarding-api'
export type { AutoAcceptPolicyDetail, FleetVehicle, FleetVehicleInput, FleetVehicleListMeta, InventoryLedgerMeta, InventoryMovement, InventoryRow, InventorySettings, PageMeta, PriceHistoryEntry, StockLabel }

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'
const configuration = () => createWebApiConfiguration(basePath, { refreshSession: true })
const inventoryApi = () => new VendorInventoryApi(configuration())
const autoAcceptApi = () => new VendorAutoAcceptApi(configuration())
const fleetApi = () => new VendorFleetApi(configuration())

export type InventoryFilters = { q?: string; listingId?: string; stock?: StockLabel; confirmation?: 'DUE' | 'STALE'; page?: number }

export async function listInventory(filters: InventoryFilters): Promise<{ items: InventoryRow[]; meta: InventoryLedgerMeta }> {
  const response = await inventoryApi().listVendorInventoryItems(filters)
  return { items: response.data, meta: response.meta }
}

export async function updateInventoryRow(variantId: string, update: InventoryRowUpdate): Promise<InventoryRow> {
  return (await inventoryApi().updateVendorInventoryItem({ variantId, inventoryRowUpdate: update })).data
}

export async function confirmStock(items: { listingVariantId: string; lockVersion: number }[]): Promise<InventoryRow[]> {
  return (await inventoryApi().confirmVendorStock({ stockConfirmationRequest: { items } })).data
}

export async function listMovements(variantId: string, page = 1): Promise<{ items: InventoryMovement[]; meta: PageMeta }> {
  const response = await inventoryApi().listVendorInventoryMovements({ variantId, page })
  return { items: response.data, meta: response.meta }
}

export async function listPriceHistory(variantId: string): Promise<PriceHistoryEntry[]> {
  return (await inventoryApi().listVendorPriceHistory({ variantId })).data
}

export async function getInventorySettings(): Promise<InventorySettings> {
  return (await inventoryApi().getVendorInventorySettings()).data
}

export async function saveInventorySettings(lockVersion: number, reminderLocalTime: string, emailReminders: boolean, autoAcceptReadyLeadDays?: number | null): Promise<InventorySettings> {
  return (await inventoryApi().saveVendorInventorySettings({ inventorySettingsUpdate: { lockVersion, reminderLocalTime, emailReminders, ...(autoAcceptReadyLeadDays === undefined ? {} : { autoAcceptReadyLeadDays }) } })).data
}

export async function getAutoAccept(variantId: string): Promise<AutoAcceptPolicyDetail> {
  return (await autoAcceptApi().getAutoAcceptPolicy({ variantId })).data
}

export async function configureAutoAccept(variantId: string, policy: AutoAcceptPolicyConfigure): Promise<AutoAcceptPolicyDetail> {
  return (await autoAcceptApi().configureAutoAcceptPolicy({ variantId, autoAcceptPolicyConfigure: policy })).data
}

export async function updateAllotment(variantId: string, lockVersion: number, allotmentQuantity: string): Promise<AutoAcceptPolicyDetail> {
  return (await autoAcceptApi().updateAutoAcceptAllotment({ variantId, autoAcceptAllotmentUpdate: { lockVersion, allotmentQuantity } })).data
}

export async function pauseAutoAccept(variantId: string, lockVersion: number): Promise<AutoAcceptPolicyDetail> {
  return (await autoAcceptApi().pauseAutoAcceptPolicy({ variantId, autoAcceptPause: { lockVersion } })).data
}

export async function resumeAutoAccept(variantId: string, lockVersion: number, confirmedAllotmentQuantity: string): Promise<AutoAcceptPolicyDetail> {
  return (await autoAcceptApi().resumeAutoAcceptPolicy({ variantId, idempotencyKey: newIdempotencyKey(), autoAcceptResume: { lockVersion, confirmedAllotmentQuantity } })).data
}

export async function listFleet(): Promise<{ items: FleetVehicle[]; meta: FleetVehicleListMeta }> {
  const response = await fleetApi().listVendorFleetVehicles()
  return { items: response.data, meta: response.meta }
}

export async function saveFleet(vehicles: FleetVehicleInput[]): Promise<{ items: FleetVehicle[]; meta: FleetVehicleListMeta }> {
  const response = await fleetApi().saveVendorFleetVehicles({ fleetVehiclesSave: { vehicles } })
  return { items: response.data, meta: response.meta }
}

export async function uploadFleetImage(file: Blob): Promise<string> {
  return (await fleetApi().uploadFleetVehicleImage({ file })).data.fileId
}

export async function fleetImageUrl(fileId: string): Promise<string> {
  return (await fleetApi().getFleetVehicleImageUrl({ fileId })).data.url
}

export type ApiFailure = { status: number; code: string | null; details: Record<string, unknown> }

/** Reads the structured error envelope without discarding the caller's unsaved input. */
export async function apiFailure(error: unknown): Promise<ApiFailure | null> {
  if (!(error instanceof ResponseError)) return null
  const payload: unknown = await error.response.clone().json().catch(() => null)
  const first = payload && typeof payload === 'object' && Array.isArray((payload as { errors?: unknown }).errors) ? (payload as { errors: Record<string, unknown>[] }).errors[0] : undefined
  const details = first?.details && typeof first.details === 'object' ? first.details as Record<string, unknown> : {}
  return { status: error.response.status, code: typeof first?.code === 'string' ? first.code : null, details }
}

/** The current saved row returned with a 409 stale-version or price-version conflict. */
export function conflictRow(failure: ApiFailure | null): InventoryRow | null {
  const current = failure?.details.current
  return current && typeof current === 'object' ? InventoryRowFromJSON(current) : null
}

/** Trims trailing zeros from a four-decimal quantity for display. */
export function quantityDisplay(value: string | null | undefined): string {
  if (value === null || value === undefined || value === '') return '—'
  return value.includes('.') ? value.replace(/\.?0+$/, '') : value
}
