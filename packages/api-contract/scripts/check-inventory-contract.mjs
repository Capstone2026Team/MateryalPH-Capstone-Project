import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { spawnSync } from 'node:child_process'
import { fileURLToPath } from 'node:url'
import { resolve } from 'node:path'
import { parse } from 'yaml'

// Phase 5 contract: every inventory, auto-accept and fleet route matches OpenAPI in both directions,
// carries its authorization guards, and keeps the stock, money and auto-accept invariants intact.
const root = fileURLToPath(new URL('../', import.meta.url))
const spec = parse(readFileSync(resolve(root, 'openapi.yaml'), 'utf8'))
let routes
if (process.argv[2]) routes = JSON.parse(readFileSync(process.argv[2], 'utf8').replace(/^﻿/, ''))
else {
  const result = spawnSync('php', ['artisan', 'route:list', '--json', '--path=api/v1'], { cwd: resolve(root, '../../services/api'), encoding: 'utf8', timeout: 60000 })
  assert.equal(result.status, 0, 'Laravel route export failed; provide an isolated route:list --json export as the first argument.')
  routes = JSON.parse(result.stdout)
}

const pattern = / \/api\/v1\/(vendor\/inventory|vendor\/auto-accept|vendor\/fleet|fleet-files)/
const actual = new Map(routes.flatMap(route => route.method.split('|').filter(method => method !== 'HEAD').map(method => [`${method} /${route.uri}`, route])))
const hasMiddleware = (route, ...names) => names.some(name => route.middleware.includes(name))
const normalize = path => path.replace(/\{[^}]+\}/g, '{}')
const expected = new Set()

for (const [path, item] of Object.entries(spec.paths)) {
  for (const [method, operation] of Object.entries(item)) {
    if (!['get', 'post', 'put', 'patch', 'delete'].includes(method)) continue
    const key = `${method.toUpperCase()} /api/v1${path}`
    if (!pattern.test(key)) continue
    expected.add(normalize(key))
    const route = [...actual.entries()].find(([candidate]) => normalize(candidate) === normalize(key))?.[1]
    assert.ok(route, `Laravel route missing for OpenAPI operation ${operation.operationId}: ${key}`)
    assert.ok(hasMiddleware(route, 'auth:api', 'Illuminate\\Auth\\Middleware\\Authenticate:api'), `Passport guard missing: ${key}`)
    assert.ok(hasMiddleware(route, 'auth.transport:WEB', 'App\\Http\\Middleware\\SetAuthTransport:WEB'), `Transport guard missing: ${key}`)
    const stream = path === '/fleet-files/{fileId}/content'
    assert.ok(stream
      ? hasMiddleware(route, 'account.access', 'App\\Http\\Middleware\\RequireAccountAccess') && hasMiddleware(route, 'signed', 'Illuminate\\Routing\\Middleware\\ValidateSignature')
      : hasMiddleware(route, 'account.access:VENDOR', 'App\\Http\\Middleware\\RequireAccountAccess:VENDOR'), `Vendor portal authorization missing: ${key}`)
    if (!stream) assert.ok(hasMiddleware(route, 'web.csrf', 'App\\Http\\Middleware\\VerifyAccountCsrf'), `Web CSRF guard missing: ${key}`)
    if (method !== 'get') assert.ok(operation.security?.some(requirement => 'webCsrf' in requirement), `${operation.operationId} must declare webCsrf security`)
    for (const response of Object.values(operation.responses)) {
      const reference = response.content?.['application/json']?.schema?.$ref
      if (response.content?.['application/json']) assert.ok(reference && spec.components.schemas[reference.split('/').at(-1)], `${operation.operationId} references an unknown response envelope`)
    }
    if (method !== 'get' && !stream) assert.ok(operation.responses['403'], `${operation.operationId} must document the denied-role response`)
  }
}
for (const key of actual.keys()) {
  if (pattern.test(key)) assert.ok(expected.has(normalize(key)), `Laravel Phase 5 route missing from OpenAPI: ${key}`)
}

assert.ok(spec.paths['/vendor/auto-accept/policies/{variantId}/resume'].post.parameters.some(parameter => parameter.name === 'Idempotency-Key' && parameter.required), 'Resume must require Idempotency-Key')
for (const [path, method] of [['/vendor/inventory/items/{variantId}', 'patch'], ['/vendor/inventory/confirmations', 'post'], ['/vendor/fleet/vehicles', 'put'], ['/vendor/auto-accept/policies/{variantId}', 'put'], ['/vendor/auto-accept/policies/{variantId}/resume', 'post']]) {
  assert.ok(spec.paths[path][method].responses['409'], `${path} ${method} must document the stale-version conflict`)
}

const schemas = spec.components.schemas
assert.deepEqual(schemas.StockLabel.enum, ['IN_STOCK', 'LIMITED_STOCK', 'OUT_OF_STOCK'], 'Buyers receive only three stock labels')
assert.deepEqual(schemas.CatalogListingSummary.properties.public_availability.enum, schemas.StockLabel.enum)
assert.deepEqual(schemas.CatalogVariant.properties.public_availability.enum, schemas.StockLabel.enum)
assert.deepEqual(schemas.AutoAcceptStatus.enum, ['DISABLED', 'ACTIVE', 'PAUSED'])
assert.ok(schemas.InventoryRowUpdate.required.includes('lock_version'), 'Manual edits carry an optimistic version')
assert.ok(schemas.InventoryPriceChange.required.includes('expected_price_version_id'), 'Price edits name the version they replace')
assert.ok(schemas.AutoAcceptResume.required.includes('confirmed_allotment_quantity'), 'Resume names the restored allotment')
assert.equal(schemas.AutoAcceptPolicyConfigure.properties.allotment_quantity.pattern, '^\\d{1,14}$', 'Allotment is a whole number')
assert.equal(schemas.AutoAcceptPolicyConfigure.properties.status, undefined, 'Clients never submit an auto-accept status')
assert.equal(schemas.AutoAcceptPolicyConfigure.properties.procurement_type, undefined, 'Policies never widen to Project-Based procurement')
assert.equal(schemas.AutoAcceptPolicyDetail.properties.scope.properties.project_based_excluded.const, true)
assert.equal(schemas.AutoAcceptPolicyDetail.properties.scope.properties.nrpc_excluded.const, true)
for (const [schema, field] of [['InventoryPriceChange', 'amount_centavos'], ['AutoAcceptPolicyConfigure', 'max_order_amount_centavos'], ['FleetVehicleInput', 'base_fee_centavos'], ['FleetVehicleInput', 'per_km_centavos']]) {
  assert.ok([schemas[schema].properties[field].type].flat().includes('integer'), `${schema}.${field} must be integer centavos`)
}
assert.equal(schemas.FleetVehicleInput.properties.number_available.minimum, 1)
for (const envelope of ['InventoryLedgerEnvelope', 'InventoryRowEnvelope', 'AutoAcceptPolicyDetailEnvelope', 'FleetVehicleListEnvelope']) {
  assert.deepEqual(schemas[envelope].required, ['data', 'meta', 'errors'], `${envelope} uses the canonical envelope`)
}
for (const publicSchema of ['CatalogListingSummary', 'StaleListing', 'PriceHistoryEntry']) {
  for (const field of ['quantity_on_hand', 'hard_reserved_quantity', 'soft_held_quantity', 'available_to_sell']) {
    assert.equal(schemas[publicSchema].properties[field], undefined, `${publicSchema} must not expose ${field}`)
  }
}

console.log(`Phase 5 inventory contract passed: ${expected.size} inventory, auto-accept and fleet operations match Laravel routes and guards.`)
