import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import type { CatalogImportJob, CatalogListing, CatalogListingSummary, CatalogTaxonomy } from '../lib/catalog-api'
import * as catalog from '../lib/catalog-api'
import * as onboarding from '../lib/onboarding-api'
import { VendorCatalogImportPage, VendorCatalogPage, VendorListingEditorPage } from './CatalogPages'

vi.mock('../lib/onboarding-api', async original => ({ ...await original<typeof import('../lib/onboarding-api')>(), getVendorOnboarding: vi.fn(), getVendorPrivateFileUrl: vi.fn() }))
vi.mock('../lib/catalog-api', async original => ({
  ...await original<typeof import('../lib/catalog-api')>(),
  getCatalogTaxonomy: vi.fn(), listListings: vi.fn(), getListing: vi.fn(), getMaterial: vi.fn(), saveVariants: vi.fn(), uploadComplianceEvidence: vi.fn(),
  submitCompliance: vi.fn(), getImportTemplate: vi.fn(), uploadImport: vi.fn(), applyImport: vi.fn(), getCatalogFileUrl: vi.fn(), searchMaterials: vi.fn(), updateListing: vi.fn(),
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
    materialMatch: 'EXACT', materialCategoryId: 'cat-cement', otherLabel: null, tagIds: ['tag-1'], technicalAttributes: {}, brand: 'BrandCo', model: null, manufacturer: 'Sample Cement Corporation', manufacturerAddress: 'Test City', countryOfManufacture: 'PH',
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
  vi.mocked(onboarding.getVendorOnboarding).mockResolvedValue({ stepCompletion: [], lockVersion: 1, requirements: [], drafts: [], organization: { store_name: 'Test Supply' }, welcomeRequired: false, permissions: ['portal.products', 'catalog.manage', 'compliance.submit'], verification: {}, setup: { status: 'COMPLETED' }, activation: { status: 'ACTIVE', marketplaceDiscoverabilityStatus: 'NOT_DISCOVERABLE', readiness: { ready: true, blockers: [], status: 'READY', ruleVersion: 'test' } }, sections: {} })
  vi.mocked(onboarding.getVendorPrivateFileUrl).mockResolvedValue({ url: 'https://example.test/logo', expiresAt: new Date() })
  vi.mocked(catalog.getCatalogTaxonomy).mockResolvedValue(taxonomy)
  vi.mocked(catalog.getListing).mockResolvedValue(listing())
  vi.mocked(catalog.getMaterial).mockResolvedValue({ id: 'mat-cement', code: 'PORTLAND_CEMENT', name: 'Portland cement', regulated: true, categoryId: 'cat-cement', categoryName: 'Cement and Concrete', canonicalUnitId: unit.id, compatibleUnitIds: [unit.id], suggestedTagIds: ['tag-1'], regulatedRule: null })
  vi.mocked(catalog.getCatalogFileUrl).mockResolvedValue('https://example.test/photo.png')
})

function open(path: string) {
  return render(<MemoryRouter initialEntries={[path]}><Routes><Route path="/products" element={<VendorCatalogPage />} /><Route path="/products/import" element={<VendorCatalogImportPage />} /><Route path="/products/:listingId" element={<VendorListingEditorPage />} /><Route path="/dashboard" element={<h1>Dashboard</h1>} /></Routes></MemoryRouter>)
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
  expect(screen.getByText('Out of stock').nextElementSibling).toHaveTextContent('2')
  expect(screen.getByText('Needs attention').nextElementSibling).toHaveTextContent('1')
  const chips = screen.getByRole('group', { name: 'Filter by listing status' })
  expect(within(chips).getByRole('button', { name: /All\s*5/ })).toHaveAttribute('aria-pressed', 'true')
  fireEvent.click(within(chips).getByRole('button', { name: /Pending Compliance\s*1/ }))
  await waitFor(() => expect(catalog.listListings).toHaveBeenLastCalledWith(expect.objectContaining({ status: 'PENDING_COMPLIANCE', page: 1 })))
  expect(screen.getByRole('link', { name: 'Add product' })).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Table' }))
  const table = await screen.findByRole('table', { name: 'Store products' })
  expect(within(table).getByText('₱285.50 / bag')).toBeInTheDocument()
})

test('an empty catalog explains that activation does not need products and offers the next action', async () => {
  vi.mocked(catalog.listListings).mockResolvedValue({ items: [], meta: { total: 0, lastPage: 1, statusCounts: {}, activeOutOfStock: 0 } })
  open('/products')
  expect(await screen.findByRole('heading', { name: 'No products yet.' })).toBeVisible()
  expect(screen.getByText(/stays active without products/)).toBeVisible()
  expect(screen.getByRole('link', { name: 'Add your first product' })).toBeVisible()
})

test('catalog stays closed before Store Activation without blocking the store', async () => {
  vi.mocked(onboarding.getVendorOnboarding).mockResolvedValue({ stepCompletion: [], lockVersion: 1, requirements: [], drafts: [], organization: {}, welcomeRequired: false, permissions: ['portal.products', 'catalog.manage'], verification: {}, setup: {}, activation: { status: 'NOT_READY', marketplaceDiscoverabilityStatus: 'NOT_DISCOVERABLE', readiness: { ready: false, blockers: [], status: 'NOT_READY', ruleVersion: 'test' } }, sections: {} })
  open('/products')
  expect(await screen.findByText(/Products are not required to activate your store/)).toBeVisible()
  expect(catalog.listListings).not.toHaveBeenCalled()
})

