import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { createRequire } from 'node:module'
import { parse } from 'yaml'

const require = createRequire(import.meta.url)
const client = require('../generated/typescript/dist/index.js')
const spec = parse(readFileSync(new URL('../openapi.yaml', import.meta.url), 'utf8'))
const counts = { OPEN: 32, CLOSED: 0 }
for (const name of ['ProductComplianceQueueEnvelope', 'EnforcementListEnvelope', 'ModerationQueueEnvelope', 'SupportTicketListResponse']) {
  const envelope = spec.components.schemas[name]
  const reference = envelope.properties.meta.$ref?.split('/').at(-1)
  const meta = reference ? spec.components.schemas[reference] : envelope.properties.meta
  assert.equal(meta.properties.counts.type, 'object', `${name} documents count metadata`)
  assert.deepEqual(meta.properties.counts.additionalProperties, { type: 'integer', minimum: 0 })
  const wire = { data: [], meta: { counts, total: 32, current_page: 2, last_page: 2, page: 2, per_page: 25, has_more: false, next_cursor: null }, errors: [] }
  const decoded = client[`${name}FromJSON`](wire)
  assert.deepEqual(decoded.meta.counts, counts, `${name} preserves full totals and zeroes`)
  assert.deepEqual(client[`${name}ToJSON`](decoded).meta.counts, counts, `${name} round trips counts`)
  if (name === 'ProductComplianceQueueEnvelope') assert.equal(decoded.meta.currentPage, 2)
  if (name === 'EnforcementListEnvelope') assert.equal(decoded.meta.perPage, 25)
}
assert.equal(client.SupportPageMetaFromJSON({ next_cursor: null }).counts, undefined, 'Non-Admin support lists need no counts')
console.log('Admin queue count schemas and generated client serialization passed for all four queues.')
