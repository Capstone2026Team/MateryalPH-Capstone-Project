import { readFileSync, writeFileSync } from 'node:fs';
import YAML from 'yaml';

// Phase 16 contract: Admin operations (versioned Platform Settings, Buyer/Vendor enforcement, privacy requests,
// append-only audit search, Integration and Job Health, Budget Override log), Philippine geographic analytics (PSGC
// drill-down, suppression, boundaries), FIN-10 finance queues and tax adjustments, the Vendor Owner finance review
// status, and additive extensions of the Phase 3E verification queue/case and the operations home. No operation
// edits or deletes an audit entry, reveals a secret, shows a balance, moves money or marks a provider connection ready.
// Idempotent: rerunning replaces the Phase 16 block and re-applies the additive edits.
const file = new URL('../openapi.yaml', import.meta.url);
const original = readFileSync(file, 'utf8');
const crlf = original.includes('\r\n');
let source = original.replace(/\r\n/g, '\n');
const ref = name => ({ $ref: `#/components/schemas/${name}` });
const str = { type: 'string' }, uuid = { type: 'string', format: 'uuid' }, int = { type: 'integer' }, bool = { type: 'boolean' }, dt = { type: 'string', format: 'date-time' }, date = { type: 'string', format: 'date' };
const json = { type: 'object', additionalProperties: true };
const any = {};
// OpenAPI 3.1 nulls (`type: [T, 'null']`), as the rest of the contract uses. Nullable properties are never required.
const NULLABLE = new WeakSet();
const nullable = schema => {
  const out = schema.oneOf ? { ...schema, oneOf: [...schema.oneOf, { type: 'null' }] }
    : typeof schema.type === 'string' ? { ...schema, type: [schema.type, 'null'], ...(schema.enum ? { enum: [...schema.enum, null] } : {}) } : { ...schema };
  NULLABLE.add(out);
  return out;
};
const arr = items => ({ type: 'array', items });
const enumOf = (...values) => ({ type: 'string', enum: values });
const optional = property => NULLABLE.has(property);
const obj = (properties, required = Object.keys(properties).filter(key => !optional(properties[key]))) => ({ type: 'object', required, properties });
// All properties optional. Typed properties are never mixed with additionalProperties: the Dart generator cannot build those.
const loose = properties => ({ type: 'object', properties });
const percent = nullable({ type: 'string', pattern: '^\\d{1,3}\\.\\d{2}$' });

const ENFORCEMENT_ACTIONS = ['WARNING', 'TEMPORARY_RESTRICTION', 'SUSPENSION', 'PERMANENT_BAN'];
const ENFORCEMENT_STATES = ['EFFECTIVE', 'REFERRED', 'APPLIED', 'LIFTED', 'DECLINED'];
const PLANS = ['CONTINUE', 'MONITORED_FULFILLMENT', 'CANCELLATION_REVIEW', 'REPLACEMENT', 'REFUND', 'NO_OPEN_ORDERS'];
const PRIVACY_TYPES = ['ACCESS', 'CORRECTION', 'OBJECTION', 'DELETION', 'RESTRICTION', 'PORTABILITY', 'OTHER'];
const PRIVACY_STATES = ['RECEIVED', 'IDENTITY_VERIFIED', 'IN_PROGRESS', 'COMPLETED', 'REJECTED', 'WITHDRAWN'];
const PRIVACY_CHANNELS = ['DPO_EMAIL', 'SUPPORT_CASE', 'WRITTEN_LETTER', 'IN_APP'];
const VERIFICATION_METHODS = ['REGISTERED_EMAIL_CONFIRMATION', 'SIGNED_IN_ACCOUNT_CONFIRMATION', 'GOVERNMENT_ID_SIGHTED', 'AUTHORIZED_REPRESENTATIVE_DOCUMENT_SIGHTED'];
const ORDER_STATES = ['CONFIRMED', 'PROCESSING', 'READY_FOR_PICKUP', 'OUT_FOR_DELIVERY', 'DELIVERED', 'PICKED_UP', 'COMPLETED', 'DISPUTED', 'CANCELLATION_REQUESTED', 'CANCELLED'];
const BLOCKER_CATEGORIES = ['ACCOUNT', 'TERMS', 'AUTHORITY', 'TAX', 'MEDIA', 'HOURS', 'SETUP', 'DELIVERY', 'PROVIDER_CAPABILITY', 'HOLD', 'VERIFICATION'];
const TAX_ADJUSTMENT_STATES = ['ADJUSTMENT_REQUIRED', 'UNDER_REVIEW', 'APPROVED', 'POSTED', 'REJECTED'];

const cell = { ...obj({ value: nullable(int), suppressed: bool, reason: nullable(str) }), description: 'A person-derived value; null with a reason when suppressed under the small-cell rule.' };
const rate = { ...obj({ percent, numerator: nullable(int), denominator: nullable(int), suppressed: nullable(bool), reason: nullable(str) }), description: 'Numerator and denominator are always shown with the percentage, or all null when suppressed.' };

