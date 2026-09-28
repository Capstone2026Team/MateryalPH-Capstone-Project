import { expect, test, type Page, type Route } from '@playwright/test'
import { mkdirSync } from 'node:fs'
import { resolve } from 'node:path'

// Layout evidence only: every /api/v1 call is served by a synthetic fixture, so these runs say
// nothing about live provider, register or storage readiness.
const ADMIN = 'http://127.0.0.1:4174'
// A neutral product placeholder so layout screenshots show a realistic photo area.
const PHOTO = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 200"><rect width="320" height="200" fill="#e7e5e4"/><path d="M120 50h80l14 110H106z" fill="#a8a29e"/><rect x="128" y="80" width="64" height="34" rx="4" fill="#f5f5f4"/></svg>'
const PIXEL = Buffer.from('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=', 'base64')

const unit = { id: 'unit-bag', code: 'BAG', name: 'Bag', dimension: 'PACK', precision: 0 }
const piece = { id: 'unit-pc', code: 'PC', name: 'Piece', dimension: 'COUNT', precision: 0 }
const rule = { id: 'rule-1', version: 1, required_marking: 'PS_OR_ICC', product_name: 'PORTLAND CEMENT', reference_standard: 'PNS 07:2018', technical_regulation: 'DAO 17-06:2017', scope: 'Type I', marking_requirements: ['PS Mark', 'Brand name'], source_reference: 'DTI-BPS' }
const taxonomy = {
  categories: [{ id: 'cat-cement', code: 'CEMENT_AND_CONCRETE', name: 'Cement and Concrete' }], units: [unit, piece],
  tags: [{ id: 'tag-1', code: 'STRUCTURAL', name: 'Structural' }, { id: 'tag-2', code: 'MASONRY', name: 'Masonry' }],
  attribute_definitions: [], tax_categories: ['VAT_12', 'VAT_ZERO', 'VAT_EXEMPT', 'NON_VAT'], allowed_tax_categories: ['NON_VAT'],
  limits: { max_variants: 50, max_media: 8, max_listing_image_kb: 5120, image_types: ['image/jpeg', 'image/png', 'image/webp'] },
}
const material = { id: 'mat-cement', code: 'PORTLAND_CEMENT', name: 'Portland cement', regulated: true, category_id: 'cat-cement', category_name: 'Cement and Concrete', canonical_unit_id: unit.id, compatible_unit_ids: [unit.id], suggested_tag_ids: ['tag-1'], regulated_rule: rule }
const steps = (media: boolean, compliance: string) => [
  { key: 'material_classification', label: 'Material and classification', level: 'REQUIRED', status: 'COMPLETED' },
  { key: 'product_details', label: 'Product details', level: 'REQUIRED', status: 'COMPLETED' },
  { key: 'variants_pricing', label: 'Variants', level: 'REQUIRED', status: 'COMPLETED' },
  { key: 'media', label: 'Photos', level: 'REQUIRED', status: media ? 'COMPLETED' : 'NOT_STARTED' },
  { key: 'product_compliance', label: 'PS/ICC', level: 'CONDITIONALLY_REQUIRED', status: compliance === 'NOT_SUBMITTED' ? 'NOT_STARTED' : 'IN_PROGRESS' },
  { key: 'review_publish', label: 'Review', level: 'REQUIRED', status: 'NOT_STARTED' },
]

