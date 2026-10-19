import { cleanup, fireEvent, render, screen, within } from '@testing-library/react'
import { afterEach, describe, expect, it, vi } from 'vitest'
import { ConversationHeader, QuotationThreadCard, QuotationVersionCard, ChatAttachmentButton, ChatMessageBubble, ChatTypingIndicator, conversationTimeline } from '@materyalph/web-ui'
import type { ChatQuotationVersion, ChatMessage, ChatQuotationChange } from '@materyalph/api-client-ts'
import { ChatQuotationLineFromJSON, ChatQuotationLineToJSON, ChatQuotationVersionFromJSON, ChatQuotationVersionToJSON } from '@materyalph/api-client-ts'

afterEach(cleanup)
/** jsdom has no object URLs; previews only need a stable string and a revoke record. */
const stubObjectUrls = () => {
  const urls = { createObjectURL: vi.fn(() => 'blob:photo'), revokeObjectURL: vi.fn() }
  Object.assign(URL, urls)
  return urls
}
const version: ChatQuotationVersion = {
  id: 'version-2', version: 2, latest: true, state: 'PUBLISHED', publishedAt: '2026-09-30T00:00:00Z', expiresAt: '2099-09-30T00:00:00Z', contentHash: 'a'.repeat(64), viewed: true, actions: ['withdraw'],
  content: { lines: [{ variantId: 'item', quantity: '4', unitPriceCentavos: 1700, description: 'Portland Cement', unitCode: 'bag', taxCategory: 'VAT_12', sourcePriceVersionId: 'price', sourceTaxVersionId: 'tax' }], commercial: { materialsPayableCentavos: 6800, materialsVatCentavos: 729, vendorDiscountCentavos: 0, deliveryCentavos: 0, nrpcCentavos: 0, commercialTotalCentavos: 6800 }, fulfillmentMethod: 'PICKUP', paymentMethod: 'ONLINE', fulfillmentDate: '2099-10-01', priceSource: 'PRIVATE_TRANSACTION', processingFeeStatus: 'PENDING_PAYMENT_CHANNEL', changes: [{ path: 'lines.0.quantity', label: 'Quantity changed', before: '5', after: '4' }], originalChanges: [] },
}
describe('conversation and quotation presentation', () => {
  it('preserves version-specific change requests through the generated client', () => {
    const countered = { ...version, requestedChanges: 'Please reduce quantity.', changeRequestedAt: '2026-10-18T03:00:00Z', vendorResponseDueAt: '2026-10-19T03:00:00Z' }
    const wire = ChatQuotationVersionToJSON(countered)
    expect(wire).toMatchObject({ requested_changes: countered.requestedChanges, change_requested_at: countered.changeRequestedAt, vendor_response_due_at: countered.vendorResponseDueAt })
    expect(ChatQuotationVersionFromJSON(wire)).toMatchObject(countered)
    expect(ChatQuotationVersionFromJSON(ChatQuotationVersionToJSON(version)).requestedChanges).toBeUndefined()
  })
  it('keeps published quotations between messages when their state changes', () => {
    const message: ChatMessage = { id: 'message', clientMessageId: 'client', body: 'Later reply', kind: 'TEXT', sender: { displayName: 'Buyer', role: 'BUYER' }, sentAt: '2026-09-30T01:00:00Z', mine: false, attachments: [], readByRecipient: false }
    const entries = conversationTimeline([message], [{ ...version, state: 'COUNTERED' }])
    expect(entries.map(entry => entry.id)).toEqual(['quotation-version-2', 'message-message'])
    expect(entries[0]?.timestamp).toBe(version.publishedAt)
  })
  it('shows the exact Buyer request and Vendor deadline on a compact quotation entry', () => {
    const onOpen = vi.fn(), onRevise = vi.fn()
    const countered = { ...version, state: 'COUNTERED', requestedChanges: 'Please reduce quantity to 3.\nKeep Self-Pickup.', changeRequestedAt: '2026-10-18T03:00:00Z', vendorResponseDueAt: '2099-10-19T03:00:00Z', actions: [] }
    const { rerender } = render(<QuotationThreadCard version={countered} onOpen={onOpen} onRevise={onRevise} />)
    expect(screen.getByLabelText('Buyer change request for quotation v2')).toHaveTextContent('Please reduce quantity to 3. Keep Self-Pickup.')
    expect(screen.getByText(/Vendor response due/)).toBeInTheDocument()
    expect(screen.queryByText('Portland Cement')).not.toBeInTheDocument()
    fireEvent.click(screen.getByRole('button', { name: 'View quotation v2' }))
    fireEvent.click(screen.getByRole('button', { name: 'Revise quotation' }))
    expect(onOpen).toHaveBeenCalledOnce()
    expect(onRevise).toHaveBeenCalledOnce()
    rerender(<QuotationThreadCard version={{ ...countered, latest: false, state: 'SUPERSEDED' }} onOpen={onOpen} onRevise={onRevise} />)
    expect(screen.getByLabelText('Buyer change request for quotation v2')).toBeInTheDocument()
    expect(screen.queryByText(/Vendor response due/)).not.toBeInTheDocument()
    expect(screen.queryByRole('button', { name: 'Revise quotation' })).not.toBeInTheDocument()
  })
  it('replaces the Buyer timer with the Vendor timer after a request for changes', () => {
    render(<QuotationVersionCard version={{ ...version, state: 'COUNTERED', requestedChanges: 'Please reduce quantity.', vendorResponseDueAt: '2099-10-19T03:00:00Z', actions: [] }} />)
    expect(screen.getByText('Please reduce quantity.')).toBeInTheDocument()
    expect(screen.getByText(/Vendor response due/)).toBeInTheDocument()
    expect(screen.queryByText(/Buyer deadline/)).not.toBeInTheDocument()
    expect(screen.queryByRole('button', { name: 'Withdraw quotation' })).not.toBeInTheDocument()
  })
  it('leaves payment to the Buyer and shows the recorded choice after acceptance', () => {
    const { rerender } = render(<QuotationVersionCard version={version} />)
    expect(screen.getByText('Payment method').closest('div')).toHaveTextContent('Buyer selects before accepting')
    rerender(<QuotationVersionCard version={{ ...version, state: 'ACCEPTED', selectedPaymentMethod: 'IN_STORE', acceptedOrderId: 'order', actions: [] }} />)
    expect(screen.getByText('Payment method').closest('div')).toHaveTextContent('In-Store Payment')
    expect(screen.getByText('Processing fee', { exact: true }).closest('div')).toHaveTextContent('Not applicable')
    expect(screen.queryByText('Buyer selects before accepting')).not.toBeInTheDocument()
  })
  it('retains published technical details through the client and shows them beside the material', () => {
    const line = ChatQuotationLineFromJSON({
      variant_id: 'item', quantity: '4.0000', unit_price_centavos: 1700, description: 'Portland Cement', unit_code: 'bag', tax_category: 'VAT_12',
      source_price_version_id: 'price', source_tax_version_id: 'tax', brand: 'Quoted brand', variant_label: '40 kg bag',
      specifications: { compressive_strength_mpa: '28', cement_type: 'Type 1' },
    })
    expect(ChatQuotationLineToJSON(line)).toMatchObject({ brand: 'Quoted brand', variant_label: '40 kg bag', specifications: { compressive_strength_mpa: '28', cement_type: 'Type 1' } })
    render(<QuotationVersionCard version={{ ...version, state: 'VIEWED', content: { ...version.content, lines: [line] } }} />)
    const specs = screen.getByLabelText('Technical details for Portland Cement')
    expect(specs).toHaveTextContent('Brand:Quoted brand')
    expect(specs).toHaveTextContent('Variant:40 kg bag')
    expect(specs).toHaveTextContent('Compressive Strength (MPa):28')
    expect(specs).toHaveTextContent('Cement Type:Type 1')
    expect(screen.getByText('4 bag × ₱17.00')).toBeInTheDocument()
    expect(screen.getByText('Viewed by Buyer', { exact: true })).toBeInTheDocument()
  })
  it('keeps historical terms readable without fetching current listing details or showing zero discounts', () => {
    render(<QuotationVersionCard version={version} />)
    expect(screen.getByText('Technical details not recorded for this quotation.')).toBeInTheDocument()
    expect(screen.queryByText(/Vendor discount \(/)).not.toBeInTheDocument()
    expect(screen.queryByText('Materials subtotal')).not.toBeInTheDocument()
    expect(screen.getByText('Included VAT (in materials)').closest('div')).toHaveTextContent('₱7.29')
    expect(screen.getByText('Total before processing fee').closest('div')).toHaveTextContent('₱68.00')
    expect(screen.getByText('Processing fee', { exact: true }).closest('div')).toHaveTextContent('Pending')
  })
  it('uses saved net amounts and shows materials discounts, included VAT and NRPC without adding them to the total', () => {
    render(<QuotationVersionCard version={{ ...version, content: { ...version.content,
      fulfillmentMethod: 'DELIVERY',
      commercial: { materialsGrossCentavos: 100000, vendorDiscountCentavos: 10000, materialsPayableCentavos: 90000, materialsVatCentavos: 9643, deliveryCentavos: 20000, nrpcCentavos: 5000, commercialTotalCentavos: 110000 },
      discount: { scope: 'MATERIALS', percent: '10.00', basisCentavos: 100000, deductionCentavos: 10000 },
    } }} />)
    const payment = within(screen.getByRole('region', { name: 'Payment breakdown' }))
    expect(payment.getByText('Materials subtotal').closest('div')).toHaveTextContent('₱1,000.00')
    expect(payment.getByText('Vendor discount (materials · 10.00%)').closest('div')).toHaveTextContent('− ₱100.00')
    expect(payment.getByText('Materials after discounts').closest('div')).toHaveTextContent('₱900.00')
    expect(payment.getByText('Included VAT (in materials)').closest('div')).toHaveTextContent('₱96.43')
    expect(payment.getByText('Total before processing fee').closest('div')).toHaveTextContent('₱1,100.00')
    expect(payment.getByText('NRPC included in total').closest('div')).toHaveTextContent('₱50.00')
  })
  it('separates the saved delivery discount from the materials amount', () => {
    render(<QuotationVersionCard version={{ ...version, content: { ...version.content,
      fulfillmentMethod: 'DELIVERY',
      commercial: { ...version.content.commercial, deliveryCentavos: 18000, commercialTotalCentavos: 24800 },
      discount: { scope: 'DELIVERY', percent: '10.00', basisCentavos: 20000, deductionCentavos: 2000 },
    } }} />)
    expect(screen.getByText('Delivery subtotal').closest('div')).toHaveTextContent('₱200.00')
    expect(screen.getByText('Vendor discount (delivery · 10.00%)').closest('div')).toHaveTextContent('− ₱20.00')
    expect(screen.getByText('Delivery after discounts').closest('div')).toHaveTextContent('₱180.00')
    expect(screen.queryByText(/Vendor discount \(materials/)).not.toBeInTheDocument()
    expect(screen.getByText('Total before processing fee').closest('div')).toHaveTextContent('₱248.00')
  })
  it('summarizes the initial quotation without calculation data, IDs, coordinates or default discounts', () => {
    const change = (path: string, after: unknown): ChatQuotationChange => ({ path, label: `Raw internal details for ${path}`, before: null, after })
    const { container } = render(<QuotationVersionCard version={{ ...version, content: { ...version.content, changes: [
      change('lines', [{ description: 'Portland Cement', quantity: '4.0000', unit_code: 'bag', variant_id: 'private-variant-id' }]),
      change('commercial', { calculation_version: 'fin02.order.v1', line_id: 'private-line-id', rounding: 'largest-remainder', commercial_total_centavos: 6800 }),
      change('fulfillment_method', 'PICKUP'), change('payment_method', 'ONLINE'), change('fulfillment_date', '2099-10-01'),
      change('destination', { intended: { formatted_address: 'Unnecessary pickup address', latitude: 14.5, longitude: 120.9, address_id: 'private-address-id' } }),
      change('price_source', 'PRIVATE_TRANSACTION'), change('fee_policy_version_id', 'private-policy-id'),
      change('processing_fee_status', 'PENDING_PAYMENT_CHANNEL'), change('discount', { scope: 'MATERIALS', percent: '0.00', basis_centavos: 6800 }),
    ] } }} />)
    fireEvent.click(screen.getByText('What changed · 4 changes'))
    expect(screen.getByText('Added · Portland Cement')).toBeInTheDocument()
    expect(screen.getByText('4 bag')).toBeInTheDocument()
    const notes = within(screen.getByText('What changed · 4 changes').closest('details')!)
    expect(notes.getByText('Self-Pickup', { exact: true })).toBeInTheDocument()
    expect(notes.getByText('Online payment', { exact: true })).toBeInTheDocument()
    expect(container.textContent).not.toMatch(/Raw internal|private-.*-id|fin02|largest-remainder|14\.5|120\.9|Unnecessary pickup address|PRIVATE_TRANSACTION|PENDING_PAYMENT_CHANNEL/)
    expect(screen.queryByText('Vendor discount', { exact: true })).not.toBeInTheDocument()
  })
  it('shows readable before and after amounts and omits derived totals and identifiers', () => {
    render(<QuotationVersionCard version={{ ...version, content: { ...version.content, changes: [
      { path: 'lines.0.quantity', label: 'raw quantity', before: '2.0000', after: '4.0000' },
      { path: 'lines.0.unit_price_centavos', label: 'raw money', before: 1500, after: 1700 },
      { path: 'lines.0.source_price_version_id', label: 'raw identifier', before: 'old', after: 'new' },
      { path: 'commercial.materials_payable_centavos', label: 'raw total', before: 3000, after: 6800 },
    ] } }} />)
    fireEvent.click(screen.getByText('What changed · 2 changes'))
    expect(screen.getByText('Portland Cement · Quantity').closest('li')).toHaveTextContent(/Changed from 2 bag.*to 4 bag/)
    expect(screen.getByText('Portland Cement · Unit price').closest('li')).toHaveTextContent(/Changed from ₱15\.00.*to ₱17\.00/)
    expect(screen.queryByText(/raw /)).not.toBeInTheDocument()
  })
  it('folds longer change lists and restores the compact list when requested', () => {
    render(<QuotationVersionCard version={{ ...version, content: { ...version.content, changes: Array.from({ length: 7 }, (_, index) => ({ path: `lines.${index}.quantity`, label: 'unused', before: '2', after: '4' })) } }} />)
    fireEvent.click(screen.getByText('What changed · 7 changes'))
    expect(screen.queryByText('Product 7 · Quantity')).not.toBeInTheDocument()
    fireEvent.click(screen.getByRole('button', { name: 'Show all 7 changes' }))
    expect(screen.getByText('Product 7 · Quantity')).toBeInTheDocument()
    expect(screen.getByRole('button', { name: 'Show fewer changes' })).toHaveAttribute('aria-expanded', 'true')
    fireEvent.click(screen.getByRole('button', { name: 'Show fewer changes' }))
    expect(screen.queryByText('Product 7 · Quantity')).not.toBeInTheDocument()
  })
  it('uses a compact empty summary when only internal fields changed', () => {
    render(<QuotationVersionCard version={{ ...version, content: { ...version.content, changes: [{ path: 'fee_policy_version_id', label: 'Private policy ID', before: 'old', after: 'new' }] } }} />)
    fireEvent.click(screen.getByText('What changed', { exact: true }))
    expect(screen.getByText('Quotation terms are shown above.')).toBeInTheDocument()
    expect(screen.queryByText(/Private policy/)).not.toBeInTheDocument()
  })
  it('retains changed delivery fees, discounts, NRPC and readable delivery addresses', () => {
    const { container } = render(<QuotationVersionCard version={{ ...version, content: { ...version.content, fulfillmentMethod: 'DELIVERY', changes: [
      { path: 'delivery.final_charge_centavos', label: 'raw delivery', before: 10000, after: 12000 },
      { path: 'discount', label: 'raw discount', before: { scope: 'MATERIALS', percent: '5' }, after: { scope: 'DELIVERY', percent: '10' } },
      { path: 'nrpc.amount_centavos', label: 'raw NRPC', before: 2000, after: 2500 },
      { path: 'destination', label: 'raw address', before: { intended: { formatted_address: 'Old project site', latitude: 14.5 } }, after: { intended: { formatted_address: 'New project site', latitude: 14.6, address_id: 'internal-address-id' } } },
    ] } }} />)
    fireEvent.click(screen.getByText('What changed · 4 changes'))
    expect(screen.getByText('Delivery fee').closest('li')).toHaveTextContent(/Changed from ₱100\.00.*to ₱120\.00/)
    expect(screen.getByText('Vendor discount').closest('li')).toHaveTextContent(/Changed from 5% · materials.*to 10% · delivery fee/)
    expect(screen.getByText('NRPC', { exact: true }).closest('li')).toHaveTextContent(/Changed from ₱20\.00.*to ₱25\.00/)
    expect(screen.getByText('Delivery address').closest('li')).toHaveTextContent(/Changed from Old project site.*to New project site/)
    expect(container.textContent).not.toMatch(/raw |internal-address-id|14\.5|14\.6/)
  })
  it('names removed materials and combines specification changes without showing object data', () => {
    render(<QuotationVersionCard version={{ ...version, content: { ...version.content, changes: [
      { path: 'lines.1', label: 'raw removed line', before: { description: 'Gravel', quantity: '1.0000', unit_code: 'cu.m', variant_id: 'internal-variant' }, after: null },
      { path: 'lines.0.specifications.thickness', label: 'raw specification', before: 'old', after: 'new' },
      { path: 'lines.0.specifications.grade', label: 'raw grade', before: 'old', after: 'new' },
    ] } }} />)
    fireEvent.click(screen.getByText('What changed · 2 changes'))
    expect(screen.getByText('Removed · Gravel').closest('li')).toHaveTextContent('1 cu.m')
    expect(screen.getAllByText('Portland Cement · Specifications updated')).toHaveLength(1)
    expect(screen.queryByText(/raw |internal-variant/)).not.toBeInTheDocument()
  })
  it('retains vehicle, trip and NRPC term changes without rendering their IDs or objects', () => {
    const { container } = render(<QuotationVersionCard version={{ ...version, content: { ...version.content, fulfillmentMethod: 'DELIVERY', changes: [
      { path: 'delivery.vehicles.0.vehicle_id', label: 'raw vehicle', before: 'internal-old-vehicle', after: 'internal-new-vehicle' },
      { path: 'delivery.vehicles.0.total_vehicle_trips', label: 'raw trips', before: 2, after: 3 },
      { path: 'nrpc.allocations', label: 'raw allocations', before: null, after: [{ line_id: 'internal-line-id', amount_centavos: 2500 }] },
      { path: 'nrpc.terms.id', label: 'raw terms', before: 'internal-old-terms', after: 'internal-new-terms' },
    ] } }} />)
    fireEvent.click(screen.getByText('What changed · 4 changes'))
    expect(screen.getByText('Delivery vehicle updated')).toBeInTheDocument()
    expect(screen.getByText('Delivery trips').closest('li')).toHaveTextContent(/Changed from 2.*to 3/)
    expect(screen.getByText('NRPC affected materials updated')).toBeInTheDocument()
    expect(screen.getByText('NRPC terms updated')).toBeInTheDocument()
    expect(container.textContent).not.toMatch(/raw |internal-/)
  })
  it('keeps an earlier accepted quotation distinct from superseded terms', () => {
    render(<QuotationVersionCard version={{ ...version, latest: false, state: 'ACCEPTED', actions: [], acceptedOrderId: 'order-one' }} />)
    expect(screen.getByText('Accepted', { exact: true })).toBeInTheDocument()
    expect(screen.queryByText('Superseded', { exact: true })).not.toBeInTheDocument()
    expect(screen.queryByText(/A newer quotation replaces/)).not.toBeInTheDocument()
    expect(screen.queryByText(/Buyer deadline/)).not.toBeInTheDocument()
  })
  it('opens the snapshotted product listing and keeps unavailable cards readable', () => {
    const open = vi.fn()
    const message: ChatMessage = { id: 'message', clientMessageId: 'client', body: '', kind: 'PRODUCT', mine: false, sentAt: '2026-10-02T00:00:00Z', sender: { displayName: 'Buyer', role: 'BUYER' }, readByRecipient: false, attachments: [], product: { productId: 'variant', listingId: 'listing', name: 'Original cement name', priceCentavos: 1800, available: true } }
    const { rerender } = render(<ol><ChatMessageBubble message={message} onOpenAttachment={vi.fn()} onOpenProduct={open} /></ol>)
    fireEvent.click(screen.getByRole('button', { name: /Original cement name/ }))
    expect(open).toHaveBeenCalledWith('listing')
    rerender(<ol><ChatMessageBubble message={{ ...message, product: { ...message.product!, available: false } }} onOpenAttachment={vi.fn()} onOpenProduct={open} /></ol>)
    expect(screen.getByText('No longer available')).toBeInTheDocument()
    expect(screen.getByRole('button', { name: /Original cement name/ })).toBeDisabled()
  })
  it('distinguishes pending and failed sends and exposes retry', () => {
    const retry = vi.fn()
    const message: ChatMessage = { id: 'message', clientMessageId: 'client', body: 'Hello', kind: 'TEXT', mine: true, sentAt: '2026-10-02T00:00:00Z', sender: { displayName: 'You', role: 'VENDOR' }, readByRecipient: false, attachments: [] }
    const { rerender } = render(<ol><ChatMessageBubble message={message} deliveryState="pending" onOpenAttachment={vi.fn()} /></ol>)
    expect(screen.getByRole('status')).toHaveTextContent('Sending…')
    expect(screen.queryByText('Sent')).not.toBeInTheDocument()
    rerender(<ol><ChatMessageBubble message={message} deliveryState="failed" onRetry={retry} onOpenAttachment={vi.fn()} /></ol>)
    fireEvent.click(screen.getByRole('button', { name: 'Failed to send · Retry' }))
    expect(retry).toHaveBeenCalledOnce()
  })
  it('announces typing through a persistent status region and hides the decorative dots', () => {
    const { container, rerender } = render(<ChatTypingIndicator active={false} />)
    expect(screen.getByRole('status')).toHaveTextContent('')
    expect(container.querySelector('.chat-typing-bubble')).toBeNull()
    rerender(<ChatTypingIndicator active />)
    expect(screen.getByRole('status')).toHaveTextContent('Someone is typing…')
    expect(container.querySelector('.chat-typing-bubble')).toHaveAttribute('aria-hidden', 'true')
  })
  it('shows the Buyer instead of the store when a Buyer is given', () => {
    render(<ConversationHeader store={{ id: 'store', name: 'RJ Hardware', verified: true }} buyer={{ displayName: 'Maria Santos', role: 'BUYER' }} handler={{ displayName: 'Alex Cruz', role: 'CUSTOMER_SERVICE' }} purpose="SALES" />)
    expect(screen.getByRole('heading', { name: 'Maria Santos' })).toBeInTheDocument()
    expect(screen.getByText(/Buyer · Sales & quotations/)).toBeInTheDocument()
    expect(screen.queryByText('RJ Hardware')).not.toBeInTheDocument()
    expect(screen.queryByText(/Verified/)).not.toBeInTheDocument()
  })
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
  it('previews a clean photo with a Download button and keeps other files as rows', async () => {
    const { revokeObjectURL } = stubObjectUrls()
    const open = vi.fn()
    const load = vi.fn(() => Promise.resolve(new Blob(['png'], { type: 'image/png' })))
    const photo = { id: 'photo', displayName: 'Attachment.png', mediaType: 'image/png', sizeBytes: 49152, scanState: 'CLEAN' as const }
    const pdf = { id: 'pdf', displayName: 'Attachment.pdf', mediaType: 'application/pdf', sizeBytes: 2048, scanState: 'CLEAN' as const }
    const message: ChatMessage = { id: 'message', clientMessageId: 'client', body: 'Attachment', kind: 'ATTACHMENT', mine: false, sentAt: '2026-10-02T00:00:00Z', sender: { displayName: 'Buyer', role: 'BUYER' }, readByRecipient: false, attachments: [photo, pdf] }
    const { unmount } = render(<ol><ChatMessageBubble message={message} onOpenAttachment={open} loadAttachment={load} /></ol>)
    expect(await screen.findByRole('img', { name: 'Attachment.png' })).toHaveAttribute('src', 'blob:photo')
    expect(load).toHaveBeenCalledOnce()
    expect(load).toHaveBeenCalledWith('photo')
    expect(screen.queryByText('Attachment', { exact: true })).not.toBeInTheDocument()
    fireEvent.click(screen.getByRole('button', { name: 'Download' }))
    expect(open).toHaveBeenCalledWith('photo', photo)
    fireEvent.click(screen.getByRole('button', { name: /Attachment\.pdf/ }))
    expect(open).toHaveBeenCalledWith('pdf', pdf)
    unmount()
    expect(revokeObjectURL).toHaveBeenCalledWith('blob:photo')
  })
  it('offers a retry when a photo cannot be loaded', async () => {
    stubObjectUrls()
    const load = vi.fn().mockRejectedValueOnce(new Error('offline')).mockResolvedValue(new Blob(['png'], { type: 'image/png' }))
    const message: ChatMessage = { id: 'message', clientMessageId: 'client', body: 'Attachment', kind: 'ATTACHMENT', mine: true, sentAt: '2026-10-02T00:00:00Z', sender: { displayName: 'You', role: 'VENDOR' }, readByRecipient: false, attachments: [{ id: 'photo', displayName: 'Attachment.jpg', mediaType: 'image/jpeg', sizeBytes: 1024, scanState: 'CLEAN' }] }
    render(<ol><ChatMessageBubble message={message} onOpenAttachment={vi.fn()} loadAttachment={load} /></ol>)
    fireEvent.click(await screen.findByRole('button', { name: /Image unavailable · Retry/ }))
    expect(await screen.findByRole('img', { name: 'Attachment.jpg' })).toBeInTheDocument()
    expect(load).toHaveBeenCalledTimes(2)
  })
  it('never enables an unscanned attachment', () => {
    render(<ChatAttachmentButton attachment={{ id: 'file', displayName: 'Attachment.pdf', mediaType: 'application/pdf', sizeBytes: 2048, scanState: 'PENDING' }} onOpen={vi.fn()} />)
    expect(screen.getByRole('button')).toBeDisabled()
    expect(screen.getByText(/2 KB/)).toBeInTheDocument()
  })
})
