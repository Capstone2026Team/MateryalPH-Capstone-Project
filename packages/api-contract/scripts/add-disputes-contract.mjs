import { readFileSync, writeFileSync } from 'node:fs';
import YAML from 'yaml';

// Phase 13 contract: transaction disputes (filing, response, mutual resolution, clarification, decision, one appeal,
// remedies and Dispute-Conclusion Refunds), the Owner-controlled staff dispute export and realtime channel, and FIN-09
// invoice records, Buyer billing details and copy/correction requests. No schema anywhere accepts a refund destination.
// Idempotent: rerunning replaces the Phase 13 block and the widened shared order fields.
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
const loose = properties => ({ type: 'object', properties });
const binary = { type: 'string', format: 'binary' };
const files = (max, description) => ({ type: 'array', maxItems: max, items: binary, description });

const CASE_STATES = ['OPEN_AWAITING_RESPONSE', 'MUTUAL_RESOLUTION', 'ESCALATED_ADMIN_REVIEW', 'AWAITING_CLARIFICATION', 'DECIDED', 'APPEAL_OPEN', 'RESOLVED', 'CLOSED_INCONCLUSIVE'];
const BUYER_ISSUES = ['WRONG_ITEM', 'DEFECTIVE', 'INCOMPLETE_DELIVERY', 'LATE_OR_MISSING', 'MISLEADING_LISTING', 'PAYMENT', 'INVOICE', 'OTHER_TRANSACTION'];
const VENDOR_ISSUES = ['PHYSICAL_PAYMENT_NOT_RECEIVED', 'PICKUP_NO_SHOW', 'ABUSIVE_COMMUNICATION', 'FALSE_EVIDENCE', 'INACCESSIBLE_DELIVERY_SITE'];
const ISSUES = [...BUYER_ISSUES, ...VENDOR_ISSUES];
const REMEDIES = ['REPLACEMENT', 'FULL_REFUND', 'PARTIAL_REFUND', 'RETURN_AND_REFUND', 'INVOICE_CORRECTION', 'PAYMENT_OF_BALANCE', 'WARNING_ONLY', 'OTHER'];
const OUTCOMES = ['DISMISSED', 'REPLACEMENT', 'FULL_REFUND', 'PARTIAL_REFUND', 'INCONCLUSIVE', 'NO_FURTHER_ACTION'];
const DECIDABLE = OUTCOMES.filter(outcome => outcome !== 'NO_FURTHER_ACTION');
const PROPOSALS = ['REPLACEMENT', 'FULL_REFUND', 'PARTIAL_REFUND', 'NO_FURTHER_ACTION'];
const POSITIONS = ['ACCEPT_REQUEST', 'OFFER_REPLACEMENT', 'OFFER_REFUND', 'REJECT_WITH_EVIDENCE', 'REQUEST_ADMIN_REVIEW'];
const SANCTIONS = ['WARNING', 'TEMPORARY_RESTRICTION', 'SUSPENSION', 'PERMANENT_BAN'];
const METRICS = ['VALIDATED_DEFECT_RETURN', 'VENDOR_NON_FULFILLMENT', 'MISREPRESENTED_LISTING'];
const GROUNDS = ['NEW_EVIDENCE', 'MATERIAL_PROCESS_ERROR'];
const EVENTS = ['CASE_FILED', 'RESPONSE_SUBMITTED', 'EVIDENCE_ADDED', 'MESSAGE', 'PROPOSAL_MADE', 'PROPOSAL_ACCEPTED', 'PROPOSAL_REJECTED', 'AGREEMENT_RECORDED', 'ESCALATED',
  'CLARIFICATION_REQUESTED', 'CLARIFICATION_ANSWERED', 'CLARIFICATION_EXPIRED', 'DECISION_ISSUED', 'DECISION_ENFORCEABLE', 'APPEAL_FILED', 'APPEAL_DECIDED', 'REMEDY_CREATED', 'REMEDY_UPDATED',
  'REMEDY_COMPLETED', 'REFUND_UPDATED', 'SANCTION_RECORDED', 'HANDLER_ASSIGNED', 'HANDLER_REASSIGNED', 'CASE_RESOLVED', 'CASE_CLOSED_INCONCLUSIVE', 'ORDER_HOLD_CHANGED'];
const PARTY_ACTIONS = ['RESPOND', 'PROPOSE', 'ANSWER_PROPOSAL', 'ESCALATE', 'ADD_EVIDENCE', 'MESSAGE', 'ANSWER_CLARIFICATION', 'APPEAL', 'RECORD_REPLACEMENT', 'CONFIRM_REPLACEMENT',
  'ADD_FULFILLMENT_EVIDENCE', 'ASSIGN_TO_ME', 'REQUEST_CLARIFICATION', 'DECIDE', 'DECIDE_APPEAL'];
const REMEDY_KINDS = ['ONLINE_REFUND', 'CASH_REIMBURSEMENT', 'REPLACEMENT', 'FEE_CREDIT_REVIEW', 'ORDER_CANCELLATION'];
const GROUPS = ['ALL', 'ACTIVE', 'NEEDS_RESPONSE', 'ADMIN_REVIEW', 'DECIDED', 'CONCLUDED'];
const INVOICE_TYPES = ['VENDOR_GOODS_INVOICE', 'VENDOR_ADJUSTMENT_DOCUMENT', 'PLATFORM_SERVICE_INVOICE', 'PROCESSOR_INVOICE'];
const VENDOR_INVOICE_TYPES = ['VENDOR_GOODS_INVOICE', 'VENDOR_ADJUSTMENT_DOCUMENT'];
const RECONCILIATION = ['NOT_APPLICABLE', 'MATCHED', 'INVOICE_RECONCILIATION_REQUIRED', 'EXPLAINED', 'CORRECTED'];
const REQUEST_STATES = ['REQUESTED', 'UPLOADED', 'DOWNLOADED', 'RETURNED_FOR_CORRECTION', 'CLOSED'];
const SOURCE_SYSTEMS = ['REGISTERED_CAS', 'BIR_EIS', 'LOOSE_LEAF_OR_PRINTED', 'OTHER_REGISTERED'];
const INVOICING_METHODS = ['ELECTRONIC', 'COMPUTERIZED', 'MANUAL'];
const NOT_TAX = 'Not a tax invoice';

