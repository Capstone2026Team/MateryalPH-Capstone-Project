import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { parse } from 'yaml'
import { createRequire } from 'node:module'

// Earnings trend contract test: the Owner-only Earnings response documents its chart series; the figure keys of every
// trend schema equal VendorFinanceService::TREND_FIGURES, so implementation and contract cannot drift; points carry no
// identity, tax or provider data; and the comparison is nullable rather than faked when the period is empty.
const spec = parse(readFileSync(new URL('../openapi.yaml', import.meta.url), 'utf8'))
const service = readFileSync(new URL('../../../services/api/app/Domain/Finance/VendorFinanceService.php', import.meta.url), 'utf8')
const constant = service.match(/TREND_FIGURES = \[([^\]]+)\]/)
assert.ok(constant, 'VendorFinanceService::TREND_FIGURES exists')
const figures = [...constant[1].matchAll(/'([a-z_]+)'/g)].map(match => match[1])
assert.ok(figures.length >= 8 && figures.every(name => name.endsWith('_centavos')), 'Every trend figure is integer centavos')

const schemas = spec.components.schemas
const { WithholdingThresholdPanelFromJSON } = createRequire(import.meta.url)('../generated/typescript/dist/index.js')
const calculation = {
  collections_centavos: 131872, refunds_centavos: 0, delivery_centavos: 42825, material_vat_centavos: 9177,
  provider_charges_centavos: 3397, gross_basis_centavos: 76473, withheld_centavos: 381, assessed_cash_centavos: 128094,
}
assert.ok(schemas.WithholdingThresholdPanel.required.includes('calculation_breakdown'))
assert.deepEqual(schemas.WithholdingThresholdPanel.properties.calculation_breakdown.oneOf, [
  { $ref: '#/components/schemas/WithholdingThresholdCalculation' }, { type: 'null' },
])
assert.deepEqual([...schemas.WithholdingThresholdCalculation.required].sort(), Object.keys(calculation).sort())
for (const field of Object.keys(calculation)) assert.equal(schemas.WithholdingThresholdCalculation.properties[field].type, 'integer')
const parsedCalculation = WithholdingThresholdPanelFromJSON({ calculation_breakdown: calculation, events: [] }).calculationBreakdown
assert.equal(parsedCalculation.grossBasisCentavos, 76473)
assert.equal(parsedCalculation.assessedCashCentavos, 128094)
assert.equal(parsedCalculation.deliveryCentavos, 42825)
assert.equal(parsedCalculation.materialVatCentavos, 9177)
assert.equal(WithholdingThresholdPanelFromJSON({ calculation_breakdown: null, events: [] }).calculationBreakdown, null)
const operation = spec.paths['/vendor/finance/earnings']?.get
assert.ok(operation, 'GET /vendor/finance/earnings is documented')
assert.deepEqual(operation.security, [{ accessCookie: [], webCsrf: [] }])
assert.ok(schemas.VendorEarnings.required.includes('trend'), 'Earnings always returns its trend')
assert.equal(schemas.VendorEarnings.properties.trend.$ref, '#/components/schemas/VendorEarningsTrend')
assert.ok(schemas.VendorEarnings.required.includes('online_refunds_centavos'), 'Earnings separately reports confirmed online refunds')
assert.equal(schemas.VendorEarnings.properties.online_refunds_centavos.type, 'integer')
for (const figure of ['remittance_collections_centavos', 'remittance_refunds_centavos']) {
  assert.ok(schemas.VendorEarnings.required.includes(figure), `${figure} is an authoritative remittance component`)
  assert.equal(schemas.VendorEarnings.properties[figure].type, 'integer')
  assert.match(schemas.VendorEarnings.properties[figure].description, /assessment-date range/)
}
assert.match(schemas.VendorEarnings.properties.remittance_collections_centavos.description, /fully refunded VOIDED/)
assert.match(schemas.VendorEarnings.properties.remittance_refunds_centavos.description, /full and partial refunds/)
assert.match(schemas.VendorEarnings.properties.online_collections_centavos.description, /less confirmed refunded principal/)
assert.match(schemas.FinanceTransactionListEnvelope.description, /refund_state.*refunded_centavos.*net_collected_centavos/)

