import { expect, test, type Page } from '@playwright/test'
import { vendorInsights } from './fixtures/dashboard-insights'
import { tutorialCommission, tutorialEarnings, tutorialFinance } from './fixtures/tutorial-finance'
import { completedVendorTutorials } from './fixtures/tutorial-progress'

async function mockPortal(page: Page, withTeamMember = false) {
  const writes: string[] = []
  await page.route('**/api/v1/**', async route => {
    const request = route.request()
    const path = new URL(request.url()).pathname
    if (!['GET', 'HEAD'].includes(request.method()) && !path.endsWith('/csrf') && !path.includes('/account/tutorials')) writes.push(path)
    let data: unknown = {}
    let meta: unknown = {}
    if (path.includes('/account/tutorials')) data = completedVendorTutorials
    else if (path.endsWith('/profile')) data = { id: 'guide-review', full_name: 'Guide Reviewer', account_type: 'VENDOR', account_status: 'ACTIVE', role: 'OWNER' }
    else if (path.endsWith('/onboarding')) data = {
      step_completion: [], requirements: [], drafts: [], sections: {}, lock_version: 1,
      organization: { store_name: 'Sample Supply', lock_version: 1 },
      permissions: ['vendor.onboarding.manage', 'vendor.onboarding.submit', 'portal.products', 'catalog.manage', 'inventory.view', 'portal.orders', 'portal.messages', 'portal.vehicles', 'vehicles.manage', 'portal.wallet', 'portal.earnings', 'finance.view', 'scores.view_store', 'staff.manage', 'portal.tracking', 'portal.disputes', 'portal.invoices', 'invoices.view', 'portal.reviews'], welcome_required: false,
      verification: { status: 'APPROVED' }, setup: { status: 'COMPLETED' }, activation: { status: 'ACTIVE', readiness: { ready: true, blockers: [] } },
    }
    else if (path.endsWith('/vendor/dashboard/insights')) data = vendorInsights()
    else if (path.endsWith('/vendors/account/memberships')) { data = withTeamMember ? [{ id: 'team-one', name: 'Sample Team Member', role: 'INVENTORY', status: 'ACTIVE', can_manage_staff: false, lock_version: 1 }] : []; meta = { current_page: 1, last_page: 1, total: withTeamMember ? 1 : 0 } }
    else if (path.endsWith('/vendors/account/activity/performance')) data = {
      member_id: 'team-one', role: 'INVENTORY', timezone: 'Asia/Manila', from: '2026-10-13', to: '2026-11-11', sales_value_visible: false,
      activity: { total: 7, succeeded: 6, unsuccessful: 1 }, sales: null, quotations: null, orders: null, disputes: null, fulfillment: null,
      inventory: { stock_updates: 2, stock_confirmations: 1, listings_created: 1, listing_updates: 2, compliance_submissions: 1, allotment_updates: 0, unsuccessful: 1 },
      trend: { metric: 'INVENTORY_UPDATES', granularity: 'DAY', from: '2026-10-13', to: '2026-11-11', points: [{ date: '2026-11-10', value: 7 }] },
    }
    else if (path.endsWith('/vendors/account/activity')) { data = []; meta = { current_page: 1, last_page: 1, total: 0, total_events: 0, succeeded_events: 0, failed_events: 0, categories: [] } }
    else if (path.endsWith('/vendor/finance/earnings')) data = tutorialEarnings
    else if (path.endsWith('/vendor/finance/commissions')) data = tutorialCommission
    else if (path.endsWith('/vendor/finance')) data = tutorialFinance
    else if (/finance\/(transactions|statements)/.test(path)) { data = []; meta = { total: 0, has_more: false } }
    else if (path.endsWith('/vendor/invoices')) {
      data = [{ order_id: 'invoice-order', order_reference: 'PRIVATE-ORDER-REFERENCE', buyer_name: 'PRIVATE BUYER NAME', order_state: 'COMPLETED' }]
      meta = { counts: { REQUESTS: 1, DUE: 6, RECORDS: 1, RECONCILIATION: 1 }, total: 1, has_more: false }
    }
    else if (path.endsWith('/invoices') && path.includes('/orders/')) data = {
      order_id: 'invoice-order', order_reference: 'PRIVATE-ORDER-REFERENCE', status: 'NOT_YET_UPLOADED', issuance_notice: 'The Vendor issues its own invoice.', issuer_name: 'Sample Supply',
      records: [], requests: [], platform_documents: [], billing_details: null, buyer_name: 'PRIVATE BUYER NAME', can_upload: false, can_open_files: false,
      invoice_types: [], source_systems: [], invoicing_methods: [], lines: [],
    }
    else if (path.endsWith('/auth/csrf')) data = { csrf_token: 'guide-fixture' }
    else if (/fleet|vehicles/.test(path)) { data = []; meta = { summary: { configurations: 0, total_vehicles: 0, active_vehicles: 0, available_vehicles: 0, out_for_delivery_vehicle_assignments: 0, out_for_delivery_orders: 0 }, scope: 'ORGANIZATION', delivery: { fulfillment_method: 'BOTH', delivery_enabled: false, service_radius_km: 50 }, permissions: { can_manage: true }, limits: { max_vehicles: 50 } } }
    else if (/activity|enforcement|invitations|memberships/.test(path)) data = []
    await route.fulfill({ json: { data, meta, errors: [] } })
  })
  return writes
}

