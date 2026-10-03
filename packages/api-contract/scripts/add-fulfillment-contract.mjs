import { readFileSync, writeFileSync } from 'node:fs';
import YAML from 'yaml';

// Phase 12 contract: fulfillment milestones and proof, receipt confirmation and problem reports, cancellation
// requests and decisions, Cancellation Refund timelines, cash reimbursements and Admin order operations.
// Idempotent: rerunning replaces the Phase 12 block and the widened shared order and conversation fields.
const file = new URL('../openapi.yaml', import.meta.url);
const original = readFileSync(file, 'utf8');
const crlf = original.includes('\r\n');
let source = original.replace(/\r\n/g, '\n');
const ref = name => ({ $ref: `#/components/schemas/${name}` });
const str = { type: 'string' }, uuid = { type: 'string', format: 'uuid' }, int = { type: 'integer' }, bool = { type: 'boolean' }, dt = { type: 'string', format: 'date-time' };
const cents = { type: 'integer', minimum: 0 };
const json = { type: 'object', additionalProperties: true };
const nullable = type => ({ ...type, nullable: true });
const maybe = name => ({ oneOf: [ref(name), { type: 'null' }] });
const arr = items => ({ type: 'array', items });
const enumOf = (...values) => ({ type: 'string', enum: values });
const optional = property => property.nullable === true || (property.oneOf ?? []).some(option => option.type === 'null');
const obj = (properties, required = Object.keys(properties).filter(key => !optional(properties[key]))) => ({ type: 'object', required, properties });

const MILESTONES = ['PROCESSING', 'READY_FOR_PICKUP', 'OUT_FOR_DELIVERY', 'DELIVERED', 'PICKED_UP'];
const BUYER_REASONS = ['CHANGE_OF_REQUIREMENT', 'DUPLICATE_ORDER', 'BUDGET_CHANGE', 'PROJECT_DELAY', 'SCHEDULE_CONFLICT', 'VENDOR_AGREEMENT', 'OTHER'];
const VENDOR_REASONS = ['STOCK_FAILURE', 'OPERATIONAL_INABILITY', 'DELIVERY_INABILITY', 'COMPLIANCE_RESTRICTION', 'ACCOUNT_RESTRICTION', 'BUYER_AGREEMENT', 'OTHER'];
const ISSUES = ['NOT_RECEIVED', 'INCOMPLETE', 'DAMAGED', 'WRONG_ITEM', 'LATE', 'ACCESS_PROBLEM', 'OTHER'];
const VEHICLE_ISSUES = ['BREAKDOWN', 'CAPACITY_SHORTFALL', 'ACCESS_BLOCKED', 'DELAY', 'OTHER'];
const REFUND_STATES = ['REFUND_PENDING', 'REFUNDED', 'REFUND_FAILED'];
const TRIGGERS = ['CANCELLATION', 'DISPUTE_CONCLUSION', 'TECHNICAL_COMPENSATION', 'FEE_CREDIT'];
const REMEDIES = ['REPORT_PROBLEM', 'DISPUTE', 'RETURN', 'WARRANTY', 'STATUTORY_REMEDIES'];
const BUYER_MODES = ['WITHDRAW', 'USE_REJECT', 'CANCEL_BEFORE_PAYMENT', 'CANCEL_NOW', 'REQUEST', 'REQUEST_OPEN', 'UNAVAILABLE', 'CLOSED'];
const VENDOR_NEXT = ['START_PREPARATION', 'MARK_READY', 'DISPATCH', 'RECORD_PICKUP', 'RECORD_DELIVERY', 'AWAIT_RECEIPT', 'RESPOND_TO_CANCELLATION', 'NONE'];

