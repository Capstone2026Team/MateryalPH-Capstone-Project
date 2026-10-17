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
      assert.ok(hasMiddleware(route, 'auth:api', 'Illuminate\\Auth\\Middleware\\Authenticate:api'), `Passport guard missing: ${key}`)
      const audience = { buyers: 'BUYER', vendors: 'VENDOR', admin: 'ADMIN' }[portal]
      assert.ok(hasMiddleware(route, `account.access:${audience}`, `App\\Http\\Middleware\\RequireAccountAccess:${audience}`), `Portal authorization missing: ${key}`)
      const transport = portal === 'buyers' ? 'MOBILE' : 'WEB'
      assert.ok(hasMiddleware(route, `auth.transport:${transport}`, `App\\Http\\Middleware\\SetAuthTransport:${transport}`), `Transport guard missing: ${key}`)
      if (portal !== 'buyers') assert.ok(hasMiddleware(route, 'web.csrf', 'App\\Http\\Middleware\\VerifyAccountCsrf'), `Web CSRF guard missing: ${key}`)
    }
    for (const response of Object.values(operation.responses)) {
      const reference = response.content?.['application/json']?.schema?.$ref
      assert.ok(reference, `${operation.operationId} needs a defined response envelope`)
      assert.ok(spec.components.schemas[reference.split('/').at(-1)])
    }
  }
}
for (const [path, item] of Object.entries(spec.paths)) {
  if (!path.startsWith('/vendors/account/')) continue
  for (const [method, operation] of Object.entries(item)) {
    const key = `${method.toUpperCase()} /api/v1${path}`
    expected.add(key)
    const route = actual.get(key)
    assert.ok(route, `Contract route missing from Laravel: ${key}`)
    assert.ok(hasMiddleware(route, 'auth:api', 'Illuminate\\Auth\\Middleware\\Authenticate:api'), `Passport guard missing: ${key}`)
    assert.ok(hasMiddleware(route, 'account.access:VENDOR', 'App\\Http\\Middleware\\RequireAccountAccess:VENDOR'), `Vendor guard missing: ${key}`)
    assert.ok(hasMiddleware(route, 'web.csrf', 'App\\Http\\Middleware\\VerifyAccountCsrf'), `CSRF guard missing: ${key}`)
    assert.ok(operation.security?.length, `Security missing: ${key}`)
  }
}
const vendorInvite = spec.paths['/vendors/account/invitations']?.post
if (vendorInvite) {
  const key = 'POST /api/v1/vendors/account/invitations'
  expected.add(key)
  const route = actual.get(key)
  assert.ok(route, `Contract route missing from Laravel: ${key}`)
  assert.ok(hasMiddleware(route, 'auth:api', 'Illuminate\\Auth\\Middleware\\Authenticate:api'), `Passport guard missing: ${key}`)
  assert.ok(hasMiddleware(route, 'account.access:VENDOR', 'App\\Http\\Middleware\\RequireAccountAccess:VENDOR'), `Portal authorization missing: ${key}`)
  assert.ok(hasMiddleware(route, 'auth.transport:WEB', 'App\\Http\\Middleware\\SetAuthTransport:WEB'), `Transport guard missing: ${key}`)
  assert.ok(hasMiddleware(route, 'web.csrf', 'App\\Http\\Middleware\\VerifyAccountCsrf'), `Web CSRF guard missing: ${key}`)
  const reference = vendorInvite.responses?.['202']?.content?.['application/json']?.schema?.$ref
  assert.ok(reference && spec.components.schemas[reference.split('/').at(-1)], `${vendorInvite.operationId} needs a defined response envelope`)
}
for (const portal of ['vendors', 'admin']) {
  const path = '/{webAccountPortal}/account/photo'
  for (const method of ['get', 'post']) {
    assert.ok(spec.paths[path]?.[method]?.operationId)
    const key = `${method.toUpperCase()} /api/v1/${portal}/account/photo`
    expected.add(key)
    const route = actual.get(key)
    assert.ok(route, `Photo route missing: ${key}`)
    assert.ok(hasMiddleware(route, 'auth:api', 'Illuminate\\Auth\\Middleware\\Authenticate:api'))
    assert.ok(hasMiddleware(route, `account.access:${portal === 'admin' ? 'ADMIN' : 'VENDOR'}`, `App\\Http\\Middleware\\RequireAccountAccess:${portal === 'admin' ? 'ADMIN' : 'VENDOR'}`))
    assert.ok(hasMiddleware(route, 'web.csrf', 'App\\Http\\Middleware\\VerifyAccountCsrf'))
    if (method === 'get') assert.ok(hasMiddleware(route, 'signed', 'Illuminate\\Routing\\Middleware\\ValidateSignature'))
  }
}
for (const method of ['get', 'post']) {
  const operation = spec.paths['/buyers/account/photo']?.[method]
  assert.equal(operation?.operationId, method === 'get' ? 'getBuyerAccountPhoto' : 'uploadBuyerAccountPhoto')
  assert.deepEqual(operation.security, [{ passportBearer: [] }])
  const key = `${method.toUpperCase()} /api/v1/buyers/account/photo`
  expected.add(key)
  const route = actual.get(key)
  assert.ok(route, `Buyer photo route missing: ${key}`)
  assert.ok(hasMiddleware(route, 'auth:api', 'Illuminate\\Auth\\Middleware\\Authenticate:api'))
  assert.ok(hasMiddleware(route, 'account.access:BUYER', 'App\\Http\\Middleware\\RequireAccountAccess:BUYER'))
  assert.ok(hasMiddleware(route, 'auth.transport:MOBILE', 'App\\Http\\Middleware\\SetAuthTransport:MOBILE'))
  if (method === 'get') {
    assert.ok(hasMiddleware(route, 'signed', 'Illuminate\\Routing\\Middleware\\ValidateSignature'))
    assert.deepEqual(operation.parameters.map(parameter => parameter.name), ['expires', 'owner', 'version', 'signature'], 'Buyer photo query order must preserve Laravel signed URLs')
  }
  else {
    assert.deepEqual(operation.requestBody.content['multipart/form-data'].schema.required, ['photo', 'lock_version'])
    assert.ok(operation.responses['409'] && operation.responses['422'] && operation.responses['503'])
  }
}
for (const [path, method, operationId, throttled] of [
  ['/buyers/account/two-factor', 'post', 'startBuyerTwoFactor', true],
  ['/buyers/account/two-factor/confirm', 'post', 'confirmBuyerTwoFactor', true],
  ['/buyers/account/two-factor/disable', 'post', 'disableBuyerTwoFactor', true],
  ['/buyers/account/deletion', 'get', 'getBuyerAccountDeletionPreview', false],
  ['/buyers/account/deletion', 'post', 'deleteBuyerAccount', true],
]) {
  const operation = spec.paths[path]?.[method]
  assert.equal(operation?.operationId, operationId)
  assert.deepEqual(operation.security, [{ passportBearer: [] }])
  const key = `${method.toUpperCase()} /api/v1${path}`
  expected.add(key)
  const route = actual.get(key)
  assert.ok(route, `Buyer security route missing: ${key}`)
  assert.ok(hasMiddleware(route, 'auth:api', 'Illuminate\\Auth\\Middleware\\Authenticate:api'), `Passport guard missing: ${key}`)
  assert.ok(hasMiddleware(route, 'account.access:BUYER', 'App\\Http\\Middleware\\RequireAccountAccess:BUYER'), `Buyer guard missing: ${key}`)
  assert.ok(hasMiddleware(route, 'auth.transport:MOBILE', 'App\\Http\\Middleware\\SetAuthTransport:MOBILE'), `Transport guard missing: ${key}`)
  assert.equal(route.middleware.some(name => /(?:throttle|ThrottleRequests):account-security/.test(name)), throttled, `Throttle mismatch: ${key}`)
  for (const response of Object.values(operation.responses)) {
    const reference = response.$ref ?? response.content?.['application/json']?.schema?.$ref
    assert.ok(reference, `${operationId} needs a defined response`)
  }
}
assert.deepEqual(spec.components.schemas.BuyerAccountDeletionRequest.properties.confirmation.enum, ['DELETE'])
for (const id of ['completeBuyerMobileMfaChallenge', 'recoverBuyerMobileMfaChallenge']) {
  const path = id.startsWith('complete') ? '/mobile/auth/mfa/challenge' : '/mobile/auth/mfa/recovery'
  assert.equal(spec.paths[path]?.post?.operationId, id)
  assert.ok(!spec.paths[path].post.security, `${id} authenticates with the challenge token, not a session`)
  const route = actual.get(`POST /api/v1${path}`)
  assert.ok(route, `Native MFA route missing: ${path}`)
  assert.ok(hasMiddleware(route, 'auth.transport:MOBILE', 'App\\Http\\Middleware\\SetAuthTransport:MOBILE'), `Transport guard missing: ${path}`)
  assert.ok(route.middleware.some(name => /(?:throttle|ThrottleRequests):auth-public/.test(name)), `Throttle missing: ${path}`)
}
assert.ok(spec.components.schemas.AuthEnvelope.allOf[1].properties.data.properties.challenge_token)
for (const key of actual.keys()) {
  if (/ \/api\/v1\/(buyers|vendors|admin)\/account\//.test(key)) assert.ok(expected.has(key), `Laravel route missing from contract: ${key}`)
}
const invite = spec.paths['/{accountPortal}/account/invitations'].post
assert.ok(invite.parameters.some(parameter => parameter.name === 'Idempotency-Key' && parameter.required))
assert.deepEqual(spec.paths['/{accountPortal}/account/administrators'].get.parameters[0].schema.enum, ['admin'])
assert.deepEqual(spec.paths['/{accountPortal}/account/memberships'].get.parameters[0].schema.enum, ['vendors'])
console.log(`Account contract passed: ${expected.size} protected operations match Laravel routes, audiences, transport, and response envelopes.`)

for (const [path, id] of [['/vendors/account/memberships/{membershipId}', 'deleteVendorTeamMember'], ['/vendors/account/invitations/{invitationId}', 'deleteVendorTeamInvitation']]) {
  const operation = spec.paths[path].delete
  assert.equal(operation.operationId, id)
  assert.equal(operation.requestBody.content['application/json'].schema.$ref, '#/components/schemas/VendorTeamDeletion')
  assert.ok(operation.responses['409'])
  assert.ok(operation.responses['403'])
  assert.ok(operation.security.some(security => 'accessCookie' in security && 'webCsrf' in security))
}
assert.deepEqual(spec.components.schemas.VendorTeamDeletion.required, ['lock_version'])
assert.ok(spec.components.schemas.VendorTeamInvitationRecord.required.includes('can_delete'))
assert.ok(spec.components.schemas.VendorTeamInvitationRecord.required.includes('lock_version'))
console.log('Team deletion contract passed: versioned Owner deletion, cookie/CSRF guards and invitation eligibility.')

const staffAcceptance = spec.paths['/auth/vendor-invitations/accept'].post
assert.equal(staffAcceptance.operationId, 'acceptVendorStaffInvitation')
assert.equal(staffAcceptance.requestBody.content['application/json'].schema.$ref, '#/components/schemas/VendorInvitationAcceptance')
assert.ok(staffAcceptance.security.some(security => 'webCsrf' in security))
assert.match(staffAcceptance.description, /ACTIVE or PENDING_VERIFICATION/)
assert.match(staffAcceptance.description, /no retained Vendor membership/)
assert.match(staffAcceptance.responses['429'].description, /OTP_RESEND_THROTTLED.*unconsumed/)
assert.equal(spec.components.schemas.VendorInvitationAcceptance.properties.password.minLength, 1)
assert.equal(spec.components.schemas.VendorInvitationAcceptance.properties.bot_protection.allOf[0].$ref, '#/components/schemas/VendorBotProtectionEvidence')
assert.equal(staffAcceptance.responses['403'].$ref, '#/components/responses/BotStepUpResponse')
assert.ok(staffAcceptance.responses['503'])
assert.match(staffAcceptance.description, /vendor_invitation_accept/)
console.log('Staff acceptance contract passed: pending identity reconnection, existing credentials, email verification and atomic OTP cooldown.')
