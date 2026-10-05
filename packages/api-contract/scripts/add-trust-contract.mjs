import { readFileSync, writeFileSync } from 'node:fs';
import YAML from 'yaml';

// Phase 14 contract: verified-purchase reviews (14-day window, blind reveal, 24-hour correction, dispute withholding,
// moderation), Store Performance and Admin Score & Badge Monitoring (exclusions and suppression; no award or score
// command), and MAT-01–MAT-07 Materials Analytics with separate Buyer, Vendor and Admin resources. The Vendor resource
// has no offer rows, competitor identities or sub-threshold counts. Idempotent: rerunning replaces the Phase 14 block.
const file = new URL('../openapi.yaml', import.meta.url);
const original = readFileSync(file, 'utf8');
const crlf = original.includes('\r\n');
let source = original.replace(/\r\n/g, '\n');
const ref = name => ({ $ref: `#/components/schemas/${name}` });
const str = { type: 'string' }, uuid = { type: 'string', format: 'uuid' }, int = { type: 'integer' }, bool = { type: 'boolean' }, dt = { type: 'string', format: 'date-time' }, date = { type: 'string', format: 'date' };
const json = { type: 'object', additionalProperties: true };
const nullable = type => ({ ...type, nullable: true });
const maybe = name => ({ oneOf: [ref(name), { type: 'null' }] });
const arr = items => ({ type: 'array', items });
const enumOf = (...values) => ({ type: 'string', enum: values });
const decimal = description => ({ type: 'string', pattern: '^-?\\d+\\.\\d{2}$', description });
const optional = property => property.nullable === true || (property.oneOf ?? []).some(option => option.type === 'null');
const obj = (properties, required = Object.keys(properties).filter(key => !optional(properties[key]))) => ({ type: 'object', required, properties });
const loose = properties => ({ type: 'object', properties });
const binary = { type: 'string', format: 'binary' };
const stars = { type: 'integer', minimum: 1, maximum: 5 };

const BADGES = ['FAST_RESPONDER', 'ON_TIME', 'MOST_ORDERED', 'HIGHLY_RATED', 'HIGH_QUALITY_MATERIALS', 'TRUSTED_SUPPLIER', 'BEST_PRICE'];
const STORED_BADGES = BADGES.filter(code => code !== 'BEST_PRICE');
const VISIBILITY = ['PUBLIC', 'HIDDEN_UNTIL_REVEAL', 'WITHHELD_ACTIVE_DISPUTE', 'HIDDEN_BY_MODERATION', 'REMOVED', 'EXCLUDED_BY_INVESTIGATION'];
const MODERATION_STATES = ['NONE', 'FLAGGED', 'HIDDEN_PENDING_REVIEW', 'CORRECTION_REQUESTED', 'REMOVED'];
const MODERATION_ACTIONS = ['DISMISS_FLAG', 'REQUEST_CORRECTION', 'HIDE_PENDING_REVIEW', 'REMOVE', 'RESTORE'];
const FLAG_REASONS = ['OFFENSIVE', 'PERSONAL_INFORMATION', 'SPAM', 'IRRELEVANT', 'CONFLICT_OF_INTEREST', 'FALSE_CLAIM', 'OTHER'];
const POINT_STATUS = ['OK', 'LIMITED_DATA', 'NO_LOCAL_OBSERVATIONS', 'SUPPRESSED', 'MISSING_DAY'];
const TREND_REASONS = ['INSUFFICIENT_LOCAL_DATA', 'INSUFFICIENT_COMPETITOR_DATA', 'MISSING_ENDPOINT_SNAPSHOT', 'ZERO_BASELINE', 'NO_PUBLISHED_HISTORY'];
const METRICS = ['ORDER_CONFIRMED', 'FULFILLMENT_DISPATCHED', 'ORDER_FULFILLED', 'ORDER_COMPLETED', 'VENDOR_NON_FULFILLMENT', 'VALIDATED_DEFECT_RETURN', 'ORDER_DEFECT', 'MISREPRESENTED_LISTING', 'INQUIRY'];

const reviewWindow = {
  order_id: uuid, order_reference: str, state: enumOf('NOT_COMPLETED', 'OPEN', 'CLOSED'), completed_at: nullable(dt), closes_at: nullable(dt), closes_at_label: nullable(str),
  revealed: bool, revealed_at: nullable(dt), reveal_reason: nullable(enumOf('BOTH_SUBMITTED', 'WINDOW_EXPIRED')), withheld_for_dispute: bool, rules: ref('ReviewWindowRules'),
};
const groupSummary = { group_id: uuid, display_name: str, material: ref('AnalyticsMaterialRef'), category: ref('AnalyticsCategoryRef'), specification: ref('ComparableSpecification'), unit: ref('AnalyticsUnit') };
const envelopeData = {
  audience: enumOf('BUYER', 'VENDOR', 'ADMIN'), scope: json, source_kind: enumOf('PUBLIC_LISTING'), dataset: ref('DatasetLabel'), window: ref('AnalyticsWindow'), current_as_of: dt,
  snapshot: maybe('AnalyticsSnapshotRef'), update_schedule: str, explanation: str,
};

