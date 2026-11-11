import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { Field } from '@materyalph/web-ui'
import { MemoryRouter } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import VendorProductPractice from './VendorProductPractice'
import VendorVehiclePractice from './VendorVehiclePractice'
import VendorInvoicePractice from './VendorInvoicePractice'
import VendorTrackingPractice from './VendorTrackingPractice'

vi.mock('../lib/vendor-status', async original => ({ ...await original<typeof import('../lib/vendor-status')>(), useOnboardingSnapshot: () => ({ snapshot: { permissions: [] } }) }))
beforeEach(() => {
  HTMLDialogElement.prototype.showModal = function () { this.open = true }
  HTMLDialogElement.prototype.close = function () { this.open = false }
  vi.stubGlobal('ResizeObserver', class { observe() {} disconnect() {} })
  vi.stubGlobal('matchMedia', () => ({ matches: false, addEventListener() {}, removeEventListener() {} }))
  vi.stubGlobal('fetch', vi.fn(() => { throw new Error('Practice must not call the API') }))
  Object.defineProperty(URL, 'createObjectURL', { configurable: true, value: vi.fn(() => 'blob:tutorial-photo') })
  Object.defineProperty(URL, 'revokeObjectURL', { configurable: true, value: vi.fn() })
})
const next = () => fireEvent.click(screen.getByRole('button', { name: 'Next' }))

test('product practice validates local edits, adds a sample image and simulates publication without API requests', async () => {
  const close = vi.fn()
  const { unmount } = render(<MemoryRouter><Field label="Live display name" name="display_name" defaultValue="Unsaved real product" /><VendorProductPractice onClose={close} /></MemoryRouter>)
  fireEvent.change(screen.getByRole('textbox', { name: 'Display name' }), { target: { value: 'Practice plywood' } })
  fireEvent.click(screen.getByRole('button', { name: 'Create sample draft' }))
  next()
  const demo = screen.getByRole('dialog', { name: 'Practice adding a product' })
  fireEvent.change(within(demo).getByRole('textbox', { name: 'Display name' }), { target: { value: 'Practice plywood' } })
  expect(screen.getByRole('textbox', { name: 'Live display name' })).toHaveValue('Unsaved real product')
  const description = screen.getByRole('textbox', { name: /Description/ })
  fireEvent.change(description, { target: { value: '' } })
  next()
  expect(screen.getByRole('alert')).toHaveTextContent('Complete the highlighted')
  fireEvent.change(description, { target: { value: 'A clear sample description.' } })
  next(); next()
  expect(screen.getByRole('heading', { name: 'Add a public product image' })).toBeInTheDocument()
  next()
  expect(screen.getByRole('alert')).toHaveTextContent('Complete the highlighted')
  fireEvent.click(screen.getByRole('button', { name: 'Use sample product image' }))
  fireEvent.click(screen.getByRole('button', { name: 'Replace main photo' }))
  fireEvent.change(screen.getByLabelText('Product photos', { selector: 'input' }), { target: { files: [new File(['sample image'], 'practice.png', { type: 'image/png' })] } })
  expect(screen.getByRole('list', { name: 'Product photos: 1 of 8' })).toBeInTheDocument()
  next()
  expect(screen.getByText('Practice plywood')).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Publish listing' }))
  expect(screen.getByText(/Sample publication completed/)).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Finish' }))
  expect(close).toHaveBeenCalledWith(true)
  expect(fetch).not.toHaveBeenCalled()
  unmount()
  expect(URL.revokeObjectURL).toHaveBeenCalledWith('blob:tutorial-photo')
})

test('vehicle practice uses the real capacity validation and saves only inside the demo', async () => {
  const close = vi.fn()
  render(<VendorVehiclePractice onClose={close} />)
  fireEvent.change(screen.getByRole('spinbutton', { name: 'Maximum Weight Capacity (kg)' }), { target: { value: '0' } })
  next(); next(); next(); next()
  fireEvent.click(screen.getByRole('button', { name: 'Save sample vehicle' }))
  expect(screen.queryByText(/Sample vehicle saved in this practice/)).not.toBeInTheDocument()
  fireEvent.change(screen.getByRole('spinbutton', { name: 'Maximum Weight Capacity (kg)' }), { target: { value: '1000' } })
  fireEvent.click(screen.getByRole('button', { name: 'Save sample vehicle' }))
  expect(screen.getByText(/Sample vehicle saved in this practice/)).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Finish' }))
  expect(close).toHaveBeenCalledWith(true)
  expect(fetch).not.toHaveBeenCalled()
})

test('invoice practice requires a saved sample draft before Send and keeps sent history after a simulated return', async () => {
  const close = vi.fn()
  render(<VendorInvoicePractice onClose={close} />)
  next(); next()
  fireEvent.click(screen.getByRole('button', { name: 'Save sample draft' }))
  expect(screen.getByRole('alert')).toHaveTextContent('Complete the highlighted')
  fireEvent.click(screen.getByRole('button', { name: 'Use sample invoice copy' }))
  fireEvent.click(screen.getByRole('button', { name: 'Save sample draft' }))
  next()
  expect(screen.getByRole('button', { name: 'Send sample copy' })).toBeEnabled()
  fireEvent.click(screen.getByRole('button', { name: 'Send sample copy' }))
  next()
  fireEvent.click(screen.getByRole('button', { name: 'Simulate Buyer return' }))
  expect(screen.getByText(/remains in the sent history/)).toBeInTheDocument()
  expect(screen.getByRole('heading', { name: 'DEMO-INV-001' })).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Finish' }))
  expect(close).toHaveBeenCalledWith(true)
  expect(fetch).not.toHaveBeenCalled()
})

test('invoice viewing roles receive sample details without preparation or Send controls', () => {
  render(<VendorInvoicePractice onClose={vi.fn()} canPrepare={false} />)
  next()
  expect(screen.getByText('Example Buyer')).toBeInTheDocument()
  expect(screen.queryByRole('button', { name: /Send sample|Use sample/ })).not.toBeInTheDocument()
  expect(fetch).not.toHaveBeenCalled()
})

test('Team Tracking practice opens a fictional member and traverses the real read-only views without API requests', async () => {
  render(<VendorTrackingPractice onClose={vi.fn()} />)
  await waitFor(() => expect(screen.getByRole('button', { name: /Demo Inventory Staff/ })).toHaveAttribute('aria-pressed', 'true'))
  next(); next(); next(); next()
  await screen.findByText('Stock updated')
  fireEvent.click(screen.getByText('Record details'))
  const history = screen.getByRole('region', { name: 'Activity history' })
  expect(within(history).getByText('40 → 50')).toBeInTheDocument()
  next()
  await waitFor(() => expect(screen.getByRole('button', { name: 'Role responsibilities' })).toHaveAttribute('aria-pressed', 'true'))
  expect(fetch).not.toHaveBeenCalled()
})
