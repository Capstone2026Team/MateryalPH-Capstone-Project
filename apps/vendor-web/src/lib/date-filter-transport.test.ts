import { afterEach, expect, test, vi } from 'vitest'
import { listOrders } from './orders-api'
import { listDisputes, listInvoices } from './disputes-api'
import { exportTransactions, getEarnings, listTransactions } from './finance-api'
import { exportVendorAnalytics, getVendorAnalyticsDetail, listReviews, listVendorAnalytics } from './trust-api'
import { getVendorDashboardInsights } from './dashboard-api'
import { listMovements, listPriceHistory } from './inventory-api'
import { clearWebSessionTransport } from '@materyalph/web-ui'

afterEach(() => { clearWebSessionTransport(); vi.restoreAllMocks() })

const jsonResponse = (request: RequestInfo | URL) => new Response(JSON.stringify({ data: String(request).endsWith('/auth/csrf') ? { csrf_token: 'synthetic-test-csrf' } : [], meta: { total: 0 }, errors: [] }), { status: 200, headers: { 'Content-Type': 'application/json' } })

test('every date-filtered Vendor transport serializes the selected calendar dates and preserves its existing query scope', async () => {
  const fetch = vi.spyOn(globalThis, 'fetch').mockImplementation(async request => {
    if (String(request).endsWith('/auth/csrf')) return jsonResponse(request)
    throw new Error('Synthetic transport observation')
  })
  const range = { from: '2026-10-01', to: '2026-10-09' }
  await expect(listOrders({ group: 'CLOSED', closedState: 'EXPIRED', q: 'cement', page: 2, ...range })).rejects.toThrow()
  await expect(listDisputes({ group: 'CONCLUDED', page: 2, ...range })).rejects.toThrow()
  await expect(listInvoices({ view: 'RECORDS', page: 2, ...range })).rejects.toThrow()
  await expect(listReviews('PRODUCT', 2, range)).rejects.toThrow()
  await expect(listTransactions('REFUNDS', 2, range)).rejects.toThrow()
  await expect(exportTransactions('REFUNDS', range)).rejects.toThrow()
  await expect(getEarnings(range)).rejects.toThrow()
  await expect(getVendorDashboardInsights(range)).rejects.toThrow()
  await expect(listMovements('variant-1', 2, range)).rejects.toThrow()
  await expect(listPriceHistory('variant-1', range)).rejects.toThrow()
  const calls = fetch.mock.calls.filter(([request]) => !String(request).endsWith('/auth/csrf'))
  expect(calls).toHaveLength(10)
  for (const [request] of calls) {
    const url = new URL(String(request))
    expect(url.searchParams.get('from')).toBe('2026-10-01')
    expect(url.searchParams.get('to')).toBe('2026-10-09')
  }
  const orderUrl = new URL(String(calls[0]![0]))
  expect(orderUrl.searchParams.get('group')).toBe('CLOSED')
  expect(orderUrl.searchParams.get('closed_state')).toBe('EXPIRED')
  expect(orderUrl.searchParams.get('q')).toBe('cement')
  expect(orderUrl.searchParams.get('page')).toBe('2')
})

test('materials requests and exports preserve paired calendar dates and the authoritative comparison preset contract', async () => {
  const fetch = vi.spyOn(globalThis, 'fetch').mockImplementation(async request => {
    if (String(request).endsWith('/auth/csrf')) return jsonResponse(request)
    throw new Error('Synthetic transport observation')
  })
  const filters = { radiusKm: 20, presetDays: null, startDate: '2026-10-01', endDate: '2026-10-09', q: 'cement' }
  await expect(listVendorAnalytics(filters, 'next-page')).rejects.toThrow()
  await expect(getVendorAnalyticsDetail('group-1', filters)).rejects.toThrow()
  await expect(exportVendorAnalytics(filters)).rejects.toThrow()
  await expect(listVendorAnalytics({ radiusKm: 50, presetDays: 30, startDate: null, endDate: null })).rejects.toThrow()
  const calls = fetch.mock.calls.filter(([request]) => !String(request).endsWith('/auth/csrf'))
  expect(calls).toHaveLength(4)
  for (const [request] of calls.slice(0, 3)) {
    const url = new URL(String(request))
    expect(url.searchParams.get('start_date')).toBe('2026-10-01')
    expect(url.searchParams.get('end_date')).toBe('2026-10-09')
    expect(url.searchParams.get('radius_km')).toBe('20')
    expect(url.searchParams.has('preset_days')).toBe(false)
  }
  const listUrl = new URL(String(calls[0]![0]))
  expect(listUrl.searchParams.get('q')).toBe('cement')
  expect(listUrl.searchParams.get('cursor')).toBe('next-page')
  const presetUrl = new URL(String(calls[3]![0]))
  expect(presetUrl.searchParams.get('preset_days')).toBe('30')
  expect(presetUrl.searchParams.has('start_date')).toBe(false)
  expect(presetUrl.searchParams.has('end_date')).toBe(false)
})

test('All dates sends no date restriction and an open-ended range sends only the chosen boundary', async () => {
  const fetch = vi.spyOn(globalThis, 'fetch').mockImplementation(async request => jsonResponse(request))
  await listOrders({ group: 'NEW' })
  await listOrders({ group: 'NEW', to: '2026-10-09' })
  const calls = fetch.mock.calls.filter(([request]) => !String(request).endsWith('/auth/csrf'))
  const all = new URL(String(calls[0]![0]))
  const openEnded = new URL(String(calls[1]![0]))
  expect(all.searchParams.has('from')).toBe(false)
  expect(all.searchParams.has('to')).toBe(false)
  expect(openEnded.searchParams.has('from')).toBe(false)
  expect(openEnded.searchParams.get('to')).toBe('2026-10-09')
})
