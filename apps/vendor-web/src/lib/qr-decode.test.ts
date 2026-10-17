import { afterEach, beforeEach, expect, test, vi } from 'vitest'
import jsQR from 'jsqr'
import { decodeQrFromImage } from './qr-decode'

vi.mock('jsqr', () => ({ default: vi.fn() }))

const close = vi.fn()
const context = { drawImage: vi.fn(), getImageData: vi.fn((_x: number, _y: number, width: number, height: number) => ({ data: new Uint8ClampedArray(width * height * 4), width, height })) }

beforeEach(() => {
  vi.stubGlobal('createImageBitmap', vi.fn(async () => ({ width: 3200, height: 2400, close })))
  vi.spyOn(HTMLCanvasElement.prototype, 'getContext').mockImplementation(() => context as unknown as CanvasRenderingContext2D)
})

afterEach(() => {
  vi.unstubAllGlobals()
  vi.restoreAllMocks()
  vi.mocked(jsQR).mockReset()
})

test('the native detector is used where the browser provides it', async () => {
  vi.stubGlobal('BarcodeDetector', class { async detect() { return [{ rawValue: 'A500000001' }] } })
  expect(await decodeQrFromImage(new Blob(['x']))).toBe('A500000001')
  expect(jsQR).not.toHaveBeenCalled()
  expect(close).toHaveBeenCalled()
})

test('without a native detector jsQR reads the pixels, retrying smaller scans of a large photo', async () => {
  vi.mocked(jsQR).mockReturnValueOnce(null).mockReturnValueOnce({ data: 'https://icc.example.gov.ph/verify?serial=A500000001' } as ReturnType<typeof jsQR>)
  expect(await decodeQrFromImage(new Blob(['x']))).toBe('https://icc.example.gov.ph/verify?serial=A500000001')
  // A 3200×2400 photo is scanned at a 1600 px edge first, then at 1000 px.
  expect(vi.mocked(jsQR).mock.calls.map(([, width, height]) => [width, height])).toEqual([[1600, 1200], [1000, 750]])
  expect(vi.mocked(jsQR).mock.calls[0]?.[3]).toEqual({ inversionAttempts: 'attemptBoth' })
})

test('an unreadable image or a failing native detector falls back and finally returns null', async () => {
  vi.stubGlobal('BarcodeDetector', class { async detect(): Promise<never> { throw new Error('unsupported') } })
  vi.mocked(jsQR).mockReturnValue(null)
  expect(await decodeQrFromImage(new Blob(['x']))).toBeNull()
  expect(jsQR).toHaveBeenCalledTimes(3)
  vi.stubGlobal('createImageBitmap', vi.fn(async () => { throw new Error('not an image') }))
  expect(await decodeQrFromImage(new Blob(['x']))).toBeNull()
})
