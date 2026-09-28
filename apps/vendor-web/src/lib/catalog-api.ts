import {
  VendorCatalogApi,
  type CatalogImportJob,
  type CatalogListing,
  type CatalogListingListMeta,
  type CatalogListingSummary,
  type CatalogListingUpdate,
  type CatalogMaterial,
  type CatalogMaterialMatch,
  type CatalogTaxonomy,
  type CatalogVariantInput,
  type CatalogVolumeTier,
  type CatalogVolumeTierInput,
  type ComplianceEvidence,
  type ComplianceSubmission,
  type CompliancePath,
  type ListingStatus,
} from '@materyalph/api-client-ts'
import { createWebApiConfiguration } from '@materyalph/web-ui'
import { newIdempotencyKey } from './onboarding-api'

export { readableOnboardingError as readableCatalogError, onboardingFieldErrors as catalogFieldErrors } from './onboarding-api'
export type { CatalogImportJob, CatalogListing, CatalogListingListMeta, CatalogListingSummary, CatalogMaterial, CatalogMaterialMatch, CatalogTaxonomy, CatalogVariantInput, CatalogVolumeTier, CatalogVolumeTierInput, ComplianceEvidence, CompliancePath }

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'

function catalogApi(): VendorCatalogApi {
  return new VendorCatalogApi(createWebApiConfiguration(basePath, { refreshSession: true }))
}

export async function getCatalogTaxonomy(): Promise<CatalogTaxonomy> {
  return (await catalogApi().getVendorCatalogTaxonomy()).data
}

export async function searchMaterials(q: string): Promise<CatalogMaterialMatch[]> {
  return (await catalogApi().searchCatalogMaterials({ q })).data
}

export async function getMaterial(materialId: string): Promise<CatalogMaterial> {
  return (await catalogApi().getCatalogMaterial({ materialId })).data
}

export async function listListings(filters: { status?: ListingStatus; categoryId?: string; q?: string; page?: number }) {
  const response = await catalogApi().listVendorCatalogListings(filters)
  return { items: response.data, meta: response.meta }
}

export async function getListing(listingId: string): Promise<CatalogListing> {
  return (await catalogApi().getVendorCatalogListing({ listingId })).data
}

export async function createListing(displayName: string, vendorSku: string): Promise<CatalogListing> {
  return (await catalogApi().createVendorCatalogListing({ idempotencyKey: newIdempotencyKey(), catalogListingCreate: { displayName, vendorSku } })).data
}

export async function updateListing(listingId: string, update: CatalogListingUpdate): Promise<CatalogListing> {
  return (await catalogApi().updateVendorCatalogListing({ listingId, catalogListingUpdate: update })).data
}

export async function saveVariants(listingId: string, lockVersion: number, variants: CatalogVariantInput[]): Promise<CatalogListing> {
  return (await catalogApi().saveVendorCatalogVariants({ listingId, catalogVariantsSave: { lockVersion, variants } })).data
}

export async function uploadListingMedia(listingId: string, file: Blob, altText: string | null, replacesMediaId: string | null): Promise<CatalogListing> {
  return (await catalogApi().uploadVendorListingMedia({ listingId, file, altText, replacesMediaId })).data
}

export async function removeListingMedia(listingId: string, mediaId: string): Promise<CatalogListing> {
  return (await catalogApi().removeVendorListingMedia({ listingId, mediaId })).data
}

export async function publishListing(listingId: string, lockVersion: number): Promise<CatalogListing> {
  return (await catalogApi().publishVendorCatalogListing({ listingId, idempotencyKey: newIdempotencyKey(), catalogLockVersion: { lockVersion } })).data
}

export async function deactivateListing(listingId: string, lockVersion: number, reason: string | null): Promise<CatalogListing> {
  return (await catalogApi().deactivateVendorCatalogListing({ listingId, catalogDeactivation: { lockVersion, reason } })).data
}

export async function deleteListing(listingId: string, lockVersion: number): Promise<void> {
  await catalogApi().deleteVendorCatalogListing({ listingId, lockVersion })
}

export async function uploadComplianceEvidence(listingId: string, path: CompliancePath, file: Blob, qrPayload: string | null): Promise<ComplianceEvidence> {
  return (await catalogApi().uploadListingComplianceEvidence({ listingId, path, file, qrPayload })).data
}

export async function submitCompliance(listingId: string, submission: ComplianceSubmission): Promise<CatalogListing> {
  return (await catalogApi().submitListingCompliance({ listingId, idempotencyKey: newIdempotencyKey(), complianceSubmission: submission })).data
}

export async function getCatalogFileUrl(fileId: string): Promise<string> {
  return (await catalogApi().getVendorCatalogFileUrl({ fileId })).data.url
}

export async function getImportTemplate() {
  return (await catalogApi().getCatalogImportTemplate()).data
}

export async function uploadImport(file: Blob): Promise<CatalogImportJob> {
  return (await catalogApi().uploadCatalogImport({ file })).data
}

export async function getImport(jobId: string, page: number): Promise<CatalogImportJob> {
  return (await catalogApi().getCatalogImport({ jobId, page })).data
}

export async function applyImport(jobId: string): Promise<CatalogImportJob> {
  return (await catalogApi().applyCatalogImport({ jobId, idempotencyKey: newIdempotencyKey() })).data
}

/** Converts a peso amount typed by a person into integer centavos without binary floating point. */
export function pesoToCentavos(value: string): number | null {
  const match = /^(\d{1,12})(?:\.(\d{1,2}))?$/.exec(value.replaceAll(',', '').trim())
  if (!match) return null
  const centavos = Number(match[1]) * 100 + Number((match[2] ?? '0').padEnd(2, '0'))
  return centavos > 0 ? centavos : null
}

export function formatCentavos(centavos: number | null | undefined): string {
  if (centavos === null || centavos === undefined) return '—'
  return new Intl.NumberFormat('en-PH', { style: 'currency', currency: 'PHP' }).format(centavos / 100)
}

export function centavosToPeso(centavos: number | null | undefined): string {
  if (centavos === null || centavos === undefined) return ''
  return `${Math.trunc(centavos / 100)}.${String(centavos % 100).padStart(2, '0')}`
}
