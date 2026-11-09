import { expect, test } from '@playwright/test'

test('registration scrolls only the form on desktop and uses page scrolling on mobile', async ({ page }, testInfo) => {
  // Keep this layout test independent of a late-loading live provider iframe.
  await page.addInitScript(() => {
    window.grecaptcha = { enterprise: {
      ready: callback => callback(),
      render: container => {
        container.dataset.layoutCheckbox = 'true'
        container.style.cssText = 'width: 304px; max-width: 100%; height: 78px; border: 1px solid #d3d3d3; background: #fafafa'
        container.textContent = 'Synthetic security checkbox'
        return 1
      },
      reset: () => {},
    } }
  })
  await page.goto('/register')
  const panel = page.getByRole('region', { name: 'Register your store', exact: true })
  const story = page.getByRole('region', { name: 'Vendor portal benefits' })
  const width = page.viewportSize()?.width ?? 0
  const signIn = page.getByRole('link', { name: 'Sign in', exact: true })
  await expect(page.getByRole('heading', { name: 'Register your store' })).toBeVisible()
  await expect.poll(() => page.locator('#vendor-registration-captcha').evaluate(element => Boolean(
    element.querySelector('[data-layout-checkbox]') || element.textContent?.includes('not configured'),
  ))).toBe(true)
  await page.evaluate(() => document.fonts.ready)
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)

  if (width > 900) {
    const before = await story.boundingBox()
    const brandBefore = await story.getByRole('link').boundingBox()
    await expect(panel).toHaveCSS('overflow-y', 'auto')
    expect(await page.evaluate(() => document.documentElement.scrollHeight <= innerHeight)).toBe(true)
    const maxScroll = await panel.evaluate(element => element.scrollHeight - element.clientHeight)
    expect(maxScroll).toBeGreaterThan(0)
    await panel.hover()
    await page.mouse.wheel(0, 600)
    await expect.poll(() => panel.evaluate(element => element.scrollTop)).toBeGreaterThan(0)
    expect(await story.boundingBox()).toEqual(before)
    expect(await story.getByRole('link').boundingBox()).toEqual(brandBefore)
    expect(await page.evaluate(() => scrollY)).toBe(0)
    await signIn.focus()
    await expect(signIn).toBeInViewport()
    await panel.evaluate(element => { element.scrollTop = 0 })
  } else {
    await expect(story).toBeHidden()
    await expect(panel).toHaveCSS('overflow-y', 'visible')
    await signIn.focus()
    await expect(signIn).toBeInViewport()
    expect(await page.evaluate(() => scrollY)).toBeGreaterThan(0)
    await page.evaluate(() => scrollTo(0, 0))
  }

  if (width === 1440 || width === 390) await page.screenshot({ path: testInfo.outputPath(`signup-${width}.png`), fullPage: true })
})
