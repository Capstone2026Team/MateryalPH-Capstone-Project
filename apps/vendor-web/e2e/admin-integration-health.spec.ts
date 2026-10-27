import { expect, test, type Page } from '@playwright/test'

// Synthetic API responses verify presentation and interaction, not live provider health.
const checkedAt = '2026-10-27T02:00:00Z'
const overview = {
  generated_at: checkedAt, environment: { app: 'TEST', commerce: 'TEST — LIVE commerce disabled' }, can_retry: true,
  integrations: [
    ['xendit', 'Xendit payments and webhooks', 'SIMULATED', 'Simulated gateway; no provider calls.'],
    ['maps', 'Google Maps, Places and Routes', 'HEALTHY', 'Server configuration present; values hidden.'],
    ['email', 'Email delivery', 'DEGRADED', '3 failed email deliveries in 24 h.'],
    ['storage', 'Private file storage and scanning', 'HEALTHY', 'No files waiting for a scan over 1 hour.'],
    ['reverb', 'Laravel Reverb realtime', 'NOT_CONFIGURED', 'Clients fall back to REST polling.'],
    ['registers', 'DTI-BPS PS and ICC registers', 'HEALTHY', 'Current register snapshots are loaded.'],
  ].map(([key, label, status, detail]) => ({ key, label, status, detail })),
  queues: { connection: 'Redis', status: 'DEGRADED', outbox_backlog: 8, dead_letters: 3, failed_jobs: 0 },
  scheduled_tasks: [
    { task: 'materyalph:outbox-dispatch', status: 'HEALTHY', last_started_at: checkedAt, duration_ms: 45, expected_within_minutes: 5 },
    { task: 'analytics:capture-material-prices', status: 'FAILED', last_started_at: checkedAt, duration_ms: 12000, expected_within_minutes: 1500 },
    { task: 'analytics:aggregate-marketplace', status: 'OVERDUE', last_started_at: checkedAt, duration_ms: 3200, expected_within_minutes: 1500 },
    { task: 'materyalph:orders-expire', status: 'NO_RUN_RECORDED', last_started_at: null, duration_ms: null, expected_within_minutes: 5 },
  ],
  analytics: {
    geo_aggregation: { status: 'STALE', through_date: '2026-10-25', last_published_at: checkedAt, revision: 3 },
    materials_snapshot: { status: 'HEALTHY', dataset: 'Recorded marketplace observations', snapshot_date: '2026-10-27', observations: 120, vendors: 18, failed_captures_7_days: 0 },
    psgc: { status: 'HEALTHY', version: '2026-Q3', effective_on: '2026-09-30', boundaries: { REGION: 18, PROVINCE: 82 }, last_boundary_import: checkedAt },
  },
}

async function fits(page: Page) {
  const overflow = await page.evaluate(() => {
    const modal = document.querySelector('dialog[open]')
    const right = modal ? (visualViewport?.offsetLeft ?? 0) + (visualViewport?.width ?? document.documentElement.clientWidth) : document.documentElement.clientWidth
    const scope = modal ?? document.querySelector('main')
    return [...(scope?.querySelectorAll<HTMLElement>('*') ?? [])].filter(element => element.getBoundingClientRect().right > right + 1 && getComputedStyle(element).position !== 'fixed' && !element.closest('[class*="overflow-x-auto"]')).map(element => ({ tag: element.tagName, className: element.className, right: element.getBoundingClientRect().right })).slice(0, 5)
  })
  expect(overflow).toEqual([])
  expect(await page.evaluate(() => Boolean(document.querySelector('dialog[open]')) || document.documentElement.scrollWidth <= innerWidth)).toBe(true)
}

