import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { spawnSync } from 'node:child_process'
import { fileURLToPath } from 'node:url'
import { resolve } from 'node:path'
import { parse } from 'yaml'

const root = fileURLToPath(new URL('../', import.meta.url))
const spec = parse(readFileSync(resolve(root, 'openapi.yaml'), 'utf8'))
const exported = process.argv[2]
  ? readFileSync(process.argv[2], 'utf8').replace(/^\uFEFF/, '')
  : (() => {
      const result = spawnSync('php', ['artisan', 'route:list', '--json', '--path=api/v1'], { cwd: resolve(root, '../../services/api'), encoding: 'utf8' })
      assert.equal(result.status, 0, 'Laravel route export failed.')
      return result.stdout
    })()
const routeList = JSON.parse(exported)
for (const route of routeList) {
  if (/^api\/v1\/(?:auth\/|mobile\/auth\/|webhooks\/)/.test(route.uri)) continue
  const credentialAction = route.method === 'POST' && /\/(?:account\/(?:reauthentication(?:\/email)?|password|email(?:\/confirm)?|factor(?:\/confirm)?|recovery-codes)|vendors\/account\/invitations|vendors\/onboarding\/store-email(?:\/confirm)?)$/.test(route.uri)
  const throttles = route.middleware.filter(name => /(?:throttle|ThrottleRequests):/.test(name))
  assert.equal(throttles.length, credentialAction ? 1 : 0, `Unexpected throttle policy: ${route.method} ${route.uri}`)
  if (credentialAction) assert.ok(throttles[0].endsWith(':account-security'), route.uri)
}
const routes = new Map(routeList.flatMap(route => route.method.split('|').map(method => [`${method} /${route.uri}`, route])))
let checked = 0
for (const [path, item] of Object.entries(spec.paths)) {
  for (const [method, operation] of Object.entries(item)) {
    if (!operation.responses) continue
    const paths = path.includes('{accountPortal}')
      ? (operation.parameters.find(parameter => parameter.name === 'accountPortal')?.schema.enum ?? []).map(portal => path.replace('{accountPortal}', portal))
      : [path]
    for (const expanded of paths) {
      const route = routes.get(`${method.toUpperCase()} /api/v1${expanded}`)
      if (!route) continue
      const throttled = route.middleware.some(name => /(?:throttle|ThrottleRequests):/.test(name))
      const authentication = /^\/(?:auth|mobile\/auth)\//.test(expanded)
      if (!throttled && !authentication) {
        assert.ok(!operation.responses['429'], `Obsolete rate-limit response: ${method} ${path}`)
        checked++
      }
    }
  }
}
assert.ok(checked > 100)
console.log(`Rate-limit contract passed: ${checked} everyday operations without 429 responses.`)
