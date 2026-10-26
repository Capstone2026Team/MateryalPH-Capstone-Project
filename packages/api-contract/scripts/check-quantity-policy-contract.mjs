import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { parse } from 'yaml'

const contract = parse(readFileSync(new URL('../openapi.yaml', import.meta.url), 'utf8'))
const schemas = contract.components.schemas
assert.deepEqual(schemas.QuantityPolicy.properties.mode.enum, ['COUNT', 'PACK', 'MEASURED'])
assert.deepEqual(schemas.QuantityPolicy.required, ['mode', 'dimension', 'precision', 'step'])
for (const name of ['CatalogUnit', 'ProjectMaterialUnit', 'CatalogVariant', 'ListingVariantOffer', 'CartLine', 'InventoryRow', 'OrderLine', 'ChatQuotationLine', 'ChatDraftLine']) {
  assert.equal(schemas[name].properties.quantity_policy.$ref, '#/components/schemas/QuantityPolicy', name)
  assert.equal(schemas[name].properties.quantity_policy.readOnly, true, name)
  assert.ok(!(schemas[name].required ?? []).includes('quantity_policy'), `${name} must remain compatible with older records`)
}
for (const name of ['CartItemCreate', 'CartItemUpdate', 'WorkPackageLineInput', 'CatalogVariantInput']) {
  assert.ok(!(schemas[name].required ?? []).includes('quantity_policy'), `${name} cannot require client policy metadata`)
}
console.log('Quantity policy contract: optional read-only metadata and legacy request compatibility passed.')
