import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { spawnSync } from 'node:child_process'
import { fileURLToPath } from 'node:url'
import { parse } from 'yaml'

const spec = parse(readFileSync(new URL('../openapi.yaml', import.meta.url), 'utf8'))
const routeFile = process.argv[2]
let routes
if (routeFile) {
  routes = JSON.parse(readFileSync(routeFile, 'utf8'))
} else {
  const result = spawnSync('php', ['artisan', 'route:list', '--json', '--path=api/v1/buyers'], { cwd: fileURLToPath(new URL('../../../services/api/', import.meta.url)), encoding: 'utf8', timeout: 60000 })
  assert.equal(result.status, 0, 'Laravel route export must succeed')
  routes = JSON.parse(result.stdout)
}
const expected = new Set()
for (const [path, methods] of Object.entries(spec.paths)) {
  for (const [method, operation] of Object.entries(methods)) {
    if (!operation.tags?.includes('Buyer Projects')) continue
    assert.deepEqual(operation.security, [{ passportBearer: [] }], `${operation.operationId} must use the configured native Buyer bearer transport`)
    const uri = `api/v1${path.replace(/\{[^}]+\}/g, '{}')}`
    const key = `${method.toUpperCase()} ${uri}`
    expected.add(key)
    const actual = routes.find(route => route.uri.replace(/\{[^}]+\}/g, '{}') === uri && route.method.split('|').includes(method.toUpperCase()))
    assert.ok(actual, `Missing Laravel route ${key}`)
    assert.ok(actual.middleware.some(value => value.endsWith('Authenticate:api')) && actual.middleware.some(value => value.endsWith('RequireAccountAccess:BUYER')), `${key} must authorize the Buyer`)
    assert.ok(operation.responses['401'] && operation.responses['403'] && operation.responses['409'], `${key} must document authentication, authorization and concurrency errors`)
  }
}
for (const route of routes.filter(route => /buyers\/(projects|work-packages|project-ranking-preferences|project-materials)/.test(route.uri))) {
  for (const method of route.method.split('|').filter(method => method !== 'HEAD')) assert.ok(expected.has(`${method} ${route.uri.replace(/\{[^}]+\}/g, '{}')}`), `Undocumented Project route ${route.uri}`)
}
const schemas = spec.components.schemas
assert.deepEqual(schemas.WorkPackageInput.properties.radius_km.enum, [5, 10, 20, 30, 40, 50])
assert.deepEqual(schemas.WorkPackageInput.properties.heavy_vehicle_restriction.enum, ['YES', 'NO'])
assert.equal(schemas.ProjectCandidate.properties.delivery_centavos.nullable, true)
assert.equal(schemas.ProjectCandidate.properties.projected_total_centavos.nullable, true)
assert.ok(schemas.ChatDraftLine.properties.specifications)
assert.ok(schemas.ChatDecision.properties.budget_override_reason)
assert.ok(schemas.OrderDetail.properties.project_context)
console.log(`Project contract passed: ${expected.size} operations, protected routes and shared quotation/budget fields`)
