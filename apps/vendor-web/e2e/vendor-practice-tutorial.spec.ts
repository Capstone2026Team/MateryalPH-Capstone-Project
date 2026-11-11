import { expect, test, type Locator, type Page } from '@playwright/test'
import { completedVendorTutorials } from './fixtures/tutorial-progress'

async function emptyPortal(page: Page, firstVisit = false) {
  const writes: string[] = []
  const sampleReads: string[] = []
  const progress = new Map<string, string>(firstVisit ? [] : completedVendorTutorials.map(row => [row.tutorial_key, row.status]))
  await page.route('**/api/v1/**', async route => {
    const request = route.request()
    const path = new URL(request.url()).pathname
    if (!['GET', 'HEAD'].includes(request.method()) && !path.endsWith('/csrf') && !path.includes('/account/tutorials')) writes.push(path)
    if (path.includes('demo-')) sampleReads.push(path)
    let data: unknown = []
    let meta: unknown = {}
    if (path.endsWith('/profile')) data = { id: 'practice-owner', full_name: 'Tutorial Reviewer', account_type: 'VENDOR', account_status: 'ACTIVE', role: 'OWNER' }
    else if (path.endsWith('/onboarding')) data = { step_completion: [], requirements: [], drafts: [], sections: {}, lock_version: 1, organization: { store_name: 'Example Supply', lock_version: 1 }, welcome_required: false,
      permissions: ['vendor.onboarding.manage', 'vendor.onboarding.submit', 'portal.products', 'catalog.manage', 'inventory.view', 'portal.vehicles', 'vehicles.manage', 'portal.invoices', 'invoices.view', 'invoices.upload', 'staff.manage', 'portal.tracking'], verification: { status: 'APPROVED' }, setup: { status: 'COMPLETED' }, activation: { status: 'ACTIVE', readiness: { ready: true, blockers: [] } } }
    else if (path.includes('/account/tutorials')) {
      if (request.method() === 'PUT') progress.set(path.split('/').at(-1)!, request.postDataJSON().status)
      data = [...progress].map(([tutorial_key, status]) => ({ tutorial_key, status, updated_at: '2026-11-11T00:00:00Z' }))
    }
    else if (path.endsWith('/vendor/invoices')) meta = { counts: { REQUESTS: 0, DUE: 0, RECORDS: 0, RECONCILIATION: 0 }, total: 0, has_more: false }
    else if (path.endsWith('/memberships')) meta = { current_page: 1, last_page: 1, total: 0 }
    else if (/fleet|vehicles/.test(path)) meta = { summary: { configurations: 0, total_vehicles: 0, active_vehicles: 0, available_vehicles: 0, out_for_delivery_vehicle_assignments: 0, out_for_delivery_orders: 0 }, scope: 'ORGANIZATION', delivery: { fulfillment_method: 'BOTH', delivery_enabled: false, service_radius_km: 50 }, permissions: { can_manage: true }, limits: { max_vehicles: 50 } }
    else if (path.endsWith('/csrf')) data = { csrf_token: 'tutorial-fixture' }
    await route.fulfill({ json: { data, meta, errors: [] } })
  })
  return { writes, sampleReads, progress }
}
async function openPractice(page: Page, feature: string, button: string) {
  await page.getByRole('button', { name: 'Help / tutorial' }).click()
  const help = page.getByRole('dialog', { name: 'Help / tutorial', exact: true })
  await help.getByRole('searchbox').fill(feature)
  await help.getByRole('button', { name: button, exact: true }).click()
  return page.getByRole('dialog', { name: button, exact: true })
}
async function fits(page: Page, demo: Locator) {
  await expect(demo).toBeVisible()
  await expect(demo.getByRole('button', { name: 'Skip', exact: true })).toBeInViewport()
  await expect(demo.getByRole('button', { name: 'Back', exact: true })).toBeInViewport()
  const box = (await demo.boundingBox())!
  const viewport = page.viewportSize()!
  expect(box.x).toBeGreaterThanOrEqual(0)
  expect(box.y).toBeGreaterThanOrEqual(0)
  expect(box.x + box.width).toBeLessThanOrEqual(viewport.width + 1)
  expect(box.y + box.height).toBeLessThanOrEqual(viewport.height + 1)
  expect(await demo.evaluate(element => element.scrollWidth <= element.clientWidth + 1)).toBe(true)
  expect(await demo.locator('.mp-practice-workspace').evaluate(element => element.scrollWidth <= element.clientWidth + 1)).toBe(true)
  await expect(demo.locator('[data-practice-highlight]')).toHaveCount(1)
  expect(await demo.locator('.mp-practice-workspace').evaluate(element => element.clientHeight)).toBeGreaterThan(135)
  expect(await page.evaluate(() => window.scrollX)).toBe(0)
}
async function next(demo: Locator) { await demo.getByRole('button', { name: 'Next', exact: true }).click() }
async function finishPageGuide(page: Page) {
  const tour = page.locator('dialog.mp-walkthrough')
  await expect(tour).toBeVisible()
  for (let step = 0; step < 80; step++) {
    await expect(tour.getByRole('button', { name: 'Opening…', exact: true })).toHaveCount(0)
    await expect(tour.getByRole('heading', { name: 'This guide is not ready' })).toHaveCount(0)
    const finish = tour.getByRole('button', { name: 'Finish', exact: true })
    if (await finish.count()) { await finish.click(); return }
    await next(tour)
  }
  throw new Error('The first-visit page guide did not finish')
}

