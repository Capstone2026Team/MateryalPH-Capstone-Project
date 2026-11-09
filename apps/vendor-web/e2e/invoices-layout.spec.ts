import { expect, test } from '@playwright/test'

test('invoice list and document details reflow and retain selection and uploads', async ({ page }) => {
  const preset = { invoice_type: 'VENDOR_GOODS_INVOICE', issuer_name: 'Sample Supply Corporation', source_system: 'REGISTERED_CAS', invoicing_method: 'COMPUTERIZED', date_mode: 'TODAY', lock_version: 0 }
  const summary = { lines: [{ order_line_id: 'line-1', display_name: 'Portland cement · 40 kg bags', quantity: '10.0000', unit_name: 'bag', unit_price_centavos: 25000, line_total_centavos: 250000 }], materials_subtotal_centavos: 250000, delivery_centavos: 25000, discount_centavos: 0, included_vat_centavos: 29464, total_centavos: 275000 }
  let prepared = false
  let sent = false
  const draft = { ...preset, id: 'draft-1', invoice_number: 'SAMPLE-NEW', issued_on: '2026-11-04', amount_centavos: 275000, lock_version: 1, file_name: 'sample.pdf', download: { url: '/api/v1/vendor/invoice-drafts/019a4db9-1234-7123-8123-012345678901/files/019a4db9-1234-7123-8123-012345678902?expires=9999999999&signature=sample', expires_at: '2030-01-01T00:00:00Z' } }
  const records = Array.from({ length: 6 }, (_, index) => ({
    id: `record-${index}`, order_id: `order-${index}`, order_reference: `ORD-2026-SAMPLE${index + 1}`, invoice_type: 'VENDOR_GOODS_INVOICE',
    issuer: 'Sample Supply Corporation', invoice_number: `SAMPLE-00${index + 1}`, issued_on: '2026-11-03', amount_centavos: 275000 + index * 150000, vat_centavos: 29464,
    document_origin: 'DEMO_SAMPLE', origin_label: 'DEMO sample (TEST)', verification_state: 'UNVERIFIED', e_invoicing_coverage: 'REVIEW_REQUIRED',
    compliance_note: 'An uploaded PDF is not proof of BIR compliance.', reconciliation_state: index === 1 ? 'INVOICE_RECONCILIATION_REQUIRED' : 'MATCHED',
    reconciliation_difference_centavos: index === 1 ? 10000 : 0, expected_total_centavos: 275000 + index * 150000 - (index === 1 ? 10000 : 0),
    can_explain: index === 1, buyer_total_unchanged: true, uploaded_at: '2026-11-03T02:00:00Z', download: null, order_summary: summary,
  }))
  await page.route('**/api/v1/**', async route => {
    const url = new URL(route.request().url())
    let data: unknown = {}
    let meta: unknown = {}
    if (url.pathname.endsWith('/auth/csrf')) data = { csrf_token: 'sample-csrf-for-ui-review' }
    if (url.pathname.endsWith('/vendor/navigation-updates')) data = { sections: { '/invoices': 1 } }
    if (url.pathname.endsWith('/profile')) data = { id: 'invoice-reviewer', full_name: 'Sample Vendor', account_type: 'VENDOR', account_status: 'ACTIVE', role: 'OWNER' }
    if (url.pathname.endsWith('/onboarding')) data = {
      step_completion: [], requirements: [], drafts: [], sections: {}, lock_version: 1,
      organization: { store_name: 'Sample Supply', lock_version: 1 }, permissions: ['portal.invoices', 'portal.orders', 'invoices.view', 'invoices.upload'],
      welcome_required: false, verification: { status: 'APPROVED' }, setup: { status: 'COMPLETED' },
      activation: { status: 'ACTIVE', marketplace_discoverability_status: 'DISCOVERABLE', readiness: { ready: true, blockers: [] } },
    }
    if (url.pathname.endsWith('/vendor/invoices')) {
      const view = url.searchParams.get('view')
      data = view === 'RECORDS' ? records : view === 'RECONCILIATION' ? [records[1]] : view === 'DUE' ? [{ order_id: 'sale-no-copy', order_reference: 'ORD-2026-NEEDS-COPY', buyer_name: 'Sample Buyer Construction', order_state: 'CONFIRMED', accepted_at: '2026-11-03T02:00:00Z', open_request: false }] : []
      meta = { counts: { REQUESTS: 0, DUE: 1, RECORDS: 6, RECONCILIATION: 1 }, page: 1, per_page: 20, total: (data as unknown[]).length, has_more: false, issuance_notice: 'The Vendor issues the invoice when legally due; the copy service target never extends that deadline.' }
    }
    if (url.pathname.endsWith('/vendor/invoices/preset')) data = preset
    if (url.pathname.endsWith('/invoices/send')) {
      expect(prepared).toBe(true)
      sent = true
    }
    if (/\/vendor\/orders\/[^/]+\/invoices(?:\/send)?$/.test(url.pathname)) {
      const orderId = url.pathname.split('/')[5]!
      const item = records.find(record => record.order_id === orderId)
      if (route.request().method() === 'POST' && !url.pathname.endsWith('/send')) prepared = true
      data = {
        order_id: orderId, order_reference: item?.order_reference ?? 'ORD-2026-NEEDS-COPY', issuer_name: 'Sample Supply Corporation',
        status: item || sent ? 'ISSUED' : 'NOT_YET_UPLOADED', records: item ? [item] : sent ? [{ ...records[0], id: 'record-new', invoice_number: 'SAMPLE-NEW' }] : [], requests: [], platform_documents: [],
        buyer_name: 'Sample Buyer Construction', billing_details: item ? { billing_name: 'Sample Buyer Construction', billing_address: 'Sample billing address, Quezon City', tin_masked: '•••• 1234' } : null,
        can_upload: !sent && (!item || item.reconciliation_state === 'INVOICE_RECONCILIATION_REQUIRED'), can_send: prepared && !sent, can_open_files: true, draft: prepared ? { ...draft, ...(sent ? { sent_record_id: 'record-new', lock_version: 2 } : {}) } : null, preset, order_summary: summary, invoice_types: ['VENDOR_GOODS_INVOICE', 'VENDOR_ADJUSTMENT_DOCUMENT'],
        source_systems: ['REGISTERED_CAS'], invoicing_methods: ['COMPUTERIZED'],
        lines: [{ order_line_id: 'line-1', display_name: 'Portland cement · 40 kg bags' }], issuance_notice: 'Issue the invoice when legally due.',
      }
    }
    await route.fulfill({ json: { data, meta, errors: [] } })
  })
  await page.goto('/invoices?view=RECORDS')
  const sidebar = page.getByRole('complementary', { name: 'VENDOR PORTAL navigation' })
  if (page.viewportSize()!.width < 1024) await page.getByRole('button', { name: 'Open navigation' }).click()
  await expect(sidebar.getByRole('link', { name: 'E-Invoices, 1 pending invoice task' })).toBeVisible()
  if (page.viewportSize()!.width < 1024) await sidebar.getByRole('button', { name: 'Close navigation' }).click()
  const sheet = page.getByRole('region', { name: 'Invoice details' })
  await expect(sheet.getByRole('heading', { name: 'SAMPLE-001' })).toBeVisible()
  const second = page.getByRole('button', { name: 'View SAMPLE-002 · ORD-2026-SAMPLE2' })
  await second.click()
  await expect(second).toHaveAttribute('aria-pressed', 'true')
  await expect(sheet.getByRole('heading', { name: 'SAMPLE-002' })).toBeVisible()
  await expect(sheet.getByText('Amount mismatch needs review', { exact: true })).toBeVisible()
  await expect(sheet.getByRole('button', { name: 'Prepare corrected invoice' })).toBeVisible()
  await sheet.getByRole('button', { name: 'Prepare corrected invoice' }).click()
  const correction = page.getByRole('dialog', { name: 'Upload invoice copy', exact: true })
  await expect(correction.getByLabel('Invoice total (₱)', { exact: true })).toHaveValue('4250.00')
  await expect(correction.getByText('SAMPLE-002', { exact: true })).toBeVisible()
  await expect(correction.getByLabel('Copy (PDF, JPG or PNG)', { exact: true })).not.toHaveAttribute('required')
  expect(await correction.evaluate(element => element.scrollWidth <= element.clientWidth)).toBe(true)
  await page.screenshot({ path: `test-results/invoice-correction-${page.viewportSize()!.width}.png` })
  await correction.getByRole('button', { name: 'Cancel', exact: true }).click()
  await expect(sheet.getByRole('link', { name: 'View order' })).toHaveAttribute('href', '/orders/order-1#invoices')
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  expect(await sheet.evaluate(element => element.scrollWidth <= element.clientWidth)).toBe(true)
  const layout = await page.evaluate(() => {
    const list = document.querySelector('.mp-invoice-list')!.getBoundingClientRect()
    const detail = document.querySelector('.mp-invoice-detail')!.getBoundingClientRect()
    return { listRight: list.right, listBottom: list.bottom, detailLeft: detail.left, detailTop: detail.top }
  })
  if (page.viewportSize()!.width >= 1280) expect(layout.detailLeft).toBeGreaterThan(layout.listRight)
  else expect(layout.detailTop).toBeGreaterThan(layout.listBottom)
  await page.evaluate(() => window.scrollTo({ top: 0, behavior: 'instant' }))
  await page.screenshot({ path: `test-results/invoices-${page.viewportSize()!.width}.png`, fullPage: true })
  await page.getByRole('button', { name: 'Filter: No copy yet' }).click()
  await expect(sheet.getByRole('heading', { name: 'ORD-2026-NEEDS-COPY' })).toBeVisible()
  await expect(page.getByRole('button', { name: 'View ORD-2026-NEEDS-COPY · Buyer: Sample Buyer Construction' })).toBeVisible()
  await expect(sheet.getByText('Sample Buyer Construction', { exact: true })).toBeVisible()
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  expect(await sheet.evaluate(element => element.scrollWidth <= element.clientWidth)).toBe(true)
  await page.screenshot({ path: `test-results/invoices-no-copy-${page.viewportSize()!.width}.png`, fullPage: true })
  await expect(sheet.getByText('Portland cement · 40 kg bags')).toBeVisible()
  await sheet.getByRole('button', { name: 'Upload invoice copy' }).click()
  const dialog = page.getByRole('dialog', { name: 'Upload invoice copy', exact: true })
  await expect(dialog).toBeVisible()
  expect(await dialog.evaluate(element => element.scrollWidth <= element.clientWidth)).toBe(true)
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  await page.screenshot({ path: `test-results/invoice-upload-${page.viewportSize()!.width}.png` })
  await dialog.getByLabel('Invoice number', { exact: true }).fill('SAMPLE-NEW')
  await dialog.getByLabel('Invoice total (₱)', { exact: true }).fill('2750.00')
  await dialog.getByLabel(/Copy \(PDF/).setInputFiles({ name: 'sample.pdf', mimeType: 'application/pdf', buffer: Buffer.from('%PDF sample for UI checks') })
  await dialog.getByRole('button', { name: 'Upload copy', exact: true }).click()
  await expect(sheet.getByRole('button', { name: 'Review uploaded copy' })).toBeVisible()
  await expect(sheet.getByText('Ready to send', { exact: true })).toBeVisible()
  await sheet.getByRole('button', { name: 'Send', exact: true }).click()
  await expect(sheet.getByRole('button', { name: 'Sent', exact: true })).toBeDisabled()
  await expect(sheet.getByRole('button', { name: 'Review uploaded copy' })).toHaveCount(0)
})
