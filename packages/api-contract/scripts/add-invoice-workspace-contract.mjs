import { readFileSync, writeFileSync } from 'node:fs'
import { parse, stringify } from 'yaml'

const path = new URL('../openapi.yaml', import.meta.url)
let source = readFileSync(path, 'utf8').replaceAll('\r\n', '\n')
const spec = parse(source)
const schemas = spec.components.schemas
const ref = name => ({ $ref: `#/components/schemas/${name}` })
const nullable = type => ({ type: [type, 'null'] })
const integer = { type: 'integer', minimum: 0 }
const version = { ...integer, description: 'Current lock version; zero creates a new draft or preset.' }
const uuid = { type: 'string', format: 'uuid' }
const dateTime = { type: ['string', 'null'], format: 'date-time' }
const fileFields = { file_name: nullable('string'), content_type: nullable('string'), file_size_bytes: nullable('integer') }

function block(root, name, value) {
  const indent = root === 'schema' ? '    ' : '  '
  const pattern = new RegExp(`^${indent}(?:"${name.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}"|${name.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}):`, 'm')
  const match = pattern.exec(source)
  const text = stringify({ [name]: value }, { lineWidth: 100 }).trimEnd().split('\n').map(line => indent + line).join('\n') + '\n'
  if (match) {
    const from = match.index
    const tail = source.slice(from + match[0].length)
    const next = new RegExp(`^[ ]{0,${indent.length}}[^ \n]`, 'm').exec(tail)
    const to = next ? from + match[0].length + next.index : source.length
    source = source.slice(0, from) + text + source.slice(to)
  } else {
    const anchor = root === 'schema' ? '    "InvoiceExplanationRequest":' : 'components:'
    const index = source.indexOf(anchor)
    if (index < 0) throw new Error(`Missing contract anchor ${anchor}`)
    source = source.slice(0, index) + text + source.slice(index)
  }
}

const upload = structuredClone(schemas.InvoiceUploadForm)
upload.required = [...new Set([...upload.required.filter(name => name !== 'file'), 'lock_version'])]
upload.properties.lock_version = version
upload.properties.file.description = 'PDF, JPG or PNG, validated and scanned fail-closed. Required for a new draft; omit to retain its current file.'
upload.description = 'Saves a private, editable invoice draft. Never sends a copy or fulfills a Buyer request. Sent versions remain immutable; a Buyer correction or return is required before preparing a correction.'
block('schema', 'InvoiceUploadForm', upload)

const presetProperties = Object.fromEntries(['invoice_type', 'issuer_name', 'source_system', 'invoicing_method'].map(name => [name, upload.properties[name]]))
const presetInput = { type: 'object', required: [...Object.keys(presetProperties), 'lock_version'], properties: { ...presetProperties, lock_version: version } }
block('schema', 'InvoicePresetInput', presetInput)
block('schema', 'VendorInvoicePreset', { ...presetInput, required: [...presetInput.required, 'date_mode'], properties: { ...presetInput.properties, date_mode: { type: 'string', enum: ['TODAY'], description: 'New copies start with today in Asia/Manila. Each invoice date remains editable; numbers and amounts are never preset.' } } })
const presetEnvelope = structuredClone(schemas.VendorOrderInvoicesEnvelope)
presetEnvelope.properties.data = ref('VendorInvoicePreset')
block('schema', 'VendorInvoicePresetEnvelope', presetEnvelope)
block('schema', 'InvoiceSendInput', { type: 'object', required: ['lock_version'], properties: { lock_version: { type: 'integer', minimum: 1 } } })
const draftProperties = structuredClone(upload.properties)
delete draftProperties.file
block('schema', 'InvoiceDraft', {
  type: 'object', required: ['id', ...upload.required, 'download'],
  properties: { ...draftProperties, id: uuid, lock_version: { type: 'integer', minimum: 1 }, sent_record_id: { ...uuid, type: ['string', 'null'] }, sent_at: dateTime, updated_at: dateTime, ...fileFields, download: ref('DisputeFileLink') },
  description: 'Private Vendor preparation. Only invoice-upload roles receive it. The uploaded file is ready for review; sending freezes a separate invoice record. Buyer and Admin record lists never include drafts.',
})
const line = structuredClone(schemas.InvoiceOrderLine)
Object.assign(line.properties, { category: nullable('string'), quantity: { type: 'string' }, unit_name: { type: 'string' }, unit_price_centavos: integer, line_total_centavos: nullable('integer') })
block('schema', 'InvoiceOrderLine', line)
const amounts = Object.fromEntries(['materials_subtotal_centavos', 'discount_centavos', 'delivery_centavos', 'included_vat_centavos', 'total_centavos'].map(name => [name, nullable('integer')]))
block('schema', 'InvoiceBillingSnapshot', { type: 'object', required: ['billing_name', 'billing_address'], properties: { billing_name: { type: 'string' }, billing_address: { type: 'string' }, tin_masked: nullable('string') } })
block('schema', 'InvoiceOrderSummary', { type: 'object', required: ['lines', ...Object.keys(amounts)], properties: { lines: { type: 'array', items: ref('InvoiceOrderLine') }, billing_details: { oneOf: [ref('InvoiceBillingSnapshot'), { type: 'null' }] }, ...amounts }, description: 'Accepted order values and billing facts for context, excluding Buyer processing fees and full TIN. Not extracted invoice prices or newly computed tax. Snapshotted when a copy is sent; VAT is included, never added again.' })
const record = structuredClone(schemas.InvoiceRecordView)
Object.assign(record.properties, fileFields, { sent_at: dateTime, order_summary: ref('InvoiceOrderSummary') })
block('schema', 'InvoiceRecordView', record)
const vendor = structuredClone(schemas.VendorOrderInvoices)
Object.assign(vendor.properties, { can_send: { type: 'boolean' }, draft: { oneOf: [ref('InvoiceDraft'), { type: 'null' }] }, preset: ref('VendorInvoicePreset'), order_summary: ref('InvoiceOrderSummary') })
block('schema', 'VendorOrderInvoices', vendor)
const buyer = structuredClone(schemas.BuyerOrderInvoices)
buyer.properties.can_request_copy.description = 'False once a Vendor sales invoice copy has been sent, including legacy uploaded copies. Corrections remain a separate action.'
buyer.properties.order_summary = ref('InvoiceOrderSummary')
block('schema', 'BuyerOrderInvoices', buyer)

