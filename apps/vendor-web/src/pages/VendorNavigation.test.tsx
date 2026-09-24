import { DocumentUploadField } from '@materyalph/web-ui'
import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import { VendorDashboardPage, VendorWelcomePage, VendorVerificationPage, VendorSetupPage, VendorStoreProfilePage } from './PhaseThreeVendorPages'
import { VendorEntryPage } from './VendorEntryPage'
import * as api from '../lib/onboarding-api'
import { ResponseError } from '@materyalph/api-client-ts'
import { vendorLoginDestination } from '../lib/vendor-destination'

vi.mock('../lib/onboarding-api', async original => ({ ...await original<typeof import('../lib/onboarding-api')>(), getVendorOnboarding: vi.fn(), previewVendorRequirements: vi.fn(), dismissVendorWelcome: vi.fn(), saveVendorVerificationDraft: vi.fn(), saveVendorSetupDraft: vi.fn(), submitVendorVerification: vi.fn(), completeVendorSetup: vi.fn(), getVendorPrivateFileUrl: vi.fn(), uploadVendorMedia: vi.fn(), uploadVendorDocument: vi.fn(), removePendingVendorDocument: vi.fn(), requestStoreEmailVerification: vi.fn(), confirmStoreEmailVerification: vi.fn() }))
let snapshot: api.VendorOnboardingSnapshot
beforeEach(() => {
  vi.clearAllMocks()
  vi.mocked(api.previewVendorRequirements).mockResolvedValue({})
  snapshot = { stepCompletion: [], lockVersion: 1, requirements: [], drafts: [], organization: { store_name: 'Test Supply', lock_version: 1 }, welcomeRequired: false, permissions: ['vendor.onboarding.manage', 'vendor.onboarding.submit'], verification: { privacy_notice: { version: 2, content: 'Sample Privacy Notice for this test.' }, status: 'NOT_STARTED' }, setup: { status: 'NOT_STARTED' }, activation: { status: 'NOT_READY', marketplaceDiscoverabilityStatus: 'NOT_DISCOVERABLE', readiness: { ready: false, blockers: [], status: 'NOT_READY', ruleVersion: 'phase3a.v1' } }, sections: {} }
  vi.mocked(api.getVendorOnboarding).mockImplementation(async () => snapshot)
  vi.mocked(api.dismissVendorWelcome).mockImplementation(async () => { snapshot = { ...snapshot, welcomeRequired: false }; return snapshot })
  vi.mocked(api.saveVendorVerificationDraft).mockImplementation(async () => snapshot)
  vi.mocked(api.removePendingVendorDocument).mockImplementation(async () => snapshot)
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
  expect(screen.queryByText('Primary Business Contact')).not.toBeInTheDocument()
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
  fireEvent.click(screen.getByRole('button', { name: '1 Business Information' }))
  await waitFor(() => expect(api.saveVendorVerificationDraft).toHaveBeenCalledWith(expect.objectContaining({ formState: expect.stringContaining('replacement@example.test'), lockVersion: 2 })))
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
  fireEvent.click(screen.getByRole('button', { name: '1 Business Information' }))
  await waitFor(() => expect(api.saveVendorVerificationDraft).toHaveBeenCalledWith(expect.objectContaining({ formState: expect.stringContaining('different@example.test') })))
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
  await screen.findByRole('radio', { name: 'One Person Corporation (OPC)' })
  expect(screen.queryByRole('textbox', { name: 'Company registered name' })).not.toBeInTheDocument()
  expect(screen.getByRole('group', { name: 'Business and Compliance Evidence' })).toBeVisible()
  fireEvent.click(screen.getByRole('radio', { name: 'One Person Corporation (OPC)' }))
  fireEvent.change(screen.getByRole('textbox', { name: 'Company registered name' }), { target: { value: 'Draft Supply' } })
  expect(screen.getByRole('textbox', { name: 'Surname' })).toBeVisible()
  expect(screen.getByRole('radio', { name: 'One Person Corporation (OPC)' })).toBeVisible()
  fireEvent.click(screen.getByRole('button', { name: '2 Registered Business Address' }))
  expect(await screen.findByRole('textbox', { name: 'Detailed Address' })).toBeVisible()
  expect(screen.queryByLabelText('Latitude')).not.toBeInTheDocument()
  expect(screen.queryByLabelText('Longitude')).not.toBeInTheDocument()
  expect(screen.queryByRole('textbox', { name: 'Company registered name' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Back' }))
  expect(await screen.findByRole('textbox', { name: 'Company registered name' })).toHaveValue('Draft Supply')
  await waitFor(() => expect(screen.queryByText('Updating applicable requirements…')).not.toBeInTheDocument())
  fireEvent.click(screen.getByRole('button', { name: '1 Business Information' }))
  await waitFor(() => expect(api.saveVendorVerificationDraft).toHaveBeenCalledWith(expect.objectContaining({ formState: expect.stringContaining('Draft Supply') })))
})

test('combined privacy and review preserves explicit acknowledgement across navigation', async () => {
  open('/onboarding/verification')
  fireEvent.click(await screen.findByRole('button', { name: '4 Privacy, Review and Submit' }))
  const checklist = await screen.findByRole('region', { name: 'Verification checklist' })
  const privacyNotice = screen.getByRole('region', { name: 'Privacy Notice' })
  expect(checklist.compareDocumentPosition(privacyNotice) & Node.DOCUMENT_POSITION_FOLLOWING).toBeTruthy()
  fireEvent.click(screen.getByRole('checkbox', { name: /I acknowledge the current Privacy Notice/ }))
  expect(screen.getByRole('button', { name: 'Submit for Admin Review' })).toBeVisible()
  fireEvent.click(screen.getByRole('button', { name: 'Back' }))
  await screen.findByRole('heading', { name: 'Supplier Type / Classification' })
  fireEvent.click(screen.getByRole('button', { name: 'Next' }))
  expect(await screen.findByRole('checkbox', { name: /I acknowledge/ })).toBeChecked()
  fireEvent.click(screen.getByRole('button', { name: 'Submit for Admin Review' }))
  expect(await screen.findByText('Please correct the highlighted fields.')).toBeVisible()
  expect(api.submitVendorVerification).not.toHaveBeenCalled()
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

test('setup review requires saved edits, does not collect commission consent, and does not unlock Team Accounts', async () => {
  open('/onboarding/setup')
  fireEvent.change(await screen.findByRole('textbox', { name: 'Public store name' }), { target: { value: 'Draft name' } })
  expect(screen.queryByRole('button', { name: /Commission Terms/ })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: '4 Team Accounts' }))
  expect(screen.getByText(/Team Accounts do not block/)).toBeVisible()
  expect(screen.queryByRole('link', { name: 'Manage Team Accounts' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Next' }))
  expect(screen.getByRole('button', { name: 'Complete Store Setup' })).toBeDisabled()
  expect(screen.queryByRole('button', { name: 'Next' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Save setup draft' }))
  await waitFor(() => expect(screen.getByRole('button', { name: 'Complete Store Setup' })).toBeEnabled())
  fireEvent.click(screen.getByRole('button', { name: 'Complete Store Setup' }))
  await waitFor(() => expect(api.completeVendorSetup).toHaveBeenCalledWith({ organizationLockVersion: 1 }))
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


test('tax uses one combined TIN with VAT radio choices and no office controls', async () => {
  open('/onboarding/verification')
  await screen.findByRole('radio', { name: 'One Person Corporation (OPC)' })
  expect(screen.queryByRole('button', { name: /Tax Profile/ })).not.toBeInTheDocument()
  expect(screen.getByLabelText('Taxpayer Identification Number (TIN)')).toBeVisible()
  expect(screen.getByLabelText('Taxpayer Identification Number (TIN)')).toHaveAttribute('pattern', '([0-9]{12,14}|[0-9]{3}-[0-9]{3}-[0-9]{3}-[0-9]{3,5})')
  expect(screen.queryByText('Office & Branch Details')).not.toBeInTheDocument()
  expect(screen.getByRole('radio', { name: 'VAT Registered' })).toBeVisible()
  expect(screen.getByRole('radio', { name: 'Non-VAT Registered' })).toBeVisible()
  expect(screen.queryByLabelText('Declaration taxable year')).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('radio', { name: 'Yes' }))
  expect(screen.getByLabelText('Declaration taxable year')).toBeVisible()
  const declarationPanel = within(screen.getByRole('group', { name: 'Sworn Declaration' }))
  expect(declarationPanel.getByText('PDF, up to 10 MB')).toBeVisible()
  fireEvent.click(screen.getByRole('button', { name: 'Dismiss Sworn Declaration guidance' }))
  expect(declarationPanel.queryByText(/Standard withholding is/)).not.toBeInTheDocument()
  expect(screen.getByLabelText('Declaration taxable year')).toBeVisible()
  fireEvent.click(screen.getByRole('radio', { name: 'No — use applicable standard withholding' }))
  expect(screen.queryByLabelText('Declaration taxable year')).not.toBeInTheDocument()
  expect(declarationPanel.queryByText('PDF, up to 10 MB')).not.toBeInTheDocument()
})


test.each(['Sole Proprietorship', 'Partnership', 'Corporation', 'One Person Corporation (OPC)', 'Cooperative'])('Business Type %s displays only applicable identity fields', async name => {
  open('/onboarding/verification')
  fireEvent.click(await screen.findByRole('radio', { name }))
  expect(screen.queryByRole('textbox', { name: 'Surname' }) !== null).toBe(['Sole Proprietorship', 'One Person Corporation (OPC)'].includes(name))
  expect(screen.queryByRole('textbox', { name: 'Company registered name' }) !== null).toBe(name !== 'Sole Proprietorship')
  await waitFor(() => expect(api.previewVendorRequirements).toHaveBeenCalled())
})

test.each(['12345678', '1234567890', '12345AB89', '123-45678'])('preserves incomplete TIN %s as a draft and validates on submission', async tin => {
  open('/onboarding/verification')
  fireEvent.change(await screen.findByLabelText('Taxpayer Identification Number (TIN)'), { target: { value: tin } })
  fireEvent.click(screen.getByRole('button', { name: '4 Privacy, Review and Submit' }))
  fireEvent.click(await screen.findByRole('checkbox', { name: /I acknowledge/ }))
  fireEvent.click(screen.getByRole('button', { name: 'Submit for Admin Review' }))
  expect((await screen.findAllByText('Enter your 9-digit TIN followed by a 3- to 5-digit branch code (for example, 123-456-789-000).'))[0]).toBeVisible()
  expect(api.saveVendorVerificationDraft).toHaveBeenCalledWith(expect.objectContaining({ formState: expect.stringContaining(tin) }))
  expect(api.submitVendorVerification).not.toHaveBeenCalled()
})

test.each(['123', '1234', '12345'])('autosave retains combined TIN and separate names with concurrency guards for %s', async code => {
  snapshot.organization = { lock_version: 7, store_name: 'Public Supply', business_type: 'CORPORATION' }
  snapshot.drafts = [{ workstream: 'STORE_VERIFICATION', lockVersion: 4 }]
  vi.mocked(api.saveVendorVerificationDraft).mockImplementation(async () => {
    snapshot = { ...snapshot, organization: { ...snapshot.organization, lock_version: 8 }, drafts: [{ workstream: 'STORE_VERIFICATION', lockVersion: 5 }] }
    return snapshot
  })
  open('/onboarding/verification')
  fireEvent.change(await screen.findByLabelText('Taxpayer Identification Number (TIN)'), { target: { value: `123-456-789-${code}` } })
  fireEvent.change(screen.getByRole('textbox', { name: 'Registered Business Name' }), { target: { value: 'Legal Trading Name' } })
  fireEvent.click(screen.getByRole('button', { name: '2 Registered Business Address' }))
  await screen.findByRole('textbox', { name: 'Detailed Address' })
  const saved = vi.mocked(api.saveVendorVerificationDraft).mock.calls[0]![0]
  expect(saved).toMatchObject({ lockVersion: 7, draftLockVersion: 4 })
  expect(JSON.parse(saved.formState!)).toMatchObject({ store_name: ['Public Supply'], legal_business_name: ['Legal Trading Name'], tin: [`123-456-789-${code}`] })
  fireEvent.click(screen.getByRole('button', { name: 'Back' }))
  await waitFor(() => expect(api.saveVendorVerificationDraft).toHaveBeenLastCalledWith(expect.objectContaining({ lockVersion: 8, draftLockVersion: 5 })))
})

test.each(['RESOURCE_VERSION_CONFLICT', 'STALE_VERSION'])('renders %s as the same recoverable conflict', async code => {
  vi.mocked(api.saveVendorVerificationDraft).mockRejectedValue(new ResponseError(new Response(JSON.stringify({ errors: [{ code, message: 'Backend detail' }] }), { status: 409 })))
  open('/onboarding/verification')
  fireEvent.change(await screen.findByRole('textbox', { name: 'Public Store Name' }), { target: { value: 'Keep my edits' } })
  fireEvent.click(screen.getByRole('button', { name: '1 Business Information' }))
  expect(await screen.findByText('This draft changed in another session. Reload the latest version before saving again. Your unsaved edits are still on this page.')).toBeVisible()
  expect(screen.getByRole('textbox', { name: 'Public Store Name' })).toHaveValue('Keep my edits')
})

test.each(['EMPLOYEE', 'ACCOUNTANT', 'OTHER', 'OFFICER'])('authority is separate unless accepted officer records exist: %s', async role => {
  snapshot.organization = { ...snapshot.organization, business_type: 'CORPORATION' }
  snapshot.verification = { ...snapshot.verification, documents: [{ id: 'accepted-registration', requirement_key: 'business_registration', status: 'APPROVED', original_name: 'registration.pdf' }] }
  open('/onboarding/verification')
  fireEvent.change(await screen.findByLabelText('Relationship to the business'), { target: { value: role } })
  expect(screen.queryByRole('checkbox', { name: 'Use accepted registration evidence for this officer' }) !== null).toBe(role === 'OFFICER')
  if (role === 'OFFICER') {
    fireEvent.click(screen.getByRole('checkbox', { name: 'Use accepted registration evidence for this officer' }))
    expect(screen.getByLabelText(/Accepted registration evidence/)).toBeVisible()
  }
})


test('government ID details appear only after selecting a type with applicable sides', async () => {
  open('/onboarding/verification')
  fireEvent.click(await screen.findByRole('radio', { name: 'Sole Proprietorship' }))
  expect(screen.queryByLabelText('Government ID number')).not.toBeInTheDocument()
  expect(screen.queryByLabelText('Select Government ID — front')).not.toBeInTheDocument()
  fireEvent.change(screen.getByRole('combobox', { name: 'Government ID type' }), { target: { value: 'NATIONAL_ID' } })
  expect(screen.getByLabelText('Government ID number')).toHaveAttribute('placeholder', 'Enter your national id number')
  expect(screen.getByLabelText('Select Government ID — front')).toBeInTheDocument()
  expect(screen.getByLabelText('Select Government ID — back')).toBeInTheDocument()
  fireEvent.change(screen.getByRole('combobox', { name: 'Government ID type' }), { target: { value: 'PASSPORT' } })
  expect(screen.getByLabelText('Select Government ID — front')).toBeInTheDocument()
  expect(screen.queryByLabelText('Select Government ID — back')).not.toBeInTheDocument()
})


test('selection stays pending and can be removed without uploading', () => {
  const onChange = vi.fn()
  const file = new File(['sample'], 'sample.pdf', { type: 'application/pdf' })
  const view = render(<DocumentUploadField label="ID front" name="id_front" file={null} onChange={onChange} />)
  const input = screen.getByLabelText('Select ID front')
  fireEvent.change(input, { target: { files: [file] } })
  expect(onChange).toHaveBeenCalledWith(file)
  view.rerender(<DocumentUploadField label="ID front" name="id_front" file={file} onChange={onChange} />)
  expect(screen.getByText('Pending Submission')).toBeVisible()
  expect(screen.getByRole('button', { name: 'Preview document' })).toBeVisible()
  expect(screen.queryByRole('button', { name: 'Upload reviewed file' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Remove' }))
  expect(onChange).toHaveBeenLastCalledWith(null)
  fireEvent.change(input, { target: { files: [new File(['x'], 'invalid.txt', { type: 'text/plain' })] } })
  expect(screen.getByRole('alert')).toHaveTextContent('Select a non-empty JPG')
})


test.each(['Corporation', 'Cooperative', 'Partnership'])('%s collects government ID only inside the representative section', async businessType => {
  open('/onboarding/verification')
  fireEvent.click(await screen.findByRole('radio', { name: businessType }))
  expect(screen.queryByRole('group', { name: 'Government-Issued Identification' })).not.toBeInTheDocument()
  const representative = within(screen.getByRole('group', { name: 'Authorized Representative / Authorized Signatory' }))
  expect(representative.queryByLabelText('Representative government ID number')).not.toBeInTheDocument()
  expect(screen.queryByLabelText('Select Representative government ID — front')).not.toBeInTheDocument()
  fireEvent.change(representative.getByRole('combobox', { name: 'Representative government ID type' }), { target: { value: 'NATIONAL_ID' } })
  expect(representative.getByLabelText('Representative government ID number')).toHaveAttribute('placeholder', 'Enter your national id number')
  expect(representative.getByLabelText('Select Representative government ID — front')).toBeInTheDocument()
  expect(representative.getByLabelText('Select Representative government ID — back')).toBeInTheDocument()
  expect(screen.getAllByLabelText('Select Representative government ID — front')).toHaveLength(1)
  expect(representative.getAllByText('JPG, JPEG, PNG or PDF, up to 10 MB')).toHaveLength(2)
  fireEvent.change(representative.getByRole('combobox', { name: 'Representative government ID type' }), { target: { value: 'PASSPORT' } })
  expect(representative.getByLabelText('Select Representative government ID — front')).toBeInTheDocument()
  expect(representative.queryByLabelText('Select Representative government ID — back')).not.toBeInTheDocument()
  fireEvent.change(representative.getByRole('combobox', { name: 'Representative government ID type' }), { target: { value: '' } })
  expect(representative.queryByLabelText('Representative government ID number')).not.toBeInTheDocument()
  expect(representative.queryByLabelText('Select Representative government ID — front')).not.toBeInTheDocument()
})


test('authority date, scopes and review upload appear after selecting the document type', async () => {
  open('/onboarding/verification')
  fireEvent.click(await screen.findByRole('radio', { name: 'Corporation' }))
  const authority = within(screen.getByRole('group', { name: 'Authority to Act for the Organization' }))
  expect(authority.queryByLabelText('Authority document date')).not.toBeInTheDocument()
  expect(authority.queryByRole('group', { name: 'Requested authority scopes' })).not.toBeInTheDocument()
  expect(screen.queryByLabelText('Select Authority to Act for the Organization')).not.toBeInTheDocument()
  fireEvent.change(authority.getByRole('combobox', { name: 'Authority document type' }), { target: { value: 'BOARD_RESOLUTION' } })
  expect(authority.getByLabelText('Authority document date')).toBeVisible()
  expect(authority.getByRole('group', { name: 'Requested authority scopes' })).toBeVisible()
  expect(authority.getByText('JPG, JPEG, PNG or PDF, up to 10 MB')).toBeVisible()
  fireEvent.change(authority.getByRole('combobox', { name: 'Authority document type' }), { target: { value: '' } })
  expect(authority.queryByLabelText('Authority document date')).not.toBeInTheDocument()
  expect(authority.queryByRole('group', { name: 'Requested authority scopes' })).not.toBeInTheDocument()
  expect(authority.queryByText('JPG, JPEG, PNG or PDF, up to 10 MB')).not.toBeInTheDocument()
})


test('verification review combines identity evidence and omits inactive and optional checklist items', async () => {
  snapshot.sections.STORE_VERIFICATION = {
    key: 'STORE_VERIFICATION', label: 'Store Verification', status: 'IN_PROGRESS', complete: 0, total: 1, progress: { complete: 0, total: 1 },
    steps: [
      { id: 'inactive', lockVersion: 1, key: 'representative_identity', label: 'Inactive representative evidence', level: 'CONDITIONALLY_REQUIRED', status: 'NOT_APPLICABLE' },
      { id: 'active', lockVersion: 1, key: 'identity_evidence', label: 'Applicable identity evidence', level: 'CONDITIONALLY_REQUIRED', status: 'IN_PROGRESS' },
      { id: 'optional', lockVersion: 1, key: 'optional_certification', label: 'Optional certification', level: 'OPTIONAL', status: 'NOT_STARTED' },
    ],
  }
  open('/onboarding/verification')
  fireEvent.click(await screen.findByRole('button', { name: '4 Privacy, Review and Submit' }))
  const checklist = within(await screen.findByRole('region', { name: 'Verification checklist' }))
  expect(checklist.queryByText('Inactive representative evidence')).not.toBeInTheDocument()
  expect(checklist.getByText('Government ID — Registered legal identity')).toBeVisible()
  expect(checklist.queryByText('Optional certification')).not.toBeInTheDocument()
  fireEvent.click(checklist.getByRole('button', { name: 'Review Government ID — Registered legal identity' }))
  await waitFor(() => expect(screen.getByRole('heading', { name: /^Business Information$/ })).toHaveFocus())
})


test('representative file survives a failed automatic save and is staged on retry', async () => {
  snapshot.organization = { ...snapshot.organization, business_type: 'CORPORATION' }
  vi.mocked(api.saveVendorVerificationDraft).mockRejectedValueOnce(new TypeError('Network unavailable')).mockImplementation(async () => snapshot)
  open('/onboarding/verification')
  fireEvent.change(await screen.findByRole('textbox', { name: 'Representative full legal name' }), { target: { value: 'Test Representative' } })
  fireEvent.change(screen.getByRole('combobox', { name: 'Representative government ID type' }), { target: { value: 'PASSPORT' } })
  const input = await screen.findByLabelText('Select Representative government ID — front')
  const file = new File(['fictional test'], 'representative.pdf', { type: 'application/pdf' })
  fireEvent.change(input, { target: { files: [file] } })
  expect(api.uploadVendorDocument).not.toHaveBeenCalled()
  fireEvent.click(screen.getByRole('button', { name: '2 Registered Business Address' }))
  await screen.findByRole('alert')
  expect(screen.getByText(/representative.pdf/)).toBeVisible()
  expect(screen.getByRole('textbox', { name: 'Representative full legal name' })).toHaveValue('Test Representative')
  fireEvent.click(screen.getByRole('button', { name: '2 Registered Business Address' }))
  await waitFor(() => expect(api.uploadVendorDocument).toHaveBeenCalledWith('representative_identity', file))
  await screen.findByRole('textbox', { name: 'Detailed Address' })
  expect(api.submitVendorVerification).not.toHaveBeenCalled()
})


test('reopening partial progress restores draft email and hides sole proprietor business name', async () => {
  snapshot.organization = { ...snapshot.organization, store_email: 'verified@example.test', store_email_verified: true }
  snapshot.verification = { ...snapshot.verification, form_state: { business_type: ['SOLE_PROPRIETORSHIP'], individual_first_name: ['Saved'], store_email: ['draft@example.test'] } }
  open('/onboarding/verification')
  expect(await screen.findByRole('textbox', { name: 'First name' })).toHaveValue('Saved')
  const email = screen.getByRole('textbox', { name: 'Store email' })
  expect(email).toHaveValue('draft@example.test')
  expect(email).not.toHaveAttribute('readonly')
  expect(within(screen.getByRole('region', { name: 'Store contact information' })).queryByText('Verified')).not.toBeInTheDocument()
  expect(screen.queryByRole('textbox', { name: 'Registered Business Name' })).not.toBeInTheDocument()
})

test('pending selection survives a failed upload and Finish Later succeeds on retry', async () => {
  vi.mocked(api.uploadVendorDocument).mockRejectedValueOnce(new TypeError('Network unavailable')).mockResolvedValue({ id: 'pending' } as never)
  open('/onboarding/verification')
  const input = await screen.findByLabelText('Select Business Registration')
  const file = new File(['test image'], 'document.png', { type: 'image/png' })
  fireEvent.change(input, { target: { files: [file] } })
  expect(api.uploadVendorDocument).not.toHaveBeenCalled()
  fireEvent.click(screen.getByRole('button', { name: 'Finish Later' }))
  await waitFor(() => expect(api.uploadVendorDocument).toHaveBeenCalledWith('business_registration', file))
  expect(await screen.findByText('Please correct the highlighted fields.')).toBeVisible()
  expect(screen.getByText(/document.png/)).toBeVisible()
  expect(screen.getByRole('heading', { name: 'Store Verification', level: 1 })).toBeVisible()
  fireEvent.click(screen.getByRole('button', { name: 'Finish Later' }))
  expect(await screen.findByRole('heading', { name: /Welcome back/ })).toBeVisible()
  expect(api.submitVendorVerification).not.toHaveBeenCalled()
})

test('removing saved pending evidence hides it immediately while deletion is in flight', async () => {
  snapshot.verification = { ...snapshot.verification, pending_documents: [{ requirement_key: 'business_registration', file_id: 'pending', original_name: 'saved.pdf', byte_size: 42 }] }
  let finish!: (value: api.VendorOnboardingSnapshot) => void
  vi.mocked(api.removePendingVendorDocument).mockImplementation(() => new Promise(resolve => { finish = resolve }))
  open('/onboarding/verification')
  expect(await screen.findByText(/saved.pdf/)).toBeVisible()
  fireEvent.click(screen.getByRole('button', { name: 'Remove' }))
  expect(screen.queryByText(/saved.pdf/)).not.toBeInTheDocument()
  expect(api.removePendingVendorDocument).toHaveBeenCalledWith('business_registration')
  finish({ ...snapshot, verification: { ...snapshot.verification, pending_documents: [] } })
  await waitFor(() => expect(screen.getByRole('button', { name: 'Finish Later' })).toBeEnabled())
})

test('Admin correction reason stays with its document and approved evidence cannot be replaced', async () => {
  snapshot.verification = { ...snapshot.verification, status: 'CHANGES_REQUIRED', documents: [
    { requirement_key: 'business_registration', status: 'CHANGES_REQUIRED', version: 1, original_name: 'returned.pdf' },
    { requirement_key: 'lgu_permit', status: 'APPROVED', version: 1, original_name: 'approved.pdf' },
  ] }
  snapshot.sections = { STORE_VERIFICATION: { key: 'STORE_VERIFICATION', label: 'Store Verification', status: 'CHANGES_REQUIRED', complete: 1, total: 2, progress: { complete: 1, total: 2 }, steps: [
    { id: 'registration', lockVersion: 1, key: 'business_registration', label: 'Business Registration', status: 'CHANGES_REQUIRED', level: 'REQUIRED', reason: 'Include every page.' },
    { id: 'permit', lockVersion: 1, key: 'lgu_permit', label: 'LGU Permit', status: 'APPROVED', level: 'REQUIRED' },
  ] } } as api.VendorOnboardingSnapshot['sections']
  open('/onboarding/verification')
  const reason = await screen.findByText('Admin reason: Include every page.')
  expect(reason.parentElement).toContainElement(screen.getByLabelText('Select Business Registration'))
  expect(screen.queryByLabelText('Select LGU Permit')).not.toBeInTheDocument()
  fireEvent.change(screen.getByLabelText('Select Business Registration'), { target: { files: [new File(['pdf'], 'replacement.pdf', { type: 'application/pdf' })] } })
  expect(screen.getByText(/Replacement for version 1/)).toBeVisible()
  expect(screen.getByText(/returned.pdf/)).toBeVisible()
})


test('Submit for Admin Review sends current form data directly with the package after autosave', async () => {
  snapshot.organization = { business_type: 'SOLE_PROPRIETORSHIP', date_established: '2020-01-01', store_name: 'Current Store', store_email: 'store@example.test', store_email_verified: true, store_phone: '+639171234567', lock_version: 7 }
  snapshot.verification = { ...snapshot.verification, classification: { supplier_type: 'RETAIL_HARDWARE_STORE', niches: ['Construction Materials'] }, legal_identity: { surname: 'Owner', first_name: 'Test', id_type: 'PASSPORT' }, address: { street: '123 Test Street', postal_code: '1100', province_code: '1300000000', city_code: '1381300000', psgc_code: '1381300001' } }
  vi.mocked(api.submitVendorVerification).mockImplementation(async () => ({ ...snapshot, verification: { ...snapshot.verification, status: 'PENDING_VERIFICATION' } }))
  open('/onboarding/verification')
  fireEvent.change(await screen.findByRole('textbox', { name: 'Public Store Name' }), { target: { value: 'Latest Store Name' } })
  fireEvent.click(screen.getByRole('button', { name: '4 Privacy, Review and Submit' }))
  fireEvent.click(await screen.findByRole('checkbox', { name: /I acknowledge/ }))
  fireEvent.click(screen.getByRole('button', { name: 'Submit for Admin Review' }))
  await waitFor(() => expect(api.submitVendorVerification).toHaveBeenCalledWith(expect.objectContaining({ lockVersion: 7, privacyAcknowledged: true, draft: expect.objectContaining({ storeName: 'Latest Store Name', businessType: 'SOLE_PROPRIETORSHIP' }) })))
  expect(vi.mocked(api.saveVendorVerificationDraft).mock.calls.every(([request]) => typeof request.formState === 'string')).toBe(true)
  expect(screen.queryByRole('button', { name: 'Save verification draft' })).not.toBeInTheDocument()
  expect(await screen.findByText(/Your Store Verification is awaiting Admin review/)).toBeVisible()
})


test('Back to dashboard automatically preserves incomplete form progress', async () => {
  open('/onboarding/verification')
  fireEvent.change(await screen.findByRole('textbox', { name: 'Public Store Name' }), { target: { value: 'Unfinished Store' } })
  fireEvent.click(screen.getByRole('link', { name: 'Back to dashboard' }))
  expect(await screen.findByRole('heading', { name: /Welcome back/ })).toBeVisible()
  expect(api.saveVendorVerificationDraft).toHaveBeenCalledWith(expect.objectContaining({ formState: expect.stringContaining('Unfinished Store') }))
  expect(api.submitVendorVerification).not.toHaveBeenCalled()
})

test('multiple invalid fields have their own errors and retain the selected document', async () => {
  snapshot.organization = { ...snapshot.organization, business_type: 'SOLE_PROPRIETORSHIP' }
  vi.mocked(api.uploadVendorDocument).mockResolvedValue({ id: 'pending' } as never)
  open('/onboarding/verification')
  const input = await screen.findByLabelText('Select Business Registration')
  fireEvent.change(input, { target: { files: [new File(['image'], 'keep.png', { type: 'image/png' })] } })
  fireEvent.click(screen.getByRole('button', { name: '4 Privacy, Review and Submit' }))
  fireEvent.click(await screen.findByRole('checkbox', { name: /I acknowledge/ }))
  fireEvent.click(screen.getByRole('button', { name: 'Submit for Admin Review' }))
  const surname = await screen.findByRole('textbox', { name: 'Surname' })
  expect(surname).toHaveAttribute('aria-invalid', 'true')
  expect(screen.getByRole('textbox', { name: 'First name' })).toHaveAttribute('aria-invalid', 'true')
  expect(document.getElementById('individual_surname-error')).toHaveTextContent('Please complete this field.')
  expect(document.getElementById('individual_first_name-error')).toHaveTextContent('Please complete this field.')
  expect(screen.getByText(/keep.png/)).toBeVisible()
})


test('an approved Owner-linked authority can attest pending tax information without replacing evidence', async () => {
  snapshot.verification = { ...snapshot.verification, status: 'PENDING_VERIFICATION', representative: { same_as_owner: true }, authority_review: { decision: 'APPROVED', scope: 'TAX_DECLARATIONS' }, tax_profile: { owner_attested: false } }
  snapshot.sections = { STORE_VERIFICATION: { key: 'STORE_VERIFICATION', label: 'Store Verification', status: 'PENDING_VERIFICATION', complete: 1, total: 2, progress: { complete: 1, total: 2 }, steps: [{ id: 'authority', key: 'authority_to_act', label: 'Authority to Act', level: 'REQUIRED', status: 'APPROVED', lockVersion: 1 }] } }
  vi.mocked(api.saveVendorVerificationDraft).mockImplementation(async () => ({ ...snapshot, verification: { ...snapshot.verification, tax_profile: { owner_attested: true } } }))
  open('/onboarding/verification')
  fireEvent.click(await screen.findByRole('button', { name: 'Confirm tax declaration' }))
  await waitFor(() => expect(api.saveVendorVerificationDraft).toHaveBeenCalledWith({ lockVersion: 1, taxProfile: { ownerAttested: true } }))
  await waitFor(() => expect(screen.queryByRole('button', { name: 'Confirm tax declaration' })).not.toBeInTheDocument())
  expect(api.submitVendorVerification).not.toHaveBeenCalled()
  expect(api.uploadVendorDocument).not.toHaveBeenCalled()
})


test('submitted information is read-only but its document previews remain available', async () => {
  snapshot.verification = { ...snapshot.verification, status: 'PENDING_VERIFICATION', documents: [{ requirement_key: 'business_registration', status: 'SUBMITTED', version: 1, original_name: 'submitted.pdf', file_id: 'submitted-file' }] }
  open('/onboarding/verification')
  fireEvent.click(await screen.findByRole('button', { name: 'Review submitted information' }))
  expect(screen.getByRole('textbox', { name: 'Public Store Name' })).toBeDisabled()
  expect(screen.getByRole('button', { name: 'View submitted document' })).toBeEnabled()
  expect(screen.queryByLabelText('Select Business Registration')).not.toBeInTheDocument()
})
