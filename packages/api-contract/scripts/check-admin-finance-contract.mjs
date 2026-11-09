import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { parse } from 'yaml'
import { createRequire } from 'node:module'

const { Configuration, AdminFinanceApi, VendorFinanceApi, FinanceKpisFromJSON } = createRequire(import.meta.url)('../generated/typescript/dist/index.js')

const spec = parse(readFileSync(new URL('../openapi.yaml', import.meta.url), 'utf8'))
const schemas = spec.components.schemas
assert.equal(spec.paths['/admin/finance/commission-transactions'].get.operationId, 'listCommissionTransactions')
assert.equal(spec.paths['/admin/finance/commission-transactions'].get.parameters.some(item => item.name === 'purpose'), false, 'Commission captures have a fixed server-side purpose')
assert.equal(spec.paths['/admin/finance/statements/{statementId}/invoice'].put.parameters.find(item => item.name === 'Idempotency-Key').required, true)
assert.deepEqual(schemas.StatementInvoiceUpdateRequest.required, ['lock_version', 'invoice_heading', 'invoice_message'])
assert.equal(schemas.StatementInvoiceUpdateRequest.properties.invoice_heading.maxLength, 100)
assert.equal(schemas.StatementInvoiceUpdateRequest.properties.invoice_message.maxLength, 1000)
let invoiceRequest
const invoiceApi = new AdminFinanceApi(new Configuration({ basePath: 'https://example.invalid/api/v1', fetchApi: async (url, init) => {
  invoiceRequest = { url: String(url), body: JSON.parse(init.body), key: init.headers['Idempotency-Key'] }
  return new Response(JSON.stringify({ data: { id: 'draft', state: 'DRAFT', invoice_heading: 'October fees', invoice_message: 'Thank you', lock_version: 2 }, meta: {}, errors: [] }), { status: 200, headers: { 'Content-Type': 'application/json' } })
} }))
await invoiceApi.updateFeeStatementInvoice({ statementId: 'draft', idempotencyKey: 'request-key', statementInvoiceUpdateRequest: { lockVersion: 1, invoiceHeading: 'October fees', invoiceMessage: 'Thank you' } })
assert.deepEqual(invoiceRequest.body, { lock_version: 1, invoice_heading: 'October fees', invoice_message: 'Thank you' })
assert.equal(invoiceRequest.key, 'request-key')
assert.deepEqual(spec.paths['/admin/finance/withholding-register'].get.security, [{ accessCookie: [], webCsrf: [] }])
assert.equal(spec.paths['/admin/finance/withholding-register'].get.parameters.find(item => item.name === 'month').required, false)
assert.equal(schemas.WithholdingRegister.properties.vendors.maxItems, 25)
assert.deepEqual(schemas.WithholdingRegister.properties.assignment_status.enum, ['UNCONFIRMED'])
assert.deepEqual(schemas.WithholdingRegister.properties.environment.enum, ['TEST'])
assert.equal(schemas.WithholdingRegister.properties.bir_paid_centavos, undefined, 'Assessments are not proof of BIR payment')
assert.equal(schemas.FinanceKpis.properties.trend.maxItems, 120)
assert.deepEqual(schemas.FinanceKpis.properties.trend_granularity.enum, ['DAY', 'MONTH'], 'Platform earnings trend is daily for short ranges and monthly otherwise')
assert.equal(schemas.FinanceKpis.properties.trend.items.$ref, '#/components/schemas/CommissionTrendPoint')
assert.deepEqual(schemas.CommissionTrendPoint.required, ['period', 'earned_centavos', 'credits_centavos', 'collected_centavos', 'refunded_centavos', 'net_earnings_centavos', 'gmv_centavos', 'buyer_payments_centavos', 'buyer_refunds_centavos'])
assert.equal(schemas.CommissionTrendPoint.properties.net_earnings_centavos.minimum, undefined)
assert.equal(schemas.VendorEarnings.properties.earned_commission_centavos.minimum, undefined)
assert.equal(schemas.FinanceKpis.properties.payment_methods.items.$ref, '#/components/schemas/FinancePaymentMethod')
assert.equal(schemas.FinanceKpis.required.includes('payment_methods'), false, 'Older Platform Finance responses without the method breakdown still parse')
assert.deepEqual(schemas.FinancePaymentMethod.properties.kind.enum, ['ONLINE', 'PHYSICAL'])
const wire = { label: 'Recorded transactions', scenario: 'Event dates', period: { from: null, to: null }, commerce: [], finance: [], counts: {},
  payment_methods: [{ method: 'GCASH', label: 'GCash', kind: 'ONLINE', payments: 2, amount_centavos: 205000 }, { method: 'CASH_ON_DELIVERY', label: 'Cash on Delivery', kind: 'PHYSICAL', payments: 1, amount_centavos: 90000 }],
  trend: [{ period: '2026-10-01', earned_centavos: 0, credits_centavos: 4000, collected_centavos: 0, refunded_centavos: 4000, net_earnings_centavos: -4100, gmv_centavos: 300000, buyer_payments_centavos: 295000, buyer_refunds_centavos: 1000 }] }
