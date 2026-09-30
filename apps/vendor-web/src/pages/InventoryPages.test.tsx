import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import { ResponseError } from '@materyalph/api-client-ts'
import * as inventory from '../lib/inventory-api'
import type { AutoAcceptPolicyDetail, InventoryLedgerMeta, InventoryRow } from '../lib/inventory-api'
import * as onboarding from '../lib/onboarding-api'
import { VendorInventoryPage } from './InventoryPages'

vi.mock('../lib/onboarding-api', async original => ({ ...await original<typeof import('../lib/onboarding-api')>(), getVendorOnboarding: vi.fn(), getVendorPrivateFileUrl: vi.fn() }))
vi.mock('../lib/inventory-api', async original => ({
  ...await original<typeof import('../lib/inventory-api')>(),
  listInventory: vi.fn(), updateInventoryRow: vi.fn(), confirmStock: vi.fn(), listMovements: vi.fn(), listPriceHistory: vi.fn(), getInventorySettings: vi.fn(), saveInventorySettings: vi.fn(),
  getAutoAccept: vi.fn(), configureAutoAccept: vi.fn(), updateAllotment: vi.fn(), pauseAutoAccept: vi.fn(), resumeAutoAccept: vi.fn(),
}))

const schedule = (state: InventoryRow['stockConfirmation']['state'], confirmedAt: string | null, hideAt: string | null) => ({ state, confirmedAt: confirmedAt ? new Date(confirmedAt) : null, firstReminderAt: null, finalReminderAt: null, hideAt: hideAt ? new Date(hideAt) : null, daysSinceConfirmation: null })
const policy = (overrides: Partial<InventoryRow['autoAccept']> = {}): InventoryRow['autoAccept'] => ({ status: 'DISABLED', enabled: false, paused: false, pauseReason: null, pausedAt: null, allotmentQuantity: '0', remainingAllotmentQuantity: '0', maxUnitCount: null, maxOrderAmountCentavos: null, currentVersion: 0, lockVersion: 0, updatedAt: null, ...overrides })

function row(overrides: Partial<InventoryRow> = {}): InventoryRow {
  return {
    listingVariantId: 'variant-1', listingId: 'listing-1', listingName: 'Portland cement', listingStatus: 'ACTIVE', variantLabel: '40 kg', sku: 'CEM-40-1', unitCode: 'BAG', lockVersion: 4,
    inventory: { quantityOnHand: '120.0000', hardReservedQuantity: '20.0000', softHeldQuantity: '30.0000', availableToSell: '100.0000', reorderLevel: '100.0000', confirmedAt: new Date('2026-10-01T00:00:00Z') },
    publicLabel: 'LIMITED_STOCK', stockConfirmation: schedule('REMINDER', '2026-10-01T00:00:00Z', '2026-10-16T00:00:00Z'), listingConfirmation: schedule('REMINDER', '2026-10-01T00:00:00Z', '2026-10-16T00:00:00Z'),
    price: { priceVersionId: 'price-2', version: 2, amountCentavos: 28550, taxCategory: 'NON_VAT', effectiveAt: null },
    comparability: { status: 'NOT_YET_COMPARABLE', groupVersionId: null, ruleVersion: 'mat03' }, autoAccept: policy(),
    ...overrides,
  }
}

function meta(permissions: Partial<InventoryLedgerMeta['permissions']> = {}): InventoryLedgerMeta {
  return {
    currentPage: 1, lastPage: 1, total: 1, pageSize: 25, labelRuleVersion: 'test', timezone: 'Asia/Manila',
    summary: { variants: 1, outOfStock: 0, limitedStock: 1, confirmationDue: 1, stale: 0 },
    staleListings: { count: 1, items: [{ listingId: 'listing-1', listingName: 'Portland cement', listingStatus: 'ACTIVE', confirmation: schedule('REMINDER', '2026-10-01T00:00:00Z', '2026-10-16T00:00:00Z') }] },
    permissions: { canAdjust: true, canChangePrice: true, canConfigureAutoAccept: true, canUpdateAllotment: true, canViewAutoAccept: true, canEditSettings: true, ...permissions },
  }
}

function detail(overrides: Partial<AutoAcceptPolicyDetail['policy']> = {}, canConfigure = true): AutoAcceptPolicyDetail {
  return {
    listingVariantId: 'variant-1', listingId: 'listing-1', listingName: 'Portland cement', listingStatus: 'ACTIVE', variantLabel: '40 kg', sku: 'CEM-40-1', unitCode: 'BAG',
    stock: { quantityOnHand: '120.0000', hardReservedQuantity: '20.0000', softHeldQuantity: '30.0000', availableToSell: '100.0000' },
    policy: policy(overrides), versions: [], scope: { itemBasedOnly: true, nrpcExcluded: true, projectBasedExcluded: true, ruleVersion: 'test' },
    permissions: { canConfigure, canUpdateAllotment: true },
  }
}

