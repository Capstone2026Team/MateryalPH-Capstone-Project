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
  '/admin/dashboard',
  '/admin/dashboard/audit',
  '/vendor/onboarding',
  '/vendors/onboarding',
  '/vendors/onboarding/requirements',
  '/vendors/onboarding/verification',
  '/vendors/onboarding/verification/submit',
  '/vendors/onboarding/verification/commission',
  '/vendors/onboarding/setup',
  '/vendors/onboarding/setup/complete',
  '/vendors/onboarding/welcome/dismiss',
  '/vendors/onboarding/address/geocode',
  '/vendors/onboarding/address/areas',
  '/vendors/onboarding/address/resolve',
  '/vendors/onboarding/address/pin',
  '/vendors/onboarding/store-email',
  '/vendors/onboarding/store-email/confirm',
  '/vendors/onboarding/documents',
  '/vendors/onboarding/documents/pending/{requirementKey}',
  '/vendors/onboarding/media',
  '/vendors/onboarding/media/{mediaId}',
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

for (const [path, method] of [['/stores', 'get'], ['/stores/{storeId}/profile', 'get']]) {
  const operation = spec.paths[path]?.[method]
  assert.ok(operation, `Public Store path missing from OpenAPI: ${path}`)
  const route = actual.get(`GET /api/v1${path}`)
  assert.ok(route, `Laravel public Store route missing: ${path}`)
  assert.ok(!hasMiddleware(route, 'auth:api', 'Illuminate\\Auth\\Middleware\\Authenticate:api'), `Public Store route unexpectedly requires a Vendor session: ${path}`)
  const ref = operation.responses?.['200']?.content?.['application/json']?.schema?.$ref
  assert.ok(spec.components.schemas[ref?.split('/').at(-1)], `Public Store response envelope missing: ${path}`)
}
assert.equal(spec.components.schemas.VendorSetupDraft.properties.operating_schedule.minItems, 7)
assert.equal(spec.components.schemas.VendorSetupDraft.properties.operating_schedule.maxItems, 7)
assert.deepEqual(spec.components.schemas.StoreOperatingDay.properties.status.enum, ['OPEN', 'CLOSED'])
assert.equal(spec.components.schemas.VendorOnboardingSnapshot.properties.setup.properties.operating_schedule.items.$ref, '#/components/schemas/StoreOperatingDay')