const caseSummary = {
  id: uuid, reference: str, order_id: uuid, order_reference: str, status: enumOf(...CASE_STATES), case_kind: enumOf('TRANSACTION', 'POST_COMPLETION_RETURN'), issue_type: enumOf(...ISSUES),
  requested_remedy: enumOf(...REMEDIES), requested_amount_centavos: nullable(cents), filed_by_party: enumOf('BUYER', 'VENDOR'),
  responsible_party: enumOf('BUYER', 'VENDOR', 'BOTH', 'ADMIN', 'REQUESTED_PARTY', 'NONE'), next_deadline: maybe('DisputeDeadline'), refund_state: str, remedy_state: enumOf('NONE', 'PENDING', 'COMPLETED', 'FAILED'),
  appeal_available: bool, vendor_name: str, buyer_name: nullable(str), assigned_to_admin: bool, decisions: int, filed_at: nullable(dt), updated_at: nullable(dt),
};

const schemas = {
  DisputeDeadline: { ...obj({ kind: enumOf('RESPONSE', 'MUTUAL_RESOLUTION', 'CLARIFICATION', 'APPEAL'), at: dt, responsible_party: enumOf('BUYER', 'VENDOR', 'BOTH', 'REQUESTED_PARTY', 'EITHER'), label: str }),
    description: 'An exact stored instant for a countdown plus its Asia/Manila date and time label.' },
  DisputeAffectedLine: obj({ order_line_id: uuid, display_name: str, variant_label: nullable(str), quantity: str, line_total_centavos: cents, refundable_centavos: cents }),
  DisputeFileLink: { ...obj({ url: str, expires_at: dt }), description: 'A five-minute signed URL; the fetch also re-authorizes the signed-in caller.' },
  DisputeEvidence: obj({ file_id: uuid, label: enumOf('ORIGINAL', 'SUPPLEMENTAL', 'RESPONSE', 'CLARIFICATION', 'APPEAL', 'FULFILLMENT', 'REMEDY'), description: nullable(str), content_type: str, name: str,
    byte_size: int, url: str, expires_at: dt }),
  DisputeTimelineActor: obj({ party: enumOf('BUYER', 'VENDOR', 'ADMIN', 'SYSTEM'), role: nullable(str), display_name: str }),
  DisputeTimelineEntry: { ...obj({ id: uuid, sequence: int, type: enumOf(...EVENTS), at: nullable(dt), actor: ref('DisputeTimelineActor'), body: nullable(str), details: json, evidence: arr(ref('DisputeEvidence')) }),
    description: 'One append-only, chronologically numbered event with its actor, role, exact time and evidence.' },
  DisputeProposal: obj({ id: uuid, proposed_by_party: enumOf('BUYER', 'VENDOR'), remedy: enumOf(...PROPOSALS), amount_centavos: nullable(cents), terms: str,
    state: enumOf('PROPOSED', 'ACCEPTED', 'REJECTED', 'SUPERSEDED', 'EXPIRED'), proposed_at: nullable(dt), answered_at: nullable(dt), can_answer: bool }),
  DisputeClarification: obj({ id: uuid, requested_party: enumOf('BUYER', 'VENDOR'), question: str, due_at: nullable(dt), state: enumOf('OPEN', 'ANSWERED', 'EXPIRED'), response: nullable(str),
    responded_at: nullable(dt), can_answer: bool }),
  DisputeDecision: { ...obj({ id: uuid, version: int, kind: enumOf('ADMIN_DECISION', 'APPEAL_DECISION', 'MUTUAL_AGREEMENT'), outcome: enumOf(...OUTCOMES), appeal_result: nullable(enumOf('AFFIRMED', 'MODIFIED', 'REVERSED')),
    awarded_centavos: cents, reason: nullable(str), evidence_limitation: nullable(str), enforceable: bool, decided_at: nullable(dt), appeal_due_at: nullable(dt), supersedes_decision_id: nullable(uuid),
    decider_role: str, decider_name: nullable(str), sanctions: nullable(json), current: bool }), description: 'Immutable decision versions. An appeal decision supersedes without erasing the original.' },
  DisputeAppeal: obj({ id: uuid, appellant_party: enumOf('BUYER', 'VENDOR'), grounds: enumOf(...GROUNDS), statement: str, state: enumOf('OPEN', 'DECIDED'), filed_at: nullable(dt), decided_at: nullable(dt),
    appealed_decision_id: uuid, result_decision_id: nullable(uuid) }),
  DisputeRemedy: obj({ id: uuid, kind: enumOf(...REMEDY_KINDS), state: enumOf('PENDING', 'COMPLETED', 'FAILED'), amount_centavos: cents, note: nullable(str), recorded: bool, completed_at: nullable(dt),
    decision_id: nullable(uuid), evidence: maybe('DisputeFileLink'), can_record: bool, can_confirm: bool }),
  DisputeOriginalPaymentMethod: { ...obj({ label: str, physical: bool, notice: str }), description: 'Information only. No request anywhere accepts a different refund destination.' },
  DisputeOrderRef: obj({ id: uuid, reference: str, order_state: str, dispute_state: str, refund_state: str, payment_method: str }),
  DisputeHandlerRef: obj({ display_name: str, role: str }),
  DisputeHandler: obj({ vendor: maybe('DisputeHandlerRef'), admin_assigned: bool, admin_is_me: bool }),
  DisputeVendorPermissions: obj({ can_respond: bool, can_offer_refund: bool }),
  DisputeRefundable: obj({ online_centavos: cents, cash_centavos: cents }),
  DisputeAdminParty: obj({ display_name: str, prior_cases: int }),
  DisputeAdminContext: { ...obj({ outcomes: arr(enumOf(...OUTCOMES)), sanctions: arr(enumOf(...SANCTIONS)), metric_events: arr(enumOf(...METRICS)), refundable: ref('DisputeRefundable'),
    already_awarded_centavos: cents, appeal_reviewer_conflict: bool, unanswered_clarification: bool, buyer: ref('DisputeAdminParty'), vendor: ref('DisputeAdminParty'), order_timeline: arr(json), enforcement: arr(json) }),
    description: 'Decision support for Order and Dispute Staff. Refundable amounts return only to the original payments; Admins never hold or disburse money.' },
  DisputeSummary: obj(caseSummary),
  DisputeDetail: { ...obj({ ...caseSummary, description: nullable(str), affected_lines: arr(ref('DisputeAffectedLine')), original_payment_method: maybe('DisputeOriginalPaymentMethod'),
    preferred_contact_channel: nullable(enumOf('IN_APP', 'EMAIL')), order: ref('DisputeOrderRef'), deadlines: arr(ref('DisputeDeadline')), server_time: dt, timezone: str, handler: ref('DisputeHandler'),
    lock_version: int, timeline: arr(ref('DisputeTimelineEntry')), proposals: arr(ref('DisputeProposal')), clarifications: arr(ref('DisputeClarification')), decisions: arr(ref('DisputeDecision')),
    appeal: maybe('DisputeAppeal'), remedies: arr(ref('DisputeRemedy')), refunds: arr(ref('RefundTimelineItem')), reimbursements: { ...arr(ref('ReimbursementTimelineItem')), nullable: true },
    available_actions: arr(enumOf(...PARTY_ACTIONS)), limited_view: bool, permissions: maybe('DisputeVendorPermissions'), admin: maybe('DisputeAdminContext') }),
    description: 'One case: the chronological timeline, proposals, clarifications, immutable decisions, the one appeal, remedies and the linked Dispute-Conclusion Refunds. Fulfillment Staff receive a limited view.' },
  DisputeEligibilityMethod: obj({ label: str, channel: nullable(str), physical: bool }),
  DisputeEligibility: { ...obj({ available: bool, reason: str, active_case_id: nullable(uuid), case_kind: enumOf('TRANSACTION', 'POST_COMPLETION_RETURN'), post_completion_deadline: nullable(dt),
    issue_types: arr(enumOf(...ISSUES)), requested_remedies: arr(enumOf(...REMEDIES)), lines: arr(ref('DisputeAffectedLine')), original_payment_method: ref('DisputeEligibilityMethod'),
    refund_destination_notice: str, filing_creates_refund: bool }), description: 'Filing creates a Case ID and dispute state only, never a refund.' },
  DisputeFileForm: { type: 'object', required: ['order_id', 'issue_type', 'requested_remedy', 'description'], properties: { order_id: uuid, issue_type: enumOf(...ISSUES), requested_remedy: enumOf(...REMEDIES),
    requested_amount_centavos: { type: 'integer', minimum: 1, description: 'Required for PARTIAL_REFUND; at most the affected lines less earlier refunds.' }, description: { ...str, minLength: 20, maxLength: 4000 },
    affected_line_ids: arr(uuid), preferred_contact_channel: enumOf('IN_APP', 'EMAIL'), files: files(5, 'Up to five JPG, PNG or PDF files, validated and scanned, stored privately.') },
    description: 'The structured Refund/Dispute Request Form. It has no refund-destination field; any destination key is refused with 422 REFUND_DESTINATION_NOT_ACCEPTED.' },
  DisputeRespondForm: { type: 'object', required: ['position', 'body'], properties: { position: enumOf(...POSITIONS), body: { ...str, minLength: 10, maxLength: 4000 },
    amount_centavos: { type: 'integer', minimum: 1, description: 'OFFER_REFUND only; omit for a full refund. Vendor refund offers are Owner-only.' }, files: files(5, 'Evidence; required to REJECT_WITH_EVIDENCE.') } },
  DisputeProposalRequest: { type: 'object', required: ['remedy', 'terms'], properties: { remedy: enumOf(...PROPOSALS), amount_centavos: nullable({ type: 'integer', minimum: 1 }), terms: { ...str, minLength: 10, maxLength: 2000 } } },
  DisputeProposalAnswer: obj({ decision: enumOf('ACCEPT', 'REJECT') }),
  DisputeEscalateRequest: obj({ reason: { ...str, minLength: 10, maxLength: 2000 } }),
  DisputeEvidenceForm: { type: 'object', required: ['files'], properties: { description: { ...str, maxLength: 500 }, files: files(5, 'Labeled supplemental (or assigned Fulfillment Staff fulfillment) evidence; the original complaint is never edited.') } },
  DisputeMessageRequest: obj({ body: { ...str, minLength: 2, maxLength: 2000 } }),
  DisputeClarificationAnswerForm: { type: 'object', required: ['response'], properties: { response: { ...str, minLength: 5, maxLength: 4000 }, files: files(5, 'Optional supporting files.') } },
  DisputeAppealForm: { type: 'object', required: ['grounds', 'statement'], properties: { grounds: enumOf(...GROUNDS), statement: { ...str, minLength: 20, maxLength: 4000 }, files: files(5, 'Required for NEW_EVIDENCE.') } },
  DisputeReplacementForm: { type: 'object', required: ['note'], properties: { note: { ...str, minLength: 10, maxLength: 500 }, files: files(1, 'Optional proof of the replacement.') } },
  DisputeRemedyConfirmRequest: obj({ reason: { ...str, minLength: 10, maxLength: 2000 } }),
  AdminDisputeClarificationRequest: obj({ parties: { type: 'array', minItems: 1, maxItems: 2, items: enumOf('BUYER', 'VENDOR') }, question: { ...str, minLength: 10, maxLength: 2000 } }),
  DisputeSanctionInput: { type: 'object', required: ['subject', 'action', 'reason'], properties: { subject: enumOf('BUYER', 'VENDOR'), action: enumOf(...SANCTIONS), reason: { ...str, minLength: 10, maxLength: 1000 },
    scope: nullable({ ...str, maxLength: 160 }), duration_days: nullable({ type: 'integer', minimum: 1, maximum: 365 }), restoration_condition: nullable({ ...str, maxLength: 1000 }) },
    description: 'A warning takes effect when the decision is final; restriction, suspension and ban are recorded and referred to User Management Staff.' },
  AdminDisputeDecisionRequest: { type: 'object', required: ['outcome', 'reason', 'enforceable', 'conflict_check_confirmed', 'lock_version'], properties: { outcome: enumOf(...DECIDABLE), reason: { ...str, minLength: 20, maxLength: 4000 },
    amount_centavos: nullable({ type: 'integer', minimum: 1 }), affected_line_ids: arr(uuid), enforceable: { type: 'boolean', description: 'Immediately enforceable; otherwise the award executes when the five-business-day appeal window lapses unappealed.' },
    conflict_check_confirmed: bool, evidence_limitation: nullable({ ...str, maxLength: 2000 }), sanctions: { type: 'array', maxItems: 4, items: ref('DisputeSanctionInput') }, metric_event: nullable(enumOf(...METRICS)),
    lock_version: { type: 'integer', minimum: 1 } }, description: 'The remedy, the reason and the conflict check are required. A stale lock_version returns 409.' },
  AdminDisputeAppealDecisionRequest: { type: 'object', required: ['result', 'reason', 'conflict_check_confirmed', 'lock_version'], properties: { result: enumOf('AFFIRMED', 'MODIFIED', 'REVERSED'),
    outcome: nullable(enumOf(...DECIDABLE)), reason: { ...str, minLength: 20, maxLength: 4000 }, amount_centavos: nullable({ type: 'integer', minimum: 1 }), affected_line_ids: arr(uuid), conflict_check_confirmed: bool,
    sanctions: { type: 'array', maxItems: 4, items: ref('DisputeSanctionInput') }, metric_event: nullable(enumOf(...METRICS)), lock_version: { type: 'integer', minimum: 1 } },
    description: 'Reviewed by an Admin who did not make the appealed decision, unless that Admin is a Super Admin (409 CONFLICT_OF_INTEREST otherwise). Final and executed at once.' },
  DisputeExport: obj({ id: uuid, state: enumOf('QUEUED', 'READY', 'REVOKED', 'FAILED', 'EXPIRED'), row_count: nullable(int), requested_at: dt, completed_at: nullable(dt), expires_at: nullable(dt), revocation_reason: nullable(str) }),
  DisputeExportRequest: { type: 'object', properties: { group: nullable(enumOf(...GROUPS)) } },
  DisputeRealtime: obj({ channel: nullable(str), enabled: bool, key: nullable(str), host: nullable(str), port: nullable(int), scheme: nullable(str) }),
  DisputeChannelAuthRequest: obj({ socket_id: str, channel_name: { ...str, maxLength: 240 } }),
  DisputeListMeta: loose({ page: int, per_page: int, total: int, has_more: bool, group: str, status: str, counts: { type: 'object', additionalProperties: { type: 'integer' } } }),
  // FIN-09
  InvoiceRecordView: { ...obj({ id: uuid, invoice_type: enumOf(...INVOICE_TYPES), issuer: str, invoice_number: str, issued_on: str, amount_centavos: cents, vat_centavos: nullable(cents), document_origin: enumOf('DEMO_SAMPLE', 'VENDOR_REGISTERED_PROCESS', 'PLATFORM_SAMPLE'),
    origin_label: str, verification_state: enumOf('UNVERIFIED', 'VERIFIED', 'REJECTED'), e_invoicing_coverage: enumOf('REVIEW_REQUIRED', 'COVERED', 'NOT_COVERED', 'EXEMPT_MICRO'), compliance_note: str,
    reconciliation_state: enumOf(...RECONCILIATION), reconciliation_difference_centavos: int, expected_total_centavos: nullable(int), reconciliation_note: nullable(str), amends_invoice_record_id: nullable(uuid),
    uploaded_at: nullable(dt), uploaded_role: nullable(str), source_system: nullable(str), invoicing_method: nullable(str), download: maybe('DisputeFileLink'), can_explain: bool, buyer_total_unchanged: bool,
    order_reference: nullable(str), vendor_name: nullable(str), downloads: nullable(int), last_download_at: nullable(dt) }),
    description: 'A protected copy of an externally issued Vendor document. An uploaded PDF is not proof of BIR or structured e-invoicing compliance; a reconciliation difference never changes the accepted Buyer total.' },
  InvoiceRequestView: obj({ id: uuid, kind: enumOf('COPY', 'CORRECTION'), state: enumOf(...REQUEST_STATES), details: nullable(str), invoice_record_id: nullable(uuid), fulfilled_invoice_record_id: nullable(uuid),
    requested_at: nullable(dt), service_target_at: dt, service_target_label: str, overdue: bool, uploaded_at: nullable(dt), downloaded_at: nullable(dt), closed_at: nullable(dt), can_return: bool, can_close: bool,
    order_reference: nullable(str), vendor_name: nullable(str) }),
  PlatformDocumentRef: { ...obj({ kind: enumOf('PURCHASE_ORDER', 'PAYMENT_CONFIRMATION'), title: str, not_tax_invoice: bool, label: enumOf(NOT_TAX), availability: str }),
    description: 'MateryalPH documents are always labelled not a tax invoice.' },
  BuyerInvoiceBillingDetails: obj({ billing_name: str, billing_address: str, tin_masked: nullable(str), lock_version: int }),
  VendorInvoiceBillingDetails: obj({ billing_name: str, billing_address: str, tin: nullable(str), tin_masked: nullable(str) }),
  InvoiceOrderLine: obj({ order_line_id: uuid, display_name: str }),
  BuyerOrderInvoices: obj({ order_id: uuid, order_reference: str, status: enumOf('ISSUED', 'NOT_YET_UPLOADED', 'NOT_DUE'), issuance_notice: str, records: arr(ref('InvoiceRecordView')),
    requests: arr(ref('InvoiceRequestView')), platform_documents: arr(ref('PlatformDocumentRef')), billing_details: maybe('BuyerInvoiceBillingDetails'), can_edit_billing_details: bool,
    can_request_copy: bool, can_request_correction: bool }),
  VendorOrderInvoices: obj({ order_id: uuid, order_reference: str, status: enumOf('ISSUED', 'NOT_YET_UPLOADED', 'NOT_DUE'), issuance_notice: str, records: arr(ref('InvoiceRecordView')),
    requests: arr(ref('InvoiceRequestView')), platform_documents: arr(ref('PlatformDocumentRef')), billing_details: maybe('VendorInvoiceBillingDetails'), can_upload: bool, can_open_files: bool, issuer_name: str,
    invoice_types: arr(enumOf(...VENDOR_INVOICE_TYPES)), source_systems: arr(enumOf(...SOURCE_SYSTEMS)), invoicing_methods: arr(enumOf(...INVOICING_METHODS)), lines: arr(ref('InvoiceOrderLine')) }),
  InvoiceLogRow: { ...loose({ id: uuid, order_id: uuid, order_reference: str, order_state: str, payment_state: str, accepted_at: nullable(dt), open_request: bool, note: str, kind: str, state: str, details: nullable(str),
    service_target_at: dt, service_target_label: str, overdue: bool, invoice_type: str, issuer: str, invoice_number: str, issued_on: str, amount_centavos: int, reconciliation_state: str,
    reconciliation_difference_centavos: int, origin_label: str, compliance_note: str, vendor_name: nullable(str), downloads: nullable(int), last_download_at: nullable(dt), uploaded_at: nullable(dt),
    download: maybe('DisputeFileLink') }), description: 'One row of the selected view: an open request, an order without an invoice copy yet, an uploaded record or a reconciliation item.' },
  InvoiceListMeta: loose({ view: str, counts: { type: 'object', additionalProperties: { type: 'integer' } }, page: int, per_page: int, total: int, has_more: bool, can_upload: bool, issuance_notice: str, notice: str }),
  InvoiceBillingDetailsRequest: { type: 'object', required: ['billing_name', 'billing_address'], properties: { billing_name: { ...str, minLength: 2, maxLength: 180 }, billing_address: { ...str, minLength: 10, maxLength: 500 },
    tin: nullable({ ...str, maxLength: 20 }), lock_version: nullable({ type: 'integer', minimum: 1 }) }, description: 'Collected only for the invoice. The TIN is encrypted and shown masked to the Buyer.' },
  InvoiceRequestCreate: { type: 'object', required: ['kind', 'details'], properties: { kind: enumOf('COPY', 'CORRECTION'), details: { ...str, minLength: 10, maxLength: 2000 }, invoice_record_id: nullable(uuid) } },
  InvoiceRequestAnswer: { type: 'object', required: ['action'], properties: { action: enumOf('RETURN', 'CLOSE'), reason: nullable({ ...str, maxLength: 1000 }) } },
  InvoiceUploadForm: { type: 'object', required: ['invoice_type', 'issuer_name', 'invoice_number', 'issued_on', 'amount_centavos', 'source_system', 'invoicing_method', 'file'], properties: {
    invoice_type: enumOf(...VENDOR_INVOICE_TYPES), issuer_name: { ...str, maxLength: 240, description: 'Must equal the registered business name.' }, invoice_number: { ...str, maxLength: 64 }, issued_on: { type: 'string', format: 'date' },
    amount_centavos: { type: 'integer', minimum: 0 }, vat_centavos: { type: 'integer', minimum: 0 }, vat_exempt_centavos: { type: 'integer', minimum: 0 }, zero_rated_centavos: { type: 'integer', minimum: 0 },
    related_line_ids: arr(uuid), source_system: enumOf(...SOURCE_SYSTEMS), invoicing_method: enumOf(...INVOICING_METHODS), amends_invoice_record_id: uuid, invoice_request_id: uuid,
    file: { ...binary, description: 'PDF, JPG or PNG copy, validated and scanned fail-closed, stored privately.' } },
    description: 'Owner, Store Manager or Store Staff upload a copy of the invoice issued through their registered process. MateryalPH never assigns the official number.' },
  InvoiceExplanationRequest: obj({ note: { ...str, minLength: 10, maxLength: 2000 } }),
  OrderDisputeRef: { type: 'object', required: ['case_id', 'reference', 'status', 'filed_by_party'], properties: { case_id: uuid, reference: str, status: enumOf(...CASE_STATES), filed_by_party: enumOf('BUYER', 'VENDOR'),
    filing_available: bool, filing_note: str } },
  OrderInvoiceRef: obj({ status: enumOf('ISSUED', 'NOT_YET_UPLOADED', 'NOT_DUE'), records: int, open_requests: int }),
};
const envelope = (name, data, meta = json) => { schemas[name] = obj({ data, meta, errors: arr(ref('ApiError')) }); };
envelope('DisputeListEnvelope', arr(ref('DisputeSummary')), ref('DisputeListMeta'));
envelope('DisputeDetailEnvelope', ref('DisputeDetail'));
envelope('DisputeEligibilityEnvelope', ref('DisputeEligibility'));
envelope('DisputeExportEnvelope', ref('DisputeExport'));
envelope('DisputeExportListEnvelope', arr(ref('DisputeExport')));
envelope('DisputeRealtimeEnvelope', ref('DisputeRealtime'));
envelope('BuyerOrderInvoicesEnvelope', ref('BuyerOrderInvoices'));
envelope('VendorOrderInvoicesEnvelope', ref('VendorOrderInvoices'));
envelope('InvoiceLogEnvelope', arr(ref('InvoiceLogRow')), ref('InvoiceListMeta'));