function listingState() {
  let status = 'DRAFT'
  let compliance = 'NOT_SUBMITTED'
  let lock = 3
  const media: Record<string, unknown>[] = []
  const submissions: Record<string, unknown>[] = []
  const body = () => ({
    id: 'listing-1', status, lock_version: lock, display_name: 'Portland cement 40 kg', vendor_sku: 'CEM-40', description: 'Bagged Type I cement.',
    material: { id: material.id, code: material.code, name: material.name, regulated: true }, material_match: 'EXACT', material_category_id: 'cat-cement', other_label: null,
    tag_ids: ['tag-1'], technical_attributes: {}, brand: 'BrandCo', model: null, manufacturer: 'Sample Cement Corporation', manufacturer_address: 'Test City', country_of_manufacture: 'PH',
    regulated: true, compliance_status: compliance, regulated_rule: rule, publication_version: 0, published_at: null, publication_requested_at: null,
    variants: [{ id: 'variant-1', sku: 'CEM-40-1', label: '40 kg', unit_id: unit.id, unit_code: 'BAG', pack_quantity: '1.0000', attributes: {}, active: true, weight_kg: '40.000', length_cm: '60.00', width_cm: '40.00', height_cm: '12.00', lock_version: 1,
      price: { price_version_id: 'price-1', version: 1, amount_centavos: 28550, tax_category: 'NON_VAT', tax_basis: null, included_vat_centavos: 0, effective_at: null },
      inventory: { quantity_on_hand: '50.0000', hard_reserved_quantity: '0.0000', available_to_sell: '50.0000', confirmed_at: '2026-09-27T01:00:00Z' }, volume_tiers: [{ price_version_id: 'tier-1', version: 2, minimum_quantity: '50.0000', amount_centavos: 26000, included_vat_centavos: 0 }], public_availability: 'IN_STOCK', comparability: 'NOT_YET_COMPARABLE' }],
    media, compliance_submissions: submissions, status_history: [],
    completion: { key: 'LISTING', label: 'Listing', steps: steps(media.length > 0, compliance) },
    blockers: [
      ...(media.length ? [] : [{ key: 'media', step: 'media', reason: 'Upload at least one product photo that passed the safety check.' }]),
      ...(compliance === 'NOT_SUBMITTED' ? [{ key: 'product_compliance', step: 'product_compliance', reason: 'Submit PS Mark or ICC sticker evidence for this regulated material.' }] : []),
    ],
    permissions: { can_manage: true, can_submit_compliance: true },
  })
  return {
    body,
    addPhoto() { media.push({ id: 'media-1', file_id: 'photo-file-1', alt_text: 'Portland cement 40 kg', status: 'READY', version: 1, replaces_media_id: null, content_type: 'image/png', byte_size: PIXEL.length, scan_state: 'CLEAN', uploaded_at: '2026-09-28T01:00:00Z' }); lock += 1 },
    submit() { compliance = 'PENDING_ADMIN_REVIEW'; status = 'PENDING_ADMIN_REVIEW'; lock += 1; submissions.unshift({ id: 'submission-1', version: 1, path: 'MANUAL', status: 'PENDING_ADMIN_REVIEW', submitted_at: '2026-09-28T01:00:00Z', latest_review: null }) },
  }
}

const envelope = (data: unknown, meta: Record<string, unknown> = {}) => ({ data, meta, errors: [] })

async function fulfil(route: Route, data: unknown, meta: Record<string, unknown> = {}, status = 200) {
  await route.fulfill({ status, contentType: 'application/json', body: JSON.stringify(envelope(data, meta)) })
}

