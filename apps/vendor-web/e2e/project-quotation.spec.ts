import { expect, test } from '@playwright/test'

test('Work Package shows one simple item list and accessible automated response settings', async ({ page }, testInfo) => {
  const permissions = ['messaging.automated_response.configure', 'portal.messages', 'quotations.publish', 'orders.confirm']
  const snapshot = { lock_version: 1, requirements: [], drafts: [], step_completion: [], welcome_required: false, organization: { store_name: 'Sample Hardware', business_type: 'CORPORATION', lock_version: 1 }, permissions, activation: { status: 'ACTIVE' }, verification: { status: 'APPROVED' }, setup: { status: 'COMPLETED', vacation_mode: false, media: [], profile: { public_store_name: 'Sample Hardware' } }, sections: {} }
  const duplicate = { lines: [{ variant_id: 'variant-1', quantity: '8', unit_price_centavos: 5000, description: 'Proposed masonry blocks', specifications: { grade: 'A' } }], fulfillment_method: 'PICKUP', payment_method: 'ONLINE', fulfillment_date: null, deadline_hours: 24 }
  const conversation = { id: 'project-conversation', purpose: 'SALES', context_type: 'PROJECT_BASED', lock_version: 1, store: { id: 'store-1', name: 'Sample Hardware', verified: true }, handler: { display_name: 'Alex Cruz', role: 'OWNER', avatar_path: null }, unread_count: 0, channel: 'fixture-channel', locked_reference: { material_scope: 'VENDOR_ALLOCATION', version_id: 'version-1', content_hash: 'a'.repeat(64), work_package: { name: 'Foundation materials', budget_centavos: 100000, site: { name: 'Confirmed site', point: { formatted_address: 'Quezon City' } }, destination: { vehicle_endpoint: 'INTENDED_LOCATION' }, fulfillment_method: 'PICKUP', payment_method: 'ONLINE', lines: [{ id: 'line-1', name: 'Original masonry blocks', quantity: '10', unit_code: 'PC', specifications: { grade: 'A' } }] }, working_duplicate: duplicate }, updated_at: '2026-10-01T00:00:00Z', can_transfer: true, fulfillment_entry_enabled: false }
  const detail = { conversation, messages: { items: [{ id: 'package-message', conversation_id: conversation.id, client_message_id: 'package-message', kind: 'WORK_PACKAGE', body: 'Work Package', sender: { display_name: 'Sample Buyer', role: 'BUYER' }, sent_at: '2026-11-05T00:00:00Z', mine: false, attachments: [], read_by_recipient: false, work_package_attachment: { inquiry_id: conversation.id, reference: conversation.locked_reference, can_prepare_quotation: true } }], has_more: false, next_before: null }, quotations: { quotation: { id: 'quote-1', state: 'DRAFT', lock_version: 1, current_version_id: null, draft: duplicate, can_draft: true, can_publish: true }, versions: [], page: 1, has_more: false } }
  await page.emulateMedia({ reducedMotion: 'reduce' })
  await page.route('**/api/v1/**', async route => {
    const path = new URL(route.request().url()).pathname
    let data: unknown = snapshot
    if (path.endsWith('/automated-response')) data = { enabled: false, welcome_message: '', options: [], lock_version: 0 }
    else if (path.endsWith('/csrf')) data = { csrf_token: 'project-fixture' }
    else if (path.endsWith('/profile')) data = { id: 'fixture', full_name: 'Sample Owner', account_type: 'VENDOR', account_status: 'ACTIVE', role: 'OWNER', permissions }
    else if (path.endsWith('/messaging/realtime')) data = { enabled: false, key: null, host: null, port: 443, scheme: 'https' }
    else if (path.endsWith('/conversations')) data = { items: [conversation], has_more: false, page: 1 }
    else if (path.includes('/conversations/project-conversation')) data = detail
    await route.fulfill({ status: 200, contentType: 'application/json', body: JSON.stringify({ data, meta: {}, errors: [] }) })
  })
  await page.goto('/messages?conversation=project-conversation')
  await page.getByRole('complementary', { name: 'Attached Work Package' }).getByRole('button').click()
  const attachment = page.getByRole('complementary', { name: 'Work Package details' })
  await expect(attachment).toBeVisible()
  await expect(attachment.getByText(/Budget/)).toHaveCount(0)
  await expect(attachment.getByText('Original masonry blocks', { exact: true })).toHaveCount(0)
  await expect(attachment.getByText('Proposed masonry blocks', { exact: true })).toBeVisible()
  await expect(attachment.getByRole('button', { name: /Phase 15/ })).toHaveCount(0)
  const proposalRegion = attachment.getByRole('region', { name: 'Items', exact: true })
  await expect(attachment.getByRole('table')).toHaveCount(1)
  await expect(attachment.getByRole('region', { name: 'Payment summary', exact: true })).toHaveCount(1)
  await expect(attachment.getByRole('region', { name: 'Delivery and payment', exact: true })).toHaveCount(1)
  await expect(attachment.getByText(/Materials for your store|Your quotation proposal/)).toHaveCount(0)
  await expect(proposalRegion.getByRole('table').getByRole('columnheader', { name: 'Qty', exact: true })).toBeVisible()
  await expect(proposalRegion.getByRole('table').getByRole('columnheader', { name: 'Total', exact: true })).toBeVisible()
  await expect(proposalRegion.getByRole('table').getByRole('cell', { name: '₱400.00', exact: true })).toBeVisible()
  await expect(proposalRegion.getByRole('cell', { name: '₱400.00', exact: true })).toBeInViewport()
  expect(await proposalRegion.getByRole('region', { name: 'Materials table', exact: true }).evaluate(element => element.scrollWidth <= element.clientWidth)).toBe(true)
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= window.innerWidth)).toBe(true)
  await page.screenshot({ path: testInfo.outputPath('project-quotation.png'), fullPage: true })
  await proposalRegion.getByText('Proposed masonry blocks', { exact: true }).scrollIntoViewIfNeeded()
  await expect(proposalRegion.getByText('Proposed masonry blocks', { exact: true })).toBeInViewport()
  await expect(page.getByRole('button', { name: 'Close Work Package' })).toBeInViewport()
  await page.screenshot({ path: testInfo.outputPath('project-quotation-scrolled.png'), fullPage: true })
  const lineTotal = proposalRegion.getByRole('cell', { name: '₱400.00', exact: true })
  await lineTotal.scrollIntoViewIfNeeded()
  await expect(lineTotal).toBeInViewport()
  await proposalRegion.getByRole('region', { name: 'Materials table', exact: true }).focus()
  await expect(proposalRegion.getByRole('region', { name: 'Materials table', exact: true })).toBeFocused()
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= window.innerWidth)).toBe(true)
  await page.screenshot({ path: testInfo.outputPath('project-quotation-prices.png'), fullPage: true })
  await page.getByRole('button', { name: 'Close Work Package' }).click()
  if (testInfo.project.use.viewport!.width <= 767) await page.getByRole('button', { name: 'Back to inbox' }).click()
  const automation = page.getByRole('button', { name: 'Automated Response Settings', exact: true })
  await expect(automation.locator('svg.lucide-bot')).toBeVisible()
  const robotBounds = await automation.locator('svg.lucide-bot').boundingBox()
  expect(robotBounds!.width).toBe(20)
  expect((await automation.boundingBox())!.width).toBeGreaterThanOrEqual(44)
  await automation.hover()
  const tooltip = page.getByRole('tooltip', { name: 'Automated Response Settings', exact: true })
  await expect(tooltip).toBeVisible()
  const tooltipBounds = await tooltip.boundingBox()
  expect(tooltipBounds!.x).toBeGreaterThanOrEqual(0)
  expect(tooltipBounds!.x + tooltipBounds!.width).toBeLessThanOrEqual(testInfo.project.use.viewport!.width)
  await tooltip.hover()
  await expect(tooltip).toBeVisible()
  await page.screenshot({ path: testInfo.outputPath('automated-response-tooltip.png'), fullPage: true })
  await page.keyboard.press('Escape')
  await expect(tooltip).toHaveCount(0)
  await automation.focus()
  await expect(tooltip).toBeVisible()
  await automation.click()
  await expect(tooltip).toHaveCount(0)
  const settings = page.getByRole('dialog', { name: 'Automated Response Settings' })
  await expect(settings.getByRole('switch', { name: 'Automated responses' })).toBeVisible()
  await settings.getByRole('button', { name: 'Add quick reply' }).click()
  await expect(settings.getByRole('textbox', { name: 'Exact response' })).toBeVisible()
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= window.innerWidth)).toBe(true)
  await page.screenshot({ path: testInfo.outputPath('automated-response-settings.png'), fullPage: true })
})
