import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { createRequire } from 'node:module'
import { parse } from 'yaml'

const { AdminFinanceApi, PublicFinanceApi, Configuration } = createRequire(import.meta.url)('../generated/typescript/dist/index.js')
const spec = parse(readFileSync(new URL('../openapi.yaml', import.meta.url), 'utf8'))
const requests = []
const current = { id: '019d0000-0000-7000-8000-000000000001', version: 2, commission_basis_points: 150, rate_label: '1.50%', effective_from: '2026-11-09T00:00:00Z', status: 'CURRENT', terms_version: 4, terms_content: 'Published terms', vendor_message: 'A lower rate', delivery: { total: 3, sent: 2, failed: 1, queued: 0, blocked: 0 } }
const config = new Configuration({ basePath: 'https://example.invalid/api/v1', fetchApi: async (url, init) => {
  requests.push({ url: new URL(String(url)), body: init.body ? JSON.parse(init.body) : null, headers: init.headers })
  const data = String(url).includes('/commission-policy') ? { current, next: null, selected: null }
    : String(url).endsWith('/commission-policies') ? current : String(url).includes('/statements?') ? [] : { queued: true }
  return new Response(JSON.stringify({ data, meta: {}, errors: [] }), { status: 200, headers: { 'Content-Type': 'application/json' } })
} })
const admin = new AdminFinanceApi(config)
const published = await admin.publishCommissionPolicy({ idempotencyKey: 'test-request-key', commissionPolicyPublishRequest: { commissionBasisPoints: 150, expectedVersion: 1, reason: 'Internal accounting rationale', vendorMessage: 'A lower rate', noticeOverride: true, noticeOverrideReason: 'Approved shorter notice', supersedesPolicyId: current.id, cancelScheduled: false } })
assert.equal(published.data.termsVersion, 4)
assert.equal(published.data.delivery.failed, 1)
assert.deepEqual(requests.at(-1).body, { commission_basis_points: 150, expected_version: 1, reason: 'Internal accounting rationale', vendor_message: 'A lower rate', notice_override: true, notice_override_reason: 'Approved shorter notice', supersedes_policy_id: current.id, cancel_scheduled: false })
await admin.listFeeStatements({ search: 'Test Supply', states: 'ISSUED,PARTIALLY_PAID', overdue: true })
assert.equal(requests.at(-1).url.searchParams.get('states'), 'ISSUED,PARTIALLY_PAID')
assert.equal(requests.at(-1).url.searchParams.get('search'), 'Test Supply')
await admin.resendCommissionEmail({ eventId: current.id, idempotencyKey: 'resend-key' })
assert.equal(requests.at(-1).headers['Idempotency-Key'], 'resend-key')
const result = await new PublicFinanceApi(config).getPublicCommissionPolicy({})
assert.equal(result.data.current.rateLabel, '1.50%')
assert.equal(result.data.next, null)
assert.deepEqual(spec.components.schemas.CommissionPolicyPublishRequest.required, ['commission_basis_points', 'expected_version', 'reason'], 'Existing publish clients retain their request shape; the domain now enforces configured notice.')
assert.ok(spec.components.schemas.CommissionPolicy.properties.status.enum.includes('CANCELLED'))
assert.equal(spec.paths['/admin/finance/commission-policies/preview'].post.operationId, 'previewCommissionPolicy')
assert.equal(spec.paths['/admin/finance/statements/{statementId}'].get.operationId, 'getAdminCommissionStatement')
assert.equal(spec.paths['/commission-policy'].get.security, undefined)
console.log('Commission policy, public terms, filters and audited resend transport passed.')
