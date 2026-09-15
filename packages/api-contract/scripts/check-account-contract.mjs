import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { spawnSync } from 'node:child_process'
import { fileURLToPath } from 'node:url'
import { resolve } from 'node:path'
import { parse } from 'yaml'

const root = fileURLToPath(new URL('../', import.meta.url))
const spec = parse(readFileSync(resolve(root, 'openapi.yaml'), 'utf8'))
let routes
if (process.argv[2]) routes = JSON.parse(readFileSync(process.argv[2], 'utf8').replace(/^\uFEFF/, ''))
else {
  const result = spawnSync('php', ['artisan', 'route:list', '--json', '--path=api/v1'], { cwd: resolve(root, '../../services/api'), encoding: 'utf8', timeout: 60000 })
  assert.equal(result.status, 0, 'Laravel route export failed; provide an isolated route:list --json export as the first argument.')
  routes = JSON.parse(result.stdout)
}
const actual = new Map(routes.flatMap(route => route.method.split('|').filter(method => method !== 'HEAD').map(method => [`${method} /${route.uri}`, route])))
const expected = new Set()
for (const [path, item] of Object.entries(spec.paths)) {
  if (!path.startsWith('/{accountPortal}/account/')) continue
  for (const [method, operation] of Object.entries(item)) {
    const portalParameter = operation.parameters.find(parameter => parameter.name === 'accountPortal')
    assert.ok(portalParameter?.schema.enum.length)
    for (const portal of portalParameter.schema.enum) {
      const key = `${method.toUpperCase()} /api/v1${path.replace('{accountPortal}', portal)}`
      expected.add(key)
      const route = actual.get(key)
      assert.ok(route, `Contract route missing from Laravel: ${key}`)
      assert.ok(route.middleware.includes('auth:api'), `Passport guard missing: ${key}`)
      assert.ok(route.middleware.includes(`account.access:${{ buyers: 'BUYER', vendors: 'VENDOR', admin: 'ADMIN' }[portal]}`), `Portal authorization missing: ${key}`)
      assert.ok(route.middleware.includes(`auth.transport:${portal === 'buyers' ? 'MOBILE' : 'WEB'}`), `Transport guard missing: ${key}`)
      if (portal !== 'buyers') assert.ok(route.middleware.includes('App\\Http\\Middleware\\VerifyAccountCsrf'), `Web CSRF guard missing: ${key}`)
    }
    for (const response of Object.values(operation.responses)) {
      const reference = response.content?.['application/json']?.schema?.$ref
      assert.ok(reference, `${operation.operationId} needs a defined response envelope`)
      assert.ok(spec.components.schemas[reference.split('/').at(-1)])
    }
  }
}
for (const key of actual.keys()) {
  if (/ \/api\/v1\/(buyers|vendors|admin)\/account\//.test(key)) assert.ok(expected.has(key), `Laravel route missing from contract: ${key}`)
}
const invite = spec.paths['/{accountPortal}/account/invitations'].post
assert.ok(invite.parameters.some(parameter => parameter.name === 'Idempotency-Key' && parameter.required))
assert.deepEqual(spec.paths['/{accountPortal}/account/administrators'].get.parameters[0].schema.enum, ['admin'])
assert.deepEqual(spec.paths['/{accountPortal}/account/memberships'].get.parameters[0].schema.enum, ['vendors'])
console.log(`Account contract passed: ${expected.size} protected operations match Laravel routes, audiences, transport, and response envelopes.`)
