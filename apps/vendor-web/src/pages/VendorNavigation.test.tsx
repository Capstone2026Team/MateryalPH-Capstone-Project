import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import { VendorDashboardPage, VendorWelcomePage, VendorVerificationPage, VendorSetupPage, VendorStoreProfilePage } from './PhaseThreeVendorPages'
import { VendorEntryPage } from './VendorEntryPage'
import * as api from '../lib/onboarding-api'
import { vendorLoginDestination } from '../lib/vendor-destination'

vi.mock('../lib/onboarding-api', async original => ({ ...await original<typeof import('../lib/onboarding-api')>(), getVendorOnboarding: vi.fn(), dismissVendorWelcome: vi.fn(), saveVendorVerificationDraft: vi.fn(), saveVendorSetupDraft: vi.fn(), submitVendorVerification: vi.fn(), completeVendorSetup: vi.fn(), getVendorPrivateFileUrl: vi.fn(), uploadVendorMedia: vi.fn(), requestStoreEmailVerification: vi.fn(), confirmStoreEmailVerification: vi.fn() }))
let snapshot: api.VendorOnboardingSnapshot
beforeEach(() => {
  vi.clearAllMocks()
  snapshot = { organization: { store_name: 'Test Supply', lock_version: 1 }, welcomeRequired: false, permissions: ['vendor.onboarding.manage', 'vendor.onboarding.submit'], verification: { privacy_notice: { version: 2, content: 'Sample Privacy Notice for this test.' }, status: 'NOT_STARTED' }, setup: { status: 'NOT_STARTED' }, activation: { status: 'NOT_READY', readiness: { ready: false, blockers: [] } }, sections: {} }
  vi.mocked(api.getVendorOnboarding).mockImplementation(async () => snapshot)
  vi.mocked(api.dismissVendorWelcome).mockImplementation(async () => { snapshot = { ...snapshot, welcomeRequired: false }; return snapshot })
  vi.mocked(api.saveVendorVerificationDraft).mockImplementation(async () => snapshot)
  vi.mocked(api.saveVendorSetupDraft).mockImplementation(async () => snapshot)
  vi.mocked(api.submitVendorVerification).mockImplementation(async () => snapshot)
  vi.mocked(api.completeVendorSetup).mockImplementation(async () => snapshot)
  vi.mocked(api.getVendorPrivateFileUrl).mockImplementation(async fileId => ({ url: `https://example.test/private/${fileId}`, expiresAt: new Date() }))
})
function open(path: string) {
  return render(<MemoryRouter initialEntries={[path]}><Routes><Route path="/entry" element={<VendorEntryPage />} /><Route path="/welcome" element={<VendorWelcomePage />} /><Route path="/dashboard" element={<VendorDashboardPage />} /><Route path="/onboarding/verification" element={<VendorVerificationPage />} /><Route path="/onboarding/setup" element={<VendorSetupPage />} /><Route path="/store-profile" element={<VendorStoreProfilePage />} /><Route path="/settings" element={<h1>Personal account settings</h1>} /></Routes></MemoryRouter>)
}

test('onboarding is standalone without dashboard navigation', async () => {
  open('/onboarding/verification')
  expect(await screen.findByRole('heading', { name: 'Store Verification', level: 1 })).toBeVisible()
  expect(screen.queryByLabelText('VENDOR PORTAL navigation')).not.toBeInTheDocument()
})

