import { expect, test } from '@playwright/test'
import { mkdirSync } from 'node:fs'
import { resolve } from 'node:path'

const payments = [
  { id: 'cash', kind: 'PHYSICAL', order_id: 'sample-cash', reference: 'ORD-2026-7TR0MJMWHV', purpose: 'CASH_ON_DELIVERY', status: 'PHYSICAL_COLLECTED', gross_centavos: 2905250, buyer_processing_fee_centavos: 0, refunded_centavos: 0, net_collected_centavos: 2905250, remaining_centavos: 0, channel: 'CASH_ON_DELIVERY', evidence_origin: 'VENDOR_RECORD' },
  { id: 'paid', kind: 'ONLINE', order_id: 'sample-paid', reference: 'ORD-2026-BCZHVR6Q', purpose: 'FULL_ORDER_PAYMENT', status: 'PAID', gross_centavos: 28550, buyer_processing_fee_centavos: 755, refunded_centavos: 0, net_collected_centavos: 28550, evidence_origin: 'XENDIT_TEST' },
  { id: 'cancelled', kind: 'PHYSICAL', order_id: 'sample-cancelled', reference: 'ORD-2026-09R6T0EY', purpose: 'CASH_ON_DELIVERY', status: 'PHYSICAL_RELEASED', gross_centavos: 117360, buyer_processing_fee_centavos: 0, refunded_centavos: 0, net_collected_centavos: 0, remaining_centavos: 117360, channel: 'CASH_ON_DELIVERY', evidence_origin: 'VENDOR_RECORD' },
  { id: 'refund', kind: 'ONLINE', order_id: 'sample-refund', reference: 'ORD-2026-WU6IF2CW', purpose: 'FULL_ORDER_PAYMENT', status: 'PAID', refund_state: 'REFUNDED', gross_centavos: 236000, buyer_processing_fee_centavos: 6241, refunded_centavos: 236000, net_collected_centavos: 0, evidence_origin: 'XENDIT_TEST' },
].map(row => ({ ...row, at: '2026-10-20T15:50:00Z' }))
const remittances = [
  { id: 'assessment', payment_id: 'paid', order_id: 'sample-paid', reference: 'ORD-2026-BCZHVR6Q', collected_centavos: 29305, refunds_centavos: 0, delivery_centavos: 0, vat_centavos: 3059, effective_rate_basis_points: 50, provider_charge_centavos: 755, gross_basis_centavos: 25491, withheld_centavos: 127, expected_cash_centavos: 28423, calculation_state: 'POSTED', threshold_status_after: 'SUBJECT_STANDARD' },
  { id: 'void', payment_id: 'refund', order_id: 'sample-refund', reference: 'ORD-2026-WU6IF2CW', collected_centavos: 242241, refunds_centavos: 0, provider_charge_centavos: 6241, gross_basis_centavos: 152946, withheld_centavos: 765, expected_cash_centavos: 235235, calculation_state: 'VOIDED', threshold_status_after: 'SUBJECT_STANDARD' },
].map(row => ({ ...row, at: '2026-10-20T15:50:00Z', deduction_evidence_state: 'SIMULATED_WITHHELD' }))

