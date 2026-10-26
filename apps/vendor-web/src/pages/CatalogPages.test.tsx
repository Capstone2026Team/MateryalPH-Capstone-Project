import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import { ResponseError } from '@materyalph/api-client-ts'
import type { CatalogImportJob, CatalogListing, CatalogListingSummary, CatalogTaxonomy, ComplianceLookup } from '../lib/catalog-api'
import * as catalog from '../lib/catalog-api'
import * as onboarding from '../lib/onboarding-api'
import * as productAnalytics from '../lib/product-analytics-api'
import { autosaveTiming } from '../lib/listing-autosave'
import { decodeQrFromImage } from '../lib/qr-decode'
import { VendorCatalogImportPage, VendorCatalogPage, VendorListingEditorPage } from './CatalogPages'

vi.mock('../lib/qr-decode', () => ({ decodeQrFromImage: vi.fn() }))
vi.mock('../lib/onboarding-api', async original => ({ ...await original<typeof import('../lib/onboarding-api')>(), getVendorOnboarding: vi.fn(), getVendorPrivateFileUrl: vi.fn() }))
vi.mock('../lib/product-analytics-api', async original => ({ ...await original<typeof import('../lib/product-analytics-api')>(), getProductSummaries: vi.fn() }))
vi.mock('../lib/catalog-api', async original => ({
  ...await original<typeof import('../lib/catalog-api')>(),
  getCatalogTaxonomy: vi.fn(), listListings: vi.fn(), getListing: vi.fn(), getMaterial: vi.fn(), saveVariants: vi.fn(), uploadComplianceEvidence: vi.fn(), lookupCompliance: vi.fn(),
  submitCompliance: vi.fn(), getImportTemplate: vi.fn(), uploadImport: vi.fn(), applyImport: vi.fn(), getCatalogFileUrl: vi.fn(), searchMaterials: vi.fn(), updateListing: vi.fn(), deleteListing: vi.fn(), createListing: vi.fn(),
}))

const unit = { id: 'unit-bag', code: 'BAG', name: 'Bag', dimension: 'PACK', precision: 0 }
const taxonomy: CatalogTaxonomy = {
  categories: [{ id: 'cat-cement', code: 'CEMENT_AND_CONCRETE', name: 'Cement and Concrete' }], units: [unit], tags: [{ id: 'tag-1', code: 'STRUCTURAL', name: 'Structural' }],
  attributeDefinitions: [], taxCategories: ['VAT_12', 'VAT_ZERO', 'VAT_EXEMPT', 'NON_VAT'], allowedTaxCategories: ['NON_VAT'],
  limits: { maxVariants: 50, maxMedia: 8, maxListingImageKb: 5120, imageTypes: ['image/jpeg', 'image/png', 'image/webp'] },
}

function listing(overrides: Partial<CatalogListing> = {}): CatalogListing {
  return {
    id: 'listing-1', status: 'DRAFT', lockVersion: 3, displayName: 'Portland cement 40 kg', vendorSku: 'CEM-40', description: 'Bagged cement', material: { id: 'mat-cement', code: 'PORTLAND_CEMENT', name: 'Portland cement', regulated: true },
    materialMatch: 'EXACT', materialCategoryId: 'cat-cement', otherLabel: null, tagIds: ['tag-1'], customTags: [], technicalAttributes: {}, brand: 'BrandCo', model: null, manufacturer: 'Sample Cement Corporation', manufacturerAddress: 'Test City', countryOfManufacture: 'PH',
    regulated: true, complianceStatus: 'NOT_SUBMITTED', regulatedRule: { id: 'rule-1', version: 1, requiredMarking: 'PS_OR_ICC', productName: 'PORTLAND CEMENT', referenceStandard: 'PNS 07:2018', technicalRegulation: 'DAO 17-06:2017', scope: 'Type I', markingRequirements: ['PS Mark', 'Brand name'], sourceReference: 'DTI-BPS' },
    publicationVersion: 0, publishedAt: null, publicationRequestedAt: null,
    variants: [{ id: 'variant-1', sku: 'CEM-40-1', label: '40 kg', unitId: unit.id, unitCode: 'BAG', packQuantity: '1.0000', attributes: {}, active: true, weightKg: '40.000', lengthCm: '60.00', widthCm: '40.00', heightCm: '12.00', lockVersion: 1, price: { priceVersionId: 'price-1', version: 1, amountCentavos: 28550, taxCategory: 'NON_VAT', taxBasis: null, includedVatCentavos: 0, effectiveAt: null }, inventory: { quantityOnHand: '50.0000', hardReservedQuantity: '0.0000', availableToSell: '50.0000', confirmedAt: null }, volumeTiers: [], publicAvailability: 'IN_STOCK', comparability: 'NOT_YET_COMPARABLE' }],
    media: [], complianceSubmissions: [], statusHistory: [],
    completion: { key: 'LISTING', label: 'Listing', steps: [{ key: 'material_classification', label: 'Material and classification', level: 'REQUIRED', status: 'COMPLETED' }, { key: 'product_details', label: 'Product details', level: 'REQUIRED', status: 'COMPLETED' }, { key: 'variants_pricing', label: 'Variants', level: 'REQUIRED', status: 'COMPLETED' }, { key: 'media', label: 'Photos', level: 'REQUIRED', status: 'NOT_STARTED', reason: 'Upload at least one product photo.' }, { key: 'product_compliance', label: 'PS/ICC', level: 'CONDITIONALLY_REQUIRED', status: 'NOT_STARTED' }, { key: 'review_publish', label: 'Review', level: 'REQUIRED', status: 'NOT_STARTED' }] },
    blockers: [{ key: 'media', step: 'media', reason: 'Upload at least one product photo that passed the safety check.' }],
    permissions: { canManage: true, canSubmitCompliance: true },
    ...overrides,
  }
}

