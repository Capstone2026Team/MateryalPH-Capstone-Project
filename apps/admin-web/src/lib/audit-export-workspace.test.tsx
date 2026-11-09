import { Blob as NodeBlob } from 'node:buffer'
import { act, fireEvent, render, screen, waitFor } from '@testing-library/react'
import { ReportingApi, type DocumentExport } from '@materyalph/api-client-ts'
import { DocumentExportButton, DocumentExportWorkspace } from '@materyalph/web-ui'
import { afterEach, beforeEach, expect, test, vi } from 'vitest'

const item = (state = 'QUEUED', id = 'export-1', format = 'PDF'): DocumentExport => ({
  id, type: 'AUDIT_LOG', format, state, purpose: 'Audit log PDF export from admin report.',
  createdAt: '2026-11-04T00:00:00Z', expiresAt: null,
} as DocumentExport)

let click: ReturnType<typeof vi.spyOn>
beforeEach(() => {
  vi.stubGlobal('Blob', NodeBlob)
  vi.stubGlobal('URL', class extends URL {
    static override createObjectURL = vi.fn(() => 'blob:private-export')
    static override revokeObjectURL = vi.fn()
  })
  click = vi.spyOn(HTMLAnchorElement.prototype, 'click').mockImplementation(() => {})
})
afterEach(() => { vi.useRealTimers(); vi.restoreAllMocks(); vi.unstubAllGlobals() })

test.each([
  ['admin', 'PDF'], ['admin', 'CSV'], ['vendor', 'PDF'], ['vendor', 'CSV'],
] as const)('%s %s export starts and downloads without a reason or another click', async (audience, format) => {
  const ready = item('READY', 'export-1', format)
  const list = vi.spyOn(ReportingApi.prototype, 'listDocumentExports').mockResolvedValue({ data: [ready], meta: {} } as never)
  const request = vi.spyOn(ReportingApi.prototype, 'requestDocumentExport').mockResolvedValue({ data: item('QUEUED', 'export-1', format) } as never)
  const download = vi.spyOn(ReportingApi.prototype, 'downloadDocumentExport').mockResolvedValue(new Blob([format === 'PDF' ? '%PDF-1.7' : 'safe,csv']))
  render(<DocumentExportButton basePath="http://localhost/api/v1" audience={audience} types={['AUDIT_LOG']} filters={{ actor_role: 'OWNER' }} format={format} />)
  expect(list).not.toHaveBeenCalled()
  fireEvent.click(screen.getByRole('button', { name: `Export ${format}` }))
  expect(screen.queryByLabelText('Purpose')).toBeNull()
  expect(screen.queryByRole('dialog')).toBeNull()
  await waitFor(() => expect(click).toHaveBeenCalledOnce())
  expect(request).toHaveBeenCalledExactlyOnceWith(expect.objectContaining({
    audience, idempotencyKey: expect.any(String),
    documentExportInput: { type: 'AUDIT_LOG', format, resourceId: null, purpose: `Audit log ${format} export from ${audience} report.`, filters: { actor_role: 'OWNER' } },
  }))
  expect(download).toHaveBeenCalledExactlyOnceWith({ audience, exportId: 'export-1' })
  expect(URL.createObjectURL).toHaveBeenCalledWith(expect.objectContaining({ type: format === 'PDF' ? 'application/pdf' : 'text/csv;charset=utf-8' }))
})

test('polls only the requested export, including later history pages, and blocks duplicate clicks', async () => {
  vi.useFakeTimers()
  const queued = item()
  const list = vi.spyOn(ReportingApi.prototype, 'listDocumentExports')
    .mockResolvedValueOnce({ data: [item('READY', 'older-export')], meta: { has_more: true } } as never)
    .mockResolvedValueOnce({ data: [queued], meta: {} } as never)
    .mockResolvedValue({ data: [item('READY')], meta: {} } as never)
  const request = vi.spyOn(ReportingApi.prototype, 'requestDocumentExport').mockResolvedValue({ data: queued } as never)
  const download = vi.spyOn(ReportingApi.prototype, 'downloadDocumentExport').mockResolvedValue(new Blob(['%PDF-1.7']))
  render(<DocumentExportButton basePath="http://localhost/api/v1" audience="admin" types={['AUDIT_LOG']} />)
  const button = screen.getByRole('button', { name: 'Export PDF' })
  await act(async () => { fireEvent.click(button); fireEvent.click(button) })
  expect(request).toHaveBeenCalledOnce()
  expect(button).toBeDisabled()
  expect(download).not.toHaveBeenCalled()
  expect(list).toHaveBeenNthCalledWith(2, expect.objectContaining({ page: 2, type: 'AUDIT_LOG', format: 'PDF' }))
  await act(async () => { await vi.advanceTimersByTimeAsync(5000) })
  expect(download).toHaveBeenCalledExactlyOnceWith({ audience: 'admin', exportId: 'export-1' })
  expect(click).toHaveBeenCalledOnce()
  expect(button).toBeEnabled()
})

test.each(['FAILED', 'REVOKED', 'EXPIRED'])('%s exports never download and a fresh click can request a new snapshot', async state => {
  vi.spyOn(ReportingApi.prototype, 'listDocumentExports').mockResolvedValue({ data: [item(state)], meta: {} } as never)
  const request = vi.spyOn(ReportingApi.prototype, 'requestDocumentExport').mockResolvedValue({ data: item() } as never)
  const download = vi.spyOn(ReportingApi.prototype, 'downloadDocumentExport')
  render(<DocumentExportButton basePath="http://localhost/api/v1" audience="admin" types={['AUDIT_LOG']} />)
  fireEvent.click(screen.getByRole('button', { name: 'Export PDF' }))
  await screen.findByRole('alert')
  expect(download).not.toHaveBeenCalled()
  request.mockResolvedValue({ data: item('READY', 'new-export') } as never)
  download.mockResolvedValue(new Blob(['%PDF-1.7']))
  fireEvent.click(screen.getByRole('button', { name: 'Export PDF' }))
  await waitFor(() => expect(click).toHaveBeenCalledOnce())
  expect(download).toHaveBeenCalledExactlyOnceWith({ audience: 'admin', exportId: 'new-export' })
})

