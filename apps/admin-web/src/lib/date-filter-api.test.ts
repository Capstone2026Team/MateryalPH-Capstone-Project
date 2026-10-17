import { afterEach, beforeEach, expect, test, vi } from 'vitest'
import { execFileSync } from 'node:child_process'
import { resolve } from 'node:path'
import { pathToFileURL } from 'node:url'
import { parseDate } from '@materyalph/api-client-ts'
import { clearWebSessionTransport } from '@materyalph/web-ui'
import { listPayments, remittanceQueue } from './finance-api'
import { listInvoiceLog, listQueue } from './disputes-api'
import { listCancellationRequests, listReimbursements } from './order-operations-api'
import { listAdminAnalytics, listModeration } from './trust-api'
import { getGeoDashboard } from './geo-analytics-api'
import { listVendorVerificationQueue } from './vendor-verification-api'
import { searchAudit } from './operations-api'
import { dateQuery } from './admin-format'

const fetchMock = vi.fn(async (input: RequestInfo | URL, _init?: RequestInit) => {
  const path = new URL(String(input)).pathname
  const data = path.endsWith('/auth/csrf') ? { csrf_token: 'synthetic-date-filter-test' }
    : path.endsWith('/admin/geo-analytics') ? { filter_applicability: [], trends: [], activity_trend: [], children: [] }
      : path.endsWith('/admin/materials-analytics') ? { items: [] } : []
  return new Response(JSON.stringify({ data, meta: {}, errors: [] }), { headers: { 'Content-Type': 'application/json' } })
})

beforeEach(() => { clearWebSessionTransport(); fetchMock.mockClear(); vi.stubGlobal('fetch', fetchMock) })
afterEach(() => { clearWebSessionTransport(); vi.unstubAllGlobals() })

test('Admin generated requests retain calendar date filters and credentialed transport alongside state and pagination', async () => {
  const range = { from: '2026-10-01', to: '2026-10-09' }
  for (const query of [
    () => listPayments(2, 'PAID', range),
    () => remittanceQueue(2, 'RECONCILED', range),
    () => listQueue('NEEDS_ADMIN', 2, range),
    () => listInvoiceLog('RECORDS', 2, range),
    () => listModeration('NEEDS_ACTION', 2, range),
  ]) {
    await query()
    const call = fetchMock.mock.calls.at(-1) as unknown as [RequestInfo | URL, RequestInit]
    const url = new URL(String(call[0]))
    expect(url.searchParams.get('from')).toBe('2026-10-01')
    expect(url.searchParams.get('to')).toBe('2026-10-09')
    expect(url.searchParams.get('page')).toBe('2')
    expect(call[1].credentials).toBe('include')
    expect(call[1].method).toBe('GET')
  }
})

test('open-ended ranges omit only the empty boundary and All dates sends no restriction', async () => {
  await listReimbursements({ from: '2026-10-01', to: '' })
  let url = new URL(String((fetchMock.mock.calls.at(-1) as unknown as [RequestInfo])[0]))
  expect(url.searchParams.get('from')).toBe('2026-10-01')
  expect(url.searchParams.has('to')).toBe(false)
  await listCancellationRequests({ from: '', to: '2026-10-09' })
  url = new URL(String((fetchMock.mock.calls.at(-1) as unknown as [RequestInfo])[0]))
  expect(url.searchParams.has('from')).toBe(false)
  expect(url.searchParams.get('to')).toBe('2026-10-09')
  await listPayments(1, undefined, { from: '', to: '' })
  url = new URL(String((fetchMock.mock.calls.at(-1) as unknown as [RequestInfo])[0]))
  expect(url.searchParams.has('from')).toBe(false)
  expect(url.searchParams.has('to')).toBe(false)
})

test('bounded analytics and existing audit and verification dates retain the selected calendar days', async () => {
  const range = { from: '2026-03-07', to: '2026-03-10' }
  await getGeoDashboard({ dataset: 'TEST', area: 'PH', ...range, granularity: 'DAY', procurementType: '', categoryId: '', materialId: '', fulfillmentMethod: '', paymentMethod: '', orderState: '' })
  let url = new URL(String((fetchMock.mock.calls.at(-1) as unknown as [RequestInfo])[0]))
  expect(url.searchParams.get('from')).toBe(range.from)
  expect(url.searchParams.get('to')).toBe(range.to)
  expect(url.searchParams.get('area')).toBe('PH')
  await listAdminAnalytics({ presetDays: null, startDate: range.from, endDate: range.to, psgcCode: 'PH', q: 'Cement' })
  url = new URL(String((fetchMock.mock.calls.at(-1) as unknown as [RequestInfo])[0]))
  expect(url.searchParams.get('start_date')).toBe(range.from)
  expect(url.searchParams.get('end_date')).toBe(range.to)
  expect(url.searchParams.has('preset_days')).toBe(false)
  expect(url.searchParams.get('q')).toBe('Cement')
  await listVendorVerificationQueue({ submittedFrom: parseDate(range.from), submittedTo: parseDate(range.to), page: 2 })
  url = new URL(String((fetchMock.mock.calls.at(-1) as unknown as [RequestInfo])[0]))
  expect(url.searchParams.get('submitted_from')).toBe(range.from)
  expect(url.searchParams.get('submitted_to')).toBe(range.to)
  expect(url.searchParams.get('page')).toBe('2')
  await searchAudit({ actor: 'Synthetic reviewer', ...dateQuery(range) })
  url = new URL(String((fetchMock.mock.calls.at(-1) as unknown as [RequestInfo])[0]))
  expect(url.searchParams.get('from')).toBe(range.from)
  expect(url.searchParams.get('to')).toBe(range.to)
  expect(url.searchParams.get('actor')).toBe('Synthetic reviewer')
})

test('calendar adapter serializes both sides of a daylight-saving change in a browser timezone west of UTC', () => {
  const moduleUrl = pathToFileURL(resolve(process.cwd(), 'src/lib/admin-format.ts')).href
  const script = `import { dateQuery } from ${JSON.stringify(moduleUrl)};
    import { serializeDate } from '@materyalph/api-client-ts';
    const { from, to } = dateQuery({ from: '2026-03-07', to: '2026-03-10' });
    console.log(JSON.stringify({ from: serializeDate(from), to: serializeDate(to), offsets: [from.getTimezoneOffset(), to.getTimezoneOffset()] }));`
  const result = execFileSync(process.execPath, ['--input-type=module', '-e', script], {
    cwd: process.cwd(), env: { ...process.env, TZ: 'America/Los_Angeles' }, encoding: 'utf8', timeout: 20_000,
  })
  expect(JSON.parse(result)).toEqual({ from: '2026-03-07', to: '2026-03-10', offsets: [480, 420] })
}, 25_000)
