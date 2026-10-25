import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { createRequire } from 'node:module'
import { spawnSync } from 'node:child_process'
import { fileURLToPath } from 'node:url'
import YAML from 'yaml'

const require = createRequire(import.meta.url)
const client = require('../generated/typescript/dist/index.js')
const spec = YAML.parse(readFileSync(new URL('../openapi.yaml', import.meta.url), 'utf8'))
const routeResult = spawnSync('php', ['artisan', 'route:list', '--json', '--path=api/v1/auth/password'], {
  cwd: fileURLToPath(new URL('../../../services/api/', import.meta.url)), encoding: 'utf8', timeout: 60000,
})
assert.equal(routeResult.status, 0, 'Could not inspect Laravel recovery routes.')
const routes = JSON.parse(routeResult.stdout)
for (const [suffix, operationId, request] of [
  ['verify', 'verifyWebPasswordRecovery', 'VerifyWebPasswordRecoveryRequest'],
  ['complete', 'completeWebPasswordRecovery', 'CompleteWebPasswordRecoveryRequest'],
]) {
  const path = `/auth/password/${suffix}`
  const operation = spec.paths[path].post
  assert.equal(operation.operationId, operationId)
  assert.deepEqual(operation.security, [{ webCsrf: [] }])
  assert.equal(operation.requestBody.content['application/json'].schema.$ref, `#/components/schemas/${request}`)
  const route = routes.find(item => item.uri === `api/v1${path}` && item.method === 'POST')
  assert.ok(route, `Missing route: ${path}`)
  for (const aliases of [
    ['auth.transport:WEB', 'App\\Http\\Middleware\\SetAuthTransport:WEB'],
    ['web.csrf', 'App\\Http\\Middleware\\VerifyWebCsrf'],
    ['throttle:auth-public', 'Illuminate\\Routing\\Middleware\\ThrottleRequests:auth-public'],
  ]) assert.ok(aliases.some(middleware => route.middleware.includes(middleware)), `${path} requires ${aliases[0]}`)
}
const verifySchema = spec.components.schemas.VerifyWebPasswordRecoveryRequest
assert.equal(verifySchema.oneOf.length, 2)
assert.ok(!('token' in verifySchema.properties), 'Proof must remain in its HttpOnly cookie.')
assert.equal(spec.components.schemas.CompleteWebPasswordRecoveryRequest.properties.password.minLength, 12)
assert.equal(verifySchema.properties.portal.$ref, '#/components/schemas/WebPasswordRecoveryPortal')
assert.deepEqual(spec.components.schemas.WebPasswordRecoveryPortal.enum, ['VENDOR', 'ADMIN'])
assert.equal(spec.paths['/auth/password/forgot'].post.responses['200'].content['application/json'].schema.$ref, '#/components/schemas/PasswordRecoveryEnvelope')
for (const portal of ['VENDOR', 'ADMIN']) {
  const wire = client.VerifyWebPasswordRecoveryRequestToJSON({ email: 'account@example.test', portal, recoveryCode: 'TEST-ONLY' })
  assert.equal(wire.recovery_code, 'TEST-ONLY')
  assert.equal(wire.portal, portal)
}
assert.equal(client.VerifyWebPasswordRecoveryRequestToJSON({ email: 'admin@example.test', portal: 'ADMIN', code: '123456', challengeId: 'test-challenge' }).challenge_id, 'test-challenge')
const completed = client.CompleteWebPasswordRecoveryRequestToJSON({ email: 'admin@example.test', portal: 'ADMIN', password: 'TestPassword12345', passwordConfirmation: 'TestPassword12345' })
assert.equal(completed.password_confirmation, 'TestPassword12345')
assert.equal(completed.code, undefined)
const proof = client.WebPasswordRecoveryEnvelopeFromJSON({ data: { verified: true, expires_in: 600, recovery_codes: ['TEST-ONLY'] }, meta: {}, errors: [] })
assert.equal(proof.data.expiresIn, 600)
assert.deepEqual(proof.data.recoveryCodes, ['TEST-ONLY'])
console.log('Vendor/Admin password recovery routes, security, schemas and TypeScript serialization passed.')