const paths = {};
const keyParam = { name: 'Idempotency-Key', in: 'header', required: true, schema: uuid };
const errors = codes => Object.fromEntries(codes.map(code => [String(code), { $ref: '#/components/responses/ErrorResponse' }]));
const BUYER = [{ passportBearer: [] }], WEB = [{ accessCookie: [], webCsrf: [] }];
const signedQuery = [{ name: 'expires', in: 'query', required: true, schema: { type: 'integer' } }, { name: 'signature', in: 'query', required: true, schema: str }];
function op(path, method, operationId, tag, security, description, { response, request, keyed = false, created = false, accepted = false, query = [], codes = [401, 403, 404, 409, 422], multipart = false, raw } = {}) {
  const parameters = [...path.matchAll(/\{(.*?)\}/g)].map(m => ({ name: m[1], in: 'path', required: true, schema: uuid }));
  if (keyed) parameters.push(keyParam);
  parameters.push(...query);
  const success = raw ?? { description: 'Authorized result.', content: { 'application/json': { schema: ref(response) } } };
  const status = accepted ? '202' : created ? '201' : '200';
  (paths[path] ??= {})[method] = { operationId, tags: [tag], description, security, ...(parameters.length ? { parameters } : {}),
    ...(request ? { requestBody: { required: true, content: { [multipart ? 'multipart/form-data' : 'application/json']: { schema: ref(request) } } } } : {}),
    responses: { [status]: success, ...(created ? { '200': { description: 'Idempotent replay.', content: success.content } } : {}), ...errors(codes) } };
}
const evidenceFile = { description: 'Private evidence bytes for a signed, unexpired link and an authorized caller.', content: { 'image/png': { schema: binary }, 'image/jpeg': { schema: binary }, 'application/pdf': { schema: binary } } };
const csvFile = { description: 'CSV of case headers; spreadsheet formulas neutralized.', content: { 'text/csv': { schema: binary } } };
const channelAuth = { description: 'Reverb private-channel authorization.', content: { 'application/json': { schema: json } } };