test('one Store Email field handles change, verification and draft saves', async () => {
  snapshot.organization = { ...snapshot.organization, store_email: 'verified@example.test', store_email_verified: true }
  vi.mocked(api.requestStoreEmailVerification).mockResolvedValue({ sent: true, expires_at: '2026-09-21T08:00:00Z' })
  vi.mocked(api.confirmStoreEmailVerification).mockImplementation(async ({ email }) => {
    snapshot = { ...snapshot, organization: { ...snapshot.organization, store_email: email, store_email_verified: true, lock_version: 2 } }
    return snapshot
  })
  open('/onboarding/verification')
  const email = await screen.findByRole('textbox', { name: 'Store email' })
  const contacts = screen.getByRole('region', { name: 'Store contact information' })
  expect(email).toHaveAttribute('readonly')
  expect(screen.queryByLabelText('Email to verify')).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Send Code' })).not.toBeInTheDocument()
  expect(within(contacts).getByText('Verified', { exact: true })).toBeVisible()
  fireEvent.click(screen.getByRole('button', { name: 'Change' }))
  expect(email).not.toHaveAttribute('readonly')
  expect(email).toHaveFocus()
  fireEvent.change(email, { target: { value: 'replacement@example.test' } })
  expect(within(contacts).queryByText('Verified', { exact: true })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Send Code' }))
  await screen.findByRole('textbox', { name: 'Six-digit code' })
  expect(api.requestStoreEmailVerification).toHaveBeenCalledWith('replacement@example.test')
  fireEvent.change(screen.getByRole('textbox', { name: 'Six-digit code' }), { target: { value: '123456' } })
  fireEvent.click(screen.getByRole('button', { name: 'Confirm email' }))
  await waitFor(() => expect(email).toHaveAttribute('readonly'))
  expect(api.confirmStoreEmailVerification).toHaveBeenCalledWith({ email: 'replacement@example.test', code: '123456' })
  expect(within(contacts).getByText('Verified', { exact: true })).toBeVisible()
  expect(screen.getByRole('button', { name: 'Change' })).toBeVisible()
  expect(screen.queryByRole('textbox', { name: 'Six-digit code' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Save verification draft' }))
  await waitFor(() => expect(api.saveVendorVerificationDraft).toHaveBeenCalledWith(expect.objectContaining({ storeEmail: 'replacement@example.test', lockVersion: 2 })))
  fireEvent.click(screen.getByRole('button', { name: 'Change' }))
  fireEvent.change(email, { target: { value: 'another@example.test' } })
  expect(within(contacts).queryByText('Verified', { exact: true })).not.toBeInTheDocument()
})

test('pending replacements never inherit verification and changing the email clears its code challenge', async () => {
  snapshot.organization = { ...snapshot.organization, store_email: 'verified@example.test', store_email_verified: true, pending_store_email: 'pending@example.test' }
  vi.mocked(api.requestStoreEmailVerification).mockResolvedValue({ sent: true })
  open('/onboarding/verification')
  const email = await screen.findByRole('textbox', { name: 'Store email' })
  expect(email).toHaveValue('verified@example.test')
  expect(email).toHaveAttribute('readonly')
  expect(screen.getByText('Verified', { exact: true })).toBeVisible()
  fireEvent.click(screen.getByRole('button', { name: 'Change' }))
  fireEvent.change(email, { target: { value: 'pending@example.test' } })
  expect(screen.queryByText('Verified', { exact: true })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Send Code' }))
  await screen.findByRole('textbox', { name: 'Six-digit code' })
  fireEvent.change(email, { target: { value: 'different@example.test' } })
  expect(screen.queryByRole('textbox', { name: 'Six-digit code' })).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Confirm email' })).not.toBeInTheDocument()
  expect(api.confirmStoreEmailVerification).not.toHaveBeenCalled()
  fireEvent.click(screen.getByRole('button', { name: 'Save verification draft' }))
  await waitFor(() => expect(api.saveVendorVerificationDraft).toHaveBeenCalledWith(expect.objectContaining({ storeEmail: 'different@example.test' })))
})

test('failed code requests and confirmations leave the replacement unverified and recoverable', async () => {
  snapshot.organization = { ...snapshot.organization, store_email: 'verified@example.test', store_email_verified: true }
  vi.mocked(api.requestStoreEmailVerification).mockRejectedValueOnce(new TypeError('Network unavailable')).mockResolvedValue({ sent: true })
  vi.mocked(api.confirmStoreEmailVerification).mockRejectedValueOnce(new TypeError('Invalid or expired code'))
  open('/onboarding/verification')
  const email = await screen.findByRole('textbox', { name: 'Store email' })
  fireEvent.click(screen.getByRole('button', { name: 'Change' }))
  fireEvent.change(email, { target: { value: 'replacement@example.test' } })
  fireEvent.click(screen.getByRole('button', { name: 'Send Code' }))
  await screen.findByRole('alert')
  expect(screen.queryByRole('textbox', { name: 'Six-digit code' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Send Code' }))
  fireEvent.change(await screen.findByRole('textbox', { name: 'Six-digit code' }), { target: { value: '123456' } })
  fireEvent.click(screen.getByRole('button', { name: 'Confirm email' }))
  await screen.findByRole('alert')
  expect(email).not.toHaveAttribute('readonly')
  expect(email).toHaveValue('replacement@example.test')
  expect(screen.queryByText('Verified', { exact: true })).not.toBeInTheDocument()
  expect(snapshot.organization.store_email).toBe('verified@example.test')
  expect(screen.getByRole('button', { name: 'Send Code' })).toBeEnabled()
})

test('activated dashboard changes sections without showing onboarding forms', async () => {
  snapshot.activation.status = 'ACTIVE'
  open('/dashboard')
  fireEvent.click(await screen.findByRole('button', { name: 'Sales & Revenue' }))
  expect(screen.getByText('Average order value')).toBeVisible()
  expect(screen.queryByText('Quality summary')).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Save verification draft' })).not.toBeInTheDocument()
})
test('first login persists Continue then permits later login to resume onboarding', async () => {
  snapshot.welcomeRequired = true
  open('/entry')
  fireEvent.click(await screen.findByRole('button', { name: 'Continue' }))
  await waitFor(() => expect(api.dismissVendorWelcome).toHaveBeenCalledOnce())
  expect(await screen.findByRole('heading', { level: 1, name: 'Store Verification' })).toBeVisible()
  expect(vendorLoginDestination(snapshot)).toBe('/onboarding/verification')
})
test('Finish Later saves each standalone onboarding form before returning to limited dashboard', async () => {
  open('/onboarding/verification')
  fireEvent.click(await screen.findByRole('button', { name: 'Finish Later' }))
  expect(await screen.findByText('Limited-Access Vendor Dashboard')).toBeVisible()
  fireEvent.click(screen.getByRole('link', { name: 'Continue Store Setup' }))
  expect(await screen.findByRole('heading', { level: 1, name: 'Store Setup' })).toBeVisible()
  expect(api.saveVendorVerificationDraft).toHaveBeenCalledOnce()
  fireEvent.click(screen.getByRole('button', { name: 'Finish Later' }))
  expect(await screen.findByText('Limited-Access Vendor Dashboard')).toBeVisible()
  expect(api.saveVendorSetupDraft).toHaveBeenCalledOnce()
  expect(vi.mocked(api.saveVendorSetupDraft).mock.calls[0]?.[0]).not.toHaveProperty('fulfillmentMethod')
})
test('Store Profile is separate and logo returns to the authenticated dashboard', async () => {
  snapshot.activation.status = 'ACTIVE'
  open('/dashboard')
  fireEvent.click(await screen.findByRole('link', { name: 'Store Profile' }))
  expect(await screen.findByRole('heading', { level: 1, name: 'Test Supply' })).toBeVisible()
  fireEvent.click(screen.getByRole('link', { name: /MateryalPH VENDOR PORTAL/ }))
  expect(await screen.findByRole('heading', { name: 'Dashboard' })).toBeVisible()
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

test('Finish Later does not leave the form when saving fails', async () => {
  vi.mocked(api.saveVendorVerificationDraft).mockRejectedValueOnce(new TypeError('Network unavailable'))
  open('/onboarding/verification')
  fireEvent.click(await screen.findByRole('button', { name: 'Finish Later' }))
  await waitFor(() => expect(api.saveVendorVerificationDraft).toHaveBeenCalledOnce())
  expect(await screen.findByRole('alert')).toBeVisible()
  expect(screen.getByRole('heading', { level: 1, name: 'Store Verification' })).toBeVisible()
  expect(screen.queryByRole('heading', { level: 1, name: 'Store Setup' })).not.toBeInTheDocument()
})


test('limited dashboard retains both workstreams without extra next-step content', async () => {
  open('/dashboard')
  expect(await screen.findByText('Limited-Access Vendor Dashboard')).toBeVisible()
  expect(screen.getByRole('link', { name: /Continue Store Verification/ })).toBeVisible()
  expect(screen.getByRole('link', { name: 'Continue Store Setup' })).toBeVisible()
  for (const label of ['What happens next', 'Keep both tracks moving.', 'Invite fixed-role teammates']) expect(screen.queryByText(label)).not.toBeInTheDocument()
  expect(document.querySelector('aside details')).toBeNull()
  expect(screen.getByRole('link', { name: 'Dashboard' })).toHaveAttribute('aria-current', 'page')
})

test('verification shows one step, retains draft fields and adapts legal identity before saving', async () => {
  open('/onboarding/verification')
  const businessType = await screen.findByRole('combobox', { name: 'Business type' })
  expect(screen.queryByRole('textbox', { name: 'Company registered name' })).not.toBeInTheDocument()
  expect(screen.getByRole('heading', { name: 'Private evidence' })).toBeVisible()
  fireEvent.change(businessType, { target: { value: 'ONE_PERSON_CORPORATION' } })
  fireEvent.change(screen.getByRole('textbox', { name: 'Company registered name' }), { target: { value: 'Draft Supply' } })
  expect(screen.getByRole('textbox', { name: 'Surname' })).toBeVisible()
  expect(screen.getByRole('combobox', { name: 'Business type' })).toBeVisible()
  fireEvent.click(screen.getByRole('button', { name: '2 Registered Business Address' }))
  fireEvent.change(screen.getByRole('textbox', { name: 'Street' }), { target: { value: 'Sample Street' } })
  expect(screen.queryByRole('textbox', { name: 'Company registered name' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Back' }))
  expect(screen.getByRole('textbox', { name: 'Company registered name' })).toHaveValue('Draft Supply')
  fireEvent.click(screen.getByRole('button', { name: 'Save verification draft' }))
  await waitFor(() => expect(api.saveVendorVerificationDraft).toHaveBeenCalledWith(expect.objectContaining({ businessType: 'ONE_PERSON_CORPORATION', legalIdentity: expect.objectContaining({ companyRegisteredName: 'Draft Supply' }), address: expect.objectContaining({ street: 'Sample Street' }) })))
})

test('combined privacy and review preserves explicit acknowledgement across navigation', async () => {
  open('/onboarding/verification')
  fireEvent.click(await screen.findByRole('button', { name: '4 Privacy, Review and Submit' }))
  fireEvent.click(screen.getByRole('checkbox', { name: /I acknowledge the current Privacy Notice/ }))
  expect(screen.getByRole('button', { name: 'Submit Store Verification' })).toBeVisible()
  fireEvent.click(screen.getByRole('button', { name: 'Back' }))
  fireEvent.click(screen.getByRole('button', { name: 'Next' }))
  expect(screen.getByRole('checkbox', { name: /I acknowledge/ })).toBeChecked()
  fireEvent.click(screen.getByRole('button', { name: 'Submit Store Verification' }))
  await waitFor(() => expect(api.submitVendorVerification).toHaveBeenCalledWith({ lockVersion: 1, privacyAcknowledged: true }))
})

test('setup preview updates public content and keeps private contact details out', async () => {
  snapshot.verification = { status: 'IN_PROGRESS', contacts: [{ full_name: 'Private Owner', email: 'private@example.test', phone: 'private-phone' }], address: { city_municipality: 'Sample City', province: 'Sample Province' } }
  open('/onboarding/setup')
  const preview = await screen.findByRole('complementary', { name: 'Store Profile Preview' })
  fireEvent.change(screen.getByRole('textbox', { name: 'Public store name' }), { target: { value: 'New Store' } })
  fireEvent.change(screen.getByRole('textbox', { name: 'Store description' }), { target: { value: 'Materials for your next project.' } })
  fireEvent.change(screen.getByRole('textbox', { name: 'Public email' }), { target: { value: 'public@example.test' } })
  expect(within(preview).getByRole('heading', { name: 'New Store' })).toBeVisible()
  expect(preview).toHaveTextContent('Materials for your next project.')
  expect(preview).toHaveTextContent('public@example.test')
  expect(preview).toHaveTextContent('Sample City, Sample Province')
  expect(preview).not.toHaveTextContent('private@example.test')
  expect(preview).not.toHaveTextContent('Private Owner')
  fireEvent.click(screen.getByRole('button', { name: '2 Fulfillment Configuration' }))
  expect(preview).not.toBeVisible()
  expect(screen.queryByRole('textbox', { name: 'Public store name' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('radio', { name: 'Not currently' }))
  fireEvent.click(screen.getByRole('button', { name: '1 Public Store Profile' }))
  expect(screen.getByRole('textbox', { name: 'Public store name' })).toHaveValue('New Store')
  fireEvent.click(screen.getByRole('button', { name: 'Save setup draft' }))
  await waitFor(() => expect(api.saveVendorSetupDraft).toHaveBeenCalledWith(expect.objectContaining({ publicStoreName: 'New Store', description: 'Materials for your next project.', bulkCapability: false, publicEmail: 'public@example.test' })))
})

test('media uploads refresh the profile preview without losing edited public fields', async () => {
  vi.mocked(api.uploadVendorMedia).mockImplementation(async () => {
    snapshot = { ...snapshot, setup: { ...snapshot.setup, media: [{ kind: 'BANNER', file_id: 'banner-file', alt_text: 'Store banner' }] } }
    return { uploaded: true }
  })
  open('/onboarding/setup')
  fireEvent.change(await screen.findByRole('textbox', { name: 'Public store name' }), { target: { value: 'Unsaved store name' } })
  const inputs = screen.getAllByLabelText('Upload image')
  fireEvent.change(inputs[1]!, { target: { files: [new File(['fixture'], 'banner.png', { type: 'image/png' })] } })
  await waitFor(() => expect(api.getVendorPrivateFileUrl).toHaveBeenCalledWith('banner-file'))
  fireEvent.click(screen.getByRole('button', { name: '1 Public Store Profile' }))
  const preview = screen.getByRole('complementary', { name: 'Store Profile Preview' })
  expect(within(preview).getByRole('img', { name: 'Store banner' })).toHaveAttribute('src', 'https://example.test/private/banner-file')
  expect(screen.getByRole('textbox', { name: 'Public store name' })).toHaveValue('Unsaved store name')
  fireEvent.error(within(preview).getByRole('img', { name: 'Store banner' }))
  expect(within(preview).queryByRole('img')).not.toBeInTheDocument()
  expect(within(preview).getByRole('button', { name: 'Reload banner' })).toBeVisible()
})

test('review requires unsaved edits to be saved, retains terms, and does not unlock Team Accounts', async () => {
  open('/onboarding/setup')
  fireEvent.change(await screen.findByRole('textbox', { name: 'Public store name' }), { target: { value: 'Draft name' } })
  fireEvent.click(screen.getByRole('button', { name: '4 2% Commission Terms' }))
  fireEvent.click(screen.getByRole('checkbox', { name: /I accept the current version/ }))
  fireEvent.click(screen.getByRole('button', { name: 'Next' }))
  expect(screen.getByText(/Team Accounts do not block/)).toBeVisible()
  expect(screen.queryByRole('link', { name: 'Manage Team Accounts' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Next' }))
  expect(screen.getByRole('button', { name: 'Complete Store Setup' })).toBeDisabled()
  expect(screen.queryByRole('button', { name: 'Next' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Save setup draft' }))
  await waitFor(() => expect(screen.getByRole('button', { name: 'Complete Store Setup' })).toBeEnabled())
  fireEvent.click(screen.getByRole('button', { name: 'Complete Store Setup' }))
  await waitFor(() => expect(api.completeVendorSetup).toHaveBeenCalledWith({ organizationLockVersion: 1, commissionTermsAccepted: true }))
})

test('visited sections are not represented as completed without server confirmation', async () => {
  snapshot.sections.STORE_SETUP = { key: 'STORE_SETUP', label: 'Store Setup', status: 'IN_PROGRESS', complete: 1, total: 6, progress: { complete: 1, total: 6 }, steps: [{ id: 'profile-step', lockVersion: 1, key: 'public_store_profile', label: 'Public store profile', level: 'REQUIRED', status: 'COMPLETED' }, { id: 'media-step', lockVersion: 1, key: 'store_media', label: 'Store media', level: 'OPTIONAL', status: 'COMPLETED' }] }
  open('/onboarding/setup')
  const nav = await screen.findByRole('navigation', { name: 'Store Setup steps' })
  expect(within(nav).getByRole('button', { name: /Completed, Public Store Profile/ })).toHaveAttribute('aria-current', 'step')
  fireEvent.click(within(nav).getByRole('button', { name: '2 Fulfillment Configuration' }))
  fireEvent.click(screen.getByRole('button', { name: 'Next' }))
  expect(within(nav).getByRole('button', { name: '2 Fulfillment Configuration' })).not.toHaveTextContent('Completed')
})


test('tax is combined with business information and Head Office respects the branch representation', async () => {
  open('/onboarding/verification')
  await screen.findByRole('combobox', { name: 'Business type' })
  expect(screen.queryByRole('button', { name: /Tax Profile/ })).not.toBeInTheDocument()
  expect(screen.getByLabelText('Core TIN')).toBeVisible()
  expect(screen.getByLabelText('Core TIN')).toHaveAttribute('maxLength', '9')
  fireEvent.change(screen.getByRole('combobox', { name: 'Taxpayer location' }), { target: { value: 'HEAD_OFFICE' } })
  expect(screen.getByLabelText('Branch Code')).toHaveValue('00000')
  fireEvent.change(screen.getByRole('combobox', { name: 'Branch code representation' }), { target: { value: '3' } })
  expect(screen.getByLabelText('Branch Code')).toHaveValue('000')
  expect(screen.queryByLabelText('Declaration taxable year')).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('radio', { name: 'Yes' }))
  expect(screen.getByLabelText('Declaration taxable year')).toBeVisible()
})