function conflict(body: unknown): ResponseError {
  return new ResponseError(new Response(JSON.stringify(body), { status: 409, headers: { 'Content-Type': 'application/json' } }), 'conflict')
}

beforeEach(() => {
  vi.clearAllMocks()
  vi.mocked(onboarding.getVendorOnboarding).mockResolvedValue({ stepCompletion: [], lockVersion: 1, requirements: [], drafts: [], organization: { store_name: 'Test Supply' }, welcomeRequired: false, permissions: ['portal.products', 'catalog.manage', 'inventory.view', 'inventory.manage'], verification: {}, setup: { status: 'COMPLETED' }, activation: { status: 'ACTIVE', marketplaceDiscoverabilityStatus: 'DISCOVERABLE', readiness: { ready: true, blockers: [], status: 'READY', ruleVersion: 'test' } }, sections: {} })
  vi.mocked(onboarding.getVendorPrivateFileUrl).mockResolvedValue({ url: 'https://example.test/logo', expiresAt: new Date() })
  vi.mocked(inventory.listInventory).mockResolvedValue({ items: [row()], meta: meta() })
  vi.mocked(inventory.getInventorySettings).mockResolvedValue({ reminderLocalTime: '08:00', emailReminders: true, inAppReminders: true, timezone: 'Asia/Manila', reminderDays: [7, 12], hideAfterDays: 15, autoAcceptReadyLeadDays: null, lockVersion: 0, canEdit: true })
})

function open(path = '/products/inventory') {
  return render(<MemoryRouter initialEntries={[path]}><Routes><Route path="/products/inventory" element={<VendorInventoryPage />} /><Route path="/products" element={<h1>Listings</h1>} /></Routes></MemoryRouter>)
}

test('the ledger shows private quantities beside the public label and a stale-stock band with the exact Manila date', async () => {
  open()
  const ledger = await screen.findByRole('table', { name: 'Inventory ledger' })
  expect(screen.getByRole('region', { name: 'Inventory ledger' })).toHaveAttribute('tabindex', '0')
  const header = within(ledger).getAllByRole('columnheader').map(cell => cell.textContent)
  expect(header).toEqual(expect.arrayContaining(['On hand', 'Hard reserved', 'Soft-held', 'Available to sell', 'Reorder level', 'Buyers see', 'Auto-accept']))
  const cells = within(ledger).getAllByRole('row')[1]!
  expect(within(cells).getByText('120')).toBeInTheDocument()
  expect(within(cells).getByText('Limited Stock')).toBeInTheDocument()
  expect(within(cells).getByText('Off')).toBeInTheDocument()
  const band = screen.getByRole('region', { name: /need a stock confirmation/ })
  expect(within(band).getByText(/Oct 16, 2026/)).toHaveTextContent('(Asia/Manila)')
  expect(within(band).getByText(/Your store is not suspended/)).toBeInTheDocument()
  expect(screen.getByRole('link', { name: 'Inventory' })).toHaveAttribute('aria-current', 'page')
})