const schemas = {
  PublicBadge: { ...obj({ code: enumOf(...BADGES), name: str, scope_label: nullable(str), description: str, earned_at: dt }), description: 'An active automatic badge, shown as text plus an icon. Admin-suppressed badges are omitted.' },
  ReviewWindowRules: obj({ window_days: int, edit_hours: int, comment_max: int, media_max: int, blind_reveal: str }),
  ReviewRatings: loose({ service_quality: stars, speed_rating: stars, speed_kind: enumOf('DELIVERY_SPEED', 'PROCESSING_SPEED'), product_quality: stars,
    inquiry_seriousness: stars, communication_quality: stars, payment_reliability: stars }),
  ReviewMediaLink: { ...obj({ id: uuid, url: str, expires_at: dt }), description: 'A five-minute signed link; the fetch re-authorizes the caller.' },
  PublicReview: { ...obj({ id: uuid, type: enumOf('VENDOR', 'PRODUCT', 'BUYER'), ratings: ref('ReviewRatings'), comment: nullable(str), display_name: str, verified_purchase: bool,
    submitted_at: nullable(dt), edited: bool, variant_label: nullable(str), media: arr(ref('ReviewMediaLink')) }), description: 'Privacy-safe public review: first name and last initial or Verified Buyer; no reviewer id or contact.' },
  OwnReview: obj({ id: uuid, type: enumOf('VENDOR', 'PRODUCT', 'BUYER'), ratings: ref('ReviewRatings'), comment: nullable(str), display_name: str, submitted_at: nullable(dt),
    editable_until: nullable(dt), editable_until_label: nullable(str), can_edit: bool, correction_requested: bool, correction_due_at: nullable(dt), visibility: enumOf(...VISIBILITY),
    revision: int, lock_version: int, media: arr(ref('ReviewMediaLink')) }),
  ReviewDisplayOption: obj({ choice: enumOf('FIRST_NAME_LAST_INITIAL', 'VERIFIED_BUYER'), preview: str }),
  ReviewLine: obj({ order_line_id: uuid, listing_id: uuid, display_name: str, variant_label: nullable(str), review: maybe('OwnReview'), can_review: bool }),
  CounterpartRating: obj({ ratings: ref('ReviewRatings'), comment: nullable(str), display_name: str, submitted_at: nullable(dt) }),
  BuyerOrderReviews: { ...obj({ ...reviewWindow, party: enumOf('BUYER'), speed_kind: enumOf('DELIVERY_SPEED', 'PROCESSING_SPEED'), speed_label: str, display_name_options: arr(ref('ReviewDisplayOption')),
    vendor_rating: maybe('OwnReview'), can_submit_vendor_rating: bool, lines: arr(ref('ReviewLine')), counterpart_rating: maybe('CounterpartRating') }),
    description: 'The Vendor\'s rating of the Buyer appears only after the blind reveal and while visible.' },
  VendorOrderReviews: obj({ ...reviewWindow, party: enumOf('VENDOR'), buyer_rating: maybe('OwnReview'), can_submit_buyer_rating: bool, received: arr(ref('PublicReview')) }),
  BuyerReviewSubmitRequest: { type: 'object', required: ['display_name_choice'], properties: {
    display_name_choice: enumOf('FIRST_NAME_LAST_INITIAL', 'VERIFIED_BUYER'),
    vendor_rating: nullable({ type: 'object', required: ['service_quality', 'speed_rating'], properties: { service_quality: stars, speed_rating: stars, comment: nullable({ ...str, maxLength: 1000 }) } }),
    product_reviews: { type: 'array', maxItems: 100, items: { type: 'object', required: ['order_line_id', 'rating'], properties: { order_line_id: uuid, rating: stars, comment: nullable({ ...str, maxLength: 1000 }) } } } },
    description: 'Any not-yet-submitted subset; each rating once per order or purchased line. Requires a COMPLETED order inside its 14-day window.' },
  BuyerReviewEditRequest: { type: 'object', required: ['lock_version'], properties: { lock_version: { type: 'integer', minimum: 1 }, service_quality: stars, speed_rating: stars, rating: stars, comment: nullable({ ...str, maxLength: 1000 }) } },
  VendorBuyerRatingRequest: { type: 'object', required: ['inquiry_seriousness', 'communication_quality', 'payment_reliability'], properties: { inquiry_seriousness: stars, communication_quality: stars, payment_reliability: stars, comment: nullable({ ...str, maxLength: 1000 }) } },
  VendorReviewEditRequest: { type: 'object', required: ['lock_version'], properties: { lock_version: { type: 'integer', minimum: 1 }, inquiry_seriousness: stars, communication_quality: stars, payment_reliability: stars, comment: nullable({ ...str, maxLength: 1000 }) } },
  ReviewMediaForm: { type: 'object', required: ['files'], properties: { files: { type: 'array', minItems: 1, maxItems: 3, items: binary, description: 'JPG or PNG, content-validated and scanned fail-closed.' } } },
  ReviewFlagRequest: { type: 'object', required: ['reason_code'], properties: { reason_code: enumOf(...FLAG_REASONS), details: nullable({ ...str, maxLength: 1000 }) } },
  ReviewReported: obj({ reported: bool }),
  ReviewListMeta: loose({ page: int, per_page: int, total: int, type: str, summary: json, scores: ref('PublicScores'), correlation_id: str }),
  VendorReviewRow: loose({ id: uuid, type: enumOf('VENDOR', 'PRODUCT', 'BUYER'), ratings: ref('ReviewRatings'), comment: nullable(str), display_name: str, verified_purchase: bool, submitted_at: nullable(dt),
    edited: bool, variant_label: nullable(str), media: arr(ref('ReviewMediaLink')), visibility: enumOf(...VISIBILITY), order_id: uuid, order_reference: str, can_report: bool }),
  ModerationQueueRow: obj({ id: uuid, type: enumOf('VENDOR', 'PRODUCT', 'BUYER'), moderation_state: enumOf(...MODERATION_STATES), order_reference: str, store_name: str, display_name: str,
    ratings: ref('ReviewRatings'), comment: nullable(str), open_flags: int, submitted_at: nullable(dt), updated_at: nullable(dt) }),
  ModerationDetail: loose({ id: uuid, type: str, ratings: ref('ReviewRatings'), comment: nullable(str), display_name: str, moderation_state: enumOf(...MODERATION_STATES), reviewer_party: enumOf('BUYER', 'VENDOR'),
    display_name_choice: str, author_display_rule: str, verified_purchase: json, related_dispute: nullable(json), revisions: arr(json), flags: arr(json), history: arr(json),
    available_actions: arr(enumOf(...MODERATION_ACTIONS)), media: arr(ref('ReviewMediaLink')), lock_version: int, visibility: enumOf(...VISIBILITY) }),
  ReviewModerationRequest: { type: 'object', required: ['action', 'reason', 'lock_version'], properties: { action: enumOf(...MODERATION_ACTIONS), reason: { ...str, minLength: 10, maxLength: 2000 }, lock_version: { type: 'integer', minimum: 1 } },
    description: 'There is no delete action. Request Correction hides the review and gives its author one correction within 7 days.' },

  PublicScores: obj({ label: str, new_vendor: bool, vps: nullable(decimal()), vcs: nullable(decimal()), mqs: nullable(decimal()), ohs: nullable(decimal()), as_of: nullable(date), badges: arr(ref('PublicBadge')) }),
  ScoreMetric: obj({ key: enumOf('VPS', 'VCS', 'MQS', 'OHS'), value: nullable(decimal()), published: bool, sample_count: int, minimum_sample: int, window: str, status_text: str }),
  BadgeMetric: obj({ key: enumOf('CRR', 'FRR'), value: nullable(decimal()), sample_count: int, window: str, definition: str }),
  BadgeState: obj({ code: enumOf(...STORED_BADGES), name: str, description: str, status: enumOf('EARNED', 'NOT_EARNED', 'SUPPRESSED'), scopes: arr(obj({ scope_label: nullable(str), earned_at: nullable(dt) })), suppression: nullable(json) }),
  ScoreHistoryPoint: obj({ date: date, vps: nullable(str), vcs: nullable(str), mqs: nullable(str), ohs: nullable(str) }),
  StorePerformance: { ...obj({ calculated: bool, as_of: nullable(date), calculated_at: nullable(dt), label: str, scores: arr(ref('ScoreMetric')), rating_components: json, operations: nullable(json),
    ohs_calculated_on: nullable(date), next_ohs_recalculation_on: date, badge_metrics: arr(ref('BadgeMetric')), completed_orders: json, history: arr(ref('ScoreHistoryPoint')), badges: arr(ref('BadgeState')) }),
    description: 'Owner and Store Manager. The same formulas and thresholds as the System Workflow; no Buyer identity, order amounts or protected finance.' },
  AdminScoreRow: obj({ vendor_id: uuid, store_name: str, scores: ref('PublicScores'), crr: nullable(str), frr: nullable(str), sample_counts: json, active_suppressions: int, active_exclusions: int }),
  AdminScoreDetail: { ...loose({ vendor_id: uuid, store_name: str, calculated: bool, as_of: nullable(date), label: str, scores: arr(ref('ScoreMetric')), operations: nullable(json), badge_metrics: arr(ref('BadgeMetric')),
    badges: arr(ref('BadgeState')), badge_history: arr(json), suppressions: arr(json), exclusions: arr(json), source_events: json, history: arr(ref('ScoreHistoryPoint')), can_investigate: bool }) },
  ScoreExclusionRequest: { type: 'object', required: ['order_id', 'reason_code', 'note'], properties: { order_id: uuid, reason_code: enumOf('FRAUD', 'DUPLICATE', 'TEST', 'INVALID_SOURCE'), note: { ...str, minLength: 10, maxLength: 2000 } } },
  BadgeSuppressionRequest: { type: 'object', required: ['badge_code', 'reason_code', 'case_reference', 'note'], properties: { badge_code: enumOf(...STORED_BADGES), reason_code: enumOf('FRAUD', 'COMPLIANCE'),
    case_reference: { ...str, minLength: 3, maxLength: 120 }, note: { ...str, minLength: 10, maxLength: 2000 } }, description: 'Display suppression for a documented fraud or compliance case. There is no award command.' },
  InvestigationReasonRequest: { type: 'object', required: ['reason'], properties: { reason: { ...str, minLength: 10, maxLength: 2000 } } },

  AnalyticsMaterialRef: obj({ id: uuid, name: str }),
  AnalyticsCategoryRef: obj({ id: uuid, code: str, name: str }),
  AnalyticsUnit: obj({ code: str, name: str }),
  ComparableSpecification: obj({ brand: nullable(str), model: nullable(str), attributes: arr(obj({ key: str, value: str })) }),
  AnalyticsWindow: obj({ preset_days: nullable(int), start_date: nullable(date), end_date: nullable(date), earliest_available_date: nullable(date), latest_available_date: nullable(date), max_days: int, presets: arr(int) }),
  AnalyticsSnapshotRef: obj({ date: date, observed_at: dt, revision: int }),
  AnalyticsTrend: { ...obj({ change_percent: nullable(decimal('((end − start) / start) × 100 from unrounded means, half-up to 2 dp')), direction: nullable(enumOf('INCREASING', 'DECREASING', 'NO_MATERIAL_CHANGE')),
    reason: nullable(enumOf(...TREND_REASONS)), composition_changed: nullable(bool), start_date: nullable(date), end_date: nullable(date), label: nullable(str), composition_note: nullable(str) }),
    description: 'Endpoints are exact dates; a missing or insufficient endpoint returns a null percentage with its reason — never zero.' },
  BuyerAnalyticsPoint: obj({ date: date, status: enumOf(...POINT_STATUS), label: nullable(str), average_php: nullable(decimal('Equal-Vendor mean, PHP per canonical unit')), vendor_count: nullable(int), participants_changed: nullable(bool) }),
  VendorAnalyticsPoint: { ...obj({ date: date, status: enumOf('OK', 'SUPPRESSED', 'MISSING_DAY'), label: nullable(str), average_php: nullable(decimal('Competitor equal-Vendor mean excluding your organization')),
    competitor_count: nullable({ type: 'integer', minimum: 3 }), participants_changed: nullable(bool) }), description: 'Below three competing Vendors every value and count is null; the sub-threshold count is never returned.' },
  AdminAnalyticsPoint: obj({ date: date, status: enumOf(...POINT_STATUS), label: nullable(str), average_php: nullable(decimal()), average_php_exact: nullable(str), vendor_count: nullable(int), participants_changed: nullable(bool) }),
  AnalyticsCurrentCounts: obj({ vendor_count: int, listing_count: int, status: enumOf('AVAILABLE', 'NO_CURRENT_OFFERS') }),
  VendorCurrentCompetitors: obj({ competitor_count: nullable({ type: 'integer', minimum: 3 }), status: enumOf('AVAILABLE', 'SUPPRESSED'), label: nullable(str) }),
  VendorOwnOffer: { ...obj({ listing_id: uuid, variant_id: uuid, display_name: str, variant_label: nullable(str), price_centavos: int, normalized_php: decimal(), tax_label: str, price_as_of: dt }),
    description: 'Your own current comparable price; never part of the competitor average.' },
  BuyerAnalyticsRow: obj({ ...groupSummary, start_point: ref('BuyerAnalyticsPoint'), end_point: ref('BuyerAnalyticsPoint'), trend: ref('AnalyticsTrend'), current: ref('AnalyticsCurrentCounts') }),
  VendorAnalyticsRow: obj({ ...groupSummary, start_point: ref('VendorAnalyticsPoint'), end_point: ref('VendorAnalyticsPoint'), trend: ref('AnalyticsTrend'), current_competitors: ref('VendorCurrentCompetitors'), own_offer: maybe('VendorOwnOffer') }),
  AdminAnalyticsRow: obj({ ...groupSummary, start_point: ref('AdminAnalyticsPoint'), end_point: ref('AdminAnalyticsPoint'), trend: ref('AnalyticsTrend'), current: ref('AnalyticsCurrentCounts') }),
  ComparableVariant: obj(groupSummary),
  BuyerMaterialsAnalyticsList: obj({ ...envelopeData, items: arr(ref('BuyerAnalyticsRow')), next_cursor: nullable(str) }),
  VendorMaterialsAnalyticsList: obj({ ...envelopeData, items: arr(ref('VendorAnalyticsRow')), next_cursor: nullable(str) }),
  AdminMaterialsAnalyticsList: obj({ ...envelopeData, items: arr(ref('AdminAnalyticsRow')), next_cursor: nullable(str) }),
  BuyerMaterialsAnalyticsDetail: obj({ ...envelopeData, group: { allOf: [ref('BuyerAnalyticsRow'), loose({ description: nullable(str) })] }, variants: arr(ref('ComparableVariant')), series: arr(ref('BuyerAnalyticsPoint')) }),
  VendorMaterialsAnalyticsDetail: obj({ ...envelopeData, group: { allOf: [ref('VendorAnalyticsRow'), loose({ description: nullable(str) })] }, variants: arr(ref('ComparableVariant')), series: arr(ref('VendorAnalyticsPoint')), can_edit_own_listing: bool }),
  AdminMaterialsAnalyticsDetail: obj({ ...envelopeData, group: { allOf: [ref('AdminAnalyticsRow'), loose({ description: nullable(str) })] }, variants: arr(ref('ComparableVariant')), series: arr(ref('AdminAnalyticsPoint')), can_inspect_sources: bool }),
  MaterialOffer: { ...obj({ vendor_id: uuid, store_name: str, listing_id: uuid, variant_id: uuid, display_name: str, variant_label: nullable(str), price_centavos: int, normalized_php: decimal(), tax_category: str,
    tax_label: str, availability: enumOf('IN_STOCK', 'LIMITED_STOCK', 'OUT_OF_STOCK'), distance_meters: int, price_as_of: dt }), description: 'Buyer-only current public offer; opens the existing Product Details. Never exact stock.' },
  AnalyticsSource: obj({ observation_id: uuid, store_name: str, listing_id: uuid, display_name: str, variant_label: nullable(str), price_version: int, ordinary_payable_centavos: int, normalized_php_exact: str,
    tax_category: str, captured_at: dt, price_effective_at: nullable(dt), selected_for_average: bool, exclusion_reason: nullable(str), geography: json }),
  AnalyticsRun: obj({ id: uuid, snapshot_date: date, revision: int, state: enumOf('RUNNING', 'VALIDATED', 'PUBLISHED', 'FAILED', 'SUPERSEDED'), error_code: nullable(str), observed_at: nullable(dt),
    published_at: nullable(dt), observations: int, selected: int, vendors: int, delayed: bool, reviewer_reason: nullable(str) }),
  AnalyticsCorrectionRequest: { type: 'object', required: ['excluded_observation_ids', 'reason'], properties: { excluded_observation_ids: { type: 'array', minItems: 1, maxItems: 200, items: uuid }, reason: { ...str, minLength: 10, maxLength: 1000 } } },
  AnalyticsCorrectionResult: loose({ state: str, snapshot_date: date, run_id: uuid, revision: int, observations: int, selected: int, vendors: int }),
  BuyerMaterialsAnalyticsRequest: { type: 'object', properties: { location_id: nullable(uuid), latitude: { type: 'number' }, longitude: { type: 'number' }, origin_source: enumOf('DEVICE', 'MAP_PIN', 'SEARCH'),
    radius_km: { type: 'integer', enum: [5, 10, 20, 30, 40, 50] }, preset_days: { type: 'integer', enum: [7, 30, 90] }, start_date: nullable(date), end_date: nullable(date), category_id: nullable(uuid),
    q: nullable({ ...str, maxLength: 100 }), cursor: nullable(str), per_page: { type: 'integer', minimum: 1, maximum: 50 } }, additionalProperties: false,
    description: 'Origins travel in the body. Any other field (a role, competitor id or include flag) is refused with 422.' },
};
const envelope = (name, data, meta = json) => { schemas[name] = obj({ data, meta, errors: arr(ref('ApiError')) }); };
envelope('BuyerOrderReviewsEnvelope', ref('BuyerOrderReviews'));
envelope('VendorOrderReviewsEnvelope', ref('VendorOrderReviews'));
envelope('PublicReviewListEnvelope', arr(ref('PublicReview')), ref('ReviewListMeta'));
envelope('VendorReviewListEnvelope', arr(ref('VendorReviewRow')), ref('ReviewListMeta'));
envelope('ReviewReportedEnvelope', ref('ReviewReported'));
envelope('ModerationQueueEnvelope', arr(ref('ModerationQueueRow')), ref('ReviewListMeta'));
envelope('ModerationDetailEnvelope', ref('ModerationDetail'));
envelope('StorePerformanceEnvelope', ref('StorePerformance'));
envelope('AdminScoreListEnvelope', arr(ref('AdminScoreRow')), ref('ReviewListMeta'));
envelope('AdminScoreDetailEnvelope', ref('AdminScoreDetail'));
envelope('InvestigationAckEnvelope', json);
envelope('BuyerMaterialsAnalyticsListEnvelope', ref('BuyerMaterialsAnalyticsList'));
envelope('VendorMaterialsAnalyticsListEnvelope', ref('VendorMaterialsAnalyticsList'));
envelope('AdminMaterialsAnalyticsListEnvelope', ref('AdminMaterialsAnalyticsList'));
envelope('BuyerMaterialsAnalyticsDetailEnvelope', ref('BuyerMaterialsAnalyticsDetail'));
envelope('VendorMaterialsAnalyticsDetailEnvelope', ref('VendorMaterialsAnalyticsDetail'));
envelope('AdminMaterialsAnalyticsDetailEnvelope', ref('AdminMaterialsAnalyticsDetail'));
envelope('MaterialOfferListEnvelope', arr(ref('MaterialOffer')), json);
envelope('AnalyticsSourceListEnvelope', arr(ref('AnalyticsSource')), json);
envelope('AnalyticsRunListEnvelope', arr(ref('AnalyticsRun')), json);
envelope('AnalyticsCorrectionEnvelope', ref('AnalyticsCorrectionResult'));

