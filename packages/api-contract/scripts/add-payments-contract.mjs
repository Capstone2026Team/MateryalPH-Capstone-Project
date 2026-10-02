import { readFileSync, writeFileSync } from 'node:fs';
import YAML from 'yaml';

// Phase 11 contract: Xendit TEST checkout payments, the verified webhook inbox, Vendor (Owner-only) finance and
// Admin finance. Idempotent: rerunning replaces the Phase 11 block and the widened shared fields.
const file = new URL('../openapi.yaml', import.meta.url);
const original = readFileSync(file, 'utf8');
const crlf = original.includes('\r\n');
let source = original.replace(/\r\n/g, '\n');
const ref = name => ({ $ref: `#/components/schemas/${name}` });
const str = { type: 'string' }, uuid = { type: 'string', format: 'uuid' }, int = { type: 'integer' }, bool = { type: 'boolean' }, dt = { type: 'string', format: 'date-time' };
const cents = { type: 'integer', minimum: 0 };
const json = { type: 'object', additionalProperties: true };
const nullable = type => ({ ...type, nullable: true });
const arr = items => ({ type: 'array', items });
const enumOf = (...values) => ({ type: 'string', enum: values });
const obj = (properties, required = Object.keys(properties).filter(k => !properties[k].nullable)) => ({ type: 'object', required, properties });
const STATUSES = ['RELIEF_ACTIVE', 'SUBJECT_STANDARD', 'SUBJECT_THRESHOLD_BREACHED', 'SUBJECT_PRIOR_YEAR', 'UNDER_REVIEW'];
const PURPOSES = ['FULL_ORDER_PAYMENT', 'NRPC_ASSURANCE_PAYMENT', 'ORDER_BALANCE_PAYMENT', 'PLATFORM_FEE_PAYMENT'];
const ORIGINS = ['XENDIT_TEST', 'SIMULATED'];