const schemas = {
  FulfillmentProof: { ...obj({ milestone: enumOf('DELIVERED', 'PICKED_UP'), recorded_at: nullable(dt), receiver_name: nullable(str), receiver_kind: nullable(enumOf('BUYER', 'AUTHORIZED_RECEIVER')),
    handover_confirmed: bool, photo_path: nullable(str), signature_path: nullable(str), vehicle: nullable(json) }),
    description: 'Proof attached to the Delivered or Picked up milestone. File paths are authorized, order-scoped API paths relative to /api/v1, never public URLs.' },
  FulfillmentStep: obj({ key: str, label: str, status: enumOf('COMPLETE', 'CURRENT', 'UPCOMING'), at: nullable(dt), actor_role: nullable(str), proof_required: bool,
    proof: maybe('FulfillmentProof'), proof_requirements: arr(enumOf('DELIVERY_PHOTO', 'RECEIVER_NAME', 'SIGNATURE_OPTIONAL', 'HANDOVER_CONFIRMATION', 'RECEIVER_TYPE')) }),
  FulfillmentTrip: obj({ vehicle_index: int, trip_number: int, name: nullable(str), total_vehicle_trips: int, dispatched_at: nullable(dt) }),
  FulfillmentArrangementVehicle: obj({ vehicle_index: int, name: nullable(str), vehicle_type: nullable(str), number_of_vehicles: int, total_vehicle_trips: int }),
  FulfillmentArrangement: { ...obj({ vehicles: arr(ref('FulfillmentArrangementVehicle')), final_fee_centavos: cents, endpoint: nullable(str), fulfillment_date: nullable(str), arrangement: nullable(str), notice: str }),
    description: 'The accepted delivery commitment from the order snapshot. Later vehicle, rate or store-hour settings never change it.' },
  FulfillmentReceipt: obj({ due_at: nullable(dt), paused: bool, remaining_seconds: nullable(int), confirmed_at: nullable(dt), confirmation_source: nullable(enumOf('BUYER', 'AUTO_CONFIRMATION')), window_hours: int }),
  FulfillmentIssue: obj({ id: uuid, category: enumOf(...ISSUES), description: str, state: enumOf('OPEN', 'RESOLVED'), reported_at: nullable(dt), vendor_response: nullable(str), vendor_responded_at: nullable(dt),
    resolution: nullable(enumOf('BUYER_RESOLVED', 'RECEIPT_CONFIRMED', 'ORDER_CANCELLED')), resolved_at: nullable(dt), photo_paths: arr(str) }),
  FulfillmentAssignment: obj({ display_name: str, role: enumOf('FULFILLMENT'), assigned_at: nullable(dt), user_id: nullable(int) }),
  FulfillmentVehicleIssue: obj({ category: enumOf(...VEHICLE_ISSUES), description: str, reported_at: nullable(dt), actor_role: nullable(str) }),
  FulfillmentThreadRef: obj({ available: bool, conversation_id: nullable(uuid), read_only: bool, read_only_reason: nullable(enumOf('ORDER_COMPLETED', 'ORDER_CANCELLED', 'ORDER_NOT_IN_FULFILLMENT')), notice: nullable(str) }),
  OrderFulfillment: { ...obj({ method: enumOf('DELIVERY', 'PICKUP'), state: str, expected_date: nullable(str), late: bool, steps: arr(ref('FulfillmentStep')), proof: maybe('FulfillmentProof'), tracking_notice: str,
    trips: arr(ref('FulfillmentTrip')), accepted_arrangement: maybe('FulfillmentArrangement'), receipt: ref('FulfillmentReceipt'), issue: maybe('FulfillmentIssue'), assignment: maybe('FulfillmentAssignment'),
    vehicle_issues: arr(ref('FulfillmentVehicleIssue')), thread: ref('FulfillmentThreadRef'), next_action: enumOf(...VENDOR_NEXT, 'CONFIRM_RECEIPT') }),
    description: 'Server-derived milestone stepper. Step completion comes only from recorded milestones; there is no live GPS or vehicle position.' },
  CancellationRemedy: obj({ code: enumOf(...REMEDIES), available: bool, note: str }),
  VendorCancellationRequestRef: obj({ reason_code: str, reason: nullable(str), requested_at: nullable(dt), response_due_at: nullable(dt), order_state_at_request: str }),
  OrderCancellation: { type: 'object', required: ['explanation'], properties: {
    mode: enumOf(...BUYER_MODES), available: bool, explanation: str, requires_reason: bool, reason_codes: arr(str), nrpc_retainable_centavos: cents, can_withdraw_request: bool,
    response_due_at: nullable(dt), remedies: arr(ref('CancellationRemedy')), open_request: maybe('VendorCancellationRequestRef') },
    description: 'Buyer responses carry mode, availability, reason codes and remedies; Vendor responses carry the explanation, Vendor reason codes and any open Buyer request. Unavailability is always explained in text.' },
  RefundTimelineItem: { ...obj({ id: uuid, trigger: enumOf(...TRIGGERS), state: enumOf(...REFUND_STATES), display_state: enumOf('QUEUED', 'INITIATED', 'PROCESSED', 'FAILED'), amount_centavos: cents,
    principal_centavos: nullable(cents), processing_fee_centavos: cents, payment_purpose: str, original_method: str, attempt_number: int, requested_at: nullable(dt), completed_at: nullable(dt),
    failure_code: nullable(str), evidence_origin: nullable(str), can_retry: bool, arrival_note: nullable(str), message: str }),
    description: 'One timeline per original online payment. INITIATED is never success; PROCESSED requires a verified provider event or reconciliation.' },
  ReimbursementTimelineItem: obj({ id: uuid, state: enumOf('VENDOR_REIMBURSEMENT_PENDING', 'REIMBURSEMENT_CONFIRMED'), amount_centavos: cents, method: str, reimbursed_at: nullable(dt),
    buyer_acknowledged_at: nullable(dt), has_evidence: bool, evidence_path: nullable(str), confirmed_by_review: bool, message: str }),
  CancellationDecisionView: obj({ cause: enumOf('BUYER', 'VENDOR'), decided_by: enumOf('BUYER', 'VENDOR', 'SYSTEM'), decision_code: str, reason_code: nullable(str), reason: nullable(str),
    nrpc_retained_centavos: cents, refund_total_centavos: cents, cash_reimbursement_centavos: cents, released_unpaid_centavos: cents, order_state_before: str, decided_at: nullable(dt),
    nrpc_evidence_on_file: bool, nrpc_evidence_path: nullable(str) }),
  OrderRefundTimeline: obj({ refunds: arr(ref('RefundTimelineItem')), reimbursements: arr(ref('ReimbursementTimelineItem')), no_longer_due_centavos: cents, decision: maybe('CancellationDecisionView') }),
  CancellationPlanPayment: obj({ payment_id: uuid, purpose: str, channel_code: nullable(str), channel_name: nullable(str), captured_centavos: cents, prior_allocated_centavos: cents, retained_centavos: cents,
    refund_centavos: cents, principal_centavos: cents, processing_fee_centavos: cents, capped_by_prior_refunds: bool, allocation: json }),
  CancellationPlan: { ...obj({ cause: enumOf('BUYER', 'VENDOR'), nrpc_retained_centavos: cents, nrpc_accepted_centavos: cents, online: arr(ref('CancellationPlanPayment')), online_refund_total_centavos: cents,
    cash_reimbursement_centavos: cents, released_unpaid_centavos: cents, paid_total_centavos: cents, excludes: arr(enumOf('VENDOR_COMMISSION', 'MERCHANT_WITHHOLDING', 'PROVIDER_SETTLEMENT_DEDUCTIONS')) }),
    description: 'FIN-07 amounts from the original frozen allocations. Vendor withholding, commission and provider deductions never reduce a Buyer refund.' },
  BuyerCancellationPreview: obj({ availability: ref('OrderCancellation'), full_refund: ref('CancellationPlan'), with_nrpc_retained: maybe('CancellationPlan'), nrpc_retainable_centavos: cents, notice: str }),
  VendorCancellationPreview: { type: 'object', required: ['vendor_cancellation'], properties: { vendor_cancellation: ref('CancellationPlan'), full_refund: ref('CancellationPlan'),
    with_nrpc_retained: maybe('CancellationPlan'), nrpc_retainable_centavos: cents, notice: str } },
  FulfillmentAssignee: obj({ user_id: int, display_name: str, assigned: bool }),
  BuyerCancelRequest: { type: 'object', required: ['lock_version'], properties: { lock_version: { type: 'integer', minimum: 1 }, reason_code: nullable(enumOf(...BUYER_REASONS)),
    reason: nullable({ ...str, maxLength: 1000 }) }, description: 'Withdrawal and cancel-before-payment need no reason; CONFIRMED and PROCESSING need a reason code, and OTHER needs text.' },
  VendorCancelRequest: obj({ lock_version: { type: 'integer', minimum: 1 }, reason_code: enumOf(...VENDOR_REASONS), reason: { ...str, minLength: 10, maxLength: 1000 } }),
  FulfillmentAssignmentRequest: obj({ user_id: { type: 'integer', minimum: 1 }, reason: { ...str, minLength: 5, maxLength: 500 } }),
  FulfillmentMilestoneForm: { type: 'object', required: ['milestone', 'lock_version'], properties: { milestone: enumOf(...MILESTONES), lock_version: { type: 'integer', minimum: 1 },
    vehicle_index: { type: 'integer', minimum: 0 }, trip_number: { type: 'integer', minimum: 1 }, receiver_name: { ...str, maxLength: 120 }, receiver_kind: enumOf('BUYER', 'AUTHORIZED_RECEIVER'),
    handover_confirmed: bool, note: { ...str, maxLength: 500 },
    file: { type: 'string', format: 'binary', description: 'Delivery photo (required for DELIVERED): JPG or PNG up to 10 MB, scanned fail-closed, stored privately.' },
    signature: { type: 'string', format: 'binary', description: 'Optional receiver signature image.' } },
    description: 'No price, fee, vehicle configuration or commercial term is accepted. OUT_FOR_DELIVERY names a vehicle and trip of the accepted snapshot.' },
  FulfillmentTripRequest: obj({ vehicle_index: { type: 'integer', minimum: 0 }, trip_number: { type: 'integer', minimum: 1 } }),
  VehicleIssueRequest: obj({ category: enumOf(...VEHICLE_ISSUES), description: { ...str, minLength: 10, maxLength: 1000 } }),
  ProblemReportForm: { type: 'object', required: ['category', 'description'], properties: { category: enumOf(...ISSUES), description: { ...str, minLength: 10, maxLength: 2000 },
    files: { type: 'array', maxItems: 3, items: { type: 'string', format: 'binary' }, description: 'Up to three JPG or PNG photos.' } } },
  ProblemResolveRequest: { type: 'object', properties: { note: nullable({ ...str, maxLength: 1000 }) } },
  ProblemResponseRequest: obj({ response: { ...str, minLength: 5, maxLength: 2000 } }),
  CancellationFinalizeForm: { type: 'object', required: ['retain_nrpc'], properties: { retain_nrpc: bool, note: { ...str, maxLength: 2000 },
    file: { type: 'string', format: 'binary', description: 'Required to retain NRPC: evidence of the actual irreversible preparation (JPG, PNG or PDF).' } } },
  ReimbursementRecordForm: { type: 'object', required: ['file'], properties: { file: { type: 'string', format: 'binary' }, reimbursed_at: { type: 'string', format: 'date-time' }, note: { ...str, maxLength: 500 } } },
  AdminReimbursementDecision: obj({ reason: { ...str, minLength: 10, maxLength: 2000 } }),
  AdminOrderOperationsSummary: obj({ refunds_failed: int, refunds_pending: int, reimbursements_pending: int, cancellation_requests_open: int, nfr_events_30_days: int }),
  AdminRefundRow: obj({ id: uuid, target_type: enumOf('ORDER', 'PLATFORM_FEE'), trigger: enumOf(...TRIGGERS), state: enumOf(...REFUND_STATES), display_state: enumOf('QUEUED', 'INITIATED', 'PROCESSED', 'FAILED'),
    amount_centavos: cents, attempt_number: int, failure_code: nullable(str), evidence_origin: nullable(str), order_id: nullable(uuid), order_reference: nullable(str), statement_reference: nullable(str),
    vendor_name: nullable(str), requested_at: nullable(dt), completed_at: nullable(dt), can_retry: bool }),
  AdminReimbursementRow: obj({ id: uuid, order_reference: str, vendor_name: nullable(str), state: enumOf('VENDOR_REIMBURSEMENT_PENDING', 'REIMBURSEMENT_CONFIRMED'), amount_centavos: cents, method: str,
    has_evidence: bool, reimbursed_at: nullable(dt), buyer_acknowledged_at: nullable(dt), confirmed_by_review: bool, can_decide: bool }),
  AdminCancellationRequestRow: obj({ id: uuid, order_reference: str, vendor_name: nullable(str), reason_code: str, requested_at: nullable(dt), response_due_at: nullable(dt), overdue: bool }),
};
const envelope = (name, data) => { schemas[name] = obj({ data, meta: json, errors: arr(ref('ApiError')) }); };
envelope('BuyerCancellationPreviewEnvelope', ref('BuyerCancellationPreview'));
envelope('VendorCancellationPreviewEnvelope', ref('VendorCancellationPreview'));
envelope('FulfillmentAssigneeListEnvelope', arr(ref('FulfillmentAssignee')));
envelope('AdminOrderOperationsSummaryEnvelope', ref('AdminOrderOperationsSummary'));
envelope('AdminRefundListEnvelope', arr(ref('AdminRefundRow')));
envelope('AdminReimbursementListEnvelope', arr(ref('AdminReimbursementRow')));
envelope('AdminCancellationRequestListEnvelope', arr(ref('AdminCancellationRequestRow')));
envelope('AdminOrderActionResultEnvelope', json);