async function vendorFixture(page: Page, options: { empty?: boolean } = {}) {
  const listing = listingState()
  const mutations: { method: string; path: string; idempotencyKey: string | null }[] = []
  let imported = false
  await page.route('**/maps.googleapis.com/**', route => route.abort())
  await page.route('https://files.example.test/**', route => route.fulfill({ status: 200, contentType: 'image/svg+xml', body: PHOTO }))
  await page.route('**/api/v1/**', async route => {
    const request = route.request()
    const path = new URL(request.url()).pathname.replace(/^.*\/api\/v1/, '')
    const method = request.method()
    if (method !== 'GET') mutations.push({ method, path, idempotencyKey: await request.headerValue('idempotency-key') })
    if (path.endsWith('/csrf')) return fulfil(route, { csrf_token: 'layout-fixture' })
    if (path.endsWith('/profile')) return fulfil(route, { id: 'fixture-owner', account_type: 'VENDOR', account_status: 'ACTIVE', role: 'OWNER', full_name: 'Test Owner', email: 'owner@example.test', organization_name: 'Sample Supply', lock_version: 1, created_at: '2026-09-01T00:00:00Z', permissions: [] })
    if (path.endsWith('/onboarding')) return fulfil(route, {
      step_completion: [], requirements: [], drafts: [], lock_version: 1, organization: { store_name: 'Sample Supply', lock_version: 1 }, welcome_required: false,
      permissions: ['portal.products', 'catalog.manage', 'compliance.submit'], verification: { status: 'APPROVED' }, setup: { status: 'COMPLETED' },
      activation: { status: 'ACTIVE', marketplace_discoverability_status: 'NOT_DISCOVERABLE' }, sections: {},
    })
    if (path === '/vendor/catalog/taxonomy') return fulfil(route, taxonomy)
    if (path === '/vendor/catalog/materials/mat-cement') return fulfil(route, material)
    if (path === '/vendor/catalog/materials/search') return fulfil(route, [{ id: material.id, code: material.code, name: material.name, category_id: 'cat-cement', category_name: 'Cement and Concrete', regulated: true, match_type: 'ALIAS', matched_text: 'cement', similarity: 1 }])
    if (path === '/vendor/catalog/listings' && method === 'GET') {
      if (options.empty) return fulfil(route, [], { total: 0, last_page: 1, current_page: 1, scope: 'ORGANIZATION', status_counts: {}, active_out_of_stock: 0 })
      const current = listing.body()
      return fulfil(route, [
        { id: 'listing-1', display_name: current.display_name, vendor_sku: 'CEM-40', status: current.status, compliance_status: current.compliance_status, regulated: true, category_name: 'Cement and Concrete', material_name: 'Portland cement', other_label: null, lock_version: current.lock_version, updated_at: '2026-09-28T01:00:00Z', variant_count: 1, min_price_centavos: 28550, max_price_centavos: 28550, public_availability: 'IN_STOCK', primary_image_file_id: 'photo-file-1', primary_image_url: 'https://files.example.test/photo.png', unit_code: 'BAG', available_quantity: '50.0000', deletable: current.status === 'DRAFT' },
        { id: 'listing-2', display_name: 'Hollow block 4 in', vendor_sku: 'CHB-4', status: 'ACTIVE', compliance_status: 'NOT_REQUIRED', regulated: false, category_name: 'Cement and Concrete', material_name: null, other_label: 'Hollow block', lock_version: 1, updated_at: '2026-09-27T01:00:00Z', variant_count: 2, min_price_centavos: 1450, max_price_centavos: 1875, public_availability: 'OUT_OF_STOCK', primary_image_file_id: null, primary_image_url: null, unit_code: 'PC', available_quantity: '0.0000' },
      ], { total: 2, last_page: 1, current_page: 1, scope: 'ORGANIZATION', status_counts: { [current.status]: 1, ACTIVE: 1 }, active_out_of_stock: 1 })
    }
    if (path === '/vendor/catalog/listings' && method === 'POST') return fulfil(route, listing.body(), {}, 201)
    if (path === '/vendor/catalog/listings/listing-1' && method === 'DELETE') return fulfil(route, { id: 'listing-1', removed_at: '2026-09-28T03:00:00Z' })
    if (path === '/vendor/catalog/listings/listing-1/media' && method === 'POST') { listing.addPhoto(); return fulfil(route, listing.body(), {}, 201) }
    if (path === '/vendor/catalog/listings/listing-1/compliance/evidence') return fulfil(route, { evidence_id: 'evidence-1', file_id: 'evidence-file-1', path: 'MANUAL', evidence_kind: 'MARKING_PHOTO', content_type: 'image/png', byte_size: PIXEL.length, scan_state: 'CLEAN', extraction: { source: 'MANUAL', status: 'NOT_REQUESTED', confidence: null, suggestions: {}, assistance_only: true } }, {}, 201)
    if (path === '/vendor/catalog/listings/listing-1/compliance') { listing.submit(); return fulfil(route, listing.body()) }
    if (path.startsWith('/vendor/catalog/listings/listing-1')) return fulfil(route, listing.body())
    if (path.startsWith('/vendor/catalog/files/')) return fulfil(route, { url: 'https://files.example.test/photo.png', expires_at: '2026-09-28T02:00:00Z' })
    if (path === '/vendor/catalog/imports/template') return fulfil(route, { template_version: 'catalog-import.v1', columns: ['vendor_sku', 'display_name', 'material_code', 'variant_sku', 'unit_code', 'pack_quantity', 'price_php', 'tax_category', 'quantity_on_hand'], required_columns: ['vendor_sku', 'display_name', 'variant_sku', 'unit_code', 'price_php'], max_rows: 500 })
    if (path.startsWith('/vendor/catalog/imports')) {
      if (path.endsWith('/apply')) imported = true
      const rowErrors = [
        { row_number: 4, vendor_sku: 'IMP-BAD', variant_sku: 'IMP-BAD-1', errors: { price_php: ['Enter a peso amount greater than zero.'] } },
        { row_number: 7, vendor_sku: 'IMP-RENT', variant_sku: 'IMP-RENT-1', errors: { display_name: ['Vehicle and equipment rental services are not supported by MateryalPH.'], unit_code: ['Choose a unit from the approved list.'] } },
      ]
      return fulfil(route, { id: 'job-1', status: imported ? 'APPLIED_WITH_REJECTIONS' : 'HAS_ERRORS', template_version: 'catalog-import.v1', total_rows: 12, valid_rows: 10, error_rows: 2, applied_rows: imported ? 10 : 0, applied_at: imported ? '2026-09-28T01:05:00Z' : null, created_at: '2026-09-28T01:00:00Z', row_errors: rowErrors, row_errors_meta: { current_page: 1, last_page: 1, total: 2 } }, {}, path === '/vendor/catalog/imports' ? 201 : 200)
    }
    return fulfil(route, {})
  })
  return mutations
}

