import { AsyncLoading } from './async-state'
import { useEffect, useLayoutEffect, useRef, useState } from 'react'
import { FileText, Maximize2 } from 'lucide-react'
import { Button } from './button'
import { FormDialog } from './form-dialog'
import { readWebPrivateFile } from './web-api-session'

/** `publicImage` marks an already-public photo (for example a CDN listing image) that may be shown from its own https URL. */
export type PrivateEvidenceItem = { id: string; label: string } & (
  | { loadUrl: () => Promise<{ url: string }>; publicImage?: boolean; loadFile?: never }
  | { loadFile: () => Promise<Blob>; loadUrl?: never; publicImage?: never }
)

function publicImageUrl(url: string, apiBasePath: string): string | null {
  const api = new URL(apiBasePath, window.location.origin)
  const parsed = new URL(url, api)
  return parsed.protocol === 'https:' && parsed.origin !== api.origin ? parsed.href : null
}

export function PrivateEvidenceGallery({ items, apiBasePath, layout = 'default' }: { items: PrivateEvidenceItem[]; apiBasePath: string; layout?: 'default' | 'thumbnails' }) {
  return <div className={layout === 'thumbnails' ? 'grid min-w-0 grid-cols-[repeat(auto-fill,minmax(min(100%,8rem),1fr))] items-start gap-3' : 'grid min-w-0 gap-5'}>
    {items.map(item => <EvidencePreview key={item.id} item={item} apiBasePath={apiBasePath} thumbnail={layout === 'thumbnails'} />)}
  </div>
}