const schemas = {
  PaymentChannelOption: obj({ code: str, display_name: str, kind: enumOf('CARD', 'EWALLET', 'QR', 'OVER_THE_COUNTER', 'DIRECT_DEBIT', 'BANK_TRANSFER'), available: bool,
    unavailable_reason: nullable(str), refund_supported: bool, fee_version: int, rate_label: str, fee_centavos: nullable(cents), total_centavos: nullable(cents),
    fee_bearer: enumOf('BUYER', 'PLATFORM'), rate_source: enumOf('DEMO_PUBLISHED_RATE') }),
  PaymentAttempt: { ...obj({ id: uuid, purpose: enumOf(...PURPOSES), status: enumOf('PENDING', 'PAID', 'FAILED', 'EXPIRED', 'CAPTURED_LATE_REFUND_PENDING'), attempt_number: int,
    order_id: nullable(uuid), statement_id: nullable(uuid), channel_code: nullable(str), channel_name: nullable(str), principal_centavos: cents, processing_fee_centavos: cents,
    total_centavos: cents, fee_bearer: enumOf('BUYER', 'PLATFORM'), expires_at: nullable(dt), paid_at: nullable(dt), created_at: nullable(dt), environment: enumOf('TEST'),
    evidence_origin: enumOf(...ORIGINS), checkout_url: nullable({ ...str, format: 'uri' }), can_check_status: bool, message: str }),
    description: 'Client view of one payment attempt. Everything before a verified provider capture reads PENDING; a redirect never yields PAID. The hosted checkout link is returned only to its payer while open.' },
  PaymentCreateRequest: obj({ channel_code: { ...str, maxLength: 32 }, expected_total_centavos: { type: 'integer', minimum: 1 } }),
  StatementPaymentRequest: obj({ channel_code: { ...str, maxLength: 32 }, amount_centavos: nullable({ type: 'integer', minimum: 1 }) }, ['channel_code']),
  PaymentOptions: obj({ order_id: uuid, order_reference: str, payment_due: bool, purpose: nullable(enumOf(...PURPOSES)), principal_centavos: nullable(cents), breakdown: nullable(json),
    channels: arr(ref('PaymentChannelOption')), pay_by: nullable(dt), environment: enumOf('TEST'), evidence_origin: enumOf(...ORIGINS), provider_ready: bool,
    latest_attempt: nullable(ref('PaymentAttempt')), notice: str }),
  PhysicalPaymentRecord: obj({ id: uuid, kind: enumOf('OBLIGATION_OPENED', 'COLLECTION', 'ONLINE_BALANCE_CREDIT', 'CORRECTION', 'CANCELLATION_RELEASE'), method: str, amount_centavos: cents,
    remaining_centavos: cents, state: enumOf('UNPAID', 'PARTIALLY_RECORDED', 'PHYSICAL_PAYMENT_RECORDED', 'CANCELLED_UNPAID'), recorded_at: dt, recorded_role: nullable(str),
    has_evidence: bool, source: enumOf('VENDOR_RECORD', 'VERIFIED_ONLINE_PAYMENT', 'SYSTEM'), buyer_acknowledged_at: nullable(dt) }),
  PhysicalPaymentSummary: obj({ applicable: bool, method: str, state: str, remaining_centavos: nullable(cents), online_balance_approved: bool, records: arr(ref('PhysicalPaymentRecord')), notice: str }),
  PhysicalPaymentSettings: obj({ cod_enabled: bool, in_store_enabled: bool, lock_version: int, updated_at: nullable(str) }),
  PhysicalPaymentSettingsUpdate: obj({ lock_version: { type: 'integer', minimum: 0 }, cod_enabled: bool, in_store_enabled: bool }),
  PhysicalPaymentRecordForm: { type: 'object', required: ['amount_centavos', 'file'], properties: { amount_centavos: { type: 'integer', minimum: 1 }, received_at: { type: 'string', format: 'date-time' },
    note: { type: 'string', maxLength: 500 }, file: { type: 'string', format: 'binary', description: 'Private receipt evidence: JPG, PNG, WebP or PDF up to 10 MB; scanned fail-closed.' } } },
  ThresholdStatusEvent: obj({ from_status: nullable(enumOf(...STATUSES)), to_status: enumOf(...STATUSES), reason_code: str, g_before_centavos: cents, g_after_centavos: cents, actor_type: enumOf('SYSTEM', 'ADMIN', 'VENDOR'), occurred_at: nullable(dt) }),
  WithholdingThresholdPanel: { ...obj({ demo: bool, taxable_year: int, year_start_at: dt, year_end_at: dt, threshold_centavos: cents, cumulative_gross_centavos: cents, remaining_allowance_centavos: cents,
    local_gross_centavos: cents, external_declared_centavos: cents, external_overlap_centavos: cents, external_overlap_state: enumOf('NONE', 'UNRESOLVED', 'RESOLVED'), percent_of_threshold: int,
    advisory: bool, status: enumOf(...STATUSES, 'NOT_STARTED'), status_label: str, status_icon: str, reason_code: nullable(str), crossed_at: nullable(dt), crossed_at_manila: nullable(str),
    prior_year_total_centavos: nullable(cents), final_for_year_notice: str, events: arr(ref('ThresholdStatusEvent')) }),
    description: 'FIN-04A panel. Status never uses EXEMPT/SUBJECT_TO_WITHHOLDING; remaining allowance is floored at zero; every figure is DEMO.' },
  VendorFinanceNotice: obj({ id: uuid, mandatory: bool, title: str, body: str, created_at: nullable(dt), read: bool }),
  VendorFinanceOverview: obj({ demo_label: str, xendit_connection: json, tax_profile: json, withholding_arrangement: json, threshold: nullable(ref('WithholdingThresholdPanel')),
    commission_terms: json, online_channels: json, physical_payments: json, refund_capability: json, statements: json, notices: arr(ref('VendorFinanceNotice')) }),
  FeeStatement: obj({ id: uuid, reference: str, state: enumOf('DRAFT', 'ISSUED', 'PARTIALLY_PAID', 'PAID', 'VOIDED'), overdue: bool, period_start: str, period_end: str, issued_on: str, due_on: str,
    charges_centavos: cents, credits_centavos: cents, paid_centavos: cents, outstanding_centavos: cents, disputed_held_centavos: cents, lock_version: int, sample_notice: str }),
  FeeStatementDetail: obj({ id: uuid, reference: str, state: str, overdue: bool, period_start: str, period_end: str, issued_on: str, due_on: str, charges_centavos: cents, credits_centavos: cents,
    paid_centavos: cents, outstanding_centavos: cents, disputed_held_centavos: cents, lock_version: int, sample_notice: str, lines: arr(json), payments: arr(ref('PaymentAttempt')), channels: arr(ref('PaymentChannelOption')) }),
  VendorEarnings: obj({ demo: bool, environment: str, notice: str, commercial_sales_centavos: cents, included_vat_centavos: cents, online_collections_centavos: cents, buyer_processing_fees_centavos: cents,
    physical_collections_centavos: cents, provider_charges_centavos: cents, simulated_cwt_centavos: cents, estimated_remittance_cash_centavos: int, earned_commission_centavos: cents,
    estimated_commission_centavos: cents, unpaid_statements_centavos: cents }),
  FinanceReviewItem: obj({ id: uuid, kind: str, state: enumOf('OPEN', 'RESOLVED'), reason_code: str, summary: str, vendor: nullable(json), source_type: str, source_id: uuid,
    expected: json, reported: json, resolution: nullable(str), created_at: nullable(dt), resolved_at: nullable(dt) }),
  WithholdingAccumulatorView: obj({ id: uuid, vendor: json, environment: str, taxpayer_key_suffix: str, taxable_year: int, threshold_centavos: cents, g_accumulated_centavos: cents,
    g_external_declared_centavos: cents, g_external_overlap_centavos: cents, g_effective_centavos: cents, remaining_allowance_centavos: cents, external_overlap_state: str,
    status: enumOf(...STATUSES), status_label: str, reason_code: str, breached: bool, crossed_at: nullable(dt), prior_year_total_centavos: nullable(cents), lock_version: int, demo: bool }),
  WithholdingAccumulatorDetail: obj({ id: uuid, vendor: json, environment: str, taxpayer_key_suffix: str, taxable_year: int, threshold_centavos: cents, g_accumulated_centavos: cents,
    g_external_declared_centavos: cents, g_external_overlap_centavos: cents, g_effective_centavos: cents, remaining_allowance_centavos: cents, external_overlap_state: str,
    status: enumOf(...STATUSES), status_label: str, reason_code: str, breached: bool, crossed_at: nullable(dt), prior_year_total_centavos: nullable(cents), lock_version: int, demo: bool,
    tax_profile: json, events: arr(json), assessments: arr(json) }),
  OverlapResolveRequest: obj({ overlap_centavos: cents, lock_version: { type: 'integer', minimum: 1 }, reason: { ...str, minLength: 10, maxLength: 2000 } }),
  ReviewResolveRequest: obj({ resolution: { ...str, minLength: 10, maxLength: 2000 } }),
  StatementApproveRequest: obj({ lock_version: { type: 'integer', minimum: 1 } }),
  FeeCreditProposalRequest: obj({ fee_assessment_id: uuid, returned_exclusive_centavos: { type: 'integer', minimum: 1 }, reason: { ...str, minLength: 10, maxLength: 2000 } }),
  ChannelFeeVersion: obj({ code: str, display_name: str, kind: str, version: int, rate_ppm: int, fixed_centavos: cents, fee_vat_basis_points: int, rate_includes_vat: bool, refund_supported: bool,
    enabled: bool, disabled_reason: nullable(str), source_type: str, source_reference: str, effective_from: nullable(dt) }),
  PaymentWebhookAck: obj({ received: bool, duplicate: bool }),
};
const envelope = (name, data) => { schemas[name] = obj({ data, meta: json, errors: arr(ref('ApiError')) }); };
for (const name of ['PaymentOptions', 'PaymentAttempt', 'PhysicalPaymentSummary', 'PhysicalPaymentSettings', 'VendorFinanceOverview', 'FeeStatementDetail', 'VendorEarnings', 'PaymentWebhookAck',
  'WithholdingAccumulatorDetail', 'FeeStatement']) envelope(`${name}Envelope`, ref(name));
