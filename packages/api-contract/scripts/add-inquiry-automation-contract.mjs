import { readFileSync, writeFileSync } from 'node:fs'
import { parse, stringify } from 'yaml'

const path = new URL('../openapi.yaml', import.meta.url)
let source = readFileSync(path, 'utf8').replaceAll('\r\n', '\n')
const spec = parse(source)
const schemas = spec.components.schemas
const ref = name => ({ $ref: `#/components/schemas/${name}` })
function block(kind, name, value) {
  const indent = kind === 'schema' ? '    ' : '  '
  const escaped = name.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')
  const match = new RegExp(`^${indent}(?:"${escaped}"|${escaped}):`, 'm').exec(source)
  const text = stringify({ [name]: value }, { lineWidth: 100 }).trimEnd().split('\n').map(line => indent + line).join('\n') + '\n'
  if (match) {
    const start = match.index
    const tail = source.slice(start + match[0].length)
    const next = new RegExp(`^[ ]{0,${indent.length}}[^ \n]`, 'm').exec(tail)
    const end = next ? start + match[0].length + next.index : source.length
    source = source.slice(0, start) + text + source.slice(end)
  } else {
    const index = source.indexOf(kind === 'schema' ? '    ChatMessage:' : 'components:')
    if (index < 0) throw new Error('Missing insertion anchor')
    source = source.slice(0, index) + text + source.slice(index)
  }
}
const object = (properties, required = Object.keys(properties)) => ({ type: 'object', required, properties })
const integer = { type: 'integer', minimum: 0 }
const uuid = { type: 'string', format: 'uuid' }
block('schema', 'AutomatedResponseOption', object({ label: { type: 'string', minLength: 1, maxLength: 80 }, response: { type: 'string', minLength: 1, maxLength: 5000 } }))
block('schema', 'AutomatedResponseSettings', object({ enabled: { type: 'boolean' }, welcome_message: { type: 'string', maxLength: 5000 }, options: { type: 'array', maxItems: 3, items: ref('AutomatedResponseOption') }, lock_version: integer }))
block('schema', 'AutomatedResponseSettingsEnvelope', object({ data: ref('AutomatedResponseSettings'), meta: { type: 'object', additionalProperties: true }, errors: { type: 'array', items: ref('ApiError') } }, ['data']))
block('schema', 'ChatAutomatedOption', object({ index: { ...integer, maximum: 2 }, label: { type: 'string' }, available: { type: 'boolean' } }))
block('schema', 'ChatAutomatedReply', object({ options: { type: 'array', maxItems: 3, items: ref('ChatAutomatedOption') } }))
block('schema', 'ChatAutomatedChoice', object({ welcome_message_id: uuid, option_index: { ...integer, maximum: 2 }, client_message_id: uuid }))
schemas.ChatMessage.properties.automated_reply = { ...ref('ChatAutomatedReply'), nullable: true, description: 'Static store reply. SYSTEM messages with this field do not count as human responses.' }
block('schema', 'ChatMessage', schemas.ChatMessage)
Object.assign(schemas.ConversationView.properties, {
  needs_human_response: { type: 'boolean', description: 'Buyer activity awaiting a manual store reply. Automated replies never clear it.' },
  can_configure_automated_response: { type: 'boolean' },
  can_prepare_order_quotation: { type: 'boolean' },
  order_lock_version: { type: 'integer', nullable: true, minimum: 1 },
  pending_order_id: { ...uuid, nullable: true },
})
block('schema', 'ConversationView', schemas.ConversationView)
schemas.ChatQuotation.properties.replaces_order_id = { ...uuid, nullable: true }
block('schema', 'ChatQuotation', schemas.ChatQuotation)
schemas.ChatQuotationVersion.properties.replaces_order_id = { ...uuid, nullable: true }
block('schema', 'ChatQuotationVersion', schemas.ChatQuotationVersion)
const responses = { '200': { description: 'Authorized result', content: { 'application/json': { schema: ref('AutomatedResponseSettingsEnvelope') } } }, '401': { description: 'Authentication required' }, '403': { description: 'Current role denied' }, '409': { description: 'Stale version, unavailable option or idempotency conflict' }, '422': { description: 'Validation failed' } }
const security = [{ passportBearer: [] }, { accessCookie: [], webCsrf: [] }]
const key = { name: 'Idempotency-Key', in: 'header', required: true, schema: uuid }
const body = schema => ({ required: true, content: { 'application/json': { schema: ref(schema) } } })
block('path', '/vendor/messaging/automated-response', {
  get: { tags: ['Messaging'], operationId: 'getAutomatedResponseSettings', description: 'Owner and Store Manager only. Static store text, disabled by default.', security, parameters: [], responses },
  put: { tags: ['Messaging'], operationId: 'saveAutomatedResponseSettings', description: 'Versioned, idempotent static response settings. Up to three explicit button rules; no AI or NLP.', security, parameters: [key], requestBody: body('AutomatedResponseSettings'), responses },
})
const choiceResponses = structuredClone(responses)
delete choiceResponses['200']
choiceResponses['201'] = { description: 'Idempotent Buyer choice and static response saved atomically', content: { 'application/json': { schema: ref('ChatIdResponse') } } }
block('path', '/buyers/conversations/{conversationId}/automated-response', { post: { tags: ['Messaging'], operationId: 'chooseChatAutomatedResponse', security: [{ passportBearer: [] }], description: 'Buyer-only explicit button selection for the active welcome message. Rechecks membership, enabled settings, read-only closure and human takeover. Same client_message_id replays safely.', parameters: [{ name: 'conversationId', in: 'path', required: true, schema: uuid }], requestBody: body('ChatAutomatedChoice'), responses: choiceResponses } })
block('schema', 'PendingOrderQuotationInput', object({ lock_version: { type: 'integer', minimum: 1 } }))
const pendingResponses = structuredClone(responses)
pendingResponses['200'].content['application/json'].schema = ref('ChatIdResponse')
block('path', '/vendor/orders/{orderId}/quotation-inquiry', { post: { tags: ['Messaging'], operationId: 'openPendingOrderQuotation', security, parameters: [{ name: 'orderId', in: 'path', required: true, schema: uuid }, key], requestBody: body('PendingOrderQuotationInput'), responses: pendingResponses, description: 'Authorized sales publisher opens the inquiry attached to this pending unconfirmed order. Opening never removes or cancels the order. Buyer acceptance atomically cancels the original pending request and creates its quotation-backed replacement. Accepted orders and any order with payment records cannot be replaced.' } })
spec.paths['/{messagingPortal}/conversations'].get.description = 'Unified paginated inbox of authorized SALES inquiry threads, including Work Packages directly. Fulfillment remains order-specific. Each inquiry preserves its own receipts and personal archive.'
block('path', '/{messagingPortal}/conversations', spec.paths['/{messagingPortal}/conversations'])
spec.paths['/{messagingPortal}/conversations/{conversationId}/project-inquiries'].get.deprecated = true
block('path', '/{messagingPortal}/conversations/{conversationId}/project-inquiries', spec.paths['/{messagingPortal}/conversations/{conversationId}/project-inquiries'])
writeFileSync(path, source)
