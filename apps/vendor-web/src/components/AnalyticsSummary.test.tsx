import { render, screen, within } from '@testing-library/react'
import { expect, test } from 'vitest'
import { AnalyticsSummary } from '../../../../packages/web-ui/src/analytics-layout'

test('summary keeps the heading, metric values, hints and decorative icons', () => {
  render(<AnalyticsSummary
    title="Marketplace overview"
    context="Marketplace · last 30 days"
    featured={{ label: 'Gross GMV', value: <span>₱34,584.70</span>, hint: 'Confirmed order value', icon: <svg data-testid="gmv-icon" />, changePercent: 12.4, comparison: 'vs previous 30 days' }}
    metrics={[{ label: 'Confirmed orders', value: 7, hint: 'In the selected dates', icon: <svg data-testid="orders-icon" />, changePercent: -3.2, comparison: 'vs previous 30 days' }]}
  />)

  const summary = within(screen.getByRole('region', { name: 'At a glance' }))
  expect(summary.getByRole('heading', { name: 'Marketplace overview' })).toBeVisible()
  expect(summary.getByText('Marketplace · last 30 days')).toBeVisible()
  expect(summary.getByText('Gross GMV')).toBeVisible()
  expect(summary.getByText('₱34,584.70')).toBeVisible()
  expect(summary.getByText('Confirmed order value')).toBeVisible()
  expect(summary.getByText('Confirmed orders')).toBeVisible()
  expect(summary.getByText('7')).toBeVisible()
  expect(summary.getByText('In the selected dates')).toBeVisible()
  expect(summary.getByTestId('gmv-icon').parentElement).toHaveAttribute('aria-hidden', 'true')
  expect(summary.getByTestId('orders-icon').parentElement).toHaveAttribute('aria-hidden', 'true')
  expect(summary.getByText('Increase:')).toBeInTheDocument()
  expect(summary.getByText('Decrease:')).toBeInTheDocument()
})

test.each([
  { changePercent: 12.44, value: '+12.4%', label: 'Increase:', direction: 'up', icon: 'trending-up' },
  { changePercent: -3.24, value: '-3.2%', label: 'Decrease:', direction: 'down', icon: 'trending-down' },
  { changePercent: 0, value: '0.0%', label: 'No change:', direction: 'flat', icon: 'minus' },
  { changePercent: -0.04, value: '0.0%', label: 'No change:', direction: 'flat', icon: 'minus' },
])('$changePercent renders a readable $direction indicator rounded to one decimal', ({ changePercent, value, label, direction, icon }) => {
  render(<AnalyticsSummary featured={{ label: 'Gross GMV', value: '₱34,584.70', changePercent, comparison: 'vs previous 30 days' }} metrics={[]} />)

  const percentage = screen.getByText(value)
  const change = percentage.closest('dd')!
  expect(change).toHaveAttribute('data-direction', direction)
  expect(within(change).getByText(label)).toBeInTheDocument()
  expect(change.querySelector(`.lucide-${icon}`)).toHaveAttribute('aria-hidden', 'true')
  const comparison = within(change).getByText('vs previous 30 days')
  expect(comparison).toBeVisible()
  expect(percentage.parentElement).not.toContainElement(comparison)
  expect(screen.queryByText('-0.0%')).not.toBeInTheDocument()
})

test.each([undefined, null, Number.NaN, Number.POSITIVE_INFINITY, Number.NEGATIVE_INFINITY])('an unavailable numeric change (%s) does not invent a percentage or comparison', changePercent => {
  render(<AnalyticsSummary featured={{ label: 'Gross GMV', value: '₱34,584.70', changePercent, comparison: 'vs previous 30 days' }} metrics={[]} />)

  expect(screen.getByText('₱34,584.70')).toBeVisible()
  expect(screen.queryByText(/%/)).not.toBeInTheDocument()
  expect(screen.queryByText('vs previous 30 days')).not.toBeInTheDocument()
  expect(screen.queryByText('No comparison')).not.toBeInTheDocument()
})

test.each([null, Number.NaN, Number.POSITIVE_INFINITY])('an explicitly unavailable comparison explains the missing change (%s)', changePercent => {
  render(<AnalyticsSummary featured={{ label: 'Gross GMV', value: '₱34,584.70', changePercent, comparisonUnavailable: 'No activity in the previous period' }} metrics={[]} />)

  expect(screen.getByText('No comparison')).toBeVisible()
  expect(screen.getByText('No activity in the previous period')).toBeVisible()
  expect(screen.queryByText(/%/)).not.toBeInTheDocument()
  expect(screen.queryByText(/Increase:|Decrease:|No change:/)).not.toBeInTheDocument()
})

test('a measured change takes precedence over an unavailable-comparison message', () => {
  render(<AnalyticsSummary featured={{ label: 'Gross GMV', value: '₱34,584.70', changePercent: 12.4, comparisonUnavailable: 'No previous activity' }} metrics={[]} />)

  expect(screen.getByText('+12.4%')).toBeVisible()
  expect(screen.queryByText('No comparison')).not.toBeInTheDocument()
  expect(screen.queryByText('No previous activity')).not.toBeInTheDocument()
})
