import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { createRequire } from 'node:module'
import { parse } from 'yaml'

const spec = parse(readFileSync(new URL('../openapi.yaml', import.meta.url), 'utf8'))
const schema = spec.components.schemas.AssessedOnlinePayment
const require = createRequire(import.meta.url)
const { AssessedOnlinePaymentFromJSON, AssessedOnlinePaymentToJSON } = require('../generated/typescript/dist/models/AssessedOnlinePayment.js')
for (const wire of ['assessed_payment_centavos', 'delivery_centavos', 'material_vat_centavos']) {
  assert.ok(schema.required.includes(wire), `Annual payment breakdown requires ${wire}`)
  assert.equal(schema.properties[wire].type, 'integer')
  assert.equal(schema.properties[wire].minimum, 0)
}
const payment = {
  id: '019a0f2a-9500-7000-8000-000000000001', order_reference: 'ORD-SAMPLE', assessed_at: '2026-10-02T10:00:00.000Z',
  payment_principal_centavos: 10000, buyer_processing_fees_centavos: 0, collections_centavos: 10000,
  assessed_payment_centavos: 42825, delivery_centavos: 14275, material_vat_centavos: 3059,
  gross_basis_centavos: 25491, rate_basis_points: 50, withheld_centavos: 127,
}
for (const recorded of [payment, { ...payment, assessed_payment_centavos: 28550, delivery_centavos: 0, rate_basis_points: 0, withheld_centavos: 0 }]) {
  assert.deepEqual(AssessedOnlinePaymentToJSON(AssessedOnlinePaymentFromJSON(recorded)), recorded,
    'The generated client must preserve recorded assessment components, zero relief and the separate retained principal')
}
console.log('Vendor annual payment breakdown contract passed: required centavo fields and generated-client round trips')