beforeEach(() => {
  vi.clearAllMocks()
  autosaveTiming.delayMs = 10
  autosaveTiming.retryMs = 60_000
  vi.mocked(catalog.searchMaterials).mockResolvedValue([])
  vi.mocked(productAnalytics.getProductSummaries).mockResolvedValue({ period: { days: 30, from: new Date('2026-09-11'), to: new Date('2026-10-10'), timezone: 'Asia/Manila' }, items: [] })
  vi.mocked(onboarding.getVendorOnboarding).mockResolvedValue({ stepCompletion: [], lockVersion: 1, requirements: [], drafts: [], organization: { store_name: 'Test Supply' }, welcomeRequired: false, permissions: ['portal.products', 'catalog.manage', 'compliance.submit'], verification: {}, setup: { status: 'COMPLETED' }, activation: { status: 'ACTIVE', marketplaceDiscoverabilityStatus: 'NOT_DISCOVERABLE', readiness: { ready: true, blockers: [], status: 'READY', ruleVersion: 'test' } }, sections: {} })
  vi.mocked(onboarding.getVendorPrivateFileUrl).mockResolvedValue({ url: 'https://example.test/logo', expiresAt: new Date() })
  vi.mocked(catalog.getCatalogTaxonomy).mockResolvedValue(taxonomy)
  vi.mocked(catalog.getListing).mockResolvedValue(listing())
  vi.mocked(catalog.getMaterial).mockResolvedValue({ id: 'mat-cement', code: 'PORTLAND_CEMENT', name: 'Portland cement', regulated: true, categoryId: 'cat-cement', categoryName: 'Cement and Concrete', canonicalUnitId: unit.id, compatibleUnitIds: [unit.id], suggestedTagIds: ['tag-1'], regulatedRule: null })
  vi.mocked(catalog.getCatalogFileUrl).mockResolvedValue('https://example.test/photo.png')
})

function open(path: string) {
  return render(<MemoryRouter initialEntries={[path]}><Routes><Route path="/products" element={<VendorCatalogPage />} /><Route path="/products/import" element={<VendorCatalogImportPage />} /><Route path="/products/new" element={<VendorListingEditorPage />} /><Route path="/products/:listingId" element={<VendorListingEditorPage />} /><Route path="/dashboard" element={<h1>Dashboard</h1>} /></Routes></MemoryRouter>)
}

test('catalog shows summary tiles, status chips and product cards, with a table view from the same data', async () => {
  const summary: CatalogListingSummary = { id: 'listing-1', displayName: 'Portland cement 40 kg', vendorSku: 'CEM-40', status: 'PENDING_COMPLIANCE', complianceStatus: 'NOT_SUBMITTED', regulated: true, lockVersion: 3, variantCount: 1, minPriceCentavos: 28550, maxPriceCentavos: 28550, publicAvailability: 'IN_STOCK', materialName: 'Portland cement', categoryName: 'Cement and Concrete', unitCode: 'BAG', availableQuantity: '480.0000', primaryImageUrl: null }
  vi.mocked(catalog.listListings).mockResolvedValue({ items: [summary], meta: { total: 1, lastPage: 1, statusCounts: { PENDING_COMPLIANCE: 1, ACTIVE: 4 }, activeOutOfStock: 2 } })
  open('/products')
  const cards = await screen.findByRole('list', { name: 'Store products' })
  expect(within(cards).getByRole('link', { name: 'Portland cement 40 kg' })).toHaveAttribute('href', '/products/listing-1')
  expect(within(cards).getByText('₱285.50')).toBeInTheDocument()
  expect(within(cards).getByText('/ bag', { exact: false })).toBeInTheDocument()
  expect(within(cards).getByText('Pending Compliance')).toBeInTheDocument()
  expect(within(cards).getByText('PS/ICC: Not Submitted')).toBeInTheDocument()
  expect(within(cards).getByText('480')).toBeInTheDocument()
  expect(screen.getByRole('button', { name: 'Filter: Total' })).toHaveAttribute('aria-pressed', 'true')
  fireEvent.change(screen.getByRole('combobox', { name: 'Status' }), { target: { value: 'PENDING_COMPLIANCE' } })
  await waitFor(() => expect(catalog.listListings).toHaveBeenLastCalledWith(expect.objectContaining({ status: 'PENDING_COMPLIANCE', page: 1 })))
  expect(screen.getByRole('link', { name: 'Add product' })).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Table' }))
  const table = await screen.findByRole('table', { name: 'Store products' })
  expect(within(table).getByText('₱285.50 / bag')).toBeInTheDocument()
})

test('My Products shows 30-day analytics for each published listing with shortcuts to Product analytics', async () => {
  const summary: CatalogListingSummary = { id: 'listing-1', displayName: 'Portland cement 40 kg', vendorSku: 'CEM-40', status: 'ACTIVE', complianceStatus: 'VERIFIED', regulated: true, lockVersion: 3, variantCount: 1, minPriceCentavos: 28550, maxPriceCentavos: 28550, publicAvailability: 'IN_STOCK', materialName: 'Portland cement', categoryName: 'Cement and Concrete', unitCode: 'BAG', availableQuantity: '480.0000', primaryImageUrl: null, deletable: false }
  const draft: CatalogListingSummary = { ...summary, id: 'listing-2', displayName: 'Unpublished draft', vendorSku: 'DRAFT-1', status: 'DRAFT', deletable: true }
  vi.mocked(catalog.listListings).mockResolvedValue({ items: [summary, draft], meta: { total: 2, lastPage: 1, statusCounts: { ACTIVE: 1, DRAFT: 1 }, activeOutOfStock: 0 } })
  vi.mocked(productAnalytics.getProductSummaries).mockResolvedValue({ period: { days: 30, from: new Date('2026-09-11'), to: new Date('2026-10-10'), timezone: 'Asia/Manila' },
    items: [{ listingId: 'listing-1', views: 42, previousViews: 21, viewsChangePercent: 100, viewers: 30, orders: 6, conversion: { percent: '20.00', numerator: 6, denominator: 30 }, dailyViews: [1, 2, 3] }] })
  open('/products')
  const cards = await screen.findByRole('list', { name: 'Store products' })
  expect(await within(cards).findByText('42')).toBeInTheDocument()
  expect(productAnalytics.getProductSummaries).toHaveBeenCalledWith(['listing-1'], 30)
  expect(within(cards).getByText('20.00%')).toBeInTheDocument()
  expect(within(cards).getAllByRole('link', { name: 'View product analytics' })).toHaveLength(1)
  expect(within(cards).getByRole('link', { name: 'View product analytics' })).toHaveAttribute('href', '/performance/products/listing-1')
  expect(screen.getByRole('link', { name: 'Product analytics' })).toHaveAttribute('href', '/performance?tab=products')
  fireEvent.click(screen.getByRole('button', { name: 'Table' }))
  const table = await screen.findByRole('table', { name: 'Store products' })
  expect(within(table).getByText('Not published yet')).toBeInTheDocument()
})

