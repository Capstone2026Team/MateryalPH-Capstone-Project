import { expect, test, type Page } from '@playwright/test'
import { mkdirSync } from 'node:fs'
import { resolve } from 'node:path'

// Business dates stay in Manila even when the browser's local calendar is west of UTC.
test.use({ timezoneId: 'America/Los_Angeles' })

async function prepare(page: Page, portal: 'vendor' | 'admin') {
  await page.clock.setFixedTime(new Date('2026-10-09T02:00:00Z'))
  const queries: URL[] = []
  await page.route('**/api/v1/**', async route => {
    const url = new URL(route.request().url())
    queries.push(url)
    let data: unknown = []
    let meta: unknown = { page: 1, per_page: 20, total: 0, last_page: 1, has_more: false }
    if (url.pathname.endsWith('/profile')) data = { id: 'synthetic-design-review', full_name: 'DEMO Design Reviewer', account_type: portal.toUpperCase(), account_status: 'ACTIVE', role: portal === 'admin' ? 'ADMIN_SUPERADMIN' : 'OWNER' }
    else if (url.pathname.endsWith('/onboarding')) data = { step_completion: [], requirements: [], drafts: [], sections: {}, lock_version: 1, organization: { store_name: 'DEMO Sample Supply', lock_version: 1 }, permissions: ['portal.orders', 'portal.notifications'], welcome_required: false, verification: { status: 'APPROVED' }, setup: { status: 'COMPLETED' }, activation: { status: 'ACTIVE', marketplace_discoverability_status: 'DISCOVERABLE', readiness: { ready: true, blockers: [] } } }
    else if (url.pathname.endsWith('/vendor/orders')) meta = { ...meta as object, group: url.searchParams.get('group') ?? 'NEW', counts: { ALL: 0, NEW: 0, WAITING_ON_BUYER: 0, AWAITING_PAYMENT: 0, CONFIRMED: 0, CLOSED: 0 }, current_as_of: '2026-10-09T02:00:00Z' }
    await route.fulfill({ json: { data, meta, errors: [] } })
  })
  return queries
}

async function capture(page: Page, name: string) {
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  const dialog = page.getByRole('dialog')
  const modalVisible = await dialog.isVisible()
  if (modalVisible) {
    expect(await dialog.evaluate(element => element.scrollWidth <= element.clientWidth)).toBe(true)
    expect(await dialog.locator('[data-date]').evaluateAll(elements => elements.every(element => { const box = element.getBoundingClientRect(); return box.width >= 44 && box.height >= 44 }))).toBe(true)
  }
  const directory = resolve('../../docs/design/evidence/portal-standardization')
  mkdirSync(directory, { recursive: true })
  await page.screenshot({ path: resolve(directory, `${name}-${page.viewportSize()!.width}.png`), fullPage: !modalVisible })
}

