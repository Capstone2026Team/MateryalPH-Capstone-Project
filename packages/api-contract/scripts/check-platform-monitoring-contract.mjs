import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { createRequire } from 'node:module'
import { parse } from 'yaml'

const require = createRequire(import.meta.url)
const { IntegrationOverviewFromJSON, OperationFailureFromJSON } = require('../generated/typescript/dist/index.js')
const spec = parse(readFileSync(new URL('../openapi.yaml', import.meta.url), 'utf8'))
const schemas = spec.components.schemas
assert.equal(schemas.IntegrationOverview.properties.automatic_recovery.$ref, '#/components/schemas/AutomaticRecoveryHealth')
assert.equal(schemas.AutomaticRecoveryHealth.properties.max_cycles.const, 3)
assert.deepEqual(schemas.OperationFailure.properties.recovery_status.enum, ['SCHEDULED', 'LIMIT_REACHED', 'OWNING_PROCESS', 'RESOLVED'])
assert.equal(schemas.OperationFailure.properties.recovery_attempts.maximum, 3)
const overview = IntegrationOverviewFromJSON({ generated_at: '2026-11-07T03:00:00Z', environment: { deployment: 'HOSTINGER_VPS' }, integrations: [], queues: { failed_jobs: 5, dead_letters: 8 },
  automatic_recovery: { status: 'OVERDUE', max_cycles: 3, delays_minutes: [15, 60, 360], last_started_at: null }, scheduled_tasks: [], analytics: {}, can_retry: false })
assert.equal(overview.queues.failed_jobs, 5)
assert.equal(overview.environment.deployment, 'HOSTINGER_VPS')
assert.equal(overview.queues.dead_letters, 8)
assert.equal(overview.automaticRecovery.status, 'OVERDUE')
assert.deepEqual(overview.automaticRecovery.delaysMinutes, [15, 60, 360])
assert.equal(overview.automaticRecovery.lastStartedAt, null)
const failure = OperationFailureFromJSON({ kind: 'OUTBOX_EVENT', reference: 'event', label: 'Notice', queue: 'default', failure: 'Delivery attempts exhausted', failed_at: '2026-11-07T03:00:00Z',
  retryable: true, recovery_status: 'SCHEDULED', recovery_attempts: 1, next_retry_at: '2026-11-07T04:00:00Z' })
assert.equal(failure.recoveryStatus, 'SCHEDULED')
assert.equal(failure.recoveryAttempts, 1)
assert.equal(failure.nextRetryAt.toISOString(), '2026-11-07T04:00:00.000Z')
console.log('Platform Monitoring contract and generated TypeScript decoding passed.')
