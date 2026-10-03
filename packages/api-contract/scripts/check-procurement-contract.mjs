import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { spawnSync } from 'node:child_process'
import { fileURLToPath } from 'node:url'
import { resolve } from 'node:path'
import { parse } from 'yaml'

// Phase 7 contract: every Buyer Explore/search/preference/cart route matches OpenAPI in both directions, is Buyer-only
// on the native bearer transport, and the schemas keep the ranking, stock, money and delivery invariants intact.
const root = fileURLToPath(new URL('../', import.meta.url))
const source = readFileSync(resolve(root, 'openapi.yaml'), 'utf8')
const spec = parse(source)
// The Java client generators read YAML 1.1, where a bare NO/YES/ON/OFF is a boolean; enum values must be quoted.
assert.ok(!/enum: \[[^\]]*(?<![\w'"])(NO|YES|ON|OFF)(?![\w'"])[^\]]*\]/.test(source), 'Quote NO/YES/ON/OFF enum values so generated clients keep them as strings')
let routes
if (process.argv[2]) routes = JSON.parse(readFileSync(process.argv[2], 'utf8').replace(/^﻿/, ''))
else {
  const result = spawnSync('php', ['artisan', 'route:list', '--json', '--path=api/v1'], { cwd: resolve(root, '../../services/api'), encoding: 'utf8', timeout: 60000 })
  assert.equal(result.status, 0, 'Laravel route export failed; provide an isolated route:list --json export as the first argument.')
  routes = JSON.parse(result.stdout)
}

const pattern = / \/api\/v1\/buyers\/(explore|listings|ranking-preferences|cart)/
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
  if (pattern.test(key)) assert.ok(expected.has(normalize(key)), `Laravel Phase 7 route missing from OpenAPI: ${key}`)
}

const operation = (path, method) => spec.paths[path][method]
assert.ok(operation('/buyers/cart/items', 'post').parameters.some(parameter => parameter.name === 'Idempotency-Key' && parameter.required), 'Adding to the cart requires Idempotency-Key')
for (const [path, method] of [['/buyers/cart/items/{itemId}', 'patch'], ['/buyers/cart/items/{itemId}', 'delete'], ['/buyers/cart/vendor-groups/{vendorId}/fulfillment', 'put'], ['/buyers/cart/destination', 'put'], ['/buyers/ranking-preferences/item-based', 'put'], ['/buyers/ranking-preferences/item-based', 'delete']]) {
  assert.ok(operation(path, method).responses['409'], `${path} ${method} must document the stale-version conflict`)
}
for (const path of ['/buyers/explore/summary', '/buyers/listings/search', '/buyers/listings/{listingId}/details']) {
  assert.equal(spec.paths[path].get, undefined, `${path}: origins travel in a request body, never a URL`)
}

const schemas = spec.components.schemas
assert.deepEqual(schemas.RankingWeightSet.required, ['distance', 'price', 'vps', 'stock', 'product_rating'], 'SRS has exactly five components')
assert.equal(schemas.RankingWeightSet.additionalProperties, false, 'No hidden or sponsored ranking component can be submitted')
assert.equal(schemas.RankingPreferences.properties.total_percent.const, 100, 'Weights always total 100%')
assert.deepEqual(schemas.ListingSearchSort.enum, ['BEST_DEAL', 'DISTANCE', 'PRICE', 'RATING', 'FAVORITES_FIRST', 'DISTANCE_DESC', 'PRICE_DESC', 'RATING_ASC'], 'Favorites First is a separate explicit sort')
assert.deepEqual(schemas.ListingSearchResult.properties.stock_label.enum, ['IN_STOCK', 'LIMITED_STOCK'], 'Out of Stock offers never appear as results')
assert.deepEqual(schemas.ListingSearchResult.properties.badges.items.enum, ['BEST_PRICE', 'PS_ICC_VERIFIED'], 'Result badges are system-derived only; Favorite is never a badge')
assert.deepEqual(schemas.RankingComponent.properties.key.enum, ['distance', 'price', 'vps', 'stock', 'product_rating'])
for (const schema of ['ListingSearchResult', 'ListingVariantOffer', 'CartLine', 'CartLineCurrent', 'ListingDetails', 'ExploreSummary', 'ExploreCounts']) {
  for (const privateField of ['quantity_on_hand', 'hard_reserved_quantity', 'soft_held_quantity', 'available_to_sell', 'available', 'reorder_level']) {
    if (schema === 'ListingVariantOffer' && privateField === 'available') continue // Boolean "currently offered", never a quantity.
    assert.equal(schemas[schema].properties[privateField], undefined, `${schema} must not expose exact inventory (${privateField})`)
  }
}
assert.equal(schemas.ListingVariantOffer.properties.available.type, 'boolean', 'Variant availability is a boolean, never a quantity')
for (const request of ['ListingSearchRequest', 'BuyerOriginRequest', 'CartItemCreate', 'CartItemUpdate', 'CartDestinationUpdate', 'RankingPreferencesUpdate', 'CheckoutPreviewRequest']) {
  assert.equal(schemas[request].additionalProperties, false, `${request} rejects undocumented fields`)
  for (const field of ['buyer_profile_id', 'buyer_id', 'user_id', 'organization_id', 'competitor_id']) {
    assert.equal(schemas[request].properties[field], undefined, `${request} must not accept ${field}`)
  }
}
for (const scopeField of ['latitude', 'longitude']) assert.equal(schemas.DiscoveryScope.properties[scopeField], undefined, 'Scopes never echo the origin')
assert.deepEqual(schemas.ExploreSummary.properties.count_scope.enum, ['ALL_CATEGORIES_AT_LOCATION_RADIUS'], 'Explore counts are scoped before category filters')
assert.ok(schemas.ExploreSummary.required.includes('current_as_of'), 'Explore returns one snapshot time')
assert.ok(schemas.ExploreSummary.required.includes('materials_analytics'), 'Materials Analytics availability is explicit')
assert.deepEqual(schemas.FinancialPreview.properties.excludes.items.enum, ['VENDOR_COMMISSION', 'MERCHANT_WITHHOLDING'], 'Buyer totals never include commission or withholding')
for (const field of ['commission_centavos', 'withholding_centavos', 'cwt_centavos', 'platform_fee_centavos']) {
  assert.equal(schemas.FinancialPreview.properties[field], undefined, `Buyer preview must not carry ${field}`)
}
assert.equal(schemas.CartSummary.properties.reserves_stock.const, false, 'Cart placement never reserves stock')
assert.equal(schemas.CheckoutPreviewSummary.properties.creates_orders.const, false, 'A preview never creates orders')
assert.equal(schemas.CheckoutPreviewSummary.properties.reserves_stock.const, false, 'A preview never reserves stock')
assert.ok(schemas.DeliveryPreview.required.includes('confirmed_offer') && schemas.DeliveryPreview.required.includes('estimate'), 'Estimate and confirmed offer are distinct fields')
assert.deepEqual(schemas.DeliveryRoute.properties.basis.enum, ['ROAD_ROUTE_STORE_TO_VEHICLE_DROP_OFF'], 'The fee basis is the route to the vehicle drop-off')
assert.deepEqual(schemas.CartDestination.properties.heavy_vehicle_restriction.enum, ['UNANSWERED', 'NO', 'YES'])
assert.ok(schemas.CartDestination.required.includes('intended') && schemas.CartDestination.required.includes('alternate_drop_off'), 'Both destinations are preserved and labelled')
assert.deepEqual(schemas.PaymentMethodEligibility.properties.method.enum, ['ONLINE', 'CASH_ON_DELIVERY', 'IN_STORE'])
for (const field of ['week', 'open_now', 'all_closed', 'hours_as_of']) assert.ok(schemas.PublicStoreProfile.required.includes(field), `Store Profile hours include ${field}`)
assert.deepEqual(schemas.StoreHoursDay.properties.source.enum, ['WEEKLY', 'DATE_OVERRIDE'])
for (const envelope of ['ExploreSummaryEnvelope', 'ListingSearchEnvelope', 'ListingDetailsEnvelope', 'RankingPreferencesEnvelope', 'CartEnvelope', 'CheckoutPreviewEnvelope']) {
  assert.deepEqual(schemas[envelope].required, ['data', 'meta', 'errors'], `${envelope} uses the canonical envelope`)
}

console.log(`Phase 7 procurement contract passed: ${expected.size} Buyer Explore, search, preference and cart operations match Laravel routes and guards.`)