test('a stale inline edit keeps the typed values and shows the saved row instead of overwriting it', async () => {
  vi.mocked(inventory.updateInventoryRow).mockRejectedValueOnce(conflict({ data: null, meta: {}, errors: [{ code: 'STALE_VERSION', message: 'Changed', details: { current: { listing_variant_id: 'variant-1', listing_id: 'listing-1', listing_name: 'Portland cement', listing_status: 'ACTIVE', variant_label: '40 kg', sku: 'CEM-40-1', unit_code: 'BAG', lock_version: 5, inventory: { quantity_on_hand: '140.0000', hard_reserved_quantity: '20.0000', soft_held_quantity: '30.0000', available_to_sell: '120.0000', reorder_level: '100.0000', confirmed_at: '2026-10-02T00:00:00Z' }, public_label: 'IN_STOCK', stock_confirmation: { state: 'CONFIRMED', confirmed_at: null, first_reminder_at: null, final_reminder_at: null, hide_at: null, days_since_confirmation: null }, listing_confirmation: { state: 'CONFIRMED', confirmed_at: null, first_reminder_at: null, final_reminder_at: null, hide_at: null, days_since_confirmation: null }, price: { price_version_id: 'price-2', version: 2, amount_centavos: 28550, tax_category: 'NON_VAT', effective_at: null }, comparability: { status: 'NOT_YET_COMPARABLE', group_version_id: null, rule_version: 'mat03' }, auto_accept: { status: 'DISABLED', enabled: false, paused: false, pause_reason: null, paused_at: null, allotment_quantity: '0', remaining_allotment_quantity: '0', max_unit_count: null, max_order_amount_centavos: null, current_version: 0, lock_version: 0, updated_at: null } } } }] }))
  vi.mocked(inventory.updateInventoryRow).mockResolvedValueOnce(row({ lockVersion: 6, inventory: { ...row().inventory!, quantityOnHand: '150.0000' } }))
  open()
  fireEvent.click(await screen.findByRole('button', { name: 'Edit Portland cement — 40 kg' }))
  const form = screen.getByRole('form', { name: 'Edit Portland cement — 40 kg' })
  fireEvent.change(within(form).getByLabelText('Quantity on hand (BAG)'), { target: { value: '150' } })
  fireEvent.change(within(form).getByLabelText('Reason for the change'), { target: { value: 'RECEIVED' } })
  fireEvent.click(within(form).getByRole('button', { name: 'Save row' }))
  await waitFor(() => expect(inventory.updateInventoryRow).toHaveBeenCalledWith('variant-1', { lockVersion: 4, quantityOnHand: '150', reasonCode: 'RECEIVED', note: null }))
  const banner = await within(form).findByRole('alert')
  expect(banner).toHaveTextContent('This row changed while you were editing')
  expect(within(banner).getByText('140 BAG')).toBeInTheDocument()
  expect(within(form).getByLabelText('Quantity on hand (BAG)')).toHaveValue('150')
  fireEvent.click(within(banner).getByRole('button', { name: 'Use current values' }))
  expect(within(form).getByLabelText('Quantity on hand (BAG)')).toHaveValue('140')
  fireEvent.change(within(form).getByLabelText('Quantity on hand (BAG)'), { target: { value: '150' } })
  fireEvent.click(within(form).getByRole('button', { name: 'Save row' }))
  await waitFor(() => expect(inventory.updateInventoryRow).toHaveBeenLastCalledWith('variant-1', expect.objectContaining({ lockVersion: 5, quantityOnHand: '150' })))
  expect(await screen.findByText('Portland cement — 40 kg saved.')).toBeInTheDocument()
})

test('a price change sends the price version it replaces and roles without stock authority cannot edit', async () => {
  vi.mocked(inventory.updateInventoryRow).mockResolvedValueOnce(row())
  open()
  fireEvent.click(await screen.findByRole('button', { name: 'Edit Portland cement — 40 kg' }))
  fireEvent.change(screen.getByLabelText('Ordinary price (₱)'), { target: { value: '299.00' } })
  fireEvent.click(screen.getByRole('button', { name: 'Save row' }))
  await waitFor(() => expect(inventory.updateInventoryRow).toHaveBeenCalledWith('variant-1', { lockVersion: 4, price: { expectedPriceVersionId: 'price-2', amountCentavos: 29900 } }))
})

test('the Customer Service sales stock view is read-only', async () => {
  vi.mocked(inventory.listInventory).mockResolvedValue({ items: [row()], meta: meta({ canAdjust: false, canChangePrice: false, canConfigureAutoAccept: false, canUpdateAllotment: false, canEditSettings: false }) })
  open()
  expect(await screen.findByRole('table', { name: 'Inventory ledger' })).toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Edit Portland cement — 40 kg' })).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Confirm counts on this page' })).not.toBeInTheDocument()
  expect(screen.getByRole('button', { name: 'Auto-accept for Portland cement — 40 kg' })).toBeInTheDocument()
  expect(screen.getByRole('button', { name: 'History of Portland cement — 40 kg' })).toBeInTheDocument()
})

