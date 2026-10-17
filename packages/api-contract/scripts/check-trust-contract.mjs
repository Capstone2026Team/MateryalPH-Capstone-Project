import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { spawnSync } from 'node:child_process'
import { fileURLToPath } from 'node:url'
import { parse } from 'yaml'

// Phase 14 contract test: every documented review, score and Materials Analytics operation exists with the right
// transport and audience middleware, every Phase 14 route is documented, retry-sensitive mutations require an
// Idempotency-Key, signed photo links require the signature middleware, no review delete or badge award operation
// exists, and the Vendor analytics resources cannot carry competitor offers, identities or sub-threshold counts.
const spec = parse(readFileSync(new URL('../openapi.yaml', import.meta.url), 'utf8'))
const routeFile = process.argv[2]
let routes
if (routeFile) {
  routes = JSON.parse(readFileSync(routeFile, 'utf8'))
} else {
  const result = spawnSync('php', ['artisan', 'route:list', '--json', '-v'], { cwd: fileURLToPath(new URL('../../../services/api/', import.meta.url)), encoding: 'utf8', timeout: 60000 })
  assert.equal(result.status, 0, 'Laravel route export must succeed')
  routes = JSON.parse(result.stdout)
}
const TAGS = { 'Buyer Reviews': 'BUYER', 'Vendor Reviews': 'VENDOR', 'Vendor Store Performance': 'VENDOR', 'Admin Review Moderation': 'ADMIN', 'Admin Score Monitoring': 'ADMIN',
  'Buyer Materials Analytics': 'BUYER', 'Vendor Materials Analytics': 'VENDOR', 'Admin Materials Analytics': 'ADMIN' }
