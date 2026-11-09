import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import YAML from 'yaml'

const spec = YAML.parse(readFileSync(new URL('../openapi.yaml', import.meta.url), 'utf8'))
for (const [suffix, operation] of [['', 'listAdminAuditOrders'], ['/{orderId}', 'getAdminAuditOrder'], ['/{orderId}/files/{fileId}', 'getAdminAuditOrderFile']]) {
  const path = spec.paths[`/admin/order-operations/orders${suffix}`]
  assert.deepEqual(Object.keys(path), ['get'])
  assert.equal(path.get.operationId, operation)
  assert.ok(path.get.security.some(item => 'accessCookie' in item && 'webCsrf' in item))
  assert.ok(path.get.responses['403'])
  if (suffix) {
    assert.ok(path.get.parameters.some(parameter => parameter.name === 'case_id' && parameter.schema.format === 'uuid'))
    assert.ok(path.get.responses['404'])
  }
}
const ts = readFileSync(new URL('../generated/typescript/src/apis/AdminOrderOperationsApi.ts', import.meta.url), 'utf8')
assert.ok(spec.paths['/admin/order-operations/reimbursements'].get.parameters.some(parameter => parameter.name === 'page'))
assert.equal(spec.components.schemas.AdminReimbursementRow.properties.order_id.format, 'uuid')
const dart = readFileSync(new URL('../generated/dart/lib/src/api/admin_order_operations_api.dart', import.meta.url), 'utf8')
for (const operation of ['listAdminAuditOrders', 'getAdminAuditOrder', 'getAdminAuditOrderFile']) {
  assert.ok(ts.includes(operation))
  assert.ok(dart.includes(operation))
}
console.log('Read-only Admin order audit and generated-client contracts passed.')