test('an empty catalog explains that activation does not need products and offers the next action', async () => {
  vi.mocked(catalog.listListings).mockResolvedValue({ items: [], meta: { total: 0, lastPage: 1, statusCounts: {}, activeOutOfStock: 0 } })
  open('/products')
  expect(await screen.findByText('No products yet.')).toBeVisible()
  expect(screen.getByText(/stays active without products/)).toBeVisible()
  expect(screen.getByRole('link', { name: 'Add your first product' })).toBeVisible()
})

test('catalog stays closed before Store Activation without blocking the store', async () => {
  vi.mocked(onboarding.getVendorOnboarding).mockResolvedValue({ stepCompletion: [], lockVersion: 1, requirements: [], drafts: [], organization: {}, welcomeRequired: false, permissions: ['portal.products', 'catalog.manage'], verification: {}, setup: {}, activation: { status: 'NOT_READY', marketplaceDiscoverabilityStatus: 'NOT_DISCOVERABLE', readiness: { ready: false, blockers: [], status: 'NOT_READY', ruleVersion: 'test' } }, sections: {} })
  open('/products')
  expect(await screen.findByText(/Products are not required to activate your store/)).toBeVisible()
  expect(catalog.listListings).not.toHaveBeenCalled()
})

test('a draft saves itself shortly after an edit and says so', async () => {
  vi.mocked(catalog.updateListing).mockResolvedValue(listing({ lockVersion: 4, displayName: 'Portland cement 50 kg' }))
  open('/products/listing-1?step=1')
  const name = await screen.findByRole('textbox', { name: /Display name/ })
  expect(screen.getAllByRole('status').some(status => status.textContent === 'All changes saved')).toBe(true)
  fireEvent.change(name, { target: { value: 'Portland cement 50 kg' } })
  await waitFor(() => expect(catalog.updateListing).toHaveBeenCalledWith('listing-1', expect.objectContaining({ lockVersion: 3, displayName: 'Portland cement 50 kg', customTags: [] })))
  expect(catalog.saveVariants).not.toHaveBeenCalled()
  await waitFor(() => expect(screen.getAllByRole('status').some(status => /All changes saved ·/.test(status.textContent ?? ''))).toBe(true))
  // What the Vendor typed stays on screen while the server answers.
  expect(name).toHaveValue('Portland cement 50 kg')
})

test('an incomplete variant row is not saved and the status line names what is missing', async () => {
  open('/products/listing-1?step=1')
  await screen.findByRole('group', { name: 'Variants' })
  fireEvent.click(screen.getByRole('button', { name: 'Add variant' }))
  await waitFor(() => expect(screen.getAllByRole('status').some(status => /Not saved yet: Choose a sale unit\./.test(status.textContent ?? ''))).toBe(true))
  expect(catalog.saveVariants).not.toHaveBeenCalled()
})

test('a failed save keeps the edit, reports the problem and can be retried', async () => {
  vi.mocked(catalog.updateListing).mockRejectedValueOnce(new Error('offline')).mockResolvedValue(listing({ lockVersion: 4, displayName: 'Cement' }))
  open('/products/listing-1?step=1')
  fireEvent.change(await screen.findByRole('textbox', { name: /Display name/ }), { target: { value: 'Cement' } })
  fireEvent.click(await screen.findByRole('button', { name: 'Try again' }))
  await waitFor(() => expect(catalog.updateListing).toHaveBeenCalledTimes(2))
  expect(screen.getByRole('textbox', { name: /Display name/ })).toHaveValue('Cement')
})

test('a live listing is saved by hand because every save reaches Buyers', async () => {
  vi.mocked(catalog.getListing).mockResolvedValue(listing({ status: 'ACTIVE', complianceStatus: 'VERIFIED' }))
  vi.mocked(catalog.updateListing).mockResolvedValue(listing({ status: 'ACTIVE', complianceStatus: 'VERIFIED', lockVersion: 4, description: 'Updated' }))
  open('/products/listing-1?step=1')
  fireEvent.change(await screen.findByRole('textbox', { name: /Description/ }), { target: { value: 'Updated' } })
  expect(await screen.findByRole('button', { name: 'Save changes' })).toBeVisible()
  await new Promise(resolve => setTimeout(resolve, 60))
  expect(catalog.updateListing).not.toHaveBeenCalled()
  fireEvent.click(screen.getByRole('button', { name: 'Save changes' }))
  await waitFor(() => expect(catalog.updateListing).toHaveBeenCalledWith('listing-1', expect.objectContaining({ description: 'Updated' })))
  expect(await screen.findByText('Changes saved.')).toBeVisible()
})

