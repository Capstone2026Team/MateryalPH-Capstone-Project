import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { spawnSync } from 'node:child_process'
import { fileURLToPath } from 'node:url'
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
assert.match(spec.info.version, /phase\.12$/)
console.log(`Fulfillment contract passed: ${expected.size} operations, transports, idempotency and FIN-07 enums`)
