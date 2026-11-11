import assert from 'node:assert/strict'
import { createRequire } from 'node:module'
import { readFileSync } from 'node:fs'
import { spawnSync } from 'node:child_process'
import { fileURLToPath } from 'node:url'
import { parse } from 'yaml'

// Dashboard insights contract test: both documented operations exist with the right audience, transport and read-only
// method; every dashboard route is documented; no point, radius or identity filter is offered; role-gated sections are
// nullable; and no schema exposes coordinates, Buyer identity, TIN or tax evidence.
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
const OPERATIONS = { '/vendor/dashboard/insights': 'VENDOR', '/admin/dashboard/insights': 'ADMIN' }
for (const [path, audience] of Object.entries(OPERATIONS)) {
  const methods = spec.paths[path]
  assert.ok(methods, `${path} is documented`)
  assert.deepEqual(Object.keys(methods), ['get'], `${path} is read-only`)
  const operation = methods.get
  const uri = `api/v1${path}`
  const route = routes.find(r => r.uri === uri && r.method.split('|').includes('GET'))
  assert.ok(route, `Missing Laravel route GET ${uri}`)
  const has = (...names) => names.some(name => route.middleware.includes(name))
  assert.ok(has('auth:api', 'Illuminate\\Auth\\Middleware\\Authenticate:api') && has(`account.access:${audience}`, `App\\Http\\Middleware\\RequireAccountAccess:${audience}`), `${uri} must authorize the ${audience}`)
  assert.ok(has('auth.transport:WEB', 'App\\Http\\Middleware\\SetAuthTransport:WEB') && has('auth.cookie', 'App\\Http\\Middleware\\AuthenticateFromCookie'), `${uri} uses the web cookie transport`)
  assert.deepEqual(operation.security, [{ accessCookie: [], webCsrf: [] }])
  assert.ok(operation.responses['401'] && operation.responses['403'] && operation.responses['422'])
  assert.ok((operation.parameters ?? []).every(p => !/latitude|longitude|radius|buyer|store_id|vendor_id|organization/i.test(p.name)), `${path} offers no point, radius or identity filter`)
}
for (const route of routes.filter(r => /^api\/v1\/(vendor|admin)\/dashboard\/insights/.test(r.uri))) {
  assert.ok(spec.paths[`/${route.uri.replace(/^api\/v1\//, '')}`], `Undocumented dashboard route ${route.uri}`)
}
const schemas = spec.components.schemas
for (const field of ['active', 'inactive']) {
  assert.ok(schemas.VendorDashboardStock.required.includes(field))
  assert.equal(schemas.VendorDashboardStock.properties[field].minimum, 0)
}
const { VendorDashboardStockFromJSON, VendorDashboardStockToJSON } = createRequire(import.meta.url)('../generated/typescript/dist/index.js')
const stock = { variants: 10, active: 7, inactive: 3, in_stock: 8, limited_stock: 1, out_of_stock: 1, attention: [] }
assert.deepEqual(VendorDashboardStockToJSON(VendorDashboardStockFromJSON(stock)), stock)
const nullableRef = (schema, name) => Array.isArray(schema.oneOf) && schema.oneOf.some(s => s.$ref === `#/components/schemas/${name}`) && schema.oneOf.some(s => s.type === 'null')
const vendor = schemas.VendorDashboardInsights.properties
for (const [section, name] of [['orders', 'VendorDashboardOrders'], ['performance', 'VendorDashboardPerformance'], ['stock', 'VendorDashboardStock'], ['disputes', 'VendorDashboardDisputes']]) {
  assert.ok(nullableRef(vendor[section], name), `Vendor ${section} is null without its grant`)
}
const products = schemas.VendorDashboardOrders.properties.products
assert.ok(products.required.includes('sales_breakdown'))
assert.ok(nullableRef(products.properties.sales_breakdown, 'VendorProductSalesBreakdown'), 'Product reconciliation is null without finance.view')
assert.deepEqual([...schemas.VendorProductSalesBreakdown.required].sort(), ['delivery_centavos', 'net_sales_centavos', 'product_sales_centavos', 'refunds_centavos'])
for (const value of Object.values(schemas.VendorProductSalesBreakdown.properties)) {
  assert.equal(value.type, 'integer')
  assert.equal(value.minimum, 0)
}
assert.match(products.properties.sales_breakdown.description, /same surviving confirmed orders/)
const { VendorProductSalesBreakdownFromJSON, VendorProductSalesBreakdownToJSON } = createRequire(import.meta.url)('../generated/typescript/dist/index.js')
const values = { product_sales_centavos: 2940650, delivery_centavos: 93075, refunds_centavos: 0, net_sales_centavos: 3033725 }
const decoded = VendorProductSalesBreakdownFromJSON(values)
assert.equal(decoded.productSalesCentavos + decoded.deliveryCentavos - decoded.refundsCentavos, decoded.netSalesCentavos)
assert.deepEqual(VendorProductSalesBreakdownToJSON(decoded), values)
assert.equal(VendorProductSalesBreakdownFromJSON(null), null)

const kpis = schemas.VendorDashboardOrders.properties.kpis.properties
const refunds = schemas.VendorDashboardSeriesPoint.properties.refunds_centavos
assert.deepEqual(refunds.type, ['integer', 'null'], 'Daily refunds are integer centavos and null without finance.view')
assert.equal(refunds.minimum, 0)
assert.match(refunds.description, /first confirmed/)
const cancellations = schemas.VendorDashboardSeriesPoint.properties.cancellation_deductions_centavos
assert.deepEqual(cancellations.type, ['integer', 'null'])
assert.equal(cancellations.minimum, 0)
assert.match(cancellations.description, /not already included/)
for (const money of ['gross_sales_centavos', 'net_sales_centavos', 'average_order_value_centavos']) {
  assert.ok(kpis[money].oneOf?.some(s => s.type === 'null') || (Array.isArray(kpis[money].type) && kpis[money].type.includes('null')), `${money} is nullable for roles without finance.view`)
}
assert.deepEqual(schemas.VendorDashboardInsights.properties.traffic.properties.store_visits.properties.tracked, { type: 'boolean' })
const admin = schemas.AdminDashboardInsights.properties
assert.ok(nullableRef(admin.marketplace, 'AdminDashboardMarketplace') && nullableRef(admin.vendor_health, 'AdminDashboardVendorHealth'))
assert.deepEqual(schemas.DashboardClassification.properties.class.enum, ['BUILDING_TRACK_RECORD', 'BELOW_WATCH_LEVEL', 'WATCH', 'HEALTHY'])
const text = JSON.stringify(Object.fromEntries(Object.entries(schemas).filter(([name]) => /^(Dashboard|VendorProductSalesBreakdown|VendorDashboard|AdminDashboard(Insights|Marketplace|Series|Activity|Area|Categories|VendorHealth))/.test(name))))
assert.ok(!/latitude|longitude|"location"|buyer_key|buyer_profile_id|email|phone|"tin"|tax_evidence/i.test(text), 'Dashboard schemas expose no coordinates, Buyer identity, contact data, TIN or tax evidence')
console.log('Dashboard insights contract checks passed (2 operations).')