for (const [prefix, audience, tag, security] of [['/buyers', 'BUYER', 'Buyer Disputes', BUYER], ['/vendor', 'VENDOR', 'Vendor Disputes', WEB]]) {
  const p = audience === 'BUYER' ? 'Buyer' : 'Vendor';
  const scope = audience === 'BUYER' ? 'The Buyer\'s own cases.' : 'Owner and Store Manager; Store Staff and Customer Service while the Owner\'s staff dispute flag is on (403 otherwise); assigned Fulfillment Staff see a limited case and add fulfillment evidence only; Inventory Staff are denied.';
  op(`${prefix}/disputes`, 'get', `list${p}Disputes`, tag, security, `${scope} Paginated, active first.`, { response: 'DisputeListEnvelope', codes: [401, 403, 422],
    query: [{ name: 'group', in: 'query', schema: enumOf(...GROUPS) }, { name: 'q', in: 'query', schema: { ...str, maxLength: 120 } }, { name: 'page', in: 'query', schema: { type: 'integer', minimum: 1, maximum: 1000 } }] });
  op(`${prefix}/disputes`, 'post', `file${p}Dispute`, tag, security, 'File a structured case. Creates a Case ID and the dispute state only — never a refund or REFUND_PENDING. A transaction case opens from PROCESSING; a post-completion return within seven days after COMPLETED. An active case on the order returns 409 DISPUTE_ALREADY_OPEN with its id.',
    { response: 'DisputeDetailEnvelope', request: 'DisputeFileForm', keyed: true, created: true, multipart: true });
  op(`${prefix}/disputes/realtime`, 'get', `get${p}DisputeRealtime`, tag, security, 'The caller\'s private dispute channel. Its name changes whenever the caller\'s access changes; only "case changed" signals travel over it.', { response: 'DisputeRealtimeEnvelope', codes: [401, 403] });
  op(`${prefix}/disputes/realtime/auth`, 'post', `authorize${p}DisputeChannel`, tag, security, 'Authorize the current dispute channel; a stale or revoked channel is refused.', { raw: channelAuth, request: 'DisputeChannelAuthRequest', codes: [401, 403, 422, 503] });
  op(`${prefix}/orders/{orderId}/dispute-eligibility`, 'get', `get${p}DisputeEligibility`, tag, security, 'Whether a case can be filed, the read-only masked original payment method and the affected-line amounts. Never a refund destination.', { response: 'DisputeEligibilityEnvelope', codes: [401, 403, 404] });
  const c = `${prefix}/disputes/{caseId}`;
  op(c, 'get', `get${p}Dispute`, tag, security, 'The case with its single chronological timeline, signed evidence links, deadlines and server-computed actions.', { response: 'DisputeDetailEnvelope', codes: [401, 403, 404] });
  op(`${c}/respond`, 'post', `respond${p}Dispute`, tag, security, 'The responding party answers within 48 hours. A response opens 72 hours of mutual resolution; REQUEST_ADMIN_REVIEW escalates. A late response returns 409 RESPONSE_WINDOW_CLOSED.', { response: 'DisputeDetailEnvelope', request: 'DisputeRespondForm', keyed: true, multipart: true });
  op(`${c}/proposals`, 'post', `propose${p}DisputeResolution`, tag, security, 'Propose a remedy during mutual resolution; it supersedes your earlier open proposal. Vendor refund proposals are Owner-only.', { response: 'DisputeDetailEnvelope', request: 'DisputeProposalRequest', keyed: true });
  op(`${c}/proposals/{proposalId}/answer`, 'post', `answer${p}DisputeProposal`, tag, security, 'The other party accepts or rejects. Acceptance records the agreement as a final decision; a money agreement creates one DISPUTE_CONCLUSION refund per original payment and the case resolves only when it completes.', { response: 'DisputeDetailEnvelope', request: 'DisputeProposalAnswer', keyed: true });
  op(`${c}/escalate`, 'post', `escalate${p}Dispute`, tag, security, 'Ask for Admin review during mutual resolution (or as the responding party).', { response: 'DisputeDetailEnvelope', request: 'DisputeEscalateRequest', keyed: true });
  op(`${c}/evidence`, 'post', `add${p}DisputeEvidence`, tag, security, 'Labeled supplemental evidence; the original complaint is never edited.', { response: 'DisputeDetailEnvelope', request: 'DisputeEvidenceForm', keyed: true, created: true, multipart: true });
  op(`${c}/messages`, 'post', `send${p}DisputeMessage`, tag, security, 'A case message, appended to the timeline.', { response: 'DisputeDetailEnvelope', request: 'DisputeMessageRequest', keyed: true, created: true });
  op(`${c}/clarifications/{clarificationId}/answer`, 'post', `answer${p}DisputeClarification`, tag, security, 'Answer an Admin clarification within 24 hours.', { response: 'DisputeDetailEnvelope', request: 'DisputeClarificationAnswerForm', keyed: true, multipart: true });
  op(`${c}/appeal`, 'post', `appeal${p}Dispute`, tag, security, 'The case\'s one appeal, within five business days of an Admin decision, with new evidence or a material process error.', { response: 'DisputeDetailEnvelope', request: 'DisputeAppealForm', keyed: true, created: true, multipart: true });
  if (audience === 'BUYER') {
    op(`${c}/remedies/{remedyId}/confirm`, 'post', 'confirmBuyerDisputeReplacement', tag, security, 'Confirm receiving a replacement the Vendor recorded.', { response: 'DisputeDetailEnvelope', keyed: true });
  } else {
    op(`${c}/remedies/{remedyId}/record`, 'post', 'recordVendorDisputeReplacement', tag, security, 'Record the replacement; the Buyer confirms it.', { response: 'DisputeDetailEnvelope', request: 'DisputeReplacementForm', keyed: true, multipart: true });
    op('/vendor/disputes/exports', 'get', 'listVendorDisputeExports', tag, security, 'Your recent case exports.', { response: 'DisputeExportListEnvelope', codes: [401, 403] });
    op('/vendor/disputes/exports', 'post', 'requestVendorDisputeExport', tag, security, 'Queue a CSV of case headers. The job re-checks access when it runs and on download; switching the staff dispute flag off revokes staff exports.', { response: 'DisputeExportEnvelope', request: 'DisputeExportRequest', accepted: true, codes: [401, 403, 422] });
    op('/vendor/disputes/exports/{exportId}/download', 'get', 'downloadVendorDisputeExport', tag, security, 'Download a ready, unexpired export (audited).', { raw: csvFile, codes: [401, 403, 404, 503] });
  }
  op(`${c}/files/{fileId}/content`, 'get', `get${p}DisputeEvidenceFile`, tag, security, 'Evidence bytes behind a five-minute signed link; the caller is re-authorized against the case.', { raw: evidenceFile, query: signedQuery, codes: [401, 403, 404, 503] });
}