// Read-only analytics queries use POST only to keep Buyer origins out of URLs.
const NO_KEY = [/^\/buyers\/materials-analytics/]
const expected = new Set()
for (const [path, methods] of Object.entries(spec.paths)) {
  for (const [method, operation] of Object.entries(methods)) {
    const tag = operation.tags?.find(value => value in TAGS)
    if (!tag) continue
    const uri = `api/v1${path.replace(/\{[^}]+\}/g, '{}')}`
    const key = `${method.toUpperCase()} ${uri}`
    expected.add(key)
    const actual = routes.find(route => route.uri.replace(/\{[^}]+\}/g, '{}') === uri && route.method.split('|').includes(method.toUpperCase()))
    assert.ok(actual, `Missing Laravel route ${key}`)
    const audience = TAGS[tag]
    const has = (...names) => names.some(name => actual.middleware.includes(name))
    assert.ok(has('auth:api', 'Illuminate\\Auth\\Middleware\\Authenticate:api') && has(`account.access:${audience}`, `App\\Http\\Middleware\\RequireAccountAccess:${audience}`), `${key} must authorize the ${audience}`)
    if (audience !== 'BUYER' && method !== 'get') assert.ok(has('App\\Http\\Middleware\\VerifyAccountCsrf'), `${key} must verify CSRF`)
    if (audience === 'BUYER') assert.deepEqual(operation.security, [{ passportBearer: [] }], `${key} uses the native Buyer bearer`)
    else assert.deepEqual(operation.security, [{ accessCookie: [], webCsrf: [] }], `${key} uses cookies with CSRF`)
    assert.ok(operation.responses['401'] && operation.responses['403'], `${key} documents authentication and authorization errors`)
    if (method === 'post' && !NO_KEY.some(pattern => pattern.test(path))) {
      assert.ok(operation.parameters?.some(p => p.name === 'Idempotency-Key' && p.required), `${key} requires an Idempotency-Key`)
    }
    if (/\/content$/.test(path)) {
      assert.ok(has('signed', 'Illuminate\\Routing\\Middleware\\ValidateSignature'), `${key} is a short-lived signed link`)
      assert.ok(operation.parameters?.some(p => p.name === 'signature' && p.required), `${key} documents the signature`)
    }
  }
}
const phaseFourteen = /^api\/v1\/((buyers|vendor|admin)\/(reviews|materials-analytics)|(buyers|vendor)\/orders\/\{[^}]+\}\/(reviews|buyer-rating)|buyers\/(listings|stores)\/\{[^}]+\}\/reviews|vendor\/performance|admin\/scores)/
for (const route of routes.filter(route => phaseFourteen.test(route.uri))) {
  for (const method of route.method.split('|').filter(method => method !== 'HEAD')) {
    assert.ok(expected.has(`${method} ${route.uri.replace(/\{[^}]+\}/g, '{}')}`), `Undocumented Phase 14 route ${method} ${route.uri}`)
  }
}
// No operation deletes a review (photo retirement only) and none awards a badge or sets a score.
for (const [path, methods] of Object.entries(spec.paths)) {
  if (/reviews\/\{reviewId\}$/.test(path)) assert.ok(!('delete' in methods), `${path} must not delete a review`)
  assert.ok(!/\/badges$|\/scores\/\{vendorId\}\/(score|award)/.test(path), `${path} must not award a badge or set a score`)
}
assert.ok(!routes.some(route => /api\/v1\/vendor\/reviews\/\{[^}]+\}$/.test(route.uri) && route.method.includes('DELETE')), 'No Vendor review delete route')
const s = spec.components.schemas
const vendorReviewList = spec.paths['/vendor/reviews'].get
const productFilter = vendorReviewList.parameters.find(parameter => parameter.name === 'listing_id')
assert.ok(productFilter && productFilter.in === 'query' && productFilter.schema.format === 'uuid', 'Vendor review lists support an opaque product filter')
assert.match(productFilter.description, /only with type PRODUCT/, 'Product filtering cannot mix Store and Buyer ratings')
assert.ok(vendorReviewList.responses['404'], 'A foreign product filter is unavailable')
const vendorReviewDetail = spec.paths['/vendor/reviews/{reviewId}'].get
assert.equal(vendorReviewDetail.operationId, 'getVendorReview')
assert.match(vendorReviewDetail.description, /reviews\.view/, 'Review detail retains review viewing authorization')
assert.match(vendorReviewDetail.description, /blind reveal.*dispute.*moderation.*exclusion/, 'Review detail documents every current visibility gate')
assert.ok(vendorReviewDetail.responses['404'], 'A foreign or newly hidden review is unavailable')
assert.equal(vendorReviewDetail.responses['200'].content['application/json'].schema.$ref, '#/components/schemas/VendorReviewEnvelope')
assert.equal(s.VendorReviewEnvelope.properties.data.$ref, '#/components/schemas/VendorReviewRow')
assert.ok(s.VendorReviewRow.properties.product.oneOf.some(schema => schema.$ref === '#/components/schemas/ReviewProduct'))
assert.ok(s.VendorReviewRow.properties.product.oneOf.some(schema => schema.type === 'null'), 'Non-product ratings have no product')
assert.deepEqual(s.ReviewProduct.required, ['listing_id', 'name', 'variant_label'])
assert.equal(s.ReviewProduct.properties.listing_id.format, 'uuid')
assert.match(s.ReviewProduct.properties.name.description, /order line snapshot/, 'Product names come from purchase history')
assert.ok(!/buyer_id|profile_id|email|phone|coordinate|latitude|longitude/.test(JSON.stringify(s.ReviewProduct)), 'Review product context exposes no private identities or contact')
assert.equal(s.VendorReviewListEnvelope.properties.meta.$ref, '#/components/schemas/VendorReviewListMeta')
assert.equal(s.PublicReviewListEnvelope.properties.meta.$ref, '#/components/schemas/ReviewListMeta', 'Existing Buyer summary contracts stay unchanged')
assert.equal(s.VendorReviewListMeta.properties.summary.$ref, '#/components/schemas/ReviewSummary')
assert.deepEqual(s.ReviewSummary.required, ['count', 'average', 'distribution'])
assert.equal(s.ReviewSummary.properties.count.minimum, 0)
assert.ok(s.ReviewSummary.properties.average.oneOf.some(schema => schema.type === 'number' && schema.minimum === 1 && schema.maximum === 5))
assert.ok(s.ReviewSummary.properties.average.oneOf.some(schema => schema.type === 'null'), 'An unrated product has a null average')
assert.equal(s.ReviewSummary.properties.distribution.minItems, 5)
assert.equal(s.ReviewSummary.properties.distribution.maxItems, 5)
assert.equal(s.ReviewRatingBucket.properties.stars.minimum, 1)
assert.equal(s.ReviewRatingBucket.properties.stars.maximum, 5)
assert.equal(s.ReviewRatingBucket.properties.count.minimum, 0)
const vendorReviewsTs = readFileSync(new URL('../generated/typescript/src/apis/VendorReviewsApi.ts', import.meta.url), 'utf8')
const vendorReviewsDart = readFileSync(new URL('../generated/dart/lib/src/api/vendor_reviews_api.dart', import.meta.url), 'utf8')
assert.match(vendorReviewsTs, /getVendorReview\(/, 'TypeScript exposes review details')
assert.match(vendorReviewsTs, /listingId\?: string/, 'TypeScript exposes the product filter')
assert.match(vendorReviewsDart, /getVendorReview\(/, 'Dart exposes review details')
assert.match(vendorReviewsDart, /String\? listingId/, 'Dart exposes the product filter')
assert.match(readFileSync(new URL('../generated/typescript/src/models/ReviewSummary.ts', import.meta.url), 'utf8'), /average: number \| null/, 'TypeScript preserves the required nullable average')
assert.match(readFileSync(new URL('../generated/dart/lib/src/model/review_summary.dart', import.meta.url), 'utf8'), /num\? get average/, 'Dart preserves the required nullable average')
assert.deepEqual(s.ReviewModerationRequest.properties.action.enum, ['DISMISS_FLAG', 'REQUEST_CORRECTION', 'HIDE_PENDING_REVIEW', 'REMOVE', 'RESTORE'])
assert.deepEqual(s.BadgeSuppressionRequest.properties.reason_code.enum, ['FRAUD', 'COMPLIANCE'])
assert.ok(!s.BadgeSuppressionRequest.properties.badge_code.enum.includes('BEST_PRICE'), 'Best Price is evaluated at query time and never stored')
assert.deepEqual(s.ScoreExclusionRequest.properties.reason_code.enum, ['FRAUD', 'DUPLICATE', 'TEST', 'INVALID_SOURCE'])
// Vendor analytics resources: aggregates only, no identities, no offers, no exact sub-threshold count.
const identity = /store_name|vendor_id|organization|listing_id|offer|coordinate|latitude|longitude|minimum|maximum|vendor_ids|average_php_exact|logo/i
for (const name of ['VendorAnalyticsPoint', 'VendorCurrentCompetitors', 'VendorMaterialsAnalyticsList']) {
  for (const field of Object.keys(s[name].properties)) assert.ok(!identity.test(field), `${name}.${field} must not identify a competitor`)
}
assert.equal(s.VendorAnalyticsPoint.properties.competitor_count.minimum, 3, 'A displayed competitor count is never below three')
assert.ok(!Object.keys(spec.paths).some(path => /^\/vendor\/materials-analytics\/\{groupId\}\/offers/.test(path)), 'Vendors have no competitor-offers child')
for (const name of ['VendorAnalyticsRow', 'VendorMaterialsAnalyticsDetail', 'StorePerformance']) {
  for (const field of Object.keys(s[name].properties ?? {})) assert.ok(!/commission|withholding|earning|payout|taxpayer|remittance|fee_statement|transaction/i.test(field), `${name}.${field} must not expose protected finance`)
}
assert.equal(s.BuyerMaterialsAnalyticsRequest.additionalProperties, false, 'Undocumented analytics filters are refused')
assert.deepEqual(s.AnalyticsWindow.properties.max_days, { type: 'integer' })
assert.ok(JSON.stringify(s.AnalyticsTrend.properties.reason).includes('INSUFFICIENT_COMPETITOR_DATA'), 'Null trends carry their reason')
assert.ok(s.PublicBadge && s.ListingVendorCard.properties.badges && s.PublicStoreProfile.properties.badges, 'Badges are published on vendor cards and store profiles')
assert.equal(s.ReviewMediaForm.properties.files.maxItems, 3);
assert.deepEqual(s.ReviewMediaLink.properties.content_type.enum, ['image/jpeg', 'image/png', 'video/mp4', 'video/quicktime']);
for (const audience of ['buyers', 'vendor', 'admin']) {
  const content = spec.paths[`/${audience}/reviews/{reviewId}/media/{mediaId}/content`].get.responses['200'].content;
  assert.ok(content['video/mp4'] && content['video/quicktime'], 'Every authorized audience can inspect review videos');
}
assert.match(readFileSync(new URL('../generated/dart/lib/src/api/buyer_reviews_api.dart', import.meta.url), 'utf8'), /r'files\[\]': files.toList\(\)/, 'Dart uploads a PHP multipart array');
assert.match(readFileSync(new URL('../generated/typescript/src/apis/BuyerReviewsApi.ts', import.meta.url), 'utf8'), /append\('files\[\]'/, 'TypeScript uploads a PHP multipart array');
assert.match(spec.info.version, /phase\.(1[4-9]|20)$/)
console.log(`Trust and analytics contract passed: ${expected.size} operations, transports, signed links, idempotency, no delete/award path and aggregate-only Vendor analytics`)
