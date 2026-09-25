import { expect, test } from '@playwright/test'

test('optional team setup invites employees and fits the viewport', async ({ page }, testInfo) => {
  let invited = false
  await page.route('**/api/v1/**', async route => {
    const path = new URL(route.request().url()).pathname
    let data: unknown = {}
    let meta: unknown = {}
    if (path.endsWith('/auth/csrf')) data = { csrf_token: 'synthetic-csrf' }
    if (path.endsWith('/profile')) data = { id: 'owner', full_name: 'Vendor Owner', account_type: 'VENDOR', account_status: 'ACTIVE', role: 'OWNER', permissions: [], lock_version: 1 }
    if (path.endsWith('/invitations')) {
      if (route.request().method() === 'POST') {
        expect(route.request().postDataJSON()).toMatchObject({ invitee_name: 'Sample Employee', email: 'employee@example.test', role: 'STORE_STAFF', can_manage_staff: false })
        invited = true
        data = { queued: true }
      } else {
        data = invited ? [{ id: 'invitation', invitee_name: 'Sample Employee', email: 'employee@example.test', role: 'STORE_STAFF', status: 'PENDING', can_manage_staff: false, vendor_organization_id: 'org', invited_by_id: 'owner', invited_by_name: 'Vendor Owner', created_at: '2026-09-25T00:00:00Z', expires_at: '2026-09-26T00:00:00Z', accepted_at: null }] : []
        meta = { current_page: 1, last_page: 1 }
      }
    }
    if (path.includes('/onboarding')) data = {
      step_completion: [], requirements: [], drafts: [], lock_version: 1,
      organization: { store_name: 'Sample Building Supply', lock_version: 1 }, welcome_required: false,
      permissions: ['staff.manage', 'managers.manage', 'vendor.onboarding.manage', 'vendor.onboarding.submit'],
      verification: {}, setup: { status: 'IN_PROGRESS' }, activation: { status: 'NOT_READY', marketplace_discoverability_status: 'NOT_DISCOVERABLE', readiness: { ready: false, status: 'NOT_READY', blockers: [], rule_version: 'test' } },
      sections: { STORE_SETUP: { key: 'STORE_SETUP', label: 'Store Setup', status: 'IN_PROGRESS', complete: 0, total: 8, progress: { complete: 0, total: 8 }, steps: [] } },
    }
    await route.fulfill({ status: 200, contentType: 'application/json', body: JSON.stringify({ data, meta, errors: [] }) })
  })
  await page.goto('/onboarding/setup')
  await page.getByRole('button', { name: '4 Team Accounts' }).click()
  await expect(page.getByText('No invitations yet.', { exact: false })).toBeVisible()
  await page.getByRole('combobox', { name: 'Fixed role' }).selectOption('STORE_MANAGER')
  await expect(page.getByRole('checkbox', { name: 'Allow this Store Manager to manage staff accounts' })).not.toBeChecked()
  await page.getByRole('combobox', { name: 'Fixed role' }).selectOption('STORE_STAFF')
  await page.getByRole('textbox', { name: 'Employee full name' }).fill('Sample Employee')
  await page.getByRole('textbox', { name: 'Email address' }).fill('employee@example.test')
  await page.getByRole('button', { name: 'Send invitation', exact: true }).click()
  await expect(page.getByText('Invitation queued for email delivery.', { exact: false })).toBeVisible()
  await expect(page.getByText('Sample Employee', { exact: true })).toBeVisible()
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= window.innerWidth)).toBe(true)
  await page.screenshot({ path: testInfo.outputPath('team-setup.png'), fullPage: true })
  await page.getByRole('button', { name: 'Next', exact: true }).click()
  await expect(page.getByRole('heading', { name: 'Review and Complete', exact: true })).toBeVisible()
})
