import { readFileSync, writeFileSync } from 'node:fs'
import YAML from 'yaml'

const path = new URL('../openapi.yaml', import.meta.url)
const doc = YAML.parseDocument(readFileSync(path, 'utf8'))
const ref = name => ({ $ref: `#/components/schemas/${name}` })
const uuid = { type: 'string', format: 'uuid' }
const nullable = schema => ({ ...schema, nullable: true })
const set = (name, value) => doc.setIn(['components', 'schemas', name], value)
const prop = (name, key, value) => doc.setIn(['components', 'schemas', name, 'properties', key], value)
set('ChatProduct', { type: 'object', required: ['product_id', 'listing_id', 'name', 'price_centavos', 'available'], properties: {
  product_id: uuid, listing_id: uuid, name: { type: 'string' }, price_centavos: { type: 'integer', format: 'int64' }, image_url: nullable({ type: 'string' }), available: { type: 'boolean' },
} })
set('ChatProductPage', { type: 'object', required: ['items', 'page', 'has_more'], properties: { items: { type: 'array', items: ref('ChatProduct') }, page: { type: 'integer' }, has_more: { type: 'boolean' } } })
const envelope = doc.getIn(['components', 'schemas', 'ConversationPageResponse']).toJSON()
envelope.properties.data = ref('ChatProductPage')
set('ChatProductPageResponse', envelope)
set('ChatTyping', { type: 'object', required: ['typing'], properties: { typing: { type: 'boolean' } } })
prop('ChatSend', 'product_id', nullable(uuid))
prop('ChatSend', 'body', nullable({ type: 'string', maxLength: 5000 }))
doc.setIn(['components', 'schemas', 'ChatSend', 'required'], ['client_message_id'])
doc.setIn(['components', 'schemas', 'ChatSend', 'description'], 'Requires nonblank body or product_id (listing variant UUID), or both. The product must be an eligible product of this conversation store. Retries with the same client_message_id and content return the same message; changed content conflicts.')
prop('ChatCreate', 'listing_variant_id', nullable(uuid))
prop('ChatMessage', 'product', nullable(ref('ChatProduct')))
prop('ChatMessage', 'kind', { type: 'string', enum: ['TEXT', 'SYSTEM', 'ATTACHMENT', 'PRODUCT', 'TEXT_WITH_PRODUCT'] })
prop('ConversationView', 'buyer', nullable(ref('ChatIdentity')))
prop('ConversationView', 'last_message_preview', { type: 'string' })
prop('ConversationView', 'latest_product_id', nullable(uuid))
prop('ConversationView', 'canonical_conversation_id', nullable(uuid))
prop('ConversationView', 'legacy_conversation_ids', { type: 'array', items: uuid })
prop('ConversationView', 'legacy_has_more', { type: 'boolean' })
prop('ConversationView', 'legacy_page', { type: 'integer' })
prop('ChatQuotationVersion', 'quotation_id', uuid)
prop('ChatQuotationVersion', 'accepted_order_id', nullable(uuid))
doc.setIn(['components', 'schemas', 'ChatRealtime', 'properties', 'inbox_channel', 'description'], 'Viewer-bound Buyer or Vendor inbox invalidation channel. Re-fetch configuration on reconnect. No message content is broadcast.')
const base = '/{messagingPortal}/conversations/{conversationId}'
const detailParameters = doc.getIn(['paths', base, 'get', 'parameters']).toJSON().filter(p => p.name !== 'legacy_page')
detailParameters.push({ name: 'legacy_page', in: 'query', schema: { type: 'integer', minimum: 1 }, description: 'Page of preserved legacy inquiry references, 25 per page.' })
doc.setIn(['paths', base, 'get', 'parameters'], detailParameters)
const template = doc.getIn(['paths', base, 'get']).toJSON()
const products = structuredClone(template)
products.operationId = 'listChatProducts'
products.description = 'Search active eligible products of this conversation store. product_id filters one listing variant for a local unsent draft.'
products.parameters = products.parameters.filter(p => !['before', 'page', 'legacy_page'].includes(p.name))
products.parameters.push({ name: 'q', in: 'query', schema: { type: 'string', maxLength: 120 } }, { name: 'product_id', in: 'query', schema: uuid }, { name: 'page', in: 'query', schema: { type: 'integer', minimum: 1 } })
products.responses['200'].content['application/json'].schema = ref('ChatProductPageResponse')
doc.setIn(['paths', `${base}/products`], { get: products })
const typing = doc.getIn(['paths', `${base}/read`, 'post']).toJSON()
typing.operationId = 'sendChatTyping'
typing.description = 'Ephemeral authorized conversation.typing event on existing viewer channels, with typing boolean and server millisecond timestamp at. Never persisted; receivers ignore older events and clear after three seconds. Existing account rate limits apply.'
typing.requestBody.content['application/json'].schema = ref('ChatTyping')
doc.setIn(['paths', `${base}/typing`], { post: typing })
const startPath = `${base}/quotation/start`
const start = doc.getIn(['paths', `${base}/quotation/publish`, 'post']).toJSON()
start.operationId = 'startNextChatQuotation'
start.description = 'Start a separate quotation after acceptance in the canonical general store chat. Prior accepted quotations and orders stay immutable. Work Package and fulfillment threads cannot start a later quotation. Requires the latest quotation lock_version and Idempotency-Key.'
doc.setIn(['paths', startPath], { post: start })
const destinationSchema = structuredClone(doc.getIn(['components', 'schemas', 'ChatCreate']).toJSON())
destinationSchema.properties = Object.fromEntries(Object.entries(destinationSchema.properties).filter(([key]) => ['location_id', 'heavy_vehicle_restriction', 'alternate_drop_off_location_id', 'access_instructions'].includes(key)))
destinationSchema.properties.lock_version = { type: 'integer', minimum: 1 }
destinationSchema.properties.heavy_vehicle_restriction = { type: 'string', enum: ['NO', 'YES'] }
destinationSchema.required = ['lock_version', 'location_id', 'heavy_vehicle_restriction']
set('ChatDestinationUpdate', doc.createNode(destinationSchema))
for (const item of doc.getIn(['components', 'schemas', 'ChatDestinationUpdate', 'properties', 'heavy_vehicle_restriction', 'enum']).items) item.type = 'QUOTE_SINGLE'
const destination = structuredClone(typing)
destination.operationId = 'updateChatDestination'
destination.description = 'Buyer-owned saved destination and heavy access for a general store chat. Requires the current conversation lock_version; rejects changes while a quotation is published/viewed. Accepted snapshots stay immutable. An active draft must be reviewed against its incremented quotation lock_version.'
destination.parameters.find(p => p.name === 'messagingPortal').schema.enum = ['buyers']
destination.requestBody.content['application/json'].schema = ref('ChatDestinationUpdate')
doc.setIn(['paths', `${base}/destination`], { put: destination })
writeFileSync(path, doc.toString({ lineWidth: 0 }))
