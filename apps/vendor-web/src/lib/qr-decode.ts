import jsQR from 'jsqr'

type NativeDetector = new (options: { formats: string[] }) => { detect: (source: ImageBitmap) => Promise<{ rawValue: string }[]> }

/** Longest edges tried, largest first: a QR code in a full product photo needs detail, a close-up decodes faster small. */
const SCAN_EDGES = [1600, 1000, 640]

/**
 * Reads a QR code from an image the Vendor chose, entirely in the browser; the image
 * is never sent anywhere for decoding. The native BarcodeDetector is used where the
 * browser provides it (Android, macOS, ChromeOS); everywhere else, including Chrome,
 * Edge and Firefox on Windows, jsQR decodes the pixels. Returns null when no QR code
 * is readable — the photo is still uploaded as evidence and the number can be typed.
 */
export async function decodeQrFromImage(file: Blob): Promise<string | null> {
  if (typeof createImageBitmap !== 'function') return null
  let bitmap: ImageBitmap
  try { bitmap = await createImageBitmap(file) } catch { return null }
  try {
    const Detector = (globalThis as unknown as { BarcodeDetector?: NativeDetector }).BarcodeDetector
    if (Detector) {
      try {
        const codes = await new Detector({ formats: ['qr_code'] }).detect(bitmap)
        const value = codes.find(code => code.rawValue.trim() !== '')?.rawValue
        if (value) return value
      } catch { /* fall through to jsQR */ }
    }
    for (const edge of SCAN_EDGES) {
      const pixels = rasterize(bitmap, edge)
      if (!pixels) return null
      const code = jsQR(pixels.data, pixels.width, pixels.height, { inversionAttempts: 'attemptBoth' })
      if (code?.data.trim()) return code.data
    }
    return null
  } finally {
    bitmap.close()
  }
}

function rasterize(bitmap: ImageBitmap, maxEdge: number): ImageData | null {
  const scale = Math.min(1, maxEdge / Math.max(bitmap.width, bitmap.height))
  const width = Math.max(1, Math.round(bitmap.width * scale))
  const height = Math.max(1, Math.round(bitmap.height * scale))
  const canvas = document.createElement('canvas')
  canvas.width = width
  canvas.height = height
  const context = canvas.getContext('2d', { willReadFrequently: true })
  if (!context) return null
  context.drawImage(bitmap, 0, 0, width, height)
  return context.getImageData(0, 0, width, height)
}
