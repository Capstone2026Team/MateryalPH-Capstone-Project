import { fireEvent, render, screen, waitFor } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import { VendorDashboardPage, VendorWelcomePage, VendorVerificationPage, VendorSetupPage, VendorStoreProfilePage } from './PhaseThreeVendorPages'
import { VendorEntryPage } from './VendorEntryPage'
import * as api from '../lib/onboarding-api'
import { vendorLoginDestination } from '../lib/vendor-destination'

vi.mock('../lib/onboarding-api', async original => ({ ...await original<typeof import('../lib/onboarding-api')>(), getVendorOnboarding: vi.fn(), dismissVendorWelcome: vi.fn(), saveVendorVerificationDraft: vi.fn(), saveVendorSetupDraft: vi.fn() }))
let snapshot: api.VendorOnboardingSnapshot
beforeEach(() => {
  vi.clearAllMocks()
  snapshot = { organization: { store_name: 'Test Supply', lock_version: 1 }, welcomeRequired: false, permissions: ['vendor.onboarding.manage', 'vendor.onboarding.submit'], verification: { status: 'NOT_STARTED' }, setup: { status: 'NOT_STARTED' }, activation: { status: 'NOT_READY', readiness: { ready: false, blockers: [] } }, sections: {} }
  vi.mocked(api.getVendorOnboarding).mockImplementation(async () => snapshot)
  vi.mocked(api.dismissVendorWelcome).mockImplementation(async () => { snapshot = { ...snapshot, welcomeRequired: false }; return snapshot })
  vi.mocked(api.saveVendorVerificationDraft).mockImplementation(async () => snapshot)
  vi.mocked(api.saveVendorSetupDraft).mockImplementation(async () => snapshot)
})
function open(path: string) {
  return render(<MemoryRouter initialEntries={[path]}><Routes><Route path="/entry" element={<VendorEntryPage />} /><Route path="/welcome" element={<VendorWelcomePage />} /><Route path="/dashboard" element={<VendorDashboardPage />} /><Route path="/onboarding/verification" element={<VendorVerificationPage />} /><Route path="/onboarding/setup" element={<VendorSetupPage />} /><Route path="/store-profile" element={<VendorStoreProfilePage />} /><Route path="/account" element={<h1>Personal account settings</h1>} /></Routes></MemoryRouter>)
}
test('first login persists Continue then permits later login to resume onboarding', async () => {
  snapshot.welcomeRequired = true
  open('/entry')
  fireEvent.click(await screen.findByRole('button', { name: 'Continue' }))
  await waitFor(() => expect(api.dismissVendorWelcome).toHaveBeenCalledOnce())
  expect(await screen.findByRole('heading', { level: 1, name: 'Store Verification' })).toBeVisible()
  expect(vendorLoginDestination(snapshot)).toBe('/onboarding/verification')
})
test('Continue Later saves verification then setup before reaching limited dashboard', async () => {
  open('/onboarding/verification')
  fireEvent.click(await screen.findByRole('button', { name: 'Continue Later' }))
  expect(await screen.findByRole('heading', { level: 1, name: 'Store Setup' })).toBeVisible()
  expect(api.saveVendorVerificationDraft).toHaveBeenCalledOnce()
  fireEvent.click(screen.getByRole('button', { name: 'Continue Later' }))
  expect(await screen.findByText('Limited-Access Vendor Dashboard')).toBeVisible()
  expect(api.saveVendorSetupDraft).toHaveBeenCalledOnce()
  expect(vi.mocked(api.saveVendorSetupDraft).mock.calls[0]?.[0]).not.toHaveProperty('fulfillmentMethod')
})
test('Store Profile is separate and logo returns to the authenticated dashboard', async () => {
  open('/dashboard')
  fireEvent.click(await screen.findByRole('link', { name: 'Store Profile' }))
  expect(await screen.findByRole('heading', { level: 1, name: 'Store Profile' })).toBeVisible()
  fireEvent.click(screen.getByRole('link', { name: /MateryalPH VENDOR PORTAL/ }))
  expect(await screen.findByText('Limited-Access Vendor Dashboard')).toBeVisible()
  expect(screen.queryByText('Personal account settings')).not.toBeInTheDocument()
})
test('pending review with complete setup and activated stores have distinct dashboard states', () => {
  snapshot.setup.status = 'COMPLETED'
  snapshot.verification.status = 'PENDING_VERIFICATION'
  expect(vendorLoginDestination(snapshot)).toBe('/dashboard')
  snapshot.activation.status = 'ACTIVE'
  expect(vendorLoginDestination(snapshot)).toBe('/dashboard')
})
test('staff cannot enter the Owner Store Profile', async () => {
  snapshot.permissions = []
  open('/store-profile')
  expect(await screen.findByRole('heading', { name: 'Personal account settings' })).toBeVisible()
})

test('an unavailable API keeps entry recoverable instead of routing to login', async () => {
  vi.mocked(api.getVendorOnboarding).mockRejectedValueOnce(new TypeError('Network unavailable'))
  open('/entry')
  fireEvent.click(await screen.findByRole('button', { name: 'Retry' }))
  expect(await screen.findByRole('heading', { level: 1, name: 'Store Verification' })).toBeVisible()
})

test('Continue Later does not leave the form when saving fails', async () => {
  vi.mocked(api.saveVendorVerificationDraft).mockRejectedValueOnce(new TypeError('Network unavailable'))
  open('/onboarding/verification')
  fireEvent.click(await screen.findByRole('button', { name: 'Continue Later' }))
  await waitFor(() => expect(api.saveVendorVerificationDraft).toHaveBeenCalledOnce())
  expect(await screen.findByRole('alert')).toBeVisible()
  expect(screen.getByRole('heading', { level: 1, name: 'Store Verification' })).toBeVisible()
  expect(screen.queryByRole('heading', { level: 1, name: 'Store Setup' })).not.toBeInTheDocument()
})