const schemas = {
  PlatformSetting: { ...obj({ key: str, group: str, label: str, description: str, validation_rule: str, applies_to: str, value: any, default_value: any, version: int,
    previous_value: nullable(any), last_reason: nullable(str), updated_at: nullable(dt), updated_by: nullable(str), editable: bool }),
    description: 'An approved non-secret default. Version 0 means the approved default has never been stored; consuming rules apply it to new records only.' },
  FixedSetting: { ...obj({ key: str, label: str, value: nullable(any), reason: str }), description: 'Shown for transparency; there is no control (radius allowlist, VPS weights, NRPC cap, LIVE commerce, statutory rates).' },
  PlatformSettingListMeta: loose({ fixed: arr(ref('FixedSetting')), can_manage: bool, correlation_id: str }),
  PlatformSettingVersion: obj({ version: int, value: any, previous_value: nullable(any), source: enumOf('SEED', 'ADMIN'), reason: str, changed_by: nullable(str), changed_role: nullable(str), correlation_id: nullable(str), effective_from: dt }),
  PlatformSettingUpdateRequest: { type: 'object', required: ['value', 'expected_version', 'reason'], properties: { value: { description: 'The new value in the setting\'s shape.' }, expected_version: { type: 'integer', minimum: 0 },
    reason: { ...str, minLength: 10, maxLength: 500 } }, description: 'Needs platform_settings.manage and recent re-authentication. 409 SETTING_VERSION_CONFLICT for a stale version; 422 SETTING_INVALID with field errors.' },
  OperationsQueue: obj({ key: str, label: str, group: str, count: int, href: str, description: str, oldest_at: nullable(dt) }),
  EnforcementSummary: obj({ id: uuid, subject_type: enumOf('BUYER', 'VENDOR_ORGANIZATION'), subject_id: uuid, subject_name: str, action: enumOf(...ENFORCEMENT_ACTIONS), action_label: str,
    state: enumOf(...ENFORCEMENT_STATES), source: enumOf('DISPUTE_REFERRAL', 'DIRECT'), case_id: nullable(uuid), case_reference: nullable(str), reason: str, duration_days: nullable(int),
    continuation_plan: nullable(enumOf(...PLANS)), issued_role: nullable(str), applied_role: nullable(str), created_at: dt, applied_at: nullable(dt), expires_at: nullable(dt), lifted_at: nullable(dt),
    lift_reason: nullable(str), lock_version: int }),
  EnforcementEvent: obj({ event: enumOf('RECORDED', 'REFERRED', 'APPLIED', 'DECLINED', 'LIFTED', 'EXPIRED', 'SUPERSEDED'), from_state: nullable(str), to_state: str, before: nullable(json), after: nullable(json),
    reason: str, actor: str, actor_role: str, correlation_id: str, occurred_at: dt }),
  SubjectReview: { ...loose({ subject_type: str, subject_id: uuid, display_name: str, masked_email: nullable(str), account_status: str, store_activation_status: nullable(str), open_orders: int, orders_total: int,
    disputes_total: int, disputes_open: int, commerce_restricted_until: nullable(dt) }), description: 'Account-review facts only: no contact details, coordinates, documents or payment data.' },
  EnforcementDetail: { allOf: [ref('EnforcementSummary'), obj({ scope: str, restoration_condition: nullable(str), continuation_note: nullable(str), prior_subject_state: nullable(json),
    subject_review: ref('SubjectReview'), events: arr(ref('EnforcementEvent')), allowed_actions: arr(enumOf('APPLY', 'DECLINE', 'LIFT')) })] },
  EnforcementSubjectMatch: obj({ type: enumOf('BUYER', 'VENDOR_ORGANIZATION'), id: uuid, display_name: str, status: str }),
  EnforcementRecordRequest: { type: 'object', required: ['subject_type', 'subject_id', 'action', 'reason'], properties: { subject_type: enumOf('BUYER', 'VENDOR_ORGANIZATION'), subject_id: uuid,
    action: enumOf(...ENFORCEMENT_ACTIONS), reason: { ...str, minLength: 10, maxLength: 2000 }, scope: { ...str, maxLength: 160 }, duration_days: nullable({ type: 'integer', minimum: 1, maximum: 365 }),
    restoration_condition: nullable({ ...str, maxLength: 2000 }), continuation_plan: nullable(enumOf(...PLANS)), continuation_note: nullable({ ...str, maxLength: 2000 }) },
    description: 'A Warning is effective at once; other sanctions are applied at once. Permanent Ban needs enforcement.ban and recent re-authentication.' },
  EnforcementApplyRequest: { type: 'object', required: ['continuation_plan', 'lock_version', 'reason'], properties: { continuation_plan: enumOf(...PLANS), continuation_note: nullable({ ...str, maxLength: 2000 }),
    lock_version: { type: 'integer', minimum: 1 }, reason: { ...str, minLength: 10, maxLength: 2000 } } },
  ReasonedVersionRequest: { type: 'object', required: ['lock_version', 'reason'], properties: { lock_version: { type: 'integer', minimum: 1 }, reason: { ...str, minLength: 10, maxLength: 2000 } } },
  PrivacyRequestSummary: obj({ id: uuid, reference: str, request_type: enumOf(...PRIVACY_TYPES), state: enumOf(...PRIVACY_STATES), subject_account_type: str, subject_display: str,
    intake_channel: nullable(str), received_at: nullable(dt), target_date: nullable(date), handler: nullable(str), handler_user_id: nullable(int), identity_verified: bool, lock_version: int, created_at: nullable(dt) }),
  PrivacyRequestEvent: obj({ event: str, from_state: nullable(str), to_state: str, note: str, actor: str, actor_role: str, correlation_id: str, occurred_at: dt }),
  PrivacyHandler: obj({ user_id: int, name: str, role: str }),
  PrivacyRequestDetail: { allOf: [ref('PrivacyRequestSummary'), obj({ scope: nullable(str), response_summary: nullable(str), legal_exception: nullable(str), identity_verification_method: nullable(str),
    identity_verified_at: nullable(dt), subject_masked_email: str, completed_at: nullable(dt), events: arr(ref('PrivacyRequestEvent')),
    allowed_actions: arr(enumOf('ASSIGN', 'VERIFY', 'START', 'COMPLETE', 'REJECT', 'WITHDRAW')), handlers: arr(ref('PrivacyHandler')) })] },
  PrivacyRequestCreateRequest: { type: 'object', required: ['subject_email', 'request_type', 'intake_channel', 'received_on', 'scope', 'note'], properties: { subject_email: { ...str, format: 'email' },
    request_type: enumOf(...PRIVACY_TYPES), intake_channel: enumOf(...PRIVACY_CHANNELS), received_on: date, scope: { ...str, minLength: 10, maxLength: 4000 }, note: { ...str, minLength: 3, maxLength: 2000 } } },
  PrivacyTransitionRequest: { type: 'object', required: ['lock_version', 'note'], properties: { lock_version: { type: 'integer', minimum: 1 }, note: { ...str, minLength: 3, maxLength: 4000 },
    handler_user_id: int, target_date: nullable(date), verification_method: enumOf(...VERIFICATION_METHODS), legal_exception: nullable({ ...str, maxLength: 2000 }) } },
  AuditEvent: obj({ id: uuid, created_at: dt, actor: str, actor_role: nullable(str), action: str, resource_type: str, resource_id: nullable(uuid), organization: nullable(str), organization_id: nullable(uuid),
    succeeded: bool, reason: nullable(str), correlation_id: str, has_detail: bool }),
  AuditEventDetail: { allOf: [ref('AuditEvent'), obj({ before: nullable(any), after: nullable(any), redaction_note: str })] },
  AuditSearchMeta: loose({ next_cursor: nullable(str), page_size: int, can_view_detail: bool, can_export: bool }),
  IntegrationStatus: obj({ key: str, label: str, status: enumOf('HEALTHY', 'DEGRADED', 'NOT_CONFIGURED', 'SIMULATED'), detail: str, environment: nullable(str), last_event_at: nullable(dt) }),
  ScheduledTaskHealth: obj({ task: str, status: enumOf('HEALTHY', 'RUNNING', 'FAILED', 'OVERDUE', 'NO_RUN_RECORDED'), last_outcome: nullable(str), last_started_at: nullable(dt), duration_ms: nullable(int), expected_within_minutes: int }),
  IntegrationOverview: { ...obj({ generated_at: dt, environment: json, integrations: arr(ref('IntegrationStatus')), queues: json, scheduled_tasks: arr(ref('ScheduledTaskHealth')), analytics: json, can_retry: bool }),
    description: 'Configuration presence and masked labels only; credentials, payloads, recipients and exception messages never appear.' },
  OperationFailure: obj({ kind: enumOf('FAILED_JOB', 'OUTBOX_EVENT'), reference: str, label: str, queue: str, failure: str, attempts: nullable(int), failed_at: dt, retryable: bool, retry_note: nullable(str) }),
  OperationRetryRequest: { type: 'object', required: ['target_type', 'reference', 'reason'], properties: { target_type: enumOf('FAILED_JOB', 'OUTBOX_EVENT', 'GEO_FACTS_RUN', 'MATERIAL_SNAPSHOT'),
    reference: { ...str, maxLength: 80 }, reason: { ...str, minLength: 10, maxLength: 500 } } },
  OperationRetryResult: obj({ target_type: str, reference: str, label: str, outcome: enumOf('QUEUED'), correlation_id: str }),
  OperationRetryRecord: obj({ target_type: str, label: str, reason: str, outcome: str, actor: str, actor_role: str, correlation_id: str, created_at: dt }),
  BudgetOverrideRecord: obj({ id: uuid, project: str, work_package: str, order_reference: nullable(str), prior_budget_centavos: int, order_amount_centavos: int, overage_centavos: int, reason: str, actor: str, recorded_at: dt }),
  GeoCell: cell,
  GeoRate: rate,
  GeoBreadcrumb: obj({ code: nullable(str), name: str, level: nullable(str) }),
  GeoScope: obj({ code: nullable(str), name: str, level: nullable(str), level_label: str, label: str, breadcrumbs: arr(ref('GeoBreadcrumb')), children_label: str, drillable: bool,
    psgc_version: nullable(obj({ id: uuid, label: str, effective_on: str })) }),
  GeoDataset: obj({ environment: enumOf('TEST', 'DEMO'), label: str, demo: bool, last_aggregated_at: nullable(dt), through_date: nullable(str), revision: nullable(int), available: bool }),
  GeoResponseTime: obj({ suppressed: bool, reason: nullable(str), mean_seconds: nullable(int), median_seconds: nullable(int), p90_seconds: nullable(int), answered: nullable(int), unanswered: nullable(int) }),
  GeoActiveUsers: obj({ dau: ref('GeoCell'), wau: ref('GeoCell'), mau: ref('GeoCell') }),
  GeoKpis: obj({ vendor_count: ref('GeoCell'), registered_buyers: ref('GeoCell'), gross_gmv_centavos: ref('GeoCell'), net_gmv_centavos: ref('GeoCell'), order_volume: ref('GeoCell'),
    fulfillment_rate: ref('GeoRate'), cancellation_rate: ref('GeoRate'), dispute_rate: ref('GeoRate'), response_time: ref('GeoResponseTime'), active_users: obj({ buyer: ref('GeoActiveUsers'), vendor: ref('GeoActiveUsers') }) }),
  GeoTrendPoint: obj({ bucket: date, gross_gmv_centavos: nullable(int), net_gmv_centavos: nullable(int), order_volume: nullable(int), suppressed: bool, reason: nullable(str) }),
  GeoActivityPoint: obj({ date, buyer_dau: nullable(int), buyer_wau: nullable(int), buyer_mau: nullable(int), vendor_dau: nullable(int), vendor_wau: nullable(int), vendor_mau: nullable(int) }),
  GeoChild: obj({ code: str, name: str, level: str, level_label: str, drillable: bool, vendor_count: int, registered_buyers: obj({ value: nullable(int), suppressed: bool }),
    gross_gmv_centavos: obj({ value: nullable(int), suppressed: bool }), net_gmv_centavos: obj({ value: nullable(int), suppressed: bool }), order_volume: obj({ value: nullable(int), suppressed: bool }),
    fulfillment_rate: ref('GeoRate'), cancellation_rate: ref('GeoRate'), dispute_rate: ref('GeoRate'), median_response_seconds: nullable(int), response_suppressed: bool, suppressed: bool,
    suppression_reason: nullable(enumOf('SMALL_CELL', 'COMPLEMENTARY')), suppression_note: nullable(str) }),
  GeoFilterApplicability: obj({ filter: str, applies_to: arr(str), not_applicable_to: arr(str), note: str }),
  GeoDashboard: { ...obj({ scope: ref('GeoScope'), dataset: ref('GeoDataset'), period: obj({ from: date, to: date, granularity: enumOf('DAY', 'WEEK', 'MONTH') }), filters: json,
    filter_applicability: arr(ref('GeoFilterApplicability')), disclosure: obj({ minimum_persons: int, method: enumOf('ROLL_UP_TO_PARENT'), description: str }), kpis: ref('GeoKpis'),
    trends: arr(ref('GeoTrendPoint')), activity_trend: arr(ref('GeoActivityPoint')), children: arr(ref('GeoChild')),
    unresolved: obj({ orders: int, vendors: int, registered_buyers: int, responses: int, activity: int }), definitions: { type: 'object', additionalProperties: str } }),
    description: 'Aggregate facts only: PSGC codes and counts, never coordinates, Buyer identities or private evidence. Suppressed person-derived values are null with the reason; they stay counted in the parent total.' },
  GeoDemandCell: obj({ column: uuid, value: nullable({ oneOf: [int, str] }), suppressed: bool, reason: nullable(str) }),
  GeoDemand: obj({ scope: ref('GeoScope'), dataset: ref('GeoDataset'), measure: enumOf('ORDER_COUNT', 'QUANTITY', 'VALUE'), unit: nullable(str), dimension: enumOf('CATEGORY', 'MATERIAL'),
    columns: arr(obj({ id: uuid, name: str })), rows: arr(obj({ code: str, name: str, level: str, cells: arr(ref('GeoDemandCell')) })), not_comparable_lines: int, definition: str }),
  GeoBoundaryCollection: { ...obj({ type: enumOf('FeatureCollection'), features: arr(json), missing_codes: arr(str), psgc_version: obj({ id: uuid, label: str }) }),
    description: 'Simplified GeoJSON per child area; properties are code, name and level only. Areas without imported geometry are listed for the tile fallback.' },
  FinanceKpi: obj({ key: str, label: str, value_centavos: int, definition: str }),
  FinanceKpis: obj({ label: str, scenario: str, period: obj({ from: date, to: date }), commerce: arr(ref('FinanceKpi')), finance: arr(ref('FinanceKpi')), counts: { type: 'object', additionalProperties: int } }),
  RemittanceQueueRow: obj({ id: uuid, order_reference: str, vendor_name: str, environment: str, taxpayer_key_suffix: str, scenario: nullable(str), components: json,
    threshold_status_before: nullable(str), threshold_status_after: nullable(str), g_effective_before_centavos: nullable(int), g_effective_after_centavos: nullable(int),
    calculation_state: str, deduction_evidence_state: str, reconciliation_state: str, review_item_id: nullable(uuid), reason: str, created_at: dt }),
  TaxEvidenceRow: obj({ id: uuid, evidence_type: str, origin: str, valid_from: nullable(date), valid_until: nullable(date), review_state: str, reviewed_at: nullable(dt), tax_profile_version: int,
    taxable_year: nullable(int), vendor: obj({ id: uuid, name: str }), decision_href: str, created_at: dt, note: str }),
  TaxAdjustment: obj({ id: uuid, kind: str, state: enumOf(...TAX_ADJUSTMENT_STATES), environment: str, opened_by: enumOf('USER', 'SYSTEM'), order_reference: nullable(str), vendor_name: nullable(str),
    original_record_type: str, original_record_id: uuid, period_start: date, period_end: date, amount_centavos: int, before_values: json, after_values: json, reason: str, preparer: nullable(str),
    reviewer: nullable(str), reviewed_at: nullable(dt), posted_at: nullable(dt), created_at: nullable(dt), allowed_actions: arr(enumOf('PREPARE', 'APPROVE', 'REJECT', 'POST')), separation_note: nullable(str) }),
  TaxAdjustmentPrepareRequest: { type: 'object', required: ['corrected_withheld_centavos', 'reason', 'certificate_impact'], properties: { corrected_withheld_centavos: { type: 'integer', minimum: 0 },
    reason: { ...str, minLength: 10, maxLength: 2000 }, certificate_impact: enumOf('NONE', 'REISSUE_REQUIRED', 'AMENDMENT_REQUIRED'), evidence_reference: nullable({ ...str, maxLength: 200 }) } },
  TaxAdjustmentReviewRequest: { type: 'object', required: ['decision', 'reason'], properties: { decision: enumOf('APPROVED', 'REJECTED'), reason: { ...str, minLength: 10, maxLength: 2000 } },
    description: '409 PREPARER_CANNOT_REVIEW when the reviewer prepared the adjustment.' },
  VendorFinanceReviews: { ...obj({ label: str, statements: arr(json), tax_adjustments: arr(json), evidence: arr(json), open_reviews: arr(obj({ id: uuid, kind: str, label: str, created_at: dt })) }),
    description: 'Owner only. Statement approval and payment status, tax adjustments, evidence review state and open finance reviews; no reviewer notes or taxpayer identifiers.' },
  ActivationBlockerSource: loose({ type: str, label: str, revision: nullable(int), status: nullable(str), updated_at: nullable(dt) }),
  ActivationBlocker: obj({ key: str, condition: int, reason: str, category: enumOf(...BLOCKER_CATEGORIES), source: ref('ActivationBlockerSource') }),
  ActivationRestrictions: { ...obj({ ready: bool, status: str, rule_version: str, evaluated_at: dt, blockers: arr(ref('ActivationBlocker')), categories: arr(enumOf(...BLOCKER_CATEGORIES)),
    not_blocking: arr(str), override_available: { type: 'boolean', enum: [false] } }), description: 'StoreActivationGate result explained by source revision. There is no override; teams and products never block.' },
  VendorWorkstreams: obj({ verification: obj({ status: str }), setup: obj({ status: str }), provider_readiness: loose({ status: str, provider_status: nullable(str), environment: str, last_error_code: nullable(str), last_reconciled_at: nullable(dt), note: str }),
    activation: obj({ status: str, hold_code: nullable(str) }), discoverability: obj({ status: str, reason: nullable(str), evaluated_at: nullable(dt) }) }),
  AdminVendorVerificationDetail: { ...loose({ workstreams: ref('VendorWorkstreams'), activation_restrictions: ref('ActivationRestrictions'), readiness: json }),
    description: 'Documents the Phase 16 keys of the free-form Phase 3E case payload (AdminVendorVerificationDetailEnvelope.data): separate workstream states and source-revision activation restrictions.' },
};
const envelope = (name, data, meta = json) => { schemas[name] = obj({ data, meta, errors: arr(ref('ApiError')) }); };
envelope('PlatformSettingListEnvelope', arr(ref('PlatformSetting')), ref('PlatformSettingListMeta'));
envelope('PlatformSettingEnvelope', ref('PlatformSetting'));
envelope('PlatformSettingHistoryEnvelope', arr(ref('PlatformSettingVersion')));
envelope('EnforcementListEnvelope', arr(ref('EnforcementSummary')));
envelope('EnforcementDetailEnvelope', ref('EnforcementDetail'));
envelope('EnforcementSubjectMatchListEnvelope', arr(ref('EnforcementSubjectMatch')));
envelope('EnforcementSubjectEnvelope', { allOf: [ref('SubjectReview'), obj({ sanctions: arr(ref('EnforcementSummary')) })] });
envelope('PrivacyRequestListEnvelope', arr(ref('PrivacyRequestSummary')));
envelope('PrivacyRequestDetailEnvelope', ref('PrivacyRequestDetail'));
envelope('AuditEventListEnvelope', arr(ref('AuditEvent')), ref('AuditSearchMeta'));
envelope('AuditEventDetailEnvelope', ref('AuditEventDetail'));
envelope('AuditActionListEnvelope', arr(str));
envelope('IntegrationOverviewEnvelope', ref('IntegrationOverview'));
envelope('OperationFailureListEnvelope', arr(ref('OperationFailure')));
envelope('OperationRetryEnvelope', ref('OperationRetryResult'));
envelope('OperationRetryListEnvelope', arr(ref('OperationRetryRecord')));
envelope('BudgetOverrideListEnvelope', arr(ref('BudgetOverrideRecord')));
envelope('GeoDashboardEnvelope', ref('GeoDashboard'));
envelope('GeoDemandEnvelope', ref('GeoDemand'));
envelope('GeoBoundaryEnvelope', ref('GeoBoundaryCollection'));
envelope('FinanceKpiEnvelope', ref('FinanceKpis'));
envelope('RemittanceQueueEnvelope', arr(ref('RemittanceQueueRow')));
envelope('TaxEvidenceQueueEnvelope', arr(ref('TaxEvidenceRow')));
envelope('TaxAdjustmentListEnvelope', arr(ref('TaxAdjustment')));
envelope('TaxAdjustmentEnvelope', ref('TaxAdjustment'));
envelope('VendorFinanceReviewsEnvelope', ref('VendorFinanceReviews'));

