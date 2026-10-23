import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { spawnSync } from 'node:child_process'
import { fileURLToPath } from 'node:url'
import { parse } from 'yaml'

// Product analytics contract test: the three read-only Vendor operations exist with the Vendor audience and web cookie
// transport; every product analytics route is documented; no point, radius or identity filter is offered; peso values
// are nullable for roles without finance.view; and no schema exposes coordinates, Buyer identity, contact data or tax data.
const spec = parse(readFileSync(new URL('../openapi.yaml', import.meta.url), 'utf8'))
const routeFile = process.argv[2]
let routes
if (routeFile) {
  routes = JSON.parse(readFileSync(routeFile, 'utf8').replace(/^﻿/, ''))
} else {
  const result = spawnSync('php', ['artisan', 'route:list', '--json'], { cwd: fileURLToPath(new URL('../../../services/api/', import.meta.url)), encoding: 'utf8', timeout: 60000 })
  assert.equal(result.status, 0, 'Laravel route export must succeed')
  routes = JSON.parse(result.stdout)
}
const OPERATIONS = { '/vendor/product-analytics': 'vendor/product-analytics', '/vendor/product-analytics/summaries': 'vendor/product-analytics/summaries', '/vendor/product-analytics/listings/{listingId}': 'vendor/product-analytics/listings/{listingId}' }
for (const [path, uriPath] of Object.entries(OPERATIONS)) {
  const methods = spec.paths[path]
  assert.ok(methods, `${path} is documented`)
  assert.deepEqual(Object.keys(methods), ['get'], `${path} is read-only`)
  const operation = methods.get
  const uri = `api/v1/${uriPath}`
  const route = routes.find(r => r.uri === uri && r.method.split('|').includes('GET'))
  assert.ok(route, `Missing Laravel route GET ${uri}`)
  const has = (...names) => names.some(name => route.middleware.includes(name))
  assert.ok(has('auth:api', 'Illuminate\\Auth\\Middleware\\Authenticate:api') && has('account.access:VENDOR', 'App\\Http\\Middleware\\RequireAccountAccess:VENDOR'), `${uri} must authorize the Vendor`)
  assert.ok(has('auth.transport:WEB', 'App\\Http\\Middleware\\SetAuthTransport:WEB') && has('auth.cookie', 'App\\Http\\Middleware\\AuthenticateFromCookie'), `${uri} uses the web cookie transport`)
  assert.deepEqual(operation.security, [{ accessCookie: [], webCsrf: [] }])
  assert.ok(operation.responses['401'] && operation.responses['403'] && operation.responses['422'])
  assert.ok((operation.parameters ?? []).every(p => !/latitude|longitude|radius|buyer|store_id|vendor_id|organization/i.test(p.name)), `${path} offers no point, radius or identity filter`)
}
assert.ok(spec.paths['/vendor/product-analytics/listings/{listingId}'].get.responses['404'], 'A foreign listing is documented as 404')
for (const route of routes.filter(r => /^api\/v1\/vendor\/product-analytics/.test(r.uri))) {
  assert.ok(spec.paths[`/${route.uri.replace(/^api\/v1\//, '')}`], `Undocumented product analytics route ${route.uri}`)
}
const schemas = spec.components.schemas
const isNullable = schema => schema.oneOf?.some(s => s.type === 'null') || (Array.isArray(schema.type) && schema.type.includes('null'))
assert.ok(isNullable(schemas.VendorProductAnalytics.properties.kpis.properties.value_centavos), 'Overview value is null without finance.view')
assert.ok(isNullable(schemas.VendorProductAnalyticsDetail.properties.kpis.properties.value_centavos), 'Detail value is null without finance.view')
assert.ok(isNullable(schemas.ProductAnalyticsRow.properties.value_centavos), 'Row value is null without finance.view')
assert.ok(isNullable(schemas.ProductAnalyticsSeriesPoint.properties.value_centavos), 'Series value is null without finance.view')
assert.deepEqual(schemas.VendorProductAnalytics.properties.products.properties.meta.properties.sort.enum, ['views', 'orders', 'conversion', 'value'])
const text = JSON.stringify(Object.fromEntries(Object.entries(schemas).filter(([name]) => /^(ProductAnalytics|VendorProductAnalytics)/.test(name))))
assert.ok(!/latitude|longitude|"location"|buyer_key|buyer_profile_id|email|phone|"tin"|tax_evidence/i.test(text), 'Product analytics schemas expose no coordinates, Buyer identity, contact data, TIN or tax evidence')
console.log('Product analytics contract checks passed (3 operations).')