const paths = {};
const keyParam = { name: 'Idempotency-Key', in: 'header', required: true, schema: uuid };
const errors = codes => Object.fromEntries(codes.map(code => [String(code), { $ref: '#/components/responses/ErrorResponse' }]));
const BUYER = [{ passportBearer: [] }], WEB = [{ accessCookie: [], webCsrf: [] }];
function op(path, method, operationId, tag, security, description, { response, request, keyed = false, created = false, query = [], codes = [401, 403, 404, 409, 422], multipart = false, raw } = {}) {
  const parameters = [...path.matchAll(/\{(.*?)\}/g)].map(m => ({ name: m[1], in: 'path', required: true, schema: uuid }));
  if (keyed) parameters.push(keyParam);
  parameters.push(...query);
  const success = raw ?? { description: 'Authorized result.', content: { 'application/json': { schema: ref(response) } } };
  (paths[path] ??= {})[method] = { operationId, tags: [tag], description, security, ...(parameters.length ? { parameters } : {}),
    ...(request ? { requestBody: { required: true, content: { [multipart ? 'multipart/form-data' : 'application/json']: { schema: ref(request) } } } } : {}),
    responses: { ...(created ? { '201': success, '200': { description: 'Idempotent replay.', content: success.content } } : { '200': success }), ...errors(codes) } };
}
const fileResponse = { description: 'Private evidence bytes, order-scoped and authorized on every request.', content: { 'image/png': { schema: { type: 'string', format: 'binary' } }, 'image/jpeg': { schema: { type: 'string', format: 'binary' } }, 'application/pdf': { schema: { type: 'string', format: 'binary' } } } };

