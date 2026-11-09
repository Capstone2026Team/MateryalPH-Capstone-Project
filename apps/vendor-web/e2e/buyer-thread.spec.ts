import { expect, test } from '@playwright/test'

test('one Buyer chat carries Work Package attachments and replies without a subject picker', async ({ page }, testInfo) => {
  const permissions = ['portal.messages', 'quotations.publish', 'orders.confirm']
  const snapshot = { lock_version: 1, requirements: [], drafts: [], step_completion: [], welcome_required: false, organization: { store_name: 'Sample Hardware', business_type: 'CORPORATION', lock_version: 1 }, permissions, activation: { status: 'ACTIVE' }, verification: { status: 'APPROVED' }, setup: { status: 'COMPLETED', vacation_mode: false, media: [], profile: { public_store_name: 'Sample Hardware' } }, sections: {} }
  const base = { purpose: 'SALES', context_type: 'ITEM_BASED', buyer_thread_id: 'sample-buyer', conversation_count: 3, lock_version: 1, store: { id: 'sample-store', name: 'Sample Hardware', verified: true }, buyer: { display_name: 'Sample Buyer', role: 'BUYER' }, handler: { display_name: 'Alex Cruz', role: 'OWNER' }, unread_count: 0, channel: 'fixture-channel', locked_reference: {}, updated_at: '2026-11-05T02:00:00Z', can_transfer: false, can_list_fulfillment_conversations: true, fulfillment_unread_count: 1, fulfillment_entry_enabled: false, read_only: false }
  const general = { ...base, id: 'sales-context' }
  const project = { ...base, id: 'package-context', context_type: 'PROJECT_BASED', inquiry_label: 'Foundation materials', locked_reference: { material_scope: 'VENDOR_ALLOCATION', work_package: { name: 'Foundation materials', lines: [{ name: 'Masonry blocks', quantity: '10', unit_code: 'PC', specifications: {} }] } } }
  const order = { ...base, id: 'order-context', purpose: 'FULFILLMENT', order_id: 'sample-order', order_reference: 'ORD-SAMPLE', read_only: true, read_only_reason: 'ORDER_COMPLETED' }
  const contexts = [general, project, order]
  const messages = [
    { id: '019a3ec0-0000-7000-8000-000000000000', conversation_id: general.id, client_message_id: 'client-0', kind: 'TEXT', body: 'Is your store open?', sender: { display_name: 'Sample Buyer', role: 'BUYER' }, sent_at: '2026-11-05T00:00:00Z', mine: false, attachments: [], read_by_recipient: false },
    { id: '019a3ec0-0000-7000-8000-000000000001', conversation_id: general.id, client_message_id: 'client-1', kind: 'WORK_PACKAGE', body: 'Work Package: Foundation materials', sender: { display_name: 'Sample Buyer', role: 'BUYER' }, sent_at: '2026-11-05T01:00:00Z', mine: false, attachments: [], read_by_recipient: false, work_package_attachment: { inquiry_id: project.id, reference: project.locked_reference, can_prepare_quotation: true } },
    { id: '019a3ec0-0000-7000-8000-000000000002', conversation_id: order.id, client_message_id: 'client-2', kind: 'TEXT', body: 'Thank you for coordinating pickup.', sender: { display_name: 'Sample Buyer', role: 'BUYER' }, sent_at: '2026-11-05T02:00:00Z', mine: false, attachments: [], read_by_recipient: false },
  ]
  let sentTo: string | undefined
  await page.emulateMedia({ reducedMotion: 'reduce' })
  await page.route('**/api/v1/**', async route => {
    const path = new URL(route.request().url()).pathname
    const selected = contexts.find(context => path.includes(`/conversations/${context.id}/`)) ?? general
    let data: unknown = snapshot
    if (path.endsWith('/csrf')) data = { csrf_token: 'buyer-thread-fixture-csrf-token' }
    else if (path.endsWith('/profile')) data = { id: 'fixture', full_name: 'Sample Owner', account_type: 'VENDOR', account_status: 'ACTIVE', role: 'OWNER', permissions }
    else if (path.endsWith('/messaging/realtime')) data = { enabled: false, key: null, host: null, port: 443, scheme: 'https' }
    else if (path.endsWith('/fulfillment-conversations')) data = { items: [{ conversation_id: order.id, order_id: order.order_id, order_reference: order.order_reference, order_state: 'COMPLETED', fulfillment_method: 'PICKUP', unread_count: 1, updated_at: order.updated_at, read_only: true }], page: 1, has_more: false }
    else if (path.endsWith('/conversations/order-context')) data = { conversation: order, messages: { items: [messages[2]], has_more: false }, quotations: { versions: [], has_more: false } }
    else if (path.endsWith('/buyer-thread/contexts')) data = { items: contexts, page: 1, has_more: false }
    else if (path.endsWith('/buyer-thread')) data = { conversation: general, messages: { items: messages, has_more: false }, quotations: { quotation: null, versions: [], page: 1, has_more: false }, thread_contexts: contexts, thread_authority: 'fixture-authority' }
    else if (path.endsWith('/conversations/package-context')) data = { conversation: project, messages: { items: [], has_more: false }, quotations: { quotation: { id: 'package-quotation', state: 'DRAFT', lock_version: 1, can_draft: true, can_publish: true, draft: { lines: [], fulfillment_method: 'PICKUP', deadline_hours: 24 } }, versions: [], has_more: false } }
    else if (path.endsWith('/conversations')) data = { items: [general], page: 1, has_more: false }
    else if (path.endsWith('/messages') && route.request().method() === 'POST') {
      sentTo = selected.id
      const input = route.request().postDataJSON() as { body: string; client_message_id: string }
      messages.push({ ...messages[0]!, id: '019a3ec0-0000-7000-8000-000000000004', conversation_id: selected.id, body: input.body, client_message_id: input.client_message_id, sender: { display_name: 'Sample Owner', role: 'OWNER' }, sent_at: '2026-11-05T03:00:00Z', mine: true })
      data = { id: messages.at(-1)!.id }
    }
    await route.fulfill({ status: 200, contentType: 'application/json', body: JSON.stringify({ data, meta: {}, errors: [] }) })
  })
  await page.goto('/messages?conversation=sales-context')
  const inbox = page.getByRole('complementary', { name: 'Conversation inbox', includeHidden: true })
  await expect(inbox.getByRole('button', { name: /Sample Buyer/, includeHidden: true })).toHaveCount(1)
  await expect(page.getByText('Is your store open?', { exact: true })).toBeVisible()
  await expect(page.getByText('Thank you for coordinating pickup.', { exact: true })).toBeVisible()
  await expect(page.getByRole('button', { name: /Reply about/ })).toHaveCount(0)
  await expect(page.getByRole('dialog', { name: 'Choose reply subject' })).toHaveCount(0)
  const composer = page.getByRole('textbox', { name: 'Message', exact: true })
  await composer.fill('We can prepare your quotation.')
  await page.getByRole('button', { name: 'Fulfillment conversations', exact: true }).click()
  const fulfillment = page.getByRole('dialog', { name: 'Fulfillment conversations' })
  await fulfillment.getByRole('button', { name: /ORD-SAMPLE/ }).click()
  await expect(fulfillment.getByText('Thank you for coordinating pickup.', { exact: true })).toBeVisible()
  await expect(fulfillment.getByRole('textbox', { name: 'Message', exact: true })).toHaveCount(0)
  await fulfillment.getByRole('button', { name: 'Close fulfillment conversations' }).click()
  await expect(composer).toHaveValue('We can prepare your quotation.')

  await page.getByRole('complementary', { name: 'Attached Work Package' }).getByRole('button').click()
  await expect(page.getByRole('region', { name: 'Items', exact: true }).getByText('Masonry blocks')).toBeVisible()
  await page.getByRole('button', { name: 'Close Work Package' }).click()
  await expect(composer).toHaveValue('We can prepare your quotation.')
  await page.getByRole('button', { name: 'Send message', exact: true }).click()
  await expect.poll(() => sentTo).toBe('sales-context')
  await expect(page.getByText('Thank you for coordinating pickup.', { exact: true })).toBeVisible()
  await page.getByRole('complementary', { name: 'Attached Work Package' }).locator('..').getByRole('button', { name: 'Prepare quotation', exact: true }).click()
  const editor = page.getByRole('dialog', { name: 'Prepare quotation' })
  await expect(editor).toBeVisible()
  await editor.getByRole('button', { name: 'Close', exact: true }).click()
  await expect(composer).toBeVisible()
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= window.innerWidth)).toBe(true)
  await page.screenshot({ path: testInfo.outputPath('combined-buyer-thread.png'), fullPage: true })
})