for (const portal of ['vendor', 'admin'] as const) {
  test(`${portal} notification bulk read retains the selected inclusive calendar boundaries`, async ({ page }) => {
    await prepare(page, portal)
    const currentId = '019a0000-0000-7000-8000-000000000002'
    const oldId = '019a0000-0000-7000-8000-000000000001'
    let read = false
    let submitted: Record<string, unknown> | null = null
    await page.route('**/api/v1/*/notifications**', async route => {
      const path = new URL(route.request().url()).pathname
      if (path.endsWith('/read-all')) {
        submitted = route.request().postDataJSON() as Record<string, unknown>
        read = true
        await route.fulfill({ json: { data: { read_at: '2026-10-09T02:00:00Z', matched: 1 }, meta: {}, errors: [] } })
      } else {
        await route.fulfill({ json: { data: [
          { id: currentId, category: 'SECURITY', title: 'DEMO Current notice', body: 'Synthetic account event.', mandatory: true, created_at: '2026-10-08T23:00:00Z', read_at: read ? '2026-10-09T02:00:00Z' : null },
          { id: oldId, category: 'SECURITY', title: 'DEMO Older notice', body: 'Synthetic earlier event.', mandatory: true, created_at: '2026-10-07T23:00:00Z', read_at: null },
        ], meta: { next_cursor: null }, errors: [] } })
      }
    })
    await page.goto(`http://127.0.0.1:${portal === 'vendor' ? 4173 : 4174}/notifications`)
    await expect(page.getByRole('heading', { name: 'DEMO Current notice' })).toBeVisible()
    await page.getByRole('button', { name: 'All dates', exact: true }).click()
    const dialog = page.getByRole('dialog', { name: 'Notification dates' })
    await dialog.getByRole('button', { name: 'Today', exact: true }).click()
    await dialog.getByRole('button', { name: 'Apply', exact: true }).click()
    await expect(page.getByRole('heading', { name: 'DEMO Older notice' })).toHaveCount(0)
    await page.getByRole('button', { name: 'Mark all as read', exact: true }).click()
    await expect.poll(() => submitted).toMatchObject({ through_id: currentId, from: '2026-10-09', to: '2026-10-09' })
    await expect(page.getByRole('heading', { name: 'DEMO Current notice' })).toHaveCount(0)
    // Read notices leave the inbox; the former Unread/Read/Archived status filter was removed (2026-10-17).
    await capture(page, `${portal}-notification-dates`)
  })

  test(`${portal} dates preserve other filters, wait for Apply and restore keyboard focus`, async ({ page }) => {
    const queries = await prepare(page, portal)
    const path = portal === 'vendor' ? '/orders?group=CLOSED&closed_state=COMPLETED&q=cement&page=3' : 'http://127.0.0.1:4174/vendor-verification'
    await page.goto(path)
    const trigger = page.getByRole('button', { name: 'All dates', exact: true }).first()
    await expect(trigger).toBeVisible()
    await trigger.click()
    const dialog = page.getByRole('dialog', { name: portal === 'vendor' ? 'Order submission dates' : 'Submission dates' })
    await expect(dialog).toBeVisible()
    await dialog.getByRole('button', { name: 'Last 7 days', exact: true }).click()
    expect(queries.filter(url => url.searchParams.has(portal === 'vendor' ? 'from' : 'submitted_from'))).toHaveLength(0)
    await capture(page, `${portal}-date-picker`)
    await dialog.getByRole('button', { name: 'Apply', exact: true }).click()
    await expect(dialog).not.toBeVisible()
    const dateKey = portal === 'vendor' ? 'from' : 'submitted_from'
    await expect.poll(() => queries.some(url => url.searchParams.get(dateKey)?.startsWith('2026-10-03'))).toBe(true)
    await expect(page.getByRole('button', { name: 'Last 7 days', exact: true }).first()).toBeFocused()
    if (portal === 'vendor') {
      await expect(page).toHaveURL(/group=CLOSED/)
      await expect(page).toHaveURL(/closed_state=COMPLETED/)
      await expect(page).toHaveURL(/q=cement/)
      expect(new URL(page.url()).searchParams.get('page')).toBeNull()
    }
    await page.getByRole('button', { name: 'Last 7 days', exact: true }).first().click()
    await dialog.getByRole('button', { name: 'Today', exact: true }).click()
    await page.keyboard.press('Escape')
    await expect(dialog).not.toBeVisible()
    await expect(page.getByRole('button', { name: 'Last 7 days', exact: true }).first()).toBeFocused()
    await capture(page, `${portal}-filtered-page`)
    await page.emulateMedia({ reducedMotion: 'reduce' })
    await page.getByRole('button', { name: 'Last 7 days', exact: true }).first().click()
    await dialog.getByLabel('From', { exact: true }).fill('2026-10-07')
    await dialog.getByLabel('To', { exact: true }).fill('2026-10-09')
    await dialog.getByRole('button', { name: 'Apply', exact: true }).click()
    await expect.poll(() => queries.some(url => url.searchParams.get(dateKey)?.startsWith('2026-10-07'))).toBe(true)
    await page.getByRole('button', { name: 'Oct 7, 2026 – Oct 9, 2026', exact: true }).click()
    await dialog.getByLabel('To', { exact: true }).fill('')
    await dialog.getByRole('button', { name: 'Apply', exact: true }).click()
    const endKey = portal === 'vendor' ? 'to' : 'submitted_to'
    await expect.poll(() => queries.some(url => url.searchParams.get(dateKey) === '2026-10-07' && !url.searchParams.has(endKey))).toBe(true)
    await page.getByRole('button', { name: 'From Oct 7, 2026', exact: true }).click()
    await dialog.getByRole('button', { name: 'All dates', exact: true }).click()
    const beforeReset = queries.length
    await dialog.getByRole('button', { name: 'Apply', exact: true }).click()
    await expect(page.getByRole('button', { name: 'All dates', exact: true }).first()).toBeFocused()
    await expect.poll(() => queries.slice(beforeReset).some(url => url.pathname.includes('verification') || url.pathname.endsWith('/vendor/orders') ? !url.searchParams.has(dateKey) && !url.searchParams.has(endKey) : false)).toBe(true)
    if (portal === 'vendor') {
      await expect(page).toHaveURL(/group=CLOSED/)
      await expect(page).toHaveURL(/closed_state=COMPLETED/)
      await expect(page).toHaveURL(/q=cement/)
    }
    await page.getByRole('button', { name: 'All dates', exact: true }).first().click()
    await dialog.getByLabel('From', { exact: true }).fill('2025-02-03')
    await dialog.getByLabel('To', { exact: true }).fill('2025-02-09')
    await dialog.getByRole('button', { name: 'Apply', exact: true }).click()
    const historicalTrigger = page.getByRole('button', { name: 'Feb 3, 2025 – Feb 9, 2025', exact: true })
    await historicalTrigger.click()
    await expect(dialog.getByRole('region', { name: 'February 2025' })).toBeVisible()
    await dialog.getByRole('button', { name: 'Today', exact: true }).click()
    await expect(dialog.getByRole('region', { name: 'October 2026' })).toBeVisible()
    await expect(dialog.getByRole('button', { name: '2026-10-09', exact: true })).toHaveAttribute('aria-pressed', 'true')
    await dialog.getByRole('button', { name: 'Cancel', exact: true }).click()
    await expect(historicalTrigger).toBeFocused()
  })
}