const A = 'Admin Disputes';
op('/admin/disputes', 'get', 'listAdminDisputes', A, WEB, 'disputes.view. Case ID, order, parties, issue, handler, deadline, status, requested remedy and refund state.', { response: 'DisputeListEnvelope', codes: [401, 403, 422],
  query: [{ name: 'status', in: 'query', schema: enumOf('NEEDS_ADMIN', 'WITH_PARTIES', 'REMEDY_TRACKING', 'CONCLUDED', 'ALL') }, { name: 'page', in: 'query', schema: { type: 'integer', minimum: 1, maximum: 1000 } }] });
op('/admin/disputes/realtime', 'get', 'getAdminDisputeRealtime', A, WEB, 'disputes.view. The caller\'s dispute channel.', { response: 'DisputeRealtimeEnvelope', codes: [401, 403] });
op('/admin/disputes/realtime/auth', 'post', 'authorizeAdminDisputeChannel', A, WEB, 'Authorize the current dispute channel.', { raw: channelAuth, request: 'DisputeChannelAuthRequest', codes: [401, 403, 422, 503] });
op('/admin/disputes/{caseId}', 'get', 'getAdminDispute', A, WEB, 'disputes.view. The case with decision support.', { response: 'DisputeDetailEnvelope', codes: [401, 403, 404] });
op('/admin/disputes/{caseId}/assign', 'post', 'assignAdminDispute', A, WEB, 'disputes.decide. Take the case.', { response: 'DisputeDetailEnvelope', keyed: true });
op('/admin/disputes/{caseId}/escalate', 'post', 'escalateAdminDispute', A, WEB, 'disputes.decide. Direct safety or compliance escalation.', { response: 'DisputeDetailEnvelope', request: 'DisputeEscalateRequest', keyed: true });
op('/admin/disputes/{caseId}/clarifications', 'post', 'requestAdminDisputeClarification', A, WEB, 'disputes.decide. Structured question with a 24-hour deadline per requested party.', { response: 'DisputeDetailEnvelope', request: 'AdminDisputeClarificationRequest', keyed: true });
op('/admin/disputes/{caseId}/decision', 'post', 'decideAdminDispute', A, WEB, 'disputes.decide. A new immutable decision version with the remedy, reason and conflict check. A money award executes now when immediately enforceable, otherwise after the appeal window lapses.', { response: 'DisputeDetailEnvelope', request: 'AdminDisputeDecisionRequest', keyed: true });
op('/admin/disputes/{caseId}/appeal-decision', 'post', 'decideAdminDisputeAppeal', A, WEB, 'disputes.decide by a different Admin than the appealed decision. Affirmed, Modified or Reversed; final.', { response: 'DisputeDetailEnvelope', request: 'AdminDisputeAppealDecisionRequest', keyed: true });
op('/admin/disputes/{caseId}/remedies/{remedyId}/confirm', 'post', 'confirmAdminDisputeRemedy', A, WEB, 'disputes.decide. Reasoned confirmation of a recorded replacement the Buyer did not acknowledge.', { response: 'DisputeDetailEnvelope', request: 'DisputeRemedyConfirmRequest', keyed: true });
op('/admin/disputes/{caseId}/files/{fileId}/content', 'get', 'getAdminDisputeEvidenceFile', A, WEB, 'disputes.view. Evidence behind a signed link.', { raw: evidenceFile, query: signedQuery, codes: [401, 403, 404, 503] });