envelope('FinanceTransactionListEnvelope', arr(json));
envelope('AdminPaymentListEnvelope', arr(json));
envelope('FinanceReviewItemListEnvelope', arr(ref('FinanceReviewItem')));
envelope('WithholdingAccumulatorListEnvelope', arr(ref('WithholdingAccumulatorView')));
envelope('FeeStatementListEnvelope', arr(json));
envelope('ChannelFeeVersionListEnvelope', arr(ref('ChannelFeeVersion')));
envelope('FinanceActionResultEnvelope', json);

const paths = {};
const keyParam = { name: 'Idempotency-Key', in: 'header', required: true, schema: uuid };
const errors = codes => Object.fromEntries(codes.map(code => [String(code), { $ref: '#/components/responses/ErrorResponse' }]));
const BUYER = [{ passportBearer: [] }], WEB = [{ accessCookie: [], webCsrf: [] }];
function op(path, method, operationId, tag, security, description, { response, request, keyed = false, created = false, query = [], codes = [401, 403, 404, 409, 422, 503], multipart = false, raw } = {}) {
  const parameters = [...path.matchAll(/\{(.*?)\}/g)].map(m => ({ name: m[1], in: 'path', required: true, schema: uuid }));
  if (keyed) parameters.push(keyParam);
  parameters.push(...query);
  const success = raw ?? { description: 'Authorized result.', content: { 'application/json': { schema: ref(response) } } };
  (paths[path] ??= {})[method] = { operationId, tags: [tag], description, security, ...(parameters.length ? { parameters } : {}),
    ...(request ? { requestBody: { required: true, content: { [multipart ? 'multipart/form-data' : 'application/json']: { schema: ref(request) } } } } : {}),
    responses: { ...(created ? { '201': success, '200': { description: 'Idempotent replay.', content: success.content } } : { '200': success }), ...errors(codes) } };
}
const pageQ = { name: 'page', in: 'query', schema: { type: 'integer', minimum: 1, maximum: 1000 } };
const tabQ = required => ({ name: 'tab', in: 'query', required, schema: enumOf('PAYMENTS', 'PHYSICAL', 'REMITTANCES', 'STATEMENTS', 'REFUNDS', 'TAX_DOCUMENTS') });

