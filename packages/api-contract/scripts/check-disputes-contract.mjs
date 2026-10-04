import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { spawnSync } from 'node:child_process'
import { fileURLToPath } from 'node:url'
import { parse } from 'yaml'

// Phase 13 contract test: every documented dispute and invoice operation exists with the right transport and
// authorization middleware, every Phase 13 route is documented, retry-sensitive mutations require an Idempotency-Key,
// signed content links require the signature middleware, no request schema can carry a refund destination, and the
// binding enums (case states, timers' deadline kinds, outcomes, sanctions, refund trigger, invoice labels) cannot drift.
const spec = parse(readFileSync(new URL('../openapi.yaml', import.meta.url), 'utf8'))
const routeFile = process.argv[2]
let routes
if (routeFile) {
  routes = JSON.parse(readFileSync(routeFile, 'utf8'))
} else {
  const result = spawnSync('php', ['artisan', 'route:list', '--json', '-v'], { cwd: fileURLToPath(new URL('../../../services/api/', import.meta.url)), encoding: 'utf8', timeout: 60000 })
  assert.equal(result.status, 0, 'Laravel route export must succeed')
  routes = JSON.parse(result.stdout)
}
const TAGS = { 'Buyer Disputes': 'BUYER', 'Vendor Disputes': 'VENDOR', 'Admin Disputes': 'ADMIN', 'Buyer Invoices': 'BUYER', 'Vendor Invoices': 'VENDOR', 'Admin Invoices': 'ADMIN' }
const NO_KEY = [/\/realtime\/auth$/, /^\/vendor\/disputes\/exports$/]
const expected = new Set()
for (const [path, methods] of Object.entries(spec.paths)) {
  for (const [method, operation] of Object.entries(methods)) {
    const tag = operation.tags?.find(value => value in TAGS)
    if (!tag) continue
    const uri = `api/v1${path.replace(/\{[^}]+\}/g, '{}')}`
    const key = `${method.toUpperCase()} ${uri}`
    expected.add(key)
    const actual = routes.find(route => route.uri.replace(/\{[^}]+\}/g, '{}') === uri && route.method.split('|').includes(method.toUpperCase()))
    assert.ok(actual, `Missing Laravel route ${key}`)
    const audience = TAGS[tag]
    const has = (...names) => names.some(name => actual.middleware.includes(name))
    assert.ok(has('auth:api', 'Illuminate\\Auth\\Middleware\\Authenticate:api') && has(`account.access:${audience}`, `App\\Http\\Middleware\\RequireAccountAccess:${audience}`), `${key} must authorize the ${audience}`)
    if (audience !== 'BUYER' && method !== 'get') assert.ok(has('App\\Http\\Middleware\\VerifyAccountCsrf'), `${key} must verify CSRF`)
    if (audience === 'BUYER') assert.deepEqual(operation.security, [{ passportBearer: [] }], `${key} uses the native Buyer bearer`)
    else assert.deepEqual(operation.security, [{ accessCookie: [], webCsrf: [] }], `${key} uses cookies with CSRF`)
    assert.ok(operation.responses['401'] && operation.responses['403'], `${key} documents authentication and authorization errors`)
    if (method === 'post' && !NO_KEY.some(pattern => pattern.test(path))) {
      assert.ok(operation.parameters?.some(p => p.name === 'Idempotency-Key' && p.required), `${key} requires an Idempotency-Key`)
    }
    if (/\/content$/.test(path)) {
      assert.ok(has('signed', 'Illuminate\\Routing\\Middleware\\ValidateSignature'), `${key} is a short-lived signed link`)
      assert.ok(operation.parameters?.some(p => p.name === 'signature' && p.required) && operation.parameters?.some(p => p.name === 'expires' && p.required), `${key} documents the signature`)
    }
  }
}
const phaseThirteen = /^api\/v1\/((buyers|vendor|admin)\/disputes|(buyers|vendor)\/orders\/\{[^}]+\}\/(dispute-eligibility|invoices)|vendor\/invoices|admin\/invoices|(buyers|vendor|admin)\/invoice-records)/
for (const route of routes.filter(route => phaseThirteen.test(route.uri))) {
  for (const method of route.method.split('|').filter(method => method !== 'HEAD')) {
    assert.ok(expected.has(`${method} ${route.uri.replace(/\{[^}]+\}/g, '{}')}`), `Undocumented Phase 13 route ${method} ${route.uri}`)
  }
}
const s = spec.components.schemas
const CASES = ['OPEN_AWAITING_RESPONSE', 'MUTUAL_RESOLUTION', 'ESCALATED_ADMIN_REVIEW', 'AWAITING_CLARIFICATION', 'DECIDED', 'APPEAL_OPEN', 'RESOLVED', 'CLOSED_INCONCLUSIVE']
assert.deepEqual(s.DisputeSummary.properties.status.enum, CASES)
assert.deepEqual(s.DisputeDeadline.properties.kind.enum, ['RESPONSE', 'MUTUAL_RESOLUTION', 'CLARIFICATION', 'APPEAL'])
assert.deepEqual(s.DisputeDecision.properties.outcome.enum, ['DISMISSED', 'REPLACEMENT', 'FULL_REFUND', 'PARTIAL_REFUND', 'INCONCLUSIVE', 'NO_FURTHER_ACTION'])
assert.deepEqual(s.DisputeSanctionInput.properties.action.enum, ['WARNING', 'TEMPORARY_RESTRICTION', 'SUSPENSION', 'PERMANENT_BAN'])
assert.deepEqual(s.DisputeAppealForm.properties.grounds.enum, ['NEW_EVIDENCE', 'MATERIAL_PROCESS_ERROR'])
assert.deepEqual(s.AdminDisputeDecisionRequest.required.sort(), ['conflict_check_confirmed', 'enforceable', 'lock_version', 'outcome', 'reason'], 'Remedy, reason and the conflict check are required')
assert.ok(s.RefundTimelineItem.properties.trigger.enum.includes('DISPUTE_CONCLUSION') && s.RefundTimelineItem.properties.trigger.enum.includes('CANCELLATION'), 'Dispute and cancellation refunds stay separate triggers')
// No request anywhere can carry a different refund destination.
const destination = /destination|bank|account_number|card_number|wallet|gcash|payout/i
for (const name of Object.keys(s).filter(name => /(Form|Request|Input|Answer)$/.test(name))) {
  for (const field of Object.keys(s[name].properties ?? {})) assert.ok(!destination.test(field), `${name}.${field} must not collect a refund destination`)
}
assert.ok(!('refund_destination' in s.DisputeEligibility.properties) && s.DisputeEligibility.properties.original_payment_method, 'The masked original method is read-only information')
assert.deepEqual(s.PlatformDocumentRef.properties.label.enum, ['Not a tax invoice'])
assert.deepEqual(s.InvoiceUploadForm.properties.invoice_type.enum, ['VENDOR_GOODS_INVOICE', 'VENDOR_ADJUSTMENT_DOCUMENT'], 'Vendors upload only their own goods or adjustment documents')
assert.ok(s.InvoiceRecordView.properties.reconciliation_state.enum.includes('INVOICE_RECONCILIATION_REQUIRED'))
for (const name of ['InvoiceRecordView', 'VendorOrderInvoices', 'DisputeDetail', 'DisputeSummary']) {
  for (const field of Object.keys(s[name].properties)) assert.ok(!/commission|withholding|earning|payout|taxpayer|remittance|fee_statement/i.test(field), `${name}.${field} must not expose protected finance`)
}
assert.ok(s.OrderDetail.properties.available_actions.items.enum.includes('FILE_DISPUTE') && s.OrderDetail.properties.available_actions.items.enum.includes('REQUEST_INVOICE'))
assert.ok(s.OrderDetail.properties.dispute && s.OrderDetail.properties.invoice && s.VendorOrderPermissions.properties.can_upload_invoice)
assert.match(spec.info.version, /phase\.(1[3-9]|20)$/)
console.log(`Disputes contract passed: ${expected.size} operations, transports, signed links, idempotency, enums and no refund destination`)
