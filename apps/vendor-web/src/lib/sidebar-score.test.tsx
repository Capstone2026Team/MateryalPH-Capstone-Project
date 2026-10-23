import { render, screen, within } from '@testing-library/react'
import { expect, test } from 'vitest'
import { PortalShell } from '@materyalph/web-ui'
import { sidebarScore } from './sidebar-score'
import { StoreScoreLine } from '../components/StoreScoreLine'
import type { StorePerformance } from './trust-api'

const performance = (vps: { value?: string; published: boolean } | null, calculated = true) => ({
  calculated, label: vps?.published ? `VPS ${vps.value} of 5` : 'New Vendor — Building Track Record',
  scores: vps ? [{ key: 'VPS', value: vps.value, published: vps.published, sampleCount: 0, minimumSample: 0, window: 'Daily', statusText: '' }] : [],
}) as unknown as StorePerformance

test('sidebar shows only a published VPS and otherwise the New Vendor label', () => {
  expect(sidebarScore(performance({ value: '4.20', published: true }))).toEqual({ name: 'Vendor Performance Score', value: '4.20', unpublishedLabel: 'New Vendor — Building Track Record' })
  expect(sidebarScore(performance({ value: '3.00', published: false })).value).toBeNull()
  expect(sidebarScore(performance(null)).value).toBeNull()
  expect(sidebarScore(performance({ value: '4.20', published: true }, false)).value).toBeNull()
})

test('Vendor sidebar footer announces the star rating with the store identity', () => {
  render(<PortalShell portalLabel="VENDOR PORTAL" pageTitle="Dashboard" accountLabel="BuildSphere Construction Supply" accountStatus="Store Active" activeHref="/dashboard" sections={[]}
    accountScore={{ name: 'Vendor Performance Score', value: '4.20', unpublishedLabel: 'New Vendor — Building Track Record' }}><h1>Content</h1></PortalShell>)
  const footer = within(screen.getByLabelText('VENDOR PORTAL navigation')).getByRole('group', { name: /Account profile:/ })
  expect(footer.closest('a')).toBeNull()
  expect(footer).toHaveAccessibleName('Account profile: BuildSphere Construction Supply, Store Active, Vendor Performance Score 4.20 out of 5')
  expect(within(footer).getByText('4.20')).toBeVisible()
})

test('Vendor sidebar footer shows the New Vendor label until VPS is published', () => {
  render(<PortalShell portalLabel="VENDOR PORTAL" pageTitle="Dashboard" accountLabel="New Store" accountStatus="Store Active" activeHref="/dashboard" sections={[]}
    accountScore={{ name: 'Vendor Performance Score', value: null, unpublishedLabel: 'New Vendor — Building Track Record' }}><h1>Content</h1></PortalShell>)
  const footer = screen.getByRole('group', { name: /Account profile:/ })
  expect(within(footer).getByText('New Vendor — Building Track Record')).toBeVisible()
  expect(footer).toHaveAccessibleName('Account profile: New Store, Store Active, Vendor Performance Score: New Vendor — Building Track Record')
})

test('Store Profile score line shows the published VPS out of 5, or the New Vendor label', () => {
  const view = render(<StoreScoreLine score={{ name: 'Vendor Performance Score', value: '4.20', unpublishedLabel: 'New Vendor — Building Track Record' }} />)
  expect(screen.getByLabelText('Vendor Performance Score 4.20 out of 5')).toHaveTextContent('4.20/ 5· Vendor Performance Score')
  view.unmount()
  render(<StoreScoreLine score={{ name: 'Vendor Performance Score', value: null, unpublishedLabel: 'New Vendor — Building Track Record' }} />)
  expect(screen.getByLabelText('Vendor Performance Score: New Vendor — Building Track Record')).toBeVisible()
})