// Card breakdowns and the product list: integer centavos only, bounded, and no Buyer or provider identity.
for (const field of ['breakdown', 'products']) assert.ok(schemas.VendorEarnings.required.includes(field), `Earnings always returns ${field}`)
assert.equal(schemas.VendorEarnings.properties.breakdown.$ref, '#/components/schemas/VendorEarningsBreakdown')
assert.equal(schemas.VendorEarnings.properties.products.$ref, '#/components/schemas/VendorEarningsProducts')
assert.match(schemas.VendorEarnings.properties.commercial_sales_centavos.description, /fully refunded/)
const breakdown = schemas.VendorEarningsBreakdown
assert.deepEqual([...breakdown.required].sort(), ['online', 'physical', 'sales'])
const breakdownFields = {
  sales: ['delivery_centavos', 'materials_after_discount_centavos', 'materials_before_discount_centavos', 'orders', 'vendor_discounts_centavos'],
  online: ['payments', 'principal_paid_centavos', 'refunded_principal_centavos'],
  physical: ['cash_on_delivery_centavos', 'in_store_centavos', 'records'],
}
for (const [group, fields] of Object.entries(breakdownFields)) {
  assert.deepEqual([...breakdown.properties[group].required].sort(), fields, `${group} breakdown fields`)
  for (const field of fields) assert.equal(breakdown.properties[group].properties[field].type, 'integer', `${group}.${field} is an integer`)
}
const productList = schemas.VendorEarningsProducts
assert.deepEqual([...productList.required].sort(), ['items', 'total', 'truncated'])
assert.equal(productList.properties.items.maxItems, 50, 'The product list is bounded')
const product = schemas.VendorEarningsProduct
assert.deepEqual([...product.required].sort(), ['category', 'listing_id', 'name', 'orders', 'sku', 'value_centavos', 'vat_centavos'])
for (const field of ['orders', 'value_centavos', 'vat_centavos']) assert.equal(product.properties[field].type, 'integer')
assert.ok(!/buyer|email|phone|provider_id|payment_id|order_id/i.test(JSON.stringify({ breakdown, productList, product })), 'Breakdown and products expose no identity or provider data')

const trend = schemas.VendorEarningsTrend
assert.deepEqual(trend.properties.granularity.enum, ['DAY', 'MONTH'])
assert.deepEqual([...trend.required].sort(), ['days', 'from', 'granularity', 'points', 'previous', 'timezone', 'to'])
assert.ok(trend.properties.previous.oneOf.some(option => option.type === 'null'), 'The comparison is null for an empty period')

const sorted = list => [...list].sort()
assert.deepEqual(sorted(Object.keys(schemas.VendorEarningsTrendPoint.properties)), sorted(['date', ...figures]), 'Point keys equal TREND_FIGURES plus date')
assert.deepEqual(sorted(schemas.VendorEarningsTrendPoint.required), sorted(['date', ...figures]))
for (const name of ['VendorEarningsTrendFigures', 'VendorEarningsTrendChange']) {
  assert.deepEqual(sorted(Object.keys(schemas[name].properties)), sorted(figures), `${name} keys equal TREND_FIGURES`)
  assert.deepEqual(sorted(schemas[name].required), sorted(figures))
}
for (const figure of figures) {
  assert.equal(schemas.VendorEarningsTrendPoint.properties[figure].type, 'integer', `${figure} is integer centavos`)
  assert.deepEqual(schemas.VendorEarningsTrendChange.properties[figure].type, ['number', 'null'], `${figure} change is nullable`)
}

const text = JSON.stringify(Object.fromEntries(Object.entries(schemas).filter(([name]) => name.startsWith('VendorEarningsTrend'))))
assert.ok(!/buyer_(profile|key|id|name)|email|phone|"tin"|provider_id|payment_id|order_id|latitude|longitude/i.test(text), 'Trend schemas expose no identity, tax, provider or location data')
console.log(`Earnings trend contract checks passed (${figures.length} figures).`)
