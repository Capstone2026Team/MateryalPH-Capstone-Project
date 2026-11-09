import { expect, test, type Page } from '@playwright/test'
import { mkdirSync } from 'node:fs'
import { resolve } from 'node:path'

const rows = [
  { id: 'review-product', type: 'PRODUCT', moderation_state: 'FLAGGED', store_name: 'Northside Construction Materials and Hardware Supply', display_name: 'Juan Dela Cruz', order_reference: 'ORD-2026-REVIEW-001', ratings: { product_quality: 2 }, open_flags: 2, comment: 'The delivered material differed from the ordered specification. Supporting evidence has been submitted for review.' },
  { id: 'review-store', type: 'VENDOR', moderation_state: 'CORRECTION_REQUESTED', store_name: 'Metro Building Supply', display_name: 'Maria Santos', order_reference: 'ORD-2026-REVIEW-002', ratings: { service_quality: 3, speed_kind: 'DELIVERY_SPEED', speed_rating: 4 }, open_flags: 0, comment: 'The author has been asked to correct this feedback.' },
  { id: 'review-buyer', type: 'BUYER', moderation_state: 'REMOVED', store_name: 'Southside Hardware', display_name: 'Vendor team', order_reference: 'ORD-2026-REVIEW-003', ratings: { inquiry_seriousness: 4, communication_quality: 3, payment_reliability: 5 }, open_flags: 0, comment: 'Original feedback remains available for audit.' },
].map(row => ({ ...row, submitted_at: '2026-11-05T02:00:00Z', updated_at: '2026-11-06T03:30:00Z' }))

async function mock(page: Page) {
  await page.route('**/api/v1/**', async route => {
    const url = new URL(route.request().url())
    const path = url.pathname
    let data: unknown = {}
    let meta: Record<string, unknown> = {}
    if (path.endsWith('/profile')) data = { id: 'layout-admin', full_name: 'Platform Admin', account_type: 'ADMIN', account_status: 'ACTIVE', role: 'ADMIN_SUPERADMIN' }
    else if (path.endsWith('/auth/csrf')) data = { csrf_token: 'layout-review-csrf' }
    else if (path.endsWith('/notifications/unread-count')) data = { count: 0 }
    else if (path.endsWith('/admin/reviews')) {
      const state = url.searchParams.get('state')
      data = url.searchParams.get('from') === '2020-01-01' ? [] : state === 'ALL' ? rows : state === 'CORRECTION_REQUESTED' ? [rows[1]] : state === 'REMOVED' ? [rows[2]] : [rows[0]]
      meta = { page: 1, per_page: 20, total: (data as unknown[]).length }
    } else if (path.endsWith('/admin/reviews/review-product')) {
      data = { ...rows[0], visibility: 'HIDDEN_BY_MODERATION', author_display_rule: 'Full profile name', verified_purchase: { store_name: rows[0]!.store_name, order_reference: rows[0]!.order_reference },
        available_actions: ['DISMISS_FLAG', 'HIDE_PENDING_REVIEW', 'REQUEST_CORRECTION', 'REMOVE'], lock_version: 2, media: [], related_dispute: { reference: 'CASE-2026-001', status: 'UNDER_REVIEW' },
        flags: [{ id: 'report-1', reporter_party: 'VENDOR', reason_code: 'FALSE_CLAIM', details: 'Please compare the delivered material with the order specification.', state: 'OPEN', created_at: '2026-11-06T03:30:00Z' }],
        history: [{ action: 'FLAG_RAISED', actor_role: 'OWNER', reason: 'FALSE_CLAIM', at: '2026-11-06T03:30:00Z' }],
        revisions: [{ revision: 1, reason: 'SUBMITTED', created_at: '2026-11-05T02:00:00Z', content: { rating: 2, comment: rows[0]!.comment } }],
      }
    }
    await route.fulfill({ json: { data, meta, errors: [] } })
  })
}

async function capture(page: Page, name: string) {
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  for (const panel of await page.locator('.mp-moderation-workspace .mp-card').all()) {
    const box = await panel.boundingBox()
    expect(box).not.toBeNull()
    expect(box!.x).toBeGreaterThanOrEqual(0)
    expect(box!.x + box!.width).toBeLessThanOrEqual(page.viewportSize()!.width + 1)
    expect(await panel.evaluate(element => element.scrollWidth <= element.clientWidth + 1)).toBe(true)
  }
  const directory = resolve('../../.tmp/review-moderation/screenshots')
  mkdirSync(directory, { recursive: true })
  await page.screenshot({ path: resolve(directory, `${page.viewportSize()!.width}-${name}.png`), fullPage: true })
}

test('Review Moderation keeps every queue and detail section usable across viewport sizes', async ({ page }) => {
  await page.emulateMedia({ reducedMotion: 'reduce' })
  await mock(page)
  await page.goto('http://127.0.0.1:4174/reviews')
  await expect(page.getByRole('heading', { name: 'Review Moderation', level: 1 })).toBeVisible()
  await expect(page.getByRole('list', { name: 'Reviews in this queue' })).toBeVisible()
  await expect(page.getByRole('list', { name: 'Review types on this page' })).toHaveCount(0)
  await capture(page, 'needs-action')
  for (const [label, name] of [['Correction requested', 'corrections'], ['Removed', 'removed'], ['All reviews', 'all-reviews']]) {
    await page.getByRole('tab', { name: label, exact: true }).click()
    await expect(page.getByRole('tab', { name: label, selected: true })).toBeVisible()
    await expect(page.getByRole('button', { name: 'Refresh queue' })).toBeEnabled()
    await capture(page, name!)
  }
  await page.getByRole('link', { name: /View product review by Juan Dela Cruz/ }).click()
  await expect(page.getByRole('heading', { name: 'Record a decision' })).toBeVisible()
  const sections = page.getByRole('navigation', { name: 'Review sections' })
  await expect(sections.getByRole('link')).toHaveCount(5)
  for (const link of await sections.getByRole('link').all()) {
    const href = await link.getAttribute('href')
    await expect(page.locator(href!)).toHaveCount(1)
    expect((await link.boundingBox())!.height).toBeGreaterThanOrEqual(44)
  }
  await capture(page, 'detail')
  await page.getByRole('main').getByRole('link', { name: 'Review Moderation', exact: true }).click()
  await expect(page.getByRole('tab', { name: 'All reviews', selected: true })).toBeVisible()
  await page.goto('http://127.0.0.1:4174/reviews?state=REMOVED&from=2020-01-01&to=2020-01-02')
  await expect(page.getByRole('heading', { name: 'No reviews in this date range' })).toBeVisible()
  await expect(page.getByRole('region', { name: 'Queue snapshot' })).toHaveCount(0)
  await capture(page, 'empty')
})