op('/webhooks/xendit', 'post', 'receiveXenditPaymentWebhook', 'Payment Webhooks', [],
  'Fast inbox. Verifies x-callback-token in constant time (Xendit documents no HMAC signature header), stores the raw event once by webhook-id, acknowledges, then processes asynchronously. Processing re-reads the session authoritatively and checks identifier, reference, amount, currency, account and transition before anything is PAID. Forged, duplicate, reordered, mismatched or unknown events never create a paid order.',
  { response: 'PaymentWebhookAckEnvelope', request: 'PaymentWebhookPayload', codes: [400, 401, 413, 422, 503],
    query: [{ name: 'x-callback-token', in: 'header', required: true, schema: str }, { name: 'webhook-id', in: 'header', required: false, schema: str }] });
schemas.PaymentWebhookPayload = { type: 'object', required: ['event', 'data'], additionalProperties: true, properties: { event: str, business_id: str, created: str, data: json } };
op('/payments/return', 'get', 'showPaymentReturnPage', 'Payment Webhooks', [], 'Browser return page after the hosted payment page. Always renders Pending with a deep link back to the app; never reads or changes payment state.',
  { query: [{ name: 'attempt', in: 'query', required: false, schema: uuid }], codes: [429], raw: { description: 'Pending HTML page.', content: { 'text/html': { schema: str } } } });