async function assertCardFits(page: Page) {
  const card = page.locator('.mp-walkthrough-card')
  await expect(card.getByRole('button', { name: 'Skip', exact: true })).toBeInViewport()
  const box = await card.boundingBox()
  const viewport = page.viewportSize()!
  expect(box!.y).toBeGreaterThanOrEqual(0)
  expect(box!.x).toBeGreaterThanOrEqual(0)
  expect(box!.y + box!.height).toBeLessThanOrEqual(viewport.height + 1)
  expect(box!.x + box!.width).toBeLessThanOrEqual(viewport.width + 1)
  expect(await page.evaluate(() => window.scrollX)).toBe(0)
  if (viewport.width >= 1024) expect(box!.x).toBeGreaterThanOrEqual((await page.locator('#main-content').boundingBox())!.x)
  expect(await card.locator('.mp-walkthrough-copy').evaluate(element => element.clientHeight)).toBeGreaterThan(95)
  for (const button of await card.getByRole('button').all()) await expect(button).toBeInViewport()
  const spotlight = page.locator('.mp-walkthrough-ring')
  const ring = await spotlight.count() ? await spotlight.boundingBox() : null
  if (ring) {
    const intersects = ring.x < box!.x + box!.width && ring.x + ring.width > box!.x && ring.y < box!.y + box!.height && ring.y + ring.height > box!.y
    expect(intersects, 'Spotlight must not overlap its instruction card').toBe(false)
  }
}

async function completeFeature(page: Page, expected: string[]) {
  const tour = page.locator('dialog.mp-walkthrough')
  const seen = new Set<string>()
  const titles: string[] = []
  for (let count = 0; count < 150; count++) {
    await expect(tour.getByRole('button', { name: 'Opening…', exact: true })).toHaveCount(0)
    const title = await tour.getByRole('heading').innerText()
    expect(title).not.toBe('This guide is not ready')
    expect(title).not.toMatch(/PRIVATE|per day|per month/)
    expect(await tour.locator('.mp-walkthrough-copy p').innerText()).not.toMatch(/Read the measure|Review this section|Use its information control|Compare the labelled axes/)
    const unexplained = await page.locator('#main-content .mp-metric-card:not([data-vendor-guide-target])').evaluateAll(elements => elements.filter(element => element.getClientRects().length > 0 && !element.closest('dialog, [hidden], [aria-hidden="true"]')).map(element => element.querySelector('.mp-kpi-label')?.textContent))
    expect(unexplained, 'Every visible metric needs its own authored explanation').toEqual([])
    await assertCardFits(page)
    if (title === 'Current role' || title === 'Stock updates') {
      await expect.poll(() => tour.locator('.mp-walkthrough-copy').evaluate(element => element.getAnimations().some(animation => animation.playState === 'running'))).toBe(false)
      await page.screenshot({ path: test.info().outputPath(title === 'Current role' ? 'team-picker-guide.png' : 'team-statistic-guide.png') })
    }
    seen.add(title)
    titles.push(title)
    if (await tour.getByRole('button', { name: 'Finish', exact: true }).count()) { await tour.getByRole('button', { name: 'Finish', exact: true }).click(); break }
    await tour.getByRole('button', { name: 'Next', exact: true }).click()
  }
  await expect(tour).toHaveCount(0)
  for (const title of expected) expect(seen.has(title), title).toBe(true)
  return titles
}

