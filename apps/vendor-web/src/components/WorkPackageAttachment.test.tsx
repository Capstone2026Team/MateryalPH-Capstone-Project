import { fireEvent, render, screen, within } from '@testing-library/react'
import { describe, expect, it } from 'vitest'
import { WorkPackageAttachment } from './WorkPackageAttachment'

describe('Project Work Package attachment', () => {
  it('opens a compact card with only this store allocation and its assigned quantity', () => {
    render(<WorkPackageAttachment compact reference={{ version: 2, arrangement_id: 'group', work_package: { name: 'Foundation', budget_centavos: 999900,
      lines: [{ id: 'blocks', name: 'Assigned blocks', quantity: '100', unit_code: 'PC', specifications: { thickness_mm: '100' } }, { id: 'cement', name: 'Another vendor cement', quantity: '30', unit_code: 'BAG' }] },
      vendor_allocations: [{ line_id: 'blocks', name: 'Assigned blocks', quantity: '5', unit_code: 'PC' }] }} />)
    fireEvent.click(screen.getByRole('button', { name: /Foundation.*1 material.*View details/ }))
    const modal = screen.getByRole('dialog', { name: 'Work Package' })
    const materials = within(modal).getByRole('region', { name: 'Items' })
    expect(materials).toHaveTextContent('Assigned blocks')
    expect(materials).toHaveTextContent('5 PC')
    expect(within(materials).getByText('Thickness mm: 100')).toBeInTheDocument()
    expect(modal).not.toHaveTextContent('Another vendor cement')
    expect(modal).not.toHaveTextContent('100 PC')
    expect(modal).not.toHaveTextContent('Budget')
    fireEvent.click(within(modal).getByRole('button', { name: 'Close work package' }))
    expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
  })
  it('shows accepted order items and fulfillment details without an obsolete proposal', () => {
    render(<WorkPackageAttachment compact proposal={{ lines: [{ description: 'Obsolete proposal', quantity: '99', unit_price_centavos: 9999 }] }} reference={{ material_scope: 'VENDOR_ORDER', order: { id: 'order', reference: 'ORD-SAMPLE', accepted: true },
      work_package: { name: 'Foundation', site: { name: 'Main site', point: { formatted_address: 'Quezon City' } }, fulfillment_method: 'PICKUP', payment_method: 'ONLINE', fulfillment_date: '2026-11-10',
        lines: [{ name: 'Accepted blocks', quantity: '3', unit_code: 'PC', unit_price_centavos: 1700, specifications: { thickness_mm: '100' } }] } }} />)
    fireEvent.click(screen.getByRole('button', { name: /Foundation/ }))
    const modal = screen.getByRole('dialog', { name: 'Work Package' })
    const items = within(modal).getByRole('region', { name: 'Items' })
    expect(items).toHaveTextContent('3 PC')
    const table = within(items).getByRole('table')
    expect(within(table).getByRole('columnheader', { name: 'Unit price' })).toBeInTheDocument()
    expect(within(table).getByRole('cell', { name: '₱17.00' })).toBeInTheDocument()
    expect(within(table).getByRole('cell', { name: '₱51.00' })).toBeInTheDocument()
    expect(modal).toHaveTextContent('ORD-SAMPLE')
    expect(modal).toHaveTextContent('Accepted terms')
    expect(modal).toHaveTextContent('Quezon City')
    expect(within(items).getByText('Expected fulfillment').nextElementSibling).toHaveTextContent('2026-11-10')
    expect(modal).not.toHaveTextContent('Obsolete proposal')
    expect(within(modal).getAllByRole('table')).toHaveLength(1)
  })
  it('shows one item list and one set of details, using the current items instead of a comparison', () => {
    render(<WorkPackageAttachment reference={{version_id:'v1',content_hash:'hash',work_package:{name:'Foundation',budget_centavos:10000,site:{name:'House site',point:{formatted_address:'Quezon City'}},destination:{vehicle_endpoint:'ALTERNATE_DROP_OFF'},lines:[{id:'a',name:'Blocks',quantity:'10',unit_code:'PC',specifications:{thickness_mm:'100'}}]},working_duplicate:{lines:[{variant_id:'b',description:'Proposed blocks',quantity:'8',unit_price_centavos:1500}]}}} />)
    expect(screen.getAllByRole('table')).toHaveLength(1)
    expect(screen.getByRole('table')).toHaveTextContent('Proposed blocks')
    expect(screen.queryByRole('rowheader', { name: /^Blocks/ })).not.toBeInTheDocument()
    expect(screen.getAllByRole('region', { name: 'Payment summary' })).toHaveLength(1)
    expect(screen.getAllByRole('region', { name: 'Delivery and payment' })).toHaveLength(1)
    expect(screen.getByText('Alternative vehicle drop-off')).toBeInTheDocument()
    expect(screen.queryByText(/Buyer original|Your quotation|Materials for your store/)).not.toBeInTheDocument()
    expect(screen.queryByRole('button',{name:/Phase 15/})).not.toBeInTheDocument()
  })
  it('keeps attachment actions and an empty item state', () => {
    render(<WorkPackageAttachment reference={{version: 1, work_package: {name: 'Foundation', fulfillment_method: 'BOTH', lines: []}}} actions={<button>Export PDF</button>} />)
    expect(screen.getByRole('button', {name: 'Export PDF'})).toBeEnabled()
    expect(screen.getByText('Pickup or site delivery')).toBeInTheDocument()
    expect(screen.getByText('No items to display.')).toBeInTheDocument()
  })
  it('does not show a Project attachment for Item-Based conversations', () => {
    const {container}=render(<WorkPackageAttachment reference={{lines:[]}} />)
    expect(container).toBeEmptyDOMElement()
  })
  it('rounds fractional line totals with the shared centavo calculation and leaves missing prices unquoted', () => {
    render(<WorkPackageAttachment reference={{ material_scope: 'VENDOR_ALLOCATION', work_package: { name: 'Foundation', lines: [] } }}
      proposal={{ lines: [{ variant_id: 'fractional', description: 'Cut material', quantity: '0.125', unit_code: 'M', unit_price_centavos: 101 }, { variant_id: 'unpriced', description: 'Unpriced material', quantity: '2', unit_code: 'PC' }] }} />)
    const proposal = screen.getByRole('region', { name: 'Items' })
    const table = within(proposal).getByRole('table')
    expect(within(table).getByRole('row', { name: /Cut material/ })).toHaveTextContent('₱0.13')
    expect(within(table).getByRole('row', { name: /Unpriced material/ })).toHaveTextContent('—')
    expect(within(proposal).queryByRole('region', { name: 'Payment summary' })).not.toBeInTheDocument()
  })
  it('uses the recorded commercial totals and included VAT in the listed payment summary', () => {
    render(<WorkPackageAttachment reference={{ material_scope: 'VENDOR_ALLOCATION', work_package: { name: 'Foundation', lines: [] } }}
      proposal={{ lines: [{ variant_id: 'blocks', description: 'Quoted blocks', quantity: '8', unit_code: 'PC', unit_price_centavos: 5000 }], fulfillment_method: 'DELIVERY', payment_method: 'ONLINE',
        commercial: { materials_gross_centavos: 40000, materials_payable_centavos: 35000, vendor_discount_centavos: 5000, materials_vat_centavos: 3750, delivery_centavos: 2000, commercial_total_centavos: 37000 } }} />)
    const proposal = screen.getByRole('region', { name: 'Items' })
    const summary = within(proposal).getByRole('region', { name: 'Payment summary' })
    expect(within(proposal).getByRole('table')).toHaveTextContent('₱400.00')
    expect(within(summary).getByText('Materials after discount').nextElementSibling).toHaveTextContent('₱350.00')
    expect(within(summary).getByText('Included VAT (in materials)').nextElementSibling).toHaveTextContent('₱37.50')
    expect(within(summary).getByText('Total before e-wallet transaction fee').nextElementSibling).toHaveTextContent('₱370.00')
    expect(summary).not.toHaveTextContent('E-wallet transaction fee')
  })
  it('keeps an explicitly empty item list empty instead of restoring the original items', () => {
    render(<WorkPackageAttachment reference={{ material_scope: 'VENDOR_ALLOCATION', work_package: { name: 'Foundation', lines: [{ name: 'Removed material', quantity: '10' }] } }} proposal={{ lines: [] }} />)
    expect(screen.getByText('No items to display.')).toBeInTheDocument()
    expect(screen.queryByText('Removed material')).not.toBeInTheDocument()
    expect(screen.queryByRole('table')).not.toBeInTheDocument()
  })
})
