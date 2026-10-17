import { expect, test } from '@playwright/test'

test('assigned staff workspace reflows, keeps role navigation and requires submitted delivery proof', async ({ page }) => {
  const fulfillment = {
    method: 'DELIVERY', state: 'OUT_FOR_DELIVERY', expected_date: '2026-10-14', late: false, tracking_notice: 'No live GPS tracking. Status changes when a milestone is recorded.',
    steps: [{ key: 'CONFIRMED', label: 'Confirmed', status: 'COMPLETE', proof_required: false, proof_requirements: [] }, { key: 'OUT_FOR_DELIVERY', label: 'Out for delivery', status: 'COMPLETE', proof_required: false, proof_requirements: [] }, { key: 'DELIVERED', label: 'Delivered', status: 'CURRENT', proof_required: true, proof_requirements: ['DELIVERY_PHOTO', 'RECEIVER_NAME', 'SIGNATURE_OPTIONAL'] }],
    receipt: { paused: false, window_hours: 48 }, trips: [], vehicle_issues: [], assignment_history: [], proof_upload_limit_kb: 10240,
    assignment: { display_name: 'Delivery Staff', role: 'FULFILLMENT', assigned_at: '2026-10-13T01:00:00Z', vehicle: { name: 'Accepted box truck', vehicle_index: 0, number_of_vehicles: 1, total_vehicle_trips: 1 } },
    thread: { available: true, conversation_id: 'delivery-thread', read_only: false, unread_count: 0 }, next_action: 'RECORD_DELIVERY',
  }
  const order = { id: 'delivery-layout', reference: 'ORD-DELIVERY-LAYOUT', vendor: { id: 'sample-store', name: 'Sample Delivery Supply' }, procurement_type: 'ITEM_BASED', fulfillment_method: 'DELIVERY', payment_method: 'ONLINE', submitted_at: '2026-10-13T00:00:00Z', accepted_at: '2026-10-13T00:30:00Z', lock_version: 4, states: [{ family: 'ORDER', state: 'OUT_FOR_DELIVERY' }], changes: [], lines: [], timeline: [], buyer: { display_name: 'Sample Buyer' }, destination: { type: 'DELIVERY', intended: { label: 'Project site', formatted_address: 'Site address' }, heavy_vehicle_restriction: 'YES', alternate_drop_off: { label: 'North gate', formatted_address: 'Confirmed north gate, Example street, Quezon City' }, access_instructions: 'Use the north gate. Coordinate unloading with the receiver.' }, permissions: { can_record_milestone: true, can_assign_fulfillment: false, can_report_vehicle_issue: true }, fulfillment }
  let proofSubmissions = 0
  await page.route('**/api/v1/**', async route => {
    const url = new URL(route.request().url())
    let data: unknown = {}, meta: unknown = {}
    if (url.pathname.endsWith('/csrf')) data = { csrf_token: 'synthetic-delivery-fixture' }
    if (url.pathname.endsWith('/profile')) data = { id: 'sample-staff', full_name: 'Delivery Staff', account_type: 'VENDOR', account_status: 'ACTIVE', role: 'FULFILLMENT' }
    if (url.pathname.endsWith('/onboarding')) data = { step_completion: [], requirements: [], drafts: [], sections: {}, lock_version: 1, organization: { store_name: 'Sample Delivery Supply' }, permissions: ['portal.fulfillment', 'portal.orders', 'portal.messages', 'portal.notifications', 'portal.vehicles', 'fulfillment.record', 'vehicles.view_assigned'], welcome_required: false, verification: { status: 'APPROVED' }, setup: { status: 'COMPLETED' }, activation: { status: 'ACTIVE', readiness: { ready: true, blockers: [] } } }
    if (url.pathname.endsWith('/vendor/fulfillment')) { data = [order]; meta = { page: 1, per_page: 20, total: 1, has_more: false } }
    if (url.pathname.endsWith('/vendor/orders/delivery-layout')) data = order
    if (url.pathname.endsWith('/fulfillment/route')) { await route.fulfill({ status: 503, json: { data: null, errors: [{ code: 'ROUTE_UNAVAILABLE', message: 'Delivery directions are temporarily unavailable.' }] } }); return }
    if (url.pathname.endsWith('/fulfillment/milestones')) {
      proofSubmissions++
      data = { ...order, states: [{ family: 'ORDER', state: 'DELIVERED' }], fulfillment: { ...fulfillment, state: 'DELIVERED', next_action: 'AWAIT_RECEIPT', steps: [{ key: 'DELIVERED', label: 'Delivered', status: 'COMPLETE', proof_required: true, proof_requirements: [], proof: { milestone: 'DELIVERED', receiver_name: 'Sample Receiver', handover_confirmed: false, recorded_at: '2026-10-13T02:00:00Z' } }] } }
    }
    await route.fulfill({ json: { data, meta, errors: [] } })
  })
  await page.goto('/fulfillment')
  await expect(page.getByRole('heading', { name: 'Fulfillment', exact: true })).toBeVisible()
  await expect(page.getByText('Accepted box truck', { exact: true })).toBeVisible()
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  await page.screenshot({ path: `test-results/assigned-deliveries-${page.viewportSize()!.width}.png`, fullPage: true })
  const menu = page.getByRole('button', { name: 'Open navigation' })
  if (await menu.isVisible()) await menu.click()
  const sidebar = page.getByRole('navigation', { name: 'VENDOR PORTAL menu' })
  await expect(sidebar.getByRole('link', { name: 'Fulfillment', exact: true })).toBeVisible()
  await expect(sidebar.getByRole('link', { name: 'Store Profile', exact: true })).toHaveCount(0)
  await expect(sidebar.getByRole('link', { name: 'E-Invoices', exact: true })).toHaveCount(0)
  await expect(sidebar.getByRole('link', { name: 'My Products', exact: true })).toHaveCount(0)
  if (await page.getByRole('button', { name: 'Close navigation' }).isVisible()) await page.getByRole('button', { name: 'Close navigation' }).click()
  await page.getByRole('link', { name: 'View assignment' }).click()
  await expect(page.getByRole('heading', { name: 'ORD-DELIVERY-LAYOUT' })).toBeVisible()
  await expect(page.getByRole('link', { name: 'Open directions' })).toHaveAttribute('href', /Confirmed%20north%20gate/)
  await page.getByRole('button', { name: 'Record delivery', exact: true }).click()
  await expect(page.getByText('Add a delivery photo.')).toBeVisible()
  expect(proofSubmissions).toBe(0)
  await page.getByRole('textbox', { name: /Receiver name/ }).fill('Sample Receiver')
  await page.locator('input[type="file"]:not([capture])').first().setInputFiles({ name: 'pod.png', mimeType: 'image/png', buffer: Buffer.from('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aH1cAAAAASUVORK5CYII=', 'base64') })
  await expect(page.getByRole('img', { name: /Selected image preview/ })).toBeVisible()
  await expect(page.getByLabel('Take delivery photo')).toHaveAttribute('capture', 'environment')
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  await page.screenshot({ path: `test-results/delivery-proof-${page.viewportSize()!.width}.png`, fullPage: true })
  await page.getByRole('button', { name: 'Record delivery', exact: true }).click()
  await expect(page.getByText('Received by')).toBeVisible()
  expect(proofSubmissions).toBe(1)
})