test('transaction lists keep signed deductions, whole identifiers and readable mobile records', async ({ page }) => {
  await page.route('**/api/v1/**', async route => {
    const url = new URL(route.request().url())
    const path = url.pathname
    let data: unknown = {}
    if (path.endsWith('/profile')) data = { id: 'sample-owner', full_name: 'Sample Owner', account_type: 'VENDOR', account_status: 'ACTIVE', role: 'OWNER' }
    else if (path.endsWith('/onboarding')) data = { step_completion: [], requirements: [], drafts: [], sections: {}, lock_version: 1, organization: { store_name: 'Sample Supply', lock_version: 1 }, welcome_required: false,
      permissions: ['portal.wallet', 'finance.view'], verification: { status: 'APPROVED' }, setup: { status: 'COMPLETED' },
      activation: { status: 'ACTIVE', marketplace_discoverability_status: 'DISCOVERABLE', readiness: { ready: true, blockers: [] } } }
    else if (path.endsWith('/auth/csrf')) data = { csrf_token: 'sample-csrf-token' }
    else if (path.endsWith('/vendor/finance/transactions')) data = url.searchParams.get('tab') === 'TAX_DOCUMENTS' ? [] : payments.map(payment => {
      const assessment = remittances.find(item => item.payment_id === payment.id)
      return assessment ? { ...payment, assessment_id: assessment.id, assessment_collected_centavos: assessment.collected_centavos, assessment_refunds_centavos: assessment.refunds_centavos,
        order_after_refunds_centavos: payment.id === 'paid' ? 28550 : 0, net_remittance_centavos: payment.id === 'paid' ? 28423 : null,
        provider_charge_centavos: assessment.provider_charge_centavos, gross_basis_centavos: assessment.gross_basis_centavos, withheld_centavos: assessment.withheld_centavos,
        assessment_delivery_centavos: assessment.delivery_centavos, assessment_vat_centavos: assessment.vat_centavos, assessment_rate_basis_points: assessment.effective_rate_basis_points,
        expected_cash_centavos: assessment.expected_cash_centavos, calculation_state: assessment.calculation_state, threshold_status_after: assessment.threshold_status_after,
        deduction_evidence_state: assessment.deduction_evidence_state, reconciliation_state: 'MATCHED', assessment_at: assessment.at } : payment
    })
    else if (path.endsWith('/notifications/unread-count')) data = { count: 0 }
    await route.fulfill({ json: { data, meta: { total: Array.isArray(data) ? data.length : 0, has_more: false }, errors: [] } })
  })
  await page.goto('/finance/transactions?tab=REMITTANCES&from=2026-10-01&to=2026-10-31')
  await expect(page).toHaveURL(/tab=PAYMENTS&from=2026-10-01&to=2026-10-31/)
  await expect(page.getByRole('tab', { name: 'Remittances and withholding tax', exact: true })).toHaveCount(0)
  const directory = resolve('../../.tmp/finance-transactions-review')
  mkdirSync(directory, { recursive: true })
  const width = page.viewportSize()!.width
  const desktop = width >= 1024
  const paymentsRegion = page.getByRole('region', { name: 'Payments records', exact: true })
  await expect(paymentsRegion).toBeVisible()
  await expect(paymentsRegion.getByRole('link', { name: 'ORD-2026-WU6IF2CW', exact: true })).toHaveAttribute('href', '/orders/sample-refund')
  await expect(paymentsRegion.getByText('-₱2,360.00', { exact: true })).toBeVisible()
  await expect(paymentsRegion.getByText('E-wallet transaction fee ₱7.55', { exact: true })).toHaveCount(0)
  await expect(paymentsRegion.getByText('₱1,173.60 still owed', { exact: true })).toHaveCount(0)
  await expect(paymentsRegion.getByText('No longer due', { exact: true })).toBeVisible()
  const onlineRow = paymentsRegion.getByRole('link', { name: 'ORD-2026-BCZHVR6Q', exact: true }).locator(desktop ? 'xpath=ancestor::tr' : 'xpath=ancestor::article')
  const physicalRow = paymentsRegion.getByRole('link', { name: 'ORD-2026-09R6T0EY', exact: true }).locator(desktop ? 'xpath=ancestor::tr' : 'xpath=ancestor::article')
  await expect(onlineRow.getByText('Online payment', { exact: true })).toBeVisible()
  await expect(physicalRow.getByText('Physical payment', { exact: true })).toBeVisible()
  await expect(onlineRow.getByRole('link')).toHaveCSS('color', 'rgb(30, 58, 138)')
  await expect(physicalRow.getByRole('link')).toHaveCSS('color', 'rgb(120, 53, 15)')
  await expect(paymentsRegion.getByRole('table')).toHaveCount(desktop ? 1 : 0)
  if (desktop) {
    const scroller = paymentsRegion.getByRole('region', { name: 'Payments', exact: true })
    await scroller.focus()
    await expect(scroller).toBeFocused()
    if (await scroller.evaluate(element => element.scrollWidth > element.clientWidth)) {
      await page.keyboard.press('ArrowRight')
      await expect.poll(() => scroller.evaluate(element => element.scrollLeft)).toBeGreaterThan(0)
      await scroller.evaluate(element => { element.scrollLeft = 0 })
    }
    await scroller.evaluate(element => element.blur())
  }
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  const viewport = page.viewportSize()!
  await page.setViewportSize({ width, height: Math.max(viewport.height, await paymentsRegion.evaluate(element => element.scrollHeight) + 600) })
  await paymentsRegion.screenshot({ path: resolve(directory, `${width}-payments.png`) })
  await page.setViewportSize(viewport)

  await expect(onlineRow.getByText('-₱1.27', { exact: true })).toBeVisible()
  await expect(onlineRow.getByText('₱284.23', { exact: true })).toBeVisible()
  await expect(onlineRow.getByText('Order after refunds', { exact: true })).toBeVisible()
  await expect(onlineRow.getByText('₱285.50', { exact: true })).toHaveCount(3)
  await expect(onlineRow.getByText('₱293.05', { exact: true })).toHaveCount(0)
  await expect(onlineRow.getByText('Net remittance', { exact: true })).toBeVisible()
  await expect(onlineRow.getByText('Tax basis', { exact: true })).toHaveCount(0)
  await expect(onlineRow.getByText('₱254.91', { exact: true })).toHaveCount(0)
  await expect(onlineRow.getByRole('button')).toHaveCount(1)
  await expect(paymentsRegion.getByRole('button', { name: /How this is calculated/ })).toHaveCount(0)
  await expect(paymentsRegion.getByText('Voided — fully refunded', { exact: true })).toBeVisible()
  await expect(paymentsRegion.getByText('₱2,352.35', { exact: true })).toHaveCount(0)
  await expect(physicalRow.getByText('Not applicable · Direct Vendor payment', { exact: true })).toBeVisible()
  for (const region of [paymentsRegion]) {
    const wrappingText = await region.locator('.mp-finance-amount, .mp-finance-remittance-basis .mp-calculation-trigger > span').evaluateAll(elements => elements.filter(element => {
      const range = document.createRange()
      range.selectNodeContents(element)
      return range.getClientRects().length !== 1
    }).map(element => element.textContent))
    expect(wrappingText).toEqual([])
  }
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  const taxHelp = onlineRow.getByRole('button', { name: 'View breakdown: Tax basis · ORD-2026-BCZHVR6Q', exact: true })
  await taxHelp.focus()
  await page.keyboard.press('Enter')
  const taxDetails = page.getByRole('dialog', { name: 'Tax basis · ORD-2026-BCZHVR6Q', exact: true })
  await expect(taxDetails).toContainText('recorded portion of this payment used to calculate withholding tax')
  await expect(taxDetails).toContainText('0.5%')
  await expect(taxDetails).not.toContainText('Buyer-paid processing fee')
  await expect(taxDetails).not.toContainText('Buyer fee')
  const basis = taxDetails.getByRole('table', { name: 'Tax basis calculation' })
  await expect(basis).toContainText('Included material VAT-₱30.59')
  await expect(basis).toContainText('Tax basis₱254.91')
  await expect(taxDetails).toContainText('Withholding tax₱1.27')
  expect(await taxDetails.evaluate(element => element.scrollWidth <= element.clientWidth)).toBe(true)
  await taxDetails.screenshot({ path: resolve(directory, `${width}-tax-breakdown.png`) })
  const bounds = (await taxDetails.boundingBox())!
  expect(bounds.x).toBeGreaterThanOrEqual(12)
  expect(bounds.x + bounds.width).toBeLessThanOrEqual(width - 12)
  const withholding = taxDetails.getByText('Withholding tax', { exact: true })
  await withholding.scrollIntoViewIfNeeded()
  await expect(withholding).toBeVisible()
  await expect(taxDetails.getByRole('button', { name: 'Close calculation explanation' })).toBeVisible()
  await taxDetails.screenshot({ path: resolve(directory, `${width}-tax-withholding.png`) })
  await page.keyboard.press('Escape')
  await expect(taxHelp).toBeFocused()
})
