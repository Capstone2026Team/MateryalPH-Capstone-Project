import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { createRequire } from 'node:module'
import { parse } from 'yaml'

const require = createRequire(import.meta.url)
const client = require('../generated/typescript/dist/index.js')
const spec = parse(readFileSync(new URL('../openapi.yaml', import.meta.url), 'utf8'))
for (const [path, method, operation] of [
  ['/admin/enforcement/subjects/{type}/{subjectId}/files', 'post', 'uploadEnforcementEvidence'],
  ['/admin/enforcement/{actionId}/files/{fileId}', 'get', 'getEnforcementEvidenceLink'],
  ['/admin/enforcement/{actionId}/files/{fileId}/content', 'get', 'downloadEnforcementEvidence'],
]) {
  assert.equal(spec.paths[path][method].operationId, operation)
  assert.ok(spec.paths[path][method].security.some(item => 'accessCookie' in item))
  assert.equal(typeof client.AdminEnforcementApi.prototype[operation], 'function')
}
assert.equal(spec.components.schemas.EnforcementRecordRequest.properties.evidence_file_ids.maxItems, 5)
const request = client.EnforcementRecordRequestToJSON({ subjectType: 'BUYER', subjectId: 'subject-1', action: 'WARNING', reason: 'Reviewed incident.', evidenceFileIds: new Set(['file-1']) })
assert.deepEqual(request.evidence_file_ids, ['file-1'])
const detail = client.EnforcementDetailFromJSON({ evidence: [{ id: 'file-1', name: 'proof.mp4', content_type: 'video/mp4', byte_size: 1024 }], events: [], allowed_actions: [] })
assert.equal(detail.evidence[0].contentType, 'video/mp4')
assert.equal(detail.evidence[0].byteSize, 1024)
const subject = client.EnforcementSubjectEnvelopeDataFromJSON({ recordable_actions: ['WARNING'], sanctions: [] })
assert.deepEqual(subject.recordableActions, ['WARNING'])
console.log('Enforcement evidence contract and generated TypeScript transport passed.')
