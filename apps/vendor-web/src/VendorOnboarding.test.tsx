import { fireEvent, render, screen, waitFor } from '@testing-library/react'
import { afterEach, beforeEach, expect, test, vi } from 'vitest'
import { VendorOnboardingWorkspace } from '@materyalph/web-ui'

let role = 'OWNER'
let permissions: string[] = []
let paymentStatus: string | null = null
const paths: string[] = []
const response = (data: unknown) => new Response(JSON.stringify({ data, meta: { page: 1, last_page: 1 }, errors: [] }), { headers: { 'Content-Type': 'application/json' } })
const readiness = {
  organization_id: 'test-organization', store_name: 'SAMPLE Store', onboarding_status: 'PENDING_VERIFICATION',
  store_verification_status: 'PENDING_VERIFICATION', store_setup_status: 'IN_PROGRESS', activation_status: 'NOT_ACTIVE',
  discoverability_status: 'NOT_DISCOVERABLE', marketplace_status: 'NOT_ACTIVE', lock_version: 3, environment: 'TEST',
  rule_version: 'PHASE_3_REVISED_ONBOARDING_V2', ready: false, evaluated_at: '2026-09-15T00:00:00Z',
  checklist: [
    { id: 'DTI', section: 'STORE_VERIFICATION', label: 'DTI registration', requirement_level: 'REQUIRED', status: 'PENDING_VERIFICATION', blocking: true, reason: 'Manual Admin review is pending.', next_action: 'documents', version_id: null, updated_at: '2026-09-15T00:00:00Z', recent_authentication_required: false },
    { id: 'TEAM_ACCOUNTS', section: 'STORE_SETUP', label: 'Vendor Team Accounts', requirement_level: 'OPTIONAL', status: 'NOT_STARTED', blocking: false, reason: null, next_action: 'team', version_id: null, updated_at: '2026-09-15T00:00:00Z', recent_authentication_required: false },
  ],
}

beforeEach(() => {
  role = 'OWNER'; permissions = []; paymentStatus = null; paths.length = 0
  vi.stubGlobal('fetch', vi.fn(async (input: RequestInfo | URL) => {
    const path = input instanceof Request ? input.url : String(input); paths.push(path)
    if (path.endsWith('/auth/csrf')) return response({ csrf_token: 'test-csrf' })
    if (path.endsWith('/account/profile')) return response({ id: 'test-owner', full_name: 'SAMPLE Owner', email: 'owner@example.test', account_type: 'VENDOR', account_status: 'ACTIVE', lock_version: 1, created_at: '2026-01-01', organization_id: 'test-organization', role, permissions, can_manage_staff: permissions.includes('staff.manage') })
    if (path.endsWith('/onboarding')) return response(readiness)
    if (path.endsWith('/tax-profile')) return response({ lock_version: 3, evidence_versions: [], profile_id: null, version_id: null, version: null, status: 'NOT_STARTED', environment: 'TEST', evidence_origin: 'SAMPLE_DEMO', data: {}, owner_attested_at: null, withholding_treatment: 'STANDARD', history: [], legal_effect: 'TEST_DEMO_ONLY_NOT_REGULATORY_APPROVAL' })
    if (path.endsWith('/setup') || path.endsWith('/payment-connection/reconciliation')) return response({ lock_version: 3, store: null, hours: [], bulk_order_capable: null, delivery_vehicles: [], payment: paymentStatus ? { provider_status: null, connection_error: 'PROVIDER_OUTCOME_UNCONFIRMED', environment: 'TEST', status: paymentStatus, evidence_origin: 'PROVIDER_TEST', checked_at: null } : null, withholding_demo_scenario: null, production_withholding_assignment: 'UNCONFIRMED', environment: 'TEST' })
    if (path.endsWith('/commission-terms')) return response({ agreement: null, commission_basis_points: 200, basis: 'MATERIALS_AFTER_DISCOUNT_EXCLUDING_VAT', cadence: 'MONTHLY', environment: 'TEST', content_available: false })
    if (path.includes('/team/invitations')) return response(role === 'STORE_MANAGER' ? [
      { id: 'staff-invitation', full_name: 'SAMPLE Invited Staff', normalized_email: 'staff@example.test', role: 'STORE_STAFF', can_manage_staff: false, expires_at: '2026-09-30T00:00:00Z', accepted_at: null, revoked_at: null, lock_version: 1 },
      { id: 'manager-invitation', full_name: 'SAMPLE Invited Manager', normalized_email: 'manager@example.test', role: 'STORE_MANAGER', can_manage_staff: false, expires_at: '2026-09-30T00:00:00Z', accepted_at: null, revoked_at: null, lock_version: 1 },
    ] : [])
    if (path.includes('/team')) return response({ members: role === 'STORE_MANAGER' ? [
      { id: 'manager-member', name: 'SAMPLE Delegated Manager', role: 'STORE_MANAGER', status: 'ACTIVE', can_manage_staff: true, lock_version: 1, created_at: '2026-09-01T00:00:00Z' },
      { id: 'staff-member', name: 'SAMPLE Store Staff', role: 'STORE_STAFF', status: 'ACTIVE', can_manage_staff: false, lock_version: 1, created_at: '2026-09-02T00:00:00Z' },
    ] : [], invitations: [] })
    return response([])
  }))
})

