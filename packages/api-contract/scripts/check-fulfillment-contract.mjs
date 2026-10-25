import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { spawnSync } from 'node:child_process'
import { fileURLToPath } from 'node:url'
import { createRequire } from 'node:module'
import { parse } from 'yaml'

// Phase 12 contract test: every documented fulfillment/cancellation/refund operation exists with the right transport
// and authorization middleware, every Phase 12 route is documented, retry-sensitive mutations require an
// Idempotency-Key, and the binding enums (refund states, remedies, reason codes, receipt sources) cannot drift.
const spec = parse(readFileSync(new URL('../openapi.yaml', import.meta.url), 'utf8'))
const routeFile = process.argv[2]
let routes
if (routeFile) {
  routes = JSON.parse(readFileSync(routeFile, 'utf8'))
} else {
  const result = spawnSync('php', ['artisan', 'route:list', '--json', '-v'], { cwd: fileURLToPath(new URL('../../../services/api/', import.meta.url)), encoding: 'utf8', timeout: 60000 })
  assert.equal(result.status, 0, 'Laravel route export must succeed')
  routes = JSON.parse(result.stdout)
}
const TAGS = { 'Buyer Fulfillment': 'BUYER', 'Vendor Fulfillment': 'VENDOR', 'Admin Order Operations': 'ADMIN' }
const expected = new Set()
for (const [path, methods] of Object.entries(spec.paths)) {
  for (const [method, operation] of Object.entries(methods)) {
    const tag = operation.tags?.find(value => value in TAGS)
    if (!tag) continue
    const uri = `api/v1${path.replace(/\{[^}]+\}/g, '{}')}`
    const key = `${method.toUpperCase()} ${uri}`
    expected.add(key)
    const actual = routes.find(route => route.uri.replace(/\{[^}]+\}/g, '{}') === uri && route.method.split('|').includes(method.toUpperCase()))
    assert.ok(actual, `Missing Laravel route ${key}`)
    const audience = TAGS[tag]
    const has = (...names) => names.some(name => actual.middleware.includes(name))
    assert.ok(has('auth:api', 'Illuminate\\Auth\\Middleware\\Authenticate:api') && has(`account.access:${audience}`, `App\\Http\\Middleware\\RequireAccountAccess:${audience}`), `${key} must authorize the ${audience}`)
    if (audience !== 'BUYER' && method !== 'get') assert.ok(has('App\\Http\\Middleware\\VerifyAccountCsrf'), `${key} must verify CSRF`)
    if (audience === 'BUYER') assert.deepEqual(operation.security, [{ passportBearer: [] }], `${key} uses the native Buyer bearer`)
    else assert.deepEqual(operation.security, [{ accessCookie: [], webCsrf: [] }], `${key} uses cookies with CSRF`)
    assert.ok(operation.responses['401'] && operation.responses['403'], `${key} documents authentication and authorization errors`)
    if (method === 'post' && !/reimbursements\/\{[^}]+\}\/confirm$/.test(path)) {
      assert.ok(operation.parameters?.some(p => p.name === 'Idempotency-Key' && p.required), `${key} requires an Idempotency-Key`)
    }
  }
}
const phaseTwelve = /^api\/v1\/(buyers\/orders\/\{[^}]+\}\/(cancellation-preview|cancel|cancellation-request|receipt|problems|reimbursements|files)|vendor\/orders\/\{[^}]+\}\/(fulfillment|problems|cancellation-preview|cancel|cancellation-request|refunds|reimbursements|files)|admin\/order-operations)/
for (const route of routes.filter(route => phaseTwelve.test(route.uri))) {
  for (const method of route.method.split('|').filter(method => method !== 'HEAD')) {
    assert.ok(expected.has(`${method} ${route.uri.replace(/\{[^}]+\}/g, '{}')}`), `Undocumented Phase 12 route ${method} ${route.uri}`)
  }
}
const s = spec.components.schemas
assert.deepEqual(s.RefundTimelineItem.properties.state.enum, ['REFUND_PENDING', 'REFUNDED', 'REFUND_FAILED'])
assert.deepEqual(s.RefundTimelineItem.properties.display_state.enum, ['QUEUED', 'INITIATED', 'PROCESSED', 'FAILED'], 'Initiation and success stay visibly different')
assert.deepEqual(s.RefundTimelineItem.properties.trigger.enum, ['CANCELLATION', 'DISPUTE_CONCLUSION', 'TECHNICAL_COMPENSATION', 'FEE_CREDIT'])
assert.deepEqual(s.AdminRefundRow.properties.target_type.enum, ['ORDER', 'PLATFORM_FEE'])
assert.deepEqual(s.ReimbursementTimelineItem.properties.state.enum, ['VENDOR_REIMBURSEMENT_PENDING', 'REIMBURSEMENT_CONFIRMED'])
assert.deepEqual(s.CancellationRemedy.properties.code.enum, ['REPORT_PROBLEM', 'DISPUTE', 'RETURN', 'WARRANTY', 'STATUTORY_REMEDIES'])
assert.deepEqual(s.BuyerCancelRequest.properties.reason_code.enum, ['CHANGE_OF_REQUIREMENT', 'DUPLICATE_ORDER', 'BUDGET_CHANGE', 'PROJECT_DELAY', 'SCHEDULE_CONFLICT', 'VENDOR_AGREEMENT', 'OTHER'])
assert.deepEqual(s.VendorCancelRequest.properties.reason_code.enum, ['STOCK_FAILURE', 'OPERATIONAL_INABILITY', 'DELIVERY_INABILITY', 'COMPLIANCE_RESTRICTION', 'ACCOUNT_RESTRICTION', 'BUYER_AGREEMENT', 'OTHER'])
assert.deepEqual(s.FulfillmentReceipt.properties.confirmation_source.enum, ['BUYER', 'AUTO_CONFIRMATION'])
assert.deepEqual(s.FulfillmentMilestoneForm.properties.milestone.enum, ['PROCESSING', 'READY_FOR_PICKUP', 'OUT_FOR_DELIVERY', 'DELIVERED', 'PICKED_UP'])
for (const forbidden of ['price_centavos', 'final_fee_centavos', 'delivery_centavos', 'vehicle_id', 'number_of_vehicles']) {
  assert.ok(!(forbidden in s.FulfillmentMilestoneForm.properties), `A milestone request never carries ${forbidden}`)
}
const fulfillmentFields = ['OrderFulfillment', 'FulfillmentStep', 'FulfillmentProof', 'FulfillmentTrip', 'FulfillmentArrangement', 'FulfillmentArrangementVehicle'].flatMap(name => Object.keys(s[name].properties))
assert.ok(!fulfillmentFields.some(field => /latitude|longitude|gps|position|location/i.test(field)), 'No live GPS, vehicle position or coordinates in the fulfillment view')
assert.ok(s.OrderDetail.properties.fulfillment && s.OrderDetail.properties.cancellation && s.OrderDetail.properties.refund_timeline)
assert.ok(s.OrderDetail.properties.available_actions.items.enum.includes('REPORT_PROBLEM') && s.OrderDetail.properties.available_actions.items.enum.includes('CONFIRM_RECEIPT'))
assert.ok(s.VendorOrderPermissions.properties.can_record_milestone && s.VendorOrderPermissions.properties.can_retry_refund)
assert.ok(s.ConversationView.properties.read_only && s.ConversationView.required.includes('read_only'))
assert.equal(s.FulfillmentThreadRef.properties.unread_count.type, 'integer')
assert.equal(s.FulfillmentThreadRef.properties.unread_count.minimum, 0)
assert.ok(spec.paths['/vendor/fulfillment'].get.operationId === 'listAssignedFulfillments')
const buyerPhoto = spec.paths['/vendor/orders/{orderId}/fulfillment/buyer-photo'].get
assert.equal(buyerPhoto.operationId, 'getDeliveryBuyerPhoto')
assert.match(buyerPhoto.description, /current active assigned Fulfillment Staff/)
assert.match(buyerPhoto.description, /Reauthorizes after private storage access/)
assert.match(buyerPhoto.description, /closure, reassignment or deactivation revokes access/)
assert.match(buyerPhoto.description, /private and no-store/)
assert.equal(buyerPhoto.responses['200'].content['image/png'].schema.format, 'binary')
assert.deepEqual(s.OrderBuyerRef.properties.mobile_e164.type, ['string', 'null'])
assert.deepEqual(s.OrderBuyerRef.properties.avatar_path.type, ['string', 'null'])
assert.match(s.OrderBuyerRef.properties.mobile_e164.description, /Other roles and closed\/pickup orders receive null/)
for (const field of ['email', 'user_id', 'profile_photo_key', 'profile_photo_disk']) assert.ok(!(field in s.OrderBuyerRef.properties), `Delivery contact never includes ${field}`)
const require = createRequire(import.meta.url)
for (const field of ['refunds_total', 'reimbursements_total']) {
  assert.ok(s.AdminOrderOperationsSummary.required.includes(field), `Admin summary requires ${field}`)
  assert.equal(s.AdminOrderOperationsSummary.properties[field].type, 'integer')
  assert.equal(s.AdminOrderOperationsSummary.properties[field].minimum, 0)
}
const { AdminOrderOperationsSummaryFromJSON, AdminOrderOperationsSummaryToJSON } = require('../generated/typescript/dist/models/AdminOrderOperationsSummary.js')
const summaryWire = { refunds_total: 33, refunds_failed: 0, refunds_pending: 0, reimbursements_total: 4, reimbursements_pending: 0, cancellation_requests_open: 0, nfr_events_30_days: 1 }
const summaryModel = AdminOrderOperationsSummaryFromJSON(summaryWire)
assert.equal(summaryModel.refundsTotal, 33, 'Refund total includes processed records beyond one page')
assert.equal(summaryModel.reimbursementsTotal, 4, 'Reimbursement total includes confirmed records')
assert.deepEqual(AdminOrderOperationsSummaryToJSON(summaryModel), summaryWire, 'Generated summary counts round-trip without replacing totals with exceptions')
const { OrderBuyerRefFromJSON, OrderBuyerRefToJSON } = require('../generated/typescript/dist/models/OrderBuyerRef.js')
for (const wire of [
  { display_name: 'Sample Buyer' },
  { display_name: 'Sample Buyer', mobile_e164: null, avatar_path: null },
  { display_name: 'Sample Buyer', mobile_e164: '+639170000001', avatar_path: '/vendor/orders/019c6e27-e55b-73d1-87d8-4e01f1f75043/fulfillment/buyer-photo?version=2' },
]) {
  const model = OrderBuyerRefFromJSON(wire)
  assert.equal(model.mobileE164, wire.mobile_e164)
  assert.equal(model.avatarPath, wire.avatar_path)
  assert.deepEqual(JSON.parse(JSON.stringify(OrderBuyerRefToJSON(model))), wire, 'Generated TS contact serialization must retain optional contact fields')
}
assert.ok(spec.paths['/vendor/orders/{orderId}/fulfillment/route'].get.description.includes('No') || spec.paths['/vendor/orders/{orderId}/fulfillment/route'].get.description.includes('no live'))
assert.equal(s.FulfillmentAssignmentRequest.properties.dispatch.type, 'boolean')
assert.equal(s.FulfillmentAssignmentRequest.properties.lock_version.minimum, 1)
const assignmentOperation = spec.paths['/vendor/orders/{orderId}/fulfillment/assignment'].post
const milestoneOperation = spec.paths['/vendor/orders/{orderId}/fulfillment/milestones'].post
assert.match(assignmentOperation.description, /dispatch=true.*assignment and Out for Delivery commit atomically.*vehicle_index and lock_version/)
assert.match(assignmentOperation.description, /order appears in the assigned staff workspace/)
assert.match(milestoneOperation.description, /DELIVERED is restricted to the currently assigned active Fulfillment Staff/)
assert.match(milestoneOperation.description, /Owner or Store Manager attempts return 403 PERMISSION_DENIED before proof storage/)
assert.match(milestoneOperation.description, /Self-Pickup handover rules are unchanged/)
assert.ok(milestoneOperation.responses['403'], 'Owner/Manager delivery attempts document permission denial')
assert.match(s.FulfillmentMilestoneForm.description, /DELIVERED is restricted to the currently assigned active Fulfillment Staff and requires receiver_name plus file/)
assert.match(s.FulfillmentMilestoneForm.description, /signature and additional photos are optional/)
assert.equal(s.FulfillmentMilestoneForm.properties.additional_photos.maxItems, 3)
assert.ok(s.FulfillmentAssignment.properties.vehicle && s.FulfillmentAssignment.properties.acknowledged_at)
for (const field of ['fee_centavos', 'final_fee_centavos', 'vehicle_id', 'number_of_vehicles']) assert.ok(!(field in s.FulfillmentAssignmentRequest.properties))
assert.match(spec.info.version, /(?:phase\.(1[2-9]|20)|audit\.2026-10-24)$/)
console.log(`Fulfillment contract passed: ${expected.size} operations, transports, idempotency and FIN-07 enums`)