test('Admin health charts, tasks and retry controls reflow across screen sizes', async ({ page }) => {
  await page.route('**/api/v1/**', async route => {
    const path = new URL(route.request().url()).pathname
    let data: unknown = {}
    if (path.endsWith('/profile')) data = { id: 'layout-review', full_name: 'Platform Admin', account_type: 'ADMIN', account_status: 'ACTIVE', role: 'ADMIN_SUPERADMIN' }
    else if (path.endsWith('/auth/csrf')) data = { csrf_token: 'synthetic-layout-csrf' }
    else if (path.endsWith('/admin/integrations')) data = overview
    else if (path.endsWith('/admin/integrations/failures')) data = [{ kind: 'OUTBOX_EVENT', reference: 'event-layout', label: 'Notification delivery', queue: 'notifications', failure: 'Delivery attempts exhausted', attempts: 5, failed_at: checkedAt, retryable: true }]
    else if (path.endsWith('/admin/integrations/retries')) data = []
    else if (path.endsWith('/notifications/unread-count')) data = { count: 0 }
    await route.fulfill({ json: { data, meta: { last_page: 1, total: 1 }, errors: [] } })
  })
  await page.goto('http://127.0.0.1:4174/integrations')
  await expect(page.getByRole('heading', { name: 'Integration & Job Health', exact: true })).toBeVisible()
  await expect(page.getByLabel('Operational summary')).toContainText('3 / 6')
  await expect(page.getByRole('list', { name: 'Queue exception counts' })).toBeVisible()
  await fits(page)
  await page.screenshot({ path: test.info().outputPath('health-overview.png'), fullPage: true })
  await page.getByRole('button', { name: 'Retry eligible deliveries' }).click()
  const batch = page.getByRole('dialog', { name: 'Retry eligible deliveries' })
  await expect(batch.getByRole('button', { name: 'Retry 1 delivery' })).toBeVisible()
  await expect(batch.getByLabel(/^Reason/)).toBeVisible()
  await expect.poll(() => batch.evaluate(element => element.getAnimations().every(animation => animation.playState === 'finished'))).toBe(true)
  await fits(page)
  await batch.screenshot({ path: test.info().outputPath('retry-eligible-deliveries.png') })
  await batch.getByRole('button', { name: 'Close panel' }).click()
  await expect(batch).not.toBeVisible()
  await page.getByRole('tab', { name: 'Scheduled tasks', exact: true }).click()
  await expect(page.getByRole('list', { name: 'Latest scheduled task durations' })).toContainText('0.045 s')
  await expect(page.getByRole('table', { name: 'Scheduled task health' })).toContainText('25 h')
  await fits(page)
  await page.screenshot({ path: test.info().outputPath('health-tasks.png'), fullPage: true })
  await page.getByRole('tab', { name: 'Failures & retries' }).click()
  await expect(page.getByRole('table', { name: 'Failures', exact: true })).toContainText('Notification delivery')
  await fits(page)
  const retry = page.getByRole('button', { name: 'Retry', exact: true })
  await retry.focus()
  await retry.press('Enter')
  const dialog = page.getByRole('dialog', { name: 'Retry work' })
  await expect(dialog).toBeVisible()
  await expect.poll(() => dialog.evaluate(element => {
    const bounds = element.getBoundingClientRect()
    const left = visualViewport?.offsetLeft ?? 0
    const right = left + (visualViewport?.width ?? document.documentElement.clientWidth)
    return Math.max(left - bounds.left, bounds.right - right)
  })).toBeLessThanOrEqual(1)
  await expect(page.getByLabel(/^Reason/)).toBeVisible()
  await fits(page)
})

test('card batch action queues only eligible work with a reason and refreshes its count', async ({ page }) => {
  const requests: { reference: string; reason: string; key: string | undefined }[] = []
  await page.route('**/api/v1/**', async route => {
    const path = new URL(route.request().url()).pathname
    let data: unknown = {}
    if (path.endsWith('/profile')) data = { id: 'retry-review', full_name: 'Platform Admin', account_type: 'ADMIN', account_status: 'ACTIVE', role: 'ADMIN_SUPERADMIN' }
    else if (path.endsWith('/auth/csrf')) data = { csrf_token: 'synthetic-layout-csrf' }
    else if (path.endsWith('/admin/integrations')) data = { ...overview, queues: { ...overview.queues, dead_letters: 2 - requests.length } }
    else if (path.endsWith('/admin/integrations/failures')) data = [
      ...(requests.length === 0 ? [{ kind: 'OUTBOX_EVENT', reference: 'eligible-event', label: 'Notification delivery', queue: 'notifications', failure: 'Delivery exhausted', attempts: 5, failed_at: checkedAt, retryable: true }] : []),
      { kind: 'OUTBOX_EVENT', reference: 'restricted-event', label: 'Payment refund', queue: 'payments', failure: 'Delivery exhausted', attempts: 5, failed_at: checkedAt, retryable: false, retry_note: 'Use payment reconciliation.' },
    ]
    else if (path.endsWith('/admin/integrations/retries')) {
      if (route.request().method() === 'POST') {
        const input = route.request().postDataJSON() as { reference: string; reason: string }
        requests.push({ ...input, key: route.request().headers()['idempotency-key'] })
        data = { target_type: 'OUTBOX_EVENT', reference: input.reference, label: 'Notification delivery', outcome: 'QUEUED', correlation_id: 'retry-layout-correlation' }
      } else data = []
    } else if (path.endsWith('/notifications/unread-count')) data = { count: 0 }
    await route.fulfill({ json: { data, meta: { last_page: 1, total: 2 }, errors: [] } })
  })
  await page.goto('http://127.0.0.1:4174/integrations')
  await page.getByRole('button', { name: 'Retry eligible deliveries' }).click()
  const batch = page.getByRole('dialog', { name: 'Retry eligible deliveries' })
  await batch.getByLabel(/^Reason/).fill('Mail service recovered after the outage.')
  await batch.getByRole('button', { name: 'Retry 1 delivery' }).click()
  await expect(batch.getByText('Retry results', { exact: true })).toBeVisible()
  await expect(batch.getByText('Correlation ID retry-layout-correlation')).toHaveCount(1)
  expect(requests).toHaveLength(1)
  expect(requests[0]).toMatchObject({ reference: 'eligible-event', reason: 'Mail service recovered after the outage.', key: expect.any(String) })
  const card = page.getByText('Dead-lettered deliveries', { exact: true }).first().locator('..').locator('..')
  await expect(card).toContainText('1')
})
