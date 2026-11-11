import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { spawnSync } from 'node:child_process'
import { fileURLToPath } from 'node:url'
import { resolve } from 'node:path'
import { parse } from 'yaml'

const root = fileURLToPath(new URL('../', import.meta.url))
const spec = parse(readFileSync(resolve(root, 'openapi.yaml'), 'utf8'))
const read = spec.paths['/{tutorialPortal}/account/tutorials']
const update = spec.paths['/{tutorialPortal}/account/tutorials/{tutorialKey}']
assert.deepEqual(read.parameters[0].schema.enum, ['buyers', 'vendors'])
assert.equal(read.get.operationId, 'getTutorialProgress')
assert.equal(update.put.operationId, 'acknowledgeTutorial')
assert.equal(spec.components.schemas.TutorialProgressEnvelope.properties.data.maxItems, 23)
assert.deepEqual(spec.components.schemas.TutorialAcknowledgment.properties.status.enum, ['COMPLETED', 'SKIPPED'])
assert.equal(spec.components.schemas.TutorialAcknowledgment.additionalProperties, false)
assert.deepEqual(update.parameters[1].schema.enum, ['overview', 'discovery', 'procurement', 'projects', 'messages', 'orders', 'store', 'products', 'inventory', 'dashboard', 'fulfillment', 'invoices', 'disputes', 'reviews', 'vehicles', 'finance', 'commissions', 'transactions', 'remittance', 'performance', 'analytics', 'team', 'tracking', 'settings', 'notifications', 'support'])
const domain = readFileSync(resolve(root, '../../services/api/app/Domain/Identity/TutorialProgress.php'), 'utf8')
for (const key of ['overview', 'store', 'products', 'inventory', 'messages', 'orders', 'dashboard', 'fulfillment', 'invoices', 'disputes', 'reviews', 'vehicles', 'finance', 'commissions', 'transactions', 'remittance', 'performance', 'analytics', 'team', 'tracking', 'settings', 'notifications', 'support']) assert.ok(domain.includes("'" + key + "'"), key)
assert.deepEqual(update.put.security, [{ passportBearer: [] }, { accessCookie: [], webCsrf: [] }])
const routes = spawnSync('php', ['artisan', 'route:list', '--json', '--path=account/tutorials'], { cwd: resolve(root, '../../services/api'), encoding: 'utf8', timeout: 60000 })
assert.equal(routes.status, 0, routes.stderr)
const registered = JSON.parse(routes.stdout)
for (const portal of ['buyers', 'vendors']) {
  assert.ok(registered.some(route => route.uri === `api/v1/${portal}/account/tutorials` && route.method.includes('GET')))
  assert.ok(registered.some(route => route.uri === `api/v1/${portal}/account/tutorials/{tutorialKey}` && route.method === 'PUT'))
}
assert.ok(registered.every(route => !route.uri.includes('/admin/')))
for (const [language, path, operation] of [
  ['TypeScript', 'generated/typescript/src/apis/TutorialsApi.ts', /acknowledgeTutorial/],
  ['Dart', 'generated/dart/lib/src/api/tutorials_api.dart', /acknowledgeTutorial/],
]) assert.match(readFileSync(resolve(root, path), 'utf8'), operation, language)
console.log('Tutorial contract, generated clients and role-scoped routes passed.')
