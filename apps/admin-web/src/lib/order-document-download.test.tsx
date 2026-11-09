import { Blob as NodeBlob } from 'node:buffer'
import { act, fireEvent, render, screen, waitFor } from '@testing-library/react'
import { ReportingApi, type PlatformDocumentRef } from '@materyalph/api-client-ts'
import { DocumentExportButton, PlatformDocumentNotice } from '@materyalph/web-ui'
import { afterEach, beforeEach, expect, test, vi } from 'vitest'

let click: ReturnType<typeof vi.spyOn>
beforeEach(() => {
  vi.stubGlobal('Blob', NodeBlob)
  vi.stubGlobal('URL', class extends URL {
    static override createObjectURL = vi.fn(() => 'blob:issued-document')
    static override revokeObjectURL = vi.fn()
  })
  click = vi.spyOn(HTMLAnchorElement.prototype, 'click').mockImplementation(() => {})
})
afterEach(() => { vi.useRealTimers(); vi.restoreAllMocks(); vi.unstubAllGlobals() })

const document = (kind: 'PURCHASE_ORDER' = 'PURCHASE_ORDER', availability = 'READY'): PlatformDocumentRef => ({
  kind, availability, title: kind === 'PURCHASE_ORDER' ? 'MateryalPH Purchase Order' : 'MateryalPH payment confirmation',
  notTaxInvoice: true, label: 'Not a tax invoice', ...(availability === 'READY' ? { downloadUrl: '/authenticated-download' } : {}),
})

test.each(['PURCHASE_ORDER'] as const)('%s uses an already generated PDF without requesting another export', async kind => {
  const request = vi.spyOn(ReportingApi.prototype, 'requestDocumentExport')
  vi.spyOn(ReportingApi.prototype, 'listOrderDocuments').mockResolvedValue({ data: [document(kind)] } as never)
  const download = vi.spyOn(ReportingApi.prototype, 'downloadOrderDocument').mockResolvedValue(new Blob(['%PDF-1.7']))
  render(<DocumentExportButton basePath="http://localhost/api/v1" audience="vendor" types={[kind]} resourceId="order-1" />)
  fireEvent.click(screen.getByRole('button', { name: 'Purchase order PDF' }))
  await waitFor(() => expect(click).toHaveBeenCalledOnce())
  expect(request).not.toHaveBeenCalled()
  expect(download).toHaveBeenCalledExactlyOnceWith({ audience: 'vendor', orderId: 'order-1', kind })
})

test('a queued issued document is polled read-only and automatically saved when ready', async () => {
  vi.useFakeTimers()
  const request = vi.spyOn(ReportingApi.prototype, 'requestDocumentExport')
  const list = vi.spyOn(ReportingApi.prototype, 'listOrderDocuments').mockResolvedValue({ data: [document('PURCHASE_ORDER', 'QUEUED')] } as never)
  const download = vi.spyOn(ReportingApi.prototype, 'downloadOrderDocument').mockResolvedValue(new Blob(['%PDF-1.7']))
  render(<DocumentExportButton basePath="http://localhost/api/v1" audience="vendor" types={['PURCHASE_ORDER']} resourceId="order-1" />)
  await act(async () => { fireEvent.click(screen.getByRole('button', { name: 'Purchase order PDF' })) })
  expect(download).not.toHaveBeenCalled()
  list.mockResolvedValue({ data: [document()] } as never)
  await act(async () => { await vi.advanceTimersByTimeAsync(5000) })
  expect(click).toHaveBeenCalledOnce()
  expect(request).not.toHaveBeenCalled()
})

test('invoice rows show the Purchase Order download without a tax-invoice badge', async () => {
  const download = vi.spyOn(ReportingApi.prototype, 'downloadOrderDocument').mockResolvedValue(new Blob(['%PDF-1.7']))
  render(<PlatformDocumentNotice documents={[document()]} orderId="order-1" apiBasePath="http://localhost/api/v1" />)
  expect(screen.queryByText('Not a tax invoice')).not.toBeInTheDocument()
  expect(screen.queryByText('MateryalPH payment confirmation')).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Download MateryalPH Purchase Order PDF' }))
  await waitFor(() => expect(click).toHaveBeenCalledOnce())
  expect(download).toHaveBeenCalledExactlyOnceWith({ audience: 'vendor', orderId: 'order-1', kind: 'PURCHASE_ORDER' })
})

test('invoice rows request a refreshed status while a PDF is queued', async () => {
  vi.useFakeTimers()
  const refresh = vi.fn()
  render(<PlatformDocumentNotice documents={[document('PURCHASE_ORDER', 'QUEUED')]} orderId="order-1" apiBasePath="http://localhost/api/v1" onRefresh={refresh} />)
  expect(screen.getByText('Preparing PDF…')).toBeVisible()
  expect(screen.queryByRole('button')).toBeNull()
  await act(async () => { await vi.advanceTimersByTimeAsync(5000) })
  expect(refresh).toHaveBeenCalledOnce()
})

test('session clearing prevents a pending invoice-row download from being saved', async () => {
  let complete!: (blob: Blob) => void
  vi.spyOn(ReportingApi.prototype, 'downloadOrderDocument').mockReturnValue(new Promise(resolve => { complete = resolve }))
  render(<PlatformDocumentNotice documents={[document()]} orderId="order-1" apiBasePath="http://localhost/api/v1" />)
  fireEvent.click(screen.getByRole('button', { name: 'Download MateryalPH Purchase Order PDF' }))
  await act(async () => {
    window.dispatchEvent(new Event('materyalph:session-cleared'))
    complete(new Blob(['%PDF-1.7']))
  })
  expect(click).not.toHaveBeenCalled()
})

test('an unaccepted order never generates a fresh Purchase Order from a click', async () => {
  const request = vi.spyOn(ReportingApi.prototype, 'requestDocumentExport')
  vi.spyOn(ReportingApi.prototype, 'listOrderDocuments').mockResolvedValue({ data: [document('PURCHASE_ORDER', 'AFTER_ACCEPTANCE')] } as never)
  const download = vi.spyOn(ReportingApi.prototype, 'downloadOrderDocument')
  render(<DocumentExportButton basePath="http://localhost/api/v1" audience="admin" types={['PURCHASE_ORDER']} resourceId="order-1" />)
  fireEvent.click(screen.getByRole('button', { name: 'Purchase order PDF' }))
  expect(await screen.findByRole('alert')).toHaveTextContent('after the final order is accepted')
  expect(request).not.toHaveBeenCalled()
  expect(download).not.toHaveBeenCalled()
})
