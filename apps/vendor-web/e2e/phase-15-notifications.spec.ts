import { expect, test } from '@playwright/test'
import { mkdirSync } from 'node:fs'
import { resolve } from 'node:path'

const noticeId = '01995000-0000-7000-8000-000000000001'
for (const audience of ['vendor', 'admin'] as const) {
  test(`${audience} notification preferences and revoked notice links`, async ({ page }) => {
    await page.route('**/api/v1/**', async route => {
      const path = new URL(route.request().url()).pathname
      let data: unknown = {}
      let status = 200
      if (path.endsWith('/profile')) data = { id: 'synthetic-owner', full_name: 'Demo Reviewer', account_type: audience.toUpperCase(), account_status: 'ACTIVE', role: audience === 'vendor' ? 'OWNER' : 'ADMIN_SUPERADMIN' }
      else if (path.endsWith('/onboarding')) data = { step_completion: [], requirements: [], drafts: [], sections: {}, lock_version: 1, organization: { store_name: 'DEMO Sample Supply', lock_version: 1 }, permissions: ['portal.notifications'], welcome_required: false, verification: { status: 'APPROVED' }, setup: { status: 'COMPLETED' }, activation: { status: 'ACTIVE', marketplace_discoverability_status: 'DISCOVERABLE' } }
      else if (path.endsWith('/notifications')) data = [{ id: noticeId, category: 'SECURITY', title: 'Account access changed', body: 'Review your current account permissions and active sessions.', mandatory: true, read_at: null, created_at: '2026-10-05T00:00:00Z' }]
      else if (path.endsWith('/preferences')) data = [
        { category: 'SECURITY', mandatory: true, explanation: 'Required for account safety and legal duties. These updates stay enabled.', in_app: true, email: true, push: true },
        { category: 'MARKETING', mandatory: false, explanation: 'Choose where you receive optional updates.', in_app: true, email: false, push: false },
      ]
      else if (path.endsWith('/reports')) data = [{ id: noticeId, type: 'PURCHASE_ORDER', format: 'PDF', state: 'READY', purpose: 'Review the accepted procurement snapshot', filters: {}, source_versions: { order_snapshot: 'synthetic-version', version: 2 }, source_hash: 'a'.repeat(64), checksum: 'b'.repeat(64), created_at: '2026-10-05T00:00:00Z', expires_at: '2026-10-06T00:00:00Z', failure_code: null, access_record: [{ action: 'GENERATED', occurred_at: '2026-10-05T00:00:00Z' }] }]
      else if (path.endsWith('/resolve') || path.endsWith('/download')) status = 403
      await route.fulfill({ status, contentType: 'application/json', body: JSON.stringify({ data: status === 200 ? data : null, meta: {}, errors: status === 200 ? [] : [{ code: 'ACCESS_REVOKED', message: 'You no longer have permission to open this resource.' }] }) })
    })
    await page.goto(`http://127.0.0.1:${audience === 'vendor' ? 4173 : 4174}/notifications`)
    await expect(page.getByRole('heading', { name: 'Account access changed' })).toBeVisible()
    await page.getByRole('button', { name: /View details/ }).click()
    await expect(page.getByRole('alert')).toContainText('You no longer have permission')
    await page.getByRole('button', { name: 'Notification preferences', exact: true }).click()
    await expect(page.getByText(/Always enabled/)).toBeVisible()
    await expect(page.getByRole('checkbox')).toHaveCount(3)
    const directory = resolve('../../docs/design/evidence/phase-15')
    mkdirSync(directory, { recursive: true })
    await page.evaluate(() => window.scrollTo(0, 0))
    await page.screenshot({ path: resolve(directory, `${audience}-${page.viewportSize()!.width}-preferences.png`), fullPage: true })
    await expect(page.getByRole('button', { name: 'Documents & exports', exact: true })).toHaveCount(0)
    expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
    await page.evaluate(() => window.scrollTo(0, 0))
    await page.screenshot({ path: resolve(directory, `${audience}-${page.viewportSize()!.width}-inbox.png`), fullPage: true })
  })
}
