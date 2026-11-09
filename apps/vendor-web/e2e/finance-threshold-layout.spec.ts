import { expect, test, type Page } from '@playwright/test'
import { mkdirSync } from 'node:fs'
import { resolve } from 'node:path'

const threshold = {
  demo: true, taxable_year: 2026, year_start_at: '2025-12-31T16:00:00Z', year_end_at: '2026-12-31T16:00:00Z', threshold_centavos: 50000000,
  cumulative_gross_centavos: 101964, remaining_allowance_centavos: 49898036, local_gross_centavos: 101964, external_declared_centavos: 0,
  external_overlap_centavos: 0, external_overlap_state: 'NONE', percent_of_threshold: 0, advisory: false, status: 'SUBJECT_STANDARD', reason_code: 'NO_DECLARATION', crossed_at: null,
  prior_year_total_centavos: null, final_for_year_notice: 'Crossing the threshold is final for the taxable year. Withholding applies to the whole crossing remittance and later remittances. Refunds or later declarations do not restore relief.',
  calculation_breakdown: { assessed_payments: 4, payment_principal_centavos: 157025, buyer_processing_fees_centavos: 4152, collections_centavos: 161177, refunds_centavos: 0, delivery_centavos: 42825, material_vat_centavos: 12236, provider_charges_centavos: 4152,
    gross_basis_centavos: 101964, withheld_centavos: 508, assessed_cash_centavos: 156517,
    withholding_breakdown: { payments: ['AZ5YXGDX', 'WKRIWRHJ', 'QOJYQLNH', 'BCZHVR6Q'].map(reference => ({
      id: `sample-${reference}`, order_reference: `ORD-2026-${reference}`, gross_basis_centavos: 25491, rate_basis_points: 50, withheld_centavos: 127,
    })), remaining_payments: 0, remaining_basis_centavos: 0, remaining_withheld_centavos: 0 } }, events: [],
}

const paymentSources = {
  taxable_year: 2026,
  totals: { assessed_payments: 4, payment_principal_centavos: 157025, buyer_processing_fees_centavos: 4152, collections_centavos: 161177, withheld_centavos: 508 },
  other_store_totals: null,
  payments: [
    ['AZ5YXGDX', 28550, 755, 29305, '02'], ['WKRIWRHJ', 28550, 755, 29305, '07'],
    ['QOJYQLNH', 71375, 1887, 73262, '13'], ['BCZHVR6Q', 28550, 755, 29305, '20'],
  ].map(([reference, principal, fee, total, day]) => ({ id: `sample-${reference}`, order_reference: `ORD-2026-${reference}`,
    assessed_at: `2026-10-${day}T10:00:00Z`, payment_principal_centavos: principal, buyer_processing_fees_centavos: fee, collections_centavos: total,
    assessed_payment_centavos: principal, delivery_centavos: principal === 71375 ? 42825 : 0, material_vat_centavos: 3059,
    gross_basis_centavos: 25491, rate_basis_points: 50, withheld_centavos: 127 })),
}