const paths = {};
const keyParam = { name: 'Idempotency-Key', in: 'header', required: true, schema: uuid };
const errors = codes => Object.fromEntries(codes.map(code => [String(code), { $ref: '#/components/responses/ErrorResponse' }]));
const BUYER = [{ passportBearer: [] }], WEB = [{ accessCookie: [], webCsrf: [] }];
const signedQuery = [{ name: 'expires', in: 'query', required: true, schema: { type: 'integer' } }, { name: 'signature', in: 'query', required: true, schema: str }];
const page = { name: 'page', in: 'query', schema: { type: 'integer', minimum: 1, maximum: 500 } };
const windowQuery = [{ name: 'preset_days', in: 'query', schema: { type: 'integer', enum: [7, 30, 90] } }, { name: 'start_date', in: 'query', schema: date }, { name: 'end_date', in: 'query', schema: date }];
const listQuery = [...windowQuery, { name: 'category_id', in: 'query', schema: uuid }, { name: 'q', in: 'query', schema: { ...str, maxLength: 100 } }, { name: 'cursor', in: 'query', schema: str },
  { name: 'per_page', in: 'query', schema: { type: 'integer', minimum: 1, maximum: 50 } }];
const radius = { name: 'radius_km', in: 'query', schema: { type: 'integer', enum: [5, 10, 20, 30, 40, 50] }, description: 'Around your own verified store point (default 50 km). Any origin or competitor field is refused.' };
const psgc = [{ name: 'psgc_code', in: 'query', schema: { ...str, maxLength: 16 } }, { name: 'psgc_version_id', in: 'query', schema: uuid }];
function op(path, method, operationId, tag, security, description, { response, request, keyed = false, created = false, query = [], codes = [401, 403, 404, 409, 422], multipart = false, raw } = {}) {
  const parameters = [...path.matchAll(/\{(.*?)\}/g)].map(m => ({ name: m[1], in: 'path', required: true, schema: uuid }));
  if (keyed) parameters.push(keyParam);
  parameters.push(...query);
  const success = raw ?? { description: 'Authorized result.', content: { 'application/json': { schema: ref(response) } } };
  (paths[path] ??= {})[method] = { operationId, tags: [tag], description, security, ...(parameters.length ? { parameters } : {}),
    ...(request ? { requestBody: { required: true, content: { [multipart ? 'multipart/form-data' : 'application/json']: { schema: ref(request) } } } } : {}),
    responses: { [created ? '201' : '200']: success, ...(created ? { '200': { description: 'Idempotent replay.', content: success.content } } : {}), ...errors(codes) } };
}
const photo = { description: 'Review photo bytes for a signed, unexpired link and an authorized caller.', content: { 'image/png': { schema: binary }, 'image/jpeg': { schema: binary } } };
const csv = description => ({ description, content: { 'text/csv': { schema: binary } } });

