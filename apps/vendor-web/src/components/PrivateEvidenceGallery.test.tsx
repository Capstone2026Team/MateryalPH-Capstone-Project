import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { afterEach, expect, test, vi } from 'vitest'
import { PrivateEvidenceGallery } from '@materyalph/web-ui'

afterEach(() => vi.unstubAllGlobals())

test.each([
  ['small square', 256, 256, 800, 800],
  ['landscape', 1600, 900, 1280, 720],
  ['portrait', 256, 768, 240, 720],
] as const)('zoom doubles the fitted %s photo and Fit image restores the preview', async (_shape, naturalWidth, naturalHeight, zoomWidth, zoomHeight) => {
  vi.stubGlobal('URL', class extends URL { static override createObjectURL = vi.fn(() => 'blob:proof'); static override revokeObjectURL = vi.fn() })
  const loadFile = vi.fn(async () => new Blob(['sample image'], { type: 'image/png' }))
  render(<PrivateEvidenceGallery apiBasePath="/api/v1" layout="thumbnails" items={[{ id: 'proof-1', label: 'Proof photo', loadFile }]} />)
  await screen.findByRole('img', { name: 'Proof photo' })
  const trigger = screen.getByRole('button', { name: 'View proof photo' })
  trigger.focus()
  fireEvent.click(trigger)
  const popup = screen.getByRole('dialog', { name: 'Proof photo full preview' })
  const photo = within(popup).getByRole('img', { name: 'Proof photo' })
  Object.defineProperties(photo, { naturalWidth: { value: naturalWidth }, naturalHeight: { value: naturalHeight } })
  vi.spyOn(photo, 'getBoundingClientRect').mockReturnValue(new DOMRect(0, 0, 960, naturalWidth === naturalHeight ? 400 : 360))
  const area = within(popup).getByRole('region', { name: 'Proof photo image area' })
  Object.defineProperties(area, { scrollWidth: { value: 1200 }, clientWidth: { value: 960 }, scrollHeight: { value: 800 }, clientHeight: { value: 400 } })
  fireEvent.click(within(popup).getByRole('button', { name: 'Zoom in' }))
  expect(photo).toHaveStyle({ width: `${zoomWidth}px`, height: `${zoomHeight}px` })
  expect(area.scrollLeft).toBe(120)
  expect(area.scrollTop).toBe(200)
  expect(within(popup).getByRole('button', { name: 'Fit image' })).toHaveAttribute('aria-pressed', 'true')
  fireEvent.click(within(popup).getByRole('button', { name: 'Fit image' }))
  expect(photo.style.width).toBe('')
  expect(photo.style.height).toBe('')
  expect(area.scrollLeft).toBe(0)
  expect(area.scrollTop).toBe(0)
  expect(loadFile).toHaveBeenCalledTimes(1)
  fireEvent.click(within(popup).getByRole('button', { name: 'Close preview' }))
  expect(trigger).toHaveFocus()
})

test('an image decode failure retries the private read and releases replaced previews', async () => {
  const create = vi.fn().mockReturnValueOnce('blob:first').mockReturnValueOnce('blob:second')
  const revoke = vi.fn()
  vi.stubGlobal('URL', class extends URL { static override createObjectURL = create; static override revokeObjectURL = revoke })
  const loadFile = vi.fn(async () => new Blob(['sample image'], { type: 'image/png' }))
  const { unmount } = render(<PrivateEvidenceGallery apiBasePath="/api/v1" layout="thumbnails" items={[{ id: 'proof-1', label: 'Proof photo', loadFile }]} />)
  fireEvent.error(await screen.findByRole('img', { name: 'Proof photo' }))
  expect(screen.getByRole('alert')).toHaveTextContent('Preview could not be loaded')
  expect(screen.queryByRole('button', { name: 'View proof photo' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Retry preview' }))
  expect(await screen.findByRole('img', { name: 'Proof photo' })).toHaveAttribute('src', 'blob:second')
  expect(loadFile).toHaveBeenCalledTimes(2)
  expect(revoke).toHaveBeenCalledWith('blob:first')
  unmount()
  expect(revoke).toHaveBeenCalledWith('blob:second')
})

test('an evidence read finishing after navigation never creates a preview URL', async () => {
  const create = vi.fn()
  vi.stubGlobal('URL', class extends URL { static override createObjectURL = create; static override revokeObjectURL = vi.fn() })
  let finish!: (blob: Blob) => void
  const pending = new Promise<Blob>(resolve => { finish = resolve })
  const { unmount } = render(<PrivateEvidenceGallery apiBasePath="/api/v1" layout="thumbnails" items={[{ id: 'proof-1', label: 'Proof photo', loadFile: () => pending }]} />)
  expect(screen.getByRole('button', { name: 'View proof photo' })).toBeDisabled()
  unmount()
  finish(new Blob(['sample image'], { type: 'image/png' }))
  await pending
  await waitFor(() => expect(create).not.toHaveBeenCalled())
})