const B = 'Buyer Fulfillment';
const buyer = '/buyers/orders/{orderId}';
op(`${buyer}/cancellation-preview`, 'get', 'getBuyerCancellationPreview', B, BUYER, 'Server-computed availability and FIN-07 refund estimate from the original payments and allocations, with and without an evidenced NRPC retention.', { response: 'BuyerCancellationPreviewEnvelope', codes: [401, 403, 404] });
op(`${buyer}/cancel`, 'post', 'cancelBuyerOrder', B, BUYER, 'Withdraw before Vendor confirmation, cancel before paying, cancel with a reason at CONFIRMED (final at once, full refund) or request cancellation with a reason during PROCESSING (CANCELLATION_REQUESTED; the Vendor has 24 hours). Unavailable at READY_FOR_PICKUP and later (409 CANCELLATION_UNAVAILABLE with remedies). A final paid cancellation creates exactly one Cancellation Refund per original payment and submits it immediately after commit.', { response: 'OrderDetailEnvelope', request: 'BuyerCancelRequest', keyed: true });
op(`${buyer}/cancellation-request/withdraw`, 'post', 'withdrawBuyerCancellationRequest', B, BUYER, 'Withdraw an open request; the order returns to PROCESSING.', { response: 'OrderDetailEnvelope', keyed: true, codes: [401, 403, 404, 409] });
op(`${buyer}/receipt/confirm`, 'post', 'confirmBuyerReceipt', B, BUYER, 'Confirm receipt after DELIVERED or PICKED_UP. Completes the order once and earns the commission once.', { response: 'OrderDetailEnvelope', keyed: true, codes: [401, 403, 404, 409] });
op(`${buyer}/problems`, 'post', 'reportBuyerProblem', B, BUYER, 'Report a Problem from READY_FOR_PICKUP until receipt. Pauses the 48-hour auto-confirmation; never opens a dispute or a refund.', { response: 'OrderDetailEnvelope', request: 'ProblemReportForm', keyed: true, created: true, multipart: true });
op(`${buyer}/problems/{issueId}/resolve`, 'post', 'resolveBuyerProblem', B, BUYER, 'Mark the reported problem resolved; the remaining auto-confirmation time resumes.', { response: 'OrderDetailEnvelope', request: 'ProblemResolveRequest', keyed: true, codes: [401, 403, 404, 409] });
op(`${buyer}/reimbursements/{reimbursementId}/acknowledge`, 'post', 'acknowledgeBuyerReimbursement', B, BUYER, 'Confirm receipt of an evidenced Vendor cash reimbursement (REIMBURSEMENT_CONFIRMED). Not a provider refund.', { response: 'OrderDetailEnvelope', keyed: true, codes: [401, 403, 404, 409] });
op(`${buyer}/files/{fileId}`, 'get', 'getBuyerOrderFile', B, BUYER, 'Proof, problem and reimbursement evidence referenced by this order only.', { raw: fileResponse, codes: [401, 403, 404, 503] });