function EvidencePreview({ item, apiBasePath, thumbnail }: { item: PrivateEvidenceItem; apiBasePath: string; thumbnail: boolean }) {
  const [preview, setPreview] = useState<{ url: string; type: string } | null>(null)
  const [error, setError] = useState('')
  const [zoomSize, setZoomSize] = useState<{ width: number; height: number } | null>(null)
  const [open, setOpen] = useState(false)
  const [retry, setRetry] = useState(0)
  const fullImage = useRef<HTMLImageElement>(null)
  const imageArea = useRef<HTMLDivElement>(null)
  const zoomed = zoomSize !== null

  useLayoutEffect(() => {
    const area = imageArea.current
    if (!area) return
    area.scrollLeft = zoomSize ? Math.max(0, (area.scrollWidth - area.clientWidth) / 2) : 0
    area.scrollTop = zoomSize ? Math.max(0, (area.scrollHeight - area.clientHeight) / 2) : 0
  }, [zoomSize])

  useEffect(() => {
    let active = true
    let objectUrl = ''
    setPreview(null)
    setError('')
    setOpen(false)
    setZoomSize(null)
    void (async () => {
      let blob: Blob
      if (item.loadFile) blob = await item.loadFile()
      else {
        const file = await item.loadUrl()
        if (!active) return
        const external = item.publicImage ? publicImageUrl(file.url, apiBasePath) : null
        if (external) {
          setPreview({ url: external, type: 'image/*' })
          return
        }
        blob = await readWebPrivateFile(apiBasePath, file.url)
      }
      if (!active) return
      objectUrl = URL.createObjectURL(blob)
      setPreview({ url: objectUrl, type: blob.type })
    })().catch(() => { if (active) setError('Preview could not be loaded. Try again.') })
    return () => { active = false; if (objectUrl) URL.revokeObjectURL(objectUrl) }
  }, [apiBasePath, item.id, retry])

  const image = preview?.type.startsWith('image/')
  const video = preview?.type.startsWith('video/')
  const close = () => { setOpen(false); setZoomSize(null) }
  const imageError = () => { setError('Preview could not be loaded. Try again.'); close() }
  const toggleZoom = () => {
    if (zoomed) { setZoomSize(null); return }
    const photo = fullImage.current
    if (!photo?.naturalWidth || !photo.naturalHeight) return
    const bounds = photo.getBoundingClientRect()
    // object-contain can leave empty space inside the image element. Enlarge the
    // painted photo, including small originals, instead of reverting to native pixels.
    const fittedScale = Math.min(bounds.width / photo.naturalWidth, bounds.height / photo.naturalHeight)
    if (fittedScale > 0) setZoomSize({ width: photo.naturalWidth * fittedScale * 2, height: photo.naturalHeight * fittedScale * 2 })
  }
  return <div className={thumbnail ? 'grid min-w-0 max-w-48 content-start gap-2' : 'min-w-0 border-t border-border-default pt-4'}>
    {!thumbnail && <div className="mb-3 flex flex-wrap items-center justify-between gap-3"><h4 className="font-semibold">{item.label}</h4>{preview && !error && <Button type="button" variant="quiet" onClick={() => setOpen(true)}>Enlarge {item.label}</Button>}</div>}
    {error ? <div role="alert" className="rounded-control border border-border-default p-3 text-sm text-status-error">{item.label}: {error} <Button type="button" variant="quiet" onClick={() => setRetry(value => value + 1)}>Retry preview</Button></div>
      : !preview ? <div role="status" className="min-w-0">{thumbnail ? <button type="button" disabled aria-label={`View ${item.label.toLowerCase()}`} className="flex aspect-[4/3] w-full items-center justify-center rounded-control border border-border-default bg-surface-canvas p-3 text-sm text-text-secondary">Loading {item.label.toLowerCase()}…</button> : <AsyncLoading compact label="Loading private evidence…" />}</div>
        : thumbnail ? <button type="button" aria-label={`View ${item.label.toLowerCase()}`} aria-haspopup="dialog" className="group grid min-w-0 overflow-hidden rounded-control border border-border-default bg-surface-primary text-left hover:border-action-primary focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-focus-ring" onClick={() => setOpen(true)}>
          <span className="flex aspect-[4/3] min-w-0 items-center justify-center overflow-hidden bg-surface-canvas p-1">{image ? <img src={preview.url} alt={item.label} className="h-full w-full object-contain" onError={imageError} /> : <FileText size={32} className="text-text-secondary" aria-hidden="true" />}</span>
          <span className="flex min-h-11 items-center justify-between gap-2 border-t border-border-default px-3 py-2 text-xs font-semibold text-action-primary"><span className="min-w-0 break-words">{item.label}</span><Maximize2 size={14} className="shrink-0" aria-hidden="true" /></span>
        </button>
        : image ? <button type="button" aria-label={`Enlarge ${item.label}`} aria-haspopup="dialog" className="flex min-h-44 w-full items-center justify-center overflow-hidden rounded-control border border-border-default bg-surface-primary p-2 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-focus-ring" onClick={() => setOpen(true)}><img src={preview.url} alt={item.label} className="max-h-80 w-full object-contain" onError={imageError} /></button>
          : video ? <video src={preview.url} controls preload="metadata" aria-label={item.label} className="max-h-80 w-full rounded-control bg-surface-canvas" /> : <iframe src={preview.url} title={item.label} className="h-96 w-full rounded-control border border-border-default bg-surface-primary" />}
    {preview && open && <FormDialog open title={`${item.label} full preview`} description="Review the attachment. Close the preview to return to the details." onClose={close}
      bodyClassName="flex min-h-0 flex-col overflow-hidden px-5 py-5 sm:px-6"
      footer={<div className="flex flex-wrap justify-end gap-2">{image && <Button variant="secondary" onClick={toggleZoom} aria-pressed={zoomed}>{zoomed ? 'Fit image' : 'Zoom in'}</Button>}<Button variant="secondary" onClick={close}>Close preview</Button></div>}>
      <div ref={imageArea} role="region" aria-label={`${item.label} image area`} tabIndex={0} className="max-h-[65dvh] min-h-0 min-w-0 overflow-auto rounded-control bg-surface-canvas p-2 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-focus-ring">
        {image ? <div className="grid min-h-full w-max min-w-full place-items-center"><img ref={fullImage} src={preview.url} alt={item.label} style={zoomSize ?? undefined} className={zoomed ? 'block max-w-none' : 'block max-h-[62dvh] w-full object-contain'} onError={imageError} /></div> : video ? <video src={preview.url} controls preload="metadata" aria-label={`${item.label} full size`} className="max-h-[62dvh] w-full" /> : <iframe src={preview.url} title={`${item.label} full size`} className="h-[62dvh] w-full border-0" />}
      </div>
    </FormDialog>}
  </div>
}
