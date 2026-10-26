import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { spawnSync } from 'node:child_process'
import { fileURLToPath } from 'node:url'
import { parse } from 'yaml'

// Admin user directory contract test: every documented Buyer and Vendor directory operation exists as a read-only Laravel
// route on the Admin cookie transport, every route under /admin/buyers and /admin/vendors is documented, and no response
// schema carries coordinates, payment details, secrets or exact inventory.
const spec = parse(readFileSync(new URL('../openapi.yaml', import.meta.url), 'utf8'))
const routeFile = process.argv[2]
let routes
if (routeFile) {
  routes = JSON.parse(readFileSync(routeFile, 'utf8').replace(/^﻿/, ''))
} else {
  const result = spawnSync('php', ['artisan', 'route:list', '--json'], { cwd: fileURLToPath(new URL('../../../services/api/', import.meta.url)), encoding: 'utf8', timeout: 60000 })
  assert.equal(result.status, 0, 'Laravel route export must succeed')
  routes = JSON.parse(result.stdout)
}

const normalize = value => value.replace(/\{[^}]+\}/g, '{}')
const expected = new Set()
let count = 0
for (const [path, methods] of Object.entries(spec.paths)) {
  for (const [method, operation] of Object.entries(methods)) {
    if (!operation.tags?.includes('Admin User Directory')) continue
    count++
    const key = `${method.toUpperCase()} api/v1${normalize(path)}`
    expected.add(key)
    assert.equal(method, 'get', `${key} is read-only`)
    assert.ok(/^\/admin\/(buyers|vendors)/.test(path), `${path} belongs to the Buyer or Vendor directory`)
    const actual = routes.find(route => normalize(route.uri) === `api/v1${normalize(path)}` && route.method.split('|').includes('GET'))
    assert.ok(actual, `Missing Laravel route ${key}`)
    const has = (...names) => names.some(name => actual.middleware.includes(name))
    assert.ok(has('auth:api', 'Illuminate\\Auth\\Middleware\\Authenticate:api') && has('account.access:ADMIN', 'App\\Http\\Middleware\\RequireAccountAccess:ADMIN'), `${key} must authorize the ADMIN audience`)
    assert.ok(has('auth.transport:WEB', 'App\\Http\\Middleware\\SetAuthTransport:WEB') && has('auth.cookie', 'App\\Http\\Middleware\\AuthenticateFromCookie'), `${key} uses the web cookie transport`)
    assert.deepEqual(operation.security, [{ accessCookie: [], webCsrf: [] }], `${key} uses cookies with CSRF`)
    assert.ok(operation.responses['401'] && operation.responses['403'], `${key} documents authentication and authorization errors`)
    assert.match(operation.description ?? '', /user_directory\.view/, `${key} names the permission it needs`)
    if (path.includes('{')) assert.ok(operation.responses['404'], `${key} documents a missing profile`)
    // A list is always paginated.
    if (['/admin/buyers', '/admin/vendors', '/admin/buyers/{buyerId}/reviews', '/admin/vendors/{vendorId}/reviews', '/admin/vendors/{vendorId}/listings'].includes(path)) {
      const page = operation.parameters.find(parameter => parameter.name === 'page')
      assert.ok(page && page.schema.maximum === 1000, `${key} is paginated`)
    }
  }
}
assert.equal(count, 8, `Expected 8 directory operations, found ${count}`)

const photo = spec.paths['/admin/buyers/{buyerId}/photo'].get
assert.equal(photo.operationId, 'getDirectoryBuyerPhoto')
assert.deepEqual(photo.parameters.map(parameter => parameter.name), ['buyerId', 'expires', 'owner', 'version', 'viewer', 'signature'])
assert.ok(photo.parameters.every(parameter => parameter.required), 'Private Buyer photo parameters are required')
assert.deepEqual(photo.responses['200'].content['image/png'].schema, { type: 'string', format: 'binary' })
assert.match(photo.description, /current Admin session and permission/)
const photoRoute = routes.find(route => route.uri === 'api/v1/admin/buyers/{buyerId}/photo')
assert.ok(photoRoute.middleware.some(name => /(^signed$|ValidateSignature$)/.test(name)), 'Private Buyer photo needs a signed URL')
assert.ok(spec.components.schemas.DirectoryBuyerProfile.properties.profile.required.includes('avatar_url'))
assert.ok(spec.components.schemas.DirectoryVendorProfile.properties.store.required.includes('banner_url'))

const documented = /^api\/v1\/admin\/(buyers|vendors)(\/|$)/
for (const route of routes.filter(route => documented.test(route.uri))) {
  for (const method of route.method.split('|').filter(method => method !== 'HEAD')) {
    assert.ok(expected.has(`${method} ${normalize(route.uri)}`), `Undocumented directory route ${method} ${route.uri}`)
  }
}

const schemas = ['DirectoryBuyerRow', 'DirectoryBuyerProfile', 'DirectoryVendorRow', 'DirectoryVendorProfile', 'DirectoryReview', 'DirectoryListing', 'DirectorySanction']
for (const name of schemas) {
  const text = JSON.stringify(spec.components.schemas[name])
  assert.ok(text, `${name} is defined`)
  assert.ok(!/latitude|longitude|coordinates|site_instructions|password|secret|token|card|account_number|quantity_on_hand|hard_reserved/i.test(text.replace(/never coordinates or site instructions/g, '')), `${name} must not expose coordinates, credentials, payment details or exact inventory`)
}
assert.deepEqual(spec.components.schemas.DirectoryListing.properties.stock.enum, ['IN_STOCK', 'LIMITED_STOCK', 'OUT_OF_STOCK'], 'Stock is the public availability label only')
console.log(`Admin user directory contract checks passed (${count} operations).`)
