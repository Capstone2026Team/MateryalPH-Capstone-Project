import { expect, test } from '@playwright/test'

test('quotation history and public handler identity remain readable across screen sizes', async ({ page }, testInfo) => {
  const permissions = ['portal.messages', 'quotations.publish', 'orders.confirm']
  const snapshot = { lock_version: 1, requirements: [], drafts: [], step_completion: [], welcome_required: false, organization: { store_name: 'Sample Hardware', business_type: 'CORPORATION', lock_version: 1 }, permissions, activation: { status: 'ACTIVE' }, verification: { status: 'APPROVED' }, setup: { status: 'COMPLETED', vacation_mode: false, media: [], profile: { public_store_name: 'Sample Hardware' } }, sections: {} }
  const content = { lines: [{ variant_id: 'variant-1', quantity: '12', unit_price_centavos: 27000, description: 'Portland Cement · 40 kg bag', unit_code: 'bag', tax_category: 'VAT_12', source_price_version_id: 'price-1', source_tax_version_id: 'tax-1' }], commercial: { materials_payable_centavos: 324000, materials_vat_centavos: 34714, vendor_discount_centavos: 0, delivery_centavos: 0, nrpc_centavos: 0, commercial_total_centavos: 324000 }, fulfillment_method: 'PICKUP', payment_method: 'ONLINE', fulfillment_date: '2099-10-01', price_source: 'PRIVATE_TRANSACTION', processing_fee_status: 'PENDING_PAYMENT_CHANNEL', nrpc: null, delivery: null, changes: [{ path: 'lines.0.quantity', label: 'Quantity changed', before: '15', after: '12' }], original_changes: [] }
  const detail = { conversation: { id: 'conversation-1', purpose: 'SALES', context_type: 'ITEM_BASED', lock_version: 1, store: { id: 'store-1', name: 'Sample Hardware', verified: true }, handler: { display_name: 'Alex Cruz', role: 'STORE_STAFF', avatar_path: null }, unread_count: 0, channel: 'fixture-channel', locked_reference: {}, updated_at: '2026-09-30T00:00:00Z', can_transfer: true, fulfillment_entry_enabled: false }, messages: { items: [{ id: 'message-1', client_message_id: 'client-1', kind: 'TEXT', body: 'I have revised the quantity to twelve bags. Please review the latest quotation.', sender: { display_name: 'Alex Cruz', role: 'STORE_STAFF', avatar_path: null }, sent_at: '2026-09-30T00:00:00Z', mine: true, read_by_recipient: true, attachments: [{ id: 'file-1', display_name: 'Attachment.pdf', media_type: 'application/pdf', size_bytes: 2048, scan_state: 'CLEAN' }] }], has_more: false, next_before: null }, quotations: { quotation: { id: 'quote-1', state: 'PUBLISHED', lock_version: 3, current_version_id: 'version-2', draft: null, can_draft: true, can_publish: true }, versions: [{ id: 'version-2', version: 2, latest: true, state: 'PUBLISHED', published_at: '2026-09-30T00:00:00Z', expires_at: '2099-09-30T00:00:00Z', content_hash: 'a'.repeat(64), content, viewed: true, actions: ['withdraw'] }, { id: 'version-1', version: 1, latest: false, state: 'SUPERSEDED', published_at: '2026-09-29T00:00:00Z', expires_at: '2099-09-29T00:00:00Z', content_hash: 'b'.repeat(64), content, viewed: true, actions: [] }], page: 1, has_more: false } }
  detail.messages.items.unshift({ id: 'buyer-message', client_message_id: 'buyer-client', kind: 'TEXT', body: 'Hi! Do you have Portland cement available?', sender: { display_name: 'Pedro Dela Cruz', role: 'BUYER', avatar_path: null }, sent_at: '2026-09-29T23:55:00Z', mine: false, read_by_recipient: true, attachments: [] })
  let sendAttempts = 0
  const sentKeys: string[] = []
  await page.route('**/api/v1/**', async route => {
    const path = new URL(route.request().url()).pathname
    let data: unknown = snapshot
    if (path.endsWith('/csrf')) data = { csrf_token: 'messaging-fixture' }
    else if (path.endsWith('/profile')) data = { id: 'fixture', full_name: 'Sample Owner', account_type: 'VENDOR', account_status: 'ACTIVE', role: 'OWNER', permissions }
    else if (path.endsWith('/messaging/realtime')) data = { enabled: false, key: null, host: null, port: 443, scheme: 'https' }
    else if (path.endsWith('/conversations')) data = { items: [detail.conversation, { ...detail.conversation, id: 'conversation-2', context_type: 'PROJECT_BASED', unread_count: 2 }], has_more: false, page: 1 }
    else if (path.endsWith('/messages') && route.request().method() === 'POST') {
      sendAttempts++
      const body = route.request().postDataJSON() as { body: string; client_message_id: string }
      sentKeys.push(body.client_message_id)
      if (sendAttempts === 1) {
        await route.fulfill({ status: 503, contentType: 'application/json', body: JSON.stringify({ data: null, meta: {}, errors: [{ code: 'UNAVAILABLE', message: 'Message could not be sent. Please retry.' }] }) })
        return
      }
      detail.messages.items.push({ id: 'sent-message', client_message_id: body.client_message_id, kind: 'TEXT', body: body.body, sender: { display_name: 'Alex Cruz', role: 'STORE_STAFF', avatar_path: null }, sent_at: '2026-09-30T00:05:00Z', mine: true, read_by_recipient: false, attachments: [] })
      data = detail.messages.items.at(-1)
    }
    else if (path.includes('/conversations/conversation-1')) data = detail
    await route.fulfill({ status: 200, contentType: 'application/json', body: JSON.stringify({ data, meta: {}, errors: [] }) })
  })
  await page.goto('/messages?conversation=conversation-1')
  await expect(page.getByText('Handled by', { exact: true })).toBeVisible()
  await expect(page.getByText('Alex Cruz', { exact: true })).toBeVisible()
  const inbox = page.getByRole('complementary', { name: 'Conversation inbox' })
  if (testInfo.project.use.viewport!.width >= 768) {
    await expect(inbox).toBeVisible()
    await expect(inbox.locator('[aria-current="true"]')).toContainText('Product inquiry')
    const search = inbox.getByRole('searchbox')
    await search.fill('Project')
    await expect(inbox.getByRole('button', { name: /Product inquiry/ })).toHaveCount(0)
    await expect(inbox.getByRole('button', { name: /Project inquiry/ })).toBeVisible()
    await search.fill('no matching inquiry')
    await expect(inbox.getByRole('status')).toHaveText('No matching conversations on this page.')
    await search.clear()
  } else {
    await expect(inbox).toBeHidden()
    await page.getByRole('button', { name: 'Back to inbox' }).click()
    await expect(inbox).toBeVisible()
    await inbox.getByRole('button', { name: /Product inquiry/ }).click()
  }
  await expect(page.getByText('Hi! Do you have Portland cement available?')).toBeVisible()
  await page.screenshot({ path: testInfo.outputPath('messaging.png'), fullPage: true })
  await page.getByRole('button', { name: 'Quotation history', exact: true }).click()
  const latest = page.getByRole('article', { name: 'Quotation version 2' })
  const old = page.getByRole('article', { name: 'Quotation version 1' })
  await expect(latest.getByRole('button', { name: 'Withdraw quotation' })).toBeVisible()
  await expect(old.getByRole('button')).toHaveCount(0)
  await expect(old.getByText('Superseded', { exact: true })).toBeVisible()
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= window.innerWidth)).toBe(true)
  await page.getByRole('button', { name: 'Quotation history', exact: true }).click()
  await page.getByRole('button', { name: 'Prepare quotation', exact: true }).click()
  await expect(page.getByRole('region', { name: 'Quotation draft' })).toBeVisible()
  await page.getByRole('button', { name: 'Close draft editor' }).click()
  await page.getByLabel('Message', { exact: true }).fill('Thank you for reviewing the quotation.')
  await expect(page.getByRole('button', { name: 'Send message' })).toBeEnabled()
  await page.getByRole('button', { name: 'Send message' }).click()
  await expect(page.getByLabel('Message', { exact: true })).toHaveValue('Thank you for reviewing the quotation.')
  await expect(page.getByRole('button', { name: 'Send message' })).toBeEnabled()
  await page.getByRole('button', { name: 'Send message' }).click()
  await expect(page.getByLabel('Message', { exact: true })).toHaveValue('')
  await expect(page.getByText('Thank you for reviewing the quotation.', { exact: true })).toBeVisible()
  expect(sentKeys).toHaveLength(2)
  expect(sentKeys[0]).toBe(sentKeys[1])
})
