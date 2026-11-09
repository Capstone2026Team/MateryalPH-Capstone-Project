import { expect, test } from '@playwright/test'
import { fileURLToPath } from 'node:url'
import { orderAuditDetailWire, orderAuditSummaryWire } from '../../admin-web/src/test/order-audit-fixture'

test('Audit Log order and refund browser opens a passive responsive order view', async ({ page }) => {
  const mutations: string[] = []
  await page.route('**/api/v1/**', async route => {
    const request = route.request(), path = new URL(request.url()).pathname
    if (request.method() !== 'GET') mutations.push(`${request.method()} ${path}`)
    let data: unknown = {}, meta: unknown = {}
    if (path.endsWith('/profile')) data = { id: 'audit-review', full_name: 'Platform Admin', account_type: 'ADMIN', account_status: 'ACTIVE', role: 'ADMIN_SUPERADMIN' }
    else if (path.endsWith('/auth/csrf')) data = { csrf_token: 'synthetic-layout-csrf' }
    else if (path.endsWith('/notifications/unread-count')) data = { count: 0 }
    else if (path.endsWith('/admin/order-operations/orders')) { data = [orderAuditSummaryWire]; meta = { group: 'ALL', counts: {}, page: 1, per_page: 20, total: 1, has_more: false, current_as_of: '2026-11-07T01:00:00Z' } }
    else if (path.endsWith('/orders/order-layout')) data = orderAuditDetailWire
    else if (path.endsWith('/admin/order-operations/refunds')) data = [{ id: 'refund-1', order_id: 'order-layout', order_reference: orderAuditSummaryWire.reference, vendor_name: 'Sample Supply', target_type: 'ORDER', trigger: 'CANCELLATION', state: 'REFUND_FAILED', display_state: 'FAILED', amount_centavos: 280000, attempt_number: 1, evidence_origin: 'SIMULATED', can_retry: true }]
    else if (path.endsWith('/admin/order-operations/reimbursements')) data = [{ id: 'cash-1', order_id: 'order-layout', order_reference: orderAuditSummaryWire.reference, vendor_name: 'Sample Supply', state: 'VENDOR_REIMBURSEMENT_PENDING', amount_centavos: 275000, method: 'CASH_ON_DELIVERY', has_evidence: true, confirmed_by_review: false, can_decide: true }]
    await route.fulfill({ json: { data, meta, errors: [] } })
  })
  await page.goto('http://127.0.0.1:4174/audit?view=transactions')
  await expect(page.getByRole('heading', { name: 'Audit Log', exact: true })).toBeVisible()
  await expect(page.getByRole('link', { name: 'View order', exact: true }).first()).toBeVisible()
  const filters = page.getByRole('region', { name: 'Transaction filters', exact: true })
  const search = filters.getByRole('searchbox', { name: 'Order, Buyer or Vendor' })
  await expect(search).toBeVisible()
  if (page.viewportSize()!.width >= 1024) {
    const searchBounds = (await search.boundingBox())!
    const statusBounds = (await filters.getByRole('combobox', { name: 'Status', exact: true }).boundingBox())!
    const methodBounds = (await filters.getByRole('combobox', { name: 'Payment method', exact: true }).boundingBox())!
    const panelBounds = (await filters.boundingBox())!
    expect(Math.abs(searchBounds.y - statusBounds.y)).toBeLessThanOrEqual(1)
    expect(Math.abs(searchBounds.y - methodBounds.y)).toBeLessThanOrEqual(1)
    expect(panelBounds.x + panelBounds.width - methodBounds.x - methodBounds.width).toBeLessThanOrEqual(20)
  }
  await filters.screenshot({ path: test.info().outputPath('order-filters.png') })
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  await page.getByRole('link', { name: 'View order', exact: true }).first().click()
  await expect(page.getByRole('heading', { name: 'Recorded payment breakdown' })).toBeVisible()
  await expect(page.getByRole('heading', { name: 'Payment transactions' })).toBeVisible()
  await expect(page.getByRole('heading', { name: 'Cancellation & refunds' })).toBeVisible()
  await expect(page.getByRole('button', { name: /Retry|Pay now|Confirm|Cancel|Decline|Approve/ })).toHaveCount(0)
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  await page.screenshot({ path: test.info().outputPath('read-only-order.png'), fullPage: true })
  await page.getByRole('link', { name: 'Return to orders & refunds' }).click()
  await page.getByRole('tab', { name: 'Online refunds' }).click()
  await expect(page.getByRole('link', { name: 'View order', exact: true }).first()).toBeVisible()
  await expect(page.getByRole('button', { name: /Retry after funding/ })).toHaveCount(0)
  await filters.screenshot({ path: test.info().outputPath('refund-filters.png') })
  await page.getByRole('tab', { name: 'Cash reimbursements' }).click()
  await expect(page.getByText('Pending reimbursement confirmation').filter({ visible: true })).toBeVisible()
  await expect(page.getByRole('button', { name: /Confirm reimbursement/ })).toHaveCount(0)
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  expect(mutations).toEqual([])
  await filters.screenshot({ path: test.info().outputPath('cash-filters.png') })
  await page.screenshot({ path: test.info().outputPath('cash-reimbursements.png'), fullPage: true })
})

