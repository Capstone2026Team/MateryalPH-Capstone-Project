import { Blob as NodeBlob } from 'node:buffer'
import { fireEvent, render, screen, waitFor } from '@testing-library/react'
import { clearWebSessionTransport, PortalResourceProvider } from '@materyalph/web-ui'
import { afterEach, beforeEach, expect, test, vi } from 'vitest'
import { GeoExportButton } from '../pages/GeoAnalyticsPage'
import { type GeoFilters, exportFilters } from './geo-analytics-api'
import { useAnalyticsResource } from './use-analytics-resource'

const filters: GeoFilters = {
  dataset: 'TEST', area: '1300000000', from: '2026-10-14', to: '2026-11-12', granularity: 'WEEK',
  procurementType: 'ITEM_BASED', categoryId: '', materialId: '', fulfillmentMethod: 'PICKUP', paymentMethod: 'ONLINE', orderState: 'CONFIRMED',
}
const json = (data: unknown, status = 200, errors: unknown[] = []) => new Response(JSON.stringify({ data, meta: {}, errors }), {
  status, headers: { 'Content-Type': 'application/json' },
})

function Analytics() {
  const dashboard = useAnalyticsResource('export-verification', async () => 'Recorded marketplace activity', { automaticRefresh: false })
  // Like the analytics page, an access error replaces the loaded overview and its export controls.
  return dashboard.error ? <p role="alert">{dashboard.error}</p>
    : <section><p>{dashboard.data}</p><GeoExportButton filters={filters} /></section>
}

let click: ReturnType<typeof vi.spyOn>
beforeEach(() => {
  vi.stubGlobal('Blob', NodeBlob)
  vi.stubGlobal('URL', class extends URL {
    static override createObjectURL = vi.fn(() => 'blob:private-geo-export')
    static override revokeObjectURL = vi.fn()
  })
  click = vi.spyOn(HTMLAnchorElement.prototype, 'click').mockImplementation(() => {})
})
afterEach(() => { clearWebSessionTransport(); vi.restoreAllMocks(); vi.unstubAllGlobals() })

function mockExportTransport(format: 'PDF' | 'CSV', verificationStatus = 200) {
  const requests: { input: unknown; key: string | null }[] = []
  let verified = false
  const item = (state: 'QUEUED' | 'READY') => ({
    id: 'geo-export-1', type: 'GEO_ANALYTICS', format, state, purpose: 'Geographic analytics export',
    filters: exportFilters(filters), source_hash: null, source_versions: {}, checksum: null,
    created_at: '2026-11-12T00:00:00Z', expires_at: null, failure_code: null, access_record: [],
  })
  const fetcher = vi.fn(async (input: RequestInfo | URL, init?: RequestInit) => {
    const path = new URL(String(input)).pathname
    if (path.endsWith('/auth/csrf')) return json({ csrf_token: 'synthetic-geo-export-csrf' })
    if (path.endsWith('/account/security')) return json({ totp_enrolled: true })
    if (path.endsWith('/account/reauthentication')) {
      if (verificationStatus !== 200) return json(null, verificationStatus, [{ code: 'REAUTHENTICATION_FAILED', message: 'The verification details are incorrect.' }])
      verified = true
      return json({ verified: true })
    }
    if (path.endsWith('/admin/reports') && init?.method === 'POST') {
      requests.push({ input: JSON.parse(String(init.body)), key: new Headers(init.headers).get('Idempotency-Key') })
      if (!verified) return json(null, 403, [{ code: 'RECENT_AUTHENTICATION_REQUIRED', message: 'Verify your identity again to continue.' }])
      return json(item('QUEUED'), 202)
    }
    if (path.endsWith('/admin/reports')) return json([item('READY')])
    if (path.endsWith('/admin/reports/geo-export-1/download')) return new Response(format === 'PDF' ? '%PDF-1.7' : 'Area,Orders\nNCR,5', { headers: { 'Content-Type': format === 'PDF' ? 'application/pdf' : 'text/csv' } })
    throw new Error(`Unexpected test request: ${path}`)
  })
  vi.stubGlobal('fetch', fetcher)
  return { requests, fetcher }
}

test.each(['PDF', 'CSV'] as const)('%s keeps analytics mounted through verification and downloads the original filtered export', async format => {
  const { requests, fetcher } = mockExportTransport(format)
  render(<PortalResourceProvider><Analytics /></PortalResourceProvider>)
  await screen.findByText('Recorded marketplace activity')
  fireEvent.click(screen.getByRole('button', { name: `Export ${format}` }))
  fireEvent.change(await screen.findByLabelText(/Authenticator code/), { target: { value: '123456' } })
  expect(screen.getByText('Recorded marketplace activity')).toBeInTheDocument()
  expect(requests).toHaveLength(1)
  expect(click).not.toHaveBeenCalled()
  fireEvent.click(screen.getByRole('button', { name: 'Verify and continue' }))
  await waitFor(() => expect(click).toHaveBeenCalledOnce())
  expect(requests).toHaveLength(2)
  expect(requests[1]).toEqual(requests[0])
  expect(requests[0]?.key).toBeTruthy()
  expect(requests[0]?.input).toMatchObject({ type: 'GEO_ANALYTICS', format, filters: exportFilters(filters) })
  expect(screen.getByText('Recorded marketplace activity')).toBeInTheDocument()
  expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
  expect(await screen.findByText(`${format} download started.`)).toBeInTheDocument()
  for (const [, init] of fetcher.mock.calls) expect(init?.credentials).toBe('include')
})

test.each(['cancel', 'incorrect code'])('%s does not retry or download and preserves the analytics page', async action => {
  const { requests, fetcher } = mockExportTransport('PDF', 422)
  render(<PortalResourceProvider><Analytics /></PortalResourceProvider>)
  await screen.findByText('Recorded marketplace activity')
  fireEvent.click(screen.getByRole('button', { name: 'Export PDF' }))
  const code = await screen.findByLabelText(/Authenticator code/)
  if (action === 'cancel') {
    fireEvent.click(screen.getByRole('button', { name: 'Cancel' }))
    await screen.findByText('Verification was cancelled. Your PDF was not requested.')
    expect(fetcher.mock.calls.some(([input]) => String(input).endsWith('/account/reauthentication'))).toBe(false)
  } else {
    fireEvent.change(code, { target: { value: '123456' } })
    fireEvent.click(screen.getByRole('button', { name: 'Verify and continue' }))
    await screen.findByText('The verification details are incorrect.')
    expect(screen.getByRole('dialog')).toBeInTheDocument()
  }
  expect(requests).toHaveLength(1)
  expect(click).not.toHaveBeenCalled()
  expect(screen.getByText('Recorded marketplace activity')).toBeInTheDocument()
})
