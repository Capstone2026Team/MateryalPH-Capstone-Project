import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { parse } from 'yaml'

assert.ok(process.argv[2], 'Supply an isolated Laravel route:list --json export, or - for stdin.')
const spec = parse(readFileSync(new URL('../openapi.yaml', import.meta.url), 'utf8'))
const routeSource = process.argv[2] === '-' ? 0 : process.argv[2]
const routes = JSON.parse(readFileSync(routeSource, 'utf8').replace(/^\uFEFF/, ''))
const actual = new Map(routes.flatMap(route => route.method.split('|').filter(method => method !== 'HEAD').map(method => [`${method} /${route.uri}`, route])))
const expected = new Set()
for (const [path, item] of Object.entries(spec.paths)) {
  for (const [method, operation] of Object.entries(item)) {
    if (!operation.tags?.includes('VendorOnboarding')) continue
    const key = `${method.toUpperCase()} /api/v1${path}`
    expected.add(key)
    const route = actual.get(key)
    assert.ok(route, `Contract operation missing from Laravel: ${key}`)
    if (path.startsWith('/public/')) {
      assert.deepEqual(operation.security, [], `Public media must not advertise session authentication: ${key}`)
      assert.ok(route.middleware.includes('throttle:auth-public'), `Missing public throttle: ${key}`)
      assert.ok(!route.middleware.includes('auth:api'), `Public media unexpectedly requires Passport: ${key}`)
    } else {
      for (const middleware of ['auth:api', 'auth.transport:WEB', 'App\\Http\\Middleware\\VerifyAccountCsrf', `account.access:${path.startsWith('/admin/') ? 'ADMIN' : 'VENDOR'}`]) {
        assert.ok(route.middleware.includes(middleware), `Missing ${middleware}: ${key}`)
      }
    }
    for (const response of Object.values(operation.responses)) {
      const schema = response.content?.['application/json']?.schema
      if (schema) assert.ok(spec.components.schemas[schema.$ref?.split('/').at(-1)], `Undefined response for ${key}`)
    }
  }
}
for (const [key, route] of actual) {
  if (route.action.includes('VendorOnboardingController')) assert.ok(expected.has(key), `Laravel operation missing from contract: ${key}`)
}
assert.ok(spec.paths['/vendors/{organization}/team/invitations'].post.parameters.some(parameter => parameter.name === 'Idempotency-Key' && parameter.required))
assert.equal(spec.components.schemas.InviteVendorTeam.properties.can_manage_staff.default, false)
assert.deepEqual(spec.components.schemas.VendorReadiness.properties.environment.enum, ['TEST'])
console.log(`Phase 3 contract passed: ${expected.size} operations match routes, Passport, CSRF, portal guards and response envelopes.`)