const BI = 'Buyer Invoices';
op('/buyers/orders/{orderId}/invoices', 'get', 'getBuyerOrderInvoices', BI, BUYER, 'Invoice copies as soon as the Vendor uploads them (not only after completion), requests with their three-business-day target and MateryalPH documents labelled not a tax invoice.', { response: 'BuyerOrderInvoicesEnvelope', codes: [401, 403, 404] });
op('/buyers/orders/{orderId}/invoices/details', 'put', 'saveBuyerInvoiceDetails', BI, BUYER, 'Billing name, address and optional TIN for the Vendor\'s invoice. Stale lock_version returns 409.', { response: 'BuyerOrderInvoicesEnvelope', request: 'InvoiceBillingDetailsRequest' });
op('/buyers/orders/{orderId}/invoices/requests', 'post', 'requestBuyerInvoice', BI, BUYER, 'Request a copy or a correction. The service target never extends the Vendor\'s legal issuance deadline.', { response: 'BuyerOrderInvoicesEnvelope', request: 'InvoiceRequestCreate', keyed: true, created: true });
op('/buyers/orders/{orderId}/invoices/requests/{requestId}/answer', 'post', 'answerBuyerInvoiceRequest', BI, BUYER, 'Return an uploaded document for correction, or close the request.', { response: 'BuyerOrderInvoicesEnvelope', request: 'InvoiceRequestAnswer', keyed: true });
op('/buyers/invoice-records/{recordId}/content', 'get', 'getBuyerInvoiceFile', BI, BUYER, 'Invoice copy behind a signed link; the download is recorded.', { raw: evidenceFile, query: signedQuery, codes: [401, 403, 404, 503] });
const VI = 'Vendor Invoices';
op('/vendor/invoices', 'get', 'listVendorInvoices', VI, WEB, 'invoices.view. Open requests, orders without an invoice copy yet, uploaded records and reconciliation items. Never Earnings or other protected finance.', { response: 'InvoiceLogEnvelope', codes: [401, 403, 422],
  query: [{ name: 'view', in: 'query', schema: enumOf('REQUESTS', 'DUE', 'RECORDS', 'RECONCILIATION') }, { name: 'page', in: 'query', schema: { type: 'integer', minimum: 1, maximum: 1000 } }] });
