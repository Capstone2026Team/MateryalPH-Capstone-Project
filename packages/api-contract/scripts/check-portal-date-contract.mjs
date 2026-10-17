import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { parse } from 'yaml'

const spec = parse(readFileSync(new URL('../openapi.yaml', import.meta.url), 'utf8'))
const operations = new Map(Object.values(spec.paths).flatMap(path =>
  Object.entries(path).filter(([, value]) => value.operationId).map(([method, operation]) => [operation.operationId, { method, operation }]),
))
const datedReads = [
  'listVendorTeamActivity', 'listVendorOrders', 'getVendorDashboardInsights', 'getAdminDashboardInsights',
  'listEnforcementActions', 'listPrivacyRequests', 'listOperationFailures', 'listBudgetOverrides',
  'listRemittanceQueue', 'listTaxEvidenceQueue', 'listTaxAdjustments', 'listVendorReviews', 'listAdminReviewModeration',
  'listVendorDisputes', 'listAdminDisputes', 'listVendorInvoices', 'listAdminInvoiceLog', 'listAdminRefunds',
  'listVendorTransactions', 'exportVendorTransactions', 'getVendorEarnings', 'listAdminPayments',
  'listFinanceReviewItems', 'listFeeStatements', 'listProductComplianceQueue', 'listNotifications',
  'listNotificationFailures', 'listAdminReimbursements', 'listAdminCancellationRequests', 'listTaxPackages',
  'listDocumentExports', 'listVendorInventoryMovements', 'listVendorPriceHistory',
]
for (const name of datedReads) {
  const entry = operations.get(name)
  assert.ok(entry, `${name} must exist`)
  assert.equal(entry.method, 'get', `${name} is read-only`)
  for (const boundary of ['from', 'to']) {
    const parameter = entry.operation.parameters?.find(parameter => parameter.name === boundary)
    assert.ok(parameter, `${name} documents ${boundary}`)
    assert.equal(parameter.in, 'query')
    assert.equal(parameter.schema.format, 'date')
    assert.notEqual(parameter.required, true, `${name} permits open boundaries`)
    assert.match(parameter.description, /Asia\/Manila/)
  }
}
for (const name of ['confirmAdminReimbursement', 'receiveXenditPaymentWebhook']) {
  const entry = operations.get(name)
  assert.ok(entry, `${name} must exist`)
  assert.ok(!entry.operation.parameters?.some(parameter => ['from', 'to'].includes(parameter.name)), `${name} must not acquire unrelated date filters`)
}
const readFilter = spec.components.schemas.NotificationReadFilter
assert.equal(readFilter.additionalProperties, false)
for (const boundary of ['from', 'to']) assert.equal(readFilter.properties[boundary].format, 'date')
const kpiPeriod = spec.components.schemas.FinanceKpis.properties.period.properties
for (const boundary of ['from', 'to']) assert.deepEqual(kpiPeriod[boundary].type, ['string', 'null'])
assert.equal(spec.components.schemas.VendorDashboardInsights.properties.period.properties.days.minimum, 1)
assert.equal(spec.components.schemas.AdminDashboardMarketplace.properties.period.properties.days.maximum, 366)
console.log(`Portal date contract checks passed (${datedReads.length} dated read operations and filtered notification bulk read).`)
