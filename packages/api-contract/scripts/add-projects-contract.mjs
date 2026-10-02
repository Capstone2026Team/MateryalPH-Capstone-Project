import { readFileSync, writeFileSync } from 'node:fs';
import YAML from 'yaml';

const file = new URL('../openapi.yaml', import.meta.url);
let source = readFileSync(file, 'utf8');
const ref = name => ({ $ref: `#/components/schemas/${name}` });
const str = { type: 'string' }, uuid = { type: 'string', format: 'uuid' }, int = { type: 'integer' }, bool = { type: 'boolean' };
const json = { type: 'object', additionalProperties: true };
const nullable = type => ({ ...type, nullable: true });
const arr = items => ({ type: 'array', items });
const obj = (properties, required = Object.keys(properties).filter(k => !properties[k].nullable)) => ({ type: 'object', required, properties });
const money = { type: 'integer', minimum: 0, maximum: 100000000000 };
const schemas = {
  ProjectBudget: obj({ budget_centavos: int, pending_centavos: int, actual_centavos: int, awaiting_recovery_centavos: int, committed_centavos: int, remaining_centavos: int, utilization_percent: str, warning: bool, label: str, allocated_centavos: int, unallocated_centavos: int, pending_confirmation_count: int, processing_fee_status: str }),
  ProjectSite: obj({ id: uuid, name: str, discovery_origin: str, point: json }),
  ProjectSummary: obj({ id: uuid, name: str, status: { type: 'string', enum: ['ACTIVE','COMPLETED','ARCHIVED'] }, budget_centavos: int, starts_on: nullable(str), ends_on: nullable(str), lock_version: int, budget: ref('ProjectBudget') }),
  WorkPackageSummary: obj({ id: uuid, project_id: uuid, name: str, status: { type: 'string', enum: ['DRAFT','ACTIVE','QUOTATION_INQUIRY','VENDOR_SELECTED','AWAITING_PAYMENT','IN_PROGRESS','COMPLETED','CANCELLED'] }, budget_centavos: int, lock_version: int, current_version_id: nullable(uuid), selected_vendor_id: nullable(uuid), order_id: nullable(uuid) }),
  WorkPackagePage: obj({ items: arr(ref('WorkPackageSummary')), page: int, has_more: bool }),
  ProjectPage: obj({ items: arr(ref('ProjectSummary')), page: int, has_more: bool }),
  ProjectView: { ...obj({ id: uuid, name: str, status: str, budget_centavos: int, starts_on: nullable(str), ends_on: nullable(str), lock_version: int, budget: ref('ProjectBudget'), sites: arr(ref('ProjectSite')), packages: ref('WorkPackagePage') }) },
  WorkPackageVersion: obj({ id: uuid, version: int, content_hash: str, locked_at: nullable(str), content: json }),
  WorkPackageVersionPage: obj({ items: arr(ref('WorkPackageVersion')), page: int, has_more: bool }),
  WorkPackageView: obj({ id: uuid, project_id: uuid, project_status: {type:'string',enum:['ACTIVE','COMPLETED','ARCHIVED']}, name: str, status: str, budget_centavos: int, lock_version: int, current_version_id: nullable(uuid), selected_vendor_id: nullable(uuid), order_id: nullable(uuid), version: nullable(ref('WorkPackageVersion')), versions: ref('WorkPackageVersionPage'), budget: ref('ProjectBudget'), missing_lines: arr(json), document: json }),
  ProjectCreate: obj({ name: { ...str, maxLength: 150 }, budget_centavos: money, starts_on: str, ends_on: str, location_id: uuid }),
  ProjectUpdate: obj({ lock_version: int, name: str, budget_centavos: money, starts_on: str, ends_on: str, location_id: uuid, status: { type: 'string', enum: ['ACTIVE','COMPLETED','ARCHIVED'] } }, ['lock_version']),
  WorkPackageLineInput: obj({ material_id: uuid, name: { ...str, maxLength: 200 }, unit_id: uuid, quantity: { ...str, pattern: '^\\d{1,7}(\\.\\d{1,4})?$', description: 'Positive quantity within the selected normalized unit precision; maximum 1,000,000.' }, specifications: { type: 'object', additionalProperties: str }, preferred_brand: nullable(str) }),
  WorkPackageInput: obj({ lock_version: int, name: str, description: nullable(str), budget_centavos: money, site_id: uuid, radius_km: { type: 'integer', enum: [5,10,20,30,40,50] }, fulfillment_method: { type: 'string', enum: ['PICKUP','DELIVERY'] }, payment_method: { type: 'string', enum: ['ONLINE'] }, site_contact: nullable(str), heavy_vehicle_restriction: { type: 'string', enum: ['YES','NO'] }, alternate_drop_off_location_id: nullable(uuid), access_instructions: nullable(str), lines: { ...arr(ref('WorkPackageLineInput')), minItems: 1, maxItems: 100 } }, ['name','budget_centavos','site_id','radius_km','fulfillment_method','payment_method','lines']),
  ProjectVersionRequest: obj({ lock_version: { type: 'integer', minimum: 1 } }),
  ProjectCompile: obj({ lock_version: int, radius_km: { type: 'integer', enum: [5,10,20,30,40,50] } }),
  ProjectCandidateRequest: obj({ lock_version: int, candidate_id: uuid, note: nullable({ ...str, maxLength: 2000 }), budget_override_reason: nullable({ ...str, minLength: 10, maxLength: 2000 }) }, ['lock_version','candidate_id']),
  ProjectCandidate: obj({ id: uuid, estimate_id: uuid, vendor_id: uuid, store_name: str, rank: int, latitude: { type: 'number' }, longitude: { type: 'number' }, score_label: str, vps: nullable(str), fms: json, complete: bool, fulfillment_percent: str, missing_lines: arr(json), lines: arr(json), materials_centavos: int, included_vat_centavos: int, delivery_centavos: nullable(int), processing_fee_centavos: nullable(int), processing_fee_status: str, projected_total_centavos: nullable(int), budget_label: str, distance_meters: int, distance_basis: str, eta_seconds: nullable(int), fulfillment_method: str, payment_method: str, delivery: json, destination: json, expires_at: str, stale: bool, label: str, current_quotation_state: str }),
  ProjectCompiledEstimate: obj({ id: uuid, version_id: uuid, created_at: str, expires_at: str, state: str, context: json }),
  ProjectEstimatePage: obj({ estimate: nullable(ref('ProjectCompiledEstimate')), items: arr(ref('ProjectCandidate')), page: int, has_more: bool, total: int, suggested_radius_km: nullable(int) }),
  ProjectPreferences: obj({ weights: json, default_weights: json, personalized: bool, version: int, defaults_version: int, algorithm_version: str }),
  ProjectPreferenceSave: obj({ version: int, weights: json }),
  ProjectPreferenceReset: obj({ version: int }),
  ProjectMissingResolve: obj({ lock_version: int, order_id: nullable(uuid), reason: nullable({ ...str, minLength: 10, maxLength: 2000 }), budget_override_reason: nullable(str) }, ['lock_version']),
  ProjectImportRequest: obj({ csv: { ...str, maxLength: 100000 } }),
  ProjectImportPreview: obj({ lines: arr(ref('WorkPackageLineInput')), validation_errors: arr(json), valid: bool }),
  ProjectRoute: obj({ candidate_id: uuid, version_id: uuid, origin: { type: 'string', enum: ['PROJECT_SITE'] }, distance_meters: int, duration_seconds: int, encoded_polyline: str, duration_basis: str, computed_at: str }),
  ProjectMaterialPage: obj({ items: arr(json) }),
};
for (const name of ['ProjectView','ProjectPage','WorkPackageView','ProjectEstimatePage','ProjectPreferences','ProjectImportPreview','ProjectRoute','ProjectMaterialPage']) {
  schemas[name + 'Response'] = obj({ data: ref(name), meta: json, errors: arr(ref('ApiError')) });
}
const paths = {};
const key = { name: 'Idempotency-Key', in: 'header', required: true, schema: uuid };
const page = { name: 'page', in: 'query', schema: { type: 'integer', minimum: 1, maximum: 10000 } };
function operation(path, method, operationId, response, input, description, keyed = false, paginated = false) {
  const parameters = [...path.matchAll(/\{(.*?)\}/g)].map(m => ({ name: m[1], in: 'path', required: true, schema: uuid }));
  if (keyed) parameters.push(key);
  if (paginated) parameters.push(page);
  const success = operationId === 'createProject' || operationId === 'createWorkPackage' || operationId === 'inquireProjectVendor' || operationId === 'selectProjectVendor' ? '201' : '200';
  (paths[path] ??= {})[method] = { tags: ['Buyer Projects'], operationId, description, security: [{ passportBearer: [] }], parameters,
    ...(input ? { requestBody: { required: true, content: { 'application/json': { schema: ref(input) } } } } : {}),
    responses: { [success]: { description: 'Authorized Project procurement result.', content: { 'application/json': { schema: ref(response) } } },
      '401': { description: 'Authentication required.' }, '403': { description: 'Current Buyer authorization required.' }, '404': { description: 'No owned resource or current candidate.' }, '409': { description: 'Stale version, expired estimate, source change or already selected Vendor; no mutation.' }, '422': { description: 'Validation, fulfillment review or written budget override required.' }, '503': { description: 'Provider unavailable; retry without fabricated values.' } } };
}
operation('/buyers/projects','get','listProjects','ProjectPageResponse',null,'Paginated owned Projects and disjoint FIN-11 metrics.',false,true);
operation('/buyers/projects','post','createProject','ProjectViewResponse','ProjectCreate','Create an Active Project with a frozen site copied from the authenticated Buyer saved location.',true);
operation('/buyers/projects/{projectId}','get','getProject','ProjectViewResponse',null,'Project sites and paginated Work Packages.',false,true);
operation('/buyers/projects/{projectId}','patch','updateProject','ProjectViewResponse','ProjectUpdate','Edit before procurement history; complete/archive afterward. A site never replaces an accepted destination.',true);
operation('/buyers/projects/{projectId}/work-packages','post','createWorkPackage','WorkPackageViewResponse','WorkPackageInput','Save a Draft. Normalized units, positive quantities, explicit site and access are validated.',true);
operation('/buyers/work-packages/{packageId}','get','getWorkPackage','WorkPackageViewResponse',null,'Locked original, paginated version history, missing-item resolution and budget metrics. PDF generation remains Phase 15.',false,true);
operation('/buyers/work-packages/{packageId}','put','editWorkPackage','WorkPackageViewResponse','WorkPackageInput','Editable Draft only; saves an append-only draft version.',true);
operation('/buyers/work-packages/{packageId}/versions','post','createWorkPackageVersion','WorkPackageViewResponse','WorkPackageInput','Explicit correction version invalidates estimates and expires inquiries. Selected work requires prior order cancellation.',true);
operation('/buyers/work-packages/{packageId}/activate','post','activateWorkPackage','WorkPackageViewResponse','ProjectVersionRequest','Lock the original version; scan explicitly afterward.',true);
operation('/buyers/work-packages/{packageId}/close','post','closeWorkPackage','WorkPackageViewResponse','ProjectVersionRequest','Cancel an unassigned package, retaining every locked version. Selected work follows order cancellation rules.');
operation('/buyers/work-packages/{packageId}/estimates','get','getProjectEstimates','ProjectEstimatePageResponse',null,'Immutable, paginated snapshots. Complete one-Vendor matches first; missing lines explicit. Expiry is exactly 48 hours.',false,true);
operation('/buyers/work-packages/{packageId}/estimates','post','compileProjectEstimates','ProjectEstimatePageResponse','ProjectCompile','Scan eligible Bulk Yes Tier 2 offers within the confirmed radius from the Project site. FMS uses exact normalized weights. Unknown delivery cost remains pending; schedules never change validity or score.');
operation('/buyers/work-packages/{packageId}/inquiries','post','inquireProjectVendor','ChatIdResponse','ProjectCandidateRequest','Open/resume this eligible candidate inquiry only; attach locked original and Vendor-editable duplicate to the shared quotation engine.',true);
operation('/buyers/work-packages/{packageId}/selection','post','selectProjectVendor','ChatIdResponse','ProjectCandidateRequest','Select exactly one Vendor from a fresh estimate and expire other active quotations. Creates a manual 24-hour package request. Optional Note needs no Vendor response. No auto-accept.',true);
operation('/buyers/work-packages/{packageId}/candidates/{candidateId}/route','post','getProjectCandidateRoute','ProjectRouteResponse',null,'One decision route from the frozen Project site. Separate delivery endpoint/rate basis remains in the advisory estimate.');
operation('/buyers/work-packages/{packageId}/missing-lines/{lineId}','put','resolveProjectMissingLine','WorkPackageViewResponse','ProjectMissingResolve','Link a covering owned Item-Based order or explicitly waive with a reason. Linked child orders enter budgets once.');
operation('/buyers/work-packages/import-preview','post','previewWorkPackageCsv','ProjectImportPreviewResponse','ProjectImportRequest','Validate at most 100 CSV lines without saving. Header: material_code,name,unit_code,quantity,preferred_brand,specifications.');
operation('/buyers/project-ranking-preferences','get','getProjectRankingPreferences','ProjectPreferencesResponse',null,'Separate Project-Based preference record and active personalized indicator.');
operation('/buyers/project-ranking-preferences','put','saveProjectRankingPreferences','ProjectPreferencesResponse','ProjectPreferenceSave','Exactly four integer weights in [0,100] totaling 100. Defaults: material_match 40, budget_fit 25, distance 20, vps 15.');
operation('/buyers/project-ranking-preferences/reset','post','resetProjectRankingPreferences','ProjectPreferencesResponse','ProjectPreferenceReset','Reset to current platform defaults with version conflict protection.');
operation('/buyers/projects/{projectId}','delete','deleteProject','ChatEmptyResponse','ProjectVersionRequest','Delete only when no Work Packages or procurement history exists. Otherwise archive.');
operation('/buyers/work-packages/{packageId}','delete','deleteWorkPackage','ChatEmptyResponse','ProjectVersionRequest','Delete only a Draft with no locked historical version. Retain activated evidence.');
operation('/buyers/project-materials','get','searchProjectMaterials','ProjectMaterialPageResponse',null,'Up to eight canonical material suggestions, each with compatible normalized units. Buyer must explicitly select a suggestion.');
paths['/buyers/project-materials'].get.parameters.push({ name: 'query', in: 'query', required: true, schema: { ...str, minLength: 2, maxLength: 100 } });

