import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { spawnSync } from 'node:child_process'
import { fileURLToPath } from 'node:url'
import { parse } from 'yaml'

const spec = parse(readFileSync(new URL('../openapi.yaml', import.meta.url), 'utf8'))
const routeFile = process.argv[2]
let routes
if (routeFile) {
  routes = JSON.parse(readFileSync(routeFile, 'utf8'))
} else {
  const result = spawnSync('php', ['artisan', 'route:list', '--json', '--path=api/v1/buyers'], { cwd: fileURLToPath(new URL('../../../services/api/', import.meta.url)), encoding: 'utf8', timeout: 60000 })
  assert.equal(result.status, 0, 'Laravel route export must succeed')
  routes = JSON.parse(result.stdout)
}
const expected = new Set()
for (const [path, methods] of Object.entries(spec.paths)) {
  for (const [method, operation] of Object.entries(methods)) {
    if (!operation.tags?.includes('Buyer Projects')) continue
    assert.deepEqual(operation.security, [{ passportBearer: [] }], `${operation.operationId} must use the configured native Buyer bearer transport`)
    const uri = `api/v1${path.replace(/\{[^}]+\}/g, '{}')}`
    const key = `${method.toUpperCase()} ${uri}`
    expected.add(key)
    const actual = routes.find(route => route.uri.replace(/\{[^}]+\}/g, '{}') === uri && route.method.split('|').includes(method.toUpperCase()))
    assert.ok(actual, `Missing Laravel route ${key}`)
    // route:list may export middleware as aliases or as resolved classes; accept either form.
    assert.ok(actual.middleware.some(value => value === 'auth:api' || value.endsWith('Authenticate:api')) && actual.middleware.some(value => value === 'account.access:BUYER' || value.endsWith('RequireAccountAccess:BUYER')), `${key} must authorize the Buyer`)
    assert.ok(operation.responses['401'] && operation.responses['403'] && operation.responses['409'], `${key} must document authentication, authorization and concurrency errors`)
  }
}
for (const route of routes.filter(route => /buyers\/(projects|work-packages|project-ranking-preferences|project-materials)/.test(route.uri))) {
  for (const method of route.method.split('|').filter(method => method !== 'HEAD')) assert.ok(expected.has(`${method} ${route.uri.replace(/\{[^}]+\}/g, '{}')}`), `Undocumented Project route ${route.uri}`)
}
const schemas = spec.components.schemas
for (const field of ['selected_arrangement_id', 'procurement_candidate_id', 'vendor_orders']) assert.ok(schemas.WorkPackageView.properties[field], 'Work Package detail must retain procurement resume fields')
assert.ok(schemas.ProjectSeparatePurchase.properties.load, 'Typed separate purchases retain delivery material classification')
assert.match(schemas.ProjectPreferenceSave.properties.weights.description, /persisted unchanged/)
assert.match(spec.paths['/buyers/project-ranking-preferences'].put.description, /WEIGHTS_ALL_ZERO/)
// Owner request 2026-10-17: 50 km is the only Project-Based radius, optional on every request that used to choose one.
assert.deepEqual(schemas.WorkPackageInput.properties.radius_km.enum, [50])
assert.ok(!schemas.WorkPackageInput.required.includes('radius_km') && !schemas.ProjectCompile.required.includes('radius_km') && !schemas.WorkPackageBudgetEstimateRequest.required.includes('radius_km'))
assert.deepEqual(schemas.ProjectCompile.properties.radius_km.enum, [50])
assert.deepEqual(schemas.WorkPackageBudgetEstimateRequest.properties.radius_km.enum, [50])
assert.equal(schemas.ProjectEstimatePage.properties.suggested_radius_km, undefined, 'the Project-Based radius is never widened')
assert.deepEqual(schemas.WorkPackageAlternativePage.properties.radius_km.enum, [50])
assert.deepEqual(schemas.WorkPackageInput.properties.heavy_vehicle_restriction.enum, ['YES', 'NO'])
assert.equal(schemas.ProjectCandidate.properties.delivery_centavos.nullable, true)
assert.equal(schemas.ProjectCandidate.properties.projected_total_centavos.nullable, true)
assert.ok(schemas.ChatDraftLine.properties.specifications)
assert.ok(schemas.ChatDecision.properties.budget_override_reason)
assert.ok(schemas.OrderDetail.properties.project_context)
// Owner decision 2026-10-12: unlisted lines, catalog details and an advisory materials-only estimate.
assert.equal(schemas.WorkPackageLineInput.properties.material_id.nullable, true)
assert.ok(schemas.WorkPackageLineInput.properties.description && schemas.WorkPackageLineInput.properties.color)
assert.deepEqual(schemas.ProjectMaterial.properties.match_type.enum, ['EXACT', 'ALIAS', 'FUZZY'])
assert.ok(schemas.ProjectMaterialPage.required.includes('units'))
assert.deepEqual(schemas.WorkPackageBudgetEstimateLine.properties.status.enum, ['PRICED', 'NO_PRICE_DATA', 'UNLISTED'])
assert.equal(schemas.WorkPackageBudgetEstimateLine.properties.amount_centavos.nullable, true)
// Vendor selection sorts/filters on the server; missing lines source separate, tagged Item-Based purchases.
const estimateParams = spec.paths['/buyers/work-packages/{packageId}/estimates'].get.parameters.map(p => p.name)
assert.ok(['sort', 'favorites_only', 'complete_only', 'within_budget'].every(name => estimateParams.includes(name)))
assert.ok(schemas.ProjectCandidate.properties.is_favorite)
assert.equal(schemas.WorkPackageAlternative.properties.stock_label.type, 'string')
assert.equal(schemas.WorkPackageAlternative.properties.available, undefined, 'exact inventory is never exposed')
assert.ok(schemas.CartItemCreate.properties.work_package_line_id && schemas.CartLine.properties.work_package_line_id)
// Owner decision 2026-10-16 removed Work Package versioning for the Buyer: no version routes or version fields remain.
// Owner request 2026-10-16: open details become a Buyer specification choice that select/inquiry carry.
assert.equal(schemas.ProjectCandidateRequest.properties.selections.items.$ref, '#/components/schemas/ProjectSpecificationSelection')
assert.deepEqual(schemas.ProjectSpecificationSelection.required, ['line_id', 'option_id'])
const preview = spec.paths['/buyers/work-packages/{packageId}/candidates/{candidateId}/selection-preview'].post
assert.equal(preview.requestBody.content['application/json'].schema.$ref, '#/components/schemas/ProjectSelectionPreview')
assert.equal(preview.responses['200'].content['application/json'].schema.$ref, '#/components/schemas/ProjectCandidateResponse')
assert.equal(schemas.ProjectCandidate.properties.selection_required.type, 'boolean')
assert.equal(schemas.WorkPackageAlternative.properties.specifications.items.$ref, '#/components/schemas/ProjectSpecificationDetail')
assert.equal(schemas.ProjectMaterialAttribute.properties.offered_values.items.type, 'string')
assert.equal(schemas.ListingDetails.properties.attribute_labels.items.$ref, '#/components/schemas/ListingAttributeLabel')
// Owner request 2026-10-17: one server-side fulfillment feeds the card, quotation and missing items; alternatives rank on the quantity still needed.
assert.equal(schemas.ProjectCandidate.properties.fulfillment.$ref, '#/components/schemas/ProjectFulfillment')
assert.ok(schemas.ProjectCandidate.required.includes('fulfillment'))
assert.deepEqual(schemas.ProjectFulfillment.properties.status.enum, ['COMPLETE', 'PARTIAL', 'NONE'])
assert.deepEqual(schemas.ProjectFulfillmentLine.properties.status.enum, ['FULFILLED', 'PARTIAL', 'UNFULFILLED'])
assert.deepEqual(schemas.WorkPackageAlternativePage.properties.status.enum, ['CATALOG', 'NO_SUITABLE_ALTERNATIVE', 'COVERED', 'UNLISTED'])
assert.ok(schemas.WorkPackageAlternativePage.required.includes('needed_quantity') && schemas.WorkPackageAlternativePage.required.includes('excluded'))
assert.deepEqual(schemas.WorkPackageAlternative.properties.availability.enum, ['FULL', 'PARTIAL'])
// The server sends the first photo as {url, alt_text}; a string schema made the generated client reject the whole page ("Something went wrong").
assert.ok(JSON.stringify(schemas.WorkPackageAlternative.properties.image).includes('#/components/schemas/ListingImage'), 'a photographed offer must deserialize')
assert.ok(spec.paths['/buyers/work-packages/{packageId}/lines/{lineId}/alternatives'].get.parameters.some(p => p.name === 'candidate_id'))
assert.equal(schemas.CartItemCreate.properties.allow_partial_stock.type, 'boolean')
console.log(`Project contract passed: ${expected.size} operations, protected routes and shared quotation/budget fields`)
