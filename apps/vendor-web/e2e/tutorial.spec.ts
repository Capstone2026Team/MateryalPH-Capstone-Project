import { expect, test } from '@playwright/test'
import { vendorInsights } from './fixtures/dashboard-insights'

test('first-visit tour stays in bounds, persists completion, and replays with keyboard support', async ({ page }, testInfo) => {
  const progress = new Map<string, string>()
  let writes = 0
  await page.route('**/api/v1/**', async route => {
    const path = new URL(route.request().url()).pathname
    let data: unknown = {}
    if (path.includes('/account/tutorials')) {
      if (route.request().method() === 'PUT') {
        progress.set(path.split('/').at(-1)!, route.request().postDataJSON().status)
        writes++
      }
      data = [...progress].map(([tutorial_key, status]) => ({ tutorial_key, status, updated_at: '2026-11-10T00:00:00Z' }))
    } else if (path.endsWith('/profile')) data = { id: 'tutorial-review', full_name: 'Tutorial Reviewer', account_type: 'VENDOR', account_status: 'ACTIVE', role: 'OWNER' }
    else if (path.endsWith('/onboarding')) data = {
      step_completion: [], requirements: [], drafts: [], sections: {}, lock_version: 1,
      organization: { store_name: 'Sample Supply', lock_version: 1 },
      permissions: ['vendor.onboarding.manage', 'vendor.onboarding.submit', 'portal.products', 'catalog.manage', 'portal.orders', 'portal.messages'], welcome_required: false,
      verification: { status: 'APPROVED' }, setup: { status: 'COMPLETED' },
      activation: { status: 'ACTIVE', readiness: { ready: true, blockers: [] } },
    }
    else if (path.endsWith('/vendor/dashboard/insights')) data = vendorInsights()
    else if (path.endsWith('/auth/csrf')) data = { csrf_token: 'tutorial-fixture' }
    else if (path.endsWith('/enforcement/notices')) data = []
    await route.fulfill({ json: { data, meta: {}, errors: [] } })
  })
  await page.goto('/dashboard')
  const tour = page.locator('dialog.mp-walkthrough')
  await expect(tour).toBeVisible()
  await expect(tour.getByRole('heading', { name: 'Your store, at a glance' })).toBeVisible()
  await expect(tour.getByRole('button', { name: 'Back', exact: true })).toBeDisabled()
  for (let index = 0; index < 7; index++) {
    const card = page.locator('.mp-walkthrough-card')
    const bounds = await card.boundingBox()
    expect(bounds!.x).toBeGreaterThanOrEqual(0)
    expect(bounds!.y).toBeGreaterThanOrEqual(0)
    expect(bounds!.x + bounds!.width).toBeLessThanOrEqual(page.viewportSize()!.width)
    expect(bounds!.y + bounds!.height).toBeLessThanOrEqual(page.viewportSize()!.height)
    if (index === 0) await page.screenshot({ path: testInfo.outputPath('vendor-tutorial.png') })
    const next = tour.getByRole('button', { name: 'Next', exact: true })
    if (await next.count()) await next.click()
    else break
  }
  await tour.getByRole('button', { name: 'Finish', exact: true }).click()
  await expect.poll(() => progress.get('overview')).toBe('COMPLETED')
  await expect(tour.getByRole('heading', { name: 'Dashboard · Overview', exact: true })).toBeVisible()
  await tour.getByRole('button', { name: 'Skip', exact: true }).click()
  await expect.poll(() => progress.get('dashboard')).toBe('SKIPPED')
  await expect(tour).toHaveCount(0)
  await page.reload()
  await expect(page.getByRole('button', { name: 'Help / tutorial' })).toBeVisible()
  await expect(tour).toHaveCount(0)
  await page.getByRole('button', { name: 'Help / tutorial' }).click()
  await page.getByRole('button', { name: 'Take the complete tour' }).click()
  await expect(tour).toBeVisible()
  if (page.viewportSize()!.width >= 1024) {
    await page.setViewportSize({ width: 390, height: 844 })
    await expect(page.locator('.mp-walkthrough-card')).toBeVisible()
  }
  await page.keyboard.press('Tab')
  expect(await tour.evaluate(dialog => dialog.contains(document.activeElement))).toBe(true)
  await page.keyboard.press('Escape')
  await expect(tour).toHaveCount(0)
  expect(writes).toBeGreaterThanOrEqual(1)
  await page.emulateMedia({ reducedMotion: 'reduce' })
  await page.getByRole('button', { name: 'Help / tutorial' }).click()
  await page.getByText('Product listings', { exact: true }).click()
  await page.getByRole('button', { name: 'Tour Product listings', exact: true }).click()
  await expect(tour).toBeVisible()
  expect(await page.locator('.mp-walkthrough-copy').evaluate(element => getComputedStyle(element).animationName)).toBe('none')
  await tour.getByRole('button', { name: 'Close tutorial' }).click()
})