op('/buyers/orders/{orderId}/payment-options', 'get', 'getBuyerPaymentOptions', 'Buyer Payments', BUYER, 'Server-computed purpose, principal and per-channel Payment Processing Fee (versioned DEMO schedule, grossed up, no markup). Refund-incompatible channels are listed as unavailable with a reason.', { response: 'PaymentOptionsEnvelope' });
op('/buyers/orders/{orderId}/payments', 'post', 'createBuyerPayment', 'Buyer Payments', BUYER, 'Opens one provider session for the due purpose through the reconciled Vendor TEST sub-account. expected_total_centavos must equal the server total (409 PAYMENT_AMOUNT_CHANGED). An open attempt blocks another charge (409 PAYMENT_ATTEMPT_IN_PROGRESS). Payment and provisioning idempotency are separate scopes.', { response: 'PaymentAttemptEnvelope', request: 'PaymentCreateRequest', keyed: true, created: true });
op('/buyers/payments/{paymentId}', 'get', 'getBuyerPayment', 'Buyer Payments', BUYER, 'The Buyer\'s own attempt. Pending until a verified event or authoritative reconciliation.', { response: 'PaymentAttemptEnvelope', codes: [401, 403, 404] });
op('/buyers/payments/{paymentId}/refresh', 'post', 'refreshBuyerPayment', 'Buyer Payments', BUYER, 'Asks the provider for the authoritative session state; a provider outage keeps the attempt pending.', { response: 'PaymentAttemptEnvelope', codes: [401, 403, 404, 429] });
op('/buyers/orders/{orderId}/physical-payments/{recordId}/acknowledge', 'post', 'acknowledgePhysicalPayment', 'Buyer Payments', BUYER, 'Acknowledge one Vendor-recorded direct collection. Set once; never an online payment confirmation.', { response: 'PhysicalPaymentSummaryEnvelope', keyed: true, codes: [401, 403, 404, 409] });

op('/vendor/finance', 'get', 'getVendorFinanceOverview', 'Vendor Finance', WEB, 'Owner-only. Separate Xendit connection, Vendor Tax Profile summary, withholding arrangement (Production assignment unconfirmed), FIN-04A threshold panel, Commission Terms, online channels, physical payments and refund capability. Every simulated figure is DEMO.', { response: 'VendorFinanceOverviewEnvelope', codes: [401, 403] });
op('/vendor/finance/physical-payments', 'put', 'updateVendorPhysicalPayments', 'Vendor Finance', WEB, 'Owner-only. Enable Cash on Delivery (Site Delivery) or In-Store Payment (Self-Pickup) for future orders; both default off. lock_version 0 before the first save.', { response: 'PhysicalPaymentSettingsEnvelope', request: 'PhysicalPaymentSettingsUpdate', codes: [401, 403, 409, 422] });
op('/vendor/finance/transactions', 'get', 'listVendorTransactions', 'Vendor Finance', WEB, 'Owner-only read-only Transaction History (former Wallet label). No balance, wallet or escrow.', { response: 'FinanceTransactionListEnvelope', query: [tabQ(false), pageQ], codes: [401, 403, 422] });
op('/vendor/finance/transactions/export', 'get', 'exportVendorTransactions', 'Vendor Finance', WEB, 'Owner-only audited CSV export: Internal Operational Report — Not a Tax Invoice.', { query: [tabQ(true)], codes: [401, 403, 422], raw: { description: 'CSV export.', content: { 'text/csv': { schema: str } } } });
op('/vendor/finance/earnings', 'get', 'getVendorEarnings', 'Vendor Finance', WEB, 'Owner-only FIN-11 Earnings with separate sales, collections, charges, simulated CWT and commission.', { response: 'VendorEarningsEnvelope', codes: [401, 403] });
op('/vendor/finance/statements/{statementId}', 'get', 'getVendorFeeStatement', 'Vendor Finance', WEB, 'Owner-only issued commission statement with lines, payments and payable channels (platform absorbs its bill processing charge).', { response: 'FeeStatementDetailEnvelope', codes: [401, 403, 404] });
op('/vendor/finance/statements/{statementId}/payments', 'post', 'payVendorFeeStatement', 'Vendor Finance', WEB, 'Owner-only PLATFORM_FEE_PAYMENT to the platform TEST account, 45-minute attempt, optional installment amount. No auto debit or split. Open attempts are reconciled first.', { response: 'PaymentAttemptEnvelope', request: 'StatementPaymentRequest', keyed: true, created: true });
op('/vendor/finance/payments/{paymentId}', 'get', 'getVendorFeePayment', 'Vendor Finance', WEB, 'Owner-only platform-fee payment attempt.', { response: 'PaymentAttemptEnvelope', codes: [401, 403, 404] });
op('/vendor/finance/payments/{paymentId}/refresh', 'post', 'refreshVendorFeePayment', 'Vendor Finance', WEB, 'Owner-only authoritative status check.', { response: 'PaymentAttemptEnvelope', codes: [401, 403, 404, 429] });
op('/vendor/orders/{orderId}/physical-payments', 'post', 'recordVendorPhysicalPayment', 'Vendor Finance', WEB, 'Owner, Store Manager or Store Staff (payments.record_physical) record cash received with private evidence. Partial collection leaves an outstanding balance; never above it; never an online success.', { response: 'PhysicalPaymentSummaryEnvelope', request: 'PhysicalPaymentRecordForm', keyed: true, created: true, multipart: true });
op('/vendor/orders/{orderId}/online-balance/approve', 'post', 'approveVendorOnlineBalance', 'Vendor Finance', WEB, 'Owner, Manager or Store Staff approve paying the uncollected physical balance online (ORDER_BALANCE_PAYMENT).', { response: 'FinanceActionResultEnvelope', keyed: true, codes: [401, 403, 404, 409] });