test('help lists every workspace and tours every dashboard chapter, metric and graph', async ({ page }, testInfo) => {
  const writes = await mockPortal(page)
  await page.goto('/dashboard')
  await expect(page.getByRole('tab', { name: 'Traffic & Volume', exact: true })).toBeVisible()
  await page.getByRole('button', { name: 'Help / tutorial' }).click()
  const help = page.getByRole('dialog', { name: 'Help / tutorial', exact: true })
  for (const name of ['Overview', 'Store Operations', 'Store Management', 'Finance', 'Analytics', 'Vendor Team Accounts', 'Store Profile', 'Account & Help']) await expect(help.getByRole('heading', { name, exact: true })).toBeVisible()
  await expect(help.getByText('On this page', { exact: true })).toHaveCount(0)
  await expect(help.getByText('Bulk import', { exact: true })).toHaveCount(0)
  await help.getByRole('searchbox', { name: 'Find a page or feature' }).fill('vehicles')
  await expect(help.getByRole('button', { name: 'Tour Vehicles', exact: true })).toBeVisible()
  await help.getByRole('searchbox', { name: 'Find a page or feature' }).fill('')
  await expect.poll(() => help.evaluate(element => element.getAnimations().some(animation => animation.playState === 'running'))).toBe(false)
  const helpBounds = await help.boundingBox()
  expect(helpBounds).not.toBeNull()
  expect(helpBounds!.x).toBeGreaterThanOrEqual(0)
  expect(helpBounds!.x + helpBounds!.width).toBeLessThanOrEqual(page.viewportSize()!.width + 1)
  await page.screenshot({ path: testInfo.outputPath('expanded-vendor-help.png') })
  await help.getByRole('button', { name: 'Tour this page: Dashboard' }).click()
  const tour = page.locator('dialog.mp-walkthrough')
  await expect(tour.getByRole('heading', { name: 'Dashboard · Overview', exact: true })).toBeVisible()
  const seen = new Set<string>()
  let finished = false
  for (let count = 0; count < 120; count++) {
    await expect(tour.getByRole('button', { name: 'Opening…', exact: true })).toHaveCount(0)
    const title = await tour.getByRole('heading').innerText()
    seen.add(title)
    expect(title).not.toBe('This guide is not ready')
    expect(await tour.locator('.mp-walkthrough-copy p').innerText()).not.toMatch(/Read the measure|Review this section|Use its information control|Compare the labelled axes/)
    expect(await page.locator('#main-content .mp-metric-card:not([data-vendor-guide-target])').evaluateAll(elements => elements.filter(element => element.getClientRects().length > 0 && !element.closest('dialog, [hidden], [aria-hidden="true"]')).map(element => element.querySelector('.mp-kpi-label')?.textContent)), 'Dashboard metrics need authored explanations').toEqual([])
    await assertCardFits(page)
    if (title === 'Sales trend') {
      await expect.poll(() => page.locator('.mp-walkthrough-ring').evaluate(element => element.getAnimations().some(animation => animation.playState === 'running'))).toBe(false)
      await page.screenshot({ path: testInfo.outputPath('sales-trend-guide.png') })
    }
    if (await tour.getByRole('button', { name: 'Finish', exact: true }).count()) { await tour.getByRole('button', { name: 'Finish', exact: true }).click(); finished = true; break }
    const next = tour.getByRole('button', { name: 'Next', exact: true })
    if (await next.count()) await next.click()
    else throw new Error('The tour has no next control')
  }
  expect(finished).toBe(true)
  for (const title of ['Dashboard · Overview', 'Earnings', 'Sales trend', 'Order activity', 'Dashboard · Traffic & Volume', 'Demand funnel', 'Order mix', 'Requests and confirmations per day', 'Dashboard · Disputes & Quality', 'Cases filed per day', 'Issue types', 'Open cases by status', 'Cancellation']) expect(seen.has(title), title).toBe(true)
  expect(writes).toEqual([])
})