for (const path of phaseThreePaths) {
  const item = spec.paths[path]
  assert.ok(item, `Phase 3 path missing from OpenAPI: ${path}`)
  for (const [method, operation] of Object.entries(item)) {
    if (! ['get', 'post', 'patch', 'delete'].includes(method)) continue
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
  if (/ \/api\/v1\/(vendor\/onboarding|vendors\/onboarding|admin\/vendor-verification|vendor-onboarding-files|webhooks\/xendit\/account-verification)/.test(key)) {
    assert.ok(expected.has(key), `Laravel Phase 3 route missing from OpenAPI: ${key}`)
  }
}

for (const path of [
  '/vendors/onboarding/verification/submit',
  '/vendors/onboarding/verification/commission',
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

const draft = spec.components.schemas.VendorVerificationDraft.properties
const tax = draft.tax_profile.properties
assert.equal(tax.tin.pattern, '^(?:[0-9]{12,14}|[0-9]{3}-[0-9]{3}-[0-9]{3}-[0-9]{3,5})$')
assert.equal(tax.tin.writeOnly, true)
assert.equal(tax.branch_code, undefined)
assert.equal(tax.branch_code_length, undefined)
assert.equal(tax.head_office, undefined)
assert.equal(draft.representative.properties.id_number.writeOnly, true)
assert.deepEqual(spec.components.schemas.AdminVendorVerificationDecision.properties.authority_scopes.items.enum, ['TAX_DECLARATIONS', 'COMMISSION_AGREEMENT', 'PAYMENT_CONFIGURATION'])
assert.deepEqual(spec.components.schemas.AdminVendorVerificationDecision.properties.requirement_versions.additionalProperties, { type: 'integer', minimum: 1 })

console.log(`Phase 3 contract passed: ${expected.size} Vendor/Admin operations match Laravel routes; private tax, representative, and authority schemas verified.`)

for (const field of ['requirements', 'drafts', 'lock_version']) assert.ok(spec.components.schemas.VendorOnboardingSnapshot.required.includes(field), `Authoritative snapshot is missing ${field}`)
assert.deepEqual(spec.components.schemas.StoreActivationBlocker.required, ['key', 'condition', 'reason'])

assert.equal(spec.paths['/vendors/onboarding/address/areas'].get.operationId, 'searchVendorAddressAreas')
assert.equal(spec.paths['/vendors/onboarding/address/pin'].post.operationId, 'resolveVendorAddressPin')
assert.deepEqual(spec.components.schemas.VendorAddressSelection.required, ['province_code', 'city_code', 'psgc_code'])
assert.ok(spec.components.schemas.VendorAddressSelection.properties.pin_token)

assert.equal(draft.classification.properties.custom_labels.items.maxLength, 60)
assert.equal(draft.classification.properties.custom_labels.type, 'array')

assert.equal(Object.hasOwn(draft, 'contacts'), false, 'Retired primary contacts must not be exposed')

assert.equal(spec.components.schemas.VendorDocument.properties.status.enum[0], 'PENDING_SUBMISSION')
assert.equal(spec.components.schemas.VendorDocument.properties.version.minimum, 0)
assert.ok(draft.form_state)

assert.equal(draft.classification.properties.custom_labels.items.minLength, 2)
assert.match(draft.address.description, /source MANUAL.*null coordinates/)

assert.deepEqual(spec.components.schemas.VendorCommissionAcceptance.required, ['organization_lock_version', 'agreement_version_id', 'accepted'])
assert.deepEqual(spec.components.schemas.VendorSetupComplete.required, ['organization_lock_version'])
assert.equal(spec.components.schemas.VendorSetupComplete.properties.commission_terms_accepted, undefined)

const vehicleSchema = spec.components.schemas.VendorSetupDraft.properties.vehicles
assert.equal(vehicleSchema.maxItems, undefined, 'Vehicle configurations must not have a fixed count cap')
for (const field of ['vehicle_category', 'vehicle_type', 'custom_type_name', 'brand', 'mixer_capacity_m3', 'image_file_id', 'active']) assert.ok(vehicleSchema.items.properties[field])
assert.ok(spec.components.schemas.VendorMediaUpload.properties.kind.enum.includes('VEHICLE_IMAGE'))
assert.match(spec.components.schemas.VendorSetupDraft.properties.delivery.properties.maximum_distance_km.description, /50 km/)

assert.equal(spec.components.schemas.VendorSetupDraft.properties.form_state.type, 'string')
assert.equal(spec.components.schemas.VendorSetupDraft.properties.form_state.maxLength, 65536)

const connectPayment = spec.paths['/vendors/onboarding/payment-connection'].post
assert.equal(connectPayment.operationId, 'connectVendorPayment')
assert.match(connectPayment.description, /POST \/v2\/accounts/)
assert.equal(connectPayment.requestBody, undefined, 'Provider IDs and invitations must never be client supplied')
assert.ok(connectPayment.responses['503'])
assert.deepEqual(spec.components.schemas.XenditAccountVerificationWebhook.required, ['event', 'created', 'data'])
assert.deepEqual(spec.components.schemas.XenditAccountVerificationWebhook.properties.event.enum, ['account.registered', 'account.activated'])

assert.deepEqual(spec.components.schemas.VendorPaymentOnboarding.required, ['status', 'environment'])
assert.deepEqual(spec.components.schemas.VendorPaymentOnboarding.properties.status.enum, ['NOT_CONNECTED', 'CONNECTING', 'PENDING', 'CONNECTED_TEST', 'CONNECTION_FAILED'])
assert.equal(spec.components.schemas.VendorPaymentOnboarding.properties.invitation_url, undefined)
