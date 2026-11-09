import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { createRequire } from 'node:module'
import { parse } from 'yaml'

const read = path => readFileSync(new URL(`../${path}`, import.meta.url), 'utf8')
const spec = parse(read('openapi.yaml'))
const require = createRequire(import.meta.url)
const { OrderBuyerRefFromJSON, OrderLocationMapFromJSON } = require('../generated/typescript/dist/index.js')
for (const [path, operationId] of [
  ['/vendor/orders/{orderId}/buyer-photo', 'getVendorOrderBuyerPhoto'],
  ['/vendor/orders/{orderId}/route', 'getVendorOrderRoute'],
]) {
  const operation = spec.paths[path].get
  assert.equal(operation.operationId, operationId)
  assert.deepEqual(operation.security, [{ accessCookie: [] }])
  for (const status of ['401', '403', '404', '422', '503']) assert.ok(operation.responses[status])
}
assert.equal(spec.paths['/vendor/orders/{orderId}/buyer-photo'].get.parameters[1].required, true)
assert.ok(spec.components.schemas.OrderBuyerRef.properties.profile_photo_path)
assert.equal(spec.components.schemas.OrderDetail.properties.location_map.$ref, '#/components/schemas/OrderLocationMap')
assert.ok(!spec.components.schemas.OrderSummary.properties.location_map)
const point = { latitude: 14.6, longitude: 121.1, label: 'Sample drop-off' }
assert.deepEqual(OrderLocationMapFromJSON({ store: point, destination: null }), { store: point, destination: null })
assert.equal(OrderBuyerRefFromJSON({ display_name: 'Sample Buyer', profile_photo_path: '/vendor/orders/sample/buyer-photo?version=2' }).profilePhotoPath, '/vendor/orders/sample/buyer-photo?version=2')
for (const [file, field] of [['order_location_map', 'destination'], ['order_buyer_ref', 'profilePhotoPath'], ['order_detail', 'locationMap']]) {
  assert.match(read(`generated/dart/lib/src/model/${file}.dart`), new RegExp(`get ${field};`))
  assert.match(read(`generated/dart/lib/src/model/${file}.g.dart`), new RegExp(field))
}
console.log('Order photo and location contract: OK')
