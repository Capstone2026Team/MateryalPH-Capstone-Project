import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import YAML from 'yaml'
const spec = YAML.parse(readFileSync(new URL('../openapi.yaml', import.meta.url), 'utf8'))
for (const [path, operation] of [
  ['/{audience}/orders/{orderId}/documents', 'listOrderDocuments'],
  ['/{audience}/orders/{orderId}/documents/{kind}/download', 'downloadOrderDocument'],
]) {
  assert.equal(spec.paths[path].get.operationId, operation)
  assert.ok(spec.paths[path].get.security.some(item => 'passportBearer' in item))
  assert.equal(spec.paths[path].post, undefined)
}
const properties = spec.components.schemas.PlatformDocumentRef.properties
for (const key of ['availability', 'generated_at', 'checksum', 'download_url']) assert.ok(properties[key])
assert.deepEqual(spec.paths['/{audience}/orders/{orderId}/documents/{kind}/download'].get.parameters.find(parameter => parameter.name === 'kind').schema.enum, ['PURCHASE_ORDER'])
assert.equal(spec.paths['/{audience}/orders/{orderId}/documents'].get.responses['200'].content['application/json'].schema.properties.data.items.$ref, '#/components/schemas/PlatformDocumentRef')
console.log('Automatically issued order document read/download contract checks passed.')
