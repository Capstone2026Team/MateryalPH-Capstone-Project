import { Blob as NodeBlob } from 'node:buffer'
import { fireEvent, render, screen, waitFor } from '@testing-library/react'
import { ReportingApi } from '@materyalph/api-client-ts'
import { afterEach, expect, test, vi } from 'vitest'
import { GeoExportButton } from './GeoAnalyticsPage'
import type { GeoFilters } from '../lib/geo-analytics-api'

afterEach(() => { vi.restoreAllMocks(); vi.unstubAllGlobals() })

test.each(['PDF', 'CSV'] as const)('geographic %s downloads directly with the complete current filter scope', async format => {
  vi.stubGlobal('Blob', NodeBlob)
  vi.stubGlobal('URL', class extends URL {
    static override createObjectURL = vi.fn(() => 'blob:geographic-export')
    static override revokeObjectURL = vi.fn()
  })
  const click = vi.spyOn(HTMLAnchorElement.prototype, 'click').mockImplementation(() => {})
  const request = vi.spyOn(ReportingApi.prototype, 'requestDocumentExport').mockResolvedValue({
    data: { id: 'geo-export', type: 'GEO_ANALYTICS', format, state: 'READY', expiresAt: null },
  } as never)
  vi.spyOn(ReportingApi.prototype, 'downloadDocumentExport').mockResolvedValue(new Blob([format === 'PDF' ? '%PDF-1.7' : 'safe,csv']))
  const filters: GeoFilters = {
    dataset: 'DEMO', area: '1300000000', from: '2026-10-01', to: '2026-10-31', granularity: 'MONTH',
    procurementType: 'ITEM_BASED', categoryId: 'category-id', materialId: 'material-id',
    fulfillmentMethod: 'DELIVERY', paymentMethod: 'GCASH', orderState: 'COMPLETED',
  }
  render(<GeoExportButton filters={filters} />)
  fireEvent.click(screen.getByRole('button', { name: `Export ${format}` }))
  expect(screen.queryByLabelText(/purpose|reason/i)).toBeNull()
  expect(screen.queryByRole('dialog')).toBeNull()
  await waitFor(() => expect(click).toHaveBeenCalledOnce())
  expect(request).toHaveBeenCalledExactlyOnceWith(expect.objectContaining({
    audience: 'admin',
    documentExportInput: {
      type: 'GEO_ANALYTICS', format, resourceId: null,
      purpose: `Geographic analytics ${format} export from admin report.`,
      filters: {
        dataset: 'DEMO', area: '1300000000', from: '2026-10-01', to: '2026-10-31', granularity: 'MONTH',
        procurement_type: 'ITEM_BASED', category_id: 'category-id', material_id: 'material-id',
        fulfillment_method: 'DELIVERY', payment_method: 'GCASH', order_state: 'COMPLETED',
      },
    },
  }))
})
