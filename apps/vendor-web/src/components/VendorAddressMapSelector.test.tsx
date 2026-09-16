import { render, screen } from '@testing-library/react'
import { afterEach, expect, test, vi } from 'vitest'

import { VendorAddressMapSelector } from './VendorAddressMapSelector'

afterEach(() => vi.unstubAllEnvs())

test('keeps the labeled address fields as an accessible fallback when maps are unavailable', () => {
  vi.stubEnv('VITE_GOOGLE_MAPS_BROWSER_KEY', '')
  render(<VendorAddressMapSelector latitude={14.5995} longitude={120.9842} onCoordinatesChange={() => undefined} />)

  expect(screen.getByRole('status')).toHaveTextContent('Interactive Google Maps is not configured')
  expect(screen.getByText(/labeled address fields above remain the complete non-map alternative/i)).toBeInTheDocument()
})