for (const [path, key, title] of [
  ['/products', 'products', 'Practice adding a product'],
  ['/invoices', 'invoices', 'Practice E-Invoices'],
  ['/preview/tracking', 'tracking', 'Practice Team Tracking'],
] as const) {
  test(`first visit to ${path} offers practice automatically, remembers Skip and supports replay`, async ({ page }) => {
    const traffic = await emptyPortal(page, true)
    await page.goto(path)
    if (key === 'products') await finishPageGuide(page)
    const demo = page.getByRole('dialog', { name: title, exact: true })
    await fits(page, demo)
    expect(traffic.progress.has(key)).toBe(false)
    await demo.getByRole('button', { name: 'Skip', exact: true }).click()
    await expect.poll(() => traffic.progress.get(key)).toBe('SKIPPED')
    await page.reload()
    await expect(page.getByRole('button', { name: 'Help / tutorial' })).toBeVisible()
    await expect(page.getByRole('dialog')).toHaveCount(0)
    const replay = await openPractice(page, key, title)
    await fits(page, replay)
    await replay.getByRole('button', { name: 'Skip', exact: true }).click()
    expect(traffic.writes).toEqual([]); expect(traffic.sampleReads).toEqual([])
  })
}

test('product creation practice uses the real editor, keeps edits on Back and resets on replay', async ({ page }, info) => {
  const traffic = await emptyPortal(page)
  await page.goto('/invoices')
  const demo = await openPractice(page, 'product', 'Practice adding a product')
  await demo.getByRole('textbox', { name: 'Display name', exact: true }).fill('My practice plywood')
  await demo.getByRole('button', { name: 'Create sample draft' }).click()
  await fits(page, demo)
  await next(demo)
  await fits(page, demo)
  await demo.getByRole('textbox', { name: 'Description', exact: false }).fill('A description entered only in this tutorial.')
  await next(demo)
  await fits(page, demo)
  await demo.getByRole('button', { name: 'Back', exact: true }).click()
  await expect(demo.getByRole('textbox', { name: 'Description', exact: false })).toHaveValue('A description entered only in this tutorial.')
  await next(demo); await next(demo)
  await demo.getByRole('button', { name: 'Use sample product image' }).click()
  await fits(page, demo)
  await next(demo)
  await expect(demo.getByText('My practice plywood', { exact: true })).toBeVisible()
  await fits(page, demo)
  await page.screenshot({ path: info.outputPath('product-practice-review.png') })
  await demo.getByRole('button', { name: 'Publish listing', exact: true }).click()
  await expect(demo.getByText(/Sample publication completed/)).toBeVisible()
  await demo.getByRole('button', { name: 'Finish', exact: true }).click()
  await expect(demo).toHaveCount(0)
  const replay = await openPractice(page, 'product', 'Practice adding a product')
  await expect(replay.getByRole('textbox', { name: 'Display name', exact: true })).toHaveValue('Demo plywood 18 mm')
  await replay.getByRole('button', { name: 'Skip', exact: true }).click()
  expect(traffic.writes).toEqual([]); expect(traffic.sampleReads).toEqual([])
})

