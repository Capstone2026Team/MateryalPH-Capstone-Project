import { cleanup, fireEvent, render, screen, waitFor } from '@testing-library/react'
import { afterEach, expect, test, vi } from 'vitest'
import type { SiteInspection } from '@materyalph/api-client-ts'
import { manilaInstant } from '../lib/ready-mixed-concrete'
import { SiteInspectionPanel } from './SiteInspectionPanel'

afterEach(cleanup)

const requested: SiteInspection = {
  id: 'inspection-1', status: 'REQUESTED', lockVersion: 1, listing: { id: 'listing-1', displayName: 'Ready-mixed concrete' }, variant: { id: 'variant-1', label: '3000 PSI' },
  site: { locationId: 'location-1', label: 'Tower site', kind: 'PROJECT_SITE', formattedAddress: 'Aurora Blvd, Quezon City' }, preferredDate: new Date('2026-10-20'),
  buyerNotes: 'Slab is 12 m by 20 m.', scheduledFor: null, vendorNote: null, measuredVolumeM3: null, requestedAt: new Date('2026-10-16T02:00:00Z'), closedAt: null, free: true,
  actions: { cancel: false, schedule: true, decline: true, complete: false },
}

test('shows the request with only the actions the server allows', () => {
  render(<SiteInspectionPanel inspections={[requested]} busy={false} onDecide={vi.fn()} />)
  expect(screen.getByRole('heading', { name: 'Free site inspection' })).toBeVisible()
  expect(screen.getByText('Ready-mixed concrete · 3000 PSI')).toBeVisible()
  expect(screen.getByText('Slab is 12 m by 20 m.')).toBeVisible()
  expect(screen.getByRole('button', { name: 'Schedule visit' })).toBeEnabled()
  expect(screen.queryByRole('button', { name: 'Record measured volume' })).toBeNull()
})

test('declining needs a reason before calling the server', async () => {
  const onDecide = vi.fn().mockResolvedValue(undefined)
  render(<SiteInspectionPanel inspections={[requested]} busy={false} onDecide={onDecide} />)
  fireEvent.click(screen.getByRole('button', { name: 'Decline' }))
  fireEvent.click(await screen.findByRole('button', { name: 'Decline request' }))
  expect(await screen.findByText('Explain the reason in at least 10 characters.')).toBeVisible()
  expect(onDecide).not.toHaveBeenCalled()
  fireEvent.change(screen.getByLabelText('Reason'), { target: { value: 'Outside our batching area this week.' } })
  fireEvent.click(screen.getByRole('button', { name: 'Decline request' }))
  await waitFor(() => expect(onDecide).toHaveBeenCalledWith(requested, 'decline', { lockVersion: 1, reason: 'Outside our batching area this week.' }))
})

test('a scheduled request records the measured volume and offers a quotation once completed', async () => {
  const onDecide = vi.fn().mockResolvedValue(undefined)
  const scheduled: SiteInspection = { ...requested, status: 'SCHEDULED', lockVersion: 2, scheduledFor: new Date('2026-10-20T01:30:00Z'), actions: { cancel: false, schedule: true, decline: true, complete: true } }
  const { rerender } = render(<SiteInspectionPanel inspections={[scheduled]} busy={false} onDecide={onDecide} />)
  fireEvent.click(screen.getByRole('button', { name: 'Record measured volume' }))
  fireEvent.change(await screen.findByLabelText('Measured volume (m³)'), { target: { value: '7.5' } })
  fireEvent.click(screen.getByRole('button', { name: 'Save volume' }))
  await waitFor(() => expect(onDecide).toHaveBeenCalledWith(scheduled, 'complete', { lockVersion: 2, measuredVolumeM3: '7.5' }))
  const prepare = vi.fn()
  rerender(<SiteInspectionPanel inspections={[{ ...scheduled, status: 'COMPLETED', measuredVolumeM3: '7.500', actions: { cancel: false, schedule: false, decline: false, complete: false } }]} busy={false} onDecide={onDecide} onPrepareQuotation={prepare} />)
  fireEvent.click(screen.getByRole('button', { name: 'Prepare quotation for 7.5 m³' }))
  expect(prepare).toHaveBeenCalled()
})

test('schedule times are Philippine local times', () => {
  expect(manilaInstant('2026-10-20T09:30')).toBe('2026-10-20T09:30:00+08:00')
  expect(manilaInstant('')).toBeNull()
})