test('a Vendor adds and removes their own search tags and they are saved with the listing', async () => {
  vi.mocked(catalog.updateListing).mockResolvedValue(listing({ lockVersion: 4 }))
  open('/products/listing-1')
  const field = await screen.findByRole('textbox', { name: 'Your own tags' })
  fireEvent.change(field, { target: { value: '  rebar   10mm ' } })
  fireEvent.keyDown(field, { key: 'Enter' })
  const tags = within(screen.getByRole('list', { name: 'Your own search tags' }))
  expect(tags.getByText('rebar 10mm')).toBeVisible()
  fireEvent.change(field, { target: { value: 'REBAR 10MM' } })
  fireEvent.keyDown(field, { key: 'Enter' })
  expect(await screen.findByText(/already added/)).toBeVisible()
  await waitFor(() => expect(catalog.updateListing).toHaveBeenCalledWith('listing-1', expect.objectContaining({ tagIds: ['tag-1'], customTags: ['rebar 10mm'] })))
  fireEvent.click(tags.getByRole('button', { name: 'Remove tag rebar 10mm' }))
  await waitFor(() => expect(catalog.updateListing).toHaveBeenLastCalledWith('listing-1', expect.objectContaining({ customTags: [] })))
})

test('variant rows validate per row inline and show server row errors in the matching row', async () => {
  vi.mocked(catalog.getListing).mockResolvedValue(listing({ status: 'ACTIVE', complianceStatus: 'VERIFIED' }))
  vi.mocked(catalog.saveVariants).mockRejectedValue(new Error('rejected'))
  open('/products/listing-1?step=1')
  await screen.findByRole('group', { name: 'Variants' })
  fireEvent.click(screen.getByRole('button', { name: 'Add variant' }))
  const second = screen.getByRole('region', { name: 'Variant 2' })
  fireEvent.click(screen.getByRole('button', { name: 'Save changes' }))
  expect(await within(second).findByText('Choose a sale unit.')).toBeVisible()
  // The message appears in the row summary and inline on its field, which is marked invalid.
  expect(within(second).getAllByText('Enter a price in pesos, for example 285.50.')).toHaveLength(2)
  expect(within(second).getByRole('textbox', { name: /^Price \(PHP/ })).toHaveAttribute('aria-invalid', 'true')
  expect(within(screen.getByRole('region', { name: 'Variant 1 — 40 kg' })).queryByRole('alert')).not.toBeInTheDocument()
  expect(catalog.saveVariants).not.toHaveBeenCalled()
  expect(catalog.updateListing).not.toHaveBeenCalled()
  expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
})

const tileRecord: ComplianceLookup = {
  markingType: 'ICC_STICKER', number: 'A988239400', result: 'MATCHED', reason: null, canVerifyAutomatically: true,
  message: 'Found in the DTI-BPS List of ICC Certificate Holders dated 2026-09-30. The details below come from that record.',
  register: { registerKind: 'ICC_CERTIFICATE', snapshotDate: '2026-09-30', sourceReference: 'DTI-BPS' },
  record: { registerKind: 'ICC_CERTIFICATE', companyName: '21TH CONSTRUCTION DEVELOPMENT', productDescription: 'CERAMIC TILES', brand: 'BEETHOVEN', referenceStandard: 'PNS ISO 13006:2019', iccCertificateNumber: '002541/0524', serialRange: 'A988239313 – A988295070' },
}
const notListed: ComplianceLookup = {
  markingType: 'PS_MARK', number: 'Q-9999', result: 'UNMATCHED', reason: 'NUMBER_NOT_FOUND', canVerifyAutomatically: false, record: null,
  message: 'No record with this PS License No. is in the DTI-BPS List of PS Licensees dated 2026-09-30. Check the number against the marking and try again, or request a manual review.',
  register: { registerKind: 'PS_LICENSE', snapshotDate: '2026-09-30', sourceReference: 'DTI-BPS' },
}

test('an ICC sticker QR code is read in the browser and only the serial is needed for automatic verification', async () => {
  vi.mocked(decodeQrFromImage).mockResolvedValue('https://icc.example.gov.ph/verify?serial=A988239400')
  vi.mocked(catalog.uploadComplianceEvidence).mockResolvedValue({ evidenceId: 'evidence-1', fileId: 'file-1', path: 'QR', evidenceKind: 'QR_IMAGE', contentType: 'image/png', byteSize: 2048, scanState: 'CLEAN', extraction: { source: 'QR', provider: 'BROWSER_QR_DECODER', status: 'EXTRACTED', confidence: 0.9, suggestions: { marking_type: 'ICC_STICKER', certificate_number: 'A988239400' }, registerListed: true, assistanceOnly: true } })
  vi.mocked(catalog.lookupCompliance).mockResolvedValue(tileRecord)
  vi.mocked(catalog.submitCompliance).mockResolvedValue(listing({ complianceStatus: 'VERIFIED', status: 'ACTIVE' }))
  open('/products/listing-1?step=2')
  const paths = await screen.findByRole('group', { name: 'How will you provide the marking?' })
  expect(within(paths).getAllByRole('radio')).toHaveLength(3)
  expect(screen.getByText('PNS 07:2018')).toBeVisible()
  fireEvent.click(within(screen.getByRole('group', { name: 'Marking on the product' })).getByRole('radio', { name: /ICC sticker/ }))
  fireEvent.click(within(paths).getByRole('radio', { name: /QR code scan or upload/ }))
  const image = new File(['qr'], 'qr.png', { type: 'image/png' })
  fireEvent.change(screen.getByLabelText(/QR code image/), { target: { files: [image] } })
  // The chosen image is checked first; nothing is uploaded until the Vendor confirms it.
  expect(await screen.findByRole('heading', { name: 'Check the photo before uploading' })).toBeVisible()
  expect(catalog.uploadComplianceEvidence).not.toHaveBeenCalled()
  fireEvent.click(screen.getByRole('button', { name: 'Upload this photo' }))
  await waitFor(() => expect(catalog.uploadComplianceEvidence).toHaveBeenCalledWith('listing-1', 'QR', image, 'https://icc.example.gov.ph/verify?serial=A988239400', 'ICC_STICKER'))
  expect(await screen.findByText('Found in the DTI-BPS register')).toBeVisible()
  expect(catalog.lookupCompliance).toHaveBeenCalledWith('listing-1', 'ICC_STICKER', 'A988239400')
  expect(screen.getByRole('textbox', { name: /ICC sticker serial no/ })).toHaveValue('A988239400')
  expect(screen.getByText(/Read A988239400 from the QR code, and it is listed/)).toBeVisible()
  // The register record fills in the importer and product; the Vendor types nothing else.
  expect(screen.getByText('21TH CONSTRUCTION DEVELOPMENT')).toBeVisible()
  expect(screen.getByText('A988239313 – A988295070')).toBeVisible()
  expect(screen.queryByRole('textbox', { name: /Importer name/ })).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: /Request manual review/ })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Submit for automatic verification' }))
  expect(await screen.findByText('Confirm that you checked the number against the physical marking.')).toBeVisible()
  expect(catalog.submitCompliance).not.toHaveBeenCalled()
  fireEvent.click(screen.getByRole('checkbox', { name: /I checked this ICC sticker serial no/ }))
  fireEvent.click(screen.getByRole('button', { name: 'Submit for automatic verification' }))
  await waitFor(() => expect(catalog.submitCompliance).toHaveBeenCalledWith('listing-1', expect.objectContaining({ path: 'QR', markingType: 'ICC_STICKER', certificateNumber: 'A988239400', reviewMode: 'AUTOMATIC', evidenceIds: ['evidence-1'], confirmed: true })))
  expect(await screen.findByText('Verified through a match with the current DTI-BPS register.')).toBeVisible()
})

