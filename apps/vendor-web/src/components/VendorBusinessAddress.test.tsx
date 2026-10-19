import { fireEvent, render, screen, waitFor } from '@testing-library/react'
import { beforeEach, expect, test, vi } from 'vitest'
import { VendorBusinessAddress } from './VendorBusinessAddress'
import * as api from '../lib/onboarding-api'
vi.mock('../lib/onboarding-api', () => ({ searchAddressAreas: vi.fn(), resolveAddressSelection: vi.fn(), resolveAddressPin: vi.fn(), readableOnboardingError: async () => 'Lookup failed. Retry.' }))
vi.mock('./VendorAddressMapSelector', () => ({ VendorAddressMapSelector: ({ onCoordinatesChange }: { onCoordinatesChange: (point: { latitude: number; longitude: number }) => void }) => <button type="button" onClick={() => onCoordinatesChange({ latitude: 14.65, longitude: 121.02 })}>Select test pin</button> }))
const address = { province_code: '1300000000', province: 'NCR', city_code: '1381300000', city_municipality: 'Quezon City', psgc_code: '1381300001', barangay: 'Alicia', street: '1 Test Street', unit: '', postal_code: '1100', latitude: 14.65, longitude: 121.02 }
beforeEach(() => { vi.clearAllMocks(); vi.mocked(api.resolveAddressPin).mockResolvedValue({ address, pin_token: 'test-pin', message: 'Review your pin' }); vi.mocked(api.resolveAddressSelection).mockResolvedValue({ address, resolution_token: 'test-resolution' }); vi.mocked(api.searchAddressAreas).mockResolvedValue({ items: [], hasMore: false, page: 1, versionId: 'test' }) })
test('pin fills editable fields without PSGC selectors and saves a token instead of coordinates', async () => {
  const { container } = render(<VendorBusinessAddress initial={{}} active onDirty={vi.fn()} />)
  fireEvent.click(screen.getByRole('button', { name: 'Select test pin' }))
  await waitFor(() => expect(screen.getByRole('textbox', { name: /City/ })).toHaveValue('Quezon City'))
  expect(screen.getByRole('textbox', { name: /Barangay/ })).toHaveValue('Alicia')
  expect(screen.getByRole('textbox', { name: 'Street address' })).toHaveValue('1 Test Street')
  expect(screen.queryByRole('combobox')).not.toBeInTheDocument()
  await screen.findByText('Map location confirmed. Review the address details before continuing.')
  expect(api.resolveAddressSelection).toHaveBeenCalledWith(expect.objectContaining({ pinToken: 'test-pin' }))
  const payload = () => JSON.parse((container.querySelector('[name=address_payload]') as HTMLInputElement).value)
  expect(payload()).toMatchObject({ resolution_token: 'test-resolution', barangay: 'Alicia' })
  expect(payload()).not.toHaveProperty('psgc_code')
  expect(payload()).not.toHaveProperty('latitude')
  fireEvent.change(screen.getByRole('textbox', { name: /Province/ }), { target: { value: 'unmatched' } })
  expect(payload().resolution_token).toBe('')
  expect(screen.getByRole('textbox', { name: /City/ })).toBeEnabled()
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
  fireEvent.change(screen.getByRole('textbox', { name: 'Street address' }), { target: { value: '2 Manual Street' } })
  const payload = JSON.parse((container.querySelector('[name=address_payload]') as HTMLInputElement).value)
  expect(payload).toMatchObject({ source: 'MANUAL', street: '2 Manual Street', city_municipality: 'Quezon City' })
  expect(payload).not.toHaveProperty('psgc_code')
  expect(payload).not.toHaveProperty('resolution_token')
  expect(payload).not.toHaveProperty('latitude')
  expect(api.resolveAddressSelection).not.toHaveBeenCalled()
  expect(api.resolveAddressPin).not.toHaveBeenCalled()
})

test('a provider failure can switch to manual completion without losing structured fields', async () => {
  vi.mocked(api.resolveAddressSelection).mockRejectedValue(new Error('unavailable'))
  const { container } = render(<VendorBusinessAddress initial={{ ...address, source: 'MAP' }} active onDirty={vi.fn()} />)
  fireEvent.change(screen.getByRole('textbox', { name: 'Street address' }), { target: { value: '2 Manual Street' } })
  await screen.findByText('Lookup failed. Retry.')
  fireEvent.click(screen.getByRole('button', { name: 'Enter address manually' }))
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
  await waitFor(() => expect(screen.getByRole('textbox', { name: 'Street address' })).toHaveValue('1 Test Street'))
})

