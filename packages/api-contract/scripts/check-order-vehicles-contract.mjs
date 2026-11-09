import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { parse } from 'yaml'

const read = path => readFileSync(new URL(`../${path}`, import.meta.url), 'utf8')
const spec = parse(read('openapi.yaml'))
const schemas = spec.components.schemas
const fields = ['name', 'vehicle_category', 'vehicle_type', 'custom_type_name', 'brand', 'image_file_id', 'capacity_kg', 'mixer_capacity_m3', 'cargo_length_m', 'cargo_width_m', 'cargo_height_m', 'heavy_classification']
assert.deepEqual(Object.keys(schemas.DeliveryVehicleProfile.properties), fields, 'Exclude private fleet counts and operational data')
assert.equal(schemas.DeliveryVehicleProfile.additionalProperties, false)
for (const schema of ['DeliveryEstimateOption', 'DeliveryPlanVehicle', 'OrderDeliveryVehicle']) {
  assert.equal(schemas[schema].properties.vehicle_details.oneOf[0].$ref, '#/components/schemas/DeliveryVehicleProfile')
  assert.ok(!schemas[schema].required?.includes('vehicle_details'), 'Historical vehicle snapshots remain readable')
  assert.match(read(`generated/typescript/src/models/${schema}.ts`), /vehicleDetails\??:/)
}
for (const filePath of ['/buyers/orders/{orderId}/files/{fileId}', '/vendor/orders/{orderId}/files/{fileId}']) {
  const operation = spec.paths[filePath].get
  assert.match(operation.description, /vehicle/i, 'Order-authorized image delivery is documented')
  assert.ok(operation.responses['401'] && operation.responses['403'] && operation.responses['404'])
}
const dart = read('generated/dart/lib/src/model/delivery_vehicle_profile.dart')
const typescript = read('generated/typescript/src/models/DeliveryVehicleProfile.ts')
for (const field of ['imageFileId', 'capacityKg', 'mixerCapacityM3', 'cargoLengthM', 'cargoWidthM', 'cargoHeightM', 'heavyClassification']) {
  assert.match(dart, new RegExp(`get ${field};`))
  assert.match(typescript, new RegExp(`${field}\\??:`))
}
console.log('Order vehicle display contract: OK')
