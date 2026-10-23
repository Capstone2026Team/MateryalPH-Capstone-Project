import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { spawnSync } from 'node:child_process'
import { fileURLToPath } from 'node:url'
import { parse } from 'yaml'

const spec = parse(readFileSync(new URL('../openapi.yaml', import.meta.url), 'utf8'))
// CI passes its exported api/v1 route list; otherwise export the support routes from Laravel directly.
const exported = process.argv[2]
  ? readFileSync(process.argv[2], 'utf8').replace(/^﻿/, '')
  : (() => {
      const result = spawnSync('php', ['artisan', 'route:list', '--path=support', '--json'], { cwd: fileURLToPath(new URL('../../../services/api', import.meta.url)), encoding: 'utf8', timeout: 60000 })
      assert.equal(result.status, 0, 'Support route export must succeed')
      return result.stdout
    })()
const routes = JSON.parse(exported).filter(route => route.uri.includes('support'))
const normalize = path => path.replace(/\{[^}]+\}/g, '{}')
const operations = new Set()
for (const route of routes) {
  const path = '/' + route.uri.replace('api/v1/', '')
  const portal = path.split('/')[2]
  const generic = path.replace(`/support/${portal}`, '/support/{supportPortal}')
  for (const method of route.method.split('|').filter(method => method !== 'HEAD')) {
    const operation = spec.paths[path]?.[method.toLowerCase()] ?? spec.paths[generic]?.[method.toLowerCase()]
    assert.ok(operation, `Missing support contract: ${method} ${path}`)
    operations.add(operation.operationId)
    const middleware = route.middleware.join('|')
    if (portal === 'guest') {
      assert.match(middleware, /support-guest/, 'Guest requests must be rate limited')
      assert.match(middleware, /VerifyAccountCsrf/, 'Guest browser mutations use existing CSRF')
    } else {
      assert.match(middleware, /RequireAccountAccess|account\.access:/, 'Account access must be enforced')
      assert.match(middleware, new RegExp(portal === 'buyers' ? 'MOBILE' : 'WEB'), 'Correct transport is required')
    }
    assert.match(middleware, new RegExp(`SetSupportPortal:${portal}`), 'Portal scope is fixed by the route')
    if (method === 'POST' && /\/tickets(?:\/[^/]+\/entries)?$/.test(path) || method === 'PATCH') {
      assert.ok(operation.parameters.some(parameter => parameter.name === 'Idempotency-Key' && parameter.required), 'Mutations require idempotency')
    }
  }
}
assert.equal(operations.size, 10)
assert.deepEqual(spec.components.schemas.SupportStatus.enum, ['OPEN','IN_PROGRESS','WAITING_FOR_USER','RESOLVED','CLOSED'])
const ts = readFileSync(new URL('../generated/typescript/src/apis/SupportApi.ts', import.meta.url), 'utf8')
const dart = readFileSync(new URL('../generated/dart/lib/src/api/support_api.dart', import.meta.url), 'utf8')
assert.equal((ts.match(/formParams.append\('files\[\]'/g) ?? []).length, 2, 'Both web multipart operations use PHP array keys')
assert.equal((dart.match(/r'files\[\]'/g) ?? []).length, 2, 'Both mobile multipart operations use PHP array keys')
assert.ok(!Object.keys(spec.components.schemas.SupportTicket.properties).some(name => /token|secret|object_key|scan_payload/.test(name)))
assert.ok(!Object.keys(spec.components.schemas.SupportReceipt.properties).some(name => /email|token|message/.test(name)))
console.log(`Support contract passed: ${operations.size} operations, ${routes.length} audience-scoped routes, private receipts and multipart clients.`)