async function mock(page: Page, current: () => Record<string, unknown>) {
  await page.route('**/api/v1/**', async route => {
    const path = new URL(route.request().url()).pathname
    let data: unknown = {}
    if (path.endsWith('/profile')) data = { id: 'sample-owner', full_name: 'Sample Owner', account_type: 'VENDOR', account_status: 'ACTIVE', role: 'OWNER' }
    else if (path.endsWith('/onboarding')) data = { step_completion: [], requirements: [], drafts: [], sections: {}, lock_version: 1, organization: { store_name: 'Sample Supply', lock_version: 1 }, welcome_required: false,
      permissions: ['portal.wallet', 'portal.earnings', 'finance.view'], verification: { status: 'APPROVED' }, setup: { status: 'COMPLETED' },
      activation: { status: 'ACTIVE', marketplace_discoverability_status: 'DISCOVERABLE', readiness: { ready: true, blockers: [] } } }
    else if (path.endsWith('/auth/csrf')) data = { csrf_token: 'sample-csrf-token' }
    else if (path.endsWith('/vendor/finance/threshold-payments')) data = paymentSources
    else if (path.endsWith('/vendor/finance/earnings')) data = {
      demo: true, environment: 'TEST', commercial_sales_centavos: 157025, online_collections_centavos: 99925, physical_collections_centavos: 0,
      included_vat_centavos: 12236, simulated_cwt_centavos: 254, estimated_remittance_cash_centavos: 99671,
      remittance_collections_centavos: 99925, remittance_refunds_centavos: 0, provider_charges_centavos: 0,
      buyer_processing_fees_centavos: 4152, online_refunds_centavos: 0, earned_commission_centavos: 0, estimated_commission_centavos: 0, unpaid_statements_centavos: 0,
      breakdown: { sales: { orders: 4, materials_before_discount_centavos: 114200, vendor_discounts_centavos: 0, materials_after_discount_centavos: 114200, delivery_centavos: 42825, refunds_centavos: 0 },
        online: { payments: 4, principal_paid_centavos: 99925, refunded_principal_centavos: 0 }, physical: { records: 0, cash_on_delivery_centavos: 0, in_store_centavos: 0 } },
      products: { total: 0, truncated: false, items: [] }, trend: { from: '2026-10-08', to: '2026-11-06', days: 30, granularity: 'DAY', timezone: 'Asia/Manila', points: [], previous: null },
    }
    else if (path.endsWith('/vendor/finance')) data = { demo_label: 'DEMO — No real funds or BIR filing', notices: [], threshold: current(),
      tax_profile: { available: true, tin_masked: '•••-•••-012 (masked)', vat_category: 'VAT', fiscal_year_start_month: 1, declaration: { status: current().status === 'RELIEF_ACTIVE' ? 'APPROVED' : 'NOT_SUBMITTED' } },
      withholding_arrangement: { rate_label: '0.5% of qualifying gross remittance (RR No. 5-2025); never an extra Buyer charge' } }
    else if (path.endsWith('/notifications/unread-count')) data = { count: 0 }
    await route.fulfill({ json: { data, meta: {}, errors: [] } })
  })
}

async function capture(page: Page, name: string) {
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  const workspace = page.getByRole('tabpanel', { name: 'Xendit cash revenue & remittance', exact: true })
  const viewport = page.viewportSize()!
  const height = await workspace.evaluate(element => element.scrollHeight)
  const taxWorkspace = page.locator('.mp-threshold-workspace')
  // Visible records grow with the page; keep the threshold summary and calculation compact independently.
  const taxContentWidth = await taxWorkspace.evaluate(element => element.clientWidth - parseFloat(getComputedStyle(element).paddingLeft) - parseFloat(getComputedStyle(element).paddingRight))
  const paymentHeight = await taxWorkspace.locator('.mp-threshold-payments').evaluateAll(elements => elements[0]?.getBoundingClientRect().height ?? 0)
  if (taxContentWidth >= 720) expect(await taxWorkspace.evaluate(element => element.scrollHeight) - paymentHeight, 'wide annual tax summary and calculation remain compact').toBeLessThan(750)
  await page.setViewportSize({ width: viewport.width, height: Math.max(viewport.height, height + 350) })
  const directory = resolve('../../.tmp/finance-threshold-review')
  mkdirSync(directory, { recursive: true })
  await workspace.screenshot({ path: resolve(directory, `${viewport.width}-${name}.png`) })
  await page.setViewportSize(viewport)
}

