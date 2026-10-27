import { expect, test, type Page } from '@playwright/test'

// Presentation and interaction only. Every API response is synthetic; no funds or provider calls are involved.
const stamp = '2026-10-27T02:00:00Z'

async function fixture(page: Page) {
  await page.route('**/api/v1/**', async route => {
    const url = new URL(route.request().url())
    const path = url.pathname
    let data: unknown = {}
    if (path.endsWith('/profile')) data = { id: 'layout-review', full_name: 'Platform Admin', account_type: 'ADMIN', account_status: 'ACTIVE', role: 'ADMIN_SUPERADMIN' }
    else if (path.endsWith('/auth/csrf')) data = { csrf_token: 'synthetic-layout-csrf' }
    else if (path.endsWith('/notifications/unread-count')) data = { count: 0 }
    else if (path.endsWith('/admin/order-operations/summary')) data = { refunds_total: 18, reimbursements_total: 7, refunds_failed: 2, refunds_pending: 4, reimbursements_pending: 3, cancellation_requests_open: 2, nfr_events_30_days: 5 }
    else if (path.endsWith('/admin/order-operations/refunds')) {
      const state = url.searchParams.get('state') ?? 'REFUND_FAILED'
      const display = state === 'REFUND_FAILED' ? 'FAILED' : state === 'REFUNDED' ? 'PROCESSED' : 'PROCESSING'
      data = [
        { id: 'refund-layout', order_id: 'order-layout', target_type: 'ORDER', trigger: 'CANCELLATION', state, display_state: display, amount_centavos: 1026441, attempt_number: 2, failure_code: state === 'REFUND_FAILED' ? 'INSUFFICIENT_BALANCE' : null, evidence_origin: 'SIMULATED', order_reference: 'ORD-2026-AAAA', vendor_name: 'Sample Construction Supply', requested_at: stamp, can_retry: state === 'REFUND_FAILED' },
        { id: 'refund-fee', target_type: 'PLATFORM_FEE', trigger: 'FEE_CREDIT', state, display_state: display, amount_centavos: 15375, attempt_number: 1, evidence_origin: 'SIMULATED', statement_reference: 'FEE-2026-0012', vendor_name: 'Metro Building Materials', requested_at: stamp, can_retry: false },
      ]
    } else if (path.endsWith('/admin/order-operations/reimbursements')) data = [
      { id: 'cash-layout', order_reference: 'ORD-2026-CASH', vendor_name: 'Sample Construction Supply', state: 'VENDOR_REIMBURSEMENT_PENDING', amount_centavos: 150000, method: 'IN_STORE', has_evidence: true, reimbursed_at: stamp, confirmed_by_review: false, can_decide: true },
      { id: 'cash-done', order_reference: 'ORD-2026-PAID', vendor_name: 'Metro Building Materials', state: 'REIMBURSEMENT_CONFIRMED', amount_centavos: 245000, method: 'CASH_ON_DELIVERY', has_evidence: true, reimbursed_at: stamp, confirmed_by_review: false, can_decide: false },
    ]
    else if (path.endsWith('/admin/order-operations/cancellation-requests')) data = [
      { id: 'request-overdue', order_id: 'order-cancel', order_reference: 'ORD-2026-CANCEL', vendor_name: 'Sample Construction Supply', reason_code: 'CHANGE_OF_PLAN', response_due_at: stamp, overdue: true },
      { id: 'request-wait', order_reference: 'ORD-2026-WAIT', vendor_name: 'Metro Building Materials', reason_code: 'ORDERED_BY_MISTAKE', response_due_at: '2026-10-28T02:00:00Z', overdue: false },
    ]
    await route.fulfill({ json: { data, meta: { has_more: false }, errors: [] } })
  })
}

async function fits(page: Page) {
  const overflow = await page.evaluate(() => {
    const width = document.documentElement.clientWidth
    return [...document.querySelectorAll<HTMLElement>('main *')]
      .filter(element => element.getClientRects().length && element.getBoundingClientRect().right > width + 1 && getComputedStyle(element).position !== 'fixed' && !element.closest('[class*="overflow-x-auto"]'))
      .map(element => ({ tag: element.tagName, className: String(element.className), right: element.getBoundingClientRect().right })).slice(0, 5)
  })
  expect(overflow).toEqual([])
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
}

test('Orders & Refunds Logs lives under Tracking and its records reflow cleanly', async ({ page }) => {
  await fixture(page)
  await page.goto('http://127.0.0.1:4174/order-operations')
  await expect(page.getByRole('heading', { name: 'Orders & Refunds Logs', level: 1 })).toBeVisible()
  const mobile = page.viewportSize()!.width < 1024
  if (mobile) await page.getByRole('button', { name: 'Open navigation' }).click()
  const sidebar = page.getByRole('complementary', { name: 'ADMIN PORTAL navigation' })
  const tracking = sidebar.getByRole('region', { name: 'Tracking' })
  const link = tracking.getByRole('link', { name: 'Orders & Refunds Logs' })
  await expect(link).toHaveAttribute('href', '/order-operations')
  await expect(link).toHaveAttribute('aria-current', 'page')
  await expect(sidebar.getByRole('region', { name: 'Finance' }).getByRole('link', { name: 'Orders & Refunds Logs' })).toHaveCount(0)
  if (mobile) await page.getByRole('button', { name: 'Close navigation' }).click()
  await expect(page.getByRole('link', { name: 'Invoice Request Log' })).toHaveAttribute('href', '/invoices')
  const role = mobile ? 'list' : 'table'
  const refunds = page.getByRole(role, { name: 'Refund records', exact: true })
  await expect(refunds).toContainText('₱10,264.41')
  await expect(refunds).toContainText('INSUFFICIENT_BALANCE')
  await fits(page)
  await page.screenshot({ path: test.info().outputPath('refund-log.png'), fullPage: true })
  await page.getByRole('button', { name: 'Processed', exact: true }).click()
  await expect(refunds).toContainText('Refund processed by the payment provider')
  await expect(refunds.getByRole('button', { name: 'Retry after funding is resolved' })).toHaveCount(0)
  await page.getByRole('tab', { name: 'Cash reimbursements 7' }).click()
  const cash = page.getByRole(role, { name: 'Cash reimbursement records', exact: true })
  await expect(cash).toContainText('In-Store Payment')
  await expect(cash).toContainText('Confirmed by the Buyer')
  await fits(page)
  await cash.scrollIntoViewIfNeeded()
  await page.screenshot({ path: test.info().outputPath('cash-reimbursement-log.png'), fullPage: true })
  await cash.getByRole('button', { name: 'Confirm with reason' }).click()
  await expect(page.getByRole('dialog')).toBeVisible()
  await page.getByRole('button', { name: 'Confirm reimbursement', exact: true }).click()
  await expect(page.getByRole('dialog')).toContainText('at least 10 characters')
  await page.getByRole('dialog').getByRole('button', { name: 'Cancel', exact: true }).click()
  await page.getByRole('tab', { name: 'Open cancellation requests 2' }).click()
  const requests = page.getByRole(role, { name: 'Cancellation request records', exact: true })
  await expect(requests).toContainText('Past due — finalizing automatically')
  await expect(requests).toContainText('Awaiting Vendor response')
  await fits(page)
  await requests.scrollIntoViewIfNeeded()
  await page.screenshot({ path: test.info().outputPath('cancellation-request-log.png'), fullPage: true })
})
