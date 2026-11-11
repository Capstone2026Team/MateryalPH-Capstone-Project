import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { createRequire } from 'node:module'
import { parse } from 'yaml'

const spec = parse(readFileSync(new URL('../openapi.yaml', import.meta.url), 'utf8'))
const schemas = spec.components.schemas
const operation = spec.paths['/vendor/finance/commissions'].get
assert.ok(operation.parameters.some(parameter => parameter.name === 'history_page' && parameter.schema.minimum === 1))
for (const field of ['annual_payments', 'monthly_payments', 'payment_history']) {
  assert.ok(schemas.VendorCommissionMonitoring.required.includes(field))
}
assert.equal(schemas.CommissionPaymentPeriod.properties.net_collected_centavos.minimum, undefined, 'Refund-only periods may be negative')
const require = createRequire(import.meta.url)
const { CommissionPaymentPeriodFromJSON, CommissionPaymentPeriodToJSON, CommissionPaymentHistoryFromJSON, CommissionPaymentHistoryToJSON } = require('../generated/typescript/dist/index.js')
const period = { label: '2026', starts_on: '2026-01-01', ends_on: '2026-12-31', resets_at: '2026-12-31T16:00:00.000Z', collected_centavos: 10000, refunded_centavos: 20000, net_collected_centavos: -10000 }
assert.deepEqual(CommissionPaymentPeriodToJSON(CommissionPaymentPeriodFromJSON(period)), period)
const history = { items: [period], page: 2, per_page: 10, total: 11, has_more: false }
assert.deepEqual(CommissionPaymentHistoryToJSON(CommissionPaymentHistoryFromJSON(history)), history)
console.log('Commission periods contract passed: required periods, independent history pagination, dates and negative-net serialization')