const BR = 'Buyer Reviews';
op('/buyers/orders/{orderId}/reviews', 'get', 'getBuyerOrderReviews', BR, BUYER, 'Rating eligibility, the exact 14-day deadline (with its Asia/Manila label), your submissions and, after the blind reveal, the Vendor\'s rating of you.', { response: 'BuyerOrderReviewsEnvelope', codes: [401, 403, 404] });
op('/buyers/orders/{orderId}/reviews', 'post', 'submitBuyerOrderReviews', BR, BUYER, 'Rate the Vendor (Service Quality and Delivery or Processing Speed) and purchased lines (Product Quality). 409 REVIEW_NOT_ELIGIBLE before COMPLETED, REVIEW_WINDOW_CLOSED at 14 days, REVIEW_ALREADY_SUBMITTED for a repeat.',
  { response: 'BuyerOrderReviewsEnvelope', request: 'BuyerReviewSubmitRequest', keyed: true, created: true });
op('/buyers/reviews/{reviewId}', 'patch', 'editBuyerReview', BR, BUYER, 'Correct your review within 24 hours of submitting (409 REVIEW_LOCKED at the exact instant), or once within 7 days after an Admin requests a correction.', { response: 'BuyerOrderReviewsEnvelope', request: 'BuyerReviewEditRequest' });
op('/buyers/reviews/{reviewId}/media', 'post', 'addBuyerReviewMedia', BR, BUYER, 'Up to three photos on your Product Review while it can still be edited.', { response: 'BuyerOrderReviewsEnvelope', request: 'ReviewMediaForm', keyed: true, multipart: true });
op('/buyers/reviews/{reviewId}/media/{mediaId}', 'delete', 'removeBuyerReviewMedia', BR, BUYER, 'Remove one of your photos while the review can still be edited (retired, not erased from history).', { response: 'BuyerOrderReviewsEnvelope' });
op('/buyers/reviews/{reviewId}/flags', 'post', 'reportBuyerReview', BR, BUYER, 'Report a public review for moderation. Nothing is hidden or deleted by a report.', { response: 'ReviewReportedEnvelope', request: 'ReviewFlagRequest', keyed: true, created: true });
op('/buyers/listings/{listingId}/reviews', 'get', 'listListingReviews', BR, BUYER, 'Visible Product Reviews of one listing with its own product average (separate from the Vendor\'s MQS).', { response: 'PublicReviewListEnvelope', codes: [401, 403, 404, 422], query: [page] });
op('/buyers/stores/{vendorId}/reviews', 'get', 'listStoreReviews', BR, BUYER, 'Visible Vendor ratings, published scores (or New Vendor — Building Track Record) and active badges.', { response: 'PublicReviewListEnvelope', codes: [401, 403, 404, 422], query: [page] });
op('/buyers/reviews/{reviewId}/media/{mediaId}/content', 'get', 'getBuyerReviewPhoto', BR, BUYER, 'Photo behind a five-minute signed link; re-authorized on every fetch.', { raw: photo, query: signedQuery, codes: [401, 403, 404, 503] });