test('variant rows validate per row inline and show server row errors in the matching row', async () => {
  vi.mocked(catalog.saveVariants).mockRejectedValue(new Error('rejected'))
  open('/products/listing-1?step=1')
  await screen.findByRole('group', { name: 'Variants' })
  fireEvent.click(screen.getByRole('button', { name: 'Add variant' }))
  const second = screen.getByRole('region', { name: 'Variant 2' })
  fireEvent.click(screen.getByRole('button', { name: 'Save product information' }))
  expect(await within(second).findByText('Choose a sale unit.')).toBeVisible()
  // The message appears in the row summary and inline on its field, which is marked invalid.
  expect(within(second).getAllByText('Enter a price in pesos, for example 285.50.')).toHaveLength(2)
  expect(within(second).getByRole('textbox', { name: 'Price (PHP)' })).toHaveAttribute('aria-invalid', 'true')
  expect(within(screen.getByRole('region', { name: 'Variant 1 — 40 kg' })).queryByRole('alert')).not.toBeInTheDocument()
  expect(catalog.saveVariants).not.toHaveBeenCalled()
  expect(catalog.updateListing).not.toHaveBeenCalled()
  expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
})

test('all three compliance paths converge on one editable Review and Confirm step', async () => {
  vi.mocked(catalog.uploadComplianceEvidence).mockResolvedValue({ evidenceId: 'evidence-1', fileId: 'file-1', path: 'QR', evidenceKind: 'QR_IMAGE', contentType: 'image/png', byteSize: 2048, scanState: 'CLEAN', extraction: { source: 'QR', status: 'EXTRACTED', confidence: 0.6, suggestions: { marking_type: 'PS_MARK', certificate_number: 'Q-1234' }, assistanceOnly: true } })
  vi.mocked(catalog.submitCompliance).mockResolvedValue(listing({ complianceStatus: 'PENDING_ADMIN_REVIEW', status: 'PENDING_ADMIN_REVIEW' }))
  open('/products/listing-1?step=2')
  const paths = await screen.findByRole('group', { name: 'How will you provide the marking?' })
  expect(within(paths).getAllByRole('radio')).toHaveLength(3)
  expect(screen.getByText('PNS 07:2018')).toBeVisible()
  fireEvent.click(within(paths).getByRole('radio', { name: /QR code scan or upload/ }))
  fireEvent.change(screen.getByLabelText(/QR code image/), { target: { files: [new File(['qr'], 'qr.png', { type: 'image/png' })] } })
  expect(await screen.findByRole('heading', { name: 'Review and confirm' })).toBeVisible()
  const number = screen.getByRole('textbox', { name: /PS License No/ })
  expect(number).toHaveValue('Q-1234')
  fireEvent.change(number, { target: { value: 'Q-1235' } })
  fireEvent.click(screen.getByRole('button', { name: 'Submit PS/ICC evidence' }))
  expect(await screen.findByText('Confirm that you reviewed each value against the physical marking.')).toBeVisible()
  expect(catalog.submitCompliance).not.toHaveBeenCalled()
  fireEvent.click(screen.getByRole('checkbox', { name: /checked every value/ }))
  fireEvent.click(screen.getByRole('button', { name: 'Submit PS/ICC evidence' }))
  await waitFor(() => expect(catalog.submitCompliance).toHaveBeenCalledWith('listing-1', expect.objectContaining({ path: 'QR', certificateNumber: 'Q-1235', evidenceIds: ['evidence-1'], confirmed: true })))
  expect(await screen.findByText(/No result is an accusation/)).toBeVisible()
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

test('volume tiers are checked against the ordinary price and saved with the details in order', async () => {
  vi.mocked(catalog.updateListing).mockResolvedValue(listing({ lockVersion: 4 }))
  vi.mocked(catalog.saveVariants).mockResolvedValue(listing({ lockVersion: 5 }))
  open('/products/listing-1?step=1')
  const first = await screen.findByRole('region', { name: 'Variant 1 — 40 kg' })
  fireEvent.click(within(first).getByRole('button', { name: 'Add tier' }))
  fireEvent.change(within(first).getByRole('textbox', { name: /Minimum quantity/ }), { target: { value: '50' } })
  fireEvent.change(within(first).getByRole('textbox', { name: 'Price per unit (PHP)' }), { target: { value: '290' } })
  fireEvent.click(screen.getByRole('button', { name: 'Save product information' }))
  expect(await within(first).findAllByText('A tier price must be lower than the ordinary price.')).toHaveLength(2)
  expect(catalog.updateListing).not.toHaveBeenCalled()
  fireEvent.change(within(first).getByRole('textbox', { name: 'Price per unit (PHP)' }), { target: { value: '260' } })
  expect(within(first).getByText('50+ bag')).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Save product information' }))
  await waitFor(() => expect(catalog.saveVariants).toHaveBeenCalledWith('listing-1', 4, [expect.objectContaining({ id: 'variant-1', priceCentavos: 28550, volumeTiers: [{ minimumQuantity: '50', priceCentavos: 26000 }] })]))
  expect(vi.mocked(catalog.updateListing).mock.invocationCallOrder[0]).toBeLessThan(vi.mocked(catalog.saveVariants).mock.invocationCallOrder[0]!)
  expect(await screen.findByText('Product information, prices and stock counts saved.')).toBeVisible()
})