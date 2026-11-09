import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { spawnSync } from 'node:child_process'
import { fileURLToPath } from 'node:url'
import { parse } from 'yaml'

const root = fileURLToPath(new URL('../', import.meta.url))
const spec = parse(readFileSync(new URL('../openapi.yaml', import.meta.url), 'utf8'))
let routeJson
if (process.argv[2]) routeJson = readFileSync(process.argv[2], 'utf8')
else {
  const result = spawnSync('php', ['artisan', 'route:list', '--json', '--path=api/v1'], { cwd: `${root}/../../services/api`, encoding: 'utf8', timeout: 60000 })
  assert.equal(result.status, 0, 'Export Laravel routes successfully before checking the contract')
  routeJson = result.stdout
}
const routes = JSON.parse(routeJson)
const expected = new Set()
for (const [path, methods] of Object.entries(spec.paths)) {
  for (const [method, operation] of Object.entries(methods)) {
    if (!operation.tags?.includes('Messaging')) continue
    assert.ok(operation.responses['401'] && operation.responses['403'] && operation.responses['409'])
    const portals = operation.parameters.find(p => p.name === 'messagingPortal')?.schema.enum ?? [path.startsWith('/buyers/') ? 'buyers' : 'vendor']
    for (const portal of portals) {
      const uri = `api/v1${path.replace('{messagingPortal}', portal)}`
      const route = routes.find(r => r.uri === uri && r.method.split('|').includes(method.toUpperCase()))
      assert.ok(route, `Missing ${method} ${uri}`)
      expected.add(`${method.toUpperCase()} ${uri}`)
      const middleware = route.middleware.join(',')
      assert.match(middleware, /Authenticate:api|auth:api/)
      assert.match(middleware, portal === 'buyers' ? /RequireAccountAccess:BUYER|account.access:BUYER/ : /RequireAccountAccess:VENDOR|account.access:VENDOR/)
      if (portal === 'vendor' && method !== 'get') assert.match(middleware, /VerifyAccountCsrf/)
    }
    if (['publishChatQuotation', 'startNextChatQuotation', 'decideChatQuotation', 'createConversation', 'openVendorOrderConversation'].includes(operation.operationId)) {
      assert.ok(operation.parameters.some(p => p.name === 'Idempotency-Key' && p.required))
    }
  }
}
for (const route of routes.filter(r => /api\/v1\/(buyers|vendor)\/(conversations|messaging)/.test(r.uri))) {
  for (const method of route.method.split('|').filter(m => m !== 'HEAD')) assert.ok(expected.has(`${method} ${route.uri}`), `Undocumented messaging route ${route.uri}`)
}
assert.deepEqual(spec.components.schemas.ConversationView.properties.purpose.enum, ['SALES', 'FULFILLMENT'])
assert.equal(spec.paths['/{messagingPortal}/conversations/{conversationId}/project-inquiries'].get.operationId, 'listChatProjectInquiries')
assert.equal(spec.components.schemas.ConversationView.properties.main_conversation_id.format, 'uuid')
assert.equal(spec.components.schemas.ConversationView.properties.project_unread_count.minimum, 0)
assert.equal(spec.components.schemas.ConversationView.properties.can_list_fulfillment_conversations.type, 'boolean')
assert.equal(spec.components.schemas.ConversationView.properties.fulfillment_unread_count.type, 'integer')
assert.equal(spec.components.schemas.ConversationView.properties.fulfillment_unread_count.minimum, 0)
assert.match(spec.paths['/{messagingPortal}/conversations'].get.description, /previews and unread counts exclude order-specific fulfillment messages/)
assert.match(spec.paths['/vendor/conversations/{conversationId}/buyer-thread'].get.description, /closed fulfillment thread never locks the normal chat/)
assert.equal(spec.paths['/vendor/conversations/{conversationId}/fulfillment-conversations'].get.operationId, 'listVendorFulfillmentConversations')
assert.equal(spec.components.schemas.FulfillmentConversationPage.properties.items.maxItems, 25)
assert.ok(spec.components.schemas.FulfillmentConversationSummary.required.includes('read_only'))
assert.equal(spec.components.schemas.ChatRealtime.properties.inbox_channel.type, 'string')
assert.equal(spec.components.schemas.ChatRealtime.properties.inbox_channel.nullable, true)
assert.equal(spec.components.schemas.ChatDraftContent.properties.deadline_hours.default, 24)
assert.equal(spec.components.schemas.ChatDraftContent.properties.message.maxLength, 5000)
assert.equal(spec.components.schemas.ChatDraftContent.properties.destination.$ref, '#/components/schemas/ChatQuotationDestination')
assert.deepEqual(spec.components.schemas.ChatQuotationDestination.properties.heavy_vehicle_restriction.enum, ['UNANSWERED', 'NO', 'YES'])
assert.equal(spec.components.schemas.ChatQuotationDestination.properties.intended_address.readOnly, true)
assert.equal(spec.components.schemas.QuotationLocationSearch.properties.latitude.minimum, 4)
assert.equal(spec.components.schemas.QuotationLocationSearch.properties.longitude.maximum, 127)
assert.equal(spec.components.schemas.QuotationLocationSearch.properties.address_id.format, 'uuid')
assert.ok(spec.components.schemas.QuotationLocation.required.includes('latitude'))
assert.ok(spec.components.schemas.QuotationLocation.required.includes('longitude'))
assert.equal(spec.components.schemas.ChatQuotationContent.properties.destination.type, 'object')
assert.equal(spec.paths['/vendor/conversations/{conversationId}/quotation/location'].post.operationId, 'searchChatQuotationLocation')
assert.equal(spec.paths['/vendor/conversations/{conversationId}/quotation/delivery-plan'].post.responses['200'].content['application/json'].schema.$ref, '#/components/schemas/DeliveryPlanEnvelope')
assert.equal(spec.components.schemas.ChatQuotationContent.properties.message.maxLength, 5000)
assert.equal(spec.components.schemas.ChatDraftContent.properties.lines.minItems, 0)
assert.ok(!spec.components.schemas.ChatDraftContent.required.includes('fulfillment_date'))
assert.equal(spec.components.schemas.ChatDraftContent.properties.deadline_hours.minimum, 1)
assert.equal(spec.components.schemas.ChatDraftContent.properties.deadline_hours.maximum, 72)
assert.equal(spec.components.schemas.ChatDraftContent.properties.discount.$ref, '#/components/schemas/ChatQuotationDiscount')
assert.equal(spec.components.schemas.ChatDraftContent.properties.vendor_discount_centavos.deprecated, true)
assert.ok(!spec.components.schemas.ChatDraftContent.required.includes('payment_method'))
assert.ok(!spec.components.schemas.ChatQuotationContent.required.includes('payment_method'))
assert.equal(spec.components.schemas.ChatDraftContent.properties.payment_method.deprecated, true)
assert.equal(spec.components.schemas.ChatQuotationContent.properties.payment_method.deprecated, true)
assert.deepEqual(spec.components.schemas.ChatDecision.properties.payment_method.enum, ['ONLINE', 'CASH_ON_DELIVERY', 'IN_STORE'])
assert.equal(spec.components.schemas.ChatQuotationVersion.properties.available_payment_methods.maxItems, 2)
assert.equal(spec.components.schemas.ChatQuotationVersion.properties.selected_payment_method.nullable, true)
for (const field of ['requested_changes', 'change_requested_at', 'vendor_response_due_at']) {
  assert.equal(spec.components.schemas.ChatQuotationVersion.properties[field].type, 'string')
  assert.ok(!spec.components.schemas.ChatQuotationVersion.required.includes(field), 'Versions without a counter-offer remain readable')
}
assert.deepEqual(spec.components.schemas.ChatQuotationDiscount.properties.scope.enum, ['MATERIALS', 'DELIVERY'])
assert.equal(spec.components.schemas.ChatQuotationDiscount.additionalProperties, false)
assert.deepEqual(spec.components.schemas.ChatQuotationDiscount.required, ['scope', 'percent'])
const percent = new RegExp(spec.components.schemas.ChatQuotationDiscount.properties.percent.pattern)
for (const valid of ['0', '0.01', '20', '99.99', '100', '100.00']) assert.ok(percent.test(valid), valid)
for (const invalid of ['-1', '100.01', '1.001', '1e1', '101', '']) assert.ok(!percent.test(invalid), invalid)
assert.equal(spec.components.schemas.ChatQuotationContent.properties.discount.$ref, '#/components/schemas/ChatQuotationDiscountAssessment')
assert.ok(!spec.components.schemas.ChatQuotationContent.required.includes('discount'), 'Existing immutable versions still decode without a percentage assessment')
assert.deepEqual(spec.components.schemas.ChatQuotationDiscountAssessment.required, ['scope', 'percent', 'basis_centavos', 'deduction_centavos'])
assert.deepEqual(spec.components.schemas.ChatQuotationContent.properties.price_source.enum, ['PRIVATE_TRANSACTION'])
assert.deepEqual(Object.keys(spec.components.schemas.ChatIdentity.properties).sort(), ['avatar_path', 'display_name', 'role'])
assert.match(spec.components.schemas.ChatIdentity.properties.display_name.description, /Current public profile name/)
assert.match(spec.components.schemas.ChatIdentity.properties.role.description, /role recorded when the message was sent/)
assert.equal(spec.components.schemas.ChatQuotationLine.properties.specifications.additionalProperties.type, 'string')
for (const field of ['brand', 'variant_label', 'specifications']) assert.ok(!spec.components.schemas.ChatQuotationLine.required.includes(field), 'Older quotation snapshots remain readable')
assert.equal(spec.components.schemas.ChatQuotationMoney.properties.materials_gross_centavos.type, 'integer')
assert.ok(!Object.keys(spec.paths).some(p => p.includes('fulfillment-thread')), 'Phase 12 entry must remain disabled')
console.log(`Phase 9 contract passed: ${expected.size} authorized operations, private identity and immutable quotation schemas.`)