const VR = 'Vendor Reviews';
op('/vendor/reviews', 'get', 'listVendorReviews', VR, WEB, 'reviews.view (Owner, Store Manager, Store Staff, Customer Service). Visible received Vendor ratings or Product Reviews, or your store\'s Buyer ratings. There is no delete operation.',
  { response: 'VendorReviewListEnvelope', codes: [401, 403, 422], query: [{ name: 'type', in: 'query', schema: enumOf('VENDOR', 'PRODUCT', 'BUYER') }, page] });
op('/vendor/reviews/{reviewId}', 'patch', 'editVendorBuyerRating', VR, WEB, 'reviews.rate_buyer. Correct your store\'s Buyer rating within 24 hours.', { response: 'VendorOrderReviewsEnvelope', request: 'VendorReviewEditRequest' });
op('/vendor/reviews/{reviewId}/flags', 'post', 'reportVendorReview', VR, WEB, 'reviews.report. Report a review of your store; a Vendor can never remove a Buyer review.', { response: 'ReviewReportedEnvelope', request: 'ReviewFlagRequest', keyed: true, created: true });
op('/vendor/orders/{orderId}/reviews', 'get', 'getVendorOrderReviews', VR, WEB, 'reviews.view. The order\'s rating window; Buyer ratings appear only after the blind reveal.', { response: 'VendorOrderReviewsEnvelope', codes: [401, 403, 404] });
op('/vendor/orders/{orderId}/buyer-rating', 'post', 'submitVendorBuyerRating', VR, WEB, 'reviews.rate_buyer (Owner, Store Manager, Store Staff, Customer Service): Inquiry Seriousness, Communication Quality and Payment Reliability (CCS inputs).',
  { response: 'VendorOrderReviewsEnvelope', request: 'VendorBuyerRatingRequest', keyed: true, created: true });
