import { expect, test } from '@playwright/test'
import { readFileSync } from 'node:fs'

const terms = readFileSync(new URL('../../../services/api/resources/agreements/TERMS_OF_SERVICE/2.md', import.meta.url), 'utf8')
const privacy = readFileSync(new URL('../../../services/api/resources/agreements/PRIVACY_NOTICE/2.md', import.meta.url), 'utf8').replace('{{PRIVACY_CONTACT}}', 'Test privacy contact')

test('sign-up links show separate documents and preserve the registration form', async ({ page, context }) => {
  await context.route('**/api/v1/agreements/current', route => route.fulfill({ json: {
    data: [
      { id: 'terms', code: 'TERMS_OF_SERVICE', title: 'Test Terms of Service', audience: 'ALL', version: 2, content_uri: '/legal/terms-of-service', effective_at: '2026-09-14T00:00:00Z', content: terms },
      { id: 'privacy', code: 'PRIVACY_NOTICE', title: 'Test Privacy Notice', audience: 'ALL', version: 2, content_uri: '/legal/privacy-notice', effective_at: '2026-09-14T00:00:00Z', content: privacy },
    ], meta: {}, errors: [],
  } }))
  await page.goto('/register')
  await page.getByLabel('Owner full name').fill('Test Owner')
  await page.getByLabel('Business or store name').fill('Test Supply')
  for (const [title, content] of [
    ['Terms of Service', 'Marketplace roles'],
    ['Privacy Notice', 'Retention and requests'],
  ]) {
    const popupPromise = page.waitForEvent('popup')
    await page.getByRole('link', { name: `${title} (opens in a new tab)` }).click()
    const popup = await popupPromise
    await expect(popup.getByRole('heading', { level: 1, name: title, exact: true })).toBeVisible()
    await expect(popup.getByRole('heading', { name: content, exact: true })).toBeVisible()
    await expect(popup.getByText(/Version 2 · Effective/)).toBeVisible()
    expect(await popup.evaluate(() => document.documentElement.scrollWidth <= window.innerWidth)).toBe(true)
    if (page.viewportSize()?.width === 390 || page.viewportSize()?.width === 1440) await popup.screenshot({ path: `test-results/legal-${title.replaceAll(' ', '-').toLowerCase()}-${page.viewportSize()?.width}.png`, fullPage: true })
    await popup.close()
    await expect(page).toHaveURL(/\/register$/)
    await expect(page.getByLabel('Owner full name')).toHaveValue('Test Owner')
    await expect(page.getByLabel('Business or store name')).toHaveValue('Test Supply')
    await expect(page.getByRole('checkbox', { name: /I accept the versioned/ })).not.toBeChecked()
    await expect(page.getByRole('checkbox', { name: /I acknowledge the separate/ })).not.toBeChecked()
  }
})