op('/vendor/orders/{orderId}/invoices', 'get', 'getVendorOrderInvoices', VI, WEB, 'invoices.view. Customer Service sees status and metadata only; the full Buyer TIN only for roles that upload.', { response: 'VendorOrderInvoicesEnvelope', codes: [401, 403, 404] });
op('/vendor/orders/{orderId}/invoices', 'post', 'uploadVendorInvoice', VI, WEB, 'invoices.upload (Owner, Store Manager, Store Staff). Validates type and issuer; a total or VAT difference opens INVOICE_RECONCILIATION_REQUIRED without changing the accepted Buyer total.', { response: 'VendorOrderInvoicesEnvelope', request: 'InvoiceUploadForm', keyed: true, created: true, multipart: true });
op('/vendor/orders/{orderId}/invoices/{recordId}/explanation', 'post', 'explainVendorInvoiceDifference', VI, WEB, 'invoices.upload. Explain a reconciliation difference.', { response: 'VendorOrderInvoicesEnvelope', request: 'InvoiceExplanationRequest', keyed: true });
op('/vendor/invoice-records/{recordId}/content', 'get', 'getVendorInvoiceFile', VI, WEB, 'Owner, Store Manager, Store Staff, or the assigned Fulfillment Staff; signed link; recorded.', { raw: evidenceFile, query: signedQuery, codes: [401, 403, 404, 503] });
const AI = 'Admin Invoices';
op('/admin/invoices', 'get', 'listAdminInvoiceLog', AI, WEB, 'invoices.view. Read-only Invoice Request Log with records, mismatches and download events.', { response: 'InvoiceLogEnvelope', codes: [401, 403, 422],
  query: [{ name: 'view', in: 'query', schema: enumOf('REQUESTS', 'RECORDS', 'MISMATCHES') }, { name: 'page', in: 'query', schema: { type: 'integer', minimum: 1, maximum: 1000 } }] });
