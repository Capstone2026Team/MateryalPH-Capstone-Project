import { expect, test, type Page } from '@playwright/test'

// Synthetic API responses verify presentation and interaction, not live provider health.
const checkedAt = '2026-10-27T02:00:00Z'
// Capture the entire desktop workspace without its shell scroll viewport clipping the artifact.
// Layout/overflow assertions run before this temporary screenshot-only stylesheet applies.
const screenshotStyle = `.portal-workspace > header { position: static !important; }
@media (min-width: 1024px) {
  html:has(.portal-layout), body:has(.portal-layout) { overflow: visible !important; }
  .portal-layout { height: auto !important; overflow: visible !important; }
  .portal-workspace { overflow: visible !important; }
}`
const overview = {
  generated_at: checkedAt, environment: { app: 'STAGING', deployment: 'HOSTINGER_VPS', commerce: 'TEST — LIVE commerce disabled' }, can_retry: true,
  integrations: [
    ['xendit_payments', 'Xendit payments and webhooks', 'SIMULATED', 'Simulated gateway; no provider calls.'],
    ['google_maps', 'Google Maps, Places and Routes', 'HEALTHY', 'Server configuration present; values hidden.'],
    ['email', 'Email delivery', 'DEGRADED', '3 failed email deliveries in 24 h.'],
    ['backblaze', 'Backblaze B2 storage', 'HEALTHY', 'Private storage configuration present.'],
    ['cloudinary', 'Cloudinary', 'HEALTHY', 'Media configuration present.'],
    ['bouncer', 'Bouncer', 'HEALTHY', 'No files waiting for a scan over 1 hour.'],
    ['push', 'Firebase FCM', 'HEALTHY', 'No failed push deliveries in 24 h.'],
    ['google_oidc', 'Google sign-in', 'HEALTHY', 'Client configuration present.'],
    ['recaptcha', 'Google reCAPTCHA Enterprise', 'HEALTHY', 'Bot protection configured.'],
    ['xendit_accounts', 'Xendit accounts', 'HEALTHY', 'No account errors.'],
    ['file_storage', 'Private file storage and scanning', 'HEALTHY', 'No files waiting for a scan over 1 hour.'],
    ['reverb', 'Laravel Reverb realtime', 'NOT_CONFIGURED', 'Clients fall back to REST polling.'],
    ['ocr', 'OCR assistance', 'HEALTHY', 'Suggestions require Vendor confirmation; OCR never approves compliance.'],
    ['dti_bps_registers', 'DTI-BPS PS and ICC registers', 'HEALTHY', 'Current register snapshots are loaded.'],
  ].map(([key, label, status, detail]) => ({ key, label, status, detail,
    ...(key === 'xendit_payments' ? { environment: 'Xendit TEST', last_event_at: checkedAt } : key === 'email' ? { environment: 'Brevo SMTP' } : {}) })),
  queues: { connection: 'Redis', status: 'DEGRADED', outbox_backlog: 8, dead_letters: 3, failed_jobs: 0 },
  automatic_recovery: { status: 'HEALTHY', max_cycles: 3, delays_minutes: [15, 60, 360], last_started_at: checkedAt },
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

test('Platform Monitoring consoles, tasks and automatic recovery reflow across screen sizes', async ({ page }) => {
  const mutations: string[] = []
  await page.route('**/api/v1/**', async route => {
    const path = new URL(route.request().url()).pathname
    if (route.request().method() === 'POST' && path.includes('/integrations/')) mutations.push(path)
    let data: unknown = {}
    if (path.endsWith('/profile')) data = { id: 'layout-review', full_name: 'Platform Admin', account_type: 'ADMIN', account_status: 'ACTIVE', role: 'ADMIN_SUPERADMIN' }
    else if (path.endsWith('/auth/csrf')) data = { csrf_token: 'synthetic-layout-csrf' }
    else if (path.endsWith('/admin/integrations')) data = overview
    else if (path.endsWith('/admin/integrations/failures')) data = [{ kind: 'OUTBOX_EVENT', reference: 'event-layout', label: 'Notification delivery', queue: 'notifications', failure: 'Delivery attempts exhausted', attempts: 5, failed_at: checkedAt, retryable: true, recovery_status: 'SCHEDULED', recovery_attempts: 1, next_retry_at: checkedAt }]
    else if (path.endsWith('/admin/integrations/retries')) data = []
    else if (path.endsWith('/notifications/unread-count')) data = { count: 0 }
    await route.fulfill({ json: { data, meta: { last_page: 1, total: 1 }, errors: [] } })
  })
  await page.goto('http://127.0.0.1:4174/integrations')
  await expect(page.getByRole('heading', { name: 'Platform Monitoring', exact: true })).toBeVisible()
  await expect(page.getByLabel('Operational summary')).toContainText('VPS third-party services9')
  await expect(page.getByRole('list', { name: 'Queue exception counts' })).toBeVisible()
  const services = page.getByRole('group', { name: 'Services and integrations' })
  await expect(services.getByRole('note', { name: 'Service status scope' })).toHaveCount(0)
  await expect(page.getByRole('heading', { name: 'Services & integrations', exact: true })).toHaveCount(1)
  await expect(page.getByRole('heading', { name: /^(Integrations|Connected services)$/ })).toHaveCount(0)
  await expect(services.getByRole('list', { name: / checks$/ }).getByRole('listitem')).toHaveCount(16)
  await expect(services.getByRole('region')).toHaveCount(6)
  const groupColors: string[] = []
  for (const card of await services.getByRole('region').all()) {
    const surface = await card.evaluate(element => {
      const style = getComputedStyle(element)
      return { border: Number.parseFloat(style.borderTopWidth), background: style.backgroundColor }
    })
    expect(surface.border).toBeGreaterThan(0)
    expect(surface.background).not.toBe('rgba(0, 0, 0, 0)')
    groupColors.push(await card.locator(':scope > div').first().evaluate(element => getComputedStyle(element).backgroundColor))
  }
  expect(new Set(groupColors).size).toBe(6)
  const serviceColumns = await services.locator('.mp-service-directory-columns').evaluate(element => getComputedStyle(element).gridTemplateColumns.split(' ').length)
  const groupBoxes = await Promise.all((await services.getByRole('region').all()).map(async card => (await card.boundingBox())!))
  if (serviceColumns > 1) {
    expect(Math.max(...groupBoxes.map(box => box.width)) - Math.min(...groupBoxes.map(box => box.width))).toBeLessThanOrEqual(1)
    expect(Math.max(...groupBoxes.map(box => box.height)) - Math.min(...groupBoxes.map(box => box.height))).toBeLessThanOrEqual(1)
  }
  const servicesCard = page.getByRole('region', { name: 'Services & integrations', exact: true })
  await expect(servicesCard.getByRole('link')).toHaveCount(10)
  const sidebar = page.getByRole('complementary', { name: 'Platform health', exact: true })
  for (const heading of ['Integration status', 'Queues and outbox', 'Automatic recovery']) {
    await expect(sidebar.getByRole('heading', { name: heading, exact: true })).toBeVisible()
    const panel = sidebar.getByRole('region', { name: heading, exact: true })
    const headerBox = (await panel.locator(':scope > div').first().boundingBox())!
    const contentBox = (await panel.locator(':scope > :nth-child(2)').boundingBox())!
    // Stretching the card must not spread its content into disconnected vertical tracks.
    expect(contentBox.y - headerBox.y - headerBox.height).toBeGreaterThanOrEqual(0)
    expect(contentBox.y - headerBox.y - headerBox.height).toBeLessThanOrEqual(16)
  }
  const workspace = page.getByRole('group', { name: 'Platform monitoring overview' })
  const references = workspace.getByRole('region', { name: 'Analytics and reference data', exact: true })
  await expect(workspace.locator('details, summary')).toHaveCount(0)
  for (const heading of ['Geographic aggregation', 'Materials Analytics snapshot', 'PSGC reference']) {
    await expect(references.getByRole('heading', { name: heading, exact: true })).toBeVisible()
  }
  const expandedServicesBox = (await servicesCard.boundingBox())!
  const expandedSidebarBox = (await sidebar.boundingBox())!
  const referencesBox = (await references.boundingBox())!
  const workspaceBox = (await workspace.boundingBox())!
  const landscapeBottom = Math.max(expandedServicesBox.y + expandedServicesBox.height, expandedSidebarBox.y + expandedSidebarBox.height)
  expect(referencesBox.y - landscapeBottom).toBeGreaterThanOrEqual(0)
  expect(referencesBox.y - landscapeBottom).toBeLessThanOrEqual(16)
  expect(Math.abs(referencesBox.x - workspaceBox.x)).toBeLessThanOrEqual(1)
  expect(Math.abs(referencesBox.width - workspaceBox.width)).toBeLessThanOrEqual(1)
  const referenceSections = await references.locator(':scope > div:last-child > div').all()
  const sectionBoxes = await Promise.all(referenceSections.map(async section => (await section.boundingBox())!))
  if (page.viewportSize()!.width >= 1024) {
    expect(Math.max(...sectionBoxes.map(box => box.y)) - Math.min(...sectionBoxes.map(box => box.y))).toBeLessThanOrEqual(1)
    expect(sectionBoxes[0]!.x + sectionBoxes[0]!.width).toBeLessThan(sectionBoxes[1]!.x)
    expect(sectionBoxes[1]!.x + sectionBoxes[1]!.width).toBeLessThan(sectionBoxes[2]!.x)
  } else {
    expect(sectionBoxes[1]!.y).toBeGreaterThanOrEqual(sectionBoxes[0]!.y + sectionBoxes[0]!.height)
    expect(sectionBoxes[2]!.y).toBeGreaterThanOrEqual(sectionBoxes[1]!.y + sectionBoxes[1]!.height)
  }
  await fits(page)
  await workspace.screenshot({ path: test.info().outputPath('health-analytics.png'), style: screenshotStyle })
  const servicesBox = (await servicesCard.boundingBox())!
  const sidebarBox = (await sidebar.boundingBox())!
  if (page.viewportSize()!.width >= 1280) {
    expect(sidebarBox.x + sidebarBox.width).toBeLessThan(servicesBox.x)
    expect(Math.abs(sidebarBox.y - servicesBox.y)).toBeLessThanOrEqual(2)
    expect(Math.abs(sidebarBox.height - servicesBox.height)).toBeLessThanOrEqual(2)
  } else {
    expect(sidebarBox.y).toBeGreaterThanOrEqual(servicesBox.y + servicesBox.height)
  }
  for (const integration of overview.integrations) {
    const row = services.getByRole('listitem', { name: integration.label, exact: true })
    await expect(row).toContainText(integration.detail)
    if (integration.environment) await expect(row).toContainText(integration.environment)
  }
  for (const provider of ['Hostinger', 'Duck DNS', 'Backblaze B2', 'Brevo', 'Cloudinary', 'Bouncer', 'Google Cloud', 'Firebase', 'Xendit']) {
    const consoleLink = services.getByRole('link', { name: `Open ${provider} console (new tab)`, exact: true })
    await expect(consoleLink).toHaveCount(1)
    await expect(consoleLink).toBeVisible()
    expect(await consoleLink.evaluate(element => element.getBoundingClientRect().height)).toBeGreaterThanOrEqual(44)
  }
  await expect(services.getByRole('region', { name: 'Infrastructure', exact: true })).toContainText('Hostinger')
  await expect(services.getByRole('region', { name: 'Payments & onboarding', exact: true }).getByRole('list', { name: 'Xendit checks' }).getByRole('listitem')).toHaveCount(2)
  await expect(services.getByRole('region', { name: 'Maps & identity', exact: true }).getByRole('list', { name: 'Google Cloud checks' }).getByRole('listitem')).toHaveCount(3)
  await expect(services.getByRole('link')).toHaveCount(10)
  for (const image of await services.locator('img').all()) {
    await expect.poll(() => image.evaluate(element => (element as HTMLImageElement).naturalWidth)).toBeGreaterThan(0)
  }
  await expect(page.getByRole('region', { name: 'Automatic recovery' })).toContainText('3 cycles per event')
  await expect(page.getByRole('button', { name: /Retry eligible/ })).toHaveCount(0)
  await fits(page)
  await page.screenshot({ path: test.info().outputPath('health-overview.png'), fullPage: true, style: screenshotStyle })
  await page.getByRole('group', { name: 'Platform monitoring overview' }).screenshot({ path: test.info().outputPath('health-workspace.png'), style: screenshotStyle })
  await services.screenshot({ path: test.info().outputPath('health-service-cards.png'), style: screenshotStyle })
  await page.getByRole('tab', { name: 'Scheduled tasks', exact: true }).click()
  await expect(page.getByRole('list', { name: 'Latest scheduled task durations' })).toContainText('0.045 s')
  await expect(page.getByRole('table', { name: 'Scheduled task health' })).toContainText('25 h')
  await fits(page)
  await page.screenshot({ path: test.info().outputPath('health-tasks.png'), fullPage: true, style: screenshotStyle })
  await page.getByRole('tab', { name: 'Recovery activity' }).click()
  await expect(page.getByRole('table', { name: 'Failures', exact: true })).toContainText('Notification delivery')
  await fits(page)
  await expect(page.getByText('Automatic retry scheduled')).toBeVisible()
  await expect(page.getByRole('button', { name: 'Retry', exact: true })).toHaveCount(0)
  expect(mutations).toEqual([])
  await fits(page)
  await page.screenshot({ path: test.info().outputPath('health-recovery.png'), fullPage: true, style: screenshotStyle })
})

test('local runtime diagnostics share one VPS reference notice and remain readable', async ({ page }) => {
  await page.route('**/api/v1/**', async route => {
    const path = new URL(route.request().url()).pathname
    let data: unknown = {}
    if (path.endsWith('/profile')) data = { id: 'local-layout-review', full_name: 'Platform Admin', account_type: 'ADMIN', account_status: 'ACTIVE', role: 'ADMIN_SUPERADMIN' }
    else if (path.endsWith('/auth/csrf')) data = { csrf_token: 'synthetic-layout-csrf' }
    else if (path.endsWith('/admin/integrations')) data = { ...overview, environment: { app: 'DEVELOPMENT', deployment: 'OTHER', commerce: 'TEST — LIVE commerce disabled' } }
    else if (path.endsWith('/admin/integrations/failures') || path.endsWith('/admin/integrations/retries')) data = []
    else if (path.endsWith('/notifications/unread-count')) data = { count: 0 }
    await route.fulfill({ json: { data, meta: { last_page: 1, total: 0 }, errors: [] } })
  })
  await page.goto('http://127.0.0.1:4174/integrations')
  const services = page.getByRole('group', { name: 'Services and integrations' })
  await expect(services.getByRole('note', { name: 'Service status scope' })).toHaveCount(1)
  await expect(services.getByRole('note')).toContainText('Checks below describe the current runtime, not deployed provider health.')
  await expect(page.getByRole('region', { name: 'Integration status', exact: true })).toContainText('VPS reference')
  for (const integration of overview.integrations) {
    await expect(services.getByRole('listitem', { name: integration.label, exact: true })).toContainText(integration.detail)
  }
  for (const heading of await services.locator('.mp-service-check-heading').all()) {
    const title = heading.getByRole('heading')
    const badge = heading.locator('span').first()
    const badgeBox = (await badge.boundingBox())!
    expect(badgeBox.height).toBeGreaterThanOrEqual(24)
    if (await title.count()) {
      const titleBox = (await title.boundingBox())!
      expect(titleBox.x + titleBox.width).toBeLessThanOrEqual(badgeBox.x)
    }
  }
  for (const link of await services.getByRole('link').all()) {
    const box = (await link.boundingBox())!
    expect(box.height).toBeGreaterThanOrEqual(44)
    expect(box.width).toBeGreaterThanOrEqual(44)
  }
  await fits(page)
  await page.getByRole('group', { name: 'Platform monitoring overview' }).screenshot({ path: test.info().outputPath('health-local-workspace.png'), style: screenshotStyle })
})

test('protected work and retry limits remain visible without manual queue actions', async ({ page }) => {
  const requests: { reference: string; reason: string; key: string | undefined }[] = []
  await page.route('**/api/v1/**', async route => {
    const path = new URL(route.request().url()).pathname
    let data: unknown = {}
    if (path.endsWith('/profile')) data = { id: 'retry-review', full_name: 'Platform Admin', account_type: 'ADMIN', account_status: 'ACTIVE', role: 'ADMIN_SUPERADMIN' }
    else if (path.endsWith('/auth/csrf')) data = { csrf_token: 'synthetic-layout-csrf' }
    else if (path.endsWith('/admin/integrations')) data = { ...overview, queues: { ...overview.queues, dead_letters: 2 - requests.length } }
    else if (path.endsWith('/admin/integrations/failures')) data = [
      { kind: 'OUTBOX_EVENT', reference: 'eligible-event', label: 'Notification delivery', queue: 'notifications', failure: 'Delivery exhausted', attempts: 5, failed_at: checkedAt, retryable: true, recovery_status: 'LIMIT_REACHED', recovery_attempts: 3 },
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
  await page.getByRole('tab', { name: 'Recovery activity' }).click()
  await expect(page.getByText('Retry limit reached · needs investigation')).toBeVisible()
  await expect(page.getByText('Use payment reconciliation.')).toBeVisible()
  await expect(page.getByRole('button', { name: /Retry/ })).toHaveCount(0)
  expect(requests).toEqual([])
  await fits(page)
})