test('an unlisted number is never sent to Admins automatically; the Vendor edits, retries or asks for manual review', async () => {
  vi.mocked(catalog.uploadComplianceEvidence).mockResolvedValue({ evidenceId: 'evidence-ocr', fileId: 'file-ocr', path: 'PHOTO_OCR', evidenceKind: 'MARKING_PHOTO', contentType: 'image/png', byteSize: 2048, scanState: 'CLEAN', extraction: { source: 'OCR', provider: 'TESSERACT', status: 'FAILED', confidence: null, suggestions: {}, registerListed: false, assistanceOnly: true } })
  vi.mocked(catalog.lookupCompliance).mockResolvedValue(notListed)
  vi.mocked(catalog.submitCompliance).mockResolvedValue(listing({ complianceStatus: 'PENDING_ADMIN_REVIEW', status: 'PENDING_ADMIN_REVIEW' }))
  open('/products/listing-1?step=2')
  fireEvent.change(await screen.findByLabelText(/Upload PS Mark marking photo/), { target: { files: [new File(['photo'], 'mark.png', { type: 'image/png' })] } })
  fireEvent.click(screen.getByRole('button', { name: 'Upload this photo' }))
  expect(await screen.findByText(/The PS License No. could not be read from this photo/)).toBeVisible()
  expect(within(screen.getByRole('list', { name: 'Uploaded marking photos' })).getByText('Marking photo 1')).toBeVisible()
  // A PS Mark photo never runs the browser QR reader.
  expect(decodeQrFromImage).not.toHaveBeenCalled()
  // Typing a complete number checks the register automatically.
  fireEvent.change(screen.getByRole('textbox', { name: /PS License No/ }), { target: { value: 'Q-9999' } })
  expect(await screen.findByText('Not found in the DTI-BPS register', {}, { timeout: 3000 })).toBeVisible()
  expect(catalog.lookupCompliance).toHaveBeenCalledWith('listing-1', 'PS_MARK', 'Q-9999')
  expect(screen.queryByRole('button', { name: 'Submit for automatic verification' })).not.toBeInTheDocument()
  expect(catalog.submitCompliance).not.toHaveBeenCalled()
  fireEvent.click(screen.getByRole('button', { name: /Try again/ }))
  await waitFor(() => expect(catalog.lookupCompliance).toHaveBeenCalledTimes(2))
  fireEvent.click(await screen.findByRole('button', { name: /Edit number/ }))
  expect(screen.getByRole('textbox', { name: /PS License No/ })).toHaveFocus()
  fireEvent.click(screen.getByRole('button', { name: /Request manual review/ }))
  const form = screen.getByRole('form', { name: 'Request manual review' })
  fireEvent.change(within(form).getByRole('textbox', { name: /Note for the reviewer/ }), { target: { value: 'Licence issued this month.' } })
  fireEvent.click(within(form).getByRole('button', { name: 'Send for manual review' }))
  expect(await screen.findByText('Confirm that you checked the number against the physical marking.')).toBeVisible()
  fireEvent.click(within(form).getByRole('checkbox', { name: /I checked this PS License No/ }))
  fireEvent.click(within(form).getByRole('button', { name: 'Send for manual review' }))
  await waitFor(() => expect(catalog.submitCompliance).toHaveBeenCalledWith('listing-1', expect.objectContaining({ path: 'PHOTO_OCR', certificateNumber: 'Q-9999', reviewMode: 'MANUAL_REVIEW', reviewNote: 'Licence issued this month.', evidenceIds: ['evidence-ocr'] })))
  expect(await screen.findByText(/Sent for manual review/)).toBeVisible()
})