op('/vendor/reviews/{reviewId}/media/{mediaId}/content', 'get', 'getVendorReviewPhoto', VR, WEB, 'Photo of a visible review of your store behind a signed link.', { raw: photo, query: signedQuery, codes: [401, 403, 404, 503] });

const VS = 'Vendor Store Performance';
op('/vendor/performance', 'get', 'getVendorStorePerformance', VS, WEB, 'scores.view_store (Owner, Store Manager). VPS, VCS, MQS, OHS, CRR, FRR, sample gates, windows, OHS components and badge states.', { response: 'StorePerformanceEnvelope', codes: [401, 403] });

const AR = 'Admin Review Moderation';
op('/admin/reviews', 'get', 'listAdminReviewModeration', AR, WEB, 'reviews.moderate (Super Admin, User Management Staff). The Product Review Moderation Queue.',
  { response: 'ModerationQueueEnvelope', codes: [401, 403, 422], query: [{ name: 'state', in: 'query', schema: enumOf('NEEDS_ACTION', 'ALL', ...MODERATION_STATES) }, page] });
op('/admin/reviews/{reviewId}', 'get', 'getAdminReviewModeration', AR, WEB, 'reviews.moderate. Review, media, flags, verified-purchase reference, related dispute, immutable revisions and moderation history.', { response: 'ModerationDetailEnvelope', codes: [401, 403, 404] });
op('/admin/reviews/{reviewId}/moderation', 'post', 'moderateAdminReview', AR, WEB, 'reviews.moderate. Dismiss Flag, Request Correction, Hide Pending Review, Remove or Restore, each with a reason and audit record; original content is preserved.', { response: 'ModerationDetailEnvelope', request: 'ReviewModerationRequest', keyed: true });
op('/admin/reviews/{reviewId}/media/{mediaId}/content', 'get', 'getAdminReviewPhoto', AR, WEB, 'reviews.moderate. Photo behind a signed link.', { raw: photo, query: signedQuery, codes: [401, 403, 404, 503] });