const paths = {};
const keyParam = { name: 'Idempotency-Key', in: 'header', required: true, schema: uuid };
const errors = codes => Object.fromEntries(codes.map(code => [String(code), { $ref: '#/components/responses/ErrorResponse' }]));
const WEB = [{ accessCookie: [], webCsrf: [] }];
const page = { name: 'page', in: 'query', schema: { type: 'integer', minimum: 1, maximum: 1000 } };
const q = (name, schema, description) => ({ name, in: 'query', schema, ...(description ? { description } : {}) });
function op(path, method, operationId, tag, description, { response, request, keyed = false, created = false, accepted = false, query = [], codes = [401, 403, 404, 409, 422] } = {}) {
  const parameters = [...path.matchAll(/\{(.*?)\}/g)].map(m => ({ name: m[1], in: 'path', required: true,
    schema: m[1] === 'key' ? { ...str, pattern: '^[a-z0-9_.]+$' } : m[1] === 'type' ? enumOf('BUYER', 'VENDOR_ORGANIZATION') : m[1] === 'command' ? enumOf('assign', 'verify', 'start', 'complete', 'reject', 'withdraw') : uuid }));
  if (keyed) parameters.push(keyParam);
  parameters.push(...query);
  const success = { description: 'Authorized result.', content: { 'application/json': { schema: ref(response) } } };
  (paths[path] ??= {})[method] = { operationId, tags: [tag], description, security: WEB, ...(parameters.length ? { parameters } : {}),
    ...(request ? { requestBody: { required: true, content: { 'application/json': { schema: ref(request) } } } } : {}),
    responses: { [created ? '201' : accepted ? '202' : '200']: success, ...(created ? { '200': { description: 'Idempotent replay of the original result.', content: success.content } } : {}), ...errors(codes) } };
}

