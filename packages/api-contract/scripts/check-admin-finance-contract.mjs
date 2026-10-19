import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { parse } from 'yaml'
import { createRequire } from 'node:module'

const { Configuration, AdminFinanceApi, VendorFinanceApi, FinanceKpisFromJSON } = createRequire(import.meta.url)('../generated/typescript/dist/index.js')

const spec = parse(readFileSync(new URL('../openapi.yaml', import.meta.url), 'utf8'))
const schemas = spec.components.schemas
assert.equal(schemas.FinanceKpis.properties.trend.maxItems, 120)
assert.deepEqual(schemas.FinanceKpis.properties.trend_granularity.enum, ['DAY', 'MONTH'], 'Platform earnings trend is daily for short ranges and monthly otherwise')
assert.equal(schemas.FinanceKpis.properties.trend.items.$ref, '#/components/schemas/CommissionTrendPoint')
assert.deepEqual(schemas.CommissionTrendPoint.required, ['period', 'earned_centavos', 'credits_centavos', 'collected_centavos', 'refunded_centavos', 'net_earnings_centavos'])
assert.equal(schemas.CommissionTrendPoint.properties.net_earnings_centavos.minimum, undefined)
assert.equal(schemas.VendorEarnings.properties.earned_commission_centavos.minimum, undefined)
const wire = { label: 'Recorded transactions', scenario: 'Event dates', period: { from: null, to: null }, commerce: [], finance: [], counts: {}, trend: [{ period: '2026-10-01', earned_centavos: 0, credits_centavos: 4000, collected_centavos: 0, refunded_centavos: 4000, net_earnings_centavos: -4100 }] }
const parsed = FinanceKpisFromJSON(wire)
assert.equal(parsed.trend[0].netEarningsCentavos, -4100)
assert.equal(parsed.trend[0].creditsCentavos, 4000)
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
console.log('Admin finance contract checks passed: dated earnings, rate publishing transport, saved order rates, monitoring pagination, authorization.')
