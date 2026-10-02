import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { spawnSync } from 'node:child_process'
import { fileURLToPath } from 'node:url'
import { parse } from 'yaml'

// Phase 11 contract test: every documented payment/finance operation exists with the right transport and
// authorization middleware, every Phase 11 route is documented, and the binding enums cannot drift.
const spec = parse(readFileSync(new URL('../openapi.yaml', import.meta.url), 'utf8'))
const routeFile = process.argv[2]
let routes
if (routeFile) {
  routes = JSON.parse(readFileSync(routeFile, 'utf8'))
} else {
  const result = spawnSync('php', ['artisan', 'route:list', '--json'], { cwd: fileURLToPath(new URL('../../../services/api/', import.meta.url)), encoding: 'utf8', timeout: 60000 })
  assert.equal(result.status, 0, 'Laravel route export must succeed')
  routes = JSON.parse(result.stdout)
}
const TAGS = { 'Buyer Payments': 'BUYER', 'Vendor Finance': 'VENDOR', 'Admin Finance': 'ADMIN', 'Payment Webhooks': null }
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
    if (audience === null) {
      assert.deepEqual(operation.security, [], `${key} is public and authenticated by the provider token or not at all`)
      assert.ok(!actual.middleware.some(value => value === 'auth:api' || value.endsWith('Authenticate:api')), `${key} must not require a user session`)
      continue
    }
    const has = (...names) => names.some(name => actual.middleware.includes(name))
    assert.ok(has('auth:api', 'Illuminate\\Auth\\Middleware\\Authenticate:api') && has(`account.access:${audience}`, `App\\Http\\Middleware\\RequireAccountAccess:${audience}`), `${key} must authorize the ${audience}`)
    if (audience !== 'BUYER' && method !== 'get') assert.ok(has('App\\Http\\Middleware\\VerifyAccountCsrf'), `${key} must verify CSRF`)
    if (audience === 'BUYER') assert.deepEqual(operation.security, [{ passportBearer: [] }], `${key} uses the native Buyer bearer`)
    else assert.deepEqual(operation.security, [{ accessCookie: [], webCsrf: [] }], `${key} uses cookies with CSRF`)
    assert.ok(operation.responses['401'] && operation.responses['403'], `${key} documents authentication and authorization errors`)
    if (method === 'post' && /\/payments$/.test(path)) {
      assert.ok(operation.parameters?.some(p => p.name === 'Idempotency-Key' && p.required), `${key} requires an Idempotency-Key`)
    }
  }
}
for (const route of routes.filter(route => /^api\/v1\/(webhooks\/xendit$|payments\/return|buyers\/(payments|orders\/\{[^}]+\}\/(payment|physical))|vendor\/finance|vendor\/orders\/\{[^}]+\}\/(physical|online-balance)|admin\/finance)/.test(route.uri))) {
  for (const method of route.method.split('|').filter(method => method !== 'HEAD')) {
    assert.ok(expected.has(`${method} ${route.uri.replace(/\{[^}]+\}/g, '{}')}`), `Undocumented Phase 11 route ${method} ${route.uri}`)
  }
}
const schemas = spec.components.schemas
const statuses = ['RELIEF_ACTIVE', 'SUBJECT_STANDARD', 'SUBJECT_THRESHOLD_BREACHED', 'SUBJECT_PRIOR_YEAR', 'UNDER_REVIEW']
assert.deepEqual(schemas.WithholdingAccumulatorView.properties.status.enum, statuses)
const enumValues = []
JSON.stringify(schemas, (key, value) => { if (key === 'enum' && Array.isArray(value)) enumValues.push(...value); return value })
assert.ok(!enumValues.includes('EXEMPT') && !enumValues.includes('SUBJECT_TO_WITHHOLDING'), 'Never persist or expose EXEMPT / SUBJECT_TO_WITHHOLDING as a status value')
assert.deepEqual(schemas.PaymentAttempt.properties.purpose.enum, ['FULL_ORDER_PAYMENT', 'NRPC_ASSURANCE_PAYMENT', 'ORDER_BALANCE_PAYMENT', 'PLATFORM_FEE_PAYMENT'])
assert.deepEqual(schemas.PaymentAttempt.properties.environment.enum, ['TEST'])
assert.deepEqual(schemas.PaymentAttempt.properties.evidence_origin.enum, ['XENDIT_TEST', 'SIMULATED'])
assert.ok(!schemas.PaymentAttempt.properties.status.enum.includes('SUCCESS'), 'A redirect state never exists in the contract')
assert.equal(schemas.PaymentCreateRequest.properties.expected_total_centavos.minimum, 1)
assert.deepEqual(schemas.CheckoutSubmitRequest.properties.payment_methods.additionalProperties.enum, ['ONLINE', 'CASH_ON_DELIVERY', 'IN_STORE'])
assert.ok(schemas.OrderPaymentAvailability.properties.physical && schemas.VendorOrderPermissions.properties.can_record_physical_payment)
assert.match(spec.info.version, /phase\.11$/)
console.log(`Payments contract passed: ${expected.size} operations, transports, authorization middleware and FIN-04A enums`)