test('incomplete reverse geocode lets the vendor type missing address details', async () => {
  vi.mocked(api.resolveAddressPin).mockResolvedValue({ address: { ...address, psgc_code: null, barangay: '', postal_code: '' }, pin_token: 'partial' })
  const { container } = render(<VendorBusinessAddress initial={{}} active onDirty={vi.fn()} />)
  fireEvent.click(screen.getByRole('button', { name: 'Select test pin' }))
  await screen.findByDisplayValue('Quezon City')
  expect(screen.getByRole('textbox', { name: 'Barangay' })).toHaveValue('')
  expect(JSON.parse((container.querySelector('[name=address_payload]') as HTMLInputElement).value).resolution_token).toBe('')
  expect(api.resolveAddressSelection).not.toHaveBeenCalled()
  fireEvent.change(screen.getByRole('textbox', { name: 'Barangay' }), { target: { value: 'Ali' } })
  fireEvent.change(screen.getByRole('textbox', { name: 'Barangay' }), { target: { value: 'Alicia' } })
  fireEvent.change(screen.getByRole('textbox', { name: 'Postal code' }), { target: { value: '11' } })
  fireEvent.change(screen.getByRole('textbox', { name: 'Postal code' }), { target: { value: '1100' } })
  await screen.findByText('Map location confirmed. Review the address details before continuing.')
  expect(api.resolveAddressSelection).toHaveBeenCalledWith(expect.objectContaining({ pinToken: 'partial', barangay: 'Alicia' }))
  expect(screen.queryByLabelText('Latitude')).not.toBeInTheDocument()
  expect(screen.queryByLabelText('Longitude')).not.toBeInTheDocument()
})

test('a failed pin lookup can retry without address search controls', async () => {
  vi.mocked(api.resolveAddressPin).mockRejectedValueOnce(new Error('unavailable'))
  const { container } = render(<VendorBusinessAddress initial={{}} active onDirty={vi.fn()} />)
  expect(screen.queryByRole('textbox', { name: 'Search for your business address' })).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Find on Google Maps' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Select test pin' }))
  await screen.findByText('Lookup failed. Retry.')
  fireEvent.click(screen.getByRole('button', { name: 'Retry address lookup' }))
  await screen.findByDisplayValue('Quezon City')
  await screen.findByText('Map location confirmed. Review the address details before continuing.')
  expect(api.resolveAddressPin).toHaveBeenCalledTimes(2)
  expect(JSON.parse((container.querySelector('[name=address_payload]') as HTMLInputElement).value)).toMatchObject({ source: 'MAP', resolution_token: 'test-resolution', city_municipality: 'Quezon City' })
})

test('manual entry from an empty form needs no directory or map lookup', () => {
  const { container } = render(<VendorBusinessAddress initial={{}} active onDirty={vi.fn()} />)
  fireEvent.click(screen.getByRole('radio', { name: 'Enter address manually' }))
  for (const [name, value] of [['Street address', '2 Manual Street'], ['Barangay', 'Alicia'], ['City / Municipality', 'Quezon City'], ['Province / Metro Manila', 'Metro Manila'], ['Postal code', '1100']] as const) {
    fireEvent.change(screen.getByRole('textbox', { name }), { target: { value } })
  }
  expect(screen.queryByRole('button', { name: 'Select test pin' })).not.toBeInTheDocument()
  expect(JSON.parse((container.querySelector('[name=address_payload]') as HTMLInputElement).value)).toMatchObject({ source: 'MANUAL', city_municipality: 'Quezon City', province: 'Metro Manila' })
  expect(api.resolveAddressSelection).not.toHaveBeenCalled()
  expect(api.resolveAddressPin).not.toHaveBeenCalled()
  expect(api.searchAddressAreas).not.toHaveBeenCalled()
})

test('a pending pin cannot overwrite manual edits after switching modes', async () => {
  let finish!: (value: Record<string, unknown>) => void
  vi.mocked(api.resolveAddressPin).mockImplementationOnce(() => new Promise(resolve => { finish = resolve }))
  const { container } = render(<VendorBusinessAddress initial={{}} active onDirty={vi.fn()} />)
  fireEvent.click(screen.getByRole('button', { name: 'Select test pin' }))
  fireEvent.click(screen.getByRole('radio', { name: 'Enter address manually' }))
  fireEvent.change(screen.getByRole('textbox', { name: 'Street address' }), { target: { value: 'My manual address' } })
  finish({ address, pin_token: 'late-pin' })
  await waitFor(() => expect(screen.getByRole('textbox', { name: 'Street address' })).toHaveValue('My manual address'))
  expect(JSON.parse((container.querySelector('[name=address_payload]') as HTMLInputElement).value).source).toBe('MANUAL')
})