const V = 'Vendor Fulfillment';
const vendor = '/vendor/orders/{orderId}';
op(`${vendor}/fulfillment/assignees`, 'get', 'listVendorFulfillmentAssignees', V, WEB, 'Owner or Store Manager: active Fulfillment Staff that can be assigned.', { response: 'FulfillmentAssigneeListEnvelope', codes: [401, 403, 404] });
op(`${vendor}/fulfillment/assignment`, 'post', 'assignVendorFulfillmentStaff', V, WEB, 'Owner or Store Manager assign or reassign Fulfillment Staff. The former assignee loses order, thread, file and realtime access immediately; history keeps its attribution.', { response: 'OrderDetailEnvelope', request: 'FulfillmentAssignmentRequest', keyed: true });
op(`${vendor}/fulfillment/milestones`, 'post', 'recordVendorFulfillmentMilestone', V, WEB, 'Owner, Store Manager or the assigned Fulfillment Staff record the next milestone through the shared state machine. Duplicate → replay or 409 MILESTONE_ALREADY_RECORDED; out of order → 409 ORDER_STATE_CONFLICT; open cancellation request → 409 CANCELLATION_PENDING; missing proof → 422 PROOF_REQUIRED. READY_FOR_PICKUP or OUT_FOR_DELIVERY opens the one fulfillment thread in the same transaction.', { response: 'OrderDetailEnvelope', request: 'FulfillmentMilestoneForm', keyed: true, multipart: true });
op(`${vendor}/fulfillment/trips`, 'post', 'recordVendorFulfillmentTrip', V, WEB, 'Record another accepted trip while out for delivery; never beyond the accepted trip count.', { response: 'OrderDetailEnvelope', request: 'FulfillmentTripRequest', keyed: true });
op(`${vendor}/fulfillment/vehicle-issues`, 'post', 'reportVendorVehicleIssue', V, WEB, 'Report a vehicle issue. The accepted arrangement and fee are unchanged; a different arrangement needs an authorized revision approved by the Buyer.', { response: 'OrderDetailEnvelope', request: 'VehicleIssueRequest', keyed: true, created: true });
op(`${vendor}/problems/{issueId}/respond`, 'post', 'respondVendorProblem', V, WEB, 'Respond to an open Buyer problem report.', { response: 'OrderDetailEnvelope', request: 'ProblemResponseRequest', keyed: true });
op(`${vendor}/cancellation-preview`, 'get', 'getVendorCancellationPreview', V, WEB, 'Owner, Store Manager or Store Staff: FIN-07 amounts for a Vendor cancellation and for finalizing an open Buyer request.', { response: 'VendorCancellationPreviewEnvelope', codes: [401, 403, 404] });
op(`${vendor}/cancel`, 'post', 'cancelVendorOrder', V, WEB, 'Owner, Store Manager or Store Staff cancel with a reason before DELIVERED/PICKED_UP: NRPC forfeited, every Buyer-paid amount refunded to the original method, reservation released, NFR event recorded.', { response: 'OrderDetailEnvelope', request: 'VendorCancelRequest', keyed: true });
op(`${vendor}/cancellation-request/finalize`, 'post', 'finalizeVendorCancellationRequest', V, WEB, 'Finalize a Buyer request within 24 hours. Retaining the accepted NRPC requires preparation evidence; otherwise everything is refunded. The Vendor cannot refuse a permitted request.', { response: 'OrderDetailEnvelope', request: 'CancellationFinalizeForm', keyed: true, multipart: true });
op(`${vendor}/refunds/{refundId}/retry`, 'post', 'retryVendorRefund', V, WEB, 'Owner only: retry a REFUND_FAILED instruction after funding is resolved. Same instruction and trigger; the next attempt uses a new provider idempotency key.', { response: 'OrderDetailEnvelope', keyed: true });
op(`${vendor}/reimbursements/{reimbursementId}`, 'post', 'recordVendorReimbursement', V, WEB, 'Record returning cash collected directly, with private evidence. Confirmed by the Buyer or an authorized Admin decision.', { response: 'OrderDetailEnvelope', request: 'ReimbursementRecordForm', keyed: true, multipart: true });
op(`${vendor}/files/{fileId}`, 'get', 'getVendorOrderFile', V, WEB, 'Order evidence for authorized Vendor users of this order; Fulfillment Staff only while assigned.', { raw: fileResponse, codes: [401, 403, 404, 503] });