const parsed = FinanceKpisFromJSON(wire)
assert.equal(parsed.trend[0].netEarningsCentavos, -4100)
assert.equal(parsed.trend[0].creditsCentavos, 4000)
assert.deepEqual([parsed.trend[0].gmvCentavos, parsed.trend[0].buyerPaymentsCentavos, parsed.trend[0].buyerRefundsCentavos], [300000, 295000, 1000])
assert.deepEqual(parsed.paymentMethods.map(method => [method.method, method.kind, method.amountCentavos]), [['GCASH', 'ONLINE', 205000], ['CASH_ON_DELIVERY', 'PHYSICAL', 90000]])
let requested
const api = new AdminFinanceApi(new Configuration({ basePath: 'https://example.invalid/api/v1', fetchApi: async (url) => {
  requested = String(url)
  return new Response(JSON.stringify({ data: [], meta: {}, errors: [] }), { status: 200, headers: { 'Content-Type': 'application/json' } })
} }))
await api.listFeeStatements({ overdue: true, page: 1 })
assert.equal(new URL(requested).searchParams.get('overdue'), 'true', 'The backend must accept the generated boolean query value.')
assert.deepEqual(spec.paths['/admin/finance/kpis'].get.security, [{ accessCookie: [], webCsrf: [] }])
assert.equal(schemas.FeeAssessment.properties.commission_basis_points.const, undefined)
assert.equal(schemas.CommissionPolicyPublishRequest.properties.commission_basis_points.maximum, 10000)
assert.deepEqual(spec.paths['/admin/finance/commission-policies'].post.security, [{ accessCookie: [], webCsrf: [] }])
assert.equal(spec.paths['/admin/finance/commission-policies'].post.parameters[0].name, 'Idempotency-Key')
const policy = { id: '019c0000-0000-7000-8000-000000000001', version: 2, commission_basis_points: 325, rate_label: '3.25%', effective_from: '2026-11-01T00:00:00Z', agreement_version_id: null, reason: 'Commercial rate review', status: 'SCHEDULED' }
let published
const policyApi = new AdminFinanceApi(new Configuration({ basePath: 'https://example.invalid/api/v1', fetchApi: async (url, init) => {
  published = { url: String(url), body: JSON.parse(init.body), key: init.headers['Idempotency-Key'] }
  return new Response(JSON.stringify({ data: policy, meta: {}, errors: [] }), { status: 200, headers: { 'Content-Type': 'application/json' } })
} }))
const result = await policyApi.publishCommissionPolicy({ commissionPolicyPublishRequest: { commissionBasisPoints: 325, expectedVersion: 1, effectiveFrom: new Date('2026-11-01T00:00:00Z'), reason: 'Commercial rate review' }, idempotencyKey: policy.id })
assert.deepEqual(published.body, { commission_basis_points: 325, expected_version: 1, effective_from: '2026-11-01T00:00:00.000Z', reason: 'Commercial rate review' })
assert.equal(published.key, policy.id)
assert.equal(result.data.commissionBasisPoints, 325)
assert.equal(result.data.effectiveFrom.toISOString(), '2026-11-01T00:00:00.000Z')
const summary = Object.fromEntries(schemas.VendorCommissionSummary.required.map(key => [key, 0]))
const vendorApi = new VendorFinanceApi(new Configuration({ basePath: 'https://example.invalid/api/v1', fetchApi: async (url) => {
  assert.equal(new URL(url).searchParams.get('page'), '2')
  return new Response(JSON.stringify({ data: { current_policy: policy, next_policy: null, terms_accepted: false, summary, assessments: [{ id: policy.id, order_reference: 'OLD-ORDER', state: 'EARNED', commission_basis_centavos: 1000000, commission_basis_points: 200, estimated_centavos: 0, earned_centavos: 20000, credited_centavos: 4000, net_centavos: 16000, dispute_hold: false, earned_at: null }] }, meta: { has_more: false }, errors: [] }), { status: 200, headers: { 'Content-Type': 'application/json' } })
} }))
const monitoring = await vendorApi.getVendorCommissionMonitoring({ page: 2 })
assert.equal(monitoring.data.currentPolicy.commissionBasisPoints, 325)
assert.equal(monitoring.data.assessments[0].commissionBasisPoints, 200)
assert.equal(monitoring.data.assessments[0].netCentavos, 16000)
assert.equal(monitoring.data.termsAccepted, false)
console.log('Admin finance contract checks passed: dated earnings, marketplace money flow and payment methods, rate publishing transport, saved order rates, monitoring pagination, authorization.')