test('completed order keeps a compact summary and small evidence thumbnails with a full-size preview', async ({ page }) => {
  const orderId = '01900000-0000-7000-8000-000000000001'
  const evidencePath = `/admin/order-operations/orders/${orderId}/files/01900000-0000-7000-8000-000000000002`
  const recordedAt = '2026-11-07T04:00:00Z'
  const mutations: string[] = []
  const errors: string[] = []
  page.on('pageerror', error => errors.push(error.message))
  const detail = {
    ...orderAuditDetailWire, id: orderId, reference: 'ORD-2026-COMPLETED', accepted_at: recordedAt, closed_at: recordedAt,
    commercial_version: { ...orderAuditDetailWire.commercial_version, accepted: 1 },
    lines: orderAuditDetailWire.lines.map(line => ({ ...line, confirmed_quantity: '10' })),
    money: { ...orderAuditDetailWire.money, status: 'FINAL', processing_fee: { status: 'CONFIRMED', amount_centavos: 5000 } },
    states: [{ family: 'ORDER', state: 'COMPLETED' }, { family: 'PAYMENT', state: 'PAID' }, { family: 'FULFILLMENT', state: 'PICKED_UP' }, { family: 'REFUND', state: 'NOT_REQUESTED' }, { family: 'DISPUTE', state: 'NONE' }],
    refund_timeline: { refunds: [], reimbursements: [], no_longer_due_centavos: 0 },
    fulfillment: {
      method: 'PICKUP', state: 'PICKED_UP', late: false,
      steps: ['Confirmed', 'Preparing', 'Ready for pickup', 'Picked up', 'Receipt confirmed'].map((label, index) => ({ key: `step-${index}`, label, status: 'COMPLETE', at: recordedAt, actor_role: 'OWNER', proof_required: false, proof_requirements: [] })),
      proof: { photo_path: evidencePath, receiver_name: 'Sample Buyer', recorded_at: recordedAt, recorded_by: 'Owner', note: 'Pickup handover recorded.' },
      receipt: { paused: false, confirmed_at: recordedAt, confirmation_source: 'BUYER', window_hours: 24 },
      trips: [], vehicle_issues: [], next_action: 'NONE', tracking_notice: 'Recorded milestones only. No live vehicle tracking.',
    },
    timeline: ['CONFIRMED', 'PROCESSING', 'READY_FOR_PICKUP', 'PICKED_UP', 'COMPLETED'].map(toState => ({ family: 'ORDER', to_state: toState, source: 'VENDOR', actor_role: 'OWNER', snapshot_version: 1, at: recordedAt })),
  }
  await page.route('**/api/v1/**', async route => {
    const request = route.request(), path = new URL(request.url()).pathname
    if (request.method() !== 'GET') mutations.push(`${request.method()} ${path}`)
    if (path.endsWith(evidencePath)) {
      await route.fulfill({ contentType: 'image/jpeg', path: fileURLToPath(new URL('../../../packages/web-ui/src/assets/materials-store.jpg', import.meta.url)) })
      return
    }
    let data: unknown = {}
    if (path.endsWith('/profile')) data = { id: 'audit-review', full_name: 'Platform Admin', account_type: 'ADMIN', account_status: 'ACTIVE', role: 'ADMIN_SUPERADMIN' }
    else if (path.endsWith('/auth/csrf')) data = { csrf_token: 'synthetic-layout-csrf' }
    else if (path.endsWith('/notifications/unread-count')) data = { count: 0 }
    else if (path.endsWith(`/orders/${orderId}`)) data = detail
    await route.fulfill({ json: { data, meta: {}, errors: [] } })
  })
  await page.goto(`http://127.0.0.1:4174/audit/orders/${orderId}`)
  const overview = page.getByRole('region', { name: 'Order overview', exact: true })
  await expect(overview).toBeVisible()
  await expect(overview.getByRole('heading', { name: 'Recorded payment breakdown' })).toBeVisible()
  const payments = page.getByRole('region', { name: 'Payment transactions', exact: true })
  await expect(payments.getByText('TEST · SIMULATED').filter({ visible: true })).toBeVisible()
  await expect(payments.getByText('Principal ₱2,750.00').filter({ visible: true })).toBeVisible()
  await expect(payments.getByText('Processing fee ₱50.00').filter({ visible: true })).toBeVisible()
  const thumbnail = page.getByRole('button', { name: 'View handover evidence 1' })
  await expect(thumbnail).toBeVisible()
  const bounds = await thumbnail.boundingBox()
  expect(bounds!.width).toBeLessThanOrEqual(192)
  expect(bounds!.height).toBeLessThan(256)
  const layout = await page.locator('.order-audit').evaluate(element => {
    const info = element.querySelector('.order-audit__information')!.getBoundingClientRect()
    const money = element.querySelector('.order-audit__money')!.getBoundingClientRect()
    return { width: element.clientWidth, sideBySide: money.left >= info.right - 1 }
  })
  expect(layout.sideBySide).toBe(layout.width >= 960)
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  await thumbnail.click()
  const preview = page.getByRole('dialog', { name: 'Handover evidence 1 full preview' })
  await expect(preview).toBeVisible()
  await preview.getByRole('button', { name: 'Zoom in' }).click()
  await expect(preview.getByRole('button', { name: 'Fit image' })).toHaveAttribute('aria-pressed', 'true')
  await preview.getByRole('button', { name: 'Close preview' }).click()
  await expect(thumbnail).toBeFocused()
  await page.getByRole('region', { name: 'Fulfillment evidence', exact: true }).screenshot({ path: test.info().outputPath('compact-fulfillment.png') })
  await page.getByRole('heading', { name: 'ORD-2026-COMPLETED' }).scrollIntoViewIfNeeded()
  await page.screenshot({ path: test.info().outputPath('compact-completed-order.png'), fullPage: true })
  expect(mutations).toEqual([])
  expect(errors).toEqual([])
})