const PS = 'Admin Platform Settings';
op('/admin/platform-settings', 'get', 'listPlatformSettings', PS, 'platform_settings.view. Every approved non-secret default with its current version, validation rule and previous value, plus the fixed references that have no control.', { response: 'PlatformSettingListEnvelope', codes: [401, 403] });
op('/admin/platform-settings/{key}/history', 'get', 'listPlatformSettingHistory', PS, 'platform_settings.view. Append-only versions with previous value, reason, actor role and correlation ID.', { response: 'PlatformSettingHistoryEnvelope', codes: [401, 403, 404] });
op('/admin/platform-settings/{key}', 'put', 'updatePlatformSetting', PS, 'platform_settings.manage with recent re-authentication. Writes a new version; consuming rules apply it to new records only.', { response: 'PlatformSettingEnvelope', request: 'PlatformSettingUpdateRequest' });

const EN = 'Admin Enforcement';
op('/admin/enforcement', 'get', 'listEnforcementActions', EN, 'enforcement.view (Super Admin, User Management, Order and Dispute read-only). Referred sanctions first, oldest first.',
  { response: 'EnforcementListEnvelope', codes: [401, 403, 422], query: [q('state', enumOf(...ENFORCEMENT_STATES)), q('subject_type', enumOf('BUYER', 'VENDOR_ORGANIZATION')), q('action', enumOf(...ENFORCEMENT_ACTIONS)),
    q('source', enumOf('DISPUTE_REFERRAL', 'DIRECT')), q('subject_id', uuid), page] });