test('first Vehicles visit guides creation and remembers completed practice', async ({ page }, info) => {
  const traffic = await emptyPortal(page, true)
  await page.goto('/vehicles')
  await finishPageGuide(page)
  const demo = page.getByRole('dialog', { name: 'Practice adding a vehicle', exact: true })
  await demo.getByRole('textbox', { name: 'Vehicle Name', exact: true }).fill('Practice delivery pickup')
  await fits(page, demo)
  await next(demo); await fits(page, demo)
  await next(demo); await fits(page, demo)
  await next(demo); await fits(page, demo)
  await demo.getByText('Try the delivery rate calculator', { exact: true }).click()
  await demo.getByRole('spinbutton', { name: 'Sample delivery distance (km)' }).fill('10')
  await expect(demo.getByText(/Estimated delivery charge:.*550/)).toBeVisible()
  await next(demo)
  await demo.getByRole('checkbox', { name: 'Available now' }).uncheck()
  await demo.getByRole('button', { name: 'Save sample vehicle' }).click()
  await expect(demo.getByText(/Sample vehicle saved in this practice/)).toBeVisible()
  await fits(page, demo)
  await page.screenshot({ path: info.outputPath('vehicle-practice.png') })
  await demo.getByRole('button', { name: 'Finish', exact: true }).click()
  await expect.poll(() => traffic.progress.get('vehicles')).toBe('COMPLETED')
  await page.reload()
  await expect(page.getByRole('button', { name: 'Help / tutorial' })).toBeVisible()
  await expect(page.getByRole('dialog')).toHaveCount(0)
  await page.goto('/invoices')
  const invoiceDemo = page.getByRole('dialog', { name: 'Practice E-Invoices', exact: true })
  await expect(invoiceDemo).toBeVisible()
  await invoiceDemo.getByRole('button', { name: 'Skip', exact: true }).click()
  await expect.poll(() => traffic.progress.get('invoices')).toBe('SKIPPED')
  expect(traffic.writes).toEqual([]); expect(traffic.sampleReads).toEqual([])
})

test('empty invoices automatically open a sample upload, review, Send and correction walkthrough', async ({ page }, info) => {
  const traffic = await emptyPortal(page)
  await page.goto('/invoices')
  await page.getByRole('button', { name: 'Help / tutorial' }).click()
  const help = page.getByRole('dialog', { name: 'Help / tutorial', exact: true })
  await help.getByRole('searchbox').fill('invoices')
  await help.getByRole('button', { name: 'Tour E-Invoices', exact: true }).click()
  const demo = page.getByRole('dialog', { name: 'Practice E-Invoices', exact: true })
  await fits(page, demo)
  await next(demo); await fits(page, demo)
  await next(demo)
  await demo.getByRole('button', { name: 'Use sample invoice copy' }).click()
  await fits(page, demo)
  await demo.getByRole('button', { name: 'Save sample draft' }).click()
  await fits(page, demo)
  await next(demo)
  await demo.getByRole('button', { name: 'Send sample copy' }).click()
  await expect(demo.getByText(/No real invoice or Buyer notification was created/)).toBeVisible()
  await next(demo)
  await demo.getByRole('button', { name: 'Simulate Buyer return' }).click()
  await expect(demo.getByRole('heading', { name: 'DEMO-INV-001' })).toBeVisible()
  await fits(page, demo)
  await page.screenshot({ path: info.outputPath('invoice-practice.png') })
  await demo.getByRole('button', { name: 'Finish', exact: true }).click()
  await expect(demo).toHaveCount(0)
  await expect(page.getByText('No invoices match these dates.', { exact: true })).toBeVisible()
  expect(traffic.writes).toEqual([]); expect(traffic.sampleReads).toEqual([])
})

test('an empty team receives a fictional account and recorded event for the whole tracking tutorial', async ({ page }, info) => {
  const traffic = await emptyPortal(page)
  await page.goto('/preview/tracking')
  await page.getByRole('button', { name: 'Help / tutorial' }).click()
  const help = page.getByRole('dialog', { name: 'Help / tutorial', exact: true })
  await help.getByRole('searchbox').fill('tracking')
  await help.getByRole('button', { name: 'Tour Team Tracking', exact: true }).click()
  const demo = page.getByRole('dialog', { name: 'Practice Team Tracking', exact: true })
  await expect(demo.getByRole('button', { name: /Demo Inventory Staff/ })).toHaveAttribute('aria-pressed', 'true')
  for (let step = 0; step < 4; step++) { await fits(page, demo); await next(demo) }
  await expect(demo.getByText('Stock updated', { exact: true })).toBeVisible()
  await demo.getByText('Record details', { exact: true }).click()
  await expect(demo.getByText('40 → 50', { exact: true })).toBeVisible()
  await fits(page, demo)
  await next(demo); await fits(page, demo)
  await page.screenshot({ path: info.outputPath('tracking-practice.png') })
  await demo.getByRole('button', { name: 'Finish', exact: true }).click()
  await expect(demo).toHaveCount(0)
  await expect(page.getByText(/No team members match this view/)).toBeVisible()
  await expect(page.getByText('Demo Inventory Staff', { exact: true })).toHaveCount(0)
  expect(traffic.writes).toEqual([]); expect(traffic.sampleReads).toEqual([])
})
