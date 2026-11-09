import { readFileSync, writeFileSync } from 'node:fs'
import { parse, stringify } from 'yaml'

const path = new URL('../openapi.yaml', import.meta.url)
let source = readFileSync(path, 'utf8').replaceAll('\r\n', '\n')
const spec = parse(source)
const schemas = spec.components.schemas
const ref = name => ({ $ref: `#/components/schemas/${name}` })
const uuid = { type: 'string', format: 'uuid' }
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
block('schema', 'ChatWorkPackageAttachment', { type: 'object', required: ['reference', 'can_prepare_quotation'], properties: {
  inquiry_id: { ...uuid, nullable: true, description: 'Private quotation linkage used by the attachment action, not a separate user-facing chat subject.' },
  order_id: { ...uuid, nullable: true }, order_lock_version: { type: 'integer', minimum: 1, nullable: true },
  reference: { type: 'object', additionalProperties: true, description: "Vendor-scoped read projection of the locked Work Package. Only this store's assigned quantities or its order snapshot items are included; other suppliers' materials and the package-wide budget are excluded. material_scope is VENDOR_ALLOCATION or VENDOR_ORDER; work_package contains the scoped lines and fulfillment details. order, when present, identifies the order and whether its terms were accepted. Source version/hash identify the retained complete original, not a hash of the filtered projection." },
  can_prepare_quotation: { type: 'boolean', description: 'Authorized Vendor may prepare the quotation directly from this attachment. Accepted orders cannot be replaced.' },
} })
schemas.ChatMessage.properties.work_package_attachment = { ...ref('ChatWorkPackageAttachment'), nullable: true }
if (!schemas.ChatMessage.properties.kind.enum.includes('WORK_PACKAGE')) schemas.ChatMessage.properties.kind.enum.push('WORK_PACKAGE')
block('schema', 'ChatMessage', schemas.ChatMessage)
schemas.ChatId.properties.store_conversation_id = { ...uuid, description: 'Normal Buyer/store chat to open after sharing a Work Package. The id field preserves historical quotation linkage.' }
block('schema', 'ChatId', schemas.ChatId)
schemas.ConversationView.properties.locked_reference.description = 'Locked reference for this conversation. Vendor Work Package views include only the store allocation or its order snapshot items; the complete immutable Buyer original stays retained internally and available to its Buyer.'
block('schema', 'ConversationView', schemas.ConversationView)
schemas.ConversationDetail.properties.thread_contexts.description = 'Authorized original references used to resolve older messages, quotations, files and receipts within the single chat. No reply-subject selector is shown.'
block('schema', 'ConversationDetail', schemas.ConversationDetail)
const get = spec.paths['/{messagingPortal}/conversations/{conversationId}'].get
if (!get.parameters.some(p => p.name === 'store_thread')) get.parameters.push({ name: 'store_thread', in: 'query', schema: { type: 'boolean', default: false }, description: 'Buyer app opens one normal store chat with all authorized sales history. The server selects the normal chat automatically. Dedicated fulfillment and raw commercial history remain separately authorized.' })
block('path', '/{messagingPortal}/conversations/{conversationId}', { get })
const combined = spec.paths['/vendor/conversations/{conversationId}/buyer-thread']
combined.get.description = 'One normal Buyer/store chat. The server uses the authorized store sales conversation for ordinary replies automatically, preserving order closure and original commercial permissions. Work Packages appear as message attachments; users never choose a reply subject.'
block('path', '/vendor/conversations/{conversationId}/buyer-thread', combined)
const contexts = spec.paths['/vendor/conversations/{conversationId}/buyer-thread/contexts']
contexts.get.deprecated = true
contexts.get.description = 'Compatibility read for historical clients. The application has no subject picker; normal chat replies are routed automatically.'
block('path', '/vendor/conversations/{conversationId}/buyer-thread/contexts', contexts)
const key = { name: 'Idempotency-Key', in: 'header', required: true, schema: uuid }
const responses = { '201': { description: 'Normal store chat opened and the Work Package attached once for this request', content: { 'application/json': { schema: ref('ChatIdResponse') } } }, ...Object.fromEntries(['401', '403', '404', '409', '422'].map(status => [status, { $ref: '#/components/responses/ErrorResponse' }])) }
for (const [url, operationId, name] of [
  ['/buyers/conversations/{conversationId}/work-package-attachment', 'shareChatWorkPackage', 'conversationId'],
  ['/buyers/orders/{orderId}/work-package-message', 'messageWorkPackageOrder', 'orderId'],
]) block('path', url, { post: { tags: ['Messaging'], operationId, description: 'Buyer-only Message action. Reuses the normal store chat and posts its locked Work Package attachment; never changes an order, quotation or procurement selection.', security: [{ passportBearer: [] }], parameters: [{ name, in: 'path', required: true, schema: uuid }, key], responses } })
writeFileSync(path, source)
