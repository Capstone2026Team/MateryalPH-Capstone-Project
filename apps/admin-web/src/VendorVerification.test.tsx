import { fireEvent, render, screen, waitFor } from '@testing-library/react'
import { afterEach, expect, test, vi } from 'vitest'
import { VendorOnboardingWorkspace } from '@materyalph/web-ui'

afterEach(() => vi.unstubAllGlobals())

test('reviewers inspect Store Verification and expose the three canonical decisions', async () => {
  const response = (data: unknown) => new Response(JSON.stringify({ data, meta: { page: 1, last_page: 1 }, errors: [] }), { headers: { 'Content-Type': 'application/json' } })
  vi.stubGlobal('fetch', vi.fn(async (input: RequestInfo | URL) => {
    const path = input instanceof Request ? input.url : String(input)
    if (path.endsWith('/account/profile')) return response({ id: 'test-reviewer', full_name: 'SAMPLE Reviewer', email: 'reviewer@example.test', account_type: 'ADMIN', account_status: 'ACTIVE', lock_version: 1, created_at: '2026-01-01', role: 'ADMIN_VENDOR_VERIFICATION', permissions: ['vendors.verify'] })
    if (path.includes('/vendor-verification?')) return response([{ id: 'test-org', store_name: 'SAMPLE Store', onboarding_status: 'PENDING_VERIFICATION', store_verification_status: 'PENDING_VERIFICATION', store_setup_status: 'IN_PROGRESS', activation_status: 'NOT_ACTIVE', discoverability_status: 'NOT_DISCOVERABLE', marketplace_status: 'NOT_ACTIVE', lock_version: 2, submitted_at: '2026-09-15T00:00:00Z' }])
    if (path.endsWith('/onboarding')) return response({ organization_id: 'test-org', store_name: 'SAMPLE Store', onboarding_status: 'PENDING_VERIFICATION', store_verification_status: 'PENDING_VERIFICATION', store_setup_status: 'IN_PROGRESS', activation_status: 'NOT_ACTIVE', discoverability_status: 'NOT_DISCOVERABLE', marketplace_status: 'NOT_ACTIVE', lock_version: 2, environment: 'TEST', rule_version: 'PHASE_3_REVISED_ONBOARDING_V2', ready: false, evaluated_at: '2026-09-15T00:00:00Z', checklist: [] })
    if (path.endsWith('/business')) return response({ lock_version: 2, status: 'PENDING_VERIFICATION', review_reason: null, store_email_verification: { email: 'store@example.test', verified_at: '2026-09-15T00:00:00Z', pending_email: null }, draft: { business_type: 'SOLE_PROPRIETORSHIP', legal_name: 'SAMPLE Submitted Legal Name', store_name: 'SAMPLE Store' } })
    if (path.endsWith('/tax-profile')) return response({ lock_version: 2, evidence_versions: [], profile_id: null, version_id: null, version: null, status: 'PENDING_VERIFICATION', environment: 'TEST', evidence_origin: 'SAMPLE_DEMO', data: {}, owner_attested_at: null, withholding_treatment: 'STANDARD', history: [], legal_effect: 'TEST_DEMO_ONLY_NOT_REGULATORY_APPROVAL' })
    if (path.includes('/documents') || path.includes('/store-media')) return response([])
    return response([])
  }))

  render(<VendorOnboardingWorkspace portal="admin" basePath="https://api.example.test/api/v1" accountPath="/account" dashboardPath="/workspace" />)
  fireEvent.click(await screen.findByRole('button', { name: 'Review' }))
  expect(await screen.findByRole('heading', { name: 'Store Verification manual review' })).toBeVisible()
  expect(await screen.findByText('SAMPLE Submitted Legal Name')).toBeVisible()
  const decisions = screen.getAllByRole('combobox', { name: 'Decision' })
  expect(decisions[0]!).toHaveValue('RETURN_FOR_CORRECTION')
  fireEvent.change(decisions[0]!, { target: { value: 'APPROVE' } })
  expect(decisions[0]!).toHaveValue('APPROVE')
  fireEvent.change(decisions[0]!, { target: { value: 'REJECT' } })
  expect(decisions[0]!).toHaveValue('REJECT')
  expect(screen.getByRole('textbox', { name: 'Applicability/dependency basis' })).toBeVisible()
  await waitFor(() => expect(screen.getByRole('button', { name: 'Store Setup' })).toBeEnabled())
})