source = source.replace(/\n  # Phase 10 Project operations[\s\S]*?(?=\ncomponents:)/, '');
source = source.replace(/\n    # Phase 10 Project schemas[\s\S]*$/, '');
source = source.replace('\ncomponents:', '\n  # Phase 10 Project operations\n' + YAML.stringify(paths, { aliasDuplicateObjects: false, defaultStringType: 'QUOTE_DOUBLE' }).split('\n').filter(Boolean).map(l => '  ' + l).join('\n') + '\ncomponents:');
source += '\n    # Phase 10 Project schemas\n' + YAML.stringify(schemas, { aliasDuplicateObjects: false, defaultStringType: 'QUOTE_DOUBLE' }).split('\n').filter(Boolean).map(l => '    ' + l).join('\n') + '\n';
source = source.replace('version: 1.0.0-phase.9','version: 1.0.0-phase.10');
// Preserve unrelated authored contract formatting. Extend shared decisions and quotation proposal fields.
// Scope edits to a single schema so repeated runs cannot backtrack into its neighbours.
source = source.replace(/^        budget_override_reason: \{ type: string, minLength: 10, maxLength: 2000 \}\n/gm, '');
source = source.replace(/^        description: \{ type: string, maxLength: 200 \}\n        specifications: \{ type: object, additionalProperties: \{ type: string \} \}\n/gm, '');
function extendSchema(name, fields) {
  const pattern = new RegExp(`(    ${name}:\\n)([\\s\\S]*?)(?=\\n    [A-Za-z][A-Za-z0-9_]*:|$)`);
  source = source.replace(pattern, (_, heading, body) => heading + body.replace('      properties:\n', '      properties:\n' + fields));
}
for (const name of ['ChatDecision','OrderRevisionDecision','NrpcAcceptRequest']) extendSchema(name, '        budget_override_reason: { type: string, minLength: 10, maxLength: 2000 }\n');
extendSchema('ChatDraftLine', '        description: { type: string, maxLength: 200 }\n        specifications: { type: object, additionalProperties: { type: string } }\n');
source = source.replace(/^        project_context: \{ type: object, additionalProperties: true, nullable: true \}\n/gm, '');
extendSchema('OrderDetail', '        project_context: { type: object, additionalProperties: true, nullable: true }\n');
writeFileSync(file, source);
console.log(`Authored ${Object.keys(paths).length} Project paths and ${Object.keys(schemas).length} schemas.`);
