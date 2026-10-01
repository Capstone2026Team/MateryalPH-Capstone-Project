import { cleanup, fireEvent, render, screen } from '@testing-library/react'
import { afterEach, describe, expect, it, vi } from 'vitest'
import { ConversationHeader, QuotationVersionCard, ChatAttachmentButton } from '@materyalph/web-ui'
import type { ChatQuotationVersion } from '@materyalph/api-client-ts'

afterEach(cleanup)
const version: ChatQuotationVersion = {
  id: 'version-2', version: 2, latest: true, state: 'PUBLISHED', publishedAt: '2026-09-30T00:00:00Z', expiresAt: '2099-09-30T00:00:00Z', contentHash: 'a'.repeat(64), viewed: true, actions: ['withdraw'],
  content: { lines: [{ variantId: 'item', quantity: '4', unitPriceCentavos: 1700, description: 'Portland Cement', unitCode: 'bag', taxCategory: 'VAT_12', sourcePriceVersionId: 'price', sourceTaxVersionId: 'tax' }], commercial: { materialsPayableCentavos: 6800, materialsVatCentavos: 729, vendorDiscountCentavos: 0, deliveryCentavos: 0, nrpcCentavos: 0, commercialTotalCentavos: 6800 }, fulfillmentMethod: 'PICKUP', paymentMethod: 'ONLINE', fulfillmentDate: '2099-10-01', priceSource: 'PRIVATE_TRANSACTION', processingFeeStatus: 'PENDING_PAYMENT_CHANNEL', changes: [{ path: 'lines.0.quantity', label: 'Quantity changed', before: '5', after: '4' }], originalChanges: [] },
}
describe('conversation and quotation presentation', () => {
  it('shows public identity and fixed role without private contact fields', () => {
    render(<ConversationHeader store={{ id: 'store', name: 'RJ Hardware', verified: true }} handler={{ displayName: 'Alex Cruz', role: 'CUSTOMER_SERVICE' }} purpose="SALES" />)
    expect(screen.getByText('RJ Hardware')).toBeInTheDocument()
    expect(screen.getByText('Handled by')).toBeInTheDocument()
    expect(screen.getByText('Alex Cruz')).toBeInTheDocument()
    expect(screen.getByText('Customer Service')).toBeInTheDocument()
    expect(screen.getByText(/Verified/)).toBeInTheDocument()
  })
  it('invokes an action for the exact latest version and renders its Manila deadline', () => {
    const action = vi.fn()
    render(<QuotationVersionCard version={version} onAction={action} />)
    fireEvent.click(screen.getByRole('button', { name: 'Withdraw quotation' }))
    expect(action).toHaveBeenCalledWith('withdraw', version)
    expect(screen.getByText(/Viewed by Buyer/)).toBeInTheDocument()
    expect(screen.getByText(/Manila/)).toBeInTheDocument()
  })
  it('retains superseded terms but removes stale actions even if a caller passes them', () => {
    render(<QuotationVersionCard version={{ ...version, latest: false, state: 'SUPERSEDED' }} onAction={vi.fn()} />)
    expect(screen.getByText('Portland Cement')).toBeInTheDocument()
    expect(screen.queryByRole('button', { name: 'Withdraw quotation' })).not.toBeInTheDocument()
  })
  it('never enables an unscanned attachment', () => {
    render(<ChatAttachmentButton attachment={{ id: 'file', displayName: 'Attachment.pdf', mediaType: 'application/pdf', sizeBytes: 2048, scanState: 'PENDING' }} onOpen={vi.fn()} />)
    expect(screen.getByRole('button')).toBeDisabled()
    expect(screen.getByText(/2 KB/)).toBeInTheDocument()
  })
})