/** Fails with the offending elements named, so a reflow regression is diagnosable from the report. */
async function fits(page: Page) {
  const overflow = await page.evaluate(() => {
    const limit = document.documentElement.clientWidth
    const wide = [...document.querySelectorAll<HTMLElement>('main *')]
      .filter(element => element.getBoundingClientRect().right > limit + 1 && getComputedStyle(element).position !== 'fixed' && !element.closest('[class*="overflow-x-auto"]'))
      .map(element => `${element.tagName.toLowerCase()}.${String(element.className).split(' ').slice(0, 3).join('.')} right=${Math.round(element.getBoundingClientRect().right)}`)
    return { page: document.documentElement.scrollWidth > innerWidth, wide: wide.slice(0, 5) }
  })
  expect(overflow, `horizontal overflow at ${page.viewportSize()!.width}px`).toEqual({ page: false, wide: [] })
}

async function capture(page: Page, name: string) {
  const directory = resolve('../../docs/design/evidence/phase-4')
  mkdirSync(directory, { recursive: true })
  // Desktop portals scroll inside the workspace; release it so the capture shows the whole page.
  await page.addStyleTag({ content: 'html, body, .portal-layout, .portal-workspace { height: auto !important; max-height: none !important; overflow: visible !important; } .portal-workspace > header { position: static !important; }' })
  await page.screenshot({ path: resolve(directory, `${page.viewportSize()!.width}-${name}.png`), fullPage: true })
}

test('My Products shows summary tiles, status chips and product cards, and the same data as a table', async ({ page }) => {
  await vendorFixture(page)
  await page.goto('/products')
  await expect(page.getByRole('heading', { name: 'My Products', exact: true })).toBeVisible()
  await expect(page.getByText('2 products')).toBeVisible()
  const cards = page.getByRole('list', { name: 'Store products' })
  await expect(cards.getByRole('listitem')).toHaveCount(3)
  await expect(cards.getByText('₱285.50')).toBeVisible()
  await expect(cards.getByText('₱14.50 – ₱18.75')).toBeVisible()
  await expect(cards.getByText('Out of stock')).toBeVisible()
  await expect(cards.locator('img')).toHaveCount(1)
  await expect(page.getByText('Needs attention')).toBeVisible()
  await expect(page.getByRole('group', { name: 'Filter by listing status' }).getByRole('button', { name: /All\s*2/ })).toHaveAttribute('aria-pressed', 'true')
  await expect(page.getByRole('link', { name: 'Add new product' })).toBeVisible()
  await expect(cards.getByRole('button', { name: /^Delete / })).toHaveCount(1)
  await fits(page)
  await capture(page, 'products-list')
  await cards.getByRole('button', { name: 'Delete Portland cement 40 kg' }).click()
  const dialog = page.getByRole('dialog', { name: 'Delete this draft?' })
  await expect(dialog).toBeVisible()
  await expect(dialog.getByRole('button', { name: 'Cancel' })).toBeFocused()
  await capture(page, 'products-delete-dialog')
  await dialog.getByRole('button', { name: 'Cancel' }).click()
  await expect(dialog).toBeHidden()
  await page.getByRole('button', { name: 'Table' }).click()
  await expect(page).toHaveURL(/view=table/)
  const records = page.viewportSize()!.width >= 1024 ? page.getByRole('table', { name: 'Store products' }) : page.getByRole('list', { name: 'Store products' })
  await expect(records.getByText('₱285.50 / bag')).toBeVisible()
  await expect(records.getByText('Not regulated')).toBeVisible()
  await fits(page)
  await capture(page, 'products-table')

  await page.unrouteAll({ behavior: 'ignoreErrors' })
  await vendorFixture(page, { empty: true })
  await page.goto('/products')
  await expect(page.getByRole('heading', { name: 'No products yet.' })).toBeVisible()
  await expect(page.getByText(/stays active without products/)).toBeVisible()
  await fits(page)
  await capture(page, 'products-empty')
})