const AS = 'Admin Score Monitoring';
op('/admin/scores', 'get', 'listAdminScores', AS, WEB, 'scores.view (Super Admin, User Management Staff, Order and Dispute Staff).', { response: 'AdminScoreListEnvelope', codes: [401, 403, 422], query: [{ name: 'q', in: 'query', schema: { ...str, maxLength: 120 } }, page] });
op('/admin/scores/{vendorId}', 'get', 'getAdminScore', AS, WEB, 'scores.view. Components, sample sizes, windows, badge history, suppressions, exclusions and paginated source events.',
  { response: 'AdminScoreDetailEnvelope', codes: [401, 403, 404, 422], query: [{ name: 'metric', in: 'query', schema: enumOf(...METRICS) }, page] });
op('/admin/scores/{vendorId}/exclusions', 'post', 'excludeAdminScoreSource', AS, WEB, 'scores.investigate. Reversibly exclude one order (fraud, duplicate, test, invalid source) from later snapshots.', { response: 'AdminScoreDetailEnvelope', request: 'ScoreExclusionRequest', keyed: true, created: true });
op('/admin/scores/exclusions/{exclusionId}/revoke', 'post', 'revokeAdminScoreExclusion', AS, WEB, 'scores.investigate. Reverse an exclusion with a reason.', { response: 'InvestigationAckEnvelope', request: 'InvestigationReasonRequest', keyed: true });
op('/admin/scores/{vendorId}/badge-suppressions', 'post', 'suppressAdminBadge', AS, WEB, 'scores.investigate. Suppress a badge\'s display for a documented fraud or compliance case. Admins can never award a badge.', { response: 'AdminScoreDetailEnvelope', request: 'BadgeSuppressionRequest', keyed: true, created: true });
op('/admin/scores/badge-suppressions/{suppressionId}/lift', 'post', 'liftAdminBadgeSuppression', AS, WEB, 'scores.investigate. Lift a suppression with a reason.', { response: 'InvestigationAckEnvelope', request: 'InvestigationReasonRequest', keyed: true });

const BM = 'Buyer Materials Analytics';
op('/buyers/materials-analytics', 'post', 'listBuyerMaterialsAnalytics', BM, BUYER, 'Categorized comparable variants within your origin and radius: daily equal-Vendor averages (one-Vendor limited data), exact-endpoint trends needing two Vendors at each endpoint, and current offering counts. Read-only; POST keeps the origin out of URLs.',
  { response: 'BuyerMaterialsAnalyticsListEnvelope', request: 'BuyerMaterialsAnalyticsRequest', codes: [401, 403, 409, 422, 503] });
op('/buyers/materials-analytics/{groupId}', 'post', 'getBuyerMaterialPriceDetails', BM, BUYER, 'Material Price Details: every date in the window (gaps are MISSING_DAY), the trend and the comparable variant selector.', { response: 'BuyerMaterialsAnalyticsDetailEnvelope', request: 'BuyerMaterialsAnalyticsRequest', codes: [401, 403, 404, 409, 422, 503] });
op('/buyers/materials-analytics/{groupId}/offers', 'post', 'listBuyerMaterialOffers', BM, BUYER, 'Current public offers (Buyer only), cheapest per canonical unit first; each opens the existing Product Details.', { response: 'MaterialOfferListEnvelope', request: 'BuyerMaterialsAnalyticsRequest', codes: [401, 403, 404, 409, 422, 503] });

const VM = 'Vendor Materials Analytics';
op('/vendor/materials-analytics', 'get', 'listVendorMaterialsAnalytics', VM, WEB, 'materials_analytics.view_competitors (Owner, Store Manager only). Competitor aggregates excluding your organization, suppressed below three competitors at every point and endpoint, and your own price separately. No offers, identities or protected finance.',
  { response: 'VendorMaterialsAnalyticsListEnvelope', codes: [401, 403, 409, 422, 503], query: [...listQuery, radius] });
op('/vendor/materials-analytics/export', 'get', 'exportVendorMaterialsAnalytics', VM, WEB, 'materials_analytics.view_competitors. Aggregate-only CSV with the same suppression; re-authorized on every request.', { raw: csv('Competitor aggregates CSV; formulas neutralized.'), codes: [401, 403, 409, 422, 503], query: [...windowQuery, radius] });
op('/vendor/materials-analytics/{groupId}', 'get', 'getVendorMaterialPriceDetails', VM, WEB, 'materials_analytics.view_competitors. The aggregate graph/table for one comparable variant; there is no competitor-offers child.', { response: 'VendorMaterialsAnalyticsDetailEnvelope', codes: [401, 403, 404, 409, 422, 503], query: [...windowQuery, radius] });