const A = 'Admin Order Operations';
op('/admin/order-operations/summary', 'get', 'getAdminOrderOperationsSummary', A, WEB, 'orders.operations.view. Counts of failed and pending refunds, pending reimbursements, open cancellation requests and recent NFR events.', { response: 'AdminOrderOperationsSummaryEnvelope', codes: [401, 403] });
op('/admin/order-operations/refunds', 'get', 'listAdminRefunds', A, WEB, 'orders.operations.view. Refund instructions, failures first. Admins never hold or disburse funds.', { response: 'AdminRefundListEnvelope', codes: [401, 403, 422],
  query: [{ name: 'state', in: 'query', schema: enumOf(...REFUND_STATES) }, { name: 'trigger', in: 'query', schema: enumOf(...TRIGGERS) }, { name: 'page', in: 'query', schema: { type: 'integer', minimum: 1, maximum: 1000 } }] });
op('/admin/order-operations/refunds/{refundId}/retry', 'post', 'retryAdminRefund', A, WEB, 'refunds.retry. Re-send a failed instruction to the original payment only.', { response: 'AdminOrderActionResultEnvelope', keyed: true });
op('/admin/order-operations/reimbursements', 'get', 'listAdminReimbursements', A, WEB, 'orders.operations.view. Vendor cash reimbursements of cancelled orders.', { response: 'AdminReimbursementListEnvelope', codes: [401, 403] });
op('/admin/order-operations/reimbursements/{reimbursementId}/confirm', 'post', 'confirmAdminReimbursement', A, WEB, 'reimbursements.decide. Reasoned confirmation of an evidenced reimbursement.', { response: 'AdminOrderActionResultEnvelope', request: 'AdminReimbursementDecision' });
op('/admin/order-operations/cancellation-requests', 'get', 'listAdminCancellationRequests', A, WEB, 'orders.operations.view. Open Buyer requests awaiting the Vendor, earliest deadline first.', { response: 'AdminCancellationRequestListEnvelope', codes: [401, 403] });