test('listing wizard creates a draft, validates variants and tiers, uploads a photo and converges PS/ICC on one review step', async ({ page }) => {
  const mutations = await vendorFixture(page)
  await page.goto('/products/new')
  await expect(page.getByRole('heading', { name: 'Add product', exact: true })).toBeVisible()
  await page.getByRole('textbox', { name: /Material name/ }).fill('portland')
  await page.getByRole('radio', { name: /Portland cement/ }).check()
  await expect(page.getByRole('textbox', { name: /Display name/ })).toHaveAttribute('placeholder', 'Portland cement')
  await expect(page.getByRole('button', { name: 'Use suggestion: Portland cement' })).toBeVisible()
  await page.getByRole('textbox', { name: /Display name/ }).fill('Portland cement 40 kg')
  await page.getByRole('textbox', { name: /Vendor SKU/ }).fill('CEM-40')
  await fits(page)
  await capture(page, 'wizard-create')
  await page.getByRole('button', { name: 'Create draft' }).click()
  await expect(page).toHaveURL(/\/products\/listing-1$/)
  await expect(page.getByRole('heading', { name: 'Material selection', level: 2 })).toBeVisible()
  await expect(page.getByText('DTI-BPS regulated', { exact: true }).first()).toBeVisible()
  await expect(page.getByRole('region', { name: 'Publication gate' })).toContainText('2 items before publishing')
  await fits(page)
  await capture(page, 'wizard-material')

  const afterCreate = mutations.length
  await page.getByRole('button', { name: 'Continue: Product information' }).click()
  await expect(page.getByRole('group', { name: 'Variants' })).toBeVisible()
  const first = page.getByRole('region', { name: 'Variant 1 — 40 kg' })
  await expect(first.getByRole('textbox', { name: /Minimum quantity/ })).toHaveValue('50')
  await expect(first.getByText('50+ bag')).toBeVisible()
  await page.getByRole('button', { name: 'Add variant' }).click()
  await page.getByRole('button', { name: 'Save product information' }).click()
  const second = page.getByRole('region', { name: 'Variant 2' })
  await expect(second.getByText('Choose a sale unit.').first()).toBeVisible()
  await expect(second.getByRole('textbox', { name: 'Price (PHP)' })).toHaveAttribute('aria-invalid', 'true')
  expect(mutations.slice(afterCreate).filter(item => item.path.endsWith('/variants') || item.method === 'PATCH')).toHaveLength(0)
  await fits(page)
  await capture(page, 'wizard-product-information')

  await page.goto('/products/listing-1?step=2')
  await expect(page.getByText(/Accepted: JPG, PNG or WebP/)).toBeVisible()
  await page.locator('input[type="file"]').first().setInputFiles({ name: 'cement.png', mimeType: 'image/png', buffer: PIXEL })
  await expect(page.getByText('Photo uploaded.')).toBeVisible()
  await expect(page.getByText('Main photo')).toBeVisible()
  const paths = page.getByRole('group', { name: 'How will you provide the marking?' })
  await expect(paths.getByRole('radio')).toHaveCount(3)
  await expect(page.getByText('PNS 07:2018', { exact: true })).toBeVisible()
  await paths.getByRole('radio', { name: /Manual entry/ }).check()
  await page.getByLabel(/Upload PS Mark marking photo/).setInputFiles({ name: 'marking.png', mimeType: 'image/png', buffer: PIXEL })
  await expect(page.getByRole('heading', { name: 'Check the photo before uploading' })).toBeVisible()
  await expect(page.getByRole('img', { name: 'Preview of marking.png' })).toBeVisible()
  expect(mutations.filter(item => item.path.endsWith('/compliance/evidence'))).toHaveLength(0)
  await fits(page)
  await capture(page, 'wizard-compliance-preview')
  await page.getByRole('button', { name: 'Upload this photo' }).click()
  await expect(page.getByRole('heading', { name: 'Review and confirm' })).toBeVisible()
  await page.getByRole('textbox', { name: /PS License No/ }).fill('Q-1234')
  await page.getByRole('button', { name: 'Submit PS/ICC evidence' }).click()
  await expect(page.getByText('Confirm that you reviewed each value against the physical marking.')).toBeVisible()
  expect(mutations.filter(item => item.path.endsWith('/compliance'))).toHaveLength(0)
  await fits(page)
  await capture(page, 'wizard-photos-compliance')
  await page.getByRole('checkbox', { name: /checked every value/ }).check()
  await page.getByRole('button', { name: 'Submit PS/ICC evidence' }).click()
  await expect(page.getByText(/No result is an accusation/)).toBeVisible()
  expect(mutations.find(item => item.path.endsWith('/compliance'))?.idempotencyKey).toBeTruthy()
  await capture(page, 'wizard-compliance-submitted')

  await page.getByRole('button', { name: 'Continue: Review and publish' }).click()
  await expect(page.getByRole('region', { name: 'Listing preview' })).toContainText('Volume price: ₱260.00 / bag from 50 bag')
  await expect(page.getByRole('region', { name: 'Publication gate' })).toContainText('It becomes active once the PS/ICC evidence is verified')
  await expect(page.getByRole('button', { name: 'Request publication' })).toBeEnabled()
  await fits(page)
  await capture(page, 'wizard-review')
})