op('/admin/invoice-records/{recordId}/content', 'get', 'getAdminInvoiceFile', AI, WEB, 'invoices.view. Signed link; recorded.', { raw: evidenceFile, query: signedQuery, codes: [401, 403, 404, 503] });

source = source.replace(/\n  # Phase 13 disputes and invoices operations[\s\S]*?(?=\n  # Phase 12 fulfillment and cancellation operations)/, '');
source = source.replace(/\n    # Phase 13 disputes and invoices schemas[\s\S]*?(?=\n    # Phase 12 fulfillment and cancellation schemas)/, '');
const indent = (text, pad) => YAML.stringify(text, { aliasDuplicateObjects: false, defaultStringType: 'QUOTE_DOUBLE', lineWidth: 0 }).split('\n').filter(Boolean).map(l => pad + l).join('\n');
source = source.replace('\n  # Phase 12 fulfillment and cancellation operations', '\n  # Phase 13 disputes and invoices operations\n' + indent(paths, '  ') + '\n  # Phase 12 fulfillment and cancellation operations');
source = source.replace('\n    # Phase 12 fulfillment and cancellation schemas', '\n    # Phase 13 disputes and invoices schemas\n' + indent(schemas, '    ') + '\n    # Phase 12 fulfillment and cancellation schemas');
source = source.replace(/version: 1\.0\.0-phase\.\d+/, 'version: 1.0.0-phase.13');

function editSchema(name, edit) {
  const pattern = new RegExp(`(\\n    ${name}:\\n)([\\s\\S]*?)(?=\\n    [A-Za-z#][A-Za-z0-9_ ]*:|$)`);
  if (!pattern.test(source)) throw new Error(`Schema ${name} not found`);
  source = source.replace(pattern, (_, heading, body) => heading + edit(body));
}
editSchema('OrderDetail', body => {
  const actions = body.match(/\n        available_actions: \{ type: array, items: \{ type: string, enum: \[ (.*?) \] \} \}/);
  if (!actions) throw new Error('OrderDetail.available_actions not found');
  const merged = [...new Set([...actions[1].split(', '), 'FILE_DISPUTE', 'VIEW_DISPUTE', 'REQUEST_INVOICE'])];
  return body.replace(actions[0], `\n        available_actions: { type: array, items: { type: string, enum: [ ${merged.join(', ')} ] } }`)
    .replace(/\n        dispute: .*|\n        invoice: .*/g, '')
    + '\n        dispute: { oneOf: [ { $ref: "#/components/schemas/OrderDisputeRef" }, { type: \'null\' } ] }\n        invoice: { oneOf: [ { $ref: "#/components/schemas/OrderInvoiceRef" }, { type: \'null\' } ] }';
});
const PERMISSIONS = ['can_file_dispute', 'can_upload_invoice'];
editSchema('VendorOrderPermissions', body => body.replace(new RegExp(`\\n        (${PERMISSIONS.join('|')}): .*`, 'g'), '') + PERMISSIONS.map(name => `\n        ${name}: { type: boolean }`).join(''));
for (const tag of ['Buyer Disputes', 'Vendor Disputes', A, BI, VI, AI]) {
  if (!source.includes(`  - name: ${tag}\n`)) source = source.replace('\ntags:\n', `\ntags:\n  - name: ${tag}\n`);
}
writeFileSync(file, crlf ? source.replace(/\n/g, '\r\n') : source);
console.log(`Authored ${Object.values(paths).reduce((n, methods) => n + Object.keys(methods).length, 0)} Phase 13 operations and ${Object.keys(schemas).length} schemas.`);