test('Invoices is one continuous tour through all four views with a populated detail panel', async ({ page }, testInfo) => {
  const writes = await mockPortal(page)
  await page.goto('/invoices?view=DUE')
  await expect(page.getByRole('heading', { name: 'PRIVATE-ORDER-REFERENCE' })).toBeVisible()
  await page.getByRole('button', { name: 'Help / tutorial' }).click()
  const help = page.getByRole('dialog', { name: 'Help / tutorial', exact: true })
  await help.getByRole('searchbox').fill('invoices')
  await expect(help.getByRole('button', { name: 'Requests', exact: true })).toHaveCount(0)
  await help.getByRole('button', { name: 'Tour E-Invoices', exact: true }).click()
  await completeFeature(page, ['E-Invoices · Requests', 'E-Invoices · No copy yet', 'E-Invoices · Uploaded', 'E-Invoices · Mismatches', 'Invoice details'])
  await page.screenshot({ path: testInfo.outputPath('invoices-after-tour.png') })
  expect(writes).toEqual([])
})

test('Finance continues from overview into commission, transactions and remittance without hidden graph tables', async ({ page }) => {
  test.setTimeout(60_000)
  const writes = await mockPortal(page)
  await page.goto('/finance')
  await page.getByRole('button', { name: 'Help / tutorial' }).click()
  const help = page.getByRole('dialog', { name: 'Help / tutorial', exact: true })
  await help.getByRole('searchbox').fill('finance')
  await help.getByRole('button', { name: 'Tour Finance overview', exact: true }).click()
  await completeFeature(page, ['Finance overview', 'Deductions and commission', 'Product sales value', 'Online payment channels', 'Commission monitoring', 'Annual total commission payment', 'Monthly commission payment', 'Current commission balances', 'Transactions', 'Xendit cash revenue & remittance'])
  expect(writes).toEqual([])
})

test('Team Tracking offers a tutorial sample when the authorized team list is empty', async ({ page }) => {
  await mockPortal(page)
  await page.goto('/preview/tracking')
  await page.getByRole('button', { name: 'Help / tutorial' }).click()
  const help = page.getByRole('dialog', { name: 'Help / tutorial', exact: true })
  await help.getByRole('searchbox').fill('tracking')
  await help.getByRole('button', { name: 'Tour Team Tracking', exact: true }).click()
  const demo = page.getByRole('dialog', { name: 'Practice Team Tracking', exact: true })
  await expect(demo.getByRole('button', { name: /Demo Inventory Staff/ })).toHaveAttribute('aria-pressed', 'true')
  await demo.getByRole('button', { name: 'Skip', exact: true }).click()
  await expect(page.getByText('Demo Inventory Staff', { exact: true })).toHaveCount(0)
  await page.goto('/products/import')
  await expect(page).toHaveURL(/\/products$/)
})