test('bulk import reports partial validation as a problem and links every rejected row', async ({ page }) => {
  const mutations = await vendorFixture(page)
  await page.goto('/products/import')
  await expect(page.getByRole('heading', { name: 'Bulk import', exact: true })).toBeVisible()
  await expect(page.getByRole('link', { name: 'Download CSV template' })).toBeVisible()
  await page.getByLabel(/CSV file/).setInputFiles({ name: 'catalog.csv', mimeType: 'text/csv', buffer: Buffer.from('vendor_sku,display_name\nIMP-1,Sand\n') })
  await expect(page.getByText(/2 of 12 rows have problems. Nothing is saved yet./)).toBeVisible()
  await expect(page.getByRole('link', { name: 'Row 7' })).toHaveAttribute('href', '#import-row-7')
  await fits(page)
  await capture(page, 'import-validation')
  await page.getByRole('button', { name: 'Apply 10 valid rows' }).click()
  const result = page.getByText(/Partially imported: 10 rows became draft listings and 2 rows were not imported/)
  await expect(result).toBeVisible()
  await expect(page.getByText(/Imported 10 rows as draft listings/)).toHaveCount(0)
  expect(mutations.find(item => item.path.endsWith('/apply'))?.idempotencyKey).toBeTruthy()
  await fits(page)
  await capture(page, 'import-applied')
})

