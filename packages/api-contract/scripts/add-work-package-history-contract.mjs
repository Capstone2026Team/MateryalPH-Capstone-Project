import { readFileSync, writeFileSync } from 'node:fs'
import YAML from 'yaml'

const file = new URL('../openapi.yaml', import.meta.url)
const document = YAML.parseDocument(readFileSync(file, 'utf8'))
const base = document.getIn(['paths', '/buyers/work-packages/{packageId}/activate', 'post']).toJSON()
for (const [path, method, operationId, description] of [
  ['/buyers/work-packages/{packageId}/versions/{versionId}/reactivate', 'post', 'reactivateWorkPackageVersion',
    'Copy an older visible version into a new locked Active version. Revalidate its materials, site and budget; invalidate estimates and expire inquiries atomically. Selected work requires prior order cancellation. Originals are retained.'],
  ['/buyers/work-packages/{packageId}/versions/{versionId}', 'delete', 'deleteWorkPackageVersion',
    'Remove an older version from Buyer history, retaining immutable originals and all procurement references. The current version cannot be removed. Requires an Active owned Project, current package lock_version and an Idempotency-Key.'],
]) {
  const operation = structuredClone(base)
  operation.operationId = operationId
  operation.description = description
  operation.parameters.splice(1, 0, {
    name: 'versionId', in: 'path', required: true, schema: { type: 'string', format: 'uuid' },
  })
  operation.responses['409'].description = 'PROJECT_VERSION_CONFLICT, WORK_PACKAGE_VERSION_CURRENT, PROJECT_CLOSED, WORK_PACKAGE_LOCKED or IDEMPOTENCY_CONFLICT; no mutation.'
  operation.responses['404'].description = 'No owned package or visible version belonging to this package.'
  document.setIn(['paths', path, method], operation)
}
document.setIn(['components', 'schemas', 'WorkPackageInput', 'properties', 'source_version_id'], {
  type: 'string', format: 'uuid', description: 'Optional visible version from this same package used as the basis for an edited copy. Retained in the audit trail; never overwrites the source.',
})
document.setIn(['components', 'schemas', 'WorkPackageView', 'properties', 'can_delete_draft'], {
  type: 'boolean', description: 'True only for an editable Draft in an Active Project with no locked originals or retained version-deletion history.',
})
writeFileSync(file, String(document))