op('/admin/enforcement', 'post', 'recordEnforcementAction', EN, 'enforcement.apply. Record a Warning or apply a restriction, suspension or (Super Admin) ban with a reason, restoration condition and continuation plan for open orders.',
  { response: 'EnforcementDetailEnvelope', request: 'EnforcementRecordRequest', keyed: true, created: true });
op('/admin/enforcement/subjects', 'get', 'searchEnforcementSubjects', EN, 'enforcement.view. A Vendor by store name or a Buyer by exact account email; minimal identity only.',
  { response: 'EnforcementSubjectMatchListEnvelope', codes: [401, 403, 422], query: [{ name: 'type', in: 'query', required: true, schema: enumOf('BUYER', 'VENDOR_ORGANIZATION') }, { name: 'q', in: 'query', required: true, schema: { ...str, minLength: 3, maxLength: 120 } }] });
op('/admin/enforcement/subjects/{type}/{subjectId}', 'get', 'getEnforcementSubject', EN, 'enforcement.view. Account-review facts and the sanction history of one Buyer or Vendor.', { response: 'EnforcementSubjectEnvelope', codes: [401, 403, 404] });
op('/admin/enforcement/{actionId}', 'get', 'getEnforcementAction', EN, 'enforcement.view. Sanction, subject review, append-only events and the actions your role may take.', { response: 'EnforcementDetailEnvelope', codes: [401, 403, 404] });
op('/admin/enforcement/{actionId}/apply', 'post', 'applyEnforcementAction', EN, 'enforcement.apply (ban: enforcement.ban plus recent re-authentication). Apply a referred sanction; 409 on a stale lock_version.', { response: 'EnforcementDetailEnvelope', request: 'EnforcementApplyRequest' });
op('/admin/enforcement/{actionId}/decline', 'post', 'declineEnforcementAction', EN, 'enforcement.apply. Decline a referred sanction with a reason.', { response: 'EnforcementDetailEnvelope', request: 'ReasonedVersionRequest' });
op('/admin/enforcement/{actionId}/lift', 'post', 'liftEnforcementAction', EN, 'enforcement.apply (ban: enforcement.ban plus recent re-authentication). Lift an applied sanction; a store returns to READY or NOT_READY, never ACTIVE.', { response: 'EnforcementDetailEnvelope', request: 'ReasonedVersionRequest' });

