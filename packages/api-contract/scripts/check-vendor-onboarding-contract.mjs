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
const hasMiddleware = (route, ...names) => names.some(name => route.middleware.includes(name))
const phaseThreePaths = new Set([
  '/vendors/onboarding',
  '/vendors/onboarding/verification',
  '/vendors/onboarding/verification/submit',
  '/vendors/onboarding/setup',
  '/vendors/onboarding/setup/complete',
  '/vendors/onboarding/welcome/dismiss',
  '/vendors/onboarding/address/geocode',
  '/vendors/onboarding/store-email',
  '/vendors/onboarding/store-email/confirm',
  '/vendors/onboarding/documents',
  '/vendors/onboarding/media',
  '/vendors/onboarding/files/{fileId}',
  '/vendors/onboarding/payment-connection',
  '/vendors/onboarding/payment-connection/reconcile',
  '/vendors/onboarding/activation',
  '/vendors/account/invitations',
  '/admin/vendor-verification',
  '/admin/vendor-verification/{organizationId}',
  '/admin/vendor-verification/{organizationId}/requirements/{requirementKey}/decision',
  '/admin/vendor-verification/files/{fileId}',
  '/admin/vendor-verification/{organizationId}/restrict',
  '/admin/vendor-verification/{organizationId}/restore',
  '/vendor-onboarding-files/{fileId}/content',
  '/webhooks/xendit/account-verification',
])
const expected = new Set()

for (const path of phaseThreePaths) {
  const item = spec.paths[path]
  assert.ok(item, `Phase 3 path missing from OpenAPI: ${path}`)
  for (const [method, operation] of Object.entries(item)) {
    if (! ['get', 'post', 'patch'].includes(method)) continue
    const key = `${method.toUpperCase()} /api/v1${path}`
    expected.add(key)
    const route = actual.get(key)
    assert.ok(route, `Laravel route missing from Phase 3 contract: ${key}`)

    const webhook = path.startsWith('/webhooks/')
    if (! webhook) {
      assert.ok(hasMiddleware(route, 'auth:api', 'Illuminate\\Auth\\Middleware\\Authenticate:api'), `Passport guard missing: ${key}`)
      const privateStream = path === '/vendor-onboarding-files/{fileId}/content'
      const admin = path.startsWith('/admin/')
      const audience = admin ? 'ADMIN' : 'VENDOR'
      const transport = 'WEB'
      assert.ok(privateStream
        ? hasMiddleware(route, 'account.access', 'App\\Http\\Middleware\\RequireAccountAccess')
        : hasMiddleware(route, `account.access:${audience}`, `App\\Http\\Middleware\\RequireAccountAccess:${audience}`), `Portal authorization missing: ${key}`)
      assert.ok(hasMiddleware(route, `auth.transport:${transport}`, `App\\Http\\Middleware\\SetAuthTransport:${transport}`), `Transport guard missing: ${key}`)
      if (path !== '/vendor-onboarding-files/{fileId}/content') assert.ok(hasMiddleware(route, 'web.csrf', 'App\\Http\\Middleware\\VerifyAccountCsrf'), `Web CSRF guard missing: ${key}`)
    }

    for (const response of Object.values(operation.responses)) {
      const responseSchema = response.content?.['application/json']?.schema
      if (! responseSchema) continue
      const reference = responseSchema.$ref
      assert.ok(reference, `${operation.operationId} needs a defined response envelope`)
      assert.ok(spec.components.schemas[reference.split('/').at(-1)], `${operation.operationId} references an unknown response schema`)
    }
  }
}

for (const key of actual.keys()) {
  if (/ \/api\/v1\/(vendors\/onboarding|admin\/vendor-verification|vendor-onboarding-files|webhooks\/xendit\/account-verification)/.test(key)) {
    assert.ok(expected.has(key), `Laravel Phase 3 route missing from OpenAPI: ${key}`)
  }
}

for (const path of [
  '/vendors/onboarding/verification/submit',
  '/vendors/onboarding/setup/complete',
  '/vendors/onboarding/payment-connection',
  '/vendors/onboarding/activation',
  '/vendors/account/invitations',
  '/admin/vendor-verification/{organizationId}/requirements/{requirementKey}/decision',
  '/admin/vendor-verification/{organizationId}/restrict',
  '/admin/vendor-verification/{organizationId}/restore',
]) {
  const operation = spec.paths[path].post
  assert.ok(operation.parameters?.some(parameter => parameter.name === 'Idempotency-Key' && parameter.required), `${path} must require Idempotency-Key`)
}

console.log(`Phase 3 contract passed: ${expected.size} Vendor/Admin onboarding, verification, file, invitation, payment, and webhook operations match Laravel routes.`)
