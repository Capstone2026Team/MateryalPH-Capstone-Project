import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { spawnSync } from 'node:child_process'
import { fileURLToPath } from 'node:url'
import { resolve } from 'node:path'
import { parse } from 'yaml'

// Phase 4 contract: every catalog and product-compliance route matches OpenAPI in both
// directions, carries its authorization guards, and keeps the invariant schemas intact.
const root = fileURLToPath(new URL('../', import.meta.url))
const spec = parse(readFileSync(resolve(root, 'openapi.yaml'), 'utf8'))
let routes
if (process.argv[2]) routes = JSON.parse(readFileSync(process.argv[2], 'utf8').replace(/^﻿/, ''))
else {
  const result = spawnSync('php', ['artisan', 'route:list', '--json', '--path=api/v1'], { cwd: resolve(root, '../../services/api'), encoding: 'utf8', timeout: 60000 })
  assert.equal(result.status, 0, 'Laravel route export failed; provide an isolated route:list --json export as the first argument.')
  routes = JSON.parse(result.stdout)
}

const catalogPattern = / \/api\/v1\/(vendor\/catalog|admin\/product-compliance|admin\/taxonomy|catalog-files)/
const actual = new Map(routes.flatMap(route => route.method.split('|').filter(method => method !== 'HEAD').map(method => [`${method} /${route.uri}`, route])))
const hasMiddleware = (route, ...names) => names.some(name => route.middleware.includes(name))
const normalize = path => path.replace(/\{[^}]+\}/g, '{}')
const expected = new Set()

for (const [path, item] of Object.entries(spec.paths)) {
  for (const [method, operation] of Object.entries(item)) {
    if (!['get', 'post', 'put', 'patch', 'delete'].includes(method)) continue
    const key = `${method.toUpperCase()} /api/v1${path}`
    if (!catalogPattern.test(key)) continue
    expected.add(normalize(key))
    const route = [...actual.entries()].find(([candidate]) => normalize(candidate) === normalize(key))?.[1]
    assert.ok(route, `Laravel route missing for OpenAPI operation ${operation.operationId}: ${key}`)
    assert.ok(hasMiddleware(route, 'auth:api', 'Illuminate\\Auth\\Middleware\\Authenticate:api'), `Passport guard missing: ${key}`)
    assert.ok(hasMiddleware(route, 'auth.transport:WEB', 'App\\Http\\Middleware\\SetAuthTransport:WEB'), `Transport guard missing: ${key}`)
    const stream = path === '/catalog-files/{fileId}/content'
    const audience = path.startsWith('/admin/') ? 'ADMIN' : 'VENDOR'
    assert.ok(stream
      ? hasMiddleware(route, 'account.access', 'App\\Http\\Middleware\\RequireAccountAccess') && hasMiddleware(route, 'signed', 'Illuminate\\Routing\\Middleware\\ValidateSignature')
      : hasMiddleware(route, `account.access:${audience}`, `App\\Http\\Middleware\\RequireAccountAccess:${audience}`), `Portal authorization missing: ${key}`)
    if (!stream) assert.ok(hasMiddleware(route, 'web.csrf', 'App\\Http\\Middleware\\VerifyAccountCsrf'), `Web CSRF guard missing: ${key}`)
    if (method !== 'get') assert.ok(operation.security?.some(requirement => 'webCsrf' in requirement), `${operation.operationId} must declare webCsrf security`)
    for (const response of Object.values(operation.responses)) {
      const reference = response.content?.['application/json']?.schema?.$ref
      if (response.content?.['application/json']) assert.ok(reference && spec.components.schemas[reference.split('/').at(-1)], `${operation.operationId} references an unknown response envelope`)
    }
  }
}
for (const key of actual.keys()) {
  if (catalogPattern.test(key)) assert.ok(expected.has(normalize(key)), `Laravel catalog route missing from OpenAPI: ${key}`)
}

for (const [path, method] of [
  ['/vendor/catalog/listings', 'post'],
  ['/vendor/catalog/listings/{listingId}/publish', 'post'],
  ['/vendor/catalog/listings/{listingId}/compliance', 'post'],
  ['/vendor/catalog/imports/{jobId}/apply', 'post'],
  ['/admin/product-compliance/{submissionId}/decision', 'post'],
]) {
  assert.ok(spec.paths[path][method].parameters?.some(parameter => parameter.name === 'Idempotency-Key' && parameter.required), `${path} must require Idempotency-Key`)
}

const schemas = spec.components.schemas
assert.deepEqual(schemas.ListingStatus.enum, ['DRAFT', 'PENDING_COMPLIANCE', 'PENDING_ADMIN_REVIEW', 'ACTIVE', 'INACTIVE', 'TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED', 'REJECTED'])
assert.deepEqual(schemas.TaxCategory.enum, ['VAT_12', 'VAT_ZERO', 'VAT_EXEMPT', 'NON_VAT'])
assert.deepEqual(schemas.CompliancePath.enum, ['PHOTO_OCR', 'QR', 'MANUAL'])
assert.deepEqual(schemas.ComplianceReferenceResult.enum, ['MATCHED', 'UNMATCHED', 'UNCERTAIN', 'UNAVAILABLE'])
assert.equal(schemas.CatalogVariantInput.properties.price_centavos.type, 'integer', 'Money must be integer centavos')
assert.equal(schemas.CatalogPrice.properties.amount_centavos.type, 'integer', 'Money must be integer centavos')
assert.equal(schemas.CatalogListingUpdate.properties.tag_ids.maxItems, 3)
assert.equal(schemas.ComplianceSubmission.properties.confirmed.const, true, 'Review and Confirm must be explicit')
assert.ok(schemas.ProductComplianceDecision.required.includes('lock_version'), 'Admin decisions must name the reviewed version')
assert.equal(schemas.ProductComplianceDecision.properties.reason.minLength, 3)
assert.equal(schemas.CatalogListing.properties.completion.$ref, '#/components/schemas/CatalogCompletion', 'Wizard completion is server-derived')
assert.equal(schemas.CatalogListingUpdate.properties.status, undefined, 'Clients never submit a listing status')
assert.equal(schemas.CatalogListingUpdate.properties.compliance_status, undefined, 'Clients never submit a compliance decision')
assert.equal(schemas.CatalogListingSummary.properties.inventory, undefined, 'Listing summaries never expose exact inventory')
assert.equal(schemas.ComplianceEvidenceUpload.properties.file.format, 'binary')

console.log(`Phase 4 catalog contract passed: ${expected.size} catalog and product-compliance operations match Laravel routes and guards.`)