const PR = 'Admin Privacy Requests';
op('/admin/privacy-requests', 'get', 'listPrivacyRequests', PR, 'privacy.manage sees every request; privacy.handle sees only requests assigned to you.',
  { response: 'PrivacyRequestListEnvelope', codes: [401, 403, 422], query: [q('state', enumOf(...PRIVACY_STATES)), q('request_type', enumOf(...PRIVACY_TYPES)), q('handler', enumOf('UNASSIGNED')), page] });
op('/admin/privacy-requests', 'post', 'recordPrivacyRequest', PR, 'privacy.manage. Record a request received through an official channel.', { response: 'PrivacyRequestDetailEnvelope', request: 'PrivacyRequestCreateRequest', keyed: true, created: true });
op('/admin/privacy-requests/{requestId}', 'get', 'getPrivacyRequest', PR, 'Assigned handler or privacy.manage; each opening is audited. Unassigned handlers receive 404.', { response: 'PrivacyRequestDetailEnvelope', codes: [401, 403, 404] });
op('/admin/privacy-requests/{requestId}/{command}', 'post', 'transitionPrivacyRequest', PR, 'Assign (privacy.manage), verify identity, start, complete, reject or withdraw with the current lock_version; closed requests are final.', { response: 'PrivacyRequestDetailEnvelope', request: 'PrivacyTransitionRequest' });

const AU = 'Admin Audit Log';
op('/admin/audit-log', 'get', 'searchAuditLog', AU, 'audit.view. Append-only safe projection filterable by actor, role, action, resource, organization, result, date, correlation ID and reason; cursor paginated.',
  { response: 'AuditEventListEnvelope', codes: [401, 403, 422], query: [q('actor', { ...str, maxLength: 120 }), q('actor_role', str), q('action', str), q('resource_type', str), q('resource_id', uuid), q('organization_id', uuid),
    q('result', enumOf('SUCCEEDED', 'FAILED')), q('correlation_id', str), q('reason', { ...str, maxLength: 200 }), q('from', date), q('to', date), q('cursor', str)] });
op('/admin/audit-log/actions', 'get', 'listAuditActions', AU, 'audit.view. Distinct action codes for the filter control.', { response: 'AuditActionListEnvelope', codes: [401, 403] });
op('/admin/audit-log/{auditId}', 'get', 'getAuditEvent', AU, 'audit.view_sensitive. Redacted before/after; the opening is itself audited. There is no edit or delete operation.', { response: 'AuditEventDetailEnvelope', codes: [401, 403, 404] });

const IH = 'Admin Integration Health';
op('/admin/integrations', 'get', 'getIntegrationHealth', IH, 'integrations.view. Provider, queue, scheduled-task, aggregation, Materials snapshot and PSGC health without secrets.', { response: 'IntegrationOverviewEnvelope', codes: [401, 403] });
op('/admin/integrations/failures', 'get', 'listOperationFailures', IH, 'integrations.view. Dead-lettered outbox deliveries or failed jobs: type and failure class only.', { response: 'OperationFailureListEnvelope', codes: [401, 403, 422], query: [q('kind', enumOf('OUTBOX', 'JOBS')), page] });
op('/admin/integrations/retries', 'get', 'listOperationRetries', IH, 'integrations.view. Recent authorized retries with reasons.', { response: 'OperationRetryListEnvelope', codes: [401, 403] });
op('/admin/integrations/retries', 'post', 'retryOperation', IH, 'jobs.retry. Retry an allowlisted idempotent failed job, outbox delivery or daily analytics run with a reason. Payment and refund work belongs to reconciliation (409 RETRY_NOT_ALLOWED).',
  { response: 'OperationRetryEnvelope', request: 'OperationRetryRequest', keyed: true, accepted: true });

