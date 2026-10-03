import { readFileSync, writeFileSync } from 'node:fs';
import YAML from 'yaml';

// Additive authoring helper. Generated clients are produced only by generate-clients.mjs.
const file = new URL('../openapi.yaml', import.meta.url);
let source = readFileSync(file, 'utf8');
source = source.replace(/  \/\{messagingPortal\}\/conversations:[\s\S]*?(?=  \/\{webAccountPortal\}\/account\/photo:)/, '').replace(/    ChatIdentity:[\s\S]*?(?=    BuyerOriginRequest:)/, '');
const ref = name => ({ $ref: `#/components/schemas/${name}` });
const str = { type: 'string' }, uuid = { type: 'string', format: 'uuid' }, integer = { type: 'integer' }, bool = { type: 'boolean' };
const json = { type: 'object', additionalProperties: true };
const arr = items => ({ type: 'array', items });
const obj = (properties, required = Object.keys(properties).filter(key => !properties[key].nullable)) => ({ type: 'object', required, properties });
const nullable = schema => ({ ...schema, nullable: true });
const schemas = {
  ChatIdentity: obj({ display_name: str, role: str, avatar_path: nullable(str) }),
  ChatStore: obj({ id: uuid, name: str, logo_url: nullable(str), verified: bool }),
  ConversationView: obj({ id: uuid, purpose: { type: 'string', enum: ['SALES', 'FULFILLMENT'] }, context_type: { type: 'string', enum: ['ITEM_BASED', 'PROJECT_BASED'] }, order_id: nullable(uuid), lock_version: integer, store: ref('ChatStore'), handler: nullable(ref('ChatIdentity')), unread_count: integer, channel: str, locked_reference: json, updated_at: str, can_transfer: bool, fulfillment_entry_enabled: bool }),
  ChatAttachment: obj({ id: uuid, display_name: str, media_type: str, size_bytes: integer, scan_state: { type: 'string', enum: ['PENDING', 'CLEAN', 'REJECTED', 'FAILED'] } }),
  ChatMessage: obj({ id: uuid, client_message_id: uuid, body: str, kind: { type: 'string', enum: ['TEXT', 'SYSTEM', 'ATTACHMENT'] }, sender: ref('ChatIdentity'), sent_at: str, mine: bool, attachments: arr(ref('ChatAttachment')), read_by_recipient: bool }),
  ChatMessagePage: obj({ items: arr(ref('ChatMessage')), has_more: bool, next_before: nullable(uuid) }),
  ChatQuotationLine: obj({ variant_id: uuid, quantity: str, unit_price_centavos: integer, description: str, unit_code: str, tax_category: str, source_price_version_id: uuid, source_tax_version_id: uuid }),
  ChatQuotationChange: obj({ path: str, label: str, before: {}, after: {} }),
  ChatQuotationMoney: obj({ materials_payable_centavos: integer, materials_vat_centavos: integer, vendor_discount_centavos: integer, delivery_centavos: integer, nrpc_centavos: integer, commercial_total_centavos: integer }),
  ChatQuotationContent: obj({ lines: arr(ref('ChatQuotationLine')), commercial: ref('ChatQuotationMoney'), fulfillment_method: str, payment_method: str, fulfillment_date: str, delivery: nullable(json), nrpc: nullable(json), changes: arr(ref('ChatQuotationChange')), original_changes: arr(ref('ChatQuotationChange')), price_source: { type: 'string', enum: ['PRIVATE_TRANSACTION'] }, processing_fee_status: str }),
  ChatQuotationVersion: obj({ id: uuid, version: integer, latest: bool, state: str, published_at: str, expires_at: str, content_hash: str, content: ref('ChatQuotationContent'), viewed: bool, actions: arr(str) }),
  ChatQuotation: obj({ id: uuid, state: str, lock_version: integer, current_version_id: nullable(uuid), accepted_order_id: nullable(uuid), response_due_at: nullable(str), draft: nullable(json), can_draft: bool, can_publish: bool }),
  ChatQuotationPage: obj({ quotation: nullable(ref('ChatQuotation')), versions: arr(ref('ChatQuotationVersion')), has_more: bool, page: integer }, ['versions', 'has_more']),
  ConversationDetail: obj({ conversation: ref('ConversationView'), messages: ref('ChatMessagePage'), quotations: ref('ChatQuotationPage') }),
  ConversationPage: obj({ items: arr(ref('ConversationView')), page: integer, has_more: bool }),
  ChatCreate: obj({ vendor_id: uuid, listing_variant_id: uuid, location_id: uuid, heavy_vehicle_restriction: str, alternate_drop_off_location_id: uuid, access_instructions: str, context_type: { type: 'string', enum: ['ITEM_BASED', 'PROJECT_BASED'] } }, ['vendor_id']),
  ChatSend: obj({ client_message_id: uuid, body: { type: 'string', minLength: 1, maxLength: 5000 } }),
  ChatRead: obj({ through_message_id: uuid }),
  ChatTransfer: obj({ handler_user_id: integer, lock_version: integer, reason: { type: 'string', maxLength: 500 } }),
  ChatHandler: obj({ id: integer, display_name: str, role: str }),
  ChatDraftLine: obj({ variant_id: uuid, quantity: str, unit_price_centavos: { type: 'integer', minimum: 1, maximum: 100000000000 } }),
  ChatDraftContent: obj({ lines: { ...arr(ref('ChatDraftLine')), minItems: 1, maxItems: 100 }, fulfillment_method: { type: 'string', enum: ['PICKUP', 'DELIVERY'] }, payment_method: { type: 'string', enum: ['ONLINE'] }, fulfillment_date: str, deadline_hours: { type: 'integer', minimum: 1, maximum: 72, default: 24 }, vendor_discount_centavos: integer, delivery: json, nrpc: json }, ['lines', 'fulfillment_method', 'payment_method', 'fulfillment_date']),
  ChatDraftSave: obj({ lock_version: integer, draft: ref('ChatDraftContent') }),
  ChatPublish: obj({ lock_version: integer }),
  ChatDecision: obj({ version_id: uuid, content_hash: { type: 'string', minLength: 64, maxLength: 64 }, reason: { type: 'string', maxLength: 2000 }, nrpc_acknowledged: bool, nrpc_terms_version_id: uuid }, ['version_id']),
  ChatDecisionResult: obj({ order_id: nullable(uuid) }),
  ChatId: obj({ id: uuid }),
  ChatRealtime: obj({ inbox_channel: { ...nullable(str), description: 'Opaque private Buyer inbox channel without the private- prefix; null for non-Buyers. Receives inbox.changed invalidations only. Re-fetch configuration after reconnecting.' }, enabled: bool, key: nullable(str), host: nullable(str), port: integer, scheme: str }),
  ChatChannelAuth: obj({ socket_id: str, channel_name: str }),
  ChatChannelSignature: obj({ auth: str }),
};
const envelope = schema => obj({ data: schema, meta: json, errors: arr(ref('ApiError')) });
// Match the established error model, avoiding a second error vocabulary.
const existing = YAML.parse(source);
const errorName = existing.components.schemas.ApiError ? 'ApiError' : Object.keys(existing.components.schemas).find(x => x === 'ErrorDetail') || 'Error';
for (const [name, schema] of Object.entries({ ConversationDetail: ref('ConversationDetail'), ConversationPage: ref('ConversationPage'), ChatQuotationPage: ref('ChatQuotationPage'), ChatId: ref('ChatId'), ChatDecisionResult: ref('ChatDecisionResult'), ChatRealtime: ref('ChatRealtime'), ChatHandlers: arr(ref('ChatHandler')), ChatEmpty: { nullable: true, type: 'object' } })) {
  schemas[name+'Response'] = envelope(schema);
  schemas[name+'Response'].properties.errors = arr(ref(errorName));
}
const paths = {};
const portal = { name: 'messagingPortal', in: 'path', required: true, schema: { type: 'string', enum: ['buyers', 'vendor'] } };
const conversation = { name: 'conversationId', in: 'path', required: true, schema: uuid };
const key = { name: 'Idempotency-Key', in: 'header', required: true, schema: uuid };
const page = { name: 'page', in: 'query', schema: { type: 'integer', minimum: 1 } };
function add(path, method, operationId, response, input, extra = [], description = '') {
  const params = [portal, ...(path.includes('{conversationId}') ? [conversation] : []), ...extra];
  const op = { tags: ['Messaging'], operationId, description: description || 'Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.', security: [{ passportBearer: [] }, { accessCookie: [], webCsrf: [] }], parameters: params, responses: { '200': { description: 'Authorized result', content: { 'application/json': { schema: ref(response) } } }, '401': { description: 'Authentication required' }, '403': { description: 'Current role or channel access denied' }, '404': { description: 'Conversation unavailable or access revoked' }, '409': { description: 'Recoverable version, deadline, idempotency or stock conflict; re-read the current version' }, '422': { description: 'Invalid fields or undisclosed NRPC' }, '503': { description: 'Provider or scanner unavailable; retry safely' } } };
  if (['createConversation'].includes(operationId)) { op.parameters[0] = { ...portal, schema: { type: 'string', enum: ['buyers'] } }; op.security = [{ passportBearer: [] }]; }
  if (['listChatHandlers', 'transferChatHandler', 'saveChatQuotationDraft', 'publishChatQuotation'].includes(operationId)) { op.parameters[0] = { ...portal, schema: { type: 'string', enum: ['vendor'] } }; op.security = [{ accessCookie: [], webCsrf: [] }]; }
  if (input) op.requestBody = { required: true, content: { 'application/json': { schema: ref(input) } } };
  paths[path] ??= {}; paths[path][method] = op;
  return op;
}
const base = '/{messagingPortal}/conversations';
const thread = base+'/{conversationId}';
add(base, 'get', 'listConversations', 'ConversationPageResponse', null, [page]);
add(base, 'post', 'createConversation', 'ChatIdResponse', 'ChatCreate', [key], 'Buyer-only Item-Based inquiry. Project inquiry entry remains gated until Phase 10; both contexts use the same quotation engine. Fulfillment thread creation has no public endpoint and Phase 12 entry remains disabled.').responses['201'] = { description: 'Conversation created', content: { 'application/json': { schema: ref('ChatIdResponse') } } };
add(thread, 'get', 'getConversation', 'ConversationDetailResponse', null, [page, { name: 'before', in: 'query', schema: uuid }]);
add(thread+'/messages', 'post', 'sendChatMessage', 'ChatIdResponse', 'ChatSend').responses['201'] = { description: 'Message saved idempotently by client_message_id', content: { 'application/json': { schema: ref('ChatIdResponse') } } };
add(thread+'/read', 'post', 'readChatMessages', 'ChatEmptyResponse', 'ChatRead');
add(thread+'/handlers', 'get', 'listChatHandlers', 'ChatHandlersResponse', null, [page]);
add(thread+'/transfer', 'post', 'transferChatHandler', 'ChatEmptyResponse', 'ChatTransfer');
add(thread+'/quotation/draft', 'put', 'saveChatQuotationDraft', 'ChatQuotationPageResponse', 'ChatDraftSave');
add(thread+'/quotation/publish', 'post', 'publishChatQuotation', 'ChatQuotationPageResponse', 'ChatPublish', [key]);
add(thread+'/quotation/{action}', 'post', 'decideChatQuotation', 'ChatDecisionResultResponse', 'ChatDecision', [{ name: 'action', in: 'path', required: true, schema: { type: 'string', enum: ['view', 'accept', 'reject', 'counter', 'withdraw'] } }, key]);
const upload = add(thread+'/attachments', 'post', 'uploadChatAttachment', 'ChatEmptyResponse');
upload.requestBody = { required: true, content: { 'multipart/form-data': { schema: obj({ file: { type: 'string', format: 'binary' }, client_message_id: uuid }) } } };
upload.responses['201'] = upload.responses['200'];
for (const [suffix, parameter, op] of [['attachments', 'attachmentId', 'downloadChatAttachment'], ['avatars', 'userId', 'getChatAvatar']]) {
  const route = add(thread+`/${suffix}/{${parameter}}`, 'get', op, 'ChatEmptyResponse', null, [{ name: parameter, in: 'path', required: true, schema: parameter === 'userId' ? integer : uuid }]);
  route.responses['200'] = { description: 'Private authorized bytes; no-store. CLEAN files only. Fulfillment cannot retrieve sales or financial attachments.', content: { 'application/octet-stream': { schema: { type: 'string', format: 'binary' } } } };
}
add('/{messagingPortal}/messaging/realtime', 'get', 'getChatRealtime', 'ChatRealtimeResponse');
const auth = add('/{messagingPortal}/messaging/auth', 'post', 'authorizeChatChannel', 'ChatChannelSignature', 'ChatChannelAuth');
auth.description = 'Pusher protocol signature for an authorized per-viewer Reverb channel. Purpose, membership and assignment epoch must match. Broadcasts carry only invalidations; message/file data always requires a fresh authorized REST request. No client events are accepted.';
if (!source.includes('  /{messagingPortal}/conversations:')) {
  source = source.replace('paths:\n', 'paths:\n'+YAML.stringify(paths, { aliasDuplicateObjects: false }).split('\n').filter(Boolean).map(x=>'  '+x).join('\n')+'\n');
  source = source.replace('  schemas:\n', '  schemas:\n'+YAML.stringify(schemas, { aliasDuplicateObjects: false }).split('\n').filter(Boolean).map(x=>'    '+x).join('\n')+'\n');
  source = source.replace('1.0.0-phase.8', '1.0.0-phase.9');
  writeFileSync(file, source);
}
