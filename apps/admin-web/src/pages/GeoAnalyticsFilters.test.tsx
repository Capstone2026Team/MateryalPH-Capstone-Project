import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { afterEach, beforeEach, expect, test, vi } from 'vitest'
import { GeoFilterBar } from './GeoAnalyticsPage'
import { getGeoFilterOptions, type GeoFilters } from '../lib/geo-analytics-api'

vi.mock('../lib/geo-analytics-api', async importOriginal => ({
  ...await importOriginal<typeof import('../lib/geo-analytics-api')>(),
  getGeoFilterOptions: vi.fn(),
}))

const filters: GeoFilters = { dataset: 'TEST', area: null, from: '2026-10-01', to: '2026-10-27', granularity: 'WEEK', categoryId: '', materialId: '', procurementType: '', fulfillmentMethod: '', paymentMethod: '', orderState: '' }
const categories = [{ id: 'steel', name: 'Steel and Reinforcement' }, { id: 'cement', name: 'Cement without orders' }, ...Array.from({ length: 10 }, (_, i) => ({ id: `category-${i}`, name: `Material category ${i}` }))]

beforeEach(() => {
  vi.mocked(getGeoFilterOptions).mockImplementation(async categoryId => categoryId === undefined ? categories : [{ id: `${categoryId}-material`, name: `${categoryId} material without orders` }])
})
afterEach(() => vi.clearAllMocks())

test('offers the complete taxonomy, applies category and material, and clears the previous material when category changes', async () => {
  const onApply = vi.fn()
  render(<GeoFilterBar filters={filters} dashboard={null} onApply={onApply} />)
  fireEvent.click(screen.getByRole('button', { name: 'Filters' }))
  const category = screen.getByRole('combobox', { name: 'Category' })
  const material = screen.getByRole('combobox', { name: 'Material' })
  expect(material).toBeDisabled()
  await screen.findByRole('option', { name: 'Cement without orders' })
  expect(within(category).getAllByRole('option')).toHaveLength(13)
  fireEvent.change(category, { target: { value: 'cement' } })
  await screen.findByRole('option', { name: 'cement material without orders' })
  fireEvent.change(material, { target: { value: 'cement-material' } })
  fireEvent.click(screen.getByRole('button', { name: 'Apply filters' }))
  expect(onApply).toHaveBeenLastCalledWith({ ...filters, categoryId: 'cement', materialId: 'cement-material' })
  fireEvent.change(category, { target: { value: 'steel' } })
  await screen.findByRole('option', { name: 'steel material without orders' })
  expect(material).toHaveValue('')
  expect(screen.queryByRole('option', { name: 'cement material without orders' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Apply filters' }))
  expect(onApply).toHaveBeenLastCalledWith({ ...filters, categoryId: 'steel', materialId: '' })
})

test('taxonomy choices remain available when dates, geography and transaction filters change', async () => {
  const { rerender } = render(<GeoFilterBar filters={filters} dashboard={null} onApply={vi.fn()} />)
  fireEvent.click(screen.getByRole('button', { name: 'Filters' }))
  await screen.findByRole('option', { name: 'Cement without orders' })
  rerender(<GeoFilterBar filters={{ ...filters, from: '2026-10-26', area: '1300000000', paymentMethod: 'IN_STORE' }} dashboard={null} onApply={vi.fn()} />)
  expect(screen.getByRole('option', { name: 'Cement without orders' })).toBeInTheDocument()
  expect(getGeoFilterOptions).toHaveBeenCalledTimes(1)
})

test('a failed taxonomy request can be retried', async () => {
  vi.mocked(getGeoFilterOptions).mockRejectedValueOnce(new Error('Taxonomy unavailable'))
  render(<GeoFilterBar filters={filters} dashboard={null} onApply={vi.fn()} />)
  fireEvent.click(screen.getByRole('button', { name: 'Filters' }))
  const retry = await screen.findByRole('button', { name: 'Try again' })
  fireEvent.click(retry)
  await screen.findByRole('option', { name: 'Cement without orders' })
  await waitFor(() => expect(retry).not.toBeInTheDocument())
})

test('a late material response cannot replace the newly selected category', async () => {
  let finishSteel!: (value: { id: string; name: string }[]) => void
  vi.mocked(getGeoFilterOptions).mockImplementation(async categoryId => {
    if (!categoryId) return categories
    if (categoryId === 'steel') return new Promise(resolve => { finishSteel = resolve })
    return [{ id: 'cement-material', name: 'Cement material' }]
  })
  render(<GeoFilterBar filters={filters} dashboard={null} onApply={vi.fn()} />)
  fireEvent.click(screen.getByRole('button', { name: 'Filters' }))
  await screen.findByRole('option', { name: 'Cement without orders' })
  fireEvent.change(screen.getByRole('combobox', { name: 'Category' }), { target: { value: 'steel' } })
  await waitFor(() => expect(finishSteel).toBeDefined())
  fireEvent.change(screen.getByRole('combobox', { name: 'Category' }), { target: { value: 'cement' } })
  await screen.findByRole('option', { name: 'Cement material' })
  finishSteel([{ id: 'steel-material', name: 'Stale steel material' }])
  await waitFor(() => expect(screen.queryByRole('option', { name: 'Stale steel material' })).not.toBeInTheDocument())
})

test('filters start collapsed and retain unapplied selections when closed and reopened', async () => {
  const onApply = vi.fn()
  render(<GeoFilterBar filters={filters} dashboard={null} onApply={onApply} />)
  const toggle = screen.getByRole('button', { name: 'Filters' })
  expect(toggle).toHaveAttribute('aria-expanded', 'false')
  expect(screen.queryByRole('form', { name: 'Dashboard filters' })).not.toBeInTheDocument()
  expect(screen.getAllByText('Oct 1, 2026 – Oct 27, 2026').find(element => !element.closest('[hidden]'))).toBeVisible()
  expect(screen.getByText('Weekly trends')).toBeVisible()
  fireEvent.click(toggle)
  expect(toggle).toHaveAttribute('aria-expanded', 'true')
  expect(screen.getByRole('form', { name: 'Dashboard filters' })).toBeVisible()
  expect(document.getElementById(toggle.getAttribute('aria-controls')!)).toBeVisible()
  await screen.findByRole('option', { name: 'Cement without orders' })
  fireEvent.change(screen.getByRole('combobox', { name: 'Payment' }), { target: { value: 'ONLINE' } })
  fireEvent.click(toggle)
  expect(screen.queryByRole('combobox', { name: 'Payment' })).not.toBeInTheDocument()
  expect(onApply).not.toHaveBeenCalled()
  fireEvent.click(toggle)
  expect(screen.getByRole('combobox', { name: 'Payment' })).toHaveValue('ONLINE')
  fireEvent.click(screen.getByRole('button', { name: 'Apply filters' }))
  expect(onApply).toHaveBeenCalledWith({ ...filters, paymentMethod: 'ONLINE' })
})