afterEach(() => vi.unstubAllGlobals())

const open = () => render(<VendorOnboardingWorkspace portal="vendors" basePath="https://api.example.test/api/v1" accountPath="/account" dashboardPath="/dashboard" />)

test('shows distinct onboarding states, level/status semantics, and no listing activation prerequisite', async () => {
  open()
  expect(await screen.findByText('Manual Admin review is pending.')).toBeVisible()
  expect(screen.getByText('Store Verification')).toBeVisible()
  expect(screen.getByText('Marketplace Discoverability')).toBeVisible()
  expect(screen.getByText('Required')).toBeVisible()
  expect(screen.getByText('Optional')).toBeVisible()
  expect(screen.queryByText(/publishable listing.*activation prerequisite/i)).not.toBeInTheDocument()
})

test('ordinary staff do not repeat onboarding or receive Owner controls', async () => {
  role = 'STORE_STAFF'; open()
  expect(await screen.findByText(/Staff accounts do not repeat Vendor Onboarding/)).toBeVisible()
  expect(screen.queryByRole('button', { name: 'Business identity' })).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Activate Store' })).not.toBeInTheDocument()
})

test('a delegated Store Manager can access only optional Team Accounts', async () => {
  role = 'STORE_MANAGER'; permissions = ['staff.manage']; open()
  expect(await screen.findByRole('heading', { name: 'Vendor Team Accounts' })).toBeVisible()
  expect(await screen.findByRole('combobox', { name: 'Role for SAMPLE Store Staff' })).toBeVisible()
  expect(screen.getByRole('button', { name: 'Team accounts' })).toBeVisible()
  expect(screen.queryByRole('button', { name: 'Store profile' })).not.toBeInTheDocument()
  expect(screen.queryByRole('option', { name: 'STORE_MANAGER' })).not.toBeInTheDocument()
  expect(screen.getAllByRole('button', { name: 'Change role' })).toHaveLength(1)
  expect(screen.getAllByRole('button', { name: 'Revoke invitation' })).toHaveLength(1)
  expect(screen.queryByRole('button', { name: 'Update delegation' })).not.toBeInTheDocument()
})

test('Xendit remains mandatory and an unfinished TEST attempt exposes reconciliation', async () => {
  paymentStatus = 'TEST_CONNECTING'; open()
  await screen.findByText('Manual Admin review is pending.')
  fireEvent.click(screen.getByRole('button', { name: 'Payment and commission' }))
  expect(await screen.findByText(/mandatory for every Vendor seeking Store Activation/)).toBeVisible()
  expect(screen.getByRole('button', { name: 'Connect Xendit TEST account' })).toBeDisabled()
  fireEvent.click(screen.getByRole('button', { name: 'Reconcile attempt' }))
  await waitFor(() => expect(paths.some(path => path.endsWith('/payment-connection/reconciliation'))).toBe(true))
  expect(screen.getByText(/2% Vendor-paid commission/)).toBeVisible()
  expect(screen.getByText(/does not duplicate it/)).toBeVisible()
})
