import { expect, test } from '@playwright/test'

for (const portal of ['vendor', 'admin']) {
  test(`${portal} login layout, validation and keyboard controls`, async ({ page }) => {
    await page.route('**/api/v1/**', route => route.request().url().endsWith('/auth/csrf') ? route.fulfill({ status: 200, contentType: 'application/json', body: JSON.stringify({ data: { csrf_token: 'synthetic-layout-csrf' } }) }) : route.fulfill({ status: 401, contentType: 'application/json', body: '{"data":null,"meta":{},"errors":[]}' }))
    await page.goto(`http://127.0.0.1:${portal === 'vendor' ? 4173 : 4174}/login`)
    const submit = page.getByRole('button', { name: portal === 'vendor' ? 'Sign in' : 'Sign in securely', exact: true })
    await expect(submit).toBeVisible()
    await expect(page.getByRole('heading', { name: 'Welcome back' })).toBeVisible()
    const email = page.getByRole('textbox', { name: 'Email address' })
    await expect(email).toHaveAttribute('required', '')
    await email.fill('layout@example.test')
    await page.locator('input[name="password"]').fill('layout-test-only')
    await email.focus()
    await page.keyboard.press('Tab')
    await expect(page.locator('input[name="password"]')).toBeFocused()
    await page.keyboard.press('Tab')
    await expect(page.getByRole('button', { name: 'Show password' })).toBeFocused()
    await page.keyboard.press('Space')
    await expect(page.locator('input[name="password"]')).toHaveAttribute('type', 'text')
    await page.getByRole('button', { name: 'Hide password' }).click()
    await expect(page.locator('input[name="password"]')).toHaveAttribute('type', 'password')
    await page.locator('input[name="password"]').fill('')
    await email.fill('')
    expect(await page.evaluate(() => document.documentElement.scrollWidth - innerWidth)).toBeLessThanOrEqual(1)
    expect((await submit.boundingBox())!.height).toBeGreaterThanOrEqual(44)
    if (portal === 'vendor') {
      await expect(page.getByRole('button', { name: 'Continue with Google' })).toBeVisible()
      await page.getByRole('button', { name: 'Use an email security check instead' }).click()
      await expect(page.getByRole('button', { name: 'Email security check selected' })).toHaveAttribute('aria-pressed', 'true')
    } else {
      await expect(page.getByRole('link', { name: /register/i })).toHaveCount(0)
    }
    await page.screenshot({ path: `test-results/login-${portal}-${test.info().project.name}.png`, fullPage: true })
  })
}

