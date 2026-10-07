import fs from 'node:fs'
import YAML from 'yaml'

const file = new URL('../openapi.yaml', import.meta.url)
const doc = YAML.parseDocument(fs.readFileSync(file, 'utf8'))
const ref = name => ({ $ref: `#/components/schemas/${name}` })
const str = { type: 'string' }
const nullable = { type: ['string', 'null'] }
const bool = { type: 'boolean' }
const integer = { type: 'integer' }
const object = { type: 'object', additionalProperties: true }
const schema = (properties, required = Object.keys(properties)) => ({ type: 'object', required, properties })
const array = name => ({ type: 'array', items: ref(name) })
const envelope = data => schema({ data, meta: object, errors: { type: 'array', items: object } })
const schemas = {
  NotificationItem: schema({ id: str, category: str, title: str, body: str, mandatory: bool, read_at: nullable, created_at: str }),
  NotificationPreference: schema({ category: str, mandatory: bool, explanation: str, in_app: bool, email: bool, push: bool }),
  NotificationPreferenceInput: schema({ category: str, in_app: bool, email: bool, push: bool }),
  NotificationDeviceInput: schema({ platform: { type: 'string', enum: ['ANDROID', 'IOS', 'WEB'] }, token: { type: 'string', minLength: 20, maxLength: 4096, writeOnly: true } }),
  NotificationDeviceResult: schema({ id: str }),
  NotificationTarget: schema({ path: str }),
  NotificationAction: schema({ read: bool, revoked: bool }, []),
  DeliveryFailure: schema({ id: str, channel: str, state: str, attempt_count: integer, failure_code: nullable, updated_at: str }),
  DocumentExportInput: schema({ type: { type: 'string', enum: ['PURCHASE_ORDER', 'PAYMENT_CONFIRMATION', 'PROJECT_SUMMARY', 'BUDGET_REPORT', 'OPERATIONAL_ORDER', 'FEE_STATEMENT', 'MATERIALS_ANALYTICS', 'TAX_PACKAGE'] }, format: { type: 'string', enum: ['PDF', 'CSV'] }, resource_id: nullable, purpose: { type: 'string', minLength: 10, maxLength: 500 }, filters: object }, ['type', 'format', 'purpose']),
  ExportAccessRecord: schema({ action: str, occurred_at: str }),
  DocumentExport: schema({ id: str, type: str, format: str, state: str, purpose: str, filters: object, source_hash: nullable, source_versions: object, checksum: nullable, created_at: str, expires_at: nullable, failure_code: nullable, access_record: array('ExportAccessRecord') }),
  TaxPackageInput: schema({ form: { type: 'string', enum: ['2307', '0619-E', '1601-EQ', 'QAP', '1604-E', 'ANNUAL_ALPHALIST'] }, period_start: str, withholding_entity: { type: 'string', enum: ['DEMO_PLATFORM_WITHHOLDER', 'DEMO_PROVIDER_WITHHOLDER'] }, vendor_organization_id: nullable }, ['form', 'period_start', 'withholding_entity']),
  TaxPackageReview: schema({ lock_version: integer, actual_due_date: str, due_date_source: str, reason: str, reconciled: bool }),
  TaxPackage: schema({ id: str, package_type: str, state: str, period_start: str, period_end: str, withholding_entity: str, nominal_due_date: nullable, actual_due_date: nullable, due_date_source: nullable, due_date_status: str, due_date_reviewer_id: { type: ['integer', 'null'] }, lock_version: integer, snapshot: object, content_hash: str, submission_state: nullable }, ['id', 'package_type', 'state', 'period_start', 'period_end', 'withholding_entity', 'nominal_due_date', 'actual_due_date', 'due_date_reviewer_id', 'lock_version']),
}
for (const [name, value] of Object.entries(schemas)) doc.setIn(['components', 'schemas', name], JSON.parse(JSON.stringify(value)))
const audience = { name: 'audience', in: 'path', required: true, schema: { type: 'string', enum: ['buyers', 'vendor', 'admin'] }, description: 'Authenticated surface. The server rejects mismatched account types.' }
const id = name => ({ name, in: 'path', required: true, schema: { type: 'string', format: 'uuid' } })
const page = { name: 'page', in: 'query', schema: { type: 'integer', minimum: 1 } }
const key = { name: 'Idempotency-Key', in: 'header', required: true, schema: { type: 'string', minLength: 8, maxLength: 128 } }
function operation(path, verb, name, response, { input, parameters = [], tag = 'Notifications', status = '200', description = '', binary = false } = {}) {
  const responses = { [status]: { description: 'Success', content: binary ? { 'application/octet-stream': { schema: { type: 'string', format: 'binary' } } } : { 'application/json': { schema: envelope(response) } } } }
  for (const code of ['401', '403', '409', '410', '422', '503']) responses[code] = { description: 'Structured error; see errors[0].code and correlation ID.', content: { 'application/json': { schema: object } } }
  doc.setIn(['paths', path, verb], JSON.parse(JSON.stringify({ operationId: name, tags: [tag], summary: name.replace(/([A-Z])/g, ' $1'), description,
    security: [{ passportBearer: [] }], parameters: [...(path.includes('{audience}') ? [audience] : []), ...parameters],
    ...(input ? { requestBody: { required: true, content: { 'application/json': { schema: ref(input) } } } } : {}), responses })))
}
operation('/{audience}/notifications', 'get', 'listNotifications', array('NotificationItem'), { parameters: [{ name: 'cursor', in: 'query', schema: { type: 'string', format: 'uuid' } }], description: 'Cursor feed filtered by current membership, role, assignment and preferences. Authoritative records precede delivery.' })
operation('/{audience}/notifications/preferences', 'get', 'getNotificationPreferences', array('NotificationPreference'))
operation('/{audience}/notifications/preferences', 'put', 'updateNotificationPreference', array('NotificationPreference'), { input: 'NotificationPreferenceInput', description: 'Mandatory classes cannot be disabled. Unknown categories are rejected.' })
operation('/{audience}/notifications/devices', 'post', 'registerNotificationDevice', ref('NotificationDeviceResult'), { input: 'NotificationDeviceInput', status: '201', description: 'Encrypted session-bound token registration. Web requires deployment approval. Token never returned.' })
operation('/{audience}/notifications/devices/{deviceId}', 'delete', 'revokeNotificationDevice', ref('NotificationAction'), { parameters: [id('deviceId')] })
operation('/{audience}/notifications/{noticeId}/read', 'post', 'readNotification', ref('NotificationAction'), { parameters: [id('noticeId')] })
operation('/{audience}/notifications/{noticeId}/resolve', 'post', 'resolveNotification', ref('NotificationTarget'), { parameters: [id('noticeId')], description: 'Fresh authenticated session and resource authorization required. Returns only an allowlisted same-application path; denied links return NOTICE_ACCESS_REVOKED.' })
operation('/admin/notifications/failures', 'get', 'listNotificationFailures', array('DeliveryFailure'), { parameters: [page] })
operation('/{audience}/reports', 'get', 'listDocumentExports', array('DocumentExport'), { tag: 'Reporting', parameters: [page] })
operation('/{audience}/reports', 'post', 'requestDocumentExport', ref('DocumentExport'), { tag: 'Reporting', input: 'DocumentExportInput', parameters: [key], status: '202', description: 'Private immutable snapshot. Current access checked at request, generation and download. Admin requires recent authentication. Files expire 24 hours after generation. MAT audience suppression applies.' })
operation('/{audience}/reports/{exportId}/download', 'get', 'downloadDocumentExport', object, { tag: 'Reporting', parameters: [id('exportId')], binary: true })
operation('/admin/reports/tax', 'get', 'listTaxPackages', array('TaxPackage'), { tag: 'Reporting', parameters: [page] })
operation('/admin/reports/tax', 'post', 'prepareTaxPackage', ref('TaxPackage'), { tag: 'Reporting', input: 'TaxPackageInput', parameters: [key], status: '201' })
operation('/admin/reports/tax/{packageId}', 'get', 'getTaxPackage', ref('TaxPackage'), { tag: 'Reporting', parameters: [id('packageId')] })
operation('/admin/reports/tax/{packageId}/review', 'post', 'reviewTaxPackage', ref('TaxPackage'), { tag: 'Reporting', parameters: [id('packageId')], input: 'TaxPackageReview', description: 'Independent finance reviewer, source reconciliation and cited actual deadline required. Nominal deadline retained. No live tax filing.' })
operation('/admin/reports/tax/{packageId}/simulation', 'post', 'recordTaxSimulation', object, { tag: 'Reporting', parameters: [id('packageId')], description: 'Only SIMULATED_SUBMISSION_RECORDED after export; never FILED or BIR_PAID, no government receipt.' })
fs.writeFileSync(file, doc.toString({ lineWidth: 160 }))