test('manual entry needs a marking photo, and a register change at submission shows the new result instead of an error', async () => {
  vi.mocked(catalog.lookupCompliance).mockResolvedValue({ ...notListed, number: 'Q-7001', result: 'MATCHED', reason: null, canVerifyAutomatically: true, message: 'Found in the DTI-BPS List of PS Licensees dated 2026-09-30.', record: { registerKind: 'PS_LICENSE', companyName: 'Sample Cement Corporation', productDescription: 'PORTLAND CEMENT TYPE I', licenseNumber: 'Q-7001' } })
  vi.mocked(catalog.uploadComplianceEvidence).mockResolvedValue({ evidenceId: 'evidence-m', fileId: 'file-m', path: 'MANUAL', evidenceKind: 'MARKING_PHOTO', contentType: 'image/png', byteSize: 2048, scanState: 'CLEAN', extraction: { source: null, provider: null, status: 'NOT_REQUESTED', confidence: null, suggestions: {}, registerListed: false, assistanceOnly: true } })
  const refused = { ...notListed, number: 'Q-7001', result: 'UNCERTAIN', reason: 'PRODUCT_NOT_COVERED', message: 'This PS License No. is listed for electric fans, not for portland cement.', record: { register_kind: 'PS_LICENSE', company_name: 'Fan Makers Inc.', product_description: 'ELECTRIC FANS' } }
  vi.mocked(catalog.submitCompliance).mockRejectedValue(new ResponseError(new Response(JSON.stringify({ data: null, meta: {}, errors: [{ code: 'COMPLIANCE_REGISTER_NOT_MATCHED', message: refused.message, details: { lookup: { marking_type: 'PS_MARK', number: 'Q-7001', result: 'UNCERTAIN', reason: 'PRODUCT_NOT_COVERED', message: refused.message, can_verify_automatically: false, register: null, record: refused.record } } }] }), { status: 422, headers: { 'Content-Type': 'application/json' } }), 'Response returned an error code'))
  open('/products/listing-1?step=2')
  fireEvent.click(within(await screen.findByRole('group', { name: 'How will you provide the marking?' })).getByRole('radio', { name: /Manual entry/ }))
  fireEvent.change(screen.getByRole('textbox', { name: /PS License No/ }), { target: { value: 'Q-7001' } })
  fireEvent.click(screen.getByRole('button', { name: 'Check number' }))
  expect(await screen.findByText('Sample Cement Corporation')).toBeVisible()
  fireEvent.click(screen.getByRole('checkbox', { name: /I checked this PS License No/ }))
  fireEvent.click(screen.getByRole('button', { name: 'Submit for automatic verification' }))
  expect(await screen.findByText('Upload a clear photo of the PS Mark above. It is kept privately as evidence.')).toBeVisible()
  expect(catalog.submitCompliance).not.toHaveBeenCalled()
  fireEvent.change(screen.getByLabelText(/Upload PS Mark marking photo/), { target: { files: [new File(['photo'], 'mark.png', { type: 'image/png' })] } })
  fireEvent.click(screen.getByRole('button', { name: 'Upload this photo' }))
  expect(await screen.findByText(/Photo attached/)).toBeVisible()
  // A manual-entry photo keeps the number the Vendor typed.
  expect(screen.getByRole('textbox', { name: /PS License No/ })).toHaveValue('Q-7001')
  expect(screen.getByRole('checkbox', { name: /I checked this PS License No/ })).toBeChecked()
  fireEvent.click(screen.getByRole('button', { name: 'Submit for automatic verification' }))
  expect(await screen.findByText('Listed for a different product')).toBeVisible()
  expect(screen.getByText('Fan Makers Inc.')).toBeVisible()
  expect(screen.queryByText(/error code/i)).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Submit for automatic verification' })).not.toBeInTheDocument()
  expect(screen.getByRole('button', { name: /Request manual review/ })).toBeVisible()
})

test('review step lists server blockers with a jump to the owning step', async () => {
  open('/products/listing-1?step=3')
  expect(await screen.findAllByText('Upload at least one product photo that passed the safety check.')).toHaveLength(2)
  expect(screen.getByRole('region', { name: 'Publication gate' })).toHaveTextContent('1 item before publishing')
  expect(screen.getByRole('button', { name: 'Request publication' })).toBeDisabled()
  fireEvent.click(screen.getByRole('button', { name: 'Go to step 3' }))
  expect(await screen.findByRole('heading', { name: 'Photos and compliance', level: 2 })).toBeVisible()
  expect(screen.getByText(/Accepted: JPG, PNG or WebP/)).toBeVisible()
})

test('bulk import never reports partial validation as success and links to each rejected row', async () => {
  vi.mocked(catalog.getImportTemplate).mockResolvedValue({ templateVersion: 'catalog-import.v1', columns: ['vendor_sku', 'display_name'], requiredColumns: ['vendor_sku'], maxRows: 500 })
  const job: CatalogImportJob = { id: 'job-1', status: 'HAS_ERRORS', templateVersion: 'catalog-import.v1', totalRows: 3, validRows: 2, errorRows: 1, appliedRows: 0, rowErrors: [{ rowNumber: 4, vendorSku: 'IMP-BAD', variantSku: 'IMP-BAD-1', errors: { price_php: ['Enter a peso amount greater than zero.'] } }], rowErrorsMeta: { last_page: 1 } }
  vi.mocked(catalog.uploadImport).mockResolvedValue(job)
  vi.mocked(catalog.applyImport).mockResolvedValue({ ...job, status: 'APPLIED_WITH_REJECTIONS', appliedRows: 2 })
  open('/products/import')
  fireEvent.change(await screen.findByLabelText(/CSV file/), { target: { files: [new File(['a,b'], 'catalog.csv', { type: 'text/csv' })] } })
  expect(await screen.findByText(/1 of 3 rows have problems. Nothing is saved yet./)).toBeVisible()
  expect(screen.getByRole('link', { name: 'Row 4' })).toHaveAttribute('href', '#import-row-4')
  expect(screen.getByRole('rowheader', { name: 'Row 4' }).closest('tr')).toHaveAttribute('id', 'import-row-4')
  fireEvent.click(screen.getByRole('button', { name: 'Apply 2 valid rows' }))
  expect(await screen.findByText(/Partially imported: 2 rows became draft listings and 1 rows were not imported/)).toBeVisible()
  expect(screen.getByText(/Partially imported/).closest('[role]')).toHaveAttribute('role', 'alert')
})

