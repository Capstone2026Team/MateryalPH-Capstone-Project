import { fireEvent, render, screen, within } from '@testing-library/react'
import { expect, test } from 'vitest'
import { KpiCard, StatCards } from '@materyalph/web-ui'

test.each([
  { change: 12.4, text: '+12.4%', direction: 'up', label: 'Increase:' },
  { change: -3.2, text: '-3.2%', direction: 'down', label: 'Decrease:' },
  { change: -0.04, text: '0.0%', direction: 'flat', label: 'No change:' },
])('financial cards expose a signed $direction change with its comparison period', ({ change, text, direction, label }) => {
  render(<dl><KpiCard appearance="financial" label="Collections" value="₱1,000.00" delta={{ changePercent: change, periodLabel: 'previous 30 days' }} /></dl>)
  const indicator = screen.getByText(text).closest('dd')!
  expect(indicator).toHaveAttribute('data-direction', direction)
  expect(within(indicator).getByText(label)).toBeInTheDocument()
  expect(within(indicator).getByText('vs previous 30 days')).toBeInTheDocument()
})

test.each([null, Number.NaN, Number.POSITIVE_INFINITY])('unavailable financial comparisons (%s) do not fabricate a percentage', change => {
  render(<dl><KpiCard appearance="financial" label="Collections" value="₱1,000.00" delta={{ changePercent: change, periodLabel: 'previous 30 days' }} /></dl>)
  expect(screen.getByText('No comparison')).toBeInTheDocument()
  expect(screen.getByText('No previous 30 days to compare')).toBeInTheDocument()
  expect(screen.queryByText(/%/)).not.toBeInTheDocument()
})

test('financial appearance preserves signed calculation rows, disclosure and actions', () => {
  render(<dl><KpiCard appearance="financial" accent label="Net collections" value="₱900.00" hint="Confirmed collections after refunds" collapsibleBreakdown
    breakdown={{ caption: 'Collections calculation', rows: [
      { key: 'paid', label: 'Paid', amount: '₱1,000.00' }, { key: 'refunds', label: 'Refunds', amount: '-₱100.00' }, { key: 'net', label: 'Net', amount: '₱900.00', total: true },
    ] }} actions={<a href="/finance/transactions">View payments</a>} /></dl>)
  expect(screen.getByText('Confirmed collections after refunds')).toBeInTheDocument()
  expect(screen.queryByText(/%/)).not.toBeInTheDocument()
  expect(screen.queryByText('No comparison')).not.toBeInTheDocument()
  fireEvent.click(screen.getByText('View breakdown'))
  const calculation = screen.getByRole('table', { name: 'Collections calculation' })
  expect(within(calculation).getByRole('row', { name: 'Refunds -₱100.00' })).toBeVisible()
  expect(screen.getByRole('link', { name: 'View payments' })).toHaveAttribute('href', '/finance/transactions')
})

test('financial statement summaries keep supplied totals and visible descriptions without invented trends', () => {
  render(<StatCards appearance="financial" label="Statement amounts" tiles={[{ key: 'outstanding', label: 'Outstanding', value: '₱1,000.00', hint: 'Current unpaid balance' }]} />)
  const amounts = within(screen.getByLabelText('Statement amounts'))
  expect(amounts.getByText('Outstanding')).toBeInTheDocument()
  expect(amounts.getByText('₱1,000.00')).toBeInTheDocument()
  expect(amounts.getByText('Current unpaid balance')).toBeVisible()
  expect(amounts.queryByText(/%/)).not.toBeInTheDocument()
})