test('compact annual threshold separates the tax total from payout and keeps help accessible', async ({ page }) => {
  await mock(page, () => threshold)
  await page.goto('/finance?section=threshold')
  await expect(page.getByRole('heading', { name: 'Xendit cash revenue & remittance', exact: true })).toBeVisible()
  await expect(page.getByRole('heading', { name: 'Withholding tax', exact: true })).toBeVisible()
  await expect(page.getByLabel('Total withholding tax', { exact: true })).toBeVisible()
  await expect(page.getByLabel('Total withholding tax', { exact: true })).toContainText('₱5.08')
  await expect(page.locator('.mp-threshold-period')).toContainText('Annual · 2026')
  await expect(page.getByText('Full taxable year. Not affected by the date filter.', { exact: true })).toBeVisible()
  await expect(page.getByText('0.2% of annual threshold', { exact: true })).toHaveCount(0)
  await expect(page.getByText('₱500,000.00', { exact: true })).toHaveCount(0)
  await expect(page.getByText('Counted toward threshold', { exact: true })).toHaveCount(0)
  await expect(page.getByText('Remaining to threshold', { exact: true })).toHaveCount(0)
  await expect(page.getByText('Threshold not crossed.', { exact: true })).toHaveCount(0)
  await expect(page.getByRole('note', { name: 'Tax is withheld', exact: true })).toBeVisible()
  await expect(page.locator('.mp-threshold-meter')).toHaveCount(0)
  const withholdingNotice = page.getByRole('note', { name: 'Why tax is withheld' })
  await expect(withholdingNotice).toBeVisible()
  await expect(withholdingNotice).toContainText('Tax is withheld because no approved Sworn Declaration is on record.')
  await expect(page.locator('.mp-threshold-progress')).toContainText('Why tax is withheld')
  const noticeBounds = (await withholdingNotice.boundingBox())!
  const treatmentBounds = (await page.getByRole('region', { name: 'Current withholding status', exact: true }).boundingBox())!
  const withholdingBarBounds = (await page.getByRole('note', { name: 'Tax is withheld', exact: true }).boundingBox())!
  expect(noticeBounds.x, 'the explanation aligns with the left withholding bar').toBeCloseTo(withholdingBarBounds.x, 0)
  expect(noticeBounds.y, 'the explanation follows the withholding bar').toBeGreaterThanOrEqual(withholdingBarBounds.y + withholdingBarBounds.height)
  const statusContentWidth = await page.locator('.mp-threshold-workspace').evaluate(element => element.clientWidth - parseFloat(getComputedStyle(element).paddingLeft) - parseFloat(getComputedStyle(element).paddingRight))
  if (statusContentWidth >= 720) expect(noticeBounds.x + noticeBounds.width, 'Why tax is withheld stays to the left of withholding status').toBeLessThanOrEqual(treatmentBounds.x)
  else expect(treatmentBounds.y, 'status stacks after the left explanation on narrow screens').toBeGreaterThanOrEqual(noticeBounds.y + noticeBounds.height)
  await expect(page.getByText('Tax applies to the tax basis shown below, regardless of the annual total.', { exact: false })).toBeVisible()
  await expect(page.getByText('₱498,980.36', { exact: true })).toHaveCount(0)
  await expect(page.getByRole('heading', { name: 'On-platform threshold calculation', exact: true })).toBeVisible()
  await expect(page.getByRole('heading', { name: 'Tax basis calculation', exact: true })).toHaveCount(0)
  await expect(page.getByRole('region', { name: 'Annual tax basis across platforms', exact: true })).toHaveCount(0)
  await expect(page.getByText('Why does this differ from Xendit cash revenue?', { exact: true })).toHaveCount(0)
  await expect(page.getByText('Tax basis is the amount from online payments used to calculate withholding tax. Buyer-paid fees are excluded.', { exact: true })).toBeVisible()
  await expect(page.getByRole('heading', { name: 'Find the tax basis', exact: true })).toHaveCount(0)
  await expect(page.getByRole('heading', { name: /^How .* is used$/ })).toHaveCount(0)
  await expect(page.getByRole('group', { name: 'Standard withholding example' })).toHaveCount(0)
  await expect(page.getByText(/^Withholding tax recorded/)).toHaveCount(0)
  const calculation = page.getByRole('table', { name: 'On-platform threshold calculation' })
  await expect(calculation.getByRole('row', { name: /^Online payments/ })).toContainText('₱1,570.25')
  await expect(calculation.getByRole('row', { name: /^Delivery/ })).toContainText('-₱428.25')
  await expect(calculation.getByRole('row', { name: /^Material VAT/ })).toContainText('-₱122.36')
  await expect(calculation.getByRole('row', { name: /^Total gross threshold/ })).toContainText('₱1,019.64')
  await expect(page.getByText('Qualifying MateryalPH remittances', { exact: true })).toHaveCount(0)
  await expect(calculation.getByRole('row', { name: /Provider charges|E-wallet transaction fees/ })).toHaveCount(0)
  await expect(page.getByRole('table', { name: 'Remittance cash for these assessments' })).toHaveCount(0)
  await expect(page.getByRole('button', { name: 'Show TIN', exact: true })).toBeVisible()
  const taxProfile = page.locator('.mp-finance-tax-profile')
  const thresholdCard = page.locator('.mp-threshold-workspace')
  const profileBounds = (await taxProfile.boundingBox())!
  const thresholdBounds = (await thresholdCard.boundingBox())!
  expect(profileBounds.y + profileBounds.height + 12, 'Tax profile is a separate card above the threshold').toBeCloseTo(thresholdBounds.y, 0)
  expect(profileBounds.width).toBeCloseTo((await page.locator('.mp-online-payout-layout').boundingBox())!.width, 0)
  await expect(thresholdCard.locator('#tax')).toHaveCount(0)
  await expect(page.getByRole('tabpanel', { name: 'Xendit cash revenue & remittance', exact: true })).not.toContainText(/\bbalance\b/i)
  await capture(page, 'standard')
  const payments = page.locator('.mp-assessed-payments')
  await expect(payments.getByRole('heading', { name: 'Annual retained online payments (4)' })).toBeVisible()
  await expect(payments.locator('details, summary')).toHaveCount(0)
  const paymentBounds = (await payments.boundingBox())!
  const thresholdContent = (await page.locator('.mp-threshold').boundingBox())!
  expect(paymentBounds.width, 'annual order records fill the threshold card').toBeCloseTo(thresholdContent.width, 0)
  const calculationBounds = (await page.locator('.mp-threshold-breakdown').boundingBox())!
  expect(paymentBounds.y, 'records start after the on-platform calculation and its divider').toBeCloseTo(calculationBounds.y + calculationBounds.height + 13, 0)
  expect((await page.getByRole('region', { name: 'On-platform threshold calculation', exact: true }).boundingBox())!.width, 'calculation fills the available width after the annual panel is removed').toBeCloseTo(calculationBounds.width, 0)
  await expect(payments).toContainText('Full taxable year, regardless of the selected Xendit cash revenue or Transactions dates.')
  await expect(payments.getByRole('link', { name: 'View Payments for this taxable year' })).toHaveAttribute('href', '/finance/transactions?tab=PAYMENTS&from=2026-01-01&to=2026-12-31')
  const order = payments.getByRole('article', { name: 'ORD-2026-QOJYQLNH' })
  await expect(order).toContainText('₱713.75')
  await expect(order.getByRole('row', { name: /^Online payment at assessment/ })).toContainText('₱713.75')
  await expect(order.getByRole('row', { name: /^Delivery/ })).toContainText('-₱428.25')
  await expect(order.getByRole('row', { name: /^Material VAT/ })).toContainText('-₱30.59')
  await expect(order.getByText('× Applied rate').locator('..')).toContainText('0.5%')
  await expect(order.getByText('Withholding tax', { exact: true }).locator('..')).toContainText('₱1.27')
  await expect(order).toContainText('₱1.27')
  await expect(payments.getByRole('article')).toHaveCount(4)
  await expect(payments.locator('.mp-assessed-payment-tax-total')).toContainText('Total withholding tax')
  await expect(payments.locator('.mp-assessed-payment-tax-total')).toContainText('₱5.08')
  await expect(order).not.toContainText('₱18.87')
  await expect(order).not.toContainText('₱732.62')
  expect(await payments.getByRole('columnheader').evaluateAll(headers => headers.every(header => header.scrollWidth <= header.clientWidth + 1))).toBe(true)
  await expect(page.locator('.mp-assessed-payment-total')).toHaveCount(0)
  await expect(payments.locator('table table')).toHaveCount(0)
  await expect(calculation.locator('details')).toHaveCount(0)
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  const paymentViewport = page.viewportSize()!
  await page.setViewportSize({ width: paymentViewport.width, height: Math.max(paymentViewport.height, await payments.evaluate(element => element.scrollHeight) + 180) })
  await payments.screenshot({ path: resolve(`../../.tmp/finance-threshold-review/${paymentViewport.width}-payments.png`) })
  await page.setViewportSize(paymentViewport)
  const workspace = page.locator('.mp-threshold-workspace')
  const height = (await workspace.boundingBox())!.height
  await expect(page.getByRole('button', { name: 'How this is calculated: Earnings and annual remittances', exact: true })).toHaveCount(0)
  const trigger = page.getByRole('button', { name: 'How this is calculated: On-platform threshold calculation', exact: true })
  await trigger.focus()
  await page.keyboard.press('Enter')
  const dialog = page.getByRole('dialog', { name: 'On-platform threshold calculation', exact: true })
  await expect(dialog).toBeVisible()
  await expect(dialog).toContainText('Online payments - delivery - material VAT = tax basis')
  await expect(dialog).toContainText('Later refunds do not rewrite posted tax assessments')
  const bounds = (await dialog.boundingBox())!
  expect(bounds.x).toBeGreaterThanOrEqual(12)
  expect(bounds.x + bounds.width).toBeLessThanOrEqual(page.viewportSize()!.width - 12)
  expect((await workspace.boundingBox())!.height).toBeCloseTo(height, 0)
  await page.keyboard.press('Escape')
  await expect(dialog).toHaveCount(0)
  await expect(trigger).toBeFocused()
  const taxTrigger = page.getByRole('button', { name: 'How this is calculated: Total withholding tax', exact: true })
  await taxTrigger.focus()
  await page.keyboard.press('Enter')
  const taxDialog = page.getByRole('dialog', { name: 'Total withholding tax', exact: true })
  await expect(taxDialog).toBeVisible()
  await taxDialog.evaluate(element => { element.scrollTop = 0 })
  await expect(taxDialog.getByRole('button', { name: 'Close calculation explanation' })).toBeInViewport()
  await expect(taxDialog.getByText('₱254.91 tax basis × 0.5% · Rounded per payment')).toHaveCount(4)
  await expect(taxDialog.getByRole('row', { name: /^Total withholding tax/ })).toContainText('₱5.08')
  const taxBounds = (await taxDialog.boundingBox())!
  expect(taxBounds.x).toBeGreaterThanOrEqual(12)
  expect(taxBounds.x + taxBounds.width).toBeLessThanOrEqual(page.viewportSize()!.width - 12)
  await taxDialog.screenshot({ path: resolve(`../../.tmp/finance-threshold-review/${paymentViewport.width}-withholding-calculation.png`) })
  await taxDialog.evaluate(element => { element.scrollTop = 0 })
  await page.screenshot({ path: resolve(`../../.tmp/finance-threshold-review/${paymentViewport.width}-withholding-viewport.png`) })
  await page.keyboard.press('Escape')
  await expect(taxDialog).toHaveCount(0)
  await expect(taxTrigger).toBeFocused()
})