op('/admin/budget-overrides', 'get', 'listBudgetOverrides', 'Admin Budget Overrides', 'budget_overrides.view. Read-only Buyer budget overrides; Buyer decisions need no Admin approval.', { response: 'BudgetOverrideListEnvelope', codes: [401, 403, 422], query: [page] });

const GA = 'Admin Geographic Analytics';
const geoQuery = [q('dataset', enumOf('TEST', 'DEMO')), q('area', { ...str, pattern: '^[0-9]{10}$' }, 'Active-version PSGC code of a region, province, independent city or city/municipality; omit for the Philippines. No radius applies.'),
  q('from', date), q('to', date), q('granularity', enumOf('DAY', 'WEEK', 'MONTH')), q('procurement_type', enumOf('ITEM_BASED', 'PROJECT_BASED')), q('category_id', uuid), q('material_id', uuid),
  q('fulfillment_method', enumOf('DELIVERY', 'PICKUP')), q('payment_method', enumOf('ONLINE', 'CASH_ON_DELIVERY', 'IN_STORE')), q('order_state', enumOf(...ORDER_STATES))];
op('/admin/geo-analytics', 'get', 'getGeoAnalyticsDashboard', GA, 'analytics.view_aggregates. KPIs, trends, rates, response time, DAU/WAU/MAU and the child-area table from daily facts, after small-cell suppression. Unknown parameters return 422 ANALYTICS_FILTER_UNSUPPORTED.',
  { response: 'GeoDashboardEnvelope', codes: [401, 403, 409, 422, 503], query: geoQuery });
op('/admin/geo-analytics/demand', 'get', 'getGeoDemandHeatmap', GA, 'analytics.view_aggregates. Category or material demand by child area; quantity needs one material (422 QUANTITY_NEEDS_MATERIAL).',
  { response: 'GeoDemandEnvelope', codes: [401, 403, 409, 422, 503], query: [...geoQuery, q('measure', enumOf('ORDER_COUNT', 'QUANTITY', 'VALUE'))] });
op('/admin/geo-analytics/boundaries', 'get', 'getGeoBoundaries', GA, 'analytics.view_aggregates. Simplified PSGC boundaries of the selection\'s children for the map.', { response: 'GeoBoundaryEnvelope', codes: [401, 403, 409, 422, 503], query: [q('area', { ...str, pattern: '^[0-9]{10}$' })] });

const FO = 'Admin Finance Operations';
op('/admin/finance/kpis', 'get', 'getFinanceKpis', FO, 'finance.view. Gross and net GMV beside assessed CWT, commission, platform revenue, collected cash and receivables (DEMO).', { response: 'FinanceKpiEnvelope', codes: [401, 403, 422], query: [q('from', date), q('to', date)] });
op('/admin/finance/remittances', 'get', 'listRemittanceQueue', FO, 'finance.view. Remittance reconciliation queue with FIN-05 components and FIN-04A threshold before/after.',
  { response: 'RemittanceQueueEnvelope', codes: [401, 403, 422], query: [q('reconciliation_state', enumOf('PENDING', 'RECONCILED', 'RECONCILIATION_EXCEPTION')), q('calculation_state', enumOf('CALCULATED', 'POSTED', 'BASE_REVIEW_REQUIRED', 'VOIDED')),
    q('deduction_evidence_state', enumOf('UNCONFIRMED', 'SIMULATED_WITHHELD', 'PROVIDER_REPORTED', 'PLATFORM_EVIDENCED')), page] });
op('/admin/finance/evidence', 'get', 'listTaxEvidenceQueue', FO, 'finance.view. Tax evidence review state; decisions are made in the Vendor Verification case.', { response: 'TaxEvidenceQueueEnvelope', codes: [401, 403, 422], query: [q('review_state', str), page] });
op('/admin/finance/tax-adjustments', 'get', 'listTaxAdjustments', FO, 'finance.view. Tax adjustments with preparer, reviewer and the actions available to you.', { response: 'TaxAdjustmentListEnvelope', codes: [401, 403, 422], query: [q('state', enumOf(...TAX_ADJUSTMENT_STATES)), page] });
op('/admin/finance/tax-adjustments/{adjustmentId}/prepare', 'post', 'prepareTaxAdjustment', FO, 'finance.review_tax. Record the proposed correction, reason, evidence reference and certificate impact.', { response: 'TaxAdjustmentEnvelope', request: 'TaxAdjustmentPrepareRequest' });
op('/admin/finance/tax-adjustments/{adjustmentId}/review', 'post', 'reviewTaxAdjustment', FO, 'finance.review_tax by a different user than the preparer.', { response: 'TaxAdjustmentEnvelope', request: 'TaxAdjustmentReviewRequest' });
op('/admin/finance/tax-adjustments/{adjustmentId}/post', 'post', 'postTaxAdjustment', FO, 'finance.review_tax. Post an approved adjustment as a linked compensating entry; posted assessments and the FIN-04A counter are never rewritten.', { response: 'TaxAdjustmentEnvelope' });

op('/vendor/finance/reviews', 'get', 'getVendorFinanceReviews', 'Vendor Finance Reviews', 'Vendor Owner only (finance.view). FIN-10 review status for this store.', { response: 'VendorFinanceReviewsEnvelope', codes: [401, 403] });