const orderPath = '/vendor/orders/{orderId}/invoices'
const order = structuredClone(spec.paths[orderPath])
order.post.description = 'invoices.upload. Save or replace the private invoice draft with optimistic concurrency and Idempotency-Key. Uploading never sends to the Buyer. After Send, preparation is locked until the Buyer requests a correction or returns the latest copy. No accepted Buyer total changes.'
block('path', orderPath, order)
const key = { name: 'Idempotency-Key', in: 'header', required: true, schema: uuid }
const orderParam = { name: 'orderId', in: 'path', required: true, schema: uuid }
const security = [{ accessCookie: [], webCsrf: [] }]
const responses = schema => ({ '200': { description: 'Authorized result.', content: { 'application/json': { schema: ref(schema) } } }, '401': ref('Unauthorized'), '403': ref('Forbidden') })
// Reuse canonical error response definitions rather than inventing response names.
const errors = Object.fromEntries(['401', '403', '409', '422'].map(code => [code, structuredClone(order.post.responses[code] ?? { $ref: '#/components/responses/ErrorResponse' })]))
block('path', `${orderPath}/send`, { post: { operationId: 'sendVendorInvoice', tags: ['Vendor Invoices'], description: 'invoices.upload. Sends the saved, clean draft exactly once, creates an immutable invoice version, fulfills the applicable Buyer request and notifies the Buyer after commit. Requires the current lock_version. No file means no send. A sent version cannot be edited or resent with a new key until the Buyer returns it or requests a correction.', security, parameters: [orderParam, key], requestBody: { required: true, content: { 'application/json': { schema: ref('InvoiceSendInput') } } }, responses: { '200': responses('VendorOrderInvoicesEnvelope')['200'], ...errors } } })
block('path', '/vendor/invoices/preset', { get: { operationId: 'getVendorInvoicePreset', tags: ['Vendor Invoices'], description: 'invoices.view. Returns the store invoice defaults and current lock_version. Invoice dates default to today in Asia/Manila.', security, responses: { '200': responses('VendorInvoicePresetEnvelope')['200'], ...errors } }, put: { operationId: 'saveVendorInvoicePreset', tags: ['Vendor Invoices'], description: 'invoices.upload. Saves the store invoice defaults with current lock_version and Idempotency-Key. Presets apply to future preparations only; sent records never change. Invoice dates default to today in Asia/Manila, while invoice numbers and amounts stay document-specific.', security, parameters: [key], requestBody: { required: true, content: { 'application/json': { schema: ref('InvoicePresetInput') } } }, responses: { '200': responses('VendorInvoicePresetEnvelope')['200'], ...errors } } })
block('path', '/vendor/invoice-drafts/{draftId}/files/{fileId}', { get: { operationId: 'downloadVendorInvoiceDraft', tags: ['Vendor Invoices'], description: 'invoices.upload. Authorized, short-lived private draft preview. Reauthorizes the current Vendor role, store, order and current file. A replaced file link fails closed. Never available to Buyers.', security, parameters: [{ name: 'draftId', in: 'path', required: true, schema: uuid }, { name: 'fileId', in: 'path', required: true, schema: uuid }, { name: 'expires', in: 'query', required: true, schema: { type: 'integer' } }, { name: 'signature', in: 'query', required: true, schema: { type: 'string' } }], responses: { '200': { description: 'Private invoice copy.', content: { 'application/octet-stream': { schema: { type: 'string', format: 'binary' } } } }, ...errors } } })

writeFileSync(path, source)
