import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { spawnSync } from 'node:child_process'
import { fileURLToPath } from 'node:url'
import { parse } from 'yaml'

// Phase 16 contract test: every documented Admin operations, geographic analytics and FIN-10 operation exists with the
// right transport and audience middleware, every Phase 16 route is documented, record-creating commands require an
// Idempotency-Key, and no operation edits or deletes audit entries, exposes secrets or balances, moves money, marks a
// provider ready, caps NRPC or edits VPS weights.
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
assert.ok(!Object.keys(spec.paths).some(path => path.startsWith('/admin/privacy-requests')), 'Privacy request endpoints are retired')
assert.ok(!routes.some(route => route.uri.startsWith('api/v1/admin/privacy-requests')), 'Retired privacy routes must not be registered')
assert.ok(!Object.keys(spec.components.schemas).some(name => /^Privacy(Request|Transition|Handler)/.test(name)), 'Privacy request schemas are retired')
const TAGS = { 'Admin Platform Settings': 'ADMIN', 'Admin Enforcement': 'ADMIN', 'Admin Audit Log': 'ADMIN', 'Admin Integration Health': 'ADMIN',
  'Admin Budget Overrides': 'ADMIN', 'Admin Geographic Analytics': 'ADMIN', 'Admin Finance Operations': 'ADMIN', 'Vendor Finance Reviews': 'VENDOR' }
const KEYED = ['POST /admin/enforcement', 'POST /admin/integrations/retries']
const expected = new Set()
let count = 0
for (const [path, methods] of Object.entries(spec.paths)) {
  for (const [method, operation] of Object.entries(methods)) {
    const tag = operation.tags?.find(value => value in TAGS)
    if (!tag) continue
    count++
    const uri = `api/v1${path.replace(/\{[^}]+\}/g, '{}')}`
    const key = `${method.toUpperCase()} ${uri}`
    expected.add(key)
    const actual = routes.find(route => route.uri.replace(/\{[^}]+\}/g, '{}') === uri && route.method.split('|').includes(method.toUpperCase()))
    assert.ok(actual, `Missing Laravel route ${key}`)
    const audience = TAGS[tag]
    const has = (...names) => names.some(name => actual.middleware.includes(name))
    assert.ok(has('auth:api', 'Illuminate\\Auth\\Middleware\\Authenticate:api') && has(`account.access:${audience}`, `App\\Http\\Middleware\\RequireAccountAccess:${audience}`), `${key} must authorize the ${audience}`)
    assert.ok(has('auth.transport:WEB', 'App\\Http\\Middleware\\SetAuthTransport:WEB') && has('auth.cookie', 'App\\Http\\Middleware\\AuthenticateFromCookie'), `${key} uses the web cookie transport`)
    if (method !== 'get') assert.ok(has('App\\Http\\Middleware\\VerifyAccountCsrf'), `${key} must verify CSRF`)
    assert.deepEqual(operation.security, [{ accessCookie: [], webCsrf: [] }], `${key} uses cookies with CSRF`)
    assert.ok(operation.responses['401'] && operation.responses['403'], `${key} documents authentication and authorization errors`)
    if (KEYED.includes(`${method.toUpperCase()} ${path}`)) {
      assert.ok(operation.parameters?.some(p => p.name === 'Idempotency-Key' && p.required), `${key} requires an Idempotency-Key`)
    }
  }
}
assert.ok(count >= 30, `Expected at least 30 Phase 16 operations, found ${count}`)
const phaseSixteen = /^api\/v1\/(admin\/(platform-settings|enforcement|audit-log|integrations|budget-overrides|geo-analytics|finance\/(kpis|remittances|evidence|tax-adjustments))|vendor\/finance\/reviews)/
for (const route of routes.filter(route => phaseSixteen.test(route.uri))) {
  for (const method of route.method.split('|').filter(method => method !== 'HEAD')) {
    assert.ok(expected.has(`${method} ${route.uri.replace(/\{[^}]+\}/g, '{}')}`), `Undocumented Phase 16 route ${method} ${route.uri}`)
  }
}
for (const [path, methods] of Object.entries(spec.paths)) {
  if (/^\/admin\/audit-log/.test(path)) assert.deepEqual(Object.keys(methods), ['get'], `${path} is read-only`)
  if (path.startsWith('/admin/')) assert.ok(!/(secret|withdraw|balance|payout|disburse|nrpc-cap|vps-weights|provider-ready|payment-connection)/i.test(path), `${path} must not expose secrets, balances, payouts or overrides`)
}
// Phase 3E extension is additive on the same queue and case; no second approval engine.
const queue = spec.paths['/admin/vendor-verification'].get
for (const name of ['setup_status', 'activation', 'discoverability', 'blocker', 'requirement_key', 'age_days', 'expiry_days']) {
  assert.ok(queue.parameters.some(p => p.name === name), `Verification queue documents ${name}`)
}
assert.ok(spec.components.schemas.ActivationRestrictions.properties.override_available.enum.length === 1, 'No activation override')
assert.deepEqual(spec.components.schemas.AdminDashboardSummary.properties.queues.items, { $ref: '#/components/schemas/OperationsQueue' })
// Geographic responses carry no coordinates; transaction filters are reported as not applicable to price panels.
const geo = JSON.stringify(spec.components.schemas.GeoDashboard) + JSON.stringify(spec.components.schemas.GeoChild)
const filterOptions = spec.paths['/admin/geo-analytics/filter-options'].get
assert.equal(filterOptions.operationId, 'getGeoFilterOptions')
assert.deepEqual(filterOptions.parameters.map(parameter => parameter.name), ['category_id', 'page'], 'Taxonomy choices do not depend on transaction, date or area filters')
assert.deepEqual(spec.components.schemas.GeoFilterOptionsEnvelope.properties.meta, { $ref: '#/components/schemas/PageMeta' }, 'Taxonomy choices are paginated')
assert.deepEqual(spec.components.schemas.GeoFilterOption.required, ['id', 'name'])
assert.ok(spec.paths['/admin/geo-analytics/demand'].get.parameters.some(parameter => parameter.name === 'page'))
assert.ok(spec.components.schemas.GeoDemand.required.includes('column_pagination'))
assert.deepEqual(spec.components.schemas.GeoDemand.properties.column_pagination, { $ref: '#/components/schemas/PageMeta' })
assert.ok(!/latitude|longitude|"location"/.test(geo), 'Geographic aggregates never carry coordinates')
assert.ok(spec.paths['/admin/geo-analytics'].get.parameters.every(p => !/latitude|longitude|radius/.test(p.name)), 'No radius or point filter on national analytics')
// Settings never include an NRPC cap, VPS weights or secrets.
const settingsText = JSON.stringify(spec.paths['/admin/platform-settings/{key}'])
assert.ok(!/nrpc_cap|vps_weights|secret/.test(settingsText), 'No NRPC cap, VPS weights or secret settings')
assert.ok(spec.components.schemas.DocumentExportInput.properties.type.enum.includes('GEO_ANALYTICS') && spec.components.schemas.DocumentExportInput.properties.type.enum.includes('AUDIT_LOG'))
console.log(`Phase 16 admin operations contract checks passed (${count} operations).`)