for (const role of ['OWNER', 'STORE_MANAGER', 'STORE_STAFF', 'CUSTOMER_SERVICE', 'INVENTORY']) {
  test(`${role} sidebar scopes Store Profile and excludes the staff workspace`, async ({ page }) => {
    const permissions = ['portal.orders', 'portal.notifications', ...(role === 'OWNER' ? ['organization.legal', 'vendor.onboarding.submit', 'vehicles.manage', 'fulfillment.assign'] : role === 'STORE_MANAGER' ? ['vehicles.manage', 'fulfillment.assign'] : [])]
    await page.route('**/api/v1/**', async route => {
      const path = new URL(route.request().url()).pathname
      let data: unknown = {}
      if (path.endsWith('/csrf')) data = { csrf_token: 'synthetic-sidebar-fixture' }
      if (path.endsWith('/profile')) data = { id: 'fixture-member', full_name: 'Sidebar Member', account_type: 'VENDOR', account_status: 'ACTIVE', role }
      if (path.endsWith('/onboarding')) data = { step_completion: [], requirements: [], drafts: [], sections: {}, lock_version: 1, organization: { store_name: 'Sample Store' }, permissions, welcome_required: false, verification: { status: 'APPROVED' }, setup: { status: 'COMPLETED' }, activation: { status: 'ACTIVE', readiness: { ready: true, blockers: [] } } }
      await route.fulfill({ json: { data, meta: {}, errors: [] } })
    })
    await page.goto('/fulfillment')
    await expect(page.getByText(/This workspace is available to Fulfillment Staff/)).toBeVisible()
    const menu = page.getByRole('button', { name: 'Open navigation' })
    if (await menu.isVisible()) await menu.click()
    const sidebar = page.getByRole('navigation', { name: 'VENDOR PORTAL menu' })
    await expect(sidebar.getByRole('link', { name: 'Fulfillment', exact: true })).toHaveCount(0)
    await expect(sidebar.getByRole('link', { name: 'Store Profile', exact: true })).toHaveCount(role === 'OWNER' || role === 'STORE_MANAGER' ? 1 : 0)
  })
}