const ADMIN = 'Admin Finance';
op('/admin/finance/payments', 'get', 'listAdminPayments', ADMIN, WEB, 'finance.view. Payment log with evidence origin and reconciliation state.', { response: 'AdminPaymentListEnvelope', query: [pageQ,
  { name: 'state', in: 'query', schema: enumOf('CREATING', 'PENDING', 'UNCERTAIN', 'PAID', 'FAILED', 'EXPIRED', 'CANCELLED') }, { name: 'purpose', in: 'query', schema: enumOf(...PURPOSES) },
  { name: 'evidence_origin', in: 'query', schema: enumOf(...ORIGINS) }, { name: 'reconciliation_state', in: 'query', schema: enumOf('NOT_REQUIRED', 'PENDING', 'RECONCILED', 'EXCEPTION') }], codes: [401, 403, 422] });
op('/admin/finance/review-items', 'get', 'listFinanceReviewItems', ADMIN, WEB, 'finance.view. Reconciliation exceptions, payment mismatches, late captures, unresolved overlap, threshold adjustments, base reviews, overdue statements and fee-credit proposals.',
  { response: 'FinanceReviewItemListEnvelope', query: [pageQ, { name: 'state', in: 'query', schema: enumOf('OPEN', 'RESOLVED') }, { name: 'kind', in: 'query', schema: str }], codes: [401, 403, 422] });
op('/admin/finance/review-items/{itemId}/resolve', 'post', 'resolveFinanceReviewItem', ADMIN, WEB, 'finance.record_external_evidence. Record a reasoned resolution.', { response: 'FinanceActionResultEnvelope', request: 'ReviewResolveRequest', codes: [401, 403, 409, 422] });
op('/admin/finance/withholding-accumulators', 'get', 'listWithholdingAccumulators', ADMIN, WEB, 'finance.view. FIN-04A accumulators.', { response: 'WithholdingAccumulatorListEnvelope',
  query: [pageQ, { name: 'status', in: 'query', schema: enumOf(...STATUSES) }, { name: 'taxable_year', in: 'query', schema: int }], codes: [401, 403, 422] });