const { AdminFinanceOperationsApi } = createRequire(import.meta.url)('../generated/typescript/dist/index.js')
const vendorTaxWire = { vendor_id: 'sample-vendor', vendor_name: 'Sample Supply', withholding_entity: 'DEMO_PLATFORM_WITHHOLDER', assessment_count: 3, withheld_centavos: 12345, review_required: 1,
  calculation: { collections_centavos: 3100000, refunds_centavos: 100000, delivery_centavos: 200000, vat_centavos: 250000, provider_charge_centavos: 81000, gross_basis_centavos: 2469000, taxable_basis_centavos: 2469000, relieved_basis_centavos: 0 }, filing_issues: ['TAX_ADJUSTMENT_OPEN'] }
const registerApi = new AdminFinanceOperationsApi(new Configuration({ basePath: 'https://example.invalid/api/v1', fetchApi: async (url) => {
  assert.equal(new URL(url).pathname, '/api/v1/admin/finance/withholding-register')
  assert.equal(new URL(url).searchParams.get('month'), '2026-10')
  assert.equal(new URL(url).searchParams.get('page'), '2')
  return new Response(JSON.stringify({ data: { month: '2026-10', period_start: '2026-10-01', period_end: '2026-10-31', environment: 'TEST', assignment_status: 'UNCONFIRMED', platform_withheld_centavos: 12345, provider_withheld_centavos: 6789, vendor_count: 2, assessment_count: 4, review_required: 1, vendors: [vendorTaxWire] }, meta: { has_more: false, total: 2, page: 2 }, errors: [] }), { status: 200, headers: { 'Content-Type': 'application/json' } })
} }))
const register = await registerApi.getWithholdingRegister({ month: '2026-10', page: 2 })
assert.equal(register.data.platformWithheldCentavos, 12345)
assert.equal(register.data.providerWithheldCentavos, 6789)
assert.equal(register.data.assignmentStatus, 'UNCONFIRMED')
assert.equal(register.meta.total, 2)
assert.equal(register.data.vendors[0].calculation.collectionsCentavos, 3100000)
assert.equal(register.data.vendors[0].calculation.grossBasisCentavos, 2469000)
assert.deepEqual([...register.data.vendors[0].filingIssues], ['TAX_ADJUSTMENT_OPEN'])
console.log('Withholding register contract passed: month/page transport, exact integer totals and separate responsibility.')

const latestRegisterApi = new AdminFinanceOperationsApi(new Configuration({ basePath: 'https://example.invalid/api/v1', fetchApi: async url => {
  assert.equal(new URL(url).searchParams.has('month'), false)
  return new Response(JSON.stringify({ data: { month: '2026-10', period_start: '2026-10-01', period_end: '2026-10-31', environment: 'TEST', assignment_status: 'UNCONFIRMED', platform_withheld_centavos: 508, provider_withheld_centavos: 0, vendor_count: 1, assessment_count: 4, review_required: 0, vendors: [] }, meta: { has_more: false, total: 1, page: 1 }, errors: [] }), { status: 200, headers: { 'Content-Type': 'application/json' } })
} }))
const latestRegister = await latestRegisterApi.getWithholdingRegister({ page: 1 })
assert.equal(latestRegister.data.month, '2026-10')
assert.equal(latestRegister.data.platformWithheldCentavos, 508)
console.log('Withholding register default-month transport passed.')

const approvalPath = spec.paths['/admin/finance/remittances/{assessmentId}/approve-reconciliation'].post
assert.equal(approvalPath.operationId, 'approveRemittanceReconciliation')
assert.deepEqual(approvalPath.security, [{ accessCookie: [], webCsrf: [] }])
assert.equal(approvalPath.parameters.find(item => item.name === 'Idempotency-Key').required, true)
assert.deepEqual(schemas.RemittanceReconciliationApproval.required, ['source_version', 'reason'])
let approvalRequest
const approvalApi = new AdminFinanceOperationsApi(new Configuration({ basePath: 'https://example.invalid/api/v1', fetchApi: async (url, init) => {
  approvalRequest = { url: String(url), body: JSON.parse(init.body), key: init.headers['Idempotency-Key'] }
  return new Response(JSON.stringify({ data: { id: 'decision-1', assessment_id: 'assessment-1', environment: 'TEST', origin: 'SIMULATED', method: 'BACKUP_APPROVAL', actor_role: 'ADMIN_FINANCE', reason: 'Checked the recorded sources.', reconciled_at: '2026-11-08T00:00:00Z' }, meta: {}, errors: [] }), { status: 200, headers: { 'Content-Type': 'application/json' } })
} }))
const approved = await approvalApi.approveRemittanceReconciliation({ assessmentId: 'assessment-1', idempotencyKey: 'stable-request-key', remittanceReconciliationApproval: { sourceVersion: 'a'.repeat(64), reason: 'Checked the recorded sources.' } })
assert.equal(approvalRequest.url, 'https://example.invalid/api/v1/admin/finance/remittances/assessment-1/approve-reconciliation')
assert.deepEqual(approvalRequest.body, { source_version: 'a'.repeat(64), reason: 'Checked the recorded sources.' })
assert.equal(approvalRequest.key, 'stable-request-key')
assert.equal(approved.data.origin, 'SIMULATED')
assert.equal(approved.data.actorRole, 'ADMIN_FINANCE')
assert.equal(approved.data.method, 'BACKUP_APPROVAL')
assert.ok(approved.data.reconciledAt instanceof Date)
console.log('Remittance backup approval contract passed: version, reason, idempotency and recorded TEST decision.')

