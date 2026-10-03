import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { spawnSync } from 'node:child_process'
import { fileURLToPath } from 'node:url'
import { resolve } from 'node:path'
import { parse } from 'yaml'

// Phase 6 contract: every Buyer location/discovery route matches OpenAPI in both directions, is Buyer-only on
// the native bearer transport, and the public schemas keep Tier 1, privacy and radius invariants intact.
const root = fileURLToPath(new URL('../', import.meta.url))
const spec = parse(readFileSync(resolve(root, 'openapi.yaml'), 'utf8'))
let routes
if (process.argv[2]) routes = JSON.parse(readFileSync(process.argv[2], 'utf8').replace(/^﻿/, ''))
else {
  const result = spawnSync('php', ['artisan', 'route:list', '--json', '--path=api/v1'], { cwd: resolve(root, '../../services/api'), encoding: 'utf8', timeout: 60000 })
  assert.equal(result.status, 0, 'Laravel route export failed; provide an isolated route:list --json export as the first argument.')
  routes = JSON.parse(result.stdout)
}

const pattern = / \/api\/v1\/buyers\/(onboarding|discovery|geography|locations|favorite-suppliers)/
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
    assert.ok(hasMiddleware(route, 'auth.transport:MOBILE', 'App\\Http\\Middleware\\SetAuthTransport:MOBILE'), `Native Buyer transport missing: ${key}`)
    assert.ok(hasMiddleware(route, 'account.access:BUYER', 'App\\Http\\Middleware\\RequireAccountAccess:BUYER'), `Buyer-only access missing: ${key}`)
    assert.deepEqual(operation.security, [{ passportBearer: [] }], `${operation.operationId} must use the native bearer transport only`)
    assert.ok(operation.responses['401'] && operation.responses['403'], `${operation.operationId} must document unauthenticated and denied responses`)
    for (const response of Object.values(operation.responses)) {
      const reference = response.content?.['application/json']?.schema?.$ref
      if (response.content?.['application/json']) assert.ok(reference && spec.components.schemas[reference.split('/').at(-1)], `${operation.operationId} references an unknown response envelope`)
    }
  }
}
for (const key of actual.keys()) {
  if (pattern.test(key)) assert.ok(expected.has(normalize(key)), `Laravel Phase 6 route missing from OpenAPI: ${key}`)
}

const operation = (path, method) => spec.paths[path][method]
assert.ok(operation('/buyers/locations', 'post').parameters.some(parameter => parameter.name === 'Idempotency-Key' && parameter.required), 'Saving a location requires Idempotency-Key')
for (const [path, method] of [['/buyers/locations/{locationId}', 'patch'], ['/buyers/locations/{locationId}', 'delete'], ['/buyers/locations/{locationId}/primary', 'post'], ['/buyers/onboarding', 'put']]) {
  assert.ok(operation(path, method).responses['409'], `${path} ${method} must document the stale-version conflict`)
}
for (const [path, method] of [['/buyers/discovery/routes', 'post'], ['/buyers/discovery/directory-suppliers/{supplierId}', 'get'], ['/buyers/discovery/directory-suppliers/{supplierId}/photo', 'get'], ['/buyers/locations/resolve', 'post']]) {
  assert.ok(operation(path, method).responses['503'], `${path} ${method} must document provider unavailability`)
}
assert.equal(spec.paths['/buyers/discovery/search'].get, undefined, 'Discovery origins travel in a request body, never a URL')