test('threshold relief, crossing, review and unavailable calculation states stay explicit', async ({ page }) => {
  let current: Record<string, unknown> = threshold
  await mock(page, () => current)
  const cases = [
    { name: 'relief', patch: { status: 'RELIEF_ACTIVE', reason_code: 'RELIEF_VALID', cumulative_gross_centavos: 50000000, local_gross_centavos: 50000000, remaining_allowance_centavos: 0, percent_of_threshold: 100, advisory: true, calculation_breakdown: null }, text: 'Relief active — no withholding' },
    { name: 'crossed', patch: { status: 'SUBJECT_THRESHOLD_BREACHED', reason_code: 'THRESHOLD_CROSSED', cumulative_gross_centavos: 50000001, local_gross_centavos: 50000001, remaining_allowance_centavos: 0, percent_of_threshold: 100, crossed_at: '2026-10-20T08:00:00Z' }, text: 'Subject to withholding — threshold crossed' },
    { name: 'review', patch: { status: 'UNDER_REVIEW', external_overlap_state: 'UNRESOLVED', external_declared_centavos: 20000, external_overlap_centavos: 10000, cumulative_gross_centavos: 111964, prior_year_total_centavos: 61000000 }, text: 'Under review — standard rate applies' },
    { name: 'not-started', patch: { status: 'NOT_STARTED', reason_code: null, cumulative_gross_centavos: 0, local_gross_centavos: 0, remaining_allowance_centavos: 50000000, calculation_breakdown: null }, text: 'No remittance assessed this taxable year' },
  ]
  for (const scenario of cases) {
    current = { ...threshold, ...scenario.patch }
    await page.goto('/finance?section=threshold')
    await expect(page.getByText(scenario.text, { exact: true })).toBeVisible()
    await expect(page.getByRole('heading', { name: scenario.name === 'relief' ? 'Gross-remittance threshold' : 'Withholding tax', exact: true })).toBeVisible()
    const withholdingApplies = scenario.name === 'crossed' || scenario.name === 'review'
    await expect(page.getByRole('note', { name: 'Tax is withheld', exact: true })).toHaveCount(withholdingApplies ? 1 : 0)
    await expect(page.locator('.mp-threshold-meter')).toHaveCount(scenario.name === 'relief' ? 1 : 0)
    if (scenario.name === 'crossed') await expect(page.getByText(/Threshold crossed on .*Asia\/Manila/)).toBeVisible()
    else if (scenario.name === 'relief') await expect(page.getByText('Threshold not crossed.', { exact: true })).toBeVisible()
    else await expect(page.getByText('Threshold not crossed.', { exact: true })).toHaveCount(0)
    if (scenario.name === 'relief' || scenario.name === 'not-started') await expect(page.locator('.mp-threshold-workspace').getByRole('table')).toHaveCount(0)
    await expect(page.getByRole('region', { name: 'Annual tax basis across platforms', exact: true })).toHaveCount(0)
    await capture(page, scenario.name)
  }
})