const paymentStatuses = spec.paths['/admin/finance/commission-transactions'].get.parameters.find(item => item.name === 'status').schema.enum
assert.deepEqual(paymentStatuses, ['PAID', 'PAID_PARTIALLY_REFUNDED', 'PAID_REFUND_PENDING', 'PAID_REFUNDED', 'PAID_REFUND_FAILED'])
const commissionApi = new AdminFinanceApi(new Configuration({ basePath: 'https://example.invalid/api/v1', fetchApi: async url => {
  const query = new URL(url).searchParams
  assert.equal(query.get('page'), '2')
  assert.equal(query.get('status'), 'PAID_PARTIALLY_REFUNDED')
  assert.equal(query.get('from'), '2026-11-01')
  assert.equal(query.get('to'), '2026-11-07')
  return new Response(JSON.stringify({ data: [], meta: { page: 2, total: 25, has_more: false }, errors: [] }), { status: 200, headers: { 'Content-Type': 'application/json' } })
} }))
await commissionApi.listCommissionTransactions({ page: 2, status: 'PAID_PARTIALLY_REFUNDED', from: new Date('2026-11-01T00:00:00Z'), to: new Date('2026-11-07T00:00:00Z') })
console.log('Commission payment status, dates and pagination transport passed.')
const drawerPath = spec.paths['/admin/finance/withholding-register/{vendorId}'].get
assert.equal(drawerPath.operationId, 'getWithholdingVendor')
assert.deepEqual(drawerPath.security, [{ accessCookie: [], webCsrf: [] }])
assert.equal(schemas.WithholdingVendorDetail.properties.payments.maxItems, 25)
const drawerApi = new AdminFinanceOperationsApi(new Configuration({ basePath: 'https://example.invalid/api/v1', fetchApi: async url => {
  const request = new URL(url)
  assert.equal(request.pathname, '/api/v1/admin/finance/withholding-register/sample-vendor')
  assert.equal(request.searchParams.get('month'), '2026-10')
  assert.equal(request.searchParams.get('withholding_entity'), 'DEMO_PLATFORM_WITHHOLDER')
  assert.equal(request.searchParams.get('page'), '2')
  return new Response(JSON.stringify({ data: { vendor_id: 'sample-vendor', vendor_name: 'Sample Supply', month: '2026-10', withholding_entity: 'DEMO_PLATFORM_WITHHOLDER', declaration_state: 'PENDING', threshold: null, payments: [{ id: 'assessment', order_reference: 'MP-100', collected_at: '2026-10-21T10:00:00Z', amount_centavos: 999, taxable_centavos: null, tax_centavos: null }] }, meta: { page: 2, total: 26, has_more: false }, errors: [] }), { status: 200, headers: { 'Content-Type': 'application/json' } })
} }))
const drawer = await drawerApi.getWithholdingVendor({ vendorId: 'sample-vendor', month: '2026-10', withholdingEntity: 'DEMO_PLATFORM_WITHHOLDER', page: 2 })
assert.equal(drawer.data.threshold, null)
assert.equal(drawer.data.payments[0].taxCentavos, null)
assert.equal(drawer.data.payments[0].amountCentavos, 999)
assert.equal(drawer.meta.total, 26)
assert.equal(spec.paths['/admin/finance/tax-issues'].get.operationId, 'listTaxIssues')
const issuesApi = new AdminFinanceOperationsApi(new Configuration({ basePath: 'https://example.invalid/api/v1', fetchApi: async url => {
  assert.equal(new URL(url).pathname, '/api/v1/admin/finance/tax-issues')
  assert.equal(new URL(url).searchParams.get('page'), '2')
  return new Response(JSON.stringify({ data: [], meta: { has_more: false, total: 25 }, errors: [] }), { status: 200, headers: { 'Content-Type': 'application/json' } })
} }))
assert.equal((await issuesApi.listTaxIssues({ page: 2 })).meta.total, 25)
console.log('Tax drawer and action-queue contract passed: scoped transport, nullable unposted values and exact pagination.')
