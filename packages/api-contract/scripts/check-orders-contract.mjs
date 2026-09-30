import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { spawnSync } from 'node:child_process'
import { fileURLToPath } from 'node:url'
import { resolve } from 'node:path'
import { parse } from 'yaml'

// Phase 8 contract: every Buyer checkout/order and Vendor order route matches OpenAPI in both directions, runs on the
// right transport with the right account guard, requires Idempotency-Key for retry-sensitive mutations, and the schemas
// keep the order, money, NRPC, delivery-privacy and state-family invariants intact.
const root = fileURLToPath(new URL('../', import.meta.url))
const source = readFileSync(resolve(root, 'openapi.yaml'), 'utf8')
const spec = parse(source)
assert.ok(!/enum: \[[^\]]*(?<![\w'"])(NO|YES|ON|OFF)(?![\w'"])[^\]]*\]/.test(source), 'Quote NO/YES/ON/OFF enum values so generated clients keep them as strings')
let routes
if (process.argv[2]) routes = JSON.parse(readFileSync(process.argv[2], 'utf8').replace(/^﻿/, ''))
else {
  const result = spawnSync('php', ['artisan', 'route:list', '--json', '--path=api/v1'], { cwd: resolve(root, '../../services/api'), encoding: 'utf8', timeout: 60000 })
  assert.equal(result.status, 0, 'Laravel route export failed; provide an isolated route:list --json export as the first argument.')
  routes = JSON.parse(result.stdout)
}

const buyerPattern = / \/api\/v1\/buyers\/(checkouts|orders)/
const vendorPattern = / \/api\/v1\/vendor\/orders/
const actual = new Map(routes.flatMap(route => route.method.split('|').filter(method => method !== 'HEAD').map(method => [`${method} /${route.uri}`, route])))
const has = (route, ...names) => names.some(name => route.middleware.includes(name))
const normalize = path => path.replace(/\{[^}]+\}/g, '{}')
const expected = new Set()

for (const [path, item] of Object.entries(spec.paths)) {
  for (const [method, operation] of Object.entries(item)) {
    if (!['get', 'post', 'put', 'patch', 'delete'].includes(method)) continue
    const key = `${method.toUpperCase()} /api/v1${path}`
    const buyer = buyerPattern.test(key)
    const vendor = vendorPattern.test(key)
    if (!buyer && !vendor) continue
    expected.add(normalize(key))
    const route = [...actual.entries()].find(([candidate]) => normalize(candidate) === normalize(key))?.[1]
    assert.ok(route, `Laravel route missing for OpenAPI operation ${operation.operationId}: ${key}`)
    assert.ok(has(route, 'auth:api', 'Illuminate\\Auth\\Middleware\\Authenticate:api'), `Passport guard missing: ${key}`)
    if (buyer) {
      assert.ok(has(route, 'auth.transport:MOBILE', 'App\\Http\\Middleware\\SetAuthTransport:MOBILE'), `Native Buyer transport missing: ${key}`)
      assert.ok(has(route, 'account.access:BUYER', 'App\\Http\\Middleware\\RequireAccountAccess:BUYER'), `Buyer-only access missing: ${key}`)
      assert.deepEqual(operation.security, [{ passportBearer: [] }], `${operation.operationId} must use the native bearer transport only`)
    } else {
      assert.ok(has(route, 'auth.transport:WEB', 'App\\Http\\Middleware\\SetAuthTransport:WEB'), `Vendor web transport missing: ${key}`)
      assert.ok(has(route, 'account.access:VENDOR', 'App\\Http\\Middleware\\RequireAccountAccess:VENDOR'), `Vendor-only access missing: ${key}`)
      if (method !== 'get') {
        assert.ok(has(route, 'App\\Http\\Middleware\\VerifyAccountCsrf'), `CSRF missing on Vendor mutation: ${key}`)
        assert.deepEqual(operation.security, [{ accessCookie: [], webCsrf: [] }], `${operation.operationId} must require the cookie and CSRF`)
      }
    }
    assert.ok(operation.responses['401'] && operation.responses['403'], `${operation.operationId} must document unauthenticated and denied responses`)
    if (method === 'post' && !path.endsWith('/delivery-recommendations')) {
      assert.ok((operation.parameters ?? []).some(parameter => parameter.name === 'Idempotency-Key' && parameter.required), `${operation.operationId} requires Idempotency-Key`)
      assert.ok(operation.responses['409'], `${operation.operationId} must document the conflict response`)
    }
    for (const response of Object.values(operation.responses)) {
      const reference = response.content?.['application/json']?.schema?.$ref
      if (response.content?.['application/json']) assert.ok(reference && spec.components.schemas[reference.split('/').at(-1)], `${operation.operationId} references an unknown response envelope`)
    }
  }
}
for (const key of actual.keys()) {
  if (buyerPattern.test(key) || vendorPattern.test(key)) assert.ok(expected.has(normalize(key)), `Laravel Phase 8 route missing from OpenAPI: ${key}`)
}

const schemas = spec.components.schemas
assert.deepEqual(schemas.OrderState.enum, ['AWAITING_VENDOR_CONFIRMATION', 'AWAITING_BUYER_APPROVAL', 'AWAITING_NRPC_ACCEPTANCE', 'AWAITING_PAYMENT', 'CONFIRMED', 'PROCESSING', 'READY_FOR_PICKUP', 'OUT_FOR_DELIVERY', 'DELIVERED', 'PICKED_UP', 'COMPLETED', 'CANCELLATION_REQUESTED', 'DECLINED', 'EXPIRED', 'CANCELLED', 'DISPUTED'], 'Canonical order states only')
assert.deepEqual(schemas.OrderPaymentState.enum, ['NOT_REQUIRED', 'PENDING', 'PAID', 'FAILED', 'EXPIRED'])
assert.deepEqual(schemas.OrderStateRow.properties.family.enum, ['ORDER', 'PAYMENT', 'FULFILLMENT', 'REFUND', 'DISPUTE'], 'Five independent state families')
assert.equal(schemas.MoneyNrpc.properties.within_order_value.const, true, 'NRPC is part of the order value')
assert.deepEqual(schemas.MoneyBreakdown.properties.excludes.items.enum, ['VENDOR_COMMISSION', 'MERCHANT_WITHHOLDING'], 'Commission and withholding are never Buyer charges')
for (const field of ['commission_centavos', 'withholding_centavos', 'fee_assessment', 'earned_centavos']) {
  assert.equal(schemas.MoneyBreakdown.properties[field], undefined, `MoneyBreakdown must not expose ${field}`)
}
assert.deepEqual(schemas.ProcessingFee.properties.status.enum, ['PENDING_PAYMENT_CHANNEL', 'QUOTED', 'NOT_APPLICABLE'])
assert.equal(schemas.NrpcAcceptRequest.properties.acknowledged.const, true, 'NRPC acceptance is explicit')
assert.ok(schemas.NrpcAcceptRequest.required.includes('terms_version_id'), 'NRPC acceptance names the Terms version shown')
assert.equal(schemas.NrpcProposal.properties.amount_centavos.maximum, undefined, 'There is no platform-wide NRPC cap')
assert.ok(schemas.NrpcFlagRequest.required.includes('reason'))
assert.equal(schemas.NrpcFlagRequest.properties.acknowledged, undefined, 'A flag never accepts')
for (const schema of ['OrderPoint', 'OrderDestination', 'OrderConfirmedDelivery', 'DeliveryPlanEndpoint']) {
  for (const field of ['latitude', 'longitude', 'location', 'coordinates']) {
    assert.equal(schemas[schema].properties[field], undefined, `${schema} must not expose Buyer coordinates (${field})`)
  }
}
for (const schema of ['OrderSummary', 'CheckoutChildOrder', 'MoneyBreakdown']) {
  for (const field of ['quantity_on_hand', 'hard_reserved_quantity', 'available_to_sell']) {
    assert.equal(schemas[schema].properties[field], undefined, `${schema} must not expose exact inventory (${field})`)
  }
}
assert.match(schemas.OrderLineInventory.description, /Vendor roles only/, 'Line inventory is Vendor-only')
assert.deepEqual(schemas.OrderDestination.properties.vehicle_endpoint.enum, ['INTENDED_LOCATION', 'ALTERNATE_DROP_OFF', null], 'The actual drop-off is named separately from the intended site')
assert.equal(schemas.OrderDeadlines.properties.timezone.const, 'Asia/Manila')
assert.deepEqual(schemas.VendorOrderPrimaryAction.enum, ['CONFIRM', 'WAITING_FOR_BUYER', 'WAITING_FOR_PAYMENT', 'PREPARE_WHEN_AVAILABLE', 'NONE'], 'One primary action per state')
assert.equal(schemas.DeliveryPlan.properties.advisory.const, true, 'A delivery plan is advisory only')
for (const request of ['CheckoutSubmitRequest', 'OrderRevisionDecision', 'NrpcAcceptRequest', 'NrpcRejectRequest', 'NrpcFlagRequest', 'VendorOrderConfirmRequest', 'VendorOrderDeclineRequest', 'DeliveryPlanRequest', 'NrpcProposal', 'DeliveryConfirmation']) {
  assert.equal(schemas[request].additionalProperties, false, `${request} rejects undocumented fields`)
  for (const field of ['buyer_profile_id', 'organization_id', 'vendor_organization_id', 'order_state', 'payment_state', 'confirmation_source', 'unit_price_centavos', 'auto_accept']) {
    assert.equal(schemas[request].properties[field], undefined, `${request} must not accept ${field}`)
  }
}
assert.ok(schemas.InventorySettings.required.includes('auto_accept_ready_lead_days'), 'Inventory settings expose the auto-accept ready lead time')
console.log('Phase 8 orders contract: OK')