test('auto-accept is one surface with a switch, three safeguards, a text pause state and a confirmed resume naming the allotment', async () => {
  vi.mocked(inventory.getAutoAccept).mockResolvedValueOnce(detail())
  vi.mocked(inventory.configureAutoAccept).mockResolvedValueOnce(detail({ status: 'PAUSED', enabled: true, paused: true, pauseReason: 'ALLOTMENT_EXHAUSTED', remainingAllotmentQuantity: '12', lockVersion: 3 }))
  vi.mocked(inventory.resumeAutoAccept).mockResolvedValueOnce(detail({ status: 'ACTIVE', enabled: true, remainingAllotmentQuantity: '12', lockVersion: 4 }))
  open()
  fireEvent.click(await screen.findByRole('button', { name: 'Auto-accept for Portland cement — 40 kg' }))
  const panel = await screen.findByRole('region', { name: 'Item-Based auto-accept' })
  expect(within(panel).getByRole('status')).toHaveTextContent('Off — every order waits for manual confirmation (default)')
  expect(within(panel).getByText(/Project-Based procurement and any order with NRPC always wait for manual review/)).toBeInTheDocument()
  const toggle = within(panel).getByRole('switch', { name: 'Enable auto-accept' })
  expect(toggle).toHaveAttribute('aria-checked', 'false')
  fireEvent.click(toggle)
  fireEvent.change(within(panel).getByLabelText('Allotment (BAG)'), { target: { value: '12' } })
  fireEvent.change(within(panel).getByLabelText('Max units per order (BAG)'), { target: { value: '5' } })
  fireEvent.change(within(panel).getByLabelText('Max order amount (₱)'), { target: { value: '15000.50' } })
  fireEvent.click(within(panel).getByRole('button', { name: 'Save auto-accept' }))
  await waitFor(() => expect(inventory.configureAutoAccept).toHaveBeenCalledWith('variant-1', { lockVersion: 0, enabled: true, allotmentQuantity: '12', maxUnitCount: '5', maxOrderAmountCentavos: 1500050 }))
  expect(await within(panel).findByText('Paused — the allotment reached zero')).toBeInTheDocument()
  fireEvent.click(within(panel).getByRole('button', { name: 'Resume' }))
  const dialog = await screen.findByRole('dialog', { name: 'Resume auto-accept?' })
  expect(within(dialog).getByText('12 BAG')).toBeInTheDocument()
  fireEvent.click(within(dialog).getByRole('button', { name: 'Resume with 12 BAG' }))
  await waitFor(() => expect(inventory.resumeAutoAccept).toHaveBeenCalledWith('variant-1', 3, '12'))
})

test('staff limited to the allotment grant can save the allotment but not the safeguards', async () => {
  vi.mocked(inventory.getAutoAccept).mockResolvedValueOnce(detail({ status: 'PAUSED', enabled: true, paused: true, pauseReason: 'ALLOTMENT_EXHAUSTED', lockVersion: 2 }, false))
  vi.mocked(inventory.updateAllotment).mockResolvedValueOnce(detail({ status: 'PAUSED', enabled: true, paused: true, pauseReason: 'ALLOTMENT_EXHAUSTED', remainingAllotmentQuantity: '8', lockVersion: 3 }, false))
  open()
  fireEvent.click(await screen.findByRole('button', { name: 'Auto-accept for Portland cement — 40 kg' }))
  const panel = await screen.findByRole('region', { name: 'Item-Based auto-accept' })
  expect(within(panel).getByRole('switch', { name: 'Enable auto-accept' })).toBeDisabled()
  expect(within(panel).getByLabelText('Max order amount (₱)')).toBeDisabled()
  expect(within(panel).queryByRole('button', { name: 'Resume' })).not.toBeInTheDocument()
  fireEvent.change(within(panel).getByLabelText('Allotment (BAG)'), { target: { value: '8' } })
  fireEvent.click(within(panel).getByRole('button', { name: 'Save allotment' }))
  await waitFor(() => expect(inventory.updateAllotment).toHaveBeenCalledWith('variant-1', 2, '8'))
  expect(await screen.findByText(/stays paused until the Owner or Store Manager resumes it/)).toBeInTheDocument()
  expect(within(panel).getByText('Paused — the allotment reached zero')).toBeInTheDocument()
})

test('bulk confirmation is all-or-nothing and a conflict refreshes the ledger', async () => {
  vi.mocked(inventory.confirmStock).mockRejectedValueOnce(conflict({ data: null, meta: {}, errors: [{ code: 'STALE_VERSION', message: 'Changed', details: {} }] }))
  open()
  fireEvent.click(await screen.findByRole('button', { name: 'Confirm counts on this page' }))
  fireEvent.click(await screen.findByRole('button', { name: 'Confirm 1 count' }))
  await waitFor(() => expect(inventory.confirmStock).toHaveBeenCalledWith([{ listingVariantId: 'variant-1', lockVersion: 4 }]))
  expect(await screen.findByText(/nothing was confirmed/)).toBeInTheDocument()
  await waitFor(() => expect(inventory.listInventory).toHaveBeenCalledTimes(2))
})

test('a failed load offers retry instead of a false empty state', async () => {
  vi.mocked(inventory.listInventory).mockRejectedValueOnce(new TypeError('Failed to fetch'))
  open()
  const retry = await screen.findByRole('button', { name: /Try again/ })
  expect(screen.queryByText('No stock to track yet.')).not.toBeInTheDocument()
  fireEvent.click(retry)
  expect(await screen.findByRole('table', { name: 'Inventory ledger' })).toBeInTheDocument()
})
