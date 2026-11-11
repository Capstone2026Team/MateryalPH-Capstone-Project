import { serializeDate, type AccountMembershipListEnvelope, type CatalogListing, type CatalogMaterial, type CatalogMaterialMatch, type CatalogTaxonomy, type GetVendorTeamPerformanceRequest, type ListVendorTeamActivityRequest, type VendorOrderInvoices, type VendorTeamActivityEnvelope, type VendorTeamPerformanceEnvelope } from '@materyalph/api-client-ts'
import { dateFilterPreset, emptyDeliveryVehicle, type DeliveryVehicleDraft } from '@materyalph/web-ui'
import type { ListAccountMembershipsRequest } from '@materyalph/api-client-ts'

/** Fictional, in-memory records. Never pass these IDs to the API. */
export const sampleTaxonomy: CatalogTaxonomy = {
  categories: [{ id: 'demo-wood', code: 'WOOD_AND_LUMBER', name: 'Wood and Lumber' }],
  units: [{ id: 'demo-sheet', code: 'SHEET', name: 'Sheet', dimension: 'COUNT', precision: 0 }],
  tags: [{ id: 'demo-tag', code: 'BUILDING', name: 'Building materials' }], attributeDefinitions: [],
  taxCategories: ['NON_VAT'], allowedTaxCategories: ['NON_VAT'],
  limits: { maxVariants: 50, maxMedia: 8, maxListingImageKb: 5120, imageTypes: ['image/jpeg', 'image/png', 'image/webp'] },
}
export const sampleMaterial: CatalogMaterial = { id: 'demo-plywood', code: 'PLYWOOD', name: 'Plywood', regulated: false, categoryId: 'demo-wood', categoryName: 'Wood and Lumber', canonicalUnitId: 'demo-sheet', compatibleUnitIds: ['demo-sheet'], suggestedTagIds: ['demo-tag'], regulatedRule: null }
export const sampleMaterialMatch: CatalogMaterialMatch = { ...sampleMaterial, matchType: 'EXACT', matchedText: 'Plywood', similarity: 1 }
export function sampleProduct(): CatalogListing {
  return {
    id: 'demo-product', status: 'DRAFT', lockVersion: 1, displayName: 'Demo plywood 18 mm', vendorSku: 'DEMO-PLY-001', description: 'Sample plywood sheet for learning the listing editor.',
    material: sampleMaterial, materialMatch: 'EXACT', materialCategoryId: 'demo-wood', otherLabel: null, tagIds: ['demo-tag'], customTags: [], technicalAttributes: {},
    brand: 'Demo Timber', model: '18 mm', manufacturer: 'Example Timber Company', manufacturerAddress: 'Example City', countryOfManufacture: 'PH',
    regulated: false, complianceStatus: 'NOT_REQUIRED', regulatedRule: null, publicationVersion: 0, publishedAt: null, publicationRequestedAt: null,
    variants: [{ id: 'demo-variant', sku: 'DEMO-PLY-001-1', label: '18 mm sheet', unitId: 'demo-sheet', unitCode: 'SHEET', packQuantity: '1', attributes: {}, active: true,
      weightKg: '25', lengthCm: '244', widthCm: '122', heightCm: '1.8', lockVersion: 1,
      price: { priceVersionId: 'demo-price', version: 1, amountCentavos: 65000, taxCategory: 'NON_VAT', taxBasis: null, includedVatCentavos: 0, effectiveAt: null },
      inventory: { quantityOnHand: '50', hardReservedQuantity: '0', availableToSell: '50', confirmedAt: new Date().toISOString() }, volumeTiers: [], publicAvailability: 'IN_STOCK', comparability: 'NOT_YET_COMPARABLE' }],
    media: [], complianceSubmissions: [], statusHistory: [], blockers: [], completion: { key: 'LISTING', label: 'Listing', steps: [] }, permissions: { canManage: true, canSubmitCompliance: false },
  }
}
export function sampleVehicle(): DeliveryVehicleDraft {
  return { ...emptyDeliveryVehicle(), key: 'demo-vehicle', category: 'PICKUP', type: 'MID_SIZE_PICKUP', name: 'Demo delivery pickup', brand: 'Example Motors', count: '1', weight: '1000', length: '2.4', width: '1.5', height: '1', heavy: 'NOT_HEAVY', baseFee: '300.00', perKm: '25.00', maxDistance: '25', imageId: 'demo-truck-image' }
}
export function sampleInvoice(): VendorOrderInvoices {
  return {
    orderId: 'demo-order', orderReference: 'DEMO-ORDER-001', status: 'NOT_YET_UPLOADED', issuerName: 'Demo Building Supply', buyerName: 'Example Buyer',
    issuanceNotice: 'Tutorial example only. Issue real invoices through your registered process when legally due.', records: [], requests: [], platformDocuments: [],
    billingDetails: { billingName: 'Example Buyer', billingAddress: 'Example City' }, canUpload: false, canOpenFiles: false,
    invoiceTypes: ['VENDOR_GOODS_INVOICE'], sourceSystems: ['REGISTERED_CAS'], invoicingMethods: ['COMPUTERIZED'],
    lines: [{ orderLineId: 'demo-line', displayName: 'Demo plywood 18 mm' }],
    orderSummary: { lines: [{ orderLineId: 'demo-line', displayName: 'Demo plywood 18 mm', category: 'Wood and Lumber', quantity: '10', unitName: 'Sheet', unitPriceCentavos: 65000, lineTotalCentavos: 650000 }], materialsSubtotalCentavos: 650000, discountCentavos: 0, deliveryCentavos: 30000, includedVatCentavos: 0, totalCentavos: 680000 },
  }
}
export const sampleMembers = async (query: Pick<ListAccountMembershipsRequest, 'search' | 'role'> = {}): Promise<AccountMembershipListEnvelope> => {
  const data = [{ id: 'demo-member', name: 'Demo Inventory Staff', role: 'INVENTORY', status: 'ACTIVE', canManageStaff: false }].filter(member => (!query.search || member.name.toLowerCase().includes(query.search.toLowerCase())) && (!query.role || member.role === query.role))
  return { data, meta: { current_page: 1, last_page: 1, total: data.length }, errors: [] }
}
export const samplePerformance = async (query?: GetVendorTeamPerformanceRequest): Promise<VendorTeamPerformanceEnvelope> => {
  const range = dateFilterPreset(30)
  if (query?.from) range.from = serializeDate(query.from)
  if (query?.to) range.to = serializeDate(query.to)
  return { data: { memberId: 'demo-member', role: 'INVENTORY', timezone: 'Asia/Manila', from: range.from, to: range.to, salesValueVisible: false,
    activity: { total: 8, succeeded: 7, unsuccessful: 1 }, inventory: { stockUpdates: 3, stockConfirmations: 1, listingsCreated: 1, listingUpdates: 2, complianceSubmissions: 0, allotmentUpdates: 0, unsuccessful: 1 },
    trend: { metric: 'INVENTORY_UPDATES', granularity: 'DAY', from: range.from, to: range.to, points: [{ date: range.to, value: 7 }] } }, meta: {}, errors: [] }
}
export const sampleActivity = async (_query?: ListVendorTeamActivityRequest): Promise<VendorTeamActivityEnvelope> => ({ data: [{ id: 'demo-event', actorName: 'Demo Inventory Staff', actorRole: 'INVENTORY', category: 'INVENTORY', correlationId: 'demo-reference', action: 'STOCK_UPDATED', resourceType: 'PRODUCT_VARIANT', resourceId: 'demo-variant', createdAt: new Date(), succeeded: true, before: { quantity: '40' }, after: { quantity: '50' } }], meta: { currentPage: 1, lastPage: 1, total: 1, totalEvents: 8, succeededEvents: 7, failedEvents: 1, categories: [] }, errors: [] })
export const sampleWatch = async () => () => {}
export const sampleError = async () => 'The tutorial example could not open. Close it and try again.'
