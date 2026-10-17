import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { createRequire } from 'node:module'
import YAML from 'yaml'

const require = createRequire(import.meta.url)
const client = require('../generated/typescript/dist/index.js')
const spec = YAML.parse(readFileSync(new URL('../openapi.yaml', import.meta.url), 'utf8'))
const schemas = spec.components.schemas
assert.deepEqual(Object.keys(schemas.AdminInvitationRequest.properties.email).sort(), ['description', 'format', 'maxLength', 'type'])

for (const name of ['LoginRequest', 'PasswordRecoveryRequest', 'AdminInvitationRequest']) {
  assert.equal(schemas[name].properties.bot_protection.allOf[0].$ref, '#/components/schemas/VendorBotProtectionEvidence')
}
for (const [path, request] of [
  ['/auth/login', 'LoginRequest'],
  ['/auth/admin-invitations/accept', 'AdminInvitationRequest'],
  ['/auth/bot-challenges/{challenge_id}/verify', 'WebVerifyBotChallengeRequest'],
  ['/auth/bot-challenges/{challenge_id}/resend', 'WebResendBotChallengeRequest'],
]) {
  const operation = spec.paths[path].post
  assert.equal(operation.requestBody.content['application/json'].schema.$ref, `#/components/schemas/${request}`)
  assert.deepEqual(operation.security, [{ webCsrf: [] }])
}
for (const name of ['WebVerifyBotChallengeRequest', 'WebResendBotChallengeRequest']) {
  assert.deepEqual(schemas[name].properties.portal.enum, ['VENDOR', 'ADMIN'])
  assert.equal(schemas[name].properties.portal.default, undefined, 'The generated native client must not acquire a browser default.')
}
for (const name of ['VerifyBotChallengeRequest', 'ResendBotChallengeRequest']) {
  assert.equal(schemas[name].properties.portal, undefined)
}
for (const [suffix, name] of [['verify', 'VerifyBotChallengeRequest'], ['resend', 'ResendBotChallengeRequest']]) {
  assert.equal(spec.paths[`/mobile/auth/bot-challenges/{challenge_id}/${suffix}`].post.requestBody.content['application/json'].schema.$ref, `#/components/schemas/${name}`)
}
const invitation = client.AdminInvitationRequestToJSON({ token: 'test-invitation', email: 'admin@example.test', fullName: 'Test Admin', password: 'TestPassword123', passwordConfirmation: 'TestPassword123', termsAccepted: true, privacyAccepted: true, botProtection: { recaptchaToken: 'test-checkbox' } })
assert.deepEqual(invitation.bot_protection, { recaptcha_token: 'test-checkbox', request_email_step_up: undefined })
assert.equal(invitation.email, 'admin@example.test')
assert.equal(client.WebVerifyBotChallengeRequestToJSON({ email: 'admin@example.test', code: '123456', portal: 'ADMIN' }).portal, 'ADMIN')
assert.equal(client.WebResendBotChallengeRequestToJSON({ email: 'admin@example.test', portal: 'ADMIN' }).portal, 'ADMIN')
assert.equal(client.VerifyBotChallengeRequestToJSON({ email: 'buyer@example.test', code: '123456' }).portal, undefined)
console.log('Bot-protection contract and generated TypeScript serialization checks passed.')