source = source.replace(/\n  # Phase 12 fulfillment and cancellation operations[\s\S]*?(?=\n  # Phase 11 payment and finance operations)/, '');
source = source.replace(/\n    # Phase 12 fulfillment and cancellation schemas[\s\S]*?(?=\n    # Phase 11 payment and finance schemas)/, '');
const indent = (text, pad) => YAML.stringify(text, { aliasDuplicateObjects: false, defaultStringType: 'QUOTE_DOUBLE', lineWidth: 0 }).split('\n').filter(Boolean).map(l => pad + l).join('\n');
source = source.replace('\n  # Phase 11 payment and finance operations', '\n  # Phase 12 fulfillment and cancellation operations\n' + indent(paths, '  ') + '\n  # Phase 11 payment and finance operations');
source = source.replace('\n    # Phase 11 payment and finance schemas', '\n    # Phase 12 fulfillment and cancellation schemas\n' + indent(schemas, '    ') + '\n    # Phase 11 payment and finance schemas');
source = source.replace(/version: 1\.0\.0-phase\.\d+/, 'version: 1.0.0-phase.12');

// Shared order and conversation fields widened by Phase 12 (scoped to their schemas so reruns are stable).
function editSchema(name, edit) {
  const pattern = new RegExp(`(\\n    ${name}:\\n)([\\s\\S]*?)(?=\\n    [A-Za-z#][A-Za-z0-9_ ]*:|$)`);
  if (!pattern.test(source)) throw new Error(`Schema ${name} not found`);
  source = source.replace(pattern, (_, heading, body) => heading + edit(body));
}
const BUYER_ACTIONS = ['APPROVE_REVISION', 'REJECT_REVISION', 'ACCEPT_NRPC', 'REJECT_NRPC', 'FLAG_NRPC', 'PAY', 'WITHDRAW', 'CANCEL', 'REQUEST_CANCELLATION', 'WITHDRAW_CANCELLATION_REQUEST',
  'CONFIRM_RECEIPT', 'REPORT_PROBLEM', 'RESOLVE_PROBLEM', 'ACKNOWLEDGE_REIMBURSEMENT'];
editSchema('OrderDetail', body => body
  .replace(/\n        available_actions: .*/, `\n        available_actions: { type: array, items: { type: string, enum: [ ${BUYER_ACTIONS.join(', ')} ] } }`)
  .replace(/\n        fulfillment: .*|\n        cancellation: .*|\n        refund_timeline: .*/g, '')
  + '\n        fulfillment: { $ref: "#/components/schemas/OrderFulfillment" }\n        cancellation: { $ref: "#/components/schemas/OrderCancellation" }\n        refund_timeline: { $ref: "#/components/schemas/OrderRefundTimeline" }');
const PERMISSIONS = ['can_record_milestone', 'can_assign_fulfillment', 'can_cancel', 'can_finalize_cancellation', 'can_report_vehicle_issue', 'can_retry_refund', 'can_respond_problem'];
editSchema('VendorOrderPermissions', body => body.replace(new RegExp(`\\n        (${PERMISSIONS.join('|')}): .*`, 'g'), '') + PERMISSIONS.map(name => `\n        ${name}: { type: boolean }`).join(''));
editSchema('VendorOrderPrimaryAction', () => `      type: string
      enum: [ CONFIRM, WAITING_FOR_BUYER, WAITING_FOR_PAYMENT, PREPARE_WHEN_AVAILABLE, ${VENDOR_NEXT.join(', ')} ]`);
editSchema('OrderDeadline', body => body.replace(/\n        kind: .*/, '\n        kind: { type: string, enum: [ VENDOR_RESPONSE, BUYER_RESPONSE, PAYMENT, RECEIPT_CONFIRMATION, CANCELLATION_RESPONSE ] }'));
editSchema('OrderSummary', body => body.replace(/\n        next_action: .*/, '\n        next_action: { type: [ string, \'null\' ], enum: [ REVIEW_REVISION, REVIEW_NRPC, PAY, CONFIRM_RECEIPT, null ] }'));
editSchema('ConversationView', body => body
  .replace(/\n        read_only:\n          type: boolean|\n        read_only_reason:\n          type: string\n          nullable: true|\n        order_reference:\n          type: string\n          nullable: true/g, '')
  .replace(/(\n        - fulfillment_entry_enabled)(?!\n        - read_only)/, '$1\n        - read_only')
  .replace(/(\n        fulfillment_entry_enabled:\n          type: boolean)/, '$1\n        read_only:\n          type: boolean\n        read_only_reason:\n          type: string\n          nullable: true\n        order_reference:\n          type: string\n          nullable: true'));
for (const tag of [B, V, A]) {
  if (!source.includes(`  - name: ${tag}\n`)) source = source.replace('\ntags:\n', `\ntags:\n  - name: ${tag}\n`);
}
writeFileSync(file, crlf ? source.replace(/\n/g, '\r\n') : source);
console.log(`Authored ${Object.keys(paths).length} Phase 12 paths and ${Object.keys(schemas).length} schemas.`);