test('a failed file transfer resumes the same export on the next click', async () => {
  const request = vi.spyOn(ReportingApi.prototype, 'requestDocumentExport').mockResolvedValue({ data: item('READY') } as never)
  const download = vi.spyOn(ReportingApi.prototype, 'downloadDocumentExport').mockRejectedValueOnce(new Error('offline')).mockResolvedValue(new Blob(['%PDF-1.7']))
  render(<DocumentExportButton basePath="http://localhost/api/v1" audience="admin" types={['AUDIT_LOG']} />)
  fireEvent.click(screen.getByRole('button', { name: 'Export PDF' }))
  await screen.findByRole('alert')
  expect(download).toHaveBeenCalledOnce()
  fireEvent.click(screen.getByRole('button', { name: 'Export PDF' }))
  await waitFor(() => expect(click).toHaveBeenCalledOnce())
  expect(request).toHaveBeenCalledOnce()
  expect(download).toHaveBeenCalledTimes(2)
})

test.each(['unmount', 'session', 'context'])('stale queued work cannot download after %s changes', async change => {
  vi.useFakeTimers()
  const list = vi.spyOn(ReportingApi.prototype, 'listDocumentExports').mockResolvedValue({ data: [item()], meta: {} } as never)
  vi.spyOn(ReportingApi.prototype, 'requestDocumentExport').mockResolvedValue({ data: item() } as never)
  const download = vi.spyOn(ReportingApi.prototype, 'downloadDocumentExport')
  const { unmount, rerender } = render(<DocumentExportButton basePath="http://localhost/api/v1" audience="admin" types={['AUDIT_LOG']} />)
  await act(async () => { fireEvent.click(screen.getByRole('button', { name: 'Export PDF' })) })
  list.mockResolvedValue({ data: [item('READY')], meta: {} } as never)
  await act(async () => {
    if (change === 'unmount') unmount()
    if (change === 'session') window.dispatchEvent(new Event('materyalph:session-cleared'))
    if (change === 'context') rerender(<DocumentExportButton basePath="http://localhost/api/v1" audience="admin" types={['AUDIT_LOG']} filters={{ actor_role: 'OWNER' }} />)
  })
  await act(async () => { await vi.advanceTimersByTimeAsync(5000) })
  expect(download).not.toHaveBeenCalled()
  expect(click).not.toHaveBeenCalled()
})

test('rejects a non-PDF response', async () => {
  vi.spyOn(ReportingApi.prototype, 'requestDocumentExport').mockResolvedValue({ data: item('READY') } as never)
  vi.spyOn(ReportingApi.prototype, 'downloadDocumentExport').mockResolvedValue(new Blob(['<html>failed</html>']))
  render(<DocumentExportButton basePath="http://localhost/api/v1" audience="admin" types={['AUDIT_LOG']} />)
  fireEvent.click(screen.getByRole('button', { name: 'Export PDF' }))
  expect(await screen.findByRole('alert')).toHaveTextContent('PDF could not be verified')
  expect(click).not.toHaveBeenCalled()
})

test('multiple document types each have a direct action with the original record context', async () => {
  const request = vi.spyOn(ReportingApi.prototype, 'requestDocumentExport')
  vi.spyOn(ReportingApi.prototype, 'listOrderDocuments').mockResolvedValue({ data: [{ kind: 'PURCHASE_ORDER', availability: 'READY', downloadUrl: '/private-document' }] } as never)
  const download = vi.spyOn(ReportingApi.prototype, 'downloadOrderDocument').mockResolvedValue(new Blob(['%PDF-1.7']))
  render(<DocumentExportButton basePath="http://localhost/api/v1" audience="vendor" types={['PURCHASE_ORDER']} resourceId="order-id" />)
  expect(screen.getByRole('button', { name: 'Purchase order PDF' })).toBeEnabled()
  expect(screen.queryByRole('button', { name: 'Operational order PDF' })).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Payment confirmation PDF' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Purchase order PDF' }))
  await waitFor(() => expect(click).toHaveBeenCalledOnce())
  expect(request).not.toHaveBeenCalled()
  expect(download).toHaveBeenCalledExactlyOnceWith({ audience: 'vendor', orderId: 'order-id', kind: 'PURCHASE_ORDER' })
})

test('history remains available without automatically downloading an older ready export', async () => {
  vi.spyOn(ReportingApi.prototype, 'listDocumentExports').mockResolvedValue({ data: [item('READY')], meta: {} } as never)
  const download = vi.spyOn(ReportingApi.prototype, 'downloadDocumentExport').mockResolvedValue(new Blob(['%PDF-1.7']))
  render(<DocumentExportWorkspace basePath="http://localhost/api/v1" audience="admin" types={['AUDIT_LOG']} />)
  await screen.findByRole('button', { name: 'Download PDF' })
  expect(download).not.toHaveBeenCalled()
  fireEvent.click(screen.getByRole('button', { name: 'Download PDF' }))
  await waitFor(() => expect(click).toHaveBeenCalledOnce())
})