const schemas = spec.components.schemas
assert.deepEqual(schemas.RadiusKm.enum, [5, 10, 20, 30, 40, 50], 'Radius allowlist is exact')
assert.deepEqual(schemas.ScoreLabel.properties.kind.enum, ['VPS', 'NEW_VENDOR', 'DIRECTORY'], 'Marker labels are VPS, New Vendor or Directory only')
assert.deepEqual(schemas.SupplierTier.enum, ['VERIFIED_VENDOR', 'DIRECTORY_SUPPLIER'])
assert.equal(schemas.DirectorySupplierDetail.additionalProperties, false, 'Tier 1 details are a closed allowlist')
for (const forbidden of ['vps', 'score_label', 'vendor', 'listings', 'message', 'order', 'review', 'payment', 'storefront', 'verified', 'is_favorite']) {
  assert.equal(schemas.DirectorySupplierDetail.properties[forbidden], undefined, `Tier 1 details must not expose ${forbidden}`)
}
assert.deepEqual(schemas.DirectorySupplierDetail.properties.actions.items.enum, ['CALL', 'OPEN_IN_MAPS', 'WEBSITE', 'SHARE'], 'Tier 1 actions are informational only')
assert.equal(schemas.DirectorySupplierDetail.properties.reviews.items.$ref, '#/components/schemas/GooglePlaceReview', 'Directory reviews are attributed Google data only')
assert.ok(schemas.GooglePlaceReview.required.includes('author'))
assert.ok(schemas.GooglePlacePhoto.required.includes('authors'))
assert.equal(schemas.DirectorySupplierPhoto.properties.photos.maxItems, 1)
assert.equal(schemas.DirectorySupplierPhoto.additionalProperties, false)
assert.deepEqual(schemas.GoogleRating.properties.source.enum, ['GOOGLE'], 'A Google rating is always attributed to Google')
for (const scopeField of ['latitude', 'longitude', 'origin_latitude', 'origin_longitude']) {
  assert.equal(schemas.DiscoveryScope.properties[scopeField], undefined, `Discovery scope must not echo ${scopeField}`)
}
for (const request of ['DiscoverySearchRequest', 'RouteEstimateRequest']) {
  for (const field of ['vendor_id', 'organization_id', 'competitor_id', 'store_id']) {
    assert.equal(schemas[request].properties[field], undefined, `${request} must not accept ${field}`)
  }
  assert.equal(schemas[request].additionalProperties, false, `${request} rejects undocumented fields`)
}
assert.ok(schemas.SupplierResult.properties.distance_meters.description.includes('straight-line'), 'Result distance is geodesic, not route distance')
assert.ok(schemas.RadiusExpansion.required.includes('requires_confirmation'), 'Expansion is a confirmed suggestion')
assert.ok(schemas.RouteEstimate.required.includes('request_version') && schemas.RouteEstimate.required.includes('origin_version'), 'Routes echo stale-response guards')
for (const publicSchema of ['PublicStoreProfile', 'PublicStoreSummary', 'SupplierResult', 'VerifiedVendorSummary', 'FavoriteSupplier']) {
  for (const privateField of ['legal_name', 'registered_name', 'legal_business_name', 'store_email', 'tin', 'taxpayer_key_hash', 'identity_id_number_last4', 'provider_account_id', 'site_instructions']) {
    assert.equal(schemas[publicSchema].properties[privateField], undefined, `${publicSchema} must not expose ${privateField}`)
  }
}
assert.deepEqual(schemas.PsgcResolution.properties.resolution.enum, ['RESOLVED', 'PARTIAL', 'UNRESOLVED'])
assert.deepEqual(schemas.BuyerIndustryClassification.enum, ['GENERAL_CONTRACTOR', 'SUBCONTRACTOR_TRADE', 'INDEPENDENT_BUILDER', 'DIY_HOMEOWNER', 'OTHER'])
for (const envelope of ['DiscoverySearchEnvelope', 'DirectorySupplierPhotoEnvelope', 'DirectorySupplierDetailEnvelope', 'RouteEstimateEnvelope', 'BuyerLocationEnvelope', 'BuyerLocationListEnvelope', 'BuyerOnboardingEnvelope', 'FavoriteSupplierListEnvelope', 'PsgcAreaListEnvelope']) {
  assert.deepEqual(schemas[envelope].required, ['data', 'meta', 'errors'], `${envelope} uses the canonical envelope`)
}

console.log(`Phase 6 geography contract passed: ${expected.size} Buyer location and discovery operations match Laravel routes and guards.`)