test('volume tiers are checked against the ordinary price before they are saved', async () => {
  vi.mocked(catalog.saveVariants).mockResolvedValue(listing({ lockVersion: 4 }))
  open('/products/listing-1?step=1')
  const first = await screen.findByRole('region', { name: 'Variant 1 — 40 kg' })
  fireEvent.click(within(first).getByRole('button', { name: 'Add tier' }))
  fireEvent.change(within(first).getByRole('textbox', { name: /Minimum quantity/ }), { target: { value: '50' } })
  fireEvent.change(within(first).getByRole('textbox', { name: 'Price per unit (PHP)' }), { target: { value: '290' } })
  await waitFor(() => expect(screen.getAllByRole('status').some(status => /Not saved yet: A tier price must be lower than the ordinary price\./.test(status.textContent ?? ''))).toBe(true))
  expect(catalog.saveVariants).not.toHaveBeenCalled()
  fireEvent.change(within(first).getByRole('textbox', { name: 'Price per unit (PHP)' }), { target: { value: '260' } })
  expect(within(first).getByText('50+ bag')).toBeInTheDocument()
  // Only the variants changed, so the details are not written again; the unchanged stock count is not re-recorded.
  await waitFor(() => expect(catalog.saveVariants).toHaveBeenCalledWith('listing-1', 3, [expect.objectContaining({ id: 'variant-1', priceCentavos: 28550, quantityOnHand: null, volumeTiers: [{ minimumQuantity: '50', priceCentavos: 26000 }] })]))
  expect(catalog.updateListing).not.toHaveBeenCalled()
  await waitFor(() => expect(screen.getAllByRole('status').some(status => /All changes saved ·/.test(status.textContent ?? ''))).toBe(true))
})

const steelTaxonomy: CatalogTaxonomy = {
  ...taxonomy,
  categories: [...taxonomy.categories, { id: 'cat-steel', code: 'STEEL_AND_REINFORCEMENT', name: 'Steel and Reinforcement' }],
  units: [unit, { id: 'unit-pc', code: 'PC', name: 'Piece', dimension: 'COUNT', precision: 0 }],
  attributeDefinitions: [
    { id: 'def-diameter', materialCategoryId: 'cat-steel', code: 'diameter_mm', label: 'Nominal diameter or leg size', valueType: 'NUMBER', required: true, allowedValues: null, unitCode: 'mm', comparabilityKey: true },
    { id: 'def-length', materialCategoryId: 'cat-steel', code: 'length_m', label: 'Length', valueType: 'NUMBER', required: true, allowedValues: null, unitCode: 'm', comparabilityKey: true },
  ],
}

function steelListing(): CatalogListing {
  const base = listing()
  return listing({
    displayName: 'Rerolled steel bar', material: { id: 'mat-deformed', code: 'DEFORMED_STEEL_BAR', name: 'Deformed steel bar', regulated: true }, materialMatch: 'FUZZY_CONFIRMED', materialCategoryId: 'cat-steel',
    technicalAttributes: { diameter_mm: '15', length_m: '120' },
    variants: [{ ...base.variants[0]!, label: null, unitId: 'unit-pc', unitCode: 'PC', weightKg: '20.000', lengthCm: '231.00', widthCm: '323.00', heightCm: '123123.00' }],
  })
}

test('Product information shows the Buyer category and checks weight and dimensions against Technical details', async () => {
  vi.mocked(catalog.getCatalogTaxonomy).mockResolvedValue(steelTaxonomy)
  vi.mocked(catalog.getListing).mockResolvedValue(steelListing())
  vi.mocked(catalog.getMaterial).mockResolvedValue({ id: 'mat-deformed', code: 'DEFORMED_STEEL_BAR', name: 'Deformed steel bar', regulated: true, categoryId: 'cat-steel', categoryName: 'Steel and Reinforcement', canonicalUnitId: 'unit-pc', compatibleUnitIds: ['unit-pc'], suggestedTagIds: [], regulatedRule: null })
  vi.mocked(catalog.updateListing).mockResolvedValue(steelListing())
  vi.mocked(catalog.saveVariants).mockResolvedValue(steelListing())
  open('/products/listing-1?step=1')
  const category = await screen.findByRole('region', { name: 'Category' })
  expect(within(category).getByText('Steel and Reinforcement')).toBeVisible()
  expect(within(category).getByText('Deformed steel bar', { selector: 'strong' })).toBeVisible()
  expect(within(category).getByText(/match on the material/)).toBeVisible()
  expect(screen.getByText(/usually supplied 6 to 12 m long/)).toBeVisible()

  const variant = screen.getByRole('region', { name: 'Variant 1' })
  const measures = within(variant).getByRole('region', { name: 'Weight and dimensions' })
  expect(within(measures).getByText(/longer than any delivery truck bed/)).toBeVisible()
  expect(within(measures).getByText(/lighter than packing foam/)).toBeVisible()

  fireEvent.change(screen.getByRole('textbox', { name: /^Length \(m\)/ }), { target: { value: '12' } })
  expect(within(measures).getByText(/Weight 16\.667 kg · Length 1,200 cm · Width 1\.5 cm · Height 1\.5 cm/)).toBeVisible()
  fireEvent.click(within(measures).getByRole('button', { name: 'Apply suggestion' }))
  expect(within(measures).getByRole('textbox', { name: 'Length (cm)' })).toHaveValue('1200')
  expect(within(measures).getByText('Matches the Technical details.')).toBeVisible()
  expect(within(measures).queryByText(/lighter than packing foam/)).not.toBeInTheDocument()
  fireEvent.click(within(variant).getByRole('button', { name: 'Use “15 mm × 12 m”' }))
  expect(within(variant).getByRole('textbox', { name: 'Label' })).toHaveValue('15 mm × 12 m')

  await waitFor(() => expect(catalog.saveVariants).toHaveBeenCalledWith('listing-1', 3, [expect.objectContaining({ label: '15 mm × 12 m', weightKg: '16.667', lengthCm: '1200', widthCm: '1.5', heightCm: '1.5' })]))
  expect(catalog.updateListing).toHaveBeenCalledWith('listing-1', expect.objectContaining({ technicalAttributes: { diameter_mm: '15', length_m: '12' } }))
})