op('/admin/finance/withholding-accumulators/{accumulatorId}', 'get', 'getWithholdingAccumulator', ADMIN, WEB, 'finance.view. Figures, prior-year position, declaration year, overlap, breach, reason code and status-event history. Raw TIN never returned.', { response: 'WithholdingAccumulatorDetailEnvelope', codes: [401, 403, 404] });
op('/admin/finance/withholding-accumulators/{accumulatorId}/overlap', 'post', 'resolveWithholdingOverlap', ADMIN, WEB, 'finance.review_tax. Record the outside-platform overlap of an UNDER_REVIEW accumulator; a total above the limit breaches.', { response: 'WithholdingAccumulatorDetailEnvelope', request: 'OverlapResolveRequest' });
op('/admin/finance/statements', 'get', 'listFeeStatements', ADMIN, WEB, 'finance.view. Monthly commission statements.', { response: 'FeeStatementListEnvelope', query: [pageQ, { name: 'state', in: 'query', schema: enumOf('DRAFT', 'ISSUED', 'PARTIALLY_PAID', 'PAID', 'VOIDED') }], codes: [401, 403, 422] });
op('/admin/finance/statements/draft', 'post', 'draftFeeStatements', ADMIN, WEB, 'finance.approve_statements. Idempotently draft last month\'s statements (also scheduled 00:05 Asia/Manila on the 1st).', { response: 'FinanceActionResultEnvelope', codes: [401, 403] });
op('/admin/finance/statements/{statementId}/approve', 'post', 'approveFeeStatement', ADMIN, WEB, 'finance.approve_statements. Issue a DRAFT; due = max(15th of next month, issue + 12 days).', { response: 'FeeStatementEnvelope', request: 'StatementApproveRequest' });
op('/admin/finance/fee-credits', 'post', 'proposeFeeCredit', ADMIN, WEB, 'finance.review_tax. Prepare a FIN-03 credit from returned exclusive value after completion.', { response: 'FinanceActionResultEnvelope', request: 'FeeCreditProposalRequest', created: true, codes: [401, 403, 409, 422] });
op('/admin/finance/fee-credits/{proposalId}/approve', 'post', 'approveFeeCredit', ADMIN, WEB, 'finance.approve_statements by a user different from the preparer (403 PREPARER_REVIEWER_SAME).', { response: 'FinanceActionResultEnvelope', codes: [401, 403, 409] });
op('/admin/finance/channel-fees', 'get', 'listChannelFees', ADMIN, WEB, 'finance.view. Versioned TEST channel fee schedule (DEMO published rates; validate against the active Xendit agreement).', { response: 'ChannelFeeVersionListEnvelope', codes: [401, 403] });
op('/admin/finance/reconciliation/run', 'post', 'runPaymentReconciliation', ADMIN, WEB, 'finance.view. Run the bounded reconciliation sweep now.', { response: 'FinanceActionResultEnvelope', codes: [401, 403] });