assert.equal(spec.components.schemas.ChatDraftContent.properties.nrpc.deprecated, true)
assert.match(spec.components.schemas.ChatDraftContent.properties.nrpc.description, /prohibited/)
assert.match(spec.components.schemas.VendorOrderPermissions.properties.can_set_nrpc.description, /COD or In-Store/)

assert.equal(spec.components.schemas.AutomatedResponseSettings.properties.options.maxItems, 3)
assert.ok(spec.components.schemas.AutomatedResponseSettings.required.includes('lock_version'))
assert.equal(spec.components.schemas.ChatQuotationVersion.properties.replaces_order_id.format, 'uuid')
assert.equal(spec.components.schemas.ChatAutomatedChoice.properties.option_index.maximum, 2)
assert.ok(spec.components.schemas.ConversationView.properties.needs_human_response)
assert.ok(spec.paths['/vendor/messaging/automated-response'].put.parameters.some(p => p.name === 'Idempotency-Key' && p.required))
assert.equal(spec.paths['/buyers/conversations/{conversationId}/automated-response'].post.operationId, 'chooseChatAutomatedResponse')
assert.equal(spec.paths['/vendor/conversations/{conversationId}/buyer-thread'].get.operationId, 'getVendorBuyerThread')
assert.equal(spec.paths['/vendor/conversations/{conversationId}/buyer-thread/contexts'].get.operationId, 'listVendorBuyerThreadContexts')
assert.equal(spec.components.schemas.ConversationDetail.properties.thread_contexts.maxItems, 61)
assert.equal(spec.components.schemas.ConversationDetail.properties.thread_authority.type, 'string')
assert.equal(spec.components.schemas.ConversationView.properties.buyer_thread_id.format, 'uuid')
for (const model of ['ChatMessage', 'ChatQuotationVersion']) assert.equal(spec.components.schemas[model].properties.conversation_id.format, 'uuid')
assert.ok(spec.components.schemas.ChatMessage.properties.kind.enum.includes('WORK_PACKAGE'))
assert.match(spec.components.schemas.ChatWorkPackageAttachment.properties.reference.description, /Vendor-scoped/)
assert.match(spec.components.schemas.ConversationView.properties.locked_reference.description, /only the store allocation/)
assert.equal(spec.components.schemas.ChatMessage.properties.work_package_attachment.$ref, '#/components/schemas/ChatWorkPackageAttachment')
assert.equal(spec.components.schemas.ChatId.properties.store_conversation_id.format, 'uuid')
assert.ok(spec.paths['/{messagingPortal}/conversations/{conversationId}'].get.parameters.some(p => p.name === 'store_thread' && p.schema.default === false))
assert.equal(spec.paths['/vendor/conversations/{conversationId}/buyer-thread/contexts'].get.deprecated, true)
for (const path of ['/buyers/conversations/{conversationId}/work-package-attachment', '/buyers/orders/{orderId}/work-package-message']) {
  assert.ok(spec.paths[path].post.parameters.some(p => p.name === 'Idempotency-Key' && p.required))
}
