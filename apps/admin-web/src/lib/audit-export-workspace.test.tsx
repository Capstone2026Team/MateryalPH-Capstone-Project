import { fireEvent, render, screen, waitFor } from '@testing-library/react'
import { ReportingApi } from '@materyalph/api-client-ts'
import { DocumentExportWorkspace } from '@materyalph/web-ui'
import { afterEach, expect, test, vi } from 'vitest'

afterEach(() => { vi.useRealTimers(); vi.restoreAllMocks(); vi.unstubAllGlobals() })

test.each(['PDF', 'CSV'] as const)('%s audit export keeps filters and polls queued history until downloadable', async format => {
  const item = { id: 'export-1', type: 'AUDIT_LOG', format, state: 'QUEUED', purpose: 'Review audit history', createdAt: new Date(), expiresAt: null }
  const list = vi.spyOn(ReportingApi.prototype, 'listDocumentExports').mockResolvedValue({ data: [], meta: {} } as never)
  const request = vi.spyOn(ReportingApi.prototype, 'requestDocumentExport').mockResolvedValue({ data: item } as never)
  const download = vi.spyOn(ReportingApi.prototype, 'downloadDocumentExport').mockResolvedValue(new Blob(['safe,csv']))
  render(<DocumentExportWorkspace basePath="http://localhost/api/v1" audience="admin" types={['AUDIT_LOG']} filters={{ actor_role: 'OWNER' }} format={format} />)
  await waitFor(() => expect(list).toHaveBeenCalledWith({ audience: 'admin', page: 1, type: 'AUDIT_LOG', format }))
  await screen.findByText('No exports for this document yet.')
  list.mockResolvedValue({ data: [item], meta: {} } as never)
  fireEvent.change(screen.getByLabelText('Purpose'), { target: { value: 'Review audit history' } })
  fireEvent.click(screen.getByRole('button', { name: `Generate ${format}` }))
  await waitFor(() => expect(request).toHaveBeenCalledWith(expect.objectContaining({
    audience: 'admin', idempotencyKey: expect.any(String), documentExportInput: { type: 'AUDIT_LOG', format, resourceId: null, purpose: 'Review audit history', filters: { actor_role: 'OWNER' } },
  })))
  await screen.findByText('QUEUED')
  await waitFor(() => expect(screen.getByRole('button', { name: 'Refresh status' })).toBeEnabled())
  list.mockResolvedValue({ data: [{ ...item, state: 'READY' }], meta: {} } as never)
  expect(await screen.findByRole('button', { name: `Download ${format}` }, { timeout: 7000 })).toBeEnabled()
  if (format === 'CSV') {
    const create = vi.fn(() => 'blob:audit-export')
    vi.stubGlobal('URL', class extends URL { static override createObjectURL = create; static override revokeObjectURL = vi.fn() })
    const click = vi.spyOn(HTMLAnchorElement.prototype, 'click').mockImplementation(function (this: HTMLAnchorElement) { expect(this.download).toBe('materyalph-audit_log-export-1.csv') })
    fireEvent.click(screen.getByRole('button', { name: 'Download CSV' }))
    await waitFor(() => expect(click).toHaveBeenCalledOnce())
    expect(download).toHaveBeenCalledWith({ audience: 'admin', exportId: 'export-1' })
    expect(create).toHaveBeenCalledWith(expect.objectContaining({ type: 'text/csv;charset=utf-8' }))
  }
}, 10_000)
