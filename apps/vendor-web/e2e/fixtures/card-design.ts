import { expect, type Page } from '@playwright/test'

/** Guard the shared design across real portal pages, including metrics outside dashboards. */
export async function expectPortalCardDesign(page: Page) {
  const cards = await page.locator('main :is(.mp-card, .mp-metric-card)').evaluateAll(elements => elements
    .filter(element => element.getBoundingClientRect().width > 0 && element.getBoundingClientRect().height > 0)
    .map(element => {
      const style = getComputedStyle(element)
      const label = element.querySelector(':scope > .mp-kpi-label')
      const value = element.querySelector(':scope > .mp-kpi-value')
      return {
        name: element.getAttribute('aria-label') ?? label?.textContent ?? element.tagName,
        metric: element.classList.contains('mp-metric-card'),
        compactSummary: Boolean(element.closest('.mp-analytics-summary[data-density="compact"]')),
        providerSummary: Boolean(element.closest('.mp-finance-provider-summary')),
        padded: element.classList.contains('mp-card-padded'),
        radius: style.borderRadius,
        border: style.borderTopWidth,
        padding: style.paddingTop,
        labelSize: label ? getComputedStyle(label).fontSize : null,
        valueSize: value ? getComputedStyle(value).fontSize : null,
      }
    }))
  expect(cards.length, 'The page renders shared portal cards').toBeGreaterThan(0)
  const width = page.viewportSize()!.width
  const groups = await page.locator('main .mp-card-group').evaluateAll(elements => elements
    .filter(element => element.getBoundingClientRect().width > 0 && element.getBoundingClientRect().height > 0)
    .map(element => {
      const style = getComputedStyle(element)
      const bounds = element.getBoundingClientRect()
      const cards = Array.from(element.querySelectorAll(':scope > :is(.mp-card, .mp-metric-card)'))
        .map(card => card.getBoundingClientRect()).filter(card => card.width > 0 && card.height > 0)
      return {
        name: element.getAttribute('aria-label') ?? element.textContent?.slice(0, 60),
        compactSummary: element.matches('.mp-analytics-summary[data-density="compact"]'),
        background: style.backgroundColor,
        border: style.borderTopWidth,
        radius: style.borderRadius,
        padding: style.paddingTop,
        cardsWithinSurface: cards.every(card => card.left >= bounds.left + 12 && card.right <= bounds.right - 12
          && card.top >= bounds.top + 12 && card.bottom <= bounds.bottom - 12),
      }
    }))
  for (const group of groups) {
    expect(group.background, `${group.name} shared background`).toBe('rgb(255, 255, 255)')
    expect(group.border, `${group.name} group border`).toBe('1px')
    expect(group.radius, `${group.name} group radius`).toBe('12px')
    expect(group.padding, `${group.name} group padding`).toBe(group.compactSummary || width < 640 ? '12px' : '16px')
    expect(group.cardsWithinSurface, `${group.name} cards fit inside the group`).toBe(true)
  }
  const ungroupedMetrics = await page.locator('main .mp-metric-card').evaluateAll(elements => elements
    .filter(element => element.getBoundingClientRect().width > 0 && !element.parentElement?.closest('.mp-card-group, .mp-finance-provider-summary'))
    .map(element => element.textContent?.slice(0, 60)))
  expect(ungroupedMetrics, 'Every metric row has a shared background').toEqual([])
  for (const card of cards) {
    expect(card.radius, `${card.name} radius`).toBe(card.providerSummary ? '0px' : '12px')
    expect(card.border, `${card.name} border`).toBe('1px')
    if (card.metric) {
      expect(card.padding, `${card.name} metric padding`).toBe(card.compactSummary || width < 640 ? '12px' : '16px')
      expect(card.labelSize, `${card.name} metric label`).toBe('12px')
      expect(Number.parseFloat(card.valueSize!), `${card.name} metric value`).toBeCloseTo(card.providerSummary ? 28 : card.compactSummary ? 22 : Math.max(24, Math.min(28, width * 0.02)), 1)
    } else if (card.padded) {
      expect(card.padding, `${card.name} content padding`).toBe(width < 640 ? '16px' : '20px')
    }
  }
}