const AM = 'Admin Materials Analytics';
op('/admin/materials-analytics', 'get', 'listAdminMaterialsAnalytics', AM, WEB, 'analytics.view_aggregates. PSGC-scoped (or Philippines-wide) aggregates; payment/order filters do not apply to listed-price history.', { response: 'AdminMaterialsAnalyticsListEnvelope', codes: [401, 403, 422, 503], query: [...listQuery, ...psgc] });
op('/admin/materials-analytics/export', 'get', 'exportAdminMaterialsAnalytics', AM, WEB, 'analytics.view_aggregates and analytics.export. Aggregate CSV.', { raw: csv('Aggregate CSV; formulas neutralized.'), codes: [401, 403, 422, 503], query: [...windowQuery, ...psgc] });
op('/admin/materials-analytics/runs', 'get', 'listAdminMaterialPriceRuns', AM, WEB, 'analytics.view_aggregates. Snapshot health: state, revision, actual capture time and delay.', { response: 'AnalyticsRunListEnvelope', codes: [401, 403, 503] });
op('/admin/materials-analytics/runs/{runId}/corrections', 'post', 'correctAdminMaterialPriceRun', AM, WEB, 'materials_analytics.inspect_sources. Append a reviewed replacement revision excluding proven-invalid observations; originals are retained.', { response: 'AnalyticsCorrectionEnvelope', request: 'AnalyticsCorrectionRequest', keyed: true });
op('/admin/materials-analytics/{groupId}', 'get', 'getAdminMaterialPriceDetails', AM, WEB, 'analytics.view_aggregates. Graph/table with counts and exact means.', { response: 'AdminMaterialsAnalyticsDetailEnvelope', codes: [401, 403, 404, 422, 503], query: [...windowQuery, ...psgc] });
op('/admin/materials-analytics/{groupId}/sources', 'get', 'listAdminMaterialPriceSources', AM, WEB, 'materials_analytics.inspect_sources. Public listing identity, price/version, capture time and recorded geography for one published date; audited with your reason.',
  { response: 'AnalyticsSourceListEnvelope', codes: [401, 403, 404, 422, 503], query: [{ name: 'snapshot_date', in: 'query', required: true, schema: date }, { name: 'reason', in: 'query', required: true, schema: { ...str, minLength: 10, maxLength: 500 } }, { name: 'psgc_code', in: 'query', schema: str }] });

source = source.replace(/\n  # Phase 14 reviews, scores and analytics operations[\s\S]*?(?=\n  # Phase 13 disputes and invoices operations)/, '');
source = source.replace(/\n    # Phase 14 reviews, scores and analytics schemas[\s\S]*?(?=\n    # Phase 13 disputes and invoices schemas)/, '');
const indent = (text, pad) => YAML.stringify(text, { aliasDuplicateObjects: false, defaultStringType: 'QUOTE_DOUBLE', lineWidth: 0 }).split('\n').filter(Boolean).map(l => pad + l).join('\n');
source = source.replace('\n  # Phase 13 disputes and invoices operations', '\n  # Phase 14 reviews, scores and analytics operations\n' + indent(paths, '  ') + '\n  # Phase 13 disputes and invoices operations');
source = source.replace('\n    # Phase 13 disputes and invoices schemas', '\n    # Phase 14 reviews, scores and analytics schemas\n' + indent(schemas, '    ') + '\n    # Phase 13 disputes and invoices schemas');
source = source.replace(/version: 1\.0\.0-phase\.\d+/, 'version: 1.0.0-phase.14');

function editSchema(name, edit) {
  const pattern = new RegExp(`(\\n    ${name}:\\n)([\\s\\S]*?)(?=\\n    [A-Za-z#][A-Za-z0-9_ ]*:|$)`);
  if (!pattern.test(source)) throw new Error(`Schema ${name} not found`);
  source = source.replace(pattern, (_, heading, body) => heading + edit(body));
}
editSchema('FeatureAvailability', body => body.replace(/enum: \[ NOT_YET_AVAILABLE, AVAILABLE(, TEMPORARILY_UNAVAILABLE)? \]/, 'enum: [ NOT_YET_AVAILABLE, AVAILABLE, TEMPORARILY_UNAVAILABLE ]'));
editSchema('ScoreLabel', body => body.replace(/\n        detail_text: .*/g, '') + '\n        detail_text: { type: string, description: "Full wording: VPS n.nn of 5, or New Vendor — Building Track Record below the sample gates." }');
for (const name of ['ListingVendorCard', 'ListingDetailVendor', 'PublicStoreProfile', 'SupplierVendorSummary']) {
  if (!new RegExp(`\\n    ${name}:\\n`).test(source)) continue;
  editSchema(name, body => body.replace(/\n        badges: .*/g, '') + '\n        badges: { type: array, items: { $ref: "#/components/schemas/PublicBadge" }, description: "Active automatic badges (text plus icon); Admin-suppressed badges are omitted." }');
}
for (const tag of [BR, VR, VS, AR, AS, BM, VM, AM]) {
  if (!source.includes(`  - name: ${tag}\n`)) source = source.replace('\ntags:\n', `\ntags:\n  - name: ${tag}\n`);
}
writeFileSync(file, crlf ? source.replace(/\n/g, '\r\n') : source);
console.log(`Authored ${Object.values(paths).reduce((n, methods) => n + Object.keys(methods).length, 0)} Phase 14 operations and ${Object.keys(schemas).length} schemas.`);
