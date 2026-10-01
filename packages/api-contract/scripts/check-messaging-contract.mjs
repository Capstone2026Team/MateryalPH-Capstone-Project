import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { spawnSync } from 'node:child_process'
import { fileURLToPath } from 'node:url'
import { parse } from 'yaml'

const root = fileURLToPath(new URL('../', import.meta.url))
const spec = parse(readFileSync(new URL('../openapi.yaml', import.meta.url), 'utf8'))
let routeJson
if (process.argv[2]) routeJson = readFileSync(process.argv[2], 'utf8')
else {
  const result = spawnSync('php', ['artisan', 'route:list', '--json', '--path=api/v1'], { cwd: `${root}/../../services/api`, encoding: 'utf8', timeout: 60000 })
  assert.equal(result.status, 0, 'Export Laravel routes successfully before checking the contract')
  routeJson = result.stdout
}
const routes = JSON.parse(routeJson)
const expected = new Set()
for (const [path, methods] of Object.entries(spec.paths)) {
  for (const [method, operation] of Object.entries(methods)) {
    if (!operation.tags?.includes('Messaging')) continue
    assert.ok(operation.responses['401'] && operation.responses['403'] && operation.responses['409'])
    const portals = operation.parameters.find(p => p.name === 'messagingPortal').schema.enum
    for (const portal of portals) {
      const uri = `api/v1${path.replace('{messagingPortal}', portal)}`
      const route = routes.find(r => r.uri === uri && r.method.split('|').includes(method.toUpperCase()))
      assert.ok(route, `Missing ${method} ${uri}`)
      expected.add(`${method.toUpperCase()} ${uri}`)
      const middleware = route.middleware.join(',')
      assert.match(middleware, /Authenticate:api|auth:api/)
      assert.match(middleware, portal === 'buyers' ? /RequireAccountAccess:BUYER|account.access:BUYER/ : /RequireAccountAccess:VENDOR|account.access:VENDOR/)
      if (portal === 'vendor' && method !== 'get') assert.match(middleware, /VerifyAccountCsrf/)
    }
    if (['publishChatQuotation', 'decideChatQuotation', 'createConversation'].includes(operation.operationId)) {
      assert.ok(operation.parameters.some(p => p.name === 'Idempotency-Key' && p.required))
    }
  }
}
for (const route of routes.filter(r => /api\/v1\/(buyers|vendor)\/(conversations|messaging)/.test(r.uri))) {
  for (const method of route.method.split('|').filter(m => m !== 'HEAD')) assert.ok(expected.has(`${method} ${route.uri}`), `Undocumented messaging route ${route.uri}`)
}
assert.deepEqual(spec.components.schemas.ConversationView.properties.purpose.enum, ['SALES', 'FULFILLMENT'])
assert.equal(spec.components.schemas.ChatRealtime.properties.inbox_channel.type, 'string')
assert.equal(spec.components.schemas.ChatRealtime.properties.inbox_channel.nullable, true)
assert.equal(spec.components.schemas.ChatDraftContent.properties.deadline_hours.default, 24)
assert.equal(spec.components.schemas.ChatDraftContent.properties.deadline_hours.minimum, 1)
assert.equal(spec.components.schemas.ChatDraftContent.properties.deadline_hours.maximum, 72)
assert.deepEqual(spec.components.schemas.ChatQuotationContent.properties.price_source.enum, ['PRIVATE_TRANSACTION'])
assert.deepEqual(Object.keys(spec.components.schemas.ChatIdentity.properties).sort(), ['avatar_path', 'display_name', 'role'])
assert.ok(!Object.keys(spec.paths).some(p => p.includes('fulfillment-thread')), 'Phase 12 entry must remain disabled')
console.log(`Phase 9 contract passed: ${expected.size} authorized operations, private identity and immutable quotation schemas.`)
