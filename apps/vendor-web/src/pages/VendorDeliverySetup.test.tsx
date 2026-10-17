import { render, screen } from '@testing-library/react'
import { VendorDeliverySetup, type VendorDeliveryReadiness } from '@materyalph/web-ui'
import { describe, expect, test } from 'vitest'

const ready: VendorDeliveryReadiness = { staffReady: true, vehicleReady: true, pickupLocationReady: true, serviceSettingsReady: true, ready: true, enabled: false, available: false, activeDeliveryObligations: 0 }

describe('Vendor Delivery setup guidance', () => {
  test('Self-Pickup Only does not require delivery accounts or vehicles', () => {
    render(<VendorDeliverySetup method="SELF_PICKUP" state={{ ...ready, staffReady: false, vehicleReady: false, ready: false }} />)
    expect(screen.getByText(/does not require Fulfillment Staff or delivery vehicles/)).toBeInTheDocument()
    expect(screen.queryByRole('heading', { name: 'Fulfillment Staff Required' })).not.toBeInTheDocument()
  })

  test.each(['VENDOR_DELIVERY', 'BOTH'])('%s explains both missing requirements and links existing management modules', method => {
    render(<VendorDeliverySetup method={method} state={{ ...ready, staffReady: false, vehicleReady: false, ready: false }}
      staffAction={<a href="/team">Manage Fulfillment Staff</a>} vehicleAction={<a href="/vehicles">Manage Vehicles</a>} />)
    expect(screen.getByRole('heading', { name: 'Fulfillment Staff Required' })).toBeInTheDocument()
    expect(screen.getByRole('heading', { name: 'Delivery Vehicle Required' })).toBeInTheDocument()
    expect(screen.getByRole('link', { name: 'Manage Fulfillment Staff' })).toHaveAttribute('href', '/team')
    expect(screen.getByRole('link', { name: 'Manage Vehicles' })).toHaveAttribute('href', '/vehicles')
    expect(screen.getByText(/Saved as a draft/)).toBeInTheDocument()
  })

  test('ready drafts explain activation separately from live availability', () => {
    render(<VendorDeliverySetup method="BOTH" state={ready} />)
    expect(screen.getByText('Vendor Delivery Ready')).toBeInTheDocument()
    expect(screen.getByText(/Activate Vendor Delivery when all requirements are complete/)).toBeInTheDocument()
    expect(screen.queryByText('Vendor Delivery is available for new orders.')).not.toBeInTheDocument()
  })

  test('loss of a requirement explains the new-order pause and preserves outstanding obligations', () => {
    render(<VendorDeliverySetup method="BOTH" state={{ ...ready, staffReady: false, ready: false, enabled: true, activeDeliveryObligations: 2 }} />)
    expect(screen.getByText(/temporarily unavailable for new orders/)).toHaveTextContent('Existing delivery orders remain accessible')
    expect(screen.getByText(/2 active delivery obligations remain/)).toHaveTextContent('before switching to Self-Pickup Only')
  })
})