test('Team Tracking automatically selects the first account and tours all views without repetition or horizontal scrolling', async ({ page }) => {
  const writes = await mockPortal(page, true)
  await page.goto('/preview/tracking')
  await expect(page.getByRole('button', { name: /Sample Team Member/ })).toHaveAttribute('aria-pressed', 'true')
  await expect(page.locator('.mp-kpi-label', { hasText: 'Stock updates' })).toBeVisible()
  await page.getByRole('button', { name: 'Help / tutorial' }).click()
  const help = page.getByRole('dialog', { name: 'Help / tutorial', exact: true })
  await help.getByRole('searchbox').fill('tracking')
  await help.getByRole('button', { name: 'Tour Team Tracking', exact: true }).click()
  const titles = await completeFeature(page, ['Team Tracking · Statistics', 'Your team', 'Find a team member', 'Current role', 'Manage accounts', 'Selected team member', 'Tracking views', 'Stock updates', 'Compliance submissions', 'Products and inventory', 'Team Tracking · Activity history', 'Team Tracking · Role responsibilities'])
  expect(new Set(titles).size).toBe(titles.length)
  expect(writes).toEqual([])
})

test('vehicle-window guidance preserves the draft without saving or closing the editor', async ({ page }) => {
  const writes = await mockPortal(page)
  await page.goto('/vehicles')
  await page.getByRole('button', { name: 'Add vehicle', exact: true }).click()
  const editor = page.getByRole('dialog', { name: 'Add vehicle', exact: true })
  await editor.getByLabel('Vehicle Category', { exact: true }).selectOption('TRUCK')
  await editor.getByLabel('Vehicle Type', { exact: true }).selectOption('BOX_TRUCK')
  await editor.getByLabel('Vehicle Name', { exact: true }).fill('Unsaved delivery van')
  await editor.getByRole('button', { name: 'Guide add vehicle', exact: true }).click()
  const tour = page.locator('dialog.mp-walkthrough')
  await expect(tour.getByRole('heading', { name: 'Add vehicle', exact: true })).toBeVisible()
  await tour.getByRole('button', { name: 'Next', exact: true }).click()
  await page.keyboard.press('Escape')
  await expect(tour).toHaveCount(0)
  await expect(editor).toBeVisible()
  await expect(editor.getByLabel('Vehicle Name', { exact: true })).toHaveValue('Unsaved delivery van')
  expect(writes).toEqual([])
})

test('a guide can open another available page and replay a continuous feature tour', async ({ page }) => {
  const writes = await mockPortal(page)
  await page.goto('/dashboard')
  await page.getByRole('button', { name: 'Help / tutorial' }).click()
  const help = page.getByRole('dialog', { name: 'Help / tutorial', exact: true })
  await help.getByRole('searchbox', { name: 'Find a page or feature' }).fill('vehicles')
  await help.getByRole('button', { name: 'Tour Vehicles', exact: true }).click()
  await expect(page).toHaveURL(/\/vehicles$/)
  const tour = page.locator('dialog.mp-walkthrough')
  await expect(tour.getByRole('heading', { name: 'Vehicles', exact: true })).toBeVisible()
  await tour.getByRole('button', { name: 'Next', exact: true }).click()
  await expect(tour.getByRole('heading', { name: 'Fleet overview', exact: true })).toBeVisible()
  await tour.getByRole('button', { name: 'Close tutorial' }).click()
  await page.goto('/dashboard')
  await page.getByRole('button', { name: 'Help / tutorial' }).click()
  await help.getByRole('searchbox', { name: 'Find a page or feature' }).fill('dashboard')
  await expect(help.getByRole('button', { name: 'Disputes & Quality', exact: true })).toHaveCount(0)
  await help.getByRole('button', { name: 'Tour Dashboard', exact: true }).click()
  await expect(tour.getByRole('heading', { name: 'Dashboard · Overview', exact: true })).toBeVisible()
  await tour.getByRole('button', { name: 'Close tutorial' }).click()
  expect(writes).toEqual([])
})
