import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { parse } from 'yaml'
import { createRequire } from 'node:module'

const { Configuration, AdminFinanceApi, FinanceKpisFromJSON } = createRequire(import.meta.url)('../generated/typescript/dist/index.js')

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
console.log('Admin finance contract checks passed: signed monthly data, generated serialization, overdue boolean, authorization.')
