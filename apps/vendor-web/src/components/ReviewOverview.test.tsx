import { fireEvent, render, screen, within } from '@testing-library/react'
import { expect, test, vi } from 'vitest'
import { ReviewListCard, ReviewOverview, type ReviewPresentationRow } from '@materyalph/web-ui'

const row: ReviewPresentationRow = { id: 'sample-review', type: 'VENDOR', displayName: 'Sample B.', ratings: { serviceQuality: 4, speedRating: 5, speedKind: 'DELIVERY_SPEED' }, comment: 'Materials arrived as agreed.', submittedAt: new Date('2026-11-04T18:00:00Z'), verifiedPurchase: true, media: [], orderReference: 'ORD-SAMPLE' }

test('store overview keeps criteria separate and labels a partial page without turning it into a store score', () => {
  const second: ReviewPresentationRow = { ...row, id: 'sample-review-2', ratings: { serviceQuality: 2, speedRating: 1, speedKind: 'PROCESSING_SPEED' }, comment: '' }
  render(<ReviewOverview rows={[row, second]} total={42} type="VENDOR" onOpen={vi.fn()} />)
  expect(screen.getByRole('figure', { name: 'Service Quality: 3.0 out of 5. 2 reviews on this page.' })).toBeInTheDocument()
  const ratings = screen.getByRole('region', { name: 'Community rating (VCS)' })
  expect(ratings).toHaveTextContent('Delivery Speed5.0/5')
  expect(ratings).toHaveTextContent('Processing Speed1.0/5')
  expect(ratings).toHaveTextContent('Separate criteria; not a VPS or VCS score.')
  expect(screen.getByRole('meter', { name: '4 stars' })).toHaveAttribute('aria-valuenow', '1')
  expect(screen.getByRole('meter', { name: '2 stars' })).toHaveAttribute('aria-valuemax', '2')
  const statistics = screen.getByRole('region', { name: 'Review statistics' })
  expect(statistics).toHaveTextContent('Total ratings42')
  expect(statistics).toHaveTextContent('Written comments1 / 2')
})

test('product overview uses server totals and distribution before pagination', () => {
  render(<ReviewOverview rows={[{ ...row, type: 'PRODUCT', ratings: { productQuality: 2 } }]} total={42} type="PRODUCT" summary={{ count: 42, average: 4.8, distribution: [{ stars: 5, count: 35 }, { stars: 4, count: 5 }, { stars: 3, count: 1 }, { stars: 2, count: 1 }, { stars: 1, count: 0 }] }} onOpen={vi.fn()} />)
  expect(screen.getByRole('figure', { name: 'Product Quality: 4.8 out of 5. All matching product reviews.' })).toBeInTheDocument()
  expect(screen.getByRole('region', { name: 'Material quality (MQS)' })).toBeInTheDocument()
  expect(screen.getByRole('meter', { name: '5 stars' })).toHaveAttribute('aria-valuenow', '35')
  expect(screen.getByRole('meter', { name: '5 stars' })).toHaveAttribute('aria-valuemax', '42')
})

test('Buyer ratings use their own criteria and recent feedback opens the original review', () => {
  const open = vi.fn()
  const buyer: ReviewPresentationRow = { ...row, type: 'BUYER', ratings: { inquirySeriousness: 3, communicationQuality: 4, paymentReliability: 5 } }
  render(<ReviewOverview rows={[buyer]} total={1} type="BUYER" onOpen={open} />)
  expect(screen.getByRole('figure', { name: /Inquiry Seriousness: 3.0 out of 5/ })).toBeInTheDocument()
  expect(screen.getByRole('region', { name: 'Ratings' })).toHaveTextContent('Ratings submitted by your store.')
  fireEvent.click(screen.getByRole('button', { name: 'Open recent feedback by Sample B.' }))
  expect(open).toHaveBeenCalledWith(buyer)
})

test('compact cards preserve independent details and report actions and Manila dates', () => {
  const open = vi.fn(), report = vi.fn()
  render(<ReviewListCard review={row} compact onOpen={open} onReport={report} />)
  const card = screen.getByRole('article')
  expect(card).toHaveTextContent('Service Quality4/5')
  expect(card).toHaveTextContent('Nov 5, 2026')
  expect(card).toHaveTextContent('Verified purchase')
  expect(card).toHaveTextContent('Order ORD-SAMPLE')
  fireEvent.click(within(card).getByRole('button', { name: 'Report' }))
  expect(report).toHaveBeenCalledOnce()
  expect(open).not.toHaveBeenCalled()
  fireEvent.click(within(card).getByRole('button', { name: /View Store rating details/ }))
  expect(open).toHaveBeenCalledOnce()
})