test('Admin product compliance queue and case name the exact target and require a reason', async ({ page }) => {
  let decision: Record<string, unknown> | null = null
  const caseBody = (status: string) => ({
    submission: { id: 'submission-1', version: 2, lock_version: 1, path: 'MANUAL', status, marking_type: 'PS_MARK', declared: { marking_type: 'PS_MARK', certificate_number: 'Q-1234', manufacturer_name: 'Sample Cement Corporation', manufacturer_address: 'Test City', country_of_manufacture: 'PH', brand: 'BrandCo' }, submitted_at: '2026-09-27T01:00:00Z', decided_at: status === 'PENDING_ADMIN_REVIEW' ? null : '2026-09-28T02:00:00Z', rule_version: 1 },
    listing: { id: 'listing-1', display_name: 'Portland cement 40 kg', vendor_sku: 'CEM-40', status: 'PENDING_ADMIN_REVIEW', material_name: 'Portland cement', public_store_name: 'Sample Supply', media_file_ids: ['photo-file-1'] },
    rule, evidence: [{ id: 'evidence-1', evidence_kind: 'MARKING_PHOTO', path: 'MANUAL', file_id: 'evidence-file-1', content_type: 'image/png', byte_size: PIXEL.length, scan_state: 'CLEAN', checksum_prefix: 'abc123' }],
    extractions: [], reference_match: { result: 'UNCERTAIN', provider: 'DTI_BPS_REGISTER', source_reference: 'PS licensee register 2026-09-01', checked_at: '2026-09-27T01:00:00Z', details: {} },
    previous_submissions: [{ id: 'submission-0', version: 1, status: 'CHANGES_REQUIRED', submitted_at: '2026-09-20T01:00:00Z' }],
    reviews: status === 'PENDING_ADMIN_REVIEW' ? [] : [{ id: 'review-1', decision: status, reason: 'The licence number is not legible.', source: 'ADMIN_REVIEW', created_at: '2026-09-28T02:00:00Z' }],
    official_references: [{ label: 'DTI-BPS PS and ICC Marks', url: 'https://bps.dti.gov.ph/product-certification/ps-and-icc-marks' }],
  })
  await page.route('https://files.example.test/**', route => route.fulfill({ status: 200, contentType: 'image/svg+xml', body: PHOTO }))
  await page.route('**/api/v1/**', async route => {
    const request = route.request()
    const path = new URL(request.url()).pathname.replace(/^.*\/api\/v1/, '')
    if (path.endsWith('/csrf')) return fulfil(route, { csrf_token: 'layout-fixture' })
    if (path.endsWith('/profile')) return fulfil(route, { id: 'fixture-admin', account_type: 'ADMIN', account_status: 'ACTIVE', role: 'ADMIN_COMPLIANCE', full_name: 'Compliance Reviewer', email: 'reviewer@example.test', lock_version: 1, created_at: '2026-09-01T00:00:00Z', permissions: ['product_compliance.review', 'product_compliance.view_evidence', 'product_compliance.manage_registers'] })
    if (path === '/admin/product-compliance' ) return fulfil(route, [{ id: 'submission-1', version: 2, path: 'MANUAL', status: 'PENDING_ADMIN_REVIEW', marking_type: 'PS_MARK', submitted_at: '2026-09-27T01:00:00Z', listing_id: 'listing-1', display_name: 'Portland cement 40 kg', vendor_sku: 'CEM-40', public_store_name: 'Sample Supply', material_name: 'Portland cement', product_name: 'PORTLAND CEMENT', reference_standard: 'PNS 07:2018', reference_result: 'UNCERTAIN' }], { total: 1, last_page: 1, current_page: 1 })
    if (path === '/admin/product-compliance/registers') return fulfil(route, [{ id: 'register-1', register_kind: 'PS_LICENSE', source_reference: 'PS licensee register 2026-09-01', snapshot_date: '2026-09-01', status: 'ACTIVE', row_count: 1240, rejected_row_count: 3, activated_at: '2026-09-02T01:00:00Z', superseded_at: null, created_at: '2026-09-02T00:30:00Z', column_mapping: {}, rejected_rows: [] }], { last_page: 1 })
    if (path.startsWith('/admin/product-compliance/files/')) return fulfil(route, { url: 'https://files.example.test/evidence.png', expires_at: '2026-09-28T02:00:00Z' })
    if (path === '/admin/product-compliance/submission-1/decision') { decision = request.postDataJSON() as Record<string, unknown>; return fulfil(route, caseBody(String(decision.decision))) }
    if (path === '/admin/product-compliance/submission-1') return fulfil(route, caseBody('PENDING_ADMIN_REVIEW'))
    return fulfil(route, {})
  })

  await page.goto(`${ADMIN}/product-compliance`)
  await expect(page.getByRole('heading', { name: 'Product Compliance Queue' })).toBeVisible()
  const queue = page.viewportSize()!.width >= 1024 ? page.getByRole('table', { name: 'Product compliance submissions' }) : page.getByRole('list', { name: 'Product compliance submissions' })
  await expect(queue.getByText('Uncertain')).toBeVisible()
  await expect(page.getByRole('heading', { name: 'DTI-BPS register snapshots' })).toBeVisible()
  await fits(page)
  await capture(page, 'admin-compliance-queue')

  await page.goto(`${ADMIN}/product-compliance/submission-1`)
  await expect(page.getByText(/Target: submission version 2 · lock 1 · 1 evidence file/)).toBeVisible()
  await expect(page.getByRole('navigation', { name: 'Review sections' })).toBeVisible()
  await page.getByRole('radio', { name: 'Return for correction' }).check()
  const reason = page.getByRole('textbox', { name: /Reason/ })
  await expect(reason).toHaveAttribute('required', '')
  await page.getByRole('button', { name: 'Record decision' }).click()
  expect(decision).toBeNull()
  await fits(page)
  await capture(page, 'admin-compliance-case')
  await reason.fill('The licence number is not legible.')
  await page.getByRole('button', { name: 'Record decision' }).click()
  await expect(page.getByText(/Store Activation is unaffected/)).toBeVisible()
  expect(decision).toMatchObject({ decision: 'CHANGES_REQUIRED', lock_version: 1, reason: 'The licence number is not legible.' })
  await expect(page.getByRole('button', { name: 'Record decision' })).toHaveCount(0)
  await fits(page)
  await capture(page, 'admin-compliance-decided')
})