source = source.replace(/\n  # Phase 11 payment and finance operations[\s\S]*?(?=\n  # Phase 10 Project operations|\ncomponents:)/, '');
source = source.replace(/\n    # Phase 11 payment and finance schemas[\s\S]*?(?=\n    # Phase 10 Project schemas|$)/, '');
const indent = (text, pad) => YAML.stringify(text, { aliasDuplicateObjects: false, defaultStringType: 'QUOTE_DOUBLE', lineWidth: 0 }).split('\n').filter(Boolean).map(l => pad + l).join('\n');
source = source.replace('\n  # Phase 10 Project operations', '\n  # Phase 11 payment and finance operations\n' + indent(paths, '  ') + '\n  # Phase 10 Project operations');
source = source.replace('\n    # Phase 10 Project schemas', '\n    # Phase 11 payment and finance schemas\n' + indent(schemas, '    ') + '\n    # Phase 10 Project schemas');
source = source.replace(/version: 1\.0\.0-phase\.\d+/, 'version: 1.0.0-phase.11');

// Shared fields widened by Phase 11 (scoped to their schemas so reruns are stable).
function editSchema(name, edit) {
  const pattern = new RegExp(`(\\n    ${name}:\\n)([\\s\\S]*?)(?=\\n    [A-Za-z#][A-Za-z0-9_ ]*:|$)`);
  if (!pattern.test(source)) throw new Error(`Schema ${name} not found`);
  source = source.replace(pattern, (_, heading, body) => heading + edit(body));
}
editSchema('CheckoutSubmitRequest', body => body.replace(/\n        payment_methods: .*/g, '') + '\n        payment_methods: { type: object, additionalProperties: { type: string, enum: [ ONLINE, CASH_ON_DELIVERY, IN_STORE ] }, description: "Vendor id => chosen method; Online when omitted. COD pairs with Site Delivery, In-Store with Self-Pickup, each only when the Vendor enabled it." }');
editSchema('ChatDraftContent', body => body.replace(/(        payment_method:\n          type: string\n          enum:\n)(            - ONLINE\n)(?!            - CASH_ON_DELIVERY)/, '$1$2            - CASH_ON_DELIVERY\n            - IN_STORE\n'));
editSchema('OrderPaymentAvailability', () => `      type: object
      description: Order-specific payment state. Buyers see their attempts; Vendor staff see operational status only. Store-wide finance stays Owner-only in Vendor Finance.
      required: [ available, reason, notice ]
      properties:
        available: { type: boolean }
        reason: { type: [ string, 'null' ] }
        notice: { type: [ string, 'null' ] }
        purpose: { type: [ string, 'null' ], enum: [ FULL_ORDER_PAYMENT, NRPC_ASSURANCE_PAYMENT, ORDER_BALANCE_PAYMENT, null ] }
        principal_centavos: { type: [ integer, 'null' ] }
        latest_attempt: { oneOf: [ { $ref: "#/components/schemas/PaymentAttempt" }, { type: 'null' } ] }
        verified_payment: { oneOf: [ { $ref: "#/components/schemas/PaymentAttempt" }, { type: 'null' } ] }
        attempts: { type: array, items: { $ref: "#/components/schemas/PaymentAttempt" } }
        physical: { $ref: "#/components/schemas/PhysicalPaymentSummary" }
        environment: { type: string, enum: [ TEST ] }`);
// The Buyer response lists PAY when an online payment is due; the Dart enum must know it.
editSchema('OrderDetail', body => body.replace(/\n        available_actions: .*/, '\n        available_actions: { type: array, items: { type: string, enum: [ APPROVE_REVISION, REJECT_REVISION, ACCEPT_NRPC, REJECT_NRPC, FLAG_NRPC, PAY ] } }'));
editSchema('VendorOrderPermissions', body => body.replace(/\n        can_record_physical_payment: .*|\n        can_approve_online_balance: .*/g, '') + '\n        can_record_physical_payment: { type: boolean }\n        can_approve_online_balance: { type: boolean }');
source = source.replace(/("payment_method":\n\s+"type": "string"\n\s+"enum":\n\s+- "ONLINE"\n)(?!\s+- "CASH_ON_DELIVERY")/g, (match) => match + match.match(/\n(\s+)- "ONLINE"\n$/)[1] + '- "CASH_ON_DELIVERY"\n' + match.match(/\n(\s+)- "ONLINE"\n$/)[1] + '- "IN_STORE"\n');
for (const tag of ['Buyer Payments', 'Vendor Finance', 'Admin Finance', 'Payment Webhooks']) {
  if (!source.includes(`  - name: ${tag}\n`)) source = source.replace('\ntags:\n', `\ntags:\n  - name: ${tag}\n`);
}
writeFileSync(file, crlf ? source.replace(/\n/g, '\r\n') : source);
console.log(`Authored ${Object.keys(paths).length} Phase 11 paths and ${Object.keys(schemas).length} schemas.`);
