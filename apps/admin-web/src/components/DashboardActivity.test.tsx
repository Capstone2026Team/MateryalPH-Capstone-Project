import { render, screen, within } from '@testing-library/react'
import { expect, test } from 'vitest'
import { DashboardActivityList } from '@materyalph/web-ui'

test('activity rows preserve event order, readable details and exact Manila timestamp metadata', () => {
  const at = new Date('2026-11-07T02:00:00Z')
  render(<DashboardActivityList label="Recent platform activity" items={[
    { key: 'a', title: 'Invoice issued', eventType: 'INVOICE_ISSUED', resourceType: 'INVOICE', detail: <><span className="mp-activity-highlight">Invoice</span> · Succeeded</>, at },
    { key: 'b', title: 'Inventory update', eventType: 'INVENTORY_ROW_UPDATED', detail: 'Update could not be completed.', unsuccessful: true, at },
  ]} />)
  const rows = within(screen.getByRole('list', { name: 'Recent platform activity' })).getAllByRole('listitem')
  const first = rows[0]!, second = rows[1]!
  expect(first).toHaveTextContent('Invoice issued:Invoice · Succeeded')
  expect(second).toHaveTextContent('Inventory update:Update could not be completed.Unsuccessful')
  expect(first.querySelector('time')).toHaveAttribute('datetime', at.toISOString())
  expect(first.querySelector('time')).toHaveAttribute('title', expect.stringContaining('Asia/Manila'))
  expect(first.querySelector('time')).toHaveTextContent('10:00 AM')
  expect(first.querySelector('.mp-dashboard-activity-icon')).toHaveAttribute('aria-hidden', 'true')
  expect(first.querySelector('.mp-dashboard-activity-icon svg')).toHaveClass('lucide-receipt-text')
  expect(second.querySelector('.mp-dashboard-activity-icon svg')).toHaveClass('lucide-shopping-bag')
})
