import { expect, test } from '@playwright/test'

test('Project original and Vendor duplicate remain readable at the 1024px breakpoint', async ({ page }, testInfo) => {
  const permissions = ['portal.messages', 'quotations.publish', 'orders.confirm']
  const snapshot = { lock_version: 1, requirements: [], drafts: [], step_completion: [], welcome_required: false, organization: { store_name: 'Sample Hardware', business_type: 'CORPORATION', lock_version: 1 }, permissions, activation: { status: 'ACTIVE' }, verification: { status: 'APPROVED' }, setup: { status: 'COMPLETED', vacation_mode: false, media: [], profile: { public_store_name: 'Sample Hardware' } }, sections: {} }
  const duplicate = { lines: [{ variant_id: 'variant-1', quantity: '8', unit_price_centavos: 5000, description: 'Proposed masonry blocks', specifications: { grade: 'A' } }], fulfillment_method: 'PICKUP', payment_method: 'ONLINE', fulfillment_date: null, deadline_hours: 24 }
  const conversation = { id: 'project-conversation', purpose: 'SALES', context_type: 'PROJECT_BASED', lock_version: 1, store: { id: 'store-1', name: 'Sample Hardware', verified: true }, handler: { display_name: 'Alex Cruz', role: 'OWNER', avatar_path: null }, unread_count: 0, channel: 'fixture-channel', locked_reference: { version_id: 'version-1', content_hash: 'a'.repeat(64), work_package: { name: 'Foundation materials', budget_centavos: 100000, site: { name: 'Confirmed site', point: { formatted_address: 'Quezon City' } }, destination: { vehicle_endpoint: 'INTENDED_LOCATION' }, fulfillment_method: 'PICKUP', payment_method: 'ONLINE', lines: [{ id: 'line-1', name: 'Original masonry blocks', quantity: '10', unit_code: 'PC', specifications: { grade: 'A' } }] }, working_duplicate: duplicate }, updated_at: '2026-10-01T00:00:00Z', can_transfer: true, fulfillment_entry_enabled: false }
  const detail = { conversation, messages: { items: [], has_more: false, next_before: null }, quotations: { quotation: { id: 'quote-1', state: 'DRAFT', lock_version: 1, current_version_id: null, draft: duplicate, can_draft: true, can_publish: true }, versions: [], page: 1, has_more: false } }
  await page.emulateMedia({ reducedMotion: 'reduce' })
  await page.route('**/api/v1/**', async route => {
    const path = new URL(route.request().url()).pathname
    let data: unknown = snapshot
    if (path.endsWith('/csrf')) data = { csrf_token: 'project-fixture' }
    else if (path.endsWith('/profile')) data = { id: 'fixture', full_name: 'Sample Owner', account_type: 'VENDOR', account_status: 'ACTIVE', role: 'OWNER', permissions }
    else if (path.endsWith('/messaging/realtime')) data = { enabled: false, key: null, host: null, port: 443, scheme: 'https' }
    else if (path.endsWith('/conversations')) data = { items: [conversation], has_more: false, page: 1 }
    else if (path.includes('/conversations/project-conversation')) data = detail
    await route.fulfill({ status: 200, contentType: 'application/json', body: JSON.stringify({ data, meta: {}, errors: [] }) })
  })
  await page.goto('/messages?conversation=project-conversation')
  const attachment = page.getByRole('complementary', { name: 'Work Package comparison' })
  await expect(attachment).toBeVisible()
  await expect(attachment.getByText('Original masonry blocks', { exact: true })).toBeVisible()
  await expect(attachment.getByText('Proposed masonry blocks', { exact: true })).toBeVisible()
  await expect(attachment.getByRole('button', { name: 'Work Package PDF · Phase 15' })).toBeDisabled()
  const original = await attachment.getByRole('region', { name: 'Buyer original' }).boundingBox()
  const proposed = await attachment.getByRole('region', { name: 'Vendor working duplicate / proposal' }).boundingBox()
  expect(original).not.toBeNull()
  expect(proposed).not.toBeNull()
  if (testInfo.project.use.viewport!.width >= 1024) expect(Math.abs(original!.y - proposed!.y)).toBeLessThan(2)
  else expect(proposed!.y).toBeGreaterThan(original!.y + original!.height)
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= window.innerWidth)).toBe(true)
  await page.screenshot({ path: testInfo.outputPath('project-quotation.png'), fullPage: true })
})