// Replace the Phase 16 blocks, then insert them ahead of Phase 14.
source = source.replace(/\n  # Phase 16 admin operations and geographic analytics operations[\s\S]*?(?=\n  # Phase 14 reviews, scores and analytics operations)/, '');
source = source.replace(/\n    # Phase 16 admin operations and geographic analytics schemas[\s\S]*?(?=\n    # Phase 14 reviews, scores and analytics schemas)/, '');
const indent = (text, pad) => YAML.stringify(text, { aliasDuplicateObjects: false, defaultStringType: 'QUOTE_DOUBLE', lineWidth: 0 }).split('\n').filter(Boolean).map(l => pad + l).join('\n');
source = source.replace('\n  # Phase 14 reviews, scores and analytics operations', '\n  # Phase 16 admin operations and geographic analytics operations\n' + indent(paths, '  ') + '\n  # Phase 14 reviews, scores and analytics operations');
source = source.replace('\n    # Phase 14 reviews, scores and analytics schemas', '\n    # Phase 16 admin operations and geographic analytics schemas\n' + indent(schemas, '    ') + '\n    # Phase 14 reviews, scores and analytics schemas');
source = source.replace(/version: 1\.0\.0-phase\.\d+/, 'version: 1.0.0-phase.16');

function editSchema(name, edit) {
  const pattern = new RegExp(`(\\n    ${name}:\\n)([\\s\\S]*?)(?=\\n    [A-Za-z#][A-Za-z0-9_ ]*:|$)`);
  if (!pattern.test(source)) throw new Error(`Schema ${name} not found`);
  source = source.replace(pattern, (_, heading, body) => heading + edit(body));
}
// Operations home: role-scoped queues on the existing dashboard summary.
editSchema('AdminDashboardSummary', body => body.replace(/\n        queues: .*/g, '') + '\n        queues: { type: array, items: { $ref: "#/components/schemas/OperationsQueue" }, description: "Only the queues your Admin permissions allow, with counts and the oldest pending item." }');
// Phase 3E queue: separate workstream columns.
editSchema('AdminVendorVerificationQueueItem', body => body.replace(/\n        (pending_requirements|oldest_pending_at|provider_status|discoverability_status|hold_code): .*/g, '')
  + '\n        pending_requirements: { type: integer, minimum: 0 }\n        oldest_pending_at: { type: [ string, \'null\' ], format: date-time }\n        provider_status: { type: string, description: "Technical TEST provider connection state; never live KYC." }'
  + '\n        discoverability_status: { type: string }\n        hold_code: { type: [ string, \'null\' ] }');
// The sectioned case stays free-form for every client; its Phase 16 keys are documented by AdminVendorVerificationDetail.
editSchema('AdminVendorVerificationDetailEnvelope', body => body.replace(/data: \{ \$ref: "#\/components\/schemas\/AdminVendorVerificationDetail" \}|data: \{ type: object, additionalProperties: true(?:, description: [^}]*)? \}/, 'data: { type: object, additionalProperties: true, description: "Sectioned case. Includes workstreams and activation_restrictions as documented by AdminVendorVerificationDetail." }'));
// Export types for audit and geographic analytics.
editSchema('DocumentExportInput', body => body.includes('- GEO_ANALYTICS') ? body : body.replace('            - TAX_PACKAGE\n', '            - TAX_PACKAGE\n            - AUDIT_LOG\n            - GEO_ANALYTICS\n'));

// Phase 3E queue filters and the overdue statement filter.
const queueParams = ['setup_status: [ NOT_STARTED, IN_PROGRESS, COMPLETED, CHANGES_REQUIRED ]', 'activation: [ ACTIVE, NOT_ACTIVE, READY, NOT_READY, RESTRICTED, SUSPENDED ]',
  'discoverability: [ DISCOVERABLE, NOT_DISCOVERABLE ]', 'blocker: [ MEDIA, HOURS, DELIVERY, AUTHORITY, TERMS, PROVIDER ]'];
source = source.replace(/\n        - \{ name: (setup_status|activation|discoverability|blocker|requirement_key|age_days|expiry_days), in: query.*\}/g, '');
source = source.replace(/(\n        - \{ name: sort, in: query, required: false, schema: \{ type: string, enum: \[ submitted_asc, submitted_desc, location)(?:, oldest_pending)?( \], default: submitted_desc \} \})/,
  (_, head, tail) => head + ', oldest_pending' + tail + queueParams.map(param => { const [name, values] = param.split(': '); return `\n        - { name: ${name}, in: query, required: false, schema: { type: string, enum: ${values} } }`; }).join('')
    + '\n        - { name: requirement_key, in: query, required: false, description: A requirement awaiting review., schema: { type: string, pattern: "^[a-z0-9_]+$" } }'
    + '\n        - { name: age_days, in: query, required: false, description: Oldest pending requirement at least this many days old., schema: { type: integer, minimum: 1, maximum: 365 } }'
    + '\n        - { name: expiry_days, in: query, required: false, description: An approved document expires within this many days., schema: { type: integer, minimum: 1, maximum: 365 } }');
source = source.replace(/, oldest_pending, oldest_pending/g, ', oldest_pending');
const statementsPath = /("\/admin\/finance\/statements":\n    "get":\n[\s\S]*?"parameters":\n)/;
if (!source.includes('"name": "overdue"')) source = source.replace(statementsPath, match => match + '        - "name": "overdue"\n          "in": "query"\n          "description": "Issued balances past their due date."\n          "schema":\n            "type": "boolean"\n');

for (const tag of [PS, EN, PR, AU, IH, 'Admin Budget Overrides', GA, FO, 'Vendor Finance Reviews']) {
  if (!source.includes(`  - name: ${tag}\n`)) source = source.replace('\ntags:\n', `\ntags:\n  - name: ${tag}\n`);
}
writeFileSync(file, crlf ? source.replace(/\n/g, '\r\n') : source);
console.log(`Authored ${Object.values(paths).reduce((n, methods) => n + Object.keys(methods).length, 0)} Phase 16 operations and ${Object.keys(schemas).length} schemas.`);
