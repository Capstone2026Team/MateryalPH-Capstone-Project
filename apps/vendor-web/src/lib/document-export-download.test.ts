import { afterEach, expect, it, vi } from 'vitest'
import { saveDocumentBlob } from '@materyalph/web-ui'

afterEach(() => {
  vi.useRealTimers()
  vi.unstubAllGlobals()
  vi.restoreAllMocks()
})

it('keeps the PDF attachment URL alive while the browser starts saving', () => {
  vi.useFakeTimers()
  const createObjectURL = vi.fn(() => 'blob:private-export')
  const revokeObjectURL = vi.fn()
  vi.stubGlobal('URL', { createObjectURL, revokeObjectURL })
  const click = vi.spyOn(HTMLAnchorElement.prototype, 'click').mockImplementation(function (this: HTMLAnchorElement) {
    expect(this.isConnected).toBe(true)
    expect(this.download).toBe('materyalph-purchase_order.pdf')
    expect(this.href).toBe('blob:private-export')
  })
  const pdf = new Blob(['%PDF-1.7'], { type: 'application/pdf' })
  saveDocumentBlob(pdf, 'materyalph-purchase_order.pdf')
  expect(createObjectURL).toHaveBeenCalledWith(pdf)
  expect(click).toHaveBeenCalledOnce()
  expect(document.querySelector('a[download]')).toBeNull()
  expect(revokeObjectURL).not.toHaveBeenCalled()
  vi.advanceTimersByTime(60_000)
  expect(revokeObjectURL).toHaveBeenCalledWith('blob:private-export')
})
