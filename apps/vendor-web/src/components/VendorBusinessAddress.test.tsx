import { fireEvent, render, screen, waitFor } from '@testing-library/react'
import { beforeEach, expect, test, vi } from 'vitest'
import { VendorBusinessAddress } from './VendorBusinessAddress'
import * as api from '../lib/onboarding-api'
vi.mock('../lib/onboarding-api', () => ({ searchAddressAreas: vi.fn(), resolveAddressSelection: vi.fn(), resolveAddressPin: vi.fn(), readableOnboardingError: async () => 'Lookup failed. Retry.' }))
vi.mock('./VendorAddressMapSelector', () => ({ VendorAddressMapSelector: ({ onCoordinatesChange }: { onCoordinatesChange: (point: { latitude: number; longitude: number }) => void }) => <button type="button" onClick={() => onCoordinatesChange({ latitude: 14.65, longitude: 121.02 })}>Select test pin</button> }))
const address = { province_code: '1300000000', province: 'NCR', city_code: '1381300000', city_municipality: 'Quezon City', psgc_code: '1381300001', barangay: 'Alicia', street: '1 Test Street', unit: '', postal_code: '1100', latitude: 14.65, longitude: 121.02 }
beforeEach(() => { vi.clearAllMocks(); vi.mocked(api.resolveAddressPin).mockResolvedValue({ address, pin_token: 'test-pin', message: 'Review your pin' }); vi.mocked(api.resolveAddressSelection).mockResolvedValue({ address, resolution_token: 'test-resolution' }); vi.mocked(api.searchAddressAreas).mockResolvedValue({ items: [], hasMore: false, page: 1, versionId: 'test' }) })
test('pin autofills selected PSGC fields and saves a token instead of raw coordinates', async () => {
  const { container } = render(<VendorBusinessAddress initial={{}} active onDirty={vi.fn()} />)
  fireEvent.click(screen.getByRole('button', { name: 'Select test pin' }))
  await waitFor(() => expect(screen.getByRole('combobox', { name: /City/ })).toHaveValue('Quezon City'))
  expect(screen.getByRole('combobox', { name: /Barangay/ })).toHaveValue('Alicia')
  expect(screen.getByRole('textbox', { name: 'Detailed Address' })).toHaveValue('1 Test Street')
  await screen.findByText('Location resolved. Review your address before saving.')
  expect(api.resolveAddressSelection).toHaveBeenCalledWith(expect.objectContaining({ pinToken: 'test-pin' }))
  const payload = () => JSON.parse((container.querySelector('[name=address_payload]') as HTMLInputElement).value)
  expect(payload()).toMatchObject({ resolution_token: 'test-resolution', psgc_code: '1381300001' })
  expect(payload()).not.toHaveProperty('latitude')
  fireEvent.change(screen.getByRole('combobox', { name: /Province/ }), { target: { value: 'unmatched' } })
  expect(payload().resolution_token).toBe('')
  expect(screen.getByRole('combobox', { name: /City/ })).toBeDisabled()
  expect(screen.queryByLabelText('Latitude')).not.toBeInTheDocument()
  expect(screen.queryByLabelText('Longitude')).not.toBeInTheDocument()
})
test('pin failure leaves no usable address resolution', async () => {
  vi.mocked(api.resolveAddressPin).mockRejectedValue(new Error('unavailable'))
  const { container } = render(<VendorBusinessAddress initial={{}} active onDirty={vi.fn()} />)
  fireEvent.click(screen.getByRole('button', { name: 'Select test pin' }))
  await screen.findByText('Lookup failed. Retry.')
  expect(JSON.parse((container.querySelector('[name=address_payload]') as HTMLInputElement).value).resolution_token).toBe('')
})


test('manual address completion uses no pin or geocoding and submits no coordinates', () => {
  const { container } = render(<VendorBusinessAddress initial={address} active onDirty={vi.fn()} />)
  fireEvent.change(screen.getByRole('textbox', { name: 'Detailed Address' }), { target: { value: '2 Manual Street' } })
  const payload = JSON.parse((container.querySelector('[name=address_payload]') as HTMLInputElement).value)
  expect(payload).toMatchObject({ source: 'MANUAL', street: '2 Manual Street', psgc_code: '1381300001' })
  expect(payload).not.toHaveProperty('resolution_token')
  expect(payload).not.toHaveProperty('latitude')
  expect(api.resolveAddressSelection).not.toHaveBeenCalled()
  expect(api.resolveAddressPin).not.toHaveBeenCalled()
})

test('a provider failure can switch to manual completion without losing structured fields', async () => {
  vi.mocked(api.resolveAddressSelection).mockRejectedValue(new Error('unavailable'))
  const { container } = render(<VendorBusinessAddress initial={{ ...address, source: 'MAP' }} active onDirty={vi.fn()} />)
  fireEvent.change(screen.getByRole('textbox', { name: 'Detailed Address' }), { target: { value: '2 Manual Street' } })
  await screen.findByText('Lookup failed. Retry.')
  fireEvent.click(screen.getByRole('button', { name: 'Continue with manual address' }))
  expect(JSON.parse((container.querySelector('[name=address_payload]') as HTMLInputElement).value)).toMatchObject({ source: 'MANUAL', street: '2 Manual Street' })
  expect(screen.queryByLabelText('Latitude')).not.toBeInTheDocument()
  expect(screen.queryByLabelText('Longitude')).not.toBeInTheDocument()
})

test('a late pin result cannot overwrite a newer pin', async () => {
  let first!: (value: Record<string, unknown>) => void
  vi.mocked(api.resolveAddressPin).mockImplementationOnce(() => new Promise(resolve => { first = resolve }))
  render(<VendorBusinessAddress initial={{}} active onDirty={vi.fn()} />)
  fireEvent.click(screen.getByRole('button', { name: 'Select test pin' }))
  fireEvent.click(screen.getByRole('button', { name: 'Select test pin' }))
  await screen.findByDisplayValue('1 Test Street')
  first({ address: { ...address, street: 'Stale street' }, pin_token: 'stale' })
  await waitFor(() => expect(screen.getByRole('textbox', { name: 'Detailed Address' })).toHaveValue('1 Test Street'))
})

test('incomplete reverse geocode keeps unresolved selections empty for manual completion', async () => {
  vi.mocked(api.resolveAddressPin).mockResolvedValue({ address: { ...address, psgc_code: null, barangay: '', postal_code: '' }, pin_token: 'partial' })
  const { container } = render(<VendorBusinessAddress initial={{}} active onDirty={vi.fn()} />)
  fireEvent.click(screen.getByRole('button', { name: 'Select test pin' }))
  await screen.findByDisplayValue('Quezon City')
  expect(screen.getByRole('combobox', { name: 'Barangay' })).toHaveValue('')
  expect(JSON.parse((container.querySelector('[name=address_payload]') as HTMLInputElement).value).resolution_token).toBe('')
  expect(api.resolveAddressSelection).not.toHaveBeenCalled()
  expect(screen.queryByLabelText('Latitude')).not.toBeInTheDocument()
  expect(screen.queryByLabelText('Longitude')).not.toBeInTheDocument()
})
