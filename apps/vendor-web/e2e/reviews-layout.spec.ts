import { expect, test } from '@playwright/test'

test('review overview and cards reflow while details, reports, dates and tabs retain their context', async ({ page }) => {
  const received = (type: string, origin: string) => Array.from({ length: 6 }, (_, index) => ({
    id: `0199aa10-0000-7000-8000-00000000000${index}`, type, display_name: ['Alex Reyes', 'Morgan Brown', 'Sam Torres', 'Casey Moore', 'Jamie Lopez', 'Robin Cruz'][index],
    buyer_avatar_url: type !== 'BUYER' && index !== 1 ? `${origin}/api/v1/vendor/reviews/0199aa10-0000-7000-8000-00000000000${index}/buyer-photo?expires=9999999999&signature=sample` : null,
    ratings: type === 'PRODUCT' ? { product_quality: index % 2 ? 4 : 5 } : type === 'BUYER' ? { inquiry_seriousness: 4, communication_quality: 5, payment_reliability: 4 } : { service_quality: index % 2 ? 4 : 5, speed_rating: 4, speed_kind: index % 2 ? 'PROCESSING_SPEED' : 'DELIVERY_SPEED' },
    product: type === 'PRODUCT' ? { listing_id: `sample-product-${index}`, name: 'Portland cement for general construction', variant_label: '40 kg bag', image_url: `${origin}/api/v1/catalog-files/sample-product-${index}/content?expires=9999999999&signature=sample` } : null,
    submitted_at: `2026-11-0${5 - index % 4}T06:00:00Z`, verified_purchase: true, edited: index === 1,
    comment: ['Materials arrived as described. Helpful updates from the store and everything was packed carefully.', 'Quick pickup and clear communication throughout the order.', null, 'Good quality materials for our project. We would order again.', 'The store helped confirm the right quantities before dispatch.', 'Delivered on the agreed date.'][index],
    media: index === 0 && type === 'PRODUCT' ? [{ id: 'sample-photo', content_type: 'image/png' }] : [],
    order_id: `sample-order-${index}`, order_reference: `ORD-2026-SAMPLE${index + 1}`, can_report: type !== 'BUYER',
  }))
  const requests: string[] = []
  let detailType = 'VENDOR'
  await page.route('**/api/v1/**', async route => {
    const url = new URL(route.request().url())
    if (url.pathname.endsWith('/buyer-photo') || url.pathname.includes('/catalog-files/')) {
      await route.fulfill({ contentType: 'image/png', body: Buffer.from('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aHd8AAAAASUVORK5CYII=', 'base64') })
      return
    }
    let data: unknown = {}, meta: unknown = {}
    if (url.pathname.endsWith('/auth/csrf')) data = { csrf_token: 'sample-csrf' }
    if (url.pathname.endsWith('/profile')) data = { id: 'sample-user', full_name: 'Sample Vendor', account_type: 'VENDOR', account_status: 'ACTIVE', role: 'OWNER' }
    if (url.pathname.endsWith('/vendor/onboarding')) data = {
      step_completion: [], requirements: [], drafts: [], sections: {}, lock_version: 1,
      organization: { store_name: 'Sample Supply', lock_version: 1 }, permissions: ['portal.reviews', 'reviews.view', 'reviews.report', 'catalog.manage'],
      welcome_required: false, verification: { status: 'APPROVED' }, setup: { status: 'COMPLETED' },
      activation: { status: 'ACTIVE', marketplace_discoverability_status: 'DISCOVERABLE', readiness: { ready: true, blockers: [] } },
    }
    if (url.pathname.endsWith('/vendor/reviews')) {
      const type = url.searchParams.get('type') ?? 'VENDOR'
      detailType = type
      requests.push(url.search)
      data = received(type, url.origin)
      meta = { page: Number(url.searchParams.get('page') ?? 1), per_page: 20, total: 26, type, ...(type === 'PRODUCT' ? { summary: { count: 26, average: 4.5, distribution: [5, 4, 3, 2, 1].map(stars => ({ stars, count: stars >= 4 ? 13 : 0 })) } } : {}) }
    }
    if (/\/vendor\/reviews\/[0-9a-f-]{36}$/.test(url.pathname)) data = received(detailType, url.origin)[0]
    if (url.pathname.endsWith('/flags')) data = { reported: true }
    await route.fulfill({ json: { data, meta, errors: [] } })
  })
  await page.goto('/reviews')
  await expect(page.getByRole('heading', { name: 'Review statistics' })).toBeVisible()
  await expect(page.getByRole('figure', { name: /Service Quality: 4.5 out of 5/ })).toBeVisible()
  await expect(page.getByRole('list', { name: 'Reviews', exact: true }).getByRole('article')).toHaveCount(6)
  await expect(page.locator('.mp-review-grid .mp-review-avatar img')).toHaveCount(5)
  expect(await page.locator('.mp-review-grid .mp-review-avatar img').first().evaluate((element: HTMLImageElement) => element.complete && element.naturalWidth > 0)).toBe(true)
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  const layout = await page.locator('.mp-review-overview').evaluate(element => ({ columns: getComputedStyle(element).gridTemplateColumns.split(' ').length, overflow: element.scrollWidth > element.clientWidth }))
  expect(layout.overflow).toBe(false)
  expect(layout.columns).toBe(page.viewportSize()!.width >= 1280 ? 3 : page.viewportSize()!.width >= 768 ? 2 : 1)
  for (const card of await page.locator('.mp-review-card').all()) expect(await card.evaluate(element => element.scrollWidth <= element.clientWidth)).toBe(true)
  await page.screenshot({ path: `test-results/reviews-overview-${page.viewportSize()!.width}.png`, fullPage: true })

  await page.getByRole('button', { name: 'Last 30 days', exact: true }).click()
  const dates = page.getByRole('dialog', { name: 'Review submission dates' })
  await expect(dates).toBeVisible()
  await dates.getByRole('button', { name: 'Last 30 days', exact: true }).click()
  await dates.getByRole('button', { name: 'Apply', exact: true }).click()
  await expect(page).toHaveURL(/from=/)
  await expect(page.getByRole('heading', { name: 'Review statistics' })).toBeVisible()
  await page.getByRole('button', { name: /Next/ }).click()
  await expect(page).toHaveURL(/page=2/)
  const returnContext = new URL(page.url()).search
  const opener = page.getByRole('button', { name: 'View Store rating details by Alex Reyes' })
  await opener.focus()
  await page.keyboard.press('Enter')
  await expect(page.getByRole('heading', { name: 'Review details' })).toBeVisible()
  await expect(page.getByRole('main').getByRole('link', { name: 'Ratings & Reviews', exact: true })).toHaveAttribute('href', `/reviews${returnContext}`)
  await page.getByRole('main').getByRole('link', { name: 'Ratings & Reviews', exact: true }).click()
  await page.getByRole('tab', { name: 'Product reviews', exact: true }).click()
  await expect(page).toHaveURL(/tab=PRODUCT/)
  await expect(page).not.toHaveURL(/page=/)
  await expect(page.getByRole('figure', { name: /Product Quality: 4.5 out of 5. All matching product reviews/ })).toBeVisible()
  await page.screenshot({ path: `test-results/reviews-products-${page.viewportSize()!.width}.png`, fullPage: true })
  await page.getByRole('list', { name: 'Reviews', exact: true }).getByRole('button', { name: 'Report', exact: true }).first().click()
  const report = page.getByRole('dialog', { name: 'Report review', exact: true })
  await expect(report).toBeVisible()
  expect(await report.evaluate(element => element.scrollWidth <= element.clientWidth)).toBe(true)
  await report.getByRole('button', { name: 'Send report', exact: true }).click()
  await expect(page.getByText('Report sent. Our moderation team will review it.')).toBeVisible()
  await expect(page.getByRole('tab', { name: 'Your Buyer ratings' })).toHaveCount(0)
  expect(requests.some(query => query.includes('type=BUYER'))).toBe(false)
  await page.getByRole('list', { name: 'Reviews', exact: true }).getByRole('button', { name: 'View Portland cement for general construction details by Alex Reyes' }).click()
  const photo = page.getByRole('img', { name: 'Portland cement for general construction', exact: true })
  await expect(photo).toBeVisible()
  await expect.poll(() => photo.evaluate((element: HTMLImageElement) => element.complete && element.naturalWidth > 0)).toBe(true)
  await expect(page.getByRole('link', { name: 'View product analytics' })).toHaveAttribute('href', '/analytics/products/sample-product-0')
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  await page.screenshot({ path: `test-results/review-product-details-${page.viewportSize()!.width}.png`, fullPage: true })
})