test('an Other-label listing picks its Buyer category from the same category tiles', async () => {
  vi.mocked(catalog.getCatalogTaxonomy).mockResolvedValue(steelTaxonomy)
  vi.mocked(catalog.getListing).mockResolvedValue(listing({ material: null, otherLabel: 'Steel tubing', materialCategoryId: 'cat-cement', regulated: false, complianceStatus: 'NOT_REQUIRED', regulatedRule: null }))
  vi.mocked(catalog.updateListing).mockResolvedValue(listing({ lockVersion: 4 }))
  vi.mocked(catalog.saveVariants).mockResolvedValue(listing({ lockVersion: 5 }))
  open('/products/listing-1?step=1')
  const tiles = await screen.findByRole('group', { name: 'Buyer category' })
  expect(within(tiles).getByRole('radio', { name: 'Cement and Concrete' })).toBeChecked()
  fireEvent.click(within(tiles).getByRole('radio', { name: 'Steel and Reinforcement' }))
  expect(screen.getByRole('textbox', { name: /Nominal diameter/ })).toBeVisible()
  await waitFor(() => expect(catalog.updateListing).toHaveBeenCalledWith('listing-1', expect.objectContaining({ materialId: null, materialCategoryId: 'cat-steel', technicalAttributes: {} })))
})

test('a never-published draft can be deleted from its card after confirmation', async () => {
  const draft: CatalogListingSummary = { id: 'listing-9', displayName: 'Gravel draft', vendorSku: 'GRAVEL-1', status: 'DRAFT', complianceStatus: 'NOT_REQUIRED', regulated: false, lockVersion: 2, variantCount: 0, publicAvailability: 'OUT_OF_STOCK', deletable: true }
  const published: CatalogListingSummary = { ...draft, id: 'listing-8', displayName: 'Sand active', vendorSku: 'SAND-1', status: 'ACTIVE', deletable: false }
  vi.mocked(catalog.listListings).mockResolvedValue({ items: [draft, published], meta: { total: 2, lastPage: 1, statusCounts: { DRAFT: 1, ACTIVE: 1 }, activeOutOfStock: 1 } })
  vi.mocked(catalog.deleteListing).mockResolvedValue()
  open('/products')
  const cards = await screen.findByRole('list', { name: 'Store products' })
  expect(within(cards).queryByRole('button', { name: 'Delete Sand active' })).not.toBeInTheDocument()
  fireEvent.click(within(cards).getByRole('button', { name: 'Delete Gravel draft' }))
  const dialog = await screen.findByRole('dialog', { name: 'Delete this draft?' })
  expect(within(dialog).getByText(/Gravel draft/)).toBeVisible()
  fireEvent.click(within(dialog).getByRole('button', { name: 'Cancel' }))
  expect(catalog.deleteListing).not.toHaveBeenCalled()
  fireEvent.click(within(cards).getByRole('button', { name: 'Delete Gravel draft' }))
  fireEvent.click(within(await screen.findByRole('dialog', { name: 'Delete this draft?' })).getByRole('button', { name: 'Delete draft' }))
  await waitFor(() => expect(catalog.deleteListing).toHaveBeenCalledWith('listing-9', 2))
  expect(await screen.findByText('“Gravel draft” was deleted.')).toBeVisible()
  await waitFor(() => expect(catalog.listListings).toHaveBeenCalledTimes(2))
})

test('the listing editor offers Delete draft only when the server allows it and returns to My Products', async () => {
  vi.mocked(catalog.getListing).mockResolvedValue(listing({ permissions: { canManage: true, canSubmitCompliance: true, canDelete: true } }))
  vi.mocked(catalog.deleteListing).mockResolvedValue()
  vi.mocked(catalog.listListings).mockResolvedValue({ items: [], meta: { total: 0, lastPage: 1, statusCounts: {}, activeOutOfStock: 0 } })
  open('/products/listing-1')
  fireEvent.click(await screen.findByRole('button', { name: 'Delete draft' }))
  fireEvent.click(within(await screen.findByRole('dialog', { name: 'Delete this draft?' })).getByRole('button', { name: 'Delete draft' }))
  await waitFor(() => expect(catalog.deleteListing).toHaveBeenCalledWith('listing-1', 3))
  expect(await screen.findByText('“Portland cement 40 kg” was deleted.')).toBeVisible()
})

test('the material name becomes the suggested display name and the chosen material is saved with the draft', async () => {
  vi.mocked(catalog.searchMaterials).mockResolvedValue([{ id: 'mat-cement', code: 'PORTLAND_CEMENT', name: 'Portland cement', categoryId: 'cat-cement', categoryName: 'Cement and Concrete', regulated: true, matchType: 'EXACT', matchedText: 'Portland cement', similarity: 1 }])
  vi.mocked(catalog.createListing).mockResolvedValue(listing({ lockVersion: 1, material: null, displayName: 'Portland cement' }))
  vi.mocked(catalog.updateListing).mockResolvedValue(listing({ lockVersion: 2, displayName: 'Portland cement' }))
  open('/products/new')
  fireEvent.change(await screen.findByRole('textbox', { name: /Material name/ }), { target: { value: 'portland' } })
  const displayName = screen.getByRole('textbox', { name: /Display name/ })
  expect(displayName).toHaveAttribute('placeholder', 'portland')
  fireEvent.click(await screen.findByRole('radio', { name: /Portland cement/ }, { timeout: 2000 }))
  expect(displayName).toHaveAttribute('placeholder', 'Portland cement')
  fireEvent.keyDown(displayName, { key: 'Tab' })
  expect(displayName).toHaveValue('Portland cement')
  fireEvent.change(displayName, { target: { value: '' } })
  fireEvent.change(screen.getByRole('textbox', { name: /Vendor SKU/ }), { target: { value: 'CEM-40' } })
  fireEvent.click(screen.getByRole('button', { name: 'Create draft' }))
  await waitFor(() => expect(catalog.createListing).toHaveBeenCalledWith('Portland cement', 'CEM-40'))
  await waitFor(() => expect(catalog.updateListing).toHaveBeenCalledWith('listing-1', { lockVersion: 1, materialId: 'mat-cement', materialMatch: 'EXACT' }))
})
